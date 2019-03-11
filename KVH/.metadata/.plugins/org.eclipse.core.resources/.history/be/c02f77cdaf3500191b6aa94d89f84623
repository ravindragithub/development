/*******************************************************
    Name        :        Case_OrderEntryNotificationCtrl_Test
    Description :        test class for Case_OrderEntryNotificationCtrl
**********************************************************/
@isTest
private class Case_OrderEntryNotificationCtrl_Test{
    @testSetup
    static void setupTestData(){
        Account acc = new Account(Name = 'Test Account',billingcountry='USA');
        insert acc;
        
        String recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('AgilePlans').getRecordTypeId();
        Opportunity opp = new Opportunity(Name = 'Test Opp',closedate=date.today(),stagename = 'Discovery',AccountId = acc.Id,RecordTypeId = recordTypeId);
        insert opp;
    
        String queueId = [Select id from Group where type = 'Queue' and name = 'Field Service Backlog'][0].Id;
        Case newCase = new Case();
        newCase.New_Vessel_or_Platform__c = 'Test Vessel - 1';
        newCase.subject = newCase.New_Vessel_or_Platform__c + ' - New AgilePlans Install Request';
        newCase.Related_Opportunity__c = opp.Id;
        newCase.Type = 'Request AgilePlans Installation Support';
        newCase.Product_or_Service__c = 'KVH mini-VSAT Broadband (TracPhone V-Series, V-IP Series)';
        newCase.Product_or_Service_Detail__c = 'Mobile Data Carrier, KVH Mini-VSAT KU/C Band Service';
        
        String description = 'Please see the attached Service Order and Sales Order for ' + newCase.New_Vessel_or_Platform__c + ' AgilePlans installation.';
        newCase.Description = description;
        newCase.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Installation').getRecordTypeId();
        
        
        newCase.Sales_Order_Desk__c = 'KU';       
        
        
        newCase.OwnerId = queueId;
        insert newCase;
     }
    static testMethod void testController() {
        Case caseObj = [Select id from Case limit 1];
        Case_OrderEntryNotificationCtrl ctrl = new Case_OrderEntryNotificationCtrl(new Apexpages.standardcontroller(caseObj));
        ctrl.sendNotification();
        ctrl.back();
    }
    
}