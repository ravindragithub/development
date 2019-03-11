/*
    Description    :    Test class for myKVH_NotificationSettingController 
*/
@isTest
public class myKVH_NotificationSettingTestClass {
    // Test Method to cover GDPRfieldUpdate
    static testMethod void test_myKVH_NotificationSetting() {
        List<Account> accList = TestDataFactory.createAccountRecords(1, null,'Prospect',false,false,'','',null,'');
        insert accList;  
        Contact con = TestDataFactory.createContactRecords('testFCon','testLCon', 'test@email.com');
        con.AccountId = accList[0].Id;
        insert con;  
        
        Test.startTest(); 
        myKVH_NotificationSettingController.GDPRfieldUpdate(con.Id,true,true,true,false);
        
        List<Contact> theContact = new List<Contact>([Select Id,name,Email_Opted_In__c from Contact Limit 1]);
        system.assertEquals('Agree', theContact[0].Email_Opted_In__c);
        
        myKVH_NotificationSettingController.GDPRfieldUpdate(con.Id,false,false,false,true);
        
        theContact = new List<Contact>([Select Id,name,Email_Opted_In__c from Contact Limit 1]);
        system.assertEquals('Decline', theContact[0].Email_Opted_In__c);
        Test.stopTest(); 
    }
}