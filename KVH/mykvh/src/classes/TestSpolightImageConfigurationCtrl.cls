/***************************************
    Test class for SpolightImageConfigurationCtrl
    
*****************************************/
@isTest
private class TestSpolightImageConfigurationCtrl{
    
    @istest
    private static void unittest(){
        Spotlight_Image_Configuration__c spotlight = new Spotlight_Image_Configuration__c();
        insert spotlight;
        
        SpolightImageConfigurationCtrl ctrl = new SpolightImageConfigurationCtrl();
        ctrl.imagelst[0].file = Blob.valueOf('testing');
        ctrl.imagelst[0].filename = 'test.png';
        ctrl.saveRecords();
        ctrl = new SpolightImageConfigurationCtrl();
        ctrl.rownumber=0;
        ctrl.deleteSpotlight();
        
        //component controller
        SpotlightComponentController.getImagelist();
    }
}