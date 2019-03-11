/*Description    :    Test class for myKVH_SupportCenter 
*/
@isTest
public class myKVH_SupportCenter_Test {
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
        List<CaseComment> caseCommentList = new list<CaseComment>();
        integer i = 0;
        for(Case cse : caseList){
            CaseComment cc = new CaseComment(ParentId = cse.Id,CommentBody = 'test'+ i);
            i++;
            caseCommentList.add(cc);
        }
        insert caseCommentList;
    }
    static testMethod void myKVH_SupportCenterTestMethod1() {
        User user = [Select Id,name from User where email='test123@noemail.com'];    
        
        system.runAs(user) {
            Case newCase = new Case(Subject = ' Test Sub Case',New_Vessel_or_Platform__c = 'Test',Description='Test',Web_Product_or_Service_Type__c ='mini-VSAT Broadband');
            Case newCase2 = new Case(Subject = ' Test Sub Case2',New_Vessel_or_Platform__c = 'Test',Description='Test',Web_Product_or_Service_Type__c ='mini-VSAT Broadband');
            List<CaseComment> newCaseComment = new List<CaseComment>();
            myKVH_SupportCenterController obj = new myKVH_SupportCenterController();            
            
            obj = myKVH_SupportCenterController.doIntialize();
            system.assertNotEquals(null, obj.lstOfCases);
            
            newCase = myKVH_SupportCenterController.CreateCaseController(newCase,'General question or feedback','airtimeCase');
            system.assertNotEquals(null, newCase.Id);
            
            newCaseComment = myKVH_SupportCenterController.CreateCaseComment('Testing Comment' , newCase);
            system.assertEquals(newCase.Id, newCaseComment[0].ParentId);
            
            newCase.Status = 'Closed';
            newCaseComment = myKVH_SupportCenterController.CreateCaseComment('Testing Comment' , newCase);
            system.assertEquals('New Customer Comment', newCase.Status);
        } 
    }
    static testMethod void myKVH_SupportCenterTestMethod2() {
        User user = [Select Id,name from User where email='test123@noemail.com'];    
        
        system.runAs(user) {
            Case newCase = new Case(Subject = ' Test Sub Case2',New_Vessel_or_Platform__c = 'Test',Description='Test',Web_Product_or_Service_Type__c ='mini-VSAT Broadband');
            List<CaseComment> newCaseComment = new List<CaseComment>();
            myKVH_SupportCenterController obj = new myKVH_SupportCenterController();
            
            newCase = myKVH_SupportCenterController.CreateCaseController(newCase,null,'techSupportCase');
            system.assertNotEquals(null, newCase.Id);
            
            myKVH_SupportCenterController.caseCommentAccessWrapperClass tempWrap = new myKVH_SupportCenterController.caseCommentAccessWrapperClass();
            tempWrap = myKVH_SupportCenterController.caseCommentAccessMethod( newCase.Id);
            system.assertEquals('New', tempWrap.caseData.Status);
        } 
    }
}