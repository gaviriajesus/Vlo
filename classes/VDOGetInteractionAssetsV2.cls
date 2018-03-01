global with sharing class VDOGetInteractionAssetsV2 implements vlocity_cmt.VlocityOpenInterface2
{
    public Object invokeMethod(String methodName,Map<String,Object> inputs, Map<String,Object> output, Map<String,Object> options)
    {
        Boolean success = true;
        try{
            if(methodName == 'getInteractionAssets')
            {
                getInteractionAssets(inputs, output, options);
            }
            
        }catch(Exception e){
            System.debug('Error invoke method: ' + methodName + ' with error: '+ e);
            success = false;
        }
        return success;
    }

    private void getInteractionAssets(Map<String,Object> inputMap,  Map<String,Object> outMap, Map<String,Object> options)
    {
        String interactionId = String.valueOf(inputMap.get('interactionId'));
        System.debug('interaction id is '+interactionId);
        //List<vlocity_cmt__CustomerInteraction__c> interactions = [Select vlocity_cmt__AccountId__c, vlocity_cmt__ContactId__c from vlocity_cmt__CustomerInteraction__c where Id =:interactionId];
        //System.debug('interactions are '+interactions);
      
        if(String.isNotBlank(interactionId)) 
        {
            List<Map<String, Object>> listOfResults = new List<Map<String, Object>>();
            List<vlocity_cmt__CustomerInteractionTopic__c> iTopics= [SELECT Id, vlocity_cmt__AccountId__c, Name, Roles__c, vlocity_cmt__AssetId__c FROM vlocity_cmt__CustomerInteractionTopic__c WHERE vlocity_cmt__CustomerInteractionId__c = :interactionId ORDER BY CreatedDate];
            if(iTopics != null && iTopics.size() > 0)
            {
                //Set<Id> accountIds = new Set<Id>();
                Map<Id, String> accountRolesMap = new Map<Id, String>();
                //Map<Id, String> assetRolesMap = new Map<Id, String>();
                Map<Id, Id> assetTopicMap = new Map<Id, Id>();
                for(vlocity_cmt__CustomerInteractionTopic__c it:iTopics)
                {
                    //accountIds.add(it.vlocity_cmt__AccountId__c);
                    accountRolesMap.put(it.vlocity_cmt__AccountId__c, it.Roles__c);
                    assetTopicMap.put(it.vlocity_cmt__AssetId__c, it.Id);
                }
                //System.debug('accountIds: ' + accountIds);
                System.debug('accountRolesMap'+ accountRolesMap + ' assetTopicMap: ' + assetTopicMap);
                //get list of assets for accountIds
                List<Asset> assets = [SELECT Id,vlocity_cmt__ParentItemId__c,Is_Root__c,AccountId,Account.Name,LastModifiedDate,Product2.Name,Product2.vlocity_cmt__Type__c,Product2.vlocity_cmt__JSONAttribute__c, Product2.Family, Product2.vlocity_cmt__SubType__c ,vlocity_cmt__BillingAccountId__r.Name,Name, Price,SerialNumber, vlocity_cmt__LineNumber__c, Product_Family__c,Product_Family_Image__c, PurchaseDate,InstallDate,Status,Mobile_Number__c, vlocity_cmt__RecurringTotal__c,Description, Quantity, AssetCategory__c FROM Asset WHERE Id in :assetTopicMap.keySet() AND (vlocity_cmt__LineNumber__c LIKE '____.____' OR vlocity_cmt__LineNumber__c LIKE '____') ORDER BY Account.Name, vlocity_cmt__LineNumber__c];
                if(assets != null && assets.size() > 0)
                {
                    for (Asset ast: assets)
                    {
                        Map<String, Object> result = new Map<String, Object>();
                        result.put('InteractionId', interactionId);
                        result.put('InteractionTopicId', assetTopicMap.get(ast.Id));
                        result.put('AccountId', ast.AccountId);
                        result.put('Id', ast.Id);
                        result.put('vlocity_cmt__ParentItemId__c', ast.vlocity_cmt__ParentItemId__c);
                        result.put('Is_Root__c', ast.Is_Root__c);
                        result.put('Account_Name', ast.Account.Name);
                        result.put('ContactRoles', accountRolesMap.get(ast.AccountId));
                        result.put('LastModifiedDate', ast.LastModifiedDate);
                        result.put('Product2_Name', ast.Product2.Name);
                        result.put('Product2_vlocity_cmt__Type__c', ast.Product2.vlocity_cmt__Type__c);
                        result.put('Product2_vlocity_cmt__JSONAttribute__c', ast.Product2.vlocity_cmt__JSONAttribute__c);
                        result.put('Product2_Family', ast.Product2.Family);
                        result.put('Product2_vlocity_cmt__SubType__c', ast.Product2.vlocity_cmt__SubType__c);
                        result.put('vlocity_cmt__BillingAccountId__r_Name', ast.vlocity_cmt__BillingAccountId__r.Name);
                        result.put('Name', ast.Name);
                        result.put('Price', ast.Price);
                        result.put('SerialNumber', ast.SerialNumber);
                        result.put('vlocity_cmt__LineNumber__c', ast.vlocity_cmt__LineNumber__c);
                        result.put('Product_Family__c', ast.Product_Family__c);
                        result.put('Product_Family_Image__c', ast.Product_Family_Image__c);
                        result.put('PurchaseDate', ast.PurchaseDate);
                        result.put('InstallDate', ast.InstallDate);
                        result.put('Status', ast.Status);
                        result.put('Mobile_Number__c', ast.Mobile_Number__c);
                        result.put('vlocity_cmt__RecurringTotal__c', ast.vlocity_cmt__RecurringTotal__c);
                        result.put('Description', ast.Description);
                        result.put('Quantity', ast.Quantity);
                        result.put('AssetCategory__c', ast.AssetCategory__c);
                        listOfResults.add(result);
                    }
                    system.debug('listOfResults: ' + listofResults);
                    outMap.put('records', listOfResults);
                }
            }
        }

    }
}