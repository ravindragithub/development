public with sharing class RequestInfoExistingServiceController
{ 
    public boolean attachRender {get;set;}
    public boolean firstpage {get;set;}
    public Boolean displayPopup {get;set;}
    public Attachment attach {get;set;}
    public Id caseId {get;set;}
    public Case srvCase {get;set;}
    public boolean serviceProvider {get;set;}
    
    public List<SelectOption> radio1 {get;private set;}
    public List<SelectOption> radio2 {get;private set;}
    public List<SelectOption> radio3 {get;private set;}
    public List<SelectOption> radio4 {get;private set;}
    public List<SelectOption> radio5 {get;private set;}
    
    private map<string, string> ProductOrServiceMap = new map<string, string>();
    private map<string, string> ProductOrServiceDetailsMap = new map<string, string>();
    
    public String valueSelected {get;set;}
    
    public RequestInfoExistingServiceController(ApexPages.StandardController controller)
    {
        string userId = UserInfo.getUserId();
        User u = [SELECT Contact.Account.Partner_Role__c FROM User WHERE Id =:userId];
        if(u.Contact.Account.Partner_Role__c == 'Service Provider'){
            serviceProvider = true;
        } else {
            serviceProvider = false;
        }
        firstpage=true;
        srvCase = new Case();
        //added line jthom 1/30/14 Prevents IE11 issue see SF case #10161571
        //prepopulating the Description field seems to work, see URL below for description
        //http://salesforce.stackexchange.com/questions/22036/problem-rendering-textarea-inputfield-inputtextarea-in-pageblocktable-internet
        srvCase.Description = '';
        attach = new Attachment();
        
        radio1 = buildValues(new list<string>{'Questions about an invoice you received','Questions about an invoice you received'});
        
        radio2 = buildValues(new list<string>{'Questions about a high usage alert you received','Questions about a high usage alert you received'});
                                              
        radio3 = buildValues(new list<string>{'Questions about policies (such as suspension or plan change policies)','Questions about policies (such as suspension or plan change policies)', 
                                              'Questions about available services (e.g. airtime rate plans, IP-MobileCast, OneCare, Vessel Tracking, Crew Calling, etc.)', 'Questions about available services (e.g. airtime rate plans, IP-MobileCast, OneCare, Vessel Tracking, Crew Calling, etc.)',
                                              'Questions about activation forms','Questions about activation forms',
                                              'General question or feedback','General question or feedback'}); 
        radio4 = buildValues(new list<string>{'Questions about a high usage alert you received','Questions about a high usage alert'});
        radio5 = buildValues(new list<string>{'High usage', 'High usage', 'Billing issue','Billing issue', 'Airtime account change', 'Airtime account change'});
        
        ProductOrServiceMap.put('Questions about an invoice you received', 'Billing Inquiry or Dispute');
        ProductOrServiceMap.put('Billing issue', 'Billing Inquiry or Dispute');
        ProductOrServiceMap.put('Questions about a high usage alert you received', 'High Usage Alert Inquiry');
        ProductOrServiceMap.put('High usage', 'High Usage Alert Inquiry');
        ProductOrServiceMap.put('Questions about policies (such as suspension or plan change policies)', 'General Account or Service Inquiry');
        ProductOrServiceMap.put('Questions about available services (e.g. airtime rate plans, IP-MobileCast, OneCare, Vessel Tracking, Crew Calling, etc.)', 'General Account or Service Inquiry');
        ProductOrServiceMap.put('Questions about activation forms', 'General Account or Service Inquiry');
        ProductOrServiceMap.put('General question or feedback', 'General Account or Service Inquiry');
        ProductOrServiceMap.put('Airtime account change', 'General Account or Service Inquiry');
        
        ProductOrServiceDetailsMap.put('Questions about an invoice you received', 'Questions about an invoice you received');
        ProductOrServiceDetailsMap.put('Questions about a high usage alert you received', 'Questions about a high usage alert you received');
        ProductOrServiceDetailsMap.put('High usage', '');
        ProductOrServiceDetailsMap.put('Questions about policies (such as suspension or plan change policies)', 'Questions about policies (such as suspension or plan change policies)');
        ProductOrServiceDetailsMap.put('Questions about available services (e.g. airtime rate plans, IP-MobileCast, OneCare, Vessel Tracking, Crew Calling, etc.)', 'Questions about available services (e.g. airtime rate plans, GlobalCare)');
        ProductOrServiceDetailsMap.put('Questions about activation forms', 'Questions about activation forms');
        ProductOrServiceDetailsMap.put('General question or feedback', 'General questions');
        ProductOrServiceDetailsMap.put('Airtime account change', 'General questions');
        ProductOrServiceDetailsMap.put('Billing issue', '');
                                                  
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
            
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
            return null;
        }
        return new PageReference('/apex/my_Case_View?id=' + aCase.Id);
    }
    public PageReference CreateCasePartner(){
        Case aCase; 
        String URL = Label.Community_URL;
        string comm = Label.Community_Prefix;
        try{
            aCase = buildCase();
            aCase.Portal_View__c = '{!$User.Portal_View__c}';
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            
            aCase.setOptions(dmo);  
            insert aCase;    
            
            InsertAttachment(aCase);
            PageReference pageref = new PageReference(URL + '/' + comm + '/s/mycaseview?recordid=' + aCase.Id);
            return pageref;
        }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
            }
        
        PageReference pageref = new PageReference(URL + '/' + comm + '/s/supportlanding');
        return pageref;
        }
    
    public Pagereference setSelection()
    {       
        system.debug(valueSelected);
        if(string.isEmpty(valueSelected))
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select a Product or Service'));
            return null;
        }
        firstPage = false;
        return null;
    }
    public void showAttach()
    {       
        attachRender = true;
    }
    
    public Pagereference backButton()
    {
        firstpage = true;
        return null;
    }
    public PageReference goBackToMain(){
        return new PageReference(Label.Community_URL + '/' + Label.Community_Prefix + '/s/supportlanding');
    }
    
    private static final string CASE_TYPE = 'Information on an Existing Service';
    
    private Case buildCase()
    {
        Group AIRTIMEQUEUE = [Select Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Airtime_Services_Queue'];
        Case c = srvCase;
        Id userId = UserInfo.getUserId();
        User u = [Select AccountId, ContactId, Portal_View__c from User where ID =:userId];
        c.AccountId = u.AccountId;
        c.ContactId = u.ContactId;
        c.OwnerId = AIRTIMEQUEUE.Id;
        c.Origin = 'Web';
        c.Type = CASE_TYPE;
        c.RecordTypeId = PortalProductServiceRecordTypeMap__c.getAll().get(CASE_TYPE).RecordTypeId__c;
        system.debug(valueselected + ' 1' + ProductOrServiceMap.get(valueSelected) + ' 2' + ProductOrServiceDetailsMap.get(valueSelected));
        c.Product_or_Service__c = ProductOrServiceMap.get(valueSelected); 
        c.Product_or_Service_Detail__c = ProductOrServiceDetailsMap.get(valueSelected);
        c.Case_Symptom__c = valueselected;
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
    
    private SelectOption buildSelectOption(string value, string label)
    {
        return new SelectOption(value, label);
    }
    
    public SelectOption buildSelectOption(string value)
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