{
    "dataPackId": "",
    "dataPacks": [
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/xom-opv-container": "Reference by Name",
                "VlocityUITemplate/xom-opv-plan-item": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"dataSource\": {\n        \"type\": \"Custom\",\n        \"value\": {\n            \"body\": \"{\\n  \\\"OrcAttributes\\\":{\\n    \\\"OrcAttributeItems\\\": [\\n      {\\n        \\\"type\\\": \\\"Callout\\\",\\n        \\\"attributes\\\": [\\n          \\\"System Interface\\\",\\n          \\\"Orchestration Queue\\\",\\n          \\\"Error Queue\\\",\\n          \\\"Timeout (ms)\\\",\\n          \\\"Priority\\\",\\n          \\\"Actual Number Of Retries\\\",\\n          \\\"Maximum Number of Retries\\\"\\n        ]\\n      },\\n      {\\n        \\\"type\\\": \\\"AutoTask\\\",\\n        \\\"attributes\\\": []\\n      },\\n      {\\n        \\\"type\\\": \\\"Milestone\\\",\\n        \\\"attributes\\\": []\\n      },\\n      {\\n        \\\"type\\\": \\\"ManualTask\\\",\\n        \\\"attributes\\\": [\\n          \\\"Assigned To User\\\",\\n          \\\"Assigned To Manual Queue\\\",\\n          \\\"Manual Queue\\\"\\n        ]\\n      },\\n      {\\n        \\\"type\\\": \\\"PullEvent\\\",\\n        \\\"attributes\\\": []\\n      },\\n      {\\n        \\\"type\\\": \\\"PushEvent\\\",\\n        \\\"attributes\\\": []\\n      }\\n    ]}\\n  }\"\n        }\n    },\n    \"filter\": {\n    },\n    \"states\": [\n        {\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n            ],\n            \"flyout\": {\n                \"data\": \"$scope\",\n                \"layout\": \"xom-opv-item-modal\"\n            },\n            \"name\": \"ActiveItemList\",\n            \"templateUrl\": \"xom-opv-plan-item\"\n        }\n    ],\n    \"title\": \"xom orchestration card items\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "xom-opv-card-items-container/Vlocity/1497329611604",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "xom-opv-card-items-container",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/xom-opv-card-items-container/%vlocity_namespace%__VlocityCard__c/xom-opv-card-items-container"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/xom-opv-card-items-container",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/xom-opv-card-items-container",
            "VlocityDataPackName": "xom-opv-card-items-container",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/xom-opv-attribute-config": "Reference by Name",
                "VlocityUITemplate/xom-opv-attribute-config-items": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"dataSource\": {\n        \"type\": \"Custom\",\n        \"value\": {\n            \"body\": \"{\\n  \\\"orchestration-attribute-config\\\": {\\n    \\\"OrcAttributeMaxsize\\\": \\\"2\\\"\\n  }\\n}\"\n        }\n    },\n    \"filter\": {\n    },\n    \"states\": [\n        {\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n            ],\n            \"name\": \"Orchestration Attribute Config Items\",\n            \"templateUrl\": \"xom-opv-attribute-config-items\"\n        }\n    ],\n    \"title\": \"Orchestration Attribute Config Items\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "xom-opv-max-size-attribute/Vlocity/1497329731552",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "xom-opv-max-size-attribute",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/xom-opv-max-size-attribute/%vlocity_namespace%__VlocityCard__c/xom-opv-max-size-attribute"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/xom-opv-max-size-attribute",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/xom-opv-max-size-attribute",
            "VlocityDataPackName": "xom-opv-max-size-attribute",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityCard/xom-opv-max-size-attribute": "Reference by Name",
                "VlocityUITemplate/xom-opv-attribute-config-container": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUILayout__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Cards\": [\n        \"xom-opv-max-size-attribute\"\n    ],\n    \"templates\": {\n        \"0\": {\n            \"templateUrl\": \"xom-opv-attribute-config-container\"\n        }\n    }\n}",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__GlobalKey__c": "xom-opv-attribute-config/1/vlocity/1497254785157",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "Layout",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "xom-opv-attribute-config",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
                        "VlocityRecordSourceKey": "VlocityUILayout/xom-opv-attribute-config/%vlocity_namespace%__VlocityUILayout__c/xom-opv-attribute-config"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUILayout/xom-opv-attribute-config",
                "VlocityDataPackType": "VlocityUILayout"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUILayout/xom-opv-attribute-config",
            "VlocityDataPackName": "xom-opv-attribute-config",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUILayout"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityCard/xom-opv-card-items-container": "Reference by Name",
                "VlocityUITemplate/xom-opv-container": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUILayout__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Cards\": [\n        \"xom-opv-card-items-container\"\n    ],\n    \"templates\": {\n        \"0\": {\n            \"templateUrl\": \"xom-opv-container\"\n        }\n    }\n}",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__GlobalKey__c": "xom-opv-container/1/vlocity/1496928572243",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "Layout",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "xom-opv-container",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
                        "VlocityRecordSourceKey": "VlocityUILayout/xom-opv-container/%vlocity_namespace%__VlocityUILayout__c/xom-opv-container"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUILayout/xom-opv-container",
                "VlocityDataPackType": "VlocityUILayout"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUILayout/xom-opv-container",
            "VlocityDataPackName": "xom-opv-container",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUILayout"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUITemplate/xom-opv-item-modal": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUILayout__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Cards\": [\n    ],\n    \"templates\": {\n        \"0\": {\n            \"templateUrl\": \"xom-opv-item-modal\"\n        }\n    }\n}",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__GlobalKey__c": "xom-opv-item-modal/1/vlocity/1497330009687",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "Flyout",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "xom-opv-item-modal",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
                        "VlocityRecordSourceKey": "VlocityUILayout/xom-opv-item-modal/%vlocity_namespace%__VlocityUILayout__c/xom-opv-item-modal"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUILayout/xom-opv-item-modal",
                "VlocityDataPackType": "VlocityUILayout"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUILayout/xom-opv-item-modal",
            "VlocityDataPackName": "xom-opv-item-modal",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUILayout"
        },
        {
            "VlocityDataPackAllRelationships": null,
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUITemplate__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__CSS__c": "/*** MIXINS ***/\n",
                        "%vlocity_namespace%__Definition__c": "",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__DisplayOn__c": "All",
                        "%vlocity_namespace%__ExternalID__c": "mixin/1.0/Vlocity/1452117264679",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Sass__c": "/*** MIXINS ***/\n@mixin clearfix {\n    &:before, &:after {\n        content: \" \"; // 1\n        display: table; // 2\n    }\n    &:after {\n        clear: both;\n    }\n}",
                        "%vlocity_namespace%__Type__c": "mixin",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "mixin",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUITemplate__c",
                        "VlocityRecordSourceKey": "VlocityUITemplate/mixin/%vlocity_namespace%__VlocityUITemplate__c/mixin"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUITemplate/mixin",
                "VlocityDataPackType": "VlocityUITemplate"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUITemplate/mixin",
            "VlocityDataPackName": "mixin",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUITemplate"
        },
        {
            "VlocityDataPackAllRelationships": {
                "OmniScript/ThorManualTask_ThorManualTaskUpdate_English": "Reference by Salesforce Id"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUITemplate__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__CSS__c": "table {\n  /*border: 1px solid black;*/\n  text-transform: capitalize; }\n\n.vlocity .vlc-validation-field .vlc-validation-success {\n  margin-top: 25px; }\n\ntd.fixedWidth, td.fixedWidthTask {\n  width: 240px; }\n\n.XomManualQueueTask .slds-text-ctitle {\n  font-size: 15px;\n  line-height: 1.25;\n  color: #54698d; }\n\n.via-slds .slds-table--bordered {\n  border: none; }\n\n.via-slds .slds-table tr:last-child td:not(a) {\n  border-bottom: 1px solid #d8dde6; }\n\na[ng-click] {\n  cursor: pointer; }\n\n.order .field {\n  margin-bottom: 16px;\n  float: left;\n  margin-left: 50px;\n  width: 160px; }\n\n.order .field-label {\n  font-weight: 600;\n  font-size: 12px;\n  text-transform: uppercase;\n  display: block; }\n\n.order .field-value {\n  overflow: hidden;\n  text-overflow: ellipsis;\n  white-space: nowrap; }\n\n.vlocity .panel-title {\n  color: inherit; }\n\n[ng\\:cloak], [ng-cloak], .ng-cloak {\n  display: none !important; }\n\n.vlocity .vlc-overlay {\n  position: fixed;\n  z-index: 1038;\n  background-color: rgba(255, 255, 255, 0.9);\n  width: 100%;\n  height: 100%; }\n\n.vlocity .vlc-overlay .spinner {\n  position: fixed;\n  top: 50%;\n  left: 50%;\n  margin-top: -14px;\n  margin-left: -14px; }\n\n.modal-body p {\n  word-wrap: break-word; }\n\n.modal-backdrop, .am-fade {\n  display: none; }\n\n.tooltip-inner {\n  max-width: 350px !important;\n  width: auto;\n  overflow-wrap: break-word;\n  overflow: auto;\n  z-index: 10000; }\n\n.panel-title .tooltip-inner {\n  width: auto;\n  max-width: 2000px !important;\n  whitespace: no-wrap;\n  overflow-wrap: break-word;\n  overflow: visible;\n  z-index: 10000; }\n\n.order .field-value {\n  overflow: hidden;\n  text-overflow: ellipsis;\n  white-space: nowrap; }\n\n.vlocity .vlc-validation-field .vlc-validation-success i, .vlocity .vlc-validation-field .vlc-validation-success small {\n  color: red; }\n\n.vlocity .vlc-validation-field .vlc-validation-success i {\n  display: none; }\n\n.vlocity .vlc-validation-field .vlc-validation-success {\n  background-color: white; }\n",
                        "%vlocity_namespace%__Definition__c": "",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__DisplayOn__c": "",
                        "%vlocity_namespace%__ExternalID__c": "xom-manualqueue-task/1/vlocity/1498798613339",
                        "%vlocity_namespace%__HTML__c": "<script type=\"text/ng-template\" id=\"xom-manualqueue-task\" >\n<div class=\"vlocity via-slds\">\n<div class=\"XomManualQueueTask\">\n<div class=\"slds-text-ctitle\">Task : {{bpTree.response.showtaskdetails.data.name}}</div>\n<br>\n<div class=\"slds-text-ctitle\">Order Item Parameters</div><br>\n\n<div style=\"width:50%;\" ng-repeat=\"(nodeKey, nodeValue) in bpTree.response.showOrderDetails.data\">\n<table  class=\"slds-table slds-table--bordered slds-table--cell-buffer\" cellpadding=\"10\" cellspacing=\"10\" width=\"100%\" >\n<tr ng-repeat=\"field in nodeValue\" ng-if=\"nodeKey =='fields' && !field.refId\">\n    <td class=\"slds-text-title fixedWidth\">{{field.name}}</td>\n    <td>{{field.value }}</td>\n</tr>\n<tr ng-repeat=\"field in nodeValue\" ng-if=\"nodeKey =='fields' && field.value && !!field.refId\">\n    <td class=\"slds-text-title fixedWidth\">{{field.name}}</td>\n    <td><a ng-click=\"resolveByGlobalKey(field.refId)\" >{{field.value}}</a></td>\n</tr>\n<tr ng-repeat=\"attr in nodeValue\" ng-repeat=\"attr in nodeValue\" ng-if=\"nodeKey =='attrs' && attr.value\">\n    <td class=\"slds-text-title fixedWidth\">{{attr.name}}</td>\n    <td>{{attr.value}}</td>\n</tr>\n<tr ng-repeat=\"attr in nodeValue\" ng-if=\"bpTree.response.showOrderDetails.data.assetId\">\n    <td class=\"slds-text-title fixedWidth\">Asset/Inventory Item</td>\n    <td><a ng-click=\"resolveNavigate(bpTree.response.showOrderDetails.data.assetId)\">{{bpTree.response.showOrderDetails.data.assetName}}</a></a></td>\n</tr>\n</table>\n</div>\n\n<div id=\"customAttrElement\" customAttrlId=\"{{bpTree.response.showtaskdetails.data.id | json}}\" customAttrAdditionalId=\"{{bpTree.response.showtaskdetails.data.additionalId | json}}\" customAttrMQueueGlobalKey=\"{{bpTree.response.showtaskdetails.data.parameters['Manual Queue Global Key'] | json}}\" customAttrAssignedMQueueGlobalKey=\"{{bpTree.response.showtaskdetails.data.parameters['Assigned To Manual Queue Global Key'] | json}}\"   ></div>\n</div>\n</br>\n</br>\n<div class=\"slds-text-ctitle\">Task Parameters</div><br>\n<div ng-repeat=\"(key, value) in bpTree.response.showtaskdetails.data\" style=\"width:50%;\">\n<table  class=\"slds-table slds-table--bordered slds-table--cell-buffer fixedWidthTask\" cellpadding=\"10\" cellspacing=\"10\" width=\"100%\" ng-if=\"key =='parameters' &&  key !='deps'\">\n<tr>\n    <td class=\"slds-text-title fixedWidthTask\">Type</td>\n    <td>{{bpTree.response.showtaskdetails.data.type}}</td>\n    </tr>\n<tr>\n    <td class=\"slds-text-title fixedWidthTask\">State</td>\n    <td>{{bpTree.response.showtaskdetails.data.state}}</td>\n</tr>\n<tr ng-repeat=\"(pkey, pvalue) in value\" ng-if=\"pkey !='Orchestration Item Type' && pkey !='State'\">\n  <td class=\"slds-text-title fixedWidthTask\"> {{pkey}} </td> <td> {{ pvalue }} </td>\n</tr>\n</table>\n</div>\n</script>",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Sass__c": "table {\n    /*border: 1px solid black;*/\n    text-transform:capitalize;\n}\n.vlocity .table > tbody > td:nth-of-type(even){\n    \n}\n.vlocity .vlc-validation-field .vlc-validation-success{\n   margin-top:25px;\n   \n}\n\n td.fixedWidth,td.fixedWidthTask{\n    width:240px;\n}  \n\n.XomManualQueueTask .slds-text-ctitle{\n    font-size:15px;\n    line-height: 1.25;\n    color: #54698d;\n}\n.via-slds .slds-table--bordered{\n    border:none;\n}\n\n.via-slds .slds-table tr:last-child td:not(a){\n    border-bottom:1px solid #d8dde6;\n}\n\na[ng-click]{\n    cursor: pointer;\n}\n.order .field{\nmargin-bottom: 16px;\n    float: left;\n    margin-left: 50px;\n    width: 160px;\n}\n.order .field-label{\nfont-weight: 600;\n    font-size: 12px;\n    text-transform: uppercase;\n    display: block;\n}\n.order .field-value\n{\n    overflow: hidden;\n    text-overflow: ellipsis;\n    white-space: nowrap;\n}\n.vlocity .panel-title{\ncolor:inherit;\n}\n\n[ng\\:cloak], [ng-cloak], .ng-cloak {\n\t\t\tdisplay: none !important;\n\t\t}\n\n\t\t.vlocity .vlc-overlay {\n\t\t\tposition: fixed;\n\t\t\tz-index: 1038;\n\t\t\tbackground-color: rgba(255, 255, 255, 0.9);\n\t\t\twidth: 100%;\n\t\t\theight: 100%; }\n\t\t\t.vlocity .vlc-overlay .spinner {\n\t\t\t\tposition: fixed;\n\t\t\t\ttop: 50%;\n\t\t\t\tleft: 50%;\n\t\t\t\tmargin-top: -14px;\n\t\t\t\tmargin-left: -14px;\n\t\t\t}\n\t\t\t.modal-body p {\n\t\t\t\tword-wrap: break-word;\n\t\t\t}\n\t\t\t.modal-backdrop, .am-fade {\n\t\t\t\tdisplay: none;\n\t\t\t}\n            .tooltip-inner{\n                max-width:350px !important;\n                width:auto;\n                overflow-wrap: break-word;\n                overflow:auto;\n                z-index:10000;\n            }\n            .panel-title .tooltip-inner{\n                width:auto;\n                max-width:2000px !important;\n                whitespace:no-wrap;\n                overflow-wrap: break-word;\n                overflow:visible;\n                z-index:10000;\n            }\n            .order .field-value{\n                overflow:hidden; \n                text-overflow:ellipsis;\n                white-space:nowrap;\n            }\n.vlocity .vlc-validation-field .vlc-validation-success i, .vlocity .vlc-validation-field .vlc-validation-success small{\n    color:red;\n}\n.vlocity .vlc-validation-field .vlc-validation-success i{\n    display:none;\n}\n.vlocity .vlc-validation-field .vlc-validation-success{\n    background-color:white;\n}",
                        "%vlocity_namespace%__Type__c": "OmniScript",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "xom-manualqueue-task",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUITemplate__c",
                        "VlocityRecordSourceKey": "VlocityUITemplate/xom-manualqueue-task/%vlocity_namespace%__VlocityUITemplate__c/xom-manualqueue-task"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUITemplate/xom-manualqueue-task",
                "VlocityDataPackType": "VlocityUITemplate"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUITemplate/xom-manualqueue-task",
            "VlocityDataPackName": "xom-manualqueue-task",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUITemplate"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUITemplate/xom-manualqueue-task": "Reference by Salesforce Id"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__OmniScript__c": [
                    {
                        "%vlocity_namespace%__AdditionalInformation__c": "This OS used for XOM Manual Task Updates",
                        "%vlocity_namespace%__DataRaptorBundleId__c": "",
                        "%vlocity_namespace%__Element__c": [
                            {
                                "%vlocity_namespace%__Active__c": true,
                                "%vlocity_namespace%__InternalNotes__c": "",
                                "%vlocity_namespace%__Level__c": 0,
                                "%vlocity_namespace%__OmniScriptId__c": {
                                    "Name": "XOM Thor Manual Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c"
                                },
                                "%vlocity_namespace%__OmniScriptVersion__c": 1,
                                "%vlocity_namespace%__Order__c": 1,
                                "%vlocity_namespace%__ParentElementId__c": "",
                                "%vlocity_namespace%__PropertySet__c": "{\"HTMLTemplateId\":\"\",\"controlWidth\":12,\"extraPayload\":{},\"failureAbortLabel\":\"Cancel\",\"failureAbortMessage\":\"\",\"failureNextLabel\":\"Continue\",\"inProgressMessage\":\"In Progress\",\"label\":\"Get Task Details\",\"message\":{\"\":\"\"},\"namedCredential\":\"true\",\"postMessage\":\"Done\",\"postTransformBundle\":\"\",\"preTransformBundle\":\"\",\"redirectNextLabel\":\"Next\",\"redirectNextWidth\":3,\"redirectPageName\":\"\",\"redirectPreviousLabel\":\"Previous\",\"redirectPreviousWidth\":3,\"redirectTemplateUrl\":\"vlcAcknowledge.html\",\"responseJSONNode\":\"showtaskdetails\",\"responseJSONPath\":\"\",\"restMethod\":\"GET\",\"restOptions\":{\"URIEncode\":false,\"cache\":false,\"headers\":{},\"params\":{},\"sendBody\":true,\"timeout\":null,\"withCredentials\":true},\"restPath\":\"%uiServicesUrl%/orderManagement/orchestrationItem/view/%taskId%\",\"sendJSONNode\":\"\",\"sendJSONPath\":\"\",\"show\":null,\"showPersistentComponent\":[false,false],\"ssm\":false,\"type\":\"Web\",\"validationRequired\":\"None\",\"wpm\":false,\"xmlPostTransformBundle\":\"\",\"xmlPreTransformBundle\":\"\"}",
                                "%vlocity_namespace%__ReusableOmniScript__c": false,
                                "%vlocity_namespace%__SearchKey__c": "",
                                "%vlocity_namespace%__Type__c": "Rest Action",
                                "Name": "Get Task Details",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                                "VlocityRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Get Task Details"
                            },
                            {
                                "%vlocity_namespace%__Active__c": true,
                                "%vlocity_namespace%__InternalNotes__c": "",
                                "%vlocity_namespace%__Level__c": 0,
                                "%vlocity_namespace%__OmniScriptId__c": {
                                    "Name": "XOM Thor Manual Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c"
                                },
                                "%vlocity_namespace%__OmniScriptVersion__c": 1,
                                "%vlocity_namespace%__Order__c": 2,
                                "%vlocity_namespace%__ParentElementId__c": "",
                                "%vlocity_namespace%__PropertySet__c": "{\"HTMLTemplateId\":\"\",\"controlWidth\":12,\"extraPayload\":{},\"failureAbortLabel\":\"Cancel\",\"failureAbortMessage\":\"\",\"failureNextLabel\":\"Continue\",\"inProgressMessage\":\"In Progress\",\"label\":\"Get Order Details\",\"message\":{},\"namedCredential\":\"\",\"postMessage\":\"Done\",\"postTransformBundle\":\"\",\"preTransformBundle\":\"\",\"redirectNextLabel\":\"Next\",\"redirectNextWidth\":3,\"redirectPageName\":\"\",\"redirectPreviousLabel\":\"Previous\",\"redirectPreviousWidth\":3,\"redirectTemplateUrl\":\"vlcAcknowledge.html\",\"responseJSONNode\":\"showOrderDetails\",\"responseJSONPath\":\"\",\"restMethod\":\"GET\",\"restOptions\":{\"URIEncode\":false,\"cache\":false,\"headers\":{},\"params\":{},\"sendBody\":true,\"timeout\":null,\"withCredentials\":true},\"restPath\":\"%uiServicesUrl%/orderManagement/orderItems/%showtaskdetails:data:orderItemId%/view\",\"sendJSONNode\":\"\",\"sendJSONPath\":\"\",\"show\":null,\"showPersistentComponent\":[false,false],\"ssm\":false,\"type\":\"Web\",\"validationRequired\":\"None\",\"wpm\":false,\"xmlPostTransformBundle\":\"\",\"xmlPreTransformBundle\":\"\"}",
                                "%vlocity_namespace%__ReusableOmniScript__c": false,
                                "%vlocity_namespace%__SearchKey__c": "",
                                "%vlocity_namespace%__Type__c": "Rest Action",
                                "Name": "Get Order Details",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                                "VlocityRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Get Order Details"
                            },
                            {
                                "%vlocity_namespace%__Active__c": true,
                                "%vlocity_namespace%__InternalNotes__c": "",
                                "%vlocity_namespace%__Level__c": 0,
                                "%vlocity_namespace%__OmniScriptId__c": {
                                    "Name": "XOM Thor Manual Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c"
                                },
                                "%vlocity_namespace%__OmniScriptVersion__c": 1,
                                "%vlocity_namespace%__Order__c": 3,
                                "%vlocity_namespace%__ParentElementId__c": "",
                                "%vlocity_namespace%__PropertySet__c": "{\"HTMLTemplateId\":\"\",\"cancelLabel\":\"\",\"cancelMessage\":\"\",\"completeLabel\":\"\",\"completeMessage\":\"\",\"conditionType\":\"Hide if False\",\"instruction\":\"\",\"knowledgeOptions\":{\"dataCategoryCriteria\":\"\",\"keyword\":\"Done\",\"language\":\"English\",\"publishStatus\":\"Online\",\"remoteTimeout\":30000},\"label\":null,\"nextLabel\":\"\",\"nextWidth\":0,\"previousLabel\":\"\",\"previousWidth\":0,\"remoteClass\":\"\",\"remoteMethod\":\"\",\"remoteOptions\":{},\"remoteTimeout\":30000,\"saveLabel\":\"\",\"saveMessage\":\"\",\"show\":null,\"showPersistentComponent\":[false,false],\"validationRequired\":true}",
                                "%vlocity_namespace%__ReusableOmniScript__c": false,
                                "%vlocity_namespace%__SearchKey__c": "",
                                "%vlocity_namespace%__Type__c": "Step",
                                "Name": "Manual Queue Task",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                                "VlocityRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Manual Queue Task"
                            },
                            {
                                "%vlocity_namespace%__Active__c": true,
                                "%vlocity_namespace%__InternalNotes__c": "",
                                "%vlocity_namespace%__Level__c": 1,
                                "%vlocity_namespace%__OmniScriptId__c": {
                                    "Name": "XOM Thor Manual Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c"
                                },
                                "%vlocity_namespace%__OmniScriptVersion__c": 1,
                                "%vlocity_namespace%__Order__c": 1,
                                "%vlocity_namespace%__ParentElementId__c": {
                                    "%vlocity_namespace%__OmniScriptId__c": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "Name": "Manual Queue Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Manual Queue Task",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c"
                                },
                                "%vlocity_namespace%__ParentElementName__c": "Manual Queue Task",
                                "%vlocity_namespace%__ParentElementType__c": "Step",
                                "%vlocity_namespace%__PropertySet__c": "{\"HTMLTemplateId\":\"xom-manualqueue-task\",\"controlWidth\":2,\"elementValueMap\":{\"Task Details\":\"%showTaskDetails[data] %\"},\"label\":\"selectData\",\"message\":{},\"show\":null,\"showPersistentComponent\":[false,false],\"ssm\":false,\"validationRequired\":\"None\",\"wpm\":false}",
                                "%vlocity_namespace%__ReusableOmniScript__c": false,
                                "%vlocity_namespace%__SearchKey__c": "",
                                "%vlocity_namespace%__Type__c": "Set Values",
                                "Name": "Set Value",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                                "VlocityRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Set Value"
                            },
                            {
                                "%vlocity_namespace%__Active__c": true,
                                "%vlocity_namespace%__InternalNotes__c": "",
                                "%vlocity_namespace%__Level__c": 1,
                                "%vlocity_namespace%__OmniScriptId__c": {
                                    "Name": "XOM Thor Manual Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c"
                                },
                                "%vlocity_namespace%__OmniScriptVersion__c": 1,
                                "%vlocity_namespace%__Order__c": 10,
                                "%vlocity_namespace%__ParentElementId__c": {
                                    "%vlocity_namespace%__OmniScriptId__c": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "Name": "Manual Queue Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Manual Queue Task",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c"
                                },
                                "%vlocity_namespace%__ParentElementName__c": "Manual Queue Task",
                                "%vlocity_namespace%__ParentElementType__c": "Step",
                                "%vlocity_namespace%__PropertySet__c": "{\"HTMLTemplateId\":\"\",\"controlWidth\":5,\"hideLabel\":true,\"label\":\"validation Message\",\"messages\":[{\"active\":true,\"text\":\"Please Assign Task to Manual Queue for Complete/Retry\",\"type\":\"Success\",\"value\":true},{\"active\":false,\"text\":\"\",\"type\":\"Warning\",\"value\":false}],\"show\":{\"group\":{\"operator\":\"AND\",\"rules\":[{\"condition\":\"=\",\"data\":null,\"field\":\"showtaskdetails:data:parameters:Assigned To Manual Queue Global Key\"},{\"condition\":\"=\",\"data\":null,\"field\":\"showtaskdetails:data:parameters:Manual Queue Global Key\"}]}},\"validateExpression\":null}",
                                "%vlocity_namespace%__ReusableOmniScript__c": false,
                                "%vlocity_namespace%__SearchKey__c": "",
                                "%vlocity_namespace%__Type__c": "Validation",
                                "Name": "Validation Meg",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                                "VlocityRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Validation Meg"
                            },
                            {
                                "%vlocity_namespace%__Active__c": false,
                                "%vlocity_namespace%__InternalNotes__c": "",
                                "%vlocity_namespace%__Level__c": 1,
                                "%vlocity_namespace%__OmniScriptId__c": {
                                    "Name": "XOM Thor Manual Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c"
                                },
                                "%vlocity_namespace%__OmniScriptVersion__c": 1,
                                "%vlocity_namespace%__Order__c": 11,
                                "%vlocity_namespace%__ParentElementId__c": {
                                    "%vlocity_namespace%__OmniScriptId__c": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "Name": "Manual Queue Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Manual Queue Task",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c"
                                },
                                "%vlocity_namespace%__ParentElementName__c": "Manual Queue Task",
                                "%vlocity_namespace%__ParentElementType__c": "Step",
                                "%vlocity_namespace%__PropertySet__c": "{\"HTMLTemplateId\":\"\",\"controlWidth\":3,\"hideLabel\":true,\"label\":\"Complete Knowledge Message\",\"messages\":[{\"active\":true,\"text\":\"Task is completed\",\"type\":\"Success\",\"value\":true},{\"active\":true,\"text\":\"Not Completed\",\"type\":\"Warning\",\"value\":false}],\"show\":{\"group\":{\"operator\":\"AND\",\"rules\":[{\"condition\":\"<>\",\"data\":\"\",\"field\":\"completeTaskDetails:data:created\"}]}},\"validateExpression\":null}",
                                "%vlocity_namespace%__ReusableOmniScript__c": false,
                                "%vlocity_namespace%__SearchKey__c": "",
                                "%vlocity_namespace%__Type__c": "Validation",
                                "Name": "Complete Knowledge Message",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                                "VlocityRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Complete Knowledge Message"
                            },
                            {
                                "%vlocity_namespace%__Active__c": true,
                                "%vlocity_namespace%__InternalNotes__c": "",
                                "%vlocity_namespace%__Level__c": 1,
                                "%vlocity_namespace%__OmniScriptId__c": {
                                    "Name": "XOM Thor Manual Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c"
                                },
                                "%vlocity_namespace%__OmniScriptVersion__c": 1,
                                "%vlocity_namespace%__Order__c": 2,
                                "%vlocity_namespace%__ParentElementId__c": {
                                    "%vlocity_namespace%__OmniScriptId__c": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "Name": "Manual Queue Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Manual Queue Task",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c"
                                },
                                "%vlocity_namespace%__ParentElementName__c": "Manual Queue Task",
                                "%vlocity_namespace%__ParentElementType__c": "Step",
                                "%vlocity_namespace%__PropertySet__c": "{\"HTMLTemplateId\":\"xom-manualqueue-task\",\"accessibleInFutureSteps\":false,\"dataJSON\":true,\"itemsKey\":\"recSet\",\"label\":null,\"maxCompareSize\":4,\"modalConfigurationSetting\":{\"modalController\":\"ModalProductCtrl\",\"modalHTMLTemplateId\":\"vlcProductConfig.html\",\"modalSize\":\"lg\"},\"modalController\":\"ModalInstanceCtrl\",\"modalHTMLTemplateId\":\"vlcModalContent.html\",\"modalSize\":\"\",\"postTransformBundle\":\"\",\"preTransformBundle\":\"\",\"remoteClass\":\"\",\"remoteMethod\":\"\",\"remoteOptions\":{\"postTransformBundle\":\"\",\"preTransformBundle\":\"\"},\"remoteTimeout\":30000,\"responseJSONNode\":\"\",\"responseJSONPath\":\"\",\"selectMode\":\"Single\",\"sendJSONNode\":\"\",\"sendJSONPath\":\"\",\"show\":null}",
                                "%vlocity_namespace%__ReusableOmniScript__c": false,
                                "%vlocity_namespace%__SearchKey__c": "",
                                "%vlocity_namespace%__Type__c": "Selectable Items",
                                "Name": "Task Details",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                                "VlocityRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Task Details"
                            },
                            {
                                "%vlocity_namespace%__Active__c": true,
                                "%vlocity_namespace%__InternalNotes__c": "",
                                "%vlocity_namespace%__Level__c": 1,
                                "%vlocity_namespace%__OmniScriptId__c": {
                                    "Name": "XOM Thor Manual Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c"
                                },
                                "%vlocity_namespace%__OmniScriptVersion__c": 1,
                                "%vlocity_namespace%__Order__c": 3,
                                "%vlocity_namespace%__ParentElementId__c": {
                                    "%vlocity_namespace%__OmniScriptId__c": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "Name": "Manual Queue Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Manual Queue Task",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c"
                                },
                                "%vlocity_namespace%__ParentElementName__c": "Manual Queue Task",
                                "%vlocity_namespace%__ParentElementType__c": "Step",
                                "%vlocity_namespace%__PropertySet__c": "{\"HTMLTemplateId\":\"\",\"controlWidth\":12,\"currencySymbol\":\"$\",\"dataType\":\"Text\",\"dateFormat\":\"MM-dd-yyyy\",\"expression\":\"IF((%showtaskdetails:data:state%=='Pending'||%showtaskdetails:data:state%=='Failed'||%showtaskdetails:data:state%=='Ready'||%showtaskdetails:data:state%=='Fatally Failed'||%showtaskdetails:data:state%=='In Progress'||%showtaskdetails:data:state%=='Draft'||%showtaskdetails:data:state%=='Running')&&((%showtaskdetails:data:parameters:Assigned To Manual Queue Global Key%!=NULL)||(%showtaskdetails:data:parameters:Manual Queue Global Key%!=NULL)), 'DoComplete','DonotComplete')\",\"extraPayload\":{},\"failureAbortLabel\":\"Abort\",\"failureAbortMessage\":\"Are you sure?\",\"failureNextLabel\":\"Continue\",\"hide\":true,\"hideGroupSep\":false,\"inProgressMessage\":\"In Progress\",\"inputWidth\":12,\"label\":\"Formula 1\",\"mask\":null,\"message\":{},\"postMessage\":\"Done\",\"redirectNextLabel\":\"Next\",\"redirectNextWidth\":3,\"redirectPreviousLabel\":\"Previous\",\"redirectPreviousWidth\":3,\"redirectTemplateUrl\":\"vlcAcknowledge.html\",\"restOptions\":{\"URIEncode\":false,\"cache\":false,\"headers\":{},\"params\":{},\"sendBody\":true,\"timeout\":null,\"withCredentials\":false},\"show\":null,\"showInputWidth\":false,\"showPersistentComponent\":[false,false],\"ssm\":false,\"type\":\"Apex\",\"validationRequired\":\"Step\",\"wpm\":false}",
                                "%vlocity_namespace%__ReusableOmniScript__c": false,
                                "%vlocity_namespace%__SearchKey__c": "",
                                "%vlocity_namespace%__Type__c": "Formula",
                                "Name": "CompleteFormula",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                                "VlocityRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/CompleteFormula"
                            },
                            {
                                "%vlocity_namespace%__Active__c": true,
                                "%vlocity_namespace%__InternalNotes__c": "",
                                "%vlocity_namespace%__Level__c": 1,
                                "%vlocity_namespace%__OmniScriptId__c": {
                                    "Name": "XOM Thor Manual Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c"
                                },
                                "%vlocity_namespace%__OmniScriptVersion__c": 1,
                                "%vlocity_namespace%__Order__c": 4,
                                "%vlocity_namespace%__ParentElementId__c": {
                                    "%vlocity_namespace%__OmniScriptId__c": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "Name": "Manual Queue Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Manual Queue Task",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c"
                                },
                                "%vlocity_namespace%__ParentElementName__c": "Manual Queue Task",
                                "%vlocity_namespace%__ParentElementType__c": "Step",
                                "%vlocity_namespace%__PropertySet__c": "{\"HTMLTemplateId\":\"\",\"accessibleInFutureSteps\":false,\"controlWidth\":2,\"dataJSON\":false,\"extraPayload\":{},\"failureAbortLabel\":\"Abort\",\"failureAbortMessage\":\"Are you sure?\",\"failureNextLabel\":\"Continue\",\"inProgressMessage\":\"In Progress\",\"itemsKey\":\"recSet\",\"label\":\"Complete\",\"maxCompareSize\":4,\"message\":{},\"modalConfigurationSetting\":{\"modalController\":\"ModalProductCtrl\",\"modalHTMLTemplateId\":\"vlcProductConfig.html\",\"modalSize\":\"lg\"},\"modalController\":\"ModalInstanceCtrl\",\"modalHTMLTemplateId\":\"vlcModalContent.html\",\"namedCredential\":\"\",\"postMessage\":\"Done\",\"postTransformBundle\":\"\",\"preTransformBundle\":\"\",\"redirectNextLabel\":\"Next\",\"redirectNextWidth\":3,\"redirectPageName\":\"\",\"redirectPreviousLabel\":\"\",\"redirectPreviousWidth\":0,\"redirectTemplateUrl\":\"vlcAcknowledge.html\",\"remoteOptions\":{\"postTransformBundle\":\"\",\"preTransformBundle\":\"\"},\"remoteTimeout\":30000,\"responseJSONNode\":\"completeTaskDetails\",\"responseJSONPath\":\"\",\"restMethod\":\"GET\",\"restOptions\":{\"URIEncode\":false,\"cache\":false,\"headers\":{},\"params\":{},\"sendBody\":true,\"timeout\":null,\"withCredentials\":true},\"restPath\":\"%uiServicesUrl%/taskManagement/tasks/%taskId%/complete\",\"selectMode\":\"Single\",\"sendJSONNode\":\"\",\"sendJSONPath\":\"\",\"show\":{\"group\":{\"operator\":\"AND\",\"rules\":[{\"condition\":\"=\",\"data\":\"DoComplete\",\"field\":\"CompleteFormula\"}]}},\"showPersistentComponent\":[true,true],\"ssm\":false,\"type\":\"Web\",\"validationRequired\":null,\"wpm\":true,\"xmlPostTransformBundle\":\"\",\"xmlPreTransformBundle\":\"\"}",
                                "%vlocity_namespace%__ReusableOmniScript__c": false,
                                "%vlocity_namespace%__SearchKey__c": "",
                                "%vlocity_namespace%__Type__c": "Rest Action",
                                "Name": "Complete",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                                "VlocityRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Complete"
                            },
                            {
                                "%vlocity_namespace%__Active__c": true,
                                "%vlocity_namespace%__InternalNotes__c": "",
                                "%vlocity_namespace%__Level__c": 1,
                                "%vlocity_namespace%__OmniScriptId__c": {
                                    "Name": "XOM Thor Manual Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c"
                                },
                                "%vlocity_namespace%__OmniScriptVersion__c": 1,
                                "%vlocity_namespace%__Order__c": 5,
                                "%vlocity_namespace%__ParentElementId__c": {
                                    "%vlocity_namespace%__OmniScriptId__c": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "Name": "Manual Queue Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Manual Queue Task",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c"
                                },
                                "%vlocity_namespace%__ParentElementName__c": "Manual Queue Task",
                                "%vlocity_namespace%__ParentElementType__c": "Step",
                                "%vlocity_namespace%__PropertySet__c": "{\"HTMLTemplateId\":\"\",\"accessibleInFutureSteps\":false,\"controlWidth\":2,\"dataJSON\":false,\"extraPayload\":{},\"failureAbortLabel\":\"Abort\",\"failureAbortMessage\":\"Are you sure?\",\"failureNextLabel\":\"Continue\",\"inProgressMessage\":\"In Progress\",\"itemsKey\":\"recSet\",\"label\":\"Retry\",\"maxCompareSize\":4,\"message\":{},\"modalConfigurationSetting\":{\"modalController\":\"ModalProductCtrl\",\"modalHTMLTemplateId\":\"vlcProductConfig.html\",\"modalSize\":\"lg\"},\"modalController\":\"ModalInstanceCtrl\",\"modalHTMLTemplateId\":\"vlcModalContent.html\",\"namedCredential\":\"\",\"postMessage\":\"Done\",\"postTransformBundle\":\"\",\"preTransformBundle\":\"\",\"redirectNextLabel\":\"Next\",\"redirectNextWidth\":3,\"redirectPageName\":\"\",\"redirectPreviousLabel\":\"\",\"redirectPreviousWidth\":0,\"redirectTemplateUrl\":\"vlcAcknowledge.html\",\"remoteOptions\":{\"postTransformBundle\":\"\",\"preTransformBundle\":\"\"},\"remoteTimeout\":30000,\"responseJSONNode\":\"completeTaskDetails\",\"responseJSONPath\":\"\",\"restMethod\":\"GET\",\"restOptions\":{\"URIEncode\":false,\"cache\":false,\"headers\":{},\"params\":{},\"sendBody\":true,\"timeout\":null,\"withCredentials\":true},\"restPath\":\"%uiServicesUrl%/taskManagement/tasks/%taskId%/switchToReady\",\"selectMode\":\"Single\",\"sendJSONNode\":\"\",\"sendJSONPath\":\"\",\"show\":{\"group\":{\"operator\":\"AND\",\"rules\":[{\"condition\":\"=\",\"data\":\"DoRetry\",\"field\":\"RetryFormula\"}]}},\"showPersistentComponent\":[true,true],\"ssm\":false,\"type\":\"Web\",\"validationRequired\":null,\"wpm\":true,\"xmlPostTransformBundle\":\"\",\"xmlPreTransformBundle\":\"\"}",
                                "%vlocity_namespace%__ReusableOmniScript__c": false,
                                "%vlocity_namespace%__SearchKey__c": "",
                                "%vlocity_namespace%__Type__c": "Rest Action",
                                "Name": "Retry",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                                "VlocityRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Retry"
                            },
                            {
                                "%vlocity_namespace%__Active__c": true,
                                "%vlocity_namespace%__InternalNotes__c": "",
                                "%vlocity_namespace%__Level__c": 1,
                                "%vlocity_namespace%__OmniScriptId__c": {
                                    "Name": "XOM Thor Manual Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c"
                                },
                                "%vlocity_namespace%__OmniScriptVersion__c": 1,
                                "%vlocity_namespace%__Order__c": 6,
                                "%vlocity_namespace%__ParentElementId__c": {
                                    "%vlocity_namespace%__OmniScriptId__c": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "Name": "Manual Queue Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Manual Queue Task",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c"
                                },
                                "%vlocity_namespace%__ParentElementName__c": "Manual Queue Task",
                                "%vlocity_namespace%__ParentElementType__c": "Step",
                                "%vlocity_namespace%__PropertySet__c": "{\"HTMLTemplateId\":\"\",\"controlWidth\":12,\"currencySymbol\":\"$\",\"dataType\":\"Text\",\"dateFormat\":\"MM-dd-yyyy\",\"expression\":\"IF((%showtaskdetails:data:parameters:Assigned To Manual Queue Global Key%!=NULL)&&((%showtaskdetails:data:type%=='Callout')||(%showtaskdetails:data:type%=='PushEvent'))&&((%showtaskdetails:data:state%!='Ready')&&(%showtaskdetails:data:state%!='Pending')), 'DoRetry','DonotRetry')\",\"extraPayload\":{},\"failureAbortLabel\":\"Abort\",\"failureAbortMessage\":\"Are you sure?\",\"failureNextLabel\":\"Continue\",\"hide\":true,\"hideGroupSep\":false,\"inProgressMessage\":\"In Progress\",\"inputWidth\":12,\"label\":\"Retry Formula\",\"mask\":null,\"message\":{},\"postMessage\":\"Done\",\"redirectNextLabel\":\"Next\",\"redirectNextWidth\":3,\"redirectPreviousLabel\":\"Previous\",\"redirectPreviousWidth\":3,\"redirectTemplateUrl\":\"vlcAcknowledge.html\",\"restOptions\":{\"URIEncode\":false,\"cache\":false,\"headers\":{},\"params\":{},\"sendBody\":true,\"timeout\":null,\"withCredentials\":false},\"show\":null,\"showInputWidth\":true,\"showPersistentComponent\":[false,false],\"ssm\":false,\"type\":\"Apex\",\"validationRequired\":\"Step\",\"wpm\":false}",
                                "%vlocity_namespace%__ReusableOmniScript__c": false,
                                "%vlocity_namespace%__SearchKey__c": "",
                                "%vlocity_namespace%__Type__c": "Formula",
                                "Name": "RetryFormula",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                                "VlocityRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/RetryFormula"
                            },
                            {
                                "%vlocity_namespace%__Active__c": true,
                                "%vlocity_namespace%__InternalNotes__c": "",
                                "%vlocity_namespace%__Level__c": 1,
                                "%vlocity_namespace%__OmniScriptId__c": {
                                    "Name": "XOM Thor Manual Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c"
                                },
                                "%vlocity_namespace%__OmniScriptVersion__c": 1,
                                "%vlocity_namespace%__Order__c": 7,
                                "%vlocity_namespace%__ParentElementId__c": {
                                    "%vlocity_namespace%__OmniScriptId__c": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English",
                                    "Name": "Manual Queue Task",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Manual Queue Task",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c"
                                },
                                "%vlocity_namespace%__ParentElementName__c": "Manual Queue Task",
                                "%vlocity_namespace%__ParentElementType__c": "Step",
                                "%vlocity_namespace%__PropertySet__c": "{\"HTMLTemplateId\":\"\",\"consoleTabLabel\":\"New\",\"controlWidth\":2,\"label\":\"Cancel\",\"message\":{},\"redirectPageName\":\"mobileDone\",\"redirectTemplateUrl\":\"vlcMobileConfirmation.html\",\"show\":null,\"source\":\"\",\"ssm\":false,\"type\":\"Redirect\",\"validationRequired\":null,\"wpm\":false}",
                                "%vlocity_namespace%__ReusableOmniScript__c": false,
                                "%vlocity_namespace%__SearchKey__c": "",
                                "%vlocity_namespace%__Type__c": "Done Action",
                                "Name": "Cancel",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                                "VlocityRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__Element__c/Cancel"
                            }
                        ],
                        "%vlocity_namespace%__IsActive__c": true,
                        "%vlocity_namespace%__IsProcedure__c": false,
                        "%vlocity_namespace%__IsReusable__c": false,
                        "%vlocity_namespace%__Language__c": "English",
                        "%vlocity_namespace%__ProcedureKey__c": "",
                        "%vlocity_namespace%__PropertySet__c": "{\n    \"allowSaveForLater\": false,\n    \"autoFocus\": false,\n    \"autoSaveOnStepNext\": false,\n    \"cancelRedirectPageName\": \"OmniScriptCancelled\",\n    \"cancelRedirectTemplateUrl\": \"vlcCancelled.html\",\n    \"cancelSource\": \"\",\n    \"cancelType\": \"SObject\",\n    \"consoleTabLabel\": \"New\",\n    \"elementTypeToHTMLTemplateMapping\": {\n    },\n    \"enableKnowledge\": true,\n    \"knowledgeArticleTypeQueryFieldsMap\": {\n    },\n    \"message\": {\n    },\n    \"persistentComponent\": [\n        {\n            \"id\": \"vlcCart\",\n            \"itemsKey\": \"cartItems\",\n            \"label\": \"\",\n            \"modalConfigurationSetting\": {\n                \"modalController\": \"ModalProductCtrl\",\n                \"modalHTMLTemplateId\": \"vlcProductConfig.html\",\n                \"modalSize\": \"lg\"\n            },\n            \"postTransformBundle\": \"\",\n            \"preTransformBundle\": \"\",\n            \"remoteClass\": \"\",\n            \"remoteMethod\": \"\",\n            \"remoteOptions\": {\n                \"postTransformBundle\": \"\",\n                \"preTransformBundle\": \"\"\n            },\n            \"remoteTimeout\": 30000,\n            \"render\": false,\n            \"responseJSONNode\": \"\",\n            \"responseJSONPath\": \"\",\n            \"sendJSONNode\": \"\",\n            \"sendJSONPath\": \"\"\n        },\n        {\n            \"id\": \"vlcKnowledge\",\n            \"itemsKey\": \"knowledgeItems\",\n            \"label\": \"\",\n            \"modalConfigurationSetting\": {\n                \"modalController\": \"\",\n                \"modalHTMLTemplateId\": \"\",\n                \"modalSize\": \"lg\"\n            },\n            \"postTransformBundle\": \"\",\n            \"preTransformBundle\": \"\",\n            \"remoteClass\": \"\",\n            \"remoteMethod\": \"\",\n            \"remoteOptions\": {\n                \"postTransformBundle\": \"\",\n                \"preTransformBundle\": \"\"\n            },\n            \"remoteTimeout\": 30000,\n            \"render\": false\n        }\n    ],\n    \"saveContentEncoded\": false,\n    \"saveExpireInDays\": null,\n    \"saveForLaterRedirectPageName\": \"sflRedirect\",\n    \"saveForLaterRedirectTemplateUrl\": \"vlcSaveForLaterAcknowledge.html\",\n    \"saveNameTemplate\": null,\n    \"saveObjectId\": \"%ContextId%\",\n    \"saveURLPatterns\": {\n    },\n    \"seedDataJSON\": {\n    },\n    \"ssm\": false,\n    \"timeTracking\": true,\n    \"trackingCustomData\": {\n    },\n    \"visualforcePagesAvailableInPreview\": {\n    },\n    \"wpm\": false\n}",
                        "%vlocity_namespace%__SubType__c": "ThorManualTaskUpdate",
                        "%vlocity_namespace%__Type__c": "ThorManualTask",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "XOM Thor Manual Task",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                        "VlocityRecordSourceKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English/%vlocity_namespace%__OmniScript__c/ThorManualTask/ThorManualTaskUpdate/English"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English",
                "VlocityDataPackType": "OmniScript"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "OmniScript/ThorManualTask_ThorManualTaskUpdate_English",
            "VlocityDataPackName": "ThorManualTask_ThorManualTaskUpdate_English",
            "VlocityDataPackParents": [
                "VlocityUITemplate/xom-manualqueue-task"
            ],
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "OmniScript"
        },
        {
            "VlocityDataPackAllRelationships": null,
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUITemplate__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__DisplayOn__c": "",
                        "%vlocity_namespace%__ExternalID__c": "xom-opv-attribute-config-container/1/xom/1491400334909",
                        "%vlocity_namespace%__HTML__c": "<div class=\"\">\n <vloc-card ctrl=\"{{ctrl}}\" ng-model=\"card\" data=\"cards[0]\" records=\"records\" index=\"{{$index}}\" ></vloc-card>\n</div>",
                        "%vlocity_namespace%__ParentID__c": "orchestration-attribute-config-container/1/vlocity/1490075577086",
                        "%vlocity_namespace%__Type__c": "containers",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "xom-opv-attribute-config-container",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUITemplate__c",
                        "VlocityRecordSourceKey": "VlocityUITemplate/xom-opv-attribute-config-container/%vlocity_namespace%__VlocityUITemplate__c/xom-opv-attribute-config-container"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUITemplate/xom-opv-attribute-config-container",
                "VlocityDataPackType": "VlocityUITemplate"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUITemplate/xom-opv-attribute-config-container",
            "VlocityDataPackName": "xom-opv-attribute-config-container",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUITemplate"
        },
        {
            "VlocityDataPackAllRelationships": null,
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUITemplate__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__DisplayOn__c": "",
                        "%vlocity_namespace%__ExternalID__c": "xom-opv-attribute-config-items/1/xom/1491400500871",
                        "%vlocity_namespace%__HTML__c": "<div ng-view ng-init=\"importedScope.service.attributMaxSize=records['orchestration-attribute-config']['OrcAttributeMaxsize'];\"></div>",
                        "%vlocity_namespace%__ParentID__c": "orchestration-attribute-config-items/1/vlocity/1490076633201",
                        "%vlocity_namespace%__SampleJson__c": "{\n    \"data\": {\n        \"actions\": [\n            {\n                \"displayName\": \"Like Action\",\n                \"vlocityIcon\": \"icon-v-heart\"\n            }\n        ],\n        \"fields\": [\n            {\n                \"label\": \"Description\",\n                \"name\": \"description\"\n            },\n            {\n                \"label\": \"Cost\",\n                \"name\": \"cost\",\n                \"type\": \"currency\"\n            }\n        ],\n        \"title\": \"Card Title\"\n    },\n    \"obj\": {\n        \"Id\": \"123456\",\n        \"LastModifiedDate\": \"2017-03-21T06:10:34.866Z\",\n        \"Name\": \"Object Name\",\n        \"cost\": 150,\n        \"description\": \"Some description\"\n    }\n}",
                        "%vlocity_namespace%__Type__c": "Cards",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "xom-opv-attribute-config-items",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUITemplate__c",
                        "VlocityRecordSourceKey": "VlocityUITemplate/xom-opv-attribute-config-items/%vlocity_namespace%__VlocityUITemplate__c/xom-opv-attribute-config-items"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUITemplate/xom-opv-attribute-config-items",
                "VlocityDataPackType": "VlocityUITemplate"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUITemplate/xom-opv-attribute-config-items",
            "VlocityDataPackName": "xom-opv-attribute-config-items",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUITemplate"
        },
        {
            "VlocityDataPackAllRelationships": null,
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUITemplate__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__CSS__c": ".btn-off-platform {\n  top: 81px !important;\n  left: 225px !important; }\n",
                        "%vlocity_namespace%__Definition__c": "",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__DisplayOn__c": "All",
                        "%vlocity_namespace%__ExternalID__c": "xom-opv-container/1/xom/1491399450672",
                        "%vlocity_namespace%__HTML__c": "<div ng-if=\"importedScope.isExternalId\"  class=\"container-fluid\">\n    <div class=\"btn-toolbar\" role=\"toolbar\">\n        <div class=\"btn-group actions\" role=\"group\">\n            <a class=\"submit-button\"\n            ng-click=\"importedScope.viewOriginalOrder();\"><i class=\"icon icon-v-cart\"></i><span>View Original Order</span></a>\n        </div>\n        <div class=\"btn-group actions\" role=\"group\">\n            <a class=\"submit-button\" ng-if=\"importedScope.orchestrationPlanId !=null\"\n            ng-click=\"importedScope.resolveNavigate(importedScope.orchestrationPlanId)\"><i class=\"icon icon-v-play\"></i><span>View Plan Parameters</span></a>\n        </div>\n    </div>\n</div>\n<div ng-attr-width=\"{{importedScope.getCanvasWidth(importedScope.orchestrationPlan.swimlanes)}}\" right=\"{{importedScope.getCanvasWidth(importedScope.orchestrationPlan.swimlanes)}}\" ng-class=\"importedScope.isExternalId? 'vlocity btns-left btn-container btn-off-platform' : 'vlocity btns-left btn-container'\">\n        <button id=\"zoomIn\"  ng-click=\"importedScope.scaleVal = importedScope.scaleVal+0.1; importedScope.zoomIn();\"  type=\"button\" class=\"btn btn-small btn-default\"><span class=\"icon icon-v-plus\"   aria-hidden=\"true\"></span></button>\n        <button id=\"zoomOut\" ng-if=\"importedScope.scaleVal > 0.2\"  ng-click=\"importedScope.zoomOut();\" type=\"button\" class=\"btn btn-small  btn-default\">                     <span class=\"icon icon-v-minus\"  aria-hidden=\"true\"></span></button>\n        <button id=\"zoomOut\" ng-if=\"importedScope.scaleVal <= 0.2\" ng-click=\"importedScope.zoomOut();\" type=\"button\" class=\"btn btn-small  btn-default\" ng-disabled=\"true\"><span class=\"icon icon-v-minus\"  aria-hidden=\"true\"></span></button>\n    \n    </div>\n<div id=\"canvas\">\n<svg ng-attr-width=\"{{importedScope.getCanvasWidth(importedScope.orchestrationPlan.swimlanes)}}\" ng-attr-height=\"{{importedScope.getCanvasHeight(importedScope.orchestrationPlan.swimlanes)}}\" width=\"100\" height=\"100\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n          <line x1=\"0\" y1=\"0\" ng-attr-x2=\"{{importedScope.getCanvasWidth(importedScope.orchestrationPlan.swimlanes)}}\" y2=\"0\" class=\"swimlane\"/>\n          <line ng-attr-x1=\"{{::importedScope.getSwimlaneX(swimlane)}}\" ng-attr-y1=\"{{::importedScope.getSwimlaneY2(swimlane)}}\" ng-attr-x2=\"{{importedScope.getCanvasWidth(importedScope.orchestrationPlan.swimlanes)}}\" ng-attr-y2=\"{{::importedScope.getSwimlaneY2(swimlane)}}\" ng-repeat=\"swimlane in importedScope.orchestrationPlan.swimlanes track by swimlane.idx\" class=\"swimlane\"/>\n          <g ng-repeat=\"item in importedScope.orchestrationPlan.items track by item.id\">\n            <rect ng-attr-x=\"{{::importedScope.getItemX(item)}}\" ng-attr-y=\"{{::importedScope.getItemY(item)}}\" \n                  ng-attr-width=\"{{::importedScope.getItemWidth(item)}}\" ng-attr-height=\"{{::importedScope.getItemHeight(item)}}\"\n                  ng-class=\"[importedScope.label2class(item.state), importedScope.label2class(item.type), 'item']\" rx=\"8\" ry=\"8\"/>\n            <rect ng-attr-x=\"{{::importedScope.getItemX(item)}}\" ng-attr-y=\"{{::importedScope.getItemY(item)}}\"\n                  ng-attr-width=\"{{::importedScope.getItemWidth(item)}}\" ng-attr-height=\"{{::importedScope.getHeaderHeight(item)}}\"\n                  ng-class=\"['item-header', importedScope.label2class(item.state)]\" rx=\"8\" ry=\"8\"/>\n            <use xlink:href=\"{{importedScope.getIconURL('/assets/icons/utility-sprite/svg/symbols.svg', item)}}\" fill=\"{{importedScope.getIconColor(item)}}\" stroke=\"{{importedScope.getIconColor(item)}}\" stroke-width=\"0.5\" \n                ng-attr-x=\"{{importedScope.getItemIconX(item)}}\" ng-attr-y=\"{{importedScope.getItemIconY(item)}}\" ng-attr-width=\"{{importedScope.getItemIconWidth(item)}}\" ng-attr-height=\"{{importedScope.getItemIconHeight(item)}}\"\n                ng-if=\"importedScope.shouldShowIcon(item)\"\n                ></use>\n          </g>\n          <g>\n            <g ng-repeat=\"dep in importedScope.orchestrationPlan.deps track by dep.id\">\n              <path ng-attr-d=\"{{::importedScope.buildPath(dep)}}\"  class=\"dep\"/>\n            </g>\n          </g>\n          <g ng-if=\"importedScope.orchestrationPlan.highlightedDeps\">\n            <path ng-attr-d=\"{{::importedScope.buildPath(dep)}}\" class=\"dep highlighted\" ng-repeat=\"dep in importedScope.orchestrationPlan.highlightedDeps track by dep.id\"/>\n          </g>\n          <g ng-if=\"importedScope.orchestrationPlan.highlightedItems\">\n            <rect ng-repeat=\"item in importedScope.orchestrationPlan.highlightedItems track by item.id\"\n                ng-attr-x=\"{{::importedScope.getItemX(item)}}\" ng-attr-y=\"{{::importedScope.getItemY(item)}}\" \n                ng-attr-width=\"{{::importedScope.getItemWidth(item)}}\" ng-attr-height=\"{{::importedScope.getItemHeight(item)}}\" rx=\"8\" ry=\"8\"\n                class=\"highlighted\"/>\n          </g>\n        </svg>\n        \n<div ng-repeat=\"swimlane in importedScope.orchestrationPlan.swimlanes | orderBy : 'showOrder' track by swimlane.idx\"\n    ng-style=\"{top: '{{::importedScope.getSwimlaneY(swimlane)+30}}px', left:'{{::importedScope.getSwimlaneX(swimlane)+40}}px', width: '100%'}\"\n        class=\"order-label-container\" bs-tooltip=\"swimlane.orderName+' - '+swimlane.planDefName\">\n        <a target=\"_blank\" ng-bind=\"swimlane.orderName\" ng-click=\"importedScope.resolveNavigate(swimlane.orderId)\" class=\"order-label\"></a> - <a target=\"_blank\" ng-bind=\"swimlane.planDefName\" ng-click=\"importedScope.resolveNavigate(swimlane.planDefId)\" class=\"order-label\"></a>\n</div>\n<div ng-repeat=\"item in importedScope.orchestrationPlan.items track by item.id\" ng-mouseenter=\"importedScope.highlightItemAndDependencies(item)\" ng-mouseleave=\"importedScope.unhighlightItemAndDependencies(item)\">\n          <div ng-style=\"{top: '{{::importedScope.getItemLabelY(item)+22}}px', left:'{{::importedScope.getItemLabelX(item)}}px', width:'{{::importedScope.getLabelItemWidth(item)}}px', height:'30px'}\"  class=\"item-label-container\" ng-class=\"['item-header', importedScope.label2class(item.state)]\" id=\"itemLabel-{{::item.id}}\" bs-tooltip=\"item.name+' ('+item.type+') is '+item.state\">\n                <a ng-style=\"{'max-width': '142px'}\" target=\"_blank\" ng-bind=\"item.name\" ng-click=\"importedScope.resolveNavigate(item.id)\" class=\"item-label\" ng-class=\"['item-header', importedScope.label2class(item.state)]\"></a>\n          </div>\n          <div ng-style=\"{left: '{{::importedScope.getItemTextX(item)+20}}px', top: '{{::importedScope.getItemTextY(item)+20}}px', width: '{{::importedScope.getItemTextWidth(item)}}px'}\" class=\"item-body-text\">\n            <div class=\"\">\n                 <vloc-card ctrl=\"{{ctrl}}\" ng-model=\"card\" data=\"cards[0]\" records=\"citem\" index=\"{{$index}}\" ></vloc-card>\n            </div>\n          </div>\n        </div>\n    <span id=\"flyout\"></span>\n</div>",
                        "%vlocity_namespace%__ParentID__c": "orchestration-plan-view-container/6/xom/1490866168160",
                        "%vlocity_namespace%__Sass__c": ".btn-off-platform{\n   top:81px !important;\n   left:225px !important;\n}",
                        "%vlocity_namespace%__Type__c": "containers",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "xom-opv-container",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUITemplate__c",
                        "VlocityRecordSourceKey": "VlocityUITemplate/xom-opv-container/%vlocity_namespace%__VlocityUITemplate__c/xom-opv-container"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUITemplate/xom-opv-container",
                "VlocityDataPackType": "VlocityUITemplate"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUITemplate/xom-opv-container",
            "VlocityDataPackName": "xom-opv-container",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUITemplate"
        },
        {
            "VlocityDataPackAllRelationships": null,
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUITemplate__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__CSS__c": "/*** VARIABLES ***/\n/*** STYLES ***/\n#opv-model-container {\n  width: 35%;\n  min-width: 25rem; }\n\n.vlocity #opv-model-container {\n  width: 35%;\n  min-width: 25rem; }\n",
                        "%vlocity_namespace%__Definition__c": "",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__DisplayOn__c": "",
                        "%vlocity_namespace%__ExternalID__c": "xom-opv-item-modal/2/xom/1491979828978",
                        "%vlocity_namespace%__HTML__c": "<div class=\"orchestration-item-modal\" ng-init=\"modelItem=$parent.$parent.$parent.obj\">\n<!--div>\n<div><h3 class=\"slds-text-heading--small\">{{::$root.vlocity.getCustomLabel('XOMOrchestrationModalItemDetails', 'Item Details')}}</h3> </div>\n<div>Item Name               : {{modelItem.item.name}}</div>\n<div>Item Type               : {{modelItem.item.type}}</div>\n<div>Item state              : {{modelItem.item.state}}\n<div>Item additionalName     :  {{modelItem.item.additionalName}}</div>\n<div>Start Date              : {{modelItem['parameters']['Start Date']}}</div>\n<div>Due Date                : {{modelItem['parameters']['Due Date']}}</div>\n<div>Requested Start Date    : {{modelItem['parameters']['Requested Start Date']}}</div>\n<div>Expected Completion Date:{{modelItem['parameters']['Expected Completion Date']}}</div>\n<div>Jeopardy Safety Interval: {{modelItem['parameters']['Jeopardy Safety Interval']}}</div>\n<div>Skip Branch             : {{modelItem['parameters']['Skip Branch']}}</div>\n</div>\n</div -->\n\n<table class=\"slds-table slds-table--bordered slds-table--cell-buffer\">\n    <tbody>\n    <tr>\n        <th scope=\"row\" class=\"slds-text-title\" title=\"Attribute ID {{attribute.id}}\">Item Name</th>\n        <td scope=\"row\">{{modelItem.item.name}}</td>\n    </tr>\n     <tr>\n        <th scope=\"row\" class=\"slds-text-title\" title=\"Attribute ID {{attribute.id}}\">Item Type</th>\n        <td scope=\"row\">{{modelItem.item.type}}</td>\n    </tr>\n     <tr>\n        <th scope=\"row\" class=\"slds-text-title\" title=\"Attribute ID {{attribute.id}}\">Item State</th>\n        <td scope=\"row\">{{modelItem.item.state}}</td>\n    </tr>\n    <tr>\n        <th scope=\"row\" class=\"slds-text-title\" title=\"Attribute ID {{attribute.id}}\">Item Additional Name</th>\n        <td scope=\"row\">{{modelItem.item.additionalName}}</td>\n    </tr>\n    <tr>\n        <th scope=\"row\" class=\"slds-text-title\" title=\"Attribute ID {{attribute.id}}\">Start Date</th>\n        <td scope=\"row\">{{modelItem['parameters']['Start Date']}}</td>\n    </tr>\n    <tr>\n        <th scope=\"row\" class=\"slds-text-title\" title=\"Attribute ID {{attribute.id}}\">Due Date</th>\n        <td scope=\"row\">{{modelItem['parameters']['Due Date']}}</td>\n    </tr>\n    <tr>\n        <th scope=\"row\" class=\"slds-text-title\" title=\"Attribute ID {{attribute.id}}\">Requested Start Date</th>\n        <td scope=\"row\">{{modelItem['parameters']['Requested Start Date']}}</td>\n    </tr>\n    <tr>\n        <th scope=\"row\" class=\"slds-text-title\" title=\"Attribute ID {{attribute.id}}\">Expected Completion Date</th>\n        <td scope=\"row\">{{modelItem['parameters']['Expected Completion Date']}}</td>\n    </tr>\n    <tr>\n        <th scope=\"row\" class=\"slds-text-title\" title=\"Attribute ID {{attribute.id}}\">Jeopardy Safety Interval</th>\n        <td scope=\"row\">{{modelItem['parameters']['Jeopardy Safety Interval']}}</td>\n    </tr>\n    <tr>\n        <th scope=\"row\" class=\"slds-text-title\" title=\"Attribute ID {{attribute.id}}\">Skip Branch</th>\n        <td scope=\"row\">{{modelItem['parameters']['Skip Branch']}}</td>\n    </tr>\n    </tbody>\n\n   <!--div ng-repeat=\"attr in modelItem['OrcAttributes']['OrcAttributeItems']\">\n        <div ng-if=\"attr.type==modelItem.item.type && attr.attributes.length>0\" ng-repeat=\"attrVal in attr.attributes\">\n            <div ng-if=\"modelItem['parameters'][attrVal]\">\n            {{attrVal}}       :  {{modelItem['parameters'][attrVal]}}\n            </div>\n        </div>\n    <div ng-if=\"attr.type==modelItem.item.type && attr.attributes.length==0\">\n        \n        There is no Parameters.\n    </div>\n</div -->\n\n\n    <tbody ng-repeat=\"attr in modelItem['OrcAttributes']['OrcAttributeItems']\">\n    <tr ng-if=\"attr.type==modelItem.item.type && attr.attributes.length>0\" ng-repeat=\"attrVal in attr.attributes\">\n        <th scope=\"row\" class=\"slds-text-title\" title=\"\" ng-if=\"modelItem['parameters'][attrVal]\">{{attrVal}}</th>\n        <td scope=\"row\" ng-if=\"modelItem['parameters'][attrVal]\">{{modelItem['parameters'][attrVal]}}</td>\n    </tr>\n    </tbody>\n</table>\n</div>",
                        "%vlocity_namespace%__ParentID__c": "orchestration-item-modal/1/vlocity/1489753806546",
                        "%vlocity_namespace%__Sass__c": "/*** VARIABLES ***/\n\n\n/*** STYLES ***/\n#opv-model-container{\n        width:35%;\n        min-width:25rem;\n    }\n.vlocity {\n    #opv-model-container{\n        width:35%;\n        min-width:25rem;\n    }\n}",
                        "%vlocity_namespace%__Type__c": "containers",
                        "%vlocity_namespace%__Version__c": 2,
                        "Name": "xom-opv-item-modal",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUITemplate__c",
                        "VlocityRecordSourceKey": "VlocityUITemplate/xom-opv-item-modal/%vlocity_namespace%__VlocityUITemplate__c/xom-opv-item-modal"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUITemplate/xom-opv-item-modal",
                "VlocityDataPackType": "VlocityUITemplate"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUITemplate/xom-opv-item-modal",
            "VlocityDataPackName": "xom-opv-item-modal",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUITemplate"
        },
        {
            "VlocityDataPackAllRelationships": null,
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUITemplate__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__CSS__c": ".viewMore {\n  cursor: pointer;\n  float: right; }\n\n.opv_cardItem {\n  max-width: 160px;\n  white-space: nowrap;\n  text-overflow: ellipsis;\n  overflow: hidden;\n  min-height: 40px; }\n",
                        "%vlocity_namespace%__Definition__c": "",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__DisplayOn__c": "All",
                        "%vlocity_namespace%__ExternalID__c": "xom-opv-plan-item/2/xom/1491979559434",
                        "%vlocity_namespace%__HTML__c": "<div ng-init=\"cardItem=$parent.$parent.$parent.item;\">\n<div style=\"height:{{importedScope.service.attributMaxSize*20}}px;\" class=\"opv_cardItem\">\n     {{importedScope.getItemText(cardItem)}}<br>\n     {{cardItem.additionalName}}\n<!--div ng-repeat=\"attr in obj['OrcAttributes']['OrcAttributeItems']\"> \n    <div ng-if=\"attr.type==cardItem.type\" ng-repeat=\"attrVal in attr.attributes|limitTo:importedScope.service.attributMaxSize\">\n       {{attrVal}}\n   </div>\n    \n</div -->\n</div>\n<div class=\"viewMore\" ng-click=\"importedScope.viewMore($parent.$parent.$parent.item);\">View More </div> \n</div>",
                        "%vlocity_namespace%__ParentID__c": "orchestration-plan-item/5/xom/1490097327083",
                        "%vlocity_namespace%__SampleJson__c": "{\n    \"data\": {\n        \"actions\": [\n            {\n                \"displayName\": \"Call\",\n                \"openUrlIn\": \"New Tab / Window\",\n                \"url\": \"https://www.vlocity.com\",\n                \"vlocityIcon\": \"icon-v-phone-line\"\n            },\n            {\n                \"displayName\": \"Email\",\n                \"openUrlIn\": \"New Tab / Window\",\n                \"url\": \"mailto:sales@vlocity.com\",\n                \"vlocityIcon\": \"icon-v-email-line\"\n            },\n            {\n                \"displayName\": \"Alert\",\n                \"openUrlIn\": \"New Tab / Window\",\n                \"url\": \"https://www.vlocity.com\",\n                \"vlocityIcon\": \"icon-v-alert\"\n            },\n            {\n                \"displayName\": \"Like Action\",\n                \"openUrlIn\": \"New Tab / Window\",\n                \"vlocityIcon\": \"icon-v-heart\"\n            }\n        ],\n        \"fields\": [\n            {\n                \"label\": \"Company\",\n                \"name\": \"company\"\n            },\n            {\n                \"label\": \"Description\",\n                \"name\": \"description\"\n            },\n            {\n                \"label\": \"ID\",\n                \"name\": \"Id\"\n            },\n            {\n                \"label\": \"Country\",\n                \"name\": \"country\"\n            },\n            {\n                \"label\": \"Cost\",\n                \"name\": \"cost\",\n                \"type\": \"currency\"\n            }\n        ],\n        \"title\": \"Sample Card Active Title Here\"\n    },\n    \"obj\": {\n        \"Id\": \"123456\",\n        \"LastModifiedDate\": \"2016-02-05T17:22:06.871Z\",\n        \"Name\": \"Sample sObject Name\",\n        \"company\": \"Vlocity, Inc.\",\n        \"cost\": 150,\n        \"country\": \"USA\",\n        \"description\": \"Some description\"\n    }\n}",
                        "%vlocity_namespace%__Sass__c": ".viewMore{\n    cursor:pointer;\n    float:right;\n}\n.opv_cardItem{\n    max-width: 160px;\n    white-space: nowrap;\n    text-overflow: ellipsis;\n    overflow: hidden;\n    min-height: 40px;\n}",
                        "%vlocity_namespace%__Type__c": "Cards",
                        "%vlocity_namespace%__Version__c": 2,
                        "Name": "xom-opv-plan-item",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUITemplate__c",
                        "VlocityRecordSourceKey": "VlocityUITemplate/xom-opv-plan-item/%vlocity_namespace%__VlocityUITemplate__c/xom-opv-plan-item"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUITemplate/xom-opv-plan-item",
                "VlocityDataPackType": "VlocityUITemplate"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUITemplate/xom-opv-plan-item",
            "VlocityDataPackName": "xom-opv-plan-item",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUITemplate"
        }
    ],
    "name": "DP_CARDS_XOMCards",
    "primaryDataPackKey": "VlocityDeploy",
    "processMultiple": true,
    "status": "Complete",
    "version": 1
}