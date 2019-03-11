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
private class UTestMethods {
	@testSetup static void setupTestData(){
		
	}

	private static testMethod void test1()
	{
		Integer counter = 1;
		Integer numberOfAccounts = 100;
		Integer numberOfLeads = 100;
		Integer numberOfContactsPerAccount = 1;
		UTestData util = new UTestData();
		//Add accounts
		List<Account> accounts = UTestData.getAccounts(numberOfAccounts);				
		
		insert accounts;					
		
		accounts = [select Id from Account where Id in :accounts];
		
		System.assertEquals(numberOfAccounts, accounts.size(), 'Account counts don\'t match');
		
		//Add contacts
		List<Contact> contacts = UTestData.getContacts(accounts, numberOfContactsPerAccount);
		
		UTestData.addEmailToRecords(contacts, 'Email');
		
		insert contacts;
		
		contacts = [select Id from Contact where Id in :contacts];
		
		System.assertEquals(numberOfAccounts * numberOfContactsPerAccount, contacts.size(), 'Contact counts don\'t match');
				
		//Add products
		
		//List<Product2> products = new List<Product2>();		
		List<Product2> products = UTestData.getProducts(4);
		
		insert products;
				
		products = [select Id from Product2 where Name like 'Test%Product%'];
		
		System.assertEquals(4, products.size(), 'Product counts don\'t match');			
		
		//Add pricebook
		Pricebook2 pricebook = UTestData.getPricebook('Test Pricebook ' + UTestData.getTimestamp(DateTime.now()));
		
		insert pricebook;
		
		List<Pricebook2> pricebooks = [select Id from Pricebook2 where Id = :pricebook.Id and Name like 'Test Pricebook%'];
		
		System.assertEquals(1, pricebooks.size(), 'Test pricebook counts don\'t match');
		
		//Add products to standard pricebook
		/*List<PricebookEntry> standardPricebookEntries = UTestData.getStandardPricebookEntries(products);
		
		insert standardPricebookEntries;
		
		standardPricebookEntries = [select Id from PricebookEntry where Id in :standardPricebookEntries];
		
		System.assertEquals(4, standardPricebookEntries.size(), 'Standard pricebook entry counts don\'t match');
		*/
		//Add products to test pricebook
		/*List<PricebookEntry> pricebookEntries = UTestData.getPricebookEntries(pricebook, products);
		
		insert pricebookEntries;
		
		pricebookEntries = [select Id from PricebookEntry where Id in :pricebookEntries];
		
		System.assertEquals(4, pricebookEntries.size(), 'Pricebook entry counts don\'t match');
		*/
		//Add opportunities
		/*
		List<Opportunity> opps = UTestData.getOpportunities(accounts);
		
		insert opps;
		
		opps = [select Id from Opportunity where Id in :opps];
		
		System.assertEquals(accounts.size(), opps.size(), 'Opportunity counts don\'t match');
		*/
		//Add opportunity line items
		/*
		List<OpportunityLineItem> oppLineItems = UTestData.getOpportunityLineItems(opps, pricebookEntries[0]);
		
		insert oppLineItems;
		
		oppLineItems = [select Id from OpportunityLineItem where Id in :oppLineItems];
		
		System.assertEquals(opps.size(), oppLineItems.size(), 'OpportunityLineItem counts don\'t match');
		*/
		//Add leads
		List<Lead> leads = UTestData.getLeads(numberOfLeads);
		
		for(Lead l : leads)
		{
			UTestData.addEmailToRecord(l, 'Email');			
		}
		
		insert leads;					
		
		leads = [select Id from Lead where Id in :leads];
		
		System.assertEquals(numberOfLeads, leads.size(), 'Lead counts don\'t match');
		
		//Add cases
		List<Case> cases = UTestData.getCases(accounts);
		
		insert cases;
		
		cases = [select Id from Case where Id in :cases];
		
		System.assertEquals(cases.size(), accounts.size(), 'Case counts don\'t match');
		
		//Add case comments
		List<CaseComment> caseComments = UTestData.getCaseComments(cases);
		
		insert caseComments;
		
		caseComments = [select Id from CaseComment where Id in :caseComments];
		
		System.assertEquals(caseComments.size(), cases.size(), 'Case comment counts don\'t match');
		
		//Add case attachments
		List<Attachment> attachments = UTestData.getAttachments(cases);
		
		insert attachments;
		
		attachments = [select Id from Attachment where Id in :attachments];
		
		System.assertEquals(attachments.size(), cases.size(), 'Attachment counts don\'t match');	
		
		/*
		//Add case email messages		
		List<EmailMessage> emailMessages = getCaseEmailMessages(cases, null);
		
		insert emailMessages;
		
		emailMessages = [select Id from EmailMessage where Id in :emailMessages];
		
		System.assertEquals(emailMessages.size(), cases.size(), 'Email message counts don\'t match');	

		//Add case email message attachments
		List<Attachment> emailMessageAttachments = getEmailMessageAttachments(emailMessages);
		
		insert emailMessageAttachments;
		
		emailMessageAttachments = [select Id from Attachment where Id in :emailMessageAttachments];
		
		System.assertEquals(emailMessageAttachments.size(), emailMessages.size(), 'Email message attachment counts don\'t match');	
		*/
		//Get open task (Just a touch)
		Task t1 = UTestData.getOpenTask(null, null, null);

		//Get completed task (Just a touch)
		Task t2 = UTestData.getCompletedTask(null, null, null);

		//Add a user			
		User u = UTestData.getUserRecord([select Id from Profile where Name = 'System Administrator' limit 1].Id);
				
		System.assert(u != null, 'User record is null');
		
		String rs1 = UTestData.generateRandomString();
		String rs2 = UTestData.generateRandomString(10);		
	}
}