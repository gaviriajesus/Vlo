(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
angular.module('objectclassadmin')
.controller('ObjectClassAdminController', ['$scope', '$location', '$timeout', '$compile', 'remoteActions', 'objectClassService', 'cpqService',
    function ($scope, $location, $timeout, $compile, remoteActions, objectClassService, cpqService) {
        $scope.OBJECT_NAME = 'ObjectClass__c';
        $scope.nsp = fileNsPrefix();
        $scope.objectClassId = $location.search().id;
        $scope.objectClassName = $location.search().name;
        $scope.mode = $location.search().mode;
        $scope.showFacetDetail = false;
        $scope.maximizeFacetDetail = false;
        $scope.objectFields = null;
        $scope.objectobjectClasss = {};
        $scope.objectClass = {};
        $scope.editObject = {};
        $scope.attrMap = {};
        $scope.attrObjMap = {};
        $scope.attrAssgnObjMap = {};
        $scope.objectApiName = '';

        $scope.describeObject = function(objectName) {
            var inputMap = { 'objectName' : objectName };
            remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                console.log('describeObject objectClass results: ', results);
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

        $scope.getObject = function(objectClassId) {
            var inputMap = { 'objectId' : objectClassId };
            remoteActions.invokeMethod('getObject', JSON.stringify(inputMap)).then(function(results) {
                console.log('getObject results: ', results);
                $scope.objectClass = results;
                $scope.editObject = {};
                for (var key in $scope.objectClass) {
                    $scope.editObject[key] = $scope.objectClass[key];
                }

                $scope.objectApiName = $scope.objectClass[$scope.nsp + 'ObjectApiName__c'];
                if ($scope.objectApiName && $scope.objectApiName.endsWith('__c')) {
                    $scope.objectApiName = $scope.nsp + $scope.objectApiName;
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
                console.log('save objectClass results: ', results);
                $scope.objectClass = {};
                $scope.editObject = {};
                for (var key in results) {
                    if ($scope.objectFields[key] && $scope.objectFields[key].type === 'DATE') {
                        var tzOffset = (window.userTimezoneOffset || window.parent.userTimezoneOffset);
                        $scope.objectClass[key] = results[key] + tzOffset;
                        $scope.editObject[key] = results[key] + tzOffset;
                    } else {
                        $scope.objectClass[key] = results[key];
                        $scope.editObject[key] = results[key];
                    }
                }
                if (event) {
                    event.currentTarget.innerText = originalText;
                    event.currentTarget.disabled = false;
                }
                cpqService.showNotification({
                    type: 'success',
                    content: 'Object saved!',
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

        $scope.$on('showItemDetails', function(event, data) {
            $scope.openFacetDetails(data.facetType, data.facetData, data);
        });

        $scope.$on('hideItemDetails', function() {
            $scope.closeFacetDetails();
        });

        $scope.openFacetDetails = function(facetType, facetData, data) {
            var compiledHTML;
            if (facetType === 'ATTR_METADATA') {
                $scope.objectId = facetData.objectId;
                $scope.attrObj = facetData.attrObj;
                $scope.attrAssgnObj = facetData.attrAssgnObj;
                $scope.mode = facetData.mode;
                $scope.isProduct = false;
                compiledHTML = $compile('<vloc-attribute-metadata object-id="objectId" attr-obj="attrObj" attr-assgn-obj="attrAssgnObj" mode="mode" is-product="isProduct"></vloc-attribute-metadata>')($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'FIELD_METADATA') {
                $scope.objectName = facetData.objectName;
                $scope.fieldName = facetData.fieldName;
                compiledHTML = $compile('<vloc-field-metadata object-name="objectName" field-name="fieldName"></vloc-field-metadata>')($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'LAYOUT_ELEMENT') {
                $scope.objectId = facetData.objectId;
                $scope.elementObj = facetData.elementObj;
                $scope.objectName = facetData.objectName;
                $scope.objectLayoutId = facetData.objectLayoutId;
                $scope.objectFacetId = facetData.objectFacetId;
                $scope.objectSectionId = facetData.objectSectionId;
                $scope.objectLayoutFields = facetData.objectLayoutFields;
                var directiveHTML = '<vloc-layout-element item="elementObj" layout-id="objectLayoutId" ' +
                    'facet-id="objectFacetId" section-id="objectSectionId" object-name="objectName" ' +
                    'object-layout-fields="objectLayoutFields"></vloc-layout-element>';
                compiledHTML = $compile(directiveHTML)($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'OBJECT_TYPE') {
                //TODO: should be facetData.objectTypeItem and parent-item should be ParentObjectClass(?)
                $scope.objectTypeItem = facetData.objectTypeItem;
                $scope.objectClassItem = facetData.objectClassItem;
                compiledHTML = $compile('<vloc-object-type item="objectTypeItem" parent-item="objectClassItem" object-name="objectApiName"></vloc-object-type>')($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else {
                $scope.selectedItem = data;
                compiledHTML = $compile('<vloc-attachment item="selectedItem" parent-item="product" hide-item-details="closeFacetDetails"></vloc-attachment>')($scope);
                j$('#facet-detail-content').html(compiledHTML);
            }
            $scope.showFacetDetail = true;
        };

        $scope.closeFacetDetails = function() {
            $scope.maximizeFacetDetail = false;
            $scope.showFacetDetail = false;
            j$('#facet-detail-content').html('');
        };

        $scope.setupViewAttrs = function(section) {
            return {
                'name': section.facetSectionObj[$scope.nsp + 'ViewUri__c'],
                'attrs': {
                    'objectId': $scope.objectClassId,
                    'objectApiName': $scope.objectApiName
                }
            };
        };

        $scope.init = function() {
            $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
            $scope.getObjectPicklistsByName($scope.nsp + $scope.OBJECT_NAME);
            $scope.facets = objectClassService.getFacets();
            if ($scope.facets.length > 0) {
                $scope.gotoFacet($scope.facets[0]);
            }

            if ($scope.mode === 'new') {
                $scope.objectClassName = 'New Object Class';
            } else {
                $scope.getObject($scope.objectClassId);
            }
        };
        $scope.init();
    }
]);

},{}],2:[function(require,module,exports){
angular.module('objectclassadmin')
.directive('vlocAttrFieldBindings', ['$rootScope', 'remoteActions', 'cpqService',
    function($rootScope, remoteActions, cpqService) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'AttrFieldBindings.tpl.html',
            controller: function($scope, $sldsModal) {
                console.log('INIT: ', $scope.customViewAttrs);
                $scope.nsp = fileNsPrefix();
                $scope.objectId = $scope.customViewAttrs.objectId;
                $scope.selectedCount = 0;
                $scope.filter = {
                    ua: true,
                    ba: true,
                    uf: true,
                    bf: true
                };

                $scope.getAttributeFieldBindingData = function() {
                    $scope.attributeMap = {};
                    $scope.bindingMap = {};
                    $scope.attrList = [];
                    $scope.fieldList = [];
                    $scope.unboundAttrs = [];
                    $scope.unboundFields = [];

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
                            boundAttrMap[attrId] = {'Name': fieldName, 'Label': $scope.fields[fieldName].label, 'BindingId': binding.Id};
                            boundFieldMap[fieldName] = {'Id': attrId, 'Name': attrName, 'Code': attrCode, 'BindingId': binding.Id};

                            $scope.bindingMap[binding.Id] = binding;
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
                                $scope.unboundAttrs.push(item);
                            } else {
                                item.bound = true;
                                item.fieldName = boundAttrMap[attr.Id].Name;
                                item.fieldLabel = boundAttrMap[attr.Id].Label;
                                item.bindingId = boundAttrMap[attr.Id].BindingId;
                            }

                            $scope.attrList.push(item);
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
                                $scope.unboundFields.push(item);
                            } else {
                                item.bound = true;
                                item.attrId = boundFieldMap[fieldName].Id;
                                item.attrName = boundFieldMap[fieldName].Name;
                                item.attrCode = boundFieldMap[fieldName].Code;
                                item.bindingId = boundFieldMap[fieldName].BindingId;
                            }

                            $scope.fieldList.push(item);
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
                        $scope.attributes.push(attr);
                    });
                };

                $scope.newBinding = function() {
                    var modalScope = $scope.$new();
                    modalScope.nsp = $scope.nsp;
                    modalScope.title = 'Attribute-Field Binding';
                    modalScope.unboundAttrs = $scope.unboundAttrs;
                    modalScope.unboundFields = $scope.unboundFields;
                    modalScope.editAttrId = '';
                    modalScope.editFieldName = '';
                    modalScope.createBinding = function() {
                        var inputMap = { 
                            'attributeId' : this.editAttrId,
                            'fieldName' : this.editFieldName,
                            'objectId' : $scope.objectId
                        };
                        remoteActions.invokeMethod('createAttributeFieldBinding', JSON.stringify(inputMap)).then(function(results) {
                            console.log('create AttributeBinding: ', results);
                            $scope.getAttributeFieldBindingData();
                            bindingModal.hide();
                            //TODO: show delete success message
                        }, function(error) {
                            cpqService.showNotification({
                                type: 'error',
                                title: 'Error',
                                content: error.message
                            });
                        });
                    };

                    var bindingModal = $sldsModal({
                        templateUrl: 'EditAttrFieldBinding.tpl.html',
                        backdrop: 'static',
                        scope: modalScope,
                        show: true
                    });
                };

                $scope.deleteBinding = function(bindingId, attrName, fieldLabel) {
                    var modalScope = $scope.$new();
                    modalScope.nsp = $scope.nsp;
                    modalScope.confirmationTitle = 'Delete Attribute-Field Binding';
                    modalScope.confirmationMsg = 'Are you sure you want to delete the binding between the Attribute <i>' + attrName + '</i> and the Field <i>' + fieldLabel + '</i>?';
                    modalScope.cancelActionLbl = 'Cancel';
                    modalScope.confirmActionLbl = 'Delete Binding';
                    modalScope.bindingObj = $scope.bindingMap[bindingId];
                    modalScope.confirmAction = function() {
                        var inputMap = { 'objectId' : this.bindingObj.Id };
                        remoteActions.invokeMethod('deleteObject', JSON.stringify(inputMap)).then(function(results) {
                            console.log('delete AttributeBinding: ', results);
                            $scope.getAttributeFieldBindingData();
                            bindingModal.hide();
                            //TODO: show delete success message
                        }, function(error) {
                            cpqService.showNotification({
                                type: 'error',
                                title: 'Error',
                                content: error.message
                            });
                            bindingModal.hide();
                        });
                    };

                    var bindingModal = $sldsModal({
                        template: 'ConfirmationModal.tpl.html',
                        backdrop: 'static',
                        scope: modalScope,
                        show: true
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
angular.module('objectclassadmin')
.directive('vlocObjectClassAttrsFields', ['$rootScope', 'remoteActions', 'cpqService',
    function($rootScope, remoteActions, cpqService) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ObjectClassAttrsFields.tpl.html',
            controller: function($scope) {
                console.log('INIT: ', $scope.customViewAttrs);
                $scope.nsp = fileNsPrefix();
                $scope.objectId = $scope.customViewAttrs.objectId;
                $scope.objectName = $scope.customViewAttrs.objectApiName;
                $scope.attrList = [];
                $scope.fieldList = [];
                $scope.filter = {
                    ua: true,
                    ba: true,
                    uf: true,
                    bf: true
                };

                $scope.$on('refreshItems', function() {
                    $scope.getAttributeFieldBindingData();
                });

                $scope.getAttributeFieldBindingData = function() {
                    $scope.AttrObjMap = {};
                    $scope.AttrAssgnObjMap = {};
                    $scope.attributeMap = {};
                    $scope.fieldMap = {};
                    $scope.items = [];
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
                        var attrList = [];
                        var fieldList = [];

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

                            attrList.push(item);
                            $scope.items.push(item);
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
                                $scope.items.push(item);
                            } else {
                                item.bound = true;
                                item.attrId = boundFieldMap[fieldName].Id;
                                item.attrName = boundFieldMap[fieldName].Name;
                                item.attrCode = boundFieldMap[fieldName].Code;
                            }

                            fieldList.push(item);
                        }

                        $scope.attrList = attrList;
                        $scope.fieldList = fieldList;
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
                    $scope.getAttributeFieldBindingData();
                };
                $scope.init();
            }
        };
    }
]);

},{}],4:[function(require,module,exports){
angular.module('objectclassadmin')
.directive('vlocObjectTypeStructure', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ObjectTypeStructure.tpl.html',
            controller: function($scope, $rootScope, $sldsModal, $compile) {
                console.log('INIT: ', $scope.customViewAttrs);
                $scope.objectId = $scope.customViewAttrs.objectId;
                $scope.nsp = fileNsPrefix();

                $scope.getFieldSets = function() {
                    var inputMap = { 'objectName' : $scope.nsp + 'ObjectClass__c' };
                    remoteActions.invokeMethod('getFieldSetsByName', JSON.stringify(inputMap)).then(function(results) {
                        if (results[$scope.nsp.toLowerCase() + 'objecttype'] === undefined) {
                            $scope.prodFieldSet = null;
                        } else {
                            $scope.prodFieldSet = results[$scope.nsp.toLowerCase() + 'objecttype'];
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getNumber = function(num) {
                    return (new Array(num));
                };

                $scope.getObjectTypeStructure = function() {
                    var inputs= { 'objectClassId' : $scope.objectId };
                    remoteActions.invokeMethod('getObjectTypeStructure', JSON.stringify(inputs)).then(function(results) {
                        var objectTypeList = [];
                        angular.forEach(results, function(objType, idx) {
                            objType.show = true;
                            objType.RecordTypeName = objType.objectType[$scope.nsp + 'RecordTypeName__c'];
                            if (objType.level === 0) {
                                objType.isRoot = true;
                            } else {
                                objType.isRoot = false;
                            }

                            objectTypeList.push(objType);

                        });
                        $scope.objectTypeList = objectTypeList;
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.newItem = function() {
                    $scope.selectItem({});
                };

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

                $scope.$on('refreshItems', function() {
                    $scope.getObjectTypeStructure();
                });

                $scope.formatFieldValue = function(field) {
                    return (field === undefined ? '&nbsp;' : field);
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
                    $scope.getFieldSets();
                    $scope.getObjectTypeStructure();
                };
                $scope.init();
            }
        };
    }
]);

},{}],5:[function(require,module,exports){
angular.module('objectclassadmin')
.factory('objectClassService', ['$rootScope',
    function($rootScope) {
        var ENTITYCLASS_FACETS = [
            {
                'active': true,
                'facetObj': {
                    'Id': 'fo1',
                    'Name': 'General Properties'
                },
                'hasSectionCustomView': false,
                'sections': [
                    {
                        'facetSectionObj': {},
                        'sectionElements': [
                            {
                                'Id': 'se1',
                                'Name': 'Object Name',
                                'FieldApiName__c': 'Name',
                                'Type__c': 'Field'
                            },
                            {
                                'Id': 'se2',
                                'Name': 'Object API Name',
                                'FieldApiName__c': 'ObjectApiName__c',
                                'Type__c': 'Field'
                            },
                            {
                                'Id': 'se3',
                                'Name': 'Object Record Type',
                                'FieldApiName__c': 'RecordTypeName__c',
                                'Type__c': 'Field'
                            }
                        ],
                        'sectionObj': {
                            'Name': 'General Properties'
                        }
                    }
                ]
            },
            {
                'active': false,
                'facetObj': {
                    'Id': 'fo2',
                    'Name': 'Attribute-Field Bindings'
                },
                'hasSectionCustomView': true,
                'sections': [
                    {
                        'hasCustomView': true,
                        'facetSectionObj': {
                            'Name': 'Attribute-Field Bindings',
                            'ViewType__c': 'Custom View',
                            'ViewUri__c': 'AttributeFieldBindings'
                        },
                        'sectionElements': [],
                        'sectionObj': {
                            'Name': 'Attribute-Field Bindings'
                        }
                    }
                ]
            },
            {
                'active': false,
                'facetObj': {
                    'Id': 'fo3',
                    'Name': 'Attributes and Fields'
                },
                'hasSectionCustomView': true,
                'sections': [
                    {
                        'hasCustomView': true,
                        'facetSectionObj': {
                            'Name': 'Attributes and Fields',
                            'ViewType__c': 'Custom View',
                            'ViewUri__c': 'ObjectClassAttrsFields'
                        },
                        'sectionElements': [],
                        'sectionObj': {
                            'Name': 'Attributes and Fields'
                        }
                    }
                ]
            },
            {
                'active': false,
                'facetObj': {
                    'Id': 'fo4',
                    'Name': 'Layout Management'
                },
                'hasSectionCustomView': true,
                'sections': [
                    {
                        'hasCustomView': true,
                        'facetSectionObj': {
                            'Name': 'Layout Management',
                            'ViewType__c': 'Custom View',
                            'ViewUri__c': 'LayoutManagement'
                        },
                        'sectionElements': [],
                        'sectionObj': {
                            'Name': 'Layout Management'
                        }
                    }
                ]
            },
            {
                'active': false,
                'facetObj': {
                    'Id': 'fo5',
                    'Name': 'Object Types'
                },
                'hasSectionCustomView': true,
                'sections': [
                    {
                        'hasCustomView': true,
                        'facetSectionObj': {
                            'Name': 'Object Types',
                            'ViewType__c': 'Custom View',
                            // 'ViewUri__c': 'ObjectTypes'
                            'ViewUri__c': 'ObjectTypeStructure'
                        },
                        'sectionElements': [],
                        'sectionObj': {
                            'Name': 'Object Types'
                        }
                    }
                ]
            }
        ];

        return {
            getFacets: function() {
                var nsp = fileNsPrefix();
                var facets = [];
                var key;
                angular.forEach(ENTITYCLASS_FACETS, function(facet) {
                    angular.forEach(facet.sections, function(section) {
                        // sectionElements
                        angular.forEach(section.sectionElements, function(sectionElement) {
                            for (key in sectionElement) {
                                if (key.endsWith('__c')) {
                                    sectionElement[nsp + key] = sectionElement[key];
                                }
                            }
                        });

                        // sectionObj
                        for (key in section.facetSectionObj) {
                            if (key.endsWith('__c')) {
                                section.facetSectionObj[nsp + key] = section.facetSectionObj[key];
                            }
                        }
                    });
                    facets.push(facet);
                });
                return facets;
            }
        };
    }
]);

},{}],6:[function(require,module,exports){
angular.module("objectclassadmin").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("AttrFieldBindings.tpl.html",'<div class="vloc-attr-field-bindings">\n    <h3 class="slds-text-heading--small">Attribute-Field Bindings</h3>\n    <div class="vloc-section-actions">\n        <button type="button" class="slds-button slds-button--neutral" ng-click="newBinding()">New Binding</button>\n    </div>\n    <div class="item-container slds-m-bottom--x-large">\n        <div class="filter slds-clearfix slds-m-bottom--small slds-m-top--large">\n            <div class="slds-float--left filter-label">Attributes:</div>\n            <div class="slds-float--right">\n                <form class="slds-form--inline">\n                    <div class="slds-form-element">\n                        <div class="slds-form-element__control">\n                            <label class="slds-checkbox">\n                                <input type="checkbox" ng-model="filter.ua" />\n                                <span class="slds-checkbox--faux"></span>\n                                <span class="slds-form-element__label">Unbound Attributes</span>\n                            </label>\n                        </div>\n                        <div class="slds-form-element__control">\n                            <label class="slds-checkbox">\n                                <input type="checkbox" ng-model="filter.ba" />\n                                <span class="slds-checkbox--faux"></span>\n                                <span class="slds-form-element__label">Bound Attributes</span>\n                            </label>\n                        </div>\n                    </div>\n                </form>\n            </div>\n        </div>\n        <table class="slds-table slds-table--bordered">\n            <thead>\n                <tr class="slds-text-heading--label">\n                    <th><div class="slds-truncate">Attribute</div></th>\n                    <th><div class="slds-truncate">Attribute Code</div></th>\n                    <th><div class="slds-truncate">Is Bound?</div></th>\n                    <th><div class="slds-truncate">Field</div></th>\n                    <th><div class="slds-truncate">&nbsp;</div></th>\n                </tr>\n            </thead>\n            <tbody>\n                <tr ng-repeat="item in attrList | orderBy:[\'-bound\',\'attrName\']" ng-if="((item.bound && filter.ba) || (!item.bound && filter.ua))">\n                    <td>{{item.attrName}}</td>\n                    <td>{{item.attrCode}}</td>\n                    <td>{{(item.bound ? \'Yes\' : \'No\')}}</td>\n                    <td>{{item.fieldLabel}}</td>\n                    <td><a ng-if="item.bound" href="#" ng-click="deleteBinding(item.bindingId, item.attrName, item.fieldLabel)">Delete Binding</a></td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n    <div class="item-container">\n        <div class="filter slds-clearfix slds-m-bottom--small slds-m-top--large">\n            <div class="slds-float--left filter-label">Fields:</div>\n            <div class="slds-float--right">\n                <form class="slds-form--inline">\n                    <div class="slds-form-element">\n                        <div class="slds-form-element__control">\n                            <label class="slds-checkbox">\n                                <input type="checkbox" ng-model="filter.uf" />\n                                <span class="slds-checkbox--faux"></span>\n                                <span class="slds-form-element__label">Unbound Fields</span>\n                            </label>\n                        </div>\n                        <div class="slds-form-element__control">\n                            <label class="slds-checkbox">\n                                <input type="checkbox" ng-model="filter.bf" />\n                                <span class="slds-checkbox--faux"></span>\n                                <span class="slds-form-element__label">Bound Fields</span>\n                            </label>\n                        </div>\n                    </div>\n                </form>\n            </div>\n        </div>\n        <table class="slds-table slds-table--bordered">\n            <thead>\n                <tr class="slds-text-heading--label">\n                    <th><div class="slds-truncate">Field</div></th>\n                    <th><div class="slds-truncate">Is Bound?</div></th>\n                    <th><div class="slds-truncate">Attribute</div></th>\n                    <th><div class="slds-truncate">Attribute Code</div></th>\n                    <th><div class="slds-truncate">&nbsp;</div></th>\n                </tr>\n            </thead>\n            <tbody>\n                <tr ng-repeat="item in fieldList | orderBy:[\'-bound\',\'fieldLabel\']" ng-if="((item.bound && filter.bf) || (!item.bound && filter.uf))">\n                    <td>{{item.fieldLabel}}</td>\n                    <td>{{(item.bound ? \'Yes\' : \'No\')}}</td>\n                    <td>{{item.attrName}}</td>\n                    <td>{{item.attrCode}}</td>\n                    <td><a ng-if="item.bound" href="#" ng-click="deleteBinding(item.bindingId, item.attrName, item.fieldLabel)">Delete Binding</a></td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n</div>'),$templateCache.put("EditAttrFieldBinding.tpl.html",'<div class="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n            <h3 class="slds-text-heading--medium">{{title}}</h3>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium">\n            <div class="edit-attr-field-binding">\n                <fieldset class="slds-form--compound">\n                    <div class="form-element__group">\n                        <div class="slds-form-element__row">\n                            <div class="slds-form-element slds-size--1-of-3">\n                                <label class="slds-form-element__label" for="select-01">Attribute</label>\n                                <select id="select-01" ng-model="editAttrId" class="slds-select">\n                                    <option ng-repeat="a in unboundAttrs | orderBy:\'attrName\'" value="{{a.attrId}}">{{a.attrName}}</option>\n                                </select>\n                            </div>\n                            <div class="slds-form-element slds-size--1-of-3">\n                            &nbsp;\n                            </div>\n                            <div class="slds-form-element slds-size--1-of-3">\n                                <label class="slds-form-element__label" for="select-02">Field</label>\n                                <select id="select-02" ng-model="editFieldName" class="slds-select">\n                                    <option ng-repeat="f in unboundFields | orderBy:\'fieldLabel\'" value="{{f.fieldName}}">{{f.fieldLabel}}</option>\n                                </select>\n                            </div>\n                        </div>\n                    </div>\n                </fieldset>\n            </div>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="$hide()">Cancel</button>\n            <button type="button" class="slds-button slds-button--brand" ng-click="createBinding()">Save</button>\n        </div>\n    </div>\n</div>'),$templateCache.put("ObjectClassAttrsFields.tpl.html",'<div class="vloc-object-class-attrs-fields">\n    <h3 class="slds-text-heading--small">Attributes and Fields</h3>\n    <div class="item-container slds-m-bottom--x-large">\n        <div class="filter slds-clearfix slds-m-bottom--small slds-m-top--large">\n            <div class="slds-float--left filter-label">Attributes:</div>\n            <div class="slds-float--right">\n                <form class="slds-form--inline">\n                    <div class="slds-form-element">\n                        <div class="slds-form-element__control">\n                            <label class="slds-checkbox">\n                                <input type="checkbox" ng-model="filter.ua" />\n                                <span class="slds-checkbox--faux"></span>\n                                <span class="slds-form-element__label">Unbound Attributes</span>\n                            </label>\n                        </div>\n                        <div class="slds-form-element__control">\n                            <label class="slds-checkbox">\n                                <input type="checkbox" ng-model="filter.ba" />\n                                <span class="slds-checkbox--faux"></span>\n                                <span class="slds-form-element__label">Bound Attributes</span>\n                            </label>\n                        </div>\n                    </div>\n                </form>\n            </div>\n        </div>\n        <table class="slds-table slds-table--bordered">\n            <thead>\n                <tr class="slds-text-heading--label">\n                    <th><div class="slds-truncate">Attribute</div></th>\n                    <th><div class="slds-truncate">Attribute Code</div></th>\n                    <th><div class="slds-truncate">Is Bound?</div></th>\n                    <th><div class="slds-truncate">Field</div></th>\n                </tr>\n            </thead>\n            <tbody>\n                <tr ng-repeat="item in attrList | orderBy:[\'-bound\',\'attrName\']" ng-if="((item.bound && filter.ba) || (!item.bound && filter.ua))">\n                    <td><a href="#" ng-click="showAttributeMetadata(item.attrId)">{{item.attrName}}</a></td>\n                    <td>{{item.attrCode}}</td>\n                    <td>{{(item.bound ? \'Yes\' : \'No\')}}</td>\n                    <td><a href="#" ng-click="showFieldMetadata(objectName, item.fieldName)">{{item.fieldLabel}}</a></td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n    <div class="item-container">\n        <div class="filter slds-clearfix slds-m-bottom--small slds-m-top--large">\n            <div class="slds-float--left filter-label">Fields:</div>\n            <div class="slds-float--right">\n                <form class="slds-form--inline">\n                    <div class="slds-form-element">\n                        <div class="slds-form-element__control">\n                            <label class="slds-checkbox">\n                                <input type="checkbox" ng-model="filter.uf" />\n                                <span class="slds-checkbox--faux"></span>\n                                <span class="slds-form-element__label">Unbound Fields</span>\n                            </label>\n                        </div>\n                        <div class="slds-form-element__control">\n                            <label class="slds-checkbox">\n                                <input type="checkbox" ng-model="filter.bf" />\n                                <span class="slds-checkbox--faux"></span>\n                                <span class="slds-form-element__label">Bound Fields</span>\n                            </label>\n                        </div>\n                    </div>\n                </form>\n            </div>\n        </div>\n        <table class="slds-table slds-table--bordered">\n            <thead>\n                <tr class="slds-text-heading--label">\n                    <th><div class="slds-truncate">Field</div></th>\n                    <th><div class="slds-truncate">Is Bound?</div></th>\n                    <th><div class="slds-truncate">Attribute</div></th>\n                </tr>\n            </thead>\n            <tbody>\n                <tr ng-repeat="item in fieldList | orderBy:[\'-bound\',\'fieldLabel\']" ng-if="((item.bound && filter.bf) || (!item.bound && filter.uf))">\n                    <td><a href="#" ng-click="showFieldMetadata(objectName, item.fieldName)">{{item.fieldLabel}}</a></td>\n                    <td>{{(item.bound ? \'Yes\' : \'No\')}}</td>\n                    <td><a href="#" ng-click="showAttributeMetadata(item.attrId)">{{item.attrName}}</a></td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n</div>'),$templateCache.put("ObjectTypeStructure.tpl.html",'<div class="vloc-object-type-structure">\n    <h3 class="slds-text-heading--small">Object Types</h3>\n    <div class="vloc-section-actions">\n        <button type="button" class="slds-button slds-button--neutral" ng-click="newItem()">New Object Type</button>\n    </div>\n    <div class="slds-clearfix tbl-structure">\n        <div class="slds-float--left tbl-name" ng-show="!showChildDetails">\n            <table class="slds-table slds-table--bordered slds-no-row-hover prod-structure">\n                <thead>\n                    <tr class="slds-text-heading--label">\n                        <th class="prod-action"></th>\n                        <th class="prod-name"><div class="slds-truncate">Object Type Name</div></th>\n                    </tr>\n                </thead>\n                <tbody>\n                    <tr ng-repeat="p in objectTypeList" ng-if="p.show">\n                        <td class="prod-action">\n                            <button class="slds-button slds-button--icon" ng-click="editItem(p.objectType, $event)">\n                                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'edit\'"></slds-button-svg-icon>\n                                <span class="slds-assistive-text">Edit Object Type</span>\n                            </button>\n                            <button class="slds-button slds-button--icon" ng-click="deleteItem(p.objectType, $event)">\n                                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                                <span class="slds-assistive-text">Delete Object Type</span>\n                            </button>\n                        </td>\n                        <td class="prod-name">\n                            <div class="p-wrapper">\n                                <div ng-repeat="n in getNumber(p.level) track by $index" class="p-level"></div>\n                                <div class="p-name slds-truncate">\n                                    <a href="#" ng-if="!p.isRoot" ng-click="launchTab(p.objectType)">{{p.objectType.Name}}</a>\n                                    <a href="#" ng-if="p.isRoot" ng-click="launchTab(p.objectType)">{{p.objectType.Name}}</a>\n                                </div>\n                            </div>\n                        </td>\n                    </tr>\n                </tbody>\n            </table>\n        </div>\n    </div>\n</div>')}]);
},{}],7:[function(require,module,exports){
angular.module('objectclassadmin', ['vlocity', 'ngSanitize', 'cpqdirectives', 'sldsangular'])
.config(['remoteActionsProvider', function(remoteActionsProvider) {
    remoteActionsProvider.setRemoteActions(window.remoteActions || {});
}])
.config(['$locationProvider', function($locationProvider) {
    $locationProvider.html5Mode(true);
}]);

require('./modules/objectclassadmin/controller/ObjectClassAdminController.js');
require('./modules/objectclassadmin/directive/VlocAttrFieldBindings.js');
require('./modules/objectclassadmin/directive/VlocObjectClassAttrsFields.js');
require('./modules/objectclassadmin/directive/VlocObjectTypeStructure.js');
require('./modules/objectclassadmin/factory/ObjectClassService.js');
require('./modules/objectclassadmin/templates/templates.js');

},{"./modules/objectclassadmin/controller/ObjectClassAdminController.js":1,"./modules/objectclassadmin/directive/VlocAttrFieldBindings.js":2,"./modules/objectclassadmin/directive/VlocObjectClassAttrsFields.js":3,"./modules/objectclassadmin/directive/VlocObjectTypeStructure.js":4,"./modules/objectclassadmin/factory/ObjectClassService.js":5,"./modules/objectclassadmin/templates/templates.js":6}]},{},[7]);

})();