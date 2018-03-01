(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
angular.module('picklistadmin')
.controller('PicklistAdminController', ['$scope', '$rootScope', '$location', '$timeout', '$compile', 'remoteActions', 'cpqService',
    function ($scope, $rootScope, $location, $timeout, $compile, remoteActions, cpqService) {
        $scope.OBJECT_NAME = 'Picklist__c';
        $scope.nsp = fileNsPrefix();
        $scope.picklistId = $location.search().id;
        $scope.picklistName = $location.search().name;
        $scope.mode = $location.search().mode;
        $scope.showFacetDetail = false;
        $scope.maximizeFacetDetail = false;
        $scope.facets = [];
        $scope.sectionElementFields = [];
        $scope.objectFields = null;
        $scope.objectPicklists = {};
        $scope.picklist = {};
        $scope.editObject = {};
        $scope.attrMap = {};
        $scope.attrObjMap = {};
        $scope.attrAssgnObjMap = {};
        $scope.picklistItems = [];
        $scope.selectedItem = null;

        $scope.$on('refreshItems', function() {
            $scope.getPicklistItems($scope.picklistId);
        });

        $scope.$on('showItemDetails', function(event, item) {
            $scope.openFacetDetails(item);
        });

        $scope.$on('hideItemDetails', function() {
            $scope.closeFacetDetails();
        });

        $scope.getObjectLayoutByName = function(objectName, recordType) {
            var inputMap = {
                'objectName' : objectName,
                'recordType' : recordType
            };
            remoteActions.invokeMethod('getObjectLayoutByName', JSON.stringify(inputMap)).then(function(results) {
                console.log('getObjectLayoutByName productClass results: ', results);
                $scope.buildObjectLayout(results);
            }, function(error) {
                cpqService.showNotification({
                    type: 'error',
                    title: 'Error',
                    content: error.message
                });
            });
        };

        $scope.getObjectLayoutById = function(objectId, forSelf) {
            var inputMap = {
                'objectId' : objectId,
                'isInherited' : forSelf
            };
            remoteActions.invokeMethod('getObjectLayoutById', JSON.stringify(inputMap)).then(function(results) {
                console.log('getObjectLayoutById picklist results: ', results);
                $scope.buildObjectLayout(results);
            }, function(error) {
                cpqService.showNotification({
                    type: 'error',
                    title: 'Error',
                    content: error.message
                });
            });
        };

        $scope.describeObject = function(objectName) {
            var inputMap = { 'objectName' : objectName };
            remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                console.log('describeObject picklist results: ', results);
                $scope.objectFields = results;
            }, function(error) {
                cpqService.showNotification({
                    type: 'error',
                    title: 'Error',
                    content: error.message
                });
            });
        };

        $scope.getObjectFieldsAndLayoutById = function(objectId, forSelf) {
            var inputMap = {
                'objectId' : objectId,
                'isInherited' : forSelf
            };
            remoteActions.invokeMethod('getObjectLayoutById', JSON.stringify(inputMap)).then(function(results) {
                $scope.buildObjectLayout(results);
                var inputMap = {
                    'objectId' : objectId,
                    'fieldNames' : JSON.stringify($scope.sectionElementFields)
                };
                remoteActions.invokeMethod('describeObjectFieldsById', JSON.stringify(inputMap)).then(function(results) {
                    $scope.objectFields = results;
                    console.log('getObjectFieldsAndLayoutById picklist results:  ', results);
                }, function(err) {
                    cpqService.showNotification({
                        type: 'error',
                        title: 'Error',
                        content: err.message
                    });
                });
            }, function(error) {
                cpqService.showNotification({
                    type: 'error',
                    title: 'Error',
                    content: error.message
                });
            });
        };

        $scope.buildObjectLayout = function(results) {
            $scope.objFacets = results.facets;
            $scope.objectLayoutId = results.objLayout.Id;
            $scope.facets = [];
            if (j$.isArray($scope.objFacets) && $scope.objFacets.length > 0) {
                angular.forEach($scope.objFacets, function(facet, idx) {
                    facet.hasSectionCustomView = false;
                    facet.active = (idx === 0);
                    angular.forEach(facet.sections, function(section) {
                        if (section.facetSectionObj[$scope.nsp + 'ViewType__c'] === 'Custom View') {
                            section.hasCustomView = true;
                            facet.hasSectionCustomView = true;
                        }
                        else {
                            angular.forEach(section.sectionElements, function(sectionElement) {
                                if (sectionElement[$scope.nsp + 'FieldApiName__c'] != null) {
                                    $scope.sectionElementFields.push(sectionElement[$scope.nsp + 'FieldApiName__c']);
                                }
                            });
                        }
                    });
                    $scope.facets.push(facet);
                });
            }
            console.log('FACETS for picklist: ', $scope.facets);
        };

        $scope.getObjectPicklistsByName = function(objectName) {
            var inputMap = { 'objectName' : objectName };
            remoteActions.invokeMethod('getObjectPicklistsByName', JSON.stringify(inputMap)).then(function(results) {
                $scope.objectPicklists = {};
                for (var key in results) {
                    if (key.endsWith('__c')) {
                        $scope.objectPicklists[$scope.nsp + key] = results[key];
                    } else {
                        $scope.objectPicklists[key] = results[key];
                    }
                }
                console.log('getObjectPicklistsByName results:', $scope.objectPicklists);
            }, function(error) {
                cpqService.showNotification({
                    type: 'error',
                    title: 'Error',
                    content: error.message
                });
            });
        };

        $scope.getObject = function(picklistId) {
            var inputMap = { 'objectId' : picklistId };
            remoteActions.invokeMethod('getObject', JSON.stringify(inputMap)).then(function(results) {
                console.log('getObject results: ', results);
                $scope.picklist = results;
                $scope.editObject = {};
                for (var key in $scope.picklist) {
                    $scope.editObject[key] = $scope.picklist[key];
                }
            }, function(error) {
                cpqService.showNotification({
                    type: 'error',
                    title: 'Error',
                    content: error.message
                });
            });
        };

        $scope.gotoFacet = function(facet) {
            $scope.closeFacetDetails(); // close the facet details section, if open
            if (!facet.active) {
                angular.forEach($scope.facets, function(f) {
                    f.active = (f.facetObj.Id === facet.facetObj.Id);
                });
            }
        };

        $scope.getPicklistItems = function(picklistId) {
            var inputMap = { 'picklistId' : picklistId };
            remoteActions.invokeMethod('getPicklistItems', JSON.stringify(inputMap)).then(function(results) {
                console.log('getPicklistItems results: ', results);
                $scope.picklistItems = results;
                $rootScope.$broadcast('setItems', $scope.picklistItems);
            }, function(error) {
                cpqService.showNotification({
                    type: 'error',
                    title: 'Error',
                    content: error.message
                });
            });
        };

        $scope.openFacetDetails = function(picklistItem) {
            $scope.selectedItem = picklistItem;
            var compiledHTML = $compile('<vloc-picklist-item item="selectedItem" parent-item="picklist" hide-item-details="closeFacetDetails"></vloc-picklist-item>')($scope);
            j$('#facet-detail-content').html(compiledHTML);
            $scope.showFacetDetail = true;
        };

        $scope.closeFacetDetails = function() {
            $scope.maximizeFacetDetail = false;
            $scope.showFacetDetail = false;
            $rootScope.$broadcast('setSelectedItem', null);
            j$('#facet-detail-content').html('');
        };

        $scope.saveObject = function(event) {
            var originalText;
            if (event) {
                originalText = event.currentTarget.innerText;
                event.currentTarget.disabled = true;
                event.currentTarget.innerText = 'Saving...';
            }

            var itemToSave = {};
            for (var key in $scope.editObject) {
                if (key !== '$$hashKey') {
                    itemToSave[key] = ($scope.editObject[key] === null ? undefined : $scope.editObject[key]);
                }
            }

            var inputMap = { 'so' : JSON.stringify(itemToSave) };
            remoteActions.invokeMethod('updateObject', JSON.stringify(inputMap)).then(function(results) {
                console.log('save picklist results: ', results);
                $scope.picklist = {};
                $scope.editObject = {};
                for (var key in results) {
                    if ($scope.objectFields[key] && $scope.objectFields[key].type === 'DATE') {
                        var tzOffset = (window.userTimezoneOffset || window.parent.userTimezoneOffset);
                        $scope.picklist[key] = results[key] + tzOffset;
                        $scope.editObject[key] = results[key] + tzOffset;
                    } else {
                        $scope.picklist[key] = results[key];
                        $scope.editObject[key] = results[key];
                    }
                }
                if (event) {
                    event.currentTarget.innerText = originalText;
                    event.currentTarget.disabled = false;
                }
                cpqService.showNotification({
                    type: 'success',
                    content: 'Picklist saved!',
                    autohide: true
                });
            }, function(error) {
                cpqService.showNotification({
                    type: 'error',
                    title: 'Error',
                    content: error.message
                });
                if (event) {
                    event.currentTarget.innerText = 'Error!';
                    $timeout(function() {
                        event.currentTarget.innerText = originalText;
                        event.currentTarget.disabled = false;
                    }, 5000);
                }
            });
        };

        $scope.setupViewAttrs = function(section) {
            return {
                'name': section.facetSectionObj[$scope.nsp + 'ViewUri__c'],
                'attrs': {
                    'parentObj': $scope.picklist,
                    'items': $scope.picklistItems
                }
            };
        };

        $scope.init = function() {
            $scope.getObjectPicklistsByName($scope.nsp + $scope.OBJECT_NAME);

            if ($scope.mode === 'new') {
                $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                $scope.picklistName = 'New Picklist';
                $scope.getObjectLayoutByName($scope.OBJECT_NAME, '');
            } else {
                $scope.getObjectFieldsAndLayoutById($scope.picklistId, true);
                $scope.getObject($scope.picklistId);
                $scope.getPicklistItems($scope.picklistId);
            }
        };
        $scope.init();
    }
]);

},{}],2:[function(require,module,exports){
angular.module('picklistadmin')
.directive('vlocPicklistItem', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                item: '=',
                parentItem: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'PicklistItem.tpl.html',
            controller: function($scope, $rootScope, $timeout) {
                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = 'PicklistValue__c';
                $scope.editItem = {};
                $scope.facets = [];

                $scope.getObjectLayoutByName = function(objectName, recordType) {
                    var inputMap = { 
                        'objectName' : objectName,
                        'recordType' : recordType
                    };
                    remoteActions.invokeMethod('getObjectLayoutByName', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getObjectLayoutByName picklist item results: ', results);
                        $scope.buildObjectLayout(results);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getObjectLayoutById = function(objectId, forSelf) {
                    var inputMap = { 
                        'objectId' : objectId,
                        'isInherited' : forSelf
                    };
                    remoteActions.invokeMethod('getObjectLayoutById', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getObjectLayoutById picklist item results: ', results);
                        $scope.buildObjectLayout(results);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.buildObjectLayout = function(results) {
                    $scope.objFacets = results.facets;
                    $scope.objectLayoutId = results.objLayout.Id;
                    $scope.facets = [];
                    if (j$.isArray($scope.objFacets) && $scope.objFacets.length > 0) {
                        angular.forEach($scope.objFacets, function(facet, idx) {
                            facet.hasSectionCustomView = false;
                            facet.active = (idx === 0);
                            angular.forEach(facet.sections, function(section) {
                                if (section.facetSectionObj[$scope.nsp + 'ViewType__c'] === 'Custom View') {
                                    section.hasCustomView = true;
                                    facet.hasSectionCustomView = true;
                                }
                            });
                            $scope.facets.push(facet);
                        });
                    }
                    console.log('FACETS for picklist item: ', $scope.facets);
                };

                $scope.describeObject = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('describeObject picklistlist item results: ', results);
                        $scope.objectFields = results;
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getObjectPicklistsByName = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('getObjectPicklistsByName', JSON.stringify(inputMap)).then(function(results) {
                        $scope.objectPicklists = {};
                        for (var key in results) {
                            if (key.endsWith('__c')) {
                                $scope.objectPicklists[$scope.nsp + key] = results[key];
                            } else {
                                $scope.objectPicklists[key] = results[key];
                            }
                        }
                        console.log('getObjectPicklistsByName results:', $scope.objectPicklists);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.closeDetails = function() {
                    $rootScope.$broadcast('hideItemDetails');
                };

                $scope.createItem = function(event) {
                    var originalText;
                    if (event) {
                        originalText = event.currentTarget.innerText;
                        event.currentTarget.disabled = true;
                        event.currentTarget.innerText = 'Saving...';
                    }

                    var itemToSave = {};
                    for (var key in $scope.editItem) {
                        if (key !== '$$hashKey') {
                            itemToSave[key] = $scope.editItem[key];
                        }
                    }

                    var inputMap = { 
                        'objectName' : $scope.nsp + $scope.OBJECT_NAME,
                        'inputMap' : itemToSave
                    };
                    remoteActions.invokeMethod('createObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('create picklist item results: ', results);
                        $rootScope.$broadcast('refreshItems');
                        if (event) {
                            event.currentTarget.innerText = originalText;
                            event.currentTarget.disabled = false;
                        }
                        $scope.closeDetails();
                        //TODO: show save success message
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                        if (event) {
                            event.currentTarget.innerText = 'Error!';
                            $timeout(function() {
                                event.currentTarget.innerText = originalText;
                                event.currentTarget.disabled = false;
                            }, 5000);
                        }
                    });
                };

                $scope.saveItem = function(event) {
                    var originalText;
                    if (event) {
                        originalText = event.currentTarget.innerText;
                        event.currentTarget.disabled = true;
                        event.currentTarget.innerText = 'Saving...';
                    }

                    var itemToSave = {};
                    for (var key in $scope.editItem) {
                        if (key !== '$$hashKey') {
                            itemToSave[key] = ($scope.editItem[key] === null ? undefined : $scope.editItem[key]);
                        }
                    }

                    var inputMap = { 'so' : JSON.stringify(itemToSave) };
                    remoteActions.invokeMethod('updateObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('save picklist item results: ', results);
                        $rootScope.$broadcast('refreshItems');
                        $scope.item = {};
                        for (var key in results) {
                            if ($scope.objectFields[key] && $scope.objectFields[key].type === 'DATE') {
                                var tzOffset = (window.userTimezoneOffset || window.parent.userTimezoneOffset);
                                $scope.item[key] = results[key] + tzOffset;
                            } else {
                                $scope.item[key] = results[key];
                            }
                        }
                        if (event) {
                            event.currentTarget.innerText = originalText;
                            event.currentTarget.disabled = false;
                        }
                        //TODO: show save success message
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                        if (event) {
                            event.currentTarget.innerText = 'Error!';
                            $timeout(function() {
                                event.currentTarget.innerText = originalText;
                                event.currentTarget.disabled = false;
                            }, 5000);
                        }
                    });
                };

                $scope.init = function() {
                    if ($scope.item.Id === undefined) {
                        $scope.getObjectLayoutByName($scope.OBJECT_NAME, '');

                        $scope.editItem[$scope.nsp + 'PicklistId__c'] = $scope.parentItem.Id;
                    } else {
                        $scope.getObjectLayoutById($scope.item.Id, true);

                        for (var key in $scope.item) {
                            if (key !== '$$hashKey') {
                                $scope.editItem[key] = $scope.item[key];
                            }
                        }
                    }
                    $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                    $scope.getObjectPicklistsByName($scope.nsp + $scope.OBJECT_NAME);
                };
                $scope.init();
            }
        };
    }
]);

},{}],3:[function(require,module,exports){
angular.module('picklistadmin')
.directive('vlocPicklistItems', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'PicklistItems.tpl.html',
            controller: function($scope, $rootScope, $sldsModal) {
                console.log('INIT: ', $scope.customViewAttrs);
                $scope.parentObj = $scope.customViewAttrs.parentObj;
                $scope.items = $scope.customViewAttrs.items;

                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = 'PicklistValue__c';

                $scope.$on('setItems', function(event, items) {
                    $scope.items = items;
                });

                $scope.$on('setSelectedItem', function(event, item) {
                    $scope.selectedItem = item;
                });

                $scope.selectItem = function(item) {
                    $scope.selectedItem = item;
                    $rootScope.$broadcast('showItemDetails', item);
                };

                $scope.editItem = function(item, event) {
                    if (event) {
                        event.stopPropagation();
                    }
                    $scope.selectItem(item);
                };

                $scope.deleteItem = function(item, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    var modalScope = $scope.$new();
                    modalScope.confirmationTitle = 'Delete Picklist Item';
                    modalScope.confirmationMsg = 'Are you sure you want to delete the picklist item <i>' + item[$scope.nsp + 'DisplayText__c'] + '</i>?';
                    modalScope.cancelActionLbl = 'Cancel';
                    modalScope.confirmActionLbl = 'Delete';
                    modalScope.confirmAction = function() {
                        var itemToDelete = {};
                        for (var key in item) {
                            if (key !== '$$hashKey') {
                                itemToDelete[key] = item[key];
                            }
                        }
                        var inputMap = { 'objectId' : itemToDelete.Id };
                        remoteActions.invokeMethod('deleteObject', JSON.stringify(inputMap)).then(function(results) {
                            console.log('delete picklist item results: ', results);
                            $rootScope.$broadcast('refreshItems');
                            $rootScope.$broadcast('hideItemDetails');
                            deleteModal.hide();
                            //TODO: show delete success message
                        }, function(error) {
                            cpqService.showNotification({
                                type: 'error',
                                title: 'Error',
                                content: error.message
                            });
                            deleteModal.hide();
                        });
                    };

                    var deleteModal = $sldsModal({
                        templateUrl: 'ConfirmationModal.tpl.html',
                        backdrop: 'static',
                        scope: modalScope,
                        show: true
                    });
                };

                $scope.newItem = function() {
                    $scope.newPicklistItem = {};
                    $rootScope.$broadcast('showItemDetails', $scope.newPicklistItem);
                };

                $scope.describeObject = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('describeObject picklist item results: ', results);
                        $scope.objectFields = results;
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getFieldSetsByName = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('getFieldSetsByName', JSON.stringify(inputMap)).then(function(results) {
                        if (results[$scope.nsp.toLowerCase() + 'picklistitems'] === undefined) {
                            $scope.fieldSet = null;
                        } else {
                            $scope.fieldSet = results[$scope.nsp.toLowerCase() + 'picklistitems'];
                        }
                        console.log('getFieldSets results: ', $scope.fieldSet);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.init = function() {
                    $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                    $scope.getFieldSetsByName($scope.nsp + $scope.OBJECT_NAME);
                };
                $scope.init();
            }
        };
    }
]);

},{}],4:[function(require,module,exports){
angular.module("picklistadmin").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("PicklistItem.tpl.html",'<div class="vloc-picklist-item">\n    <div class="vloc-facet">\n        <section class="vloc-section">\n            <h3 class="slds-text-heading--label">General Properties</h3>\n            <div class="vloc-section-body slds-form--horizontal">\n                <div ng-if="(parentItem[nsp+\'DataType__c\'] === \'Text\')" class="slds-form-element">\n                    <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">Text Value</label>\n                    <div class="slds-form-element__control">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="nsp+\'TextValue__c\'" field-info="objectFields[nsp+\'TextValue__c\']" obj-picklists=""></vloc-obj-field>\n                    </div>\n                </div>\n                <div ng-if="(parentItem[nsp+\'DataType__c\'] === \'Number\')" class="slds-form-element">\n                    <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">Number Value</label>\n                    <div class="slds-form-element__control">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="nsp+\'NumberValue__c\'" field-info="objectFields[nsp+\'NumberValue__c\']" obj-picklists=""></vloc-obj-field>\n                    </div>\n                </div>\n                <div ng-if="(parentItem[nsp+\'DataType__c\'] === \'Number\')" class="slds-form-element">\n                    <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">Unit Of Measure</label>\n                    <div class="slds-form-element__control">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="nsp+\'UnitOfMeasureName__c\'" field-info="objectFields[nsp+\'UnitOfMeasureName__c\']" obj-picklists=""></vloc-obj-field>\n                    </div>\n                </div>\n                <div ng-if="(parentItem[nsp+\'DataType__c\'] === \'Boolean\')" class="slds-form-element">\n                    <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">Boolean Value</label>\n                    <div class="slds-form-element__control">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="nsp+\'BooleanValue__c\'" field-info="objectFields[nsp+\'BooleanValue__c\']" obj-picklists=""></vloc-obj-field>\n                    </div>\n                </div>\n                <div ng-if="(parentItem[nsp+\'DataType__c\'] === \'Date\')" class="slds-form-element">\n                    <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">Date Value</label>\n                    <div class="slds-form-element__control">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="nsp+\'DateValue__c\'" field-info="objectFields[nsp+\'DateValue__c\']" obj-picklists=""></vloc-obj-field>\n                    </div>\n                </div>\n                <div ng-if="(parentItem[nsp+\'DataType__c\'] === \'Date Time\')" class="slds-form-element">\n                    <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">Date Time Value</label>\n                    <div class="slds-form-element__control">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="nsp+\'DateTimeValue__c\'" field-info="objectFields[nsp+\'DateTimeValue__c\']" obj-picklists=""></vloc-obj-field>\n                    </div>\n                </div>\n                <div class="slds-form-element">\n                    <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">Label</label>\n                    <div class="slds-form-element__control">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="\'Name\'" field-info="objectFields[\'Name\']" obj-picklists=""></vloc-obj-field>\n                    </div>\n                </div>\n                <div class="slds-form-element">\n                    <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">Code</label>\n                    <div class="slds-form-element__control">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="nsp+\'Code__c\'" field-info="objectFields[nsp+\'Code__c\']" obj-picklists=""></vloc-obj-field>\n                    </div>\n                </div>\n                <div class="slds-form-element">\n                    <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">Abbreviation</label>\n                    <div class="slds-form-element__control">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="nsp+\'Abbreviation__c\'" field-info="objectFields[nsp+\'Abbreviation__c\']" obj-picklists=""></vloc-obj-field>\n                    </div>\n                </div>\n                <div class="slds-form-element">\n                    <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">Sequence</label>\n                    <div class="slds-form-element__control">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="nsp+\'Sequence__c\'" field-info="objectFields[nsp+\'Sequence__c\']" obj-picklists=""></vloc-obj-field>\n                    </div>\n                </div>\n            </div>\n        </section>\n        <section class="vloc-section">\n            <h3 class="slds-text-heading--label">Effectivity</h3>\n            <div class="vloc-section-body slds-form--horizontal">\n                <div class="slds-form-element">\n                    <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">Active</label>\n                    <div class="slds-form-element__control">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="nsp+\'IsActive__c\'" field-info="objectFields[nsp+\'IsActive__c\']" obj-picklists=""></vloc-obj-field>\n                    </div>\n                </div>\n                <div class="slds-form-element">\n                    <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">Effective From</label>\n                    <div class="slds-form-element__control">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="nsp+\'EffectiveFromDate__c\'" field-info="objectFields[nsp+\'EffectiveFromDate__c\']" obj-picklists=""></vloc-obj-field>\n                    </div>\n                </div>\n                <div class="slds-form-element">\n                    <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">Effective Until</label>\n                    <div class="slds-form-element__control">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="nsp+\'EffectiveUntilDate__c\'" field-info="objectFields[nsp+\'EffectiveUntilDate__c\']" obj-picklists=""></vloc-obj-field>\n                    </div>\n                </div>\n            </div>\n        </section>\n        <div class="slds-form-element__row form-buttons slds-text-align--right">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="closeDetails()">Cancel</button>\n            <button type="button" class="slds-button slds-button--brand" ng-if="item.Id === undefined" ng-click="createItem($event)">Save</button>\n            <button type="button" class="slds-button slds-button--brand" ng-if="item.Id !== undefined" ng-click="saveItem($event)">Save</button>\n        </div>\n    </div>\n</div>'),$templateCache.put("PicklistItems.tpl.html",'<div class="vloc-picklist-items">\n    <h3 class="slds-text-heading--small">Picklist Items</h3>\n    <div class="vloc-section-actions">\n        <button type="button" class="slds-button slds-button--neutral" ng-click="newItem()">New Item</button>\n    </div>\n    <div class="slds-scrollable--x">\n        <table class="slds-table slds-table--bordered items">\n            <thead>\n                <tr class="slds-text-heading--label">\n                    <th class="actions"><div class="slds-truncate">&nbsp;</div></th>\n                    <th ng-repeat="field in fieldSet">\n                        <div class="slds-truncate">{{objectFields[field.fieldPath].label}}</div>\n                    </th>\n                </tr>\n            </thead>\n            <tbody>\n                <tr ng-class="{\'slds-is-selected\': (item.Id === selectedItem.Id)}" ng-repeat="item in items" ng-click="selectItem(item)">\n                    <td class="actions">\n                        <button class="slds-button slds-button--icon" ng-click="editItem(item, $event)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'edit\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Edit</span>\n                        </button>\n                        <button class="slds-button slds-button--icon" ng-click="deleteItem(item, $event)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Delete</span>\n                        </button>\n                    </td>\n                    <td ng-repeat="field in fieldSet">\n                        <vloc-obj-field display-mode="\'view\'" parent-obj="item" field-name="field.fieldPath" field-info="objectFields[field.fieldPath]" obj-picklists=""></vloc-obj-field>\n                    </td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n</div>')}]);
},{}],5:[function(require,module,exports){
angular.module('picklistadmin', ['vlocity', 'ngSanitize', 'cpqdirectives', 'sldsangular'])
.config(['remoteActionsProvider', function(remoteActionsProvider) {
    remoteActionsProvider.setRemoteActions(window.remoteActions || {});
}])
.config(['$locationProvider', function($locationProvider) {
    $locationProvider.html5Mode(true);
}]);

require('./modules/picklistadmin/controller/PicklistAdminController.js');
require('./modules/picklistadmin/directive/VlocPicklistItem.js');
require('./modules/picklistadmin/directive/VlocPicklistItems.js');
require('./modules/picklistadmin/templates/templates.js');

},{"./modules/picklistadmin/controller/PicklistAdminController.js":1,"./modules/picklistadmin/directive/VlocPicklistItem.js":2,"./modules/picklistadmin/directive/VlocPicklistItems.js":3,"./modules/picklistadmin/templates/templates.js":4}]},{},[5]);

})();