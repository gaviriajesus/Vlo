(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
angular.module('productadmin')
.controller('ProductAdminController', ['$scope', '$rootScope', '$location', '$timeout', '$compile', 'remoteActions', '$q', 'cpqService',
    function ($scope, $rootScope, $location, $timeout, $compile, remoteActions, $q, cpqService) {
        $scope.OBJECT_NAME = 'Product2';
        $scope.nsp = fileNsPrefix();
        $scope.productId = $location.search().id;
        $scope.productName = $location.search().name;
        $scope.productSpecId = $location.search().productSpecId;
        $scope.showFacetDetail = false;
        $scope.maximizeFacetDetail = false;
        $scope.collapseFacetHeader = false;
        $scope.facets = [];
        $scope.sectionElementFields = [];
        $scope.objectFields = null;
        $scope.objectPicklists = {};
        $scope.product = {};
        $scope.editObject = {};
        $scope.attrMap = {};
        $scope.attrObjMap = {};
        $scope.attrAssgnObjMap = {};
        $scope.cfg = {};
        $scope.cfg.showProductImage = (window.showProductImage || window.parent.showProductImage);

        $scope.$on('refreshItems', function() {
            $scope.getAttachments($scope.productId);
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
                console.log('getObjectLayoutByName product results: ', results);
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
                console.log('getObjectLayoutById product results: ', results);
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
                                if (sectionElement[$scope.nsp + 'Type__c'] === 'Attribute') {
                                    var attrId = sectionElement[$scope.nsp+'AttributeId__c'];
                                    $scope.attrObjMap[attrId] = null;
                                    $scope.attrAssgnObjMap[attrId] = null;
                                }
                            });
                        }
                    });
                    $scope.facets.push(facet);
                });
            }
        };

        //Make sure layout section elements gets returned before describeObject gets called
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
                $scope.product = results;
                $scope.editObject = {};
                for (var key in $scope.product) {
                    $scope.editObject[key] = $scope.product[key];
                }
            }, function(error) {
                cpqService.showNotification({
                    type: 'error',
                    title: 'Error',
                    content: error.message
                });
            });
        };

        $scope.getAttachments = function(productId) {
            var inputMap = { 'objectId' : productId };
            remoteActions.invokeMethod('getAttachments', JSON.stringify(inputMap)).then(function(results) {
                console.log('getAttachments results: ', results);
                $scope.attachments = results;
                $rootScope.$broadcast('setItems', $scope.attachments);
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
                    if ($scope.editObject[key] !== null) {
                        itemToSave[key] = $scope.editObject[key];
                    } else {
                        itemToSave[key] = undefined;
                    }
                }
            }

            var inputMap = { 'so' : JSON.stringify(itemToSave) };
            remoteActions.invokeMethod('updateObject', JSON.stringify(inputMap)).then(function(results) {
                console.log('save product results: ', results);
                $scope.product = {};
                var key;
                for (key in results) {
                    if ($scope.objectFields[key] && $scope.objectFields[key].type === 'DATE') {
                        var tzOffset = (window.userTimezoneOffset || window.parent.userTimezoneOffset);
                        $scope.product[key] = results[key] + tzOffset;
                    } else {
                        $scope.product[key] = results[key];
                    }
                }
                if (event) {
                    event.currentTarget.innerText = originalText;
                    event.currentTarget.disabled = false;
                }

                // save attribute assignments
                var attrAssgnPromises = [];
                for (key in $scope.attrAssgnObjMap) {
                    var attrAssignItem = $scope.attrAssgnObjMap[key];
                    if (attrAssignItem) {
                        var attrAssgnObj = {};
                        for (var k in attrAssignItem) {
                            attrAssgnObj[k] = attrAssignItem[k];
                        }
                        if (attrAssgnObj[$scope.nsp+'ValueDataType__c'] === 'Checkbox' && attrAssgnObj[$scope.nsp+'Value__c'] !== undefined) {
                            attrAssgnObj[$scope.nsp+'Value__c'] += '';
                        }
                        attrAssgnPromises.push($scope.saveAttributeAssignmentPromise(attrAssgnObj));
                    }
                }
                if (attrAssgnPromises.length > 0) {
                    $q.all(attrAssgnPromises).then(function(data) {
                        console.log('saveAttributeAssignmentPromise executed: ', data);
                        // publish product
                        var inputMap = { 'productId' : $scope.productId };
                        remoteActions.invokeMethod('publishProduct', JSON.stringify(inputMap)).then(function(response) {
                            console.log('publishProduct executed: ', response);
                        });
                    });
                }
                cpqService.showNotification({
                    type: 'success',
                    content: 'Product saved!',
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

        $scope.saveAttributeAssignmentPromise = function(attrAssgnObj) {
            var deferred = $q.defer();
            var inputMap = { 'so' : JSON.stringify(attrAssgnObj) };
            remoteActions.invokeMethod('saveAttributeAssignment', JSON.stringify(inputMap)).then(function(response) {
                deferred.resolve(response);
            }, function(error) {
                cpqService.showNotification({
                    type: 'error',
                    title: 'Error',
                    content: error.message
                });
            });
            return deferred.promise;
        };

        $scope.showAttributeMetadata = function(attrId) {
            var metatdata = {
                objectId: $scope.productId,
                attrObj: $scope.attrMap[attrId].attrObj,
                attrAssgnObj: null,
                mode: 'edit'
            };
            $scope.openFacetDetails('ATTR_METADATA', metatdata);
        };

        $scope.openFacetDetails = function(facetType, facetData) {
            var compiledHTML, directiveHTML;
            if (facetType === 'ATTACHMENT_ITEM') {
                $scope.attachmentItem = facetData.attachmentItem;
                compiledHTML = $compile('<vloc-attachment item="attachmentItem" parent-item="product"></vloc-attachment>')($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'CONTEXT_RULESET') {
                $scope.contextRuleSet = facetData.contextRuleSet;
                $scope.contextRules = facetData.contextRules;
                $scope.objectId = facetData.objectId;
                $scope.mode = facetData.mode;
                compiledHTML = $compile('<vloc-context-rule-set context-rule-set="contextRuleSet" context-rules="contextRules" object-id="objectId" mode="mode"></vloc-context-rule-set>')($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'ASSIGN_ATTRS_FIELDS') {
                $scope.objectId = facetData.objectId;
                $scope.assignedItems = facetData.assignedItems;
                compiledHTML = $compile('<vloc-assign-attrs-fields object-id="objectId" assigned-items="assignedItems"></vloc-assign-attrs-fields>')($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'ATTR_METADATA') {
                $scope.objectId = facetData.objectId;
                $scope.attrObj = facetData.attrObj;
                $scope.attrAssgnObj = facetData.attrAssgnObj;
                $scope.mode = facetData.mode;
                $scope.rootProductId = facetData.rootProductId;
                $scope.prodChildItemObj = facetData.prodChildItemObj;
                $scope.isProduct = true;
                directiveHTML = '<vloc-attribute-metadata object-id="objectId" attr-obj="attrObj" attr-assgn-obj="attrAssgnObj" ' +
                    'mode="mode" root-product-id="rootProductId" prod-child-item-obj="prodChildItemObj" ' +
                    'attr-assgn-override-obj="null" attr-override-def-obj="null" is-product="isProduct"></vloc-attribute-metadata>';
                compiledHTML = $compile(directiveHTML)($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'FIELD_METADATA') {
                $scope.objectName = facetData.objectName;
                $scope.fieldName = facetData.fieldName;
                compiledHTML = $compile('<vloc-field-metadata object-name="objectName" field-name="fieldName"></vloc-field-metadata>')($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'PROD_CHILD_ITEM') {
                $scope.mode = facetData.mode;
                $scope.parentProductId = facetData.parentProductId;
                $scope.rootProductId = facetData.rootProductId;
                $scope.rootProductSpecId = facetData.rootProductSpecId;
                $scope.prodObj = facetData.prodObj;
                $scope.prodChildItemObj = facetData.prodChildItemObj;
                directiveHTML = '<vloc-prod-child-item mode="mode" parent-product-id="parentProductId" root-product-id="rootProductId" root-product-spec-id="rootProductSpecId" ' +
                    'prod-obj="prodObj" prod-child-item-obj="prodChildItemObj"></vloc-prod-child-item>';
                compiledHTML = $compile(directiveHTML)($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'PROD_CHILD_DETAILS') {
                $scope.rootProductId = facetData.rootProductId;
                $scope.prodChildItem = facetData.prodChildItem;
                $scope.pricingMode = facetData.pricingMode;
                directiveHTML = '<vloc-prod-child-details root-product-id="rootProductId" prod-child-item="prodChildItem" pricing-mode="pricingMode"></vloc-prod-child-details>';
                compiledHTML = $compile(directiveHTML)($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'PROD_PRICING_COMPONENT') {
                $scope.productId = facetData.productId;
                $scope.offerPricingItem = facetData.offerPricingItem;
                $scope.mode = facetData.mode;
                $scope.rootProductId = facetData.rootProductId;
                directiveHTML = '<vloc-offer-pricing-component offer-id="productId" offer-pricing-item="offerPricingItem" mode="mode" root-product-id="rootProductId"></vloc-offer-pricing-component>';
                compiledHTML = $compile(directiveHTML)($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'LAYOUT_ELEMENT') {
                $scope.objectId = facetData.objectId;
                $scope.elementObj = facetData.elementObj;
                $scope.objectName = facetData.objectName;
                $scope.objectLayoutId = facetData.objectLayoutId;
                $scope.objectFacetId = facetData.objectFacetId;
                $scope.objectSectionId = facetData.objectSectionId;
                directiveHTML = '<vloc-layout-element item="elementObj" layout-id="objectLayoutId" ' +
                    'facet-id="objectFacetId" section-id="objectSectionId" object-name="objectName"></vloc-layout-element>';
                compiledHTML = $compile(directiveHTML)($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'PRICING_ELEMENT') {
                $scope.pricingElementItem = facetData.pricingElementItem;
                $scope.pricingMode = facetData.pricingMode;
                $scope.isAdj = facetData.isAdj;
                directiveHTML = '<vloc-price-list-entry object-id="objectId" pricing-element-item="pricingElementItem" parent-item="product" pricing-mode="pricingMode" is-adj="isAdj"></vloc-price-list-entry>';
                compiledHTML = $compile(directiveHTML)($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'PROD_PRICING_ELEMENT') {
                $scope.rootProductId = facetData.rootProductId;
                $scope.rootProductSpecId = facetData.rootProductSpecId;
                $scope.prodChildItem = facetData.prodChildItem;
                $scope.pricingElementItem = facetData.pricingElementItem;
                $scope.pricingMode = facetData.pricingMode;
                $scope.isAdj = facetData.isAdj;
                directiveHTML = '<vloc-product-pricing object-id="objectId" pricing-element-item="pricingElementItem" parent-item="product" pricing-mode="pricingMode" is-adj="isAdj"></vloc-product-pricing>';
                compiledHTML = $compile(directiveHTML)($scope);
                j$('#facet-detail-content').html(compiledHTML);
            } else if (facetType === 'PRICELIST_ENTRY') {
                $scope.priceListEntryItem = facetData.priceListEntryItem;
                $scope.pricingMode = facetData.pricingMode;
                $scope.pricingElementObjectType = facetData.pricingElementObjectType;
                $scope.isAdj = facetData.isAdj;
                directiveHTML = '<vloc-price-list-entry object-id="productId" price-list-entry-item="priceListEntryItem" pricing-element-object-type="pricingElementObjectType" parent-item="product" pricing-mode="pricingMode" is-adj="isAdj"></vloc-price-list-entry>';
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
        $scope.setupViewAttrs = function(section) {
            return {
                'name': section.facetSectionObj[$scope.nsp + 'ViewUri__c'],
                'attrs': {
                    'objectId': $scope.product.Id,
                    'productName': $scope.productName,
                    'productSpecId': $scope.productSpecId,
                    'objName': 'VlocityAttachment__c',
                    'items': $scope.attachments,
                    'contextRulesMode': 'normal',
                    'productObj': $scope.product,
                    'pricingMode': 'PRODUCT'
                }
            };
        };

        $scope.init = function() {
            $scope.closeFacetDetails();
            $scope.getObjectFieldsAndLayoutById($scope.productId, true);
            $scope.getObjectPicklistsByName($scope.OBJECT_NAME);
            $scope.getObject($scope.productId);
            $scope.getAttachments($scope.productId);
        };
        $scope.init();
    }
]);

},{}],2:[function(require,module,exports){
angular.module('productadmin')
.directive('vlocProductStructure', ['remoteActions', 'cpqService',
    function(remoteActions, cpqService) {
        return {
            scope: {
                customViewAttrs: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: 'ProductStructure.tpl.html',
            controller: function($scope, $rootScope, $sldsModal, $compile) {
                $scope.nsp = fileNsPrefix();
                $scope.productId = $scope.customViewAttrs.objectId;
                $scope.productSpecId = $scope.customViewAttrs.productSpecId;
                $scope.productName = $scope.customViewAttrs.productName;
                $scope.productList = [];
                $scope.selectedProductId = '';
                $scope.showChildDetails = false;
                $scope.pricingMode = $scope.customViewAttrs.pricingMode;
                $scope.attrOverrideMap = {};
                $scope.pricingOverrideMap = {};
                $scope.pciOverrideMap = {};

                $scope.$on('refreshProductChildren', function(event, data) {
                    $scope.refreshProductChildren(data.productId);
                });

                $scope.getFieldSets = function() {
                    var inputMap = { 'objectName' : 'Product2' };
                    remoteActions.invokeMethod('getFieldSetsByName', JSON.stringify(inputMap)).then(function(results) {
                        if (results[$scope.nsp.toLowerCase() + 'productstructure'] === undefined) {
                            $scope.prodFieldSet = null;
                        } else {
                            $scope.prodFieldSet = results[$scope.nsp.toLowerCase() + 'productstructure'];
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                    var inputMap2 = { 'objectName' : $scope.nsp + 'ProductChildItem__c' };
                    remoteActions.invokeMethod('getFieldSetsByName', JSON.stringify(inputMap2)).then(function(results) {
                        if (results[$scope.nsp.toLowerCase() + 'productstructure'] === undefined) {
                            $scope.prodChildFieldSet = null;
                        } else {
                            $scope.prodChildFieldSet = results[$scope.nsp.toLowerCase() + 'productstructure'];
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.getRootProduct = function(rootProductId) {
                    $scope.productList = [];
                    var inputMap = {
                        'productIds': [rootProductId],
                        'pageNumber': 1,
                        'pageSize': null
                    };
                    remoteActions.invokeMethod('getProductHierarchy', JSON.stringify(inputMap)).then(function(results) {
                        angular.forEach(results.productList, function(item, idx) {
                            item.level = 1;
                            item.isRoot = true;
                            item.show = true;
                            item.showChildren = true;
                            item.fetchedChildren = true;
                            $scope.productList.push(item);
                            var pciIds = [];
                            angular.forEach(item.children, function(child) {
                                if (child.pciSO && child.pciSO[$scope.nsp+'IsRootProductChildItem__c']) {
                                    item.cardinalitySO = child.pciSO;
                                } else {
                                    child.level = item.level + 1;
                                    child.isRoot = false;
                                    child.parentId = item.productId;
                                    child.cardinalitySO = child.pciSO;
                                    child.show = true;
                                    child.showChildren = false;
                                    child.fetchedChildren = false;
                                    $scope.productList.push(child);
                                }
                                pciIds.push(child.pciSO.Id);
                            });
                            if (item.childrenInfo.currentPage < item.childrenInfo.totalPages) {
                                var loadMoreItem = {'show': false, 'loadMore': true, 'level': (item.level + 1), 'parentItem': item};
                                item.children.push(loadMoreItem);
                                $scope.productList.push(loadMoreItem);
                            }
                            $scope.getOverrideInfo(pciIds);
                        });
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
                            $scope.getProductChildren(parentItem, parentItemIdx, 1, false);
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

                $scope.getProductChildren = function(parentItem, parentItemIdx, pageNumber, refresh) {
                    var inputMap = {
                        'productIds': [parentItem.productId],
                        'pageNumber': pageNumber,
                        'pageSize': null
                    };
                    remoteActions.invokeMethod('getProductHierarchy', JSON.stringify(inputMap)).then(function(results) {
                        if (results.productList && results.productList.length > 0) {
                            if (refresh) {
                                parentItem.childrenInfo = results.productList[0].childrenInfo;
                                parentItem.isLeaf = (parentItem.childrenInfo.totalCount === 0);
                                parentItem.showChildren = (parentItem.childrenInfo.totalCount > 0);
                            }

                            if (pageNumber === 1) {
                                parentItem.children = [];
                                parentItemIdx++;
                            } else {
                                $scope.productList.splice(parentItemIdx, 1);
                                parentItem.children.pop();
                            }

                            var cardinalityObjOffset = 0;
                            var pciIds = [];
                            angular.forEach(results.productList[0].children, function(item, idx) {
                                if (item.pciSO && item.pciSO[$scope.nsp+'IsRootProductChildItem__c']) {
                                    cardinalityObjOffset++;
                                } else {
                                    item.level = parentItem.level + 1;
                                    item.isRoot = false;
                                    item.parentId = parentItem.productId;
                                    item.cardinalitySO = item.pciSO;
                                    item.show = true;
                                    item.showChildren = false;
                                    item.fetchedChildren = false;
                                    parentItem.children.push(item);
                                    $scope.productList.splice((parentItemIdx + idx - cardinalityObjOffset), 0, item);
                                    pciIds.push(item.pciSO.Id);
                                }
                            });
                            parentItem.childrenInfo = results.productList[0].childrenInfo;
                            if (parentItem.childrenInfo.currentPage < parentItem.childrenInfo.totalPages) {
                                var loadMoreItem = {'show': true, 'loadMore': true, 'level': (parentItem.level + 1), 'parentItem': parentItem};
                                parentItem.children.push(loadMoreItem);
                                $scope.productList.splice((parentItemIdx + results.productList.length + 1), 0, loadMoreItem);
                            }
                            parentItem.showChildren = true;
                            parentItem.fetchedChildren = true;
                            $scope.getOverrideInfo(pciIds);
                        }
                    }, function(error) {
                        cpqService.showNotification({
                            type: 'error',
                            title: 'Error',
                            content: error.message
                        });
                    });
                };

                $scope.refreshProductChildren = function(productId) {
                    var item, itemIdx;
                    for (var i = 0; i < $scope.productList.length; i++) {
                        item = $scope.productList[i];
                        if (item.productId === productId) {
                            itemIdx = i;
                            break;
                        }
                    }
                    if (itemIdx !== undefined) {
                        var count = 0;
                        for (var i = itemIdx + 1; i < $scope.productList.length; i++) {
                            var childProd = $scope.productList[i];
                            if (childProd.level > item.level) {
                                count++;
                            } else {
                                break;
                            }
                        }
                        $scope.productList.splice(itemIdx + 1, count);
                        $scope.getProductChildren(item, itemIdx, 1, true);
                    }
                };

                $scope.getOverrideInfo = function(pciIds) {
                    var inputMap = { 'offerId': $scope.productId, 'overriddenPCIIds': pciIds };
                    remoteActions.invokeMethod('getOverrideInfo', JSON.stringify(inputMap)).then(function(results) {
                        var resultsMap = JSON.parse(results);
                        for (var key in resultsMap) {
                            $scope.attrOverrideMap[key] = [];
                            $scope.pricingOverrideMap[key] = [];
                            $scope.pciOverrideMap[key] = [];
                            
                            var overrides = resultsMap[key];
                            angular.forEach(overrides, function(override) {
                                var attrOverrides = $scope.attrOverrideMap[key];
                                var pricingOverrides = $scope.pricingOverrideMap[key];
                                var pciOverrides = $scope.pciOverrideMap[key];

                                switch(override[$scope.nsp + 'OverrideType__c']) {
                                    case 'Attribute':
                                        attrOverrides.push(override);
                                        $scope.attrOverrideMap[key] = attrOverrides;
                                        break;
                                    case 'Pricing':
                                        pricingOverrides.push(override);
                                        $scope.pricingOverrideMap[key] = pricingOverrides;
                                        break;
                                    case 'Product Definition':
                                        pciOverrides.push(override);
                                        $scope.pciOverrideMap[key] = pciOverrides;
                                        break;
                                }
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

                $scope.addProdChildItem = function(item, itemIdx, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    var broadcastData = {
                        facetType: 'PROD_CHILD_ITEM',
                        facetData: {
                            mode: 'add',
                            parentProductId: item.productId,
                            prodChildItemObj: item
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
                };

                $scope.deleteProdChildItem = function(item, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    var modalScope = $scope.$new();
                    modalScope.confirmationTitle = 'Delete Product Child Item';
                    modalScope.confirmationMsg = 'Are you sure you want to delete the product child item <i>' + item.productSO.Name + '</i>?';
                    modalScope.cancelActionLbl = 'Cancel';
                    modalScope.confirmActionLbl = 'Delete';
                    modalScope.confirmAction = function() {
                        var inputMap = { 'objectId' : item.pciSO.Id };
                        remoteActions.invokeMethod('deleteObject', JSON.stringify(inputMap)).then(function(results) {
                            $scope.refreshProductChildren(item.parentId);
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

                $scope.viewProductChildDetails = function(item, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    if ((item.isRoot && item.isLeaf) || (item.loadMore)) {
                        return;
                    }

                    $scope.selectedProductId = item.productId;
                    var broadcastData = {
                        facetType: 'PROD_CHILD_DETAILS',
                        facetData: {
                            rootProductId: $scope.productId,
                            productId: item.productId,
                            prodChildItem: item,
                            pricingMode: $scope.pricingMode
                        }
                    };
                    $rootScope.$broadcast('showItemDetails', broadcastData);
                };

                $scope.closeChildDetails = function() {
                    $scope.showChildDetails = false;
                };

                $scope.formatFieldValue = function(field) {
                    return (field === undefined ? '&nbsp;' : field);
                };

                $scope.launchTab = function(item, event) {
                    if (event) {
                        event.stopPropagation();
                    }

                    var data = {
                        'objectId': 'product',
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
                    $scope.getRootProduct($scope.productId);
                };
                $scope.init();
            }
        };
    }
]);

},{}],3:[function(require,module,exports){
angular.module("productadmin").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("ProductStructure.tpl.html",'<div class="vloc-product-structure">\n    <div class="slds-scrollable--x">\n        <table class="slds-table slds-table--bordered slds-tree slds-table--tree product-hierarchy" role="treegrid" aria-readonly="true">\n            <thead>\n                <tr class="slds-text-heading--label">\n                    <th scope="col" class="prod-actions"></th>\n                    <th class="slds-cell-buffer--left product-name" scope="col"><div class="slds-truncate">Product</div></th>\n                    <th scope="col" class="prod-column">Code</th>\n                    <th scope="col" class="prod-column">Spec Type</th>\n                    <th scope="col" class="prod-column">Min, Max, Default</th>\n                </tr>\n            </thead>\n            <tbody>\n                <tr ng-class="{\'slds-hint-parent\': true, \'slds-is-selected\': (item.productId === selectedProductId), \'prod-standalone\': (item.isRoot && item.isLeaf)}" role="row" ng-repeat="item in productList" ng-if="item.show" ng-click="viewProductChildDetails(item, $event)" aria-level="{{item.level}}">\n                    <td class="prod-actions">\n                        <button ng-if="!item.loadMore" class="slds-button slds-button--icon" ng-click="addProdChildItem(item, $index, $event)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'new\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Add Product Child Item</span>\n                        </button>\n                        <button ng-if="!item.isRoot && !item.loadMore" class="slds-button slds-button--icon" ng-click="deleteProdChildItem(item, $event)">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'delete\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Delete Product Child Item</span>\n                        </button>\n                    </td>\n                    <th ng-if="!item.loadMore" scope="row" class="slds-tree__item product-name">\n                        <button class="slds-button slds-button--icon slds-m-right--x-small" ng-class="{\'slds-hidden\': item.isLeaf}" title="Toggle" ng-click="toggleItem(item, $index, $event)">\n                            <slds-button-svg-icon ng-if="!item.showChildren" sprite="\'utility\'" size="\'small\'" icon="\'chevronright\'"></slds-button-svg-icon>\n                            <slds-button-svg-icon ng-if="item.showChildren" sprite="\'utility\'" size="\'small\'" icon="\'chevrondown\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Toggle</span>\n                        </button>\n                        <div class="slds-truncate" title="{{rootProduct}}">\n                            <a href="javascript:void(0)" ng-if="!item.isRoot" ng-click="launchTab(item.productSO, $event)">{{item.productSO.Name}}</a>\n                            <span ng-if="item.isRoot">{{item.productSO.Name}}</span>\n                        </div>\n                    </th>\n                    <th ng-if="item.loadMore" scope="row" class="slds-tree__item product-name">\n                        <button class="slds-button slds-button--icon slds-m-right--x-small slds-hidden" title="Toggle">\n                            <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'chevrondown\'"></slds-button-svg-icon>\n                            <span class="slds-assistive-text">Toggle</span>\n                        </button>\n                        <div class="slds-truncate"><a href="javascript:void(0)" ng-click="getProductChildren(item.parentItem, $index, item.parentItem.childrenInfo.nextPage)">Load more..</a></div>\n                    </th>\n                    <td class="prod-column">\n                        <span ng-if="item.isRoot" ng-bind-html="formatFieldValue(item.productCode)"></span>\n                        <span ng-if="!item.isRoot" ng-bind-html="formatFieldValue(item.productSO[\'ProductCode\'])"></span>\n                    </td>\n                    <td class="prod-column">\n                        <span ng-if="item.isRoot" ng-bind-html="formatFieldValue(item.specType)"></span>\n                        <span ng-if="!item.isRoot" ng-bind-html="formatFieldValue(item.productSO[nsp+\'SpecificationType__c\'])"></span>\n                    </td>\n                    <td class="prod-column">\n                        <span ng-if="item.isRoot" ng-bind-html="formatFieldValue(item.pciSO)"></span>\n                        <span ng-if="!item.isRoot" ng-bind-html="formatFieldValue(item.pciSO[nsp+\'MinMaxDefaultQty__c\'])"></span>\n                    </td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n</div>')}]);
},{}],4:[function(require,module,exports){
angular.module('productadmin', ['vlocity', 'ngSanitize', 'cpqdirectives', 'sldsangular'])
.config(['remoteActionsProvider', function(remoteActionsProvider) {
    remoteActionsProvider.setRemoteActions(window.remoteActions || {});
}])
.config(['$locationProvider', function($locationProvider) {
    $locationProvider.html5Mode(true);
}]);

require('./modules/productadmin/controller/ProductAdminController.js');
require('./modules/productadmin/directive/VlocProductStructure.js');
require('./modules/productadmin/templates/templates.js');

},{"./modules/productadmin/controller/ProductAdminController.js":1,"./modules/productadmin/directive/VlocProductStructure.js":2,"./modules/productadmin/templates/templates.js":3}]},{},[4]);

})();