'use strict';

/*

 OptimizationRequestsService

 */

(function () {

    OptimizationRequestsService.$inject = ['$q', '$rootScope', 'sfdcService', 'utils', '$injector', 'RegisterService', 'TimePhasedDataService', 'StateService'];

    angular.module('serviceExpert').factory('OptimizationRequestsService', OptimizationRequestsService);

    function OptimizationRequestsService($q, $rootScope, sfdcService, utils, $injector, RegisterService, TimePhasedDataService, StateService) {

        var _optimizationRequests = {},
            inDayOptimizationsIntervals = {},
            policies = {},
            OptimizationsRequestTypes = {};

        $q.all([TimePhasedDataService.promises.initialPhasedData, StateService.promises.policies(), sfdcService.getOptimizationRequests(), sfdcService.getOptimizationsRequestTypes()]).then(function (requests) {
            requests[1].forEach(function (policy) {
                policies[policy.Id] = policy;
            });

            requests[2].forEach(function (req) {
                _optimizationRequests[req.Id] = new OptimizationRequest(req);
                addSmartActionTimespan(_optimizationRequests[req.Id]);
            });

            OptimizationsRequestTypes = requests[3];
        });

        // register to delta - optimization requests
        RegisterService.register('optimizationRequests', function (requests) {
            requests.forEach(function (req) {

                var newRequest = new OptimizationRequest(req);

                // check if exist
                if (_optimizationRequests[req.Id] && _optimizationRequests[req.Id].timespan) {
                    for (var i = 0; i < _optimizationRequests[req.Id].timespan.length; i++) {
                        scheduler.deleteMarkedTimespan(_optimizationRequests[req.Id].timespan[i]);
                    }
                }

                _optimizationRequests[req.Id] = newRequest;
                addSmartActionTimespan(newRequest);
            });

            updateViewDebounced();
        });

        // add timespan for smart action
        function addSmartActionTimespan(request) {

            if (request.type === OptimizationsRequestTypes['IN_DAY']) {
                if (request.status === 'In Progress') {
                    request.timespan = markSmartActionOnTerritory(request);
                } else if (request.status === 'Completed' || request.status === 'Failed') {
                    for (var i = 0; i < request.territories.length; i++) {
                        if (inDayOptimizationsIntervals[request.territories[i].serviceTerritory] && inDayOptimizationsIntervals[request.territories[i].serviceTerritory][request.id]) {
                            delete inDayOptimizationsIntervals[request.territories[i].serviceTerritory][request.id];
                        }
                    }
                }
            } else if (request.status !== 'Failed' && request.status !== 'Completed' && request.type !== 'Global Optimization' && request.start && request.finish) {
                request.timespan = [markSmartActionOnResource(request)];
            }
        }

        function markSmartActionOnTerritory(request) {

            var timespans = [];

            if (request.territories) {

                var optimizationTerritoriesIdsMap = {};

                for (var i = 0; i < request.territories.length; i++) {
                    optimizationTerritoriesIdsMap[request.territories[i].serviceTerritory] = true;
                }

                var ganttTerritoriesSections = TimePhasedDataService.getGanttSectionsIdsByTerritory(optimizationTerritoriesIdsMap, request.start);

                for (var territoryId in ganttTerritoriesSections) {

                    var inDayInterval = { start: request.start, end: request.finish };

                    if (useLocationTimezone) {
                        inDayInterval.start = utils.convertDateBetweenTimeZones(request.start, 'GMT', ganttTerritoriesSections[territoryId].tz);
                        inDayInterval.end = utils.convertDateBetweenTimeZones(request.finish, 'GMT', ganttTerritoriesSections[territoryId].tz);
                    }

                    if (!inDayOptimizationsIntervals[territoryId]) {
                        inDayOptimizationsIntervals[territoryId] = {};
                    }

                    inDayOptimizationsIntervals[territoryId][request.id] = inDayInterval;

                    for (var resourceId in ganttTerritoriesSections[territoryId].resources) {

                        var timespan = scheduler.addMarkedTimespan({

                            start_date: inDayInterval.start,
                            end_date: inDayInterval.end,

                            sections: { ZoomLevel2: resourceId + '_' + territoryId,
                                ZoomLevel3: resourceId + '_' + territoryId,
                                ZoomLevel4: resourceId + '_' + territoryId,
                                ZoomLevel5: resourceId + '_' + territoryId,
                                ZoomLevel6: resourceId + '_' + territoryId },
                            css: 'smart-on-gantt-inday-body'
                        });

                        timespans.push(timespan);
                    }
                }
            }

            return timespans;
        }

        // put running effect on gantt
        function markSmartActionOnResource(request) {
            if (!request.resource) return new Date().getTime();

            var resourceId = void 0,
                resourceByDate = TimePhasedDataService.getResoruceGanttIdByDate(request.resource, request.start),
                cssType = 'reshufle-on-gantt',
                actionLabel = '';

            if (resourceByDate) resourceId = resourceByDate.split(',');else return new Date().getTime();

            switch (request.type) {
                case 'Fix Overlaps':
                    cssType = 'fix-overlaps-on-gantt';
                    actionLabel = customLabels.FixOverlaps;
                    break;
                case 'SA Reshuffle':
                    cssType = 'reshufle-on-gantt';
                    actionLabel = customLabels.Reshuffle;
                    break;
                case 'Fill-In Schedule':
                    cssType = 'fillin-on-gantt';
                    actionLabel = customLabels.Fill_in_Schedule;
                    break;
                case 'Group Nearby SAs':
                    cssType = 'group-near-on-gantt';
                    actionLabel = customLabels.GroupNearby;
                    break;
                case 'Resource Schedule Optimization':
                    cssType = 'resource-day-on-gantt';
                    actionLabel = customLabels.RDOptimize;
                    break;
                default:
                    cssType = 'reshufle-on-gantt';
            }

            return scheduler.addMarkedTimespan({

                start_date: request.start,

                end_date: request.finish,

                sections: { ZoomLevel2: resourceId, ZoomLevel3: resourceId, ZoomLevel4: resourceId, ZoomLevel5: resourceId, ZoomLevel6: resourceId },
                css: 'smart-on-gantt ' + cssType,
                html: '<div><span>' + actionLabel + '</span></div>'
            });
        }

        function getNumOfActiveOptimizationRequests() {

            var sum = 0;

            for (var key in _optimizationRequests) {
                if (_optimizationRequests[key].status !== 'Completed' && _optimizationRequests[key].status !== 'Failed' && _optimizationRequests[key].status !== 'Aborted') {
                    sum++;
                }
            }

            return sum;
        }

        function isTerritoryHasInDayOptimizationInProgress(start, end, territoryId) {
            if (inDayOptimizationsIntervals[territoryId]) {
                for (var inDayRequestId in inDayOptimizationsIntervals[territoryId]) {
                    if (isIntersect(inDayOptimizationsIntervals[territoryId][inDayRequestId].start, inDayOptimizationsIntervals[territoryId][inDayRequestId].end, start, end)) {
                        return true;
                    }
                }
            }

            return false;
        }

        return {
            getNumOfActiveOptimizationRequests: getNumOfActiveOptimizationRequests,
            optimizationRequests: function optimizationRequests() {
                return _optimizationRequests;
            },
            isTerritoryHasInDayOptimizationInProgress: isTerritoryHasInDayOptimizationInProgress,
            policies: policies
        };
    }
})();