/*
Description    :    Test class for myKVH_AccountHierarchyController 
*/
@isTest
private class myKVH_AccountHierarchyTest {
    @testSetup static void setup() {
        List<Account> accList = TestDataFactory.createAccountRecords(1, null,'Prospect',false,false,'','',null,'');
        insert accList;  
        Contact con = TestDataFactory.createContactRecords('testFCon','testLCon', 'test@email.com');
        con.AccountId = accList[0].Id;
        insert con;  
        Id p = [select id from profile where name='LTE Activation User'].id;
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                             ContactId = con.Id,
                             timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert user;
        Id CORPORATEBILLINGACCOUNTRTID = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Corporate CC Account').getRecordTypeId();
        Id CUSTOMERBILLINGACCOUNTRTID = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
        List<Billing_Account__c> lstCorpBillingAccount = new List<Billing_Account__c>();
        List<Billing_Account__c> lstCustBillingAccount = new List<Billing_Account__c>();
        List<Contract> lstBillAccContract = new List<Contract>();
        for(integer i= 0; i<2; i++){
            Billing_Account__c billAcc = new Billing_Account__c(Name = 'Test' +i,RecordTypeId = CORPORATEBILLINGACCOUNTRTID,Account__c = accList[0].Id);
            lstCorpBillingAccount.add(billAcc);
        }
        insert lstCorpBillingAccount;
        for(integer i= 0; i<10; i++){
            Billing_Account__c billAcc = new Billing_Account__c(Name = 'Test' +i,RecordTypeId = CUSTOMERBILLINGACCOUNTRTID,Account__c = accList[0].Id);
            if(i < 6)
            billAcc.Corporate_CC_Account_Name__c = lstCorpBillingAccount[0].Id;
            lstCustBillingAccount.add(billAcc);
        }
        insert lstCustBillingAccount;
        for(integer i= 0; i<10; i++){
            Contract billAccContract = new Contract(AccountId = accList[0].Id,Billing_Account__c = lstCustBillingAccount[i].Id,
                                                   Installation__c = accList[0].Id);
            lstBillAccContract.add(billAccContract);
        }
        insert lstBillAccContract;
    }
    @isTest static void testMethod1() {
        List<myKVH_AccountHierarchyController.accountHierarchyWrapper> lstWrap = myKVH_AccountHierarchyController.getBillingAccountList();
        system.assertEquals(3, lstWrap.size());
    }
}