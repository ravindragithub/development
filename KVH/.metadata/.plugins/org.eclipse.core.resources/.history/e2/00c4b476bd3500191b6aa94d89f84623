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
private class SiteLoginController_test {
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
	
	@testSetup static void setupUsers(){
		// TO DO: implement unit test
		//Insert a Test User
		//Need a contact and account.. OH! and a Platform!!
		Account testAcct = new Account(Name = 'testAcct', Account_Status__c = 'Active');
		insert testAcct;
		
		Account testPlat = new Account();
		testPlat.Name = 'testPlat';
		testPlat.RecordTypeId = Platform_RECORD_TYPE_ID;
		testPlat.Send_to_myKVH_Physical__c = true;
        testPlat.Parent = testAcct;
        testPlat.myKVH_Element_Count__c = 1;
        insert testPlat;
        //testAcct = [SELECT id, Name FROM Account WHERE Name = 'testAcct'];		//uses 10 SOQL :b
        Contact testCont1 = new Contact();
        testCont1.LastName = 'test1';
        testCont1.AccountId = testPlat.Id;
        testCont1.Agree_to_myKVH_Terms_and_Conditions__c = 'Accept';
        insert testCont1;
        //testCont1 = [SELECT id, Name FROM Contact WHERE LastName = 'test1'];
		//Need a Profile.... a PORTAL profile! Profiles are meta-data
		Profile PortalProf = new Profile();
		PortalProf = [SELECT Id, Name FROM Profile WHERE Name = 'Customer Portal - Customer of Service Provider' Limit 1]; 
		system.debug(PortalProf);
        
        Contact testCont2 = new Contact();
        testCont2.LastName = 'test2';
        testCont2.AccountId = testAcct.Id;
        testCont2.Agree_to_myKVH_Terms_and_Conditions__c = 'Accept';
        insert testCont2;
        
        Contact testCont3 = new Contact();
        testCont3.LastName = 'test3';
        testCont3.AccountId = testAcct.Id;
        testCont3.Agree_to_myKVH_Terms_and_Conditions__c = 'Denied';
        insert testCont3;
		
		//Need a NOT a PORTAL profile...
		Profile NOTPortalProf = new Profile();
		NOTPortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Standard%' Limit 1];
		system.debug(NOTPortalProf);
		// testUser1 ... is a Contact
		User testUser1 = new User();
		testUser1.username = 'LoginCtrlr.testUser1@kvh.com';
		testUser1.LastName = 'User1';
		testUser1.Email = 'LoginCtrlr.testUser1@kvh.com';
		testUser1.Alias = 'tuser1';
		testUser1.TimeZoneSidKey = 'America/New_York';
		testUser1.LocaleSidKey = 'en_US';
		testUser1.EmailEncodingKey = 'ISO-8859-1';
		testUser1.ProfileId = PortalProf.id;
		testUser1.LanguageLocaleKey = 'en_US';
		testUser1.ContactId = testCont1.Id; //must CREATE() user with Contact Id.....
		system.runAs(adminUser){			//avoid mixed DML pain and suffering
			insert testUser1;
		}
        
        User testUser3 = new User();
		testUser3.username = 'LoginCtrlr.testUser3@kvh.com';
		testUser3.LastName = 'User3';
		testUser3.Email = 'LoginCtrlr.testUser3@kvh.com';
		testUser3.Alias = 'tuser3';
		testUser3.TimeZoneSidKey = 'America/New_York';
		testUser3.LocaleSidKey = 'en_US';
		testUser3.EmailEncodingKey = 'ISO-8859-1';
		testUser3.ProfileId = PortalProf.id;
		testUser3.LanguageLocaleKey = 'en_US';
		testUser3.ContactId = testCont2.Id; //must CREATE() user with Contact Id.....
		system.runAs(adminUser){			//avoid mixed DML pain and suffering
			insert testUser3;
		}
        
        User testUser4 = new User();
		testUser4.username = 'LoginCtrlr.testUser4@kvh.com';
		testUser4.LastName = 'User1';
		testUser4.Email = 'LoginCtrlr.testUser4@kvh.com';
		testUser4.Alias = 'tuser1';
		testUser4.TimeZoneSidKey = 'America/New_York';
		testUser4.LocaleSidKey = 'en_US';
		testUser4.EmailEncodingKey = 'ISO-8859-1';
		testUser4.ProfileId = PortalProf.id;
		testUser4.LanguageLocaleKey = 'en_US';
		testUser4.ContactId = testCont3.Id; //must CREATE() user with Contact Id.....
		system.runAs(adminUser){			//avoid mixed DML pain and suffering
			insert testUser4;
		}

        AccountShare accountShare = new AccountShare();
        accountShare.UserOrGroupId = testUser1.Id;
        accountShare.AccountId = testAcct.Id;
        accountShare.AccountAccessLevel = 'Edit';
        accountShare.CaseAccessLevel = 'Edit';
        accountShare.OpportunityAccessLevel = 'Edit';
        insert accountShare;
        system.debug(accountShare);
        
        AccountShare accountShare1 = new AccountShare();
        accountShare1.UserOrGroupId = testUser1.Id;
        accountShare1.AccountId = testPlat.Id;
        accountShare1.AccountAccessLevel = 'Edit';
        accountShare1.CaseAccessLevel = 'Edit';
        accountShare1.OpportunityAccessLevel = 'Edit';
        insert accountShare1;
        system.debug(accountShare1);
		
		testUser1 = [SELECT id, username, Email FROM User WHERE username = 'LoginCtrlr.testUser1@kvh.com'];
		//test data part 1 completed!!
		//need another test user...
		// testUser2... is NOT a contact
		User testUser2 = new User();
		testUser2.username = 'LoginCtrlr.testUser2@kvh.com';
		testUser2.LastName = 'User2';
		testUser2.Email = 'LoginCtrlr.testUser2@kvh.com';	
		testUser2.Alias = 'tuser2';
		testUser2.TimeZoneSidKey = 'America/New_York';
		testUser2.LocaleSidKey = 'en_US';
		testUser2.EmailEncodingKey = 'ISO-8859-1';
		testUser2.ProfileId = NOTPortalProf.id;  
		testUser2.LanguageLocaleKey = 'en_US';
		system.runAs(adminUser){			//avoid mixed DML pain and suffering
			insert testUser2;
		}
		
		testUser2 = [SELECT id, username, Email FROM User WHERE username = 'LoginCtrlr.testUser2@kvh.com'];
		//Test Data all set!
	}
	
	public static testMethod void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        // test for invalid username
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';											//invalid username
        controller.password = '123456'; 
        System.assertEquals(controller.login(),null);
        System.assertEquals(controller.shipboard(),null);

        controller.username = 'LoginCtrlr.testUser2@kvh.com';									//not a portal user...
        controller.password = '123456'; 
        system.debug(controller.getStartUrl(controller.username));
        //system.assertEquals('/home/home.jsp', controller.getStartUrl(controller.username));
        
        controller.username = 'LoginCtrlr.testUser1@kvh.com';//Customer of Service Provider...
        controller.password = '123456'; 
        system.debug(controller.getStartUrl(controller.username));
        Account testPlat = [SELECT Id FROM Account WHERE Name = 'testPlat'];
        string pageref = '/idp/login?app=0sp13000000CaVf&RelayState=/platforms/find?sf_id=' + testPlat.Id;
        system.assertEquals(pageref, controller.getStartUrl(controller.username));	//hard to predict connected app ID!
        
        pageRef = '/idp/login?app=0sp13000000CaVf';
        controller.username = 'LoginCtrlr.testUser3@kvh.com';//Customer of Service Provider...
        controller.password = '123456'; 
        system.debug(controller.getStartUrl(controller.username));
        system.assertEquals(pageref, controller.getStartUrl(controller.username));
        
        PageReference pageRef2 = new PageReference('prodreg/SiteLoginProduct?reg=true');
        Test.setCurrentPage(pageRef2);
        controller.username = 'LoginCtrlr.testUser3@kvh.com';//Customer of Service Provider...
        controller.password = '123456'; 
        system.assertEquals('/Activation_Product_Registration', controller.getStartUrl(controller.username));
        
        PageReference pageRef3 = new PageReference('prodreg/SiteLoginProduct?reg=true');
        Test.setCurrentPage(pageRef3);
        controller.username = 'LoginCtrlr.testUser4@kvh.com';//Customer of Service Provider...
        controller.password = '123456'; 
        system.assertEquals('/home/home.jsp', controller.getStartUrl(controller.username));
        system.assertEquals('/home/home.jsp', controller.getproductUrl(controller.username));        
	}
}