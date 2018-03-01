public without sharing class TelcoUnmanagedPostInstallClass implements InstallHandler {

    private static String nsp = '';

    public void onInstall(InstallContext context)
    {
        createPricingVariablesAndBindings();
    }

    public static void createPricingVariablesAndBindings()
    {
        ApexClass ac = [select Id, Name, NamespacePrefix from ApexClass where Name = 'PricingComponentSelector' LIMIT 1];
        if (ac != null && ac.NamespacePrefix != nsp)
        {
            nsp = String.isNotBlank(ac.NamespacePrefix)? ac.NamespacePrefix + '__' : ac.NamespacePrefix;
        }
        Map<Id, SObject> existingVars = new Map<Id, SObject>(Database.query('select Id, Name, ' + nsp + 'Code__c from ' + nsp + 'PricingVariable__c LIMIT 1000'));
        Map<String, SObject> existingCodeMap = new Map<String, SObject>();
        for (SObject pVarObj : existingVars.values()) {
            existingCodeMap.put((String)pVarObj.get(nsp + 'Code__c'), pVarObj);
        }
        createPricingVariables(existingCodeMap);
        createPricingVariableBindings(existingCodeMap);
    }

    private static void createPricingVariables(Map<String, SObject> existingCodeMap)
    {
        List<Map<String, Object>> pVarList = new List<Map<String, Object>>();
        Map<String, Object> pVarMap;
        pVarMap = new Map<String, Object>{
        'Name' => 'One Time Std Price',
        'AdjustmentMethod__c' => null,
        'Aggregation__c' => 'Unit',
        'AppliesToVariableId__c' => null,
        'ChargeType__c' => 'One-time',
        'Code__c' => 'OT_STD_PRC',
        'IsActive__c' => true,
        'RecurringFrequency__c' => null,
        'Scope__c' => 'Line',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Pricing Element'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'One Time Std Price Calculated',
        'AdjustmentMethod__c' => null,
        'Aggregation__c' => 'Unit',
        'AppliesToVariableId__c' => null,
        'ChargeType__c' => 'One-time',
        'Code__c' => 'OT_STD_PRC_CALC',
        'IsActive__c' => true,
        'RecurringFrequency__c' => null,
        'Scope__c' => 'Line',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Calculated'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'One Time Std Price Total',
        'AdjustmentMethod__c' => null,
        'Aggregation__c' => 'Quantity',
        'AppliesToVariableId__c' => null,
        'ChargeType__c' => 'One-time',
        'Code__c' => 'OT_STD_PRC_TOTAL',
        'IsActive__c' => true,
        'RecurringFrequency__c' => null,
        'Scope__c' => 'Line',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Calculated'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price',
        'AdjustmentMethod__c' => null,
        'Aggregation__c' => 'Unit',
        'AppliesToVariableId__c' => null,
        'ChargeType__c' => 'Recurring',
        'Code__c' => 'REC_MNTH_STD_PRC',
        'IsActive__c' => true,
        'RecurringFrequency__c' => 'Monthly',
        'Scope__c' => 'Line',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Pricing Element'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price Calculated',
        'AdjustmentMethod__c' => null,
        'Aggregation__c' => 'Unit',
        'AppliesToVariableId__c' => null,
        'ChargeType__c' => 'Recurring',
        'Code__c' => 'REC_MNTH_STD_PRC_CALC',
        'IsActive__c' => true,
        'RecurringFrequency__c' => 'Monthly',
        'Scope__c' => 'Line',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Calculated'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price Total',
        'AdjustmentMethod__c' => null,
        'Aggregation__c' => 'Quantity',
        'AppliesToVariableId__c' => null,
        'ChargeType__c' => 'Recurring',
        'Code__c' => 'REC_MNTH_STD_PRC_TOTAL',
        'IsActive__c' => true,
        'RecurringFrequency__c' => 'Monthly',
        'Scope__c' => 'Line',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Calculated'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'Effective One Time Std Price Total',
        'AdjustmentMethod__c' => null,
        'Aggregation__c' => 'Quantity',
        'AppliesToVariableId__c' => null,
        'ChargeType__c' => 'One-time',
        'Code__c' => 'EFF_OT_STD_PRC_TOTAL',
        'IsActive__c' => true,
        'RecurringFrequency__c' => null,
        'Scope__c' => 'Line',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Calculated'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'Effective Recurring Monthly Std Price Total',
        'AdjustmentMethod__c' => null,
        'Aggregation__c' => 'Quantity',
        'AppliesToVariableId__c' => null,
        'ChargeType__c' => 'Recurring',
        'Code__c' => 'EFF_REC_MNTH_STD_PRC_TOTAL',
        'IsActive__c' => true,
        'RecurringFrequency__c' => 'Monthly',
        'Scope__c' => 'Line',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Calculated'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'Line Quantity',
        'AdjustmentMethod__c' => null,
        'Aggregation__c' => 'Quantity',
        'AppliesToVariableId__c' => null,
        'ChargeType__c' => null,
        'Code__c' => 'LINE_QUANTITY',
        'IsActive__c' => true,
        'RecurringFrequency__c' => null,
        'Scope__c' => 'Line',
        'SubType__c' => null,
        'Type__c' => null,
        'ValueType__c' => 'Calculated'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'Usage',
        'AdjustmentMethod__c' => null,
        'Aggregation__c' => 'Unit',
        'AppliesToVariableId__c' => null,
        'ChargeType__c' => 'Usage',
        'Code__c' => 'USAGE',
        'IsActive__c' => true,
        'RecurringFrequency__c' => null,
        'Scope__c' => 'Line',
        'SubType__c' => null,
        'Type__c' => 'Price',
        'ValueType__c' => 'Pricing Element'
        };
        pVarList.add(pVarMap);
        doUpsertPricingVariables(pVarList, existingCodeMap);

        pVarList.clear();
        pVarMap = new Map<String, Object>{
        'Name' => 'One Time Std Price Discount Pct',
        'AdjustmentMethod__c' => 'Percent',
        'Aggregation__c' => 'Unit',
        'AppliesToVariableId__c' => ((SObject)existingCodeMap.get('OT_STD_PRC')).Id,
        'ChargeType__c' => 'Adjustment',
        'Code__c' => 'OT_STD_PRC_DISC_PCT',
        'IsActive__c' => true,
        'RecurringFrequency__c' => null,
        'Scope__c' => 'Line',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Pricing Element'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'One Time Std Price Discount Abs',
        'AdjustmentMethod__c' => 'Absolute',
        'Aggregation__c' => 'Unit',
        'AppliesToVariableId__c' => ((SObject)existingCodeMap.get('OT_STD_PRC')).Id,
        'ChargeType__c' => 'Adjustment',
        'Code__c' => 'OT_STD_PRC_DISC_ABS',
        'IsActive__c' => true,
        'RecurringFrequency__c' => null,
        'Scope__c' => 'Line',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Pricing Element'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'One Time Std Price Discount Pct Manual',
        'AdjustmentMethod__c' => 'Percent',
        'Aggregation__c' => 'Unit',
        'AppliesToVariableId__c' => ((SObject)existingCodeMap.get('OT_STD_PRC')).Id,
        'ChargeType__c' => 'Adjustment',
        'Code__c' => 'OT_STD_PRC_DISC_PCT_MAN',
        'IsActive__c' => true,
        'RecurringFrequency__c' => null,
        'Scope__c' => 'Line',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Calculated'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price Discount Pct',
        'AdjustmentMethod__c' => 'Percent',
        'Aggregation__c' => 'Unit',
        'AppliesToVariableId__c' => ((SObject)existingCodeMap.get('REC_MNTH_STD_PRC')).Id,
        'ChargeType__c' => 'Adjustment',
        'Code__c' => 'REC_MNTH_STD_PRC_DISC_PCT',
        'IsActive__c' => true,
        'RecurringFrequency__c' => 'Monthly',
        'Scope__c' => 'Line',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Pricing Element'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price Discount Abs',
        'AdjustmentMethod__c' => 'Absolute',
        'Aggregation__c' => 'Unit',
        'AppliesToVariableId__c' => ((SObject)existingCodeMap.get('REC_MNTH_STD_PRC')).Id,
        'ChargeType__c' => 'Adjustment',
        'Code__c' => 'REC_MNTH_STD_PRC_DISC_ABS',
        'IsActive__c' => true,
        'RecurringFrequency__c' => 'Monthly',
        'Scope__c' => 'Line',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Pricing Element'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price Discount Pct Manual',
        'AdjustmentMethod__c' => 'Percent',
        'Aggregation__c' => 'Unit',
        'AppliesToVariableId__c' => ((SObject)existingCodeMap.get('REC_MNTH_STD_PRC')).Id,
        'ChargeType__c' => 'Adjustment',
        'Code__c' => 'REC_MNTH_STD_PRC_DISC_PCT_MAN',
        'IsActive__c' => true,
        'RecurringFrequency__c' => 'Monthly',
        'Scope__c' => 'Line',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Calculated'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'Rollup One Time Std Price Total',
        'AdjustmentMethod__c' => null,
        'Aggregation__c' => 'Quantity',
        'AppliesToVariableId__c' => ((SObject)existingCodeMap.get('OT_STD_PRC_TOTAL')).Id,
        'ChargeType__c' => 'One-time',
        'Code__c' => 'ROLLUP_OT_STD_PRC_TOTAL',
        'IsActive__c' => true,
        'RecurringFrequency__c' => null,
        'Scope__c' => 'Rollup',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Calculated'
        };
        pVarList.add(pVarMap);
        pVarMap = new Map<String, Object>{
        'Name' => 'Rollup Recurring Monthly Std Price Total',
        'AdjustmentMethod__c' => null,
        'Aggregation__c' => 'Quantity',
        'AppliesToVariableId__c' => ((SObject)existingCodeMap.get('REC_MNTH_STD_PRC_TOTAL')).Id,
        'ChargeType__c' => 'Recurring',
        'Code__c' => 'ROLLUP_REC_MNTH_STD_PRC_TOTAL',
        'IsActive__c' => true,
        'RecurringFrequency__c' => null,
        'Scope__c' => 'Rollup',
        'SubType__c' => 'Standard',
        'Type__c' => 'Price',
        'ValueType__c' => 'Calculated'
        };
        pVarList.add(pVarMap);
        doUpsertPricingVariables(pVarList, existingCodeMap);
    }

    private static void createPricingVariableBindings(Map<String, SObject> existingCodeMap)
    {
        List<SObject> existingBindingList = Database.query('select Id, Name from ' + nsp + 'PricingVariableBinding__c LIMIT 1000');
        Map<String, SObject> existingBindingMap = new Map<String, SObject>();
        for (SObject bindingObj : existingBindingList) {
            existingBindingMap.put((String)bindingObj.get('Name'), bindingObj);
        }
        List<Map<String, Object>> pVarBindingList = new List<Map<String, Object>>();
        Map<String, Object> pVarBindingMap;
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'One Time Std Price - OrderItem',
        'DestinationSObjectType__c' => 'OrderItem',
        'DestinationFieldApiName__c' => 'OneTimeCharge__c',
        'PricingVariableId__r.Code__c' => 'OT_STD_PRC'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'One Time Std Price Discount Pct Manual - OrderItem',
        'DestinationSObjectType__c' => 'OrderItem',
        'DestinationFieldApiName__c' => 'OneTimeManualDiscount__c',
        'PricingVariableId__r.Code__c' => 'OT_STD_PRC_DISC_PCT_MAN'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'One Time Std Price Calculated - OrderItem',
        'DestinationSObjectType__c' => 'OrderItem',
        'DestinationFieldApiName__c' => 'OneTimeCalculatedPrice__c',
        'PricingVariableId__r.Code__c' => 'OT_STD_PRC_CALC'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'One Time Std Price Total - OrderItem',
        'DestinationSObjectType__c' => 'OrderItem',
        'DestinationFieldApiName__c' => 'OneTimeTotal__c',
        'PricingVariableId__r.Code__c' => 'OT_STD_PRC_TOTAL'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price - OrderItem',
        'DestinationSObjectType__c' => 'OrderItem',
        'DestinationFieldApiName__c' => 'RecurringCharge__c',
        'PricingVariableId__r.Code__c' => 'REC_MNTH_STD_PRC'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price Discount Pct Manual - OrderItem',
        'DestinationSObjectType__c' => 'OrderItem',
        'DestinationFieldApiName__c' => 'RecurringManualDiscount__c',
        'PricingVariableId__r.Code__c' => 'REC_MNTH_STD_PRC_DISC_PCT_MAN'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price Calculated - OrderItem',
        'DestinationSObjectType__c' => 'OrderItem',
        'DestinationFieldApiName__c' => 'RecurringCalculatedPrice__c',
        'PricingVariableId__r.Code__c' => 'REC_MNTH_STD_PRC_CALC'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price Total - OrderItem',
        'DestinationSObjectType__c' => 'OrderItem',
        'DestinationFieldApiName__c' => 'RecurringTotal__c',
        'PricingVariableId__r.Code__c' => 'REC_MNTH_STD_PRC_TOTAL'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Effective One Time Std Price Total - OrderItem',
        'DestinationSObjectType__c' => 'OrderItem',
        'DestinationFieldApiName__c' => 'EffectiveOneTimeTotal__c',
        'PricingVariableId__r.Code__c' => 'EFF_OT_STD_PRC_TOTAL'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Effective Recurring Monthly Std Price Total - OrderItem',
        'DestinationSObjectType__c' => 'OrderItem',
        'DestinationFieldApiName__c' => 'EffectiveRecurringTotal__c',
        'PricingVariableId__r.Code__c' => 'EFF_REC_MNTH_STD_PRC_TOTAL'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Line Quantity - OrderItem',
        'DestinationSObjectType__c' => 'OrderItem',
        'DestinationFieldApiName__c' => 'Quantity',
        'PricingVariableId__r.Code__c' => 'LINE_QUANTITY'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'One Time Std Price - QuoteLineItem',
        'DestinationSObjectType__c' => 'QuoteLineItem',
        'DestinationFieldApiName__c' => 'OneTimeCharge__c',
        'PricingVariableId__r.Code__c' => 'OT_STD_PRC'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'One Time Std Price Discount Pct Manual - QuoteLineItem',
        'DestinationSObjectType__c' => 'QuoteLineItem',
        'DestinationFieldApiName__c' => 'OneTimeManualDiscount__c',
        'PricingVariableId__r.Code__c' => 'OT_STD_PRC_DISC_PCT_MAN'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'One Time Std Price Calculated - QuoteLineItem',
        'DestinationSObjectType__c' => 'QuoteLineItem',
        'DestinationFieldApiName__c' => 'OneTimeCalculatedPrice__c',
        'PricingVariableId__r.Code__c' => 'OT_STD_PRC_CALC'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'One Time Std Price Total - QuoteLineItem',
        'DestinationSObjectType__c' => 'QuoteLineItem',
        'DestinationFieldApiName__c' => 'OneTimeTotal__c',
        'PricingVariableId__r.Code__c' => 'OT_STD_PRC_TOTAL'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price - QuoteLineItem',
        'DestinationSObjectType__c' => 'QuoteLineItem',
        'DestinationFieldApiName__c' => 'RecurringCharge__c',
        'PricingVariableId__r.Code__c' => 'REC_MNTH_STD_PRC'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price Discount Pct Manual - QuoteLineItem',
        'DestinationSObjectType__c' => 'QuoteLineItem',
        'DestinationFieldApiName__c' => 'RecurringManualDiscount__c',
        'PricingVariableId__r.Code__c' => 'REC_MNTH_STD_PRC_DISC_PCT_MAN'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price Calculated - QuoteLineItem',
        'DestinationSObjectType__c' => 'QuoteLineItem',
        'DestinationFieldApiName__c' => 'RecurringCalculatedPrice__c',
        'PricingVariableId__r.Code__c' => 'REC_MNTH_STD_PRC_CALC'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price Total - QuoteLineItem',
        'DestinationSObjectType__c' => 'QuoteLineItem',
        'DestinationFieldApiName__c' => 'RecurringTotal__c',
        'PricingVariableId__r.Code__c' => 'REC_MNTH_STD_PRC_TOTAL'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Effective One Time Std Price Total - QuoteLineItem',
        'DestinationSObjectType__c' => 'QuoteLineItem',
        'DestinationFieldApiName__c' => 'EffectiveOneTimeTotal__c',
        'PricingVariableId__r.Code__c' => 'EFF_OT_STD_PRC_TOTAL'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Effective Recurring Monthly Std Price Total - QuoteLineItem',
        'DestinationSObjectType__c' => 'QuoteLineItem',
        'DestinationFieldApiName__c' => 'EffectiveRecurringTotal__c',
        'PricingVariableId__r.Code__c' => 'EFF_REC_MNTH_STD_PRC_TOTAL'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Line Quantity - QuoteLineItem',
        'DestinationSObjectType__c' => 'QuoteLineItem',
        'DestinationFieldApiName__c' => 'Quantity',
        'PricingVariableId__r.Code__c' => 'LINE_QUANTITY'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'One Time Std Price - Asset',
        'DestinationSObjectType__c' => 'Asset',
        'DestinationFieldApiName__c' => 'OneTimeCharge__c',
        'PricingVariableId__r.Code__c' => 'OT_STD_PRC'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'One Time Std Price Discount Pct Manual - Asset',
        'DestinationSObjectType__c' => 'Asset',
        'DestinationFieldApiName__c' => 'OneTimeManualDiscount__c',
        'PricingVariableId__r.Code__c' => 'OT_STD_PRC_DISC_PCT_MAN'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'One Time Std Price Calculated - Asset',
        'DestinationSObjectType__c' => 'Asset',
        'DestinationFieldApiName__c' => 'OneTimeCalculatedPrice__c',
        'PricingVariableId__r.Code__c' => 'OT_STD_PRC_CALC'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'One Time Std Price Total - Asset',
        'DestinationSObjectType__c' => 'Asset',
        'DestinationFieldApiName__c' => 'OneTimeTotal__c',
        'PricingVariableId__r.Code__c' => 'OT_STD_PRC_TOTAL'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price - Asset',
        'DestinationSObjectType__c' => 'Asset',
        'DestinationFieldApiName__c' => 'RecurringCharge__c',
        'PricingVariableId__r.Code__c' => 'REC_MNTH_STD_PRC'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price Discount Pct Manual - Asset',
        'DestinationSObjectType__c' => 'Asset',
        'DestinationFieldApiName__c' => 'RecurringManualDiscount__c',
        'PricingVariableId__r.Code__c' => 'REC_MNTH_STD_PRC_DISC_PCT_MAN'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price Calculated - Asset',
        'DestinationSObjectType__c' => 'Asset',
        'DestinationFieldApiName__c' => 'RecurringCalculatedPrice__c',
        'PricingVariableId__r.Code__c' => 'REC_MNTH_STD_PRC_CALC'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Recurring Monthly Std Price Total - Asset',
        'DestinationSObjectType__c' => 'Asset',
        'DestinationFieldApiName__c' => 'RecurringTotal__c',
        'PricingVariableId__r.Code__c' => 'REC_MNTH_STD_PRC_TOTAL'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Effective One Time Std Price Total - Asset',
        'DestinationSObjectType__c' => 'Asset',
        'DestinationFieldApiName__c' => 'EffectiveOneTimeTotal__c',
        'PricingVariableId__r.Code__c' => 'EFF_OT_STD_PRC_TOTAL'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Effective Recurring Monthly Std Price Total - Asset',
        'DestinationSObjectType__c' => 'Asset',
        'DestinationFieldApiName__c' => 'EffectiveRecurringTotal__c',
        'PricingVariableId__r.Code__c' => 'EFF_REC_MNTH_STD_PRC_TOTAL'
        };
        pVarBindingList.add(pVarBindingMap);
        pVarBindingMap = new Map<String, Object>{
        'Name' => 'Line Quantity - Asset',
        'DestinationSObjectType__c' => 'Asset',
        'DestinationFieldApiName__c' => 'Quantity',
        'PricingVariableId__r.Code__c' => 'LINE_QUANTITY'
        };
        pVarBindingList.add(pVarBindingMap);
        doUpsertBindings(pVarBindingList, existingBindingMap, existingCodeMap);
    }

    private static void doUpsertPricingVariables(List<Map<String, Object>> pVarList, Map<String, SObject> existingCodeMap)
    {
        List<SObject> insertList = new List<SObject>();
        List<SObject> updateList = new List<SObject>();
        sObject sObj;
        for (Map<String, Object> pVarInfo : pVarList) {
            if (existingCodeMap.get((String)pVarInfo.get('Code__c')) != null) {
                sObj = existingCodeMap.get((String)pVarInfo.get('Code__c'));
                updateList.add(sObj);
            } else {
                sObj = Schema.getGlobalDescribe().get(nsp + 'PricingVariable__c').newSObject();
                insertList.add(sObj);
            }
            for (String key : pVarInfo.keySet()) {
                if (key == 'Name') {
                    sObj.put(key, pVarInfo.get(key));
                } else {
                    sObj.put(nsp + key, pVarInfo.get(key));
                }
            }
        }
        if (!updateList.isEmpty()) {
            update updateList;
            for (SObject updatedObj : updateList) {
                existingCodeMap.put((String)updatedObj.get(nsp + 'Code__c'), updatedObj);
            }
        }
        if (!insertList.isEmpty()) {
            insert insertList;
            for (SObject insertObj : insertList) {
                existingCodeMap.put((String)insertObj.get(nsp + 'Code__c'), insertObj);
            }
        }
    }

    private static void doUpsertBindings(List<Map<String, Object>> pVarBindingList, Map<String, SObject> existingBindingMap,
                                         Map<String, SObject> existingCodeMap)
    {
        sObject bindingSObj;
        List<SObject> insertList = new List<SObject>();
        List<SObject> updateList = new List<SObject>();
        for (Map<String, Object> pVarBindingInfo : pVarBindingList) {
            if (existingBindingMap.get((String)pVarBindingInfo.get('Name')) != null) {
                bindingSObj = existingBindingMap.get((String)pVarBindingInfo.get('Name'));
                updateList.add(bindingSObj);
            } else {
                bindingSObj = Schema.getGlobalDescribe().get(nsp + 'PricingVariableBinding__c').newSObject();
                insertList.add(bindingSObj);
            }
            for (String key : pVarBindingInfo.keySet()) {
                if (key == 'Name') {
                    bindingSObj.put(key, pVarBindingInfo.get(key));
                } else if (key == 'PricingVariableId__r.Code__c') {
                    if (bindingSObj.Id == null) {
                        bindingSObj.put(nsp + 'PricingVariableId__c', ((SObject)existingCodeMap.get((String)pVarBindingInfo.get(key))).Id);
                    }
                } else if (key == 'DestinationFieldApiName__c') {
                    String value = (String)pVarBindingInfo.get(key);
                    if (value.endsWith('__c')) value = nsp + value;
                    bindingSObj.put(nsp + key, value);
                } else {
                    bindingSObj.put(nsp + key, pVarBindingInfo.get(key));
                }
            }
        }
        if (!updateList.isEmpty()) {
            update updateList;
        }
        if (!insertList.isEmpty()) {
            insert insertList;
        }
    }
}