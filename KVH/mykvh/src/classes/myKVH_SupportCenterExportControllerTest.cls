/* Description: Test class for myKVH_SupportCenterExportController*/
@isTest
public class myKVH_SupportCenterExportControllerTest {
    static integer MAX_LOOP_COUNTER = 15;
    static Group AIRTIMEQUEUE = [Select Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Airtime_Services_Queue'];
    static string CASE_TYPE = 'Information on an Existing Service';
    static string valueSelected1 = 'General Account or Service Inquiry';
    static string valueSelected2 = 'Questions about activation forms';
    private static final Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airtime Service').getRecordTypeId();
    
    @TestSetup
    static void setup(){
        //add a custom settings record...s
        PortalProductServiceRecordTypeMap__c s = new PortalProductServiceRecordTypeMap__c();
        s.RecordTypeId__c = RecordTypeIdCase;
        s.Name = 'Information on an Existing Service';
        s.Record_Type_Name__c = 'Airtime Service';
        s.isCustomerPortal__c = true;
        insert s;
        
        List<Account> accList = TestDataFactory.createAccountRecords(2, null,'Prospect',false,false,'','',null,'');
        insert accList;  
        accList[1].ParentId = accList[0].Id;
        update accList;
        Contact con = TestDataFactory.createContactRecords('testFCon','testLCon', 'test@email.com');
        con.AccountId = accList[0].Id;
        insert con;  
        Id p = [select id from profile where name='myKVH Customer Community User'].id;
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                             ContactId = con.Id,
                             timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert user;
        
        list<Case> caseList = new list<Case>();
        for (integer i = 0; i<MAX_LOOP_COUNTER; i++){
            Case c = new case();
            c.Subject = i + ' Test New Case';
            c.status = 'New';
            c.AccountId = accList[0].Id;
            c.ContactId = con.Id;
            c.OwnerId = AIRTIMEQUEUE.Id;
            c.Origin = 'Customer Portal';
            c.Type = CASE_TYPE;
            c.RecordTypeId = RecordTypeIdCase;
            c.Product_or_Service__c = valueselected1;
            c.Product_or_Service_Detail__c = valueselected1;
            c.Case_Symptom__c = valueselected2;
            caseList.add(c);
        }
        system.debug('==caseList==' + caseList.size());
        for (integer i = 0; i<MAX_LOOP_COUNTER; i++){
            Case c = new case();
            c.Subject = i + ' Test Closed Case';
            c.status = 'Closed';
            c.AccountId = accList[0].Id;
            c.ContactId = con.Id;
            c.OwnerId = AIRTIMEQUEUE.Id;
            c.Origin = 'Customer Portal';
            c.Type = CASE_TYPE;
            c.RecordTypeId = RecordTypeIdCase;
            c.Product_or_Service__c = valueselected1;
            c.Product_or_Service_Detail__c = valueselected1;
            c.Case_Symptom__c = valueselected2;
            caseList.add(c);
        }
        system.debug('==caseList==' + caseList.size());
        insert caseList;
    }
    
    static testMethod void caseloadTest() {
        User user = [Select Id,name from User where email='test123@noemail.com'];    
        PageReference pageRef = Page.myKVH_SupportCenterExportExcelVF;
        Test.setCurrentPage(pageRef);   
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('caseStatus', 'Open');
        ApexPages.currentPage().getParameters().put('caseType', RecordTypeIdCase);
        system.runAs(user) {
            myKVH_SupportCenterExportController controller = new myKVH_SupportCenterExportController();
            controller.loaddata();
            system.assertEquals(15,controller.lstOfCases.size());
        }        
    }
    
    static testMethod void closedCaseTest() {
        User user = [Select Id,name from User where email='test123@noemail.com'];    
        PageReference pageRef = Page.myKVH_SupportCenterExportExcelVF;
        Test.setCurrentPage(pageRef);   
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('caseStatus', 'Closed');
        ApexPages.currentPage().getParameters().put('caseType', RecordTypeIdCase);
        system.runAs(user) {
            myKVH_SupportCenterExportController controller = new myKVH_SupportCenterExportController();
            controller.loaddata();
            system.assertEquals(15,controller.lstOfCases.size());
        }        
    }
    
    static testMethod void unselectedCaseTypeTest() {
        User user = [Select Id,name from User where email='test123@noemail.com'];    
        PageReference pageRef = Page.myKVH_SupportCenterExportExcelVF;
        Test.setCurrentPage(pageRef);   
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('caseStatus', 'Closed');
        ApexPages.currentPage().getParameters().put('caseType','');
        system.runAs(user) {
            myKVH_SupportCenterExportController controller = new myKVH_SupportCenterExportController();
            controller.loaddata();
            system.assertEquals(15,controller.lstOfCases.size());
        }        
    }
}