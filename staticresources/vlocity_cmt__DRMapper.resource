(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
angular.module('drmapper', ['vlocity', 'mgcrea.ngStrap', 'ngDraggable', 'sldsangular', 'ngSanitize'])
  .config(['remoteActionsProvider', function(remoteActionsProvider) {
      'use strict';
      remoteActionsProvider.setRemoteActions(window.remoteActions || {});
  }])
  .config(function($typeaheadProvider) {
      'use strict';
      angular.extend($typeaheadProvider.defaults, {
          minLength: 0,
          autoSelect: true,
          selectMode: true,
          limit: 5000
      });
  }).config(function($locationProvider) {
      'use strict';
      $locationProvider.html5Mode({
          enabled: !!(window.history && history.pushState),
          requireBase: false
      });
  }).config(['$compileProvider', function ($compileProvider) {
      'use strict';
      $compileProvider.debugInfoEnabled(false);
  }])
  .config(['uiZeroclipConfigProvider', function(uiZeroclipConfigProvider) {
      'use strict';
      var scripts = document.querySelectorAll('script');
      for (var i = 0; i < scripts.length; i++) {
          if (/ZeroClipboard\.js$/.test(scripts[i].src)) {
              uiZeroclipConfigProvider.setZcConf({
                  swfPath: scripts[i].src.replace('.js', '.swf').replace(
                                window.location.protocol + '://' + window.location.host, '')
              });
          }
      }
  }]).config(['$localizableProvider', function($localizableProvider) {
      'use strict';
      $localizableProvider.setLocalizedMap(window.localeMap);
      $localizableProvider.setDebugMode(window.ns === '');
  }])
  .value('jsonSeperator', ':');

require('./polyfills/Array.find.js');

require('./modules/drmapper/controller/DRMapperController.js');

require('./modules/drmapper/directive/previewExtractTransform.js');
require('./modules/drmapper/directive/previewLoadJson.js');

require('./modules/drmapper/directive/uiZeroclip.js');
require('./modules/drmapper/directive/ViaBindAndEllipsis.js');
require('./modules/drmapper/directive/ViaAffix.js');
require('./modules/drmapper/directive/vlcClipboard.js');

require('./modules/drmapper/filter/NamespaceUrlPrefix.js');
require('./modules/drmapper/filter/PhaseFilter.js');
require('./modules/drmapper/filter/UrlEncode.js');
require('./modules/drmapper/filter/TransformMappingSortFilter.js');
require('./modules/drmapper/filter/only.js');
require('./modules/drmapper/filter/filterByTab');
require('./modules/drmapper/filter/filterByViewModel');

require('./modules/drmapper/factory/MissingMappings.js');
require('./modules/drmapper/factory/SObjectFields.js');
require('./modules/drmapper/factory/RequiredMappings.js');
require('./modules/drmapper/factory/PhaseOneMappings.js');
require('./modules/drmapper/factory/Save.js');

require('./modules/drmapper/provider/uiZeroclipConfig.js');

require('./modules/drmapper/templates/templates.js');

},{"./modules/drmapper/controller/DRMapperController.js":2,"./modules/drmapper/directive/ViaAffix.js":3,"./modules/drmapper/directive/ViaBindAndEllipsis.js":4,"./modules/drmapper/directive/previewExtractTransform.js":5,"./modules/drmapper/directive/previewLoadJson.js":6,"./modules/drmapper/directive/uiZeroclip.js":7,"./modules/drmapper/directive/vlcClipboard.js":8,"./modules/drmapper/factory/MissingMappings.js":9,"./modules/drmapper/factory/PhaseOneMappings.js":10,"./modules/drmapper/factory/RequiredMappings.js":11,"./modules/drmapper/factory/SObjectFields.js":12,"./modules/drmapper/factory/Save.js":13,"./modules/drmapper/filter/NamespaceUrlPrefix.js":14,"./modules/drmapper/filter/PhaseFilter.js":15,"./modules/drmapper/filter/TransformMappingSortFilter.js":16,"./modules/drmapper/filter/UrlEncode.js":17,"./modules/drmapper/filter/filterByTab":18,"./modules/drmapper/filter/filterByViewModel":19,"./modules/drmapper/filter/only.js":20,"./modules/drmapper/provider/uiZeroclipConfig.js":21,"./modules/drmapper/templates/templates.js":22,"./polyfills/Array.find.js":29}],2:[function(require,module,exports){
/*jshint camelcase: false */
'use strict';
var DRMapItem = require('../util/DRMapItem.js');
var DRBundle = require('../util/DRBundle.js');
var CreationOrderObject = require('../util/CreationOrderObject.js');
var ns = function() {
    return window.ns || '';
};

/*
 * Used to work around prompt bug - https://bugs.webkit.org/show_bug.cgi?id=74961
 * No easy way to feature detect unfortunately
 */
var isSafari = function() {
    return /^((?!chrome).)*safari/i.test(navigator.userAgent) && (navigator.userAgent.indexOf('Mac') > 1);
}

angular.module('drmapper')
.controller('drmapperController', function($scope, $location, $timeout, $q, $localizable,
                                           remoteActions, phaseOneMappings, $modal,
                                           jsonSeperator, save, requiredMappings,
                                           missingMappings, sObjectFields, $rootScope, $window, $sldsModal) {

    try {
        window.ZeroClipboard.on('error', function() {
            $scope.noFlash = true;
        });
    } catch (e) {
        $scope.noFlash = true;
    }
    $scope.nsPrefix = fileNsPrefix();

    var bundleId = window.location ? window.location.href.split(/[?&]/).find(function(item) {
        return /^(id|bundleId)\=/.test(item) ;
    }) : null;

    $scope.loading = !!bundleId;
    if ($scope.loading) {
        $scope.loadingMessage = $localizable('DRMapperLoadingBundle', 'Loading Bundle');
    }
    $q.all({
        'sobjectTypes': remoteActions.loadObjects(),
        'interfaceObjects': remoteActions.loadInterfaceObjects(),
        'allBundles': remoteActions.getAllBundles(),
        'pdfs': remoteActions.getDocuments(),
        'docusign': remoteActions.getDocuSignTemplates(),
        'worddocs': remoteActions.getAllJSONBasedDocumentTemplates()
    })
  .then(function(result) {
      if (result.sobjectTypes !== null) {
          $scope.sobjectTypes = result.sobjectTypes.map(function(sobjectType) {
              return sobjectType.name;
          });
      }
      if (result.interfaceObjects !== null) {
          $scope.interfaceObjects = result.interfaceObjects.map(function(interfaceObject) {
              return interfaceObject.name;
          });
      }
      if (result.docusign !== null) {
          $scope.docusign = result.docusign;
      }
      if (result.worddocs !== null) {
          $scope.worddocs = result.worddocs;
      }
      if (result.allBundles !== null) {
          $rootScope.allBundles = $scope.allBundles = result.allBundles.map(function(bundle) {
              return DRBundle.fromJson(bundle);
          });
          if (bundleId) {
              bundleId = bundleId.replace(/^(id|bundleId)=/, '');
              $scope.allBundles.forEach(function(bundle) {
                  if (bundle.Id === bundleId) {
                      $scope.bundle = bundle;
                      if ($scope.bundle.OutputType__c == 'XML') {
                          $scope.viewModel.outboundMappingType = 'XML';
                      } else if ($scope.bundle.TargetOutDocuSignTemplateId__c) {
                          $scope.viewModel.outboundMappingType = 'DocuSign';
                      } else {
                          $scope.viewModel.outboundMappingType = $scope.bundle.TargetOutPdfDocName__c ? 'PDF' : 'JSON';
                      }
                      if ($scope.viewModel.outboundMappingType === 'PDF') {
                          // need to know if it's a Document Template or PDF
                          var isInWordDocs = $scope.worddocs.find(function(val) {
                              return val === $scope.bundle.TargetOutPdfDocName__c;
                          });
                          if (isInWordDocs) {
                              $scope.viewModel.outboundMappingType = 'doctemplate';
                          }
                      }
                      addOutputMappingsForTransform();
                      $scope.viewModel.lockName = true;
                  }
              });
          }
      }
      if (result.pdfs !== null) {
          var obj = {};
          result.pdfs.forEach(function(pdf) {
              obj[pdf.DeveloperName] = pdf.DeveloperName;
          });
          $scope.pdfs = obj;
      }
  });

    function addOutputMappingsForTransform() {
        if ($scope.bundle.isTransform() || $scope.bundle.isExtract() ) {
            if ($scope.bundle.TargetOutPdfDocName__c) {
                return $scope.getFieldsForPDF($scope.bundle.TargetOutPdfDocName__c);
            } else if ($scope.bundle.TargetOutDocuSignTemplateId__c) {
                $scope.initTabsForDocuSignTemplate($scope.bundle.TargetOutDocuSignTemplateId__c, ns());
            } else if ($scope.bundle.TargetOutJson__c) {
                var json = null;
                try {
                    json = JSON.parse($scope.bundle.TargetOutJson__c);
                } catch (e) {
                }
                if (json) {
                    requiredMappings.reset();
                    requiredMappings.addAllForOutputJson(json, $scope.mappings, $scope.bundle);
                }
            } else if (!$scope.bundle.isExtract() && $scope.viewModel.phasetwo_json) {
                requiredMappings.reset();
                requiredMappings.addAllForOutputJson($scope.viewModel.phasetwo_json, $scope.mappings, $scope.bundle);

                if ($scope.viewModel.xmlAsJsonOutput) {
                  requiredMappings.addAllForOutputJson($scope.viewModel.xmlAsJsonOutput, $scope.mappings, $scope.bundle);
                }
            } else if ($scope.viewModel.xmlAsJsonOutput) {
                requiredMappings.reset();
                requiredMappings.addAllForOutputJson($scope.viewModel.xmlAsJsonOutput, $scope.mappings, $scope.bundle);
            }
        }
        return $q.when(true);
    }

    // -- init default values --//
    $scope.mappings = [];
    $scope.bundle =  DRBundle.fromJson();
    $scope.form = {};
    $scope.viewModel = {
        interfaceTypes: DRBundle.types.map(function(type) {
            return {
                label: type,
                type: type
            };
        }),
        dataTypes: DRBundle.dataTypes ,
        lockName: false,
        showCreationSequence: true,
        showOptions: true,
        showJSON: true,
        showXML: true,
        showXMLAsJSON: true,
        showUrls: true,
        showDataMap: true,
        showFieldSettings: true,
        showDefault: false,
        showOutboundMappings: true,
        showRequiredMappings: false,
        showAllPhaseOneObjectProperties: false,
        creationOrderObjects: CreationOrderObject.all,
        urlPrefix: $location.protocol() + '://' + $location.host(),
        tabs: [
            {
                title: $localizable('DRMapperTransform', 'Transform'),
                content: ''
            }, {
                title: '',
                content: ''
            }
        ],
        outboundMappingType: 'JSON',
        activeTab: 0,
        filterOptions: [
          '=', '<>', '<', '>', '<=', '>=', 
          'LIKE', 'NOT LIKE', 'INCLUDES', 'EXCLUDES'
        ]
    };
    $scope.missingMappings = missingMappings;
    $scope.requiredMappings = requiredMappings;
    $scope.requiredAndMissingMappings = function() {
        return requiredMappings().concat(missingMappings());
    };
    $scope.sObjectFields = sObjectFields;
    $scope.phaseOneMappings = phaseOneMappings;
    $scope.clipboardClient = {};
    $scope.activeMappingDetail = null;

    $scope.showPreview = function() {
      if (!$scope.bundle.SampleInputJSON__c) {
        $scope.bundle.SampleInputJSON__c = $scope.bundle.InputJson__c;
      }
      if (!$scope.bundle.SampleInputXML__c) {
        $scope.bundle.SampleInputXML__c = $scope.bundle.InputXml__c;
      }
      if (angular.element(document.querySelectorAll('.via-slds')).length === 0) {
          // inject an element with class slds to hook our modal into
          $('body').append('<div class="via-slds"></div>');
      }

      // show our export modal
      var modalScope = $scope.$new();

      modalScope.cancel = function() {
          thisModal.hide();
      };

      var thisModal = $sldsModal({
          title: $localizable('DRMapperPreview', 'Preview'),
          backdrop: 'static',
          templateUrl: 'drPreviewModal.tpl.html',
          scope: modalScope,
          show: true
      });
    };

    $scope.domainObjectFieldTypeOptions = [
      '','Boolean','Currency','Double','Integer','JSON',
      'List<Decimal>','List<Double>','List<Integer>','List<Map>',
      'List<String>','Multi-Select','Object','String'
      ];

    $scope.fieldNamesforSuggest = function() {
        return $scope.mappings.concat($scope.requiredAndMissingMappings())
                          .reduce(function(array, mapping) {
                              return array.concat(
                                  [mapping.DomainObjectFieldAPIName__c, mapping.InterfaceFieldAPIName__c]
                              );
                          }, [])
                          .sort()
                          // sorted then remove items next to each other if dupes
                          // or if null/empty text
                          .filter(function(item, pos, array) {
                              /* jshint eqnull: true */
                              return !(item == null || item === '') &&
                                    /* jshint eqeqeq:false */
                                      (!pos || item != array[pos - 1]);
                          });
    };

    (function configureWatches() {
        //-- setup watches --//
        $scope.$watch('activeMappingDetail.DefaultValue__c', function(newValue) {
            $scope.viewModel.showDefault = newValue != null;
        });

        $scope.$watch('viewModel.showDefault', function(newValue, oldValue) {
            if (newValue == false && $scope.activeMappingDetail) {
                $scope.activeMappingDetail.DefaultValue__c = null;
            }
        });

        $scope.$watch('activeMappingDetail.LookupDomainObjectName__c', function(newValue) {
            if (newValue) {
                getAllFieldsForObject(newValue);
            }
        });

        $scope.$watch('viewModel.showAllPhaseOneObjectProperties', updatePhase1Json);

        // save changes on every call
        function without(obj, keys) {
            return Object.keys(obj).filter(function (key) {
                return keys.indexOf(key) === -1;
            }).reduce(function (result, key) {
                result[key] = obj[key];
                return result;
            }, {});
        }

        $scope.changeBundleName = function() {
            var newName = prompt('Please enter a new interface name', '');
            if (newName === '' && !isSafari()) {
                alert('Please enter a Name');
                $scope.loading = false;
                $scope.changeBundleName();
            } else if (newName !== null && !(newName === '' && isSafari())) {
                if (!/^[a-zA-Z0-9\s-_]+$/.test(newName)) {
                    alert('This interface name can only contain letters, numbers and spaces. Please choose a different name.');
                    $scope.changeBundleName();
                    return;
                } else if ($scope.allBundles && $scope.allBundles.find(function(bundle) {
                    return bundle._Name === newName && bundle !== $scope.bundle;
                })) {
                    alert('This name "' + newName + '" is already in use. Please choose a different name.');
                    $scope.changeBundleName();
                    return;
                } else {
                    $scope.bundle.Name(newName);
                }
            }
        }

        $scope.$watch(function() {
            if ($scope.bundle) {
                return without($scope.bundle, ['children', 'saving', '_errors', '$listeners', 'originalJson']);
            } else {
                return [];
            }
        }, function(newValue, oldValue) {
            if (!angular.equals(newValue, oldValue)) {
                // CORE-621 - show an error if Name already in use
                if ($scope.allBundles && $scope.allBundles.find(function(bundle) {
                    return bundle._Name === newValue._Name && bundle !== $scope.bundle;
                })) {
                    $scope.bundle.setErrors([{
                        message: 'The name is already in use',
                        forProp: 'Name'
                    }]);
                } else if (!/^[a-zA-Z0-9\s-_]+$/.test(newValue._Name))  {
                    $scope.bundle.setErrors([{
                        message: 'The name can only contain alphanumeric characters and spaces',
                        forProp: 'Name'
                    }]);
                } else {
                    save($scope.bundle);
                }
            }
        }, true);

        /*
         * If mapping names change due to bundle name change we need to save them all
         */
        $scope.$watchCollection(function() {
            return $scope.mappings.map(function(mapping) {
                return mapping.Name();
            });
        }, function() {
            $scope.saveMappingChanges();
        });

        $scope.$watchGroup([
          'activeMappingDetail',
          'activeMappingDetail.MapId__c',
          'activeMappingDetail.DefaultValue__c',
          'activeMappingDetail.DomainObjectAPIName__c',
          'activeMappingDetail.DomainObjectFieldAPIName__c',
          'activeMappingDetail.Formula__c',
          'activeMappingDetail.FormulaResultPath__c',
          'activeMappingDetail.FormulaOrder__c',
          'activeMappingDetail.IsDisabled__c',
          'activeMappingDetail.UpsertKey__c',
          'activeMappingDetail.IsRequiredForUpsert__c',
          'activeMappingDetail.InterfaceFieldAPIName__c',
          'activeMappingDetail.InterfaceObjectName__c()',
          'activeMappingDetail.LinkCreatedField__c',
          'activeMappingDetail.LookupDomainObjectName__c',
          'activeMappingDetail.LookupDomainObjectFieldName__c',
          'activeMappingDetail.LookupDomainObjectRequestedFieldName__c',
          'activeMappingDetail.DomainObjectFieldType__c',
          'activeMappingDetail.TransformValuesMap__c()',
          'activeMappingDetail.mapType()'
      ], function(newMappingDetail, oldMappingDetail) {
          if ($scope.activeMappingDetail && $scope.activeMappingDetail.wrapperMapping) {
              updatePhase1Json();
              updateFieldsAndFieldNamesForPhaseTwo();
          } else if ($scope.bundle.isExtract()) {
              updatePhase2Json();
          }
          if (!newMappingDetail || (oldMappingDetail.every(function(value) {
              /* jshint eqnull:true */
              return value == null;
          }) && newMappingDetail[0] && oldMappingDetail[0]) ||
          ($scope.form.activeMappingForm && $scope.form.activeMappingForm.$pristine))
        {
              return;
          }
          $scope.saveMappingChanges();
      });

    $scope.$watch(
      function() {
          if ($scope.activeMappingDetail) {
              return [$scope.activeMappingDetail.MapId__c,
                    $scope.activeMappingDetail.DomainObjectFieldAPIName__c];
          } else {
              return [null, null];
          }
      },
      function(newValue, oldValue) {
          if ($scope.activeMappingDetail && $scope.activeMappingDetail.wrapperMapping) {
              if (false && newValue[0] === oldValue[0] &&
                  newValue[1] !== oldValue[1]) {
                  // change to Extract Mapping so we need to update transform mappings
                  var matchRegex = new RegExp('^' + oldValue[1]);
                  $scope.mappings.forEach(function(mapping) {
                      if (mapping.InterfaceFieldAPIName__c &&
                          mapping.DomainObjectCreationOrder__c === 1) {
                          mapping.InterfaceFieldAPIName__c = mapping.InterfaceFieldAPIName__c.replace(matchRegex, newValue[1]);
                      } else if (mapping.DomainObjectFieldAPIName__c &&
                                 mapping.DomainObjectCreationOrder__c === 0 &&
                                 mapping !== $scope.activeMappingDetail &&
                                 mapping.DomainObjectAPIName__c !== 'Formula') {
                          mapping.DomainObjectFieldAPIName__c =
                                mapping.DomainObjectFieldAPIName__c.replace(matchRegex, newValue[1]);
                      }
                  });
                  $scope.phaseOneMappings.mappings.forEach(function(mapping) {
                      if (mapping.DomainObjectFieldAPIName__c &&
                                 mapping.DomainObjectCreationOrder__c === 0 &&
                                 mapping !== $scope.activeMappingDetail &&
                                 mapping.DomainObjectAPIName__c !== 'Formula') {
                          mapping.DomainObjectFieldAPIName__c =
                                mapping.DomainObjectFieldAPIName__c.replace(matchRegex, newValue[1]);
                      }
                  });
                  $scope.saveMappingChanges();
              }
          }
      }, true);

        $scope.$watchGroup([function() {
            if ($scope.activeMappingDetail && $scope.activeMappingDetail.wrapperMapping) {
                var output = $scope.activeMappingDetail.mappings.map(function(mapping) {
                    return mapping.MapId__c + ':' + mapping.InterfaceFieldAPIName__c +
                  mapping.FilterOperator__c + mapping.FilterValue__c + mapping.TransformValuesMap__c();
                });
                return output.join(',');
            }
            return null;
        }], function(newValue, oldValue) {
            if (newValue !== oldValue) {
                $scope.saveMappingChanges();
            }
        });

        $scope.$watch('viewModel.activeTab', function() {
            $scope.onMapItemClick(null);
        });

        $scope.$watch('bundle', function() {
            if ($scope.bundle) {
                $scope.onMapItemClick();
                loadMappingsForCurrentBundle();
            }
        });

        $scope.$watch('viewModel.showRequiredMappings', function(newValue) {
            if (newValue === true) {
                $scope.loadMappingsForRequiredDomainFields();
            }
        });

        $scope.$watch('interfaceModel.mappings', function(mappings) {
            if (mappings) {
                requiredMappings.reset();
                var promisesForAllMappings = [];
                for (var i = 0; i < mappings.length; i++) {
                    promisesForAllMappings.push(setBundleTypeFromMapping(mappings[i]));
                }
                $q.all(promisesForAllMappings).then(function() {
                    addMissingMappings();
                    updatePhase1Json();
                    updatePhase2Json();
                });
            }
        });

        $scope.$watch('bundle._Type__c', function() {
            $scope.viewModel.activeTab = 0;
            if (!$scope.bundle.isLoadObject()) {
                missingMappings.reset();
                requiredMappings.reset();
                $scope.onMapItemClick();
            }
            if ($scope.bundle.isExtract()) {
                $scope.viewModel.tabs[0].title = $localizable('DRMapperExtract','Extract');
                $scope.viewModel.tabs[1].title = $localizable('DRMapperTransform','Transform');
                $scope.viewModel.tabs[2] = {
                    title: $localizable('DRMapperOutput', 'Output'),
                    content: ''
                };
            } else {
                $scope.viewModel.tabs[0].title = $localizable('DRMapperTransform','Transform');
                if ($scope.bundle.isLoad()) {
                    $scope.viewModel.tabs[1].title = $localizable('DRMapperLoad', 'Load');
                } else {
                    $scope.viewModel.tabs[1].title = $localizable('DRMapperOutput', 'Output');
                }
                $timeout(function() {
                    $scope.viewModel.activeTab = 1;
                });
                delete $scope.viewModel.tabs[2];
            }
        });

        $scope.$watch('bundle.InterfaceObject__c', function(newSelectedInterfaceObjectName) {
            if ($scope.mappings && !!newSelectedInterfaceObjectName) {
                for (var i = 0; i < $scope.mappings.length; i++) {
                    $scope.mappings[i].InterfaceObjectName__c(newSelectedInterfaceObjectName);
                    $scope.updateMapping($scope.mappings[i]);
                }
                addMissingMappings();
                // set default if there is no other bundle for this object
                if ($scope.allBundles) {
                    for (i = 0; i < $scope.allBundles.length; i++) {
                        var bundle = $scope.allBundles[i];
                        if (bundle.InterfaceObject__c === newSelectedInterfaceObjectName &&
                            bundle !== $scope.bundle) {
                            return;
                        }
                    }
                    $scope.bundle.IsDefaultForInterface__c = true;
                }
            }
        });

        $scope.$watch('bundle.InputJson__c', function(newJsonString) {
            sObjectFields.addFieldsForJson(newJsonString);
            addMissingMappings();
        });

        $scope.$watch('bundle.TargetOutJson__c', function(targetJsonChanged) {
            try {
                var json = JSON.parse(targetJsonChanged);
                if (json) {
                    requiredMappings.reset();
                    requiredMappings.addAllForOutputJson(json, $scope.mappings, $scope.bundle);
                }
            } catch (e) {
            }
        });
    })();

    var lastLoadedPDF, lastLoadedDoc = null;
    var lastLoadedPdfFields, lastLoadedDocFields = [];

    $scope.getFieldsForPDF = function(pdfName) {
        $scope.loading = true;
        if (lastLoadedPDF === pdfName) {
            return $q(function(resolve) {
                requiredMappings.reset();
                requiredMappings.addAllForPdf(lastLoadedPdfFields, $scope.mappings, $scope.bundle);
                $scope.loading = false;
            });
        } else {
            $scope.loading = true;
            $scope.loadingMessage = $localizable('DRMapperLoadingPDFFields', 'Loading PDF Fields');
            if ($scope.viewModel.outboundMappingType === 'doctemplate') {
                return remoteActions.getAllTokensForJSONBasedDocumentTemplate(pdfName).then(function(fields) {
                    lastLoadedPDF = pdfName;
                    lastLoadedPdfFields = fields;
                    requiredMappings.reset();
                    requiredMappings.addAllForPdf(lastLoadedPdfFields, $scope.mappings, $scope.bundle);
                    $scope.loading = false;
                }, function(result, event) {
                    $scope.loading = false;
                    $window.alert(result.message);
                });
            }
            return remoteActions.getDocumentData(pdfName).then(function(dataAsString) {
              lastLoadedPDF = pdfName;
              var buffer = new window.buffer.Buffer(dataAsString, 'base64');
              lastLoadedPdfFields = window.vlocityPdfWriter.getFormFields(buffer);
              requiredMappings.reset();
              requiredMappings.addAllForPdf(lastLoadedPdfFields, $scope.mappings, $scope.bundle);
              $scope.loading = false;
          }, function(result, event) {
            $scope.loading = false;
            $window.alert(result.message);
          });
        }
    };

    $scope.initTabsForDocuSignTemplate = function(templateId, nameSpace) {
      var deferred = $q.defer();
      $timeout(function() {
          $scope.getTabsForDocuSignTemplate(templateId, nameSpace);
      });
      return deferred.promise;
  };

    $scope.getTabsForDocuSignTemplate = function(templateId, nameSpace) {
      var templates = $scope.docusign,
          tabs = null;
      for (var i = 0; i < templates.length; i++) {
          if (templates[i][nameSpace + 'TemplateIdentifier__c'] === templateId) {
              tabs = angular.fromJson(templates[i][nameSpace + 'TabsData__c'].replace(/&quot;/g,'"'));
          }
      }
      requiredMappings.reset();
      requiredMappings.addAllForDocuSign(tabs, $scope.mappings, $scope.bundle);
  };

    (function configureHandlerFunctions() {
        $scope.onMapItemClick = function(mapping) {
            if (mapping) {
                $scope.activeMappingDetail = mapping;
                $scope.activeMappingDetailIndex = (function() {
                    var mappings = $scope.mappings;
                    if (mapping.wrapperMapping) {
                        mappings = $scope.phaseOneMappings.mappings;
                    }
                    for (var i = 0; i < mappings.length; i++) {
                        if (mapping.equals(mappings[i])) {
                            return i;
                        }
                    }
                    return null;
                })();
            } else {
                $scope.activeMappingDetail = null;
                $scope.activeMappingDetailIndex = null;
            }
            if ($scope.form.activeMappingForm) {
                $scope.form.activeMappingForm.$setPristine();
            }
        };

        $scope.onDragStart = function(event) {
            if (!event.element.hasClass('grabbable')) {
                event.stopPropagation();
                return false;
            }
        };

        $scope.onDropComplete = function (index, obj) {
            var otherObj = $scope.viewModel.creationOrderObjects[index];
            var otherIndex = $scope.viewModel.creationOrderObjects.indexOf(obj);
            obj.index(index + 1);
            otherObj.index(otherIndex + 1);
            $scope.viewModel.creationOrderObjects[index] = obj;
            $scope.viewModel.creationOrderObjects[otherIndex] = otherObj;
        };

        $scope.onMapTypeChange = function(newValue) {
            $scope.activeMappingDetail.mapType(newValue);
        };

        var lastTargetJSON, lastTargetXML, lastTargetPDF, lastTargetDocuSignId;

        $scope.onOutboundMappingTypeChange = function(newValue, $event) {
            if (/label/i.test($event.target.tagName)) {
                if (newValue === 'PDF' || newValue === 'doctemplate') {
                    if (lastTargetPDF) {
                        $scope.bundle.TargetOutPdfDocName__c = lastTargetPDF;
                    }
                    lastTargetJSON = $scope.bundle.TargetOutJson__c || lastTargetJSON;
                    lastTargetXML = $scope.bundle.TargetOutXml__c || lastTargetXML;
                    lastTargetDocuSignId = $scope.bundle.TargetOutDocuSignTemplateId__c || lastTargetDocuSignId;
                    $scope.bundle.TargetOutJson__c = '';
                    $scope.bundle.TargetOutXml__c = '';
                    $scope.bundle.TargetOutDocuSignTemplateId__c = null;
                } else if (newValue === 'DocuSign') {
                    if (lastTargetDocuSignId) {
                        $scope.bundle.TargetOutDocuSignTemplateId__c = lastTargetDocuSignId;
                    }
                    lastTargetJSON = $scope.bundle.TargetOutJson__c || lastTargetJSON;
                    lastTargetXML = $scope.bundle.TargetOutXml__c || lastTargetXML;
                    lastTargetPDF = $scope.bundle.TargetOutPdfDocName__c || lastTargetPDF;
                    $scope.bundle.TargetOutJson__c = '';
                    $scope.bundle.TargetOutXml__c = '';
                    $scope.bundle.TargetOutPdfDocName__c = null;
                } else {
                    if (lastTargetJSON) {
                        $scope.bundle.TargetOutJson__c = lastTargetJSON;
                    }
                    if (lastTargetXML) {
                        $scope.bundle.TargetOutXml__c = lastTargetXML;
                    }
                    lastTargetPDF = $scope.bundle.TargetOutPdfDocName__c || lastTargetPDF;
                    lastTargetDocuSignId = $scope.bundle.TargetOutDocuSignTemplateId__c || lastTargetDocuSignId;
                    $scope.bundle.TargetOutPdfDocName__c = null;
                    $scope.bundle.TargetOutDocuSignTemplateId__c = null;
                }

            }
        };

        $scope.onCreationOrderObjectTypeChange = function(creationOrderObject) {
            var index = creationOrderObject.index();
            var mapItem, i;
            getAllFieldsForObject(creationOrderObject.object()).then(function() {
                if ($scope.bundle.isExtract()) {
                    for (i = 0; i < $scope.phaseOneMappings.mappings.length; i++) {
                        mapItem = $scope.mappings[i];
                        if (creationOrderObject.equals(mapItem.creationOrderObject())) {
                            $scope.phaseOneMappings.mappings[i].InterfaceObjectName__c(creationOrderObject.object());
                            $scope.phaseOneMappings.phaseOneMappingUpdated($scope.phaseOneMappings.mappings[i], $scope);
                        }
                    }
                }
                if ($scope.activeMappingDetail &&
                    $scope.activeMappingDetail.creationOrderObject() &&
                    $scope.activeMappingDetail.creationOrderObject().index() === index) {
                    if ($scope.activeMappingDetail.wrapperMapping) {
                        $scope.activeMappingDetail.InterfaceObjectName__c(creationOrderObject.object());
                        $scope.phaseOneMappings.phaseOneMappingUpdated($scope.activeMappingDetail, $scope);
                    } else {
                        $scope.updateMapping($scope.activeMappingDetail);
                    }
                }
                $scope.loadMappingsForRequiredDomainFields();
            });
        };
    })();

    (function configureCreationOrderObjectFunctions() {
        $scope.addNewCreationOrderObject = function() {
            var creationOrderObject = getOrCreateCreationOrderObject($scope.viewModel.creationOrderObjects.length + 1);
            if ($scope.bundle.isExtract()) {
                $scope.addNewMapping({
                    DomainObjectCreationOrder__c: 0,
                    IsDisabled__c: false,
                    InterfaceObjectLookupOrder__c: creationOrderObject.index()
                });
            }
            return creationOrderObject;
        };

        $scope.deleteCreationOrderObject = function(creationOrderObject, skipDeleteOfMapping) {
            var mapping;
            if (creationOrderObject) {
                CreationOrderObject.delete(creationOrderObject);
                // now delete all references to it in mappings on bundle
                // NOTE: if we're in outbound we delete it on the phaseOneMappings
                if ($scope.mappings && !skipDeleteOfMapping) {
                    for (var i = 0; i < $scope.mappings.length; i++) {
                        mapping = $scope.mappings[i];
                        if (creationOrderObject.equals(mapping.creationOrderObject())) {
                            if ($scope.bundle.isExtract()) {
                                $scope.deleteMapping(mapping);
                            } else {
                                mapping.creationOrderObject(null);
                                mapping.DomainObjectAPIName__c = null;
                                mapping.DomainObjectCreationOrder__c = null;
                                mapping.DomainObjectFieldAPIName__c = null;
                            }
                        }
                    }
                    // if outbound - then also delete the associated phaseonemapping
                    if ($scope.bundle.isExtract()) {
                        for (i = 0; i < phaseOneMappings.mappings.length; i++) {
                            mapping = phaseOneMappings.mappings[i];
                            if (creationOrderObject.equals(mapping.creationOrderObject())) {
                                $scope.deleteMapping(mapping);
                                phaseOneMappings.deleteMapping(mapping);
                            }
                        }
                    }
                }
                // now delete requiredMappings for this object
                requiredMappings.removeForCreationOrderObject(creationOrderObject);
            }
        };

        $scope.getCreationOrderObjectFromIndex = function(index) {
            for (var i = 0; i < CreationOrderObject.all.length; i++) {
                if (CreationOrderObject.all[i].index() === index) {
                    return CreationOrderObject.all[i].object();
                }
            }
            return '';
        };
    })();

    $scope.formatJSON = function() {
        if (angular.isObject($scope.bundle.InputJson__c)) {
            $scope.bundle.InputJson__c = JSON.stringify($scope.bundle.InputJson__c, null, 2);
        }
        try {
            $scope.bundle.InputJson__c = JSON.stringify(JSON.parse($scope.bundle.InputJson__c), null, 2);
        } catch (e) {
            // ignore parse errors
        }
    };

    $scope.formatXML = function(field) {
        console.log(field, $scope.bundle.TargetOutXml__c);
        if (field == 'TargetOutXml__c') {

          remoteActions.xmlToJson( $scope.bundle.TargetOutXml__c)
            .then(function(jsonResult) {
               $scope.viewModel.xmlAsJsonOutput = JSON.parse(jsonResult);
               addOutputMappingsForTransform();
            });
        } else if (field == 'InputXml__c') {

          remoteActions.xmlToJson( $scope.bundle.InputXml__c)
            .then(function(jsonResult) {
             $scope.viewModel.xmlAsJsonInput = JSON.parse(jsonResult);

              sObjectFields.addFieldsForJson($scope.viewModel.xmlAsJsonInput);
              addMissingMappings();
            });
        } else if (field == 'DisplayOutputXML') {
           remoteActions.jsonToXml(JSON.stringify($scope.viewModel.phasetwo_json))
            .then(function(xmlResult) {
             $scope.viewModel.jsonDisplayedAsXml = vkbeautify.xml(xmlResult);
             addOutputMappingsForTransform();
            });
        }
    };

    $scope.addNewFormulaMapping = function() {
        return $scope.addNewMapping({
            DomainObjectAPIName__c: 'Formula',
            DomainObjectFieldAPIName__c: 'Formula',
            DomainObjectCreationOrder__c: 0
        });
    }

    $scope.addNewMapping = function(defaults) {
        defaults = defaults || {};
        defaults.isNew = true;
        var newMapping = DRMapItem.fromJson(defaults, $scope.bundle);
        $scope.mappings.push(newMapping);
        if (newMapping.DomainObjectCreationOrder__c === 0 && newMapping.DomainObjectAPIName__c !== 'Formula') {
            $scope.onMapItemClick(phaseOneMappings.addMapping(newMapping));
        } else {
            $scope.onMapItemClick(newMapping);
        }
        $scope.saveMappingChanges();
        return newMapping;
    };

    $scope.addFilterMapping = function(phaseOneMapping) {
        $scope.saveMappingChanges();
        var newMapping = $scope.addNewMapping({
            DomainObjectCreationOrder__c: 0,
            InterfaceObjectLookupOrder__c: phaseOneMapping.InterfaceObjectLookupOrder__c,
            InterfaceObjectName__c: phaseOneMapping.InterfaceObjectName__c(),
            DomainObjectFieldAPIName__c: phaseOneMapping.DomainObjectFieldAPIName__c,
            IsDisabled__c: false
        });
        newMapping.creationOrderObject(phaseOneMapping.creationOrderObject());
        return newMapping;
    };

    $scope.updateMapping = function(mapping) {
        var promises = [];
        if (mapping.LookupDomainObjectName__c) {
            promises.push(getAllFieldsForObject(mapping.LookupDomainObjectName__c));
        }
        if (!$scope.bundle.isExtract()) {
            mapping.InterfaceObjectName__c(currentInterfaceObjectName());
            if (mapping.DomainObjectAPIName__c) {
                promises.push(getAllFieldsForObject(mapping.DomainObjectAPIName__c));
            }
        } else if (mapping.InterfaceObjectName__c()) {
            promises.push(getAllFieldsForObject(mapping.InterfaceObjectName__c()));
        }
        return $q.all(promises).then(function() {
            if (mapping.creationOrderObject() &&
                $scope.bundle.isExtract() &&
                mapping.DomainObjectCreationOrder__c !== 1 && mapping.DomainObjectAPIName__c !== 'Formula') {
                mapping.DomainObjectCreationOrder__c = 0;
                phaseOneMappings.updateMapping(mapping);
                updateFieldsAndFieldNamesForPhaseTwo();
            }
        });
    };

    $scope.updateFilterMapping = function(activeMappingDetail, mapping, type) {
        if (mapping.new) {
            // need to convert it to a proper mapping
            var newMapping = $scope.addFilterMapping(activeMappingDetail);
            newMapping.FilterOperator__c = type;
            newMapping.FilterValue__c = mapping.FilterValue__c;
        }
    };

    $scope.loadMappingsForRequiredDomainFields = function() {
        if (!$scope.bundle.isExtract()) {
            requiredMappings.reset();
            return requiredMappings.addAllForCreationOrderObject($scope.viewModel.creationOrderObjects,
                                                            $scope.mappings, $scope.bundle);
        }
    };

    function makeMappingEquailtyFn(newMappingDetail) {
        return function(mapping) {
            return newMappingDetail.equals(mapping);
        };
    }

    $scope.saveMappingChanges = function() {

        var newMappingDetail = $scope.activeMappingDetail;

        if (newMappingDetail && (!$scope.bundle.isExtract() || newMappingDetail.DomainObjectCreationOrder__c == 1)) {
            if (newMappingDetail.isRequiredDomainField) {
                newMappingDetail.isRequiredDomainField = undefined;
                newMappingDetail.IsDisabled__c = false;
            } else if (newMappingDetail.isMissingMapping) {
                newMappingDetail.isMissingMapping = undefined;
                newMappingDetail.IsDisabled__c = false;
            } else if (newMappingDetail.isNew && newMappingDetail.DomainObjectAPIName__c) {
                newMappingDetail.isNew = undefined;
                newMappingDetail.IsDisabled__c = false;
            }
            $scope.updateMapping(newMappingDetail);
            if (!$scope.mappings.find(makeMappingEquailtyFn(newMappingDetail))) {
                $scope.mappings.push(newMappingDetail);
                $scope.activeMappingDetailIndex = $scope.mappings.length - 1;
            }
        }
        if ($scope.activeMappingDetail && $scope.activeMappingDetail.wrapperMapping) {
            $scope.phaseOneMappings.phaseOneMappingUpdated($scope.activeMappingDetail, $scope);
            updatePhase1Json();
        } else if (newMappingDetail && $scope.activeMappingDetailIndex !== undefined) {
            $scope.mappings[$scope.activeMappingDetailIndex] = newMappingDetail;
            $scope.updateMapping($scope.mappings[$scope.activeMappingDetailIndex]);
            updatePhase2Json();
        }

        if (saveTimeoutToken) {
            clearTimeout(saveTimeoutToken);
        }
        saveTimeoutToken = setTimeout(function() {
            save($scope.bundle).then(function() {
                save($scope.mappings);
            });
        }, 500);
    };

    var saveTimeoutToken = null;
    $scope.confirmDeleteMapping = function(mapping, justResetMapping) {
        if (mapping) {
            if (!mapping.Id && !$scope.bundle.Id) {
                $scope.deleteMapping(mapping);
                return;
            }
            if (!mapping.Id && !mapping.wrapperMapping && 
                    !(this.mapping.creationOrderObject() && this.mapping.$parent &&  this.mapping.$parent.mappings && this.mapping.$parent.mappings.length > 0 && this.mapping.$parent.mappings[0].InterfaceFieldAPIName__c && !this.mapping.DomainObjectFieldAPIName__c)) {
                if (justResetMapping) {
                  mapping.InterfaceFieldAPIName__c = null;
                  mapping.FilterOperator__c = '=';
                  mapping.FilterValue__c = null;
                } else {
                  $scope.deleteMapping(mapping);
                  return;
                }
            }
            var modalScope = $scope.$new();
            modalScope.mapping = mapping;
            modalScope.ok = function() {
              if (justResetMapping) {
                  this.mapping.InterfaceFieldAPIName__c = null;
                  this.mapping.FilterOperator__c = '=';
                  this.mapping.FilterValue__c = null;
                } else {
                  $scope.deleteMapping(this.mapping);
                }
            };
            $modal({
                title: $localizable('DRMapperConfirmDeleteTitle', 'Confirm deletion'),
                template: 'confirmationModal.tpl.html',
                content: mapping.wrapperMapping ?
                            $localizable('DRMapperConfirmExtractMappingDelete',
                      'Deleting the extract mapping will also delete the extract object. Do you wish to proceed?') :
                            $localizable('DRMapperConfirmMappingDelete', 'Are you sure you want to delete the mapping?'),
                scope: modalScope,
                show: true
            });
        }
    };

    $scope.deleteMapping = function(mapping, skipSteps) {
        var i, promiseToReturn;
        $scope.loading = true;
        $scope.loadingMessage = $localizable('DRMapperDeletingMapping', 'Deleting mapping');
        if (mapping) {
            if (mapping.wrapperMapping) {
                // this is a phaseonemapping
                var promises = [];
                for (i = 0; i < mapping.mappings.length; i++) {
                    $scope.deleteMapping(mapping.mappings[i--], true);
                }
                $scope.deleteCreationOrderObject(mapping.creationOrderObject(), true);
                promiseToReturn = $q.all(promises);
            } else {
                for (i = 0; i < $scope.mappings.length; i++) {
                    if ($scope.mappings[i].MapId__c === mapping.MapId__c) {
                        $scope.mappings.splice(i, 1);
                        break;
                    }
                }
                if (mapping.Id) {
                    promiseToReturn = remoteActions.deleteMappings([mapping.asJson()]);
                } else {
                    promiseToReturn = $q(function(resolve) {
                        resolve({});
                    });
                }
            }
            if ($scope.activeMappingDetail && mapping.MapId__c === $scope.activeMappingDetail.MapId__c) {
                $scope.onMapItemClick();
            }
            if ($scope.bundle.isExtract()) {
                $scope.phaseOneMappings.deleteMapping(mapping);
                if ($scope.activeMappingDetail && $scope.activeMappingDetail.wrapperMapping) {
                    // need to refresh the activeMapping
                    for (i = 0; i < $scope.activeMappingDetail.mappings.length; i++) {
                        if ($scope.activeMappingDetail.mappings[i].MapId__c === mapping.MapId__c) {
                            $scope.activeMappingDetail.mappings.splice(i, 1);
                            break;
                        }
                    }
                }
                updatePhase1Json();
            }
            if ($scope.bundle.isTransform()) {
                updatePhase2Json();
            }
            if (!skipSteps) {
                addMissingMappings();
                $scope.loadMappingsForRequiredDomainFields();
                addOutputMappingsForTransform().then(function() {
                    $scope.loading = false;
                });
            } else {
                $scope.loading = false;
            }
        }
        return promiseToReturn;
    };

    $scope.defaultExistsForCurrentInterfaceObject = function() {
        if (!$scope.allBundles) {
            // if bundles not yet set then we're probably not finished loading them
            return true;
        }
        for (var i = 0; i < $scope.allBundles.length; i++) {
            if ($scope.allBundles[i] !== $scope.bundle &&
                    $scope.allBundles[i].InterfaceObject__c === currentInterfaceObjectName() &&
                    $scope.allBundles[i].IsDefaultForInterface__c) {
                return true;
            }
        }
        return false;
    };

    $scope.save = function(toSave) {
        save(toSave);
    };

    $scope.tooltip = {
        getMappingTooltipTitle: function(mapping) {
            if (mapping._errors && mapping._errors.length > 0) {
                return mapping._errors[0].message;
            } else if (mapping.isRequiredDomainField) {
                return $localizable('DRMapperOutputNotMappedInput', 'This output field is not yet mapped to a input field');
            } else if (mapping.isMissingMapping) {
                return $localizable('DRMapperInputNotMappedOutput', 'This field is not yet mapped to an output field');
            } else if (mapping.IsDisabled__c) {
                return $localizable('DRMapperMappingDisabled', 'This mapping is currently disabled');
            } else if (mapping.creationOrderObject() && !mapping.DomainObjectFieldAPIName__c) {
                return $localizable('DRMapperNoExtractJSONField', 'You must set an Extract JSON Output Path for this mapping');
            }
        }
    };

    function updateFieldsAndFieldNamesForPhaseTwo() {
        phaseOneMappings.addFieldsForPhaseTwo();
    }

    function applyValueToPathInObject(path, value, object) {
        if (!path || !object) {
            return;
        }
        var pathParts = path.split(jsonSeperator);
        for (var i = 0; i < pathParts.length - 1; i++) {
            var prop = pathParts[i];

            if (!object[prop]) { 
                object[prop] = {};
            }

            if (typeof object[prop] === 'object') {
               object = object[prop];
            } else {
               object[prop] = {};
               object = object[prop];
            }

            if (angular.isArray(object)) {
              object = object[0];
            }
        }

        // Special Case where an Object is turned into a Array
        if (typeof object === 'object') {
          if (value == 'List<Map>') {
             object[pathParts[pathParts.length - 1]] = [ object[pathParts[pathParts.length - 1]] != null ? object[pathParts[pathParts.length - 1]] != null : {} ];
          } else {
            object[pathParts[pathParts.length - 1]] = value;
          }
        }
    }

    function updatePhase1Json() {
        phaseOneMappings.jsonOutput($scope.viewModel.showAllPhaseOneObjectProperties, $scope)
                      .then(function(obj) {
                          $scope.viewModel.phaseone_json = obj;
                      });
    }

    function updatePhase2Json() {
        var jsonObj = {};
        for (var i = 0; i < $scope.mappings.length; i++) {
            var mapping = $scope.mappings[i];
            if (mapping.DomainObjectCreationOrder__c === 1) {
              var displayVal = 'Text';
              if (mapping.DefaultValue__c) {
                displayVal = mapping.DefaultValue__c;
              }

              if (mapping.DomainObjectFieldType__c == 'Boolean') {
                displayVal = true;
              } else if (mapping.DomainObjectFieldType__c == 'Double'
                || mapping.DomainObjectFieldType__c == 'Integer') {
                displayVal = !isNaN(displayVal) ? parseFloat(displayVal) : 1;
              } else if (mapping.DomainObjectFieldType__c == 'JSON') {
                displayVal = '{}';
              } else if (mapping.DomainObjectFieldType__c == 'List<Decimal>' 
                || mapping.DomainObjectFieldType__c == 'List<Double>' 
                || mapping.DomainObjectFieldType__c == 'List<Integer>') {
                displayVal = [(!isNaN(displayVal) ? parseFloat(displayVal) : 1)];
              } else if (mapping.DomainObjectFieldType__c == 'List<String>' ) {
                displayVal = ['Text'];
              } else if (mapping.DomainObjectFieldType__c == 'List<Map>') {
                displayVal = [{}];
              } else if (mapping.DomainObjectFieldType__c == 'Object') {
                displayVal = {};
              } else if (mapping.DomainObjectFieldType__c == 'Multi-Select') {
                displayVal = displayVal ? displayVal : 'A;B;C';
              } else {
                displayVal = displayVal ? displayVal : 'Text';
              }

              applyValueToPathInObject(mapping.DomainObjectFieldAPIName__c, displayVal, jsonObj);
            }
        }
        $scope.viewModel.phasetwo_json = jsonObj;

        if ($scope.bundle.OutputType__c == 'XML') {
          $scope.formatXML('DisplayOutputXML');
        }
    }

    function getAllFieldsForObject(objectName) {
        return sObjectFields.getFieldsForObject(objectName);
    }

    function currentInterfaceObjectName() {
        if (!$scope.bundle) {
            return null;
        }
        return $scope.bundle.InterfaceObject__c;
    }

    function currentBundleName() {
        return $scope.bundle.Name();
    }

    function addMissingMappings() {
        if (!$scope.bundle.isExtract()) {
            missingMappings.addAllForSObject(currentInterfaceObjectName(), $scope.mappings, $scope.bundle);
        }
    }

    function loadMappingsForCurrentBundle() {
        if (currentBundleName() && currentInterfaceObjectName) {
            $scope.loadingMessage = $localizable('DRMapperLoadingMappingsForBundle',
                              'Loading Mappings for {1}', currentBundleName());
            $scope.mappings = [];
            $q.all({
                mappings:  remoteActions.loadMappings(currentInterfaceObjectName(), currentBundleName()),
                fields: getAllFieldsForObject(currentInterfaceObjectName())
            }).then(function(result) {
                if (result.mappings) {
                    CreationOrderObject.reset();
                    var promisesForFieldLoading = {};
                    result.mappings = result.mappings.sort(function(a, b) {
                        /* put link created index fields last */
                        return !!a[ns() + 'LinkCreatedIndex__c'] ? 1 : (!!b[ns() + 'LinkCreatedIndex__c'] ? -1 :
                                  (a[ns() + 'DomainObjectCreationOrder__c'] > b[ns() + 'DomainObjectCreationOrder__c'] ?
                                    -1 : (a[ns() + 'DomainObjectCreationOrder__c'] < b[ns() + 'DomainObjectCreationOrder__c'] ?
                                      1 : 0)));
                    }).map(function(mapping) {
                        var objectName = null;
                        mapping = DRMapItem.fromJson(mapping, $scope.bundle);
                        $scope.updateMapping(mapping);
                        if (mapping.bundle() && !mapping.bundle().isExtract()) {
                            objectName = mapping.DomainObjectAPIName__c;
                        } else {
                            objectName = mapping.InterfaceObjectName__c();
                        }
                        if (!promisesForFieldLoading[objectName]) {
                            promisesForFieldLoading[objectName] = getAllFieldsForObject(objectName);
                        }
                        return mapping;
                    });
                    // first we need to load the fields for all the creation map objects
                    // so we can prefill mappings for required Fields
                    promisesForFieldLoading.mappings = $q.when(result.mappings);
                    return $q.all(promisesForFieldLoading);
                }
                return {mappings: []};
            }).then(function(result) {
                if (result.mappings !== null) {
                    $scope.mappings = result.mappings;
                }
                updatePhase1Json();
                updatePhase2Json();
                $scope.loading = false;
                $scope.loadingMessage = null;
            });
        }
    }

    function setBundleTypeFromMapping(mapItem) {
        if (mapItem.DomainObjectAPIName__c === 'json') {
            $scope.bundle.Type__c(DRBundle.types[1]);
        } else if (mapItem.isJson) {
            $scope.bundle.Type__c(DRBundle.types[0]);
        }
        return $scope.updateMapping(mapItem);
    }

    function getOrCreateCreationOrderObject(index, objectName) {
        if (index === null) {
            return null;
        }
        var co = null;
        for (var i = 0; i < $scope.viewModel.creationOrderObjects.length; i++) {
            if ($scope.viewModel.creationOrderObjects[i].index() === index) {
                co = $scope.viewModel.creationOrderObjects[i];
                break;
            }
        }
        if (!co) {
            co = new CreationOrderObject(index, objectName);
            $scope.viewModel.creationOrderObjects.push(co);
        }
        return co;
    }

    $scope.toggleCollapsePalette = function() {
        $scope.collapsePalette = !$scope.collapsePalette;
    };

    $scope.clipError = function($event) {
        console.log($event);
    };

    $scope.isValid = function(propertyName) {
        return $scope.bundle._errors ? !$scope.bundle._errors.find(function(error) {
            if (error.forProp === propertyName) {
                return true;
            }
        }) : true;
    };

    $scope.cloneDRBundle = function(bundle) {
        if ($scope.loading) {
            return;
        }
        $scope.loading = true;
        var newName = prompt('Please enter a new name for the cloned interface', '');
        if (newName === ''  && !isSafari()) {
            alert('Please enter a Name');
            $scope.loading = false;
            $timeout(function() {
                $scope.cloneDRBundle(bundle);
            });
        } else if (!/^[a-zA-Z0-9\s-_]+$/.test(newName) && newName && newName.length > 0) {
            alert('This interface name can only contain letters, numbers and spaces. Please choose a different name.');
            $scope.loading = false;
            $timeout(function() {
                $scope.cloneDRBundle(bundle);
            });
            return;
        } else if (newName !== null && !(newName === '' && isSafari())) {
            remoteActions.cloneDRBundle(bundle.Id, newName)
            .then(function(newId) {
                window.location = '/apex/' + fileNsPrefix() + 'drmapper?id=' + newId;
            }, function(error) {
                alert(error.message + ': ' + newName);
                $scope.loading = false;
                $scope.cloneDRBundle(bundle);
            });
        } else {
            $scope.loading = false;
        }
    }

    $scope.filterLimitOrderByMappings = function(value, index, array) {
        return value.FilterOperator__c != 'ORDER BY' && value.FilterOperator__c != 'LIMIT';
    };
});

},{"../util/CreationOrderObject.js":23,"../util/DRBundle.js":24,"../util/DRMapItem.js":25}],3:[function(require,module,exports){
angular.module('drmapper')
.directive('viaAffix', function() {
    'use strict';
    return function (scope, element) {
        var stickyTop = $(element).offset().top;
        $(window).scroll(function() {
            var windowTop = $(window).scrollTop();
            if (stickyTop < windowTop) {
                $(element).parent().height($(window).height());
                $(element).css({position: 'fixed', top: '3px', width: $(element).parent().width()});
                $(element).addClass('viaAffix');
            } else {
                $(element).removeClass('viaAffix');
                $(element).css('position','static');
            }
        });
    };
});

},{}],4:[function(require,module,exports){
angular.module('drmapper').directive('viaBindEllipsis',
  ['$compile', '$timeout', '$rootScope', function($compile) {
      'use strict';

      return {
          restrict: 'AC',
          compile: function viaBindCompile(templateElement) {
              $compile.$$addBindingClass(templateElement);
              return function viaBindLink(scope, element, attr) {
                  $compile.$$addBindingInfo(element, attr.viaBindEllipsis);
                  element = element[0];

                  scope.$watch(attr.viaBindEllipsis, function viaBindWatchAction(value) {
                      /* jshint eqnull: true */
                      value = (value == null ? '' : value);
                      element.title = value;
                      element.innerHTML = value + '<span class="td-hover"=>' + value + '</span>';
                      $(element).hover(function() {
                          var elemt = $(this);
                          var bgColor = elemt.css('backgroundColor');
                          while (bgColor === 'rgba(0, 0, 0, 0)' || bgColor === 'transparent') {
                              elemt = elemt.parent();
                              bgColor = elemt.css('backgroundColor');
                          }
                          $('span', element).css('backgroundColor', bgColor);
                      }, function() {
          });
                  });

                  $(element).on('$destroy', function() {
                      //removeElement(element);
                  });
              };
          }
      };
  }]);

},{}],5:[function(require,module,exports){
angular.module('drmapper')
    .directive('previewExtractTransform', function($q, $location, remoteActions) {
        'use strict';
        return {
            restrict: 'E',
            replace: true,
            scope: {
                url: '@drurl',
                jsonParams: '=initialJson',
                xmlInput: '=initialXml',
                resetJson: '=',
                bundleName: '@bundleName',
                inputType: '=',
                outputType: '='
            },
            bindToController: true,
            templateUrl: 'previewExtractTransform.tpl.html',
            controllerAs: 'ctrl',
            controller: function($rootScope, $scope, remoteActions) {
                var self = this;
                var params = {};
                try {
                    if (this.jsonParams) {
                        params = JSON.parse(this.jsonParams);
                    }
                    this.params = Object.keys(params).reduce(function(arr, key) {
                        arr.push({key: key, value: params[key]});
                        return arr;
                    }, []);

                    if (this.inputType == 'XML') {
                        this.jsonMode = true;
                    } else {
                        this.jsonMode = false;
                    }
                    
                } catch (e) {
                    this.jsonMode = true;
                    this.invalidJSON = true;
                }
                
                this.requesting = false;
                this.hostPrefix = $location.protocol() + '://' + $location.host();
                this.serviceUrl = this.hostPrefix + this.url;

                this.toggleJsonMode = toggleJsonMode;
                this.submitRequest = submitRequest;
                this.addParam = addParam;
                this.deleteParam = deleteParam;
                this.reset = reset;

                // public functions
                function toggleJsonMode() {
                    this.jsonMode = !this.jsonMode;
                    if (this.jsonMode) {
                        this.jsonParams = JSON.stringify(this.params.reduce(function(obj, param) {
                            obj[param.key] = param.value;
                            return obj;
                        }, {}), 4);
                    } else if (this.inputType == 'JSON') {
                        var params = JSON.parse(this.jsonParams);
                        this.params = Object.keys(params).reduce(function(arr, key) {
                            arr.push({key: key, value: params[key]});
                            return arr;
                        }, []);
                        self.invalidJSON = false;
                    }
                }

                $scope.$watch('ctrl.jsonParams', function(json) {
                    try {
                        JSON.parse(self.jsonParams);
                        self.invalidJSON = false;
                    } catch (e) {
                        self.invalidJSON = true;
                    }
                });

                $scope.$watch('ctrl.params', function(params) {
                    self.jsonParams = JSON.stringify(self.params.reduce(function(obj, param) {
                        obj[param.key] = param.value;
                        return obj;
                    }, {}), 4);
                }, true);

                function reset() {
                    self.params = [];
                    self.xmlInput = '';
                }

                function addParam() {
                    this.params.push({key:'',value:''});
                }

                function deleteParam(param) {
                    this.params.forEach(function(param_, i) {
                        if (param_ == param) {
                            self.params.splice(i, 1);
                        }
                    });
                }

                function submitRequest() {
                    this.requesting = true;
                    var startTime = Date.now();
                    var params = {
                        bundleName: this.bundleName,
                        objectList: this.inputType == 'XML' ? this.xmlInput : this.jsonParams,
                        bulkUpload: false,
                        debug: true
                    };
                    self.response = null;

                    remoteActions.drPreviewExecute(params).then(function(response) {

                        if (typeof(response) === 'string') {
                            response = JSON.parse(response);
                        }
                        
                        self.requesting = false;
                        var doneTime = Date.now();
                        self.requestTime = doneTime - startTime;

                        if (response.interfaceInfo) {
                            self.response = response;

                            if (self.outputType == 'XML') {
                                self.response.returnResultsData = vkbeautify.xml(self.response.returnResultsData);
                            } 
                        } else if (response && response.responseText) {
                            self.response.errors = JSON.parse(response.responseText);
                        } else {
                            self.response.errors = [response || 'Request Failed'];
                        }
                    }, function(response) {
                        self.requesting = false;
                        var doneTime = Date.now();                        
                        self.requestTime = doneTime - startTime;                        
                        self.response = {};
                        
                        if (response.responseText) {
                            self.response.errors = JSON.parse(response.responseText);
                        } else if (response.message) {
                            self.response.errors = [ response.message, response ];
                        } else {
                           self.response.errors = [response || 'Request Failed'];
                        }
                    });
                }
            }
        };
    });


},{}],6:[function(require,module,exports){
angular.module('drmapper')
    .directive('previewLoadJson', function($q, $location, remoteActions) {
        'use strict';
        return {
            restrict: 'E',
            replace: true,
            scope: {
                url: '@drurl',
                bundleName: '@bundleName',
                inputJson: '=initialJson',
                inputRows: '=initialRows',
                xmlInput: '=initialXml',
                isTransform: '=',
                loadJson: '=',
                resetJson: '=',
                resetXml: '=',
                inputType: '=',
                outputType: '='
            },
            bindToController: true,
            templateUrl: 'previewLoadJson.tpl.html',
            controllerAs: 'ctrl',
            controller: function($rootScope, $scope) {
                var self = this;

                this.bulkUpload = false;
                this.simulate = false;
                this.requesting = false;
                this.hostPrefix = $location.protocol() + '://' + $location.host();
                this.serviceUrl = this.hostPrefix + this.url;

                this.submitRequest = submitRequest;
                this.reset = reset;


                // public functions
                $scope.$watch('ctrl.inputJson', function(json) {
                    if (self.inputJson && self.inputType == 'JSON') {
                       try {
                            JSON.parse(self.inputJson);
                            self.invalidJSON = false;
                        } catch (e) {
                            self.invalidJSON = true;
                        }
                    } else {
                        self.invalidJSON = false;
                    }
                });

                function submitRequest() {
                    this.requesting = true;
                    var startTime = Date.now();
                    var params = {
                        bundleName: this.bundleName,
                        objectList: getObjectListJson(),
                        bulkUpload: this.bulkUpload,
                        debug: true
                    };
                    self.response = null;

                    remoteActions.drPreviewExecute(params).then(function(response) {
                        if (typeof(response) === 'string') {
                            response = JSON.parse(response);
                        }

                        self.response = response;
                        
                        self.requesting = false;
                        var doneTime = Date.now();
                        self.requestTime = doneTime - startTime;

                        if (!self.isTransform) {
                            self.response.createdObjects = Object.keys(response.createdObjectsByType)
                                .reduce(function(array, bundleName) {
                                    var bundleData = response.createdObjectsByType[bundleName];
                                    var index = 1;
                                    Object.keys(bundleData).forEach(function(objectType) {
                                        var newIds = bundleData[objectType];
                                        array = array.concat(newIds.map(function(id) {
                                            return {
                                                id: id,
                                                type: objectType,
                                                index: index++
                                            };
                                        }));
                                    })
                                    return array;
                                }, []);
                        }

                        if (self.outputType == 'XML') {
                            self.response.returnResultsData = vkbeautify.xml(self.response.returnResultsData);
                        }

                        if (response.errors) {
                            self.response.errors = Object.keys(response.errors)
                                .reduce(function(array, bundleName) {
                                    var bundleData = response.errors[bundleName];
                                    Object.keys(bundleData).forEach(function(key) {
                                        Object.keys(bundleData[key]).forEach(function(childKey) {
                                            array.push(bundleData[key][childKey]);
                                        });
                                    });
                                    return array;
                            }, []);
                        }

                        if (response.responseText) {
                            self.response.errors = JSON.parse(response.responseText);
                        }
                    }, function(response) {
                        self.requesting = false;
                        var doneTime = Date.now();                        
                        self.requestTime = doneTime - startTime;                        
                        self.response = {};
                        
                        if (response.responseText) {
                            self.response.errors = JSON.parse(response.responseText);
                        } else if (response.message) {
                            self.response.errors = [ response.message, response ];
                        } else {
                           self.response.errors = [response || 'Request Failed'];
                        }
                    });
                }

                function reset() {
                    self.inputJson = self.resetJson;
                    self.inputRows = '';
                    self.xmlInput = self.resetXml;
                }

                // private

                function getObjectListJson() {

                    if (self.inputType == 'XML') {
                       return self.xmlInput;
                    } else if (self.inputRows) {
                        return self.inputRows.split(/[,\n]/g).reduce(function(array, id) {
                            if (id && id.length > 0) {
                                array.push({
                                    Id: id.replace(/ /g, '')
                                });
                            }
                            return array;
                        }, []);
                    } else {
                       return self.inputJson;
                    }
                }
            }
        };
    });


},{}],7:[function(require,module,exports){
angular.module('drmapper')
  .directive('uiZeroclip', ['$document', '$window', 'uiZeroclipConfig',
      function($document, $window, uiZeroclipConfig) {
          'use strict';

          var zeroclipConfig = uiZeroclipConfig.zeroclipConfig || {};
          var ZeroClipboard = $window.ZeroClipboard;

          return {
              scope: {
                  onCopied: '&zeroclipCopied',
                  onError: '&?zeroclipOnError',
                  onBeforeCopy: '&?zeroclipOnBeforeCopy',
                  client: '=?uiZeroclip',
                  value: '=zeroclipModel',
                  text: '@zeroclipText'
              },
              link: function(scope, element) {
                  // config
                  ZeroClipboard.config(zeroclipConfig);
                  var btn = element[0];

                  if (angular.isFunction(ZeroClipboard)) {
                      scope.client = new ZeroClipboard(btn);
                  }

                  scope.$watch('value', function(v) {
                      if (v === undefined) {
                          return;
                      }
                      element.attr('data-clipboard-text', v);
                  });

                  scope.$watch('text', function(v) {
                      element.attr('data-clipboard-text', v);
                  });

                  var _completeHnd;

                  scope.client.on('aftercopy', _completeHnd = function(e) {
                      scope.$apply(function() {
                          scope.onCopied({$event: e});
                      });
                  });

                  scope.client.on('error', function(e) {
                      if (scope.onError) {
                          scope.$apply(function() {
                              scope.onError({$event: e});
                          });
                      }
                      ZeroClipboard.destroy();
                  });

                  scope.client.on('beforecopy', function (e) {
                if (scope.onBeforeCopy) {
                    scope.$apply(function () {
                        scope.onBeforeCopy({$event: e});
                    });
                }
            });

                  scope.$on('$destroy', function() {
                      scope.client.off('complete', _completeHnd);
                  });
              }
          };
      }
  ]);

},{}],8:[function(require,module,exports){
(function(){
    'use strict';
    
    var dModule = angular.module('drmapper');
    dModule.directive('vlcClipboard', function($sldsToast) {
        return {
            restrict: 'A',
            scope:{
                vlcClipboardValue: '='
            },
            controller: function($scope){
                $scope.select  = function(element){
                    if (Clipboard.selectedElement){ //this stores the previous selection
                        //Clipboard.selectedElement..style = '';
                    }
                    Clipboard.selectedElement = element;
                };
            },
            link: function(scope, element, attr, ctrl) {
                var clipboard = new Clipboard(element[0], {
                    text: function(trigger) {
                        return '' + JSON.stringify(scope.vlcClipboardValue);
                    }
                });
                var btn = angular.element;

                //this will make click event not bubbble thereby not toggling the sublist
                element.bind('click', function(){
                    return false;
                });

                clipboard.on('success', function(e) {
                    var elem = e.trigger;
                    scope.select(elem);
                    

                    /* this is for the tooltip to show up on the right */
                    $(elem).addClass('tooltipped tooltipped-e');
                    elem.setAttribute('aria-label', 'copied to clipboard');
                    
                    $(elem).on('mouseleave', function(e) {
                        $(elem).removeClass('tooltipped tooltipped-e');
                        elem.removeAttribute('aria-label');
                    });

                    $sldsToast({
                        message: 'Copied to clipboard',
                        severity: 'success',
                        container: $('.slds-notify_container')
                    });
                    
                    console.log('copy success');
                });

                clipboard.on('error', function(e) {
                    console.log('copy error');
                });

            }
        };
    });
    
}());

},{}],9:[function(require,module,exports){
/*jshint camelcase: false */
var DRMapItem = require('../util/DRMapItem.js');

angular.module('drmapper')
.factory('missingMappings', function($rootScope, remoteActions, sObjectFields) {
    'use strict';
    var missingMappings = [];

    function mappings() {
        return missingMappings;
    }

    mappings.addAllForSObject = function(sObject, existingMappings, bundle) {
        missingMappings = [];
        sObjectFields.getFieldsForObject(sObject).then(function(fieldsForObject) {
            Object.keys(fieldsForObject)
        .forEach(function(fieldName) {
            missingMappings.push(DRMapItem.fromJson({
                InterfaceFieldAPIName__c: fieldName,
                InterfaceObjectName__c: bundle.InterfaceObject__c,
                isMissingMapping: true
            }, bundle));
        });
        });
    };
    // mappings.removeMatching = function(mappings) {
    //   if (!angular.isArray(mappings)) {
    //     mappings = [mappings];
    //   }
    //   mappings.forEach(function(mapping){
    //     missingMappings = missingMappings.filter(function(requiredMapping){
    //       return  !(requiredMapping.InterfaceObjectName__c() == mapping.InterfaceObjectName__c() &&
    //               requiredMapping.InterfaceFieldAPIName__c == mapping.InterfaceFieldAPIName__c);
    //     });
    //   });
    // };
    mappings.reset =  function() {
        missingMappings = [];
    };
    return mappings;
}).filter('filterMissingMappings', function() {
    'use strict';
    return function(missingMappings, existingMappings) {
        if (!angular.isArray(existingMappings)) {
            existingMappings = [existingMappings];
        }
        existingMappings.forEach(function(mapping) {
            missingMappings = missingMappings.filter(function(requiredMapping) {
                /* jshint eqeqeq:false */
                return !(requiredMapping.InterfaceObjectName__c() == mapping.InterfaceObjectName__c() &&
                        /* jshint eqeqeq:false */
                        requiredMapping.InterfaceFieldAPIName__c == mapping.InterfaceFieldAPIName__c);
            });
        });
        return missingMappings.sort(function(a, b) {
            var aName = a.InterfaceFieldAPIName__c.toLowerCase(),
               bName = b.InterfaceFieldAPIName__c.toLowerCase();
            return aName > bName ? 1 : aName < bName ? -1 : 0;
        });
    };
});

},{"../util/DRMapItem.js":25}],10:[function(require,module,exports){
/*jshint camelcase: false */
var DRMapItem = require('../util/DRMapItem.js');

angular.module('drmapper')
.factory('phaseOneMappings', function($rootScope, $q, jsonSeperator, sObjectFields) {
    'use strict';
    var phaseOneMappings = {},
        boundMappingsKeySet = {},
        mappings = [];

    function addMapping(mapping) {
        var key = mapping.creationOrderObject().id;
        if (!phaseOneMappings[key]) {
            phaseOneMappings[key] = DRMapItem.fromJson({
                wrapperMapping: true,
                mappings:[],
                InterfaceObjectLookupOrder__c: mapping.InterfaceObjectLookupOrder__c,
                InterfaceObjectName__c: mapping.InterfaceObjectName__c(),
                DomainObjectCreationOrder__c: 0,
                DomainObjectFieldAPIName__c: mapping.DomainObjectFieldAPIName__c,
            }, mapping.bundle());
            mappings.push(phaseOneMappings[key]);
        }
        if (!boundMappingsKeySet[mapping.MapId__c]) {
            boundMappingsKeySet[mapping.MapId__c] = key;
            phaseOneMappings[key].mappings.push(mapping);
            mapping.$parent = phaseOneMappings[key];
        }
        mappings.sort(function(a, b) {
            return a.creationOrderObject().index() > b.creationOrderObject().index() ? 1 :
                  (a.creationOrderObject().index() < b.creationOrderObject().index() ? -1 : 0);
        });
        return phaseOneMappings[key];
    }
    return {
        addMapping: addMapping,
        addFieldsForPhaseTwo: function() {
            var phaseTwoJsonFields = mappings.reduce(function(previousValue, mapping) {
                return previousValue.concat(sObjectFields.getFieldNamesForObject(mapping.InterfaceObjectName__c(),
                mapping.DomainObjectFieldAPIName__c));
            }, []);
            $q.all(phaseTwoJsonFields).then(function(fields) {
                sObjectFields.addFieldsForJson(fields.reduce(function(previousValue, fields) {
                    return previousValue.concat(fields);
                }, []));
            });
        },
        updateMapping: function(mapping) {
            var newKey = mapping.creationOrderObject().id,
                oldKey = boundMappingsKeySet[mapping.MapId__c],
                phaseOneMapping = phaseOneMappings[oldKey];
            if (newKey !== oldKey) {
                // need to move it around in the phaseOneMappings
            }
            if (!phaseOneMapping) {
                addMapping(mapping);
            } else {
                phaseOneMapping.InterfaceObjectLookupOrder__c = mapping.InterfaceObjectLookupOrder__c;
                phaseOneMapping.InterfaceObjectName__c(mapping.InterfaceObjectName__c());
                phaseOneMapping.DomainObjectFieldAPIName__c = mapping.DomainObjectFieldAPIName__c;
            }
            return phaseOneMapping;
        },
        phaseOneMappingUpdated: function(pomClone) {
            // first get original phaseOneMapping
            var originalPom = null;
            for (var i = 0; i < mappings.length; i++) {
                /*jshint eqeqeq: false */
                if (pomClone.MapId__c == mappings[i].MapId__c) {
                    originalPom = mappings[i];
                    if (originalPom === pomClone) {
                        pomClone = pomClone.clone();
                    }
                    break;
                }
            }
            // now we update the fields on the original
            originalPom.InterfaceObjectLookupOrder__c = pomClone.InterfaceObjectLookupOrder__c;
            originalPom.InterfaceObjectName__c(pomClone.InterfaceObjectName__c());
            originalPom.DomainObjectFieldAPIName__c = pomClone.DomainObjectFieldAPIName__c;

            // now update the mappings in 2 stages
            // 1) loop through old mappings and
            //    remove if no longer there +
            //    update values if still exist
            for (i = 0; i < originalPom.mappings.length; i++) {
                var existingMapping = originalPom.mappings[i],
                    foundMatch = false;
                for (var j = 0; j < pomClone.mappings.length; j++) {
                    var newMapping = pomClone.mappings[j];
                    /*jshint eqeqeq: false */
                    if (existingMapping.MapId__c == newMapping.MapId__c) {
                        foundMatch = true;
                        existingMapping.FilterOperator__c = newMapping.FilterOperator__c;
                        existingMapping.FilterValue__c = newMapping.FilterValue__c;
                        existingMapping.InterfaceFieldAPIName__c = newMapping.InterfaceFieldAPIName__c;
                        if (!existingMapping.creationOrderObject().equals(pomClone.creationOrderObject())) {
                            // creation order object changed we need to remove the old key in the map
                            delete phaseOneMappings[existingMapping.creationOrderObject().id];
                            phaseOneMappings[pomClone.creationOrderObject().id] = pomClone;
                            mappings.sort(function(a, b) {
                                return a.creationOrderObject().index() > b.creationOrderObject().index() ? 1 :
                                      (a.creationOrderObject().index() < b.creationOrderObject().index() ? -1 : 0);
                            });
                        }
                        boundMappingsKeySet[existingMapping.MapId__c] = pomClone.creationOrderObject().id;
                        existingMapping.creationOrderObject(pomClone.creationOrderObject());
                        existingMapping.DomainObjectFieldAPIName__c = pomClone.DomainObjectFieldAPIName__c;
                        // remove this mapping from the clone now we've seen it
                        pomClone.mappings.splice(j, 1);
                        j = pomClone.mappings.length; // break out of this inner loop
                    }
                }
                if (foundMatch === false) {
                    originalPom.mappings.splice(i, 1);
                    i--;
                }
            }

            // 2) if any new mappings still remain then add them too
            for (i = 0; i < pomClone.mappings.length; i++) {
                originalPom.mappings.push(pomClone.mappings[i]);
            }
            // 3) Now copy all the mappings over from our originalPom
            pomClone.mappings = [];
            for (i = 0; i < originalPom.mappings.length; i++) {
                pomClone.mappings.push(originalPom.mappings[i]);
            }
        },
        jsonOutput: function(showAllObjectProperties) {
            var obj = {}, subObj = obj,
                promises = [];
            mappings.forEach(function(mapping) {
                var property = mapping.DomainObjectFieldAPIName__c;
                if (property) {
                    subObj = obj;
                    property.split(jsonSeperator).forEach(function(key, index, array) {
                        var initValue = (index === array.length - 1) ? [{}] : {};
                        if (!subObj[key]) {
                            if (angular.isArray(subObj)) {
                                subObj[0][key] = initValue;
                            } else {
                                subObj[key] = initValue;
                            }
                        }
                        subObj = angular.isArray(subObj) ? subObj[0][key] : subObj[key];
                    });
                    if (showAllObjectProperties) {
                        if (angular.isArray(subObj)) {
                            subObj = subObj[0];
                        }
                        promises.push(
                            sObjectFields.getFieldNamesForObject(mapping.InterfaceObjectName__c())
                  .then(function(fieldNames) {
                      fieldNames.forEach(function(field) {
                          subObj[field] = '';
                      });
                  })
            );
                    }
                }
            });
            // always add at least one promise to resolve with the object
            promises.push($q.when(obj));
            return $q.all(promises).then(function() {
                return obj;
            });
        },
        deleteMapping: function(mapping) {
            var key = boundMappingsKeySet[mapping.MapId__c],
                phaseOneMapping = phaseOneMappings[key], i;
            if (phaseOneMapping) {
                for (i = 0; i < phaseOneMapping.mappings.length; i++) {
                    if (phaseOneMapping.mappings[i].MapId__c === mapping.MapId__c) {
                        phaseOneMapping.mappings.splice(i, 1);
                        break;
                    }
                }
            }
            if (mapping.wrapperMapping) {
                for (i = 0; i < mapping.mappings.length; i++) {
                    delete boundMappingsKeySet[mapping.MapId__c];
                }
                for (i = 0; i < mappings.length; i++) {
                    if (mappings[i].MapId__c === mapping.MapId__c) {
                        mappings.splice(i, 1);
                        break;
                    }
                }
            }
            delete boundMappingsKeySet[mapping.MapId__c];
        },
        mappings: mappings
    };
});

},{"../util/DRMapItem.js":25}],11:[function(require,module,exports){
/*jshint camelcase: false */
var DRMapItem = require('../util/DRMapItem.js');

angular.module('drmapper')
.factory('requiredMappings', function($rootScope, remoteActions, sObjectFields) {
    'use strict';
    var requiredMappings = {};

    function mappings() {
        return Object.keys(requiredMappings).reduce(function(previousArray, objectName) {
            return previousArray.concat(Object.keys(requiredMappings[objectName]).map(function(fieldName) {
                return requiredMappings[objectName][fieldName];
            }));
        }, []);
    }
    mappings.addAllForCreationOrderObject = function(creationOrderObjects, existingMappings, bundle) {
        if (!angular.isArray(creationOrderObjects)) {
            creationOrderObjects = [creationOrderObjects];
        }
        creationOrderObjects.filter(function(creationOrderObject) {
            return !!creationOrderObject.object();
        }).forEach(function(creationOrderObject) {
            requiredMappings[creationOrderObject.object()] = {};
            sObjectFields.getFieldsForObject(creationOrderObject.object()).then(function(fieldsForObject) {
                Object.keys(fieldsForObject).forEach(function(fieldName) {
                    if (fieldsForObject[fieldName].isRequired &&
                          !fieldsForObject[fieldName].defaultValue &&
                          fieldsForObject[fieldName].isInputable) {
                        requiredMappings[creationOrderObject.object()][fieldName] = DRMapItem.fromJson({
                            InterfaceObjectName__c: bundle.InterfaceObject__c,
                            DomainObjectAPIName__c: creationOrderObject.object(),
                            DomainObjectCreationOrder__c: creationOrderObject.index(),
                            DomainObjectFieldAPIName__c: fieldName,
                            isRequiredDomainField: true
                        }, bundle);
                    }
                });
            });
        });
    };
    mappings.addAllForPdf = function(pdfFields, existingMappings, bundle) {
        requiredMappings.json = {};
        if (pdfFields) {
            pdfFields.forEach(function(fieldName) {
                requiredMappings.json[fieldName] = DRMapItem.fromJson({
                    DomainObjectFieldAPIName__c: fieldName,
                    DomainObjectCreationOrder__c: 1,
                    DomainObjectAPIName__c: 'json',
                    isRequiredDomainField: true
                }, bundle);
            });
        }
    };
    mappings.addAllForOutputJson = function(json, existingMappings, bundle) {
        requiredMappings.json = {};
        sObjectFields.getFieldsForJson(json).forEach(function(fieldName) {
            requiredMappings.json[fieldName] = DRMapItem.fromJson({
                DomainObjectFieldAPIName__c: fieldName,
                DomainObjectCreationOrder__c: 1,
                DomainObjectAPIName__c: 'json',
                isRequiredDomainField: true
            }, bundle);
        });
    };
    mappings.addAllForDocuSign = function(tabs, existingMappings, bundle) {
        requiredMappings.json = {};
        sObjectFields.getFieldsForJson(tabs).forEach(function(fieldName) {
            requiredMappings.json[fieldName] = DRMapItem.fromJson({
                DomainObjectFieldAPIName__c: fieldName,
                DomainObjectCreationOrder__c: 1,
                DomainObjectAPIName__c: 'json',
                isRequiredDomainField: true
            }, bundle);
        });
    };
    // mappings.removeMatching = function(mappings) {
    //   if (!angular.isArray(mappings)) {
    //     mappings = [mappings];
    //   }
    //   mappings.forEach(function(mapping){
    //     if (mapping.creationOrderObject()) {
    //       var cObject = mapping.creationOrderObject().object();
    //       if (mapping.DomainObjectFieldAPIName__c && requiredMappings[cObject]) {
    //         delete requiredMappings[cObject][mapping.DomainObjectFieldAPIName__c];
    //       }
    //     }
    //   });
    // };
    mappings.removeForCreationOrderObject = function(creationOrderObject) {
        requiredMappings[creationOrderObject.object()] = {};
    };
    mappings.reset = function() {
        requiredMappings = {};
    };
    return mappings;
}).filter('filterRequiredMappings', function() {
    'use strict';
    return function(requiredMappings, existingMappings) {
        if (!angular.isArray(existingMappings)) {
            existingMappings = [existingMappings];
        }
        var regex = '';
        existingMappings.forEach(function(mapping) {
            if (mapping.creationOrderObject()) {
                var cObject = mapping.creationOrderObject().object();
                if (mapping.DomainObjectFieldAPIName__c) {
                    regex += '|(' + cObject + '.' + mapping.DomainObjectFieldAPIName__c + ')';
                }
            }
        });
        regex = new RegExp('^(' + regex + ')$');
        return requiredMappings.filter(function(mapping) {
            return !regex.test(mapping.DomainObjectAPIName__c + '.' + mapping.DomainObjectFieldAPIName__c);
        });
    };
});

},{"../util/DRMapItem.js":25}],12:[function(require,module,exports){
angular.module('drmapper')
.factory('sObjectFields', function($rootScope, $q, remoteActions, jsonSeperator) {
    'use strict';
    var allFieldsForObjects = {};

    function allFieldsInJSON(jsonObject, prefix) {
        var fields = [];
        if (angular.isArray(jsonObject)) {
            fields = jsonObject.reduce(function(array, object) {
                return array.concat(allFieldsInJSON(object, prefix));
            }, []);
        } else if (angular.isObject(jsonObject)) {
            Object.keys(jsonObject).forEach(function(prop) {

                var fullProp = prefix ? prefix + jsonSeperator + prop : prop;

                if (jsonObject[prop] === null || typeof jsonObject[prop] !== 'object') { 
                   fields.push(fullProp);
                } else {
                    fields = fields.concat(allFieldsInJSON(jsonObject[prop], fullProp));
                }
            });
        }
        return fields;
    }

    var sObjectFields =  {
        getFieldsForObject: function(objectName) {
            if (!objectName) {
                return $q(function(resolve) {
                    resolve([]);
                });
            }
            var existingValue = allFieldsForObjects[objectName];
            if (existingValue) {
                return $q.when(existingValue);
            } else if (objectName !== 'json') {
                allFieldsForObjects[objectName] = remoteActions.loadFieldsForObject(objectName)
            .then(function(fields) {
                var fieldsMap = {};
                if (fields) {
                    Object.keys(fields).forEach(function(fieldName) {
                        if (!/^(DRBundleName__c|DRError__c|DRProgressData__c|DRStatus__c)$/.test(fieldName)) {
                            fieldsMap[fieldName] = fields[fieldName];
                        }
                    });
                }
                allFieldsForObjects[objectName] = fieldsMap;
                return allFieldsForObjects[objectName];
            });
                return allFieldsForObjects[objectName];
            } else {
                return $q.when([]);
            }
        },
        syncGetFieldsForObject: function(objectName, asArray, prefixValue) {
            if (!objectName) {
                return asArray ? [] : {};
            }
            if (asArray) {
                var startArray = [];
                if (prefixValue && prefixValue.trim().length > 0 && !allFieldsForObjects[objectName][prefixValue]) {
                    startArray.push({
                        isNew: true,
                        name: prefixValue
                    });
                } 
                return startArray.concat(Object.keys(allFieldsForObjects[objectName]).map(function(key) {
                    return allFieldsForObjects[objectName][key];
                }).sort(function(a, b) {
                    var aName = a.name || '',
                        bName = b.name || '';
                    return +(aName.toLowerCase() > bName.toLowerCase()) || +(aName.toLowerCase() === bName.toLowerCase()) - 1;
                }))
            }
            return allFieldsForObjects[objectName];
        },
        getFieldNamesForObject: function(sObject, prefix) {
            return sObjectFields.getFieldsForObject(sObject).then(function(fields) {
                return Object.keys(fields).map(function(fieldName) {
                    return (prefix ? prefix + jsonSeperator : '') + fieldName;
                }).concat(prefix ? [prefix] : []).sort();
            });
        },
        /* Util for getting all fields in JSON object without saving */
        getFieldsForJson: function(json) {
            if (angular.isString(json)) {
                try {
                    json = JSON.parse(json);
                } catch (e) {
                    // ignore errors from parsing JSON
                    return [];
                }
            }
            if (angular.isObject(json)) {
                var allFields = json;
                if (angular.isObject(json) && !angular.isArray(json)) {
                    allFields = allFieldsInJSON(json);
                }
                return allFields;
            } else {
                return [];
            }
        },
        addFieldsForJson: function(json) {
            if (json) {
                var allFields = sObjectFields.getFieldsForJson(json);
                allFieldsForObjects.json = {};
                allFields.forEach(function(fieldName) {
                    allFieldsForObjects.json[fieldName] = {
                        isInputable: true,
                        isRequired: false,
                        name: fieldName
                    };
                });
            }
        }
    };
    return sObjectFields;
});

},{}],13:[function(require,module,exports){
var DRBundle = require('../util/DRBundle.js');

angular.module('drmapper')
.factory('save', function($q, remoteActions, $rootScope, $timeout, $localizable) {
    'use strict';
    function shouldSave(item, isBundle) {
        if (item.saving) {
            return false;
        } else if (!item.Name() || item.Name() === '') {
            item.setErrors([{
                message: $localizable('DRMapperMustSetInterfaceName', 'You must set an interface name')
            }]);
            return false;
        } else if (!/^[a-zA-Z0-9\s-_]+$/.test(item.Name())) {
            item.setErrors([{
                message: 'The name can only contain alphanumeric characters and spaces',
                forProp: 'Name'
            }]);
            return false;
        } else if (isBundle && $rootScope.allBundles && $rootScope.allBundles.find(function(bundle) {
                    return bundle._Name === item._Name && bundle.Id !== item.Id;
                })) {
            item.setErrors([{
                message: 'The name is already in use',
                forProp: 'Name'
            }]);
            return false;
        }
        var previousJson = item.originalJson,
            json = item.asJson();
        if (angular.equals(json, previousJson)) {
            return false;
        }
        item.originalJson = json;
        item.setSaving(true);
        item.setErrors(null);
        return json;
    }

    function saveBundle(bundle) {
        var json = shouldSave(bundle, true);
        if (json) {
            return remoteActions.saveBundle(json).then(function(result) {
                bundle.setSaving(false);
                if (result.success) {
                    $rootScope.$broadcast('saved', bundle);
                    if (!bundle.Id) {
                        bundle.setId(result.id);
                        if (!/id/.test(window.location.search)) {
                            $timeout(function() {
                                window.history.pushState('','',window.location.pathname +
                                    (window.location.search.length === 0 ? '?' :  window.location.search + '&') + 'id=' + result.id);
                            });
                        }
                    }
                } else if (result.errors) {
                    bundle.setErrors(result.errors);
                } else if (result.type === 'exception') {
                    bundle.setErrors([{
                        message: result.message
                    }]);
                }
                return bundle;
            });
        } else {
            return $q.when(bundle);
        }
    }

    function saveMappings(mappings) {
        mappings = mappings.filter(function(mapping) {
            /* jshint eqnull:true, camelcase: false */
            return mapping.DomainObjectFieldAPIName__c != null && shouldSave(mapping, false);
        });
        if (mappings.length > 0) {
            return remoteActions.saveMappings(mappings.map(function(mapping) {
                return mapping.asJson();
            })).then(function(results) {
                results.forEach(function(result, index) {
                    var mapping = mappings[index];
                    mapping.setSaving(false);
                    if (result.success) {
                        $rootScope.$broadcast('saved', mapping);
                        if (!mapping.Id) {
                            mapping.setId(result.id);
                        }
                    } else {
                        mapping.setErrors(result.errors);
                    }
                });
                return mappings;
            });
        }
    }

    return function (bundleOrMapping) {
        return (bundleOrMapping instanceof DRBundle) ? saveBundle(bundleOrMapping) : saveMappings(bundleOrMapping);
    };
});

},{"../util/DRBundle.js":24}],14:[function(require,module,exports){
angular.module('drmapper')
.filter('namespaceUrlPrefix', function() {
    'use strict';
    return function(prefix) {
        return prefix.length === 0 ? '' : prefix.replace('__', '/');
    };
});

},{}],15:[function(require,module,exports){
/*jshint camelcase: false */

angular.module('drmapper')
.filter('phaseFilter', function(phaseOneMappings) {
    'use strict';
    function isPhaseOne(mapping) {
        return mapping.DomainObjectCreationOrder__c === 0 && mapping.DomainObjectAPIName__c !== 'Formula';
    }
    return function(mappings, phase) {
        var phasesInOutput = {},
            outputMappings = [], mapping, i,
            key;
        for (i = 0; i < mappings.length; i++) {
            mapping = mappings[i];
            if (isPhaseOne(mapping) && phase === '1') {
                phaseOneMappings.addMapping(mapping);
                if (!phasesInOutput[key]) {
                    outputMappings.push(phaseOneMappings[key]);
                    phasesInOutput[key] = true;
                }
            } else if (!isPhaseOne(mapping) && phase === '2') {
                outputMappings.push(mapping);
            }
        }
        outputMappings.sort(function(a, b) {
            var aOrder = a.InterfaceObjectLookupOrder__c,
                bOrder = b.InterfaceObjectLookupOrder__c;
            return aOrder > bOrder ? 1 : aOrder < bOrder ? -1 : 0;
        });
        return outputMappings;
    };
});

},{}],16:[function(require,module,exports){
/*jshint camelcase: false */
angular.module('drmapper')
.filter('transformMappingSortFilter', function() {
    'use strict';
    function isEmpty(string) {
        return !string || string.length === 0;
    }

    return function(mappings, existingMappings) {
        function getName(mapping) {
            return mapping.isRequiredDomainField ? mapping.DomainObjectFieldAPIName__c : mapping.InterfaceFieldAPIName__c;
        }
        var existingDomainFields = '',
            existingInterfaceFields = '';
        existingMappings.forEach(function(mapping) {
            if (!isEmpty(mapping.DomainObjectFieldAPIName__c)) {
                existingDomainFields += '|(' + mapping.DomainObjectFieldAPIName__c + ')';
            }
            if (!isEmpty(mapping.InterfaceFieldAPIName__c)) {
                existingInterfaceFields += '|(' + mapping.InterfaceFieldAPIName__c + ')';
            }
        });
        existingDomainFields = new RegExp('^(' + existingDomainFields + ')$');
        existingInterfaceFields = new RegExp('^(' + existingInterfaceFields + ')$');
        return mappings.sort(function(a, b) {
            var aName = getName(a).toLowerCase(),
                bName = getName(b).toLowerCase();
            return aName > bName ? 1 : aName < bName ? -1 : 0;
        }).filter(function(mapping) {
            if (mapping.isRequiredDomainField) {
                return !existingDomainFields.test(mapping.DomainObjectFieldAPIName__c);
            } else {
                return !existingInterfaceFields.test(mapping.InterfaceFieldAPIName__c);
            }
        });
    };
});

},{}],17:[function(require,module,exports){
angular.module('drmapper')
.filter('urlEncode', function() {
    'use strict';
    return window.encodeURIComponent;
});

},{}],18:[function(require,module,exports){
angular.module('drmapper')
.filter('filterByTab', function() {
    'use strict';
    return function(mappings, isFormulaTab) {
        return mappings.filter(function(mapping) {
            var isFormulaMapping = mapping.DomainObjectFieldAPIName__c == 'Formula' && mapping.DomainObjectAPIName__c == 'Formula';
            return (isFormulaTab && isFormulaMapping) || (!isFormulaTab && !isFormulaMapping);
        });
    };
});

},{}],19:[function(require,module,exports){
angular.module('drmapper')
.filter('filterByViewModel', function() {
    'use strict';
    return function(mappings, filter) {
        if (!filter) {
            return mappings
        }
        var fields = [],
            compiled = {};
        Object.keys(filter).forEach(function(key) {
            if (filter[key] != null && filter[key].length > 0) {
                fields.push(key);
                compiled[key] = new RegExp('^' + filter[key] + '|:' + filter[key], 'i');
            } 
        })
        if (fields.length == 0) {
            return mappings;
        }
        return mappings.filter(function(mapping) {
            var field, fieldValue;
            for (var i = 0; i < fields.length; i++) {
                field = fields[i];
                fieldValue = mapping[field];
                if (angular.isFunction(fieldValue)) {
                    fieldValue = mapping[field]();
                }
                if (!compiled[field].test(fieldValue)) {
                    return false;
                }
            }
            return true;
        });
    };
});

},{}],20:[function(require,module,exports){
/*jshint camelcase: false */

angular.module('drmapper')
    .filter('only', function() {
        'use strict';
        var cache = {};
        return function(mappings, type) {
            var outputMappings = mappings.filter(function(mapping) {
                return mapping.FilterOperator__c === type;
            });
            if (outputMappings.length === 0) {
                if (!cache[type]) {
                    cache[type] = {
                        new: true
                    };
                }
                outputMappings.push(cache[type]);
            }
            return outputMappings;
        };
    });

},{}],21:[function(require,module,exports){
angular.module('drmapper')
  .provider('uiZeroclipConfig', function() {
      'use strict';
      // default configs
      var _zeroclipConfig = {
        buttonClass: '',
        swfPath: 'ZeroClipboard.swf',
        trustedDomains: [window.location.host],
        cacheBust: true,
        forceHandCursor: false,
        zIndex: 999999999,
        debug: true,
        title: null,
        autoActivate: true,
        flashLoadTimeout: 30000,
        hoverClass: 'zeroclipboard-is-hover',
        activeClass: 'zeroclipboard-is-active'
    };
      this.setZcConf = function(zcConf) {
          angular.extend(_zeroclipConfig, zcConf);
      };
      this.$get = function() {
          return {
              zeroclipConfig: _zeroclipConfig
          };
      };
  });

},{}],22:[function(require,module,exports){
angular.module("drmapper").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("confirmationModal.tpl.html",'<div class="modal vlocity" tabindex="-1" role="dialog" aria-hidden="true">\n    <div class="modal-dialog">\n        <div class="modal-content">\n            <div class="modal-header" ng-show="title">\n                <button type="button" class="close" aria-label="Close" ng-click="$hide()" id="confirm-modal-close-button"><span aria-hidden="true">&times;</span></button>\n                <h4 class="modal-title" ng-bind="title"></h4>\n            </div>\n            <div class="modal-body" ng-bind="content"></div>\n            <div class="modal-footer">\n                <button type="button" class="btn btn-primary" ng-click="ok();$hide()" id="confirm-modal-ok-button">{{ ::\'DRMapperOK\' | localize:\'OK\' }}</button>\n                <button type="button" class="btn btn-default" ng-click="$hide()" id="confirm-modal-cancel-button">{{ ::\'DRMapperCancel\' | localize:\'Cancel\' }}</button>\n            </div>\n        </div>\n    </div>\n</div>'),$templateCache.put("drPreviewModal.tpl.html",'<div id="dataraptor-preview-modal"  class="slds-modal  slds-modal--large slds-fade-in-open" dir="ltr">\n  <style>\n    #dataraptor-preview-modal .slds-modal__content,\n    #dataraptor-preview-modal .slds-modal__content > preview-extract-transform > div {\n      min-height: calc(75vh - 5rem);\n    }\n  </style>\n  <div class="slds-modal__container">\n    <div class="slds-modal__header">\n      <button class="slds-button slds-modal__close slds-button--icon-inverse" title="Close" ng-click="$hide()">\n        <slds-button-svg-icon sprite="\'utility\'" icon="\'close\'" size="\'large\'"></slds-button-svg-icon>\n        <span class="slds-assistive-text">Close</span>\n      </button>\n      <div class="slds-notify_container"></div>\n      <h2 class="slds-text-heading--medium" id="dataraptor-preview-modal-title">{{ ::\'DataRaptorWorkbench\'| localize:\'DataRaptor Workbench\' }}</h2>\n    </div>\n\n    <div class="slds-modal__content slds-grid slds-grid--vertical-stretch">\n\n        <preview-extract-transform\n                  bundle-name="{{bundle.Name()}}"\n                  drurl="/services/apexrest/{{nsPrefix | namespaceUrlPrefix}}v2/DataRaptor/{{bundle.Name() | urlEncode}}/"\n                  initial-json="bundle.SampleInputJSON__c"\n                  initial-xml="bundle.SampleInputXML__c"\n                  reset-json="bundle.InputJson__c"\n                  reset-xml="bundle.InputXml__c"\n                  ng-if="bundle.isExtract()"\n                  input-type="bundle.InputType__c"\n                  output-type="bundle.OutputType__c">\n        </preview-extract-transform>\n\n        <preview-load-json drurl="/services/apexrest/{{nsPrefix | namespaceUrlPrefix}}v2/DataRaptor/"\n                            bundle-name="{{bundle.Name()}}"\n                            initial-json="bundle.SampleInputJSON__c"\n                            initial-rows="bundle.SampleInputRows__c"\n                            initial-xml="bundle.SampleInputXML__c"\n                            reset-json="bundle.InputJson__c"\n                            reset-xml="bundle.InputXml__c"\n                            load-json="::bundle.isLoadJson()"\n                            is-transform="::bundle.isTransform()"\n                            input-type="bundle.InputType__c"\n                            output-type="bundle.OutputType__c"\n                            ng-if="bundle.isLoad() || bundle.isTransform()"></preview-load-json>\n    </div>\n\n    <div class="slds-modal__footer">\n      <button type="button"\n              class="slds-button slds-button--neutral"\n              ng-click="$hide()"\n              id="datapack-import-modal-done-button">\n'+"        {{ ::'Done' | localize: 'Done' }}\n      </button>\n    </div>\n  </div>\n</div>"),$templateCache.put("extractJson.center.tpl.html",'<div bs-active-pane="viewModel.activeTab" bs-tabs="bs-tabs">\n    <div ng-repeat="tab in viewModel.tabs" title="{{tab.title}}" bs-pane="bs-pane"></div>\n</div>\n<div class="panel panel-sf" ng-if="viewModel.activeTab === 1" ng-include="\'formulaMapping.center.tpl.html\'"></div>\n<div class="panel panel-sf" ng-if="viewModel.activeTab !== 1">\n    <div class="panel-heading">\n        {{ ::\'DRMapperDataMappings\' | localize:\'Data Mappings\' }}\n        <button class="btn btn-primary pull-right" ng-if="viewModel.activeTab === 2" id="add-new-mapping-button" ng-click="addNewMapping()">{{ ::\'DRMapperNewMapping\' | localize:\'New Mapping\' }}</button>\n    </div>\n    <table class="table">\n        <!-- OUTBOUND PHASE ONE -->\n        <colgroup ng-if="viewModel.activeTab === 0">\n            <col width="45px" />\n            <col />\n            <col />\n            <col width="45px" />\n        </colgroup>\n        <thead ng-if="viewModel.activeTab === 0">\n            <tr>\n                <th>{{ ::\'DRMapperIndex\' | localize:\'Index\' }}</th>\n                <th>{{ ::\'DRMapperExtractObject\' | localize:\'Extract Object\' }} <input type="text" ng-model="viewModel.filter.InterfaceObjectName__c" placeholder="" required="required" /></th>\n                <th>{{ ::\'DRMapperExtractJsonObjectPath\' | localize:\'Extract JSON Output Path\' }}<input type="text" ng-model="viewModel.filter.DomainObjectFieldAPIName__c" placeholder="" required="required" /></th>\n                <th>&nbsp;</th>\n            </tr>\n        </thead>\n        <!-- OUTBOUND PHASE TWO -->\n        <colgroup ng-if="viewModel.activeTab === 2">\n            <col />\n            <col />\n            <col width="45px" />\n        </colgroup>\n        <thead ng-if="viewModel.activeTab === 2">\n            <tr>\n                <th>{{ ::\'DRMapperExtractJsonFieldPath\' | localize:\'Extract JSON Field Path\' }}\n                    <input type="text" ng-model="viewModel.filter.InterfaceFieldAPIName__c" placeholder="" required="required" />\n                </th>\n                <th>{{ ::\'DRMapperTransformJsonOutputPath\' | localize:\'Transform JSON Output Path\' }}\n                    <input type="text" ng-model="viewModel.filter.DomainObjectFieldAPIName__c" placeholder="" required="required" />\n                </th>\n                <th>&nbsp;</th>\n            </tr>\n        </thead>\n    </table>\n    <table class="table">\n        <!-- OUTBOUND PHASE ONE -->\n        <colgroup ng-if="viewModel.activeTab === 0">\n            <col width="45px" />\n            <col />\n            <col />\n            <col width="45px" />\n        </colgroup>\n        <tbody ng-if="viewModel.activeTab === 0">\n            <tr ng-repeat="(key, mapping) in phaseOneMappings.mappings | filterByViewModel:viewModel.filter | orderBy: [\'_InterfaceObjectName__c\', \'DomainObjectFieldAPIName__c\'] track by $index" \n                ng-click="onMapItemClick(mapping)" \n                ng-class="{ \'active\': activeMappingDetail.MapId__c && mapping.MapId__c == activeMappingDetail.MapId__c && (!mapping._errors || mapping._errors.length == 0), \'danger\': mapping._errors.length > 0 || (mapping.creationOrderObject() && !mapping.DomainObjectFieldAPIName__c)}"\n                data-container=".container" \n                id="phaseone-mapping-{{index}}" \n                data-placement="right" \n                data-type="info" \n                bs-tooltip="tooltip"\n                bs-enabled="mapping.IsDisabled__c || mapping._errors.length > 0 || (mapping.creationOrderObject() && !mapping.DomainObjectFieldAPIName__c)"\n                data-title="{{getMappingTooltipTitle(mapping)}}">\n                <td class="text-center">{{mapping.InterfaceObjectLookupOrder__c}}</td>\n                <td via-bind-ellipsis="mapping.InterfaceObjectName__c()"></td>\n                <td via-bind-ellipsis="mapping.DomainObjectFieldAPIName__c"></td>\n                <td class="icon-cell">\n                    <a ng-if="!mapping.saving" class="icon icon-v-trash-line" id="delete-phaseone-mapping-{{index}}-button" ng-click="confirmDeleteMapping(mapping)"></a>\n                    <span ng-if="mapping.saving" class="spinner pull-right"></span>\n                </td>\n            </tr>\n        </tbody>\n        <!-- OUTBOUND PHASE 2 -->\n        <colgroup ng-if="viewModel.activeTab === 2">\n            <col />\n            <col />\n            <col width="45px" />\n        </colgroup>\n        <tbody ng-if="viewModel.activeTab === 2">\n            <tr ng-repeat="mapping in mappings | filterByTab:(viewModel.activeTab === 1) | filterByViewModel:viewModel.filter | phaseFilter:\'2\' | orderBy: [\'InterfaceFieldAPIName__c\', \'DomainObjectFieldAPIName__c\'] track by $index" \n                ng-click="onMapItemClick(mapping)" \n                ng-class="{ \'active\': activeMappingDetail.MapId__c && mapping.MapId__c == activeMappingDetail.MapId__c && (!mapping._errors || mapping._errors.length == 0), \'danger\': mapping._errors.length > 0 }"\n                data-container=".container" \n                id="phasetwo-mapping-{{index}}" \n                data-placement="right" \n                data-type="info" \n                bs-tooltip="tooltip"\n                bs-enabled="mapping.IsDisabled__c || mapping._errors.length > 0" \n                data-title="{{getMappingTooltipTitle(mapping)}}">\n                <td via-bind-ellipsis="mapping.InterfaceFieldAPIName__c"></td>\n                <td via-bind-ellipsis="mapping.DomainObjectFieldAPIName__c"></td>\n                <td class="icon-cell">\n                    <a ng-if="!mapping.saving" class="icon icon-v-trash-line" id="delete-phasetwo-mapping-{{index}}-button" ng-click="confirmDeleteMapping(mapping)"></a>\n                    <span ng-if="mapping.saving" class="spinner pull-right"></span>\n                </td>\n            </tr>\n        </tbody>\n        <tbody ng-if="viewModel.activeTab === 2">\n            <tr ng-repeat="mapping in requiredAndMissingMappings() | filterByViewModel:viewModel.filter | transformMappingSortFilter:mappings | orderBy: [\'InterfaceFieldAPIName__c\', \'DomainObjectFieldAPIName__c\'] track by $index" \n                ng-click="onMapItemClick(mapping)"\n                ng-class="{ \'active\': activeMappingDetail.MapId__c && mapping.MapId__c == activeMappingDetail.MapId__c, \'warning\': true }"\n                id="required-missing-mapping-{{index}}" \n                data-container=".container" \n                data-placement="right" \n                data-type="info" \n                bs-tooltip="tooltip"\n                data-title="{{getMappingTooltipTitle(mapping)}}">\n                <td via-bind-ellipsis="mapping.InterfaceFieldAPIName__c"></td>\n                <td via-bind-ellipsis="mapping.DomainObjectFieldAPIName__c"></td>\n                <td>&nbsp;</td>\n            </tr>\n        </tbody>\n    </table>\n</div>'),$templateCache.put("extractJson.right.tpl.html",'<form name="form.activeMappingForm" via-affix="via-affix">\n    <div class="panel panel-sf" ng-if="viewModel.activeTab == 1" ng-include="\'formulaMapping.right.tpl.html\'"></div>\n    <div class="panel panel-sf" ng-if="viewModel.activeTab !== 1">\n        <div class="panel-heading">\n            {{ ::\'DRMapperMappingDetail\' | localize:\'Mapping Detail\' }}\n        </div>\n        <div class="panel-body" ng-if="!activeMappingDetail">\n            <p ng-if="viewModel.activeTab === 0">{{ ::\'DRMapperExtractJsonEmptyMappingExtract1\' | localize:\'Select a mapping from the Data Mappings table or add\n                a\' }} <a class="btn btn-primary btn-sm" id="active-mapping-add-new-creation-order-object" ng-click="addNewCreationOrderObject()">{{ ::\'DRMapperExtractJsonEmptyMappingExtract2\' | localize:\'new\' }}</a>                {{ ::\'DRMapperExtractJsonEmptyMappingExtract3\' | localize:\'Extract Object Order on the left to create one\'\n                }}\n            </p>\n            <p ng-if="viewModel.activeTab === 2">{{ ::\'DRMapperMappingDetailEmpty1\' | localize:\'Select a mapping from the Data Mappings table or click\' }}\n                <a class="btn btn-primary btn-sm" id="active-mapping-add-new-mapping-button" ng-click="addNewMapping()">{{ ::\'DRMapperNew\' | localize:\'New\' }}</a>                {{ ::\'DRMapperMappingDetailEmpty2\' | localize:\'to create one\' }}\n            </p>\n        </div>\n        <div class="panel-body" ng-if="activeMappingDetail">\n            <div ng-if="viewModel.activeTab === 0">\n                <div class="form-group">\n                    <label for="domainObject">{{ ::\'DRMapperExtractObject\' | localize:\'Extract Object\' }}</label>\n                    <select name="domainObject" class="form-control" id="active-mapping-creation-order-object-select" ng-options="cObject as cObject.label() for cObject in viewModel.creationOrderObjects"\n                        ng-model-options="{ getterSetter: true }" ng-model="activeMappingDetail.creationOrderObject">\n                        </select>\n                </div>\n                <div class="form-group" ng-class="{\'has-error\': activeMappingDetail.creationOrderObject() && activeMappingDetail.mappings[0].InterfaceFieldAPIName__c && !activeMappingDetail.DomainObjectFieldAPIName__c }">\n                    <label for="domainObject">{{ ::\'DRMapperExtractJSONOutputPath\' | localize:\'Extract Output Path\' }}</label>\n                    <input type="text" name="jsonOutputPath" class="form-control" ng-model="activeMappingDetail.DomainObjectFieldAPIName__c"\n                        data-type="info" bs-enabled="activeMappingDetail.DomainObjectFieldAPIName__c != null && activeMappingDetail.DomainObjectFieldAPIName__c != \'\'"\n                        data-trigger="focus" data-placement="bottom" id="active-mapping-domain-object-field-api-name-input" data-title="Warning: Changing the Extract JSON Output Path could break your Transform mappings."\n                        bs-tooltip="activeMappingDetail" />\n                    <i class="icon icon-v-warning-circle-line form-control-feedback" aria-hidden="true" ng-if="activeMappingDetail.creationOrderObject() && activeMappingDetail.mappings[0].InterfaceFieldAPIName__c && !activeMappingDetail.DomainObjectFieldAPIName__c"\n                        data-type="info" bs-enabled="true" data-title="You must set an Extract JSON Output Path" bs-tooltip="bundle"></i>\n                </div>\n                <div class="form-group">\n                    <label for="filter">{{ ::\'DRMapperFilter\' | localize:\'Filter\' }}</label>\n                    <table>\n                        <tbody ng-repeat="mapping in activeMappingDetail.mappings | filter:filterLimitOrderByMappings track by mapping.MapId__c " id="active-mapping-filter-{{$index}}">\n                            <tr>\n                                <td colspan="2">\n                                    <input name="domainObject" class="form-control" type="text" id="active-mapping-filter-interface-field-api-name-{{index}}-select"\n                                        ng-model="mapping.InterfaceFieldAPIName__c" bs-options="field.name as field.name for field in sObjectFields.syncGetFieldsForObject(activeMappingDetail.InterfaceObjectName__c(), true, $viewValue)"\n                                        data-min-length="0" data-auto-select="true" bs-typeahead container="#main-body" />\n                                </td>\n                                <td colspan="2">&nbsp;</td>\n                            </tr>\n                            <tr>\n                                <td style="text-align: center" colspan="2">\n                                    &nbsp;\n                                    <select class="filter-operator form-control" ng-options="name for name in viewModel.filterOptions" id="active-mapping-filter-filter-operator-{{index}}-select"\n                                        ng-model="mapping.FilterOperator__c"></select>&nbsp;</td>\n                                <td colspan="2">&nbsp;</td>\n                            </tr>\n                            <tr>\n                                <td colspan="2">\n                                    <input type="text" class="form-control" ng-model="mapping.FilterValue__c" id="active-mapping-filter-filter-value-{{index}}-input"\n                                    />\n                                </td>\n                                <td><a class="btn btn-link" ng-click="addFilterMapping(activeMappingDetail)" id="active-mapping-filter-and-{{index}}-button">{{ ::\'DRMapperAND\' | localize:\'AND\' }}</a></td>\n                                <td>\n                                    <a class="icon icon-v-trash-line" ng-click="confirmDeleteMapping(mapping, $first && $last)"></a>\n                                </td>\n                            </tr>\n                        </tbody>\n                        <tbody>\n                            <tr ng-repeat="mapping in activeMappingDetail.mappings | only:\'LIMIT\'">\n                                <td>\n                                    {{ ::\'DRLimit\' | localize:\'LIMIT\' }}\n                                </td>\n                                <td>\n                                    <input type="number" class="form-control" ng-model="mapping.FilterValue__c" ng-change="updateFilterMapping(activeMappingDetail, mapping, \'LIMIT\')"\n                                        id="active-mapping-limit-filter-input" /></td>\n                            </tr>\n                            <tr ng-repeat="mapping in activeMappingDetail.mappings | only:\'ORDER BY\'">\n                                <td>\n                                    {{ ::\'DROrderBy\' | localize:\'ORDER BY\' }}\n                                </td>\n                                <td>\n                                    <input type="text" class="form-control" ng-model="mapping.FilterValue__c" ng-change="updateFilterMapping(activeMappingDetail, mapping, \'ORDER BY\')"\n                                        id="active-mapping-order-by-filter-input" /></td>\n                            </tr>\n                        </tbody>\n                        <tr>\n                        </tr>\n                    </table>\n                </div>\n            </div>\n            <div ng-if="viewModel.activeTab === 2">\n                <div class="form-group">\n                    <label for="domainObject">{{ ::\'DRMapperExtractJSONPath\' | localize:\'Extract JSON Path\' }}</label>\n                    <input name="domainObject" class="form-control" type="text" id="active-mapping-interface-field-api-name-select" ng-model="activeMappingDetail.InterfaceFieldAPIName__c"\n                        bs-options="field.name as field.name for field in sObjectFields.syncGetFieldsForObject(\'json\', true, $viewValue)"\n                        data-min-length="0" data-auto-select="true" bs-typeahead container="#main-body" />\n                    </select>\n                </div>\n                <div class="form-group">\n                    <label for="domainObjectField">{{ ::\'DRMapperJSONOutputPath\' | localize:\'Output Path\' }}</label>\n                    <input class="form-control" type="text" id="active-mapping-domain-object-field-api-name-input" ng-model="activeMappingDetail.DomainObjectFieldAPIName__c"\n                    />\n                </div>\n                <div class="form-group">\n                    <label>\n                <input type="checkbox"\n                        ng-model="activeMappingDetail.IsDisabled__c"\n                        ng-true-value="false"\n                        id="active-mapping-is-disabled-checkbox"\n                        ng-false-value="true"/> {{ ::\'DRMapperActive\' | localize:\'Active\' }}\n            </label>\n                </div>\n                <div class="checkbox">\n                    <label>\n                <input type="checkbox" ng-model="viewModel.showDefault"\n                        id="active-mapping-show-default-checkbox"\n                        ng-change="viewModel.showDefault ? activeMappingDetail.DefaultValue__c = \'\' : null"/>\n                {{ ::\'DRMapperDefaultValue\' | localize:\'Default Value\' }}\n            </label>\n                </div>\n                <div class="form-group" ng-if="viewModel.showDefault">\n                    <input type="text" class="form-control" id="active-mapping-default-value-input" ng-model="activeMappingDetail.DefaultValue__c"\n                    />\n                </div>\n                <div class="form-group">\n                    <label>{{ ::\'DRDomainObjectFieldType\' | localize:\'Output Data Type\' }}</label>\n                    <select name="docusign" class="form-control" ng-options="option as option for option in domainObjectFieldTypeOptions" id="active-mapping-domain-object-field-type-select"\n                        ng-model="activeMappingDetail.DomainObjectFieldType__c">\n                        </select>\n                </div>\n                <div ng-include="\'transformValuesMap.right.tpl.html\'"></div>\n            </div>\n        </div>\n    </div>\n    <div ng-if="viewModel.activeTab == 2">\n        <div ng-if="bundle.OutputType__c == \'JSON\'" class="panel panel-sf panel-extraction-json">\n            <div class="panel-heading">\n            {{ ::\'DRMapperTargetJSONOutput\' | localize:\'Target JSON Output\' }}\n            </div>\n            <div class="panel-body">    \n                <div class="form-group"\n                     ng-class="{ \'has-error has-feedback\': !bundle.TargetOutJson__c }">\n                 <textarea class="form-control" placeholder="Paste your expected Output JSON here" rows="5"\n                    ng-model="bundle.TargetOutJson__c"\n                    id="bundle-target-out-json-textarea"\n                    ng-change="formatJSON(\'TargetOutJson__c\')"></textarea>\n            <span class="icon-v-close-circle form-control-feedback" aria-hidden="true"\n                    ng-if="!bundle.TargetOutJson__c"></span>\n            </div>\n            </div>\n        </div>\n\n        <div ng-if="bundle.OutputType__c == \'XML\'" class="panel panel-sf panel-extraction-json">\n            <div class="panel-heading">\n            {{ ::\'DRMapperTargetXMLOutput\' | localize: \'Target XML Output\' }}\n            </div>\n            <div class="panel-body">    \n                <div class="form-group"\n                     ng-class="{ \'has-error has-feedback\': !bundle.TargetOutXml__c }">\n                <textarea class="form-control" placeholder="Paste your expected Output XML here" rows="5"\n                  ng-model="bundle.TargetOutXml__c"\n                  id="bundle-target-out-json-textarea"\n                  ng-init="formatXML(\'TargetOutXml__c\')"\n                  ng-change="formatXML(\'TargetOutXml__c\')"></textarea>\n                    <span class="icon-v-close-circle form-control-feedback" aria-hidden="true"\n                          ng-if="!bundle.TargetOutXml__c"></span>\n                </div>\n            </div>\n        </div>\n    </div>\n    <div ng-if="viewModel.activeTab !== 1">\n        <div class="panel panel-sf panel-extraction-json">\n            <div class="panel-heading" ng-if="viewModel.activeTab === 0">\n                {{ ::\'DRMapperExtractionStepJSON\' | localize:\'Extraction Step JSON\' }}\n            </div>\n            <div class="panel-heading" ng-if="viewModel.activeTab === 2 && bundle.OutputType__c == \'JSON\'">\n                {{ ::\'DRMapperOutputJSON\' | localize:\'Output JSON\'  }}\n            </div>\n            <div class="panel-heading" ng-if="viewModel.activeTab === 2 && bundle.OutputType__c == \'XML\'">\n                {{ ::\'DRMapperOutputXML\' | localize:\'Output XML\' }}\n            </div>\n            <div class="panel-body">\n                <div ng-if="viewModel.activeTab === 0">\n                    <div class="checkbox">\n                        <label>\n                        <input type="checkbox" ng-model="viewModel.showAllPhaseOneObjectProperties"\n                                id="active-mapping-show-all-phase-one-object-properties"/>\n                        {{ ::\'DRMapperShowSObjectFields\' | localize:\'Show all sObject Fields\' }}\n                        </label>\n                    </div>\n                </div>\n                    <pre ng-if="viewModel.activeTab === 0">{{viewModel.phaseone_json | json:2 }}</pre>\n                    <pre ng-if="viewModel.activeTab === 2 && bundle.OutputType__c == \'JSON\'">{{viewModel.phasetwo_json | json:2 }}</pre>\n                    <pre ng-if="viewModel.activeTab === 2 && bundle.OutputType__c == \'XML\'">{{ viewModel.jsonDisplayedAsXml }}</pre>\n                </div>\n            </div>\n        </div>\n    </div>\n    \n</form>'),$templateCache.put("formulaMapping.center.tpl.html",'<div class="panel-heading">\n    {{ ::\'DRMapperFormulaMappings\' | localize:\'Formula Mappings\' }}\n    <button class="btn btn-primary pull-right" id="add-new-mapping-button" ng-click="addNewFormulaMapping()">{{ ::\'DRMapperNewFormulaMapping\' | localize:\'New Formula Mapping\' }}</button>\n</div>\n<table class="table">\n    <colgroup>\n        <col width="80px" />\n        <col />\n        <col width="320px" />\n        <col width="80px" />\n    </colgroup>\n    <thead>\n        <tr>\n            <th>{{ ::\'DRMapperFormulaOrderField\' | localize:\'Order\' }}</th>\n            <th>{{ ::\'DRMapperFormulaField\' | localize:\'Formula\' }}</th>\n            <th>{{ ::\'DRMapperFormulaResultPath\' | localize:\'Formula Result Path\' }}\n                <input type="text" ng-model="viewModel.filter.FormulaResultPath__c" placeholder="" required="required" />\n            </th>\n            <th>&nbsp;</th>\n        </tr>\n    </thead>\n</table>\n<table class="table">\n    <colgroup>\n        <col width="80px" />\n        <col />\n        <col width="320px" />\n        <col width="80px" />\n    </colgroup>\n    <tbody>\n        <tr ng-repeat="mapping in mappings | filterByTab:(viewModel.activeTab === (bundle.isExtract() ? 1 : 0)) | filterByViewModel:viewModel.filter | orderBy:[\'FormulaOrder__c\'] track by $index"\n            id="mapping-{{index}}" ng-click="onMapItemClick(mapping)" ng-class="{ \'active\': activeMappingDetail.MapId__c && mapping.MapId__c == activeMappingDetail.MapId__c && (!mapping._errors || mapping._errors.length == 0) , \'warning\': mapping.IsDisabled__c, \'danger\': mapping._errors.length > 0 }"\n            data-container=".container" data-placement="right" data-type="info" bs-tooltip="tooltip" bs-enabled="mapping.IsDisabled__c || mapping._errors.length > 0"\n            data-title="{{getMappingTooltipTitle(mapping)}}">\n            <td via-bind-ellipsis="mapping.FormulaOrder__c"></td>\n            <td via-bind-ellipsis="mapping.Formula__c"></td>\n            <td via-bind-ellipsis="mapping.FormulaResultPath__c"></td>\n            <td class="icon-cell">\n                <a ng-if="!mapping.saving" class="icon icon-v-trash-line" id="delete-mapping-{{index}}-button" ng-click="confirmDeleteMapping(mapping)"></a>\n                <span ng-if="mapping.saving" class="spinner pull-right"></span>\n            </td>\n        </tr>\n    </tbody>\n</table>'),$templateCache.put("formulaMapping.right.tpl.html","<div class=\"panel-heading\">\n    {{ ::'DRMapperMappingDetail' | localize:'Mapping Detail' }}\n</div>\n<div class=\"panel-body\" ng-if=\"!activeMappingDetail\">\n    <p>{{ ::'DRMapperMappingDetailEmpty1' | localize:'Select a mapping from the Data Mappings table or click' }} <a\n            class=\"btn btn-primary btn-sm\" id=\"active-column-add-new-mapping-button\" ng-click=\"addNewFormulaMapping()\">{{ ::'DRMapperNew' | localize:'New' }}</a>\n        {{ ::'DRMapperMappingDetailEmpty2' | localize:'to create one' }}\n    </p>\n</div>\n"+'<div class="panel-body" ng-if="activeMappingDetail">\n    <div class="form-group">\n        <label for="formula">{{ ::\'DRMapperFormula\' | localize:\'Formula\' }}</label>\n        <textarea id="active-mapping-domain-formula" class="form-control" name="formula" ng-model="activeMappingDetail.Formula__c" rows="3"/>\n    </div>\n    <div class="form-group">\n        <label for="formulaResultPath">{{ ::\'DRMapperFormulaResultPathField\' | localize:\'Formula Result Path\' }}</label>\n        <input name="formulaResultPath" class="form-control" type="text" id="active-mapping-domain-formula-result-path"\n            ng-model="activeMappingDetail.FormulaResultPath__c" />\n    </div>\n    <div class="form-group">\n        <label for="formulaOrder">{{ ::\'DRMapperFormulaOrderField\' | localize:\'Order\' }}</label>\n        <input name="formulaOrder" class="form-control" type="number" id="active-mapping-domain-formula-order"\n            ng-model="activeMappingDetail.FormulaOrder__c" />\n    </div>\n    <div class="form-group">\n        <label>\n            <input type="checkbox"\n                id="active-mapping-is-disabled-checkbox"\n                ng-model="activeMappingDetail.IsDisabled__c"\n                ng-true-value="false"\n                ng-false-value="true"/> {{ ::\'DRMapperActive\' | localize:\'Active\' }}\n        </label>\n    </div>\n</div>\n\n'),$templateCache.put("loadObjectJson.center.tpl.html",'<div bs-active-pane="viewModel.activeTab" bs-tabs="bs-tabs">\n    <div ng-repeat="tab in viewModel.tabs" title="{{tab.title}}" bs-pane="bs-pane"></div>\n</div>\n<div class="panel panel-sf" ng-if="viewModel.activeTab === 0" ng-include="\'formulaMapping.center.tpl.html\'"></div>\n<div class="panel panel-sf" ng-if="viewModel.activeTab !== 0">\n    <div class="panel-heading">\n        {{ ::\'DRMapperDataMappings\' | localize:\'Data Mappings\' }}\n        <button class="btn btn-primary pull-right" id="add-new-mapping-button" ng-click="addNewMapping()">{{ ::\'DRMapperNewMapping\' | localize:\'New Mapping\' }}</button>\n        <div class="pull-right">\n            <label>\n                <input type="checkbox" ng-model="viewModel.showRequiredMappings" id="show-required-mappings-checkbox" />\n                {{ ::\'DRMapperShowDomainObjReqFields\' | localize:\'Show domain object required fields\' }}\n            </label>\n        </div>\n    </div>\n    <table class="table">\n        <colgroup>\n            <col />\n            <col width="80px" />\n            <col />\n            <col />\n            <col width="45px" />\n            <col width="45px" />\n            <col width="45px" />\n        </colgroup>\n        <thead>\n            <tr>\n                <th>{{ ::\'DRMapperInterfaceField\' | localize:\'Interface Field\' }}\n                    <input type="text" ng-model="viewModel.filter.InterfaceFieldAPIName__c" placeholder="" required="required" />\n                </th>\n                <th>{{ ::\'DRMapperSequence\' | localize:\'Sequence\' }}</th>\n                <th>{{ ::\'DRMapperDomainObject\' | localize:\'Domain Object\' }}\n                    <input type="text" ng-model="viewModel.filter.DomainObjectAPIName__c" placeholder="" required="required" />\n                </th>\n                <th>{{ ::\'DRMapperDomainObjectField\' | localize:\'Domain Object Field\' }}\n                    <input type="text" ng-model="viewModel.filter.DomainObjectFieldAPIName__c" placeholder="" required="required" />\n                </th>\n                <th>&nbsp;</th>\n                <th>&nbsp;</th>\n                <th>&nbsp;</th>\n            </tr>\n        </thead>\n    </table>\n    <table class="table">\n        <!-- INBOUND -->\n        <colgroup>\n            <col />\n            <col width="80px" />\n            <col />\n            <col />\n            <col width="45px" />\n            <col width="45px" />\n            <col width="45px" />\n        </colgroup>\n        <tbody>\n            <tr ng-repeat="mapping in mappings | filterByTab:(viewModel.activeTab === 0) | filterByViewModel:viewModel.filter | orderBy: [\'DomainObjectCreationOrder__c\', \'InterfaceFieldAPIName__c\', \'DomainObjectFieldAPIName__c\'] track by $index"\n                id="mapping-{{index}}" ng-click="onMapItemClick(mapping)" ng-class="{ \'active\': activeMappingDetail.MapId__c && mapping.MapId__c == activeMappingDetail.MapId__c && (!mapping._errors || mapping._errors.length == 0) , \'warning\': mapping.IsDisabled__c, \'danger\': mapping._errors.length > 0 }"\n                data-container=".container" data-placement="right" data-type="info" bs-tooltip="tooltip" bs-enabled="mapping.IsDisabled__c || mapping._errors.length > 0"\n                data-title="{{getMappingTooltipTitle(mapping)}}">\n                <td via-bind-ellipsis="mapping.InterfaceFieldAPIName__c"></td>\n                <td class="text-center">{{mapping.DomainObjectCreationOrder__c}}</td>\n                <td via-bind-ellipsis="mapping.DomainObjectAPIName__c"></td>\n                <td via-bind-ellipsis="mapping.DomainObjectFieldAPIName__c"></td>\n                <td class="icon-cell">\n                    <i ng-if="mapping.mapType() == \'Linked\'" class="icon icon-v-link" data-container=".container" data-html="true" data-placement="right"\n                        data-type="info" bs-tooltip="tooltip" data-title="<table><tr><td>{{ ::\'DRMapperObject\' | localize:\'Object\' }}:</td><td>{{mapping.LinkCreatedObject().cobject}}</td></tr><tr><td>{{ ::\'DRMapperRequestedField\' | localize:\'Requested Field\' }}:</td><td>{{mapping.LinkCreatedField__c}}</td</tr></table>"></i>\n                    <i ng-if="mapping.mapType() == \'Lookup\'" class="icon icon-v-search" data-container=".container" data-html="true" data-placement="right"\n                        data-type="info" bs-tooltip="tooltip" data-title="<table><tr><td>{{ ::\'DRMapperObject\' | localize:\'Object\' }}:</td><td>{{mapping.LookupDomainObjectName__c}}</td></tr><tr><td>Field:</td><td>{{mapping.LookupDomainObjectFieldName__c}}</td></tr><tr><td>{{ ::\'DRMapperRequestedField\' | localize:\'Requested Field\' }}:</td><td>{{mapping.LookupDomainObjectName__c}}</td</tr></table>"></i>\n                </td>\n                <td class="icon-cell">\n                    <i ng-if="mapping.UpsertKey__c" class="icon icon-v-key-line" data-container=".container" data-html="true" data-placement="right"\n                        data-type="info" bs-tooltip="tooltip" data-title="<table><tr><td>{{ ::\'DRMapperUpsertKey\' | localize:\'Upsert Key\' }}:</td><td>{{mapping.UpsertKey__c}}</td></tr></table>"></i>\n                </td>\n                <td class="icon-cell">\n                    <a ng-if="!mapping.saving" class="icon icon-v-trash-line" id="delete-mapping-{{index}}-button" ng-click="confirmDeleteMapping(mapping)"></a>\n                    <span ng-if="mapping.saving" class="spinner pull-right"></span>\n                </td>\n            </tr>\n        </tbody>\n        <!-- MISSING MAPPINGS TABLE BODY -->\n        <tbody>\n            <tr ng-repeat="mapping in missingMappings() | filterMissingMappings:mappings | filterByViewModel:viewModel.filter track by $index" ng-click="onMapItemClick(mapping)" ng-class="{ \'active\': activeMappingDetail.MapId__c && mapping.MapId__c == activeMappingDetail.MapId__c, \'warning\': true }"\n                id="missing-mapping-{{index}}" data-container=".container" data-placement="right" data-type="info" bs-tooltip="tooltip"\n                data-title="{{getMappingTooltipTitle(mapping)}}">\n                <td via-bind-ellipsis="mapping.InterfaceFieldAPIName__c"></td>\n                <td colspan="6">&nbsp;</td> \n            </tr>\n        </tbody>\n        <!-- REQUIRED  MAPPINGS TABLE BODY -->\n        <tbody ng-if="viewModel.showRequiredMappings">\n            <tr ng-repeat="mapping in requiredMappings() | orderBy: [\'DomainObjectCreationOrder__c\',\'DomainObjectFieldAPIName__c\'] | filterRequiredMappings:mappings | filterByViewModel:viewModel.filter track by $index"\n                ng-click="onMapItemClick(mapping)" id="required-mapping-{{index}}" ng-class="{ \'active\': activeMappingDetail.MapId__c && mapping.MapId__c == activeMappingDetail.MapId__c, \'warning\': true }"\n                data-container=".container" data-placement="right" data-type="info" bs-tooltip="tooltip" data-title="{{getMappingTooltipTitle(mapping)}}">\n                <td><em>{{ ::\'DRMapperUnmapped\' | localize:\'Unmapped\' }}</em></td>\n                <td class="text-center">{{mapping.DomainObjectCreationOrder__c}}</td>\n                <td via-bind-ellipsis="mapping.DomainObjectAPIName__c"></td>\n                <td via-bind-ellipsis="mapping.DomainObjectFieldAPIName__c"></td>\n                <td colspan="3">&nbsp;</td>\n            </tr>\n        </tbody>\n    </table>\n</div>\n'),
$templateCache.put("loadObjectJson.right.tpl.html",'<form name="form.activeMappingForm" via-affix="via-affix">\n    <div class="panel panel-sf" ng-if="viewModel.activeTab == 0" ng-include="\'formulaMapping.right.tpl.html\'"></div>\n    <div class="panel panel-sf" ng-if="viewModel.activeTab !== 0">\n        <div class="panel-heading">\n            {{ ::\'DRMapperMappingDetail\' | localize:\'Mapping Detail\' }}\n        </div>\n        <div class="panel-body" ng-if="!activeMappingDetail">\n            <p>{{ ::\'DRMapperMappingDetailEmpty1\' | localize:\'Select a mapping from the Data Mappings table or click\' }} <a\n                    class="btn btn-primary btn-sm" id="active-column-add-new-mapping-button" ng-click="addNewMapping()">{{ ::\'DRMapperNew\' | localize:\'New\' }}</a>                {{ ::\'DRMapperMappingDetailEmpty2\' | localize:\'to create one\' }}</p>\n        </div>\n        <div class="panel-body" ng-if="activeMappingDetail">\n            <div class="form-group">\n                <input name="mapping" class="form-control" type="text" id="active-mapping-interface-field-api-name-select" ng-model="activeMappingDetail.InterfaceFieldAPIName__c"\n                    ng-disabled="activeMappingDetail.mapType() == \'Linked\'" bs-options="field.name as field.name for field in sObjectFields.syncGetFieldsForObject(bundle.InterfaceObject__c, true, $viewValue)"\n                    data-min-length="0" data-auto-select="true" bs-typeahead container="#main-body" />\n            </div>\n            <div class="form-group">\n                <label>\n        <input type="checkbox"\n                id="active-mapping-is-disabled-checkbox"\n                ng-model="activeMappingDetail.IsDisabled__c"\n                ng-true-value="false"\n                ng-false-value="true"/> {{ ::\'DRMapperActive\' | localize:\'Active\' }}\n        </label>\n            </div>\n            <div class="form-group">\n                <label for="domainObject">{{ ::\'DRMapperDomainObject\' | localize:\'Domain Object\' }}</label>\n                <select name="domainObject" class="form-control" id="active-mapping-domain-object-select" ng-options="cObject as cObject.label() for cObject in viewModel.creationOrderObjects"\n                    ng-model-options="{ getterSetter: true }" ng-model="activeMappingDetail.creationOrderObject">\n                    </select>\n            </div>\n            <div class="form-group">\n                <label for="domainObjectField">{{ ::\'DRMapperDomainObjectField\' | localize:\'Domain Object Field\' }}</label>\n                <input name="domainObjectField" class="form-control" type="text" id="active-mapping-domain-object-field-api-name-select"\n                    ng-model="activeMappingDetail.DomainObjectFieldAPIName__c" bs-options="field.name as field.name for field in sObjectFields.syncGetFieldsForObject(activeMappingDetail.DomainObjectAPIName__c, true) | filter:{isInputable: true}"\n                    data-min-length="0" data-auto-select="true" bs-typeahead container="#main-body" />\n            </div>\n            <div ng-include="\'transformValuesMap.right.tpl.html\'"></div>\n        </div>\n        <div class="panel panel-sidebar" ng-if="activeMappingDetail">\n            <div class="panel-heading">\n                {{ ::\'DRMapperMappingTypeSettings\' | localize:\'Mapping Type Settings\' }}\n                <i class="icon pull-right" id="active-mapping-toggle-show-field-settings" ng-class="{\'icon-v-right-arrow\':!viewModel.showFieldSettings, \'icon-v-down-arrow\':viewModel.showFieldSettings}"\n                    ng-click="viewModel.showFieldSettings = !viewModel.showFieldSettings"></i>\n            </div>\n            <div class="panel-body collapse" ng-class="{\'in\': viewModel.showFieldSettings}">\n                <div class="form-group text-center">\n                    <div class="btn-group" bs-radio-group="bs-radio-group" ng-model-options="{getterSetter: true}" ng-model="activeMappingDetail.mapType">\n                        <label class="btn btn-sm btn-primary" ng-click="onMapTypeChange(\'None\')">\n            <input \n                id="active-mapping-map-type-None-radio"\n                type="radio" class="btn btn-sm btn-primary" value="None"/>{{ ::\'DRMapperMappingTypeNone\' | localize:\'None\' }}\n            </label>\n                        <label class="btn btn-sm btn-primary" ng-click="onMapTypeChange(\'Linked\')">\n            <input\n                id="active-mapping-map-type-Linked-radio"\n                type="radio" class="btn btn-sm btn-primary" value="Linked" />{{ ::\'DRMapperMappingTypeLinked\' | localize:\'Linked\' }}\n            </label>\n                        <label class="btn btn-sm btn-primary" ng-click="onMapTypeChange(\'Lookup\')">\n            <input \n                id="active-mapping-map-type-Lookup-radio"\n                type="radio" class="btn btn-sm btn-primary" value="Lookup"/>{{ ::\'DRMapperMappingTypeLookUp\' | localize:\'Look-Up\' }}\n            </label>\n                    </div>\n                </div>\n                <div ng-if="activeMappingDetail.mapType() == \'Linked\'">\n                    <div class="form-group">\n                        <label for="linkDomainObject">{{ ::\'DRMapperLinkCreationObject\' | localize:\'Link Creation Object\' }}</label>\n                        <select name="linkDomainObject" class="form-control" ng-options="cObject as cObject.label() for cObject in viewModel.creationOrderObjects | orderBy:\'toString()\'"\n                            id="active-mapping-link-created-object-select" ng-model-options="{ getterSetter: true }" ng-model="activeMappingDetail.LinkCreatedObject">\n                            </select>\n                    </div>\n                    <div class="form-group">\n                        <label for="linkDomainRequestedField">{{ ::\'DRMapperLinkCreationField\' | localize:\'Link Creation Field\' }}</label>\n                        <input name="linkDomainRequestedField" class="form-control" type="text" id="active-mapping-link-created-field-select" ng-model="activeMappingDetail.LinkCreatedField__c"\n                            bs-options="field.name as field.name for (name, field) in sObjectFields.syncGetFieldsForObject(activeMappingDetail.LinkCreatedObject().cobject, true)"\n                            data-min-length="0" data-auto-select="true" bs-typeahead container="#main-body" />\n                    </div>\n                </div>\n                <div ng-if="activeMappingDetail.mapType() == \'Lookup\'">\n                    <div class="form-group">\n                        <label for="lookupDomainObject">{{ ::\'DRMapperLookupObject\' | localize:\'Lookup Object\' }}</label>\n                        <select name="lookupDomainObject" class="form-control" id="active-mapping-lookup-domain-object-name-select" ng-options="object as object for object in sobjectTypes | orderBy: \'toString()\'"\n                            ng-model="activeMappingDetail.LookupDomainObjectName__c">\n                            </select>\n                    </div>\n                    <div class="form-group">\n                        <label for="lookupDomainField">{{ ::\'DRMapperLookupField\' | localize:\'Lookup Field\' }}</label>\n                        <input name="lookupDomainField" class="form-control" type="text" id="active-mapping-lookup-domain-object-field-name-select"\n                            ng-model="activeMappingDetail.LookupDomainObjectFieldName__c" bs-options="field.name as field.name for (name, field) in sObjectFields.syncGetFieldsForObject(activeMappingDetail.LookupDomainObjectName__c, true)"\n                            data-min-length="0" data-auto-select="true" bs-typeahead container="#main-body" />\n                    </div>\n                    <div class="form-group">\n                        <label for="lookupDomainRequestedField">{{ ::\'DRMapperLookupRequestedField\' | localize:\'Lookup Requested Field\' }}</label>\n                        <input name="lookupDomainRequestedField" class="form-control" type="text" id="active-mapping-lookup-domain-object-requested-field-name-select"\n                            ng-model="activeMappingDetail.LookupDomainObjectRequestedFieldName__c" bs-options="field.name as field.name for (name, field) in sObjectFields.syncGetFieldsForObject(activeMappingDetail.LookupDomainObjectName__c, true)"\n                            data-min-length="0" data-auto-select="true" bs-typeahead container="#main-body" />\n                    </div>\n                </div>\n                <div class="checkbox">\n                    <label>\n            <input type="checkbox" ng-model="viewModel.showDefault"\n            id="active-mapping-show-default-checkbox"\n            ng-change="viewModel.showDefault ? activeMappingDetail.DefaultValue__c = \'\' : null"/>\n            {{ ::\'DRMapperDefaultValue\' | localize:\'Default Value\' }}\n        </label>\n                </div>\n                <div class="form-group" ng-if="viewModel.showDefault">\n                    <input type="text" class="form-control" id="active-mapping-default-value-input" ng-model="activeMappingDetail.DefaultValue__c"\n                    />\n                </div>\n                <div class="checkbox">\n                    <label>\n            <input type="checkbox" ng-model="activeMappingDetail.UpsertKey__c"\n                    id="active-mapping-upsert-key-checkbox"/>\n            {{ ::\'DRMapperUpsertKey\' | localize:\'Upsert Key\' }}\n        </label>\n                </div>\n                <div class="checkbox">\n                    <label>\n            <input type="checkbox" ng-model="activeMappingDetail.IsRequiredForUpsert__c"\n                    id="active-mapping-is-required-for-upsert-checkbox"/>\n            {{ ::\'DRMapperIsRequiredForUpsert\' | localize:\'Required for Upsert\' }}\n        </label>\n                </div>\n                 <div class="form-group">\n            <label>{{ ::\'DRDomainObjectFieldType\' | localize:\'Output Data Type\' }}</label>\n            <select name="docusign" class="form-control"\n                    ng-options="option as option for option in domainObjectFieldTypeOptions"\n                    id="active-mapping-domain-object-field-type-select"\n                    ng-model="activeMappingDetail.DomainObjectFieldType__c">\n            </select>\n            </div>\n\n        </div>\n        </div>\n\n    </div>\n</form>'),$templateCache.put("previewExtractTransform.tpl.html",'<div class="slds-col slds-grid slds-grid--vertical-stretch slds-is-relative" style="min-width: 0">\n  <div class="slds-col slds-size--1-of-3 slds-p-around--small slds-grid slds-grid--vertical-stretch">\n    <div class="slds-col slds-box slds-box--small slds-theme--shade slds-grid slds-grid--vertical">\n        <div class="slds-grid slds-m-bottom--small">\n            <div class="slds-text-heading--medium">{{ \'InputParameters\' | localize:\'Input Parameters\' }}</div>\n            <button class="slds-button slds-button--neutral slds-col--bump-left" ng-click="ctrl.toggleJsonMode()" ng-if="!ctrl.jsonMode && ctrl.inputType != \'XML\'">{{ \'EditAsJSON\' | localize:\'Edit as JSON\' }}</button>\n            <button class="slds-button slds-button--neutral slds-col--bump-left" ng-click="ctrl.toggleJsonMode()" ng-if="ctrl.jsonMode || ctrl.inputType == \'XML\'" ng-disabled="ctrl.invalidJSON">{{ \'EditAsParams\' | localize:\'Edit as Params\' }}</button>\n        </div>\n        <div class="slds-form--compound" ng-if="!ctrl.jsonMode">\n          <div class="slds-form-element__group">\n            <div class="slds-form-element__row">\n              <div class="slds-form-element slds-size--1-of-2">\n                <label class="slds-form-element__label">{{\'Key\' | localize:\'Key\'}}</label>\n              </div>\n              <div class="slds-form-element slds-size--1-of-2">\n                <label class="slds-form-element__label">{{\'Value\' | localize:\'Value\'}}</label>\n              </div>\n            </div>          \n          </div>\n        </div>\n        <fieldset class="slds-form--compound" ng-repeat="param in ctrl.params" ng-if="!ctrl.jsonMode">\n          <div class="slds-form-element__group">\n            <div class="slds-form-element__row">\n              <div class="slds-form-element slds-size--1-of-2">\n                <input class="slds-input" type="text" ng-model="param.key" />\n              </div>\n              <div class="slds-form-element slds-size--1-of-2">\n                <input id="input-02" class="slds-input" type="text" ng-model="param.value"/>\n              </div>\n              <button class="slds-button slds-button--icon slds-m-left--x-small" ng-click="ctrl.deleteParam(param)">\n                <slds-button-svg-icon sprite="\'utility\'" icon="\'delete\'"></slds-button-svg-icon>\n              </button>\n            </div>\n          </div>\n        </fieldset>\n        <div class="slds-text-align--center slds-m-bottom--small" ng-if="!ctrl.jsonMode">\n            <button class="slds-button" ng-click="ctrl.addParam()">\n                <slds-button-svg-icon sprite="\'utility\'" icon="\'add\'"></slds-button-svg-icon>\n                {{ \'AddNewKeyValuePair\' | localize:\'Add New Key/Value Pair\' }}\n            </button>\n        </div>\n        <div class="slds-col slds-grid slds-grid--vertical-stretch slds-p-bottom--small slds-form-element" ng-class="{\'slds-has-error\': ctrl.invalidJSON}" ng-if="ctrl.jsonMode">\n          <div class="slds-form-element__control slds-grid slds-grid--vertical-stretch" style="width:100%;">\n            <textarea ng-if="ctrl.inputType == \'XML\'" class="slds-col slds-textarea" style="width: 100%; " ng-model="ctrl.xmlInput"></textarea>\n            <textarea ng-if="ctrl.inputType != \'XML\'" class="slds-col slds-textarea" style="width: 100%; " ng-model="ctrl.jsonParams"></textarea>\n          </div>\n          <div class="slds-form-element__help" ng-if="ctrl.invalidJSON">{{ \'InvalidJSON\' | localize:\'Invalid JSON\'}}</div>\n        </div>\n        <div class="slds-clearfix">\n            <a ng-click="ctrl.reset()" class="slds-button">{{\'ClearData\' | localize:\'Clear Data\'}}</a>\n            <button class="slds-button slds-button--brand slds-float--right" ng-click="ctrl.submitRequest()" ng-disabled="ctrl.invalidJSON  && ctrl.jsonMode">{{ \'Execute\' | localize:\'Execute\' }}</button>\n        </div>\n    </div>\n  </div>\n  <div class="slds-col slds-size--2-of-3 slds-p-top--small slds-p-bottom--small slds-p-right--small slds-grid slds-grid--vertical slds-grid--vertical-stretch">\n    <div class="slds-col slds-box slds-box--small slds-theme--shade slds-text-align--left slds-grid slds-grid--vertical slds-grid--vertical-stretch">\n        <div class="slds-col slds-size--1-of-1 slds-grid slds-grid--vertical slds-grid--vertical-stretch">\n          <div class="slds-col slds-grid slds-grid slds-grid--vertical-stretch">\n            <div class="slds-col slds-size--1-of-2 slds-grid slds-grid--vertical slds-grid--vertical-stretch">\n              <div class="slds-text-heading--medium">{{ \'Response\' | localize:\'Response:\' }}\n              <span class="slds-text-body--regular slds-p-top--x-small slds-float--right" ng-if="ctrl.requestTime">{{ \'ResponseTime\' | localize:\'Response Time\'}}: {{ctrl.requestTime}}ms</span></div>\n              <div class="slds-col slds-grid slds-box slds-theme--default slds-m-top--small" >\n                <pre style="width: 100%;overflow: auto; margin: 0" ng-if="ctrl.outputType == \'JSON\'">{{ctrl.response.returnResultsData | json}}</pre>\n                <pre style="width: 100%;overflow: auto; margin: 0" ng-if="ctrl.outputType == \'XML\'">{{ ctrl.response.returnResultsData }}</pre>\n              </div>\n            </div>\n            <div class="slds-col slds-size--1-of-2 slds-grid slds-grid--vertical slds-grid--vertical-stretch slds-p-left--small ">\n              <div class="slds-text-heading--medium">{{ \'DebugLog\' | localize:\'Debug Log:\' }}</div>\n              <div class="slds-col slds-box slds-theme--default slds-m-top--small" style="overflow: auto;word-break: break-word;">\n                <ul class="slds-list--dotted">\n                  <li ng-repeat="log in ctrl.response.debugLog track by $index" ng-bind-html="log">\n                  </li>\n                </ul>\n              </div>\n            </div>\n          </div>\n        </div>\n        <div class="slds-m-top--small" ng-if="ctrl.response.errors.length > 0">\n          <div class="slds-text-heading--medium">{{ \'Errors\' | localize:\'Errors:\' }}</div>\n          <div class="slds-box slds-theme--default slds-m-top--small">\n            <ul class="slds-list--dotted slds-text-color--error">\n              <li ng-repeat="error in ctrl.response.errors track by $index">{{error.errorCode ? error.errorCode + \' - \' + error.message : error}}</li>\n            </ul>\n          </div>\n        </div>\n    </div>\n  </div>\n\n  <div class="slds-spinner_container" ng-if="ctrl.requesting">\n      <div class="slds-spinner--brand slds-spinner slds-spinner--medium" role="alert">\n        <span class="slds-assistive-text">Loading</span>\n        <div class="slds-spinner__dot-a"></div>\n        <div class="slds-spinner__dot-b"></div>\n      </div>\n    </div>\n</div>'),$templateCache.put("previewLoadJson.tpl.html",'<div class="slds-col slds-grid slds-grid--vertical-stretch slds-is-relative" style="min-width: 0">\n  <div class="slds-col slds-size--1-of-3 slds-p-around--small slds-grid slds-grid--vertical-stretch">\n    <div class="slds-col slds-box slds-box--small slds-theme--shade slds-grid slds-grid--vertical">\n        <div class="slds-grid slds-m-bottom--small">\n            <div class="slds-text-heading--medium">{{ \'InputJSONs\' | localize:\'Input\' }}</div>\n        </div>\n        <div class="slds-col slds-grid slds-grid--vertical-stretch slds-p-bottom--small slds-form-element" ng-class="{\'slds-has-error\': ctrl.invalidJSON}" ng-if="ctrl.inputType == \'JSON\'">\n          <div class="slds-col slds-form-element__control slds-grid slds-grid--vertical-stretch" style="width:100%">\n            <textarea class="slds-textarea slds-col" style="width:100%;" ng-model="ctrl.inputJson"></textarea>\n          </div>\n          <div class="slds-form-element__help" ng-if="ctrl.invalidJSON">{{ \'InvalidJSON\' | localize:\'Invalid JSON\'}}</div>\n        </div>\n        <div class="slds-col slds-grid slds-grid--vertical-stretch slds-p-bottom--small slds-form-element" ng-if="ctrl.inputType == \'XML\'">\n          <div class="slds-col slds-form-element__control slds-grid slds-grid--vertical-stretch" style="width:100%">\n            <textarea class="slds-textarea slds-col" style="width:100%;" ng-model="ctrl.xmlInput"></textarea>\n          </div>\n        </div>\n        <div class="slds-col slds-grid slds-grid--vertical-stretch slds-p-bottom--small slds-form-element" ng-if="ctrl.inputType == \'SObject\' && !ctrl.isTransform">\n          <div class="slds-col slds-form-element__control slds-grid slds-grid--vertical-stretch" style="width:100%">\n            <textarea class="slds-textarea slds-col" style="width:100%;" ng-model="ctrl.inputRows"></textarea>\n        </div>\n        </div>\n        <fieldset class="slds-form--compound slds-hide">\n          <!-- show when bulkupload logic is ready -->\n          <div class="slds-form-element__group">\n            <div class="slds-form-element__row">\n              <div class="slds-form-element slds-size--1-of-2">\n                <div class="slds-form-element__control">\n                  <span class="slds-checkbox">\n                    <input type="checkbox" ng-model="ctrl.simulate" id="simulate" />\n                    <label class="slds-checkbox__label" for="simulate">\n                      <span class="slds-checkbox--faux"></span>\n                      <span class="slds-form-element__label">{{ \'Simulate\' | localize:\'Simulate?\'}}</span>\n                    </label>\n                  </span>\n                </div>\n              </div>\n              <div class="slds-form-element slds-size--1-of-2">\n                <div class="slds-form-element__control">\n                  <span class="slds-checkbox">\n                    <input type="checkbox" ng-model="ctrl.bulkUpload" id="bulkUpload"/>\n                    <label class="slds-checkbox__label" for="bulkUpload">\n                      <span class="slds-checkbox--faux"></span>\n                      <span class="slds-form-element__label">{{ \'BulkUpload\' | localize:\'Bulk Upload?\'}}</span>\n                    </label>\n                  </span>\n                </div>\n              </div>\n            </div>\n          </div>\n        </fieldset>\n        <div class="slds-clearfix" >\n            <a ng-click="ctrl.reset()" class="slds-button">{{\'ClearData\' | localize:\'Clear Data\'}}</a>\n            <button class="slds-button slds-button--brand slds-float--right" ng-click="ctrl.submitRequest()" ng-disabled="ctrl.invalidJSON">{{ \'Execute\' | localize:\'Execute\' }}</button>\n        </div>\n    </div>\n  </div>\n  <div class="slds-col slds-size--2-of-3 slds-p-top--small slds-p-bottom--small slds-p-right--small slds-grid slds-grid--vertical slds-grid--vertical-stretch">\n    <div class="slds-col slds-box slds-box--small slds-theme--shade slds-text-align--left slds-grid slds-grid--vertical slds-grid--vertical-stretch">\n        <div class="slds-col slds-size--1-of-1 slds-grid slds-grid--vertical slds-grid--vertical-stretch">\n          <div class="slds-col slds-grid slds-grid slds-grid--vertical-stretch">\n            <div class="slds-col slds-size--1-of-2 slds-grid slds-grid--vertical slds-grid--vertical-stretch" ng-if="!ctrl.isTransform">\n              <div class="slds-text-heading--medium" >{{ \'ObjectsCreated\' | localize:\'Objects Created:\' }}<span class="slds-text-body--regular slds-p-top--x-small slds-float--right" ng-if="ctrl.requestTime">{{ \'ResponseTime\' | localize:\'Response Time\'}}: {{ctrl.requestTime}}ms</span></div>\n              <div class="slds-col slds-box slds-theme--default slds-m-top--small">\n                <ul class="slds-list--dotted">\n                  <li ng-repeat="object in ctrl.response.createdObjects track by $index">\n                    <a href="/{{object.id}}">{{object.index}}- {{object.type}}: {{object.id}}</a>\n                  </li>\n                </ul>\n              </div>\n            </div>\n            <div class="slds-col slds-size--1-of-2 slds-grid slds-grid--vertical slds-grid--vertical-stretch" ng-if="ctrl.isTransform">\n              <div class="slds-text-heading--medium">{{ \'Response\' | localize:\'Response:\' }}\n              <span class="slds-text-body--regular slds-p-top--x-small slds-float--right" ng-if="ctrl.requestTime">{{ \'ResponseTime\' | localize:\'Response Time\'}}: {{ctrl.requestTime}}ms</span></div>\n              <div class="slds-col slds-box slds-theme--default slds-m-top--small slds-grid" >\n                <pre style="width: 100%;overflow: auto; margin: 0" ng-if="ctrl.outputType == \'JSON\'">{{ctrl.response.returnResultsData | json}}</pre>\n                <pre style="width: 100%;overflow: auto; margin: 0" ng-if="ctrl.outputType == \'XML\'">{{ ctrl.response.returnResultsData }}</pre>\n              </div>\n            </div>\n            <div class="slds-col slds-size--1-of-2 slds-grid slds-grid--vertical slds-grid--vertical-stretch slds-p-left--small ">\n              <div class="slds-text-heading--medium">{{ \'DebugLog\' | localize:\'Debug Log:\' }}</div>\n              <div class="slds-col slds-box slds-theme--default slds-m-top--small" style="overflow: auto;word-break: break-word;">\n                <ul class="slds-list--dotted">\n                  <li ng-repeat="log in ctrl.response.debugLog track by $index" ng-bind-html="log">\n                  </li>\n                </ul>\n              </div>\n            </div>\n          </div>\n        </div>\n        <div class="slds-m-top--small" ng-if="ctrl.response.errors.length > 0">\n          <div class="slds-text-heading--medium">{{ \'Errors\' | localize:\'Errors:\' }}</div>\n          <div class="slds-box slds-theme--default slds-m-top--small">\n            <ul class="slds-list--dotted slds-text-color--error">\n              <li ng-repeat="error in ctrl.response.errors track by $index">{{error.errorCode ? error.errorCode + \' - \' + error.message : error}}</li>\n            </ul>\n          </div>\n        </div>\n    </div>\n  </div>\n\n  <div class="slds-spinner_container" ng-if="ctrl.requesting">\n      <div class="slds-spinner--brand slds-spinner slds-spinner--medium" role="alert">\n        <span class="slds-assistive-text">Loading</span>\n        <div class="slds-spinner__dot-a"></div>\n        <div class="slds-spinner__dot-b"></div>\n      </div>\n    </div>\n</div>'),$templateCache.put("transform.center.tpl.html",'<div bs-active-pane="viewModel.activeTab" bs-tabs="bs-tabs">\n    <div ng-repeat="tab in viewModel.tabs" title="{{tab.title}}" bs-pane="bs-pane"></div>\n</div>\n<div class="panel panel-sf" ng-if="viewModel.activeTab === 0" ng-include="\'formulaMapping.center.tpl.html\'"></div>\n<div class="panel panel-sf" ng-if="viewModel.activeTab !== 0">\n    <div class="panel-heading">\n        {{ ::\'DRMapperDataMappings\' | localize:\'Data Mappings\' }}\n        <button class="btn btn-primary pull-right" id="add-new-mapping-button" ng-click="addNewMapping()">{{ ::\'DRMapperNewMapping\' | localize:\'New Mapping\' }}</button>\n    </div>\n    <table class="table">\n        <colgroup>\n            <col />\n            <col />\n            <col width="45px" />\n        </colgroup>\n        <thead>\n            <tr>\n                <th>{{ ::\'DRMapperInputPath\' | localize:\'Input Path\' }}\n                    <input type="text" ng-model="viewModel.filter.InterfaceFieldAPIName__c" placeholder="" required="required" />\n                </th>\n                <th>{{ ::\'DRMapperOutputPath\' | localize:\'Output Path\' }}\n                    <input type="text" ng-model="viewModel.filter.DomainObjectFieldAPIName__c" placeholder="" required="required" />\n                </th>\n                <th>&nbsp;</th>\n            </tr>\n        </thead>\n    </table>\n    <table class="table">\n        <colgroup>\n            <col />\n            <col />\n            <col width="45px" />\n        </colgroup>\n        <tbody>\n            <tr ng-repeat="mapping in mappings | filterByTab:(viewModel.activeTab === 0) | filterByViewModel:viewModel.filter  | orderBy: [\'InterfaceFieldAPIName__c\', \'DomainObjectFieldAPIName__c\'] track by $index" ng-click="onMapItemClick(mapping)"\n                ng-class="{ \'active\': activeMappingDetail.MapId__c && mapping.MapId__c == activeMappingDetail.MapId__c && (!mapping._errors || mapping._errors.length == 0), \'danger\': mapping._errors.length > 0, \'warning\': mapping.IsDisabled__c }"\n                id="mapping-{{index}}" data-container=".container" data-placement="right" data-type="info" bs-tooltip="tooltip"\n                bs-enabled="mapping.IsDisabled__c || mapping._errors.length > 0" data-title="{{getMappingTooltipTitle(mapping)}}">\n                <td via-bind-ellipsis="mapping.InterfaceFieldAPIName__c"></td>\n                <td via-bind-ellipsis="mapping.DomainObjectFieldAPIName__c"></td>\n                <td class="icon-cell">\n                    <a ng-if="!mapping.saving" class="icon icon-v-trash-line" id="delete-mapping-{{index}}-button" ng-click="confirmDeleteMapping(mapping)"></a>\n                    <span ng-if="mapping.saving" class="spinner pull-right"></span>\n                </td>\n            </tr>\n        </tbody>\n        <!-- OUTBOUND JSON FIELDS TABLE BODY -->\n        <tbody>\n            <tr ng-repeat="mapping in requiredAndMissingMappings() | transformMappingSortFilter:mappings | filterByViewModel:viewModel.filter| orderBy: [\'InterfaceFieldAPIName__c\', \'DomainObjectFieldAPIName__c\'] track by $index" ng-click="onMapItemClick(mapping)"\n                ng-class="{ \'active\': activeMappingDetail.MapId__c && mapping.MapId__c == activeMappingDetail.MapId__c, \'warning\': true }"\n                id="required-missing-mapping-{{index}}" data-container=".container" data-placement="right" data-type="info" bs-tooltip="tooltip"\n                data-title="{{getMappingTooltipTitle(mapping)}}">\n                <td via-bind-ellipsis="mapping.InterfaceFieldAPIName__c"></td>\n                <td via-bind-ellipsis="mapping.DomainObjectFieldAPIName__c"></td>\n                <td>&nbsp;</td>\n            </tr>\n        </tbody>\n    </table>\n</div>'),$templateCache.put("transform.right.tpl.html",'<form name="form.activeMappingForm" via-affix="via-affix">\n    <div class="panel panel-sf" ng-if="viewModel.activeTab == 0" ng-include="\'formulaMapping.right.tpl.html\'" ></div>\n    <div class="panel panel-sf" ng-if="viewModel.activeTab !== 0">\n        <div class="panel-heading">\n        {{ ::\'DRMapperMappingDetail\' | localize:\'Mapping Detail\' }}\n        </div>\n        <div class="panel-body" ng-if="!activeMappingDetail">\n        <p>{{ ::\'DRMapperMappingDetailEmpty1\' | localize:\'Select a mapping from the Data Mappings table or click\' }} <a class="btn btn-primary btn-sm"\n                id="active-mapping-add-new-mapping-button"\n                ng-click="addNewMapping()">{{ ::\'DRMapperNew\' | localize:\'New\' }}</a> {{ ::\'DRMapperMappingDetailEmpty2\' | localize:\'to create one\' }}</p>\n        </div>\n        <div class="panel-body" ng-if="activeMappingDetail">\n            <div class="form-group">\n                <label>{{ ::\'DRMapperInputPath\' | localize:\'Input Path\' }}</label>\n                <input type="text" class="form-control"\n                        bs-options="value for value in fieldNamesforSuggest()"\n                        id="active-mapping-interface-field-api-name-input"\n                        bs-typeahead="bs-typeahead"\n                        data-min-length="0"\n                        ng-model="activeMappingDetail.InterfaceFieldAPIName__c" />\n            </div>\n            <div class="form-group">\n                <label>{{ ::\'DRMapperOutputPath\' | localize:\'Output Path\' }}</label>\n                <input type="text" class="form-control"\n                        bs-options="value for value in fieldNamesforSuggest()"\n                        bs-typeahead="bs-typeahead"\n                        id="active-mapping-domain-object-field-api-name-input"\n                        data-min-length="0"\n                        ng-disabled="viewModel.outboundMappingType === \'doctemplate\'"\n                        ng-model="activeMappingDetail.DomainObjectFieldAPIName__c" />\n            </div>\n            <div class="checkbox">\n                <label>\n                <input type="checkbox" \n                        ng-model="activeMappingDetail.IsDisabled__c" \n                        id="active-mapping-is-disabled-checkbox"\n                        ng-true-value="false"\n                        ng-false-value="true"/>\n                {{ ::\'DRMapperActive\' | localize:\'Active\' }}\n                </label>\n            </div>\n            <div class="checkbox">\n                <label>\n                <input type="checkbox" ng-model="viewModel.showDefault"\n                        id="active-mapping-show-default-checkbox"\n                        ng-change="viewModel.showDefault ? activeMappingDetail.DefaultValue__c = \'\' : null"/>\n                {{ ::\'DRMapperDefaultValue\' | localize:\'Default Value\' }}\n                </label>\n            </div>\n            <div class="form-group" ng-if="viewModel.showDefault">\n                <input type="text" class="form-control"\n                        id="active-mapping-default-value-input"\n                        ng-model="activeMappingDetail.DefaultValue__c"/>\n            </div>\n            <div class="form-group">\n                <label>{{ ::\'DRDomainObjectFieldType\' | localize:\'Output Data Type\' }}</label>\n                <select name="docusign" class="form-control"\n                        ng-options="option as option for option in domainObjectFieldTypeOptions"\n                        id="active-mapping-domain-object-field-type-select"\n                        ng-model="activeMappingDetail.DomainObjectFieldType__c">\n                </select>\n            </div>\n            <div ng-include="\'transformValuesMap.right.tpl.html\'"></div>\n        </div>\n    </div>\n    <div class="panel panel-sf" ng-if="viewModel.activeTab !== 0 && bundle.OutputType__c == \'XML\'">\n        <div class="panel-heading">\n        {{ ::\'DRMapperTargetXMLOutput\' | localize:\'Target XML Output\' }}\n        </div>\n        <div class="panel-body">    \n            <div class="form-group"\n                 ng-class="{ \'has-error has-feedback\': !bundle.TargetOutXml__c }">\n            <textarea class="form-control" placeholder="Paste your expected Output XML here" rows="5"\n              ng-model="bundle.TargetOutXml__c"\n              id="bundle-target-out-json-textarea"\n              ng-init="formatXML(\'TargetOutXml__c\')"\n              ng-change="formatXML(\'TargetOutXml__c\')"></textarea>\n                <span class="icon-v-close-circle form-control-feedback" aria-hidden="true"\n                      ng-if="!bundle.TargetOutXml__c"></span>\n            </div>\n        </div>\n    </div>\n    <div class="panel panel-sf" ng-if="viewModel.activeTab !== 0 && bundle.OutputType__c == \'JSON\'">\n        <div class="panel-heading">\n        {{ ::\'DRMapperAddOutboundMappings\' | localize:\'Add Outbound Mappings\' }}\n        <i class="icon pull-right"\n                ng-class="{\'icon-v-right-arrow\':!viewModel.showOutboundMappings, \'icon-v-down-arrow\':viewModel.showOutboundMappings}"\n                id="active-mapping-toggle-show-outbound-mappings"\n                ng-click="viewModel.showOutboundMappings = !viewModel.showOutboundMappings"></i>\n        </div>\n        <div class="panel-body collapse" ng-class="{\'in\': viewModel.showOutboundMappings}">\n        <div class="form-group text-center">\n            <div class="btn-group" bs-radio-group="bs-radio-group"\n                ng-model="viewModel.outboundMappingType">\n            <label class="btn btn-sm btn-primary" ng-mouseup="onOutboundMappingTypeChange(\'JSON\', $event)">\n                <input type="radio" class="btn btn-sm btn-primary" value="JSON" \n                        id="active-mapping-outbound-mapping-type-JSON-radio"/>JSON\n            </label>\n            <label class="btn btn-sm btn-primary" ng-mouseup="onOutboundMappingTypeChange(\'PDF\', $event)">\n                <input type="radio" class="btn btn-sm btn-primary" value="PDF" \n                        id="active-mapping-outbound-mapping-type-PDF-radio"/>PDF\n            </label>\n            <label class="btn btn-sm btn-primary" ng-mouseup="onOutboundMappingTypeChange(\'DocuSign\', $event)">\n                <input type="radio" class="btn btn-sm btn-primary" value="DocuSign" \n                    id="active-mapping-outbound-mapping-type-DocuSign-radio"/>DocuSign\n            </label>\n            <label class="btn btn-sm btn-primary" ng-mouseup="onOutboundMappingTypeChange(\'doctemplate\', $event)">\n                <input type="radio" class="btn btn-sm btn-primary" value="doctemplate" \n                    id="active-mapping-outbound-mapping-type-Doctemplate-radio"/>Document Template\n            </label>\n            </div>\n        </div>\n        <div class="form-group" ng-if="viewModel.outboundMappingType === \'JSON\'">\n            <label>{{ ::\'DRMapperTargetJSONOutput\' | localize:\'Target JSON Output\' }}</label>\n            <div class="form-group"\n                ng-class="{ \'has-error has-feedback\': !bundle.TargetOutJson__c }">\n            <textarea class="form-control" placeholder="Paste your expected Output JSON here" rows="5"\n                    ng-model="bundle.TargetOutJson__c"\n                    id="bundle-target-out-json-textarea"\n                    ng-change="formatJSON(\'TargetOutJson__c\')"></textarea>\n            <span class="icon-v-close-circle form-control-feedback" aria-hidden="true"\n                    ng-if="!bundle.TargetOutJson__c"></span>\n            </div>\n        </div>\n        <div class="form-group" ng-if="viewModel.outboundMappingType === \'PDF\'">\n            <label for="pdf">{{ ::\'DRMapperTargetDocument\' | localize:\'Target Document\' }}</label>\n            <select name="pdf" class="form-control"\n                    ng-options="value as label for (label, value) in pdfs"\n                    id="bundle-target-out-pdf-doc-name-select"\n                    ng-model="bundle.TargetOutPdfDocName__c">\n            </select>\n            <br/>\n            <button class="pull-right btn btn-primary" type="button" ng-disabled="!bundle.TargetOutPdfDocName__c" ng-click="getFieldsForPDF(bundle.TargetOutPdfDocName__c)"\n                    id="bundle-get-fields-for-pdf-button">{{ ::\'DRMapperExtractFields\' | localize:\'Extract Fields\' }}</button>\n        </div>\n        <div class="form-group" ng-if="viewModel.outboundMappingType === \'DocuSign\'">\n            <label for="DocuSign">{{ ::\'DRMapperTargetDocuSignTemplate\' | localize:\'Target Template\' }}</label>\n            <select name="docusign" class="form-control"\n                    ng-options="option[nsPrefix + \'TemplateIdentifier__c\'] as option.Name for option in docusign"\n                    id="bundle-target-out-docusign-template-id-select"\n                    ng-model="bundle.TargetOutDocuSignTemplateId__c">\n            </select>\n            <br/>\n            <button class="pull-right btn btn-primary" type="button" ng-disabled="!bundle.TargetOutDocuSignTemplateId__c" ng-click="getTabsForDocuSignTemplate(bundle.TargetOutDocuSignTemplateId__c, nsPrefix)"\n            id="get-tabs-for-docusign-template-button">{{ ::\'DRMapperExtractDocuSignTabs\' | localize:\'Extract Tabs\' }}</button>\n        </div>\n        <div class="form-group" ng-if="viewModel.outboundMappingType === \'doctemplate\'">\n            <label for="word-docs">{{ ::\'DRMapperTargetDocument\' | localize:\'Target Document\' }}</label>\n            <select name="word-docs" class="form-control"\n                    ng-options="value as value for value in worddocs"\n                    id="bundle-target-out-word-doc-name-select"\n                    ng-model="bundle.TargetOutPdfDocName__c">\n            </select>\n            <br/> \n            <button class="pull-right btn btn-primary" type="button" ng-disabled="!bundle.TargetOutPdfDocName__c" ng-click="getFieldsForPDF(bundle.TargetOutPdfDocName__c)"\n                    id="bundle-get-fields-for-pdf-button">{{ ::\'DRMapperExtractFields\' | localize:\'Extract Fields\' }}</button>\n        </div>\n        </div>\n    </div> \n    <div class="panel panel-sf" ng-if="bundle.OutputType__c == \'JSON\' && viewModel.activeTab !== 0">\n        <div class="panel-heading">\n        {{ ::\'DRMapperOutputJSON\' | localize:\'Output JSON\' }}\n        </div>\n        <div class="panel-body">\n        <pre>{{viewModel.phasetwo_json | json:2 }}</pre>\n        </div>\n    </div>\n    <div class="panel panel-sf" ng-if="bundle.OutputType__c == \'XML\' && viewModel.activeTab !== 0">\n        <div class="panel-heading">\n        {{ ::\'DRMapperOutputXML\' | localize:\'Output XML\' }}\n        </div>\n        <div class="panel-body">\n        <pre>{{ viewModel.jsonDisplayedAsXml }}</pre>\n        </div>\n    </div>\n</form>'),
$templateCache.put("transformValuesMap.right.tpl.html",'<div ng-if="activeMappingDetail" >\n    <div class="form-group">\n        <label>\n            {{ ::\'DRMapperShowTransformValuesMapFields\' | localize:\'Transform Map Values\' }}\n        </label>\n    </div>\n    <div class="row form-group" ng-repeat="property in activeMappingDetail.transformMapValues">\n        <div class="col-lg-5">\n            <input  type="text"\n                    class="form-control"\n                    ng-change="activeMappingDetail.updateTransformValueMap()"\n                    ng-model="property.key" />\n        </div>\n        <div class="col-lg-5">\n            <input  type="{{property.type}}"\n                    class="form-control"\n                    ng-change="activeMappingDetail.updateTransformValueMap()"\n                    ng-model="property.value" />\n        </div>\n        <div class="col-lg-1">\n            <button type="button" class="btn btn-link trash"\n                    ng-click="activeMappingDetail.deleteTransformMapValue(property) || form.activeMappingForm.$setDirty()" title="Delete property">\n                <span class="icon icon-v-trash"></span>\n            </button>\n        </div>\n    </div>\n    <div class="row">\n        <button class="btn btn-link" ng-click="activeMappingDetail.addTransformMapValue() || form.activeMappingForm.$setDirty()" style="padding-left: 16px">{{ ::\'DRMapperAddNewTransformMapValue\' | localize:\'+ Add New Key/Value\'}}</button>\n        <button class="btn btn-link" ng-click="activeMappingDetail.resetTransformMapValue() || form.activeMappingForm.$setDirty()" style="padding-left: 16px">{{ ::\'DRMapperClearTransformMapValue\' | localize:\'Clear Transform Map\'}}</button>\n    </div>\n</div>\n')}]);
},{}],23:[function(require,module,exports){
'use strict';
var PubSub = require('../util/PubSub.js');
var inherit = require('../util/inherit.js');
var generateId = require('../../../util/generateId.js');

function CreationOrderObject(index, object) {
    if (index === undefined && !object) {
        throw new Error('An index or object must be set on CreationOrderObjects');
    }
    this.cindex = index;
    this.cobject = object;
    this.id = generateId('CreationOrderObject');
    PubSub.call(this);
}

CreationOrderObject.prototype = inherit(PubSub.prototype);
CreationOrderObject.prototype.constructor = CreationOrderObject;

CreationOrderObject.prototype.object = function() {
    if (arguments.length > 0) {
        var oldObject = this.cobject;
        this.cobject = arguments[0];
        this.fire('objectChanged', this.cobject, oldObject);
    }
    return this.cobject;
};

CreationOrderObject.prototype.index = function(index) {
    if (arguments.length > 0) {
        var oldIndex = this.cindex;
        this.cindex = arguments[0];
        this.fire('indexChanged', index, oldIndex);
    }
    return this.cindex;
};

CreationOrderObject.prototype.equals = function(object) {
    if (!object) {
        return false;
    } else {
        return this.id === object.id;
    }
};

CreationOrderObject.prototype.label = function() {
    return this.cindex + ' - ' + this.cobject;
};

/*
 * pass in object as false and we'll match only on the index
 */
CreationOrderObject.factory = function(index, object) {
    /* jshint eqnull: true */
    if (index == null) {
        return null;
    }
    for (var i = 0; i < CreationOrderObject.all.length; i++) {
        if (CreationOrderObject.all[i].cindex === index &&
              (CreationOrderObject.all[i].cobject === object || object === false)) {
            return CreationOrderObject.all[i];
        }
    }
    var newCreationOrderObject = new CreationOrderObject(index, object);
    CreationOrderObject.all.push(newCreationOrderObject);
    CreationOrderObject.all = CreationOrderObject.all.sort(function(a, b) {
        return a.cindex - b.cindex;
    });
    return newCreationOrderObject;
};

CreationOrderObject.all = [];

CreationOrderObject.reset = function() {
    CreationOrderObject.all.splice(0, CreationOrderObject.all.length);
};

CreationOrderObject.delete = function(creationOrderObject) {
    var indexToDelete = -1, i, co;
    for (i = 0; i < CreationOrderObject.all.length; i++) {
        co = CreationOrderObject.all[i];
        if (CreationOrderObject.all[i].equals(creationOrderObject)) {
            indexToDelete = i;
        } else if (indexToDelete > -1) {
            co.index(co.index() - 1);
        }
    }
    if (indexToDelete > -1) {
        CreationOrderObject.all.splice(indexToDelete, 1);
    }
    creationOrderObject.fire('deleted', creationOrderObject);
};

module.exports = CreationOrderObject;

},{"../../../util/generateId.js":30,"../util/PubSub.js":27,"../util/inherit.js":28}],24:[function(require,module,exports){
/*jshint camelcase: false */
'use strict';

var ns = function() {
    return window.ns || '';
};
var regex = (function () {
    var _regex;
    return function() {
        if (!_regex) {
            _regex = new RegExp('^' + ns());
        }
        return _regex;
    };
})();
var PubSub = require('../util/PubSub.js');
var inherit = require('../util/inherit.js');
var unescapeHTML = require('../util/HtmlEncodeDecode.js').unescapeHTML;

function DRBundle() {
    PubSub.call(this);
    this.Name(null);
    this.InterfaceObject__c = null;
    this.Description__c = null;
    this.BatchSize__c = 200;
    this.ProcessNowThreshold__c = 0;
    this.DeleteOnSuccess__c = false;
    this.IsProcessSuperBulk__c = false;
    this.IsDefaultForInterface__c = false;
    this.CheckFieldLevelSecurity__c = false;
    this.RollbackOnError__c = false;
    this.SampleInputRows__c = null;
    this.SampleInputJSON__c = null;
    this.TargetOutDocuSignTemplateId__c = null;
    this.Type__c(DRBundle.types[0]);
    this.OutputType__c = 'JSON';
    this.InputType__c = 'JSON';
}

DRBundle.prototype = inherit(PubSub.prototype);

function formatJsonText(text) {
    text = unescapeHTML(text);
    try {
        return unescapeHTML(JSON.stringify(JSON.parse(text), null, 2));
    } catch (e) {
        return text;
    }
}

DRBundle.fromJson = function(json) {
    var bundle = new DRBundle();
    var wasTypeSet = false, settersToCall = [];
    if (json) {
        Object.keys(json).sort().forEach(function(prop) {
            var propName = prop.replace(regex(), '');
            if (typeof(bundle[propName]) === 'function') {
                settersToCall.push({
                    fn: bundle[propName],
                    value: json[prop]
                });
            } else {
                bundle[propName] = json[prop];
            }
            if (/Type__c$/.test(prop.replace(regex(), ''))) {
                wasTypeSet = true;
            }
        });
        settersToCall.forEach(function(setterConfig) {
            setterConfig.fn.call(bundle, setterConfig.value);
        });
    }

    if (!this.InputJson__c) {
        this.InputJson__c  = '{}';
    }
    if (bundle.InputJson__c) {
        bundle.InputJson__c = formatJsonText(bundle.InputJson__c);
    }
    if (bundle.SampleInputJSON__c) {
        bundle.SampleInputJSON__c = formatJsonText(bundle.SampleInputJSON__c);
    }
    if (bundle.TargetOutJson__c) {
        bundle.TargetOutJson__c = formatJsonText(bundle.TargetOutJson__c);
    }

    // if Type__c didn't exist on the object we need to figure out what
    // it should be and set it
    if (!wasTypeSet) {
        if (bundle.InterfaceObject__c === 'json') {
            bundle.Type__c(bundle.InputJson__c ? DRBundle.types[1] : DRBundle.types[2]);
        } else {
            bundle.Type__c(DRBundle.types[0]);
        }
    }

    bundle.originalJson = bundle.asJson();
    return bundle;
};

DRBundle.prototype.asJson = function() {
    var json = {
        Name: this._Name,
        Id: this.Id
    };
    for (var prop in this) {
        if (/__c$/.test(prop) && !/^_/.test(prop)) {
            if (typeof(this[prop]) === 'function') {
                json[ns() + prop] = this[prop]();
            } else {
                json[ns() + prop] = this[prop];
            }
        }
    }

    return json;
};

DRBundle.prototype.Type__c = function() {
    if (arguments.length === 1) {
        var type = arguments[0];
        if (angular.isObject(type)) {
            type = type.type;
        }
        this._Type__c = type;
        switch (type) {
            case 'Load':            this.CheckFieldLevelSecurity__c = false;

                                    break;

            case 'Extract':         if (!this.Id) { // Only set if new
                                       this.CheckFieldLevelSecurity__c = true;
                                    }


                                    this.InterfaceObject__c = 'json';
                                    break;

            case 'Transform':       this.InterfaceObject__c = 'json';


                                    break;

            case 'Load (Object)':   this.CheckFieldLevelSecurity__c = false;
                                    this.InputType__c = 'SObject';
                                    this.OutputType__c = 'SObject';
                                    this._Type__c = 'Load';
                                    break;

            case 'Load (JSON)':     this.InputType__c = 'JSON';
                                    this.OutputType__c = 'SObject';
                                    this._Type__c = 'Load';
                                    break;

            case 'Extract (JSON)':  if (!this.Id) { // Only set if new
                                       this.CheckFieldLevelSecurity__c = true;
                                    }
                                    this.InputType__c = 'JSON';
                                    this.OutputType__c = 'JSON';
                                    this._Type__c = 'Extract';
                                    break;
            default:
        }

        if (this._Type__c == 'Load') {
            if (!this.InputType__c) {
                this.InputType__c = 'JSON';
            }
            this.OutputType__c = 'SObject';
            if (this.InputType__c != 'SObject') {
                this.InterfaceObject__c = 'json';
            }
        } else {
             if (!this.InputType__c || this.InputType__c == 'SObject') {
                this.InputType__c = 'JSON';
             }
             if (!this.OutputType__c || this.OutputType__c == 'SObject') {
                this.OutputType__c = 'JSON';
             }
        }

        this.fire('typeChanged', this._Type__c);
    }
    return this._Type__c;
};

DRBundle.prototype.Name = function() {
    if (arguments.length === 1) {
        this._Name = this.DRMapName__c = arguments[0];
        this.fire('nameChanged', this._Name);
    }
    return this._Name;
};

DRBundle.prototype.isLoad = function() {
    return this.Type__c() === DRBundle.types[0];
};

DRBundle.prototype.isLoadObject = function() {
    return this.Type__c() === DRBundle.types[0] && this.InputType__c == 'SObject';
};

DRBundle.prototype.isLoadJson = function() {
    return this.Type__c() === DRBundle.types[0] && this.InputType__c == 'JSON';
};

DRBundle.prototype.isLoadXml = function() {
    return this.Type__c() === DRBundle.types[0] && this.InputType__c == 'XML';
};

DRBundle.prototype.isExtract = function() {
    return this.Type__c() === DRBundle.types[1];
};

DRBundle.prototype.isTransform = function() {
    return this.Type__c() === DRBundle.types[2];
};

DRBundle.prototype.setSaving = function(value) {
    this.saving = value;
};

DRBundle.prototype.setId = function(id) {
    this.Id = id;
};

DRBundle.prototype.setErrors = function(errors) {
    this._errors = errors;
    if (this._errors) {
        this._errors.forEach(function(error) {
            if (/Interface Object/.test(error.message)) {
                error.forProp = 'InterfaceObject__c';
            }
        });
    }
};

DRBundle.types = [ 'Load', 'Extract', 'Transform' ];

DRBundle._dataTypesSimple = [ 'JSON', 'XML', 'SObject' ];

DRBundle._dataTypes = {  'Load' : { 'Input' : [ { label: 'JSON', type: 'JSON' }, { label: 'XML', type: 'XML' }, { label: 'SObject', type: 'SObject' } ],
                                    'Output' : [ { label: 'SObject', type: 'SObject' } ] },
                         'Extract' : { 'Input' : [ { label: 'JSON', type: 'JSON' }, { label: 'XML', type: 'XML' } ],
                                        'Output' : [ { label: 'JSON', type: 'JSON' }, { label: 'XML', type: 'XML' } ] },
                         'Transform' : { 'Input' : [ { label: 'JSON', type: 'JSON' }, { label: 'XML', type: 'XML' } ],
                                         'Output' : [ { label: 'JSON', type: 'JSON' }, { label: 'XML', type: 'XML' } ] }
                      };

DRBundle.dataTypes = function(bundleType, inputOrOutput) {
    return DRBundle._dataTypes[bundleType][inputOrOutput];
}

module.exports = DRBundle;

},{"../util/HtmlEncodeDecode.js":26,"../util/PubSub.js":27,"../util/inherit.js":28}],25:[function(require,module,exports){
/*jshint camelcase: false */
'use strict';
var jsonSeperator = ':';
var ns = function() {
    return window.ns || '';
};
var regex = (function () {
    var _regex;
    return function() {
        if (!_regex) {
            _regex = new RegExp('^' + ns());
        }
        return _regex;
    };
})();
var allMappings = {};
var CreationOrderObject = require('../util/CreationOrderObject.js');
var DRBundle = require('../util/DRBundle.js');
var unescapeHTML = require('../util/HtmlEncodeDecode.js').unescapeHTML;

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min)) + min;
}

function getUniqueMapValue(mapping) {
    var newMapUnique = mapping.bundle().Name() + 'Custom' + getRandomInt(0,10000);
    while (allMappings[newMapUnique]) {
        newMapUnique = mapping.bundle().Name() + 'Custom' + getRandomInt(0,10000);
    }
    return newMapUnique;
}

function DRMapItem(bundle) {
    this.DefaultValue__c = null;
    this.DomainObjectFieldAPIName__c = null;
    this.InterfaceFieldAPIName__c = null;
    this.IsDisabled__c = false;
    this.LinkCreatedObject(null);
    this.MapId__c = null;
    this.UpsertKey__c = false;
    this.IsRequiredForUpsert__c = false;
    this.Formula__c = null;
    this.FormulaResultPath__c = null;
    this.FormulaOrder__c = 0;
    this.DomainObjectFieldType__c = '';
    this.transformMapValues = [];

    this.$creationOrderObject = null;
    this.isJson = false;
    if (bundle) {
        this.bundle(bundle);
        this.InterfaceObjectName__c(null);
    }
    this.mapType('None');
}

function itemType(mapping) {
    if (mapping.LinkCreatedIndex__c) {
        return 'Linked';
    } else if (mapping.LookupDomainObjectName__c) {
        return 'Lookup';
    }
    return 'None';
}

DRMapItem.prototype.creationOrderObject = function() {
    if (arguments.length > 0) {
        if (this.$creationOrderObject &&
            this.$creationOrderObject !== arguments[0]) {
            this.$creationOrderObject.un('indexChanged', this.handleIndexChanged, this);
            this.$creationOrderObject.un('objectChanged', this.handleObjectChanged, this);
        }
        this.$creationOrderObject = arguments[0];
        if (this.$creationOrderObject) {
            this.handleIndexChanged(null, this.$creationOrderObject.index());
            this.handleObjectChanged(null, this.$creationOrderObject.object());
            this.$creationOrderObject.on('indexChanged', this.handleIndexChanged, this);
            this.$creationOrderObject.on('objectChanged', this.handleObjectChanged, this);
        } else if (!this.bundle().isExtract()) {
            this.DomainObjectCreationOrder__c = 0;
        }
    }
    return this.$creationOrderObject;
};

DRMapItem.prototype.handleIndexChanged = function(event, newIndex) {
    if (!this.bundle().isExtract()) {
        this.DomainObjectCreationOrder__c = newIndex;
    } else {
        this.InterfaceObjectLookupOrder__c = newIndex;
    }
};

DRMapItem.prototype.mapType = function() {
    if (arguments.length > 0) {
        this.$mapType = arguments[0];
        if (this.bundle() && !this.bundle().isExtract()) {
            if (this.$mapType !== 'Lookup') {
                this.LookupDomainObjectName__c = '';
                this.LookupDomainObjectFieldName__c = '';
                this.LookupDomainObjectRequestedFieldName__c = '';
                if (this._InterfaceFieldAPIName__c) {
                    this.InterfaceFieldAPIName__c = this._InterfaceFieldAPIName__c;
                    delete this._InterfaceFieldAPIName__c;
                }
            } else if (this.DefaultValue__c) {
                this.InterfaceFieldAPIName__c = '';
            }
            if (this.$mapType !== 'Linked') {
                this.LinkCreatedObject(null);
                if (this._InterfaceFieldAPIName__c) {
                    this.InterfaceFieldAPIName__c = this._InterfaceFieldAPIName__c;
                    delete this._InterfaceFieldAPIName__c;
                }
            } else {
                this._InterfaceFieldAPIName__c = this.InterfaceFieldAPIName__c;
                this.InterfaceFieldAPIName__c = '';
            }
        }
    }
    return this.$mapType;
};

DRMapItem.prototype.LinkCreatedObject = function() {
    if (arguments.length > 0) {
        this.$linkCreatedObject = arguments[0];
        if (this.$linkCreatedObject) {
            this.LinkCreatedIndex__c = this.$linkCreatedObject.cindex;
        } else {
            this.LinkCreatedIndex__c = 0;
            this.LinkCreatedField__c = '';
        }
    }
    return this.$linkCreatedObject;
};

DRMapItem.prototype.handleObjectChanged = function(event, newObject) {
    if (!this.bundle().isExtract()) {
        var oldDomainObjectAPIName__c = this.DomainObjectAPIName__c;
        this.DomainObjectAPIName__c = newObject;
        if (newObject !== oldDomainObjectAPIName__c) {
            this.DomainObjectFieldAPIName__c = null;
        }
    } else {
        this.InterfaceObjectName__c(newObject);
    }
};

DRMapItem.prototype.bundle = function() {
    if (arguments.length > 0) {
        if (this.$bundle &&
            this.$bundle !== arguments[0]) {
            this.$bundle.un('nameChanged', this.handleNameChanged, this);
            this.$bundle.un('typeChanged', this.handleBundleTypeChanged, this);
        }
        this.$bundle = arguments[0];
        if (!this.$bundle || !(this.$bundle instanceof DRBundle)) {
            throw new Error('You must set a bundle on the mapping');
        }
        this.handleNameChanged(null, this.$bundle.Name());
        this.handleBundleTypeChanged(null, this.$bundle.Type__c());
        this.$bundle.on('nameChanged', this.handleNameChanged, this);
        this.$bundle.on('typeChanged', this.handleBundleTypeChanged, this);
    }
    return this.$bundle;
};

DRMapItem.prototype.InterfaceObjectName__c = function() {
    if (arguments.length > 0) {
        if (this.bundle().isExtract() && this.DomainObjectCreationOrder__c === 1) {
            this._InterfaceObjectName__c = null;
        } else {
            this._InterfaceObjectName__c = arguments[0];
        }
    }
    return this._InterfaceObjectName__c;
};

DRMapItem.prototype.TransformValuesMap__c = function() {
    if (arguments.length > 0) {
        this._TransformValuesMap__c = arguments[0];
        if (typeof this._TransformValuesMap__c == 'string') {
            try {
                var asJSON = JSON.parse(this._TransformValuesMap__c);
                this.transformMapValues = Object.keys(asJSON).map(function(key) {
                    return {
                        key: key,
                        value: asJSON[key]
                    };
                });
            } catch (e) {
                this._TransformValuesMap__c = null;
            }
        }
    }
    return this._TransformValuesMap__c;
};

DRMapItem.prototype.Name = function() {
    if (arguments.length > 0) {
        this._Name = arguments[0];
    }
    return this._Name;
};

DRMapItem.prototype.handleNameChanged = function(event, newName) {
    this.Name(newName);
};

DRMapItem.prototype.transformMapValues = function() {
    return this.transformMapValues;
};

DRMapItem.prototype.addTransformMapValue = function() {
    this.transformMapValues.push({
        key: '',
        value: ''
    });
    this.updateTransformValueMap();
};


DRMapItem.prototype.resetTransformMapValue = function() {
    this.transformMapValues.splice(0, this.transformMapValues.length);
    this.updateTransformValueMap();
};

DRMapItem.prototype.deleteTransformMapValue = function(transformMapValue) {
    for (var i = 0; i < this.transformMapValues.length; i++) {
        if (this.transformMapValues[i] === transformMapValue) {
            this.transformMapValues.splice(i, 1);
            this.updateTransformValueMap();
            return;
        }
    }
};

DRMapItem.prototype.updateTransformValueMap = function() {
    var asJSON = this.transformMapValues.reduce(function(object, currentValue) {
        object[currentValue.key] = currentValue.value;
        return object;
    }, {});
    this._TransformValuesMap__c = JSON.stringify(asJSON);
}

DRMapItem.prototype.handleBundleTypeChanged = function() {
    if (this.bundle().isExtract()) {
        if (this.DomainObjectAPIName__c !== 'Formula') {
            this.DomainObjectAPIName__c = 'json';
            if (this.DomainObjectCreationOrder__c !== 0) {
                this.DomainObjectCreationOrder__c = 1;
                //this.InterfaceObjectName__c(null);
                /* jshint eqnull: true */
            } else if (this.FilterOperator__c == null) {
                this.FilterOperator__c = '=';
            }
        }
    } else if (this.bundle().isLoadObject()) {
        this.InterfaceObjectName__c(this.bundle().InterfaceObject__c);
    } else if (this.bundle().isTransform()) {
        if (this.DomainObjectAPIName__c !== 'Formula') {
            this.DomainObjectAPIName__c = 'json';
            this.DomainObjectCreationOrder__c = 1;
        }
    }
};

DRMapItem.prototype.clone = function() {
    var mapping = new DRMapItem(this.bundle());
    for (var prop in this) {
        if (this.hasOwnProperty(prop)) {
            mapping[prop] = this[prop];
        }
    }
    mapping.creationOrderObject(this.creationOrderObject());
    if (this.wrapperMapping) {
        mapping.mappings = [];
        for (var i = 0; i < this.mappings.length; i++) {
            mapping.mappings[i] = this.mappings[i].clone();
        }
    }
    return mapping;
};

DRMapItem.prototype.setSaving = function(value) {
    this.saving = value;
    if (this.$parent) {
        this.$parent.setSaving(value);
    }
};

DRMapItem.prototype.setId = function(id) {
    this.Id = id;
};

DRMapItem.prototype.setErrors = function(errors) {
    this._errors = errors;
};

DRMapItem.prototype.equals = function(mapping) {
    if (!mapping) {
        return false;
    } else if (mapping === this || mapping.MapId__c === this.MapId__c) {
        return true;
    } else {
        return ((this.isRequiredDomainField || mapping.isRequiredDomainField) &&
                 this.DomainObjectFieldAPIName__c === mapping.DomainObjectFieldAPIName__c &&
                 this.DomainObjectAPIName__c === mapping.DomainObjectAPIName__c) ||
               ((this.isMissingMapping || mapping.isMissingMapping) &&
                 this.InterfaceFieldAPIName__c === mapping.InterfaceFieldAPIName__c);
    }
};

DRMapItem.prototype.asJson = function() {
    var json = {
        Name: this.Name(),
        Id: this.Id
    };
    for (var prop in this) {
        if (/__c$/.test(prop) && !/^(_|\$)/.test(prop)) {
            if (typeof(this[prop]) === 'function') {
                json[ns() + prop] = this[prop]();
            } else if (!/^parent$/.test(prop)) {
                json[ns() + prop] = this[prop];
            }
        }
    }
    if (this.LinkCreatedObject()) {
        json[ns() + 'LinkCreatedIndex__c'] = this.LinkCreatedObject().cindex;
    }
    if (json[ns() + 'InterfaceFieldAPIName__c']) {
        json[ns() + 'InterfaceFieldAPIName__c'] = json[ns() + 'InterfaceFieldAPIName__c'];
    }
    if (json[ns() + 'DomainObjectFieldAPIName__c']) {
        json[ns() + 'DomainObjectFieldAPIName__c'] = json[ns() + 'DomainObjectFieldAPIName__c'];
    }
    if (json[ns() + 'TransformValuesMap__c']) {
        var asJSON = this.transformMapValues.reduce(function(object, currentValue) {
            object[currentValue.key] = currentValue.value;
            return object;
        }, {});
        json[ns() + 'TransformValuesMap__c'] = JSON.stringify(asJSON);
    }
    return json;
};

function fixMappingPaths(propName, mapping) {
    if (mapping[propName]) {
        mapping[propName] = mapping[propName].replace(/:/gi, jsonSeperator);
    }
}

DRMapItem.fromJson = function(json, bundle) {
    var mapping = new DRMapItem();
    var cObject = null, settersToCall = [];
    Object.keys(json).sort().forEach(function(prop) {
        var propName = prop.replace(regex(), '');
        if (typeof(mapping[propName]) === 'function') {
            settersToCall.push({
                fn: mapping[propName],
                value: unescapeHTML(json[prop])
            });
        } else {
            mapping[propName] = unescapeHTML(json[prop]);
        }
    });
    mapping.bundle(bundle);
    settersToCall.forEach(function(setterConfig) {
        setterConfig.fn.call(mapping, setterConfig.value);
    });
    if (!mapping.MapId__c) {
        mapping.MapId__c = getUniqueMapValue(mapping);
    }
    // convert LinkCreatedIndex__c to CreationOrderObject
    if (mapping.LinkCreatedIndex__c) {
        mapping.LinkCreatedObject(CreationOrderObject.factory(mapping.LinkCreatedIndex__c, false));
    }
    if (mapping.FilterOperator__c === 'LIMIT') {
        mapping.FilterValue__c = Number(mapping.FilterValue__c);
    }

    // also adapt JSON fields so paths are '.' separated not ':' separated
    fixMappingPaths('InterfaceFieldAPIName__c', mapping);
    fixMappingPaths('DomainObjectFieldAPIName__c', mapping);

    mapping.isJson = mapping.InterfaceObjectName__c() === 'json';
    if (mapping.DomainObjectAPIName__c !== 'Formula') {
        if (!bundle.isExtract()) {
            cObject = CreationOrderObject.factory(mapping.DomainObjectCreationOrder__c, mapping.DomainObjectAPIName__c);
        } else if (mapping.DomainObjectCreationOrder__c === 0) {
            // We don't set creationOrderObject on phase 2 transform mappings
            cObject = CreationOrderObject.factory(mapping.InterfaceObjectLookupOrder__c, mapping.InterfaceObjectName__c());
        }
    }
    if (cObject) {
        mapping.creationOrderObject(cObject);
    }
    mapping.mapType(itemType(mapping));
    allMappings[mapping.MapId__c] = mapping;
    mapping.originalJson = mapping.asJson();
    return mapping;
};

module.exports = DRMapItem;

},{"../util/CreationOrderObject.js":23,"../util/DRBundle.js":24,"../util/HtmlEncodeDecode.js":26}],26:[function(require,module,exports){
var escape = document.createElement('textarea');
function escapeHTML(html) {
    'use strict';
    if (angular.isString(html)) {
        escape.innerHTML = html;
        return escape.innerHTML;
    } else {
        return html;
    }
}

function unescapeHTML(html) {
    'use strict';
    if (angular.isString(html)) {
        escape.innerHTML = html;
        return escape.value;
    } else {
        return html;
    }
}

exports.escapeHTML = escapeHTML;
exports.unescapeHTML = unescapeHTML;

},{}],27:[function(require,module,exports){
'use strict';

function PubSub() {
    this.$listeners = {};
}

PubSub.prototype.on = function(event, listener, scope) {
    if (!this.$listeners[event]) {
        this.$listeners[event] = [{
            scope: scope,
            listener: listener
        }];
    } else {
        this.$listeners[event].push({
            scope: scope,
            listener: listener
        });
    }
};

PubSub.prototype.fire = function() {
    var eventName = arguments[0];
    if (this.$listeners[eventName]) {
        for (var i = 0; i < this.$listeners[eventName].length; i++) {
            var scopeAndListener = this.$listeners[eventName][i];
            scopeAndListener.listener.apply(scopeAndListener.scope, arguments);
        }
    }
};

PubSub.prototype.un = function(event, listener, scope) {
    if (this.$listeners[event]) {
        for (var i = 0; i < this.$listeners[event].length; i++) {
            var scopeAndListener = this.$listeners[event][i];
            if (scopeAndListener.scope === scope &&
                scopeAndListener.listener === listener) {
                this.$listeners[event].splice(i, 1);
            }
        }
    }
};

module.exports = PubSub;

},{}],28:[function(require,module,exports){
module.exports = function inherit(proto) {
    'use strict';
    function F() {}
    F.prototype = proto;
    return new F();
};

},{}],29:[function(require,module,exports){
//https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/find
if (!Array.prototype.find) {
    Array.prototype.find = function(predicate) {
        'use strict';
        /* jshint eqnull:true */
        if (this == null) {
            throw new TypeError('Array.prototype.find called on null or undefined');
        }
        if (typeof predicate !== 'function') {
            throw new TypeError('predicate must be a function');
        }
        var list = Object(this);
        var length = list.length >>> 0;
        var thisArg = arguments[1];
        var value;

        for (var i = 0; i < length; i++) {
            value = list[i];
            if (predicate.call(thisArg, value, i, list)) {
                return value;
            }
        }
        return undefined;
    };
}

},{}],30:[function(require,module,exports){
var idFunction = (function idFunction() {
    'use strict';
    var prefixCounts = {'OmniScript Component': 1};
    var fn = function(prefix) {
        prefix = prefix ? prefix : 'OmniScript Component';
        prefix = prefix.replace(/\brest\b/i, 'REST');
        if (!prefixCounts[prefix]) {
            prefixCounts[prefix] = 1;
        }
        return prefix + ' ' + (prefixCounts[prefix]++);
    };
    fn.registerExistingPrefix = function(name) {
        var nameParts = name.split(' ');
        if (!isNaN(nameParts[nameParts.length - 1])) {
            var count = parseInt(nameParts[nameParts.length - 1], 10),
                key = nameParts.splice(0, nameParts.length - 1).join(' ');
            if (!prefixCounts[key] || prefixCounts[key] <= count) {
                prefixCounts[key] = count + 1;
            }
        }
    };
    return fn;
})();
module.exports = idFunction;

},{}]},{},[1]);

})();