public class CreateKVHIndirectContact{
    public boolean firstBlock{get;set;}
    public boolean secondBlock{get;set;}
    public boolean zeroBlock{get;set;}
    public boolean foundData{get;set;}
    public boolean newContact{get;set;}
    public boolean searchButton{get;set;}
    
    public String emailAddress{get;set;}
    public String phone{get;set;}
    public String mobile{get;set;}
    
    
    public Account acc{get;set;}
    public Contact con{get;set;}
    
    public list<Contact> contactDetails{get;set;}
    
    public ID CaseID{get;set;}
    Public ID defaultRTID{get;set;}
    public Boolean defaultContactcaseButton{get;set;}
    public CreateKVHIndirectContact(){
        
        if(apexpages.currentpage().getparameters().get('CaseId')!=null && apexpages.currentpage().getparameters().get('CaseId')!=''){
            CaseID = apexpages.currentpage().getparameters().get('CaseId');
            defaultContactcaseButton = true;
        }else{
            defaultContactcaseButton = false;
        }
        
        firstBlock = false;
        zeroBlock  = true;
        searchButton = true;
        //Object Creation
        acc = new Account();
        con = new Contact();
        
        //To Find Default case RecordTypeID
        Schema.DescribeSObjectResult dsr = case.SObjectType.getDescribe();
        Schema.RecordTypeInfo defaultRecordType;
        for(Schema.RecordTypeInfo rti : dsr.getRecordTypeInfos()) {
            if(rti.isDefaultRecordTypeMapping()) {
                defaultRecordType = rti;
            }
        }
        defaultRTID = defaultRecordType.getRecordTypeId();
    }
    Public Account populateAcc{get;set;}
    Public Contact populateCon{get;set;}
    public void CreateAccountContact(){
        try{
        secondBlock = true;
        firstBlock  = false;
        
        String RTID = ObjectUtil.getObjectRecordTypeId(Account.SobjectType,'Indirect Customer');
        acc.RecordTypeID         = RTID;
        acc.Account_Status__c    = 'Active';
        if(con.FirstName==null){
           con.FirstName = ''; 
        }
        acc.name                 = con.FirstName+' '+con.LastName;
        acc.billingCountry       = con.MailingCountry;
        acc.billingCity          = con.MailingCity;
        acc.billingPostalCode    = con.MailingPostalCode;
        if(con.MailingState == null){
            con.MailingState = 'NA';
        }
        acc.billingState         = con.MailingState;
        acc.billingStreet        = con.MailingStreet;
        insert acc;
        
        con.AccountID = acc.ID;
        insert con; 
        
        populateAcc = [SELECT ID,Name FROM Account where id=:acc.id];
        populateCon = [SELECT ID,Name FROM Contact where id=:con.id];
        }Catch(System.DmlException e){
            secondBlock = false;
            firstBlock  = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getDmlMessage(0)));
        }
    }  
    
    public void createNewContactAndAccountConfirmation(){
        foundData = false;
        firstBlock = true;
    }    
    
    public PageReference ContactToCase(){
        Case assignContact = [SELECT Id,AccountID,ContactID FROM Case WHERE Id=:CaseID];
        assignContact.AccountID  = acc.Id;
        assignContact.ContactID  = con.Id;
        update assignContact;
        
        PageReference pagRef = New PageReference('/'+CaseID);
        return pagRef;
        
    }
    
    public PageReference existingContactUpdate(){
        String ContactID = Apexpages.currentPage().getParameters().get('firstParam');
        String AccountID = Apexpages.currentPage().getParameters().get('secondParam');
        
        Case assignContact = [SELECT Id,AccountID,ContactID FROM Case WHERE Id=:CaseID];
        assignContact.AccountID  = AccountID;
        assignContact.ContactID  = ContactID;
        update assignContact;
        
        PageReference pagRef = New PageReference('/'+CaseID);
        return pagRef;
    }
    
    
    public void search(){
        
        String contactSearch = 'select id,Name,email,Phone,mobilephone,Account.name,AccountID,Account.Account_Status__c,Account.Custom_Call_Acct_ID__c,Account.Account_Type__c,Account.recordtype.name from Contact where ';
        if(emailAddress!=null && emailAddress!=''){
            contactSearch += ' email LIKE \''+String.escapeSingleQuotes(emailAddress)+'%\''+' '; contactSearch += 'AND';
        }
        
        if(phone!=null && phone!=''){
            contactSearch += ' phone LIKE \''+String.escapeSingleQuotes(phone)+'%\''+' '; contactSearch += 'AND';
        }
        
        if(mobile!=null && mobile!=''){
            contactSearch += ' MobilePhone LIKE \''+String.escapeSingleQuotes(mobile)+'%\''+' '; contactSearch += 'AND';
        }
        
        contactSearch = contactSearch.Substring(0,contactSearch.length()-3);
        contactDetails = database.query(contactSearch+ ' LIMIT 49999');
        if(contactDetails.size()>0){
            foundData = true;
        }else{
            firstBlock = false;
            foundData = false;
            searchButton = false;
            newContact = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'No Contact Found'));
        }
    }
    public pageReference ContactLinkRedirect(){
        ID contactId = apexpages.currentpage().getparameters().get('contactID');
        PageReference pagRef = New PageReference('/'+contactId);
        return pagRef;
    }
    
    public void CreateNewContact(){
        firstBlock = true;
    }
    
    
    
    
    public pageReference AccountLinkRedirect(){
        ID accountId = apexpages.currentpage().getparameters().get('accountId');
        PageReference pagRef = New PageReference('/'+accountId);
        return pagRef;
    }
    
    public void checkEmail()
    {
        if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', emailAddress))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please provide proper emailID'));
        }
    } 
}