//@isTest
public class UTestData 
{
	public class CustomException extends Exception {}
	
	public static String getTimestamp(DateTime dt)
	{
		if(dt == null)
		{
			dt = DateTime.now();
		}
		
		String timestamp = '';
		
		timestamp += dt.year();
		timestamp += dt.month();
		timestamp += dt.day();
		timestamp += dt.hour();
		timestamp += dt.minute();
		timestamp += dt.second();
		timestamp += dt.millisecond();
		
		return timestamp;
	}
	/* Slash and burn unused methods.... OR create test data and test!
	public static List<SObject> getListOfCustomSettings(String customSettingName, Integer numberOfRows)
	{
		List<SObject> customSettings = new List<SObject>();
		
		for(Integer i = 0; i < numberOfRows; i++)
		{
			customSettings.add(getCustomSetting(customSettingName));
		}
		
		return customSettings;
	}
	
	public static SObject getCustomSetting(String customSettingName)
	{
		Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(customSettingName);

		SObject customSetting = sObjectType.newSObject();

		if(customSetting.Id == null)
		{
			customSetting.put('SetupOwnerId', UserInfo.getOrganizationId());
			customSetting.put('Name', 'Default');
		}	
		
		return customSetting;						
	}
	
	public static Group getGroup(String groupName, String groupType)
	{
		Set<String> allowedGroupTypes = new Set<String>();
		
		Schema.Describefieldresult fieldResult = Group.Type.getDescribe();
		List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();		
		
		for(Schema.PicklistEntry picklistValue : picklistValues)
		{
			if(allowedGroupTypes.contains(picklistValue.getValue()) == false)
			{
				String value = picklistValue.getValue();
				
				if(value != null && value.trim().length() > 0)
				{
					allowedGroupTypes.add(value.toUpperCase());
				}
			}
		}
		
		if(allowedGroupTypes.contains(groupType.trim().toUpperCase()) == false)
		{
			throw new CustomException('UTestData.getGroup - Invalid group type');
		}
		
		Group groupRecord = new Group();
		
		groupRecord.Type = groupType;
		groupRecord.Name = groupName;
		
		return groupRecord;
	}
	
	//Must first create and insert the group using something like getGroup()
	public static QueueSObject getQueue(Group groupRecord, String sObjectType)
	{
		QueueSObject queue = new QueueSObject();
		
		queue.SobjectType = sObjectType;
		queue.QueueId = groupRecord.Id;
		
		return queue;
	}	
	*/
	/*
	public static List<Attachment> getEmailMessageAttachments(List<EmailMessage> records)
	{	
		return getAttachments(records);
	}
		
	public static List<EmailMessage> getCaseEmailMessages(List<Case> records, User u)
	{
		List<EmailMessage> emailMessages = getEmailMessages(records, u);
		
		if(records.size() == emailMessages.size())
		{
			for(Integer i = 0; i < records.size(); i++)
			{
				EmailMessage em = emailMessages[i];
				Case c = records[i];
																
				em.HtmlBody = em.HtmlBody + ' ' + c.Email_To_Case_Reference_Number__c;
				em.TextBody = em.TextBody + ' ' + c.Email_To_Case_Reference_Number__c;
			}
		}
		else
		{
			throw new CustomException('UTestData.getCaseEmailMessages record counts don\'t match');
		}
		
		return emailMessages;
	}
	
	public static List<EmailMessage> getEmailMessages(List<SObject> records, User u)
	{		
		Integer counter = 0;
		Date messageDate = Date.today();
		List<EmailMessage> emailMessages = new List<EmailMessage>();
		String emailBody = 'This is a test email message';
		 
		for(SObject record : records)
		{
			EmailMessage em = new EmailMessage();
			/*
			ToAddress 
			Incoming 
			HtmlBody 
			Headers 
			HasAttachment 
			CcAddress 
			BccAddress 
			ActivityId
			*/
			/*
			em.toAddress = 'somedude@somemail.com';
			em.ParentId = record.Id;
			em.MessageDate = messageDate;
			
			if(u != null)
			{
				em.FromName = u.Name;
				em.FromAddress = u.Email;
			}
			else
			{			
				em.FromName = UserInfo.getName();
				em.FromAddress = UserInfo.getUserName();
			}
			
			em.Subject = 'Test Email ' + (counter + 1);						
			em.Status = '0'; //Status is 0 - 4 when you look at the field using the schema browser			
			em.TextBody = emailBody;
			em.HtmlBody = emailBody;
			
			emailMessages.add(em);
			
			counter++;
		}
				
		return emailMessages;
	}	
	*/
	public static List<CaseComment> getCaseComments(List<Case> records)
	{
		List<CaseComment> caseComments = new List<CaseComment>();
		
		for(Case record : records)
		{		
			caseComments.add(getCaseComment(record));
		}
				
		return caseComments;
	}
	
	public static CaseComment getCaseComment(Case record)
	{		
		String commentBody = 'This is a test case comment';
		 
		CaseComment cc = new CaseComment();
			
		cc.ParentId = record.Id;
		cc.IsPublished = true; 
		cc.CommentBody = commentBody;
					
		return cc;
	}
	
	public static Task getOpenTask(String subject, String whoId, String whatId)
	{		
		Task t = new Task();
		
		if(subject != null && subject.trim().length() > 0)
		{
			t.Subject = subject;
		}
		else
		{
			t.Subject = 'Test Open Task';
		}
		
		if(whoId != null && whoId.trim().length() > 0)
		{
			t.whoId = whoId;
		}
		
		if(whatId != null && whatId.trim().length() > 0)
		{
			t.whatId = whatId;
		}
		
		t.ActivityDate = Date.today();
		t.Description = t.Subject + ' - Test Description on ' + t.ActivityDate;
					
		return t;
	}	
	
	public static Task getCompletedTask(String subject, String whoId, String whatId)
	{	
		Task t = getOpenTask(subject, whoId, whatId);
		
		t.Status = 'Completed';
		
		return t;
	}	
	
	public static List<Attachment> getAttachments(List<SObject> records)
	{
		List<Attachment> attachments = new List<Attachment>();
		String attachmentBody = 'This is a test attachment';
		 
		for(SObject record : records)
		{		
			attachments.add(getAttachment(record));
		}
				
		return attachments;
	}
	
	public static Attachment getAttachment(SObject record)
	{		
		String attachmentBody = 'This is a test attachment';
		 
		Attachment a = new Attachment();
			
		a.ParentId = record.Id;
		a.Name = 'Test Attachment';
		a.Description = 'Test attachment description';
		a.ContentType = 'Text';			
		a.Body = Blob.valueOf(attachmentBody);
					
		return a;
	}	
		
	public static List<Lead> getLeads(Integer numberOfRecords)
	{
		List<Lead> leads = new List<Lead>();
		 
		for(Integer i = 0; i < numberOfRecords; i++)
		{
			Lead l = new Lead();
			
			l.Company = 'Test Company ' + (i + 1);
			l.FirstName = 'Test';
			l.LastName = 'Lead ' + (i + 1);
			l.Status = 'New';
			l.Country = 'US';			
			
			leads.add(l);
		}
				
		return leads;
	}
	
	public static List<Account> getAccounts(Integer numberOfRecords)
	{
		List<Account> accounts = new List<Account>();		
		String timestamp = getTimestamp(null);
		
		for(Integer i = 0; i < numberOfRecords; i++)
		{
			
			Account a = new Account();
			
			a.Name = 'Test Account ' + timestamp + ' #' + (i + 1);
			a.BillingCountry = 'US';
			a.BillingStreet = '1 Main Street';
			a.Billingcity = 'Ashland';
			a.BillingState = 'MA';
			a.BillingPostalCode = '01721';
			//a.Location_ID_field__c = 'Test Loc';			
			
			accounts.add(a);
		}
		
		return accounts;
	}	
	
	public static List<Contact> getContacts(List<Account> accounts, Integer numberOfContactsPerAccount)
	{
		List<Contact> contacts = new List<Contact>();
		Integer counter = 1;	
		String timestamp = getTimestamp(null);	
		
		for(Account a : accounts)
		{
			for(Integer i = 0; i < numberOfContactsPerAccount; i++)
			{
				
				Contact c = new Contact();
				
				c.AccountId = a.Id;
				c.FirstName = 'Test';			
				c.LastName = 'Contact ' + timestamp + ' #' + counter;
				
				contacts.add(c);
				
				counter++;
			}
		}
		
		return contacts;
	}
		
	public static List<Case> getCases(List<Account> accounts)
	{
		List<Case> cases = new List<Case>();
		Integer counter = 1;	
		String timestamp = getTimestamp(null);	
		
		for(Account a : accounts)
		{
			Case c = new Case();
				
			c.AccountId = a.Id;				
				
			cases.add(c);
				
			counter++;			
		}
		
		return cases;
	}		
	/*
	public static List<Opportunity> getOpportunities(List<Account> accounts)
	{
		List<Opportunity> opportunities = new List<Opportunity>();
		Integer counter = 1;		
		
		for(Account a : accounts)
		{
			Opportunity opp = new Opportunity();
				
			opp.AccountId = a.Id;
			opp.Name = 'Test Opportunity #' + counter;
			opp.CloseDate = Date.today();
			opp.StageName = 'Prospect';
			
			opportunities.add(opp);
			
			counter++;			
		}
		
		return opportunities;
	}	
	
	public static List<OpportunityLineItem> getOpportunityLineItems(List<Opportunity> opps, PricebookEntry pricebookEntry)
	{
		List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
		Integer counter = 1;		
		
		for(Opportunity opp : opps)
		{
			OpportunityLineItem oli = new OpportunityLineItem();
				
			oli.OpportunityId = opp.Id;		
			oli.PricebookEntryId = pricebookEntry.Id;	
			oli.Quantity = 1;
			oli.TotalPrice = 10;
			
			opportunityLineItems.add(oli);
			
			counter++;			
		}
		
		return opportunityLineItems;
	}
	*/
	public static List<Product2> getProducts(Integer numberOfRecords)
	{
		List<Product2> products = new List<Product2>();		
		
		for(Integer i = 0; i < numberOfRecords; i++)
		{			
			Product2 p = new Product2();
			
			p.Name = 'Test Product ' + (i + 1);	
			p.IsActive = true;
			p.Description = 'Test Product ' + (i + 1) + ' Description';	
			p.ProductCode = String.valueOf(i + 1);
			
			products.add(p);
		}
		
		return products;
	}
	
	public static Pricebook2 getPricebook(String pricebookName)
	{
		Pricebook2 pb = new Pricebook2();
			
		pb.Name = pricebookName;	
		pb.IsActive = true;		
		
		return pb;
	}
	/*
	public static List<PricebookEntry> getStandardPricebookEntries(List<Product2> products)
	{
		Pricebook2 standardPricebook = [select Id from Pricebook2 where Name = 'Standard Price Book' limit 1];
		
		return getPricebookEntries(standardPricebook, products);
	}	
	
	public static List<PricebookEntry> getPricebookEntries(Pricebook2 pricebook, List<Product2> products)
	{
		List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();		
		Integer counter = 1;
		
		for(Product2 product : products)
		{			
			PricebookEntry pe = new PricebookEntry();
			
			pe.Pricebook2Id = pricebook.Id;
			pe.Product2Id = product.Id;			
			pe.IsActive = true;			
			pe.UnitPrice = 1.00 * counter;
			//pe.UseStandardPrice = true;	
			
			pricebookEntries.add(pe);
			
			counter++;
		}
		
		return pricebookEntries;
	}
	*/
	public static void addEmailToRecords(List<SObject> records, String emailFieldName)
	{
		addEmailToRecords(records, emailFieldName, null);
	}
	
	public static void addEmailToRecords(List<SObject> records, String emailFieldName, String emailBeforeAtSign)
	{		
		Integer counter = 1;
		
		for(SObject record : records)
		{		
			addEmailToRecord(record, emailFieldName, 'test' + counter);
			
			counter++;
		}
	}	
	
	public static void addEmailToRecord(SObject record, String emailFieldName)
	{
		addEmailToRecord(record, emailFieldName, null);
	}
	
	public static void addEmailToRecord(SObject record, String emailFieldName, String emailBeforeAtSign)
	{		
		Date todaysDate = Date.today();
		String email = null;
		
		if(emailBeforeAtSign != null && emailBeforeAtSign.length() > 0)
		{
			email = emailBeforeAtSign + '@' + todaysDate.year() + todaysDate.month() + todaysDate.day() + '.test';
		}
		else
		{
			email = 'test' + '@' + todaysDate.year() + todaysDate.month() + todaysDate.day() + '.test';
		}
		
		addValueToSObject(record, emailFieldName, email);		
	}	
	/*
	public static void addValueToSObjects(List<SObject> records, Map<String, Object> keyValueMap)	
	{
		for(SObject record : records)
		{
			for(String key : keyValueMap.keySet())
			{
				addValueToSObject(record, key, keyValueMap.get(key));
			}
		}
	}	
	*/
	public static void addValueToSObject(SObject record, String fieldName, Object value)	
	{
		record.put(fieldName, value);
	}	
	
	public static User getUserRecord(String profileId)
	{
		DateTime currentDateTime = DateTime.now();
		String dateString = '' + currentDateTime.year() + 
								 currentDateTime.month() + 
								 currentDateTime.day() + 
								 currentDateTime.hour() + 
								 currentDateTime.minute() + 
								 currentDateTime.second() + 
								 currentDateTime.millisecond();
		String username = 'testuser' + dateString + '@test.test';
		String email = username;
		 
		return getUserRecord(username, email, profileId);
	}		
	
	public static User getUserRecord(String username, String email, String profileId)
	{
		User u = new User();
		
		String alias = username.substring(0, username.indexOf('@'));
		
		if(alias.trim().length() > 8)
		{
			alias = alias.substring(0, 8);
		}
		
        System.debug('Alias = ' + alias);
         
        u.Alias = alias;
        u.Email = username;
        u.EmailEncodingKey = 'UTF-8';
        u.Firstname = 'Test';
        u.Lastname = 'User';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.Profileid = profileId;
        u.TimezoneSidKey = 'America/Los_Angeles';
        u.Username = username;
                 
		return u;
	}
	/*
	public static String getStandardProfileId(String profileName)
	{		
		return [select Id from Profile where UserType = 'Standard' and Name = :profileName].Id;		
	}
	*/
	public static Case getCase()
	{
		
			Case c = new Case();
			
			/*
			//Add accounts
				List<Account> accounts = getAccounts(numberOfAccounts);				
				
				insert accounts;					
				
				accounts = [select Id from Account where Id in :accounts];
				
				System.assertEquals(numberOfAccounts, accounts.size(), 'Account counts don\'t match');
				
				//Add contacts
				List<Contact> contacts = getContacts(accounts, numberOfContactsPerAccount);
			
			*/
			
			c.Subject = 'this is just a test case';
    		c.Description = 'this is a test description\nof what the case should be like';
			//c.ContactId = [select id from contact limit 1].id;	
			List<Account> a = getAccounts(1);
			insert a;
			
			List<Contact> lc = UTestData.getContacts(a, 1);
			c.ContactId = lc[0].id;
			insert c;
						
		return c;
	}
	
	
	/*
	
	
	public static list<LP__Chat_Transcript__c> getLPChat(Integer numberOfRecords ){
	
		LP__Chat_transcript__c  l = new LP__Chat_transcript__c ();
		list<LP__Chat_transcript__c > listLPC = new list<LP__Chat_transcript__c >();
		
		for(Integer i = 0; i < numberOfRecords; i++)
		{			
			LP__Chat_Transcript__c p = new LP__Chat_Transcript__c();
			p.platform = 'W7';
			p.browser  = 'IE9';
			p.chat_duration__c = (i + 10);
			p.operator_message_count__c = (i + 1);
			p.visitor_message_count__c = (i + 1);
						
			listLPC.add(p);
		}
		
		return listLPC;
	
	
	}
	

	*/
	/*	
	public static User getUser(){
		User u = new User();
		u.firstname = 'Joe';
		u.LastName = 'Dirte';
    	String random = generateRandomString(8);
    	u.Username = 'joe'+random+'@joetestercorp1000.com';
    	u.Email = 'joetester'+random+'@joetestercorp1000.com';
    	u.Alias = random;
    	u.CommunityNickname = u.Alias;
    	u.TimeZoneSidKey = 'GMT';
    	u.LocaleSidKey = 'en_US';
    	u.EmailEncodingKey = 'ISO-8859-1';
    	u.ProfileId = [select Id from Profile where Name = 'System Administrator' limit 1][0].Id;
    	u.LanguageLocaleKey = 'en_US';    	
		
		insert u;
		
		return u;
	
	}
	*/
	
	
	public static String generateRandomString(){return generateRandomString(null);}
	public static String generateRandomString(Integer length){
    	if(length == null) length = 1+Math.round( Math.random() * 8 );
    	String characters = 'abcdefghijklmnopqrstuvwxyz1234567890';
    	String returnString = '';
    	while(returnString.length() < length){
    		Integer charpos = Math.round( Math.random() * (characters.length()-1) );
    		returnString += characters.substring( charpos , charpos+1 );
    	}
    	return returnString;
    }
}