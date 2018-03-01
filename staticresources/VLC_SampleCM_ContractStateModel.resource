{
  "status": "Complete",
  "primaryDataPackKey": "8ff0fb31bc147ebbb66114317b4cf835",
  "dataPacks": [
    {
      "VlocityPrimarySourceId": "a26o0000000masqAAA",
      "VlocityDataPackType": "VlocityStateModel",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Primary",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Id: a26o0000000masqAAA",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity State Model",
      "VlocityDataPackKey": "8ff0fb31bc147ebbb66114317b4cf835",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackRelationshipType": "Primary",
        "VlocityDataPackKey": "8ff0fb31bc147ebbb66114317b4cf835",
        "VlocityDataPackLabel": "Vlocity State Model",
        "VlocityDataPackType": "VlocityStateModel",
        "Id": "a26o0000000masqAAA",
        "%vlocity_namespace%__VlocityStateModel__c": [
          {
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModel__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a26o0000000masqAAA",
            "Id": "a26o0000000masqAAA",
            "Name": "Contract State Model",
            "%vlocity_namespace%__FieldAPIName__c": "Status",
            "%vlocity_namespace%__ObjectAPIName__c": "Contract",
            "%vlocity_namespace%__VlocityStateModelVersion__c": [
              {
                "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                "VlocityDataPackType": "SObject",
                "VlocityRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG",
                "Id": "a25o0000000GM4zAAG",
                "Name": "Version 1",
                "%vlocity_namespace%__StateModelId__c": {
                  "Name": "Contract State Model",
                  "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModel__c",
                  "VlocityDataPackType": "VlocityMatchingKeyObject",
                  "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a26o0000000masqAAA"
                },
                "%vlocity_namespace%__EndDateTime__c": "2017-01-31T19:23:00.000Z",
                "%vlocity_namespace%__Priority__c": 1,
                "%vlocity_namespace%__StartDateTime__c": "2016-01-02T02:21:00.000Z",
                "%vlocity_namespace%__VersionNumber__c": 1,
                "%vlocity_namespace%__CurrentStatus__c": "Active",
                "%vlocity_namespace%__VlocityStateTransition__c": [
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PoAAI",
                    "Id": "a27o0000000x8PoAAI",
                    "Name": "Contract Negotiating to Draft",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Negotiating",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GivjAAC"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Draft",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GiveAAC"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PpAAI",
                    "Id": "a27o0000000x8PpAAI",
                    "Name": "Contract Awaiting Signature to Negotiating",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Awaiting Signature",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjJhAAK"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Negotiating",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GivjAAC"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PqAAI",
                    "Id": "a27o0000000x8PqAAI",
                    "Name": "Contract Signature Declined to Cancelled",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Signature Declined",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKfAAK"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Cancelled",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKaAAK"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PrAAI",
                    "Id": "a27o0000000x8PrAAI",
                    "Name": "Contract Draft to Waiting Approval",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Draft",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GiveAAC"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Awaiting Approval",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKVAA0"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PsAAI",
                    "Id": "a27o0000000x8PsAAI",
                    "Name": "Contract Awaiting Signature to Signed",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Awaiting Signature",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjJhAAK"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Signed",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKLAA0"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PtAAI",
                    "Id": "a27o0000000x8PtAAI",
                    "Name": "Contract Awaiting Approval to Draft",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Awaiting Approval",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKVAA0"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Draft",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GiveAAC"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PuAAI",
                    "Id": "a27o0000000x8PuAAI",
                    "Name": "Contract Signature Declined to Draft",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Signature Declined",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKfAAK"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Draft",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GiveAAC"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PvAAI",
                    "Id": "a27o0000000x8PvAAI",
                    "Name": "Contract Signed to Activated",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Signed",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKLAA0"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Activated",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKQAA0"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PwAAI",
                    "Id": "a27o0000000x8PwAAI",
                    "Name": "Contract Rejected Internally to Draft",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Rejected Internally",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjLYAA0"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Draft",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GiveAAC"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PxAAI",
                    "Id": "a27o0000000x8PxAAI",
                    "Name": "Contract Draft to Cancelled",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Draft",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GiveAAC"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Cancelled",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKaAAK"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PyAAI",
                    "Id": "a27o0000000x8PyAAI",
                    "Name": "Contract Awaiting Signature to Cancelled",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Awaiting Signature",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjJhAAK"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Cancelled",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKaAAK"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PzAAI",
                    "Id": "a27o0000000x8PzAAI",
                    "Name": "Contract Negotiating to Cancelled",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Negotiating",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GivjAAC"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Cancelled",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKaAAK"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8Q0AAI",
                    "Id": "a27o0000000x8Q0AAI",
                    "Name": "Contract Negotiating to Waiting Signature",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Negotiating",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GivjAAC"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Awaiting Signature",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjJhAAK"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8Q1AAI",
                    "Id": "a27o0000000x8Q1AAI",
                    "Name": "Contract Awaiting Signature to Signature Declined",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Awaiting Signature",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjJhAAK"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Signature Declined",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKfAAK"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8Q2AAI",
                    "Id": "a27o0000000x8Q2AAI",
                    "Name": "Contract Activated to Terminated",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Activated",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKQAA0"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Terminated",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000wkYcAAI"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8Q3AAI",
                    "Id": "a27o0000000x8Q3AAI",
                    "Name": "Contract Awaiting Approval to Negotiating",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Awaiting Approval",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKVAA0"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Negotiating",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GivjAAC"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PlAAI",
                    "Id": "a27o0000000x8PlAAI",
                    "Name": "Contract Activated to Expired",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Activated",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKQAA0"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Expired",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000wkYwAAI"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PmAAI",
                    "Id": "a27o0000000x8PmAAI",
                    "Name": "Contract Rejected Internally to Cancelled",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Rejected Internally",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjLYAA0"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Cancelled",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKaAAK"
                    },
                    "VlocityDataPackIsIncluded": true
                  },
                  {
                    "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateTransition__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a27o0000000x8PnAAI",
                    "Id": "a27o0000000x8PnAAI",
                    "Name": "Contract Awaiting Approval to Rejected Internally",
                    "%vlocity_namespace%__StateModelVersionId__c": {
                      "%vlocity_namespace%__StateModelId__c": "a26o0000000masqAAA",
                      "%vlocity_namespace%__VersionNumber__c": 1,
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModelVersion__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a25o0000000GM4zAAG"
                    },
                    "%vlocity_namespace%__From__c": {
                      "Name": "Awaiting Approval",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKVAA0"
                    },
                    "%vlocity_namespace%__To__c": {
                      "Name": "Rejected Internally",
                      "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                      "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                      "VlocityDataPackType": "VlocityMatchingKeyObject",
                      "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjLYAA0"
                    },
                    "VlocityDataPackIsIncluded": true
                  }
                ],
                "VlocityDataPackIsIncluded": true
              }
            ],
            "%vlocity_namespace%__VlocityState__c": [
              {
                "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                "VlocityDataPackType": "SObject",
                "VlocityRecordSourceKey": "VlocityRecordSourceKey:a28o0000000wkYwAAI",
                "Id": "a28o0000000wkYwAAI",
                "Name": "Expired",
                "%vlocity_namespace%__StateModelId__c": {
                  "Name": "Contract State Model",
                  "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModel__c",
                  "VlocityDataPackType": "VlocityMatchingKeyObject",
                  "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a26o0000000masqAAA"
                },
                "%vlocity_namespace%__NoDelete__c": false,
                "%vlocity_namespace%__NoUpdate__c": true,
                "%vlocity_namespace%__StateRecordType__c": "Read Only",
                "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                "VlocityDataPackIsIncluded": true
              },
              {
                "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                "VlocityDataPackType": "SObject",
                "VlocityRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GivjAAC",
                "Id": "a28o0000000GivjAAC",
                "Name": "Negotiating",
                "%vlocity_namespace%__StateModelId__c": {
                  "Name": "Contract State Model",
                  "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModel__c",
                  "VlocityDataPackType": "VlocityMatchingKeyObject",
                  "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a26o0000000masqAAA"
                },
                "%vlocity_namespace%__NoDelete__c": false,
                "%vlocity_namespace%__NoUpdate__c": false,
                "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                "VlocityDataPackIsIncluded": true
              },
              {
                "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                "VlocityDataPackType": "SObject",
                "VlocityRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKQAA0",
                "Id": "a28o0000000GjKQAA0",
                "Name": "Activated",
                "%vlocity_namespace%__StateModelId__c": {
                  "Name": "Contract State Model",
                  "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModel__c",
                  "VlocityDataPackType": "VlocityMatchingKeyObject",
                  "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a26o0000000masqAAA"
                },
                "%vlocity_namespace%__NoDelete__c": false,
                "%vlocity_namespace%__NoUpdate__c": true,
                "%vlocity_namespace%__StateRecordType__c": "Read Only",
                "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                "VlocityDataPackIsIncluded": true
              },
              {
                "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                "VlocityDataPackType": "SObject",
                "VlocityRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKaAAK",
                "Id": "a28o0000000GjKaAAK",
                "Name": "Cancelled",
                "%vlocity_namespace%__StateModelId__c": {
                  "Name": "Contract State Model",
                  "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModel__c",
                  "VlocityDataPackType": "VlocityMatchingKeyObject",
                  "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a26o0000000masqAAA"
                },
                "%vlocity_namespace%__NoDelete__c": false,
                "%vlocity_namespace%__NoUpdate__c": false,
                "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                "VlocityDataPackIsIncluded": true
              },
              {
                "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                "VlocityDataPackType": "SObject",
                "VlocityRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjLYAA0",
                "Id": "a28o0000000GjLYAA0",
                "Name": "Rejected Internally",
                "%vlocity_namespace%__StateModelId__c": {
                  "Name": "Contract State Model",
                  "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModel__c",
                  "VlocityDataPackType": "VlocityMatchingKeyObject",
                  "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a26o0000000masqAAA"
                },
                "%vlocity_namespace%__NoDelete__c": false,
                "%vlocity_namespace%__NoUpdate__c": false,
                "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                "VlocityDataPackIsIncluded": true
              },
              {
                "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                "VlocityDataPackType": "SObject",
                "VlocityRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GiveAAC",
                "Id": "a28o0000000GiveAAC",
                "Name": "Draft",
                "%vlocity_namespace%__StateModelId__c": {
                  "Name": "Contract State Model",
                  "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModel__c",
                  "VlocityDataPackType": "VlocityMatchingKeyObject",
                  "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a26o0000000masqAAA"
                },
                "%vlocity_namespace%__NoDelete__c": false,
                "%vlocity_namespace%__NoUpdate__c": false,
                "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                "VlocityDataPackIsIncluded": true
              },
              {
                "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                "VlocityDataPackType": "SObject",
                "VlocityRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjJhAAK",
                "Id": "a28o0000000GjJhAAK",
                "Name": "Awaiting Signature",
                "%vlocity_namespace%__StateModelId__c": {
                  "Name": "Contract State Model",
                  "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModel__c",
                  "VlocityDataPackType": "VlocityMatchingKeyObject",
                  "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a26o0000000masqAAA"
                },
                "%vlocity_namespace%__NoDelete__c": false,
                "%vlocity_namespace%__NoUpdate__c": false,
                "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                "VlocityDataPackIsIncluded": true
              },
              {
                "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                "VlocityDataPackType": "SObject",
                "VlocityRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKfAAK",
                "Id": "a28o0000000GjKfAAK",
                "Name": "Signature Declined",
                "%vlocity_namespace%__StateModelId__c": {
                  "Name": "Contract State Model",
                  "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModel__c",
                  "VlocityDataPackType": "VlocityMatchingKeyObject",
                  "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a26o0000000masqAAA"
                },
                "%vlocity_namespace%__NoDelete__c": false,
                "%vlocity_namespace%__NoUpdate__c": false,
                "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                "VlocityDataPackIsIncluded": true
              },
              {
                "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                "VlocityDataPackType": "SObject",
                "VlocityRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKLAA0",
                "Id": "a28o0000000GjKLAA0",
                "Name": "Signed",
                "%vlocity_namespace%__StateModelId__c": {
                  "Name": "Contract State Model",
                  "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModel__c",
                  "VlocityDataPackType": "VlocityMatchingKeyObject",
                  "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a26o0000000masqAAA"
                },
                "%vlocity_namespace%__NoDelete__c": false,
                "%vlocity_namespace%__NoUpdate__c": true,
                "%vlocity_namespace%__StateRecordType__c": "Read Only",
                "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                "VlocityDataPackIsIncluded": true
              },
              {
                "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                "VlocityDataPackType": "SObject",
                "VlocityRecordSourceKey": "VlocityRecordSourceKey:a28o0000000GjKVAA0",
                "Id": "a28o0000000GjKVAA0",
                "Name": "Awaiting Approval",
                "%vlocity_namespace%__StateModelId__c": {
                  "Name": "Contract State Model",
                  "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModel__c",
                  "VlocityDataPackType": "VlocityMatchingKeyObject",
                  "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a26o0000000masqAAA"
                },
                "%vlocity_namespace%__NoDelete__c": false,
                "%vlocity_namespace%__NoUpdate__c": false,
                "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                "VlocityDataPackIsIncluded": true
              },
              {
                "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityState__c",
                "VlocityDataPackType": "SObject",
                "VlocityRecordSourceKey": "VlocityRecordSourceKey:a28o0000000wkYcAAI",
                "Id": "a28o0000000wkYcAAI",
                "Name": "Terminated",
                "%vlocity_namespace%__StateModelId__c": {
                  "Name": "Contract State Model",
                  "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityStateModel__c",
                  "VlocityDataPackType": "VlocityMatchingKeyObject",
                  "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a26o0000000masqAAA"
                },
                "%vlocity_namespace%__NoDelete__c": false,
                "%vlocity_namespace%__NoUpdate__c": true,
                "%vlocity_namespace%__StateRecordType__c": "Read Only",
                "%vlocity_namespace%__DTPStateModelName__c": "Contract State Model",
                "VlocityDataPackIsIncluded": true
              }
            ],
            "VlocityDataPackIsIncluded": true
          }
        ],
        "VlocityDataPackIsIncluded": true
      }
    }
  ],
  "dataPackId": "a1zo0000001GolRAAS",
  "name": "ContractStateModel",
  "version": 1
}