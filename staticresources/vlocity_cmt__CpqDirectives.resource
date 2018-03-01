(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
angular.module('cpqdirectives')
.controller('NewObjectRecordController', ['$scope', '$location', 'remoteActions', '$timeout', 'cpqService',
    function ($scope, $location, remoteActions, $timeout,cpqService) {
        $scope.nsp = fileNsPrefix();
        $scope.objectLabel = $location.search().label;
        $scope.objectName = $location.search().objName;
        $scope.objectId = $location.search().objId;
        $scope.recordType = $location.search().recordType;
        $scope.editItem = {};

        $scope.hasObjectTypes = false;
        $scope.objectTypes = [];
        $scope.objTypeSelect = {
            isCreateable: true,
            isUpdateable: true,
            isRequired: false,
            label: 'objectType',
            type: 'OTPICKLIST',
        };

        $scope.getFieldSetsByName = function() {
            var inputMap = { 'objectName' : $scope.objectName };
            remoteActions.invokeMethod('getFieldSetsByName', JSON.stringify(inputMap)).then(function(results) {
                console.log('getFieldSets ' + $scope.objectName + $scope.recordType + ': ', results);
                var fsKey = $scope.nsp.toLowerCase() + 'new' + $scope.objectId;
                if (results[fsKey] === undefined) {
                    $scope.fieldSet = null;
                } else {
                    $scope.fieldSet = results[fsKey];
                }
            }, function(error) {
                cpqService.showNotification({
                    type: 'error',
                    title: 'Error',
                    content: error.message
                });
            });
        };

        $scope.describeObject = function() {
            var inputMap = { 'objectName' : $scope.objectName };
            remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                console.log('describeObject ' + $scope.objectName + ': ', results);
                $scope.objectFields = results;
            }, function(error) {
                cpqService.showNotification({
                    type: 'error',
                    title: 'Error',
                    content: error.message
                });
            });
        };

        $scope.getObjectPicklistsByName = function() {
            var inputMap = { 'objectName' : $scope.objectName };
            remoteActions.invokeMethod('getObjectPicklistsByName', JSON.stringify(inputMap)).then(function(results) {
                $scope.objectPicklists = {};
                for (var key in results) {
                    if (key.endsWith('__c')) {
                        $scope.objectPicklists[$scope.nsp + key] = results[key];
                    } else {
                        $scope.objectPicklists[key] = results[key];
                    }
                }
                console.log('getObjectPicklistsByName ' + $scope.objectName + ': ', $scope.objectPicklists);
            }, function(error) {
                cpqService.showNotification({
                    type: 'error',
                    title: 'Error',
                    content: error.message
                });
            });
        };

        $scope.saveItem = function(event) {
            var itemToSave = {};
            for (var key in $scope.editItem) {
                if (key !== '$$hashKey') {
                    itemToSave[key] = $scope.editItem[key];
                }
            }
            $scope.createItem(event, itemToSave);
        };

        $scope.createItem = function(event, itemToSave) {
            var originalText;
            if (event) {
                originalText = event.currentTarget.innerText;
                event.currentTarget.disabled = true;
                event.currentTarget.innerText = 'Saving...';
            }

            var inputMap = {
                'objectName' : $scope.objectName,
                'inputMap' : itemToSave
            };
            remoteActions.invokeMethod('createObject', JSON.stringify(inputMap)).then(function(results) {
                console.log('create object ' + $scope.objectName + ': ', results);
                if (event) {
                    event.currentTarget.innerText = originalText;
                    event.currentTarget.disabled = false;
                }

                cpqService.showNotification({
                    type: 'success',
                    content: $scope.objectLabel + ' created!',
                    autohide: true
                });

                $scope.launchTab(results);
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

        $scope.launchTab = function(item) {
            var data = {
                'objectId': $scope.objectId,
                'obj': item,
                'closeCurrentTab': true
            };
            var broadcastAction = {
                'eventName': 'launchConsoleTab',
                'eventData': data
            };
            if (window.frameElement !== null) {
                // create a iframe resize event binding with the parent
                window.parent.bindIframeEvents('broadcast', broadcastAction);
            }
        };

        $scope.getObjectTypes = function(item) {
            $scope.objectTypes = [];
            var inputMap = { 'objectName' : item };
            remoteActions.invokeMethod('getObjectClassTypesByName', JSON.stringify(inputMap)).then(function(results) {
                angular.forEach(results, function(type) {
                    $scope.objectTypes.push({label: type.Name, value: type.Id});
                });
                console.log('getObjectTypes result:', $scope.objectTypes);

                if (results.length > 0) {
                    $scope.hasObjectTypes = true;
                }
            }, function(error) {
                cpqService.showNotification({
                    type: 'error',
                    title: 'Error',
                    content: error.message
                });
            });
        };

        $scope.init = function() {
            $scope.getFieldSetsByName();
            $scope.describeObject();
            $scope.getObjectPicklistsByName();
            $scope.getObjectTypes($scope.objectName);
        };
        $scope.init();
    }
]);

},{}],2:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocAssignAttrsFields', ['$rootScope', 'remoteActions', 'cpqService',
    function($rootScope, remoteActions, cpqService) {
        return {
            scope: {
                objectId: '=',
                assignedItems: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'AssignAttrsFields.tpl.html',
            controller: function($scope) {
                $scope.nsp = fileNsPrefix();

                $scope.getAttributeFieldBindingData = function() {
                    $scope.AttrObjMap = {};
                    $scope.AttrAssgnObjMap = {};
                    $scope.attributeMap = {};
                    $scope.fieldMap = {};
                    $scope.items = [];
                    $scope.attrList = [];
                    $scope.fieldList = [];
                    $scope.allSelected = false;
                    $scope.selectedCount = 0;

                    var inputMap = { 
                        'objectId' : $scope.objectId,
                        'allObjectAttributes' : true
                    };
                    remoteActions.invokeMethod('getAttributeFieldBindingData', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getAttributeFieldBindingData results: ', results);
                        $scope.bindings = results.AttributeBinding__c;
                        $scope.fields = results.Field;
                        $scope.parseAAWrapper(results.AAWrapper);

                        var boundAttrMap = {};
                        var boundFieldMap = {};
                        angular.forEach($scope.bindings, function(binding) {
                            var attrId = binding[$scope.nsp + 'AttributeId__c'];
                            var attrObj = $scope.attributeMap[attrId];
                            var attrName = attrObj.Name;
                            var attrCode = attrObj.Code;
                            var fieldName = binding[$scope.nsp + 'FieldApiName__c'];
                            boundAttrMap[attrId] = {'Name': fieldName, 'Label': $scope.fields[fieldName].label};
                            boundFieldMap[fieldName] = {'Id': attrId, 'Name': attrName, 'Code': attrCode};
                        });
                        angular.forEach($scope.attributes, function(attr) {
                            var item = {};
                            item.isSelected = false;
                            item.attrId = attr.Id;
                            item.attrName = attr.Name;
                            item.attrCode = attr.Code;

                            if (boundAttrMap[attr.Id] === undefined) {
                                item.bound = false;
                                item.fieldName = '';
                                item.fieldLabel = '';
                            } else {
                                item.bound = true;
                                item.fieldName = boundAttrMap[attr.Id].Name;
                                item.fieldLabel = boundAttrMap[attr.Id].Label;
                            }

                            if ($scope.assignedItems[attr.Id] === undefined) {
                                $scope.attrList.push(item);
                                $scope.items.push(item);
                            }
                        });
                        for (var fieldName in $scope.fields) {
                            var field = {'name': fieldName, 'label': $scope.fields[fieldName].label};
                            var item = {};
                            item.isSelected = false;
                            item.fieldName = fieldName;
                            item.fieldLabel = field.label;

                            if (boundFieldMap[fieldName] === undefined) {
                                item.bound = false;
                                item.attrId = '';
                                item.attrName = '';
                                item.attrCode = '';
                                if ($scope.assignedItems[fieldName] === undefined) {
                                    $scope.items.push(item);
                                }
                            } else {
                                item.bound = true;
                                item.attrId = boundFieldMap[fieldName].Id;
                                item.attrName = boundFieldMap[fieldName].Name;
                                item.attrCode = boundFieldMap[fieldName].Code;
                            }

                            if ($scope.assignedItems[fieldName] === undefined) {
                                $scope.fieldList.push(item);
                            }
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.parseAAWrapper = function(aList) {
                    $scope.attributes = [];
                    angular.forEach(aList, function(aItem) {
                        var attr = {};
                        if (aItem.attributeAssignment) {
                            // use attribute assignment
                            attr.aaId = aItem.attributeAssignment.Id;
                            attr.Id = aItem.attributeAssignment[$scope.nsp + 'AttributeId__c'];
                            attr.Name = aItem.attributeAssignment[$scope.nsp + 'AttributeDisplayName__c'];
                            attr.Code = aItem.attributeAssignment[$scope.nsp + 'AttributeUniqueCode__c'];
                            $scope.AttrAssgnObjMap[attr.Id] = aItem.attributeAssignment;
                        } else {
                            // use attribute
                            attr.Id = aItem.attribute.Id;
                            attr.Name = aItem.attribute.Name;
                            attr.Code = aItem.attribute[$scope.nsp + 'Code__c'];
                            $scope.AttrAssgnObjMap[attr.Id] = null;
                        }
                        $scope.AttrObjMap[attr.Id] = aItem.attribute;
                        $scope.attributeMap[attr.Id] = attr;
                        $scope.attributes.push(attr);
                    });
                };

                $scope.selectAll = function() {
                    angular.forEach($scope.items, function(item) {
                        item.isSelected = $scope.allSelected;
                        $scope.selectItem(item);
                    });
                    $scope.selectedCount = ($scope.allSelected ? $scope.items.length : 0);
                };

                $scope.selectItem = function(item) {
                    if (item.isSelected) {
                        $scope.selectedCount++;
                    } else {
                        $scope.selectedCount--;
                        $scope.allSelected = false;
                    }
                };

                $scope.assignItems = function() {
                    var selectedAttrList = [];
                    var selectedFieldList = [];
                    angular.forEach($scope.items, function(item) {
                        if (item.isSelected) {
                            if (item.bound) {
                                selectedAttrList.push(item.attrId);
                            } else if (item.fieldName === '') {
                                selectedAttrList.push(item.attrId);
                            } else {
                                selectedFieldList.push(item.fieldName);
                            }
                        }
                    });
                    var inputMap = { 
                        'objectId' : $scope.objectId,
                        'fieldNames' : JSON.stringify(selectedFieldList),
                        'attributeIds' : JSON.stringify(selectedAttrList)
                    };
                    remoteActions.invokeMethod('applyFieldAttribute', JSON.stringify(inputMap)).then(function(results) {
                        console.log('applyFieldAttribute results: ', results);
                        $rootScope.$broadcast('refreshItems');
                        $rootScope.$broadcast('hideItemDetails');
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.init = function() {
                    $scope.getAttributeFieldBindingData();
                };
                $scope.init();
            }
        };
    }
]);

},{}],3:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocAttachment', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                item: '=',
                parentItem: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'Attachment.tpl.html',
            controller: function($scope, $rootScope, $timeout) {
                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = 'VlocityAttachment__c';
                $scope.editObject = {};
                $scope.attrMap = {};
                $scope.attrObjMap = {};
                $scope.attrAssgnObjMap = {};
                $scope.facets = [];

                $scope.getObjectLayoutByName = function(objectName, recordType) {
                    var inputMap = { 
                        'objectName' : objectName,
                        'recordType' : recordType
                    };
                    remoteActions.invokeMethod('getObjectLayoutByName', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getObjectLayoutByName attachment item results: ', results);
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
                        console.log('getObjectLayoutById attachment item results: ', results);
                        $scope.buildObjectLayout(results);
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
                        console.log('getObjectPicklistsByName  results:', $scope.objectPicklists);
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
                    console.log('FACETS for attachments: ', $scope.facets);
                };

                $scope.describeObject = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('describeObject attachment item results: ', results);
                        $scope.objectFields = results;
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
                    console.log('editItem:: ', $scope.editObject);
                    for (var key in $scope.editObject) {
                        if (key !== '$$hashKey') {
                            itemToSave[key] = $scope.editObject[key];
                        }
                    }

                    var inputMap = { 
                        'objectName' : $scope.nsp + $scope.OBJECT_NAME,
                        'inputMap' : itemToSave
                    };
                    remoteActions.invokeMethod('createObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('create attachment item results: ', results);
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
                    console.log('save attachment editItem',$scope.editObject);
                    for (var key in $scope.editObject) {
                        if (key !== '$$hashKey') {
                            itemToSave[key] = ($scope.editObject[key] === null ? undefined : $scope.editObject[key]);
                        }
                    }

                    var inputMap = { 'so' : JSON.stringify(itemToSave) };
                    remoteActions.invokeMethod('updateObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('save attachment item results: ', results);
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

                $scope.init = function() {
                    if ($scope.item.Id === undefined) {
                        $scope.getObjectLayoutByName($scope.OBJECT_NAME, '');
                        $scope.editObject[$scope.nsp + 'ObjectId__c'] = $scope.parentItem.Id;
                    } else {
                        $scope.getObjectLayoutById($scope.item.Id, true);

                        for (var key in $scope.item) {
                            if (key !== '$$hashKey') {
                                $scope.editObject[key] = $scope.item[key];
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

},{}],4:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocAttachments', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'Attachments.tpl.html',
            controller: function($scope, $rootScope, $sldsModal) {
                console.log('INIT: ', $scope.customViewAttrs);
                $scope.objectId = $scope.customViewAttrs.objectId;
                $scope.objName = $scope.customViewAttrs.objName;
                $scope.items = $scope.customViewAttrs.items;

                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = 'VlocityAttachment__c';

                $scope.$on('setItems', function(event, items) {
                    $scope.items = items;
                });

                $scope.$on('setSelectedItem', function(event, item) {
                    $scope.selectedItem = item;
                });

                $scope.selectItem = function(item) {
                    var broadcastData = {
                        facetType: 'ATTACHMENT_ITEM',
                        facetData: {
                            attachmentItem: item
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
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
                    modalScope.confirmationTitle = 'Delete Attachment';
                    modalScope.confirmationMsg = 'Are you sure you want to delete the attachment <i>' + item.Name + '</i>?';
                    modalScope.cancelActionLbl = 'Cancel';
                    modalScope.confirmActionLbl = 'Delete Attachment';
                    modalScope.confirmAction = function() {
                        var itemToDelete = {};
                        for (var key in item) {
                            if (key !== '$$hashKey') {
                                itemToDelete[key] = item[key];
                            }
                        }
                        var inputMap = { 'objectId' : itemToDelete.Id };
                        remoteActions.invokeMethod('deleteObject', JSON.stringify(inputMap)).then(function(results) {
                            console.log('delete attachment results: ', results);
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

                $scope.previewItem = function(item, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    var modalScope = $scope.$new();
                    modalScope.title = item.Name;
                    modalScope.itemName = item.Name;
                    modalScope.itemUrl = item[$scope.nsp + 'UrlLong__c'];
                    modalScope.preview = function() {
                        var itemToPreview = {};
                        for (var key in item) {
                            if (key !== '$$hashKey') {
                                itemToPreview[key] = item[key];
                            }
                        }
                    };

                    var previewModal = $sldsModal({
                        templateUrl: 'PreviewItemModal.tpl.html',
                        backdrop: 'static',
                        scope: modalScope,
                        show: true
                    });
                };

                $scope.newItem = function() {
                    $scope.selectItem({});
                };

                $scope.describeObject = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('Attachments - describeObject results: ', results);
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
                        if (results[$scope.nsp.toLowerCase() + 'attachments'] === undefined) {
                            $scope.fieldSet = null;
                        } else {
                            $scope.fieldSet = results[$scope.nsp.toLowerCase() + 'attachments'];
                        }
                        console.log('Attachments - getFieldSets results: ', $scope.fieldSet);
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

},{}],5:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocAttribute', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                attributeId: '=',
                objectId: '=',
                formElementName: '=',
                attrMap: '=',
                attrObj: '=',
                attrAssgnObj: '=',
                picklistItems: '=',
                lookupItems: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'VlocAttribute.tpl.html',
            controller: function($scope) {
                $scope.nsp = fileNsPrefix();

                $scope.$on('refreshAttributeAssignment', function(event, data) {
                    if ($scope.attributeId === data.attrId) {
                        $scope.getAttributeAssignmentById(data.attrId);
                    }
                });

                $scope.getAttributeAssignmentById = function() {
                    var inputMap = { 
                        'attributeId' : $scope.attributeId,
                        'objectId' : $scope.objectId
                    };
                    remoteActions.invokeMethod('getAttributeAssignmentById', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getAttributeAssignmentById results: ', results);
                        $scope.attrObj = results.attribute;
                        $scope.attrAssgnObj = results.attributeAssignment;
                        $scope.picklistItems = results.picklistItems;
                        $scope.lookupItems = results.lookupItems;
                        $scope.attrMap[$scope.attributeId] = {
                            'attrObj': results.attribute,
                            'attrAssgnObj': results.attributeAssignment
                        };
                        $scope.initAttribute();
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.saveAttributeAssignment = function() {
                    var inputMap = { 'so' : JSON.stringify($scope.attrAssgnObj) };
                    remoteActions.invokeMethod('saveAttributeAssignment', JSON.stringify(inputMap)).then(function(results) {
                        console.log('saveAttributeAssignment results: ', results);
                        // publish product
                        var inputMap = { 'productId' : $scope.objectId };
                        remoteActions.invokeMethod('publishProduct', JSON.stringify(inputMap)).then(function(response) {
                            console.log('publishProduct executed: ', response);
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

                $scope.$on('saveVlocAttribute', function() {
                    $scope.saveAttributeAssignment();
                });

                $scope.initAttribute = function() {
                    if ($scope.attrAssgnObj[$scope.nsp + 'ValueDataType__c'] === 'Picklist') {
                        $scope.setupPicklistItems();
                    }
                    if ($scope.attrAssgnObj[$scope.nsp + 'ValueDataType__c'] === 'Multi Picklist') {
                        $scope.setupMultiPicklistItems();
                    }
                    if ($scope.attrAssgnObj[$scope.nsp+'ValueDataType__c'] === 'Checkbox') {
                        if ($scope.attrAssgnObj[$scope.nsp+'Value__c'] !== undefined && (typeof $scope.attrAssgnObj[$scope.nsp+'Value__c'] === 'string')) {
                            $scope.attrAssgnObj[$scope.nsp+'Value__c'] = ($scope.attrAssgnObj[$scope.nsp+'Value__c'] === 'true');
                        }
                    }
                    if ($scope.attrAssgnObj[$scope.nsp + 'ValueDataType__c'] === 'Lookup') {
                        $scope.setupLookupItems();
                    }
                };

                $scope.setupPicklistItems = function() {
                    angular.forEach($scope.picklistItems, function(o) {
                        o.selected = (o[$scope.nsp+'Value__c'] === $scope.attrAssgnObj[$scope.nsp+'Value__c']);
                    });
                    if (!$scope.attrAssgnObj[$scope.nsp + 'UIDisplayType__c'] || $scope.attrAssgnObj[$scope.nsp + 'UIDisplayType__c'] === '') {
                        $scope.attrAssgnObj[$scope.nsp + 'UIDisplayType__c'] = 'Dropdown';
                    }
                };

                $scope.setupMultiPicklistItems = function() {
                    $scope.selectedItems = {
                        mpd: []
                    };
                    var selectedValues = $scope.attrAssgnObj[$scope.nsp+'Value__c'];
                    if (selectedValues) {
                        var values = selectedValues.split(';');
                        angular.forEach($scope.picklistItems, function(o) {
                            o.selected = (values.indexOf(o[$scope.nsp+'Value__c']) !== -1);
                        });
                    }
                    if (!$scope.attrAssgnObj[$scope.nsp + 'UIDisplayType__c'] || $scope.attrAssgnObj[$scope.nsp + 'UIDisplayType__c'] === '') {
                        $scope.attrAssgnObj[$scope.nsp + 'UIDisplayType__c'] = 'Dropdown';
                    }
                };

                $scope.setMultiPicklistValues = function() {
                    if ($scope.attrAssgnObj[$scope.nsp + 'UIDisplayType__c'] === 'Dropdown') {
                        $scope.attrAssgnObj[$scope.nsp+'Value__c'] = $scope.selectedItems.mpd.join(';');
                    } else {
                        var selectedValues = [];
                        angular.forEach($scope.picklistItems, function(o) {
                            if (o.selected) {
                                selectedValues.push(o[$scope.nsp+'Value__c']);
                            }
                        });
                        $scope.attrAssgnObj[$scope.nsp+'Value__c'] = selectedValues.join(';');
                    }
                };

                $scope.setupLookupItems = function() {
                    $scope.lookupMap = {};
                    $scope.lookupObj = {
                        selectedItem: '',
                        showItems: false
                    };
                    angular.forEach($scope.lookupItems, function(luItem) {
                        if (luItem.Name === undefined) {
                            luItem.Name = luItem.Id;
                        }
                        $scope.lookupMap[luItem.Name] = luItem.Id;
                        if (luItem.Id === $scope.attrAssgnObj[$scope.nsp+'Value__c']) {
                            $scope.lookupObj.selectedItem = luItem.Name;
                        }
                    });
                };

                $scope.selectLookupItem = function(luItem) {
                    if (luItem === null) {
                        var itemId = $scope.lookupMap[$scope.lookupObj.selectedItem];
                        $scope.attrAssgnObj[$scope.nsp+'Value__c'] = (itemId || '');
                    } else {
                        $scope.lookupObj.selectedItem = luItem.Name;
                        $scope.attrAssgnObj[$scope.nsp+'Value__c'] = luItem.Id;
                    }
                    $scope.lookupObj.showItems = false;
                };

                $scope.$watch('lookupObj.selectedItem', function(newValue) {
                    if (newValue === '') {
                        $scope.attrAssgnObj[$scope.nsp+'Value__c'] = '';
                    }
                }, true);

                $scope.init = function() {
                    if (!$scope.attrObj || $scope.attrObj === null || !$scope.attrAssgnObj || $scope.attrAssgnObj === null) {
                        $scope.getAttributeAssignmentById();
                    } else {
                        $scope.attrMap[$scope.attributeId] = {
                            'attrObj': $scope.attrObj,
                            'attrAssgnObj': $scope.attrAssgnObj
                        };
                        $scope.initAttribute();
                    }
                };
                $scope.init();
            }
        };
    }
]);

},{}],6:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocAttributeDefaultValue', ['remoteActions',
    function(remoteActions) {
        return {
            scope: {
                parentObj: '=',
                fieldName: '=',
                valueDataType: '=',
                picklistItems: '=',
                lookupItems: '=',
                displayMode: '=',
                configureMode: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'AttributeDefaultValue.tpl.html',
            controller: function($scope, $timeout) {
                $scope.nsp = fileNsPrefix();

                $scope.setMultiPicklistValues = function(selectedMPItems) {
                    $scope.parentObj[$scope.fieldName] = selectedMPItems.join(';');
                };

                $scope.setupValueDataType = function() {
                    $scope.objPicklists = [];
                    if ($scope.valueDataType === 'Picklist') {
                        $scope.selectedPicklistItem = $scope.parentObj[$scope.fieldName];
                        angular.forEach($scope.picklistItems, function(item) {
                            var o = {
                                'label': item.Name,
                                'value': item[$scope.nsp + 'Value__c']
                            }
                            if ($scope.parentObj[$scope.fieldName] === undefined || $scope.parentObj[$scope.fieldName] === null) {
                                if (item[$scope.nsp + 'IsDefault__c']) {
                                    o.selected = true;
                                    $scope.selectedPicklistItem = o.value;
                                } else {
                                    o.selected = false;
                                }
                            } else {
                                if ($scope.parentObj[$scope.fieldName] === o.value) {
                                    o.selected = true;
                                } else {
                                    o.selected = false;
                                }
                            }
                            $scope.objPicklists.push(o);
                        });
                        $scope.parentObj[$scope.fieldName] = $scope.selectedPicklistItem;
                    }
                    if ($scope.valueDataType === 'Multi Picklist') {
                        var values = '';
                        if ($scope.parentObj[$scope.fieldName] !== undefined && $scope.parentObj[$scope.fieldName] !== null) {
                            values = $scope.parentObj[$scope.fieldName].split(';');
                        }
                        var selectedValues = [];
                        angular.forEach($scope.picklistItems, function(item) {
                            var o = {
                                'label': item.Name,
                                'value': item[$scope.nsp + 'Value__c']
                            }
                            if ($scope.parentObj[$scope.fieldName] === undefined || $scope.parentObj[$scope.fieldName] === null) {
                                o.selected = item[$scope.nsp + 'IsDefault__c'];
                            } else {
                                o.selected = (values.indexOf(o.value) !== -1);
                            }
                            if (o.selected) {
                                selectedValues.push(o.value);
                            }
                            $scope.objPicklists.push(o);
                        });
                        $scope.parentObj[$scope.fieldName] = selectedValues.join(';');
                    }
                    if ($scope.valueDataType === 'Lookup') {
                        $scope.setupLookupItems();
                    }
                };

                var initializing = true;
                $scope.$watch('picklistItems', function(newValue) {
                    if (initializing) {
                        $timeout(function() { initializing = false; });
                    } else {
                        console.log('DEFAULT PICKLIST CHANGED TO', newValue);
                        $scope.parentObj[$scope.fieldName] = null;
                        $scope.picklistItems = newValue;
                        $scope.setupValueDataType();
                    }
                });

                $scope.setupLookupItems = function() {
                    $scope.lookupMap = {};
                    $scope.lookupObj = {
                        selectedItem: '',
                        showItems: false
                    };
                    angular.forEach($scope.lookupItems, function(luItem) {
                        if (luItem.Name === undefined) {
                            luItem.Name = luItem.Id;
                        }
                        $scope.lookupMap[luItem.Name] = luItem.Id;
                        if (luItem.Id === $scope.parentObj[$scope.fieldName]) {
                            $scope.lookupObj.selectedItem = luItem.Name;
                        }
                    });
                };

                $scope.selectLookupItem = function(luItem) {
                    if (luItem === null) {
                        var itemId = $scope.lookupMap[$scope.lookupObj.selectedItem];
                        $scope.parentObj[$scope.fieldName] = (itemId || '');
                    } else {
                        $scope.lookupObj.selectedItem = luItem.Name;
                        $scope.parentObj[$scope.fieldName] = luItem.Id;
                    }
                    $scope.lookupObj.showItems = false;
                };

                $scope.$watch('lookupObj.selectedItem', function(newValue) {
                    if (newValue === '') {
                        $scope.parentObj[$scope.fieldName] = '';
                    }
                }, true);

                $scope.init = function() {
                    $scope.fieldInfo = {'label': 'defaultValue'};
                    $scope.setupValueDataType();
                };
                $scope.init();
            }
        };
    }
]);

},{}],7:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocAttributeMetadata', ['$rootScope', 'remoteActions', 'cpqService',
    function($rootScope, remoteActions, cpqService) {
        return {
            scope: {
                objectId: '=',
                attrObj: '=',
                attrAssgnObj: '=',
                attrAssgnOverrideObj: '=',
                attrOverrideDefObj: '=',
                mode: '=',
                rootProductId: '=',
                prodChildItemObj: '=',
                isProduct: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'AttributeMetadata.tpl.html',
            controller: function($scope, $timeout) {
                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = 'AttributeAssignment__c';
                $scope.fieldSet = null;
                $scope.objectFields = null;
                $scope.objectPicklists = null;

                $scope.getAttributeAssignmentById = function() {
                    var inputMap = {
                        'attributeId' : $scope.attrObj.Id,
                        'objectId' : $scope.objectId
                    };
                    remoteActions.invokeMethod('getAttributeAssignmentById', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getAttributeAssignmentById results: ', results);
                        $scope.attrAssgnObj = results.attributeAssignment;
                        $scope.picklistItems = results.picklistItems;
                        $scope.lookupItems = results.lookupItems;
                        $scope.editItem = {};
                        for (var key in $scope.attrAssgnObj) {
                            $scope.editItem[key] = $scope.attrAssgnObj[key];
                        }
                        $scope.currentPicklistId = angular.copy($scope.editItem[$scope.nsp+'PicklistId__c']);
                        $scope.setupValueDataType();
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.describeObjectWithQuery = function(objectName) {
                    var queryMap = {};
                    objectName = objectName.replace($scope.nsp, '');

                    //Lookup Object Id filtered by Record Type = Object
                    var parentOTQueryFilter = 'WHERE RecordType.Name = \'Object\'';
                    var lookupFieldName = $scope.nsp + 'LookupObjectId__c';
                    queryMap[lookupFieldName] = parentOTQueryFilter;

                    //Lookup Object Type Id filtered by Record Type = Object Type
                    if ($scope.editItem != undefined && $scope.editItem[$scope.nsp + 'LookupObjectId__c'] != null) {
                        var parentOTQueryFilter2 = 'WHERE RootObjectClassId__c = \''+$scope.editItem[$scope.nsp + 'LookupObjectId__c']+ '\' AND RecordType.Name = \'Object Type\'';
                    } else {
                        var parentOTQueryFilter2 = 'WHERE RecordType.Name = \'Object Type\'';
                    }
                    var lookupFieldName2 = $scope.nsp + 'LookupObjectTypeId__c';
                    queryMap[lookupFieldName2] = parentOTQueryFilter2;

                    var inputMap = {
                        'objectName' : objectName,
                        'inputMap' : JSON.stringify(queryMap)
                    };
                    remoteActions.invokeMethod('describeObjectWithQuery', JSON.stringify(inputMap)).then(function(results) {
                        console.log('describeObject assignment attribute results: ', results);
                        $scope.objectFields = results;
                    }, function(error) {
                        $scope.objectFields = {};
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
                        $scope.objectPicklists = {};
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
                        console.log('getFieldSets ' + objectName + ': ', results);
                        if (results[$scope.nsp.toLowerCase() + 'attributemetadata'] === undefined) {
                            $scope.fieldSet = null;
                        } else {
                            $scope.fieldSet = results[$scope.nsp.toLowerCase() + 'attributemetadata'];
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
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
                            itemToSave[key] = $scope.editItem[key];
                        }
                    }
                    if (itemToSave[$scope.nsp+'ValueDataType__c'] === 'Checkbox' && itemToSave[$scope.nsp+'Value__c'] !== undefined) {
                        itemToSave[$scope.nsp+'Value__c'] += '';
                    }

                    var inputMap = { 'so' : JSON.stringify(itemToSave) };
                    remoteActions.invokeMethod('saveAttributeAssignment', JSON.stringify(inputMap)).then(function(results) {
                        console.log('save assignment attribute results: ', results);
                        if ($scope.isProduct) {
                            // publish product
                            var inputMap = { 'productId' : $scope.objectId };
                            remoteActions.invokeMethod('publishProduct', JSON.stringify(inputMap)).then(function(response) {
                                console.log('publishProduct executed: ', response);
                            });
                        }

                        $rootScope.$broadcast('refreshItems');
                        $rootScope.$broadcast('refreshAttributeAssignment', {attrId: results[$scope.nsp+'AttributeId__c']});
                        if (event) {
                            event.currentTarget.innerText = originalText;
                            event.currentTarget.disabled = false;
                        }
                        $rootScope.$broadcast('hideItemDetails');
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

                $scope.getOverride = function() {
                    var prodChild = $scope.prodChildItemObj === undefined ? null : $scope.prodChildItemObj.Id;
                    var inputMap = {
                        'type': 'Attribute',
                        'contextId': $scope.rootProductId,
                        'overriddenObjectId': $scope.attrAssgnObj.Id,
                        'overriddenPCIId': prodChild
                    };
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('getOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        if (result !== null) {
                            var obj = JSON.parse(result);
                            console.log('get override: ', obj);
                            $scope.overrideObj = obj.SObject;
                            $scope.overrideDef = obj.OverrideDefinition__c;
                            $scope.hasOverride = true;
                            $scope.attrAssgnOverrideObj = $scope.overrideObj;
                            $scope.attrOverrideDefObj = $scope.overrideDef;
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.createOverride = function() {
                    var itemToCreate = {};
                    for (var key in $scope.editItem) {
                        itemToCreate[key] = ($scope.editItem[key] === null ? undefined : $scope.editItem[key]);
                    }
                    itemToCreate[$scope.nsp + 'IsOverride__c'] = true;
                    delete itemToCreate.$$hashKey;
                    delete itemToCreate.Id;

                    var inputMap = {
                        'type': 'Attribute',
                        'contextId': $scope.rootProductId,
                        'overriddenObjectId': $scope.attrAssgnObj.Id,
                        'overriddenPCIId': $scope.prodChildItemObj === undefined ? null : $scope.prodChildItemObj.Id
                    };
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('createOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        var obj = JSON.parse(result);
                        console.log('create override: ', obj);
                        $scope.overrideObj = obj.SObject;
                        $scope.overrideDef = obj.OverrideDefinition__c;
                        $scope.hasOverride = true;
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.saveOverride = function(event) {
                    var originalText;
                    if (event) {
                        originalText = event.currentTarget.innerText;
                        event.currentTarget.disabled = true;
                        event.currentTarget.innerText = 'Saving...';
                    }

                    // special cases for nulls
                    var key;
                    for (key in $scope.objectFields) {
                        var type = $scope.objectFields[key].type;
                        if (type === 'DATE' || type === 'DOUBLE' || type === 'INTEGER') {
                            if ($scope.overrideObj[key] === null || $scope.overrideObj[key] === '') {
                                $scope.overrideObj[key] = undefined;
                            }
                        }
                    }

                    var itemToSave = {};
                    for (key in $scope.overrideObj) {
                        if (key !== '$$hashKey') {
                            itemToSave[key] = ($scope.overrideObj[key] === null ? undefined : $scope.overrideObj[key]);
                        }
                    }

                    var inputMap = {
                        'type': 'Attribute',
                        'contextId': $scope.rootProductId,
                        'sObject': JSON.stringify(itemToSave)
                    };
                    console.log('Save Override: ', itemToSave);
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('saveOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        console.log('save override results: ', results);
                        if (event) {
                            event.currentTarget.innerText = originalText;
                            event.currentTarget.disabled = false;
                        }
                        $rootScope.$broadcast('refreshItems');
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

                $scope.deleteOverride = function() {
                    var inputMap = {
                        'type': 'Attribute',
                        'overridingObjectId': $scope.overrideObj.Id,
                        'overrideDefinitionId': $scope.overrideDef.Id,
                        'contextId': $scope.rootProductId
                    };
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('deleteOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        console.log('delete override: ', result);
                        $scope.overrideObj = null;
                        $scope.overrideDef = null;
                        $scope.hasOverride = false;
                        $rootScope.$broadcast('refreshItems');
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.setupValueDataType = function() {
                    if ($scope.editItem[$scope.nsp+'ValueDataType__c'] === 'Checkbox') {
                        if ($scope.editItem[$scope.nsp+'Value__c'] !== undefined && (typeof $scope.editItem[$scope.nsp+'Value__c'] === 'string')) {
                            $scope.editItem[$scope.nsp+'Value__c'] = ($scope.editItem[$scope.nsp+'Value__c'] === 'true');
                        }
                    }
                    if ($scope.editItem[$scope.nsp + 'ValueDataType__c'] === 'Picklist' || $scope.editItem[$scope.nsp + 'ValueDataType__c'] === 'Multi Picklist') {
                        $scope.isPicklistValueType = true;
                        $scope.setupPicklistDataType();
                    } else {
                        $scope.isPicklistValueType = false;
                    }
                };

                $scope.setupPicklistDataType = function() {
                    if ($scope.editItem[$scope.nsp + 'ValueDataType__c'] === 'Picklist') {
                        $scope.picklistDisplayTypes = [
                            {'label': 'Dropdown', 'value': 'Dropdown'},
                            {'label': 'Radiobutton', 'value': 'Radiobutton'}
                        ];
                    }

                    if ($scope.editItem[$scope.nsp + 'ValueDataType__c'] === 'Multi Picklist') {
                        $scope.picklistDisplayTypes = [
                            {'label': 'Dropdown', 'value': 'Dropdown'},
                            {'label': 'Checkbox', 'value': 'Checkbox'}
                        ];
                    }

                    if (!$scope.editItem[$scope.nsp + 'UIDisplayType__c']) {
                        $scope.editItem[$scope.nsp + 'UIDisplayType__c'] = 'Dropdown';
                    }

                    $scope.selectedPicklistValueType = $scope.editItem[$scope.nsp + 'UIDisplayType__c'];
                };

                $scope.$watch('editItem.' + $scope.nsp + 'ValueDataType__c', function(newValue) {
                    if (newValue !== undefined) {
                        $scope.setupValueDataType();
                    }
                });

                var initializing = true;
                $scope.$watch('editItem.' + $scope.nsp + 'PicklistId__c', function(newValue) {
                    console.log('$scope.currentPicklistId = ', $scope.currentPicklistId);
                    console.log('newValue = ', newValue);
                    if (initializing) {
                        $timeout(function() { initializing = false; });
                    } else {
                        if (newValue !== undefined && newValue !== $scope.currentPicklistId) {
                            console.log('PICKLIST CHANGED TO', newValue);
                            if (newValue === '') {
                                $scope.picklistItems = [];
                            } else {
                                $scope.getPicklistValues(newValue);
                            }
                            $scope.currentPicklistId = newValue;
                        }
                    }
                });

                $scope.getPicklistValues = function(picklistId) {
                    var inputMap = { 'picklistId' : picklistId };
                    remoteActions.invokeMethod('getPicklistValues', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getPicklistValues results: ', results);
                        $scope.picklistItems = results;
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.init = function() {
                    $scope.getAttributeAssignmentById();

                    $scope.describeObjectWithQuery($scope.nsp + $scope.OBJECT_NAME);
                    $scope.getObjectPicklistsByName($scope.nsp + $scope.OBJECT_NAME);
                    $scope.getFieldSetsByName($scope.nsp + $scope.OBJECT_NAME);

                    $scope.overrideObj = null;
                    $scope.overrideDef = null;
                    $scope.hasOverride = false;

                    if ($scope.mode === 'override') {
                        $scope.overrideMode = true;
                        $scope.objDisplayMode = 'view';

                        if ($scope.attrAssgnOverrideObj === null) {
                            $scope.getOverride();
                        } else {
                            $scope.overrideObj = $scope.attrAssgnOverrideObj;
                            $scope.overrideDef = $scope.attrOverrideDefObj;
                            $scope.hasOverride = true;
                        }
                    } else {
                        $scope.overrideMode = false;
                        $scope.objDisplayMode = 'edit';
                    }
                };
                $scope.init();
            }
        };
    }
]);

},{}],8:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocContextRule', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                objectType: '=',
                contextRule: '=',
                displayMode: '=',
                objectFields: '=',
                objectPicklists: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ContextRule.tpl.html',
            controller: function($scope, $timeout) {
                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = $scope.nsp + 'ContextRule__c';

                $scope.getObjectLayoutByName = function(objectName, objectType) {
                    var inputMap = {
                        'objectName' : objectName,
                        'objectType' : objectType
                    };
                    remoteActions.invokeMethod('getObjectLayoutByName', JSON.stringify(inputMap)).then(function(results) {
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
                };

                var initializing = true;
                $scope.$watch('objectType', function(newValue) {
                    if (initializing) {
                        $timeout(function() { initializing = false; });
                    } else {
                        console.log('OBJECT TYPE CHANGED TO: ', newValue);
                        if (newValue !== undefined) {
                            $scope.getObjectLayoutByName($scope.OBJECT_NAME, newValue);
                        }
                    }
                }, true);

                $scope.init = function() {
                    $scope.getObjectLayoutByName($scope.OBJECT_NAME, $scope.objectType);
                };
                $scope.init();
            }
        };
    }
]);

},{}],9:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocContextRuleInfoCard', ['remoteActions',
    function(remoteActions) {
        return {
            scope: {
                contextRule: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ContextRuleInfoCard.tpl.html',
            controller: function($scope) {
                $scope.nsp = fileNsPrefix();
            }
        };
    }
]);

},{}],10:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocContextRuleSet', ['remoteActions',
    function(remoteActions) {
        return {
            scope: {
                contextRuleSet: '=',
                contextRules: '=',
                parentItem: '=',
                objectId: '=',
                mode: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ContextRuleSet.tpl.html',
            controller: function($scope, $rootScope, $timeout, $sldsModal) {
                $scope.nsp = fileNsPrefix();
                $scope.objectNameRule = $scope.nsp + 'ContextRule__c';
                $scope.objectNameRuleset = $scope.nsp + 'ContextRuleSet2__c';
                $scope.objectFields = {
                    'rule': {},
                    'ruleset': {}
                };
                $scope.objectPicklists = {
                    'rule': {},
                    'ruleset': {}
                };
                $scope.cfg = {
                    hasHeaderRule: false,
                    showHeaderRule: false,
                    hasFallbackRule: false,
                    showFallbackRule: false,
                    showChildrenRules: false
                };
                if ($scope.contextRuleSet !== null) {
                    $scope.cfg.hasHeaderRule = ($scope.contextRuleSet[$scope.nsp + 'HeaderRuleId__r'] !== undefined);
                    $scope.cfg.hasFallbackRule = ($scope.contextRuleSet[$scope.nsp + 'FallbackRuleId__r'] !== undefined);
                }

                $scope.describeObject = function(objectName, key) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        $scope.objectFields[key] = results;
                        console.log('describeObject ' + objectName + ' results: ', $scope.objectFields[key]);
                    });
                };

                $scope.getObjectPicklistsByName = function(objectName, key) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('getObjectPicklistsByName', JSON.stringify(inputMap)).then(function(results) {
                        for (var k in results) {
                            if (k.endsWith('__c')) {
                                $scope.objectPicklists[key][$scope.nsp + k] = results[k];
                            } else {
                                $scope.objectPicklists[key][k] = results[k];
                            }
                        }
                        console.log('getObjectPicklistsByName ' + objectName + ' results:', $scope.objectPicklists[key]);
                    });
                };

                $scope.getFieldSetsByName = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('getFieldSetsByName', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getFieldSets ' + objectName + ': ', results);
                        if (results[$scope.nsp.toLowerCase() + 'contextrules'] === undefined) {
                            $scope.fieldSet = null;
                        } else {
                            $scope.fieldSet = results[$scope.nsp.toLowerCase() + 'contextrules'];
                        }
                    });
                };

                $scope.addRule = function(ruleType) {
                    if (ruleType === 'header') {
                        $scope.cfg.hasHeaderRule = true;
                        $scope.headerRule = {'show': true};
                    }
                    if (ruleType === 'fallback') {
                        $scope.cfg.hasFallbackRule = true;
                        $scope.fallbackRule = {'show': true};
                    }
                    if (ruleType === 'child') {
                        $scope.childrenRules.push({'show': true});
                    }
                };

                $scope.removeRule = function(ruleType, rule, idx) {
                    if (ruleType === 'header') {
                        $scope.cfg.hasHeaderRule = false;
                        $scope.headerRule = null;
                        delete $scope.editRuleSet[$scope.nsp+'HeaderRuleId__c'];
                        delete $scope.editRuleSet[$scope.nsp+'HeaderRuleId__r'];
                    }
                    if (ruleType === 'fallback') {
                        $scope.cfg.hasFallbackRule = false;
                        $scope.fallbackRule = null;
                        delete $scope.editRuleSet[$scope.nsp+'FallbackRuleId__c'];
                        delete $scope.editRuleSet[$scope.nsp+'FallbackRuleId__r'];
                    }
                    if (ruleType === 'child') {
                        $scope.childrenRules.splice(idx, 1);
                    }
                };

                $scope.closeDetails = function() {
                    if ($scope.mode === 'modal') {
                        $scope.$parent.hideAction();
                    } else {
                        $rootScope.$broadcast('hideItemDetails');
                    }
                };

                $scope.createItem = function(event) {
                    var originalText;
                    if (event) {
                        originalText = event.currentTarget.innerText;
                        event.currentTarget.disabled = true;
                        event.currentTarget.innerText = 'Saving...';
                    }

                    var itemToSave = angular.copy($scope.editRuleSet);
                    delete itemToSave['$$hashKey'];
                    var headerRuleToSave = angular.copy($scope.headerRule);
                    if (headerRuleToSave) {
                        delete headerRuleToSave['$$hashKey'];
                        delete headerRuleToSave.show;
                    }
                    var fallbackRuleToSave = angular.copy($scope.fallbackRule);
                    if (fallbackRuleToSave) {
                        delete fallbackRuleToSave['$$hashKey'];
                        delete fallbackRuleToSave.show;
                    }
                    var childrenRulesToSave = [];
                    angular.forEach($scope.childrenRules, function(cr) {
                        var rule = angular.copy(cr);
                        delete rule['$$hashKey'];
                        delete rule.show;
                        childrenRulesToSave.push(rule)
                    });

                    var inputMap = {
                        'mode': 'create',
                        'objectId': $scope.objectId,
                        'ruleset': itemToSave,
                        'headerRule': headerRuleToSave,
                        'fallbackRule': fallbackRuleToSave,
                        'childrenRules': childrenRulesToSave
                    };
                    var inputMapJSON = JSON.stringify(inputMap);
                    console.log('create context ruleset input:', inputMap);

                    var invokeInputMap = { 'input' : inputMapJSON, 'options' : '' };
                    remoteActions.invokeMethod('saveRuleSetRules', JSON.stringify(invokeInputMap)).then(function(results) {
                        console.log('create context ruleset results:', results);
                        $rootScope.$broadcast('refreshContextRuleSets');
                        if ($scope.mode === 'modal') {
                            $scope.$parent.hideAction();
                        } else {
                            if (event) {
                                event.currentTarget.innerText = originalText;
                                event.currentTarget.disabled = false;
                            }
                            $scope.closeDetails();
                        }
                        //TODO: show save success message
                    }, function(error) {
                        //TODO: show save failure message
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

                    var itemToSave = angular.copy($scope.editRuleSet);
                    delete itemToSave['$$hashKey'];
                    var headerRuleToSave = angular.copy($scope.headerRule);
                    if (headerRuleToSave) {
                        delete headerRuleToSave['$$hashKey'];
                        delete headerRuleToSave.show;
                    }
                    var fallbackRuleToSave = angular.copy($scope.fallbackRule);
                    if (fallbackRuleToSave) {
                        delete fallbackRuleToSave['$$hashKey'];
                        delete fallbackRuleToSave.show;
                    }
                    var childrenRulesToSave = [];
                    angular.forEach($scope.childrenRules, function(cr) {
                        var rule = angular.copy(cr);
                        delete rule['$$hashKey'];
                        delete rule.show;
                        childrenRulesToSave.push(rule)
                    });

                    var inputMap = {
                        'mode': 'update',
                        'objectId': $scope.objectId,
                        'ruleset': itemToSave,
                        'headerRule': headerRuleToSave,
                        'fallbackRule': fallbackRuleToSave,
                        'childrenRules': childrenRulesToSave
                    };
                    var inputMapJSON = JSON.stringify(inputMap);
                    console.log('save context ruleset input:', inputMap);
                    var invokeInputMap = { 'input' : inputMapJSON, 'options' : '' };
                    remoteActions.invokeMethod('saveRuleSetRules', JSON.stringify(invokeInputMap)).then(function(results) {
                        console.log('save context ruleset results:', results);
                        $rootScope.$broadcast('refreshContextRuleSets');
                        if ($scope.mode === 'modal') {
                            $scope.$parent.hideAction();
                        } else {
                            if (event) {
                                event.currentTarget.innerText = originalText;
                                event.currentTarget.disabled = false;
                            }
                            $scope.closeDetails();
                        }
                        //TODO: show save success message
                    }, function(error) {
                        //TODO: show save failure message
                        if (event) {
                            event.currentTarget.innerText = 'Error!';
                            $timeout(function() {
                                event.currentTarget.innerText = originalText;
                                event.currentTarget.disabled = false;
                            }, 5000);
                        }
                    });
                };

                $scope.deleteItem = function(ruleType, rule, idx) {
                    if ($scope.contextRuleSet === null || rule.Id === undefined) {
                        $scope.removeRule(ruleType, rule, idx);
                    } else {
                        var inputMap = {
                            'objectToDelete': 'rule',
                            'ruleType': ruleType,
                            'ruleId': rule.Id,
                            'ruleSetId': $scope.contextRuleSet.Id
                        };
                        var inputMapJSON = JSON.stringify(inputMap);

                        var modalScope = $scope.$new();
                        modalScope.confirmationTitle = 'Delete Rule';
                        modalScope.confirmationMsg = 'Are you sure you want to delete the rule <i>' + rule.Name + '</i>?';
                        modalScope.cancelActionLbl = 'Cancel';
                        modalScope.confirmActionLbl = 'Delete Rule';
                        modalScope.confirmAction = function() {
                            console.log('delete context rule input:', inputMap);
                            var invokeInputMap = { 'input' : inputMapJSON, 'options' : '' };
                            remoteActions.invokeMethod('deleteRuleSetRules', JSON.stringify(invokeInputMap)).then(function(results) {
                                console.log('delete context rule results: ', results);
                                $scope.removeRule(ruleType, rule, idx);
                                $rootScope.$broadcast('refreshContextRuleSets');
                                deleteModal.hide();
                                //TODO: show delete success message
                            }, function(error) {
                                //TODO: show delete failure message
                            });
                        };

                        var deleteModal = $sldsModal({
                            templateUrl: 'ConfirmationModal.tpl.html',
                            backdrop: 'static',
                            scope: modalScope,
                            show: true
                        });
                    }
                };

                $scope.init = function() {
                    $scope.describeObject($scope.objectNameRule, 'rule');
                    $scope.describeObject($scope.objectNameRuleset, 'ruleset');
                    $scope.getObjectPicklistsByName($scope.objectNameRule, 'rule');
                    $scope.getObjectPicklistsByName($scope.objectNameRuleset, 'ruleset');
                    $scope.getFieldSetsByName($scope.objectNameRule);

                    if ($scope.contextRuleSet === null) {
                        console.log('NEW RULE SET!');
                        $scope.editRuleSet = {};
                        $scope.headerRule = null;
                        $scope.fallbackRule = null;
                        $scope.childrenRules = [];
                    } else {
                        console.log('EDIT RULE SET!', $scope.contextRuleSet, $scope.contextRules);
                        $scope.editRuleSet = angular.copy($scope.contextRuleSet);
                        $scope.headerRule = ($scope.contextRuleSet[$scope.nsp + 'HeaderRuleId__r'] || null);
                        $scope.fallbackRule = ($scope.contextRuleSet[$scope.nsp + 'FallbackRuleId__r'] || null);
                        if ($scope.contextRules === undefined || $scope.contextRules === null) {
                            $scope.childrenRules = [];
                        } else {
                            $scope.childrenRules = angular.copy($scope.contextRules);
                        }
                    }
                };
                $scope.init();
            }
        };
    }
]);

},{}],11:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocContextRules', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ContextRules.tpl.html',
            controller: function($scope, $rootScope, $sldsPopover, $sldsModal) {
                $scope.nsp = fileNsPrefix();
                $scope.objectId = $scope.customViewAttrs.objectId;
                $scope.mode = $scope.customViewAttrs.contextRulesMode;
                $scope.objectNameRule = $scope.nsp + 'ContextRule__c';
                $scope.objectNameRuleset = $scope.nsp + 'ContextRuleSet2__c';
                $scope.objectFields = {
                    'rule': {},
                    'ruleset': {}
                };
                $scope.objectPicklists = {
                    'rule': {},
                    'ruleset': {}
                };
                $scope.rulesets = [];

                $scope.$on('refreshContextRuleSets', function(event, data) {
                    $scope.getRuleSetRules();
                });

                $scope.describeObject = function(objectName, key) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        $scope.objectFields[key] = results;
                        console.log('describeObject ' + objectName + ' results: ', $scope.objectFields[key]);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getObjectPicklistsByName = function(objectName, key) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('getObjectPicklistsByName', JSON.stringify(inputMap)).then(function(results) {
                        for (var k in results) {
                            if (k.endsWith('__c')) {
                                $scope.objectPicklists[key][$scope.nsp + k] = results[k];
                            } else {
                                $scope.objectPicklists[key][k] = results[k];
                            }
                        }
                        console.log('getObjectPicklistsByName ' + objectName + ' results:', $scope.objectPicklists[key]);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getRuleSetRules = function() {
                    var inputMap = {
                        'objectId': $scope.objectId
                    };
                    var inputMapJSON = JSON.stringify(inputMap);
                    var invokeInputMap = { 'input' : inputMapJSON, 'options' : '' };
                    remoteActions.invokeMethod('getRuleSetRules', JSON.stringify(invokeInputMap)).then(function(results) {
                        $scope.rulesets = results.RuleSets;
                        $scope.ruleMap = results.RuleSetRules;
                        console.log('getRuleSetRules:', results);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.showRuleInfo = function(rule, event) {
                    if ($scope.contextRulePopover) {
                        $scope.contextRulePopover.destroy();
                    }
                    var popoverScope = $scope.$new();
                    popoverScope.rule = rule;
                    $scope.contextRulePopover = $sldsPopover(j$(event.currentTarget), {
                        scope: popoverScope,
                        sldsEnabled: true,
                        show: true,
                        autoClose: true,
                        trigger: 'manual',
                        nubbinDirection: 'top',
                        container: '.via-slds',
                        template: '<div class="slds-popover slds-nubbin--top" role="dialog"><div class="slds-popover__body"><vloc-context-rule-info-card context-rule="rule"></vloc-context-rule-info-card></div></div>'
                    });
                };

                $scope.newItem = function() {
                    $scope.editItem(null);
                };

                $scope.editItem = function(ruleset) {
                    if ($scope.mode === 'modal') {
                        var modalScope = $scope.$new();
                        modalScope.title = 'Context Rule Set';
                        modalScope.contextRuleSet = ruleset;
                        modalScope.contextRules = (ruleset === null ? null : $scope.ruleMap[ruleset.Id]);
                        modalScope.objectId = $scope.objectId;
                        modalScope.mode = $scope.mode;
                        modalScope.hideAction = function() {
                            contextRuleModal.hide();
                        };

                        var contextRuleModal = $sldsModal({
                            templateUrl: 'ContextRuleModal.tpl.html',
                            backdrop: 'static',
                            scope: modalScope,
                            show: true
                        });
                    } else {
                        var broadcastData = {
                            facetType: 'CONTEXT_RULESET',
                            facetData: {
                                contextRuleSet: ruleset,
                                contextRules: (ruleset === null ? null : $scope.ruleMap[ruleset.Id]),
                                objectId: $scope.objectId,
                                mode: $scope.mode
                            }
                        };
                        $rootScope.$broadcast('showItemDetails', broadcastData);
                    }
                };

                $scope.deleteItem = function(item, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    var inputMap = {
                        'objectToDelete': 'ruleset',
                        'ruleSetId': item.Id
                    };
                    var inputMapJSON = JSON.stringify(inputMap);

                    var modalScope = $scope.$new();
                    modalScope.confirmationTitle = 'Delete Rule Set';
                    modalScope.confirmationMsg = 'Are you sure you want to delete the rule set <i>' + item.Name + '</i>?';
                    modalScope.cancelActionLbl = 'Cancel';
                    modalScope.confirmActionLbl = 'Delete Rule Set';
                    modalScope.confirmAction = function() {
                        var invokeInputMap = { 'input' : inputMapJSON, 'options' : '' };
                        remoteActions.invokeMethod('deleteRuleSetRules', JSON.stringify(invokeInputMap)).then(function(results) {
                            console.log('delete context ruleset results: ', results);
                            $scope.getRuleSetRules();
                            deleteModal.hide();
                            //TODO: show delete success message
                        }, function(error) {
                            cpqService.showNotification({
                                type: 'error',
                                title: 'Error',
                                content: error.message
                            });
                        });
                    };

                    var deleteModal = $sldsModal({
                        templateUrl: 'ConfirmationModal.tpl.html',
                        backdrop: 'static',
                        scope: modalScope,
                        show: true
                    });
                };

                $scope.init = function() {
                    $scope.describeObject($scope.objectNameRule, 'rule');
                    $scope.describeObject($scope.objectNameRuleset, 'ruleset');
                    $scope.getObjectPicklistsByName($scope.objectNameRule, 'rule');
                    $scope.getObjectPicklistsByName($scope.objectNameRuleset, 'ruleset');
                    $scope.getRuleSetRules();
                };
                $scope.init();
            }
        };
    }
]);

},{}],12:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocCustomView', ['$compile',
    function($compile) {
        var VIEW_TEMPLATE_MAP = {
            'ApplicableObjects': '<vloc-applicable-objects custom-view-attrs="customViewData.attrs"></vloc-applicable-objects>',
            'ObjectClassAttrsFields': '<vloc-object-class-attrs-fields custom-view-attrs="customViewData.attrs"></vloc-object-class-attrs-fields>',
            'AttributeFieldBindings': '<vloc-attr-field-bindings custom-view-attrs="customViewData.attrs"></vloc-attr-field-bindings>',
            'VlocObjAttrsFields': '<vloc-obj-attrs-fields custom-view-attrs="customViewData.attrs"></vloc-obj-attrs-fields>',
            'LayoutManagement': '<vloc-layout-management custom-view-attrs="customViewData.attrs"></vloc-layout-management>',
            'PicklistItems': '<vloc-picklist-items custom-view-attrs="customViewData.attrs"></vloc-picklist-items>',
            'ProductDetails': '<vloc-product-details custom-view-attrs="customViewData.attrs"></vloc-product-details>',
            'ProductStructure': '<vloc-product-structure custom-view-attrs="customViewData.attrs"></vloc-product-structure>',
            'AttributeRules': '<vloc-attribute-rules custom-view-attrs="customViewData.attrs"></vloc-attribute-rules>',
            'ContextRules': '<vloc-context-rules custom-view-attrs="customViewData.attrs"></vloc-context-rules>',
            'ObjectPricing': '<vloc-object-pricing custom-view-attrs="customViewData.attrs"></vloc-object-pricing>',
            'GlobalPricingElements': '<vloc-global-pricing-elements custom-view-attrs="customViewData.attrs"></vloc-global-pricing-elements>',
            'StandalonePricingElements': '<vloc-standalone-pricing-elements custom-view-attrs="customViewData.attrs"></vloc-standalone-pricing-elements>',
            'Attachments': '<vloc-attachments custom-view-attrs="customViewData.attrs"></vloc-attachments>',
            'ObjectTypes': '<vloc-object-types custom-view-attrs="customViewData.attrs"></vloc-object-types>',
            'ObjectTypeStructure': '<vloc-object-type-structure custom-view-attrs="customViewData.attrs"></vloc-object-type-structure>',
            'PriceListHierarchy': '<vloc-price-list-hierarchy custom-view-attrs="customViewData.attrs"></vloc-price-list-hierarchy>',
            'PromotionProducts': '<vloc-promotion-products custom-view-attrs="customViewData.attrs"></vloc-promotion-products>',
            'PromoProductDiscounts': '<vloc-product-adjustments custom-view-attrs="customViewData.attrs"></vloc-product-adjustments>',
            'ProductAdjustments': '<vloc-product-adjustments custom-view-attrs="customViewData.attrs"></vloc-product-adjustments>'
        };

        var getTemplate = function(view) {
            return VIEW_TEMPLATE_MAP[view];
        };

        return {
            restrict: 'E',
            scope: false,
            link: function(scope, element, attrs) {
                var viewName = scope.customViewData.name;
                element.append($compile(getTemplate(viewName))(scope));
            }
        };
    }
]);

},{}],13:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocDataTable', [function() {
    return {
        scope: {
            parentObj: '=',
            objName: '=',
            items: '=',
            selectedItem: '=',
            showItemDetails: '&'
        },
        replace: true,
        restrict: 'E',
        templateUrl: 'DataTable.tpl.html',
        controller: function($scope) {
            $scope.nsp = fileNsPrefix();
            $scope.selectedItem = null;

            $scope.selectItem = function(item) {
                $scope.selectedItem = item;
                $scope.showItemDetails()(item);
            };
        }
    };
}]);

},{}],14:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocFacetDetails', ['remoteActions',
    function(remoteActions) {
        return {
            scope: {
                maximizeFacetDetail: '=',
				showFacetDetail: '=',
				closeFacetDetails: '&'
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'VlocFacetDetails.tpl.html'
        };
    }
]);

},{}],15:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocFieldMetadata', ['$rootScope', 'remoteActions', 'cpqService',
    function($rootScope, remoteActions, cpqService) {
        return {
            scope: {
                objectName: '=',
                fieldName: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'FieldMetadata.tpl.html',
            controller: function($scope) {
                $scope.nsp = fileNsPrefix();

                $scope.describeField = function() {
                    var inputMap = { 
                        'objectName' : $scope.objectName,
                        'fieldName' : $scope.fieldName
                     };
                    remoteActions.invokeMethod('describeField', JSON.stringify(inputMap)).then(function(results) {
                        $scope.fieldMetadata = results;
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.init = function() {
                    $scope.describeField();
                };
                $scope.init();
            }
        };
    }
]);

},{}],16:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocGlobalPricingElements', ['remoteActions',
    function(remoteActions) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'GlobalPricingElements.tpl.html',
            controller: function($scope, $rootScope, $sldsModal, $compile) {
                $scope.nsp = fileNsPrefix();

                console.log('INIT GlobalPricingElements: ', $scope.customViewAttrs.objectPricingElements);
                $scope.objectId = $scope.customViewAttrs.objectPricingElements.objectId;
                $scope.objectType = $scope.customViewAttrs.objectPricingElements.objectType;
                $scope.objectAPIName = $scope.customViewAttrs.objectPricingElements.objectAPIName;
            }
        };
    }
]);

},{}],17:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocImgCarousel', [function() {
    return {
        scope: {
            attachments: '='
        },
        replace: true,
        restrict: 'E',
        templateUrl: 'ImageCarousel.tpl.html',
        controller: function($scope) {
            $scope.nsp = fileNsPrefix();
            $scope.currentImg = null;
            $scope.currentIdx = -1;

            $scope.$watch('attachments', function(attachmentList) {
                angular.forEach(attachmentList, function(att, idx) {
                    if (att[$scope.nsp + 'ContentType__c'] === 'Image') {
                        $scope.currentImg = att;
                        $scope.currentIdx = idx;
                    }
                });
            }, true);

            $scope.switchImage = function(idx) {
                if (idx === -1) {
                    idx = $scope.attachments.length - 1;
                } else if (idx === $scope.attachments.length) {
                    idx = 0;
                }

                $scope.currentImg = $scope.attachments[idx];
                $scope.currentIdx = idx;
            };
        }
    };
}]);

},{}],18:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocLayoutElement', ['$rootScope', 'remoteActions', 'cpqService',
    function($rootScope, remoteActions, cpqService) {
        return {
            scope: {
                layoutId: '=',
                item: '=',
                facetId: '=',
                sectionId: '=',
                objectName: '=',
                objectLayoutFields: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'LayoutElement.tpl.html',
            controller: function($scope, $timeout) {
                $scope.nsp = fileNsPrefix();
                $scope.fieldSet = null;
                $scope.objectFields = null;
                $scope.objectPicklists = {};
                $scope.elementObj = {};
                $scope.sectionElement = {
                    label: '',
                    idx: '',
                    sequence: 0
                };

                $scope.describeObject = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('describeObject ' + objectName + ' results: ', results);
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

                $scope.getFieldSetsByName = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('getFieldSetsByName', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getFieldSets ' + objectName + ': ', results);
                        if (results[$scope.nsp.toLowerCase() + 'objectfacet'] !== undefined) {
                            $scope.fieldSet = results[$scope.nsp.toLowerCase() + 'objectfacet'];
                        } else if (results[$scope.nsp.toLowerCase() + 'objectsection'] !== undefined) {
                            $scope.fieldSet = results[$scope.nsp.toLowerCase() + 'objectsection'];
                        } else if (results[$scope.nsp.toLowerCase() + 'objectelement'] !== undefined) {
                            $scope.fieldSet = results[$scope.nsp.toLowerCase() + 'objectelement'];
                        } else {
                            $scope.fieldSet = null;
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
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
                    for (var key in $scope.elementObj) {
                        if (key !== '$$hashKey') {
                            itemToSave[key] = $scope.elementObj[key];
                        }
                    }

                    if ($scope.objectName === 'ObjectFacet__c') {
                        itemToSave[$scope.nsp + 'ObjectLayoutId__c'] = $scope.layoutId;
                    }
                    if ($scope.objectName === 'ObjectSection__c') {
                        itemToSave[$scope.nsp + 'ObjectFacetId__c'] = $scope.facetId;
                    }
                    if ($scope.objectName === 'ObjectElement__c') {
                        var selectedEl = $scope.objectLayoutFields[$scope.sectionElement.idx];
                        if (selectedEl.attrId === '') {
                            // selected section element is a field
                            var fieldApiName = selectedEl.fieldApiName;
                            if (fieldApiName.endsWith('__c')) {
                                fieldApiName = fieldApiName.substring($scope.nsp.length);
                            }
                            itemToSave[$scope.nsp + 'FieldApiName__c'] = fieldApiName;
                        } else {
                            // selected section element is an attribute
                            itemToSave[$scope.nsp + 'AttributeId__c'] = selectedEl.attrId;
                        }

                        itemToSave.Name = selectedEl.label;
                        itemToSave[$scope.nsp + 'ObjectSectionId__c'] = $scope.sectionId;
                        itemToSave[$scope.nsp + 'Sequence__c'] = $scope.sectionElement.sequence;
                        itemToSave.Name = $scope.sectionElement.label;
                    }

                    if (itemToSave.Id === undefined) {
                        var inputMap = {
                            'objectName' : $scope.nsp + $scope.objectName,
                            'inputMap' : itemToSave
                        };
                        remoteActions.invokeMethod('createObject', JSON.stringify(inputMap)).then(function(results) {
                            console.log('create object ' + $scope.objectName + ' results: ', results);
                            $rootScope.$broadcast('refreshItems');
                            for (var key in results) {
                                $scope.elementObj[key] = results[key];
                            }
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
                    } else {
                        var inputMap = { 'so' : JSON.stringify(itemToSave) };
                        remoteActions.invokeMethod('updateObject', JSON.stringify(inputMap)).then(function(results) {
                            console.log('save object ' + $scope.objectName + ' results: ', results);
                            $rootScope.$broadcast('refreshItems');
                            $scope.elementObj = {};
                            for (var key in results) {
                                $scope.elementObj[key] = results[key];
                            }
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
                    }
                };

                $scope.setDisplayLabel = function() {
                    $scope.sectionElement.label = $scope.objectLayoutFields[$scope.sectionElement.idx].label;
                };

                $scope.closeDetails = function() {
                    $rootScope.$broadcast('hideItemDetails');
                };

                $scope.init = function() {
                    var key;
                    if ($scope.item !== undefined) {
                        for (key in $scope.item) {
                            if (key !== '$$hashKey') {
                                $scope.elementObj[key] = $scope.item[key];
                            }
                        }
                    }

                    $scope.getObjectPicklistsByName($scope.nsp + $scope.objectName);
                    $scope.getFieldSetsByName($scope.nsp + $scope.objectName);
                    $scope.describeObject($scope.nsp + $scope.objectName);

                    if ($scope.objectName === 'ObjectElement__c') {
                        $scope.sectionElement.sequence = $scope.elementObj[$scope.nsp + 'Sequence__c'];
                        $scope.sectionElement.label = ($scope.elementObj.Name || '');

                        // setup the section element dropdown
                        for (var i = 0; i < $scope.objectLayoutFields.length; i++) {
                            var el = $scope.objectLayoutFields[i];
                            if ($scope.elementObj[$scope.nsp + 'FieldApiName__c']) {
                                if (el.fieldApiName !== null) {
                                    var tmpFieldName = el.fieldApiName;
                                    if (tmpFieldName.indexOf($scope.nsp) !== -1) {
                                        tmpFieldName = tmpFieldName.substring($scope.nsp.length);
                                    }
                                    if (tmpFieldName === $scope.elementObj[$scope.nsp + 'FieldApiName__c']) {
                                        $scope.sectionElement.idx = i;
                                        break;
                                    }
                                }
                            } else {
                                if (el.attrId === $scope.elementObj[$scope.nsp + 'AttributeId__c']) {
                                    $scope.sectionElement.idx = i;
                                    break;
                                }
                            }
                        }
                    }
                };
                $scope.init();
            }
        };
    }
]);

},{}],19:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocLayoutManagement', ['$rootScope', 'remoteActions', 'cpqService',
    function($rootScope, remoteActions, cpqService) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'LayoutManagement.tpl.html',
            controller: function($scope, $sldsModal) {
                console.log('INIT: ', $scope.customViewAttrs);
                $scope.nsp = fileNsPrefix();
                $scope.objectId = $scope.customViewAttrs.objectId;
                $scope.objectApiName = $scope.customViewAttrs.objectApiName;
                $scope.layout = [];

                $scope.$on('refreshItems', function() {
                    $scope.getObjectLayoutById($scope.objectId, false);
                });

                $scope.getObjectLayoutById = function(objectId, fromParent) {
                    var inputMap = { 
                        'objectId' : objectId,
                        'isInherited' : fromParent
                    };
                    remoteActions.invokeMethod('getObjectLayoutById', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getObjectLayoutById layout manager results: ', results);
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
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.selectItem = function(item, objectName) {
                    var broadcastData = {
                        facetType: 'LAYOUT_ELEMENT',
                        facetData: {
                            objectLayoutId: $scope.objectLayoutId,
                            elementObj: item,
                            objectName: objectName,
                            objectLayoutFields: $scope.attrFieldList
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
                };

                $scope.editItem = function(item, objectName, event) {
                    if (event) {
                        event.stopPropagation();
                    }
                    $scope.selectItem(item, objectName);
                };

                $scope.deleteItem = function(item, itemName, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    var modalScope = $scope.$new();
                    modalScope.confirmationTitle = 'Delete Section Element';
                    modalScope.confirmationMsg = 'Are you sure you want to delete the section element <i>' + itemName + '</i>?';
                    modalScope.cancelActionLbl = 'Cancel';
                    modalScope.confirmActionLbl = 'Delete Section Element';
                    modalScope.confirmAction = function() {
                        var itemToDelete = {};
                        for (var key in item) {
                            if (key !== '$$hashKey') {
                                itemToDelete[key] = item[key];
                            }
                        }
                        var inputMap = { 'objectId' : itemToDelete.Id };
                        remoteActions.invokeMethod('deleteObject', JSON.stringify(inputMap)).then(function(results) {
                            console.log('delete section element results: ', results);
                            $scope.getObjectLayoutById($scope.objectId, false);
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

                $scope.deleteFacet = function(item, itemName, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    var modalScope = $scope.$new();
                    modalScope.confirmationTitle = 'Delete Facet';
                    modalScope.confirmationMsg = 'Are you sure you want to delete the facet <i>' + itemName + '</i>?';
                    modalScope.cancelActionLbl = 'Cancel';
                    modalScope.confirmActionLbl = 'Delete Facet';
                    modalScope.confirmAction = function() {
                        var itemToDelete = {};
                        for (var key in item) {
                            if (key !== '$$hashKey') {
                                itemToDelete[key] = item[key];
                            }
                        }
                        var inputMap = { 'objectFacet' : JSON.stringify(itemToDelete) };
                        remoteActions.invokeMethod('deleteFacet', JSON.stringify(inputMap)).then(function(results) {
                            console.log('delete facet results: ', results);
                            $scope.getObjectLayoutById($scope.objectId, false);
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

                $scope.deleteSection = function(item, itemName, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    var modalScope = $scope.$new();
                    modalScope.confirmationTitle = 'Delete Section';
                    modalScope.confirmationMsg = 'Are you sure you want to delete the section <i>' + itemName + '</i>?';
                    modalScope.cancelActionLbl = 'Cancel';
                    modalScope.confirmActionLbl = 'Delete Section';
                    modalScope.confirmAction = function() {
                        var itemToDelete = {};
                        for (var key in item) {
                            if (key !== '$$hashKey') {
                                itemToDelete[key] = item[key];
                            }
                        }
                        var inputMap = { 'section' : JSON.stringify(itemToDelete) };
                        remoteActions.invokeMethod('deleteSection', JSON.stringify(inputMap)).then(function(results) {
                            console.log('delete section results: ', results);
                            $scope.getObjectLayoutById($scope.objectId, false);
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

                $scope.addFacet = function() {
                    var broadcastData = {
                        facetType: 'LAYOUT_ELEMENT',
                        facetData: {
                            objectLayoutId: $scope.objectLayoutId,
                            objectName: 'ObjectFacet__c'
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
                };

                $scope.addSection = function(fId) {
                    console.log('addSection(' + fId + ')');
                    var broadcastData = {
                        facetType: 'LAYOUT_ELEMENT',
                        facetData: {
                            objectFacetId: fId,
                            objectName: 'ObjectSection__c'
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
                };

                $scope.addSectionElement = function(sId) {
                    var broadcastData = {
                        facetType: 'LAYOUT_ELEMENT',
                        facetData: {
                            objectSectionId: sId,
                            objectName: 'ObjectElement__c',
                            objectLayoutFields: $scope.attrFieldList
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
                };

                $scope.getAttributeFieldBindingData = function() {
                    $scope.attributeMap = {};
                    $scope.attrFieldList = [];

                    var inputMap = { 
                        'objectId' : $scope.objectId,
                        'allObjectAttributes' : false
                    };
                    remoteActions.invokeMethod('getAttributeFieldBindingData', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getAttributeFieldBindingData results: ', results);
                        var fieldList = results.Field;
                        var attributes = parseAAWrapper(results.AAWrapper);
                        $scope.attrFieldList = [];

                        var boundAttrMap = {};
                        var boundFieldMap = {};
                        angular.forEach(results.AttributeBinding__c, function(binding) {
                            var attrId = binding[$scope.nsp + 'AttributeId__c'];
                            var attrObj = $scope.attributeMap[attrId];
                            if (attrObj!= null) {                            
                                var attrName = attrObj.Name;
                                var attrCode = attrObj.Code;
                                var fieldName = binding[$scope.nsp + 'FieldApiName__c'];
                                boundAttrMap[attrId] = {'fieldApiName': fieldName, 'BindingId': binding.Id, 'fieldObj': fieldList[fieldName]};
                                boundFieldMap[fieldName] = {'Id': attrId, 'Name': attrName, 'Code': attrCode, 'BindingId': binding.Id};
                            }
                        });
                        angular.forEach(attributes, function(attr) {
                            var item = {};
                            item.attrId = attr.Id;
                            item.attrName = attr.Name;
                            item.attrCode = attr.Code;
                            item.label = attr.Name;
                            item.value = attr.Id;
                            if (boundAttrMap[attr.Id] === undefined) {
                                // unbound attribute
                                item.bound = false;
                                item.field = null;
                                item.fieldApiName = null;
                            } else {
                                // bound attribute/field
                                item.bound = true;
                                item.field = boundAttrMap[attr.Id].fieldObj;
                                item.fieldApiName = boundAttrMap[attr.Id].fieldApiName;
                                item.bindingId = boundAttrMap[attr.Id].BindingId;
                            }
                            item.idx = $scope.attrFieldList.length;
                            $scope.attrFieldList.push(item);
                        });
                        for (var fieldName in fieldList) {
                            var item = {};
                            if (boundFieldMap[fieldName] === undefined) {
                                // unbound field
                                item.bound = false;
                                item.field = fieldList[fieldName];
                                item.label = fieldList[fieldName].label;
                                item.fieldApiName = fieldName;
                                item.value = fieldName;
                                item.attrId = '';
                                item.attrName = '';
                                item.attrCode = '';
                                item.idx = $scope.attrFieldList.length;
                                $scope.attrFieldList.push(item);
                            }
                        }
                        console.log('$scope.attrFieldList: ', $scope.attrFieldList);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                function parseAAWrapper(aList) {
                    var attributes = [];
                    angular.forEach(aList, function(aItem) {
                        var attr = {};
                        if (aItem.aa) {
                            // use attribute assignment
                            attr.aaId = aItem.aa.Id;
                            attr.Id = aItem.aa[$scope.nsp + 'AttributeId__c'];
                            attr.Name = aItem.aa[$scope.nsp + 'AttributeDisplayName__c'];
                            attr.Code = aItem.aa[$scope.nsp + 'AttributeUniqueCode__c'];
                        } else {
                            // use attribute
                            attr.Id = aItem.attribute.Id;
                            attr.Name = aItem.attribute.Name;
                            attr.Code = aItem.attribute[$scope.nsp + 'Code__c'];
                        }
                        $scope.attributeMap[attr.Id] = attr;
                        attributes.push(attr);
                    });
                    return attributes;
                }

                $scope.init = function() {
                    console.log('initting layout mgr');
                    $scope.getObjectLayoutById($scope.objectId, false);
                    $scope.getAttributeFieldBindingData();
                };
                $scope.init();
            }
        };
    }
]);

},{}],20:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocObjAttrsFields', ['$rootScope', 'remoteActions', '$sldsModal', 'cpqService',
    function($rootScope, remoteActions, $sldsModal, cpqService) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'VlocObjAttrsFields.tpl.html',
            controller: function($scope) {
                console.log('INIT: ', $scope.customViewAttrs);
                $scope.nsp = fileNsPrefix();
                $scope.objectId = $scope.customViewAttrs.objectId;
                $scope.objectName = $scope.customViewAttrs.objectApiName;
                $scope.items = [];

                $scope.$on('refreshItems', function() {
                    $scope.getAppliedAttributesFields();
                });

                $scope.getAppliedAttributesFields = function() {
                    $scope.AttrObjMap = {};
                    $scope.AttrAssgnObjMap = {};
                    $scope.attributeMap = {};
                    var items = [];
                    $scope.assignedItems = {};
                    $scope.allSelected = false;
                    $scope.selectedCount = 0;

                    var inputMap = { 'objectId' : $scope.objectId };
                    remoteActions.invokeMethod('getAppliedAttributesFields', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getAppliedAttributesFields results:', results);
                        angular.forEach(results, function(r) {
                            var item = {};
                            item.isSelected = false;

                            if (r.field) {
                                item.fieldName = r.objectFieldAttribute[$scope.nsp + 'FieldApiName__c'];
                                item.fieldLabel = r.field.label;
                                item.attrId = '';
                                item.attrName = '';
                                item.attrCode = '';
                                $scope.assignedItems[item.fieldName] = '';
                            } else if (r.aaWrapper) {
                                var aItem = r.aaWrapper;
                                if (aItem.attributeAssignment) {
                                    // use attribute assignment
                                    item.aaId = aItem.attributeAssignment.Id;
                                    item.attrId = aItem.attributeAssignment[$scope.nsp + 'AttributeId__c'];
                                    item.attrName = aItem.attributeAssignment[$scope.nsp + 'AttributeDisplayName__c'];
                                    item.attrCode = aItem.attributeAssignment[$scope.nsp + 'AttributeUniqueCode__c'];
                                    $scope.AttrAssgnObjMap[item.attrId] = aItem.attributeAssignment;
                                } else {
                                    // use attribute
                                    item.attrId = aItem.attribute.Id;
                                    item.attrName = aItem.attribute.Name;
                                    item.attrCode = aItem.attribute[$scope.nsp + 'Code__c'];
                                    $scope.AttrAssgnObjMap[item.attrId] = null;
                                }
                                item.fieldName = '';
                                item.fieldLabel = '';
                                $scope.AttrObjMap[item.attrId] = aItem.attribute;
                                $scope.assignedItems[item.attrId] = '';
                                $scope.attributeMap[item.attrId] = aItem.attribute;
                            }
                            items.push(item);
                        });
                        $scope.items = items;
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.selectAll = function() {
                    angular.forEach($scope.items, function(item) {
                        item.isSelected = $scope.allSelected;
                        $scope.selectItem(item);
                    });
                    $scope.selectedCount = ($scope.allSelected ? $scope.items.length : 0);
                };

                $scope.selectItem = function(item) {
                    if (item.isSelected) {
                        $scope.selectedCount++;
                    } else {
                        $scope.selectedCount--;
                        $scope.allSelected = false;
                    }
                };

                $scope.unassignAttrsFields = function() {
                    var modalScope = $scope.$new();
                    modalScope.confirmationTitle = 'Unassign Attributes and Fields';
                    modalScope.confirmationMsg = 'The attributes and fields will also be removed from all child object types and object instances.';
                    modalScope.cancelActionLbl = 'Cancel';
                    modalScope.confirmActionLbl = 'Unassign';
                    modalScope.confirmAction = function() {
                        var selectedAttrList = [];
                        angular.forEach($scope.items, function(item) {
                            if (item.isSelected) {
                                console.log('unapplyFieldAttribute', item);
                                var inputMap = { 
                                    'objectId' : $scope.objectId,
                                    'fieldName' : item.fieldName,
                                    'attributeId' : item.attrId
                                };
                                remoteActions.invokeMethod('unapplyFieldAttribute', JSON.stringify(inputMap)).then(function(results) {
                                    console.log('unapplyFieldAttribute results: ', results);
                                    $scope.getAppliedAttributesFields();
                                }, function(error) {
                                    cpqService.showNotification({
                                        type: 'error',
                                        title: 'Error',
                                        content: error.message
                                    });
                                });
                            }
                        });
                        deleteModal.hide();
                    };

                    var deleteModal = $sldsModal({
                        templateUrl: 'ConfirmationModal.tpl.html',
                        backdrop: 'static',
                        scope: modalScope,
                        show: true
                    });
                
                };

                $scope.showAllAttrsFields = function() {
                    var broadcastData = {
                        facetType: 'ASSIGN_ATTRS_FIELDS',
                        facetData: {
                            objectId: $scope.objectId,
                            assignedItems: $scope.assignedItems
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
                };

                $scope.showAttributeMetadata = function(attrId) {
                    var broadcastData = {
                        facetType: 'ATTR_METADATA',
                        facetData: {
                            objectId: $scope.objectId,
                            attrObj: $scope.AttrObjMap[attrId],
                            attrAssgnObj: $scope.AttrAssgnObjMap[attrId],
                            mode: 'edit'
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
                };

                $scope.showFieldMetadata = function(objectName, fieldName) {
                    var objApiName = $scope.objectName;
                    var broadcastData = {
                        facetType: 'FIELD_METADATA',
                        facetData: {
                            objectName: objApiName,
                            fieldName: fieldName
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
                };

                $scope.init = function() {
                    $scope.getAppliedAttributesFields();
                };
                $scope.init();
            }
        };
    }
]);

},{}],21:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocObjField', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                displayMode: '=',
                parentObj: '=',
                formElementName: '=',
                fieldName: '=',
                fieldInfo: '=',
                objPicklists: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ObjectField.tpl.html',
            controller: function($scope, $sldsModal, $timeout) {
                $scope.initLookupItem = function() {
                    var referencedFieldName;
                    $scope.lookupMap = {};
                    $scope.lookupObj = {
                        selectedItem: ''
                    };

                    var referencedId = $scope.parentObj[$scope.fieldName];
                    if (referencedId !== undefined && referencedId !== '') {
                        if ($scope.fieldName.endsWith('__c')) {
                            referencedFieldName = $scope.fieldName.substring(0, ($scope.fieldName.length - 1)) + 'r';
                        } else {
                            referencedFieldName = $scope.fieldName.substring(0, ($scope.fieldName.length - 2));
                        }

                        if ($scope.parentObj[referencedFieldName] === undefined) {
                            $scope.getReferencedFieldObject(referencedId);
                        } else {
                            $scope.lookupObj.selectedItem = $scope.parentObj[referencedFieldName].Name;
                        }
                    }
                };

                $scope.getReferencedFieldObject = function(objectId) {
                    var inputMap = { 'objectId' : objectId };
                    remoteActions.invokeMethod('getObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getReferencedFieldObject results: ', results);
                        $scope.lookupObj.selectedItem = results.Name;
                        $scope.parentObj[$scope.fieldName] = objectId;
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.searchReferenceField = function(event) {
                    var modalScope = $scope.$new();
                    modalScope.nsp = fileNsPrefix();
                    modalScope.modalTitle = $scope.fieldInfo.label + ' Lookup';
                    modalScope.cancelActionLbl = 'Cancel';
                    modalScope.fieldInfo = $scope.fieldInfo;
                    modalScope.searchResults = null;
                    modalScope.searchCfg = {
                        currentPage: 1,
                        totalPages: 1,
                        searchTerm: $scope.lookupObj.selectedItem
                    };

                    modalScope.getFieldSetsByName = function() {
                        var inputMap = { 'objectName' : modalScope.fieldInfo.referenceTo };
                        remoteActions.invokeMethod('getFieldSetsByName', JSON.stringify(inputMap)).then(function(results) {
                            if (results[modalScope.nsp.toLowerCase() + 'consoleadminsearch'] === undefined) {
                                modalScope.fieldSet = null;
                            } else {
                                modalScope.fieldSet = results[modalScope.nsp.toLowerCase() + 'consoleadminsearch'];
                            }
                        }, function(error) {
                            cpqService.showNotification({
                                type: 'error',
                                title: 'Error',
                                content: error.message
                            });
                        });
                    };

                    modalScope.searchReferenceField = function(pageNum) {
                        if (pageNum) {
                            modalScope.searchCfg.currentPage = pageNum;
                        }
                        if (modalScope.searchCfg.currentPage < 1) {
                            modalScope.searchCfg.currentPage = 1;
                        }
                        if (modalScope.searchCfg.totalPages !== 0 && (modalScope.searchCfg.currentPage > modalScope.searchCfg.totalPages)) {
                            modalScope.searchCfg.currentPage = modalScope.searchCfg.totalPages;
                        }

                        var searchTerm = modalScope.searchCfg.searchTerm.trim().toLowerCase();
                        if (searchTerm === '') {
                            searchTerm = '%';
                        }
                        var searchInputMap = {
                            'objectType': modalScope.fieldInfo.referenceTo,
                            'searchString': searchTerm,
                            'pageNumber': modalScope.searchCfg.currentPage,
                            'fieldSetName': 'consoleadminsearch'
                        };
                        var searchInputMapJSON = JSON.stringify(searchInputMap);
                        remoteActions.invokeMethod('getSearchResultsMap', searchInputMapJSON).then(function(response) {
                            console.log('search results for ' + searchTerm + ': ', response);
                            modalScope.searchCfg.previousPage = response.previousPage;
                            modalScope.searchCfg.nextPage = response.nextPage;
                            modalScope.searchCfg.totalCount = response.totalCount;
                            modalScope.searchCfg.totalPages = response.totalPages;
                            modalScope.searchCfg.pageSize = response.pageSize;
                            modalScope.searchCfg.fromCount = response.fromCount;
                            modalScope.searchCfg.toCount = response.toCount;
                            modalScope.searchCfg.nameField = response.nameField;
                            modalScope.searchResults = response.results;
                        }, function(error) {
                            cpqService.showNotification({
                                type: 'error',
                                title: 'Error',
                                content: error.message
                            });
                        });
                    };

                    modalScope.setReferenceField = function(itemId, itemName) {
                        modalScope.$parent.setReferenceField(itemId, itemName);
                        lookupReferenceModal.hide();
                    };

                    var lookupReferenceModal = $sldsModal({
                        templateUrl: 'LookupReferenceModal.tpl.html',
                        backdrop: 'static',
                        scope: modalScope,
                        show: true
                    });

                    if (modalScope.searchCfg.searchTerm.trim().length > 0) {
                        modalScope.searchReferenceField(1);
                    }
                };

                $scope.setReferenceField = function(itemId, itemName) {
                    $scope.lookupObj.selectedItem = itemName;
                    $scope.parentObj[$scope.fieldName] = itemId;
                    $scope.lookupMap[itemName] = itemId;
                };

                $scope.selectLookupItem = function(luItem) {
                    if (luItem === null) {
                        var itemId = $scope.lookupMap[$scope.lookupObj.selectedItem];
                        $scope.parentObj[$scope.fieldName] = (itemId || '');
                    } else {
                        $scope.lookupObj.selectedItem = luItem.Name;
                        $scope.parentObj[$scope.fieldName] = luItem.Id;
                    }
                    $scope.lookupObj.showItems = false;
                };

                $scope.setMultiPicklistValues = function(selectedMPItems) {
                    $scope.parentObj[$scope.fieldName] = selectedMPItems.join(';');
                };

                $scope.init = function() {
                    $scope.fieldProp = {};
                    if ($scope.fieldInfo !== undefined) {
                        $scope.fieldProp.disabled = !$scope.fieldInfo.isCreateable && !$scope.fieldInfo.isUpdateable;
                        $scope.fieldProp.required = $scope.fieldInfo.isRequired;

                        if ($scope.fieldInfo.type === 'DATE') {
                            if ($scope.parentObj[$scope.fieldName] !== undefined) {
                                var timezoneOffset = (window.userTimezoneOffset || window.parent.userTimezoneOffset);
                                $scope.parentObj[$scope.fieldName] += timezoneOffset;
                            }
                        }
                        if ($scope.fieldInfo.type === 'REFERENCE') {
                            $scope.initLookupItem();
                        }
                        if ($scope.fieldInfo.type === 'PICKLIST' || $scope.fieldInfo.type === 'OTPICKLIST') {
                            if ($scope.parentObj[$scope.fieldName] === undefined) {
                                /* This should only be done in 'create' mode, which we don't support yet
                                angular.forEach($scope.objPicklists, function(o) {
                                    if (o.isDefault) {
                                        $scope.selectedPicklistItem = o.value;
                                    }
                                });
                                */
                            } else {
                                $scope.selectedPicklistItem = $scope.parentObj[$scope.fieldName];
                            }
                        }
                        if ($scope.fieldInfo.type === 'MULTIPICKLIST') {
                            if ($scope.parentObj[$scope.fieldName] !== undefined) {
                                var values = $scope.parentObj[$scope.fieldName].split(';');
                                angular.forEach($scope.objPicklists, function(o) {
                                    o.selected = (values.indexOf(o.value) !== -1);
                                });
                            }
                        }
                        if ($scope.fieldInfo.type === 'BOOLEAN') {
                            if ($scope.parentObj[$scope.fieldName] === undefined) {
                                //TODO: describeObject api should return defaultValue. isDefaultedOnCreate just states whether or not it is defaulted. for now default to false.
                                $scope.parentObj[$scope.fieldName] = 'false';
                            }
                        }
                    }
                };
                $scope.init();

                var initializing = true;
                $scope.$watch('fieldInfo', function(newValue) {
                    if (initializing) {
                        $timeout(function() { initializing = false; });
                    } else {
                        $scope.init();
                    }
                }, true);

                var initializing2 = true;
                $scope.$watch('lookupObj.selectedItem', function(newValue) {
                    if (initializing2) {
                        $timeout(function() { initializing2 = false; });
                    } else {
                        if (newValue === '') {
                            $scope.parentObj[$scope.fieldName] = '';
                        }
                    }
                }, true);
            }
        };
    }
]);

},{}],22:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocObjectPricing', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ObjectPricing.tpl.html',
            controller: function($scope, $rootScope, $sldsModal, $compile) {
                $scope.mode = $scope.customViewAttrs.mode;
                $scope.pricingMode = $scope.customViewAttrs.pricingMode;
                $scope.objectId = $scope.customViewAttrs.objectId;
                $scope.nsp = fileNsPrefix();

                $scope.OBJECT_NAME = 'PriceListEntry__c';

                $scope.$on('refreshObjectPricingElements', function() {
                    $scope.getPriceListEntries();
                });

                $scope.getPriceListEntries = function() {
                    var inputMap = {};
                    if ($scope.pricingMode === 'PRICELIST') {
                        var pricelistIds = [];
                        pricelistIds.push($scope.objectId);
                        inputMap['PriceListIds'] = pricelistIds;
                    } else if ($scope.pricingMode === 'PRODUCT') {
                        var productIds = [];
                        productIds.push($scope.objectId);
                        inputMap['ProductIds'] = productIds;
                    }
                    var inputs = {
                        'input' : JSON.stringify(inputMap),
                        'options' : ''
                    };
                    remoteActions.invokeMethod('getPricingElements', JSON.stringify(inputs)).then(function(results) {
                        console.log('getPricingElements results: ', results);
                        $scope.processPriceListEntries(results);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.processPriceListEntries = function(results) {
                    $scope.chargeItems = [];
                    $scope.usageItems = [];
                    $scope.chargeDiscountItems = [];
                    $scope.chargeOverrideItems = [];

                    angular.forEach(results, function(item) {
                        var hasCharges = false;
                        var chargeCount = 0;
                        var hasUsages = false;
                        var usageCount = 0;
                        var hasChargeDiscounts = false;
                        var chargeDiscountCount = 0;
                        var hasChargeOverrides = false;
                        var chargeOverrideCount = 0;

                        angular.forEach(item.priceVars, function(pv) {
                            if (pv.charges && pv.charges.length > 0) {
                                hasCharges = true;
                                chargeCount += pv.charges.length;
                                pv.hasCharges = true;
                            } else {
                                pv.hasCharges = false;
                            }
                            if (pv.usages && pv.usages.length > 0) {
                                hasUsages = true;
                                usageCount += pv.usages.length;
                                pv.hasUsages = true;
                            } else {
                                pv.hasUsages = false;
                            }
                            if (pv.adjustments && pv.adjustments.length > 0) {
                                hasChargeDiscounts = true;
                                chargeDiscountCount += pv.adjustments.length;
                                pv.hasChargeDiscounts = true;
                            } else {
                                pv.hasChargeDiscounts = false;
                            }
                            if (pv.overrides && pv.overrides.length > 0) {
                                hasChargeOverrides = true;
                                chargeOverrideCount += pv.overrides.length;
                                pv.hasChargeOverrides = true;
                            } else {
                                pv.hasChargeOverrides = false;
                            }
                        });

                        if (hasCharges) {
                            item.chargeCount = chargeCount;
                            $scope.chargeItems.push(item);
                        }
                        if (hasUsages) {
                            item.usageCount = usageCount;
                            $scope.usageItems.push(item);
                        }
                        if (hasChargeDiscounts) {
                            item.chargeDiscountCount = chargeDiscountCount;
                            $scope.chargeDiscountItems.push(item);
                        }
                        if (hasChargeOverrides) {
                            item.chargeOverrideCount = chargeOverrideCount;
                            $scope.chargeOverrideItems.push(item);
                        }
                    });
                };

                $scope.selectItem = function(item, elemObjType) {
                    var broadcastData = {
                        facetType: 'PRICELIST_ENTRY',
                        facetData: {
                            priceListEntryItem: item,
                            pricingMode: $scope.pricingMode,
                            pricingElementObjectType: elemObjType,
                            isAdj: $scope.isAdj
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
                };

                $scope.newItem = function(elemObjType) {
                    $scope.isAdj = false;
                    $scope.selectItem(null, elemObjType);
                };

                $scope.newItemAdj = function() {
                    $scope.isAdj = true;
                    $scope.selectItem(null, elemObjType);
                };

                $scope.deleteItem = function(item, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    var modalScope = $scope.$new();
                    modalScope.confirmationTitle = 'Delete Price List Entry';
                    modalScope.confirmationMsg = 'Are you sure you want to delete the price list entry for <i>' + item[$scope.nsp + 'PricingElementId__r'].Name + '</i>?';
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
                            console.log('delete price list entry results: ', results);
                            $rootScope.$broadcast('refreshObjectPricingElements');
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

                $scope.describeObject = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('Pricing Elements - describeObject results: ', results);
                        $scope.objectFields = results;
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getObjectTypes = function() {
                    var inputMap = { 'objectName' : $scope.nsp + 'PricingElement__c' };
                    remoteActions.invokeMethod('getObjectClassTypesByName', JSON.stringify(inputMap)).then(function(results) {
                        angular.forEach(results, function(objType) {
                            if (objType.Name === 'Charge') {
                                $scope.ChargeOT = objType;
                            }
                            if (objType.Name === 'Usage') {
                                $scope.UsageOT = objType;
                            }
                        });
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
                    $scope.getObjectTypes();
                    $scope.getPriceListEntries();
                };
                $scope.init();
            }
        };
    }
]);

},{}],23:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocObjectPricingElement', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                priceListId: '=',
                pricingElementItem: '=',
                pricingElementObjectType: '=',
                isGlobal: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ObjectPricingElement.tpl.html',
            controller: function($scope, $rootScope, $sldsModal, $compile, $window) {
                $scope.nsp = fileNsPrefix();
                $scope.currencySymbol = currencySymbol;
                $scope.OBJECT_NAME = 'PricingElement__c';

                $scope.describeObject = function(objectName) {
                    var inputMap = { 'objectName' : $scope.nsp + 'PricingVariable__c' };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        $scope.objectFieldsPV = results;
                        console.log('describeObject PricingVariable__c results: ', $scope.objectFieldsPV);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                    var inputMap2 = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap2)).then(function(results) {
                        $scope.objectFields = results;
                        console.log('describeObject results: ', $scope.objectFields);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getObjectPicklistsByName = function(objectName) {
                    var inputMap = { 'objectName' : $scope.nsp + 'PricingVariable__c' };
                    remoteActions.invokeMethod('getObjectPicklistsByName', JSON.stringify(inputMap)).then(function(results) {
                        $scope.objectPicklistsPV = {};
                        for (var key in results) {
                            if (key.endsWith('__c')) {
                                $scope.objectPicklistsPV[$scope.nsp + key] = results[key];
                            } else {
                                $scope.objectPicklistsPV[key] = results[key];
                            }
                        }
                        console.log('getObjectPicklistsByName PricingVariable__c results:', $scope.objectPicklistsPV);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                    var inputMap2 = { 'objectName' : objectName };
                    remoteActions.invokeMethod('getObjectPicklistsByName', JSON.stringify(inputMap2)).then(function(results) {
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
                        console.log('create pricing element results:', results);
                        $rootScope.$broadcast('refreshObjectPricingElements');
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
                        console.log('save pricing element results:', results);
                        $rootScope.$broadcast('refreshObjectPricingElements');
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

                $scope.closeDetails = function() {
                    $rootScope.$broadcast('hideItemDetails');
                };

                $scope.searchPriceVariables = function() {
                    delete $scope.selectedPV;
                    var inputMap = {};
                    for (var key in $scope.editPV) {
                        if ($scope.editPV[key]) {
                            inputMap[key] = $scope.editPV[key];
                        }
                    }
                    if (inputMap[$scope.nsp + 'ChargeType__c'] !== 'Recurring') {
                        delete inputMap[$scope.nsp + 'RecurringFrequency__c'];
                    }
                    var inputMapJSON = JSON.stringify(inputMap);

                    var inputMap = {
                        'objectName' : $scope.nsp + 'PricingVariable__c',
                        'inputMap' : inputMapJSON
                     };
                    remoteActions.invokeMethod('searchObjectFields', JSON.stringify(inputMap)).then(function(results) {
                        $scope.pricingVariableList = results;
                        $scope.showPVList = true;
                        console.log('pricingVariableList results: ', $scope.pricingVariableList);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.selectPricingVariable = function(pv) {
                    $scope.selectedPV = pv;
                    $scope.showPVList = false;
                    $scope.editItem[$scope.nsp + 'PricingVariableId__c'] = pv.Id;
                };

                $scope.gotoSFObject = function(objectId) {
                    $window.open(sfBaseUrl + '/' + objectId);
                };

                $scope.init = function() {
                    $scope.editItem = {};
                    $scope.editPV = {};
                    $scope.editPV[$scope.nsp + 'ValueType__c'] = 'Pricing Element';
                    $scope.currentStep = 1;
                    $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                    $scope.getObjectPicklistsByName($scope.nsp + $scope.OBJECT_NAME);
                    $scope.pricingVariableList = [];
                    $scope.showPVList = false;

                    if ($scope.pricingElementItem == null) {
                        $scope.mode = 'new';
                        $scope.pricingElementItem = {};
                        $scope.editItem[$scope.nsp + 'ObjectTypeId__c'] = $scope.pricingElementObjectType.Id;
                        $scope.editItem[$scope.nsp + 'IsReusable__c'] = true;
                        if (!$scope.isGlobal) {
                            $scope.editItem[$scope.nsp + 'PriceListId__c'] = $scope.priceListId;
                        }
                    } else {
                        $scope.mode = 'edit';
                        var key;
                        for (key in $scope.pricingElementItem) {
                            if (key !== '$$hashKey') {
                                $scope.editItem[key] = $scope.pricingElementItem[key];
                            }
                        }
                        $scope.selectedPV = $scope.pricingElementItem[$scope.nsp + 'PricingVariableId__r'];
                        $scope.editPV[$scope.nsp + 'ChargeType__c'] = $scope.selectedPV[$scope.nsp + 'ChargeType__c'];
                        $scope.editPV[$scope.nsp + 'RecurringFrequency__c'] = $scope.selectedPV[$scope.nsp + 'RecurringFrequency__c'];
                        $scope.editPV[$scope.nsp + 'SubType__c'] = $scope.selectedPV[$scope.nsp + 'SubType__c'];
                        $scope.editPV[$scope.nsp + 'Type__c'] = $scope.selectedPV[$scope.nsp + 'Type__c'];
                    }

                    $scope.step2Fields = [];
                    $scope.step2Fields.push('Name');
                    $scope.step2Fields.push($scope.nsp + 'Code__c');
                    $scope.step2Fields.push($scope.nsp + 'DisplayText__c');
                    $scope.step2Fields.push($scope.nsp + 'HelpText__c');
                    $scope.step2Fields.push($scope.nsp + 'VersionNumber__c');

                    $scope.step4Fields = [];
                    $scope.step4Fields.push($scope.nsp + 'EffectiveFromDate__c');
                    $scope.step4Fields.push($scope.nsp + 'EffectiveUntilDate__c');
                    $scope.step4Fields.push($scope.nsp + 'IsActive__c');

                    $scope.chargeTypePicklist = [];
                    if ($scope.pricingElementObjectType.Name === 'Charge') {
                        $scope.chargeTypePicklist.push({'label': 'Recurring', value: 'Recurring'});
                        $scope.chargeTypePicklist.push({'label': 'One-time', value: 'One-time'});
                    } else if ($scope.pricingElementObjectType.Name === 'Usage') {
                        $scope.chargeTypePicklist.push({'label': 'Usage', value: 'Usage'});
                        $scope.editPV[$scope.nsp + 'ChargeType__c'] = 'Usage';
                    } else if ($scope.pricingElementObjectType.Name === 'Discount') {
                        $scope.chargeTypePicklist.push({'label': 'Adjustment', value: 'Adjustment'});
                        $scope.editPV[$scope.nsp + 'ChargeType__c'] = 'Adjustment';
                    }
                };
                $scope.init();
            }
        };
    }
]);

},{}],24:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocObjectPricingElements', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                customViewAttrs: '=',
                mode: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ObjectPricingElements.tpl.html',
            controller: function($scope, $rootScope, $sldsModal, $compile) {
                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = 'PricingElement__c';
                $scope.chargeList = [];
                $scope.discountList = [];

                console.log('INIT ObjectPricingElements: ', $scope.customViewAttrs.objectPricingElements);
                $scope.objectId = $scope.customViewAttrs.objectPricingElements.objectId;
                $scope.objectType = $scope.customViewAttrs.objectPricingElements.objectType;
                $scope.objectAPIName = $scope.customViewAttrs.objectPricingElements.objectAPIName;

                $scope.isGlobal = ($scope.mode === 'global');

                $scope.$on('hideItemDetails', function() {
                    $scope.init();
                });

                $scope.newItem = function(elemObjType) {
                    var broadcastData = {
                        facetType: 'OBJECT_PRICING_ELEMENT',
                        facetData: {
                            pricingElementItem: null,
                            pricingElementObjectType: elemObjType,
                            isGlobal: $scope.isGlobal
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
                };

                $scope.editItem = function(item, elemObjType, event) {
                    if (event) {
                        event.stopPropagation();
                    }
                    var broadcastData = {
                        facetType: 'OBJECT_PRICING_ELEMENT',
                        facetData: {
                            pricingElementItem: item,
                            pricingElementObjectType: elemObjType,
                            isGlobal: $scope.isGlobal
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
                };

                $scope.deleteItem = function(item, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    var modalScope = $scope.$new();
                    modalScope.confirmationTitle = 'Delete Pricing Element';
                    modalScope.confirmationMsg = 'Are you sure you want to delete the pricing element <i>' + item.Name + '</i>?';
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
                            console.log('delete pricing element results: ', results);
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

                $scope.getObjectTypes = function() {
                    var inputMap = { 'objectName' : $scope.nsp + $scope.OBJECT_NAME };
                    remoteActions.invokeMethod('getObjectClassTypesByName', JSON.stringify(inputMap)).then(function(results) {
                        angular.forEach(results, function(objType) {
                            if (objType.Name === 'Charge') {
                                $scope.ChargeOT = objType;
                            }
                            if (objType.Name === 'Usage') {
                                $scope.UsageOT = objType;
                            }
                            if (objType.Name === 'Discount') {
                                $scope.DiscountOT = objType;
                            }
                        });

                        if ($scope.isGlobal) {
                            $scope.getGlobalPricingElements($scope.ChargeOT);
                            $scope.getGlobalPricingElements($scope.UsageOT);
                            $scope.getGlobalPricingElements($scope.DiscountOT);
                        } else {
                            $scope.getStandalonePricingElements($scope.ChargeOT);
                            $scope.getStandalonePricingElements($scope.UsageOT);
                            $scope.getStandalonePricingElements($scope.DiscountOT);
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getGlobalPricingElements = function(objectType) {
                    var inputMap = { 
                        'objectTypeId' : objectType.Id,
                        'sortBy' : ''
                    };
                    remoteActions.invokeMethod('getGlobalPricingElements', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getGlobalPricingElements for ', objectType.Name, ': ', results);
                        if (objectType.Name === 'Charge') {
                            $scope.chargeList = results;
                        }
                        if (objectType.Name === 'Usage') {
                            $scope.usageList = results;
                        }
                        if (objectType.Name === 'Discount') {
                            $scope.discountList = results;
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getStandalonePricingElements = function(objectType) {
                    var inputMap = { 
                        'priceListId' : $scope.objectId,
                        'objectTypeId' : objectType.Id,
                        'sortBy' : ''
                    };
                    remoteActions.invokeMethod('getStandalonePricingElements', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getStandalonePricingElements for ', objectType.Name, ': ', results);
                        if (objectType.Name === 'Charge') {
                            $scope.chargeList = results;
                        }
                        if (objectType.Name === 'Usage') {
                            $scope.usageList = results;
                        }
                        if (objectType.Name === 'Discount') {
                            $scope.discountList = results;
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.init = function() {
                    $scope.getObjectTypes();
                };
                $scope.init();
            }
        };
    }
]);

},{}],25:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocObjectType', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                item: '=',
                parentItem: '=',
                objectName: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ObjectType.tpl.html',
            controller: function($scope, $rootScope, $timeout) {
                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = 'ObjectClass__c';
                $scope.editItem = {};
                $scope.facets = [];

                $scope.getObjectLayoutByName = function(objectName, recordType) {
                    var inputMap = { 
                        'objectName' : objectName,
                        'recordType' : recordType
                    };
                    remoteActions.invokeMethod('getObjectLayoutByName', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getObjectLayoutByName vlocObjectType item results: ', results);
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
                        console.log('getObjectLayoutById vlocObjectType item results: ', results);
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
                    console.log('FACETS for vlocObjectType: ', $scope.facets);
                };

                $scope.describeObjectWithQuery = function(objectName) {
                    var queryMap = {};
                    $scope.objectName = $scope.objectName.replace($scope.nsp, '');
                    var parentOTQueryFilter = 'WHERE ' + $scope.nsp + 'ObjectApiName__c = \'' + $scope.objectName + '\' AND RecordType.Name = \'Object Type\'';
                    var lookupFieldName = $scope.nsp + 'ParentObjectClassId__c';
                    queryMap[lookupFieldName] = parentOTQueryFilter;

                    var inputMap = { 
                        'objectName' : objectName,
                        'inputMap' : JSON.stringify(queryMap)
                    };
                    remoteActions.invokeMethod('describeObjectWithQuery', JSON.stringify(inputMap)).then(function(results) {
                        $scope.objectFields = results;
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
                        if (key !== '$$hashKey' && $scope.editItem[key] !== '') {
                            itemToSave[key] = $scope.editItem[key];
                        }
                    }
                    itemToSave[$scope.nsp + 'RootObjectClassId__c'] = $scope.parentItem;

                    var inputs= { 'inputMap' : itemToSave };
                    remoteActions.invokeMethod('createObjectType', JSON.stringify(inputs)).then(function(results) {
                        console.log('create vlocObjectType item results: ', results);
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
                    console.log('save vlocObjectType editItem',$scope.editItem);
                    for (var key in $scope.editItem) {
                        if (key !== '$$hashKey') {
                            itemToSave[key] = ($scope.editItem[key] === null ? undefined : $scope.editItem[key]);
                        }
                    }

                    var inputMap = { 'so' : JSON.stringify(itemToSave) };
                    remoteActions.invokeMethod('updateObject', inputMap).then(function(results) {
                        console.log('save vlocObjectType item results: ', results);
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

                $scope.init = function() {
                    console.log('object type init; ', $scope.parentItem);
                    if ($scope.item.Id === undefined) {
                        $scope.getObjectLayoutByName($scope.OBJECT_NAME, '');
                        //TODO: Remove if parentItem is not relevant
                        if ($scope.parentItem !== null && $scope.parentItem !== undefined) {
                            $scope.editItem[$scope.nsp + 'ObjectId__c'] = $scope.parentItem.Id;
                        }
                    } else {
                        $scope.getObjectLayoutById($scope.item.Id, true);

                        for (var key in $scope.item) {
                            if (key !== '$$hashKey') {
                                $scope.editItem[key] = $scope.item[key];
                            }
                        }
                    }

                    $scope.describeObjectWithQuery($scope.nsp + $scope.OBJECT_NAME);
                };
                $scope.init();
            }
        };
    }
]);

},{}],26:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocObjectTypes', ['$rootScope', 'remoteActions', 'cpqService',
    function($rootScope, remoteActions, cpqService) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ObjectTypes.tpl.html',
            controller: function($scope, $sldsModal) {
                $scope.objectId = $scope.customViewAttrs.objectId;
                $scope.objName = $scope.customViewAttrs.objName;
                $scope.OBJECT_NAME = 'ObjectClass__c';

                $scope.nsp = fileNsPrefix();

                $scope.newItem = function() {
                    $scope.selectItem({});
                };

                $scope.$on('refreshItems', function() {
                    $scope.getObjectTypes($scope.objectId);
                });

                $scope.selectItem = function(item) {
                    var broadcastData = {
                        facetType: 'OBJECT_TYPE',
                        facetData: {
                            objectTypeItem: item,
                            objectClassItem: $scope.objectId
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
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
                    modalScope.confirmationTitle = 'Delete Object Type';
                    modalScope.confirmationMsg = 'Are you sure you want to delete the Object Type <i>' + item.Name + '</i>?';
                    modalScope.cancelActionLbl = 'Cancel';
                    modalScope.confirmActionLbl = 'Delete Object Type';
                    modalScope.confirmAction = function() {
                        var itemToDelete = {};
                        for (var key in item) {
                            if (key !== '$$hashKey') {
                                itemToDelete[key] = item[key];
                            }
                        }
                        var inputs= { 'objectTypeId' : itemToDelete.Id };
                        remoteActions.invokeMethod('deleteObjectType', JSON.stringify(inputs)).then(function(results) {
                            console.log('delete Object Type results: ', results);
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

                $scope.getObjectTypes = function(objectId) {
                    console.log('getObjectTypes(' + objectId + ')');
                    var inputMap = { 'objectClassId' : objectId };
                    remoteActions.invokeMethod('getObjectClassTypes', JSON.stringify(inputMap)).then(function(results) {
                        console.log('ObjectTyeps - getObjectTypes results:', results);
                        $scope.items = results;
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
                        console.log('ObjectTypes - describeObject results: ', results);
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
                        if (results[$scope.nsp.toLowerCase() + 'objecttype'] === undefined) {
                            $scope.fieldSet = null;
                        } else {
                            $scope.fieldSet = results[$scope.nsp.toLowerCase() + 'objecttype'];
                        }
                        console.log('ObjectTypes - getFieldSets results: ', $scope.fieldSet);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.launchTab = function(item) {
                    console.log('launchTab:item: ', item);
                    console.log('launchTab:objectId: ', $scope.objectId);
                    var data = {
                        'objectId': 'objecttype',
                        'obj': item,
                        'closeCurrentTab': false
                    };
                    var broadcastAction = {
                        'eventName': 'launchConsoleTab',
                        'eventData': data
                    };
                    if (window.frameElement !== null) {
                        // create a iframe resize event binding with the parent
                        window.parent.bindIframeEvents('broadcast', broadcastAction);
                    }
                };

                $scope.init = function() {
                    console.log('object types init -- ');
                    $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                    $scope.getFieldSetsByName($scope.nsp + $scope.OBJECT_NAME);

                    $scope.getObjectTypes($scope.objectId);
                };
                $scope.init();
            }
        };
    }
]);

},{}],27:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocOfferPricingComponent', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                offerId: '=',
                offerComponentId: '=',
                contractId: '=',
                offerPricingItem: '=',
                mode: '=',
                rootProductId: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'OfferPricingComponent.tpl.html',
            controller: function($scope, $rootScope, $timeout) {
                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = 'OfferPricingComponent__c';
                console.log('RECEIVING PRODUCT ID: ', $scope.offerId);

                $scope.describeObject = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('describeObject results: ', results);
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

                $scope.getObjectLayoutByName = function(objectName, recordType) {
                    var inputMap = { 
                        'objectName' : objectName,
                        'recordType' : recordType
                    };
                    remoteActions.invokeMethod('getObjectLayoutByName', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getObjectLayoutByName offer price component results: ', results);
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
                    console.log('FACETS for offer price component: ', $scope.facets);
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
                    itemToSave[$scope.nsp + 'OfferId__c'] = $scope.offerId;

                    var inputMap = { 
                        'objectName' : $scope.nsp + $scope.OBJECT_NAME,
                        'inputMap' : itemToSave
                    };
                    remoteActions.invokeMethod('createObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('create offer pricing component results: ', results);
                        if (event) {
                            event.currentTarget.innerText = originalText;
                            event.currentTarget.disabled = false;
                        }
                        $rootScope.$broadcast('refreshItems');
                        $rootScope.$broadcast('hideItemDetails');
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

                    // special cases for nulls
                    var key;
                    for (key in $scope.objectFields) {
                        var type = $scope.objectFields[key].type;
                        if (type === 'DATE' || type === 'DOUBLE' || type === 'INTEGER') {
                            if ($scope.editItem[key] === null || $scope.editItem[key] === '') {
                                $scope.editItem[key] = undefined;
                            }
                        }
                    }

                    var itemToSave = {};
                    for (key in $scope.editItem) {
                        if (key !== '$$hashKey') {
                            itemToSave[key] = ($scope.editItem[key] === null ? undefined : $scope.editItem[key]);
                        }
                    }

                    var inputMap = { 'so' : JSON.stringify(itemToSave) };
                    remoteActions.invokeMethod('updateObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('save offer pricing component results: ', results);
                        if (event) {
                            event.currentTarget.innerText = originalText;
                            event.currentTarget.disabled = false;
                        }
                        $scope.editItem = {};
                        for (var key in results) {
                            if ($scope.objectFields[key] && $scope.objectFields[key].type === 'DATE') {
                                var tzOffset = (window.userTimezoneOffset || window.parent.userTimezoneOffset);
                                $scope.editItem[key] = results[key] + tzOffset;
                            } else {
                                $scope.editItem[key] = results[key];
                            }
                        }
                        $rootScope.$broadcast('refreshItems');
                        $rootScope.$broadcast('hideItemDetails');
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

                $scope.getOverride = function() {
                    var inputMap = {
                        'type': 'Pricing Component',
                        'overriddenObjectId': $scope.offerPricingItem.Id,
                        'contextId': $scope.rootProductId
                    };
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('getOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        if (result !== null) {
                            var obj = JSON.parse(result);
                            console.log('get override: ', obj);
                            $scope.overrideObj = obj.SObject;
                            $scope.overrideDef = obj.OverrideDefinition__c;
                            $scope.hasOverride = true;
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.createOverride = function() {
                    var itemToCreate = {};
                    for (var key in $scope.editItem) {
                        itemToCreate[key] = ($scope.editItem[key] === null ? undefined : $scope.editItem[key]);
                    }
                    itemToCreate[$scope.nsp + 'IsOverride__c'] = true;
                    itemToCreate.Name += ' Override';
                    delete itemToCreate.$$hashKey;
                    delete itemToCreate.Id;

                    var inputMap = {
                        'type': 'Pricing Component',
                        'overriddenObjectId': $scope.offerPricingItem.Id,
                        'contextId': $scope.rootProductId,
                        'sObject': JSON.stringify(itemToCreate)
                    };
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('createOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        var obj = JSON.parse(result);
                        console.log('create override: ', obj);
                        $scope.overrideObj = obj.SObject;
                        $scope.overrideDef = obj.OverrideDefinition__c;
                        $scope.hasOverride = true;
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.saveOverride = function(event) {
                    var originalText;
                    if (event) {
                        originalText = event.currentTarget.innerText;
                        event.currentTarget.disabled = true;
                        event.currentTarget.innerText = 'Saving...';
                    }

                    // special cases for nulls
                    var key;
                    for (key in $scope.objectFields) {
                        var type = $scope.objectFields[key].type;
                        if (type === 'DATE' || type === 'DOUBLE' || type === 'INTEGER') {
                            if ($scope.overrideObj[key] === null || $scope.overrideObj[key] === '') {
                                $scope.overrideObj[key] = undefined;
                            }
                        }
                    }

                    var itemToSave = {};
                    for (key in $scope.overrideObj) {
                        if (key !== '$$hashKey') {
                            itemToSave[key] = ($scope.overrideObj[key] === null ? undefined : $scope.overrideObj[key]);
                        }
                    }

                    var inputMap = {
                        'type': 'Pricing Component',
                        'sObject': JSON.stringify(itemToSave)
                    };
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('saveOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        console.log('save override results: ', results);
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

                $scope.deleteOverride = function() {
                    var inputMap = {
                        'type': 'Pricing Component',
                        'overridingObjectId': $scope.overrideObj.Id,
                        'overrideDefinitionId': $scope.overrideDef.Id,
                        'contextId': $scope.rootProductId
                    };
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('deleteOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        console.log('delete override: ', result);
                        $scope.overrideObj = null;
                        $scope.overrideDef = null;
                        $scope.hasOverride = false;
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.init = function() {
                    $scope.getObjectLayoutByName($scope.OBJECT_NAME, '');
                    $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                    $scope.getObjectPicklistsByName($scope.nsp + $scope.OBJECT_NAME);

                    $scope.objDisplayMode = ($scope.mode === 'edit' ? 'edit' : 'view');

                    $scope.editItem = {};
                    for (var key in $scope.offerPricingItem) {
                        $scope.editItem[key] = $scope.offerPricingItem[key];
                    }
                    delete $scope.editItem.$$hashKey;
                    delete $scope.editItem[$scope.nsp + 'PricingComponentId__r'];

                    if ($scope.mode === 'override') {
                        $scope.overrideMode = true;
                        $scope.overrideObj = null;
                        $scope.overrideDef = null;
                        $scope.hasOverride = false;
                        $scope.getOverride();
                    } else {
                        $scope.overrideMode = false;
                    }
                };
                $scope.init();
            }
        };
    }
]);

},{}],28:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocPriceListEntry', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                objectId: '=',
                priceListEntryItem: '=',
                pricingElementObjectType: '=',
                parentItem: '=',
                pricingMode: '=',
                mode: '=',
                rootProductId: '=',
                promotionId: '=',
                isAdj: '=',
                isOverride: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'PriceListEntry.tpl.html',
            controller: function($scope, $rootScope, $timeout) {
                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = 'PriceListEntry__c';
                $scope.tabs = [];
                $scope.editItem = {};
                $scope.editPV = {};
                $scope.editPV[$scope.nsp + 'ValueType__c'] = 'Pricing Element';
                $scope.pricingVariableList = [];
                $scope.showPVList = false;
                $scope.pricingElementList = [];
                $scope.showPEList = false;
                $scope.hasObjectTypes = false;
                $scope.objectTypes = [];
                $scope.objTypeSelect = {
                    isCreateable: true,
                    isUpdateable: true,
                    isRequired: false,
                    label: 'Object Type',
                    type: 'OTPICKLIST',
                };

                $scope.contextRuleAttrs = {
                    'contextRulesMode': 'modal'
                };
                if ($scope.priceListEntryItem === undefined || $scope.priceListEntryItem === null) {
                    $scope.contextRuleAttrs.objectId = null;
                } else {
                    $scope.contextRuleAttrs.objectId = $scope.priceListEntryItem.Id;
                }

                $scope.setActiveTab = function(activeIdx) {
                    angular.forEach($scope.tabs, function(tab, idx) {
                        tab.active = (activeIdx === idx);
                    });
                    $scope.activeIdx = activeIdx;
                    cpqService.setPriceListEntryTabIdx(activeIdx);
                };

                $scope.describeObject = function(objectName) {
                    var inputMap = { 'objectName' : $scope.nsp + 'PricingVariable__c' };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        $scope.objectFieldsPV = results;
                        console.log('describeObject PricingVariable__c results: ', $scope.objectFieldsPV);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                    var inputMap2 = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap2)).then(function(results) {
                        console.log('describeObject results: ', results);
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
                    var inputMap = { 'objectName' : $scope.nsp + 'PricingVariable__c' };
                    remoteActions.invokeMethod('getObjectPicklistsByName', JSON.stringify(inputMap)).then(function(results) {
                        $scope.objectPicklistsPV = {};
                        for (var key in results) {
                            if (key.endsWith('__c')) {
                                $scope.objectPicklistsPV[$scope.nsp + key] = results[key];
                            } else {
                                $scope.objectPicklistsPV[key] = results[key];
                            }
                        }
                        console.log('getObjectPicklistsByName PricingVariable__c results:', $scope.objectPicklistsPV);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                    var inputMap2 = { 'objectName' : objectName };
                    remoteActions.invokeMethod('getObjectPicklistsByName', JSON.stringify(inputMap2)).then(function(results) {
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
                    console.log('closeDetails scope', $scope);
                    if ($scope.mode != 'modal') {
                        $rootScope.$broadcast('hideItemDetails');
                    } else {
                        $scope.$parent.hideAction();
                    }
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
                        console.log('create pricelist entry results:', results);
                        $rootScope.$broadcast('refreshObjectPricingElements');
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
                        console.log('save pricelist entry results:', results);
                        $rootScope.$broadcast('refreshObjectPricingElements');
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

                $scope.getObjectTypes = function(item) {
                    $scope.objectTypes = [];
                    $scope.selectObjectType = false;
                    var inputMap = { 'objectName' : item };
                    remoteActions.invokeMethod('getObjectClassTypesByName', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getObjectTypes results: ', results);
                        for (var i = 0; i < results.length; i++) {
                            $scope.selectObjectType = true;
                            var res = {
                                label: results[i].Name,
                                value: results[i].Id
                            };
                            $scope.objectTypes.push(res);
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.setupViewAttrs = function(section) {
                    if ($scope.priceListEntryItem !== undefined) {
                        $scope.customViewData = {
                            'name': section.facetSectionObj[$scope.nsp + 'ViewUri__c'],
                            'attrs': {
                                'objectId': $scope.priceListEntryItem.Id,
                                'objName': 'PricingElement__c',
                                'contextCriteriaMode': 'rightPane',
                                'parentObject': $scope.priceListEntryItem
                            }
                        };
                    } else {
                        $scope.customViewData = {
                            'name': section.facetSectionObj[$scope.nsp + 'ViewUri__c'],
                            'attrs': {
                                'objName': 'PricingElement__c',
                                'contextCriteriaMode': 'rightPane',
                                'parentObject': $scope.priceListEntryItem
                            }
                        };
                    }
                };

                $scope.searchPriceVariables = function() {
                    delete $scope.selectedPV;
                    var inputMap = {};
                    for (var key in $scope.editPV) {
                        if ($scope.editPV[key]) {
                            inputMap[key] = $scope.editPV[key];
                        }
                    }
                    if (inputMap[$scope.nsp + 'ChargeType__c'] !== 'Recurring') {
                        delete inputMap[$scope.nsp + 'RecurringFrequency__c'];
                    }
                    var inputMapJSON = JSON.stringify(inputMap);

                    var inputMap = { 
                        'objectName' : $scope.nsp + 'PricingVariable__c',
                        'inputMap' : inputMapJSON
                     };
                    remoteActions.invokeMethod('searchObjectFields', JSON.stringify(inputMap)).then(function(results) {
                        $scope.pricingVariableList = results;
                        $scope.showPVList = true;
                        console.log('pricingVariableList results: ', $scope.pricingVariableList);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.searchPricingElements = function() {
                    delete $scope.selectedPE;

                    var pricelistId;
                    if ($scope.pricingMode === 'PRICELIST') {
                        pricelistId = $scope.objectId;
                    } else if ($scope.pricingMode === 'PROMOTION') {
                        pricelistId = $scope.editItem[$scope.nsp + 'PriceListId__c'];
                    } else if ($scope.pricingMode === 'PRODUCT') {
                        pricelistId = $scope.editItem[$scope.nsp + 'PriceListId__c'];
                    }

                    var inputMap = {
                        'PricingVariableId': $scope.selectedPV.Id,
                        'PriceListId': pricelistId
                    };
                    var inputs = { 
                        'input' : JSON.stringify(inputMap),
                        'options' : ''
                    };
                    remoteActions.invokeMethod('getAvailablePricingVariableElements', JSON.stringify(inputs)).then(function(results) {
                        $scope.pricingElementList = results;
                        $scope.showPEList = true;
                        console.log('getAvailablePricingElements results: ', $scope.pricingElementList);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.selectPricingVariable = function(pv) {
                    $scope.selectedPV = pv;
                    $scope.showPVList = false;
                    $scope.searchPricingElements();
                };

                $scope.selectPricingElement = function(pe) {
                    $scope.selectedPE = pe;
                    $scope.showPEList = false;
                    $scope.editItem[$scope.nsp + 'PricingElementId__c'] = pe.Id;
                };

                $scope.launchTab = function(item, itemType, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    var data = {
                        'objectId': itemType,
                        'obj': item,
                        'closeCurrentTab': false
                    };
                    var broadcastAction = {
                        'eventName': 'launchConsoleTab',
                        'eventData': data
                    };
                    if (window.frameElement !== null) {
                        // create a iframe resize event binding with the parent
                        window.parent.bindIframeEvents('broadcast', broadcastAction);
                    }
                };

                $scope.init = function() {
                    $scope.tabs = cpqService.getPriceListEntryTabs();
                    $scope.activeIdx = cpqService.getPriceListEntryTabIdx();
                    $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                    $scope.getObjectPicklistsByName($scope.nsp + $scope.OBJECT_NAME);

                    if ($scope.priceListEntryItem === null) {
                        // create new record
                        if ($scope.pricingMode === 'PRICELIST') {
                            $scope.editItem[$scope.nsp + 'PriceListId__c'] = $scope.objectId;
                        } else if ($scope.pricingMode === 'PROMOTION') {
                            $scope.editItem[$scope.nsp + 'PromotionId__c'] = $scope.promotionId;
                            $scope.editItem[$scope.nsp + 'ProductId__c'] = $scope.objectId;
                        } else if ($scope.pricingMode === 'PRODUCT') {
                            $scope.editItem[$scope.nsp + 'ProductId__c'] = $scope.objectId;
                        }
                    } else {
                        // edit existing record
                        for (var key in $scope.priceListEntryItem) {
                            if (key !== '$$hashKey') {
                                $scope.editItem[key] = $scope.priceListEntryItem[key];
                            }
                        }
                        $scope.selectedPE = $scope.priceListEntryItem[$scope.nsp + 'PricingElementId__r'];
                        $scope.selectedPV = $scope.selectedPE[$scope.nsp + 'PricingVariableId__r'];
                        $scope.editPV[$scope.nsp + 'ChargeType__c'] = $scope.selectedPV[$scope.nsp + 'ChargeType__c'];
                        $scope.editPV[$scope.nsp + 'RecurringFrequency__c'] = $scope.selectedPV[$scope.nsp + 'RecurringFrequency__c'];
                        $scope.editPV[$scope.nsp + 'SubType__c'] = $scope.selectedPV[$scope.nsp + 'SubType__c'];
                        $scope.editPV[$scope.nsp + 'Type__c'] = $scope.selectedPV[$scope.nsp + 'Type__c'];
                    }

                    $scope.chargeTypePicklist = [];
                    if ($scope.isAdj) {
                        $scope.chargeTypePicklist.push({'label': 'Adjustment', value: 'Adjustment'});
                        $scope.editPV[$scope.nsp + 'ChargeType__c'] = 'Adjustment';
                        if ($scope.pricingMode !== 'PROMOTION' || ($scope.rootProductId !== $scope.objectId)) {
                            $scope.editItem[$scope.nsp + 'OfferId__c'] = $scope.rootProductId;
                        }
                    } else if ($scope.pricingElementObjectType.Name === 'Charge') {
                        $scope.chargeTypePicklist.push({'label': 'Recurring', value: 'Recurring'});
                        $scope.chargeTypePicklist.push({'label': 'One-time', value: 'One-time'});
                    } else if ($scope.pricingElementObjectType.Name === 'Usage') {
                        $scope.chargeTypePicklist.push({'label': 'Usage', value: 'Usage'});
                        $scope.editPV[$scope.nsp + 'ChargeType__c'] = 'Usage';
                    }

                    if ($scope.isOverride) {
                        if ($scope.pricingMode !== 'PROMOTION' || ($scope.rootProductId !== $scope.objectId)) {
                            $scope.editItem[$scope.nsp + 'OfferId__c'] = $scope.rootProductId;
                        }
                        $scope.editItem[$scope.nsp + 'IsOverride__c'] = true;
                    }
                };
                $scope.init();
            }
        };
    }
]);

},{}],29:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocPriceListEntryInfoCard', ['remoteActions',
    function(remoteActions) {
        return {
            scope: {
                priceListEntry: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'PriceListEntryInfoCard.tpl.html',
            controller: function($scope, $rootScope) {
                $scope.nsp = fileNsPrefix();
                $scope.currencySymbol = currencySymbol;
                $scope.pricingElement = $scope.priceListEntry[$scope.nsp + 'PricingElementId__r'];
                $scope.pricingVariable = $scope.pricingElement[$scope.nsp + 'PricingVariableId__r'];
            }
        };
    }
]);

},{}],30:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocProdCardinality', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                parentOverrideMode: '=',
                parentProductId: '=',
                rootProductId: '=',
                prodObj: '=',
                prodChildItemObj: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ProdCardinality.tpl.html',
            controller: function($scope, $rootScope, $timeout) {
                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = 'ProductChildItem__c';
                $scope.editItem = {};

                $scope.describeObject = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('describeObject product cardinality results: ', results);
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
                        console.log('save product cardinality results:', results);
                        $scope.ProdChildItem = {};
                        $scope.editItem = {};
                        for (var key in results) {
                            if ($scope.objectFields[key] && $scope.objectFields[key].type === 'DATE') {
                                var tzOffset = (window.userTimezoneOffset || window.parent.userTimezoneOffset);
                                $scope.prodChildItemObj[key] = results[key] + tzOffset;
                                $scope.editItem[key] = results[key] + tzOffset;
                            } else {
                                $scope.prodChildItemObj[key] = results[key];
                                $scope.editItem[key] = results[key];
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

                $scope.getOverride = function() {
                    var prodChild = $scope.prodChildItemObj === undefined ? null : $scope.prodChildItemObj.Id;

                    var inputMap = {
                        'type': 'Product Definition',
                        'contextId': $scope.rootProductId,
                        'overriddenObjectId': prodChild //$scope.prodChildItemObj.Id
                    };
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('getOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        if (results !== null) {
                            var obj = JSON.parse(results);
                            console.log('get override: ', obj);
                            $scope.overrideObj = obj.SObject;
                            $scope.overrideDef = obj.OverrideDefinition__c;
                            $scope.hasOverride = true;
                            $scope.objDisplayMode = 'view';
                        } else {
                            $scope.objDisplayMode = 'edit';
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.createOverride = function() {
                    var itemToCreate = {};
                    for (var key in $scope.editItem) {
                        itemToCreate[key] = ($scope.editItem[key] === null ? undefined : $scope.editItem[key]);
                    }
                    itemToCreate[$scope.nsp + 'IsOverride__c'] = true;
                    delete itemToCreate.$$hashKey;
                    delete itemToCreate.Id;

                    var inputMap = {
                        'type': 'Product Definition',
                        'contextId': $scope.rootProductId,
                        'overriddenObjectId': $scope.prodChildItemObj === undefined ? null : $scope.prodChildItemObj.Id,
                        'isExclude': false
                    };
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('createOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        var obj = JSON.parse(results);
                        console.log('create override: ', obj);
                        $scope.overrideObj = obj.SObject;
                        $scope.overrideDef = obj.OverrideDefinition__c;
                        $scope.hasOverride = true;
                        $scope.objDisplayMode = 'view';
                        $rootScope.$broadcast('refreshStructureItems');
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.saveOverride = function(event) {
                    var originalText;
                    if (event) {
                        originalText = event.currentTarget.innerText;
                        event.currentTarget.disabled = true;
                        event.currentTarget.innerText = 'Saving...';
                    }

                    // special cases for nulls
                    var key;
                    for (key in $scope.objectFields) {
                        var type = $scope.objectFields[key].type;
                        if (type === 'DATE' || type === 'DOUBLE' || type === 'INTEGER') {
                            if ($scope.overrideObj[key] === null || $scope.overrideObj[key] === '') {
                                $scope.overrideObj[key] = undefined;
                            }
                        }
                    }

                    var itemToSave = {};
                    for (key in $scope.overrideObj) {
                        if (key !== '$$hashKey') {
                            itemToSave[key] = ($scope.overrideObj[key] === null ? undefined : $scope.overrideObj[key]);
                        }
                    }

                    var inputMap = {
                        'type': 'Product Definition',
                        'sObject': JSON.stringify(itemToSave)
                    };
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('saveOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        console.log('save override results: ', results);
                        if (event) {
                            event.currentTarget.innerText = originalText;
                            event.currentTarget.disabled = false;
                        }
                        $rootScope.$broadcast('refreshStructureItems');
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

                $scope.deleteOverride = function() {
                    var inputMap = {
                        'type': 'Product Definition',
                        'overrideDefinitionId': $scope.overrideDef.Id,
                        'contextId': $scope.rootProductId
                    };
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('deleteOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        console.log('delete override: ', results);
                        $scope.overrideObj = null;
                        $scope.overrideDef = null;
                        $scope.hasOverride = false;
                        $scope.objDisplayMode = 'edit';
                        $rootScope.$broadcast('refreshStructureItems');
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.init = function() {
                    $scope.overrideObj = null;
                    $scope.overrideDef = null;
                    $scope.hasOverride = false;

                    $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                    $scope.getObjectPicklistsByName($scope.nsp + $scope.OBJECT_NAME);

                    $scope.editItem = {};
                    if ($scope.mode === 'add') {
                        $scope.overrideMode = false;
                        $scope.objDisplayMode = 'edit';
                        $scope.editItem[$scope.nsp + 'ParentProductId__c'] = $scope.parentProductId;
                    } else {
                        $scope.overrideMode = true;
                        for (var key in $scope.prodChildItemObj) {
                            if (key !== '$$hashKey') {
                                $scope.editItem[key] = $scope.prodChildItemObj[key];
                            }
                        }
                        if ($scope.rootProductId !== undefined) {
                            $scope.getOverride();
                        }
                    }

                    $scope.customViewAttrs = {
                        'objectId': $scope.prodChildItemObj === undefined ? $scope.parentProductId : $scope.prodChildItemObj.Id,
                        'contextCriteria': $scope.contextCriteria,
                        'contextCriteriaMode': 'rightPane',
                        'parentObject': $scope.prodChildItemObj
                    };
                };
                $scope.init();
            }
        };
    }
]);

},{}],31:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocProdChildDetails', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                rootProductId: '=',
                prodChildItem: '=',
                pricingMode: '=',
                promotionId: '=',
                isAdj: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ProdChildDetails.tpl.html',
            controller: function($scope, $rootScope) {
                console.log('ProdChildDetails scope:', $scope);
                $scope.nsp = fileNsPrefix();
                $scope.tabs = [];

                $scope.setActiveTab = function(activeIdx) {
                    angular.forEach($scope.tabs, function(tab, idx) {
                        tab.active = (activeIdx === idx);
                    });
                    $scope.activeIdx = activeIdx;
                    cpqService.setProdChildActiveTabIdx(activeIdx);
                };

                $scope.$watch('isInOverrideMode', function(newValue) {
                    cpqService.setOverrideMode(newValue);
                });

                $scope.init = function() {
                    var administerRootProduct = ($scope.promotionId !== undefined);
                    $scope.tabs = cpqService.getProductChildTabs($scope.prodChildItem.isRoot, $scope.prodChildItem.isLeaf, administerRootProduct);
                    $scope.activeIdx = cpqService.getProdChildActiveTabIdx();
                    $scope.isInOverrideMode = cpqService.getOverrideMode();
                    $scope.customViewAttrs = {
                        objectId: $scope.prodChildItem.productId,
                        rootProductId: $scope.rootProductId,
                        mode: 'override'
                    };
                    $scope.customViewAttrsPricing = {
                        objectId: $scope.prodChildItem.productId,
                        rootProductId: $scope.rootProductId,
                        mode: 'override'
                    };
                };
                $scope.init();
            }
        };
    }
]);

},{}],32:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocProdChildItem', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                mode: '=',
                parentOverrideMode: '=',
                parentProductId: '=',
                rootProductId: '=',
                prodObj: '=',
                prodChildItemObj: '=',
                promotionItem: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ProdChildItem.tpl.html',
            controller: function($scope, $rootScope, $timeout) {
                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = 'ProductChildItem__c';
                $scope.editItem = {};

                $scope.getObjectLayoutByName = function(objectName, recordType) {
                    var inputMap = {
                        'objectName' : objectName,
                        'recordType' : recordType
                    };
                    remoteActions.invokeMethod('getObjectLayoutByName', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getObjectLayoutByName product child item results: ', results);
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
                    console.log('FACETS for product child item: ', $scope.facets);
                };

                $scope.describeObject = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('describeObject product child item results: ', results);
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
                        console.log('create product child item results: ', results);
                        if (event) {
                            event.currentTarget.innerText = originalText;
                            event.currentTarget.disabled = false;
                        }
                        $rootScope.$broadcast('refreshProductChildren', {'productId': results[$scope.nsp+'ParentProductId__c']});
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
                        console.log('save product child item results:', results);
                        $scope.ProdChildItem = {};
                        $scope.editItem = {};
                        for (var key in results) {
                            if ($scope.objectFields[key] && $scope.objectFields[key].type === 'DATE') {
                                var tzOffset = (window.userTimezoneOffset || window.parent.userTimezoneOffset);
                                $scope.prodChildItemObj[key] = results[key] + tzOffset;
                                $scope.editItem[key] = results[key] + tzOffset;
                            } else {
                                $scope.prodChildItemObj[key] = results[key];
                                $scope.editItem[key] = results[key];
                            }
                        }
                        if (event) {
                            event.currentTarget.innerText = originalText;
                            event.currentTarget.disabled = false;
                        }
                        $rootScope.$broadcast('refreshProductChildren', {'productId': results[$scope.nsp+'ParentProductId__c']});
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

                $scope.getOverride = function() {
                    var prodChild = $scope.prodChildItemObj === undefined ? null : $scope.prodChildItemObj.Id;

                    var inputMap = {
                        'type': 'Product Definition',
                        'contextId': $scope.rootProductId,
                        'overriddenPCIId': prodChild
                    };
                    if ($scope.promotionItem !== undefined) {
                        inputMap['promotionItemId'] = $scope.promotionItem.Id;
                        inputMap['promotionId'] = $scope.promotionItem[$scope.nsp+'PromotionId__c'];
                    }
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('getOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        if (results !== null) {
                            var obj = JSON.parse(results);
                            console.log('get override: ', obj);
                            $scope.overrideObj = obj.SObject;
                            $scope.overrideDef = obj.OverrideDefinition__c;
                            $scope.hasOverride = true;
                            $scope.excludePCI = ($scope.overrideDef[$scope.nsp + 'IsExclude__c']);
                            $scope.objDisplayMode = 'view';
                        } else {
                            $scope.objDisplayMode = 'edit';
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.createOverride = function() {
                    var itemToCreate = {};
                    for (var key in $scope.editItem) {
                        itemToCreate[key] = ($scope.editItem[key] === null ? undefined : $scope.editItem[key]);
                    }
                    itemToCreate[$scope.nsp + 'IsOverride__c'] = true;
                    delete itemToCreate.$$hashKey;
                    delete itemToCreate.Id;

                    var inputMap = {
                        'type': 'Product Definition',
                        'contextId': $scope.rootProductId,
                        'overriddenObjectId': $scope.prodChildItemObj === undefined ? null : $scope.prodChildItemObj.Id,
                        'overriddenPCIId': $scope.prodChildItemObj === undefined ? null : $scope.prodChildItemObj.Id,
                        'isExclude': false
                    };
                    if ($scope.promotionItem !== undefined) {
                        inputMap['promotionItemId'] = $scope.promotionItem.Id;
                        inputMap['promotionId'] = $scope.promotionItem[$scope.nsp+'PromotionId__c'];
                    }
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('createOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        var obj = JSON.parse(results);
                        console.log('create override:', obj);
                        $scope.overrideObj = obj.SObject;
                        $scope.overrideDef = obj.OverrideDefinition__c;
                        $scope.hasOverride = true;
                        $scope.excludePCI = false;
                        $scope.objDisplayMode = 'view';
                        $rootScope.$broadcast('refreshStructureItems');
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.saveOverride = function(event) {
                    var originalText;
                    if (event) {
                        originalText = event.currentTarget.innerText;
                        event.currentTarget.disabled = true;
                        event.currentTarget.innerText = 'Saving...';
                    }

                    // special cases for nulls
                    var key;
                    for (key in $scope.objectFields) {
                        var type = $scope.objectFields[key].type;
                        if (type === 'DATE' || type === 'DOUBLE' || type === 'INTEGER') {
                            if ($scope.overrideObj[key] === null || $scope.overrideObj[key] === '') {
                                $scope.overrideObj[key] = undefined;
                            }
                        }
                    }

                    var itemToSave = {};
                    for (key in $scope.overrideObj) {
                        if (key !== '$$hashKey') {
                            itemToSave[key] = ($scope.overrideObj[key] === null ? undefined : $scope.overrideObj[key]);
                        }
                    }

                    var inputMap = {
                        'type': 'Product Definition',
                        'sObject': JSON.stringify(itemToSave)
                    };
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('saveOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        console.log('save override results: ', results);
                        if (event) {
                            event.currentTarget.innerText = originalText;
                            event.currentTarget.disabled = false;
                        }
                        $rootScope.$broadcast('refreshStructureItems');
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

                $scope.deleteOverride = function() {
                    var inputMap = {
                        'type': 'Product Definition',
                        'overrideDefinitionId': $scope.overrideDef.Id,
                        'contextId': $scope.rootProductId
                    };
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('deleteOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        console.log('delete override: ', results);
                        $scope.overrideObj = null;
                        $scope.overrideDef = null;
                        $scope.hasOverride = false;
                        $scope.excludePCI = false;
                        $scope.objDisplayMode = 'edit';
                        $rootScope.$broadcast('refreshStructureItems');
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.excludeItem = function() {
                    var prodChild = $scope.prodChildItemObj === undefined ? null : $scope.prodChildItemObj.Id;
                    var inputMap = {
                        'type': 'Product Definition',
                        'contextId': $scope.rootProductId,
                        'overriddenObjectId': prodChild,
                        'isExclude': true
                    };
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('createOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        var obj = JSON.parse(results);
                        console.log('create override: ', obj);
                        $scope.overrideDef = obj.OverrideDefinition__c;
                        $scope.hasOverride = true;
                        $scope.excludePCI = true;
                        $scope.objDisplayMode = 'view';
                        $rootScope.$broadcast('refreshStructureItems');
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.init = function() {
                    $scope.overrideObj = null;
                    $scope.overrideDef = null;
                    $scope.hasOverride = false;

                    $scope.getObjectLayoutByName($scope.OBJECT_NAME, '');
                    $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                    $scope.getObjectPicklistsByName($scope.nsp + $scope.OBJECT_NAME);

                    $scope.editItem = {};
                    if ($scope.mode === 'add') {
                        $scope.overrideMode = false;
                        $scope.objDisplayMode = 'edit';
                        $scope.editItem[$scope.nsp + 'ParentProductId__c'] = $scope.parentProductId;
                    } else {
                        $scope.overrideMode = true;
                        for (var key in $scope.prodChildItemObj) {
                            if (key !== '$$hashKey') {
                                $scope.editItem[key] = $scope.prodChildItemObj[key];
                            }
                        }
                        if ($scope.rootProductId !== undefined) {
                            $scope.getOverride();
                        }
                    }

                    $scope.customViewAttrs = {
                        'objectId': $scope.prodChildItemObj === undefined ? $scope.parentProductId : $scope.prodChildItemObj.Id,
                        'contextCriteria': $scope.contextCriteria,
                        'contextCriteriaMode': 'rightPane',
                        'parentObject': $scope.prodChildItemObj
                    };
                };
                $scope.init();
            }
        };
    }
]);

},{}],33:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocProductAttributes', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                productId: '=',
                rootProductId: '=',
                prodChildItemObj: '=',
                parentOverrideMode: '=',
                promotionItem: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ProductAttributes.tpl.html',
            controller: function($scope, $rootScope, $sldsModal) {
                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = 'Product2';
                $scope.attrMap = {};
                $scope.attrOverrideMap = {};
                $scope.AttrObjMap = {};
                $scope.AttrAssgnObjMap = {};
                $scope.AttrPicklistMap = {};
                $scope.AttrLookupMap = {};
                $scope.AttrOverrideAssgnObjMap = {};
                $scope.AttrOverrideDefObjMap = {};
                $scope.AttrOverridePicklistMap = {};

                $scope.$on('refreshItems', function() {
                    $scope.getAppliedAttributesFields(); //Is this doing anything?
                });

                $scope.getObjectLayoutById = function(objectId, forSelf) {
                    var inputMap = {
                        'objectId' : objectId,
                        'isInherited' : forSelf
                    };
                    remoteActions.invokeMethod('getObjectLayoutById', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getObjectLayoutById product attributes: ', results);
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
                    if (results.facets && results.facets.length > 0) {
                        $scope.facets = results.facets[0];
                        $scope.sections = [];
                        if ($scope.facets.sections && $scope.facets.sections.length > 0) {
                            $scope.sections = [];
                            angular.forEach($scope.facets.sections, function(section) {
                                var hasAttributes = false;
                                angular.forEach(section.sectionElements, function(sectionEl) {
                                    if (sectionEl[$scope.nsp + 'Type__c'] === 'Attribute') {
                                        $scope.getAttributeAssignmentById(sectionEl[$scope.nsp + 'AttributeId__c']);
                                        hasAttributes = true;
                                    }
                                });
                                if (hasAttributes) {
                                    $scope.sections.push(section);
                                }
                            });
                        }
                    }
                    console.log('FACETS for product attributes: ', $scope.facets);
                };

                $scope.describeObjectById = function(objectId) {
                    var inputMap = { 'objectId' : objectId };
                    remoteActions.invokeMethod('describeObjectbyId', JSON.stringify(inputMap)).then(function(results) {
                        console.log('describeObjectById product attributes: ', results);
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
                        console.log('getObjectPicklistsByName product attributes:', $scope.objectPicklists);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getAttributeAssignmentById = function(attributeId) {
                    var inputMap = {
                        'attributeId' : attributeId,
                        'objectId' : $scope.productId
                    };
                    remoteActions.invokeMethod('getAttributeAssignmentById', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getAttributeAssignmentById results: ', results);
                        $scope.AttrObjMap[attributeId] = results.attribute;
                        $scope.AttrAssgnObjMap[attributeId] = results.attributeAssignment;
                        $scope.AttrPicklistMap[attributeId] = results.picklistItems;
                        $scope.AttrLookupMap[attributeId] = results.lookupItems;

                        var item = {};
                        item.attrId = attributeId;
                        if (results.attributeAssignment) {
                            item.aaId = results.attributeAssignment.Id;
                        }
                        $scope.getOverride(item);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getOverride = function(item) {
                    var prodChild = $scope.prodChildItemObj === undefined ? null : $scope.prodChildItemObj.Id;

                    var inputMap = {
                        'type': 'Attribute',
                        'contextId': $scope.rootProductId,
                        'overriddenObjectId': item.aaId,
                        'overriddenPCIId': prodChild
                    };
                    if ($scope.promotionItem !== undefined) {
                        inputMap['promotionItemId'] = $scope.promotionItem.Id;
                        inputMap['promotionId'] = $scope.promotionItem[$scope.nsp+'PromotionId__c'];
                    }
                    console.log('Get Override Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('getOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        if (results !== null) {
                            var obj = JSON.parse(results);
                            console.log('get override: ', obj);
                            $scope.AttrOverridePicklistMap[item.attrId] = (obj.PicklistItems || null);
                            $scope.AttrOverrideAssgnObjMap[item.attrId] = obj.SObject;
                            $scope.AttrOverrideDefObjMap[item.attrId] = obj.OverrideDefinition__c;
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.showAttributeMetadata = function(attrId) {
                    var modalScope = $scope.$new();
                    modalScope.modalTitle = 'Attribute Metadata';
                    modalScope.mode = 'override';
                    modalScope.objectId = $scope.productId;
                    modalScope.rootProductId = $scope.rootProductId;
                    modalScope.attrObj = $scope.AttrObjMap[attrId];
                    modalScope.attrAssgnObj = $scope.AttrAssgnObjMap[attrId];
                    modalScope.attrAssgnOverrideObj = $scope.AttrOverrideAssgnObjMap[attrId];
                    modalScope.attrOverrideDefObj = $scope.AttrOverrideDefObjMap[attrId];
                    modalScope.prodChildItemObj = $scope.prodChildItemObj;
                    modalScope.isProduct = true;
                    modalScope.cancelActionLbl = 'Cancel';
                    modalScope.confirmActionLbl = 'Save';
                    modalScope.confirmAction = function(attrAssgnOverrideObj, attrOverrideDefObj) {
                        metadataModal.hide();
                        $scope.AttrOverrideAssgnObjMap[attrId] = this.attrAssgnOverrideObj;
                        $scope.AttrOverrideDefObjMap[attrId] = this.attrOverrideDefObj;
                        $scope.saveOverride(attrId);
                    };
                    var metadataModal = $sldsModal({
                        templateUrl: 'AttributeMetadataModal.tpl.html',
                        backdrop: 'static',
                        scope: modalScope,
                        show: true
                    });
                };

                $scope.createOverride = function(attributeId) {
                    var inputMap = {
                        'type': 'Attribute',
                        'contextId': $scope.rootProductId,
                        'overriddenObjectId': $scope.AttrAssgnObjMap[attributeId].Id,
                        'overriddenPCIId':$scope.prodChildItemObj === undefined ? null : $scope.prodChildItemObj.Id
                    };
                    if ($scope.promotionItem !== undefined) {
                        inputMap['promotionItemId'] = $scope.promotionItem.Id;
                        inputMap['promotionId'] = $scope.promotionItem[$scope.nsp+'PromotionId__c'];
                    }
                    console.log('Create Override Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('createOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        var obj = JSON.parse(results);
                        console.log('create override: ', obj);
                        $scope.AttrOverridePicklistMap[attributeId] = (obj.PicklistItems || null);
                        $scope.AttrOverrideAssgnObjMap[attributeId] = obj.SObject;
                        $scope.AttrOverrideDefObjMap[attributeId] = obj.OverrideDefinition__c;
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.saveOverride = function(attributeId) {
                    var overrideObj = $scope.AttrOverrideAssgnObjMap[attributeId];
                    // special cases for nulls
                    var key;
                    for (key in $scope.objectFields) {
                        var type = $scope.objectFields[key].type;
                        if (type === 'DATE' || type === 'DOUBLE' || type === 'INTEGER') {
                            if (overrideObj[key] === null || overrideObj[key] === '') {
                                overrideObj[key] = undefined;
                            }
                        }
                    }

                    var itemToSave = {};
                    for (key in overrideObj) {
                        if (key !== '$$hashKey') {
                            itemToSave[key] = (overrideObj[key] === null ? undefined : overrideObj[key]);
                        }
                    }

                    var inputMap = {
                        'type': 'Attribute',
                        'contextId': $scope.rootProductId,
                        'sObject': JSON.stringify(itemToSave)
                    };
                    console.log('Save Override: ', itemToSave);
                    console.log('Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('saveOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        console.log('save override results: ', results);
                        //TODO: show save success message
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.deleteOverride = function(attributeId) {
                    var attrAssgnOverride = $scope.AttrOverrideAssgnObjMap[attributeId];
                    var attrAssgnOverrideDef = $scope.AttrOverrideDefObjMap[attributeId];
                    var inputMap = {
                        'type': 'Attribute',
                        'overridingObjectId': attrAssgnOverride.Id,
                        'overrideDefinitionId': attrAssgnOverrideDef.Id,
                        'contextId': $scope.rootProductId
                    };
                    console.log('Delete Override Input Map: ', inputMap);
                    var invokeInputMap = { 'inputMap' : JSON.stringify(inputMap) };
                    remoteActions.invokeMethod('deleteOverride', JSON.stringify(invokeInputMap)).then(function(results) {
                        console.log('delete override: ', results);
                        delete $scope.AttrOverrideAssgnObjMap[attributeId];
                        delete $scope.AttrOverrideDefObjMap[attributeId];
                        delete $scope.AttrOverridePicklistMap[attributeId];
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.init = function() {
                    $scope.getObjectLayoutById($scope.productId, true);
                    $scope.describeObjectById($scope.productId);
                    $scope.getObjectPicklistsByName($scope.OBJECT_NAME);

                    $scope.product = $scope.prodChildItemObj === undefined ? {} : $scope.prodChildItemObj[$scope.nsp + 'ChildProductId__r'];
                    $scope.editProduct = {};
                    for (var key in $scope.product) {
                        $scope.editProduct[key] = $scope.product[key];
                    }
                };
                $scope.init();
            }
        };
    }
]);

},{}],34:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocProductPricing', ['remoteActions', 'cpqService', 
    function(remoteActions, cpqService) {
        return {
            scope: {
                productId: '=',
                mode: '=',
                parentOverrideMode: '=',
                parentProductId: '=',
                rootProductId: '=',
                prodObj: '=',
                prodChildItemObj: '=',
                pricingMode: '=',
                promotionId: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ProductPricing.tpl.html',
            controller: function($scope, $rootScope, $sldsModal) {
                $scope.nsp = fileNsPrefix();

                $scope.OBJECT_NAME = 'PriceListEntry__c';

                $scope.$on('refreshObjectPricingElements', function() {
                    $scope.getPriceListEntries();
                });

                $scope.getPriceListEntries = function() {
                    var baseInputMap = {};
                    var overrideInputMap = {};

                    var productIds = [];
                    productIds.push($scope.productId);
                    var offerIds = [];
                    offerIds.push($scope.rootProductId);
                    var promotionIds = [];
                    promotionIds.push($scope.promotionId);

                    baseInputMap['ProductIds'] = productIds;
                    overrideInputMap['ProductIds'] = productIds;
                    if ($scope.rootProductId !== $scope.productId) {
                        overrideInputMap['OfferIds'] = offerIds;
                    }
                    if ($scope.pricingMode === 'PROMOTION') {
                        overrideInputMap['PromotionIds'] = promotionIds;
                    }

                    var baseInputMapJSON = JSON.stringify(baseInputMap);
                    var inputs = {
                        'input' : baseInputMapJSON,
                        'options' : ''
                    };
                    remoteActions.invokeMethod('getPricingElements', JSON.stringify(inputs)).then(function(results) {
                        console.log('getPricingElements baseInputMapJSON results: ', results);
                        $scope.processBaseEntries(results);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });

                    var overrideInputMapJSON = JSON.stringify(overrideInputMap);
                    var inputs2 = {
                        'input' : overrideInputMapJSON,
                        'options' : ''
                    };
                    remoteActions.invokeMethod('getPricingElements', JSON.stringify(inputs2)).then(function(results) {
                        console.log('getPricingElements overrideInputMapJSON results: ', results);
                        $scope.processOverrideEntries(results);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.processBaseEntries = function(results) {
                    $scope.chargeItems = [];
                    $scope.usageItems = [];

                    angular.forEach(results, function(item) {
                        var hasCharges = false;
                        var chargeCount = 0;
                        var hasUsages = false;
                        var usageCount = 0;

                        angular.forEach(item.priceVars, function(pv) {
                            if (pv.charges && pv.charges.length > 0) {
                                hasCharges = true;
                                chargeCount += pv.charges.length;
                                pv.hasCharges = true;
                            } else {
                                pv.hasCharges = false;
                            }
                            if (pv.usages && pv.usages.length > 0) {
                                hasUsages = true;
                                usageCount += pv.usages.length;
                                pv.hasUsages = true;
                            } else {
                                pv.hasUsages = false;
                            }
                        });

                        if (hasCharges) {
                            item.chargeCount = chargeCount;
                            $scope.chargeItems.push(item);
                        }
                        if (hasUsages) {
                            item.usageCount = usageCount;
                            $scope.usageItems.push(item);
                        }
                    });
                };
                $scope.processOverrideEntries = function(results) {
                    $scope.chargeDiscountItems = [];
                    $scope.chargeOverrideItems = [];

                    angular.forEach(results, function(item) {
                        var hasChargeDiscounts = false;
                        var chargeDiscountCount = 0;
                        var hasChargeOverrides = false;
                        var chargeOverrideCount = 0;

                        angular.forEach(item.priceVars, function(pv) {
                            if (pv.adjustments && pv.adjustments.length > 0) {
                                hasChargeDiscounts = true;
                                chargeDiscountCount += pv.adjustments.length;
                                pv.hasChargeDiscounts = true;
                            } else {
                                pv.hasChargeDiscounts = false;
                            }
                            if (pv.overrides && pv.overrides.length > 0) {
                                hasChargeOverrides = true;
                                chargeOverrideCount += pv.overrides.length;
                                pv.hasChargeOverrides = true;
                            } else {
                                pv.hasChargeOverrides = false;
                            }
                        });

                        if (hasChargeDiscounts) {
                            item.chargeDiscountCount = chargeDiscountCount;
                            $scope.chargeDiscountItems.push(item);
                        }
                        if (hasChargeOverrides) {
                            item.chargeOverrideCount = chargeOverrideCount;
                            $scope.chargeOverrideItems.push(item);
                        }
                    });
                };

                $scope.newDiscount = function(elemObjType) {
                    $scope.selectItem(null, elemObjType, true, false);
                };

                $scope.newOverride = function(elemObjType) {
                    $scope.selectItem(null, elemObjType, false, true);
                };

                $scope.selectItem = function(item, elemObjType, isAdj, isOverride) {
                    var broadcastData = {
                        facetType: 'PROD_PRICING_ELEMENT',
                        facetData: {
                            priceListEntryItem: item,
                            pricingMode: $scope.pricingMode,
                            pricingElementObjectType: elemObjType,
                            isAdj: isAdj,
                            isOverride: isOverride
                        }
                    };
                    if ($scope.contextCriteriaMode === 'leftPane') {
                        $rootScope.$broadcast('showItemDetails', broadcastData);
                    } else {
                        $scope.openEditModal(item, elemObjType, isAdj, isOverride);
                    }
                };

                $scope.openEditModal = function(item, elemObjType, isAdj, isOverride) {
                    var modalScope = $scope.$new();
                    modalScope.contextRuleTitle = 'Price List Entry';
                    modalScope.priceListEntryItem = item;
                    modalScope.pricingElementObjectType = elemObjType;
                    modalScope.parentObject = $scope.parentObject;
                    modalScope.objectId = $scope.productId;
                    modalScope.pricingMode = $scope.pricingMode;
                    modalScope.rootProductId = $scope.rootProductId;
                    modalScope.promotionId = $scope.promotionId;
                    modalScope.isAdj = isAdj;
                    modalScope.isOverride = isOverride;
                    modalScope.hideAction = function() {
                        editModal.hide();
                    };
                    var editModal = $sldsModal({
                        templateUrl: 'PricingElementModal.tpl.html',
                        backdrop: 'static',
                        scope: modalScope,
                        show: true
                    });
                };

                $scope.closeDetails = function() {
                    if ($scope.mode !== 'modal') {
                        $rootScope.$broadcast('hideItemDetails');
                    } else {
                        $scope.$parent.hideAction();
                    }
                };

                $scope.deleteItem = function(item, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    var modalScope = $scope.$new();
                    modalScope.confirmationTitle = 'Delete Price List Entry';
                    modalScope.confirmationMsg = 'Are you sure you want to delete the price list entry for <i>' + item[$scope.nsp + 'PricingElementId__r'].Name + '</i>?';
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
                            console.log('delete price list entry results: ', results);
                            $rootScope.$broadcast('refreshObjectPricingElements');
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

                $scope.describeObject = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('Pricing Elements - describeObject results: ', results);
                        $scope.objectFields = results;
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getObjectTypes = function() {
                    var inputMap = { 'objectName' : $scope.nsp + 'PricingElement__c' };
                    remoteActions.invokeMethod('getObjectClassTypesByName', JSON.stringify(inputMap)).then(function(results) {
                        angular.forEach(results, function(objType) {
                            if (objType.Name === 'Discount') {
                                $scope.DiscountOT = objType;
                            }
                            if (objType.Name === 'Charge') {
                                $scope.ChargeOT = objType;
                            }
                        });
                    });
                };

                $scope.init = function() {
                    $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                    $scope.getObjectTypes();
                    $scope.getPriceListEntries();
                };
                $scope.init();
            }
        };
    }
]);

},{}],35:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocSections', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                facet: '=',
				parentObj: '=',
				objectFields: '=',
				objectPicklists: '=',
				attrMap: '=',
				attrObjMap: '=',
				attrAssgnObjMap: '=',
                setupViewAttrs: '&',
				showAttributeMetadata: '&',
				formName: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'VlocSections.tpl.html',
            controller: function($scope, $rootScope, $timeout) {
                $scope.nsp = fileNsPrefix();
            }
        };
    }
]);

},{}],36:[function(require,module,exports){
angular.module('cpqdirectives')
.directive('vlocStandalonePricingElements', ['remoteActions',
    function(remoteActions) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'StandalonePricingElements.tpl.html',
            controller: function($scope, $rootScope, $sldsModal, $compile) {
                $scope.nsp = fileNsPrefix();

                console.log('INIT StandalonePricingElements: ', $scope.customViewAttrs.objectPricingElements);
                $scope.objectId = $scope.customViewAttrs.objectPricingElements.objectId;
                $scope.objectType = $scope.customViewAttrs.objectPricingElements.objectType;
                $scope.objectAPIName = $scope.customViewAttrs.objectPricingElements.objectAPIName;
            }
        };
    }
]);

},{}],37:[function(require,module,exports){
angular.module('cpqdirectives')
.factory('cpqService', ['$rootScope', 
    function($rootScope) {
        var nsp = fileNsPrefix();

        var prodChildTabs = [
            {
                'title': 'Group Cardinality',
                'active': false,
                'hidden': false
            },
            {
                'title': 'Product Child',
                'active': false,
                'hidden': false
            },
            {
                'title': 'Product Attributes',
                'active': false,
                'hidden': false
            },
            {
                'title': 'Product Pricing',
                'active': false,
                'hidden': false
            }
        ];
        var prodChildActiveTabIdx = 0;
        var overrideMode = false;
        var priceListEntryTabs = [
            {
                'title': 'Price List Entry',
                'active': true
            },
            {
                'title': 'Context Rules',
                'active': false
            }
        ];
        var priceListEntryTabIdx = 0;

        return {
            getProductChildTabs: function(isRoot, isLeaf, administerRoot) {
                prodChildTabs[0].hidden = false;
                prodChildTabs[1].hidden = false;
                prodChildTabs[2].hidden = false;
                prodChildTabs[3].hidden = false;

                if (isRoot && isLeaf) {
                    prodChildTabs[0].hidden = true;
                    prodChildTabs[1].hidden = true;
                    if (prodChildActiveTabIdx === 0 || prodChildActiveTabIdx === 1) {
                        prodChildActiveTabIdx = 2;
                    }
                } else if (isRoot) {
                    prodChildTabs[1].hidden = true;
                    if (administerRoot) {
                        if (prodChildActiveTabIdx === 1) {
                            prodChildActiveTabIdx = 0;
                        }
                    } else {
                        prodChildTabs[2].hidden = true;
                        prodChildTabs[3].hidden = true;
                        prodChildActiveTabIdx = 0;
                    }
                    prodChildActiveTabIdx = 0;
                } else if (isLeaf) {
                    prodChildTabs[0].hidden = true;
                    if (prodChildActiveTabIdx === 0) {
                        prodChildActiveTabIdx = 1;
                    }
                }

                angular.forEach(prodChildTabs, function(tab, idx) {
                    tab.active = (prodChildActiveTabIdx === idx);
                });
                return prodChildTabs;
            },
            getProdChildActiveTabIdx: function() {
                return prodChildActiveTabIdx;
            },
            setProdChildActiveTabIdx: function(value) {
                prodChildActiveTabIdx = value;
            },
            getOverrideMode: function() {
                return overrideMode;
            },
            setOverrideMode: function(value) {
                overrideMode = value;
            },
            getPriceListEntryTabs: function(isRoot) {
                return priceListEntryTabs;
            },
            getPriceListEntryTabIdx: function() {
                return priceListEntryTabIdx;
            },
            setPriceListEntryTabIdx: function(value) {
                priceListEntryTabIdx = value;
            },
            showNotification: function(message) {
                var broadcastAction = {
                    'eventName': 'showNotification',
                    'eventData': {
                        'message': message
                    }
                };
                if (window.frameElement !== null) {
                    // create a iframe resize event binding with the parent
                    window.parent.bindIframeEvents('broadcast', broadcastAction);
                }
            }
        };
    }
]);

},{}],38:[function(require,module,exports){
angular.module("cpqdirectives").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("AssignAttrsFields.tpl.html",'<div class="vloc-assgn-attrs-fields">\n    <h3 class="slds-text-heading--small">Assign Attributes and Fields</h3>\n    <div class="vloc-section-actions">\n        <button type="button" class="slds-button slds-button--neutral" ng-click="assignItems()" ng-disabled="selectedCount < 1">Assign</button>\n    </div>\n    <div class="slds-scrollable--x">\n        <table class="slds-table slds-table--bordered items">\n            <thead>\n                <tr class="slds-text-heading--label">\n                    <th>\n                        <label class="slds-checkbox">\n                            <input type="checkbox" ng-model="allSelected" ng-change="selectAll()" />\n                            <span class="slds-checkbox--faux"></span>\n                            <span class="slds-assistive-text">Select All</span>\n                        </label>\n                    </th>\n                    <th>Attribute</th>\n                    <th>Is Bound?</th>\n                    <th>Field</th>\n                </tr>\n            </thead>\n            <tbody>\n                <tr ng-repeat="item in items | orderBy:[\'-bound\',\'fieldLabel\',\'attrName\']">\n                    <td class="slds-cell-shrink" data-label="Select Row">\n                        <label class="slds-checkbox">\n                            <input type="checkbox" ng-model="item.isSelected" ng-change="selectItem(item)" />\n                            <span class="slds-checkbox--faux"></span>\n                            <span class="slds-assistive-text">Select Row</span>\n                        </label>\n                    </td>\n                    <td class="slds-truncate">{{item.attrName}}</td>\n                    <td class="slds-truncate">{{(item.bound ? \'Yes\' : \'No\')}}</td>\n                    <td class="slds-truncate">{{item.fieldLabel}}</td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n</div>'),$templateCache.put("Attachment.tpl.html",'<div class="vloc-attachment">\n    <div ng-repeat="facet in facets">\n        <div ng-if="facet.hasSectionCustomView">\n            <vloc-sections \n                facet="facet"\n                parent-obj="editObject"\n                object-fields="objectFields"\n                object-picklists="objectPicklists"\n                attr-map="attrMap"\n                attr-obj-map="attrObjMap"\n                attr-assgn-obj-map="attrAssgnObjMap"\n                setup-view-attrs="setupViewAttrs(section)"\n                show-attribute-metadata="showAttributeMetadata(attributeId)"\n                ng-if="objectFields && objectPicklists && attrObjMap && attrObjMap"></vloc-sections>\n        </div>\n        <form name="editObjectRecordForm" ng-if="!facet.hasSectionCustomView">\n            <vloc-sections \n                facet="facet"\n                parent-obj="editObject"\n                object-fields="objectFields"\n                object-picklists="objectPicklists"\n                attr-map="attrMap"\n                attr-obj-map="attrObjMap"\n                attr-assgn-obj-map="attrAssgnObjMap"\n                setup-view-attrs="setupViewAttrs(section)"\n                show-attribute-metadata="showAttributeMetadata(attributeId)"\n                form-name="\'editObjectRecordForm\'"\n                ng-if="objectFields && objectPicklists && attrObjMap && attrObjMap"></vloc-sections>\n            <div class="vloc-section-form slds-text-align--right section-el-btn">\n                <button type="button" class="slds-button slds-button--neutral" ng-click="closeDetails()">Cancel</button>\n                <button type="button" class="slds-button slds-button--brand" ng-if="item.Id === undefined" ng-click="createItem($event)" ng-disabled="editObjectRecordForm.$invalid">Save</button>\n                <button type="button" class="slds-button slds-button--brand" ng-if="item.Id !== undefined" ng-click="saveItem($event)" ng-disabled="editObjectRecordForm.$invalid">Save</button>\n            </div>\n        </form>\n    </div>\n</div>'),$templateCache.put("Attachments.tpl.html",'<div class="vloc-attachments">\n    <h3 class="slds-text-heading--small">Attachments</h3>\n    <div class="vloc-section-actions">\n        <button type="button" class="slds-button slds-button--neutral" ng-click="newItem()">New Attachment</button>\n    </div>\n    <div class="slds-scrollable--x">\n        <table class="slds-table slds-table--bordered items">\n            <thead>\n                <tr class="slds-text-heading--label">\n                    <th class="actions"><div class="slds-truncate">&nbsp;</div></th>\n                    <th ng-repeat="field in fieldSet">\n                        <div class="slds-truncate">{{objectFields[field.fieldPath].label}}</div>\n                    </th>\n                </tr>\n            </thead>\n            <tbody>\n                <tr ng-class="{\'slds-is-selected\': (item.Id === selectedItem.Id)}" ng-repeat="item in items" ng-click="selectItem(item)">\n                    <td class="actions">\n                        <button class="slds-button slds-button--icon" ng-click="previewItem(item, $event)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'preview\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Preview</span>\n                        </button>\n                        <button class="slds-button slds-button--icon" ng-click="editItem(item, $event)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'edit\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Edit</span>\n                        </button>\n                        <button class="slds-button slds-button--icon" ng-click="deleteItem(item, $event)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Delete</span>\n                        </button>\n                    </td>\n                    <td ng-repeat="field in fieldSet">\n                        <vloc-obj-field display-mode="\'view\'" parent-obj="item" field-name="field.fieldPath" field-info="objectFields[field.fieldPath]" obj-picklists=""></vloc-obj-field>\n                    </td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n</div>'),$templateCache.put("AttributeDefaultValue.tpl.html",'<span class="vloc-attribute-default-value">\n    <!-- VIEW FIELD -->\n    <span ng-if="displayMode === \'view\'" ng-switch="valueDataType">\n        <span ng-switch-when="Checkbox">\n            <label class="slds-checkbox">\n                <input type="checkbox" name="{{fieldInfo.label}}" id="{{fieldInfo.label}}" ng-model="parentObj[fieldName]" disabled="disabled" />\n                <span class="slds-checkbox--faux"></span>\n                <span class="slds-assistive-text">{{fieldInfo.label}}</span>\n            </label>\n        </span>\n        <span ng-switch-when="Date">\n            {{parentObj[fieldName] | date:\'mediumDate\'}}\n        </span>\n        <span ng-switch-when="Datetime">\n            {{parentObj[fieldName] | date:\'mediumDate\'}}\n        </span>\n        <span ng-switch-when="Lookup">\n            {{lookupObj.selectedItem}}\n        </span>\n        <span ng-switch-default="default">\n            {{parentObj[fieldName]}}\n        </span>\n    </span>\n    <!-- EDIT FIELD -->\n    <span ng-if="displayMode === \'edit\'" ng-switch="valueDataType">\n        <span ng-switch-when="Checkbox">\n            <label class="slds-checkbox">\n                <input type="checkbox" name="{{fieldInfo.label}}" id="{{fieldInfo.label}}" ng-model="parentObj[fieldName]" />\n                <span class="slds-checkbox--faux"></span>\n                <span class="slds-assistive-text">{{fieldInfo.label}}</span>\n            </label>\n        </span>\n        <span ng-switch-when="Date">\n            <input type="text" class="slds-input"\n                name="{{fieldInfo.label}}"\n                id="{{fieldInfo.label}}"\n                ng-model="parentObj[fieldName]"\n                slds-date-picker="true"\n                data-date-format="shortDate"\n                data-date-type="iso"\n                data-trigger="focus" />\n        </span>\n        <span ng-switch-when="Datetime" class="slds-grid">\n            <input type="text" class="slds-input slds-size--1-of-2"\n                name="{{fieldInfo.label}}"\n                id="{{fieldInfo.label}}"\n                ng-model="parentObj[fieldName]"\n                slds-date-picker="true"\n                data-date-format="shortDate"\n                data-date-type="iso"\n                data-trigger="focus" />\n            <input type="text" class="slds-input slds-size--1-of-2"\n                name="{{fieldInfo.label}}"\n                id="{{fieldInfo.label}}"\n                ng-model="parentObj[fieldName]"\n                slds-time-picker="true"\n                data-time-format="mediumTime"\n                data-date-type="iso" />\n        </span>\n        <span ng-switch-when="Picklist">\n            <select name="{{fieldInfo.label}}" id="{{fieldInfo.label}}" ng-model="parentObj[fieldName]" class="slds-select">\n                <option ng-repeat="o in objPicklists" value="{{o.value}}" ng-selected="o.value === selectedPicklistItem">{{o.label}}</option>\n            </select>\n        </span>\n        <span ng-switch-when="Multi Picklist">\n            <select name="{{fieldInfo.label}}" id="{{fieldInfo.label}}" multiple="multiple" ng-model="selectedMPItems" ng-change="setMultiPicklistValues(selectedMPItems)" class="slds-select">\n                <option ng-repeat="o in objPicklists" value="{{o.value}}" ng-selected="o.selected">{{o.label}}</option>\n            </select>\n        </span>\n        <span ng-switch-when="Lookup">\n            <div class="slds-input-has-icon slds-input-has-icon--right">\n                <slds-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'search\'" extra-classes="\'slds-input__icon slds-icon-text-default\'"></slds-svg-icon>\n                <input type="text" name="{{fieldInfo.label}}" id="{{fieldInfo.label}}" ng-model="lookupObj.selectedItem" ng-focus="lookupObj.showItems = true" ng-blur="lookupObj.showItems = false" class="slds-input" />\n            </div>\n            <div class="slds-lookup" ng-show="lookupObj.showItems">\n                <div class="slds-lookup__menu" role="listbox">\n                    <ul class="slds-lookup__list" role="presentation">\n                        <li class="slds-lookup__item" ng-repeat="luItem in lookupItems | orderBy:\'Name\' | filter:lookupObj.selectedItem">\n                            <a id="{{luItem.Id}}" href="#" role="option" ng-mousedown="selectLookupItem(luItem)">{{luItem.Name}}</a>\n                        </li>\n                    </ul>\n                </div>\n            </div>\n        </span>\n        <span ng-switch-default="default">\n            <input type="text" name="{{fieldInfo.label}}" id="{{fieldInfo.label}}" ng-model="parentObj[fieldName]" class="slds-input" />\n        </span>\n    </span>\n</span>'),$templateCache.put("AttributeMetadata.tpl.html",'<div class="vloc-attribute-metadata vloc-override">\n    <div class="vloc-facet">\n        <div ng-if="overrideMode" class="slds-m-top--small slds-m-bottom--medium">\n            <div class="override-form override-form-hd" ng-if="hasOverride">\n                <div class="override-form-lbl"></div>\n                <div class="override-form-element">Original Values</div>\n                <div class="override-form-element">Override Values</div>\n                <div class="override-form-element"></div>\n            </div>\n        </div>\n        <section class="vloc-section">\n            <h3 class="slds-text-heading--label">Primary Info</h3>\n            <div class="vloc-section-body">\n                <div class="override-form" ng-init="f1 = (nsp + \'AttributeDisplayNameOverride__c\')">\n                    <label class="override-form-element" for="{{objectFields[f1].label}}">Display Name</label>\n                    <div class="override-form-element">\n                        <vloc-obj-field display-mode="objDisplayMode" parent-obj="editItem" field-name="f1" field-info="objectFields[f1]" obj-picklists="objectPicklists[f1.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !overrideMode}">\n                        <vloc-obj-field ng-if="hasOverride" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f1" field-info="objectFields[f1]" obj-picklists="objectPicklists[f1.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n            </div>\n        </section>\n        <section class="vloc-section">\n            <h3 class="slds-text-heading--label">Effectivity</h3>\n            <div class="vloc-section-body">\n                <div class="override-form" ng-init="f2 = (nsp + \'IsActiveAssignment__c\')">\n                    <label class="override-form-element" for="{{objectFields[f2].label}}">Active</label>\n                    <div class="override-form-element">\n                        <vloc-obj-field display-mode="objDisplayMode" parent-obj="editItem" field-name="f2" field-info="objectFields[f2]" obj-picklists="objectPicklists[f2.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !overrideMode}">\n                        <vloc-obj-field ng-if="hasOverride" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f2" field-info="objectFields[f2]" obj-picklists="objectPicklists[f2.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n            </div>\n        </section>\n        <section class="vloc-section">\n            <h3 class="slds-text-heading--label">Data Info</h3>\n            <div class="vloc-section-body">\n                <div class="override-form" ng-init="f8 = (nsp + \'ValueDataType__c\')">\n                    <label class="override-form-element" for="{{objectFields[f8].label}}">Value Data Type</label>\n                    <div class="override-form-element">\n                        <vloc-obj-field display-mode="objDisplayMode" parent-obj="editItem" field-name="f8" field-info="objectFields[f8]" obj-picklists="objectPicklists[f8.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !overrideMode}">\n                        <vloc-obj-field ng-if="hasOverride" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f8" field-info="objectFields[f8]" obj-picklists="objectPicklists[f8.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n                <div class="override-form" ng-if="editItem[nsp+\'ValueDataType__c\'] === \'Lookup\'" ng-init="f10 = (nsp + \'LookupObjectId__c\')">\n                    <label class="override-form-element" for="{{objectFields[f10].label}}">Lookup Object</label>\n                    <div class="override-form-element">\n                        <vloc-obj-field display-mode="objDisplayMode" parent-obj="editItem" field-name="f10" field-info="objectFields[f10]" obj-picklists="objectPicklists[f10.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !overrideMode}">\n                        <vloc-obj-field ng-if="hasOverride" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f10" field-info="objectFields[f10]" obj-picklists="objectPicklists[f10.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n                <div class="override-form" ng-if="editItem[nsp+\'ValueDataType__c\'] === \'Lookup\'" ng-init="f11 = (nsp + \'LookupObjectTypeId__c\')">\n                    <label class="override-form-element" for="{{objectFields[f11].label}}">Lookup Object Type</label>\n                    <div class="override-form-element">\n                        <vloc-obj-field display-mode="objDisplayMode" parent-obj="editItem" field-name="f11" field-info="objectFields[f11]" obj-picklists="objectPicklists[f11.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !overrideMode}">\n                        <vloc-obj-field ng-if="hasOverride" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f11" field-info="objectFields[f11]" obj-picklists="objectPicklists[f11.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n                <div class="override-form" ng-if="editItem[nsp+\'ValueDataType__c\'] === \'Lookup\'" ng-init="f12 = (nsp + \'LookupFilter__c\')">\n                    <label class="override-form-element" for="{{objectFields[f12].label}}">Lookup Filter</label>\n                    <div class="override-form-element">\n                        <vloc-obj-field display-mode="objDisplayMode" parent-obj="editItem" field-name="f12" field-info="objectFields[f12]" obj-picklists="objectPicklists[f12.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !overrideMode}">\n                        <vloc-obj-field ng-if="hasOverride" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f12" field-info="objectFields[f12]" obj-picklists="objectPicklists[f12.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n                <div class="override-form" ng-init="f13 = (nsp + \'Value__c\')">\n                    <label class="override-form-element" for="defaultValue">Default Value</label>\n                    <div class="override-form-element">\n                        <vloc-attribute-default-value ng-if="editItem" configure-mode="editItem[nsp+\'IsConfigurable__c\']" display-mode="objDisplayMode" parent-obj="editItem" field-name="f13" value-data-type="editItem[nsp+\'ValueDataType__c\']" picklist-items="picklistItems" lookup-items="lookupItems"></vloc-attribute-default-value>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !overrideMode}">\n                        <vloc-obj-field ng-if="hasOverride" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f13" field-info="objectFields[f13]" obj-picklists="objectPicklists[f13.toLowerCase()]"></vloc-obj-field>\n                        <vloc-attribute-default-value ng-if="hasOverride && editItem" configure-mode="overrideObj[nsp+\'IsConfigurable__c\']" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f13" value-data-type="overrideObj[nsp+\'ValueDataType__c\']" picklist-items="picklistItems" lookup-items="lookupItems"></vloc-attribute-default-value>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n                <div class="override-form" ng-if="isPicklistValueType" ng-init="f9 = (nsp + \'PicklistId__c\')">\n                    <label class="override-form-element" for="{{objectFields[f9].label}}">Picklist</label>\n                    <div class="override-form-element">\n                        <vloc-obj-field display-mode="objDisplayMode" parent-obj="editItem" field-name="f9" field-info="objectFields[f9]" obj-picklists="objectPicklists[f9.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !overrideMode}">\n                        <vloc-obj-field ng-if="hasOverride" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f9" field-info="objectFields[f9]" obj-picklists="objectPicklists[f9.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n                <div class="override-form" ng-if="isPicklistValueType">\n                    <label class="override-form-element" for="PicklistDisplayType">Picklist Display Type</label>\n                    <div class="override-form-element">\n                        <select name="PicklistDisplayType" id="PicklistDisplayType" ng-model="editItem[nsp+\'UIDisplayType__c\']" class="slds-select">\n                            <option ng-repeat="o in picklistDisplayTypes" value="{{o.value}}" ng-selected="o.value === selectedPicklistValueType">{{o.label}}</option>\n                        </select>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !overrideMode}"></div>\n                    <div class="override-form-element"></div>\n                </div>\n            </div>\n        </section>\n        <section class="vloc-section">\n            <h3 class="slds-text-heading--label">Behaviors</h3>\n            <div class="vloc-section-body">\n                <div class="override-form" ng-init="f3 = (nsp + \'HasRule__c\')">\n                    <label class="override-form-element" for="{{objectFields[f3].label}}">Has Rule</label>\n                    <div class="override-form-element">\n                        <vloc-obj-field display-mode="objDisplayMode" parent-obj="editItem" field-name="f3" field-info="objectFields[f3]" obj-picklists="objectPicklists[f3.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !overrideMode}">\n                        <vloc-obj-field ng-if="hasOverride" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f3" field-info="objectFields[f3]" obj-picklists="objectPicklists[f3.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n                <div class="override-form" ng-init="f4 = (nsp + \'IsHidden__c\')">\n                    <label class="override-form-element" for="{{objectFields[f4].label}}">Hidden</label>\n                    <div class="override-form-element">\n                        <vloc-obj-field display-mode="objDisplayMode" parent-obj="editItem" field-name="f4" field-info="objectFields[f4]" obj-picklists="objectPicklists[f4.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !overrideMode}">\n                        <vloc-obj-field ng-if="hasOverride" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f4" field-info="objectFields[f4]" obj-picklists="objectPicklists[f4.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n                <div class="override-form" ng-init="f5 = (nsp + \'IsReadOnly__c\')">\n                    <label class="override-form-element" for="{{objectFields[f5].label}}">Read Only</label>\n                    <div class="override-form-element">\n                        <vloc-obj-field display-mode="objDisplayMode" parent-obj="editItem" field-name="f5" field-info="objectFields[f5]" obj-picklists="objectPicklists[f5.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !overrideMode}">\n                        <vloc-obj-field ng-if="hasOverride" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f5" field-info="objectFields[f5]" obj-picklists="objectPicklists[f5.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n                <div class="override-form" ng-init="f6 = (nsp + \'IsRequired__c\')">\n                    <label class="override-form-element" for="{{objectFields[f6].label}}">Required</label>\n                    <div class="override-form-element">\n                        <vloc-obj-field display-mode="objDisplayMode" parent-obj="editItem" field-name="f6" field-info="objectFields[f6]" obj-picklists="objectPicklists[f6.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !overrideMode}">\n                        <vloc-obj-field ng-if="hasOverride" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f6" field-info="objectFields[f6]" obj-picklists="objectPicklists[f6.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n                <div class="override-form" ng-init="f7 = (nsp + \'IsConfigurable__c\')">\n                    <label class="override-form-element" for="{{objectFields[f7].label}}">Run-time Configurable</label>\n                    <div class="override-form-element">\n                        <vloc-obj-field display-mode="objDisplayMode" parent-obj="editItem" field-name="f7" field-info="objectFields[f7]" obj-picklists="objectPicklists[f7.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !overrideMode}">\n                        <vloc-obj-field ng-if="hasOverride" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f7" field-info="objectFields[f7]" obj-picklists="objectPicklists[f7.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n            </div>\n        </section>\n        <div ng-if="!overrideMode" class="slds-form-element__row slds-text-align--right vloc-section-form">\n            <button type="button" class="slds-button slds-button--brand" ng-click="saveItem($event)">Save</button>\n        </div>\n    </div>\n</div>'),$templateCache.put("AttributeMetadataModal.tpl.html",'<div class="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n            <h3 class="slds-text-heading--medium">{{modalTitle}}</h3>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium">\n            <div>\n                <vloc-attribute-metadata\n                    object-id="objectId"\n                    attr-obj="attrObj"\n                    attr-assgn-obj="attrAssgnObj"\n                    attr-assgn-override-obj="attrAssgnOverrideObj"\n                    attr-override-def-obj="attrOverrideDefObj"\n                    mode="mode"\n                    root-product-id="rootProductId"\n                    prod-child-item-obj="prodChildItemObj"\n                    is-product="isProduct"></vloc-attribute-metadata>\n            </div>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="$hide()">{{cancelActionLbl}}</button>\n            <button type="button" class="slds-button slds-button--brand" ng-click="confirmAction()">{{confirmActionLbl}}</button>\n        </div>\n    </div>\n</div>'),$templateCache.put("ConfirmationModal.tpl.html",'<div class="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n            <h3 class="slds-text-heading--medium">{{confirmationTitle}}</h3>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium">\n            <div>\n                <p ng-bind-html="confirmationMsg"></p>\n            </div>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="$hide()">{{cancelActionLbl}}</button>\n            <button type="button" class="slds-button slds-button--brand" ng-click="confirmAction()">{{confirmActionLbl}}</button>\n        </div>\n    </div>\n</div>'),$templateCache.put("ContextRule.tpl.html",'<div class="vloc-context-rule">\n    <div ng-repeat="facet in facets">\n        <h2 class="slds-text-heading--small" ng-if="facets.length > 1">{{facet.facetObj.Name}}</h2>\n        <section class="vloc-section" ng-repeat="section in facet.sections">\n            <h3 class="slds-text-heading--label">{{section.sectionObj.Name}}</h3>\n            <div class="vloc-section-body">\n                <div ng-if="!section.hasCustomView" class="slds-form--horizontal">\n                    <div class="slds-form-element" ng-repeat="sectionEl in section.sectionElements" ng-init="fieldName = sectionEl[nsp+\'FieldApiName__c\']; fieldName = (fieldName.endsWith(\'__c\') ? nsp+fieldName : fieldName);">\n                        <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">{{sectionEl.Name}}</label>\n                        <div class="slds-form-element__control">\n                            <div ng-switch="sectionEl[nsp+\'Type__c\']">\n                                <div ng-switch-when="Field">\n                                    <vloc-obj-field display-mode="\'edit\'" parent-obj="contextRule" field-name="fieldName" field-info="objectFields[fieldName]" obj-picklists="objectPicklists[fieldName.toLowerCase()]"></vloc-obj-field>\n                                </div>\n                                <div ng-switch-when="Attribute">\n                                    <vloc-attribute attribute-id="sectionEl[nsp+\'AttributeId__c\']" object-id="contextRule.Id" attr-map="attrMap" attr-obj="null" attr-assgn-obj="null" picklist-items="null"></vloc-attribute>\n                                </div>\n                                <div ng-switch-when="Custom View">\n                                    Something is wrong!\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </section>\n    </div>\n</div>'),$templateCache.put("ContextRuleInfoCard.tpl.html",'<div class="slds-card slds-card--narrow vloc-context-rule-info-card">\n    <div class="slds-card__body">\n        <div class="slds-card__body--inner">\n            <div class="slds-tile">\n                <div class="slds-tile__detail slds-text-body--small">\n                    <dl class="slds-list--vertical slds-truncate">\n                        <dt class="slds-item--label slds-text-color--weak slds-truncate" title="Name">Name:</dt>\n                        <dd class="slds-item--detail slds-truncate">{{contextRule.Name}}</dd>\n                        <dt class="slds-item--label slds-text-color--weak slds-truncate" title="Expression">Expression:</dt>\n                        <dd class="slds-item--detail slds-truncate">{{contextRule[nsp+\'Expression__c\']}}</dd>\n                        <dt class="slds-item--label slds-text-color--weak slds-truncate" title="Failure Message">Failure Message:</dt>\n                        <dd class="slds-item--detail slds-truncate">{{contextRule[nsp+\'FailureMessage__c\']}}</dd>\n                        <dt class="slds-item--label slds-text-color--weak slds-truncate" title="Not">Not:</dt>\n                        <dd class="slds-item--detail slds-truncate">{{contextRule[nsp+\'IsNegated__c\']}}</dd>\n                    </dl>\n                </div>\n            </div>\n        </div>\n    </div>\n</div>'),
$templateCache.put("ContextRuleModal.tpl.html",'<div class="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n            <button class="slds-button slds-modal__close slds-button--icon-inverse" title="Close" ng-click="hideAction()">\n                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'close\'"></slds-button-svg-icon>\n                <span class="slds-assistive-text">Close</span>\n            </button>\n            <h3 class="slds-text-heading--medium">{{title}}</h3>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium">\n            <div class="vloc-context-rule-content">\n                <vloc-context-rule-set context-rule-set="contextRuleSet" context-rules="contextRules" object-id="objectId" mode="mode"></vloc-context-rule-set>\n            </div>\n        </div>\n    </div>\n</div>'),$templateCache.put("ContextRuleSet.tpl.html",'<div class="vloc-context-rule-set">\n    <div class="cr-section">\n        <h3 class="slds-text-heading--small">Context Rule Set</h3>\n        <h4 class="slds-text-heading--label">General Properties</h4>\n        <div class="slds-form--horizontal">\n            <div class="slds-form-element" ng-init="f1 = \'Name\'">\n                <label class="slds-form-element__label" for="{{objectFields.ruleset[f1].label}}">{{objectFields.ruleset[f1].label}}</label>\n                <div class="slds-form-element__control">\n                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editRuleSet" field-name="f1" field-info="objectFields.ruleset[f1]" obj-picklists="objectPicklists.ruleset[f1.toLowerCase()]"></vloc-obj-field>\n                </div>\n            </div>\n            <div class="slds-form-element" ng-init="f3 = (nsp + \'ObjectType__c\')">\n                <label class="slds-form-element__label" for="{{objectFields.ruleset[f3].label}}">{{objectFields.ruleset[f3].label}}</label>\n                <div class="slds-form-element__control">\n                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editRuleSet" field-name="f3" field-info="objectFields.ruleset[f3]" obj-picklists="objectPicklists.ruleset[f3.toLowerCase()]"></vloc-obj-field>\n                </div>\n            </div>\n        </div>\n        <h4 class="slds-text-heading--label">Effectivity</h4>\n        <div class="slds-form--horizontal">\n            <div class="slds-form-element" ng-init="f4 = (nsp + \'EffectiveFromDate__c\')">\n                <label class="slds-form-element__label" for="{{objectFields.ruleset[f4].label}}">{{objectFields.ruleset[f4].label}}</label>\n                <div class="slds-form-element__control">\n                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editRuleSet" field-name="f4" field-info="objectFields.ruleset[f4]" obj-picklists="objectPicklists.ruleset[f4.toLowerCase()]"></vloc-obj-field>\n                </div>\n            </div>\n            <div class="slds-form-element" ng-init="f5 = (nsp + \'EffectiveUntilDate__c\')">\n                <label class="slds-form-element__label" for="{{objectFields.ruleset[f5].label}}">{{objectFields.ruleset[f5].label}}</label>\n                <div class="slds-form-element__control">\n                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editRuleSet" field-name="f5" field-info="objectFields.ruleset[f5]" obj-picklists="objectPicklists.ruleset[f5.toLowerCase()]"></vloc-obj-field>\n                </div>\n            </div>\n            <div class="slds-form-element" ng-init="f6 = (nsp + \'IsActive__c\')">\n                <label class="slds-form-element__label" for="{{objectFields.ruleset[f6].label}}">{{objectFields.ruleset[f6].label}}</label>\n                <div class="slds-form-element__control">\n                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editRuleSet" field-name="f6" field-info="objectFields.ruleset[f6]" obj-picklists="objectPicklists.ruleset[f6.toLowerCase()]"></vloc-obj-field>\n                </div>\n            </div>\n        </div>\n    </div>\n    <div class="cr-section">\n        <h3 class="slds-text-heading--small">Rules</h3>\n        <div class="slds-form--horizontal">\n            <div class="slds-form-element" ng-init="f2 = (nsp + \'Expression__c\')">\n                <label class="slds-form-element__label" for="{{objectFields.ruleset[f2].label}}">Rule Set Expression</label>\n                <div class="slds-form-element__control">\n                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editRuleSet" field-name="f2" field-info="objectFields.ruleset[f2]" obj-picklists="objectPicklists.ruleset[f2.toLowerCase()]"></vloc-obj-field>\n                </div>\n            </div>\n        </div>\n        <div ng-if="!cfg.hasHeaderRule" class="slds-m-top--small">\n            <button class="slds-button" ng-click="addRule(\'header\')">\n                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'add\'"></slds-button-svg-icon>&nbsp;Add Header Rule\n            </button>\n        </div>\n        <div ng-if="cfg.hasHeaderRule" ng-class="{\'slds-section\': true, \'slds-is-open\': headerRule.show}">\n            <div class="child-rule slds-clearfix slds-m-top--medium">\n                <div class="slds-float--left">\n                    <button class="slds-button" ng-click="headerRule.show = !headerRule.show">\n                        <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'switch\'" extra-classes="\'slds-section__title-action-icon\'"></slds-button-svg-icon>&nbsp;Rule 1 (Header)\n                    </button>\n                </div>\n                <div class="slds-float--right">\n                    <button class="slds-button" ng-click="deleteItem(\'header\', headerRule)" ng-disabled="(childrenRules.length > 0 || cfg.hasFallbackRule)">\n                        <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>&nbsp;Remove Header Rule\n                    </button>\n                </div>\n            </div>\n            <div class="slds-section__content">\n                <vloc-context-rule object-type="editRuleSet[nsp+\'ObjectType__c\']" display-mode="\'edit\'" context-rule="headerRule" object-fields="objectFields.rule" object-picklists="objectPicklists.rule"></vloc-context-rule>\n            </div>\n        </div>\n        <div ng-repeat="rule in childrenRules" ng-class="{\'slds-section\': true, \'slds-is-open\': rule.show}">\n            <div class="child-rule slds-clearfix">\n                <div class="slds-float--left">\n                    <button class="slds-button" ng-click="rule.show = !rule.show">\n                        <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'switch\'" extra-classes="\'slds-section__title-action-icon\'"></slds-button-svg-icon>&nbsp;Rule {{($index + 2)}}\n                    </button>\n                </div>\n                <div class="slds-float--right">\n                    <button class="slds-button" ng-click="deleteItem(\'child\', rule, $index)">\n                        <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>&nbsp;Remove Rule\n                    </button>\n                </div>\n            </div>\n            <div class="slds-section__content">\n                <vloc-context-rule object-type="editRuleSet[nsp+\'ObjectType__c\']" display-mode="\'edit\'" context-rule="rule" object-fields="objectFields.rule" object-picklists="objectPicklists.rule"></vloc-context-rule>\n            </div>\n        </div>\n        <div>\n            <button class="slds-button" ng-click="addRule(\'child\')" ng-disabled="!cfg.hasHeaderRule">\n                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'add\'"></slds-button-svg-icon>&nbsp;Add Rule\n            </button>\n        </div>\n        <div ng-if="!cfg.hasFallbackRule">\n            <button class="slds-button" ng-click="addRule(\'fallback\')" ng-disabled="!cfg.hasHeaderRule">\n                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'add\'"></slds-button-svg-icon>&nbsp;Add Fallback Rule\n            </button>\n        </div>\n        <div ng-if="cfg.hasFallbackRule" ng-class="{\'slds-section\': true, \'slds-is-open\': fallbackRule.show}">\n            <div class="child-rule slds-clearfix">\n                <div class="slds-float--left">\n                    <button class="slds-button" ng-click="fallbackRule.show = !fallbackRule.show">\n                        <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'switch\'" extra-classes="\'slds-section__title-action-icon\'"></slds-button-svg-icon>&nbsp;Rule {{(childrenRules.length + 2)}} (Fallback)\n                    </button>\n                </div>\n                <div class="slds-float--right">\n                    <button class="slds-button" ng-click="deleteItem(\'fallback\', fallbackRule)">\n                        <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>&nbsp;Remove Fallback Rule\n                    </button>\n                </div>\n            </div>\n            <div class="slds-section__content">\n                <vloc-context-rule object-type="editRuleSet[nsp+\'ObjectType__c\']" display-mode="\'edit\'" context-rule="fallbackRule" object-fields="objectFields.rule" object-picklists="objectPicklists.rule"></vloc-context-rule>\n            </div>\n        </div>\n    </div>\n    <div class="slds-form-element__row form-buttons slds-text-align--right">\n        <button type="button" class="slds-button slds-button--neutral" ng-click="closeDetails()">Cancel</button>\n        <button type="button" class="slds-button slds-button--brand" ng-if="contextRuleSet === null" ng-click="createItem($event)">Save</button>\n        <button type="button" class="slds-button slds-button--brand" ng-if="contextRuleSet !== null" ng-click="saveItem($event)">Save</button>\n    </div>\n</div>'),$templateCache.put("ContextRules.tpl.html",'<div class="vloc-context-rules">\n    <h3 class="slds-text-heading--small">Context Rules</h3>\n    <div class="vloc-section-actions">\n        <button type="button" class="slds-button slds-button--neutral" ng-click="newItem()">New Rule Set</button>\n    </div>\n    <div class="slds-scrollable--x">\n        <table class="slds-table slds-table--bordered slds-no-row-hover context-rules">\n            <thead>\n                <tr class="slds-text-heading--label">\n                    <th class="actions"></th>\n                    <th><div class="slds-truncate">Name</div></th>\n                    <!-- <th><div class="slds-truncate">Object Type</div></th> -->\n                    <!-- <th><div class="slds-truncate">Expression</div></th> -->\n                    <th><div class="slds-truncate">Header Rule</div></th>\n                    <th><div class="slds-truncate">Fallback Rule</div></th>\n                    <th><div class="slds-truncate">Rules</div></th>\n                    <th><div class="slds-truncate">Effectivity</div></th>\n                </tr>\n            </thead>\n            <tbody>\n                <tr ng-if="rulesets.length === 0">\n                    <td colspan="6">There are no rule sets.</td>\n                </tr>\n                <tr ng-class="{\'slds-is-selected\': (ruleset.Id === selectedItem.Id)}" ng-repeat="ruleset in rulesets" ng-click="selectItem(ruleset)">\n                    <td class="actions">\n                        <button class="slds-button slds-button--icon" ng-click="editItem(ruleset, $event)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'edit\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Edit</span>\n                        </button>\n                        <button class="slds-button slds-button--icon" ng-click="deleteItem(ruleset, $event)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Delete</span>\n                        </button>\n                    </td>\n                    <td class="non-rule">\n                        <vloc-obj-field ng-init="f1 = \'Name\'" display-mode="\'view\'" parent-obj="ruleset" field-name="f1" field-info="objectFields.ruleset[f1]" obj-picklists="objectPicklistsRuleset[f1]"></vloc-obj-field></span>\n                    </td>\n                    <!-- <td class="non-rule">\n                        <vloc-obj-field ng-init="f2 = (nsp + \'ObjectType__c\')" display-mode="\'view\'" parent-obj="ruleset" field-name="f2" field-info="objectFields.ruleset[f2]" obj-picklists="objectPicklistsRuleset[f2]"></vloc-obj-field></span>\n                    </td>\n                    <td class="non-rule">\n                        <vloc-obj-field ng-init="f3 = (nsp + \'Expression__c\')" display-mode="\'view\'" parent-obj="ruleset" field-name="f3" field-info="objectFields.ruleset[f3]" obj-picklists="objectPicklistsRuleset[f3]"></vloc-obj-field></span>\n                    </td> -->\n                    <td class="rule-info">\n                        <span ng-if="ruleset[nsp+\'HeaderRuleId__r\']">\n                            {{ruleset[nsp+\'HeaderRuleId__r\'].Name}}&nbsp;\n                            <a href="javascript:void(0);" ng-click="showRuleInfo(ruleset[nsp+\'HeaderRuleId__r\'], $event)">\n                                <slds-svg-icon sprite="\'utility\'" size="\'x-small\'" icon="\'info\'" extra-classes="\'slds-icon-text-default\'"></slds-svg-icon>\n                                <span class="slds-assistive-text">Information</span>\n                            </a>\n                        </span>\n                    </td>\n                    <td class="rule-info">\n                        <span ng-if="ruleset[nsp+\'FallbackRuleId__r\']">\n                            {{ruleset[nsp+\'FallbackRuleId__r\'].Name}}&nbsp;\n                            <a href="javascript:void(0);" ng-click="showRuleInfo(ruleset[nsp+\'FallbackRuleId__r\'], $event)">\n                                <slds-svg-icon sprite="\'utility\'" size="\'x-small\'" icon="\'info\'" extra-classes="\'slds-icon-text-default\'"></slds-svg-icon>\n                                <span class="slds-assistive-text">Information</span>\n                            </a>\n                        </span>\n                    </td>\n                    <td class="rule-info">\n                        <ul>\n                            <li ng-repeat="rule in ruleMap[ruleset.Id]" ng-class="{\'slds-has-divider--top-space\': ($index !== 0)}">\n                                {{rule.Name}}&nbsp;\n                                <a href="javascript:void(0);" ng-click="showRuleInfo(rule, $event)">\n                                    <slds-svg-icon sprite="\'utility\'" size="\'x-small\'" icon="\'info\'" extra-classes="\'slds-icon-text-default\'"></slds-svg-icon>\n                                    <span class="slds-assistive-text">Information</span>\n                                </a>\n                            </li>\n                        </ul>\n                    </td>\n                    <td class="non-rule">\n                        <span><b>Active:</b> {{(ruleset[nsp+\'IsActive__c\'] ? \'Yes\' : \'No\')}}</span><br>\n                        <span><b>Start:</b> <vloc-obj-field ng-init="f5 = (nsp + \'EffectiveFromDate__c\')" display-mode="\'view\'" parent-obj="ruleset" field-name="f5" field-info="objectFields.ruleset[f5]" obj-picklists="objectPicklistsRuleset[f5]"></vloc-obj-field></span><br>\n                        <span><b>End:</b> <vloc-obj-field ng-init="f6 = (nsp + \'EffectiveUntilDate__c\')" display-mode="\'view\'" parent-obj="ruleset" field-name="f6" field-info="objectFields.ruleset[f6]" obj-picklists="objectPicklistsRuleset[f6]"></vloc-obj-field></span>\n                    </td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n</div>'),$templateCache.put("DataTable.tpl.html",'<div class="vloc-data-table">\n    <table class="slds-table slds-table--bordered">\n        <thead>\n            <tr class="slds-text-heading--label">\n                <th><div class="slds-truncate">Name</div></th>\n                <th><div class="slds-truncate">Display Text</div></th>\n                <th><div class="slds-truncate">Code</div></th>\n                <th><div class="slds-truncate">Value</div></th>\n            </tr>\n        </thead>\n        <tbody>\n            <tr ng-class="{\'slds-is-selected\': (item.Id === selectedItem.Id)}" ng-repeat="item in items" ng-click="selectItem(item)">\n                <td>{{item[\'Name\']}}</td>\n                <td>{{item[nsp+\'DisplayText__c\']}}</td>\n                <td>{{item[nsp+\'Code__c\']}}</td>\n                <td>{{item[nsp+\'Value__c\']}}</td>\n            </tr>\n        </tbody>\n    </table>\n</div>'),$templateCache.put("FieldMetadata.tpl.html",'<div class="vloc-field-metadata">\n    <div class="slds-form--horizontal">\n        <div class="slds-form-element slds-m-bottom--medium">\n            <label class="slds-form-element__label" for="">Field Label</label>\n            <div class="slds-form-element__control">\n                {{fieldMetadata.label}}\n            </div>\n        </div>\n        <div class="slds-form-element slds-m-bottom--medium">\n            <label class="slds-form-element__label" for="">Field API Name</label>\n            <div class="slds-form-element__control">\n                {{fieldMetadata.name}}\n            </div>\n        </div>\n        <div class="slds-form-element slds-m-bottom--medium">\n            <label class="slds-form-element__label" for="">Field Type</label>\n            <div class="slds-form-element__control">\n                {{fieldMetadata.type}}\n            </div>\n        </div>\n        <div class="slds-form-element slds-m-bottom--medium" ng-if="fieldMetadata.picklistValues.length > 0">\n            <label class="slds-form-element__label" for="">Picklist Values</label>\n            <div class="slds-form-element__control">\n                <select class="slds-select">\n                    <option ng-repeat="o in fieldMetadata.picklistValues" value="{{o.value}}" ng-selected="o.defaultValue">{{o.label}}</option>\n                </select>\n            </div>\n        </div>\n    </div>\n</div>'),$templateCache.put("GlobalPricingElements.tpl.html",'<div class="vloc-global-pricing-elements">\n    <vloc-object-pricing-elements mode="\'global\'" custom-view-attrs="customViewAttrs"></vloc-object-pricing-elements>\n</div>'),$templateCache.put("ImageCarousel.tpl.html",'<div class="vloc-img-carousel">\n    <div class="carousel">\n        <div class="carousel-inner">\n            <img ng-src="{{currentImg[nsp+\'UrlLong__c\']}}" class="carousel-img" alt="{{currentImg.Name}}" />\n        </div>\n        <div class="carousel-nav prev" ng-if="attachments.length > 1">\n            <button class="slds-button slds-button--icon" ng-click="switchImage(currentIdx-1)">\n                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'chevronleft\'"></slds-button-svg-icon>\n                <span class="slds-assistive-text">Previous</span>\n            </button>\n        </div>\n        <div class="carousel-nav next" ng-if="attachments.length > 1">\n            <button class="slds-button slds-button--icon" ng-click="switchImage(currentIdx+1)">\n                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'chevronright\'"></slds-button-svg-icon>\n                <span class="slds-assistive-text">Next</span>\n            </button>\n        </div>\n    </div>\n    <div class="img-nav">\n        <ul class="thumbnails" ng-if="attachments.length > 1">\n            <li ng-repeat="attachment in attachments" ng-class="{\'active\': ($index === currentIdx)}" ng-click="switchImage($index)">\n                <img ng-src="{{attachment[nsp+\'UrlLong__c\']}}" class="thumb" alt="{{attachment.Name}}" />\n            </li>\n        </ul>\n    </div>\n</div>'),$templateCache.put("LayoutElement.tpl.html",'<div class="vloc-layout-element">\n    <div class="slds-form--horizontal">\n        <div ng-if="(objectName !== \'ObjectElement__c\')" class="slds-form-element slds-m-bottom--medium" ng-repeat="field in fieldSet">\n            <label class="slds-form-element__label" for="{{objectFields[field.fieldPath].label}}">{{objectFields[field.fieldPath].label}}</label>\n            <div class="slds-form-element__control">\n                <vloc-obj-field display-mode="\'edit\'" parent-obj="elementObj" field-name="field.fieldPath" field-info="objectFields[field.fieldPath]" obj-picklists="objectPicklists[field.fieldPath.toLowerCase()]"></vloc-obj-field>\n            </div>\n        </div>\n        <div ng-if="(objectName === \'ObjectElement__c\')">\n            <div class="slds-form-element slds-m-bottom--medium">\n                <label class="slds-form-element__label" for="Field">Field</label>\n                <div class="slds-form-element__control">\n                    <select name="Field" id="Field" ng-model="sectionElement.idx" ng-change="setDisplayLabel()" class="slds-select">\n                        <option ng-repeat="el in objectLayoutFields | orderBy:\'label\'" value="{{el.idx}}" ng-selected="el.idx === sectionElement.idx">{{el.label}}</option>\n                    </select>\n                </div>\n            </div>\n            <div class="slds-form-element slds-m-bottom--medium">\n                <label class="slds-form-element__label" for="Label">Display Label</label>\n                <div class="slds-form-element__control">\n                    <input type="text" name="Label" id="Label" ng-model="sectionElement.label" class="slds-input" />\n                </div>\n            </div>\n            <div class="slds-form-element slds-m-bottom--medium">\n                <label class="slds-form-element__label" for="Sequence">Sequence</label>\n                <div class="slds-form-element__control">\n                    <input type="number" name="Sequence" id="Sequence" ng-model="sectionElement.sequence" class="slds-input" />\n                </div>\n            </div>\n        </div>\n        <div class="slds-form-element slds-text-align--right">\n            <button type="button" class="slds-button slds-button--brand" ng-click="saveItem($event)">Save</button>\n        </div>\n    </div>\n</div>'),$templateCache.put("LayoutManagement.tpl.html",'<div class="vloc-layout-mgmt">\n    <div class="instance-layout">\n        <div class="facet" ng-repeat="facet in facets">\n            <div class="facet-name slds-clearfix" ng-click="editItem(facet.objectFacetObj, \'ObjectFacet__c\', $event)">\n                <div class="slds-float--left">\n                    {{facet.facetObj.Name}} <span class="slds-badge slds-theme--facet">FACET</span>\n                </div>\n                <div class="slds-float--right el-actions">\n                    <button class="slds-button slds-button--icon" ng-click="deleteFacet(facet.objectFacetObj, facet.facetObj.Name, $event)">\n                        <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                        <span class="slds-assistive-text">Delete Facet</span>\n                    </button>\n                </div>\n            </div>\n            <div class="section" ng-repeat="section in facet.sections">\n                <div class="section-name slds-clearfix" ng-click="editItem(section.facetSectionObj, \'ObjectSection__c\', $event)">\n                    <div class="slds-float--left">\n                        {{section.sectionObj.Name}} <span class="slds-badge slds-theme--section">SECTION</span> <span ng-if="section.hasCustomView" class="slds-badge slds-theme--customview">CUSTOM VIEW</span>\n                    </div>\n                    <div class="slds-float--right el-actions">\n                        <button class="slds-button slds-button--icon" ng-click="deleteSection(section.facetSectionObj, section.sectionObj.Name, $event)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Delete Section</span>\n                        </button>\n                    </div>\n                </div>\n                <ul class="slds-list--vertical slds-has-dividers--bottom section-elements" ng-if="!section.hasCustomView">\n                    <li class="slds-list__item section-element" ng-repeat="element in section.sectionElements" ng-click="editItem(element, \'ObjectElement__c\', $event)">\n                        <div class="slds-clearfix">\n                            <div class="slds-float--left">{{element.Name}}</div>\n                            <div class="slds-float--right el-actions">\n                                <button class="slds-button slds-button--icon" ng-click="deleteItem(element, element.Name, $event)">\n                                    <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                                    <span class="slds-assistive-text">Delete Section Element</span>\n                                </button>\n                            </div>\n                        </div>\n                    </li>\n                    <li>\n                        <button class="slds-button slds-button--small slds-button--neutral" ng-click="addSectionElement(section.facetSectionObj.Id)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'new\'"></slds-button-svg-icon> Add Section Element\n                        </button>\n                    </li>\n                </ul>\n            </div>\n            <button class="slds-button slds-button--small slds-button--neutral" ng-click="addSection(facet.objectFacetObj.Id)">\n                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'new\'"></slds-button-svg-icon> Add Section\n            </button>\n        </div>\n        <button class="slds-button slds-button--small slds-button--neutral" ng-click="addFacet()">\n            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'new\'"></slds-button-svg-icon> Add Facet\n        </button>\n    </div>\n</div>'),$templateCache.put("LookupReferenceModal.tpl.html",'<div class="slds-modal slds-fade-in-open lookup-reference-modal" aria-hidden="false" role="dialog">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n            <h3 class="slds-text-heading--medium">{{modalTitle}}</h3>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium">\n            <div ng-init="getFieldSetsByName()">\n                <form class="slds-form--inline slds-m-top--medium search-form">\n                    <div class="slds-form-element">\n                        <label class="slds-form-element__label slds-assistive-text" for="text-input-01">Search</label>\n                        <div class="slds-form-element__control">\n                            <input type="text" id="searchTerm" ng-model="searchCfg.searchTerm" class="slds-input slds-input--small search-object" placeholder="Search.." />\n                        </div>\n                    </div>\n                    <div class="slds-form-element">\n                        <button class="slds-button slds-button--icon-border" ng-click="searchReferenceField(1)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'search\'"></slds-button-svg-icon>\n                        </button>\n                    </div>\n                </form>\n                <div class="search-results" ng-if="searchResults !== null">\n                    <h3 class="slds-text-heading--small slds-m-top--large slds-m-bottom--small">Search Results:</h3>\n                    <p ng-if="searchResults.length === 0">There are no results.</p>\n                    <div ng-if="searchResults.length > 0">\n                        <div class="slds-clearfix slds-m-bottom--x-small slds-form--inline">\n                            <div class="slds-float--left results-count">Showing {{searchCfg.fromCount}} - {{searchCfg.toCount}} of {{searchCfg.totalCount}} results</div>\n                            <div class="slds-float--right results-page slds-form-element">\n                                <button class="slds-button slds-button--icon" ng-disabled="(searchCfg.currentPage <= 1)" ng-click="searchReferenceField(searchCfg.previousPage)">\n                                    <slds-button-svg-icon sprite="\'utility\'" size="\'medium\'" icon="\'left\'"></slds-button-svg-icon>\n                                    <span class="slds-assistive-text">Previous Page</span>\n                                </button>&nbsp;\n                                <span>\n                                    Page\n                                    <span class="slds-form-element__control">\n                                        <input type="number" ng-model="searchCfg.currentPage" ng-change="searchReferenceField()" class="slds-input page-num" />\n                                    </span>\n                                    of {{searchCfg.totalPages}}\n                                </span>\n                                <button class="slds-button slds-button--icon" ng-disabled="(searchCfg.currentPage >= searchCfg.totalPages)" ng-click="searchReferenceField(searchCfg.nextPage)">\n                                    <slds-button-svg-icon sprite="\'utility\'" size="\'medium\'" icon="\'right\'"></slds-button-svg-icon>\n                                    <span class="slds-assistive-text">Next Page</span>\n                                </button>\n                            </div>\n                        </div>\n                        <div class="slds-scrollable--x">\n                            <table class="slds-table slds-table--bordered items">\n                                <thead>\n                                    <tr class="slds-text-heading--label">\n                                        <th class="actions"><div class="slds-truncate">&nbsp;</div></th>\n                                        <th ng-repeat="field in fieldSet">\n                                            <div class="slds-truncate">{{field.fieldLabel}}</div>\n                                        </th>\n                                    </tr>\n                                </thead>\n                                <tbody>\n                                    <tr ng-repeat="item in searchResults | orderBy:\'Name\'" ng-click="launchTab(item, $event)">\n                                        <td class="actions">\n                                            <a href="javascript:void(0)" ng-click="setReferenceField(item.Id, item[searchCfg.nameField])">Select</a>\n                                        </td>\n                                        <td ng-repeat="field in fieldSet">\n                                            <vloc-obj-field display-mode="\'view\'" parent-obj="item" field-name="field.fieldPath" field-info="field" obj-picklists=""></vloc-obj-field>\n                                        </td>\n                                    </tr>\n                                </tbody>\n                            </table>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="$hide()">{{cancelActionLbl}}</button>\n        </div>\n    </div>\n</div>'),
$templateCache.put("ObjectField.tpl.html",'<div class="vloc-obj-field">\n    <!-- VIEW FIELD -->\n    <span ng-if="displayMode === \'view\'" ng-switch="fieldInfo.type">\n        <span ng-switch-when="BOOLEAN">\n            <label class="slds-checkbox">\n                <input type="checkbox" name="{{formElementName}}" id="{{formElementName}}" ng-model="parentObj[fieldName]" disabled="disabled" />\n                <span class="slds-checkbox--faux"></span>\n                <span class="slds-assistive-text">{{fieldInfo.label}}</span>\n            </label>\n        </span>\n        <span ng-switch-when="DATE">\n            {{parentObj[fieldName] | date:\'mediumDate\'}}\n        </span>\n        <span ng-switch-when="DATETIME">\n            {{parentObj[fieldName] | date:\'mediumDate\'}}\n        </span>\n        <span ng-switch-when="REFERENCE">\n            {{lookupObj.selectedItem}}\n        </span>\n        <span ng-switch-default="default">\n            {{parentObj[fieldName]}}\n        </span>\n    </span>\n    <!-- EDIT FIELD -->\n    <span ng-if="displayMode === \'edit\'" ng-switch="fieldInfo.type">\n        <span ng-switch-when="BOOLEAN">\n            <label class="slds-checkbox">\n                <input type="checkbox" name="{{formElementName}}" id="{{formElementName}}" ng-model="parentObj[fieldName]" ng-disabled="fieldProp.disabled" ng-required="fieldProp.required" />\n                <span class="slds-checkbox--faux"></span>\n                <span class="slds-assistive-text">{{fieldInfo.label}}</span>\n            </label>\n        </span>\n        <span ng-switch-when="DATE">\n            <input type="text" class="slds-input"\n                name="{{formElementName}}"\n                id="{{formElementName}}"\n                ng-model="parentObj[fieldName]"\n                ng-disabled="fieldProp.disabled" \n                ng-required="fieldProp.required" \n                slds-date-picker="true"\n                data-date-format="shortDate"\n                data-date-type="number"\n                data-trigger="focus" />\n        </span>\n        <span ng-switch-when="DATETIME">\n            <input type="text" class="slds-input slds-size--1-of-2 vloc-dt-date"\n                name="{{formElementName}}"\n                id="{{formElementName}}"\n                ng-model="parentObj[fieldName]"\n                ng-disabled="fieldProp.disabled" \n                ng-required="fieldProp.required" \n                slds-date-picker="true"\n                data-date-format="shortDate"\n                data-date-type="number"\n                data-trigger="focus" />\n            <input type="text" class="slds-input slds-size--1-of-2 vloc-dt-time"\n                name="{{formElementName}}"\n                id="{{formElementName}}"\n                ng-model="parentObj[fieldName]"\n                ng-disabled="fieldProp.disabled" \n                ng-required="fieldProp.required" \n                slds-time-picker="true"\n                data-time-format="mediumTime"\n                data-time-type="number" />\n        </span>\n        <span ng-switch-when="PICKLIST">\n            <select name="{{formElementName}}" id="{{formElementName}}" ng-model="parentObj[fieldName]" ng-disabled="fieldProp.disabled" ng-required="fieldProp.required" class="slds-select">\n                <option ng-repeat="o in objPicklists" value="{{o.value}}" ng-selected="o.value === selectedPicklistItem">{{o.label}}</option>\n            </select>\n        </span>\n        <span ng-switch-when="OTPICKLIST">\n            <select name="{{formElementName}}" id="{{formElementName}}" ng-model="parentObj[\'objectTypeId\']" ng-disabled="fieldProp.disabled" ng-required="fieldProp.required" class="slds-select">\n                <option ng-repeat="o in objPicklists" value="{{o.value}}" ng-selected="o.value === selectedPicklistItem">{{o.label}}</option>\n            </select>\n        </span>\n        <span ng-switch-when="MULTIPICKLIST">\n            <select name="{{formElementName}}" id="{{formElementName}}" multiple="multiple" ng-model="selectedMPItems" ng-change="setMultiPicklistValues(selectedMPItems)" ng-disabled="fieldProp.disabled" ng-required="fieldProp.required" class="slds-select">\n                <option ng-repeat="o in objPicklists" value="{{o.value}}" ng-selected="o.selected">{{o.label}}</option>\n            </select>\n        </span>\n        <span ng-switch-when="TEXTAREA">\n            <textarea name="{{formElementName}}" id="{{formElementName}}" ng-model="parentObj[fieldName]" ng-disabled="fieldProp.disabled" ng-required="fieldProp.required" class="slds-textarea"></textarea>\n        </span>\n        <span ng-switch-when="REFERENCE">\n            <div class="slds-input-has-icon slds-input-has-icon--right">\n                <slds-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'search\'" extra-classes="\'slds-input__icon slds-icon-text-default\'" ng-click="searchReferenceField($event)"></slds-svg-icon>\n                <input type="text" name="{{formElementName}}" id="{{formElementName}}" ng-model="lookupObj.selectedItem" ng-disabled="fieldProp.disabled" ng-required="fieldProp.required" class="slds-input" />\n            </div>\n        </span>\n        <span ng-switch-when="CURRENCY">\n            <input type="number" name="{{formElementName}}" id="{{formElementName}}" ng-model="parentObj[fieldName]" ng-disabled="fieldProp.disabled" ng-required="fieldProp.required"  class="slds-input" />\n        </span>\n        <span ng-switch-when="DOUBLE">\n            <input type="number" name="{{formElementName}}" id="{{formElementName}}" ng-model="parentObj[fieldName]" ng-disabled="fieldProp.disabled" ng-required="fieldProp.required"  class="slds-input" />\n        </span>\n        <span ng-switch-default="default">\n            <input type="text" name="{{formElementName}}" id="{{formElementName}}" ng-model="parentObj[fieldName]" ng-disabled="fieldProp.disabled" ng-required="fieldProp.required"  class="slds-input" />\n        </span>\n    </span>\n</div>'),$templateCache.put("ObjectPricing.tpl.html",'<div class="vloc-object-pricing">\n    <div class="object-pricing-section">\n        <h3 class="slds-text-heading--small">Charges</h3>\n        <div class="vloc-section-actions">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="newItem(ChargeOT)">New</button>\n        </div>\n        <div class="slds-scrollable--x">\n            <div class="pricelist-entries tbl-charges">\n                <div class="pricelist-item-row">\n                    <div class="pricelist-item slds-text-heading--label" ng-if="pricingMode === \'PRICELIST\'">Product</div>\n                    <div class="pricelist-item slds-text-heading--label" ng-if="pricingMode !== \'PRICELIST\'">Price List</div>\n                    <div class="pricelist-pricevariables">\n                        <div class="pricevariable-row">\n                            <div class="price-variable slds-text-heading--label">Pricing Variable</div>\n                            <div class="pricevariable-entries">\n                                <div class="pricevariable-entry">\n                                    <div class="ple-details slds-text-heading--label">Pricing Element</div>\n                                    <div class="ple-effectivity slds-text-heading--label">Effectivity</div>\n                                    <div class="ple-actions"></div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n                <div ng-repeat="item in chargeItems" class="pricelist-item-row">\n                    <div class="pricelist-item" ng-if="pricingMode === \'PRICELIST\'">{{item.product.Name}}</div>\n                    <div class="pricelist-item" ng-if="pricingMode !== \'PRICELIST\'">{{item.priceList.Name}}</div>\n                    <div class="pricelist-pricevariables">\n                        <div ng-repeat="pv in item.priceVars" ng-if="pv.hasCharges" class="pricevariable-row">\n                            <div class="price-variable">{{pv.priceVar.Name}}</div>\n                            <div class="pricevariable-entries">\n                                <div ng-repeat="charge in pv.charges" class="pricevariable-entry">\n                                    <div class="ple-details">\n                                        <vloc-price-list-entry-info-card price-list-entry="charge"></vloc-price-list-entry-info-card>\n                                    </div>\n                                    <div class="ple-effectivity slds-text-body--small">\n                                        <span ng-if="charge[nsp+\'EffectiveFromDate__c\']"><b>Start:</b> <vloc-obj-field ng-init="f1 = (nsp + \'EffectiveFromDate__c\')" display-mode="\'view\'" parent-obj="charge" field-name="f1" field-info="objectFields[f1]" obj-picklists=""></vloc-obj-field></span><br>\n                                        <span ng-if="charge[nsp+\'EffectiveUntilDate__c\']"><b>End:</b> <vloc-obj-field ng-init="f2 = (nsp + \'EffectiveUntilDate__c\')" display-mode="\'view\'" parent-obj="charge" field-name="f2" field-info="objectFields[f2]" obj-picklists=""></vloc-obj-field></span>\n                                    </div>\n                                    <div class="ple-actions">\n                                        <button class="slds-button slds-button--icon" ng-click="selectItem(charge, ChargeOT)">\n                                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'edit\'"></slds-button-svg-icon>\n                                            <span class="slds-assistive-text">Edit</span>\n                                        </button>\n                                        <button class="slds-button slds-button--icon" ng-click="deleteItem(charge, $event)">\n                                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                                            <span class="slds-assistive-text">Delete</span>\n                                        </button>\n                                    </div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <div ng-if="chargeItems.length === 0" class="pricelist-entries-none tbl-charges">\n                There are no charges.\n            </div>\n        </div>\n    </div>\n    <div class="object-pricing-section" ng-if="pricingMode !== \'PRICELIST\'">\n        <h3 class="slds-text-heading--small">Usages</h3>\n        <div class="vloc-section-actions">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="newItem(UsageOT)">New</button>\n        </div>\n        <div class="slds-scrollable--x">\n            <div class="pricelist-entries tbl-usages">\n                <div class="pricelist-item-row">\n                    <div class="pricelist-item slds-text-heading--label">Price List</div>\n                    <div class="pricelist-pricevariables">\n                        <div class="pricevariable-row">\n                            <div class="price-variable slds-text-heading--label">Pricing Variable</div>\n                            <div class="pricevariable-entries">\n                                <div class="pricevariable-entry">\n                                    <div class="ple-details slds-text-heading--label">Pricing Element</div>\n                                    <div class="ple-effectivity slds-text-heading--label">Effectivity</div>\n                                    <div class="ple-actions"></div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n                <div ng-repeat="item in usageItems" class="pricelist-item-row">\n                    <div class="pricelist-item">{{item.priceList.Name}}</div>\n                    <div class="pricelist-pricevariables">\n                        <div ng-repeat="pv in item.priceVars" ng-if="pv.hasUsages" class="pricevariable-row">\n                            <div class="price-variable">{{pv.priceVar.Name}}</div>\n                            <div class="pricevariable-entries">\n                                <div ng-repeat="usage in pv.usages" class="pricevariable-entry">\n                                    <div class="ple-details">\n                                        <vloc-price-list-entry-info-card price-list-entry="usage"></vloc-price-list-entry-info-card>\n                                    </div>\n                                    <div class="ple-effectivity slds-text-body--small">\n                                        <span ng-if="usage[nsp+\'EffectiveFromDate__c\']"><b>Start:</b> <vloc-obj-field ng-init="f1 = (nsp + \'EffectiveFromDate__c\')" display-mode="\'view\'" parent-obj="usage" field-name="f1" field-info="objectFields[f1]" obj-picklists=""></vloc-obj-field></span><br>\n                                        <span ng-if="usage[nsp+\'EffectiveUntilDate__c\']"><b>End:</b> <vloc-obj-field ng-init="f2 = (nsp + \'EffectiveUntilDate__c\')" display-mode="\'view\'" parent-obj="usage" field-name="f2" field-info="objectFields[f2]" obj-picklists=""></vloc-obj-field></span>\n                                    </div>\n                                    <div class="ple-actions">\n                                        <button class="slds-button slds-button--icon" ng-click="selectItem(usage, UsageOT)">\n                                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'edit\'"></slds-button-svg-icon>\n                                            <span class="slds-assistive-text">Edit</span>\n                                        </button>\n                                        <button class="slds-button slds-button--icon" ng-click="deleteItem(usage, $event)">\n                                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                                            <span class="slds-assistive-text">Delete</span>\n                                        </button>\n                                    </div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <div ng-if="usageItems.length === 0" class="pricelist-entries-none tbl-usages">\n                There are no usages.\n            </div>\n        </div>\n    </div>\n    <div class="object-pricing-section" ng-if="pricingMode !== \'PRICELIST\'">\n        <h3 class="slds-text-heading--small">Charge Adjustments</h3>\n        <div class="slds-scrollable--x">\n            <div class="pricelist-entries tbl-charge-discounts">\n                <div class="pricelist-item-row">\n                    <div class="pricelist-item slds-text-heading--label">Price List</div>\n                    <div class="pricelist-pricevariables">\n                        <div class="pricevariable-row">\n                            <div class="price-variable slds-text-heading--label">Pricing Variable</div>\n                            <div class="pricevariable-entries">\n                                <div class="pricevariable-entry">\n                                    <div class="ple-details slds-text-heading--label">Pricing Element</div>\n                                    <div class="ple-effectivity slds-text-heading--label">Effectivity</div>\n                                    <div class="ple-promotion slds-text-heading--label">Promotion</div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n                <div ng-repeat="item in chargeDiscountItems" class="pricelist-item-row">\n                    <div class="pricelist-item">{{item.priceList.Name}}</div>\n                    <div class="pricelist-pricevariables">\n                        <div ng-repeat="pv in item.priceVars" ng-if="pv.hasChargeDiscounts" class="pricevariable-row">\n                            <div class="price-variable">{{pv.priceVar.Name}}</div>\n                            <div class="pricevariable-entries">\n                                <div ng-repeat="adjustment in pv.adjustments" class="pricevariable-entry">\n                                    <div class="ple-details">\n                                        <vloc-price-list-entry-info-card price-list-entry="adjustment"></vloc-price-list-entry-info-card>\n                                    </div>\n                                    <div class="ple-effectivity slds-text-body--small">\n                                        <span ng-if="adjustment[nsp+\'EffectiveFromDate__c\']"><b>Start:</b> <vloc-obj-field ng-init="f1 = (nsp + \'EffectiveFromDate__c\')" display-mode="\'view\'" parent-obj="adjustment" field-name="f1" field-info="objectFields[f1]" obj-picklists=""></vloc-obj-field></span><br>\n                                        <span ng-if="adjustment[nsp+\'EffectiveUntilDate__c\']"><b>End:</b> <vloc-obj-field ng-init="f2 = (nsp + \'EffectiveUntilDate__c\')" display-mode="\'view\'" parent-obj="adjustment" field-name="f2" field-info="objectFields[f2]" obj-picklists=""></vloc-obj-field></span>\n                                    </div>\n                                    <div class="ple-promotion">{{adjustment[nsp+\'PromotionId__r\'].Name}}</div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <div ng-if="chargeDiscountItems.length === 0" class="pricelist-entries-none tbl-charge-discounts">\n                There are no charge adjustments.\n            </div>\n        </div>\n    </div>\n    <div class="object-pricing-section" ng-if="(pricingMode !== \'PRICELIST\')">\n        <h3 class="slds-text-heading--small">Charge Overrides</h3>\n        <div class="slds-scrollable--x">\n            <div class="pricelist-entries tbl-charge-overrides">\n                <div class="pricelist-item-row">\n                    <div class="pricelist-item slds-text-heading--label">Price List</div>\n                    <div class="pricelist-pricevariables">\n                        <div class="pricevariable-row">\n                            <div class="price-variable slds-text-heading--label">Pricing Variable</div>\n                            <div class="pricevariable-entries">\n                                <div class="pricevariable-entry">\n                                    <div class="ple-details slds-text-heading--label">Pricing Element</div>\n                                    <div class="ple-effectivity slds-text-heading--label">Effectivity</div>\n                                    <div class="ple-promotion slds-text-heading--label">Promotion</div>\n                                    <div class="ple-offer slds-text-heading--label">Offer</div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n                <div ng-repeat="item in chargeOverrideItems" class="pricelist-item-row">\n                    <div class="pricelist-item">{{item.priceList.Name}}</div>\n                    <div class="pricelist-pricevariables">\n                        <div ng-repeat="pv in item.priceVars" ng-if="pv.hasChargeOverrides" class="pricevariable-row">\n                            <div class="price-variable">{{pv.priceVar.Name}}</div>\n                            <div class="pricevariable-entries">\n                                <div ng-repeat="override in pv.overrides" class="pricevariable-entry">\n                                    <div class="ple-details">\n                                        <vloc-price-list-entry-info-card price-list-entry="override"></vloc-price-list-entry-info-card>\n                                    </div>\n                                    <div class="ple-effectivity slds-text-body--small">\n                                        <span ng-if="override[nsp+\'EffectiveFromDate__c\']"><b>Start:</b> <vloc-obj-field ng-init="f1 = (nsp + \'EffectiveFromDate__c\')" display-mode="\'view\'" parent-obj="override" field-name="f1" field-info="objectFields[f1]" obj-picklists=""></vloc-obj-field></span><br>\n                                        <span ng-if="override[nsp+\'EffectiveUntilDate__c\']"><b>End:</b> <vloc-obj-field ng-init="f2 = (nsp + \'EffectiveUntilDate__c\')" display-mode="\'view\'" parent-obj="override" field-name="f2" field-info="objectFields[f2]" obj-picklists=""></vloc-obj-field></span>\n                                    </div>\n                                    <div class="ple-promotion">{{override[nsp+\'PromotionId__r\'].Name}}</div>\n                                    <div class="ple-offer">{{override[nsp+\'OfferId__r\'].Name}}</div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <div ng-if="chargeOverrideItems.length === 0" class="pricelist-entries-none tbl-charge-overrides">\n                There are no charge overrides.\n            </div>\n        </div>\n    </div>\n</div>'),$templateCache.put("ObjectPricingElement.tpl.html",'<div class="vloc-object-pricing-element">\n    <div ng-class="{\'pe-section\': true, \'pe-section-active\': (currentStep === 1)}">\n        <h3 class="slds-text-heading--small">Price Variable</h3>\n        <div class="slds-form--horizontal">\n            <div class="slds-form-element" ng-init="f1 = (nsp + \'ChargeType__c\')">\n                <label class="slds-form-element__label" for="{{objectFieldsPV[f1].label}}">{{objectFieldsPV[f1].label}}</label>\n                <div class="slds-form-element__control">\n                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editPV" field-name="f1" field-info="objectFieldsPV[f1]" obj-picklists="chargeTypePicklist"></vloc-obj-field>\n                </div>\n            </div>\n            <div class="slds-form-element" ng-if="editPV[nsp+\'ChargeType__c\'] === \'Recurring\'" ng-init="f2 = (nsp + \'RecurringFrequency__c\')">\n                <label class="slds-form-element__label" for="{{objectFieldsPV[f2].label}}">{{objectFieldsPV[f2].label}}</label>\n                <div class="slds-form-element__control">\n                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editPV" field-name="f2" field-info="objectFieldsPV[f2]" obj-picklists="objectPicklistsPV[f2.toLowerCase()]"></vloc-obj-field>\n                </div>\n            </div>\n            <div class="slds-form-element" ng-if="editPV[nsp+\'ChargeType__c\'] !== \'Usage\'" ng-init="f3 = (nsp + \'SubType__c\')">\n                <label class="slds-form-element__label" for="{{objectFieldsPV[f3].label}}">{{objectFieldsPV[f3].label}}</label>\n                <div class="slds-form-element__control">\n                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editPV" field-name="f3" field-info="objectFieldsPV[f3]" obj-picklists="objectPicklistsPV[f3.toLowerCase()]"></vloc-obj-field>\n                </div>\n            </div>\n            <div class="slds-form-element" ng-init="f4 = (nsp + \'Type__c\')">\n                <label class="slds-form-element__label" for="{{objectFieldsPV[f4].label}}">{{objectFieldsPV[f4].label}}</label>\n                <div class="slds-form-element__control">\n                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editPV" field-name="f4" field-info="objectFieldsPV[f4]" obj-picklists="objectPicklistsPV[f4.toLowerCase()]"></vloc-obj-field>\n                </div>\n            </div>\n            <div class="slds-form-element">\n                <div class="slds-form-element__control">\n                    <button type="button" class="slds-button slds-button--neutral" ng-click="searchPriceVariables($event)">Search</button>\n                </div>\n            </div>\n        </div>\n        <div ng-if="showPVList" class="slds-m-top--small">\n            <span>Select a Pricing Variable:</span>\n            <ul class="slds-has-block-links--space slds-has-list-interactions pv-list">\n                <li ng-repeat="pv in pricingVariableList" ng-class="{\'slds-is-selected\': (pv.Id === selectedPV.Id)}"><a href="javascript:void(0);" ng-click="selectPricingVariable(pv)">{{pv.Name}}</a></li>\n            </ul>\n        </div>\n        <div ng-if="selectedPV" class="slds-m-top--small">\n            <span><b>Selected Pricing Variable:</b> {{selectedPV.Name}}</span>\n        </div>\n    </div>\n    <div ng-class="{\'pe-section\': true, \'pe-section-active\': (currentStep === 2)}">\n        <h3 class="slds-text-heading--small">General Properties</h3>\n        <div class="slds-form--horizontal">\n            <div class="slds-form-element" ng-repeat="fieldName in step2Fields">\n                <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">{{objectFields[fieldName].label}}</label>\n                <div class="slds-form-element__control">\n                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="fieldName" field-info="objectFields[fieldName]" obj-picklists="objectPicklists[fieldName.toLowerCase()]"></vloc-obj-field>\n                </div>\n            </div>\n        </div>\n    </div>\n    <div ng-class="{\'pe-section\': true, \'pe-section-active\': (currentStep === 3)}">\n        <h3 class="slds-text-heading--small">Value</h3>\n        <div class="slds-form--horizontal">\n            <div class="slds-form-element" ng-init="f5 = (nsp + \'CalculationType__c\')">\n                <label class="slds-form-element__label" for="{{objectFields[f5].label}}">{{objectFields[f5].label}}</label>\n                <div class="slds-form-element__control">\n                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f5" field-info="objectFields[f5]" obj-picklists="objectPicklists[f5.toLowerCase()]"></vloc-obj-field>\n                </div>\n            </div>\n            <div ng-if="editItem[nsp+\'CalculationType__c\'] === \'Simple\'">\n                <div ng-if="selectedPV[nsp+\'ChargeType__c\'] !== \'Usage\'">\n                    <div class="slds-form-element" ng-if="selectedPV[nsp+\'ChargeType__c\'] !== \'Adjustment\'" ng-init="f6 = (nsp + \'Amount__c\')">\n                        <label class="slds-form-element__label" for="{{objectFields[f6].label}}">Charge</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f6" field-info="objectFields[f6]" obj-picklists="objectPicklists[f6.toLowerCase()]"></vloc-obj-field>\n                            <span>&nbsp;{{currencySymbol}}</span>\n                            <span ng-if="selectedPV[nsp+\'ChargeType__c\'] === \'Recurring\'">&nbsp;{{selectedPV[nsp+\'RecurringFrequency__c\']}}</span>\n                        </div>\n                    </div>\n                    <div class="slds-form-element" ng-if="selectedPV[nsp+\'ChargeType__c\'] === \'Adjustment\'" ng-init="f7 = (nsp + \'AdjustmentMethod__c\')">\n                        <label class="slds-form-element__label" for="{{objectFieldsPV[f7].label}}">{{objectFieldsPV[f7].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'view\'" parent-obj="selectedPV" field-name="f7" field-info="objectFieldsPV[f7]" obj-picklists="objectPicklistsPV[f7.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                    </div>\n                    <div class="slds-form-element" ng-if="selectedPV[nsp+\'ChargeType__c\'] === \'Adjustment\'" ng-init="f8 = (nsp + \'AdjustmentValue__c\')">\n                        <label class="slds-form-element__label" for="{{objectFields[f8].label}}">{{objectFields[f8].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f8" field-info="objectFields[f8]" obj-picklists="objectPicklists[f8.toLowerCase()]"></vloc-obj-field>\n                            <span ng-if="selectedPV[nsp+\'AdjustmentMethod__c\'] === \'Absolute\'">&nbsp;{{currencySymbol}}</span>\n                            <span ng-if="selectedPV[nsp+\'AdjustmentMethod__c\'] === \'Percent\'">&nbsp;%</span>\n                        </div>\n                    </div>\n                </div>\n                <div ng-if="selectedPV[nsp+\'ChargeType__c\'] === \'Usage\'">\n                    <div class="slds-form-element" ng-init="f9 = (nsp + \'PerUsageAmount__c\'); f10 = (nsp + \'PerUsageUnitOfMeasure__c\')">\n                        <label class="slds-form-element__label" for="{{objectFields[f9].label}}">Usage</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f9" field-info="objectFields[f9]" obj-picklists="objectPicklists[f9.toLowerCase()]"></vloc-obj-field>&nbsp;\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f10" field-info="objectFields[f10]" obj-picklists="objectPicklists[f10.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                    </div>\n                    <div class="slds-form-element" ng-init="f6 = (nsp + \'Amount__c\')">\n                        <label class="slds-form-element__label" for="{{objectFields[f6].label}}">Charge</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f6" field-info="objectFields[f6]" obj-picklists="objectPicklists[f6.toLowerCase()]"></vloc-obj-field>\n                            <span>&nbsp;{{currencySymbol}}</span>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <div ng-if="editItem[nsp+\'CalculationType__c\'] === \'Matrix-Based\'">\n                <div class="slds-form-element" ng-init="f11 = (nsp + \'PricingMatrixId__c\')">\n                    <label class="slds-form-element__label" for="{{objectFieldsPV[f11].label}}">{{objectFieldsPV[f11].label}}</label>\n                    <div class="slds-form-element__control">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f11" field-info="objectFields[f11]" obj-picklists="objectPicklists[f11.toLowerCase()]"></vloc-obj-field>\n                        <span ng-if="editItem[nsp+\'PricingMatrixId__c\']">\n                            <button class="slds-button slds-button--icon" ng-click="gotoSFObject(editItem[nsp+\'PricingMatrixId__c\'])">\n                                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'link\'"></slds-button-svg-icon>\n                                <span class="slds-assistive-text">Link</span>\n                            </button>\n                        </span>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n    <div ng-class="{\'pe-section\': true, \'pe-section-active\': (currentStep === 4)}">\n        <h3 class="slds-text-heading--small">Effectivity</h3>\n        <div class="slds-form--horizontal">\n            <div class="slds-form-element" ng-repeat="fieldName in step4Fields">\n                <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">{{objectFields[fieldName].label}}</label>\n                <div class="slds-form-element__control">\n                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="fieldName" field-info="objectFields[fieldName]" obj-picklists="objectPicklists[fieldName.toLowerCase()]"></vloc-obj-field>\n                </div>\n            </div>\n        </div>\n    </div>\n    <div class="slds-form-element__row form-buttons slds-text-align--right">\n        <button type="button" class="slds-button slds-button--brand" ng-if="mode === \'new\'" ng-click="createItem($event)">Save</button>\n        <button type="button" class="slds-button slds-button--brand" ng-if="mode === \'edit\'" ng-click="saveItem($event)">Save</button>\n    </div>\n</div>'),
$templateCache.put("ObjectPricingElements.tpl.html",'<div class="vloc-object-pricing-elements">\n    <div class="object-pricing-section">\n        <h3 class="slds-text-heading--small">Charges</h3>\n        <div class="vloc-section-actions">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="newItem(ChargeOT)">New</button>\n        </div>\n        <div class="slds-scrollable--x">\n            <table class="slds-table slds-table--bordered items">\n                <thead>\n                    <tr class="slds-text-heading--label">\n                        <th class="actions"><div class="slds-truncate">&nbsp;</div></th>\n                        <th><div class="slds-truncate">Name</div></th>\n                        <th><div class="slds-truncate">Code</div></th>\n                        <th><div class="slds-truncate">Pricing Variable</div></th>\n                        <th><div class="slds-truncate">Amount</div></th>\n                    </tr>\n                </thead>\n                <tbody>\n                    <tr ng-if="chargeList.length === 0"><td colspan="5">There are no charges.</td></tr>\n                    <tr ng-repeat="item in chargeList" ng-click="editItem(item, ChargeOT, $event)">\n                        <td class="actions">\n                            <button class="slds-button slds-button--icon" ng-click="editItem(item, ChargeOT, $event)">\n                                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'edit\'"></slds-button-svg-icon>\n                                <span class="slds-assistive-text">Edit</span>\n                            </button>\n                            <button class="slds-button slds-button--icon" ng-click="deleteItem(item, $event)">\n                                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                                <span class="slds-assistive-text">Delete</span>\n                            </button>\n                        </td>\n                        <td>{{item.Name}}</td>\n                        <td>{{item[nsp+\'Code__c\']}}</td>\n                        <td>{{item[nsp+\'PricingVariableId__r\'].Name}}</td>\n                        <td>{{item[nsp+\'Amount__c\']}}</td>\n                    </tr>\n                </tbody>\n            </table>\n        </div>\n    </div>\n    <div class="object-pricing-section">\n        <h3 class="slds-text-heading--small">Usages</h3>\n        <div class="vloc-section-actions">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="newItem(UsageOT)">New</button>\n        </div>\n        <div class="slds-scrollable--x">\n            <table class="slds-table slds-table--bordered items">\n                <thead>\n                    <tr class="slds-text-heading--label">\n                        <th class="actions"><div class="slds-truncate">&nbsp;</div></th>\n                        <th><div class="slds-truncate">Name</div></th>\n                        <th><div class="slds-truncate">Code</div></th>\n                        <th><div class="slds-truncate">Pricing Variable</div></th>\n                        <th><div class="slds-truncate">Amount</div></th>\n                    </tr>\n                </thead>\n                <tbody>\n                    <tr ng-if="usageList.length === 0"><td colspan="5">There are no usages.</td></tr>\n                    <tr ng-repeat="item in usageList" ng-click="editItem(item, UsageOT, $event)">\n                        <td class="actions">\n                            <button class="slds-button slds-button--icon" ng-click="editItem(item, UsageOT, $event)">\n                                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'edit\'"></slds-button-svg-icon>\n                                <span class="slds-assistive-text">Edit</span>\n                            </button>\n                            <button class="slds-button slds-button--icon" ng-click="deleteItem(item, $event)">\n                                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                                <span class="slds-assistive-text">Delete</span>\n                            </button>\n                        </td>\n                        <td>{{item.Name}}</td>\n                        <td>{{item[nsp+\'Code__c\']}}</td>\n                        <td>{{item[nsp+\'PricingVariableId__r\'].Name}}</td>\n                        <td>{{item[nsp+\'Amount__c\']}}</td>\n                    </tr>\n                </tbody>\n            </table>\n        </div>\n    </div>\n    <div class="object-pricing-section">\n        <h3 class="slds-text-heading--small">Adjustments</h3>\n        <div class="vloc-section-actions">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="newItem(DiscountOT)">New</button>\n        </div>\n        <div class="slds-scrollable--x">\n            <table class="slds-table slds-table--bordered items">\n                <thead>\n                    <tr class="slds-text-heading--label">\n                        <th class="actions"><div class="slds-truncate"></div></th>\n                        <th><div class="slds-truncate">Name</div></th>\n                        <th><div class="slds-truncate">Code</div></th>\n                        <th><div class="slds-truncate">Pricing Variable</div></th>\n                        <th><div class="slds-truncate">Amount</div></th>\n                    </tr>\n                </thead>\n                <tbody>\n                    <tr ng-if="discountList.length === 0"><td colspan="5">There are no adjustments.</td></tr>\n                    <tr ng-repeat="item in discountList" ng-click="editItem(item, DiscountOT, $event)">\n                        <td class="actions">\n                            <button class="slds-button slds-button--icon" ng-click="editItem(item, DiscountOT, $event)">\n                                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'edit\'"></slds-button-svg-icon>\n                                <span class="slds-assistive-text">Edit</span>\n                            </button>\n                            <button class="slds-button slds-button--icon" ng-click="deleteItem(item, $event)">\n                                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                                <span class="slds-assistive-text">Delete</span>\n                            </button>\n                        </td>\n                        <td>{{item.Name}}</td>\n                        <td>{{item[nsp+\'Code__c\']}}</td>\n                        <td>{{item[nsp+\'PricingVariableId__r\'].Name}}</td>\n                        <td>{{item[nsp+\'AdjustmentValue__c\']}}</td>\n                    </tr>\n                </tbody>\n            </table>\n        </div>\n    </div>\n</div>'),$templateCache.put("ObjectType.tpl.html",'<div class="vloc-object-type">\n    <div ng-repeat="facet in facets">\n        <h2 class="slds-text-heading--small" ng-if="facets.length > 1">{{facet.facetObj.Name}}</h2>\n        <section class="vloc-section" ng-repeat="section in facet.sections">\n            <h3 class="slds-text-heading--label">{{section.sectionObj.Name}}</h3>\n            <div class="vloc-section-body">\n                <div ng-if="!section.hasCustomView" class="slds-form--horizontal">\n                    <div class="slds-form-element" ng-repeat="sectionEl in section.sectionElements">\n                        <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">{{sectionEl.Name}}</label>\n                        <div class="slds-form-element__control" ng-init="fieldName = sectionEl[nsp+\'FieldApiName__c\']; fieldName = (fieldName.endsWith(\'__c\') ? nsp+fieldName : fieldName);">\n                            <div ng-switch="sectionEl[nsp+\'Type__c\']">\n                                <div ng-switch-when="Field">\n                                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="fieldName" field-info="objectFields[fieldName]" obj-picklists="objectPicklists[fieldName.toLowerCase()]"></vloc-obj-field>\n                                </div>\n                                <div ng-switch-when="Attribute">\n                                    Attribute!\n                                </div>\n                                <div ng-switch-when="Custom View">\n                                    Something is wrong!\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </section>\n        <div class="slds-form-element__row form-buttons slds-text-align--right">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="closeDetails()">Cancel</button>\n            <button type="button" class="slds-button slds-button--brand" ng-if="item.Id === undefined" ng-click="createItem($event)">Save</button>\n            <button type="button" class="slds-button slds-button--brand" ng-if="item.Id !== undefined" ng-click="saveItem($event)">Save</button>\n        </div>\n    </div>\n</div>'),$templateCache.put("ObjectTypes.tpl.html",'<div class="vloc-object-types">\n    <h3 class="slds-text-heading--small">Object Types</h3>\n    <div class="vloc-section-actions">\n        <button type="button" class="slds-button slds-button--neutral" ng-click="newItem()">New Object Type</button>\n    </div>\n    <div class="slds-scrollable--x">\n        <table class="slds-table slds-table--bordered items">\n            <thead>\n                <tr class="slds-text-heading--label">\n                    <th class="actions"><div class="slds-truncate">&nbsp;</div></th>\n                    <th ng-repeat="field in fieldSet">\n                        <div class="slds-truncate">{{objectFields[field.fieldPath].label}}</div>\n                    </th>\n                </tr>\n            </thead>\n            <tbody>\n                <tr ng-class="{\'slds-is-selected\': (item.Id === selectedItem.Id)}" ng-repeat="item in items" ng-click="launchTab(item)">\n                    <td class="actions">\n                        <button class="slds-button slds-button--icon" ng-click="editItem(item, $event)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'edit\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Edit</span>\n                        </button>\n                        <button class="slds-button slds-button--icon" ng-click="deleteItem(item, $event)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Delete</span>\n                        </button>\n                    </td>\n                    <td ng-repeat="field in fieldSet">\n                        <vloc-obj-field display-mode="\'view\'" parent-obj="item" field-name="field.fieldPath" field-info="objectFields[field.fieldPath]" obj-picklists=""></vloc-obj-field>\n                    </td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n\n</div>'),$templateCache.put("OfferPricingComponent.tpl.html",'<div class="vloc-offer-pricing-component vloc-override">\n    <div ng-repeat="facet in facets">\n        <div ng-if="overrideMode" class="slds-m-top--small slds-m-bottom--medium">\n            <div class="slds-text-align--right">\n                <button type="button" ng-if="!hasOverride" class="slds-button slds-button--neutral" ng-click="createOverride()">Create Override</button>\n                <button type="button" ng-if="hasOverride" class="slds-button slds-button--neutral" ng-click="deleteOverride()">Delete Override</button>\n            </div>\n            <div class="override-form override-form-hd" ng-if="hasOverride">\n                <div class="override-form-lbl-override"></div>\n                <div class="override-form-element-override">Original Values</div>\n                <div class="override-form-element-override">Overridden Values</div>\n            </div>\n        </div>\n        <section class="vloc-section" ng-repeat="section in facet.sections">\n            <h3 class="slds-text-heading--label">{{section.sectionObj.Name}}</h3>\n            <div class="vloc-section-body">\n                <div class="override-form" ng-repeat="sectionEl in section.sectionElements">\n                    <label ng-class="{\'override-form-lbl-override\': overrideMode, \'override-form-lbl\': !overrideMode}" for="{{objectFields[fieldName].label}}">{{sectionEl.Name}}</label>\n                    <div ng-class="{\'override-form-element-override\': overrideMode, \'override-form-element\': !overrideMode}" ng-init="fieldName = sectionEl[nsp+\'FieldApiName__c\']; fieldName = (fieldName.endsWith(\'__c\') ? nsp+fieldName : fieldName);">\n                        <vloc-obj-field display-mode="objDisplayMode" parent-obj="editItem" field-name="fieldName" field-info="objectFields[fieldName]" obj-picklists="objectPicklists[fieldName.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-if="hasOverride" ng-class="{\'override-form-element-override\': overrideMode, \'override-form-element\': !overrideMode}" ng-init="fieldName = sectionEl[nsp+\'FieldApiName__c\']; fieldName = (fieldName.endsWith(\'__c\') ? nsp+fieldName : fieldName);">\n                        <vloc-obj-field display-mode="\'edit\'" parent-obj="overrideObj" field-name="fieldName" field-info="objectFields[fieldName]" obj-picklists="objectPicklists[fieldName.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                </div>\n            </div>\n        </section>\n        <div class="slds-form-element__row form-buttons slds-text-align--right" ng-if="mode !== \'view\'">\n            <button type="button" class="slds-button slds-button--brand" ng-if="(mode === \'edit\' && editItem.Id === undefined)" ng-click="createItem($event)">Save</button>\n            <button type="button" class="slds-button slds-button--brand" ng-if="(mode === \'edit\' && editItem.Id !== undefined)" ng-click="saveItem($event)">Save</button>\n            <button type="button" class="slds-button slds-button--brand" ng-if="(mode === \'override\')" ng-click="saveOverride($event)">Save</button>\n        </div>\n    </div>\n</div>'),$templateCache.put("PreviewItemModal.tpl.html",'<div class="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n            <h3 class="slds-text-heading--medium">{{title}}</h3>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium">\n            <div class="slds-text-align--center">\n                <img ng-src="{{itemUrl}}"/>\n            </div>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="$hide()">OK</button>\n        </div>\n    </div>\n</div>'),$templateCache.put("PriceListEntry.tpl.html",'<div class="vloc-price-list-entry">\n    <div class="slds-tabs--default">\n        <ul class="slds-tabs--default__nav" role="tablist">\n            <li ng-repeat="tab in tabs" class="vloc-right-pane-tab" ng-class="{\'slds-tabs--default__item slds-text-heading--label\': true, \'slds-active\': tab.active}" title="{{tab.title}}" role="presentation">\n                <a class="slds-tabs--default__link vloc-right-pane-tab" href="#" ng-click="setActiveTab($index)" role="tab" tabindex="{{(tab.active ? 0 : -1)}}" aria-selected="true" aria-controls="tab-default-{{$index}}" id="tab-default-{{$index}}__item">{{tab.title}}</a>\n            </li>\n        </ul>\n        <div id="tab-default-0" ng-class="{\'slds-tabs--default__content\': true, \'slds-show\': (activeIdx === 0), \'slds-hide\': (activeIdx !== 0)}" role="tabpanel" aria-labelledby="tab-default-0__item">\n            <div ng-class="{\'pe-section\': true, \'pe-section-active\': (currentStep === 1)}">\n                <h3 class="slds-text-heading--small">General Properties</h3>\n                <div class="slds-form--horizontal">\n                    <div class="slds-form-element" ng-if="pricingMode === \'PRICELIST\'" ng-init="f5 = (nsp + \'ProductId__c\')">\n                        <label class="slds-form-element__label" for="{{objectFields[f5].label}}">{{objectFields[f5].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f5" field-info="objectFields[f5]" obj-picklists="objectPicklistsPV[f5.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                    </div>\n                    <div class="slds-form-element" ng-if="pricingMode !== \'PRICELIST\'" ng-init="f5 = (nsp + \'PriceListId__c\')">\n                        <label class="slds-form-element__label" for="{{objectFields[f5].label}}">{{objectFields[f5].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f5" field-info="objectFields[f5]" obj-picklists="objectPicklistsPV[f5.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                    </div>\n                    <div class="slds-form-element" ng-init="f12 = (nsp + \'DisplayText__c\')">\n                        <label class="slds-form-element__label" for="{{objectFields[f12].label}}">{{objectFields[f12].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f12" field-info="objectFields[f12]" obj-picklists="objectPicklistsPV[f12.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <div ng-class="{\'pe-section\': true, \'pe-section-active\': (currentStep === 2)}">\n                <h3 class="slds-text-heading--small">Price Variable</h3>\n                <div class="slds-form--horizontal">\n                    <div class="slds-form-element" ng-init="f1 = (nsp + \'ChargeType__c\')">\n                        <label class="slds-form-element__label" for="{{objectFieldsPV[f1].label}}">{{objectFieldsPV[f1].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editPV" field-name="f1" field-info="objectFieldsPV[f1]" obj-picklists="chargeTypePicklist"></vloc-obj-field>\n                        </div>\n                    </div>\n                    <div class="slds-form-element" ng-if="editPV[nsp+\'ChargeType__c\'] === \'Recurring\'" ng-init="f2 = (nsp + \'RecurringFrequency__c\')">\n                        <label class="slds-form-element__label" for="{{objectFieldsPV[f2].label}}">{{objectFieldsPV[f2].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editPV" field-name="f2" field-info="objectFieldsPV[f2]" obj-picklists="objectPicklistsPV[f2.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                    </div>\n                    <div class="slds-form-element" ng-if="editPV[nsp+\'ChargeType__c\'] !== \'Usage\'" ng-init="f3 = (nsp + \'SubType__c\')">\n                        <label class="slds-form-element__label" for="{{objectFieldsPV[f3].label}}">{{objectFieldsPV[f3].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editPV" field-name="f3" field-info="objectFieldsPV[f3]" obj-picklists="objectPicklistsPV[f3.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                    </div>\n                    <div class="slds-form-element" ng-init="f4 = (nsp + \'Type__c\')">\n                        <label class="slds-form-element__label" for="{{objectFieldsPV[f4].label}}">{{objectFieldsPV[f4].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editPV" field-name="f4" field-info="objectFieldsPV[f4]" obj-picklists="objectPicklistsPV[f4.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                    </div>\n                    <div class="slds-form-element">\n                        <div class="slds-form-element__control">\n                            <button type="button" class="slds-button slds-button--neutral" ng-click="searchPriceVariables($event)">Search</button>\n                        </div>\n                    </div>\n                </div>\n                <div ng-if="showPVList" class="slds-m-top--small">\n                    <span>Select a Pricing Variable:</span>\n                    <ul class="slds-has-block-links--space slds-has-list-interactions pv-list">\n                        <li ng-repeat="pv in pricingVariableList" ng-class="{\'slds-is-selected\': (pv.Id === selectedPV.Id)}"><a href="javascript:void(0);" ng-click="selectPricingVariable(pv)">{{pv.Name}}</a></li>\n                    </ul>\n                </div>\n                <div ng-if="selectedPV" class="slds-m-top--small">\n                    <span><b>Selected Pricing Variable:</b> {{selectedPV.Name}}</span>\n                </div>\n            </div>\n            <div ng-class="{\'pe-section\': true, \'pe-section-active\': (currentStep === 3)}">\n                <h3 class="slds-text-heading--small">Pricing Element</h3>\n                <div ng-if="showPEList" class="slds-m-top--small">\n                    <span>Select a Pricing Element:</span>\n                    <ul class="slds-has-block-links--space slds-has-list-interactions pe-list">\n                        <li ng-repeat="pe in pricingElementList" ng-class="{\'slds-is-selected\': (pe.Id === selectedPE.Id)}"><a href="javascript:void(0);" ng-click="selectPricingElement(pe)">{{pe.Name}}</a></li>\n                    </ul>\n                </div>\n                <div ng-if="!showPEList && !selectedPE" class="slds-m-top--small">\n                    Please select a pricing variable above.\n                </div>\n                <div ng-if="selectedPE" class="slds-m-top--small">\n                    <span><b>Selected Pricing Element:</b> {{selectedPE.Name}}</span>\n                </div>\n            </div>\n            <div ng-class="{\'pe-section\': true, \'pe-section-active\': (currentStep === 6)}">\n                <h3 class="slds-text-heading--small">Time Plan/Policy</h3>\n                <div class="slds-form--horizontal">\n                    <div class="slds-form-element" ng-init="f9 = (nsp + \'TimePlanId__c\')">\n                        <label class="slds-form-element__label" for="{{objectFields[f9].label}}">{{objectFields[f9].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f9" field-info="objectFields[f9]" obj-picklists="objectPicklists[f9.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                    </div>\n                    <div class="slds-form-element" ng-init="f10 = (nsp + \'TimePolicyId__c\')">\n                        <label class="slds-form-element__label" for="{{objectFields[f10].label}}">{{objectFields[f10].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f10" field-info="objectFields[f10]" obj-picklists="objectPicklists[f10.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <div ng-class="{\'pe-section\': true, \'pe-section-active\': (currentStep === 4)}">\n                <h3 class="slds-text-heading--small">Rules</h3>\n                <div class="slds-form--horizontal">\n                    <div class="slds-form-element" ng-init="f11 = (nsp + \'RulesDescription__c\')">\n                        <label class="slds-form-element__label" for="{{objectFields[f11].label}}">{{objectFields[f11].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f11" field-info="objectFields[f11]" obj-picklists="objectPicklists[f11.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <div ng-class="{\'pe-section\': true, \'pe-section-active\': (currentStep === 5)}">\n                <h3 class="slds-text-heading--small">Effectivity</h3>\n                <div class="slds-form--horizontal">\n                    <div class="slds-form-element" ng-init="f6 = (nsp + \'EffectiveFromDate__c\')">\n                        <label class="slds-form-element__label" for="{{objectFields[f6].label}}">{{objectFields[f6].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f6" field-info="objectFields[f6]" obj-picklists="objectPicklists[f6.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                    </div>\n                    <div class="slds-form-element" ng-init="f7 = (nsp + \'EffectiveUntilDate__c\')">\n                        <label class="slds-form-element__label" for="{{objectFields[f7].label}}">{{objectFields[f7].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f7" field-info="objectFields[f7]" obj-picklists="objectPicklists[f7.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                    </div>\n                    <div class="slds-form-element" ng-init="f8 = (nsp + \'IsActive__c\')">\n                        <label class="slds-form-element__label" for="{{objectFields[f8].label}}">{{objectFields[f8].label}}</label>\n                        <div class="slds-form-element__control">\n                            <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="f8" field-info="objectFields[f8]" obj-picklists="objectPicklists[f8.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <div class="slds-form-element__row form-buttons slds-text-align--right">\n                <button type="button" class="slds-button slds-button--neutral" ng-click="closeDetails()">Cancel</button>\n                <button type="button" class="slds-button slds-button--brand" ng-if="priceListEntryItem === null" ng-click="createItem($event)">Save</button>\n                <button type="button" class="slds-button slds-button--brand" ng-if="priceListEntryItem !== null" ng-click="saveItem($event)">Save</button>\n            </div>\n        </div>\n        <div id="tab-default-1" ng-class="{\'slds-tabs--default__content\': true, \'slds-show\': (activeIdx === 1), \'slds-hide\': (activeIdx !== 1)}" role="tabpanel" aria-labelledby="tab-default-1__item">\n            <vloc-context-rules custom-view-attrs="contextRuleAttrs"></vloc-context-rules>\n        </div>\n    </div>\n</div>'),$templateCache.put("PriceListEntryInfoCard.tpl.html",'<div class="slds-card slds-card--narrow vloc-ple-info-card">\n    <div class="slds-card__body">\n        <div class="slds-card__body--inner">\n            <div class="slds-tile">\n                <div class="slds-tile__detail slds-text-body--small" ng-if="pricingElement[nsp+\'CalculationType__c\'] === \'Simple\'">\n                    <div ng-if="pricingVariable[nsp+\'ChargeType__c\'] === \'Usage\'">\n                        <dl class="slds-list--horizontal slds-wrap">\n                            <dt class="slds-item--label slds-text-color--weak" title="Name">Name:</dt>\n                            <dd class="slds-item--detail">{{pricingElement.Name}}</dd>\n                            <dt class="slds-item--label slds-text-color--weak" title="Calculation Type">Calculation Type:</dt>\n                            <dd class="slds-item--detail">{{pricingElement[nsp+\'CalculationType__c\']}}</dd>\n                            <dt class="slds-item--label slds-text-color--weak" title="Usage">Usage:</dt>\n                            <dd class="slds-item--detail">{{pricingElement[nsp+\'PerUsageAmount__c\']}} {{pricingElement[nsp+\'PerUsageUnitOfMeasure__c\']}}</dd>\n                            <dt class="slds-item--label slds-text-color--weak" title="Charge">Charge:</dt>\n                            <dd class="slds-item--detail">{{pricingElement[nsp+\'Amount__c\']}} {{currencySymbol}}</dd>\n                        </dl>\n                    </div>\n                    <div ng-if="pricingVariable[nsp+\'ChargeType__c\'] !== \'Usage\'">\n                        <dl class="slds-list--horizontal slds-wrap">\n                            <dt class="slds-item--label slds-text-color--weak" title="Name">Name:</dt>\n                            <dd class="slds-item--detail">{{pricingElement.Name}}</dd>\n                            <dt class="slds-item--label slds-text-color--weak" title="Calculation Type">Calculation Type:</dt>\n                            <dd class="slds-item--detail">{{pricingElement[nsp+\'CalculationType__c\']}}</dd>\n                            <dt ng-if="pricingVariable[nsp+\'ChargeType__c\'] !== \'Adjustment\'" class="slds-item--label slds-text-color--weak" title="Charge">Charge:</dt>\n                            <dd ng-if="pricingVariable[nsp+\'ChargeType__c\'] !== \'Adjustment\'" class="slds-item--detail">{{pricingElement[nsp+\'Amount__c\']}} {{currencySymbol}} <span ng-if="pricingVariable[nsp+\'ChargeType__c\'] === \'Recurring\'">&nbsp;{{pricingVariable[nsp+\'RecurringFrequency__c\']}}</span></dd>\n                            <dt ng-if="pricingVariable[nsp+\'ChargeType__c\'] === \'Adjustment\'" class="slds-item--label slds-text-color--weak" title="Adjustment Method">Adjustment Method:</dt>\n                            <dd ng-if="pricingVariable[nsp+\'ChargeType__c\'] === \'Adjustment\'" class="slds-item--detail">{{pricingVariable[nsp+\'AdjustmentMethod__c\']}}</dd>\n                            <dt ng-if="pricingVariable[nsp+\'ChargeType__c\'] === \'Adjustment\'" class="slds-item--label slds-text-color--weak" title="Adjustment">Adjustment:</dt>\n                            <dd ng-if="pricingVariable[nsp+\'ChargeType__c\'] === \'Adjustment\'" class="slds-item--detail">{{pricingElement[nsp+\'AdjustmentValue__c\']}} <span ng-if="pricingVariable[nsp+\'AdjustmentMethod__c\'] === \'Absolute\'">{{currencySymbol}}</span><span ng-if="pricingVariable[nsp+\'AdjustmentMethod__c\'] === \'Percent\'">%</span></dd>\n                        </dl>\n                    </div>\n                </div>\n                <div class="slds-tile__detail slds-text-body--small" ng-if="pricingElement[nsp+\'CalculationType__c\'] === \'Matrix-Based\'">\n                    <dl class="slds-list--horizontal slds-wrap">\n                        <dt class="slds-item--label slds-text-color--weak" title="Name">Name:</dt>\n                        <dd class="slds-item--detail">{{pricingElement.Name}}</dd>\n                        <dt class="slds-item--label slds-text-color--weak" title="Calculation Type">Calculation Type:</dt>\n                        <dd class="slds-item--detail">{{pricingElement[nsp+\'CalculationType__c\']}}</dd>\n                        <dt class="slds-item--label slds-text-color--weak" title="Matrix">Matrix:</dt>\n                        <dd class="slds-item--detail">{{pricingElement[nsp+\'PricingMatrixId__c\']}}</dd>\n                    </dl>\n                </div>\n            </div>\n        </div>\n    </div>\n</div>'),
$templateCache.put("PricingElementModal.tpl.html",'<div class="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n            <button class="slds-button slds-modal__close slds-button--icon-inverse" title="Close" ng-click="hideAction()">\n                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'close\'"></slds-button-svg-icon>\n                <span class="slds-assistive-text">Close</span>\n            </button>\n            <h3 class="slds-text-heading--medium">{{contextRuleTitle}}</h3>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium">\n            <div>\n                <vloc-price-list-entry object-id="objectId" price-list-entry-item="priceListEntryItem" pricing-element-object-type="pricingElementObjectType" parent-item="product" pricing-mode="pricingMode" mode="\'modal\'" root-product-id="rootProductId" promotion-id="promotionId" is-adj="isAdj" is-override="isOverride"></vloc-price-list-entry>\n            </div>\n        </div>\n    </div>\n</div>'),$templateCache.put("ProdCardinality.tpl.html",'<div class="vloc-prod-cardinality vloc-override">\n    <div ng-if="parentOverrideMode" class="slds-m-top--small slds-m-bottom--medium">\n        <div class="slds-button-group override-actions" role="group">\n            <button type="button" ng-if="!hasOverride" class="slds-button slds-button--neutral" ng-click="createOverride()">Create Override</button>\n            <button type="button" ng-if="hasOverride" class="slds-button slds-button--neutral" ng-click="deleteOverride()">Delete Override</button>\n        </div>\n        <div class="override-form override-form-hd" ng-if="hasOverride">\n            <div class="override-form-lbl"></div>\n            <div class="override-form-element">Original Value</div>\n            <div class="override-form-element">Override Value</div>\n            <div class="override-form-element"></div>\n        </div>\n    </div>\n    <section class="vloc-section">\n        <h3 class="slds-text-heading--label">General Properties</h3>\n        <div class="vloc-section-body">\n            <div>\n                <div class="override-form" ng-init="(f1 = nsp+\'MinimumChildItemQuantity__c\')">\n                    <label class="override-form-lbl" for="{{objectFields[f1].label}}">{{objectFields[f1].label}}</label>\n                    <div ng-class="{\'override-form-element\': true}">\n                        <vloc-obj-field display-mode="(parentOverrideMode ? \'view\' : \'edit\')" parent-obj="editItem" field-name="f1" field-info="objectFields[f1]" obj-picklists="objectPicklists[f1.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': (!parentOverrideMode || !hasOverride)}">\n                        <vloc-obj-field ng-if="(overrideObj !== null)" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f1" field-info="objectFields[f1]" obj-picklists="objectPicklists[f1.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n                <div class="override-form" ng-init="(f2 = nsp+\'MaximumChildItemQuantity__c\')">\n                    <label class="override-form-lbl" for="{{objectFields[f2].label}}">{{objectFields[f2].label}}</label>\n                    <div ng-class="{\'override-form-element\': true}">\n                        <vloc-obj-field display-mode="(parentOverrideMode ? \'view\' : \'edit\')" parent-obj="editItem" field-name="f2" field-info="objectFields[f2]" obj-picklists="objectPicklists[f2.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': (!parentOverrideMode || !hasOverride)}">\n                        <vloc-obj-field ng-if="(overrideObj !== null)" display-mode="\'edit\'" parent-obj="overrideObj" field-name="f2" field-info="objectFields[f2]" obj-picklists="objectPicklists[f2.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n            </div>\n        </div>\n    </section>\n    <div class="slds-form-element__row form-buttons slds-text-align--right" ng-show="(objectFields !== undefined)">\n        <button type="button" class="slds-button slds-button--brand" ng-if="(parentOverrideMode && hasOverride)" ng-click="saveOverride($event)">Save</button>\n        <button type="button" class="slds-button slds-button--brand" ng-if="(!parentOverrideMode)" ng-click="saveItem($event)">Save</button>\n    </div>\n</div>'),$templateCache.put("ProdChildDetails.tpl.html",'<div class="vloc-product-child-details">\n    <div class="slds-clearfix slds-m-top--small">\n        <div class="slds-float--left">\n            <p class="slds-text-heading--medium slds-m-bottom--small object-name">{{prodChildItem.productName}}</p>\n        </div>\n        <div class="slds-float--right">\n            <div class="slds-form-element">\n                <label class="slds-checkbox--toggle slds-grid">\n                    <span class="slds-form-element__label slds-m-top--xx-small">Override Mode</span>\n                    <input type="checkbox" name="overridemode" ng-model="isInOverrideMode" aria-describedby="toggle-desc" />\n                    <span id="toggle-desc" class="slds-checkbox--faux_container" aria-live="assertive">\n                        <span class="slds-checkbox--faux"></span>\n                    </span>\n                </label>\n            </div>\n        </div>\n    </div>\n    <div class="slds-tabs--default">\n        <ul class="slds-tabs--default__nav" role="tablist">\n            <li ng-repeat="tab in tabs" class="vloc-right-pane-tab" ng-class="{\'slds-tabs--default__item slds-text-heading--label\': true, \'slds-active\': tab.active, \'slds-hide\': tab.hidden}" title="{{tab.title}}" role="presentation">\n                <a class="slds-tabs--default__link vloc-right-pane-tab" href="#" ng-click="setActiveTab($index)" role="tab" tabindex="{{(tab.active ? 0 : -1)}}" aria-selected="true" aria-controls="tab-default-{{$index}}" id="tab-default-{{$index}}__item">{{tab.title}}</a>\n            </li>\n        </ul>\n        <div id="tab-default-0" ng-class="{\'slds-tabs--default__content\': true, \'slds-show\': (activeIdx === 0), \'slds-hide\': (activeIdx !== 0)}" role="tabpanel" aria-labelledby="tab-default-0__item">\n            <vloc-prod-cardinality\n                parent-override-mode="isInOverrideMode"\n                parent-product-id="prodChildItem.productId"\n                root-product-id="rootProductId"\n                prod-obj="prodChildItem.productSO"\n                prod-child-item-obj="prodChildItem.cardinalitySO"\n                promotion-item="prodChildItem.promotionItemSO"></vloc-prod-cardinality>\n        </div>\n        <div id="tab-default-1" ng-class="{\'slds-tabs--default__content\': true, \'slds-show\': (activeIdx === 1), \'slds-hide\': (activeIdx !== 1)}" role="tabpanel" aria-labelledby="tab-default-1__item">\n            <vloc-prod-child-item\n                mode="\'edit\'"\n                parent-override-mode="isInOverrideMode"\n                parent-product-id="prodChildItem.productId"\n                root-product-id="rootProductId"\n                prod-obj="prodChildItem.productSO"\n                prod-child-item-obj="prodChildItem.pciSO"\n                promotion-item="prodChildItem.promotionItemSO"></vloc-prod-child-item>\n        </div>\n        <div id="tab-default-2" ng-class="{\'slds-tabs--default__content\': true, \'slds-show\': (activeIdx === 2), \'slds-hide\': (activeIdx !== 2)}" role="tabpanel" aria-labelledby="tab-default-2__item">\n            <vloc-product-attributes\n                parent-override-mode="isInOverrideMode"\n                product-id="prodChildItem.productId"\n                root-product-id="rootProductId"\n                prod-obj="prodChildItem.productSO"\n                prod-child-item-obj="prodChildItem.pciSO"\n                promotion-item="prodChildItem.promotionItemSO"></vloc-product-attributes>\n        </div>\n        <div id="tab-default-3" ng-class="{\'slds-tabs--default__content\': true, \'slds-show\': (activeIdx === 3), \'slds-hide\': (activeIdx !== 3)}" role="tabpanel" aria-labelledby="tab-default-3__item">\n            <vloc-product-pricing\n                mode="\'edit\'"\n                parent-override-mode="isInOverrideMode"\n                parent-product-id="prodChildItem.productId"\n                root-product-id="rootProductId"\n                product-id="prodChildItem.productId"\n                pricing-mode="pricingMode"\n                promotion-id="promotionId"\n                promotion-item="prodChildItem.promotionItemSO"\n                is-adj="isAdj"></vloc-product-pricing>\n        </div>\n    </div>\n</div>'),$templateCache.put("ProdChildItem.tpl.html",'<div class="vloc-prod-child-item vloc-override">\n    <div ng-if="parentOverrideMode" class="slds-m-top--small slds-m-bottom--medium">\n        <div class="slds-button-group override-actions" role="group">\n            <button type="button" ng-if="!hasOverride" class="slds-button slds-button--neutral" ng-click="createOverride()">Create Override</button>\n            <button type="button" ng-if="!hasOverride" class="slds-button slds-button--neutral" ng-click="excludeItem()">Exclude Item</button>\n            <button type="button" ng-if="hasOverride && !excludePCI" class="slds-button slds-button--neutral" ng-click="deleteOverride()">Delete Override</button>\n            <button type="button" ng-if="hasOverride && excludePCI" class="slds-button slds-button--neutral" ng-click="deleteOverride()">Include Item</button>\n        </div>\n        <div class="override-form override-form-hd" ng-if="hasOverride && !excludePCI">\n            <div class="override-form-lbl"></div>\n            <div class="override-form-element">Original Value</div>\n            <div class="override-form-element">Override Value</div>\n            <div class="override-form-element"></div>\n        </div>\n    </div>\n    <section class="vloc-section" ng-repeat="section in facets[0].sections">\n        <h3 class="slds-text-heading--label">{{section.sectionObj.Name}}</h3>\n        <div class="vloc-section-body">\n            <div ng-if="!section.hasCustomView">\n                <div class="override-form" ng-init="(f1 = nsp+\'ParentProductId__c\')">\n                    <label class="override-form-lbl" for="{{objectFields[f1].label}}">{{objectFields[f1].label}}</label>\n                    <div ng-class="{\'override-form-element\': true}">\n                        <vloc-obj-field display-mode="\'view\'" parent-obj="editItem" field-name="f1" field-info="objectFields[f1]" obj-picklists="objectPicklists[f1.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': (!parentOverrideMode || !hasOverride || excludePCI)}">\n                        <vloc-obj-field ng-if="(overrideObj !== null)" display-mode="\'view\'" parent-obj="overrideObj" field-name="f1" field-info="objectFields[f1]" obj-picklists="objectPicklists[f1.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element"></div>\n                </div>\n                <div ng-repeat="sectionEl in section.sectionElements">\n                    <div class="override-form" ng-init="fieldName = sectionEl[nsp+\'FieldApiName__c\']; fieldName = (fieldName.endsWith(\'__c\') ? nsp+fieldName : fieldName);">\n                        <label class="override-form-lbl" for="{{objectFields[fieldName].label}}">{{objectFields[fieldName].label}}</label>\n                        <div ng-class="{\'override-form-element\': true}">\n                            <vloc-obj-field display-mode="(parentOverrideMode ? \'view\' : \'edit\')" parent-obj="editItem" field-name="fieldName" field-info="objectFields[fieldName]" obj-picklists="objectPicklists[fieldName.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                        <div ng-class="{\'override-form-element\': true, \'slds-hidden\': (!parentOverrideMode || !hasOverride || excludePCI)}">\n                            <vloc-obj-field ng-if="(overrideObj !== null)" display-mode="\'edit\'" parent-obj="overrideObj" field-name="fieldName" field-info="objectFields[fieldName]" obj-picklists="objectPicklists[fieldName.toLowerCase()]"></vloc-obj-field>\n                        </div>\n                        <div class="override-form-element"></div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </section>\n    <div class="slds-form-element__row form-buttons slds-text-align--right" ng-show="(objectFields !== undefined)">\n        <button type="button" class="slds-button slds-button--neutral" ng-if="mode === \'add\'" ng-click="closeDetails()">Cancel</button>\n        <button type="button" class="slds-button slds-button--brand" ng-if="mode === \'add\'" ng-click="createItem($event)">Save</button>\n        <button type="button" class="slds-button slds-button--brand" ng-if="(mode === \'edit\' && parentOverrideMode && hasOverride && !excludePCI)" ng-click="saveOverride($event)">Save</button>\n        <button type="button" class="slds-button slds-button--brand" ng-if="(mode === \'edit\' && !parentOverrideMode)" ng-click="saveItem($event)">Save</button>\n    </div>\n    <!-- <section class="vloc-section">\n        <h3 class="slds-text-heading--label">Context Rules</h3>\n        <div class="vloc-section-body">\n            <vloc-context-rules custom-view-attrs="customViewAttrs"></vloc-context-rules>\n        </div>\n    </section> -->\n</div>'),$templateCache.put("ProductAttributes.tpl.html",'<div class="vloc-product-attributes vloc-override">\n    <div ng-if="parentOverrideMode" class="slds-m-top--small slds-m-bottom--medium">\n        <div class="override-form override-form-hd">\n            <div class="override-form-lbl"></div>\n            <div class="override-form-element">Original Value</div>\n            <div class="override-form-element">Override Value</div>\n            <div class="override-form-element"></div>\n        </div>\n    </div>\n    <section class="vloc-section" ng-repeat="section in sections">\n        <h3 class="slds-text-heading--label">{{section.sectionObj.Name}}</h3>\n        <div class="vloc-section-body">\n            <div ng-repeat="sectionEl in section.sectionElements"  ng-init="fieldName = sectionEl[nsp+\'FieldApiName__c\']; fieldName = (fieldName.endsWith(\'__c\') ? nsp+fieldName : fieldName);">\n                <!-- <div class="override-form" ng-if="(sectionEl[nsp+\'Type__c\'] === \'Field\')">\n                    <label class="override-form-lbl" for="{{objectFields[fieldName].label}}">{{sectionEl.Name}}</label>\n                    <div ng-class="{\'override-form-element\': true}">\n                        <vloc-obj-field display-mode="\'view\'" parent-obj="editProduct" field-name="fieldName" field-info="objectFields[fieldName]" obj-picklists="objectPicklists[fieldName.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !parentOverrideMode}">\n                        <vloc-obj-field display-mode="\'view\'" parent-obj="editProduct" field-name="fieldName" field-info="objectFields[fieldName]" obj-picklists="objectPicklists[fieldName.toLowerCase()]"></vloc-obj-field>\n                    </div>\n                    <div class="override-form-element">&nbsp;</div>\n                </div> -->\n                <div class="override-form" ng-if="(sectionEl[nsp+\'Type__c\'] === \'Attribute\')" ng-init="attributeId = sectionEl[nsp+\'AttributeId__c\']">\n                    <label class="override-form-lbl" for="{{sectionEl.Name}}">{{sectionEl.Name}}</label>\n                    <div ng-class="{\'override-form-element\': true}">\n                        <vloc-attribute attribute-id="attributeId" object-id="productId" attr-map="attrMap" attr-obj="AttrObjMap[attributeId]" attr-assgn-obj="AttrAssgnObjMap[attributeId]" picklist-items="AttrPicklistMap[attributeId]" lookup-items="AttrLookupMap[attributeId]"></vloc-attribute>\n                    </div>\n                    <div ng-class="{\'override-form-element\': true, \'slds-hidden\': !parentOverrideMode}">\n                        <div ng-if="(parentOverrideMode && AttrOverrideAssgnObjMap[attributeId])">\n                            <vloc-attribute attribute-id="attributeId" object-id="productId" attr-map="attrOverrideMap" attr-obj="AttrObjMap[attributeId]" attr-assgn-obj="AttrOverrideAssgnObjMap[attributeId]" picklist-items="AttrOverridePicklistMap[attributeId]"></vloc-attribute>\n                        </div>\n                    </div>\n                    <div class="override-form-element">\n                        <div ng-if="(parentOverrideMode && !AttrOverrideAssgnObjMap[attributeId])">\n                            <a href="javascript:void(0)" ng-click="createOverride(attributeId)">Create Override</a>\n                        </div>\n                        <div ng-if="(parentOverrideMode && AttrOverrideAssgnObjMap[attributeId])">\n                            <a href="javascript:void(0)" ng-click="saveOverride(sectionEl[nsp+\'AttributeId__c\'])">Save</a>&nbsp;|&nbsp;\n                            <a href="javascript:void(0)" ng-click="deleteOverride(sectionEl[nsp+\'AttributeId__c\'])">Delete</a>&nbsp;|&nbsp;\n                            <a href="javascript:void(0)" ng-click="showAttributeMetadata(sectionEl[nsp+\'AttributeId__c\'])">Advanced</a>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </section>\n</div>'),$templateCache.put("ProductPricing.tpl.html",'<div class="vloc-product-pricing vloc-section">\n    <div class="object-pricing-section">\n        <h3 class="slds-text-heading--small">Charges</h3>\n        <div class="slds-scrollable--x">\n            <div class="pricelist-entries tbl-charges">\n                <div class="pricelist-item-row">\n                    <div class="pricelist-item slds-text-heading--label">Price List</div>\n                    <div class="pricelist-pricevariables">\n                        <div class="pricevariable-row">\n                            <div class="price-variable slds-text-heading--label">Pricing Variable</div>\n                            <div class="pricevariable-entries">\n                                <div class="pricevariable-entry">\n                                    <div class="ple-details slds-text-heading--label">Pricing Element</div>\n                                    <div class="ple-effectivity slds-text-heading--label">Effectivity</div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n                <div ng-repeat="item in chargeItems" class="pricelist-item-row">\n                    <div class="pricelist-item">{{item.priceList.Name}}</div>\n                    <div class="pricelist-pricevariables">\n                        <div ng-repeat="pv in item.priceVars" ng-if="pv.hasCharges" class="pricevariable-row">\n                            <div class="price-variable">{{pv.priceVar.Name}}</div>\n                            <div class="pricevariable-entries">\n                                <div ng-repeat="charge in pv.charges" class="pricevariable-entry">\n                                    <div class="ple-details">\n                                        <vloc-price-list-entry-info-card price-list-entry="charge"></vloc-price-list-entry-info-card>\n                                    </div>\n                                    <div class="ple-effectivity slds-text-body--small">\n                                        <span ng-if="charge[nsp+\'EffectiveFromDate__c\']"><b>Start:</b> <vloc-obj-field ng-init="f1 = (nsp + \'EffectiveFromDate__c\')" display-mode="\'view\'" parent-obj="charge" field-name="f1" field-info="objectFields[f1]" obj-picklists=""></vloc-obj-field></span><br>\n                                        <span ng-if="charge[nsp+\'EffectiveUntilDate__c\']"><b>End:</b> <vloc-obj-field ng-init="f2 = (nsp + \'EffectiveUntilDate__c\')" display-mode="\'view\'" parent-obj="charge" field-name="f2" field-info="objectFields[f2]" obj-picklists=""></vloc-obj-field></span>\n                                    </div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <div ng-if="chargeItems.length === 0" class="pricelist-entries-none tbl-charges">\n                There are no charges.\n            </div>\n        </div>\n    </div>\n    <div class="object-pricing-section">\n        <h3 class="slds-text-heading--small">Usages</h3>\n        <div class="slds-scrollable--x">\n            <div class="pricelist-entries tbl-usages">\n                <div class="pricelist-item-row">\n                    <div class="pricelist-item slds-text-heading--label">Price List</div>\n                    <div class="pricelist-pricevariables">\n                        <div class="pricevariable-row">\n                            <div class="price-variable slds-text-heading--label">Pricing Variable</div>\n                            <div class="pricevariable-entries">\n                                <div class="pricevariable-entry">\n                                    <div class="ple-details slds-text-heading--label">Pricing Element</div>\n                                    <div class="ple-effectivity slds-text-heading--label">Effectivity</div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n                <div ng-repeat="item in usageItems" class="pricelist-item-row">\n                    <div class="pricelist-item">{{item.priceList.Name}}</div>\n                    <div class="pricelist-pricevariables">\n                        <div ng-repeat="pv in item.priceVars" ng-if="pv.hasUsages" class="pricevariable-row">\n                            <div class="price-variable">{{pv.priceVar.Name}}</div>\n                            <div class="pricevariable-entries">\n                                <div ng-repeat="usage in pv.usages" class="pricevariable-entry">\n                                    <div class="ple-details">\n                                        <vloc-price-list-entry-info-card price-list-entry="usage"></vloc-price-list-entry-info-card>\n                                    </div>\n                                    <div class="ple-effectivity slds-text-body--small">\n                                        <span ng-if="usage[nsp+\'EffectiveFromDate__c\']"><b>Start:</b> <vloc-obj-field ng-init="f1 = (nsp + \'EffectiveFromDate__c\')" display-mode="\'view\'" parent-obj="usage" field-name="f1" field-info="objectFields[f1]" obj-picklists=""></vloc-obj-field></span><br>\n                                        <span ng-if="usage[nsp+\'EffectiveUntilDate__c\']"><b>End:</b> <vloc-obj-field ng-init="f2 = (nsp + \'EffectiveUntilDate__c\')" display-mode="\'view\'" parent-obj="usage" field-name="f2" field-info="objectFields[f2]" obj-picklists=""></vloc-obj-field></span>\n                                    </div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <div ng-if="usageItems.length === 0" class="pricelist-entries-none tbl-usages">\n                There are no usages.\n            </div>\n        </div>\n    </div>\n    <div class="object-pricing-section">\n        <h3 class="slds-text-heading--small">Charge Adjustments</h3>\n        <div class="vloc-section-actions">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="newDiscount(ChargeOT)">New</button>\n        </div>\n        <div class="slds-scrollable--x">\n            <div class="pricelist-entries tbl-charge-discounts">\n                <div class="pricelist-item-row">\n                    <div class="pricelist-item slds-text-heading--label">Price List</div>\n                    <div class="pricelist-pricevariables">\n                        <div class="pricevariable-row">\n                            <div class="price-variable slds-text-heading--label">Pricing Variable</div>\n                            <div class="pricevariable-entries">\n                                <div class="pricevariable-entry">\n                                    <div class="ple-details slds-text-heading--label">Pricing Element</div>\n                                    <div class="ple-effectivity slds-text-heading--label">Effectivity</div>\n                                    <div class="ple-actions"></div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n                <div ng-repeat="item in chargeDiscountItems" class="pricelist-item-row">\n                    <div class="pricelist-item">{{item.priceList.Name}}</div>\n                    <div class="pricelist-pricevariables">\n                        <div ng-repeat="pv in item.priceVars" ng-if="pv.hasChargeDiscounts" class="pricevariable-row">\n                            <div class="price-variable">{{pv.priceVar.Name}}</div>\n                            <div class="pricevariable-entries">\n                                <div ng-repeat="adjustment in pv.adjustments" class="pricevariable-entry">\n                                    <div class="ple-details">\n                                        <vloc-price-list-entry-info-card price-list-entry="adjustment"></vloc-price-list-entry-info-card>\n                                    </div>\n                                    <div class="ple-effectivity slds-text-body--small">\n                                        <span ng-if="adjustment[nsp+\'EffectiveFromDate__c\']"><b>Start:</b> <vloc-obj-field ng-init="f1 = (nsp + \'EffectiveFromDate__c\')" display-mode="\'view\'" parent-obj="adjustment" field-name="f1" field-info="objectFields[f1]" obj-picklists=""></vloc-obj-field></span><br>\n                                        <span ng-if="adjustment[nsp+\'EffectiveUntilDate__c\']"><b>End:</b> <vloc-obj-field ng-init="f2 = (nsp + \'EffectiveUntilDate__c\')" display-mode="\'view\'" parent-obj="adjustment" field-name="f2" field-info="objectFields[f2]" obj-picklists=""></vloc-obj-field></span>\n                                    </div>\n                                    <div class="ple-actions">\n                                        <button class="slds-button slds-button--icon" ng-click="selectItem(adjustment, ChargeOT, true, false)">\n                                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'edit\'"></slds-button-svg-icon>\n                                            <span class="slds-assistive-text">Edit</span>\n                                        </button>\n                                        <button class="slds-button slds-button--icon" ng-click="deleteItem(adjustment, $event)">\n                                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                                            <span class="slds-assistive-text">Delete</span>\n                                        </button>\n                                    </div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <div ng-if="chargeDiscountItems.length === 0" class="pricelist-entries-none tbl-charge-discounts">\n                There are no charge adjustments.\n            </div>\n        </div>\n    </div>\n    <div class="object-pricing-section">\n        <h3 class="slds-text-heading--small">Charge Overrides</h3>\n        <div class="vloc-section-actions">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="newOverride(ChargeOT)">New</button>\n        </div>\n        <div class="slds-scrollable--x">\n            <div class="pricelist-entries tbl-charge-overrides">\n                <div class="pricelist-item-row">\n                    <div class="pricelist-item slds-text-heading--label">Price List</div>\n                    <div class="pricelist-pricevariables">\n                        <div class="pricevariable-row">\n                            <div class="price-variable slds-text-heading--label">Pricing Variable</div>\n                            <div class="pricevariable-entries">\n                                <div class="pricevariable-entry">\n                                    <div class="ple-details slds-text-heading--label">Pricing Element</div>\n                                    <div class="ple-effectivity slds-text-heading--label">Effectivity</div>\n                                    <div class="ple-actions"></div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n                <div ng-repeat="item in chargeOverrideItems" class="pricelist-item-row">\n                    <div class="pricelist-item">{{item.priceList.Name}}</div>\n                    <div class="pricelist-pricevariables">\n                        <div ng-repeat="pv in item.priceVars" ng-if="pv.hasChargeOverrides" class="pricevariable-row">\n                            <div class="price-variable">{{pv.priceVar.Name}}</div>\n                            <div class="pricevariable-entries">\n                                <div ng-repeat="override in pv.overrides" class="pricevariable-entry">\n                                    <div class="ple-details">\n                                        <vloc-price-list-entry-info-card price-list-entry="override"></vloc-price-list-entry-info-card>\n                                    </div>\n                                    <div class="ple-effectivity slds-text-body--small">\n                                        <span ng-if="override[nsp+\'EffectiveFromDate__c\']"><b>Start:</b> <vloc-obj-field ng-init="f1 = (nsp + \'EffectiveFromDate__c\')" display-mode="\'view\'" parent-obj="override" field-name="f1" field-info="objectFields[f1]" obj-picklists=""></vloc-obj-field></span><br>\n                                        <span ng-if="override[nsp+\'EffectiveUntilDate__c\']"><b>End:</b> <vloc-obj-field ng-init="f2 = (nsp + \'EffectiveUntilDate__c\')" display-mode="\'view\'" parent-obj="override" field-name="f2" field-info="objectFields[f2]" obj-picklists=""></vloc-obj-field></span>\n                                    </div>\n                                    <div class="ple-actions">\n                                        <button class="slds-button slds-button--icon" ng-click="selectItem(override, ChargeOT, false, true)">\n                                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'edit\'"></slds-button-svg-icon>\n                                            <span class="slds-assistive-text">Edit</span>\n                                        </button>\n                                        <button class="slds-button slds-button--icon" ng-click="deleteItem(override, $event)">\n                                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                                            <span class="slds-assistive-text">Delete</span>\n                                        </button>\n                                    </div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <div ng-if="chargeOverrideItems.length === 0" class="pricelist-entries-none tbl-charge-overrides">\n                There are no charge overrides.\n            </div>\n        </div>\n    </div>\n</div>'),
$templateCache.put("StandalonePricingElements.tpl.html",'<div class="vloc-standalone-pricing-elements">\n    <vloc-object-pricing-elements mode="\'standalone\'" custom-view-attrs="customViewAttrs"></vloc-object-pricing-elements>\n</div>'),$templateCache.put("VlocAttribute.tpl.html",'<span class="vloc-attribute">\n    <span ng-switch="attrAssgnObj[nsp+\'ValueDataType__c\']">\n        <span ng-switch-when="Text">\n            <input type="text" name="{{formElementName}}" id="{{formElementName}}" ng-model="attrAssgnObj[nsp+\'Value__c\']" ng-disabled="attrAssgnObj[nsp+\'IsConfigurable__c\']" ng-required="attrAssgnObj[nsp+\'IsRequired__c\']" class="slds-input" />\n        </span>\n        <span ng-switch-when="Currency">\n            <input type="text" name="{{formElementName}}" id="{{formElementName}}" ng-model="attrAssgnObj[nsp+\'Value__c\']" ng-disabled="attrAssgnObj[nsp+\'IsConfigurable__c\']" ng-required="attrAssgnObj[nsp+\'IsRequired__c\']" class="slds-input" />\n        </span>\n        <span ng-switch-when="Percent">\n            <input type="text" name="{{formElementName}}" id="{{formElementName}}" ng-model="attrAssgnObj[nsp+\'Value__c\']" ng-disabled="attrAssgnObj[nsp+\'IsConfigurable__c\']" ng-required="attrAssgnObj[nsp+\'IsRequired__c\']" class="slds-input" />\n        </span>\n        <span ng-switch-when="Number">\n            <input type="text" name="{{formElementName}}" id="{{formElementName}}" ng-model="attrAssgnObj[nsp+\'Value__c\']" ng-disabled="attrAssgnObj[nsp+\'IsConfigurable__c\']" ng-required="attrAssgnObj[nsp+\'IsRequired__c\']" class="slds-input" />\n        </span>\n        <span ng-switch-when="Checkbox">\n            <label class="slds-checkbox">\n                <input type="checkbox" name="{{formElementName}}" id="{{formElementName}}" ng-model="attrAssgnObj[nsp+\'Value__c\']" ng-disabled="attrAssgnObj[nsp+\'IsConfigurable__c\']" ng-required="attrAssgnObj[nsp+\'IsRequired__c\']" />\n                <span class="slds-checkbox--faux"></span>\n                <span class="slds-assistive-text">{{attrAssgnObj[nsp+\'AttributeName__c\']}}</span>\n            </label>\n        </span>\n        <span ng-switch-when="Date">\n            <input type="text" class="slds-input"\n                name="{{formElementName}}" \n                id="{{formElementName}}"\n                ng-model="attrAssgnObj[nsp+\'Value__c\']"\n                ng-disabled="attrAssgnObj[nsp+\'IsConfigurable__c\']" \n                ng-required="attrAssgnObj[nsp+\'IsRequired__c\']" \n                slds-date-picker="true"\n                data-date-format="shortDate"\n                data-date-type="iso"\n                data-trigger="focus" />\n        </span>\n        <span ng-switch-when="Datetime">\n            <input type="text" class="slds-input slds-size--1-of-2 vloc-dt-date"\n                name="{{formElementName}}" \n                id="{{formElementName}}"\n                ng-model="attrAssgnObj[nsp+\'Value__c\']"\n                ng-disabled="attrAssgnObj[nsp+\'IsConfigurable__c\']" \n                ng-required="attrAssgnObj[nsp+\'IsRequired__c\']" \n                slds-date-picker="true"\n                data-date-format="shortDate"\n                data-date-type="iso"\n                data-trigger="focus" />\n            <input type="text" class="slds-input slds-size--1-of-2 vloc-dt-time"\n                name="{{formElementName}}" \n                id="{{formElementName}}"\n                ng-model="attrAssgnObj[nsp+\'Value__c\']"\n                ng-disabled="attrAssgnObj[nsp+\'IsConfigurable__c\']" \n                ng-required="attrAssgnObj[nsp+\'IsRequired__c\']" \n                slds-time-picker="true"\n                data-time-format="mediumTime"\n                data-time-type="iso" />\n        </span>\n        <span ng-switch-when="Picklist">\n            <select ng-if="attrAssgnObj[nsp+\'UIDisplayType__c\'] === \'Dropdown\'" name="{{formElementName}}" id="{{formElementName}}" ng-model="attrAssgnObj[nsp+\'Value__c\']" ng-disabled="attrAssgnObj[nsp+\'IsConfigurable__c\']" ng-required="attrAssgnObj[nsp+\'IsRequired__c\']" class="slds-select">\n                <option ng-repeat="o in picklistItems" value="{{o[nsp+\'Value__c\']}}" ng-selected="o.selected">{{o.Name}}</option>\n            </select>\n            <div ng-if="attrAssgnObj[nsp+\'UIDisplayType__c\'] === \'Radiobutton\'" class="slds-form-element__control">\n                <span class="slds-radio" ng-repeat="o in picklistItems">\n                    <input type="radio" id="radio-{{o.Id}}" name="attr_{{attributeId}}" ng-model="attrAssgnObj[nsp+\'Value__c\']" value="{{o[nsp+\'Value__c\']}}" ng-disabled="$parent.attrAssgnObj[nsp+\'IsConfigurable__c\']" ng-required="attrAssgnObj[nsp+\'IsRequired__c\']" />\n                    <label class="slds-radio__label" for="radio-{{o.Id}}">\n                        <span class="slds-radio--faux"></span>\n                        <span class="slds-form-element__label">{{o.Name}}</span>\n                    </label>\n                </span>\n            </div>\n        </span>\n        <span ng-switch-when="Multi Picklist">\n            <select ng-if="attrAssgnObj[nsp+\'UIDisplayType__c\'] === \'Dropdown\'" multiple="multiple" name="{{formElementName}}" id="{{formElementName}}" ng-model="selectedItems.mpd" ng-change="setMultiPicklistValues()" ng-disabled="attrAssgnObj[nsp+\'IsConfigurable__c\']" ng-required="attrAssgnObj[nsp+\'IsRequired__c\']" class="slds-select">\n                <option ng-repeat="o in picklistItems" value="{{o[nsp+\'Value__c\']}}" ng-selected="o.selected">{{o.Name}}</option>\n            </select>\n            <div ng-if="attrAssgnObj[nsp+\'UIDisplayType__c\'] === \'Checkbox\'" class="slds-form-element__control">\n                <span class="slds-checkbox" ng-repeat="o in picklistItems">\n                    <input type="checkbox" id="chk-{{o.Id}}" ng-model="o.selected" ng-click="setMultiPicklistValues()" ng-disabled="$parent.attrAssgnObj[nsp+\'IsConfigurable__c\']" ng-required="attrAssgnObj[nsp+\'IsRequired__c\']" />\n                    <label class="slds-checkbox__label" for="chk-{{o.Id}}">\n                        <span class="slds-checkbox--faux"></span>\n                        <span class="slds-form-element__label">{{o.Name}}</span>\n                    </label>\n                </span>\n            </div>\n        </span>\n        <span ng-switch-when="Lookup">\n            <div class="slds-input-has-icon slds-input-has-icon--right">\n                <slds-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'search\'" extra-classes="\'slds-input__icon slds-icon-text-default\'"></slds-svg-icon>\n                <input type="text" name="{{formElementName}}" id="{{formElementName}}" ng-model="lookupObj.selectedItem" ng-focus="lookupObj.showItems = true" ng-blur="lookupObj.showItems = false" ng-disabled="attrAssgnObj[nsp+\'IsConfigurable__c\']" ng-required="attrAssgnObj[nsp+\'IsRequired__c\']" class="slds-input" />\n            </div>\n            <div class="slds-lookup" ng-show="lookupObj.showItems">\n                <div class="slds-lookup__menu" role="listbox">\n                    <ul class="slds-lookup__list" role="presentation">\n                        <li class="slds-lookup__item" ng-repeat="luItem in lookupItems | orderBy:\'Name\' | filter:lookupObj.selectedItem">\n                            <a id="{{luItem.Id}}" href="#" role="option" ng-mousedown="selectLookupItem(luItem)">{{luItem.Name}}</a>\n                        </li>\n                    </ul>\n                </div>\n            </div>\n        </span>\n        <span ng-switch-default="default">\n            <input type="text" name="{{formElementName}}" id="{{formElementName}}" ng-model="attrAssgnObj[nsp+\'Value__c\']" ng-disabled="attrAssgnObj[nsp+\'IsConfigurable__c\']" ng-required="attrAssgnObj[nsp+\'IsRequired__c\']" class="slds-input" />\n        </span>\n    </span>\n</span>'),$templateCache.put("VlocFacetDetails.tpl.html",'<div ng-class="{\'facet-content-more-details\': true, \'maximized\': maximizeFacetDetail}" ng-show="showFacetDetail">\n\t<div class="more-details">\n\t\t<div class="slds-m-bottom--small">\n\t\t\t<div class="slds-button-group slds-grid slds-grid--align-end" role="group">\n\t\t\t\t<button class="slds-button slds-button--icon-border" title="Resize Pane" ng-click="(maximizeFacetDetail = !maximizeFacetDetail)">\n\t\t\t\t\t<slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'expand_alt\'"></slds-button-svg-icon>\n\t\t\t\t\t<span class="slds-assistive-text">Resize Pane</span>\n\t\t\t\t</button>\n\t\t\t\t<button class="slds-button slds-button--icon-border" title="Close Pane" ng-click="closeFacetDetails()">\n\t\t\t\t\t<slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'close\'"></slds-button-svg-icon>\n\t\t\t\t\t<span class="slds-assistive-text">Close Pane</span>\n\t\t\t\t</button>\n\t\t\t</div>\n\t\t</div>\n\t\t<div id="facet-detail-content"></div>\n\t</div>\n</div>'),$templateCache.put("VlocObjAttrsFields.tpl.html",'<div class="vloc-obj-attrs-fields">\n    <h3 class="slds-text-heading--small">Attributes and Fields</h3>\n    <div class="vloc-section-actions">\n        <div class="slds-button-group slds-float--right" role="group">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="unassignAttrsFields()" ng-disabled="selectedCount < 1">Unassign</button>\n            <button type="button" class="slds-button slds-button--neutral" ng-click="showAllAttrsFields()">Assign Attributes/Fields</button>\n        </div>\n    </div>\n    <div class="slds-scrollable--x">\n        <table class="slds-table slds-table--bordered items">\n            <thead>\n                <tr class="slds-text-heading--label">\n                    <th>\n                        <label class="slds-checkbox">\n                            <input type="checkbox" ng-model="allSelected" ng-change="selectAll()" />\n                            <span class="slds-checkbox--faux"></span>\n                            <span class="slds-assistive-text">Select All</span>\n                        </label>\n                    </th>\n                    <th>Attribute</th>\n                    <th>Field</th>\n                </tr>\n            </thead>\n            <tbody>\n                <tr ng-if="items.length === 0">\n                    <td colspan="3" class="slds-text-align--center">There are no attributes/fields assigned just yet. <a href="#" ng-click="showAllAttrsFields()">Assign some attributes/fields.</a></td>\n                </tr>\n                <tr ng-repeat="item in items">\n                    <td class="slds-cell-shrink">\n                        <label class="slds-checkbox">\n                            <input type="checkbox" ng-model="item.isSelected" ng-click="$event.stopPropagation()" ng-change="selectItem(item, $event)" />\n                            <span class="slds-checkbox--faux"></span>\n                            <span class="slds-assistive-text">Select Row</span>\n                        </label>\n                    </td>\n                    <td class="slds-truncate"><a href="#" ng-click="showAttributeMetadata(item.attrId)">{{item.attrName}}</a></td>\n                    <td class="slds-truncate"><a href="#" ng-click="showFieldMetadata(objectName, item.fieldName)">{{item.fieldLabel}}</a></td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n</div>'),$templateCache.put("VlocSections.tpl.html",'<div class="vloc-sections">\n\t<section ng-class="{\'vloc-section\': true, \'vloc-section-form\': !facet.hasSectionCustomView}" ng-repeat="section in facet.sections">\n\t\t<h3 class="slds-text-heading--small" ng-if="!facet.hasSectionCustomView">{{section.sectionObj.Name}}</h3>\n\t\t<div class="vloc-section-body">\n\t\t\t<div ng-if="section.hasCustomView" ng-init="customViewData = setupViewAttrs({\'section\': section})">\n\t\t\t\t<vloc-custom-view ng-if="customViewData"></vloc-custom-view>\n\t\t\t</div>\n\t\t\t<div ng-if="!section.hasCustomView" ng-repeat="sectionEl in section.sectionElements" ng-init="attrId = sectionEl[nsp+\'AttributeId__c\']; formElementName = \'fe_\'+sectionEl.Id;">\n\t\t\t\t<ng-form name="objFieldForm" class="vloc-section-element-form">\n\t\t\t\t\t<div ng-if="(sectionEl[nsp+\'Type__c\'] === \'Field\')" ng-class="{\'vloc-section-element\': true, \'slds-has-error\': (objFieldForm[formElementName].$touched && objFieldForm[formElementName].$error.required)}" ng-init="fieldName = sectionEl[nsp+\'FieldApiName__c\']; fieldName = (fieldName.endsWith(\'__c\') ? nsp+fieldName : fieldName);">\n\t\t\t\t\t\t<div class="el__label">\n\t\t\t\t\t\t\t<abbr ng-if="objectFields[fieldName].isRequired" class="slds-required" title="required">*</abbr>\n\t\t\t\t\t\t\t<label for="{{formElementName}}">{{sectionEl.Name}}</label>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t\t<div class="el__control">\n\t\t\t\t\t\t\t<vloc-obj-field \n\t\t\t\t\t\t\t\tdisplay-mode="\'edit\'" \n\t\t\t\t\t\t\t\tparent-obj="parentObj" \n\t\t\t\t\t\t\t\tform-element-name="formElementName" \n\t\t\t\t\t\t\t\tfield-name="fieldName" \n\t\t\t\t\t\t\t\tfield-info="objectFields[fieldName]" \n\t\t\t\t\t\t\t\tobj-picklists="objectPicklists[fieldName.toLowerCase()]"></vloc-obj-field>\n\t\t\t\t\t\t\t<span ng-if="(objFieldForm[formElementName].$touched && objFieldForm[formElementName].$error.required)" class="slds-form-element__help">This field is required</span>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t\t<div class="el__attr-details"></div>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div ng-if="(sectionEl[nsp+\'Type__c\'] === \'Attribute\')" ng-class="{\'vloc-section-element\': true, \'slds-has-error\': (objFieldForm[formElementName].$touched && objFieldForm[formElementName].$error.required)}">\n\t\t\t\t\t\t<div class="el__label">\n\t\t\t\t\t\t\t<abbr ng-if="attrAssgnObjMap[attrId][nsp+\'IsRequired__c\']" class="slds-required" title="required">*</abbr>\n\t\t\t\t\t\t\t<label for="{{formElementName}}">{{sectionEl.Name}}</label>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t\t<div class="el__control">\n\t\t\t\t\t\t\t<vloc-attribute \n\t\t\t\t\t\t\t\tattribute-id="attrId" \n\t\t\t\t\t\t\t\tobject-id="parentObj.Id" \n\t\t\t\t\t\t\t\tform-element-name="formElementName" \n\t\t\t\t\t\t\t\tattr-map="attrMap" \n\t\t\t\t\t\t\t\tattr-obj="attrObjMap[attrId]" \n\t\t\t\t\t\t\t\tattr-assgn-obj="attrAssgnObjMap[attrId]" \n\t\t\t\t\t\t\t\tpicklist-items="null" \n\t\t\t\t\t\t\t\tlookup-items="null"></vloc-attribute>\n\t\t\t\t\t\t\t<span ng-if="(objFieldForm[formElementName].$touched && objFieldForm[formElementName].$error.required)" class="slds-form-element__help">This field is required</span>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t\t<div class="el__attr-details"><a href="#" ng-click="showAttributeMetadata({\'attributeId\': attrId})">Details</a></div>\n\t\t\t\t\t</div>\n\t\t\t\t</ng-form>\n\t\t\t</div>\n\t\t</div>\n\t</section>\n</div>')}]);
},{}],39:[function(require,module,exports){
angular.module('cpqdirectives', ['vlocity', 'sldsangular'])
.config(['remoteActionsProvider', function(remoteActionsProvider) {
    remoteActionsProvider.setRemoteActions(window.remoteActions || {});
}])
.config(['$locationProvider', function($locationProvider) {
    $locationProvider.html5Mode(true);
}]);

if (!String.prototype.endsWith) {
    String.prototype.endsWith = function(searchString, position) {
        var subjectString = this.toString();
        if (typeof position !== 'number' || !isFinite(position) || Math.floor(position) !== position || position > subjectString.length) {
            position = subjectString.length;
        }
        position -= searchString.length;
        var lastIndex = subjectString.lastIndexOf(searchString, position);
        return (lastIndex !== -1 && lastIndex === position);
    };
}

require('./modules/cpqdirectives/controller/NewObjectRecordController.js');
require('./modules/cpqdirectives/directive/VlocAssignAttrsFields.js');
require('./modules/cpqdirectives/directive/VlocAttachment.js');
require('./modules/cpqdirectives/directive/VlocAttachments.js');
require('./modules/cpqdirectives/directive/VlocAttribute.js');
require('./modules/cpqdirectives/directive/VlocAttributeDefaultValue.js');
require('./modules/cpqdirectives/directive/VlocAttributeMetadata.js');
require('./modules/cpqdirectives/directive/VlocContextRule.js');
require('./modules/cpqdirectives/directive/VlocContextRules.js');
require('./modules/cpqdirectives/directive/VlocContextRuleSet.js');
require('./modules/cpqdirectives/directive/VlocContextRuleInfoCard.js');
require('./modules/cpqdirectives/directive/VlocCustomView.js');
require('./modules/cpqdirectives/directive/VlocDataTable.js');
require('./modules/cpqdirectives/directive/VlocFieldMetadata.js');
require('./modules/cpqdirectives/directive/VlocImgCarousel.js');
require('./modules/cpqdirectives/directive/VlocLayoutManagement.js');
require('./modules/cpqdirectives/directive/VlocLayoutElement.js');
require('./modules/cpqdirectives/directive/VlocObjAttrsFields.js');
require('./modules/cpqdirectives/directive/VlocObjField.js');
require('./modules/cpqdirectives/directive/VlocObjectPricing.js');
require('./modules/cpqdirectives/directive/VlocGlobalPricingElements.js');
require('./modules/cpqdirectives/directive/VlocObjectPricingElement.js');
require('./modules/cpqdirectives/directive/VlocObjectPricingElements.js');
require('./modules/cpqdirectives/directive/VlocStandalonePricingElements.js');
require('./modules/cpqdirectives/directive/VlocObjectTypes.js');
require('./modules/cpqdirectives/directive/VlocObjectType.js');
require('./modules/cpqdirectives/directive/VlocOfferPricingComponent.js');
require('./modules/cpqdirectives/directive/VlocPriceListEntryInfoCard.js');
require('./modules/cpqdirectives/directive/VlocPriceListEntry.js');
require('./modules/cpqdirectives/directive/VlocProdCardinality.js');
require('./modules/cpqdirectives/directive/VlocProdChildDetails.js');
require('./modules/cpqdirectives/directive/VlocProdChildItem.js');
require('./modules/cpqdirectives/directive/VlocProductAttributes.js');
require('./modules/cpqdirectives/directive/VlocProductPricing.js');
require('./modules/cpqdirectives/directive/VlocFacetDetails.js');
require('./modules/cpqdirectives/directive/VlocSections.js');
require('./modules/cpqdirectives/factory/CpqService.js');
require('./modules/cpqdirectives/templates/templates.js');

},{"./modules/cpqdirectives/controller/NewObjectRecordController.js":1,"./modules/cpqdirectives/directive/VlocAssignAttrsFields.js":2,"./modules/cpqdirectives/directive/VlocAttachment.js":3,"./modules/cpqdirectives/directive/VlocAttachments.js":4,"./modules/cpqdirectives/directive/VlocAttribute.js":5,"./modules/cpqdirectives/directive/VlocAttributeDefaultValue.js":6,"./modules/cpqdirectives/directive/VlocAttributeMetadata.js":7,"./modules/cpqdirectives/directive/VlocContextRule.js":8,"./modules/cpqdirectives/directive/VlocContextRuleInfoCard.js":9,"./modules/cpqdirectives/directive/VlocContextRuleSet.js":10,"./modules/cpqdirectives/directive/VlocContextRules.js":11,"./modules/cpqdirectives/directive/VlocCustomView.js":12,"./modules/cpqdirectives/directive/VlocDataTable.js":13,"./modules/cpqdirectives/directive/VlocFacetDetails.js":14,"./modules/cpqdirectives/directive/VlocFieldMetadata.js":15,"./modules/cpqdirectives/directive/VlocGlobalPricingElements.js":16,"./modules/cpqdirectives/directive/VlocImgCarousel.js":17,"./modules/cpqdirectives/directive/VlocLayoutElement.js":18,"./modules/cpqdirectives/directive/VlocLayoutManagement.js":19,"./modules/cpqdirectives/directive/VlocObjAttrsFields.js":20,"./modules/cpqdirectives/directive/VlocObjField.js":21,"./modules/cpqdirectives/directive/VlocObjectPricing.js":22,"./modules/cpqdirectives/directive/VlocObjectPricingElement.js":23,"./modules/cpqdirectives/directive/VlocObjectPricingElements.js":24,"./modules/cpqdirectives/directive/VlocObjectType.js":25,"./modules/cpqdirectives/directive/VlocObjectTypes.js":26,"./modules/cpqdirectives/directive/VlocOfferPricingComponent.js":27,"./modules/cpqdirectives/directive/VlocPriceListEntry.js":28,"./modules/cpqdirectives/directive/VlocPriceListEntryInfoCard.js":29,"./modules/cpqdirectives/directive/VlocProdCardinality.js":30,"./modules/cpqdirectives/directive/VlocProdChildDetails.js":31,"./modules/cpqdirectives/directive/VlocProdChildItem.js":32,"./modules/cpqdirectives/directive/VlocProductAttributes.js":33,"./modules/cpqdirectives/directive/VlocProductPricing.js":34,"./modules/cpqdirectives/directive/VlocSections.js":35,"./modules/cpqdirectives/directive/VlocStandalonePricingElements.js":36,"./modules/cpqdirectives/factory/CpqService.js":37,"./modules/cpqdirectives/templates/templates.js":38}]},{},[39]);

})();