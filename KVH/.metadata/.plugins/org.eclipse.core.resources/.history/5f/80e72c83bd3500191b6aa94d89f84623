public with sharing class  myKVH_ReportProblem 
{   
    public boolean firstpage {get;set;}
    public boolean innerPanel {get;set;}
    public Attachment attach {get;set;}
    public Case srvCase {get;set;}
    
    public List<SelectOption> radio1 {get;private set;}
    public List<SelectOption> radio2 {get;private set;}
    public List<SelectOption> radio3 {get;private set;}
    public List<SelectOption> radio4 {get;private set;}
    public List<SelectOption> radio5 {get;private set;}
    public List<SelectOption> radio6 {get;private set;}
    public List<SelectOption> radio7 {get;private set;}
    public List<SelectOption> radio8 {get;private set;}
    public SelectOption caseType {get;set;}
    
    private map<string, string> ProductOrServiceMap = new map<string, string>();
    private map<string, string> valueSelectedLookupMap = new map<string, string>();
    
    public String valueSelected {get; set;}
    public String typeSelected {get; set;}
    public String serviceSelected {get; set;}
    
    public String valueSelectedLookup
    {
        get{return valueSelectedLookupMap.get(valueSelected);}
    }
    
    public myKVH_ReportProblem(ApexPages.StandardController controller)
    {
        firstpage=true;
        srvCase = new Case();
        //added line jthom 1/30/14 Prevents IE11 issue see SF case #10161571
        //prepopulating the Description field seems to work, see URL below for description
        //http://salesforce.stackexchange.com/questions/22036/problem-rendering-textarea-inputfield-inputtextarea-in-pageblocktable-internet
        srvCase.Description = '';
        srvCase.Type = 'Report a Service or Product Problem';
        attach = new Attachment();
        caseType = new SelectOption('Report a Service or Product Problem', 'Report a Service or Product Problem');
        radio1 = buildValues(new list<string>{'KVH mini-VSAT Broadband (TracPhone V-Series, V-IP Series)', 'KVH Mini-VSAT',  
                                              'Inmarsat (TracPhone Fleet, Mini-M, Fleetbroadband)','Inmarsat',
                                              'Iridium (Pilot)', 'Iridium'});
        
        radio2 = buildValues(new list<string>{'Standalone CommBox (C2, R8, Hub)', 'Standalone CommBox (C2, R8, Hub)'});
                                              
        radio3 = buildValues(new list<string>{'Communications: VoIP, Crew Calling, OnGo Fax, GSM Remote Support Module', 'Communications', 
                                              'CommBox "Quick" Software Applications (QuickBasic, QuickWeb, QuickCrew, QuickFile, QuickMail, QuickComplete)', 'Commbox'});       
        radio4 = buildValues(new list<string>{'Antenna Products','TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products'});
        radio5 = buildValues(new list<string>{'Digital Compasses','Digital Compasses'});
        radio6 = buildValues(new list<string>{'TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products', 'Satellite Television', 'KVH mini-VSAT Broadband (TracPhone V-Series, V-IP Series)', 'Broadband Communication'});
        radio7 = buildValues(new list<string>{'Report a service or product problem', 'Report a service or product problem'});
        radio8 = buildValues(new list<string>{'',''});
        radio8.add(new SelectOption('Please Select a Case Type', 'Please Select a Case Type', true));
        
        valueSelectedLookupMap.put('KVH mini-VSAT Broadband (TracPhone V-Series, V-IP Series)', 'KVH mini-VSAT Broadband (TracPhone V-Series, V-IP Series)');
        valueSelectedLookupMap.put('TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products', 'TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products');
        valueSelectedLookupMap.put('Inmarsat (TracPhone Fleet, Mini-M, Fleetbroadband)', 'Inmarsat (TracPhone Fleet, Mini-M, Fleetbroadband)');
        valueSelectedLookupMap.put('Standalone CommBox (C2, R8, Hub)', 'Standalone CommBox (C2, R8, Hub)');
        valueSelectedLookupMap.put('Iridium (Pilot)', 'Iridium (Pilot)');
        valueSelectedLookupMap.put('Communications: VoIP, Crew Calling, OnGo Fax, GSM Remote Support Module', 'Communications: VoIP, Crew Calling, OnGo Fax, GSM Remote Support Module');
        valueSelectedLookupMap.put('Commbox: (Quick X) Software Applications','Commbox: (Quick X) Software Applications');
        valueSelectedLookupMap.put('Antenna Products', 'TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products');
        valueSelectedLookupMap.put('Digital Compasses', 'Digital Compasses');
        
        
        ProductOrServiceMap.put('KVH mini-VSAT Broadband (TracPhone V-Series, V-IP Series)', 'KVH mini-VSAT Broadband (TracPhone V-Series, V-IP Series)');
        ProductOrServiceMap.put('Inmarsat (TracPhone Fleet, Mini-M, FleetBroadband)', 'Inmarsat (TracPhone Fleet, Mini-M, FleetBroadband)');
        ProductOrServiceMap.put('Standalone CommBox (C2, R8)', 'Standalone CommBox (C2, R8, Hub)'); //check recordtypeId
        ProductOrServiceMap.put('Iridium', 'Iridium (Pilot)');
        ProductOrServiceMap.put('Communications', 'Communications: VoIP, Crew Calling, OnGo Fax, GSM Remote Support Module');
        ProductOrServiceMap.put('Commbox','CommBox: "Quick" Software');
        ProductOrServiceMap.put('TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products', 'TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products');
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
       for(Account a : [select id,name from Account where recordTypeId in :recids order by name Limit 998])
          options.add(new SelectOption(a.id, a.name));
         
       return options;
    }
    
    public PageReference CreateCase() {
        Case aCase; 
        try {
            aCase = buildCase();
            aCase.RecordTypeId = PortalProductServiceRecordTypeMap__c.getAll().get(valueSelected).RecordTypeId__c;
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            
            aCase.setOptions(dmo);  
            aCase.Case_Symptom__c = valueselected;
            insert aCase;
            
            InsertAttachment(aCase);
        }catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
            return null;
        }
        return new PageReference('/s/mykvh-case-view?id=' + aCase.Id);
    }
    public PageReference CreateCasePartner()
    {
        Case aCase;
        //String URL = Label.Community_URL;
        //string comm = Label.Community_Prefix;
        string urlstr= URL.getSalesforceBaseUrl().toExternalForm();
        try{
            aCase = buildCase();
            //added for SF-464
            aCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('mini-VSAT').getRecordTypeId();
            system.debug(aCase);
            aCase.Portal_View__c = '{!$User.Portal_View__c}';
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            
            aCase.setOptions(dmo);  
            aCase.Origin = 'Customer Portal';
            insert aCase;
            
            InsertAttachment(aCase);
            PageReference pageref = new PageReference(Label.myKVH_community_url +'mykvh-case-view?recordid=' + aCase.Id);
            return pageref;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
            return null;
        }
    }
    
    public Pagereference setSelection()
    {       
        return nextButton();
    }
    public void recordTypeSet(){
        system.debug(valueSelected);
        if(valueSelected == 'TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products'){
            srvCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('mini-VSAT').getRecordTypeId();
            radio8 = buildValues(new list<string>{'Digital Compasses','Digital Compasses', 'Inmarsat (TracPhone Fleet, Mini-M, Fleetbroadband)', 'Inmarsat','TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products','Antenna Products'});
        } else{
            srvCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SatTV').getRecordTypeId();
            radio8 = buildValues(new list<string>{'KVH mini-VSAT Broadband (TracPhone V-Series, V-IP Series)','KVH Mini-VSAT', 'Inmarsat (TracPhone Fleet, Mini-M, Fleetbroadband)','Inmarsat', 'Standalone CommBox (C2, R8, Hub)','Standalone CommBox (C2, R8)', 'Iridium (Pilot)','Iridium', 
                'Communications: VoIP, Crew Calling, OnGo Fax, GSM Remote Support Module', 'Communications', 'CommBox "Quick" Software Applications (QuickBasic, QuickWeb, QuickCrew, QuickFile, QuickMail, QuickComplete)','Commbox', 'TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products','Antenna Products', 
                'Digital Compasses','Digital Compasses'});
        }
        innerPanel = true;
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
        system.debug('user: '+ u);
        c.AccountId = u.AccountId;
        c.ContactId = u.ContactId;
        c.Origin = 'Web';
        c.Type = 'Report a Service or Product Problem';
        system.debug(valueSelected +':'+ ProductOrServiceMap.containskey(valueSelected));
        if (serviceSelected == null){
           c.Product_or_Service__c = ProductOrServiceMap.get(valueSelected);  
        } else {
            c.Product_or_Service__c = serviceSelected;
        } 
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