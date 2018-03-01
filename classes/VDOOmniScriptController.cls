global with sharing class VDOOmniScriptController implements vlocity_cmt.VlocityOpenInterface{

    public Boolean InvokeMethod(String methodName,Map <String, Object> input,Map <String, Object> output,Map <String, Object> options){
        //Update the demo accounts and contacts in the org
        if(methodName == 'updateDemoAccountContact'){
            List<Account> demoAccount = [SELECT id, shippingcity, name, vlocity_demo_name__c, Vlocity_Demo_Key__c FROM Account WHERE Vlocity_Demo_Key__c LIKE 'demoaccount%'];
            for(Account currentAccount : demoAccount){
                currentAccount.vlocity_demo_name__c = (String) options.get('firstName') + ' ' + (String) options.get('lastName');
                if(currentAccount.Vlocity_Demo_Key__c == 'demoaccount3'){
                    currentAccount.name = (String) options.get('lastName') + ' - ' + currentAccount.ShippingCity + ' Hotel';
                }else{
                    currentAccount.name = (String) options.get('lastName') + ' - ' + currentAccount.ShippingCity + ' Residence';
                }
            }
            update demoAccount;
            output.put('DemoAccount', demoAccount); 
            List<Contact> demoContact = [SELECT id, firstname, lastname, email FROM Contact WHERE Vlocity_Demo_Key__c = 'democontact1' LIMIT 1];
            if(demoContact.size() > 0){
                demoContact[0].firstname = (String) options.get('firstName');
                demoContact[0].lastname =  (String) options.get('lastName');
                demoContact[0].email = (String)options.get('email');
                update demoContact;
                output.put('DemoContact', demoContact);  
                List<vlocity_cmt__Household__c> demoHousehold = [SELECT id, vlocity_cmt__PrimaryContactId__c FROM vlocity_cmt__Household__c WHERE vlocity_cmt__PrimaryContactId__c = :demoContact LIMIT 1];
                if(demohousehold.size() > 0){
                    demoHousehold[0].name = (String) options.get('lastName') + ' Household';
                    update demoHousehold;
                }
            }
            List<Contact> demoFamily = [SELECT id, firstname, lastname FROM Contact WHERE Vlocity_Demo_Key__c = 'demofamily'];
            for(Contact familyMember : demoFamily){
                familyMember.lastname =  (String) options.get('lastName');
            }
            update demoFamily;
        }
        //Sends an order email to the demo contact in the org
        if(methodName == 'sendOrderEmail'){
            try{
                Contact demoContact = [SELECT id, firstname, lastname, email FROM Contact WHERE Vlocity_Demo_Key__c = 'democontact1' LIMIT 1];
                EmailTemplate templateId = [Select id from EmailTemplate where name = 'VDOOrderEmailTemplate'];
                List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateID(templateId.Id); 
                mail.setTargetObjectId(demoContact.id);
                mail.setWhatId((String) options.get('OrderId'));
                mail.setSaveAsActivity(true);
                
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                Document theAttachment = [SELECT id, body, name FROM Document WHERE Name = 'VDOCommunicationsDataSheet' LIMIT 1];
                attachment.setBody(theAttachment.body);
                attachment.setContentType('application/pdf');
                attachment.setFileName('Vlocity Product Information.pdf');
                attachment.setinline(false);
                Messaging.EmailFileAttachment attachment2 = new Messaging.EmailFileAttachment();
                Document theAttachment2 = [SELECT id, body, name FROM Document WHERE Name = 'VDOGoDigitalDataSheet' LIMIT 1];
                attachment2.setBody(theAttachment2.body);
                attachment2.setContentType('application/pdf');
                attachment2.setFileName('Vlocity Go Digital Information.pdf');
                attachment2.setinline(false);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment, attachment2 } );
                
                allmsg.add(mail);
                Messaging.sendEmail(allmsg,false);
            }catch(exception e){}
        }
        return true;
    } 
}