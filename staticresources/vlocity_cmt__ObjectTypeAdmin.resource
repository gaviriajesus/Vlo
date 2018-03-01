(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
angular.module('objecttypeadmin')
.controller('ObjectTypeAdminController', ['$scope', '$location', '$timeout', '$compile', 'remoteActions', 'objectTypeService', 'cpqService',
    function ($scope, $location, $timeout, $compile, remoteActions, objectTypeService, cpqService) {
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

        $scope.describeObjectWithQuery = function(objectName) {
            var queryMap = {};
            //Build query string: WHERE myu16__ObjectApiName__c = parentItem AND RecordType.Name = 'Object Type'
            var objName = $scope.objectApiName.replace($scope.nsp, '');
            var parentOTQueryFilter = 'WHERE ' + $scope.nsp + 'ObjectApiName__c = \'' + objName + '\' AND RecordType.Name = \'Object Type\' AND Id != \''+$scope.objectClassId+'\'';
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
                $scope.objectClass = results;
                $scope.editObject = {};
                for (var key in $scope.objectClass) {
                    $scope.editObject[key] = $scope.objectClass[key];
                }

                $scope.objectApiName = $scope.objectClass[$scope.nsp + 'ObjectApiName__c'];
                if ($scope.objectApiName && $scope.objectApiName.endsWith('__c')) {
                    $scope.objectApiName = $scope.nsp + $scope.objectApiName;
                }
                $scope.describeObjectWithQuery($scope.nsp + $scope.OBJECT_NAME);
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
            if ($scope.mode === 'new') {
                $scope.createItem(event);
            } else {
                $scope.saveItem(event);
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
                console.log('create objectClass results: ', results);
                for (var key in results) {
                    $scope.objectClass[key] = results[key];
                    $scope.editObject[key] = results[key];
                }
                if (event) {
                    event.currentTarget.innerText = originalText;
                    event.currentTarget.disabled = false;
                }
                cpqService.showNotification({
                    type: 'success',
                    content: 'Object Type created!',
                    autohide: true
                });
                // redirect to object page
                window.location = '/apex/objectTypeAdmin?id=' + results.Id + '&name=' + results.Name;
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
                    content: 'Object Type saved!',
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
            console.log('showItemDetails data: ',data);
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
                $scope.isProduct = false;
                compiledHTML = $compile('<vloc-attribute-metadata object-id="objectId" attr-obj="attrObj" attr-assgn-obj="attrAssgnObj" override-mode="false" is-product="isProduct"></vloc-attribute-metadata>')($scope);
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
                    'facet-id="objectFacetId" section-id="objectSectionId" object-name="objectName" object-layout-fields="objectLayoutFields"></vloc-layout-element>';
                compiledHTML = $compile(directiveHTML)($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'ASSIGN_ATTRS_FIELDS') {
                $scope.objectId = facetData.objectId;
                $scope.assignedItems = facetData.assignedItems;
                compiledHTML = $compile('<vloc-assign-attrs-fields object-id="objectId" assigned-items="assignedItems"></vloc-assign-attrs-fields>')($scope);
                j$('#facet-detail-content').html(compiledHTML);
            }
            //TODO: change this from vloc-attachment to vloc-object-type
            else if (facetType === 'OBJECT_TYPE') {
                $scope.attachmentItem = facetData.attachmentItem;
                $scope.product = facetData.product;
                compiledHTML = $compile('<vloc-attachment item="attachmentItem" parent-item="product"></vloc-attachment>')($scope);
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
            $scope.getObject($scope.objectClassId);
            $scope.getObjectPicklistsByName($scope.nsp + $scope.OBJECT_NAME);
            $scope.facets = objectTypeService.getFacets();
            if ($scope.facets.length > 0) {
                $scope.gotoFacet($scope.facets[0]);
            }
        };
        $scope.init();
    }
]);

},{}],2:[function(require,module,exports){
angular.module('objecttypeadmin')
.factory('objectTypeService', ['$rootScope',
    function($rootScope) {
        var OBJECTTYPE_FACETS = [
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
                                'Id': 'se4',
                                'Name': 'Parent Object Type',
                                'FieldApiName__c': 'ParentObjectClassId__c',
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
                            'ViewUri__c': 'VlocObjAttrsFields'
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
            }
        ];

        return {
            getFacets: function() {
                var nsp = fileNsPrefix();
                var facets = [];
                var key;
                angular.forEach(OBJECTTYPE_FACETS, function(facet) {
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

},{}],3:[function(require,module,exports){
angular.module('objecttypeadmin', ['vlocity', 'ngSanitize', 'cpqdirectives', 'sldsangular'])
.config(['remoteActionsProvider', function(remoteActionsProvider) {
    remoteActionsProvider.setRemoteActions(window.remoteActions || {});
}])
.config(['$locationProvider', function($locationProvider) {
    $locationProvider.html5Mode(true);
}]);

require('./modules/objecttypeadmin/controller/ObjectTypeAdminController.js');
require('./modules/objecttypeadmin/factory/ObjectTypeService.js');

},{"./modules/objecttypeadmin/controller/ObjectTypeAdminController.js":1,"./modules/objecttypeadmin/factory/ObjectTypeService.js":2}]},{},[3]);

})();