'use strict';

(function () {
    var app = angular.module('Crews', ['angularMoment']);

    app.run(['amMoment', function (amMoment) {
        amMoment.changeLocale(window.userLocale);
    }]);

    moment.locale(window.userLocale);
})();
'use strict';

GanttController.$inject = ['$rootScope', '$scope', 'DataService', 'UtilsService', 'GeneralLightbox', 'ScmLightbox', 'TerritoryFilteringService', 'GetCrewCandidates'];

angular.module('Crews').controller('Gantt', GanttController);

function GanttController($rootScope, $scope, DataService, UtilsService, GeneralLightbox, ScmLightbox, TerritoryFilteringService, GetCrewCandidates) {

    var ganttFolderOpenStatus = {},
        serviceContextMenu = null,
        lastServiceRightClickId = null;

    $scope.daysOnGantt = '4';

    // attach scheduler events when ready
    scheduler.attachEvent("onSchedulerReady", function () {

        scheduler.attachEvent("onBeforeFolderToggle", onBeforeFolderToggle);
        scheduler.attachEvent("onBeforeViewChange", onBeforeViewChange);
        scheduler.attachEvent("onBeforeLightbox", function () {
            return false;
        });
        scheduler.attachEvent('onBeforeEventChanged', onBeforeEventChanged);
        scheduler.attachEvent("onBeforeDrag", onBeforeDrag);
        scheduler.attachEvent("onDblClick", onDblClick);
        scheduler.attachEvent("onYScaleClick", onYScaleClick);
        scheduler.attachEvent("onAfterEventDisplay", onAfterEventDisplay);
        scheduler.attachEvent("onCellDblClick", onCellDblClick);
        scheduler.attachEvent("onViewChange", onViewChange);
        scheduler.attachEvent("onBeforeTooltip", onBeforeTooltip);

        configureServiceContextMenu();
    });

    // update gantt resources when needed
    $rootScope.$on('createGanttTimeline', function () {

        DataService.getGanttData(scheduler._min_date, scheduler._max_date).then(function (ganttScms) {
            createGanttTimeline();
            scheduler.parse(ganttScms, 'json');
            DataService.validateAllServicesInView();
        });
    });

    ganttInit();

    // generate the timeline
    function createGanttTimeline() {

        var timeline = [],
            territories = DataService.getLoadedTerritories(),
            resources = DataService.getResources(),
            crewIdsToChildrenMap = {},
            crews = DataService.getCrews(),
            skills = DataService.getSkills();

        // copy territories into timeline as a base
        for (var territoryId in territories) {

            var crewsInTerritory = [];

            var _loop = function _loop(id) {

                var stm = territories[territoryId].territoryMemberships[id];

                // STM does not intersect
                if (!UtilsService.isIntersect(scheduler._min_date, scheduler._max_date, stm.ganttEffectiveStartDate, stm.ganttEffectiveEndDate)) {
                    return 'continue';
                }

                // STM type is secondary
                if (stm.TerritoryType === 'S') {
                    return 'continue';
                }

                // STM must be for a crew
                if (!stm.ServiceResource.ServiceCrewId) {
                    return 'continue';
                }

                // check that crew is not already in territory
                if (!crewsInTerritory.some(function (crew) {
                    return crew.crewId === stm.ServiceResource.ServiceCrewId;
                }) && crews[stm.ServiceResource.Id]) {

                    var crewKeyOnGanttForSas = stm.ServiceResource.ServiceCrewId + '_' + stm.ServiceTerritoryId,
                        crewKeyOnGanttForCrew = stm.ServiceResource.ServiceCrewId + '_' + stm.ServiceTerritoryId + '_folder',
                        crew = crews[stm.ServiceResource.Id],
                        labelOnGantt = '<div class="cm-drag-resource-on-crew">' + window.__crews.labels.DragResourcesToAssignThemTo.replace('{0}', stm.ServiceResource.Name) + '</div>',
                        crewColor = crew.ServiceCrew[window.__crews.fields.ServiceCrew.GanttColor__c] || '#52a3da',
                        skillsSentence = UtilsService.generateSkillsSentence(crew.ServiceResourceSkills, skills, crew) || window.__crews.labels.CrewHasNoSkills;

                    labelOnGantt += '<svg aria-hidden="true" class="slds-icon cm-crew-icon-folder" style="background-color: ' + crewColor + ' !important;"><use xlink:href="' + window.__crews.icons.service_crew_member + '"></use></svg>';
                    labelOnGantt += '<span title="' + skillsSentence + '">' + stm.ServiceResource.Name + ' ' + window.__crews.labels.CrewSizeOnCm.replace('{0}', crew.ServiceCrew.CrewSize) + '</span>';

                    if (skillsSentence !== window.__crews.labels.CrewHasNoSkills) {
                        labelOnGantt += '<div class="cm-crew-container-folder-buttons" onClick="window.__crews.functions.matchCrewSkillsInFilter(event, \'' + crew.Id + '\')">' + window.__crews.labels.MatchCrewSkills + '</div>';
                    }

                    crewsInTerritory.push({
                        children: [{
                            key: crewKeyOnGanttForSas,
                            label: window.__crews.labels.CrewSchedule
                        }],
                        label: labelOnGantt,
                        crewId: stm.ServiceResource.ServiceCrewId,
                        disableEventCreation: true,
                        key: crewKeyOnGanttForCrew,
                        open: ganttFolderOpenStatus[crewKeyOnGanttForCrew] !== undefined ? ganttFolderOpenStatus[crewKeyOnGanttForCrew] : true
                    });

                    crewIdsToChildrenMap[stm.ServiceResource.ServiceCrewId] = crewsInTerritory[crewsInTerritory.length - 1].children;
                }
            };

            for (var id in territories[territoryId].territoryMemberships) {
                var _ret = _loop(id);

                if (_ret === 'continue') continue;
            }

            // add this territory if it has crews
            if (crewsInTerritory.length > 0) {

                territories[territoryId].children = crewsInTerritory;
                timeline.push(territories[territoryId]);

                // make a string of IDs of all crews in current territories
                var crewsIdsInTerritory = '';
                territories[territoryId].children.forEach(function (crew) {
                    return crewsIdsInTerritory += crew.crewId + '_';
                });

                // add resources with STM and SCM
                for (var resourceId in resources) {

                    var currentResource = resources[resourceId],
                        alreadyAddedResource = {};

                    // only technicians are acceptable
                    if (currentResource.ResourceType !== 'T') {
                        continue;
                    }

                    // check if resource has SCM
                    for (var id in currentResource.crewMemberships) {

                        var scm = currentResource.crewMemberships[id];

                        // crew was already added
                        if (alreadyAddedResource[scm.ServiceCrewId]) {
                            continue;
                        }

                        // current SCM is not for a crew in the territory
                        if (!crewsIdsInTerritory.includes(scm.ServiceCrewId)) {
                            continue;
                        }

                        // current SCM doesn't intersect current view
                        if (!UtilsService.isIntersect(scheduler._min_date, scheduler._max_date, scm.start_date, scm.end_date)) {
                            continue;
                        }

                        // does resource has STM to current territory
                        var resourceStmId = UtilsService.doesResourceHasStm(currentResource, territoryId, scheduler._min_date, scheduler._max_date);
                        if (!resourceStmId) {
                            continue;
                        }

                        // all checks passed, lets add this resource to a crew and mark it as added
                        crewIdsToChildrenMap[scm.ServiceCrewId].push({
                            label: currentResource.label,
                            key: scm.ServiceResourceId + '_' + resourceStmId + '_' + scm.ServiceCrewId
                        });

                        alreadyAddedResource[scm.ServiceCrewId] = true;
                    }
                }
            }
        }

        scheduler.updateCollection('resources', timeline);
    }

    // init the gantt
    function ganttInit() {

        DataService.getResourcesPromise().promise.then(function () {

            var start = new Date();

            start.setHours(0);
            start.setMinutes(0);

            var end = new Date(start);

            end.setDate(5 + end.getDate());

            scheduler.init('Gantt', start, 'CrewsTimeline');

            // get data if user has already selected his territories, otherwise show territories panel
            var localStorageTerritories = localStorage.getItem('territories');

            if (!localStorageTerritories) {
                TerritoryFilteringService.toggle();
                return;
            }

            DataService.getGanttData(start, end).then(function (ganttScms) {
                createGanttTimeline();
                scheduler.parse(ganttScms, 'json');
                DataService.validateAllServicesInView();
            });
        });
    }

    // change date for buttons , 0 = today
    $scope.changeDate = function (time) {

        var newDate = new Date();

        if (time !== 0) {
            newDate = new Date(scheduler._min_date);
            newDate.setDate(newDate.getDate() + time);
        }

        scheduler.setCurrentView(newDate);
    };

    // jump to date with DHTMLX mini calendar
    $scope.jumpToDate = function () {
        if (scheduler.isCalendarVisible()) {
            scheduler.destroyCalendar();
        } else {
            scheduler.renderCalendar({
                position: 'JumpToDate',
                date: scheduler._date,
                navigation: true,
                handler: function handler(date, calendar) {
                    scheduler.setCurrentView(date);
                    scheduler.destroyCalendar();
                }
            });
        }
    };

    // bring new data before changing the view
    function onBeforeViewChange(old_mode, old_date, mode, newDate) {

        if (old_date && old_date.getTime() !== newDate.getTime()) {

            var timelineSize = scheduler._max_date.getTime() - scheduler._min_date.getTime(),
                endDate = new Date(newDate);

            endDate.setMilliseconds(endDate.getMilliseconds() + timelineSize);

            DataService.getGanttData(newDate, endDate).then(function (ganttScms) {

                DataService.validateAllServicesInView();

                // prase new SCMs
                scheduler.parse(ganttScms, 'json');

                // update timeline
                createGanttTimeline();
            });
        }

        return true;
    }

    // handle gantt folder state
    function onBeforeFolderToggle(section, isOpen, allSections) {
        ganttFolderOpenStatus[section.key] = isOpen;
        return true;
    }

    // you can't create SCMs on the service appointment row
    function onBeforeDrag(id, mode, e) {

        // cancel service dragging
        if (id && scheduler._events[id] && scheduler._events[id].readonly) {
            return false;
        }

        var actionData = scheduler.getActionData(e);

        return actionData.section.includes('_');
    }

    // handle saving of SCMs
    function onBeforeEventChanged(ev, e, is_new, original) {

        // check if we dragged to a folder
        var ganttDropData = scheduler.getActionData(e);

        if (ganttDropData && ganttDropData.section) {

            if (!ganttDropData.section.includes('_') || ganttDropData.section.includes('_folder')) {
                return false;
            }
        }

        // RREMINDER: resourceId on gantt is combination of RESOURCE, STM and CREW IDs

        var dataFromResourceId = ev.resourceId.split('_'),
            resourceId = dataFromResourceId[0],
            resourceStm = dataFromResourceId[1],
            crewId = dataFromResourceId[2],
            scmId = is_new ? null : ev.Id,
            resource = DataService.getResources()[resourceId];

        // checking that this is not the SA row
        if (dataFromResourceId.length === 1) {
            return false;
        }

        if (!resource) {
            return;
        }

        var stm = resource.territoryMemberships[resourceStm],
            startDate = UtilsService.convertDateToUTC(ev.start_date, stm.timezone),
            endDate = UtilsService.convertDateToUTC(ev.end_date, stm.timezone);

        // save changes to service
        DataService.saveChangesToStm(scmId, resourceId, crewId, startDate, endDate, false).then(function (data) {

            // delete old event and update with new/updated SCM
            delete scheduler._events[ev.id];
            scheduler.parse(data, 'json');
        }).catch(function (err) {

            // in case of an error, need to undo changes
            if (!is_new) {
                scheduler._events[ev.id] = original;
                scheduler.updateView();
            } else {
                scheduler.deleteEvent(ev.id);
            }
        });

        return true;
    }

    // handle clicking on events on gantt
    function onDblClick(id, e) {

        var ganttEvent = scheduler._events[id];

        if (ganttEvent.type === 'service') {

            var tabs = [{ name: window.__crews.labels.Details, url: window.__crews.pages.service + '?id=' + ganttEvent.Id }];

            if (ganttEvent.ParentRecordType === 'WorkOrder') {
                tabs.push({ name: window.__crews.labels.WorkOrder, url: window.__crews.pages.workorder + '?id=' + ganttEvent.ParentRecordId });
            } else {
                tabs.push({ name: window.__crews.labels.WOLI, url: window.__crews.pages.woli + '?id=' + ganttEvent.ParentRecordId });
            }

            GeneralLightbox.open(ganttEvent.AppointmentNumber, tabs, ganttEvent.Id);
            window.scheduler.tooltip.hide();
        }

        if (ganttEvent.type === 'scm') {
            ScmLightbox.open(ganttEvent);
            window.scheduler.tooltip.hide();
        }
    }

    // handle clicking on a resource
    function onYScaleClick(index, section, e) {

        if (section.level === 2) {

            var resourceId = section.key.split('_'),
                resource = DataService.getResources()[section.key.split('_')[0]];

            if (resourceId.length === 3 && !section.key.includes('_CREATE')) {
                GeneralLightbox.open(resource.Name, window.__crews.pages.resource + '?id=' + resourceId[0], resourceId[0]);
            }
        }
    }

    // after show on gantt, jump animation
    function onAfterEventDisplay(ev) {

        setTimeout(function () {
            ev.showEffect = false;
            scheduler.updateView();
        }, 900);
    }

    // double click empty cell to create
    function onCellDblClick(x_ind, y_ind, clickedDate, y_val, eventObject) {

        var schedulerData = scheduler.getActionData(eventObject);

        // not clicked on a resource
        if (schedulerData.section.includes('_folder') || schedulerData.section.includes('_CREATE') || schedulerData.section.split('_').length === 2) {
            return;
        }

        var start = new Date(clickedDate),
            end = new Date(clickedDate);

        start.setHours(0);
        start.setMinutes(0);
        end.setHours(24);
        end.setMinutes(0);

        // REMINDER: ServiceResourceId_resourceStmId_ServiceCrewId
        var resourceId = schedulerData.section.split('_')[0],
            stmId = schedulerData.section.split('_')[1],
            crewId = schedulerData.section.split('_')[2],
            objectForLightbox = {
            start: start,
            end: end,
            territory: DataService.getTerritories()[DataService.getTerritoryMemberships()[stmId].ServiceTerritoryId],
            resourceIds: [resourceId],
            crewId: crewId
        };

        ScmLightbox.openFromDrag(objectForLightbox);
    }

    function onViewChange(new_mode, new_date) {
        DataService.validateAllServicesInView();
        scheduler.updateView();
    }

    function onBeforeTooltip(id) {
        return !serviceContextMenu._isContextMenuVisible();
    }

    function configureServiceContextMenu() {

        serviceContextMenu = new dhtmlXMenuObject({
            parent: 'contextZone_A',
            context: true
        });

        serviceContextMenu.addNewChild(serviceContextMenu.topId, 0, 'getCandidates', '<svg aria-hidden="true" class="slds-icon cm-contextmenu"><use xlink:href="' + window.__crews.icons.candidates + '"></use></svg><span class="menu-caps">' + window.__crews.labels.Get_Candidates + '</span>', false);

        serviceContextMenu.attachEvent('onClick', function (id, zoneId, cas) {

            var service = scheduler._events[lastServiceRightClickId],
                skillsIds = [];

            switch (id) {

                case 'allSkills':
                    service.requiredSkills.forEach(function (s) {
                        return skillsIds.push(s.SkillId);
                    });
                    $rootScope.$broadcast('FilterSkills', skillsIds);
                    break;

                case 'missingSkills':
                    service.missingSkills.forEach(function (s) {
                        return s.missing && skillsIds.push(s.SkillId);
                    });
                    $rootScope.$broadcast('FilterSkills', skillsIds);
                    break;

                case 'getCandidates':

                    if (!service.MinimumCrewSize || service.MinimumCrewSize === '-') {
                        alert(window.__crews.labels.ServiceNoMinimumCrew);
                        return;
                    }

                    GetCrewCandidates.get(service);
                    break;

            }
        });

        scheduler.attachEvent('onContextMenu', function (event_id, native_event_object) {

            native_event_object.preventDefault();

            if (!event_id || event_id && scheduler._events[event_id].type !== 'service') {
                return;
            }

            lastServiceRightClickId = event_id;
            scheduler.dhtmlXTooltip.hide();

            var posx = 0,
                posy = 0;

            if (native_event_object.pageX || native_event_object.pageY) {

                posx = native_event_object.pageX;
                posy = native_event_object.pageY;
            } else if (native_event_object.clientX || native_event_object.clientY) {

                posx = native_event_object.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
                posy = native_event_object.clientY + document.body.scrollTop + document.documentElement.scrollTop;
            }

            serviceContextMenu.showContextMenu(posx, posy);
        });
    }

    window.__crews.functions.matchCrewSkillsInFilter = function (event, crewId) {

        event.stopPropagation();

        var crewSkills = DataService.getCrews()[crewId].ServiceResourceSkills;

        if (crewSkills) {
            $rootScope.$broadcast('FilterSkills', crewSkills.map(function (skill) {
                return skill.SkillId;
            }));
        }
    };

    $scope.noTerritoriesSelected = function () {
        return window.localStorage && !localStorage.territories;
    };

    $scope.changeDaysOnGantt = function () {

        var daysConfig = [{ x_step: 60, x_size: 24, x_length: 24 }, { x_step: 120, x_size: 24, x_length: 12 }, { x_step: 180, x_size: 24, x_length: 8 }, { x_step: 360, x_size: 16, x_length: 4 }, { x_step: 360, x_size: 20, x_length: 4 }, { x_step: 360, x_size: 24, x_length: 4 }, { x_step: 360, x_size: 28, x_length: 4 }, { x_step: 1440, x_size: 14, x_length: 1 }];

        angular.merge(scheduler.matrix.CrewsTimeline, daysConfig[$scope.daysOnGantt]);

        var startDate = new Date(scheduler._min_date),
            endDate = new Date(scheduler._max_date);

        endDate.setDate(endDate.getDate() + parseInt($scope.daysOnGantt) + 1);

        DataService.getGanttData(startDate, endDate).then(function (ganttScms) {

            DataService.validateAllServicesInView();

            // prase new SCMs
            scheduler.parse(ganttScms, 'json');

            // update timeline
            createGanttTimeline();
        });

        scheduler.updateView();
    };

    // key shortcuts
    document.addEventListener('keyup', function (event) {

        var element = null;

        switch (event.which) {

            case 37:

                element = window.document.getElementsByClassName('cm-top-button-container');

                if (element && element[0]) {
                    element[0].click();
                }

                break;

            // right arrow
            case 39:

                element = window.document.getElementsByClassName('cm-top-button-container');

                if (element && element[1]) {
                    element[1].click();
                }

                break;

            // T - jump to today
            case 84:
                $scope.changeDate(0);
                break;
        }
    });
}
'use strict';

ResourceListController.$inject = ['$scope', '$filter', 'DataService', 'TerritoryFilteringService', 'UtilsService'];

angular.module('Crews').controller('ResourceList', ResourceListController);

function ResourceListController($scope, $filter, DataService, TerritoryFilteringService, UtilsService) {

    $scope.selectedFilterSkills = {};
    $scope.getSelectedResourcesOnList = DataService.getSelectedResourcesOnList;
    $scope.currentFilteredResources = [];
    $scope.filterBoxXY = { x: 0, y: 0 };

    $scope.$on('FilterSkills', function (event, skills) {

        if (Array.isArray(skills) && skills.length > 0) {

            for (var key in $scope.selectedFilterSkills) {
                $scope.selectedFilterSkills[key] = false;
            }

            skills.forEach(function (skillId) {
                return $scope.selectedFilterSkills[skillId] = true;
            });
            $scope.skillsLogicOperator = "or";

            UtilsService.safeApply($scope);
        }
    });

    $scope.showSkillsFilterBox = function ($event) {

        $scope.showSkillsFilter = true;
        $event.stopPropagation();

        $scope.filterBoxXY.x = $event.currentTarget.getBoundingClientRect().left + 'px';
        $scope.filterBoxXY.y = $event.currentTarget.getBoundingClientRect().top + 34 + 'px';
    };

    $scope.isSkillsFilterApplied = function () {

        for (var key in $scope.selectedFilterSkills) {
            if ($scope.selectedFilterSkills[key]) {
                return true;
            }
        }

        return false;
    };

    $scope.setSearchTerm = function () {
        TerritoryFilteringService.setSearchTerm($scope.territorySearch);
    };

    $scope.countSelected = function () {

        var count = 0,
            selectedResources = DataService.getSelectedResourcesOnList();

        for (var key in selectedResources) {
            if (selectedResources[key]) {
                count++;
            }
        }

        return count;
    };

    $scope.unselectAllResources = function () {

        var selectedResources = DataService.getSelectedResourcesOnList();

        for (var key in selectedResources) {
            selectedResources[key] = false;
        }
    };

    $scope.getSkills = function (searchTerm) {

        if (!searchTerm) {
            return DataService.getSkills();
        }

        var skills = DataService.getSkills(),
            filtertedSkills = {};

        for (var id in skills) {

            if (skills[id].toUpperCase().includes(searchTerm.toUpperCase())) {
                filtertedSkills[id] = skills[id];
            }
        }

        return filtertedSkills;
    };

    $scope.filterTerritories = function () {

        var territoriesForFilter = [],
            territories = DataService.getLoadedTerritories();

        for (var id in territories) {
            if (territories[id] && Object.keys(territories[id].territoryMemberships).length > 0) {
                territoriesForFilter.push(territories[id]);
            }
        }

        return territoriesForFilter;
    };

    $scope.filterResources = function (territory) {

        var currentFilteredResources = $filter('ResourceFilter')(territory, $scope.selectedFilterSkills, $scope.resourceSearch, $scope.skillsLogicOperator);
        territory.hasResourcesToDisplayOnList = currentFilteredResources.length > 0;

        return currentFilteredResources;
    };

    $scope.areAnyResorcesAvailabeOnList = function () {
        return $scope.filterTerritories().find(function (x) {
            return x.hasResourcesToDisplayOnList;
        });
    };

    $scope.showTerritoryFilter = function () {
        TerritoryFilteringService.toggle();
    };

    $scope.isTerritoryFilterOpen = function () {
        return TerritoryFilteringService.isOpen();
    };
}
'use strict';

ToastController.$inject = ['$scope', 'UtilsService'];

angular.module('Crews').controller('ToastController', ToastController);

function ToastController($scope, UtilsService) {

    $scope.localErrors = [];

    $scope.clear = function () {
        $scope.localErrors.length = 0;
    };

    UtilsService.subscribeForNewErrors(function (error) {
        $scope.localErrors.unshift(error);
    });
}
'use strict';

dragTarget.$inject = ['DataService', 'UtilsService', 'ScmLightbox'];

angular.module('Crews').directive('dragTarget', dragTarget);

function dragTarget(DataService, UtilsService, ScmLightbox) {

    return {
        restrict: 'CAE',

        link: function link(scope, element, attributes, ctlr) {

            // dragging over the gantt
            element.bind('dragover', function (eventObject) {
                eventObject.preventDefault();
            });

            element.bind('drop', function (eventObject) {

                eventObject.preventDefault();

                var objectForLightbox = {
                    start: scheduler._min_date,
                    end: scheduler._max_date
                },
                    schedulerData = scheduler.getActionData(eventObject.originalEvent),
                    territoryId = schedulerData.section.split('_')[0],
                    crewId = schedulerData.section.split('_')[1];

                if (schedulerData.section.includes('_folder')) {
                    territoryId = schedulerData.section.split('_')[1];
                    crewId = schedulerData.section.split('_')[0];
                } else {

                    var foundEvent = false;

                    // set dates
                    for (var id in scheduler._events) {

                        var ganttEvent = scheduler._events[id];

                        if (ganttEvent.resourceId === schedulerData.section && UtilsService.isIntersect(schedulerData.date, schedulerData.date, ganttEvent.start_date, ganttEvent.end_date)) {

                            objectForLightbox.start = ganttEvent.start_date;
                            objectForLightbox.end = ganttEvent.end_date;

                            if (ganttEvent.type === 'service') {
                                territoryId = schedulerData.section.split('_')[1];
                                crewId = schedulerData.section.split('_')[0];
                            } else {
                                territoryId = DataService.getResources()[schedulerData.section.split('_')[0]].territoryMemberships[schedulerData.section.split('_')[1]].ServiceTerritoryId;
                                crewId = schedulerData.section.split('_')[2];
                            }

                            foundEvent = true;
                            break;
                        }
                    }

                    // wasn't dropped on SCM or SA (and not on CREATE line)
                    if (!foundEvent) {
                        return;
                    }
                }

                objectForLightbox.territory = DataService.getTerritories()[territoryId];
                objectForLightbox.resourceIds = eventObject.originalEvent.dataTransfer.getData('text').split(',');
                objectForLightbox.crewId = crewId;

                ScmLightbox.openFromDrag(objectForLightbox);
            });
        }

    };
}
'use strict';

draggableResource.$inject = ['DataService', 'UtilsService'];

angular.module('Crews').directive('draggableResource', draggableResource);

function draggableResource(DataService, UtilsService) {

    function getSelectedResources() {

        var selectedIds = [],
            resourcesNames = [],
            selectedResources = DataService.getSelectedResourcesOnList();

        for (var id in selectedResources) {
            if (selectedResources[id]) {
                selectedIds.push(id);
                resourcesNames.push(DataService.getResources()[id].Name);
            }
        }

        return {
            ids: selectedIds.join(','),
            names: resourcesNames.join(', ')
        };
    }

    return {
        restrict: 'CAE',
        scope: { draggableResource: '=' },

        link: function link(scope, element, attributes, ctlr) {

            element.bind('dragend', function (eventObject) {
                eventObject.preventDefault();
                $('#CrewsGantt').removeClass('cm-dragging');
            });

            element.bind('dragstart', function (eventObject) {

                $('#CrewsGantt').addClass('cm-dragging');

                // auto select the resource we started the drag frmo (if not selected)
                DataService.getSelectedResourcesOnList()[scope.draggableResource.Id] = true;
                UtilsService.safeApply(scope);

                var resourcesData = getSelectedResources();

                // set resourcess Ids
                eventObject.originalEvent.dataTransfer.setData('text', resourcesData.ids);

                // get draggable dom element
                var draggableDomElement = $('#cm-DraggedResources');
                draggableDomElement.html(resourcesData.names);

                var crt = document.getElementById('cm-DraggedResources');

                document.body.appendChild(crt);
                var testDataTransfer = window.DataTransfer;
                if ('setDragImage' in testDataTransfer.prototype) {
                    eventObject.originalEvent.dataTransfer.setDragImage(crt, 0, 28);
                }
            });
        }
    };
}
'use strict';

ResourceCard.$inject = ['DataService', 'GeneralLightbox', 'UtilsService'];

angular.module('Crews').directive('resourceCard', ResourceCard);

function ResourceCard(DataService, GeneralLightbox, UtilsService) {

    return {
        restrict: 'CAE',
        scope: {
            resource: '='
        },

        link: function link(scope, element, attributes, ctlr) {

            scope.getSelectedResourcesOnList = DataService.getSelectedResourcesOnList;
            scope.resource.listOpened = false;
            scope.getSelectedResourcesOnList()[scope.resource.Id] = false;

            scope.objectIsEmpty = function (obj) {
                return Object.keys(obj).length === 0;
            };

            scope.generateSkillsSentence = function (resourceSkills) {
                return UtilsService.generateSkillsSentence(resourceSkills, DataService.getSkills());
            };

            scope.openResourceLightbox = function (name, id, ev) {
                ev.stopPropagation();
                GeneralLightbox.open(name, window.__crews.pages.resource + '?id=' + id, id);
            };

            scope.showScmOnGantt = function (id) {

                if (scheduler._events[id]) {
                    scheduler._events[id].showEffect = true;
                    scheduler.showEvent(id);
                }

                if (!scheduler.getRenderedEvent(id)) {
                    window.alert(window.__crews.labels.NoScmToDisplay);
                }
            };

            scope.formatStm = function (stm) {

                var stmType = window.__crews.labels.Primary,
                    territoryName = DataService.getTerritories()[stm.ServiceTerritoryId].Name;

                if (stm.TerritoryType === 'S') {
                    stmType = window.__crews.labels.Secondary;
                } else if (stm.TerritoryType === 'R') {
                    stmType = window.__crews.labels.Relocation;
                }

                if (!stm.EffectiveStartDate && !stm.EffectiveEndDate) {
                    return '' + window.__crews.labels.StmNoStartNoEnd.replace('{0}', territoryName).replace('{1}', stmType);
                }

                if (!stm.EffectiveStartDate && stm.EffectiveEndDate) {
                    return '' + window.__crews.labels.StmNoStartHasEnd.replace('{0}', territoryName).replace('{1}', stm.EffectiveEndDate.format('l LT')).replace('{2}', stmType);
                }

                if (stm.EffectiveStartDate && !stm.EffectiveEndDate) {
                    return '' + window.__crews.labels.StmHasStartNoEnd.replace('{0}', territoryName).replace('{1}', stm.EffectiveStartDate.format('l LT')).replace('{2}', stmType);
                }

                if (stm.EffectiveStartDate && stm.EffectiveEndDate) {
                    return '' + window.__crews.labels.StmHasStartHasEnd.replace('{0}', territoryName).replace('{1}', stm.EffectiveStartDate.format('l LT')).replace('{2}', stm.EffectiveEndDate.format('l LT')).replace('{3}', stmType);
                }
            };

            scope.formatScm = function (scm) {

                var crewName = scm.ServiceCrew.Name;

                if (!scm.StartDate && !scm.EndDate) {
                    '' + window.__crews.labels.ScmNoStartNoEnd.replace('{0}', crewName);
                }

                if (!scm.StartDate && scm.EndDate) {
                    return '' + window.__crews.labels.ScmNoStartHasEnd.replace('{0}', crewName).replace('{1}', moment(scm.end_date).format('l LT'));
                }

                if (scm.StartDate && !scm.EndDate) {
                    return '' + window.__crews.labels.ScmHasStartNoEnd.replace('{0}', crewName).replace('{1}', moment(scm.start_date).format('l LT'));
                }

                if (scm.StartDate && scm.EndDate) {
                    return '' + window.__crews.labels.ScmHasStartHasEnd.replace('{0}', crewName).replace('{1}', moment(scm.start_date).format('l LT')).replace('{2}', moment(scm.end_date).format('l LT'));
                }
            };

            scope.getStmType = function (scm) {

                switch (scm.stmType) {
                    case 'S':
                        return window.__crews.labels.Secondary;
                    case 'P':
                        return window.__crews.labels.Primary;
                    case 'R':
                        return window.__crews.labels.Relocation;
                }
            };
        },

        template: '<div>\n\n                        <div class="cm-resource-header" ng-class="{\'no-label-header\': !resource[\'' + window.__crews.fields.ServiceResource.GanttLabel__c + '\'] }" draggable="true" draggable-resource="resource" ng-click="resource.listOpened = !resource.listOpened" ng-class="{\'cm-resource-open\': resource.listOpened}">\n\n                            <input type="checkbox" ng-model="getSelectedResourcesOnList()[resource.Id]" ng-click="$event.stopPropagation()" />\n\n                            <img class="cm-resource-list-avatar" ng-src="{{ resource.RelatedRecord.SmallPhotoUrl}}" />\n\n                            <div class="cm-resource-title">\n                                <h1 ng-class="{\'cm-no-gantt-label\': !resource[\'' + window.__crews.fields.ServiceResource.GanttLabel__c + '\'] }">{{resource.Name}}</h1>\n                                <h2>{{ resource[\'' + window.__crews.fields.ServiceResource.GanttLabel__c + '\'] }}</h2>\n                            </div>\n\n                            <svg aria-hidden="true" class="slds-icon cm-resource-icon-lightbox" ng-click="openResourceLightbox(resource.Name, resource.Id, $event)">\n                                \u2028<use xlink:href="' + window.__crews.icons.resource + '"></use>\n                            \u2028</svg>\n\n                        </div>\n\n\n                        <div class="cm-resource-details" ng-show="resource.listOpened" >\n\n                            <div>\n                                <b>' + window.__crews.labels.SkillsNekudotaim + '</b>\n                                <span ng-if="resource.ServiceResourceSkills" class="cm-skill-description">\n                                    {{ generateSkillsSentence(resource.ServiceResourceSkills) }}\n                                </span>\n\n                                <span ng-if="!resource.ServiceResourceSkills" class="cm-skill-description">\n                                    ' + window.__crews.labels.ResourceNoSkills + '\n                                </span>\n                            </div>\n\n                            <div ng-show="resource.Description">\n                                <b>' + window.__crews.labels.Description + ':</b>\n                                <span>' + window.__crews.labels.Description + '</span>\n                            </div>\n\n                            <div class="cm-membership-seperator" ng-show="!objectIsEmpty(resource.territoryMemberships)">\n                                <b>' + window.__crews.labels.ServiceTerritoryMembership + '</b>\n                                <div class="cm-memberships-container">\n                                    <div ng-repeat="(id,stm) in resource.territoryMemberships">\n                                        <span class="cm-member-subheader">{{stm.MemberNumber}}: </span>\n                                        <span class="cm-member-subparagraph">{{ formatStm(stm) }}</span>\n                                    </div>\n                                </div>\n                            </div>\n\n                            <div class="cm-membership-seperator" ng-show="!objectIsEmpty(resource.crewMemberships)">\n                                <b>' + window.__crews.labels.ServiceCrewMembership + '</b>\n\n                                <div class="cm-memberships-container">\n                                    <div class="hoverEffectScm" ng-repeat="(id,scm) in resource.crewMemberships" ng-click="showScmOnGantt(scm.id)">\n                                        <span class="cm-member-subheader">{{scm.ServiceCrewMemberNumber}}: </span>\n                                        <span class="cm-member-subparagraph">{{ formatScm(scm) }} ({{ getStmType(scm)}})</span>\n                                    </div>\n                                </div>\n                            </div>\n                            \n                        </div>\n\n                    </div>'
    };
}
'use strict';

(function () {

    ResourceFilter.$inject = ['DataService', 'UtilsService'];

    angular.module('Crews').filter('ResourceFilter', ResourceFilter);

    function ResourceFilter(DataService, UtilsService) {

        return function (territory, selectedFilterSkills, resourceSearch, logicOperator) {

            var resources = DataService.getResources(),
                filteredResources = [],
                filteredSkills = {},
                logicOperatorSkillsFunction = logicOperator === 'or' ? doesResourceHaveSomeSkills : doesResourceHaveAllSkills;

            // which skills are selected
            for (var id in selectedFilterSkills) {
                if (selectedFilterSkills[id]) {
                    filteredSkills[id] = true;
                }
            }

            for (var _id in territory.territoryMemberships) {

                var stm = territory.territoryMemberships[_id];

                if (!UtilsService.isIntersect(scheduler._min_date, scheduler._max_date, stm.ganttEffectiveStartDate, stm.ganttEffectiveEndDate)) {
                    continue;
                }

                var resource = resources[stm.ServiceResourceId];

                if (!resource || resource.IsCapacityBased || !resource.IsActive) {
                    continue;
                }

                if (!logicOperatorSkillsFunction(filteredSkills, resource)) {
                    continue;
                }

                if (resourceSearch && !resource.Name.toUpperCase().includes(resourceSearch.toUpperCase())) {
                    continue;
                }

                filteredResources.push(resource);
            }

            return filteredResources;
        };
    }

    function doesResourceHaveAllSkills(skills, resource) {

        if (Object.keys(skills).length > 0) {

            var resourceGotSkills = {};

            // create a map of the resource skills
            if (resource.ServiceResourceSkills) {
                resource.ServiceResourceSkills.forEach(function (skill) {
                    return resourceGotSkills[skill.SkillId] = skill;
                });
            }

            // go over checked skills
            for (var id in skills) {

                // resource doesn't have the skill, resource is filtered
                if (!resourceGotSkills[id]) {
                    return false;
                }
            }

            return true;
        }

        return true;
    }

    function doesResourceHaveSomeSkills(skills, resource) {

        if (Object.keys(skills).length > 0) {

            var resourceGotSkills = {};

            // create a map of the resource skills
            if (resource.ServiceResourceSkills) {
                resource.ServiceResourceSkills.forEach(function (skill) {
                    return resourceGotSkills[skill.SkillId] = skill;
                });
            }

            // go over checked skills
            for (var id in skills) {

                // resource doesn't have the skill, resource is filtered
                if (resourceGotSkills[id]) {
                    return true;
                }
            }

            return false;
        }

        return true;
    }
})();
'use strict';

function CrewManagementTerritory(ter, timezone) {

    for (var k in ter) {
        this[k] = ter[k];
    }

    // handle timezone label
    var timezoneDiffInHours = moment(scheduler._min_date).tz(timezone)._offset / 60,
        gmtSign = '';

    if (timezoneDiffInHours === 0) {
        gmtSign = '';
    }
    if (timezoneDiffInHours < 0) {
        gmtSign = '+';
    }
    if (timezoneDiffInHours > 0) {
        gmtSign = '-';
    }

    this.label = ter.Name + '<div class="cm-timezone-gantt">' + timezone + ' (GMT' + gmtSign + window.Math.abs(timezoneDiffInHours) + ')</div>';

    this.key = ter.Id;
    this.open = true;
    this.timezone = timezone;

    this.territoryMemberships = {};
}
'use strict';

(function () {

    scheduler.dhtmlXTooltip.config.className = 'cm-tooltip dhtmlXTooltip tooltip';
    scheduler.dhtmlXTooltip.config.timeout_to_display = 250;
    scheduler.dhtmlXTooltip.config.delta_x = 0;
    scheduler.dhtmlXTooltip.config.delta_y = 0;
    scheduler.config.minicalendar.mark_events = false;
    scheduler.config.limit_drag_out = false;
    scheduler.config.dblclick_create = false;
    scheduler.config.drag_create = false;
    scheduler.config.drag_resize = false;
    scheduler.config.drag_move = false;
    scheduler.config.mark_now = false;

    scheduler.createTimelineView({
        name: 'CrewsTimeline',
        x_unit: 'minute',
        x_date: '%g%A',
        x_step: 360,
        x_size: 20,
        x_start: 0,
        x_length: 4,
        y_unit: scheduler.serverList('resources', ''),
        y_property: 'resourceId',
        render: 'tree',
        dx: 170,
        second_scale: {
            x_unit: 'day',
            x_date: '%D, %M %j'
        },
        event_dy: 38,
        dy: 42,
        section_autoheight: false,
        folder_dy: 42,
        folder_events_available: false
    });

    scheduler.attachEvent("onSchedulerReady", function () {

        // don't let the user drag event out of the scheduler
        var cancelDragOutOfBound = false;

        // cancel drag outside of scheduler (invoke when mouse is out)
        dhtmlxEvent(scheduler._obj, 'mouseleave', function (e) {
            if (scheduler.getState().drag_id) {
                cancelDragOutOfBound = true;
                scheduler._on_mouse_up(e);
                window.getSelection().removeAllRanges();
            }
        });

        // cancel drag outside, move event back to its original
        scheduler.attachEvent('onBeforeEventChanged', function () {
            if (cancelDragOutOfBound) {
                cancelDragOutOfBound = false;
                return false;
            }

            return true;
        });
    });

    // set class for event
    scheduler.templates.event_class = function (start, end, ev) {

        var addedClasses = '';

        if (window.__currentCandidatesServiceId && ev.id !== window.__currentCandidatesServiceId) {
            addedClasses += 'cm-event-opacity ';
        }

        if (ev.type === 'scm') {

            if (ev.start_date.getTime() < scheduler._min_date.getTime() && ev.end_date.getTime() > scheduler._max_date.getTime()) {
                addedClasses += ' scm-container-both-not-ending ';
            } else if (ev.end_date.getTime() > scheduler._max_date.getTime()) {
                addedClasses += ' scm-container-right-not-ending ';
            } else if (ev.start_date.getTime() < scheduler._min_date.getTime()) {
                addedClasses += ' scm-container-left-not-ending ';
            }
        }

        if (ev.type === 'service') {
            return addedClasses + 'sa-on-gantt cm-sa-status-' + ev.StatusCategory;
        }

        if (ev.type === 'absence') {
            return addedClasses + 'absence-on-gantt';
        }

        if (ev.showEffect) {
            return addedClasses + 'scm-on-gantt cm-popup-scm';
        }

        return addedClasses + 'scm-on-gantt';
    };

    // classes for cells - draws background on level 0,1 and day separators on levle 2
    scheduler.templates.CrewsTimeline_cell_class = function (evs, date, section) {

        if (section.key.includes('_CREATE')) {
            return 'cm-gantt-drag-area';
        }

        if (section.level === 0) {
            return 'territory-on-gantt';
        }

        if (section.level === 1) {
            return 'crew-on-gantt';
        }

        // SA line
        if (section.key.split('_').length === 2) {

            if (section.level === 2 && date.getHours() === 0 && date.getTime() !== scheduler._min_date.getTime()) {
                return 'cm-BorderForDayChange cm-sa-separator-gantt-line';
            } else {
                return 'cm-sa-separator-gantt-line';
            }
        }

        if (section.level === 2 && date.getHours() === 0 && date.getTime() !== scheduler._min_date.getTime()) {
            return 'cm-BorderForDayChange';
        }
    };

    scheduler.templates.CrewsTimeline_scaley_class = function (key, label, section) {

        if (section.level === 0) {
            return 'territory-on-gantt';
        } else if (section.level === 1) {
            return 'crew-on-gantt';
        }

        return '';
    };

    scheduler.templates.event_bar_text = function (start, end, ev) {

        if (ev.type === 'service') {
            return drawServiceContent(ev);
        } else if (ev.type === 'absence') {
            return drawAbsenceContent(ev);
        } else {
            return drawScmContent(ev);
        }
    };

    // handle SCM drawing
    function drawScmContent(ev) {

        var content = '',
            darkerClass = '',
            moreClasses = '';

        if (ev.start_date.getTime() < scheduler._min_date.getTime()) {
            moreClasses += ' scm-continue-left ';
        }

        if (ev.end_date.getTime() > scheduler._max_date.getTime()) {
            moreClasses += ' scm-continue-right ';
        }

        if (!ev.ganttColor) {
            content = '<div class="cm-event-padding ' + moreClasses + '">';
        } else {
            content = '<div class="cm-event-padding ' + moreClasses + '" style="background-color: ' + ev.ganttColor + '90; border-color:' + ev.ganttColor + ';">';
            darkerClass = 'cm-makedark';
        }

        if (ev[window.__crews.fields.ServiceCrewMember.GanttLabel__c]) {
            content += '<span class="' + darkerClass + '" style="color:' + ev.ganttColor + '">' + ev[window.__crews.fields.ServiceCrewMember.GanttLabel__c] + '</span>';
        } else if (ev.ServiceCrewMemberNumber) {
            content += '<span class="' + darkerClass + '" style="color:' + ev.ganttColor + '">' + ev.ServiceCrewMemberNumber + '</span>';
        }

        if (ev.IsLeader) {
            content += '<span class="cm-is-leader-gantt">' + window.__crews.labels.Leader + '</span>';
        }

        content += '</div>';

        return content;
    }

    // handle absence drawing
    function drawAbsenceContent(ev) {
        return '';
    }

    // handle Service drawing
    function drawServiceContent(ev) {

        var content = '';

        if (ev[window.__crews.fields.ServiceAppointment.GanttColor__c]) {

            var textColor = generateGanttTextColor(ev[window.__crews.fields.ServiceAppointment.GanttColor__c].substr(1, 6));
            content = '<div class="cm-sa-padding" style="background-color: ' + ev[window.__crews.fields.ServiceAppointment.GanttColor__c] + '; color: ' + textColor + '">';
        } else {
            content = '<div class="cm-sa-padding">';
        }

        content += handleSaValidationUi(ev);

        if (ev[window.__crews.fields.ServiceAppointment.GanttLabel__c]) {
            content += ev[window.__crews.fields.ServiceAppointment.GanttLabel__c];
        } else {
            content += ev.AppointmentNumber;
        }

        content += '</div>';

        return content;
    }

    function handleSaValidationUi(ev) {

        var ui = '<div class="cm-validation"><svg aria-hidden="true" class="slds-icon">\u2028<use xlink:href="' + window.__crews.icons.warning + '"></use>\u2028</svg></div>';

        if (ev.availableMembersCount < ev.MinimumCrewSize || ev.totalMissingSkills > 0) {
            return ui;
        }

        return '';
    }

    function generateGanttTextColor(color) {

        var midColor = parseInt('0x888888', 16),
            newColor = parseInt('0x' + color, 16);

        if (midColor < newColor) return '#000000';else return '#ffffff';
    }

    scheduler.templates.tooltip_text = function (start, end, ev) {

        if (ev.type === 'service') {
            return generateServiceTooltip(ev);
        }

        if (ev.type === 'absence') {
            return generateAbsenceTooltip(ev);
        }

        return generateScmTooltip(ev);
    };

    function generateServiceTooltip(ev) {

        var tooltipContent = '<div class="cm-tooltip-wrapper">\n                                <h1>' + ev.AppointmentNumber + '</h1>\n                                <div class="cm-tooltip-crewsize">\n                                    <div class="cm-tooltip-crewsize-single">\n                                        <div class="cm-tooltip-size-label">' + window.__crews.labels.MinimumSize + '</div>\n                                        <div class="cm-tooltip-size-value">' + ev.MinimumCrewSize + '</div>\n                                    </div>\n                                    \n                                    <div class="cm-tooltip-crewsize-single">\n                                        <div class="cm-tooltip-size-label">' + window.__crews.labels.RecommendedSize + '</div>\n                                        <div class="cm-tooltip-size-value">' + ev.RecommendedCrewSize + '</div>\n                                    </div>\n                                    \n                                    <div class="cm-tooltip-crewsize-single">\n                                        <div class="cm-tooltip-size-label">' + window.__crews.labels.CurrentlyAssigned + '</div>\n                                        <div class="cm-tooltip-size-value">' + ev.availableMembersCount + '</div>\n                                    </div>                                \n                                </div>\n                                <div class="cm-tooltip-label"><b>' + window.__crews.labels.RequiredSkillsCm + ' </b>';

        var skills = [];

        if (ev.requiredSkills) {

            ev.requiredSkills.forEach(function (skill) {

                var skillStr = skill.Skill.MasterLabel;

                if (skill.SkillLevel) {
                    skillStr = '' + window.__crews.labels.SkillAndLevel.replace('{0}', skillStr).replace('{1}', skill.SkillLevel);
                }

                skills.push(skillStr);
            });
        }

        if (skills.length !== 0) {
            tooltipContent += skills.join(', ') + '</div>';
        } else {
            tooltipContent += window.__crews.labels.ServiceNoReqSkills + '</div>';
        }

        for (var apiName in window.__crews.saTooltipFieldset) {

            if (ev[apiName] !== undefined) {
                var value = generateFieldToDisplay(ev[apiName], window.__crews.saTooltipFieldset[apiName].type, ev.timezone);

                if (value) {
                    tooltipContent += '<div class="cm-tooltip-label"><b>' + window.__crews.saTooltipFieldset[apiName].label + ': </b> ' + value + '</div>';
                }
            }
        }

        tooltipContent += '</div>'; // end of cm-tooltip-wrapper

        tooltipContent += generateServiceValidationTooltip(ev);

        return tooltipContent;
    }

    function generateFieldToDisplay(value, fieldType, timezone) {

        switch (fieldType) {

            case 'PICKLIST':
            case 'INTEGER':
            case 'DOUBLE':
            case 'STRING':
            case 'TEXTAREA':
                return value.toString();

            case 'BOOLEAN':
                return value.toString();

            case 'DATE':
                return moment(value).tz(timezone).format('LL');

            case 'DATETIME':
                return moment(value).tz(timezone).format('LLLL');

            default:
                return null;

        }
    }

    function generateServiceValidationTooltip(ev) {

        var ui = '<div class="cm-tooltip-validation"><ul>',
            foundErrors = false;

        if (ev.availableMembersCount < ev.MinimumCrewSize) {
            var membersDiff = ev.MinimumCrewSize - ev.availableMembersCount;
            ui += '<li><span>' + window.__crews.labels.NotEnoughAvailableMembers.replace('{0}', membersDiff).replace('{1}', ev.MinimumCrewSize) + '</span></li>';

            foundErrors = true;
        }

        if (ev.totalMissingSkills > 0) {

            var missingSkills = [];
            foundErrors = true;

            ev.missingSkills.forEach(function (s) {

                if (s.missing) {

                    if (s.SkillLevel) {
                        missingSkills.push(' ' + window.__crews.labels.SkillAndLevel.replace('{0}', s.Skill.MasterLabel).replace('{1}', s.SkillLevel));
                    } else {
                        missingSkills.push(' ' + s.Skill.MasterLabel);
                    }
                }
            });

            ui += '<li><span>' + window.__crews.labels.MissingSkillsAre.replace('{0}', missingSkills.join(', ')) + '</span></li>';
        }

        if (!foundErrors) {
            return '';
        } else {
            return ui + '</ul></div>';
        }
    }

    function generateScmTooltip(ev) {

        var tooltipContent = '<div class="cm-tooltip-wrapper">',
            startValue = ev.StartDate ? moment(ev.start_date).format('llll') : window.__crews.labels.NotDefined,
            endValue = ev.EndDate ? moment(ev.end_date).format('llll') : window.__crews.labels.NotDefined;

        tooltipContent += '<h1>' + ev.ServiceCrewMemberNumber + '</h1>';
        tooltipContent += '<div class="cm-tooltip-label"><b>' + window.__crews.labels.EventStart + '</b> ' + startValue + '</div>';
        tooltipContent += '<div class="cm-tooltip-label"><b>' + window.__crews.labels.EventEnd + '</b> ' + endValue + '</div>';

        return tooltipContent + '</div>';
    }

    function generateAbsenceTooltip(ev) {

        var tooltipContent = '<div class="cm-tooltip-wrapper">';

        tooltipContent += '<h1>' + ev.AbsenceNumber + '</h1>';
        tooltipContent += '<div class="cm-tooltip-label"><b>' + window.__crews.labels.EventType + '</b> ' + ev.TypeLabel + '</div>';
        tooltipContent += '<div class="cm-tooltip-label"><b>' + window.__crews.labels.EventStart + '</b> ' + moment(ev.start_date).format('llll') + '</div>';
        tooltipContent += '<div class="cm-tooltip-label"><b>' + window.__crews.labels.EventEnd + '</b> ' + moment(ev.end_date).format('llll') + '</div>';

        return tooltipContent + '</div>';
    }

    // format number in localeString
    function formatNumberToLocaleString(n) {
        try {
            return n.toLocaleString(window.__crews.jsUserLocale);
        } catch (e) {
            console.warn('Something wrong with your locale settings: ' + window.__crews.jsUserLocale);
        }

        return n;
    }

    function formatDateByLocaleWithDayOfTheWeek(jsDate) {
        var res = formatDateWithDayOfWeek(jsDate);

        if (res) {
            return res;
        }

        var localesToUseWithDayOfTheWeek = ['en_US'];

        if (localesToUseWithDayOfTheWeek.indexOf(window.__crews.userLocale) !== -1) {
            return moment(jsDate).format('ddd, MMM D YYYY');
        } else {
            return moment(jsDate).format('LL');
        }
    }

    function formatDateWithDayOfWeek(date) {
        var options = { weekday: 'short', month: 'long', day: 'numeric', year: 'numeric' },
            newDate = new Date(date);

        newDate.setHours(12);

        try {
            return newDate.toLocaleDateString(window.__crews.userLocale.replace('_', '-'), options);
        } catch (e) {
            return null;
        }
    }

    scheduler.templates.CrewsTimeline_scale_date = function (date) {

        var hours = date.getHours(),
            minutes = date.getMinutes() < 10 ? formatNumberToLocaleString(0) + formatNumberToLocaleString(date.getMinutes()) : formatNumberToLocaleString(date.getMinutes());

        // for 2 weeks view
        if (scheduler.matrix.CrewsTimeline.x_step === 1440) {
            return date.getDate();
        }

        if (!window.__crews.isAMPM) {
            return (date.getHours() < 10 ? formatNumberToLocaleString(0) + formatNumberToLocaleString(date.getHours()) : formatNumberToLocaleString(date.getHours())) + ':' + minutes;
        } else {
            if (hours === 0) {
                return formatNumberToLocaleString(12) + ' AM';
            }

            if (hours === 12) {
                return formatNumberToLocaleString(12) + ' PM';
            }

            if (hours > 12) {
                return formatNumberToLocaleString(hours - 12) + ' PM';
            } else {
                return formatNumberToLocaleString(hours) + ' AM';
            }
        }
    };

    scheduler.templates.CrewsTimeline_second_scale_date = function (date) {

        if (scheduler.matrix.CrewsTimeline.x_step === 1440) {
            return moment(date).format('ddd');
        }

        return formatDateByLocaleWithDayOfTheWeek(date);
    };

    scheduler.templates.CrewsTimeline_date = function (start, end) {

        var endDate = new Date(end);
        endDate.setDate(endDate.getDate() - 1);

        if (end.getTime() - start.getTime() === 86400000) {
            return formatDateByLocaleWithDayOfTheWeek(start);
        }

        return formatDateByLocaleWithDayOfTheWeek(start) + ' - ' + formatDateByLocaleWithDayOfTheWeek(endDate);
    };
})();
'use strict';

DataService.$inject = ['$q', 'RemoteActionsService', 'UtilsService'];

angular.module('Crews').factory('DataService', DataService);

function DataService($q, RemoteActionsService, UtilsService) {

    var resources = {},
        crews = {},
        serviceCrews = {},
        territories = {},
        allTerritories = {},
        skills = {},
        territoryMemberships = {},
        crewMemberships = {},
        operatingHours = {},
        gotResources = $q.defer(),
        visitedDays = {},
        services = {},
        selectedResourcesOnList = {},
        firstLoad = true;

    window.saTooltipFieldset = {};

    // init
    function init() {

        var def = $q.defer(),
            skillsDefer = null;

        // reset everything (but skills)
        resources = {};
        crews = {};
        territories = {};
        allTerritories = {};
        territoryMemberships = {};
        crewMemberships = {};
        operatingHours = {};
        visitedDays = {};
        serviceCrews = {};
        services = {};

        if (firstLoad) {
            skillsDefer = getSkills();
            getServiceAppointmentFieldset();
        }

        getResourcesAndTerritories().then(function () {

            // defer after skill done loading (territory changed)
            if (firstLoad) {
                skillsDefer.then(function () {
                    def.resolve();
                    gotResources.resolve();
                });
            }

            def.resolve();
            gotResources.resolve();
        });

        firstLoad = false;

        return def.promise;
    }

    init();

    // get resource and territories
    function getResourcesAndTerritories() {

        // get items from local storage
        var localStorageTerritories = localStorage.getItem('territories');

        if (localStorageTerritories) {
            localStorageTerritories = localStorageTerritories.split(',');
        }

        return RemoteActionsService.callRemoteAction('GetResourcesAndTerritories', localStorageTerritories || []).then(function (data) {

            // parse operating hours
            data.operatingHours.forEach(function (oh) {
                return operatingHours[oh.Id] = oh;
            });

            // parse territories
            data.territories.forEach(function (t) {

                // territory must be active
                if (t.IsActive) {
                    territories[t.Id] = new CrewManagementTerritory(t, operatingHours[t.OperatingHoursId].TimeZone);
                }

                allTerritories[t.Id] = new CrewManagementTerritory(t, operatingHours[t.OperatingHoursId].TimeZone);
            });

            // parse resources
            data.resources.forEach(function (r) {

                // not capacity based and active resources only
                if (!r.IsCapacityBased && r.IsActive) {

                    // put to crews or resources object
                    var destMap = r.ResourceType === 'C' ? crews : resources;

                    destMap[r.Id] = r;
                    destMap[r.Id].resourceId = r.Id;
                    destMap[r.Id].label = UtilsService.generateResourceGanttLabel(r, skills, r.ResourceType === 'C');
                    destMap[r.Id].crewMemberships = {};
                    destMap[r.Id].territoryMemberships = {};

                    if (r.ResourceType === 'C') {
                        serviceCrews[r.ServiceCrewId] = r.ServiceCrew;
                    }
                }
            });
        }).catch(function (err) {
            console.warn('!!!MAJOR FAILURE!!! --- GetResourcesAndTerritories --- !!!MAJOR FAILURE!!!');
            console.error(err);
        });
    }

    // get gantt data - resolving parsed SCMs
    function getGanttData(requestedStartDate, requestedEndDate) {

        var deferred = $q.defer(),
            dataAlreadyAvailable = true;

        requestedStartDate = requestedStartDate || scheduler._min_date || new Date();
        requestedEndDate = requestedEndDate || scheduler._max_date || new Date();

        for (var newDate = new Date(requestedStartDate); newDate <= requestedEndDate; newDate.setDate(newDate.getDate() + 1)) {

            var key = UtilsService.generateDateKey(newDate);

            // one of the dates is not available locally, bring all
            if (!visitedDays[key]) {
                dataAlreadyAvailable = false;
                break;
            }
        }

        if (dataAlreadyAvailable) {
            deferred.resolve([]);
            return deferred.promise;
        }

        // get items from local storage
        var localStorageTerritories = localStorage.getItem('territories');

        if (localStorageTerritories) {
            localStorageTerritories = localStorageTerritories.split(',');
        }

        RemoteActionsService.callRemoteAction('getGanttData', requestedStartDate, requestedEndDate, localStorageTerritories || []).then(function (data) {

            // mark visited days for caching
            for (var _newDate = new Date(requestedStartDate); _newDate <= requestedEndDate; _newDate.setDate(_newDate.getDate() + 1)) {
                var _key = UtilsService.generateDateKey(_newDate);
                visitedDays[_key] = true;
            }

            var ganttEvents = [];

            // save stms and add territory memberships to resources AND territories
            data.stms.forEach(processStm);

            // save scms and add crew memberships to resources
            data.scms.forEach(function (scm) {

                var newScms = processScm(scm);

                if (newScms.length > 0) {
                    ganttEvents = ganttEvents.concat(newScms);
                }
            });

            // save scms and add crew memberships to resources
            data.services.forEach(function (service) {

                var newServices = processService(service, data.requiredServiceSkills, data.parents);

                if (newServices.length > 0) {
                    ganttEvents = ganttEvents.concat(newServices);
                }
            });

            // save scms and add crew memberships to resources
            data.absences.forEach(function (absence) {

                var newAbsences = processAbsence(absence);

                if (newAbsences.length > 0) {
                    ganttEvents = ganttEvents.concat(newAbsences);
                }
            });

            deferred.resolve(ganttEvents);
        }).catch(function (err) {
            console.warn('!!!MAJOR FAILURE!!! --- getGanttData --- !!!MAJOR FAILURE!!!');
            console.error(err);
            deferred.reject(err);
        });

        return deferred.promise;
    }

    function processService(service, requiredServiceSkills, parents) {

        var resourceId = service.ServiceResources[0].ServiceResourceId,
            crewId = service.ServiceResources[0].ServiceCrewId,
            crew = crews[resourceId],
            ganttEvents = [];

        if (!crew) {
            return [];
        }

        for (var id in crew.territoryMemberships) {

            var copiedService = {},
                stm = crew.territoryMemberships[id];

            angular.copy(service, copiedService);

            // handle timezone n'stuff
            var startTimezoeOffset = UtilsService.getLocalDateOffsetOffset(service.SchedStartTime),
                endTimezoeOffset = UtilsService.getLocalDateOffsetOffset(service.SchedEndTime);

            copiedService.momentSchedStartTime = moment(copiedService.SchedStartTime + startTimezoeOffset).tz(stm.timezone);
            copiedService.momentSchedEndTime = moment(copiedService.SchedEndTime + endTimezoeOffset).tz(stm.timezone);

            copiedService.start_date = copiedService.momentSchedStartTime._d.getTime();
            copiedService.end_date = copiedService.momentSchedEndTime._d.getTime();

            // REMINDER: service id is ServiceCrewId_TerritoryId
            copiedService.resourceId = crewId + '_' + stm.ServiceTerritoryId;

            copiedService.text = copiedService.AppointmentNumber;
            copiedService.id = copiedService.Id + '_' + stm.ServiceTerritoryId;
            copiedService.territoryOnGantt = stm.ServiceTerritoryId;
            copiedService.crewOnGantt = crewId;
            copiedService.type = 'service';
            copiedService.readonly = true;
            copiedService.requiredSkills = requiredServiceSkills[copiedService.ParentRecordId] || [];
            copiedService.MinimumCrewSize = parents[copiedService.ParentRecordId].MinimumCrewSize || '-';
            copiedService.RecommendedCrewSize = parents[copiedService.ParentRecordId].RecommendedCrewSize || window.__crews.labels.CrewSizeUndefined;
            copiedService.timezone = stm.timezone;

            ganttEvents.push(copiedService);
        }

        return ganttEvents;
    }

    function processAbsence(absence) {

        absence.type = 'absence';

        var resource = resources[absence.ResourceId],
            ganttEvents = [],
            resourceTypeIsCrew = false;

        // resource type is crew
        if (!resource && crews[absence.ResourceId]) {
            resource = crews[absence.ResourceId];
            resourceTypeIsCrew = true;
        }

        // if resource has an STM, we need to add the absence
        if (resource && resource.territoryMemberships) {

            for (var key in crews) {

                // CFSL-363
                if (resourceTypeIsCrew && key !== resource.Id) {
                    continue;
                }

                for (var id in resource.territoryMemberships) {

                    var stm = resource.territoryMemberships[id];

                    // no support for secondary
                    // if (stm.TerritoryType === 'S') {
                    //     continue;
                    // }

                    var ganttAbsence = angular.copy(absence);

                    ganttAbsence.id = ganttAbsence.Id + '_' + stm.ServiceTerritoryId + '_' + crews[key].ServiceCrewId;
                    ganttAbsence.territoryId = stm.ServiceTerritoryId;

                    // RESOURCE ID on gantt is combination of RESOURCE, STM and CREW IDs
                    if (resourceTypeIsCrew) {
                        ganttAbsence.resourceId = crews[key].ServiceCrewId + '_' + stm.ServiceTerritoryId;
                    } else {
                        ganttAbsence.resourceId = ganttAbsence.ResourceId + '_' + stm.Id + '_' + crews[key].ServiceCrewId;
                    }

                    ganttAbsence.stmId = stm.Id;
                    ganttAbsence.readonly = true;

                    ganttAbsence.text = ganttAbsence.ServiceCrewMemberNumber;

                    // remove local time diffrence
                    var startTimezoeOffset = ganttAbsence.Start ? UtilsService.getLocalDateOffsetOffset(ganttAbsence.Start) : 0,
                        endTimezoeOffset = ganttAbsence.End ? UtilsService.getLocalDateOffsetOffset(ganttAbsence.End) : 0;

                    ganttAbsence.momentStart = moment(ganttAbsence.Start + startTimezoeOffset).tz(stm.timezone);
                    ganttAbsence.momentEnd = moment(ganttAbsence.End + endTimezoeOffset).tz(stm.timezone);

                    ganttAbsence.start_date = ganttAbsence.momentStart._d.getTime();
                    ganttAbsence.end_date = ganttAbsence.momentEnd._d.getTime();

                    // save na on resource
                    resource.absences = resource.absences || {};
                    resource.absences[ganttAbsence.Id] = ganttAbsence;

                    ganttEvents.push(ganttAbsence);
                    resource.absences = resource.absences || {};
                    resource.absences[ganttAbsence.id] = ganttAbsence;
                }
            }
        }

        return ganttEvents;
    }

    function processStm(stm) {

        UtilsService.parseStm(stm, territories, operatingHours);
        territoryMemberships[stm.Id] = stm;

        if (resources[stm.ServiceResourceId]) {
            resources[stm.ServiceResourceId].territoryMemberships[stm.Id] = stm;
        }

        if (crews[stm.ServiceResourceId]) {
            crews[stm.ServiceResourceId].territoryMemberships[stm.Id] = stm;
        }

        if (territories[stm.ServiceTerritoryId]) {
            territories[stm.ServiceTerritoryId].territoryMemberships[stm.Id] = stm;
        }
    }

    function processScm(scm) {

        scm.type = 'scm';
        crewMemberships[scm.Id] = scm;

        var resource = resources[scm.ServiceResourceId],
            ganttEvents = [];

        // if resource has an STM, we need to add the SCM
        if (resource && resource.territoryMemberships) {

            for (var id in resource.territoryMemberships) {

                var stm = resource.territoryMemberships[id];

                // no support for secondary
                // if (stm.TerritoryType === 'S') {
                //     continue;
                // }

                var ganttScm = angular.copy(scm);

                // SCM ID on gantt is combination of SCM and TERRITORY IDs
                ganttScm.id = ganttScm.Id + '_' + stm.ServiceTerritoryId;

                ganttScm.territoryId = stm.ServiceTerritoryId;

                // RESOURCE ID on gantt is combination of RESOURCE, STM and CREW IDs
                ganttScm.resourceId = ganttScm.ServiceResourceId + '_' + stm.Id + '_' + scm.ServiceCrewId;

                ganttScm.ganttColor = serviceCrews[scm.ServiceCrewId] && serviceCrews[scm.ServiceCrewId][window.__crews.fields.ServiceCrew.GanttColor__c] || null;

                ganttScm.stmId = stm.Id;
                ganttScm.stmType = stm.TerritoryType;

                ganttScm.text = ganttScm.ServiceCrewMemberNumber;

                // remove local time diffrence
                var startTimezoeOffset = ganttScm.StartDate ? UtilsService.getLocalDateOffsetOffset(ganttScm.StartDate) : 0,
                    endTimezoeOffset = ganttScm.EndDate ? UtilsService.getLocalDateOffsetOffset(ganttScm.EndDate) : 0;

                ganttScm.momentStartDate = ganttScm.StartDate ? moment(ganttScm.StartDate + startTimezoeOffset).tz(stm.timezone) : moment('1,1,2015').tz(stm.timezone);
                ganttScm.momentEndDate = ganttScm.EndDate ? moment(ganttScm.EndDate + endTimezoeOffset).tz(stm.timezone) : moment('1,1,2040').tz(stm.timezone);

                ganttScm.start_date = ganttScm.momentStartDate._d.getTime();
                ganttScm.end_date = ganttScm.momentEndDate._d.getTime();

                ganttEvents.push(ganttScm);
                resource.crewMemberships[ganttScm.id] = ganttScm;
            }
        }

        return ganttEvents;
    }

    // get all skills
    function getSkills() {

        return RemoteActionsService.callRemoteAction('getSkills').then(function (data) {
            data.forEach(function (d) {
                return skills[d.Id] = d.MasterLabel;
            });
        }).catch(function (err) {
            console.warn('!!!MAJOR FAILURE!!! --- getSkills --- !!!MAJOR FAILURE!!!');
            console.error(err);
        });
    }

    // get SA tooltip fieldset
    function getServiceAppointmentFieldset() {

        return RemoteActionsService.callRemoteAction('getServiceAppointmentTooltipFieldset').then(function (data) {

            for (var api in data) {

                window.__crews.saTooltipFieldset[api] = {
                    label: data[api][0],
                    type: data[api][1],
                    api: data[api][2]
                };
            }
        }).catch(function (err) {
            console.warn('!!!MAJOR FAILURE!!! --- getServiceAppointmentFieldset --- !!!MAJOR FAILURE!!!');
            console.error(err);
        });
    }

    // save changes to SCM
    function saveChangesToStm(scmId, resourceId, crewId, strStartDate, strEndDate, isLeader) {

        var deferred = $q.defer();

        RemoteActionsService.callRemoteAction('saveChangesToScm', scmId, resourceId, crewId, strStartDate, strEndDate, isLeader).then(function (data) {
            deferred.resolve(processScm(data));
        }).catch(function (err) {
            console.warn('!!!MAJOR FAILURE!!! --- saveChangesToScm --- !!!MAJOR FAILURE!!!');
            console.error(err);
            //UtilsService.addError(err);
            deferred.reject(err);
        });

        return deferred.promise;
    }

    // save multiple SCMs (only new)
    function saveMultipleScms(resourceIds, crewId, strStartDate, strEndDate, isLeader) {

        var deferred = $q.defer();

        RemoteActionsService.callRemoteAction('saveMultipleScms', resourceIds, crewId, strStartDate, strEndDate, isLeader).then(function (data) {

            var ganttEvents = [];
            data.forEach(function (scm) {

                var scms = processScm(scm);

                if (scms.length > 0) {
                    ganttEvents = ganttEvents.concat(scms);
                }
            });
            deferred.resolve(ganttEvents);
        }).catch(function (err) {
            console.warn('!!!MAJOR FAILURE!!! --- saveMultipleScms --- !!!MAJOR FAILURE!!!');
            console.error(err);
            //UtilsService.addError(err);
            deferred.reject(err);
        });

        return deferred.promise;
    }

    // delete SCM
    function deleteScm(scm) {

        var deferred = $q.defer();

        RemoteActionsService.callRemoteAction('deleteScm', scm.Id).then(function (data) {

            // deleting all SCM references
            delete crewMemberships[scm.Id];

            var crewMembershipsOnResource = resources[scm.ServiceResourceId].crewMemberships;

            var idsToDelete = [];
            for (var id in crewMembershipsOnResource) {
                if (id.includes(scm.Id)) {
                    idsToDelete.push(id);
                }
            }

            idsToDelete.forEach(function (id) {
                return delete crewMembershipsOnResource[id];
            });

            idsToDelete = [];
            for (var _id in scheduler._events) {
                if (_id.includes(scm.Id)) {
                    idsToDelete.push(_id);
                }
            }

            idsToDelete.forEach(function (id) {
                return delete scheduler._events[id];
            });

            deferred.resolve();
        }).catch(function (err) {
            console.warn('!!!MAJOR FAILURE!!! --- deleteScm --- !!!MAJOR FAILURE!!!');
            console.error(err);
            deferred.reject(err);
        });

        return deferred.promise;
    }

    function getCrewResource(resourceId) {

        for (var id in crews) {

            if (crews[id].ServiceCrewId === resourceId) {
                return crews[id];
            }
        }

        return null;
    }

    function validateAllServicesInView() {

        for (var eventId in scheduler._events) {

            var service = scheduler._events[eventId];

            // not in view or not a service, not interesting
            if (service.type !== 'service' || !UtilsService.isIntersect(service.start_date, service.end_date, scheduler._min_date, scheduler._max_date)) {
                continue;
            }

            if (service.type === 'service') {
                initMissingSkills(service);
            }

            service.availableMembersCount = 0;

            for (var id in scheduler._events) {

                var scm = scheduler._events[id];

                if (scm.type !== 'scm') {
                    continue;
                }

                // service INSIDE scm (timeframes), same crew and same territory
                if (scm.start_date <= service.start_date && service.end_date <= scm.end_date && scm.ServiceCrewId === service.crewOnGantt && scm.territoryId === service.territoryOnGantt) {

                    service.availableMembersCount++;

                    // check skills
                    checkSkillMatching(service, scm.ServiceResourceId);
                }
            }
        }

        scheduler.updateView();
    }

    function initMissingSkills(service) {
        service.missingSkills = angular.copy(service.requiredSkills);
        service.missingSkills.forEach(function (skill) {
            return skill.missing = true;
        });
        service.totalMissingSkills = service.missingSkills.length;
    }

    function checkSkillMatching(service, resourceId) {

        var resource = resources[resourceId];

        resource && resource.ServiceResourceSkills && resource.ServiceResourceSkills.forEach(function (resourceSkill) {

            for (var i = 0; i < service.missingSkills.length; i++) {

                if (resourceSkill.SkillId === service.missingSkills[i].SkillId) {

                    var resourceSkillLevel = resourceSkill.SkillLevel || 1,
                        serviceSkillLevel = service.missingSkills[i].SkillLevel || 1;

                    if (serviceSkillLevel <= resourceSkillLevel) {
                        service.missingSkills[i].missing = false;
                        service.totalMissingSkills--;
                    }
                }
            }
        });
    }

    function getLoadedTerritories() {

        var loadedTerritories = {};

        // get items from local storage
        var localStorageTerritories = localStorage.getItem('territories');

        if (localStorageTerritories) {
            localStorageTerritories = localStorageTerritories.split(',');
            localStorageTerritories.forEach(function (id) {
                return loadedTerritories[id] = territories[id];
            });
        }

        return loadedTerritories;
    }

    return {
        init: init,
        getGanttData: getGanttData,
        getResources: function getResources() {
            return resources;
        },
        getTerritories: function getTerritories() {
            return territories;
        },
        getAllTerritories: function getAllTerritories() {
            return allTerritories;
        },
        getSkills: function getSkills() {
            return skills;
        },
        getTerritoryMemberships: function getTerritoryMemberships() {
            return territoryMemberships;
        },
        getCrewMemberships: function getCrewMemberships() {
            return crewMemberships;
        },
        getResourcesPromise: function getResourcesPromise() {
            return gotResources;
        },
        getOperatingHours: function getOperatingHours() {
            return operatingHours;
        },
        getCrews: function getCrews() {
            return crews;
        },
        getServices: function getServices() {
            return services;
        },
        getSelectedResourcesOnList: function getSelectedResourcesOnList() {
            return selectedResourcesOnList;
        },
        saveChangesToStm: saveChangesToStm,
        saveMultipleScms: saveMultipleScms,
        deleteScm: deleteScm,
        getCrewResource: getCrewResource,
        validateAllServicesInView: validateAllServicesInView,
        getLoadedTerritories: getLoadedTerritories
    };
}
'use strict';

GeneralLightbox.$inject = ['$rootScope', '$sce', '$compile', 'UtilsService'];

angular.module('Crews').factory('GeneralLightbox', GeneralLightbox);

function GeneralLightbox($rootScope, $sce, $compile, UtilsService) {

    // create a new scope
    var $scope = null;

    function open(title, urlOrTabs) {
        var extendedId = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;


        if ($scope) {
            return;
        }

        // create new isolated scope
        $scope = $rootScope.$new(true);

        // page urls
        if (window.Array.isArray(urlOrTabs)) {

            $scope.tabs = urlOrTabs;
            urlOrTabs.forEach(function (tab) {
                tab.url = $sce.trustAsResourceUrl(tab.url).toString();
            });

            $scope.activeTabIndex = 0;
        } else {

            // no tabs, just one view
            $scope.url = $sce.trustAsResourceUrl(urlOrTabs).toString();
        }

        $scope.title = title;
        $scope.extendedId = extendedId;

        $scope.closeLightbox = closeLightbox;
        $scope.openConsoleTab = UtilsService.openConsoleTab;

        $scope.changeActiveTab = function (i) {
            return $scope.activeTabIndex = i;
        };

        // add to body
        var lightboxDomElement = generateTemplate();
        angular.element('body').append(lightboxDomElement);

        // on destroy, remove DOM elements
        $scope.$on('$destroy', function () {
            return lightboxDomElement.remove();
        });

        // compile
        $compile(lightboxDomElement)($scope);

        safeApply($scope);
    }

    // esc - close lightbox
    document.addEventListener('keyup', function (e) {

        if ($scope && e.which === 27) {
            $scope.$evalAsync($scope.closeLightbox);
        }
    });

    function closeLightbox() {
        $scope.$destroy();
        $scope = null;
    }

    function safeApply(scope, fn) {

        var phase = scope.$root.$$phase;

        if (phase === '$apply' || phase === '$digest') {
            if (fn && typeof fn === 'function') {
                fn();
            }
        } else {
            scope.$apply(fn);
        }
    }

    function generateTemplate() {

        return angular.element('\n                <div class="LightboxBlackContainer">\n                    <div class="LightboxContainer">\n\n                        <div class="lightboxHeaderContainer">\n                            <svg aria-hidden="true" class="slds-icon CloseLightbox" ng-click="closeLightbox()">\n                                \u2028<use xlink:href="' + window.__crews.icons.close + '"></use>\n                            \u2028</svg>\n                            <h1 class="light-box-header" ng-bind="title"></h1>\n                            \n                            <span ng-if="tabs" class="cm-lb-tab" ng-class="{\'cm-lb-active-tab\': activeTabIndex === $index}" ng-click="changeActiveTab($index)" ng-repeat="tab in tabs">\n                                {{ tab.name }}\n                            </span>\n                            \n                            <a class="cm-layout-link" ng-show="extendedId" ng-click="openConsoleTab($event, extendedId)" target="_blank" href="../{{ extendedId }}" title="' + window.__crews.labels.OpenInLayout + '">\n                                <svg aria-hidden="true" class="slds-icon">\n                                    \u2028<use xlink:href="' + window.__crews.icons.external + '"></use>\n                                \u2028</svg>\n                            </a>\n                            \n                        </div>\n\n                        <div class="lightboxContent">\n                            \n                            <iframe  ng-if="!tabs" ng-src="{{ url }}" class="resourceLightboxIframe"></iframe>\n                            \n                            <iframe  ng-if="tabs" ng-show="activeTabIndex === $index" ng-repeat="tab in tabs" ng-src="{{ tab.url }}" class="resourceLightboxIframe"></iframe>\n                            \n                        </div>\n\n\n                    </div>\n                </div>');
    }

    // This will be our factory
    return {
        open: open
    };
}
'use strict';

GetCrewCandidates.$inject = ['$rootScope', '$compile', 'UtilsService', 'DataService', 'GeneralLightbox'];

angular.module('Crews').factory('GetCrewCandidates', GetCrewCandidates);

function GetCrewCandidates($rootScope, $compile, UtilsService, DataService, GeneralLightbox) {

    // create a new scope
    var $scope = null;

    function get(service) {

        if ($scope) {
            closeGetCandidates();
        }

        window.__currentCandidatesServiceId = service.id;

        // create new isolated scope
        $scope = $rootScope.$new(true);

        $scope.service = service;
        $scope.closeGetCandidates = closeGetCandidates;
        $scope.currentAssignedResources = getCurrentAssignedResources();
        $scope.getRelevantResources = getRelevantResources();
        $scope.openResourceLightbox = openResourceLightbox;
        $scope.openServiceLightbox = openServiceLightbox;
        $scope.getMissingSkillsForCandidate = getMissingSkillsForCandidate;
        $scope.getSelectedResourcesOnList = DataService.getSelectedResourcesOnList;
        $scope.getSelectedResources = getSelectedResources;
        $scope.assignSelected = assignSelected;
        $scope.saving = false;

        $scope.isEmpty = function (obj) {
            return Object.keys(obj).length === 0;
        };

        // unselect all resources
        var selectedResources = DataService.getSelectedResourcesOnList();
        for (var key in selectedResources) {
            selectedResources[key] = false;
        }

        $scope.$on('updateCandidates', function () {
            $scope.currentAssignedResources = getCurrentAssignedResources();
            $scope.getRelevantResources = getRelevantResources();
        });

        $scope.getMissingSkills = function () {
            return $scope.service.missingSkills.filter(function (skill) {
                return skill.missing;
            });
        };

        $scope.generateSkillsSentence = function (resourceSkills) {
            return UtilsService.generateSkillsSentence(resourceSkills, DataService.getSkills());
        };

        // add to body
        var getCandidatesDOMElement = generateTemplate();
        angular.element('#ResourceFiltersContainer').append(getCandidatesDOMElement);

        // on destroy, remove DOM elements
        $scope.$on('$destroy', function () {
            return getCandidatesDOMElement.remove();
        });

        // compile
        $compile(getCandidatesDOMElement)($scope);

        UtilsService.safeApply($scope);
        scheduler.updateView();
    }

    function closeGetCandidates() {

        // unselect all resources
        var selectedResources = DataService.getSelectedResourcesOnList();
        for (var key in selectedResources) {
            selectedResources[key] = false;
        }

        window.__currentCandidatesServiceId = null;
        $scope.$destroy();
        $scope = null;
        scheduler.updateView();
    }

    function openServiceLightbox() {

        var tabs = [{ name: window.__crews.labels.Details, url: window.__crews.pages.service + '?id=' + $scope.service.Id }];

        if ($scope.service.ParentRecordType === 'WorkOrder') {
            tabs.push({ name: window.__crews.labels.WorkOrder, url: window.__crews.pages.workorder + '?id=' + $scope.service.ParentRecordId });
        } else {
            tabs.push({ name: window.__crews.labels.WOLI, url: window.__crews.pages.woli + '?id=' + $scope.service.ParentRecordId });
        }

        GeneralLightbox.open($scope.service.AppointmentNumber, tabs, $scope.service.Id);
    }

    function openResourceLightbox(name, id, ev) {
        ev.stopPropagation();
        GeneralLightbox.open(name, window.__crews.pages.resource + '?id=' + id, id);
    }

    function getSelectedResources() {

        var r_selectedResources = [],
            selectedResources = DataService.getSelectedResourcesOnList();

        for (var key in selectedResources) {
            if (selectedResources[key]) {
                r_selectedResources.push(key);
            }
        }

        return r_selectedResources;
    }

    function assignSelected() {

        var selectedResourcesIds = getSelectedResources(),
            startDate = UtilsService.convertDateToUTC($scope.service.start_date, $scope.service.timezone),
            endDate = UtilsService.convertDateToUTC($scope.service.end_date, $scope.service.timezone);

        // save changes to service
        DataService.saveMultipleScms(selectedResourcesIds, $scope.service.crewOnGantt, startDate, endDate, false).then(function (data) {

            $scope.saving = true;

            // unselect all resources
            var selectedResources = DataService.getSelectedResourcesOnList();
            for (var key in selectedResources) {
                selectedResources[key] = false;
            }

            scheduler.parse(data, 'json');
            DataService.validateAllServicesInView();
            $rootScope.$broadcast('createGanttTimeline');
            $rootScope.$broadcast('updateCandidates');
        }).catch(function (err) {
            console.log(err);
            UtilsService.addError(err.message);
        }).finally(function () {
            $scope.saving = false;
        });
    }

    function getMissingSkillsForCandidate(resourceSkills) {

        var skills = resourceSkills.filter(function (skill) {

            for (var i = 0; i < $scope.service.missingSkills.length; i++) {

                var serviceSkill = $scope.service.missingSkills[i];

                if (serviceSkill.missing && serviceSkill.SkillId === skill.SkillId) {

                    var resourceSkillLevel = skill.SkillLevel || 1,
                        serviceSkillLevel = serviceSkill.SkillLevel || 1;

                    if (serviceSkillLevel <= resourceSkillLevel) {
                        return true;
                    }
                }
            }

            return false;
        });

        return UtilsService.generateSkillsSentence(skills, DataService.getSkills());
    }

    function getCurrentAssignedResources() {

        var resources = DataService.getResources(),
            assignedResources = [];

        for (var resourceId in resources) {

            var resource = resources[resourceId];

            for (var scmId in resource.crewMemberships) {

                var scm = resource.crewMemberships[scmId];

                // scm to different crew
                if ($scope.service.crewOnGantt !== scm.ServiceCrewId) {
                    continue;
                }

                // service INSIDE scm
                if (scm.start_date <= $scope.service.start_date && $scope.service.end_date <= scm.end_date) {
                    assignedResources.push(resource);
                    break;
                }
            }
        }

        return assignedResources;
    }

    function getRelevantResources() {

        var relevantResources = {},
            resources = DataService.getResources();

        var _loop = function _loop(resourceId) {

            // check if resource is already assigned
            if ($scope.currentAssignedResources.find(function (assignee) {
                return assignee.Id === resourceId;
            })) {
                return 'continue';
            }

            var resource = resources[resourceId],
                isAssignedToOtherCrew = false;

            // need to check that the resource is not assigned to another crew
            for (var scmId in resource.crewMemberships) {

                var scm = resource.crewMemberships[scmId];

                if (UtilsService.isIntersect($scope.service.start_date, $scope.service.end_date, scm.start_date, scm.end_date)) {

                    if ($scope.service.crewOnGantt !== scm.ServiceCrewId) {
                        isAssignedToOtherCrew = true;
                    }
                }
            }

            // assigned to another crew
            if (isAssignedToOtherCrew) {
                return 'continue';
            }

            // check for intersecting NAs
            if (resource.absences) {

                var foundIntersectingAbsence = false;

                for (var id in resource.absences) {

                    var absence = resource.absences[id];

                    if (UtilsService.isIntersect($scope.service.start_date, $scope.service.end_date, absence.start_date, absence.end_date)) {
                        foundIntersectingAbsence = true;
                        break;
                    }
                }

                if (foundIntersectingAbsence) {
                    return 'continue';
                }
            }

            // check available STMs
            for (var stmId in resource.territoryMemberships) {

                var stm = resource.territoryMemberships[stmId];

                // no stm to territory
                if ($scope.service.territoryOnGantt !== stm.ServiceTerritoryId) {
                    continue;
                }

                // service not in stm
                if (stm.ganttEffectiveStartDate > $scope.service.start_date || $scope.service.end_date > stm.ganttEffectiveEndDate) {
                    break;
                }

                // service has no required skills so the resource is a candidate
                if ($scope.service.requiredSkills.length === 0) {

                    relevantResources[resourceId] = relevantResources[resourceId] || {};
                    relevantResources[resourceId].resource = resource;
                    relevantResources[resourceId].relevantSkills = [];
                }

                // check if resource has at least one of the required skills
                for (var i = 0; i < $scope.service.requiredSkills.length; i++) {

                    var serviceSkill = $scope.service.requiredSkills[i];

                    if (!resource.ServiceResourceSkills) {
                        continue;
                    }

                    for (var j = 0; j < resource.ServiceResourceSkills.length; j++) {

                        var resourceSkill = resource.ServiceResourceSkills[j];

                        if (serviceSkill.SkillId === resourceSkill.SkillId) {

                            var resourceSkillLevel = resourceSkill.SkillLevel || 1,
                                serviceSkillLevel = serviceSkill.SkillLevel || 1;

                            if (serviceSkillLevel <= resourceSkillLevel) {

                                relevantResources[resourceId] = relevantResources[resourceId] || {};
                                relevantResources[resourceId].resource = resource;
                                relevantResources[resourceId].relevantSkills = relevantResources[resourceId].relevantSkills || [];
                                relevantResources[resourceId].relevantSkills.push(resourceSkill);
                            }
                        }
                    }
                }
            }
        };

        for (var resourceId in resources) {
            var _ret = _loop(resourceId);

            if (_ret === 'continue') continue;
        }

        return relevantResources;
    }

    function generateTemplate() {

        return angular.element('\n                <div id="cm-GetCandidates">\n                    \n                    <div id="cm-CandidatesHeader">\n                        \n                        <h1 class="cm-candidate-title"> ' + window.__crews.labels.CrewCandidatesFor + ' <u ng-click="openServiceLightbox()">{{service.AppointmentNumber}}</u></h1>\n                        \n                        <span ng-click="closeGetCandidates()" id="cm-close-get-candidates" class="truncate" title="' + window.__crews.labels.Close + '">' + window.__crews.labels.Close + '</span>\n                        \n                        <div class="cm-candidate-service-details">\n                            <b>' + window.__crews.labels.MinimumSize + ':</b> {{ service.MinimumCrewSize }} (current assigned: {{service.availableMembersCount}})<br/>\n                            <b>' + window.__crews.labels.RecommendedSize + ':</b> {{ service.RecommendedCrewSize }}<br/>\n                            <b>' + window.__crews.labels.RequiredSkillsCm + '</b> {{ generateSkillsSentence(service.requiredSkills) }}<br/>\n                            <b>' + window.__crews.labels.MissingSkills2 + ':</b> {{ generateSkillsSentence(getMissingSkills()) || "' + window.__crews.labels.NoSkillsMissings + '" }}\n                        </div>\n                    </div>\n                    \n                    <div class="cm-candidates-list">\n                        \n                        <h1>' + window.__crews.labels.CurrentMembers + '</h1>\n                        \n                        <div ng-repeat="resource in currentAssignedResources" class="cm-assigned-resource-candidate">\n\n                            <h2 ng-click="openResourceLightbox(resource.Name, resource.Id, $event)">{{resource.Name}}</h2>\n                            <div>' + window.__crews.labels.SkillsNekudotaim + ' {{ generateSkillsSentence(resource.ServiceResourceSkills) }}</div>\n                            \n                        </div>\n                        \n                        <div class="cm-no-candidates" ng-if="isEmpty(currentAssignedResources)">\n                            ' + window.__crews.labels.NoAssignedResources + ' \n                        </div>\n                        \n                    </div>\n                    \n                    \n                    <div class="cm-candidates-list">\n                        \n                        <h1>' + window.__crews.labels.Candidates + '</h1>\n                        \n                        <div id="cm-candidates-assign-selected" ng-if="!isEmpty(getRelevantResources) && getSelectedResources().length > 0" ng-click="assignSelected()">' + window.__crews.labels.AssignSelected + '</div>\n                        \n                        <div ng-repeat="relevantResource in getRelevantResources" class="cm-assigned-resource-candidate cm-candidate" draggable="true" draggable-resource="relevantResource.resource">\n\n\n                            <input type="checkbox" ng-model="getSelectedResourcesOnList()[relevantResource.resource.Id]" ng-click="$event.stopPropagation()" />\n                            <h2 ng-click="openResourceLightbox(relevantResource.resource.Name, relevantResource.resource.Id, $event)">{{relevantResource.resource.Name}}</h2>\n                            <div class="cm-candidate-text">' + window.__crews.labels.RelevantSkills + ' {{ generateSkillsSentence(relevantResource.relevantSkills) }}</div>\n                            <div class="cm-candidate-has-missing-skills">' + window.__crews.labels.HasMissingSkills + ' {{ getMissingSkillsForCandidate(relevantResource.relevantSkills) }}</div>\n                            \n                        </div>\n                        \n                        <div class="cm-no-candidates" ng-if="isEmpty(getRelevantResources)">\n                            ' + window.__crews.labels.NoCandidatesFoundCm + ' \n                        </div>\n                        \n                    </div>\n                    \n                </div>');
    }

    // This will be our factory
    return {
        get: get
    };
}
'use strict';

RemoteActionsService.$inject = ['$q'];

angular.module('Crews').factory('RemoteActionsService', RemoteActionsService);

function RemoteActionsService($q) {

    function callRemoteAction(remoteActionName) {
        for (var _len = arguments.length, params = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
            params[_key - 1] = arguments[_key];
        }

        var deferred = $q.defer(),
            remoteActionsParams = [window.__crews.remoteActions[remoteActionName]].concat(params).concat(function (data, ev) {
            ev.status ? deferred.resolve(data) : deferred.reject(ev);
        }).concat({ buffer: false, escape: false });

        remoteActionsParams = remoteActionsParams.filter(function (v) {
            return v !== undefined;
        });

        window.Visualforce.remoting.Manager.invokeAction.apply(window.Visualforce.remoting.Manager, remoteActionsParams);

        return deferred.promise;
    }

    return {
        callRemoteAction: callRemoteAction
    };
}
'use strict';

ScmLightbox.$inject = ['$rootScope', '$compile', 'DataService', 'UtilsService'];

angular.module('Crews').factory('ScmLightbox', ScmLightbox);

function ScmLightbox($rootScope, $compile, DataService, UtilsService) {

    // create a new scope
    var $scope = null;

    function openFromDrag(dragData) {

        if ($scope) {
            return;
        }

        // create new isolated scope
        $scope = $rootScope.$new(true);

        // is multiple?
        $scope.multipleScms = dragData.resourceIds.length > 1;
        $scope.isFromDrag = true;
        $scope.saving = false;

        // get resources names
        $scope.resouceNames = [];

        dragData.resourceIds.forEach(function (resourceId) {
            $scope.resouceNames.push(DataService.getResources()[resourceId].Name);
        });

        $scope.resouceNames = $scope.resouceNames.join(', ');
        $scope.resourceIds = dragData.resourceIds;
        $scope.timezone = dragData.territory.timezone;
        $scope.crewId = dragData.crewId;

        var start = moment(dragData.start),
            end = moment(dragData.end);

        initDates(start, end);

        $scope.start = new Date(dragData.start);
        $scope.end = new Date(dragData.end);

        $scope.title = window.__crews.labels.CreateScm;

        init();
    }

    function open(scm) {

        if ($scope) {
            return;
        }

        // create new isolated scope
        $scope = $rootScope.$new(true);

        $scope.scm = scm;

        if (scm) {

            var start = moment(scm.start_date),
                end = scm.EndDate ? moment(scm.end_date) : null;

            initDates(start, end);

            $scope.start = new Date(scm.start_date);
            $scope.end = scm.EndDate ? new Date(scm.end_date) : null;

            $scope.title = scm.ServiceCrewMemberNumber;
            $scope.resouceNames = DataService.getResources()[scm.ServiceResourceId].Name;
            $scope.isLeader = scm.IsLeader;
            $scope.multipleScms = false;
            $scope.isFromDrag = false;
        }

        init();
    }

    // basic init, copying stuff to scope and compiling
    function init() {

        $scope.closeLightbox = closeLightbox;

        $scope.dateSelector = function dateSelector(id, dateType) {
            if (scheduler.isCalendarVisible()) {
                scheduler.destroyCalendar();
            } else {
                scheduler.renderCalendar({
                    position: id,
                    date: scheduler._date,
                    navigation: true,
                    handler: function handler(date, calendar) {

                        UtilsService.safeApply($scope, function () {

                            if (dateType === 'end' && !$scope[dateType]) {
                                $scope.minuteEnd = '0';
                                $scope.hourEnd = '0';
                            }

                            $scope[dateType] = date;
                            scheduler.destroyCalendar();
                        });
                    }
                });
            }
        };

        $scope.formatDate = formatDate;
        $scope.deleteScm = deleteScm;
        $scope.saveScm = saveScm;

        $scope.minutesArray = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59];
        $scope.hoursArray = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23];
        $scope.hoursLabels = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23];

        handleAMPM();

        // add to body
        var lightboxDomElement = generateTemplate();
        angular.element('body').append(lightboxDomElement);

        // on destroy, remove DOM elements
        $scope.$on('$destroy', function () {
            return lightboxDomElement.remove();
        });

        // compile
        $compile(lightboxDomElement)($scope);

        UtilsService.safeApply($scope);
    }

    // esc - close lightbox
    document.addEventListener('keyup', function (e) {

        if ($scope && e.which === 27) {
            $scope.$evalAsync($scope.closeLightbox);
        }
    });

    function handleAMPM() {

        if (window.__crews.isAMPM) {
            $scope.hoursLabels = ['12AM', '1AM', '2AM', '3AM', '4AM', '5AM', '6AM', '7AM', '8AM', '9AM', '10AM', '11AM', '12PM', '1PM', '2PM', '3PM', '4PM', '5PM', '6PM', '7PM', '8PM', '9PM', '10PM', '11PM'];
        }
    }

    function initDates(start, end) {

        $scope.minuteStart = start.get('m').toString();
        $scope.hourStart = start.get('h').toString();
        $scope.minuteEnd = end ? end.get('m').toString() : null;
        $scope.hourEnd = end ? end.get('h').toString() : null;
    }

    function closeLightbox() {
        $scope.$destroy();
        $scope = null;
    }

    function formatDate(type) {

        if (type === 'start') {
            return moment($scope.start).format('ll');
        } else if ($scope.end) {
            return moment($scope.end).format('ll');
        }

        return window.__crews.labels.NotDefined;
    }

    function deleteScm() {

        if ($scope.saving) {
            return;
        }

        if (!window.confirm(window.__crews.labels.ScmDeleteConfirm)) {
            return;
        }

        DataService.deleteScm($scope.scm).then(function (data) {
            DataService.validateAllServicesInView();
            scheduler.updateView();
            $rootScope.$broadcast('createGanttTimeline');
            DataService.validateAllServicesInView();
            $rootScope.$broadcast('updateCandidates');
            $scope.closeLightbox();
        }).catch(function (err) {
            $scope.error = err.message;
            $scope.saving = false;
        });
    }

    function saveScm() {

        if ($scope.saving) {
            return;
        }

        $scope.saving = true;
        $scope.isFromDrag ? saveMultipleScms() : saveSignleScm();
    }

    function saveSignleScm() {

        var resourceId = $scope.scm.ServiceResourceId,
            resourceStm = $scope.scm.stmId,
            scmId = $scope.scm.Id,
            crewId = $scope.scm.ServiceCrewId,
            resource = DataService.getResources()[resourceId];

        handleDatesForSaving();

        var stm = resource.territoryMemberships[resourceStm],
            startDate = UtilsService.convertDateToUTC($scope.start, stm.timezone),
            endDate = $scope.end ? UtilsService.convertDateToUTC($scope.end, stm.timezone) : null;

        // save changes to service
        DataService.saveChangesToStm(scmId, resourceId, crewId, startDate, endDate, $scope.isLeader).then(function (data) {

            // unselect all resources
            var selectedResources = DataService.getSelectedResourcesOnList();
            for (var key in selectedResources) {
                selectedResources[key] = false;
            }

            scheduler.parse(data, 'json');
            DataService.validateAllServicesInView();
            $rootScope.$broadcast('createGanttTimeline');
            $rootScope.$broadcast('updateCandidates');
            $scope.closeLightbox();
        }).catch(function (err) {
            $scope.error = err.message.split(':')[1];
        }).finally(function () {
            $scope.saving = false;
        });
    }

    function saveMultipleScms() {

        handleDatesForSaving();

        var startDate = UtilsService.convertDateToUTC($scope.start, $scope.timezone),
            endDate = $scope.end ? UtilsService.convertDateToUTC($scope.end, $scope.timezone) : null;

        // save changes to service
        DataService.saveMultipleScms($scope.resourceIds, $scope.crewId, startDate, endDate, !!$scope.isLeader).then(function (data) {

            // unselect all resources
            var selectedResources = DataService.getSelectedResourcesOnList();
            for (var key in selectedResources) {
                selectedResources[key] = false;
            }

            scheduler.parse(data, 'json');
            DataService.validateAllServicesInView();
            $rootScope.$broadcast('createGanttTimeline');
            $rootScope.$broadcast('updateCandidates');
            $scope.closeLightbox();
        }).catch(function (err) {
            $scope.error = err.message.split(':')[1];
        }).finally(function () {
            $scope.saving = false;
        });
    }

    function handleDatesForSaving() {
        $scope.start.setHours($scope.hourStart);
        $scope.start.setMinutes($scope.minuteStart);

        if ($scope.end) {
            $scope.end.setHours($scope.hourEnd);
            $scope.end.setMinutes($scope.minuteEnd);
        }
    }

    function generateTemplate() {

        return angular.element('\n                <div class="LightboxBlackContainer">\n                    <div class="LightboxContainer scm-lb">\n\n                        <div class="lightboxHeaderContainer">\n                            <svg aria-hidden="true" class="slds-icon CloseLightbox" ng-click="closeLightbox()">\n                                \u2028<use xlink:href="' + window.__crews.icons.close + '"></use>\n                            \u2028</svg>\n                            <h1 class="light-box-header" ng-bind="title"></h1>\n                        </div>\n\n                        <div class="lightboxContent">\n                        \n                            <div class="scm-lb-error" ng-show="error">\n                                <svg aria-hidden="true" class="slds-icon" ng-click="error = null">\n                                    \u2028<use xlink:href="' + window.__crews.icons.close + '"></use>\n                                \u2028</svg>\n                                \n                                {{error}}\n                            </div>\n                            \n                            \n                            <div class="scm-lb-saving" ng-show="saving">\n                                ' + window.__crews.labels.OnboardingSaving + '\n                            </div>\n                        \n                        \n                            <div class="scm-scm-date-container">\n                                <div class="scm">' + window.__crews.labels.ServiceResourcesCm + '</div>\n                                <div class="scm-lb-resources">{{resouceNames}}</div>\n                            </div>\n                        \n                            \n                            <div class="scm-scm-date-container scm-lb-date-fix">\n                                <div>' + window.__crews.labels.Start_date + '</div>\n                                <span id="scm-start-date" class="scm-lb-date" ng-click="dateSelector(\'scm-start-date\', \'start\')" ng-bind="formatDate(\'start\')"></span>\n                                <svg aria-hidden="true" class="slds-icon scm-lb-date-icon" ng-click="dateSelector(\'scm-start-date\', \'start\')">\n                                    \u2028<use xlink:href="' + window.__crews.icons.event + '"></use>\n                                \u2028</svg>\n                                \n                                <select class="scm-lb-select" ng-model="hourStart">\n                                    <option ng-repeat="hour in hoursArray" value="{{+hour}}">{{hoursLabels[$index]}}</option>\n                                </select>\n                                \n                                <select class="scm-lb-select" ng-model="minuteStart">\n                                    <option ng-repeat="minute in minutesArray" value="{{+minute}}">{{minute}}</option>\n                                </select>\n                            </div>\n      \n                            \n                            <div class="scm-scm-date-container scm-lb-date-fix">\n                                <div>' + window.__crews.labels.finish_date + '</div>\n                                <span id="scm-end-date" class="scm-lb-date" ng-click="dateSelector(\'scm-end-date\', \'end\')" ng-bind="formatDate(\'end\')"></span>\n                                <svg aria-hidden="true" class="slds-icon scm-lb-date-icon" ng-click="dateSelector(\'scm-end-date\', \'end\')">\n                                    \u2028<use xlink:href="' + window.__crews.icons.event + '"></use>\n                                \u2028</svg>\n                                \n                                <select class="scm-lb-select" ng-model="hourEnd">\n                                    <option ng-repeat="hour in hoursArray" value="{{+hour}}">{{hoursLabels[$index]}}</option>\n                                </select>\n                                \n                                <select class="scm-lb-select" ng-model="minuteEnd">\n                                    <option ng-repeat="minute in minutesArray" value="{{+minute}}">{{minute}}</option>\n                                </select>\n                            </div>\n                            \n                            <div class="scm-scm-date-container" ng-hide="multipleScms">\n                                <input type="checkbox" ng-model="isLeader" id="scm-lb-leader"/>\n                                <label for="scm-lb-leader">' + window.__crews.labels.MakeLeader + '</label>\n                            </div>\n                                         \n                                                        \n                            <div class="scm-lb-footer">\n                                <div class="scm-lb-button" ng-click="saveScm()">' + window.__crews.labels.Save + '</div>\n                                <div class="scm-lb-button scm-delete-button" ng-show="scm.Id" ng-click="deleteScm()">' + window.__crews.labels.Delete + '</div>\n                            </div>\n                                                        \n                                                        \n                        </div>\n\n\n                    </div>\n                </div>');
    }

    // This will be our factory
    return {
        open: open,
        openFromDrag: openFromDrag
    };
}
'use strict';

TerritoryFilteringService.$inject = ['$compile', '$rootScope', 'DataService'];

angular.module('Crews').factory('TerritoryFilteringService', TerritoryFilteringService);

function TerritoryFilteringService($compile, $rootScope, DataService) {

    // create new isolated scope
    var $scope = $rootScope.$new(true);
    $scope.isOpen = false;

    $scope.showOrphanServices = true;
    $scope.locationSearchTerm = '';
    $scope.showLocationFiltering = false;
    $scope.noLocationsLoad = false;
    $scope.locationFilter = {};
    $scope.locationFilterCopy = {};
    $scope.locationsFlat = [];
    $scope.territoriesSortedByTree = [];
    $scope.showTree = true;
    $scope.saving = false;

    // add to body
    var filteringElement = generateTemplate().hide();
    angular.element('#ResourceList').append(filteringElement);

    // compile
    $compile(filteringElement)($scope);

    // open the UI
    function toggle() {
        $scope.isOpen = !$scope.isOpen;
        filteringElement.toggle();
    }

    function isOpen() {
        return $scope.isOpen;
    }

    function setSearchTerm(term) {
        $scope.locationSearchTerm = term;
    }

    $scope.closeTerritoryFilter = function () {
        for (var key in $scope.locationFilterCopy) {
            $scope.locationFilter[key] = $scope.locationFilterCopy[key];
        }

        $scope.isOpen = false;
        filteringElement.hide();
    };

    // this object will make the indentations on the tree UI
    $scope.styleForLocationTree = function (depth) {
        return {
            'margin-left': depth * 20 + 'px'
        };
    };

    // ready data for display - should happen only once when finished loading the territories list
    DataService.getResourcesPromise().promise.then(function () {

        var territories = DataService.getTerritories(),
            allTerritories = DataService.getAllTerritories(),
            treeData = {},
            m_locationTreeDataUnflatten = [],
            showLocations = [];

        // start build unflatten tree for location filtering hierarchy
        for (var id in territories) {
            treeData[id] = {
                id: id,
                parent: territories[id].ParentTerritory ? territories[id].ParentTerritory : 0,
                text: territories[id].Name,
                items: []
            };
        }

        // build data stuctures (tree + flat)
        for (var key in treeData) {

            var node = treeData[key];
            var activeParent = getFirstActiveParent(node);

            if (node.parent !== 0 && activeParent) {
                treeData[activeParent.Id].items.push(node);
            } else {
                m_locationTreeDataUnflatten.push(node);
            }
        }

        function getFirstActiveParent(node) {

            if (!node.id || !node.parent) return;

            if (treeData[node.parent.Id]) return node.parent;else {

                //check if territory is even available for user
                var parentNode = {};
                if (allTerritories[node.parent.Id]) parentNode = {
                    id: allTerritories[node.parent.Id].Id,
                    parent: allTerritories[node.parent.Id].ParentTerritory ? allTerritories[node.parent.Id].ParentTerritory : 0
                };

                return getFirstActiveParent(parentNode);
            }
        }

        $scope.locationsTree = m_locationTreeDataUnflatten;

        for (var i = 0; i < m_locationTreeDataUnflatten.length; i++) {
            setNodeDepth(m_locationTreeDataUnflatten[i], 0, $scope.locationsFlat);
        }

        for (var _i = 0; _i < $scope.locationsFlat.length; _i++) {

            $scope.noLocationsLoad = false;

            if ($scope.locationFilter[$scope.locationsFlat[_i].id]) showLocations.push($scope.locationsFlat[_i].id);
        }

        // get items from local storage
        var localStorageTerritories = localStorage.getItem('territories');

        if (localStorageTerritories) {
            localStorageTerritories = localStorageTerritories.split(',');
            localStorageTerritories.forEach(function (territoryId) {
                return $scope.locationFilter[territoryId] = true;
            });
        }

        // make a copy, used when user closing without save
        $scope.locationFilterCopy = angular.copy($scope.locationFilter);
    });

    // set node depth on each location (will be used to indent in the UI)
    function setNodeDepth(current, depth, arr) {
        current.depth = depth;
        arr.push(current);

        if (current.items) {
            for (var i = 0, len = current.items.length; i < len; i++) {
                current.items[i].depth = depth;
                setNodeDepth(current.items[i], depth + 1, arr);
            }
        }
    }

    // for location filter
    $scope.selectLocation = function (locationId) {
        var bool = $scope.locationFilter[locationId],
            parentLocation = findLocationInTree($scope.locationsTree, locationId);

        if (parentLocation) {
            selectLocationTree(parentLocation, bool);
        }
    };

    // find parent location in the tree
    function findLocationInTree(locationsTree, locationId) {

        var child = null;

        for (var i = 0; i < locationsTree.length; i++) {
            if (locationsTree[i].id === locationId) {
                return locationsTree[i];
            } else {
                child = findLocationInTree(locationsTree[i].items, locationId);
                if (child) {
                    return child;
                }
            }
        }

        return child;
    }

    // check / uncheck the locations.
    function selectLocationTree(location, bool) {
        for (var i = 0; i < location.items.length; i++) {
            $scope.locationFilter[location.items[i].id] = bool;
            selectLocationTree(location.items[i], bool);
        }
    }

    // select all available locations
    $scope.selectAllLocations = function (isSelectAll) {
        angular.forEach($scope.ter, function (item) {
            $scope.locationFilter[item.id] = isSelectAll;
        });
    };

    $scope.applyFilterLocation = function () {

        $scope.saving = true;

        var territories = [];

        for (var id in $scope.locationFilter) {
            if ($scope.locationFilter[id]) {
                territories.push(id);
            }
        }

        if (territories.length === 0) {
            alert(window.__crews.labels.MustHave1Territory);
            $scope.saving = false;
            return;
        }

        if (territories.toString() === localStorage.getItem('territories')) {
            $scope.saving = false;
            return;
        }

        localStorage.setItem('territories', territories);

        DataService.init().then(function () {

            $rootScope.$broadcast('createGanttTimeline');
        }).finally(function (d) {
            return $scope.saving = false;
        });
    };

    $scope.countSelected = function () {

        var selected = 0;
        for (var id in $scope.locationFilter) {

            if ($scope.locationFilter[id]) {
                selected++;
            }
        }

        return selected;
    };

    function generateTemplate() {
        return angular.element('\n    \t\t<div class="LeftSiteLocationFiltering">\n    \t\t\n    \t\t    <div id="cm-saving-territories" ng-show="saving">' + window.__crews.labels.OnboardingSaving + '</div>\n\n    \t\t    <div class="lightboxContentContainer">\n\n    \t\t        <div class="selectButtons">\n    \t\t        \n    \t\t            <span class="selectedNumberOfTerritories truncate">' + window.__crews.labels.TeritoriesSelectedCm.replace('{0}', '{{ countSelected() }}') + '</span>\n    \t\t        \n    \t\t        \n    \t\t        \n    \t\t            <span class="selectAllLocations truncate" ng-click="selectAllLocations(true)" title="' + window.__crews.labels.Select_all + '">' + window.__crews.labels.Select_all + '</span>\n    \t\t            <span class="selectAllLocations truncate" ng-click="selectAllLocations(false)" title="' + window.__crews.labels.Select_none + '">' + window.__crews.labels.Select_none + '</span>\n    \t\t        </div>\n    \t\t        \n\t    \t\t\t<div ng-show="showTree" id="LocationsTree">\n\t    \t\t\t    <div ng-repeat="l in ter = (locationsFlat | filter: {text: locationSearchTerm})" class="locationFilterRow" ng-style="{{ styleForLocationTree(l.depth) }}" ng-click="selectLocation(l.id)">\n                            <div class="slds-form-element">\n                              <div class="slds-form-element__control">\n                                <div class="slds-checkbox">\n                                    <input type="checkbox" ng-model="locationFilter[l.id]" id="location_{{ l.id }}" />   \n                                    <label class="slds-checkbox__label" for="location_{{ l.id }}">\n                                        <span class="slds-checkbox_faux"></span>\n                                        <span class="slds-form-element__label">{{ l.text }}</span>\n                                    </label>\n                                </div>\n                              </div>\n                            </div>\n\n\t    \t\t\t    </div>\n\t    \t\t    </div>\n                </div>\n                <div class="TerritoryFilterControllers">\n                    <span class="slds-button slds-button_brand ima-shel-sf-isha-tova ima-shel-sf-shomeret" ng-click="applyFilterLocation()">' + window.__crews.labels.Save + '</span>\n                    <span class="slds-button slds-button_neutral ima-shel-sf-isha-tova" ng-click="closeTerritoryFilter()">' + window.__crews.labels.Cancel + '</span>\n                </div>\n    \t\t</div>\n    \t');
    }

    return {
        toggle: toggle,
        isOpen: isOpen,
        setSearchTerm: setSearchTerm
    };
}
'use strict';

UtilsService.$inject = ['$q', 'RemoteActionsService'];

angular.module('Crews').factory('UtilsService', UtilsService);

function UtilsService() {

    var errors = [],
        errorSubscribers = [];

    function parseStm(stm, territories, operatingHours) {

        stm.OperatingHoursId = stm.OperatingHoursId || territories[stm.ServiceTerritoryId].OperatingHoursId;
        stm.timezone = operatingHours[stm.OperatingHoursId].TimeZone;

        if (stm.EffectiveStartDate) {
            stm.EffectiveStartDate = moment(stm.EffectiveStartDate).tz(stm.timezone);
            stm.ganttEffectiveStartDate = stm.EffectiveStartDate;
        } else {
            stm.ganttEffectiveStartDate = moment('1900, 1, 1').tz(stm.timezone);
        }

        if (stm.EffectiveEndDate) {
            stm.EffectiveEndDate = moment(stm.EffectiveEndDate).tz(stm.timezone);
            stm.ganttEffectiveEndDate = stm.EffectiveEndDate;
        } else {
            stm.ganttEffectiveEndDate = moment('2900, 1, 1').tz(stm.timezone);
        }

        return stm;
    }

    function doesResourceHasStm(resource, territoryId, start, end) {

        if (resource.territoryMemberships && Object.keys(resource.territoryMemberships).length === 0) {
            return false;
        }

        for (var id in resource.territoryMemberships) {

            var currentStm = resource.territoryMemberships[id];

            // has STM that is not secondary and STM is to the specified territory
            if (currentStm.ServiceTerritoryId.includes(territoryId) && isIntersect(start, end, currentStm.ganttEffectiveStartDate, currentStm.ganttEffectiveEndDate)) {
                return currentStm.Id;
            }

            // if (currentStm.TerritoryType !== 'S' && currentStm.ServiceTerritoryId.includes(territoryId) && isIntersect(start, end, currentStm.ganttEffectiveStartDate, currentStm.ganttEffectiveEndDate)) {
            //     return currentStm.Id;
            // }
        }

        return false;
    }

    function getLocalDateOffsetOffset(date) {
        return new Date(date).getTimezoneOffset() * 60 * 1000;
    }

    function isIntersect(a_start, a_end, b_start, b_end) {
        return a_start < b_end && a_end > b_start;
    }

    function generateDateKey(date) {
        return date.getDate() + '_' + date.getMonth() + '_' + date.getFullYear();
    }

    function convertDateToUTC(date, timezone) {

        var startDateOffset = moment(date).tz(timezone)._offset,
            startDate = new Date(date);

        startDate.setMinutes(startDate.getMinutes() + startDateOffset);

        return startDate;
    }

    function addError(sfdcErrorObject) {
        errors.push(sfdcErrorObject);
        errorSubscribers.forEach(function (f) {
            return f(sfdcErrorObject);
        });
    }

    // run this function when new error appears
    function subscribeForNewErrors(fn) {
        errorSubscribers.push(fn);
    }

    function generateResourceGanttLabel(resource, allSkills) {
        var isCrew = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : false;


        var ganttLabelField = window.__crews.fields.ServiceResource.GanttLabel__c,
            label = '',
            skills = [];

        if (resource.ServiceResourceSkills) {

            resource.ServiceResourceSkills.forEach(function (s) {
                skills.push('' + allSkills[s.SkillId]);

                if (s.SkillLevel !== undefined && s.SkillLevel !== 1) {
                    skills[skills.length - 1] = '' + window.__crews.labels.SkillAndLevel.replace('{0}', skills[skills.length - 1]).replace('{1}', s.SkillLevel);
                }
            });

            skills = skills.join(', ');
        } else {
            skills = isCrew ? window.__crews.labels.CrewNoSkills : window.__crews.labels.ResourceNoSkills;
        }

        label = '<div class="cm-resource-name-container-gantt" title="' + skills + '">';

        if (resource.RelatedRecord && resource.RelatedRecord.SmallPhotoUrl) {
            label += '<img class="cm-resource-photo" src="' + resource.RelatedRecord.SmallPhotoUrl + '" />';
        } else {
            label += '<div class="cm-resourcePhotoIcon"></div>';
        }

        if (resource[ganttLabelField]) {
            label += '<div class="cm-resource-name-gantt truncate">' + resource.Name + '</div>';
            label += '<div class="cm-resource-gantt-label truncate">' + resource[ganttLabelField] + '</div>';
        } else {
            label += '<div class="cm-resource-name-gantt resource-gantt-no-label cm-resource-gantt-label">' + resource.Name + '</div>';
        }

        label += '</div>';

        return label;
    }

    function safeApply(scope, fn) {

        var phase = scope.$root.$$phase;

        if (phase === '$apply' || phase === '$digest') {
            if (fn && typeof fn === 'function') {
                fn();
            }
        } else {
            scope.$apply(fn);
        }
    }

    function openConsoleTab(e, id) {

        var isInConsole = typeof sforce !== "undefined" ? sforce.console.isInConsole() : null;

        if (isInConsole) {

            if (e) {
                e.preventDefault();
            }

            window.sforce.console.generateConsoleUrl(['/' + id], function (result) {
                if (result.success) {
                    window.sforce.console.openConsoleUrl(null, result.consoleUrl, true);
                } else {
                    openLightningPrimaryTab(id);
                }
            });

            return true;
        }

        return false;
    }

    function openLightningPrimaryTab(id) {
        window.sforce.console.openPrimaryTab(null, '/' + id, true);
    }

    window.openConsoleTabFromModal = function (url) {

        var isInConsole = typeof sforce !== "undefined" ? sforce.console.isInConsole() : null;

        if (isInConsole) {

            window.sforce.console.generateConsoleUrl([url], function (result) {

                if (result.success) {
                    window.sforce.console.openConsoleUrl(null, result.consoleUrl, true);
                } else {
                    openLightningPrimaryTab(url);
                }
            });
        }
    };

    function generateSkillsSentence(resourceSkills, skills) {
        var crew = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : false;


        if (!resourceSkills) {
            return crew ? window.__crews.labels.CrewHasNoSkills : window.__crews.labels.ResourceNoSkills;
        }

        var skillNames = [];

        resourceSkills.forEach(function (s) {
            skillNames.push(skills[s.SkillId]);

            if (s.SkillLevel && s.SkillLevel !== 1) {
                skillNames[skillNames.length - 1] = '' + window.__crews.labels.SkillAndLevel.replace('{0}', skillNames[skillNames.length - 1]).replace('{1}', s.SkillLevel);
            }
        });

        return skillNames.join(', ');
    }

    return {
        parseStm: parseStm,
        isIntersect: isIntersect,
        doesResourceHasStm: doesResourceHasStm,
        getLocalDateOffsetOffset: getLocalDateOffsetOffset,
        generateDateKey: generateDateKey,
        convertDateToUTC: convertDateToUTC,
        addError: addError,
        subscribeForNewErrors: subscribeForNewErrors,
        generateResourceGanttLabel: generateResourceGanttLabel,
        getErrors: function getErrors() {
            return errors;
        },
        safeApply: safeApply,
        openConsoleTab: openConsoleTab,
        generateSkillsSentence: generateSkillsSentence
    };
}