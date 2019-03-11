public with sharing class  myKVHSupportController  
{   
    public boolean firstpage {get;set;}
    public Attachment attach {get;set;}
    public Case srvCase {get;set;}
    
    public List<SelectOption> radio1 {get;private set;}

    private map<string, string> ProductOrServiceMap = new map<string, string>();
    
    public String valueSelected 
    {
        get;
        set;
    }
    
    public myKVHSupportController(ApexPages.StandardController controller)
    {
        firstpage=true;
        srvCase = new Case();
        //added line jthom 1/30/14 Prevents IE11 issue see SF case #10161571
        //prepopulating the Description field seems to work, see URL below for description
        //http://salesforce.stackexchange.com/questions/22036/problem-rendering-textarea-inputfield-inputtextarea-in-pageblocktable-internet
        srvCase.Description = '     ';
        attach = new Attachment();
        
        radio1 = buildValues(new list<string>{'Browser problem - myKVH website does not work correctly','Browser problem - myKVH website does not work correctly',  
                                              'Data problem - my data is incorrect','Data problem - my data is incorrect',
                                              'New idea or suggestion','New idea or suggestion',
                                              'Other issue','Other issue'
                                              });
        
        ProductOrServiceMap.put('Browser problem - myKVH website does not work correctly','Browser Problem');   
        ProductOrServiceMap.put('Data problem - my data is incorrect','Data Problem');
        ProductOrServiceMap.put('New idea or suggestion','New Idea or Suggestion');
        ProductOrServiceMap.put('Other issue','Other issue');                                 
    }
        
    public PageReference CreateCase(){
        case aCase = new case(); 
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
        return nextButton();
    }
    
    public Pagereference backButton()
    {
        firstpage = true;
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
        
        firstpage = false;
        return null;
    }
    
    private Case buildCase()
    {
        Case c = srvCase;
        Id userId = UserInfo.getUserId();
        
        User u = [Select AccountId, ContactId from User where ID =:userId];
        
        c.AccountId = u.AccountId;
        c.ContactId = u.ContactId;
        c.Origin = 'Web';
        c.Type = 'myKVH Feedback';
        system.debug(valueSelected);
        c.RecordTypeId = PortalProductServiceRecordTypeMap__c.getAll().get('myKVH Support and Feedback').RecordTypeId__c;
        system.debug(c.RecordTypeId);
        c.Product_or_Service__c = ProductOrServiceMap.get(valueSelected); 
        
        c.User_Agent_String__c = ApexPages.currentPage().getHeaders().get('USER-AGENT');
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