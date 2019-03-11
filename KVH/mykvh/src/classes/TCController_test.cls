@isTest
public class TCController_test {
    @testSetup static void setupTestData(){
        //setup common test data here
        Terms_and_Conditions__c TC1 = new Terms_and_Conditions__c(Name__c = 'TestTC1', Body__c = '1234');
        insert TC1;
        Terms_and_Conditions__c TC2 = new Terms_and_Conditions__c(Name__c = 'TestTC2', Body__c = '1234');
        insert TC2;
    }
    static testMethod void TCcreatetest(){
        User u = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        Terms_and_Conditions__c TC = new Terms_and_Conditions__c();
        test.startTest();
		System.runas(u){
			PageReference pageRef = Page.CreateTC;
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController control= new ApexPages.StandardController(TC);
			TCController ext = new TCController(control);
			ext.TC.Name__c = 'Hello';
            ext.TC.Body__c = 'How are you?';
			PageReference pr = ext.createRecord();
		}
		test.stopTest();
        List <Terms_and_Conditions__c> TCstest = [SELECT Id FROM Terms_and_Conditions__c];
        system.assertEquals(3, TCstest.size());
    }
    static testMethod void TCupdatetest(){
        Terms_and_Conditions__c TC = [SELECT Id FROM Terms_and_Conditions__c WHERE Name__c = 'TestTC1'];
        User u = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        test.startTest();
		System.runas(u){
			PageReference pageRef = Page.UpdateTC;
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController control= new ApexPages.StandardController(TC);
			TCController ext = new TCController(control);
			ext.TC.Name__c = 'Hello';
            ext.TC.Body__c = 'How are you?';
			PageReference pr = ext.updateTC();
            system.assert(pr.getRedirect());
            pr = ext.updateRecord();
            system.assert(pr.getRedirect());
		}
		test.stopTest();
        List <Terms_and_Conditions__c> TCstest = [SELECT Id FROM Terms_and_Conditions__c WHERE Name__c = 'Hello'];
        system.assertEquals(1, TCstest.size());
    }

}