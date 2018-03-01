global with sharing class VDOCustomAssetsActionProcessServiceV2 implements vlocity_cmt.VlocityOpenInterface2
{
    public Object invokeMethod(String methodName,Map<String,Object> inputs, Map<String,Object> output, Map<String,Object> options)
    {
        Boolean success = true;
        try{
            if(methodName == 'createInteraction')
            {
                success = createInteraction(inputs, output, options);
            }
            
        }catch(Exception e){
            System.debug('Error invoke method: ' + methodName + ' with error: '+ e);
            success = false;
        }
        return success;
    }
    
    private static Boolean createInteraction(Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> optionMap)
    {
        Boolean success = true;
        System.debug(' input Map  is '+JSON.serializePretty(inputMap));
        String drBundleName=(String) inputMap.get('drBundleName');
        String interactionObj = (String) inputMap.get('interactionObjName');
        System.debug(' drBundleName is '+drBundleName);
        System.debug(' interactionObj is '+interactionObj);
        
        vlocity_cmt.DRProcessResult drResult;
           
        drResult = vlocity_cmt.DRGlobal.process(inputMap,drBundleName);
        System.debug(' dr result is '+drResult);
        
        if(drResult.createdObjectsByType != null && drResult.createdObjectsByType.size() > 0)
        {
            List<Id> objIds = new List<Id>();
            if(drResult.createdObjectsByType.get(drBundleName) != null && drResult.createdObjectsByType.get(drBundleName).containsKey(interactionObj))
            {
                objIds = drResult.createdObjectsByType.get(drBundleName).get(interactionObj);
            }
            else
            {
                objIds = drResult.createdObjectsByType.get(drBundleName).get('vlocity_cmt__CustomerInteraction__c');
            }
            System.debug(' ---------------'+interactionObj+'Ids is '+objIds);
            if(objIds !=null && objIds.size()==1){
               outputMap.put('parent'+interactionObj+'Id',  objIds[0]);
               outputMap.put(interactionObj+'Id',  objIds[0]);
            }
            else if(objIds !=null && objIds.size()>1){
                outputMap.put('parent'+interactionObj+'Id',  objIds[0]);
                outputMap.put(interactionObj+'Id',  objIds[1]);
            }

            //create CustomerInteractionTopic__c
            Id interactionId = objIds[0];
            List<vlocity_cmt__CustomerInteraction__c> interactions = [Select Id, vlocity_cmt__ContactId__c from vlocity_cmt__CustomerInteraction__c where Id=:interactionId];
            //List<vlocity_cmt__CustomerInteraction__c> interactions = [Select Id, vlocity_cmt__ContactId__c, vlocity_cmt_AccountId__c from vlocity_cmt__CustomerInteraction__c where Id=:interactionId];
            if(interactions[0].vlocity_cmt__ContactId__c !=null)
            {
                Id contactId = interactions[0].vlocity_cmt__ContactId__c;
                List<AccountContactRelation> relationships = [Select Id, AccountId, Account.Name, Roles, IsDirect from AccountContactRelation where ContactId=: contactId];
                //Id accountId = interactions[0].vlocity_cmt__AccountId__c;         
                //List<AccountContactRelation> relationships = [Select Id, AccountId, Account.Name, Roles, IsDirect from AccountContactRelation where ContactId=: contactId and AccountId = :accountId];
                if(relationships!=null && relationships.size()>0)
                {
                   List<vlocity_cmt__CustomerInteractionTopic__c> citList = new List<vlocity_cmt__CustomerInteractionTopic__c> ();
                   for(AccountContactRelation rel : relationships)
                   {
                        //get all assets for this account relationship
                        Id accountId = rel.AccountId;
                        List<Asset> assets = [Select Id from Asset Where AccountId = :accountId];
                        if(assets != null && assets.size() > 0)
                        {
                            for(Asset a : assets)
                            {
                                vlocity_cmt__CustomerInteractionTopic__c cit = new vlocity_cmt__CustomerInteractionTopic__c(Name=rel.Account.Name, vlocity_cmt__AccountId__c=rel.AccountId, Roles__c= rel.Roles, vlocity_cmt__CustomerInteractionId__c=interactionId, vlocity_cmt__AssetId__c=a.Id);
                                citList.add(cit);
                            }
                        }
                        
                   }
                   
                   insert citList;
                } 

            }   
        }
        System.debug('------------------outputMap is '+outputMap);       
        return success;
    }

}