/***********************************************************************************************************************
 Name: Add_or_Update_Airtime_ContactRolesTest 
 Copyright � 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "PlatformShareCustomComponent" class 
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      22/01/2015       Initial Development                                   
***********************************************************************************************************************/

/*1)      Setup account/contact/user (done!, lines 65-94)
  
  2)      Setup 2 new Direct Customer Accounts (un-related to each other, and unrelated to the Account from step 1.) with one Platform each 
(not done� you are re-using the one single account created in lines 25-30. It is important to create un-related Accounts because 
the purpose of the Platform Share is to create a relationship between unrelated accounts) (done!, lines 96-109)
  
  3)      Instantiate the PSCC, and associate it with the Contact (Incorrectly sequenced. 
This needs to happen before any Platform Share records are created) (done! lines 111-117)
  
  4)      Do a system.assertEquals on the number of records returned to the PSCC. Should be zero 
(This needs to happen before any Platform Share records are created� simulates a Contact Detail page that does not have any Platform Share records.
If I am following the code correctly, you need to 1) Create a new PSCC, 2) Set  the Current Contact ID to Contact1.Id, 3) Assign the Current URL Value. 
Since there are no records yet, the assertion on line 82 should equal 0.) (done! lines 120-122)
  
  5)      Create a Platform Share Record between one of the Platforms created in step 2 
(not done, you are re-using the one single account created in lines 25-30, 
ALSO this needs to happen in the correct sequence� 
ALSO this should be completely unrelated to the test Account in step 1.) (done! lines 157-160)

  6)      Refresh the PSCC, and do a system.assertEquals on the number of records returned.
Should be one, and it should be the *correct*one! 
(I would suggest that you create a new PSCC at this point, pass in Contact Id, and Current URL like step 4 above). (Done! Lines 162-173)


7)      Create a second Platform Share Record to the other Platform created in Step 2 
(un related to any other account created in this testMethod) (done! lines 175-178)

8)      Refresh the PSCC (Like in step 4), and do a system.assertEquals on the number of records returned. 
Should be two, and it should be both of the Platforms from step 2. (done! lines 182-203)

9)      Delete one of the Platform Share records (done! line 206)

10)   Refresh the PSCC, and count the records returned. Should be one, and it should not be the Platform from the deleted Platform Share record
      (Done! Lines 209-226)
*/
@isTest

private class PlatformShareCustomComponentTest {
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	
   static testMethod void PlatformShareCustomComponent() {
      //test.StartTest(); jthom 2/2/15
      //The Start Test method resets the Salesforce Governor Limits. Best practice is to setup all test data
      //Then invoke the Start test method. That way the test method is not penalized for governed resources consumed
      //while setting up test data....
      
      /*----------------------------------Validating For Normal Contacts--------------------------------------------*/
        
      
         //Create Normal Account
        Account normalAccount = new Account(
            Name = 'TestAccount'
        );
        Database.insert(normalAccount);
     
        //Create contact for the account, which will related for account
        Contact contactNormal = new Contact(
            FirstName = 'Test',
            Lastname = 'Amit',
            AccountId = normalAccount.Id,
            Email = 'test@test.com'
        );
        Database.insert(contactNormal); 
        
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Customer Portal - Read/Write Case Access (all cases in accounts in hierarchy)' Limit 1];
        User user1 = new User(
            Username = 'test12345test@test.com',
            ContactId = contactNormal.Id,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Kumar',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        system.runAs(adminUser){		//Must insert User as a different User to avoid mixed DML
        	Database.insert(user1); 
        }
        
        
        list<RecordType> rts = [Select Id, Name From RecordType Where (SobjectType = 'Account' And isActive = true AND DeveloperName LIKE 'Platform_%')];
       
        //Create TWO UNRELATED Platform account (OK We can skip the Direct Customer Accounts... but in Production, all Platform Accounts should have a parent!)
        Account PlatformAccount1 = new Account(
            Name = 'PlatformAccount1',
            RecordTypeID=rts[0].ID
        );
        Database.insert(PlatformAccount1);
        
        Account PlatformAccount2 = new Account(
            Name = 'PlatformAccount2',
            RecordTypeID=rts[0].ID
        );
        Database.insert(PlatformAccount2);
        
        Test.startTest();
        
        PlatformShareCustomComponent PSCCFromContact = New PlatformShareCustomComponent();
        
        //Passing contactId to test the logic.
        PSCCFromContact.currentID = contactNormal.ID;
		PSCCFromContact.assignCurrentUrlValue();		//There are no Platform Share Records at this point....
        //Initially when page loads with out calling any main function(assignCurrentUrlValue) loading data will be ZERO.
        
        System.AssertEquals(0,PSCCFromContact.lstSPRecords.Size());
        
        System.AssertEquals(0,PSCCFromContact.intPageNumber);
        
       /*----------------------------------Validating For Portal Contacts--------------------------------------------*/
        
        
        
        /* We don't need ANY of this......
        //Create contact for the account, which will enable partner portal for account
        Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'Amit',
            AccountId = portalAccount1.Id,
            Email = 'test@test.com'
        );
        Database.insert(contact1);
       
        //Create user for the contact
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Customer Portal - Read/Write Case Access (all cases in accounts in hierarchy)' Limit 1];
        User user1 = new User(
            Username = 'test12345test@test.com',
            ContactId = contact1.Id,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Kumar',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        Database.insert(user1); */
        
        //Platform Share Records 
        
        myKVH_Shared_Platforms__c SP = New myKVH_Shared_Platforms__c();
        SP.Shared_Platform__c = PlatformAccount1.ID;
        SP.User__c = user1.ID;
        Insert SP;
        
        PSCCFromContact = New PlatformShareCustomComponent();
        
        //Passing contactId to test the logic.
        PSCCFromContact.currentID = contactNormal.ID;
        PSCCFromContact.assignCurrentUrlValue();

        //Initially when page loads with out calling any main function(assignCurrentUrlValue) loading data will be ZERO.
        
        System.AssertEquals(1,PSCCFromContact.lstSPRecords.Size());
        
        System.AssertEquals(1,PSCCFromContact.intPageNumber);
        system.assertEquals(PlatformAccount1.ID, PSCCFromContact.lstSPRecords[0].Shared_Platform__c);
        
        myKVH_Shared_Platforms__c SP1 = New myKVH_Shared_Platforms__c();
        SP1.Shared_Platform__c = PlatformAccount2.ID;
        SP1.User__c = user1.ID;
        Insert SP1;
        
        
        //Ready to test PSCC controller by creating an Object
        PlatformShareCustomComponent PSCC = New PlatformShareCustomComponent();
        
        //Passing contactId to test the logic.
        PSCC.currentID = contactNormal.ID;
        
        
        //Initially when page loads with out calling main function(assignCurrentUrlValue) loading data will be ZERO.
        
        System.AssertEquals(0,PSCC.lstSPRecords.Size());
        
        System.AssertEquals(0,PSCC.intPageNumber);
        
        
        //Main Funtion to execute platform share records for each contact
        
        PSCC.assignCurrentUrlValue();
        
        System.AssertEquals(2,PSCC.lstSPRecords.Size());
        
        //Total record count is 2 ,so data will in single window
        
        System.AssertEquals(1,PSCC.intPageNumber);
        
        
        Delete SP;		//Switching Platform Accounts...
        
        
        //If we delete platform share record validating records for contact
        
        PlatformShareCustomComponent validatePSCC = New PlatformShareCustomComponent();
        
        validatePSCC.currentID = contactNormal.ID;
        
        System.AssertEquals(0,validatePSCC.lstSPRecords.Size());
        
        System.AssertEquals(0,validatePSCC.intPageNumber);
        
        validatePSCC.assignCurrentUrlValue();
        
        System.AssertEquals(1,validatePSCC.lstSPRecords.Size());
        
        System.AssertEquals(1,validatePSCC.intPageNumber);
        
        system.assertNotEquals(PlatformAccount1.ID, validatePSCC.lstSPRecords[0].Shared_Platform__c);	//the deleted one!
        system.assertEquals(PlatformAccount2.ID, validatePSCC.lstSPRecords[0].Shared_Platform__c);	//the Correct one!
        
        
        validatePSCC.firstPage();
        validatePSCC.lastPage();
        validatePSCC.nextPage();
        validatePSCC.previousPage();
        validatePSCC.goToPage();
          
      test.StopTest();
      }
}