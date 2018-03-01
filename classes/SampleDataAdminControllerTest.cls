@isTest(seeAllData=false)
public with sharing class SampleDataAdminControllerTest {
    static testMethod void testDRImport(){
        Test.startTest();
        SampleDataAdminController.invokeMethod('VLC_SampleDR_OrderItemAttr');

        Test.stopTest();
    }
    static testMethod void testCMImport(){
        Test.startTest();
        String cmPacks = SampleDataAdminController.getAllCMDataPacks();
        System.debug(cmPacks);
        Map<String, Object> result = SampleDataAdminController.importCMData('VLC_SampleCM_ActivateContractAction');
        System.debug(result);
        SampleDataAdminController dataAdmin = new SampleDataAdminController();
        result = SampleDataAdminController.importCMData('VLC_SampleCM_Blah');
        System.debug(result);
        Test.stopTest();
    }
}