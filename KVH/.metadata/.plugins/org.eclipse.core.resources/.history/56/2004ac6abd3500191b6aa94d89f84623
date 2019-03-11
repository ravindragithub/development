public with sharing class PartnerSupportCaseController
{ 
    public Attachment attach {get;set;}
    public Case srvCase {get;set;}
    public boolean firstpage {get;set;}
    
    public List<SelectOption> radio1 {get;private set;}
    public List<SelectOption> radio2 {get;private set;}
    public List<SelectOption> radio3 {get;private set;}
    public List<SelectOption> radio4 {get;private set;}
    
    public map<string, string> SymptomMap = new map<string, string>();
    public map<string, string> ProductMap = new map<string, string>();
    
    public String valueSelected {get;set;}
    
    public PartnerSupportCaseController(ApexPages.StandardController controller)
    {
        firstPage=true;//this is inherited from the old page and no longer necessary
        srvCase = new Case();
        srvCase.Description = '';
        attach = new Attachment();
        
        //These are sets of radios for the visualforce page.  User may only select one, but they are segregated into groups
        radio1 = buildValues(new list<string>{'Cannot find a document', 'Cannot find a document', 'Cannot find a KVH Product', 'Cannot find a KVH Product'});
        
        radio2 = buildValues(new list<string>{'Cannot access the Learning Center', 'Cannot access the Learning Center', 'Cannot find the training I need', 'Cannot find the training I need', 'Issue with a video, course, or webinar', 'Issue with a video, course, or webinar', 'Question about an upcoming class', 'Question about an upcoming class', 'Incorrect or missing information in My Profile', 'Incorrect or missing information in My Profile', 'Other Learning Center issue or feedback', 'Other Learning Center issue or feedback'});

        radio3 = buildValues(new list<string>{'Partner Portal access issue', 'Partner Portal access issue', 'General Information Request', 'General information request', 'Feedback on Partner Portal', 'Feedback on Partner Portal', 'Other Partner Portal problem/question', 'Other Partner Portal problem/question'});     
        
        radio4 = buildValues(new list<string>{'Open a case with KVH account management', 'Open a case with KVH account management'});
		
        //symptom map is unnecessary.  It is only there for the future when the phrasing may be changed and we have to match radio button to symptom.
        //currently, they are exact matches
        SymptomMap.put('Incorrect or missing information in My Profile', 'Incorrect or missing information in My Profile'); 
        SymptomMap.put('Other Partner Portal problem/question', 'Other Partner Portal problem/question'); 
        SymptomMap.put('Partner Portal access issue', 'Login Access'); 
        SymptomMap.put('Issue with a video, course, or webinar', 'Issue with a video, course, or webinar');
        SymptomMap.put('Cannot find the training I need', 'Cannot find the training I need');
        SymptomMap.put('Cannot find a document', 'Cannot find a document');
        SymptomMap.put('Cannot find a KVH Product', 'Cannot find a KVH Product');
        SymptomMap.put('Cannot access the Learning Center', 'Cannot access the Learning Center');
        SymptomMap.put('Other Learning Center issue or feedback', 'Other Learning Center issue or feedback');
        SymptomMap.put('Open a case with KVH account management', 'Administrative Account Update');
        SymptomMap.put('General Information Request', 'General Information Request');
        SymptomMap.put('Feedback on Partner Portal', 'Feedback on Partner Portal');
        SymptomMap.put('Question about an upcoming class', 'Question about an upcoming class');
        
        //maps the radio button selections to product or service type.  This is the heading of the radio category
        ProductMap.put('Cannot find a document', 'Product Resources');
        ProductMap.put('Cannot find a KVH Product', 'Product Resources');
        ProductMap.put('Cannot access the Learning Center', 'Learning Center');
        ProductMap.put('Cannot find the training I need', 'Learning Center');
        ProductMap.put('Issue with a video, course, or webinar', 'Learning Center');
        ProductMap.put('Question about an upcoming class', 'Learning Center');
        ProductMap.put('Incorrect or missing information in My Profile', 'Learning Center'); 
        ProductMap.put('Partner Portal access issue', 'General'); 
        ProductMap.put('Other Learning Center issue or feedback', 'Learning Center');
        ProductMap.put('Open a case with KVH account management', 'Administrative Account Update');
        ProductMap.put('General Information Request', 'General');
        ProductMap.put('Feedback on Partner Portal', 'General');
        ProductMap.put('Other Partner Portal problem/question', 'General');                                         
    }
    
    public PageReference CreateCase()
    {
        valueSelected = srvCase.Case_Symptom__c;
        system.debug('create: '+valueSelected);
        Case aCase; 
        
        try{
            aCase = buildCase(); // puts together all the parts of the case
            system.debug(aCase);
            aCase.Portal_View__c = '{!$User.Portal_View__c}';  
            // adds the current portal view of the user
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true; 
            // assigns the case to the current assignment rule
            aCase.setOptions(dmo);  
            insert aCase;
            
            InsertAttachment(aCase);
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage())); // adds the error received to the page display and the transaction rolls back
            return null;
        }
        return new PageReference('/apex/my_Case_ViewPartner?id=' + aCase.Id);  // new case record page
    }
    
    private static final string CASE_TYPE = 'KVH Partner Portal Question/Problem'; //currently only one case type
    
    public Case buildCase()
    {
        Case c = srvCase; //gets the case record from the controller
        Id userId = UserInfo.getUserId(); //gets the current user id - the person using the form
        User u = [Select AccountId, ContactId from User where ID =:userId];
        //assign values to the case from current user's information
        c.AccountId = u.AccountId;
        c.ContactId = u.ContactId;
        c.Origin = 'Web';
        c.Type = CASE_TYPE;  //currently only one case type is being used
        c.Subject = 'KVH Partner Portal Question/Problem';
     
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosbyName().get('Partner Portal').getRecordTypeId();
        List<Group> owner = new List<Group>();
        owner = [SELECT Id FROM Group WHERE Name = 'Partner Portal' AND Type='Queue' LIMIT 1]; //gets the partner portal queue Id
        c.OwnerId = owner[0].Id;
        c.Case_Symptom__c = valueselected;
        c.Product_or_Service__c = ProductMap.get(valueSelected);  //calls the map to get the product or service type corresponding to the symptom chosen
        return c;
    }
    
    private void InsertAttachment(Case aCase)
    {
        if(attach.Body==null || attach.Name==null)//if attachment actually exists
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
        //builds option if there is only one input.  Needed for the last value.
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