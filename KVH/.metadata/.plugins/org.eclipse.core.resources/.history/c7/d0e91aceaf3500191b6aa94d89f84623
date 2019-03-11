public with sharing class  ChangeExistingAddServiceController 
{	
	public boolean firstpage {get;set;}
	public boolean secondpage {get;set;}
	public Attachment attach {get;set;}
	public Case srvCase {get;set;}
	
	public List<SelectOption> radio1 {get;private set;}
	public List<SelectOption> radio2 {get;private set;}
	public List<SelectOption> radio3 {get;private set;}
	public List<SelectOption> radio4 {get;private set;}
	public List<SelectOption> radio5 {get;private set;}
	
	private map<string, string> ProductOrServiceMap = new map<string, string>();
	
	public String valueSelected 
	{
		get;
		set;
	}
	
	public ChangeExistingAddServiceController(ApexPages.StandardController controller)
	{
		firstpage=true;
		secondpage=false;
		srvCase = new Case();
		//added line jthom 1/30/14 Prevents IE11 issue see SF case #10161571
		//prepopulating the Description field seems to work, see URL below for description
		//http://salesforce.stackexchange.com/questions/22036/problem-rendering-textarea-inputfield-inputtextarea-in-pageblocktable-internet
		srvCase.Description = '	 ';
		attach = new Attachment();
		
		radio1 = buildValues(new list<string>{'Reactivate a suspended service','Reactivate a suspended service',
											  'Suspend a service', 'Suspend a service',
											  'Change an airtime plan', 'Change an airtime plan',
											  'Terminate a service','Terminate a service',
											  'Add GlobalCare', 'Add GlobalCare'});
		
		radio2 = buildValues(new list<string>{'Add Authorized Representative(s) to airtime account','Add Authorized Representative(s) to airtime account'});
											  
		radio3 = buildValues(new list<string>{'Update account or credit card information (new contact information, etc)','Update account or credit card information (new contact information, etc)',
											  'Remove or submit changes to existing authorized representatives','Remove or submit changes to existing authorized representatives'});		
		
		radio4 = buildValues(new list<string>{'Submit a Purchase Order for Prepaid Services / Crew Calling Cards','Submit a Purchase Order for Prepaid Services / Crew Calling Cards'});
		
		radio5 = buildValues(new list<string>{'Other','Other'});
		
		ProductOrServiceMap.put('Reactivate a suspended service','Airtime Services Change');
		ProductOrServiceMap.put('Suspend a service','Airtime Services Change');
		ProductOrServiceMap.put('Change an airtime plan','Airtime Services Change');
		ProductOrServiceMap.put('Terminate a service','Airtime Services Change');
		ProductOrServiceMap.put('Add GlobalCare','Airtime Services Change');
		 
		ProductOrServiceMap.put('Add Authorized Representative(s) to airtime account','Add Authorized Representative(s)');
		
		//ProductOrServiceMap.put('Administrative account change','Administrative Account Change');
		
		ProductOrServiceMap.put('Update account or credit card information (new contact information, etc)','Administrative Account Change');
		
		ProductOrServiceMap.put('Remove or submit changes to existing authorized representatives','Administrative Account Change');
		
		ProductOrServiceMap.put('Submit a Purchase Order for Prepaid Services / Crew Calling Cards','Purchase Prepaid Services Card');
		//ProductOrServiceMap.put('Purchase Prepaid Service Accounts','Purchase Prepaid Services Card');
		
		ProductOrServiceMap.put('Other', 'Other Changes');

												  
	}
	
	public List<SelectOption> getAccounts()
	{
		List<SelectOption> options = new List<SelectOption>();
		Set<id> recids = new set<ID>();
		
		for(PlatformAccountRecordType__c setting: PlatformAccountRecordType__c.getAll().values()){
				recids.add((id)setting.RecordTypeId__c);
		}
		
		options.add(new SelectOption('','--Select--'));
		options.add(new SelectOption('','--Not Specified--'));
		
		for(Account a : [select id,name from Account where recordTypeId in :recids order by name Limit 998]){
			options.add(new SelectOption(a.id, a.name));
		}
		return options;
	}
	
	public PageReference CreateCase()
	{
		Case aCase; 
		try
		{
			aCase = buildCase();
			
			Database.DMLOptions dmo = new Database.DMLOptions();
			dmo.assignmentRuleHeader.useDefaultRule = true;
			
			aCase.setOptions(dmo);  
			insert aCase;
			
			InsertAttachment(aCase);
		}
		catch(Exception ex)
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
			return null;
		}
		return new PageReference('/apex/my_Case_View?id=' + aCase.Id);
	}
	
	public Pagereference setSelection()
	{		
		if(valueSelected == 'Add Authorized Representative(s) to airtime account' && firstpage)
		{
			secondPage=true;
			firstpage =false;
		} 
		else
		{
			secondpage = false;
			firstpage =false;
		}
		return nextButton();
	}
	
	public Pagereference backButton()
	{
		if(valueSelected == 'Add Authorized Representative(s) to airtime account' && secondpage)
		{
			secondPage=false;
			firstpage=true;
		} 
		else if (valueSelected == 'Add Authorized Representative(s) to airtime account' && !secondpage)
		{
			secondpage=true;
			firstpage=false;
		}
		else
		{
			firstpage = true;
		}
		
		return null;
	}
	
	public PageReference nextButton()
	{
		system.debug(valueSelected);
		if(string.isEmpty(valueSelected) && firstpage)
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select a Product or Service'));
			return null;
		}
		
		return null;
	}
	
	private static final string CASE_TYPE = 'Change or Add an Airtime Service';
	private static final string CASE_ORIGIN = 'Web';
	
	private Case buildCase()
	{
		Case c = srvCase;
		Id userId = UserInfo.getUserId();
		
		User u = [Select AccountId, ContactId from User where ID =:userId];
		
		c.AccountId = u.AccountId;
		c.ContactId = u.ContactId;
		c.Origin = CASE_ORIGIN;
		c.Type = CASE_TYPE;
		c.RecordTypeId = PortalProductServiceRecordTypeMap__c.getAll().get(CASE_TYPE).RecordTypeId__c;
		

		//c.Product_or_Service_Detail__c = valueSelected;
		c.Product_or_Service__c = getProductOrServiceLine(); 
			
		return c;
	}
	
	private string getProductOrServiceLine()
	{
		return ProductOrServiceMap.get(valueSelected);
	}
	
	private void InsertAttachment(Case aCase)
	{
		if(attach.Body==null || attach.Name==null)
		{
			return;
		}
		attach.ParentId = aCase.Id;
		insert attach;
	}
	
	private SelectOption buildSelectOption(string value, string label)
	{
		return new SelectOption(value, label);
	}
	
	private SelectOption buildSelectOption(string value)
	{
		return new SelectOption(value, value);
	}
	
	private List<SelectOption> buildValues(list<string> buildOut)
	{
		List<SelectOption> options = new List<SelectOption>();
		for(Integer i = 0; i< buildOut.size(); i=i+2)
		{
			options.add(buildSelectOption(buildOut[i],buildOut[i+1]));
		}
		return options;
	}
}