global class VDOConfigurationController{

    public vlocity_cmt__Statement__c currentStatement {get;set;}
    public vlocity_cmt__StatementLineItem__c currentStatementLineItem {get;set;}
    public VDO_Settings__c currentDemoValues {get;set;}
    public static final integer numberOfStatements = 12;
    public static final integer numberOfStatementLineItems = 12;
    public StaticResource omniscriptResources {get;set;}
    public StaticResource productResources {get;set;}
    public StaticResource communityResources {get;set;}
    public StaticResource mobileResources {get;set;}
    public Document applogoDocument {get;set;}
    public Document consoleapplogoDocument {get;set;}
    public Folder documentFolder {get;set;}
    public ApexPage demoCSS {get;set;}
    public ApexPage mobileCSS {get;set;}
    public ApexComponent omniscriptTemplates {get;set;}
    public Site mobileSite {get;set;}

    public VDOConfigurationController(){
        currentDemoValues = VDO_Settings__c.getOrgDefaults();
        omniscriptResources = [SELECT id, name FROM StaticResource WHERE Name LIKE 'VDOOmniscriptResources' LIMIT 1];
        productResources = [SELECT id, name FROM StaticResource WHERE Name LIKE 'VDOProductResources' LIMIT 1];
        communityResources = [SELECT id, name FROM StaticResource WHERE Name LIKE 'VDOCommunityResources' LIMIT 1];
        mobileResources = [SELECT id, name FROM StaticResource WHERE Name LIKE 'VDOMobileResources' LIMIT 1];
        applogoDocument = [SELECT id FROM Document WHERE Name LIKE 'VDOAppLogo' LIMIT 1];
        consoleapplogoDocument = [SELECT id FROM Document WHERE Name LIKE 'VDOConsoleLogo' LIMIT 1];
        documentFolder = [SELECT id, name FROM Folder WHERE Name LIKE 'VDO Demo Documents' LIMIT 1];
        demoCSS = [SELECT id, name FROM ApexPage WHERE Name = 'VDODemoCSS'];
        omniscriptTemplates = [SELECT id, name FROM ApexComponent WHERE Name = 'VDOOmniscriptSelectableTemplates' LIMIT 1];
        mobileCSS = [SELECT id, name FROM ApexPage WHERE Name = 'VDOMobileLaunchPadHome'];
        mobileSite = [SELECT id, Subdomain FROM Site WHERE Subdomain != null LIMIT 1];
    }
    
    //Change the demo currency
    @RemoteAction 
    global static void ChangeCurrency(String currencytype){
        VDO_Settings__c vdv = VDO_Settings__c.getOrgDefaults();
        if(currencytype == 'Pounds'){
            vdv.Currency__c = 'pound';
            vdv.Currency_Symbol__c = '£';
        }
        else if(currencytype == 'Euros'){
            vdv.Currency__c = 'euro';
            vdv.Currency_Symbol__c = '€';
        }
        else if(currencytype == 'Dollars'){
            vdv.Currency__c = '';
            vdv.Currency_Symbol__c = '$';
        }
        update vdv;
    }
    
    //Update Mobile Launch Pad
    @RemoteAction 
    global static void UpdateMobile(String title, String username, String password, String type, Boolean show, String message){
        VDO_Settings__c vdv = VDO_Settings__c.getOrgDefaults();
        vdv.Mobile_App_Title__c = title;
        vdv.Mobile_App_Type__c = type;
        vdv.Username__c = username;
        vdv.Password__c = password;
        vdv.Mobile_App_Show_Message__c = show;
        vdv.Mobile_App_Message__c = message;
        update vdv;
    }

    //Mass rename records
    @RemoteAction 
    global static void RenameRecords(String oldName, String newName, String objectType){
        String query = 'SELECT id, name FROM ' + objectType;
        String listType = 'List<' + objectType + '>';
        List<SObject> sobjList = (List<SObject>)Type.forName(listType).newInstance();
        sobjList = Database.query(query);
        
        for(sObject sobj : sobjList){
            if((String.valueOf(sobj.get('Name')).contains(oldName))){
                sobj.put('Name', (String.valueOf(sobj.get('Name')).replace(oldName, newName)));
            }
        }
        update sobjList;
    }
    
    //Change region data for all accounts and contacts
    @RemoteAction 
    global static void ChangeOrgCountry(String country){  
        String accountData = 'VDOAccountData' + country;
        String contactData = 'VDOContactData' + country;
            
        StaticResource accountCSV = [Select  s.Body From StaticResource s where s.Name = :accountData];
        blob accounttempB = accountCSV.Body;
        String accountcontentFile = accounttempB.toString();
        String[] accountfilelines = accountcontentFile.split('\n');
        accountfilelines.remove(0);
        
        List<Account> allAccounts = [SELECT id, name, billingstreet, vlocity_data_order__c, shippingstreet, billingcity, shippingcity, billingpostalcode, shippingpostalcode, billingcountry, shippingcountry, phone FROM Account ORDER BY vlocity_data_order__c ASC];
        for (Integer i=0;(i<accountfilelines.size()) & (i<allAccounts.size());i++){
            String[] inputvalues = accountfilelines[i].split(',');
            allAccounts[i].Name = inputValues[0];
            allAccounts[i].billingstreet = inputValues[1];
            allAccounts[i].billingcity = inputValues[2];
            allAccounts[i].billingstate = inputValues[3];            
            allAccounts[i].billingpostalcode = inputValues[4];
            allAccounts[i].billingcountry = inputValues[5];
            allAccounts[i].shippingstreet = inputValues[1];
            allAccounts[i].shippingcity = inputValues[2];
            allAccounts[i].shippingstate = inputValues[3];            
            allAccounts[i].shippingpostalcode = inputValues[4];
            allAccounts[i].shippingcountry = inputValues[5];
            allAccounts[i].Phone = inputValues[6];
        }
        update allAccounts;
        
        StaticResource contactCSV = [Select  s.Body From StaticResource s where s.Name = :contactData];
        blob contacttempB = contactCSV.Body;
        String contactcontentFile = contacttempB.toString();
        String[] contactfilelines = contactcontentFile.split('\n');
        contactfilelines.remove(0);
        
        List<Contact> allContacts = [SELECT id, firstname, lastname, vlocity_data_order__c, title, salutation, mailingstreet, mailingcity, mailingpostalcode, mailingstate, mailingcountry, phone, mobilephone, homephone, email, otherstreet, othercity, otherpostalcode, otherstate, othercountry FROM Contact ORDER BY vlocity_data_order__c ASC];
        for (Integer i=0;(i<contactfilelines.size()) & (i<allContacts.size());i++){
            String[] inputvalues = contactfilelines[i].split(',');
            allContacts[i].Salutation = inputValues[0];
            allContacts[i].FirstName = inputValues[1];
            allContacts[i].LastName = inputValues[2];
            allContacts[i].mailingstreet = inputValues[3];
            allContacts[i].mailingcity = inputValues[4];
            allContacts[i].mailingstate = inputValues[5];
            allContacts[i].mailingpostalcode = inputValues[6];
            allContacts[i].mailingcountry = inputValues[7];
            allContacts[i].otherstreet = inputValues[3];
            allContacts[i].othercity = inputValues[4];
            allContacts[i].otherstate = inputValues[5];            
            allContacts[i].otherpostalcode = inputValues[6];
            allContacts[i].othercountry = inputValues[7];
            allContacts[i].Phone = inputValues[8];
            allContacts[i].MobilePhone = inputValues[9];
            allContacts[i].HomePhone = inputValues[10];
            allContacts[i].Email = inputValues[11];
        }
        update allContacts; 
    }
    
    //Reset demo account, household and contact details
    @RemoteAction 
    global static void ResetDemoData(){
        List<Task> demoActivites = [SELECT id, subject FROM Task WHERE subject = 'Email: Your Order Details'];
        delete demoActivites;
        List<Account> demoAccount = [SELECT id, shippingcity, name, vlocity_demo_name__c, Vlocity_Demo_Key__c FROM Account WHERE Vlocity_Demo_Key__c LIKE 'demoaccount%'];
        for(Account currentAccount : demoAccount){
            currentAccount.vlocity_demo_name__c = 'Jenny Smith';
            currentAccount.Vlocity_Demo_Image_ID__c = '';
            if(currentAccount.Vlocity_Demo_Key__c == 'demoaccount3'){
                currentAccount.name = 'Smith - ' + currentAccount.ShippingCity + ' Hotel';
            }else{
                currentAccount.name = 'Smith - ' + currentAccount.ShippingCity + ' Residence';
            }
        }
        update demoAccount;
        List<Contact> demoContact = [SELECT id, firstname, lastname FROM Contact WHERE Vlocity_Demo_Key__c = 'democontact1' LIMIT 1];
        if(demoContact.size() > 0){
            demoContact[0].firstname = 'Jenny';
            demoContact[0].lastname =  'Smith';
            demoContact[0].email = 'jsmith@gmail.com';
            update demoContact;
            List<vlocity_cmt__Household__c> demoHousehold = [SELECT id, vlocity_cmt__PrimaryContactId__c FROM vlocity_cmt__Household__c WHERE vlocity_cmt__PrimaryContactId__c = :demoContact LIMIT 1];
            if(demohousehold.size() > 0){
                demoHousehold[0].name = 'Smith Household';
                update demoHousehold;
            }
        }
        List<Contact> demoFamily = [SELECT id, firstname, lastname FROM Contact WHERE Vlocity_Demo_Key__c = 'demofamily'];
        for(Contact familyMember : demoFamily){
            familyMember.lastname =  'Smith';
        }
        update demoFamily;
        List<Attachment> photoAttachments = [SELECT id, Body FROM Attachment WHERE name = 'Customer Profile Picture' AND ParentId IN :demoAccount];
        delete photoAttachments;
    } 

    //Delete all new assets from demo accounts
    @RemoteAction 
    global static void DeleteNewAssets(){
        List<Account> allDemoAccounts = [SELECT id FROM Account WHERE Vlocity_Demo_Key__c LIKE 'demoAccount_'];
        List<Asset> allAssets = [SELECT id FROM Asset WHERE Vlocity_Demo_Asset__c = false AND AccountId IN :allDemoAccounts];
        delete allAssets;
    }    
    
    //Delete all orders in draft status
    @RemoteAction 
    global static void DeleteDraftOrders(){
        List<Order> allOrders = [SELECT id FROM order WHERE status = 'draft'];
        delete allOrders;    
    }
    
    //Delete all contracts in draft status
    @RemoteAction 
    global static void DeleteDraftContracts(){
        List<Contract> allContracts = [SELECT id FROM contract WHERE status = 'draft' AND name != 'Contract renewal'];
        delete allContracts;    
    }
    
    //Delete all paused scripts
    @RemoteAction 
    global static void DeletePausedScripts(){   
        delete [select id from vlocity_cmt__OmniScriptInstance__c];
        delete [select id from vlocity_cmt__VlocityTrackingEntry__c];
    }
    
    //Delete all orchestration plans
    @RemoteAction 
    global static void DeleteOrchestrationPlans(){   
        delete [select id from vlocity_cmt__OrchestrationDependency__c];
        delete [select id from vlocity_cmt__OrchestrationItem__c];
        delete [select id from vlocity_cmt__OrchestrationPlan__c];
        delete [select id from vlocity_cmt__FulfilmentRequestDecompRelationship__c];
        delete [select id from vlocity_cmt__FulfilmentRequest__c];
    }
    
    //TO DO - Delete all data created after a certain time.
    @RemoteAction 
    global static void DeleteRecords(DateTime cutOff, String objectType){
        String query = 'SELECT id, name FROM ' + objectType + ' WHERE CreatedDate > ' + cutOff;
        String listType = 'List<' + objectType + '>';
        List<SObject> sobjList = (List<SObject>)Type.forName(listType).newInstance();
        sobjList = Database.query(query);
        System.debug('*** ' + sobjList);
        //delete sobjList;
    }
    
    //Delete all existing billing statements and create new ones for all demo accounts.
    @RemoteAction
    global static void ResetStatements(String statementType){
        List<Account> demoAccounts = [SELECT id FROM Account WHERE vlocity_demo_key__c != ''];
        List<vlocity_cmt__Statement__c> oldStatements = [SELECT id FROM vlocity_cmt__Statement__c WHERE vlocity_cmt__AccountId__c IN :demoAccounts];
        List<vlocity_cmt__Statement__c> newStatements = new List<vlocity_cmt__Statement__c>();
        List<vlocity_cmt__StatementLineItem__c> newStatementLineItems = new List<vlocity_cmt__StatementLineItem__c>();
        date currentDate = Date.today();

        //Create new statements for all demo accounts
        for(Account demoAccount : demoAccounts){
            for(integer i = 0; i < numberOfStatements; i++){
                date statementDate = date.newInstance(currentDate.year(), currentDate.month() - i, 1);
                vlocity_cmt__Statement__c currentStatement = new vlocity_cmt__Statement__c();
                currentStatement.Name = 'Billing Cycle - ' + statementDate.format();
                currentStatement.vlocity_cmt__StatementDate__c = statementDate;
                currentStatement.vlocity_cmt__DueDate__c = statementDate;
                currentStatement.vlocity_cmt__ServicesBilled__c = 100;
                currentStatement.vlocity_cmt__PreviousBalance__c = 0;
                currentStatement.vlocity_cmt__CurrentBalance__c = 100;  
                currentStatement.vlocity_cmt__BalanceDue__c = 100; 
                currentStatement.vlocity_cmt__AccountId__c = demoAccount.id;  
                newStatements.add(currentStatement);
            }
        } 
        
        delete oldStatements;
        insert newStatements;
        
        //Create new statement line items for all new statements
        for(vlocity_cmt__Statement__c newStatement: newStatements){
            for(integer j = 0; j < numberOfStatementLineItems; j++){
                integer rand;
                integer amount = Math.round(Math.random()*1000);
                string type = 'Data';
                string subtype = 'Internet Services';
                string category = (Math.round(Math.random()*9) < 5) ? 'Usage' : 'Billed';
                if(category == 'Billed'){
                    amount = Math.round(Math.random()*150);
                }
                
                if(statementType == 'mobile'){
                    rand = Math.round(Math.ceil(Math.random()*9));
                    type = (rand <= 1) ? 'Tethering Data' : type;
                    type = (rand == 2) ? 'Offpeak Calls' : type;
                    type = (rand == 3) ? 'Roaming Charges' : type;
                    type = (rand == 4) ? 'International Calls' : type;
                    type = (rand == 5) ? 'Mobile Data' : type;
                    type = (rand == 6) ? 'Mobile Messaging' : type;
                    type = (rand == 7) ? 'Mobile Calls' : type;
                    type = (rand >= 8) ? 'App Purchases' : type;
                    subtype = 'Mobile';
                }
                else if(statementType == 'internet'){
                    rand = Math.round(Math.ceil(Math.random()*9));
                    type = (rand <= 1) ? 'Broadband Data' : type;
                    type = (rand == 2) ? 'Offpeak Calls' : type;
                    type = (rand == 3) ? 'Landline Calls' : type;
                    type = (rand == 4) ? 'Internet Services' : type;
                    type = (rand == 5) ? 'Server Bandwidth' : type;
                    type = (rand == 6) ? 'Email Accounts' : type;
                    type = (rand == 7) ? 'Managed Services' : type;
                    type = (rand >= 8) ? 'Cloud Storage' : type;
                    subtype = 'Internet';
                }
                else if(statementType == 'tv'){
                    rand = Math.round(Math.ceil(Math.random()*5));
                    type = (rand <= 1) ? 'Premium Channels' : type;
                    type = (rand == 2) ? 'Movie Purchases' : type;
                    type = (rand == 3) ? 'Pay Per View' : type;
                    type = (rand == 4) ? 'Sport Purchases' : type;
                    type = (rand >= 5) ? 'UHD Content' : type;
                    subtype = 'TV';
                }else{
                    rand = Math.round(Math.ceil(Math.random()*14));
                    type = (rand <= 1) ? 'Broadband Data' : type;
                    type = (rand == 2) ? 'Landline Calls' : type;
                    type = (rand == 3) ? 'Pay Per View' : type;
                    type = (rand == 4) ? 'Internet Services' : type;
                    type = (rand == 5) ? 'Mobile Data' : type;
                    type = (rand == 6) ? 'Mobile Messaging' : type;
                    type = (rand == 7) ? 'Mobile Calls' : type;
                    type = (rand == 8) ? 'Offpeak Calls' : type;
                    type = (rand == 9) ? 'Roaming Charges' : type;
                    type = (rand == 10) ? 'Premium Channels' : type;
                    type = (rand == 11) ? 'Movie Purchases' : type;
                    type = (rand == 12) ? 'International Calls' : type;
                    type = (rand == 13) ? 'Cloud Storage' : type;
                    type = (rand >= 14) ? 'Email Accounts' : type;
                    subtype = (rand <= 1) ? 'Internet' : subtype;
                    subtype = (rand == 2) ? 'Landline' : subtype;
                    subtype = (rand == 3) ? 'TV' : subtype;
                    subtype = (rand == 4) ? 'Internet' : subtype;
                    subtype = (rand == 5) ? 'Mobile' : subtype;
                    subtype = (rand == 6) ? 'Mobile' : subtype;
                    subtype = (rand == 7) ? 'Mobile' : subtype;
                    subtype = (rand == 8) ? 'Landline' : subtype;
                    subtype = (rand == 9) ? 'Mobile' : subtype;
                    subtype = (rand == 10) ? 'TV' : subtype;
                    subtype = (rand == 11) ? 'TV' : subtype;
                    subtype = (rand == 12) ? 'Landline' : subtype;
                    subtype = (rand == 13) ? 'Internet' : subtype;
                    subtype = (rand >= 14) ? 'Internet' : subtype;
                }

                date statementDate = newStatement.vlocity_cmt__StatementDate__c;
                vlocity_cmt__StatementLineItem__c currentStatementLineItem = new vlocity_cmt__StatementLineItem__c();
                currentStatementLineItem.vlocity_cmt__StatementId__c = newStatement.id;
                currentStatementLineItem.vlocity_cmt__StatementDate__c = statementDate;
                currentStatementLineItem.vlocity_cmt__StatementGroup__c = '' + statementDate.month();
                currentStatementLineItem.vlocity_cmt__ServiceStartDate__c = statementDate;
                currentStatementLineItem.vlocity_cmt__ServiceEndDate__c = date.newInstance(statementDate.year(), statementDate.month(), date.daysInMonth(statementDate.year(), statementDate.month()));
                currentStatementLineItem.vlocity_cmt__Category__c = category;  
                currentStatementLineItem.vlocity_cmt__Type__c = type; 
                currentStatementLineItem.vlocity_cmt__Subtype__c = subtype;  
                currentStatementLineItem.vlocity_cmt__ServiceName__c = type;
                currentStatementLineItem.vlocity_cmt__Usage__c = amount;
                currentStatementLineItem.vlocity_cmt__Amount__c = amount;
                currentStatementLineItem.vlocity_cmt__UOM__c = '' + amount;
                currentStatementLineItem.vlocity_cmt__CurrencyAmount__c = amount;
                currentStatementLineItem.vlocity_cmt__Recurring__c = 'N';
                currentStatementLineItem.vlocity_cmt__OneTime__c = 'Y';
                newStatementLineItems.add(currentStatementLineItem);
            }
        } 
        
        insert newStatementLineItems;
    }
    
    //Create XMD string for manual upload into Wave
    @RemoteAction 
    global static string DisplayWaveXMD(String colour1, String colour2, String colour3, String colour4, String colour5, String colour6, String colour7, String colour8, String colour9, String colour10, String colour11, String colour12, String colour13, String colour14, String colour15, String colour16, String colour17, String colour18, String colour19, String colour20, String colour21, String colour22, String colour23, String colour24, String colour25, String colour26, String colour27, String colour28, String colour29, String colour30){
        String xmdBody = '{"colors":{"vlocity_cmt__Type__c":{"Broadband Data":"colour14","Landline Calls":"colour15","Pay Per View":"colour16","Internet Services":"colour17","Mobile Data":"colour18","Mobile Messaging":"colour19","Mobile Calls":"colour20","Offpeak Calls":"colour21","Roaming Charges":"colour22","Premium Channels":"colour23","Movie Purchases":"colour24","International Calls":"colour25","Cloud Storage":"colour26","Email Accounts":"colour27","UHD Content":"colour28","Sport Purchases":"colour29","Managed Services":"colour30","Server Bandwidth":"colour29","App Purchases":"colour30","Tethering Data":"colour13"},"Product":{"LG G5":"colour14","iPhone 7":"colour15","iPhone 7 Plus":"colour16","Nexu 6P":"colour17","Samsung S7 Edge ":"colour18","Entertainment TV Package":"colour19","Sports TV Package":"colour20","Movies TV Package":"colour21","UHD TV Channels":"colour22","Broadband Internet Large":"colour23","Fibre Internet Small":"colour24","Fibre Internet Medium":"colour25","Fibre Internet Large":"colour26"}}}';        
        xmdBody = xmdBody.replace('colour30', colour30);
        xmdBody = xmdBody.replace('colour29', colour29);
        xmdBody = xmdBody.replace('colour28', colour28);
        xmdBody = xmdBody.replace('colour27', colour27);
        xmdBody = xmdBody.replace('colour26', colour26);
        xmdBody = xmdBody.replace('colour25', colour25);
        xmdBody = xmdBody.replace('colour24', colour24);
        xmdBody = xmdBody.replace('colour23', colour23);
        xmdBody = xmdBody.replace('colour22', colour22);
        xmdBody = xmdBody.replace('colour21', colour21);
        xmdBody = xmdBody.replace('colour20', colour20);
        xmdBody = xmdBody.replace('colour19', colour19);
        xmdBody = xmdBody.replace('colour18', colour18);
        xmdBody = xmdBody.replace('colour17', colour17);
        xmdBody = xmdBody.replace('colour16', colour16);
        xmdBody = xmdBody.replace('colour15', colour15);
        xmdBody = xmdBody.replace('colour14', colour14);
        xmdBody = xmdBody.replace('colour13', colour13);
        xmdBody = xmdBody.replace('colour12', colour12);
        xmdBody = xmdBody.replace('colour11', colour11);
        xmdBody = xmdBody.replace('colour10', colour10);
        xmdBody = xmdBody.replace('colour9', colour9);
        xmdBody = xmdBody.replace('colour8', colour8);
        xmdBody = xmdBody.replace('colour7', colour7);
        xmdBody = xmdBody.replace('colour6', colour6);
        xmdBody = xmdBody.replace('colour5', colour5);
        xmdBody = xmdBody.replace('colour4', colour4);
        xmdBody = xmdBody.replace('colour3', colour3);
        xmdBody = xmdBody.replace('colour2', colour2);
        xmdBody = xmdBody.replace('colour1', colour1);  
        return xmdBody;  
    }

    //Update the colours used throughout the org
    @RemoteAction 
    global static void UpdateColours(String colour1, String colour2, String colour3, String colour4, String colour5, String colour6, String colour7, String colour8, String colour9){
        //Current colours
        VDO_Settings__c vdv = VDO_Settings__c.getOrgDefaults();

        //Update the console application colours
        MetadataService.MetadataPort service = createService();
        MetadataService.CustomApplication customApp = (MetadataService.CustomApplication) service.readMetadata('CustomApplication', new String[] { 'Vlocity_Console' }).getRecords()[0];
        customApp.primaryTabColor = colour4;
        customApp.headerColor = colour2;
        customApp.footerColor = colour4;
        List<MetadataService.SaveResult> results = service.updateMetadata(new MetadataService.Metadata[] { customApp });
        
        //Update the relationship colours
        List<vlocity_cmt__PartyRelationshipType__c> prt = [SELECT name, vlocity_cmt__Color__c FROM vlocity_cmt__PartyRelationshipType__c];
        for(vlocity_cmt__PartyRelationshipType__c currentprt : prt){
            if(currentprt.name == 'Owner' || currentprt.name == 'Property' || currentprt.name == 'Service Location'){
                currentprt.vlocity_cmt__Color__c = colour1;
            }
            else if(currentprt.name == 'Employee' || currentprt.name == 'Company'){
                currentprt.vlocity_cmt__Color__c = colour2;
            }
            else if(currentprt.name == 'Billing Parent' || currentprt.name == 'Manager'){
                currentprt.vlocity_cmt__Color__c = colour3;
            }
            else if(currentprt.name == 'Member' || currentprt.name == 'Household'){
                currentprt.vlocity_cmt__Color__c = colour8;
            }
            else if(currentprt.name == 'Child' || currentprt.name == 'Parent'){
                currentprt.vlocity_cmt__Color__c = colour9;
            }
            else if(currentprt.name == 'Renter' || currentprt.name == 'Spouse'){
                currentprt.vlocity_cmt__Color__c = colour8;
            }
            else{
                currentprt.vlocity_cmt__Color__c = colour1;
            }
        }
        update prt;
        
        //Update the ui templates colours
        List<vlocity_cmt__VlocityUITemplate__c> vuit = [SELECT name, vlocity_cmt__html__c, vlocity_cmt__Active__c FROM vlocity_cmt__VlocityUITemplate__c WHERE name = 'demo-flyout-grid-usage'];
        for(vlocity_cmt__VlocityUITemplate__c currentvuit : vuit){
            currentvuit.vlocity_cmt__Active__c = false;
            if(currentvuit.vlocity_cmt__html__c != null){
                currentvuit.vlocity_cmt__html__c = currentvuit.vlocity_cmt__html__c.replace(vdv.colour4__c, colour4);
                currentvuit.vlocity_cmt__html__c = currentvuit.vlocity_cmt__html__c.replace(vdv.colour5__c, colour5);
            }
        }
        update vuit;
        for(vlocity_cmt__VlocityUITemplate__c currentvuit : vuit){
            currentvuit.vlocity_cmt__Active__c = true;
        }
        update vuit;
        
        //Update the custom setting colours
        vdv.Colour1__c = colour1;
        vdv.Colour2__c = colour2;
        vdv.Colour3__c = colour3;
        vdv.Colour4__c = colour4;
        vdv.Colour5__c = colour5;
        vdv.Colour6__c = colour6;
        vdv.Colour7__c = colour7;
        vdv.Colour8__c = colour8;
        vdv.Colour9__c = colour9;
        update vdv; 
      
    }

    //Tool to call the metadata API
    public static MetadataService.MetadataPort createService(){
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }

}