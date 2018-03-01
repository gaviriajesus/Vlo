global with sharing  class CustomerDetailUtility implements vlocity_cmt.VlocityOpenInterface2
{
    /*Created For Demo Project
    * Author: Nihal A Siddique
    * Functionality: This Class stores all methods related to account details/updates etc for Vlocity Omniscripts
    * Date: 01-Feb-2017
    */
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){
    
        /*if (methodName.equals('VerifyCustomer')){
         VerifyCustomer(input, output, options);
         System.debug('MEthod called>>>>>>>>VerifyCustomer');
         return true;
        }*/
        
        if (methodName.equals('VerifyContact')){
         System.debug('MEthod called>>>>>>>>Before__VerifyContact');
         VerifyContact(input, output, options);
         System.debug('MEthod called>>>>>>>>After__VerifyContact');
         return true;
        }
        
        if (methodName.equals('setAddOpen')){
             setAddOpen(input, output, options);
             System.debug('MEthod called>>>>>>>>AddToQueue');
             return true;
        }
        
        if (methodName.equals('setAddClose')){
             setAddClose(input, output, options);
             System.debug('MEthod called>>>>>>>>AddToQueue');
             return true;
        }
        
        if (methodName.equals('EditSelectedOpen')){
             EditSelectedOpen(input, output, options);
             System.debug('MEthod called>>>>>>>>EditSelectedOpen');
             return true;
        }
        
        if (methodName.equals('EditSelectedClose')){
             EditSelectedClose(input, output, options);
             System.debug('MEthod called>>>>>>>>EditSelectedClose');
             return true;
        }
        
        if (methodName.equals('calculateAvgCustomerSatisfaction')){
             calculateAvgCustomerSatisfaction(input, output, options);         
             return true;
        }
        return false;
    }
    
    //Customer Validation Query
    /*public void VerifyCustomer(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){
        String CustomerInput = (String)input.get('CustomerInput');
        system.debug('Input :'+ input);
        Map <String, Object> ExtractedInfo = new Map<String, Object>();
        List<Account> lstAccount = [Select Id, Name, AccountNumber, Account_Balance__c, Service_Identifier__c, vlocity_cmt__PrimaryContactId__r.Id, Last_Paid_Amount__c, Last_Paid_Date__c, vlocity_cmt__PrimaryContactId__r.Name From Account where (Id = :CustomerInput OR Service_Identifier__c = :CustomerInput OR  vlocity_cmt__PrimaryContactId__r.Name = :CustomerInput OR AccountNumber = :CustomerInput) LIMIT 1];
        if(lstAccount != null && !lstAccount.isEmpty() && lstAccount[0].vlocity_cmt__PrimaryContactId__c != null && lstAccount[0].vlocity_cmt__PrimaryContactId__r.Name != null && lstAccount[0].vlocity_cmt__PrimaryContactId__r.MobilePhone != null){
            ExtractedInfo.put('CustomerName', lstAccount[0].Name);
            ExtractedInfo.put('CustomerAccount#', lstAccount[0].AccountNumber);
            ExtractedInfo.put('CustomerServiceId', lstAccount[0].Service_Identifier__c);
            ExtractedInfo.put('CustomerFirstName', lstAccount[0].vlocity_cmt__PrimaryContactId__r.Name);
            ExtractedInfo.put('CustomerLastName', lstAccount[0].vlocity_cmt__PrimaryContactId__r.MobilePhone);
            output.put('ExtractedInfo',ExtractedInfo);
            
            system.debug('Output :'+ output);
        }
        else
        {
            
        }
    }*/
    
    public void VerifyContact(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){
        Object CustomerInput = input.get('Step 1');
        //List<String> InputFields = new List<String>(CustomerInput.split(','));
        //List<String> InputField1 = new List<String>(InputFields[0].split('='));
        //String FirstName = '';
        //InputFields = (String)('FirstName', CustomerInput.FirstName);
        //String CustomerInput1 = (String)CustomerInput.get('FirstName');
        //Object CustomerInput2 = CustomerInput.LastName;
        //Object CustomerInput3 = CustomerInput.Mobile;
        system.debug('Input :'+ input);
        system.debug('CustomerInput :'+CustomerInput);
        //system.debug('InputFields :'+ InputFields);
        //system.debug('InputField1 :'+ InputField1);
        //system.debug('CustomerInput2 :'+ CustomerInput2);
        //system.debug('CustomerInput3 :'+ CustomerInput3);
    }
    
    
    public void setAddOpen(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        String addBlock = 'open' ;
        outPutMap.put('closeAddBlock', addBlock );
        
        
    }
    
    public void setAddClose(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        String addBlock = 'close' ;
        outPutMap.put('closeAddBlock', addBlock ); 
        system.debug('outPutMap --->' + outPutMap);
    }
    
    public void EditSelectedOpen(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        String addBlock = 'open' ;
        outPutMap.put('closeAddBlock', addBlock );
    }
    
    public void EditSelectedClose(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        String addBlock = 'close' ;
        outPutMap.put('closeAddBlock', addBlock ); 
        system.debug('outPutMap --->' + outPutMap);
    }
    public void calculateAvgCustomerSatisfaction(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options){
        system.debug('inputMap--->' + inputMap);
        Object custRating  = inputMap.get('SatisfactionAssessment');
        system.debug('custRating  --->' + custRating  );        
        Map<String, Object> mapSatisfaction = (Map<String, Object>)inputMap.get('SatisfactionAssessment');
        system.debug('mapSatisfaction  --->' + mapSatisfaction  );
        Integer rating = 0;
        //String ratingStr = (String)mapSatisfaction.get('CustomerSatisfactionRating');
        //system.debug('ratingStr  --->' + ratingStr  );
        if(mapSatisfaction.get('CustomerSatisfactionRating') != null && mapSatisfaction.get('CustomerSatisfactionRating') != ''){
            rating = Integer.valueOf(mapSatisfaction.get('CustomerSatisfactionRating'));
        }
        User loggedInUser = [Select Id, NoOfCustomerServed__c, TotalCustomerSatisfactionScore__c from User where id =: userinfo.getUserId()];
        if(null == loggedInUser.NoOfCustomerServed__c  ) 
            loggedInUser.NoOfCustomerServed__c = 1;
        else{
            loggedInUser.NoOfCustomerServed__c ++ ;
            }
        if( null == loggedInUser.TotalCustomerSatisfactionScore__c ) { loggedInUser.TotalCustomerSatisfactionScore__c = rating;}
        else { loggedInUser.TotalCustomerSatisfactionScore__c = loggedInUser.TotalCustomerSatisfactionScore__c + rating; }
        system.debug('loggedInUser  --->' + loggedInUser  );
        update loggedInUser;
     }
}