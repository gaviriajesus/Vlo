(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
angular.module('promotionadmin')
.controller('PromotionAdminController', ['$scope', '$rootScope', '$location', '$timeout', '$compile', 'remoteActions', 'cpqService',
    function ($scope, $rootScope, $location, $timeout, $compile, remoteActions, cpqService) {
        $scope.OBJECT_NAME = 'Promotion__c';
        $scope.nsp = fileNsPrefix();
        $scope.promotionId = $location.search().id;
        $scope.promotionName = $location.search().name;
        $scope.mode = $location.search().mode;
        $scope.showFacetDetail = false;
        $scope.maximizeFacetDetail = false;
        $scope.collapseFacetHeader = false;
        $scope.facets = [];
        $scope.sectionElementFields = [];
        $scope.objectFields = null;
        $scope.promotion = {};
        $scope.editObject = {};
        $scope.attrMap = {};
        $scope.attrObjMap = {};
        $scope.attrAssgnObjMap = {};
        $scope.selectedItem = null;

        $scope.$on('refreshItems', function() {
            $scope.init();
        });

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
                console.log('getObjectLayoutByName promotion results: ', results);
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
                console.log('getObjectLayoutById promotion results: ', results);
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
            console.log('FACETS for promotion: ', $scope.facets);
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
                console.log('describeObject promotion results: ', results);
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

        $scope.getObject = function(promotionId) {
            var inputMap = { 'objectId' : promotionId };
            remoteActions.invokeMethod('getObject', JSON.stringify(inputMap)).then(function(results) {
                console.log('getObject results: ', results);
                $scope.promotion = results;
                $scope.editObject = {};
                for (var key in $scope.promotion) {
                    $scope.editObject[key] = $scope.promotion[key];
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
                $scope.closeFacetDetails();

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
                console.log('save promotion results: ', results);
                $scope.promotion = {};
                $scope.editObject = {};
                for (var key in results) {
                    if ($scope.objectFields[key] && $scope.objectFields[key].type === 'DATE') {
                        var tzOffset = (window.userTimezoneOffset || window.parent.userTimezoneOffset);
                        $scope.promotion[key] = results[key] + tzOffset;
                        $scope.editObject[key] = results[key] + tzOffset;
                    } else {
                        $scope.promotion[key] = results[key];
                        $scope.editObject[key] = results[key];
                    }
                }
                if (event) {
                    event.currentTarget.innerText = originalText;
                    event.currentTarget.disabled = false;
                }
                cpqService.showNotification({
                    type: 'success',
                    content: 'Promotion saved!',
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
                    'promotionId': $scope.promotionId,
                    'objectId': $scope.promotionId,
                    'promotion': $scope.promotion,
                    'contextRulesMode': 'normal',
                    'pricingMode': 'PROMOTION'
                }
            };
        };

        $scope.openFacetDetails = function(facetType, facetData) {
            var compiledHTML, directiveHTML;
            if (facetType === 'PROMOTION_PRODUCT') {
                $scope.promoItem = facetData.promotionItem;
                compiledHTML = $compile('<vloc-promotion-product promotion-item="promoItem" parent-item="promotion"></vloc-promotion-product>')($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'CONTEXT_RULESET') {
                $scope.contextRuleSet = facetData.contextRuleSet;
                $scope.contextRules = facetData.contextRules;
                $scope.objectId = facetData.objectId;
                $scope.mode = facetData.mode;
                compiledHTML = $compile('<vloc-context-rule-set context-rule-set="contextRuleSet" context-rules="contextRules" object-id="objectId" mode="mode"></vloc-context-rule-set>')($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'PROD_CHILD_DETAILS') {
                console.log('!!! promoAdmin PROD_CHILD_DETAILS', facetData);
                $scope.rootProductId = facetData.rootProductId;
                $scope.rootProductSpecId = facetData.rootProductSpecId;
                $scope.prodChildItem = facetData.prodChildItem;
                $scope.pricingMode = facetData.pricingMode;
                $scope.promotionId = facetData.promotionId;
                directiveHTML = '<vloc-prod-child-details root-product-id="rootProductId" root-product-spec-id="rootProductSpecId" ' +
                    'prod-child-item="prodChildItem" pricing-mode="pricingMode" promotion-id="promotionId"></vloc-prod-child-details>';
                compiledHTML = $compile(directiveHTML)($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'PRICING_ELEMENT') {
                $scope.pricingElementItem = facetData.pricingElementItem;
                $scope.pricingMode = facetData.pricingMode;
                $scope.isAdj = facetData.isAdj;
                directiveHTML = '<vloc-price-list-entry object-id="promotionId" pricing-element-item="pricingElementItem" parent-item="promotion" pricing-mode="pricingMode" is-adj="isAdj"></vloc-price-list-entry>';
                compiledHTML = $compile(directiveHTML)($scope);
                j$('#facet-detail-content').html(compiledHTML);
            }
            $scope.showFacetDetail = true;
            $scope.collapseFacetHeader = false;
        };

        $scope.closeFacetDetails = function() {
            $scope.maximizeFacetDetail = false;
            $scope.showFacetDetail = false;
            j$('#facet-detail-content').html('');
        };
        $scope.toggleFacetHeader = function() {
            $scope.collapseFacetHeader =  !$scope.collapseFacetHeader;
        };
        $scope.init = function() {
            $scope.getObjectPicklistsByName($scope.nsp + $scope.OBJECT_NAME);

            if ($scope.mode === 'new') {
                $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                $scope.promotionName = 'New Promotion';
                $scope.getObjectLayoutByName($scope.OBJECT_NAME, '');
            } else {
                $scope.getObjectFieldsAndLayoutById($scope.promotionId, true);
                $scope.getObject($scope.promotionId);
            }
        };
        $scope.init();
    }
]);

},{}],2:[function(require,module,exports){
angular.module('promotionadmin')
.directive('vlocProductAdjustments', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ProductAdjustments.tpl.html',
            controller: function($scope, $rootScope) {
                $scope.promotion = $scope.customViewAttrs.promotion;
                $scope.promotionId = $scope.customViewAttrs.promotionId;
                $scope.pricingMode = $scope.customViewAttrs.pricingMode;
                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = 'PromotionItem__c';
                $scope.fieldSetName = 'promotionitem';
                $scope.promotionItemMap = {};
                $scope.productList = [];
                $scope.selectedProductId = '';

                $scope.describeObject = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('vlocPromotionProducts - describeObject results: ', results);
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
                        if (results[$scope.nsp.toLowerCase() + $scope.fieldSetName] === undefined) {
                            $scope.fieldSet = null;
                        } else {
                            $scope.fieldSet = results[$scope.nsp.toLowerCase() + $scope.fieldSetName];
                        }
                        console.log('vlocPromotionProducts - getFieldSets results: ', $scope.fieldSet);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.$on('refreshPromoItems', function(event, data) {
                    $scope.getApplicableProducts();
                });

                $scope.getApplicableProducts = function() {
                    $scope.promotionItemMap = {};
                    var rootProductIds = [];

                    var inputMap = {
                        'promotionId': $scope.promotionId,
                        'mode': 'ITEMS_ONLY'
                    };
                    remoteActions.invokeMethod('getPromotionItems', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getPromotionApplicableProducts results: ', results);
                        angular.forEach(results, function(item) {
                            var itemProductId = item[$scope.nsp + 'ProductId__c'];
                            rootProductIds.push(itemProductId);
                            $scope.promotionItemMap[itemProductId] = item;
                        });
                        $scope.getRootProducts(rootProductIds);
                        console.log('$scope.promotionItemMap:', $scope.promotionItemMap);
                        console.log('rootProductIds:', rootProductIds);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getRootProducts = function(rootProductIds) {
                    $scope.productList = [];
                    var inputMap = {
                        'productIds': rootProductIds,
                        'pageNumber': 1,
                        'pageSize': null
                    };
                    remoteActions.invokeMethod('getProductHierarchy', JSON.stringify(inputMap)).then(function(results) {
                        angular.forEach(results.productList, function(item, idx) {
                            var promoItem = $scope.promotionItemMap[item.productId];
                            item.rootIndex = (idx + 1) + '.';
                            item.level = 1;
                            item.isRoot = true;
                            item.show = true;
                            item.showChildren = false;
                            item.fetchedChildren = true;
                            item.isPromoItem = true;
                            item.promotionItemSO = promoItem;
                            item.rootProductId = (promoItem[$scope.nsp+'OfferId__c'] || item.productId);
                            $scope.productList.push(item);
                            angular.forEach(item.children, function(child) {
                                if (child.pciSO && child.pciSO[$scope.nsp+'IsRootProductChildItem__c']) {
                                    item.cardinalitySO = child.pciSO;
                                } else {
                                    child.rootIndex = '';
                                    child.level = item.level + 1;
                                    child.isRoot = false;
                                    child.show = false;
                                    child.showChildren = false;
                                    child.fetchedChildren = false;
                                    child.isPromoItem = false;
                                    child.promotionItemSO = item.promotionItemSO;
                                    child.rootProductId = item.rootProductId;
                                    $scope.productList.push(child);
                                }
                            });
                            if (item.childrenInfo.currentPage < item.childrenInfo.totalPages) {
                                var loadMoreItem = {'show': false, 'loadMore': true, 'level': (item.level + 1), 'parentItem': item};
                                item.children.push(loadMoreItem);
                                $scope.productList.push(loadMoreItem);
                            }
                        });
                        console.log('getProductHierarchy ROOT: ', $scope.productList);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.toggleItem = function(parentItem, parentItemIdx, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    if (parentItem.showChildren) {
                        $scope.toggleItemVisibility(parentItem, false);
                    } else {
                        if (parentItem.fetchedChildren) {
                            // children already fetched, simply toggle visibility
                            $scope.toggleItemVisibility(parentItem, true);
                        } else {
                            // fetch children
                            $scope.getProductChildren(parentItem, parentItemIdx, 1);
                        }
                    }
                };

                $scope.toggleItemVisibility = function(parentItem, visible) {
                    parentItem.showChildren = visible;
                    angular.forEach(parentItem.children, function(item, idx) {
                        item.show = visible;
                        if (!visible && item.children) {
                            $scope.toggleItemVisibility(item, visible);
                        }
                    });
                };

                $scope.getProductChildren = function(parentItem, parentItemIdx, pageNumber) {
                    var inputMap = {
                        'productIds': [parentItem.productId],
                        'pageNumber': pageNumber,
                        'pageSize': null
                    };
                    remoteActions.invokeMethod('getProductHierarchy', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getProductHierarchy results: ', results);
                        if (pageNumber === 1) {
                            parentItem.children = [];
                            parentItemIdx++;
                        } else {
                            $scope.productList.splice(parentItemIdx, 1);
                            parentItem.children.pop();
                        }

                        if (results.productList && results.productList.length > 0) {
                            var cardinalityObjOffset = 0;
                            angular.forEach(results.productList[0].children, function(item, idx) {
                                if (item.pciSO && item.pciSO[$scope.nsp+'IsRootProductChildItem__c']) {
                                    parentItem.cardinalitySO = item.pciSO;
                                    cardinalityObjOffset++;
                                } else {
                                    item.rootIndex = '';
                                    item.level = parentItem.level + 1;
                                    item.isRoot = false;
                                    item.show = true;
                                    item.showChildren = false;
                                    item.fetchedChildren = false;
                                    item.isPromoItem = false;
                                    item.promotionItemSO = parentItem.promotionItemSO;
                                    item.rootProductId = parentItem.rootProductId;
                                    parentItem.children.push(item);
                                    $scope.productList.splice((parentItemIdx + idx - cardinalityObjOffset), 0, item);
                                }
                            });
                            parentItem.childrenInfo = results.productList[0].childrenInfo;
                            if (parentItem.childrenInfo.currentPage < parentItem.childrenInfo.totalPages) {
                                var loadMoreItem = {'show': true, 'loadMore': true, 'level': (parentItem.level + 1), 'parentItem': parentItem};
                                parentItem.children.push(loadMoreItem);
                                $scope.productList.splice((parentItemIdx + results.productList.length + 1), 0, loadMoreItem);
                            }
                        }
                        parentItem.showChildren = true;
                        parentItem.fetchedChildren = true;
                        console.log('getProductChildren: ', $scope.productList);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.selectItem = function(item, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    $scope.selectedProductId = item.productId;
                    var broadcastData = {
                        facetType: 'PROD_CHILD_DETAILS',
                        facetData: {
                            promotionId: $scope.promotionId,
                            rootProductId: item.rootProductId,
                            prodChildItem: item,
                            pricingMode: $scope.pricingMode
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
                };

                $scope.$on('hideItemDetails', function() {
                    $scope.selectedProductId = '';
                });

                $scope.init = function() {
                    $scope.getApplicableProducts();
                    $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                    $scope.getFieldSetsByName($scope.nsp + $scope.OBJECT_NAME);
                };
                $scope.init();
            }
        };
    }
]);

},{}],3:[function(require,module,exports){
angular.module('promotionadmin')
.directive('vlocPromotionProduct', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                promotionItem: '=',
                parentItem: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'PromotionProduct.tpl.html',
            controller: function($scope, $rootScope) {
                $scope.nsp = fileNsPrefix();
                $scope.items = [];
                $scope.OBJECT_NAME = 'PromotionItem__c';
                $scope.editItem = {};
                $scope.facets = [];

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
                    $scope.editItem[$scope.nsp + 'PromotionId__c'] = $scope.parentItem.Id;

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
                    remoteActions.invokeMethod('createPromotionItem', JSON.stringify(inputMap)).then(function(results) {
                        console.log('create promo item results: ', results);
                        $rootScope.$broadcast('refreshPromoItems', $scope.parentItem.Id);
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
                    remoteActions.invokeMethod('updatePromotionItem', JSON.stringify(inputMap)).then(function(results) {
                        console.log('save promo item results: ', results);
                        $rootScope.$broadcast('refreshPromoItems', $scope.parentItem.Id);
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
                    $scope.getObjectLayoutByName($scope.OBJECT_NAME, '');
                    $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                    $scope.getObjectPicklistsByName($scope.nsp + $scope.OBJECT_NAME);

                    if ($scope.promotionItem.Id !== undefined) {
                        for (var key in $scope.promotionItem) {
                            if (key !== '$$hashKey') {
                                $scope.editItem[key] = $scope.promotionItem[key];
                            }
                        }
                    }
                };
                $scope.init();
            }
        };
    }
]);

},{}],4:[function(require,module,exports){
angular.module('promotionadmin')
.directive('vlocPromotionProducts', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'PromotionProducts.tpl.html',
            controller: function($scope, $rootScope, $sldsModal, $compile) {
                $scope.promotion = $scope.customViewAttrs.promotion;
                $scope.promotionId = $scope.customViewAttrs.promotionId;
                $scope.nsp = fileNsPrefix();
                $scope.OBJECT_NAME = 'PromotionItem__c';
                $scope.fieldSetName = 'promotionitem';
                $scope.items = [];

                $scope.describeObject = function(objectName) {
                    var inputMap = { 'objectName' : objectName };
                    remoteActions.invokeMethod('describeObject', JSON.stringify(inputMap)).then(function(results) {
                        console.log('vlocPromotionProducts - describeObject results: ', results);
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
                        if (results[$scope.nsp.toLowerCase() + $scope.fieldSetName] === undefined) {
                            $scope.fieldSet = null;
                        } else {
                            $scope.fieldSet = results[$scope.nsp.toLowerCase() + $scope.fieldSetName];
                        }
                        console.log('vlocPromotionProducts - getFieldSets results: ', $scope.fieldSet);
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.$on('refreshPromoItems', function(event, data) {
                    $scope.getApplicableProducts();
                });

                $scope.getApplicableProducts = function() {
                    var inputMap = {
                        'promotionId' : $scope.promotionId,
                        'mode' : 'ITEMS_ONLY'
                    };
                    remoteActions.invokeMethod('getPromotionItems', JSON.stringify(inputMap)).then(function(results) {
                        console.log('getPromotionApplicableProducts results: ', results);
                        $scope.items = results;
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.selectItem = function(item) {
                    console.log('selectItem item: ', item);
                    var broadcastData = {
                        facetType: 'PROMOTION_PRODUCT',
                        facetData: {
                            promotionItem: item
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
                };

                $scope.deleteItem = function(item, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    var modalScope = $scope.$new();
                    modalScope.confirmationTitle = 'Delete Promotion Item';
                    modalScope.confirmationMsg = 'Are you sure you want to delete the Promotion Item <i>' + item.Name + '</i>?';
                    modalScope.cancelActionLbl = 'Cancel';
                    modalScope.confirmActionLbl = 'Delete Promotion Item';
                    modalScope.confirmAction = function() {
                        var itemToDelete = {};
                        for (var key in item) {
                            if (key !== '$$hashKey') {
                                itemToDelete[key] = item[key];
                            }
                        }
                        var inputMap = { 'objectId' : itemToDelete.Id };
                        remoteActions.invokeMethod('deleteObject', JSON.stringify(inputMap)).then(function(results) {
                            console.log('delete Promotion Item results: ', results);
                            $rootScope.$broadcast('hideItemDetails');
                            $rootScope.$broadcast('refreshPromoItems', $scope.customViewAttrs.objectId);
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
                    $scope.selectItem({});
                };

                $scope.init = function() {
                    $scope.getApplicableProducts();
                    $scope.describeObject($scope.nsp + $scope.OBJECT_NAME);
                    $scope.getFieldSetsByName($scope.nsp + $scope.OBJECT_NAME);
                };
                $scope.init();
            }
        };
    }
]);

},{}],5:[function(require,module,exports){
angular.module("promotionadmin").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("ProductAdjustments.tpl.html",'<div class="vloc-product-adjustments">\n    <h3 class="slds-text-heading--small">Product Adjustments</h3>\n    <div class="slds-scrollable--x">\n        <table class="slds-table slds-table--bordered slds-tree slds-table--tree promotion-items" role="treegrid" aria-readonly="true">\n            <thead>\n                <tr class="slds-text-heading--label">\n                    <th class="promo-idx" scope="col"></th>\n                    <th class="promo-actiontype" scope="col">Action</th>\n                    <th class="slds-cell-buffer--left product-name" scope="col"><div class="slds-truncate">Product</div></th>\n                    <th class="promo-pci" scope="col">Min, Max, Default</th>\n                    <th class="promo-offer" scope="col">Offer</th>\n                </tr>\n            </thead>\n            <tbody>\n                <tr ng-class="{\'slds-hint-parent\': true, \'is-not-promo-item\': !item.isPromoItem, \'slds-is-selected\': (item.productId === selectedProductId)}" role="row" ng-repeat="item in productList" ng-if="item.show" ng-click="selectItem(item, $event)" aria-level="{{item.level}}">\n                    <td class="promo-idx">{{item.rootIndex}}</td>\n                    <td class="promo-actiontype" ng-init="f2 = nsp + \'ActionType__c\'">\n                        <vloc-obj-field ng-if="item.isPromoItem" display-mode="\'view\'" parent-obj="item.promotionItemSO" field-name="f2" field-info="objectFields[f2]" obj-picklists="objectPicklists[f2.toLowerCase()]"></vloc-obj-field>\n                        <span ng-if="!item.isPromoItem">&nbsp;</span>\n                    </td>\n                    <td ng-if="!item.loadMore" scope="row" class="slds-tree__item product-name">\n                        <button class="slds-button slds-button--icon slds-m-right--x-small" ng-class="{\'slds-hidden\': item.isLeaf}" title="Toggle" ng-click="toggleItem(item, $index, $event)">\n                            <slds-button-svg-icon ng-if="!item.showChildren" sprite="\'utility\'" size="\'small\'" icon="\'chevronright\'"></slds-button-svg-icon>\n                            <slds-button-svg-icon ng-if="item.showChildren" sprite="\'utility\'" size="\'small\'" icon="\'chevrondown\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Toggle</span>\n                        </button>\n                        <div class="slds-truncate" title="{{rootProduct}}">{{item.productSO.Name}}</div>\n                    </td>\n                    <td ng-if="item.loadMore" scope="row" class="slds-tree__item product-name">\n                        <button class="slds-button slds-button--icon slds-m-right--x-small slds-hidden" title="Toggle">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'chevrondown\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Toggle</span>\n                        </button>\n                        <div class="slds-truncate"><a href="javascript:void(0)" ng-click="getProductChildren(item.parentItem, $index, item.parentItem.childrenInfo.nextPage)">Load more..</a></div>\n                    </td>\n                    <td class="promo-pci">\n                        <span ng-if="item.pciSO">{{item.pciSO[nsp+\'MinMaxDefaultQty__c\']}}</span>\n                        <span ng-if="!item.pciSO">&nbsp;</span>\n                    </td>\n                    <td class="promo-offer" ng-init="f1 = nsp + \'OfferId__c\'">\n                        <vloc-obj-field ng-if="item.isPromoItem" display-mode="\'view\'" parent-obj="item.promotionItemSO" field-name="f1" field-info="objectFields[f1]" obj-picklists="objectPicklists[f1.toLowerCase()]"></vloc-obj-field>\n                        <span ng-if="!item.isPromoItem">&nbsp;</span>\n                    </td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n</div>'),$templateCache.put("PromotionProduct.tpl.html",'<div class="vloc-promotion-product">\n    <div ng-if="selectObjectType" class="slds-form--inline">\n        <div class="slds-form-element">\n            <label class="slds-form-element__label" for="objectType">Object Type</label>\n            <div class="slds-form-element__control">\n                <select ng-options="option.label for option in objectTypes track by option.value" ng-model="editItem.objectType" class="slds-select"></select>\n            </div>\n        </div>\n        <div class="slds-form-element">\n            <label class="slds-form-element__label" for="objectType"></label>\n            <div class="slds-form-element__control">\n                <button type="button" class="slds-button slds-button--neutral" ng-click="setObjectType($event)">Next</button>\n            </div>\n        </div>\n    </div>\n    <div ng-repeat="facet in facets">\n        <h2 class="slds-text-heading--small" ng-if="facets.length > 1">{{facet.facetObj.Name}}</h2>\n        <section class="vloc-section" ng-repeat="section in facet.sections">\n            <h3 class="slds-text-heading--label">{{section.sectionObj.Name}}</h3>\n            <div class="vloc-section-body">\n                <div ng-if="!section.hasCustomView" class="slds-form--horizontal">\n                    <div class="slds-form-element" ng-repeat="sectionEl in section.sectionElements" ng-init="fieldName = sectionEl[nsp+\'FieldApiName__c\']; fieldName = (fieldName.endsWith(\'__c\') ? nsp+fieldName : fieldName);">\n                        <label class="slds-form-element__label" for="{{objectFields[fieldName].label}}">{{sectionEl.Name}}</label>\n                        <div class="slds-form-element__control">\n                            <div ng-switch="sectionEl[nsp+\'Type__c\']">\n                                <div ng-switch-when="Field">\n                                    <vloc-obj-field display-mode="\'edit\'" parent-obj="editItem" field-name="fieldName" field-info="objectFields[fieldName]" obj-picklists="objectPicklists[fieldName.toLowerCase()]"></vloc-obj-field>\n                                </div>\n                                <div ng-switch-when="Attribute">\n                                    <vloc-attribute attribute-id="sectionEl[nsp+\'AttributeId__c\']" object-id="promotionItem.Id" attr-map="attrMap" attr-obj="null" attr-assgn-obj="null" picklist-items="null"></vloc-attribute>\n                                </div>\n                                <div ng-switch-when="Custom View">\n                                    Something is wrong!\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </section>\n        <div class="slds-form-element__row form-buttons slds-text-align--right">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="closeDetails()">Cancel</button>\n            <button type="button" class="slds-button slds-button--brand" ng-if="promotionItem.Id === undefined" ng-click="createItem($event)">Save</button>\n            <button type="button" class="slds-button slds-button--brand" ng-if="promotionItem.Id !== undefined" ng-click="saveItem($event)">Save</button>\n        </div>\n    </div>\n</div>'),$templateCache.put("PromotionProducts.tpl.html",'<div class="vloc-promotion-products">\n    <h3 class="slds-text-heading--small">Promotion Products</h3>\n    <div class="vloc-section-actions">\n        <button type="button" class="slds-button slds-button--neutral" ng-click="newItem($event)">New Promotion Product</button>\n    </div>\n    <div class="slds-scrollable--x">\n        <table class="slds-table slds-table--bordered items">\n            <thead>\n                <tr class="slds-text-heading--label">\n                    <th class="actions"><div class="slds-truncate">&nbsp;</div></th>\n                    <th ng-repeat="field in fieldSet">\n                        <div class="slds-truncate">{{objectFields[field.fieldPath].label}}</div>\n                    </th>\n                </tr>\n            </thead>\n            <tbody>\n                <tr ng-class="{\'slds-is-selected\': (item.Id === selectedItem.Id)}" ng-repeat="item in items" ng-click="selectItem(item)">\n                    <td class="actions">\n                        <button class="slds-button slds-button--icon" ng-click="editItem(item, $event)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'edit\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Edit</span>\n                        </button>\n                        <button class="slds-button slds-button--icon" ng-click="deleteItem(item, $event)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Delete</span>\n                        </button>\n                    </td>\n                    <td ng-repeat="field in fieldSet">\n                        <vloc-obj-field display-mode="\'view\'" parent-obj="item" field-name="field.fieldPath" field-info="objectFields[field.fieldPath]" obj-picklists=""></vloc-obj-field>\n                    </td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n</div>')}]);
},{}],6:[function(require,module,exports){
angular.module('promotionadmin', ['vlocity', 'ngSanitize', 'cpqdirectives', 'sldsangular'])
.config(['remoteActionsProvider', function(remoteActionsProvider) {
    remoteActionsProvider.setRemoteActions(window.remoteActions || {});
}])
.config(['$locationProvider', function($locationProvider) {
    $locationProvider.html5Mode(true);
}]);

require('./modules/promotionadmin/controller/PromotionAdminController.js');
require('./modules/promotionadmin/directive/VlocProductAdjustments.js');
require('./modules/promotionadmin/directive/VlocPromotionProduct.js');
require('./modules/promotionadmin/directive/VlocPromotionProducts.js');
require('./modules/promotionadmin/templates/templates.js');

},{"./modules/promotionadmin/controller/PromotionAdminController.js":1,"./modules/promotionadmin/directive/VlocProductAdjustments.js":2,"./modules/promotionadmin/directive/VlocPromotionProduct.js":3,"./modules/promotionadmin/directive/VlocPromotionProducts.js":4,"./modules/promotionadmin/templates/templates.js":5}]},{},[6]);

})();