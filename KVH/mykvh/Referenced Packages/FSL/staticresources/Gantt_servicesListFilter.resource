'use strict';

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

(function () {

    angular.module('serviceExpert').filter('servicesListFilter', ['utils', '$filter', 'servicesService', 'userSettingsManager', 'ServiceSelectorService', 'SERVICE_STATUS', 'SERVICE_CATEGORY', function (utils, $filter, servicesService, userSettingsManager, ServiceSelectorService, SERVICE_STATUS, SERVICE_CATEGORY) {

        return function (services, filter, servicesListFields, allFilters) {

            var checksum = generateChecksum(services, filter);

            if (filter.selectedFilter === 'SearchOnServer') {
                var searchOnServerResult = [services[filter.searchOnServer]],
                    _totalChecksum = 0;

                searchOnServerResult.forEach(function (s) {
                    return _totalChecksum += s.totalModifiedTimes;
                });

                searchOnServerResult.checksum += _totalChecksum.toString();

                return searchOnServerResult;
            }

            var isOldFilter = allFilters && allFilters[filter.selectedFilter] && allFilters[filter.selectedFilter].old;

            if (useNewFilters && !isOldFilter) {
                var newFilterResult = $filter('servicesListFilterNew')(services, filter, servicesListFields);
                newFilterResult.checksum += newFilterResult.totalChecksum.toString();

                return newFilterResult;
            }

            var servicesArray = [];
            var endDate = new Date(filter.endDate);
            var startDate = utils.addDaysToDate(endDate, -utils.ganttSettings.backHorizon);

            var minDate = scheduler.getState().min_date,
                maxDate = scheduler.getState().max_date;

            var customFilter = isStorageFilter(filter.selectedFilter);

            var multiSearch = null,
                searchTextArray = [];
            if (filter.SearchText.indexOf(',') > -1) {
                multiSearch = filter.SearchText.replace(/, /g, ',').split(',');

                // bug fixing
                if (multiSearch[multiSearch.length - 1] === '') multiSearch.length--;
            }

            if (multiSearch) {
                searchTextArray = multiSearch;
            } else {
                searchTextArray.push(filter.SearchText);
            }

            var totalChecksum = 0;

            for (var key in services) {

                for (var i = 0; i < searchTextArray.length; i++) {

                    var searchText = searchOnService(services[key], searchTextArray[i], servicesListFields);
                    var checkDatesResult = checkDates(services[key], filter.selectedFiled, startDate, endDate);

                    if (filter.selectedFilter == 'Selected') {
                        if (ServiceSelectorService.SelectedServices[key] && ServiceSelectorService.SelectedServices[key] && searchText) {
                            totalChecksum += services[key].totalModifiedTimes;
                            servicesArray.push(services[key]);
                            break;
                        }
                    } else if (filter.selectedFilter == 'Flagged' && searchText) {
                        if (servicesService.flagged[key]) {
                            totalChecksum += services[key].totalModifiedTimes;
                            servicesArray.push(services[key]);
                            break;
                        }
                    } else if (filter.selectedFilter == 'Recent' && searchText) {
                        if (servicesService.recentlyUsed[key]) {
                            totalChecksum += services[key].totalModifiedTimes;
                            servicesArray.push(services[key]);
                            break;
                        }
                    } else if (filter.selectedFilter == 'Todo') {

                        if ((services[key].statusCategory == SERVICE_CATEGORY.NONE || services[key].violations || services[key].jeopardy) && services[key].statusCategory != SERVICE_CATEGORY.CANCELED && services[key].statusCategory != SERVICE_CATEGORY.COMPLETED) {
                            if (checkDatesResult) {

                                if (searchTextArray[i].length > 1 && searchText) {
                                    totalChecksum += services[key].totalModifiedTimes;
                                    servicesArray.push(services[key]);
                                    break;
                                } else if (searchTextArray[i].length <= 1) {
                                    totalChecksum += services[key].totalModifiedTimes;
                                    servicesArray.push(services[key]);
                                    break;
                                }
                            }
                        }
                    } else if (filter.selectedFilter == 'All') {

                        if (checkDatesResult) {

                            if (searchTextArray[i].length > 1 && searchText) {
                                totalChecksum += services[key].totalModifiedTimes;
                                servicesArray.push(services[key]);
                                break;
                            } else if (searchTextArray[i].length <= 1) {
                                totalChecksum += services[key].totalModifiedTimes;
                                servicesArray.push(services[key]);
                                break;
                            }
                        }
                    } else if (filter.selectedFilter == 'Unscheduled') {

                        if (!services[key].resource && services[key].statusCategory != SERVICE_CATEGORY.CANCELED) {
                            if (checkDatesResult) {

                                if (searchTextArray[i].length > 1 && searchText) {
                                    totalChecksum += services[key].totalModifiedTimes;
                                    servicesArray.push(services[key]);
                                    break;
                                } else if (searchTextArray[i].length <= 1) {
                                    totalChecksum += services[key].totalModifiedTimes;
                                    servicesArray.push(services[key]);
                                    break;
                                }
                            }
                        }
                    } else if (filter.selectedFilter == 'Violating') {

                        if (services[key].violations && services[key].statusCategory != SERVICE_CATEGORY.CANCELED) {
                            if (checkDatesResult) {

                                if (searchTextArray[i].length > 1 && searchText) {
                                    totalChecksum += services[key].totalModifiedTimes;
                                    servicesArray.push(services[key]);
                                    break;
                                } else if (searchTextArray[i].length <= 1) {
                                    totalChecksum += services[key].totalModifiedTimes;
                                    servicesArray.push(services[key]);
                                    break;
                                }
                            }
                        }
                    } else if (filter.selectedFilter == 'inJeopardy') {

                        if (services[key].jeopardy && services[key].statusCategory != SERVICE_CATEGORY.CANCELED) {
                            if (checkDatesResult) {

                                if (searchTextArray[i].length > 1 && searchText) {
                                    totalChecksum += services[key].totalModifiedTimes;
                                    servicesArray.push(services[key]);
                                    break;
                                } else if (searchTextArray[i].length <= 1) {
                                    totalChecksum += services[key].totalModifiedTimes;
                                    servicesArray.push(services[key]);
                                    break;
                                }
                            }
                        }
                    } else if (filter.selectedFilter == 'Scheduled') {

                        if (services[key].resource) {
                            if (checkDatesResult) {

                                if (searchTextArray[i].length > 1 && searchText) {
                                    totalChecksum += services[key].totalModifiedTimes;
                                    servicesArray.push(services[key]);
                                    break;
                                } else if (searchTextArray[i].length <= 1) {
                                    totalChecksum += services[key].totalModifiedTimes;
                                    servicesArray.push(services[key]);
                                    break;
                                }
                            }
                        }
                    } else if (filter.selectedFilter == 'Gantt filter') {

                        if (services[key].resource && (services[key].start <= maxDate && services[key].start >= minDate || services[key].finish <= maxDate && services[key].finish >= minDate)) {

                            if (searchTextArray[i].length > 1 && searchText) {
                                totalChecksum += services[key].totalModifiedTimes;
                                servicesArray.push(services[key]);
                                break;
                            } else if (searchTextArray[i].length <= 1) {
                                totalChecksum += services[key].totalModifiedTimes;
                                servicesArray.push(services[key]);
                                break;
                            }
                        }
                    } else if (filter.selectedFilter == 'Contractors filter') {

                        if (services[key].resourceContractor) {
                            if (checkDatesResult) {

                                if (searchTextArray[i].length > 1 && searchText) {
                                    totalChecksum += services[key].totalModifiedTimes;
                                    servicesArray.push(services[key]);
                                    break;
                                } else if (searchTextArray[i].length <= 1) {
                                    totalChecksum += services[key].totalModifiedTimes;
                                    servicesArray.push(services[key]);
                                    break;
                                }
                            }
                        }
                    } else if (filter.selectedFilter == 'Cancelled filter') {

                        if (services[key].statusCategory == SERVICE_CATEGORY.CANCELED && checkDatesResult) {

                            if (searchTextArray[i].length > 1 && searchText) {
                                totalChecksum += services[key].totalModifiedTimes;
                                servicesArray.push(services[key]);
                                break;
                            } else if (searchTextArray[i].length <= 1) {
                                totalChecksum += services[key].totalModifiedTimes;
                                servicesArray.push(services[key]);
                                break;
                            }
                        }
                    } else if (filter.selectedFilter == 'Crews filter') {

                        if (services[key].isAssignToCrew) {
                            //Show SA's that are assigned to crews

                            if (searchTextArray[i].length > 1 && searchText) {
                                totalChecksum += services[key].totalModifiedTimes;
                                servicesArray.push(services[key]);
                                break;
                            } else if (searchTextArray[i].length <= 1) {
                                totalChecksum += services[key].totalModifiedTimes;
                                servicesArray.push(services[key]);
                                break;
                            }
                        }

                        // SAs that requires a crew (based on WO field - required/min crew size - if not null/blank/0 - SA should be scheduled to crew and be visible in Crew list view.
                        else if (services[key].parentFields.MinimumCrewSize != undefined || services[key].parentFields.RecommendedCrewSize != undefined) {

                                if (searchTextArray[i].length > 1 && searchText) {
                                    totalChecksum += services[key].totalModifiedTimes;
                                    servicesArray.push(services[key]);
                                    break;
                                } else if (searchTextArray[i].length <= 1) {
                                    totalChecksum += services[key].totalModifiedTimes;
                                    servicesArray.push(services[key]);
                                    break;
                                }
                            }
                    } else if (customFilter) {

                        if (customFilter.statusCheckboxs[statusTranslations[services[key].status]] && checkAdvanceFilterDates(customFilter, filter.selectedFiled, services[key]) && checkPriority(services[key], customFilter.servicePriority) && checkSelectFilter(services[key], customFilter) && checkCustomFilterLocations(services[key], customFilter.locationsCheckboxs, customFilter.noLocation)) {

                            if (searchTextArray[i].length > 1 && searchText) {
                                totalChecksum += services[key].totalModifiedTimes;
                                servicesArray.push(services[key]);
                                break;
                            } else if (searchTextArray[i].length <= 1) {
                                totalChecksum += services[key].totalModifiedTimes;
                                servicesArray.push(services[key]);
                                break;
                            }
                        }
                    }
                } //end  search term for
            } //end services for

            var filterResult = $filter('orderBy')(servicesArray, filter.orderByField, filter.reverse);
            filterResult.checksum = checksum + totalChecksum.toString();
            return filterResult;
        };

        function generateChecksum(services, filter) {

            var checksum = Object.keys(services).length.toString();

            for (var key in filter) {

                if (_typeof(filter[key]) !== 'object') {

                    if (typeof filter[key] === 'boolean') {
                        checksum += filter[key] ? '1' : '0';
                        continue;
                    }

                    checksum += filter[key].toString();
                }
            }

            // individual proccessing - endDate
            checksum += filter.endDate.getTime();

            // individual proccessing - selectedFiled
            for (var _key in filter.selectedFiled) {
                checksum += filter.selectedFiled[_key] ? '1' : '0';
            }

            // individual proccessing - filter.advancedFilter.selectedFiled
            for (var _key2 in filter.advancedFilter.selectedFiled) {
                checksum += filter.advancedFilter.selectedFiled[_key2] ? '1' : '0';
            }

            // individual proccessing - filter.advancedFilter.statusCheckboxs
            for (var _key3 in filter.advancedFilter.statusCheckboxs) {
                checksum += filter.advancedFilter.statusCheckboxs[_key3] ? '1' : '0';
            }

            checksum += filter.advancedFilter.minDate.toString();
            checksum += filter.advancedFilter.maxDate.toString();
            checksum += filter.advancedFilter.servicePriority;
            checksum += filter.advancedFilter.jeopardies ? '1' : '0';
            checksum += filter.advancedFilter.unScheduled ? '1' : '0';
            checksum += filter.advancedFilter.violations ? '1' : '0';

            return checksum;
        }

        function searchOnService(service, searchText, servicesListFields) {

            if (service.name && service.name.toLowerCase().indexOf(searchText.toLowerCase()) != -1) {
                return true;
            } else if (service.ganttLabel && service.ganttLabel.toLowerCase().indexOf(searchText.toLowerCase()) != -1) {
                return true;

                // TODO
                //} else if (service.serviceTypeName && service.serviceTypeName.toLowerCase().indexOf(searchText.toLowerCase()) != -1) {
                //    return true;
            } else if (service.accountName && service.accountName.toLowerCase().indexOf(searchText.toLowerCase()) != -1) {
                return true;
            } else if (service.resourceName && service.resourceName.toLowerCase().indexOf(searchText.toLowerCase()) != -1) {
                return true;
            } else if (service.id && service.id.toLowerCase().indexOf(searchText.toLowerCase()) != -1) {
                return true;
            } else if (service.serviceTerritoryName && service.serviceTerritoryName.toLowerCase().indexOf(searchText.toLowerCase()) != -1) {
                return true;
            } else if (service.status && service.status.toLowerCase().indexOf(searchText.toLowerCase()) != -1) {
                return true;
            }

            for (var i = 0; i < servicesListFields.length; i++) {
                if (servicesListFields[i].Type == utils.fieldsTypes.String || servicesListFields[i].Type == utils.fieldsTypes.TextArea || servicesListFields[i].Type == utils.fieldsTypes.Reference || servicesListFields[i].Type == utils.fieldsTypes.Picklist) {
                    if (service[servicesListFields[i].APIName] && service[servicesListFields[i].APIName].toLowerCase().indexOf(searchText.toLowerCase()) != -1) return true;
                }
            }

            return false;
        }

        function checkDates(item, selectedFiled, startDate, endDate) {

            var date = new Date(endDate);

            if (typeof selectedFiled.earlyStart != 'undefined' && selectedFiled.earlyStart && item.earlyStart && item.earlyStart > startDate && item.earlyStart <= date) {
                return true;
            } else if (typeof selectedFiled.dueDate != 'undefined' && selectedFiled.dueDate && item.dueDate && item.dueDate > startDate && item.dueDate <= date) {
                return true;
            } else if (typeof selectedFiled.appStart != 'undefined' && selectedFiled.appStart && item.appStart && item.appStart > startDate && item.appStart <= date) {
                return true;
            } else if (typeof selectedFiled.appEnd != 'undefined' && selectedFiled.appEnd && item.appEnd && item.appEnd > startDate && item.appEnd <= date) {
                return true;
            } else if (typeof selectedFiled.finish != 'undefined' && selectedFiled.finish && item.finish && item.finish > startDate && item.finish <= date) {
                return true;
            } else if (typeof selectedFiled.start != 'undefined' && selectedFiled.start && item.start && item.start > startDate && item.start <= date) {
                return true;
            } else if (typeof selectedFiled.display != 'undefined' && selectedFiled.display && item.ganttDisplay && item.ganttDisplay > startDate && item.ganttDisplay <= date) {
                return true;
            }

            return false;
        }

        function checkAdvanceFilterDates(advancedFilterObj, selectedFiled, item) {

            var minDate = new Date(advancedFilterObj.minDate);
            minDate.setHours(0);
            minDate.setMinutes(0);
            var maxDate = new Date(advancedFilterObj.maxDate);
            maxDate.setDate(maxDate.getDate() + 1);
            maxDate.setHours(0);
            maxDate.setMinutes(0);

            for (var dateFiled in selectedFiled) {

                if (selectedFiled[dateFiled] && checkDateBetweenDates(item, dateFiled, minDate, maxDate)) {

                    return true;
                }
            }

            return false;
        }

        function checkDateBetweenDates(item, dateType, minDate, maxDate) {
            if (typeof item[dateType] == 'undefined') return false;
            var date = item[dateType];

            if (date >= minDate && date <= maxDate) return true;

            return false;
        }

        function checkPriority(item, servicePriority) {
            return item.priority <= servicePriority;
        }

        function checkSelectFilter(item, advancedFilterObj) {

            if (item.jeopardy && !advancedFilterObj.jeopardies) return false;
            if (item.violations && !advancedFilterObj.violations) return false;
            if (item.start_date === null && !advancedFilterObj.unScheduled) return false;
            return true;
        }

        function checkCustomFilterLocations(service, locationsCheckboxs, noLocation) {
            if (noLocation && !service.location) return true;

            for (var territoryName in locationsCheckboxs) {
                if (service.serviceTerritoryName == territoryName && locationsCheckboxs[territoryName]) {
                    return true;
                }
            }

            return false;
        }

        function isStorageFilter(filterName) {

            if (userSettingsManager.GetUserSettingsProperty('Filters__c') == undefined) return null;

            var storageFilters = _typeof(userSettingsManager.GetUserSettingsProperty('Filters__c')) == "object" ? userSettingsManager.GetUserSettingsProperty('Filters__c') : JSON.parse(userSettingsManager.GetUserSettingsProperty('Filters__c'));

            for (var i = 0; i < storageFilters.length; i++) {
                if (storageFilters[i].name == filterName) return storageFilters[i].filter;
            }

            return null;
        }
    }]);
})();