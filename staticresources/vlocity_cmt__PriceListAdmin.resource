(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
angular.module('pricelistadmin')
.controller('PriceListAdminController', ['$scope', '$rootScope', '$location', '$timeout', '$compile', 'remoteActions', 'cpqService',
    function ($scope, $rootScope, $location, $timeout, $compile, remoteActions, cpqService) {
        $scope.OBJECT_NAME = 'PriceList__c';
        $scope.nsp = fileNsPrefix();
        $scope.priceListId = $location.search().id;
        $scope.priceListName = $location.search().name;
        $scope.mode = $location.search().mode;
        $scope.showFacetDetail = false;
        $scope.maximizeFacetDetail = false;
        $scope.facets = [];
        $scope.sectionElementFields = [];
        $scope.objectFields = null;
        $scope.price = {};
        $scope.editObject = {};
        $scope.attrMap = {};
        $scope.attrObjMap = {};
        $scope.attrAssgnObjMap = {};
        $scope.selectedItem = null;

        $scope.$on('showItemDetails', function(event, data) {
            $scope.openFacetDetails(data.facetType, data.facetData);
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
                console.log('getObjectLayoutByName price list results: ', results);
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
                console.log('getObjectLayoutById price list results: ', results);
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
            console.log('FACETS for price list: ', $scope.facets);
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
                    console.log('getObjectFieldsAndLayoutById promotion results:  ', results);
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

        $scope.describeObject = function(objectName) {
            var inputMap = { 'objectName' : objectName };
            remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                console.log('describeObject price list results: ', results);
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

        $scope.getObject = function(priceListId) {
            var inputMap = { 'objectId' : priceListId };
            remoteActions.invokeMethod('getObject', JSON.stringify(inputMap)).then(function(results) {
                console.log('getObject results: ', results);
                $scope.price = results;
                $scope.editObject = {};
                for (var key in $scope.price) {
                    $scope.editObject[key] = $scope.price[key];
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
                console.log('save price list results: ', results);
                $scope.price = {};
                $scope.editObject = {};
                for (var key in results) {
                    if ($scope.objectFields[key] && $scope.objectFields[key].type === 'DATE') {
                        var tzOffset = (window.userTimezoneOffset || window.parent.userTimezoneOffset);
                        $scope.price[key] = results[key] + tzOffset;
                        $scope.editObject[key] = results[key] + tzOffset;
                    } else {
                        $scope.price[key] = results[key];
                        $scope.editObject[key] = results[key];
                    }
                }
                if (event) {
                    event.currentTarget.innerText = originalText;
                    event.currentTarget.disabled = false;
                }
                cpqService.showNotification({
                    type: 'success',
                    content: 'Price List saved!',
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
                    'priceListId': $scope.priceListId,
                    'priceList': $scope.price,
                    'contextCriteriaMode': 'leftPane',
                    'pricingMode': 'PRICELIST',
                    'objectId': $scope.priceListId,
                    'contextRulesMode': 'normal',
                    'objectPricingElements': {
                        'objectId': $scope.priceListId,
                        'objectType': 'PRICELIST',
                        'objectAPIName': 'PriceList__c'
                    }
                }
            };
        };

        $scope.openFacetDetails = function(facetType, facetData) {
            var compiledHTML, directiveHTML;
            if (facetType === 'CONTEXT_RULESET') {
                $scope.contextRuleSet = facetData.contextRuleSet;
                $scope.contextRules = facetData.contextRules;
                $scope.objectId = facetData.objectId;
                $scope.mode = facetData.mode;
                compiledHTML = $compile('<vloc-context-rule-set context-rule-set="contextRuleSet" context-rules="contextRules" object-id="objectId" mode="mode"></vloc-context-rule-set>')($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'PRICELIST_ENTRY') {
                $scope.priceListEntryItem = facetData.priceListEntryItem;
                $scope.pricingMode = facetData.pricingMode;
                $scope.pricingElementObjectType = facetData.pricingElementObjectType;
                $scope.isAdj = facetData.isAdj;
                directiveHTML = '<vloc-price-list-entry object-id="priceListId" price-list-entry-item="priceListEntryItem" pricing-element-object-type="pricingElementObjectType" parent-item="price" pricing-mode="pricingMode" is-adj="isAdj"></vloc-price-list-entry>';
                compiledHTML = $compile(directiveHTML)($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'OBJECT_PRICING_ELEMENT') {
                $scope.pricingElementItem = facetData.pricingElementItem;
                $scope.pricingElementObjectType = facetData.pricingElementObjectType;
                $scope.isGlobal = facetData.isGlobal;
                directiveHTML = '<vloc-object-pricing-element pricing-element-item="pricingElementItem" pricing-element-object-type="pricingElementObjectType" price-list-id="priceListId" is-global="isGlobal"></vloc-object-pricing-element>';
                compiledHTML = $compile(directiveHTML)($scope);
                j$('#facet-detail-content').html(compiledHTML);
            }
            $scope.showFacetDetail = true;
        };

        $scope.closeFacetDetails = function() {
            $scope.maximizeFacetDetail = false;
            $scope.showFacetDetail = false;
            j$('#facet-detail-content').html('');
        };

        $scope.init = function() {
            $scope.getObjectPicklistsByName($scope.nsp + $scope.OBJECT_NAME);

            if ($scope.mode === 'new') {
                $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                $scope.priceListName = 'New Price List';
                $scope.getObjectLayoutByName($scope.OBJECT_NAME, '');
            } else {
                $scope.getObjectFieldsAndLayoutById($scope.priceListId, true);
                $scope.getObject($scope.priceListId);
            }
        };
        $scope.init();
    }
]);

},{}],2:[function(require,module,exports){
angular.module('pricelistadmin')
.directive('vlocPriceListHierarchy', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'PriceListHierarchy.tpl.html',
            controller: function($scope, $rootScope, $sldsModal, $compile) {
                $scope.priceListId = $scope.customViewAttrs.priceListId;
                $scope.priceList = $scope.customViewAttrs.priceList;
                $scope.nsp = fileNsPrefix();
                $scope.sequenceField = $scope.nsp + 'Sequence__c';
                $scope.priceListHierarchy = [];

                $scope.getPriceListHierarchy = function() {
                    var inputMap= { 'priceListId' : $scope.priceListId };
                    remoteActions.invokeMethod('getPriceListHierarchy', JSON.stringify(inputMap)).then(function(results) {
                        $scope.priceListHierarchy = results;
                        console.log('getPriceListHierarchy results: ', results);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.launchTab = function(item, event) {
                    if (event) {
                        event.stopPropagation();
                    }
                    var data = {
                        'objectId': 'pricelist',
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
                    $scope.getPriceListHierarchy();
                };
                $scope.init();
            }
        };
    }
]);

},{}],3:[function(require,module,exports){
angular.module("pricelistadmin").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("PriceListHierarchy.tpl.html",'<div class="vloc-pricelist-hierarchy">\n    <div class="pricelist pricelist-hd slds-clearfix slds-text-heading--label slds-m-bottom--small">\n        <div class="pl-name slds-float--left">Name</div>\n        <div class="pl-description slds-float--right">Description</div>\n        <div class="pl-code slds-float--right">Code</div>\n    </div>\n    <div ng-repeat="wrapper in priceListHierarchy">\n        <div class="pricelist slds-clearfix slds-m-bottom--small">\n            <div class="pl-name slds-float--left">\n                <button class="slds-button slds-button--icon" ng-class="{\'slds-hidden\': !wrapper.children}">\n                    <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'chevrondown\'"></slds-button-svg-icon>\n                    <span class="slds-assistive-text">Collapse</span>\n                </button>\n                <span ng-if="(priceList.Id === wrapper.priceList.Id)" class="slds-m-left--xx-small">{{wrapper.priceList.Name}}</span>\n                <a ng-if="(priceList.Id !== wrapper.priceList.Id)" href="#" class="slds-m-left--xx-small" ng-click="launchTab(wrapper.priceList, event)">{{wrapper.priceList.Name}}</a>\n            </div>\n            <div class="pl-description slds-float--right">{{wrapper.priceList[nsp+\'Description__c\']}}</div>\n            <div class="pl-code slds-float--right">{{wrapper.priceList[nsp+\'Code__c\']}}</div>\n        </div>\n        <div ng-if="wrapper.children">\n            <div ng-repeat="wrapper in wrapper.children | orderBy: \'wrapper.priceList[sequenceField]\'" ng-include="\'pricelist_treeview.tpl.html\'"></li>\n        </div>\n    </div>\n</div>'),$templateCache.put("pricelist_treeview.tpl.html",'<div class="pricelist-child-item slds-p-left--large">\n    <div class="pricelist slds-clearfix slds-m-bottom--small">\n        <div class="pl-name slds-float--left">\n            <button class="slds-button slds-button--icon" ng-class="{\'slds-hidden\': !wrapper.children}">\n                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'chevrondown\'"></slds-button-svg-icon>\n                <span class="slds-assistive-text">Collapse</span>\n            </button>\n            <span ng-if="(priceList.Id === wrapper.priceList.Id)" class="slds-m-left--xx-small">{{wrapper.priceList.Name}}</span>\n            <a ng-if="(priceList.Id !== wrapper.priceList.Id)" href="#" class="slds-m-left--xx-small" ng-click="launchTab(wrapper.priceList, event)">{{wrapper.priceList.Name}}</a>\n        </div>\n        <div class="pl-description slds-float--right">{{wrapper.priceList[nsp+\'Description__c\']}}</div>\n        <div class="pl-code slds-float--right">{{wrapper.priceList[nsp+\'Code__c\']}}</div>\n    </div>\n    <div ng-if="wrapper.children">\n        <div ng-repeat="wrapper in wrapper.children | orderBy: \'wrapper.priceList[sequenceField]\'" ng-include="\'pricelist_treeview.tpl.html\'"></li>\n    </div>\n</div>')}]);
},{}],4:[function(require,module,exports){
angular.module('pricelistadmin', ['vlocity', 'ngSanitize', 'cpqdirectives', 'sldsangular'])
.config(['remoteActionsProvider', function(remoteActionsProvider) {
    remoteActionsProvider.setRemoteActions(window.remoteActions || {});
}])
.config(['$locationProvider', function($locationProvider) {
    $locationProvider.html5Mode(true);
}]);

require('./modules/pricelistadmin/controller/PriceListAdminController.js');
require('./modules/pricelistadmin/directive/VlocPriceListHierarchy.js');
require('./modules/pricelistadmin/templates/templates.js');

},{"./modules/pricelistadmin/controller/PriceListAdminController.js":1,"./modules/pricelistadmin/directive/VlocPriceListHierarchy.js":2,"./modules/pricelistadmin/templates/templates.js":3}]},{},[4]);

})();