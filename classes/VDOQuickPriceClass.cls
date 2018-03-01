global with sharing class VDOQuickPriceClass implements vlocity_cmt.VlocityOpenInterface {

    // ------------------------------------------------------------------------------------------
    // Open Interface API Invocation
    //
    // ------------------------------------------------------------------------------------------
    global boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) 
    {
        system.debug('>>>>> VlocityQPC in invoke method ' + methodName);
        Boolean result = true; 

        try {
            // the custom methods can have any customized signature, but 
            // PLEASE MAKE USRE YOU ALWAYS PASS IN options 
            if (methodName.equals('calcQuotePrice')) {
                calcQuotePrice(inputMap, outMap, options);
            }            
            else 
            if (methodName.equals('calcOpptyPrice')) {
                calcOpptyPrice(inputMap, outMap, options);
           }
            else 
            if (methodName.equals('calcOrderPrice')) {
                calcOrderPrice(inputMap, outMap, options);
            }
            // other methods to handle normal Remote Call
            else 
            {
                result = false;
            }   
        } 
        catch(System.Exception e) {
            system.debug('>>>>> VlocityQPC exception raised ' + e);
            result = false;
        }

        return result;
    } // invokeMethod



    public void calcQuotePrice(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options){
        
        List<QuoteLineItem> lQteLines = new List<QuoteLineItem>();
        List<QuoteLineItem> updLineList = new List<QuoteLineItem>();
        Map<Id, Double> lineQuantity = new Map<Id, Double>();
        Map<Id, Id> parentMap = new Map<Id, Id>();
        Map<Id, Double> lineEffectiveMult = new Map<Id, Double>();
        Map<Id, Boolean> childMap = new Map<Id, Boolean>();

        String calcId = (String)inputMap.get('ContextId');
        Boolean priceChildItems = (Boolean)inputMap.get('PriceChildItems');

        if (calcId == ''){
            return;
        }

        // return all of the quote lines and fields
        lQteLines = [SELECT Description,Id,ListPrice,Product2Id,ProductName__c,Quantity,QuoteId,
                            vlocity_cmt__EffectiveOneTimeTotal__c,vlocity_cmt__EffectiveQuantity__c,vlocity_cmt__EffectiveRecurringTotal__c,
                            vlocity_cmt__LineNumber__c,vlocity_cmt__OneTimeCalculatedPrice__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeDiscountPrice__c,
                            vlocity_cmt__OneTimeManualDiscount__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__OverageCalculatedPrice__c,vlocity_cmt__OverageCharge__c,
                            vlocity_cmt__OverageDiscountPrice__c,vlocity_cmt__OverageManualDiscount__c,vlocity_cmt__OverageTotal__c,vlocity_cmt__ParentItemId__c,
                            vlocity_cmt__RecurringCalculatedPrice__c,vlocity_cmt__RecurringCharge__c,vlocity_cmt__RecurringDiscountPrice__c,vlocity_cmt__RecurringManualDiscount__c,
                            vlocity_cmt__RecurringTotal__c,vlocity_cmt__RecurringUOM__c,vlocity_cmt__Recurring_UOM__c,vlocity_cmt__RootItemId__c, PricebookEntry.vlocity_cmt__RecurringPrice__c, 
                            PricebookEntry.UnitPrice, PricebookEntry.vlocity_cmt__OverageCharge__c
                            FROM QuoteLineItem WHERE QuoteId = :calcId];
            system.debug(lQteLines);

        if (lQteLines.size() > 0){
            // setup quantity Map
            for (QuoteLineItem lql:lQteLines){
                lineQuantity.put(lql.Id, lql.Quantity);

                // if this item has a parent, record it in the Map
                if (lql.vlocity_cmt__ParentItemId__c != null && 
                    (lql.vlocity_cmt__ParentItemId__c != lql.Id)){
                    parentMap.put(lql.Id, lql.vlocity_cmt__ParentItemId__c);
                    childMap.put(lql.Id, true);
                }
                else
                    childMap.put(lql.Id, false);
            }

            system.debug('>>>>> parentMap '+parentMap);

            Integer depth;

            // determine levels of heirarchy - find greatest depth
            for (QuoteLineItem lql:lQteLines){
                depth = lql.vlocity_cmt__LineNumber__c.countMatches('.');

                // if this is a child, or child of child item figure out the multiplier
                if (depth > 0){
                    Double Multiplier = lql.Quantity;
                    Id ParentId = lql.vlocity_cmt__ParentItemId__c;

                    while(depth > 0){
                        Multiplier = Multiplier * lineQuantity.get(parentId);
                        depth -= 1;

                        // cycle through and calculate the multiplier for the effective totals
                        If (depth > 0){
                            if (parentMap.get(ParentId) != null)
                                parentId = parentMap.get(ParentId);
                            } // if we still have parents of parents

                        } // while

                    lineEffectiveMult.put(lql.Id, Multiplier);
                    } // if this line has parents
                else{
                    // no parent, so set multiplier to Quantity
                    lineEffectiveMult.put(lql.Id, lql.Quantity);
                    }

                } // find deepest level - FOR loop

            system.debug('>>>>> LineEffectiveMult = '+lineEffectiveMult);
            // process all the child line items and set the values
            for (QuoteLineItem qli:lQteLines){

                // UPDATE the Opportunity line
                QuoteLineItem updLine = new QuoteLineItem();
                updLine.Id = qli.Id;
                updLine.vlocity_cmt__EffectiveQuantity__c = lineEffectiveMult.get(qli.Id);

                Double discRecurringPrice;
                // if there is a recurring charge AND it's a child item and pricing children items or parent item
                if (qli.vlocity_cmt__RecurringCharge__c != null && 
                    ( (priceChildItems && childMap.get(qli.Id)) || !childMap.get(qli.Id)) )
                    //discRecurringPrice = qli.vlocity_cmt__RecurringCharge__c;
                    discRecurringPrice = (Double) qli.getSObject('PricebookEntry').get('vlocity_cmt__RecurringPrice__c');
                else
                    discRecurringPrice = 0.0;

                // set recurring prices
                if (qli.vlocity_cmt__RecurringManualDiscount__c != null && qli.vlocity_cmt__RecurringManualDiscount__c > 0.00){
                    discRecurringPrice -= qli.vlocity_cmt__RecurringManualDiscount__c * qli.vlocity_cmt__RecurringCharge__c * .01;
                }

                updLine.vlocity_cmt__RecurringCalculatedPrice__c = discRecurringPrice* qli.Quantity;
                updLine.vlocity_cmt__RecurringDiscountPrice__c = discRecurringPrice* qli.Quantity;
                updLine.vlocity_cmt__RecurringTotal__c = discRecurringPrice* qli.Quantity;
                updLine.vlocity_cmt__EffectiveRecurringTotal__c = discRecurringPrice * lineEffectiveMult.get(qli.Id);

                // set one time prices
                Double discOneTimePrice;
                if (qli.ListPrice != null && 
                    ( (priceChildItems && childMap.get(qli.Id)) || !childMap.get(qli.Id)) )
                    discOneTimePrice = qli.ListPrice;
                else discOneTimePrice = 0.0;

                if (qli.vlocity_cmt__OneTimeManualDiscount__c != null && qli.vlocity_cmt__OneTimeManualDiscount__c > 0.00){
                    discOneTimePrice -= qli.vlocity_cmt__OneTimeManualDiscount__c *     qli.ListPrice * .01;
                }
                
                updLine.vlocity_cmt__EffectiveOneTimeTotal__c  = discOneTimePrice * lineEffectiveMult.get(qli.Id);
                updLine.vlocity_cmt__OneTimeCalculatedPrice__c = discOneTimePrice* qli.Quantity;
                updLine.vlocity_cmt__OneTimeCharge__c = qli.ListPrice;
                updLine.vlocity_cmt__OneTimeDiscountPrice__c = discOneTimePrice* qli.Quantity;
                updLine.vlocity_cmt__OneTimeTotal__c = discOneTimePrice* qli.Quantity;


                // set overage prices
                Double discOveragePrice;
                if (qli.vlocity_cmt__OverageCharge__c != null && 
                    ( (priceChildItems && childMap.get(qli.Id)) || !childMap.get(qli.Id)) )                    
                    discOveragePrice = qli.vlocity_cmt__OverageCharge__c;
                else
                    discOveragePrice = 0.0;

                if (qli.vlocity_cmt__OverageManualDiscount__c != null && qli.vlocity_cmt__OverageManualDiscount__c > 0.00){
                    discOveragePrice -= qli.vlocity_cmt__OverageDiscountPrice__c * qli.vlocity_cmt__OverageCharge__c * .01;
                }

                updLine.vlocity_cmt__OverageCalculatedPrice__c = discOveragePrice* qli.Quantity;
                updLine.vlocity_cmt__OverageDiscountPrice__c  = discOveragePrice* qli.Quantity;
                updLine.vlocity_cmt__OverageTotal__c  = discOveragePrice* qli.Quantity;             

                system.debug(updLine);
                updLineList.add(updLine);
                } // for all line items

            system.debug('>>>>> UpdLineList '+updLineList);
            update updLineList;
            } // there are line items

        return;
    } // calcQuotePrices




    public void calcOpptyPrice(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options){
        List<OpportunityLineItem> lOpptyLines = new List<OpportunityLineItem>();
        List<OpportunityLineItem> updLineList = new List<OpportunityLineItem>();
        Map<Id, Double> lineQuantity = new Map<Id, Double>();
        Map<Id, Id> parentMap = new Map<Id, Id>();
        Map<Id, Double> lineEffectiveMult = new Map<Id, Double>();
        Map<Id, Boolean> childMap = new Map<Id, Boolean>();

        String calcId = (String)inputMap.get('ContextId');
        Boolean priceChildItems = (Boolean)inputMap.get('PriceChildItems');

        if (calcId == ''){
            return;
        }

        // return all of the Opportunity lines and fields
        lOpptyLines = [SELECT Description,Id,ListPrice,Product2Id,ProductName__c,Quantity,OpportunityId,
                            vlocity_cmt__EffectiveOneTimeTotal__c,vlocity_cmt__EffectiveQuantity__c,vlocity_cmt__EffectiveRecurringTotal__c,
                            vlocity_cmt__LineNumber__c,vlocity_cmt__OneTimeCalculatedPrice__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeDiscountPrice__c,
                            vlocity_cmt__OneTimeManualDiscount__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__OverageCalculatedPrice__c,vlocity_cmt__OverageCharge__c,
                            vlocity_cmt__OverageDiscountPrice__c,vlocity_cmt__OverageManualDiscount__c,vlocity_cmt__OverageTotal__c,vlocity_cmt__ParentItemId__c,
                            vlocity_cmt__RecurringCalculatedPrice__c,vlocity_cmt__RecurringCharge__c,vlocity_cmt__RecurringDiscountPrice__c,vlocity_cmt__RecurringManualDiscount__c,
                            vlocity_cmt__RecurringTotal__c,vlocity_cmt__RecurringUOM__c,vlocity_cmt__RootItemId__c, PricebookEntry.vlocity_cmt__RecurringPrice__c, 
                            PricebookEntry.UnitPrice, PricebookEntry.vlocity_cmt__OverageCharge__c
                            FROM OpportunityLineItem WHERE OpportunityId = :calcId];
            system.debug(lOpptyLines);

        if (lOpptyLines.size() > 0){
            // setup quantity Map
            for (OpportunityLineItem lql:lOpptyLines){
                lineQuantity.put(lql.Id, lql.Quantity);

                // if this item has a parent, record it in the Map
                if (lql.vlocity_cmt__ParentItemId__c != null && 
                    (lql.vlocity_cmt__ParentItemId__c != lql.Id)){
                    parentMap.put(lql.Id, lql.vlocity_cmt__ParentItemId__c);
                    childMap.put(lql.Id, true);
                }
                else
                    childMap.put(lql.Id, false);

                // if this item has a parent, record it in the Map
/*                if (lql.vlocity_cmt__ParentItemId__c != null)
                    parentMap.put(lql.Id, lql.vlocity_cmt__ParentItemId__c);  */
            }

            system.debug('>>>>> parentMap '+parentMap);

            Integer depth;

            // determine levels of heirarchy - find greatest depth
            for (OpportunityLineItem lql:lOpptyLines){
                depth = lql.vlocity_cmt__LineNumber__c.countMatches('.');

                // if this is a child, or child of child item figure out the multiplier
                if (depth > 0){
                    Double Multiplier = lql.Quantity;
                    Id ParentId = lql.vlocity_cmt__ParentItemId__c;

                    while(depth > 0){
                        Multiplier = Multiplier * lineQuantity.get(parentId);
                        depth -= 1;

                        // cycle through and calculate the multiplier for the effective totals
                        If (depth > 0){
                            if (parentMap.get(ParentId) != null)
                                parentId = parentMap.get(ParentId);
                            } // if we still have parents of parents

                        } // while

                    lineEffectiveMult.put(lql.Id, Multiplier);
                    } // if this line has parents
                else{
                    // no parent, so set multiplier to Quantity
                    lineEffectiveMult.put(lql.Id, lql.Quantity);
                    }

                } // find deepest level - FOR loop

            system.debug('>>>>> LineEffectiveMult = '+lineEffectiveMult);
            // process all the child line items and set the values
            for (OpportunityLineItem qli:lOpptyLines){

                // UPDATE the Opportunity line
                OpportunityLineItem updLine = new OpportunityLineItem();
                updLine.Id = qli.Id;
                updLine.vlocity_cmt__EffectiveQuantity__c = lineEffectiveMult.get(qli.Id);

                Double discRecurringPrice;

                // if there is a recurring charge AND it's a child item and pricing children items or parent item
                if (qli.vlocity_cmt__RecurringCharge__c != null && 
                    ( (priceChildItems && childMap.get(qli.Id)) || !childMap.get(qli.Id)) )
                    //discRecurringPrice = qli.vlocity_cmt__RecurringCharge__c;
                    discRecurringPrice = (Double) qli.getSObject('PricebookEntry').get('vlocity_cmt__RecurringPrice__c');
                else
                    discRecurringPrice = 0.0;

/*
                Double discRecurringPrice;
                if (qli.vlocity_cmt__RecurringCharge__c != null)
                    discRecurringPrice = qli.vlocity_cmt__RecurringCharge__c;
                else
                    discRecurringPrice = 0.0;   */

                // set recurring prices
                if (qli.vlocity_cmt__RecurringManualDiscount__c != null && qli.vlocity_cmt__RecurringManualDiscount__c > 0.00){
                    discRecurringPrice -= qli.vlocity_cmt__RecurringManualDiscount__c * qli.vlocity_cmt__RecurringCharge__c * .01;
                }

                updLine.vlocity_cmt__RecurringCalculatedPrice__c = discRecurringPrice* qli.Quantity;
                updLine.vlocity_cmt__RecurringDiscountPrice__c = discRecurringPrice* qli.Quantity;
                updLine.vlocity_cmt__RecurringTotal__c = discRecurringPrice* qli.Quantity;
                updLine.vlocity_cmt__EffectiveRecurringTotal__c = discRecurringPrice * lineEffectiveMult.get(qli.Id);

                // set one time prices
                Double discOneTimePrice;
 /*               if (qli.ListPrice != null)
                    discOneTimePrice = qli.ListPrice;
                else discOneTimePrice = 0.0;   */

                if (qli.ListPrice != null && 
                    ( (priceChildItems && childMap.get(qli.Id)) || !childMap.get(qli.Id)) )
                    discOneTimePrice = qli.ListPrice;
                else discOneTimePrice = 0.0;

                if (qli.vlocity_cmt__OneTimeManualDiscount__c != null && qli.vlocity_cmt__OneTimeManualDiscount__c > 0.00){
                    discOneTimePrice -= qli.vlocity_cmt__OneTimeManualDiscount__c *     qli.ListPrice * .01;
                }
                
                updLine.vlocity_cmt__EffectiveOneTimeTotal__c  = discOneTimePrice * lineEffectiveMult.get(qli.Id);
                updLine.vlocity_cmt__OneTimeCalculatedPrice__c = discOneTimePrice* qli.Quantity;
                updLine.vlocity_cmt__OneTimeCharge__c = qli.ListPrice;
                updLine.vlocity_cmt__OneTimeDiscountPrice__c = discOneTimePrice* qli.Quantity;
                updLine.vlocity_cmt__OneTimeTotal__c = discOneTimePrice* qli.Quantity;


                // set overage prices
                Double discOveragePrice;
/*                if (qli.vlocity_cmt__OverageCharge__c != null)
                    discOveragePrice = qli.vlocity_cmt__OverageCharge__c;
                else
                    discOveragePrice = 0.0;   */

                if (qli.vlocity_cmt__OverageCharge__c != null && 
                    ( (priceChildItems && childMap.get(qli.Id)) || !childMap.get(qli.Id)) )                    
                    discOveragePrice = qli.vlocity_cmt__OverageCharge__c;
                else
                    discOveragePrice = 0.0;

                if (qli.vlocity_cmt__OverageManualDiscount__c != null && qli.vlocity_cmt__OverageManualDiscount__c > 0.00){
                    discOveragePrice -= qli.vlocity_cmt__OverageDiscountPrice__c * qli.vlocity_cmt__OverageCharge__c * .01;
                }

                updLine.vlocity_cmt__OverageCalculatedPrice__c = discOveragePrice* qli.Quantity;
                updLine.vlocity_cmt__OverageDiscountPrice__c  = discOveragePrice* qli.Quantity;
                updLine.vlocity_cmt__OverageTotal__c  = discOveragePrice* qli.Quantity;             

                system.debug(updLine);
                updLineList.add(updLine);
                } // for all line items

            system.debug('>>>>> UpdLineList '+updLineList);
            update updLineList;
            } // there are line items

        return;
    } // calcOpportunityPrices





    public void calcOrderPrice(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options){
        List<OrderItem> lOrderLines = new List<OrderItem>();
        List<OrderItem> updLineList = new List<OrderItem>();
        Map<Id, Double> lineQuantity = new Map<Id, Double>();
        Map<Id, Id> parentMap = new Map<Id, Id>();
        Map<Id, Double> lineEffectiveMult = new Map<Id, Double>();
        Map<Id, Boolean> childMap = new Map<Id, Boolean>();        

        String calcId = (String)inputMap.get('ContextId');
        Boolean priceChildItems = (Boolean)inputMap.get('PriceChildItems');
       
        if (calcId == ''){
            return;
        }

        // return all of the Opportunity lines and fields
        lOrderLines = [SELECT Description,Id,ListPrice,ProductName__c,Quantity, OrderId,
                            vlocity_cmt__EffectiveOneTimeTotal__c,vlocity_cmt__EffectiveQuantity__c,vlocity_cmt__EffectiveRecurringTotal__c,
                            vlocity_cmt__LineNumber__c,vlocity_cmt__OneTimeCalculatedPrice__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeDiscountPrice__c,
                            vlocity_cmt__OneTimeManualDiscount__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__OverageCalculatedPrice__c,vlocity_cmt__OverageCharge__c,
                            vlocity_cmt__OverageDiscountPrice__c,vlocity_cmt__OverageManualDiscount__c,vlocity_cmt__OverageTotal__c,vlocity_cmt__ParentItemId__c,
                            vlocity_cmt__RecurringCalculatedPrice__c,vlocity_cmt__RecurringCharge__c,vlocity_cmt__RecurringDiscountPrice__c,vlocity_cmt__RecurringManualDiscount__c,
                            vlocity_cmt__RecurringTotal__c,vlocity_cmt__RecurringUOM__c,vlocity_cmt__RootItemId__c, PricebookEntry.vlocity_cmt__RecurringPrice__c, 
                            PricebookEntry.UnitPrice, PricebookEntry.vlocity_cmt__OverageCharge__c
                            FROM OrderItem WHERE OrderId = :calcId];
            system.debug(lOrderLines);

        if (lOrderLines.size() > 0){
            // setup quantity Map
            for (OrderItem lql:lOrderLines){
                lineQuantity.put(lql.Id, lql.Quantity);

                // if this item has a parent, record it in the Map
                if (lql.vlocity_cmt__ParentItemId__c != null && 
                    (lql.vlocity_cmt__ParentItemId__c != lql.Id)){
                    parentMap.put(lql.Id, lql.vlocity_cmt__ParentItemId__c);
                    childMap.put(lql.Id, true);
                }
                else
                    childMap.put(lql.Id, false);

                // if this item has a parent, record it in the Map
            /*  if (lql.vlocity_cmt__ParentItemId__c != null)
                    parentMap.put(lql.Id, lql.vlocity_cmt__ParentItemId__c);  */
            }

            system.debug('>>>>> parentMap '+parentMap);

            Integer depth;

            // determine levels of heirarchy - find greatest depth
            for (OrderItem lql:lOrderLines){
                depth = lql.vlocity_cmt__LineNumber__c.countMatches('.');

                // if this is a child, or child of child item figure out the multiplier
                if (depth > 0){
                    Double Multiplier = lql.Quantity;
                    Id ParentId = lql.vlocity_cmt__ParentItemId__c;

                    while(depth > 0){
                        Multiplier = Multiplier * lineQuantity.get(parentId);
                        depth -= 1;

                        // cycle through and calculate the multiplier for the effective totals
                        If (depth > 0){
                            if (parentMap.get(ParentId) != null)
                                parentId = parentMap.get(ParentId);
                            } // if we still have parents of parents

                        } // while

                    lineEffectiveMult.put(lql.Id, Multiplier);
                    } // if this line has parents
                else{
                    // no parent, so set multiplier to Quantity
                    lineEffectiveMult.put(lql.Id, lql.Quantity);
                    }

                } // find deepest level - FOR loop

            system.debug('>>>>> LineEffectiveMult = '+lineEffectiveMult);
            // process all the child line items and set the values
            for (OrderItem qli:lOrderLines){

                // UPDATE the Opportunity line
                OrderItem updLine = new OrderItem();
                updLine.Id = qli.Id;
                updLine.vlocity_cmt__EffectiveQuantity__c = lineEffectiveMult.get(qli.Id);

                Double discRecurringPrice;
 /*               if (qli.vlocity_cmt__RecurringCharge__c != null)
                    discRecurringPrice = qli.vlocity_cmt__RecurringCharge__c;
                else
                    discRecurringPrice = 0.0;  */

                // if there is a recurring charge AND it's a child item and pricing children items or parent item
                if (qli.vlocity_cmt__RecurringCharge__c != null && 
                    ( (priceChildItems && childMap.get(qli.Id)) || !childMap.get(qli.Id)) )
                    //discRecurringPrice = qli.vlocity_cmt__RecurringCharge__c;
                    discRecurringPrice = (Double) qli.getSObject('PricebookEntry').get('vlocity_cmt__RecurringPrice__c');
                else
                    discRecurringPrice = 0.0;

                // set recurring prices
                if (qli.vlocity_cmt__RecurringManualDiscount__c != null && qli.vlocity_cmt__RecurringManualDiscount__c > 0.00){
                    discRecurringPrice -= qli.vlocity_cmt__RecurringManualDiscount__c * qli.vlocity_cmt__RecurringCharge__c * .01;
                }

                updLine.vlocity_cmt__RecurringCalculatedPrice__c = discRecurringPrice* qli.Quantity;
                updLine.vlocity_cmt__RecurringDiscountPrice__c = discRecurringPrice* qli.Quantity;
                updLine.vlocity_cmt__RecurringTotal__c = discRecurringPrice* qli.Quantity;
                updLine.vlocity_cmt__EffectiveRecurringTotal__c = discRecurringPrice * lineEffectiveMult.get(qli.Id);

                // set one time prices
                Double discOneTimePrice;
 /*               if (qli.ListPrice != null)
                    discOneTimePrice = qli.ListPrice;
                else discOneTimePrice = 0.0;   */

                if (qli.ListPrice != null && 
                    ( (priceChildItems && childMap.get(qli.Id)) || !childMap.get(qli.Id)) )
                    discOneTimePrice = qli.ListPrice;
                else discOneTimePrice = 0.0;

                if (qli.vlocity_cmt__OneTimeManualDiscount__c != null && qli.vlocity_cmt__OneTimeManualDiscount__c > 0.00){
                    discOneTimePrice -= qli.vlocity_cmt__OneTimeManualDiscount__c *     qli.ListPrice * .01;
                }

                updLine.vlocity_cmt__EffectiveOneTimeTotal__c  = discOneTimePrice * lineEffectiveMult.get(qli.Id);
                updLine.vlocity_cmt__OneTimeCalculatedPrice__c = discOneTimePrice* qli.Quantity;
                updLine.vlocity_cmt__OneTimeCharge__c = qli.ListPrice;
                updLine.vlocity_cmt__OneTimeDiscountPrice__c = discOneTimePrice* qli.Quantity;
                updLine.vlocity_cmt__OneTimeTotal__c = discOneTimePrice* qli.Quantity;


                // set overage prices
                Double discOveragePrice;
 /*               if (qli.vlocity_cmt__OverageCharge__c != null)
                    discOveragePrice = qli.vlocity_cmt__OverageCharge__c;
                else
                    discOveragePrice = 0.0;   */

                if (qli.vlocity_cmt__OverageCharge__c != null && 
                    ( (priceChildItems && childMap.get(qli.Id)) || !childMap.get(qli.Id)) )                    
                    discOveragePrice = qli.vlocity_cmt__OverageCharge__c;
                else
                    discOveragePrice = 0.0;

                if (qli.vlocity_cmt__OverageManualDiscount__c != null && qli.vlocity_cmt__OverageManualDiscount__c > 0.00){
                    discOveragePrice -= qli.vlocity_cmt__OverageDiscountPrice__c * qli.vlocity_cmt__OverageCharge__c * .01;
                }

                updLine.vlocity_cmt__OverageCalculatedPrice__c = discOveragePrice* qli.Quantity;
                updLine.vlocity_cmt__OverageDiscountPrice__c  = discOveragePrice* qli.Quantity;
                updLine.vlocity_cmt__OverageTotal__c  = discOveragePrice* qli.Quantity;             

                system.debug(updLine);
                updLineList.add(updLine);
                } // for all line items

            system.debug('>>>>> UpdLineList '+updLineList);
            update updLineList;
            } // there are line items

        return;
    } // calcOrderPrices

} // Class