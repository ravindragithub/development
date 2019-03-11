/*******************************************************
    Name        :        AgilePlansController_Test
    Description :        Test class for AgilePlansController,AgilePlans_Attach_SiteSurveyCtrl
                        AgilePlans_attachSiteSurveyCtrl, AgilePlans_attachSalesOrderCtrl
**********************************************************/
@isTest
private class AgilePlansController_Test{
    @testSetup
    static void setupTestData(){
        Account acc = new Account(Name = 'Test Account',billingcountry='USA');
        insert acc;
        
        String recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('AgilePlans').getRecordTypeId();
        Opportunity opp = new Opportunity(Name = 'Test Opp',closedate=date.today(),stagename = 'Discovery',AccountId = acc.Id,RecordTypeId = recordTypeId);
        insert opp;
    }
    
    static testMethod void testController() {
        List<Opportunity> opplst = [Select id from Opportunity limit 1];
        
        AgilePlansController ctrl1 = new AgilePlansController(new Apexpages.standardcontroller(opplst[0]));
        ctrl1.submit();        
        ctrl1.back();
        
        
        AgilePlans_attachSiteSurveyCtrl ctrl2 = new AgilePlans_attachSiteSurveyCtrl(new Apexpages.standardcontroller(opplst[0]));        
        ctrl2.submit();
        ctrl2.back();
        
        AgilePlans_attachSalesOrderCtrl ctrl4 = new AgilePlans_attachSalesOrderCtrl(new Apexpages.standardcontroller(opplst[0]));
        ctrl4.submit();
        ctrl4.back();
        
    }
    
    static testMethod void testController2() {  
        List<Opportunity> opplst = [Select id from Opportunity limit 1];      
        
        AgilePlansController ctrl1 = new AgilePlansController(new Apexpages.standardcontroller(opplst[0]));        
        ctrl1.serviceOrder.body  = Blob.valueOf('test');
        ctrl1.serviceOrder.name = 'Test.pdf';
        ctrl1.notification = 'KS';
        ctrl1.submit();
        ctrl1.back();
        
        system.debug('@@ ');
        case tempcase;
        AgilePlans_attachSiteSurveyCtrl ctrl2 = new AgilePlans_attachSiteSurveyCtrl(new Apexpages.standardcontroller(opplst[0]));
        ctrl2.siteSurvey.body = Blob.valueOf('test'); 
        ctrl2.siteSurvey.name = 'test.pdf';  
        if(ctrl2.caselist.size() > 0){
            ctrl2.caseObj = ctrl2.caselist[0];
            tempcase = ctrl2.caselist[0];
            ctrl2.submit();
        
            AgilePlans_Attach_SiteSurveyCtrl ctrl3 = new AgilePlans_Attach_SiteSurveyCtrl(new Apexpages.standardcontroller(tempcase));
            ctrl3.sitesurvey.body = Blob.valueOf('Test');
            ctrl3.sitesurvey.name = 'Test.pdf';
            ctrl3.submit();
            ctrl3.back();
        }
        
        test.starttest();
        List<Account> acclst = [Select id from Account limit 1];
        Sales_Order__c salesOrder = new Sales_Order__c(Name = '12345',Account__c = acclst[0].Id);
        insert salesOrder;
        AgilePlans_attachSalesOrderCtrl ctrl4 = new AgilePlans_attachSalesOrderCtrl(new Apexpages.standardcontroller(opplst[0]));
        if(ctrl4.caselist.size() > 0){
            ctrl4.caseObj = ctrl4.caselist[0];
            ctrl4.caseObj.Sales_Order__c = salesOrder.Id;        
            ctrl4.submit();
        }
        test.stoptest();
        
    }
    
     static testMethod void testcreateApplicationEngineeringCase() {  
        List<Opportunity> opplst = [Select id,Notify_Application_Engineering__c from Opportunity limit 1];    
        opplst[0].Notify_Application_Engineering__c =true;
        update opplst;
     }
    
}