global with sharing class SetPricesToZero implements vlocity_cmt.VlocityOpenInterface{

    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){
        if (methodName.equals('priceItems')){
            return priceItems(input, output, options);
        }
        return true;
    }

    private Boolean priceItems(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> optionsMap){
        Map<String,Object> filterEvaluatorOutput = (Map<String, Object>)inputMap.get('filterEvaluatorOutput');
        Map<Id, Sobject> sobjectIdToSobject = (Map<Id, Sobject>)filterEvaluatorOutput.get('sobjectIdToSobject');
        List<Id> qualifiedObjectIds = new List<Id>((Set <Id>)inputMap.get('qualifiedObjectIds'));

        for(Integer i = 0; i < qualifiedObjectIds.size(); i++){
            Sobject objectSO = sobjectIdToSobject.get(qualifiedObjectIds[i]);
            objectSO.put('vlocity_cmt__OneTimeTotal__c', 0.0);
            objectSO.put('vlocity_cmt__RecurringTotal__c', 0.0);
            objectSO.put('vlocity_cmt__OneTimeCharge__c', 0.0);
            objectSO.put('vlocity_cmt__RecurringCharge__c', 0.0);
            objectSO.put('vlocity_cmt__EffectiveOneTimeTotal__c', 0.0);
            objectSO.put('vlocity_cmt__EffectiveRecurringTotal__c', 0.0);   
        }
            return true;
    }
}