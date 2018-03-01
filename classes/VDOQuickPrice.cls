/***
* @group Implementations
*
* @description strongly typed interface: PricingInterface <br>
* <1>Intro and Purpose: Prices the line items in the object (Opty, Quote, Order) <br>
* <2>Triggering the Interface: Called as part of every CRUD operation on line items<br>
*
* This implements PriceLineItems method interface
*
**/
global with sharing class VDOQuickPrice implements vlocity_cmt.GlobalInterfaces.PricingInterface {
    
/**
* @param parent (SObject) : parent ie Order, Quote or Oppty
* @param itemList (List&SObject&gt) :  list of line items
* @return void
* @description Perform line item pricing based on flow
*/

    global void priceLineItems(SObject parent, List<SObject> itemList) {
        System.debug('Inside PricingInterface VDOQuickPrice');
        if (itemList == null || itemList.isEmpty()) {
            // nothing to price
            return;
        }

        // this is the custom class that implements the OpenInterface API
        VDOQuickPriceClass vqpc = new VDOQuickPriceClass();

        Map<String, Object> myMap = new Map<String, Object>(); 
        Map<String,Object> outMap = new Map<String, Object>();
        myMap.put('ContextId',parent.Id);   // pass in the ContextId which is the parent oppty, quote, or order Id


        if(parent instanceof Opportunity){
            list<Opportunity> lOpp = new list<Opportunity>();
            loPP = [SELECT Id, VDOPriceChildItems__c FROM Opportunity WHERE Id = :parent.Id];
            myMap.put('PriceChildItems', loPP[0].VDOPriceChildItems__c);
            vqpc.invokeMethod('calcOpptyPrice',myMap,outMap,null);
        }

        if(parent instanceof Order){
            list<Order> lOrder = new list<Order>();
            lOrder = [SELECT Id, VDOPriceChildItems__c FROM Order WHERE Id = :parent.Id];
            myMap.put('PriceChildItems', lOrder[0].VDOPriceChildItems__c);            
            vqpc.invokeMethod('calcOrderPrice',myMap,outMap,null);
        }

        if(parent instanceof Quote){
            list<Quote> lQte = new list<Quote>();
            lQte = [SELECT Id, VDOPriceChildItems__c FROM Quote WHERE Id = :parent.Id];
            myMap.put('PriceChildItems', lQte[0].VDOPriceChildItems__c);            
            vqpc.invokeMethod('calcQuotePrice',myMap,outMap,null);
        }
        
   }
}