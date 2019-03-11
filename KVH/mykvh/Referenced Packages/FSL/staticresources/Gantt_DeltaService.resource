'use strict';

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

(function () {

    DeltaService.$inject = ['sfdcService', '$interval', 'TimePhasedDataService', 'LastKnownPositionService', 'StateService', 'utils', 'MstResolver', '$timeout'];

    angular.module('serviceExpert').factory('DeltaService', DeltaService);

    function DeltaService(sfdcService, $interval, TimePhasedDataService, LastKnownPositionService, StateService, utils, MstResolver, $timeout) {

        var lastModifiedDate = null,
            deltaIntervalRateInSeconds = deltaInterval || 10,
            registeredFunctions = {
            services: [],
            absences: [],
            capacities: [],
            positions: [],
            optimizationRequests: [],
            rules: []
        };

        /* This is the for expilict delta calls we do from various places in FSL. 
         * when the delta returns, there is no need to start a new timeout.
         */
        function getDelta() {

            if (StateService.getStreamingActiveState() === false) {

                var deltaDates = StateService.getDeltaDates();

                sfdcService.getDelta(lastModifiedDate, deltaDates.minDate, deltaDates.maxDate).then(handleDeltaResponse).catch(function (ex) {
                    console.warn(ex);
                });
            }
        }

        /* This is the running delta call every X seconds. 
         * when the delta returns, we need to start a new timeout.
         */
        function getRunningDelta() {
            var deltaStart = new Date();

            if (StateService.getStreamingActiveState() === false) {

                var deltaDates = StateService.getDeltaDates();

                //we are adding the margins in the apex class
                //console.log('(debug only - remove before V7) Get delta between: ' + moment(deltaDates.minDate).add(-deltaBackDaysMargin, 'days').format('L') + ' and ' + moment(deltaDates.maxDate).add(deltaForwardDaysMargin, 'days').format('L'));

                sfdcService.getDelta(lastModifiedDate, deltaDates.minDate, deltaDates.maxDate).then(function (deltaResult) {

                    //get ready to call next delta
                    var deltaDiff = deltaIntervalRateInSeconds * 1000 - getElapsedDeltaTime(deltaStart);
                    $timeout(getRunningDelta, deltaDiff < 0 ? 0 : deltaDiff);

                    handleDeltaResponse(deltaResult);
                }).catch(function (ex) {
                    console.warn(ex);
                });
            }
        }

        function getElapsedDeltaTime(deltaStart) {
            return new Date() - deltaStart; //in ms
        }

        // - ori-4/10/18 change from interval to timeout to prevent long delta calls which can cause a delta queue and lead to slow UI.
        //$interval(getDelta, deltaIntervalRateInSeconds * 1000);
        $timeout(getRunningDelta, deltaIntervalRateInSeconds * 1000);

        function updateOptimizationRequest(req) {
            registeredFunctions.optimizationRequests.forEach(function (requestFunction) {
                return requestFunction([req]);
            });
        }

        // register for updates  |  TYPES: absences, services, capacities
        function register(type, callback) {
            return registeredFunctions[type] && registeredFunctions[type].push(callback);
        }

        function unRegister(type, callback) {
            registeredFunctions[type].splice(registeredFunctions[type].indexOf(callback), 1);
        }

        function handleDeltaResponse(delta) {

            lastModifiedDate = delta.updateTime;

            var servicesIdsToCheckRules = [];

            // check if got absences
            if (delta.deletedAbsence && delta.deletedAbsence.length > 0 || delta.updatedAbsence && delta.updatedAbsence.length > 0) {

                var absences = {};

                if (delta.updatedAbsence.length > 0) {
                    var absencesUpdateRes = TimePhasedDataService.updateTimePhaseData(delta.updatedAbsence, 'na');
                    absences.updated = absencesUpdateRes.absences;
                    absences.deleted = absencesUpdateRes.notApprovedAbsencesIds;

                    var resourceIds = absences.updated.map(function (v) {
                        return v.resource;
                    }).join(',');
                    servicesIdsToCheckRules.push.apply(servicesIdsToCheckRules, _toConsumableArray(utils.getRelatedServices(utils.getIdsOfSObjects(absences.updated), resourceIds)));

                    //servicesIdsToCheckRules.push(...utils.getRelatedServices(utils.getIdsOfSObjects(absences.updated)));
                }

                if (delta.deletedAbsence.length > 0) {
                    if (absences.deleted) {
                        absences.deleted = absences.deleted.concat(TimePhasedDataService.deleteTimePhaseData(delta.deletedAbsence, 'na').absences);
                    } else {
                        absences.deleted = TimePhasedDataService.deleteTimePhaseData(delta.deletedAbsence, 'na').absences;
                    }

                    servicesIdsToCheckRules.push.apply(servicesIdsToCheckRules, _toConsumableArray(utils.getRelatedServices(absences.deleted)));
                    //servicesIdsToCheckRules.push(...utils.getRelatedServices(utils.getIdsOfSObjectsAbsence(absences.deleted)));
                }

                // run registered function (only if something was really updated)
                if (absences.updated || absences.deleted) {
                    registeredFunctions.absences.forEach(function (absenceFunction) {
                        return absenceFunction(absences);
                    });
                }
            }

            // check if got services
            if (delta.updatedGanttServices && delta.updatedGanttServices.length > 0 || delta.deletedGanttServices && delta.deletedGanttServices.length > 0) {

                var services = {};

                if (delta.deletedGanttServices.length > 0) {
                    services.deleted = TimePhasedDataService.deleteTimePhaseData(delta.deletedGanttServices, 'service').services;
                    servicesIdsToCheckRules.push.apply(servicesIdsToCheckRules, _toConsumableArray(utils.getRelatedServices(services.deleted)));
                }

                if (delta.updatedGanttServices.length > 0) {
                    services.updated = TimePhasedDataService.updateTimePhaseData(delta.updatedGanttServices, 'service').services;
                    servicesIdsToCheckRules.push.apply(servicesIdsToCheckRules, _toConsumableArray(utils.getRelatedServices(utils.getIdsOfSObjects(services.updated))));
                }

                // run registered function (only if something was really updated)
                if (services.updated || services.deleted) {
                    registeredFunctions.services.forEach(function (serviceFunction) {
                        return serviceFunction(services);
                    });
                }
            }

            // check for live position
            if (delta.updatedLivePositions) {

                var updateRes = LastKnownPositionService.updatePositions(delta.updatedLivePositions);

                if (updateRes.isUpdated) {
                    registeredFunctions.positions.forEach(function (posFunction) {
                        return posFunction(updateRes.dic);
                    });
                }
            }

            // check if we need to check rules {
            if (servicesIdsToCheckRules.length > 0) {
                registeredFunctions.rules.forEach(function (posFunction) {
                    return posFunction(servicesIdsToCheckRules);
                });
            }

            // check if got capacities
            if (StateService.areContractorsSupported) {
                if (delta.deletedCapacities && delta.deletedCapacities.length > 0 || delta.updatedCapacities && delta.updatedCapacities.length > 0) {

                    var capacities = {};

                    if (delta.deletedCapacities.length > 0) {
                        capacities.deleted = TimePhasedDataService.deleteTimePhaseData(delta.deletedCapacities, 'capacity').capacities;
                    }

                    if (delta.updatedCapacities.length > 0) {
                        capacities.updated = TimePhasedDataService.updateTimePhaseData(delta.updatedCapacities, 'capacity').capacities;
                    }

                    // run registered function (only if something was really updated)
                    if (capacities.updated || capacities.deleted) {
                        registeredFunctions.capacities.forEach(function (capacityFunction) {
                            return capacityFunction(capacities);
                        });
                    }
                }
            }

            // check if got optimization requests
            if (StateService.isOptimizationEnabled && delta.optimizationRequests && delta.optimizationRequests.length > 0) {
                registeredFunctions.optimizationRequests.forEach(function (requestFunction) {
                    return requestFunction(delta.optimizationRequests);
                });
            }
        }

        // This will be our factory
        return {
            register: register,
            unRegister: unRegister,
            getDelta: getDelta,
            updateOptimizationRequest: updateOptimizationRequest,
            handleDeltaResponse: handleDeltaResponse
        };
    }
})();