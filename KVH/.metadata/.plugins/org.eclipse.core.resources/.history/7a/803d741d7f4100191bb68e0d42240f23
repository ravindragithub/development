/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class UAccountShareJKT_test {
    private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
    private static final Id DirectCust_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    private static final list<Profile> PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE 'Customer Portal%'];  //gets all Customer Portal Profiles.... Need Ids for Custom Setting, Name for conditional execution
    private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];

    @testSetup static void setupTestData(){             //Setup some test data
        //Going to need AccountShareProfile__c Custom Settings for sure!
        list<AccountShareProfiles__c> aspList = new list<AccountShareProfiles__c>();
        for(Profile p : PortalProf){
            AccountShareProfiles__c  asp = new AccountShareProfiles__c ();
            asp.SetupOwnerId = p.Id;                //SetupOwnerId is a standard field
            asp.OpportunityAccess__c = 'None';
            asp.AccountAccess__c = 'Read';
            if (p.Name.contains('Write')){          //This is the Case Read/Write profile...
                asp.CaseAccess__c = 'Edit';         //OK to edit cases!
            } else {                                //This is NOT the Case Read/Write profile...
                asp.CaseAccess__c = 'Read';         //Read only for Cases!
            }
            aspList.add(asp);
        }
        insert aspList;
        //going to need an Account Hierarchy (SOQL heavy stuff something like 38 queriew)...
        //This is a basic pattern for setting up an Acct Hierarchy....
        //Could be deeper, could have Accts at the same level for improved test quality.
        list<Account> testAccountList = new list<Account>();
        Account testAcct = new Account(Name = 'UAccountShareJKT Test Account', RecordTypeId = Platform_RECORD_TYPE_ID,Apply_Custom_Sharing__c=true);
        testAcct.myKVH_Element_Count__c = 1;                //must have elements!
        testAccountList.add(testAcct);

        Account testParent = new Account(Name = 'UAccountShareJKT Test Parent Account', RecordTypeId = DirectCust_RECORD_TYPE_ID,Apply_Custom_Sharing__c = true);
        testParent.Send_to_myKVH_Physical__c = true;
        testAccountList.add(testParent);

        Account testGrandParent = new Account(Name = 'UAccountShareJKT Test GrandParent Account', RecordTypeId = DirectCust_RECORD_TYPE_ID,apply_custom_sharing__c=false);
        testGrandParent.Send_to_myKVH_Physical__c = true;
        testAccountList.add(testGrandParent);
        
        Account testForthParent = new Account(Name = 'UAccountShareJKT Test FourthParent Account', RecordTypeId = DirectCust_RECORD_TYPE_ID,apply_custom_sharing__c=false);
        testForthParent.Send_to_myKVH_Physical__c = true;
        testAccountList.add(testForthParent);
        
        
        Account testFifthParent = new Account(Name = 'UAccountShareJKT Test FifthParent Account', RecordTypeId = DirectCust_RECORD_TYPE_ID,apply_custom_sharing__c=false);
        testFifthParent.Send_to_myKVH_Physical__c = true;
        testAccountList.add(testFifthParent);

        insert testAccountList;
        testAccountList.clear();
        testAcct.ParentId  = testParent.Id;
        testAccountList.add(testAcct);
        testParent.ParentId  = testGrandParent.Id;
        testAccountList.add(testParent);
        testGrandParent.ParentId  = testForthParent.Id;
        testAccountList.add(testGrandParent);
        testForthParent.ParentId  = testFifthParent.Id;
        testAccountList.add(testForthParent);
        
        update testAccountList;
        for(Account a : testAccountList){
            system.debug('Id: ' + a.Id + ' |Name: ' + a.Name + ' |Parent: ' + a.ParentId);
        }
        //and a bunch of Contact/Users....
        
        //GrandParent and Parent Contacts Below
        List<Contact> allContacts = New List<Contact>();
        List<Case> allCases = New List<Case>();
        for(integer i=0;i<5;i++){
        
            //GrandParent Contacts
            Contact testGPAcctCon = New Contact();
            testGPAcctCon.lastName = 'TestAccLN'+i;
            testGPAcctCon.AccountID = testGrandParent.id;
            allContacts.add(testGPAcctCon);
            
            //Parent Contacts
            Contact testParentAcctCon = New Contact();
            testParentAcctCon.lastName = 'TestAccLN'+i;
            testParentAcctCon.AccountID = testParent.id;
            allContacts.add(testParentAcctCon);
        }
        
        // GrandParent and parent cases below
        
        for(integer i=0;i<5;i++){
        
            //GrandParent Cases
            Case testGPAcctCase = New Case();
            testGPAcctCase.AccountID = testGrandParent.id;
            allCases.add(testGPAcctCase);
            
            //Parent Cases
            Case testParentAcctCase = New Case();
            testParentAcctCase.AccountID = testParent.id;
            allCases.add(testParentAcctCase);
        }
        
        insert allContacts;
        
        insert allCases;
        
        //Inserting Portal Users for each contact created above
        
        list<user> allPortalUsers = New List<User>();
        system.runAs(adminUser){
            for(integer j=0;allContacts.size()>j;j++){
                User portalUsers = new User();
                portalUsers.Username = 'userName@test.com'+j;
                portalUsers.LastName = 'lastName'+j;
                portalUsers.ContactId = allContacts[j].id;
                portalUsers.TimeZoneSidKey = 'America/Los_Angeles';
                portalUsers.Email = 'user@test.com'+j;
                portalUsers.ProfileId = PortalProf[0].Id;
                portalUsers.CommunityNickname = 'CN'+j;
                portalUsers.LocaleSidKey = 'en_US';
                portalUsers.LanguageLocaleKey = 'en_US';
                portalUsers.Alias = 'Alias'+j;
                portalUsers.EmailEncodingKey = 'UTF-8';
                portalUsers.isActive = true;
                allPortalUsers.add(portalUsers);
            }
            insert allPortalUsers; 
        }
          
    }

    static testMethod void testSetupData(){                                 //Verify that we got the test data setup correctly!
        list<AccountShareProfiles__c> aspListRead = new list<AccountShareProfiles__c>();
        for(Profile p : PortalProf){                                        //We can reuse the static list of Customer Portal Profiles
            AccountShareProfiles__c custSetting = AccountShareProfiles__c.getValues(p.Id);  //no SOQL, oh happy day!
            system.debug('Account Share Profile for: ' + p.Name);
            system.debug(custSetting);
            if (p.Name.contains('Write')){                                  //Is this the Read/Write profile?
                system.assertEquals(custSetting.CaseAccess__c, 'Edit');     //Custom Setting should allow for case edit in shares!
            } else {                                                        //IF it's not the Read/Write profile...
                system.assertEquals(custSetting.CaseAccess__c, 'Read');     //it's read-only for cases!
            }
            aspListRead.add(custSetting);
        }
        
        system.assertEquals(aspListRead.size(), PortalProf.size());         //should be one Custom Setting for Each Profile...
        list<Account> readAccts = new list<Account>();
        readAccts = [SELECT Id, Name, ParentId FROM Account];
        system.assertEquals(5,readAccts.size());
    }

    static testMethod void myUnitTest() {
        
        // TO DO: implement unit test
        List<Account> accts = [SELECT Id, Name, ParentId,(SELECT id FROM CASES) FROM Account];
        system.assertEquals(5,accts.size());
        
        //All Cases related to Account Here
        List<id> accountNotHavingCases = New List<Id>();
        Map<id,List<Case>> accountCases = New Map<id,List<Case>>();
        for(Account accCases:accts){
            if(accCases.CASES.Size()>0){
                accountCases.put(accCases.id,accCases.CASES);
                //Confirming account cases
                system.assertEquals(accCases.CASES.size(),5);
            }else{
                //Finding child Account not Having Cases
                system.assertEquals(accCases.CASES.size(),0);
                accountNotHavingCases.add(accCases.id);
            }
        }
        
        //Creating Contact for child Account
        
        Contact childContact = New Contact();
        childContact.LastName = 'ChildContactLN';
        childContact.AccountID = accountNotHavingCases[0];
        insert childContact;
        ID childPortalID;
        system.runAs(adminUser){
                User portalUsers = new User();
                portalUsers.Username = 'ChildContact@test.com';
                portalUsers.LastName = 'lastName';
                portalUsers.ContactId = childContact.id;
                portalUsers.TimeZoneSidKey = 'America/Los_Angeles';
                portalUsers.Email = 'userChildContact@test.com';
                portalUsers.ProfileId = PortalProf[0].Id;
                portalUsers.CommunityNickname = 'CN12';
                portalUsers.LocaleSidKey = 'en_US';
                portalUsers.LanguageLocaleKey = 'en_US';
                portalUsers.Alias = 'AliasCC';
                portalUsers.isActive = true;
                portalUsers.EmailEncodingKey = 'UTF-8';
            insert portalUsers; 
            childPortalID = portalUsers.id;
        }
        
        
        //Before Calling UAccountShareJKT child can not access any cases
        
        User childCaseBeforeShare = [SELECT id FROM User Where id=:childPortalID];
        system.runAs(childCaseBeforeShare){
            List<Case> casesChildCanaccess = [SELECT id FROM Case];
            system.assertEquals(casesChildCanaccess.size(),0);
        }
        //After Calling UAccountShareJKT batch Grandparent access only 5 cases and parent can access 10 Cases and child can access only 5 cases
        Set<id> childAccountID = New Set<id>();
        childAccountID.add(accountNotHavingCases[0]);
        
        //Calling UAccountShare Class here
        UAccountShareJKT.createAccountShare(accountCases.keySet(),false);
        
        User childCaseAfterShare = [SELECT id FROM User Where id=:childPortalID];
        system.runAs(childCaseAfterShare){
            List<Case> casesChildCanaccess = [SELECT id FROM Case];
            system.assertEquals(casesChildCanaccess.size(),0);
        } 
    }
    
    static testMethod void myUnitUAccountShareBatch() {
        Test.StartTest();
        //Calling Batch Class Here
        List<Account> acc = [Select id, name, Apply_Custom_Sharing__c, parent.Apply_Custom_Sharing__c From Account];
        system.assertEquals(5,acc.size());
      
        UAccountShareBatch USB = New UAccountShareBatch(true);
        ID batchprocessid = Database.executeBatch(USB);
        System.abortJob(batchprocessid);
         
        Test.StopTest();
    }
    
}