/*************************************************************
 * Created By  : USER_NAME (GearsCRM)
 * Created Date: __/__/20__ 
 * Description : Controller Class SubmitProfessionalRequestController
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/
public with sharing class SubmitProfessionalRequestController 
{ 
	public boolean firstpage {get;set;}
	public Attachment attach {get;set;}
	public Case srvCase {get;set;}
	
	public SubmitProfessionalRequestController(ApexPages.StandardController controller)
	{
		firstpage=true;
		srvCase = new Case();
		attach = new Attachment();
	}
	
	public List<SelectOption> getAccounts()
	{
	   List<SelectOption> options = new List<SelectOption>();
	   Set<id> recids = new set<ID>();
	   
	   for(PlatformAccountRecordType__c setting: PlatformAccountRecordType__c.getAll().values())
	   		recids.add((id)setting.RecordTypeId__c);
		
		options.add(new SelectOption('','--Select--'));
		options.add(new SelectOption('','--Not Specified--'));
       for(Account a : [select id,name from Account 
       						where recordTypeId in :recids order by name Limit 998])
          options.add(new SelectOption(a.id, a.name));
         
       return options;
	}
	
	public PageReference CreateCase()
	{
		Case aCase; 
		try{
			aCase = buildCase();
			
			Database.DMLOptions dmo = new Database.DMLOptions();
			dmo.assignmentRuleHeader.useDefaultRule = true;
			
			aCase.setOptions(dmo);	
			insert aCase;
			
			InsertAttachment(aCase);
		}
		catch(Exception ex){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
			return null;
		}
		return new PageReference('/apex/my_Case_View?id=' + aCase.Id);
	}
	
	public Pagereference backButton()
	{
		firstpage = true;
		return null;
	}
	
	public PageReference nextButton()
	{
		firstpage = false;
		return null;
	}
	
	private static final string CASE_TYPE ='Professional Services Request';
	
	private Case buildCase()
	{
		Case c = srvCase;
		Id userId = UserInfo.getUserId();
		
		User u = [Select AccountId, ContactId from User where ID =:userId];
		
		c.AccountId = u.AccountId;
		c.ContactId = u.ContactId;
		c.Origin = 'Web';
		c.Type = CASE_TYPE;
		c.RecordTypeId = PortalProductServiceRecordTypeMap__c.getAll().get(CASE_TYPE).RecordTypeId__c;
		c.Product_or_Service__c = 'Custom Configuration'; 
			
		return c;
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
}