(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
angular.module('pricingvariableadmin')
.controller('PricingVariableAdminController', ['$scope', '$rootScope', '$location', '$timeout', '$compile', 'remoteActions', 'cpqService',
    function ($scope, $rootScope, $location, $timeout, $compile, remoteActions, cpqService) {
        $scope.OBJECT_NAME = 'PricingVariable__c';
        $scope.nsp = fileNsPrefix();
        $scope.pricingComponentId = $location.search().id;
        $scope.pricingComponentName = $location.search().name;
        $scope.mode = $location.search().mode;
        $scope.showFacetDetail = false;
        $scope.maximizeFacetDetail = false;
        $scope.facets = [];
        $scope.objectFields = null;
        $scope.price = {};
        $scope.editObject = {};
        $scope.attrMap = {};
        $scope.attrObjMap = {};
        $scope.attrAssgnObjMap = {};
        $scope.selectedItem = null;

        $scope.getObjectLayoutByName = function(objectName, recordType) {
            var inputMap = { 
                'objectName' : objectName,
                'recordType' : recordType
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

        $scope.getObjectLayoutById = function(objectId, forSelf) {
            var inputMap = { 
                'objectId' : objectId,
                'isInherited' : forSelf
            };
            remoteActions.invokeMethod('getObjectLayoutById', JSON.stringify(inputMap)).then(function(results) {
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

        $scope.describeObject = function(objectName) {
            var inputMap = { 'objectName' : objectName };
            remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
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

        $scope.getObject = function(pricingComponentId) {
            var inputMap = { 'objectId' : pricingComponentId };
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
                    content: 'Pricing Variable saved!',
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
                    'objectId': $scope.pricingComponentId
                }
            };
        };

        $scope.init = function() {
            $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
            $scope.getObjectPicklistsByName($scope.nsp + $scope.OBJECT_NAME);

            if ($scope.mode === 'new') {
                $scope.pricingComponentName = 'New Pricing Variable';
                $scope.getObjectLayoutByName($scope.OBJECT_NAME, '');
            } else {
                $scope.getObjectLayoutById($scope.pricingComponentId, true);
                $scope.getObject($scope.pricingComponentId);
            }
        };
        $scope.init();
    }
]);

},{}],2:[function(require,module,exports){
angular.module('pricingvariableadmin', ['vlocity', 'ngSanitize', 'cpqdirectives', 'sldsangular'])
.config(['remoteActionsProvider', function(remoteActionsProvider) {
    remoteActionsProvider.setRemoteActions(window.remoteActions || {});
}])
.config(['$locationProvider', function($locationProvider) {
    $locationProvider.html5Mode(true);
}]);

require('./modules/pricingvariableadmin/controller/PricingVariableAdminController.js');

},{"./modules/pricingvariableadmin/controller/PricingVariableAdminController.js":1}]},{},[2]);

})();