global class VDOEmailController{

    public Order theOrder {get;set;}
    public Order theDisplayOrder = new Order();
    public Account theDemoAccount = new Account();
    public Site theSite = new Site();
    public List<VlocityProductWrapper> theProducts = new List<VlocityProductWrapper>();
    
    //Return a set of order items and the corresponding product image
    public List<VlocityProductWrapper> getTheProducts(){
        theSite = [SELECT Name, Status, Subdomain FROM Site WHERE Name = 'Vlocity_Site' LIMIT 1];
        theProducts = new List<VlocityProductWrapper>();
        List<OrderItem> theOrderItems = [SELECT id, vlocity_cmt__OneTimeTotal__c, vlocity_cmt__LineNumber__c, createddate, vlocity_cmt__RecurringTotal__c, PricebookEntry.Product2.Id, PricebookEntry.Product2.Name, PricebookEntry.Product2.Description FROM OrderItem WHERE OrderId = :theOrder.id ORDER BY vlocity_cmt__LineNumber__c ASC];
        Set<Id> theProductSet = new Set<Id>();
        for(OrderItem theOrderItem : theOrderItems){
            theProductSet.add(theOrderItem.PricebookEntry.Product2.Id);
        }
        List<Attachment> theAttachments = [SELECT id, parentid FROM Attachment WHERE Name LIKE 'TN%' AND ParentId IN :theProductSet];
        Map<Id, Attachment> theAttachmentsMap = new Map<Id, Attachment>();
        for(Attachment theAttachment : theAttachments){
            theAttachmentsMap.put(theAttachment.ParentId, theAttachment);
        }
        for(OrderItem theOrderItem: theOrderItems){
            VlocityProductWrapper theWrapper = new VlocityProductWrapper();
            if(theAttachmentsMap.get(theOrderItem.PricebookEntry.Product2.Id) != null){
                theWrapper.theImageURL = 'http://' + theSite.subdomain + '.force.com/servlet/servlet.FileDownload?file=' + theAttachmentsMap.get(theOrderItem.PricebookEntry.Product2.Id).Id;
            }else{
                theWrapper.theImageURL = '#';
            }
            theWrapper.theOrderItem = theOrderItem;
            theProducts.add(theWrapper);
        }
        return theProducts;
    }
    
    public Site getTheSite(){
        theSite = [SELECT Name, Status, Subdomain FROM Site WHERE Name = 'Vlocity_Site' LIMIT 1];
        return theSite;
    }

    public Account getTheDemoAccount(){
        theDemoAccount = [SELECT Vlocity_Demo_Image__c, Vlocity_Demo_Name__c FROM Account WHERE Vlocity_Demo_Key__c = 'demoaccount1' LIMIT 1];
        return theDemoAccount;
    }
    
    public Order getTheDisplayOrder(){
        theDisplayOrder = [SELECT OrderNumber, ActivatedDate, vlocity_cmt__OneTimeTotal__c, vlocity_cmt__RecurringTotal__c FROM Order WHERE id = :theOrder.id];
        return theDisplayOrder;
    }
    
    //A wrapper class used to associate an order item with a product image
    public class VlocityProductWrapper{
        public String theImageURL {get;set;}
        public OrderItem  theOrderItem {get;set;}
    }
}