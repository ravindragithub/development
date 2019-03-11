/* ************************************************************
 * Created By  : USER_NAME (GearsCRM)
 * Created Date: __/__/20__ 
 * Description : Controller Class OrderNewAirtimeServiceController
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/
public with sharing class OrderNewAirtimeServiceController 
{   
    public boolean firstpage {get;set;}
    public boolean secondpage {get;set;}
    public Attachment attach {get;set;}
    public Case srvCase {get;set;}
    
    public List<SelectOption> radio1 {get;private set;}
    private PortalOrderNewAirtimeSettings__c nullSetting;
    
    public PortalOrderNewAirtimeSettings__c airTimeSetting 
    {
        get
        {
            if (valueSelected!=null)
            {
                
                return PortalOrderNewAirtimeSettings__c.getAll().get(valueSelected.replace(' Airtime Service Activation',''));
            }
            return nullSetting;
        }
        set;
    }   
    
    public String valueSelected 
    {
        get;
        set;
    }
    
    public OrderNewAirtimeServiceController(ApexPages.StandardController controller)
    {
        firstpage=true;
        secondpage=false;
        srvCase = new Case();
        //added line jthom 1/30/14 Prevents IE11 issue see SF case #10161571
        //prepopulating the Description field seems to work, see URL below for description
        //http://salesforce.stackexchange.com/questions/22036/problem-rendering-textarea-inputfield-inputtextarea-in-pageblocktable-internet
        srvCase.Description = '     ';
        attach = new Attachment();
        
        nullSetting = new PortalOrderNewAirtimeSettings__c();
        
        radio1 = buildValues(new list<string>{'mini-VSAT Broadband Airtime Service Activation', 'mini-VSAT Broadband Airtime Service Activation',
                                              'Inmarsat Airtime Service Activation','Inmarsat Airtime Service Activation',
                                              'Iridium Airtime Service Activation','Iridium Airtime Service Activation'
                                              });

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
        if(firstpage)
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
        if(secondpage)
        {
            secondPage=false;
            firstpage=true;
        } 
        else if (!secondpage)
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
    
    private static final string CASE_TYPE = 'Order a New Airtime Service';
    private static final string CASE_ORIGIN = 'Web';
    private static final string REMOVESTRING = 'Service Activation';
    
    private Case buildCase()
    {
        Case c = srvCase;
        Id userId = UserInfo.getUserId();
        
        User u = [Select AccountId, ContactId from User where ID =:userId];
        
        c.AccountId = u.AccountId;
        c.ContactId = u.ContactId;
        c.Origin = CASE_ORIGIN;
        c.Type = CASE_TYPE;
        c.Subject = getSubject();
        string lookup = valueSelected.replace(REMOVESTRING,'').trim();
        system.debug(lookup);
        c.RecordTypeId = PortalProductServiceRecordTypeMap__c.getAll().get(lookup).RecordTypeId__c;
        
        c.Product_or_Service__c = valueSelected; 
            
        return c;
    }
    
    private string getSubject()
    {
        if(valueSelected=='Iridium Airtime Service Activation')
            return 'Order a New Airtime Service';
        return valueSelected;
    }
    
    private void InsertAttachment(Case aCase)
    {
        if(attach.Body==null || attach.Name==null)
        {
            return;
        }
        attach.ParentId = aCase.Id;
        //try{
        insert attach;
        /*}finally
        {
            attach = new Attachment();
        }*/
        
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