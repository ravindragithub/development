public with sharing class  ReportServiceProductProblemController_P {
   
    public boolean firstpage {get;set;}
    public Attachment attach {get;set;}
    public Case srvCase {get;set;}
    
    public List<SelectOption> radio1 {get;private set;}
    public List<SelectOption> radio2 {get;private set;}
    public List<SelectOption> radio3 {get;private set;}
    public List<SelectOption> radio4 {get;private set;}
    public List<SelectOption> radio5 {get;private set;}
    
    private map<string, string> ProductOrServiceMap = new map<string, string>();
    private map<string, string> valueSelectedLookupMap = new map<string, string>();
    
    public String valueSelected 
    {
        get;
        set;
    }
    
    public String valueSelectedLookup
    {
        get{return valueSelectedLookupMap.get(valueSelected);}
    }
    
    public ReportServiceProductProblemController_P(ApexPages.StandardController controller)
    {
        firstpage=true;
        srvCase = new Case();
        //added line jthom 1/30/14 Prevents IE11 issue see SF case #10161571
        //prepopulating the Description field seems to work, see URL below for description
        //http://salesforce.stackexchange.com/questions/22036/problem-rendering-textarea-inputfield-inputtextarea-in-pageblocktable-internet
        srvCase.Description = '     ';
        attach = new Attachment();
        
        radio1 = buildValues(new list<string>{'KVH Mini-VSAT','KVH mini-VSAT Broadband (TracPhone V-Series, V-IP Series)',  
                                              'Inmarsat','Inmarsat (TracPhone Fleet, Mini-M, Fleetbroadband)',
                                              'Iridium','Iridium (Pilot)'});
        
        radio2 = buildValues(new list<string>{'Standalone CommBox (C2, R8)','Standalone CommBox (C2, R8, Hub)'
                                             });
                                              
        radio3 = buildValues(new list<string>{'Communications', 'Communications: VoIP, Crew Calling, OnGo Fax, GSM Remote Support Module',
                                              'Commbox','CommBox "Quick" Software Applications (QuickBasic, QuickWeb, QuickCrew, QuickFile, QuickMail, QuickComplete)'});       
        
        radio4 = buildValues(new list<string>{'Antenna Products','TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products'});
        radio5 = buildValues(new list<string>{'Digital Compasses','Digital Compasses'});
        
        valueSelectedLookupMap.put('KVH Mini-VSAT', 'KVH mini-VSAT Broadband (TracPhone V-Series, V-IP Series)');
        valueSelectedLookupMap.put('Inmarsat', 'Inmarsat (TracPhone Fleet, Mini-M, Fleetbroadband)');
        valueSelectedLookupMap.put('Standalone CommBox (C2, R8)', 'Standalone CommBox (C2, R8, Hub)');
        valueSelectedLookupMap.put('Iridium', 'Iridium (Pilot)');
        valueSelectedLookupMap.put('Communications', 'Communications: VoIP, Crew Calling, OnGo Fax, GSM Remote Support Module');
        valueSelectedLookupMap.put('Commbox','Commbox: (Quick X) Software Applications');
        valueSelectedLookupMap.put('Antenna Products', 'TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products');
        valueSelectedLookupMap.put('Digital Compasses', 'Digital Compasses');
        
        
        ProductOrServiceMap.put('KVH Mini-VSAT', 'KVH mini-VSAT Broadband (TracPhone V-Series, V-IP Series)');
        ProductOrServiceMap.put('Inmarsat', 'Inmarsat (TracPhone Fleet, Mini-M, FleetBroadband)');
        ProductOrServiceMap.put('Standalone CommBox (C2, R8)', 'Standalone CommBox (C2, R8, Hub)'); //check recordtypeId
        ProductOrServiceMap.put('Iridium', 'Iridium (Pilot)');
        ProductOrServiceMap.put('Communications', 'Communications: VoIP, Crew Calling, OnGo Fax, GSM Remote Support Module');
        ProductOrServiceMap.put('Commbox','CommBox: "Quick" Software');
        ProductOrServiceMap.put('Antenna Products', 'TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products');
        ProductOrServiceMap.put('Digital Compasses', 'Digital Compasses');                                        
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
        c.Type = 'Report a Service or Product Problem';
        system.debug(valueSelected +':'+ ProductOrServiceMap.containskey(valueSelected));
        c.RecordTypeId = PortalProductServiceRecordTypeMap__c.getAll().get(valueSelected).RecordTypeId__c;
        c.Product_or_Service__c = ProductOrServiceMap.get(valueSelected); 
            
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