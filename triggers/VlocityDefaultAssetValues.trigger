trigger VlocityDefaultAssetValues on Asset (before insert) {
    for(Asset a: Trigger.new){
        a.SerialNumber = 'VLO-' + Math.Round(Math.Random()*9999);
        a.vlocity_cmt__ConnectDate__c = System.TODAY();
        a.vlocity_cmt__ActivationDate__c = System.TODAY();
        a.PurchaseDate = System.TODAY();
        a.InstallDate = System.TODAY();
        a.Status = 'Purchased';
    }
}