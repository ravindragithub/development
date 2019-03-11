/***********************************************************************************************************************
Name: SearchForSubscriber
Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
Purpose: This is used to subscriber search
------------------------------------------------------------------------------------------------------------------------
Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0    Gopi Kishore. K       4/30/2014        Initial Development
   1.1    Gopi Kishore. K       7/21/2014        updated code for auto population Addresses                           
***********************************************************************************************************************/

public class SearchForSubscriber{

    public boolean secondBlock                                      {get;set;}
    public boolean thirdBlock                                       {get;set;}
    public boolean fourthBlock                                      {get;set;}
    public boolean updateSubscriber                                 {get;set;}
    public boolean newSubscriber                                    {get;set;}
    public boolean ifExisting                                       {get;set;}
    public boolean ifNoRecordFound                                  {get;set;}
    public boolean finalwebserviceCall                              {get;set;}
    public String  accountName                                      {get;set;}
    public String  customCallId                                     {get;set;}
    public String  defaultRecordType                                {get;set;}
    public String  ownerName                                        {get;set;}
    public String  address1                                         {get;set;}
    public String  address2                                         {get;set;}
    public Id      currentURLCaseId                                 {get;set;}
    public Account selectedSubscriberDisplay                        {get;set;}
    public list<AccountWithRadioWrapperClass> relatedAccounts       {get;set;}
    ID selectedSubscriber;
    public boolean updateAddress;
    Map<String,String> stateISOCode;
    Boolean insertWebServiceMethod                                  {get;set;}
    Boolean updateWebServiceMethod                                  {get;set;}
    /** Start : Constructor Calling **/
    public SearchForSubscriber(ApexPages.StandardController controller) {
        insertWebServiceMethod = false;
        updateWebServiceMethod = false;
        finalwebserviceCall = false;
        stateISOCode = New Map<String,String>();
        List<pw_ccpro__State__c> stateCodes = [SELECT ID,pw_ccpro__IsoCode__c,name FROM pw_ccpro__State__c];
        for(pw_ccpro__State__c ISOCode:stateCodes){
                stateISOCode.PUT(ISOCode.name,ISOCode.pw_ccpro__IsoCode__c);
        }
        selectedSubscriberDisplay = new Account();
        currentURLCaseId    =   apexpages.currentpage().getparameters().get('caseid');
        this.initialize();
    }
    /** End : Constructor Calling **/
    
    /** 
    Method Name : initialize
    Description : initializing local and public variables
    Parameter   : None
    Return Type : void
    **/
    private void initialize() {
        secondBlock         =   false;
        thirdBlock          =   false;
        ifExisting          =   true;
        ifNoRecordFound     =   false;
        updateAddress       =   false;
        defaultRecordType   =   'Direct Customer';
        ownerName           =   userinfo.getName();
    }
    /** End : initialize method **/

    /** 
    Method Name : searchSubscriberAccount
    Description : search if Subscribers Account is there or not
    Parameter   : None
    Return Type : void
    **/
    public void searchSubscriberAccount(){
        RelatedAccounts                                 =   new List<AccountWithRadioWrapperClass>();
        list<Id> recordTypeIds                          =   new List<Id>();
        List<RTIds_SearchForSubscriber__c> accRTIDs     =   RTIds_SearchForSubscriber__c.getall().values();

        for(RTIds_SearchForSubscriber__c RTSearchSubscriberIds:accRTIDs){recordTypeIds.add(RTSearchSubscriberIds.name);
        }
        String Accts;
        if(AccountName!=null)
            Accts = 'SELECT id,name,isPersonAccount,Billing_Cycle_picklist__c,Custom_Call_Acct_ID__c,parent.name,Country_Code__c,Account_Status__c,Billing_Cycle__c,Account_Type__c,recordtype.name FROM Account WHERE RecordTypeId NOT IN : recordTypeIds AND';

        if(AccountName!=null && AccountName!=''){
            Accts += ' Name LIKE \''+String.escapeSingleQuotes(AccountName)+'%\''+' '; Accts += 'AND';
        }

        if(CustomCallId!=null && CustomCallId!=''){Accts +=  ' Custom_Call_Acct_ID__c LIKE \''+String.escapeSingleQuotes(CustomCallId)+'%\''+' '; Accts += 'AND';
        }
        Accts = Accts.Substring(0,Accts.length()-3);
        List<Account> RelatedAccount = database.query(Accts);
        if(RelatedAccount.size()>0){
            secondBlock = true;
            for(Account allAccts:RelatedAccount){
                AccountWithRadioWrapperClass newAccountwithRadio    =   new AccountWithRadioWrapperClass();
                newAccountwithRadio.selectedSubscriberAccount       =   false;
                newAccountwithRadio.properSubscriberAccount         =   allAccts;
                RelatedAccounts.add(newAccountwithRadio);
            }
        }else{ secondBlock = false; ifNoRecordFound = true;ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'No Subscriber Found'));}} public String selectedBillingCycle{get;set;} public List<SelectOption> getBillingCycle() { List<SelectOption> options = new List<SelectOption>();options.add(new SelectOption('Pending','Pending')); options.add(new SelectOption('Suspended Customers','Suspended Customers')); options.add(new SelectOption('Terminated Customers','Terminated Customers'));options.add(new SelectOption('Write Off','Write Off')); options.add(new SelectOption('Active','Active'));options.add(new SelectOption('Excluded','Excluded'));options.add(new SelectOption('New Customers','New Customers'));return options;
    }
    
    
    /** 
    Method Name : SelectedSubscriber
    Description : getting Subscribers record which got selected
    Parameter   : None
    Return Type : void
    **/
    public Void SelectedSubscriber(){
        selectedSubscriber = apexpages.currentpage().getparameters().get('subscriber');
        FinalSelectedSubscriber();
    }
    /** End : SelectedSubscriber method **/
    /** 
    Method Name : FinalSelectedSubscriber
    Description : getting selected Subscribers 
    Parameter   : None
    Return Type : void
    **/
    public void FinalSelectedSubscriber(){
        fourthBlock =   false;
        thirdBlock  =   true;
        SelectedSubscriberDisplay = [SELECT Id,Name,Billing_Cycle_picklist__c,IsPersonAccount,BillingStreet,OwnerID,BillingCity,Billingstate,BillingPostalCode
                                     ,BillingCountry,KVH_Sales_Office__c,Commission_Dealer__c ,Market__c,Market_Sector__c,Custom_Call_Acct_ID__c,
                                     Account_Effective_Date__c,Revenue_Category__c,Parent.name,Country_Code__c,Account_Status__c,Billing_Cycle__c,
                                     Account_Type__c,Recordtype.Name,Owner.name,Bill_To_Corporate__c,Mail_to_Corporate__c,Bill_to__c,
                                     Mail_to__c,Home_Hub__c,Bill_Type__c,CC_Integration_Errors__c,CC_Prospect_Acct_ID__c,CC_Reseller_Account_ID__c,
                                         (SELECT Name,Attention__c,Account__c,Address_Type__c, Address_1__c, Address_2__c, City__c, Country__c, Postal_Zipcode__c,
                                         State__c, Zip_4__c,State_Province_ISO_Code__c FROM Addresses__r) 
                                     FROM Account WHERE id=:selectedSubscriber];  
                                     
        IF(SelectedSubscriberDisplay.Account_Type__c == 'Corporate'){ billCorporate                                           = False; mailCorporate                                           = False;homeHub                                                 = False;
        }else{
            billCorporate                                           = True;
            mailCorporate                                           = True;
            homeHub                                                 = True;
            billTo                                                  = False;
            mailTo                                                  = False;
        }
        if(SelectedSubscriberDisplay.Addresses__r.size()>0){
                for(integer i=0;i<SelectedSubscriberDisplay.Addresses__r.size();i++){
                    if(SelectedSubscriberDisplay.Addresses__r[i].Address_Type__c=='Airtime Services Subscriber'){
                                billingAddress1     =    SelectedSubscriberDisplay.Addresses__r[i].Address_1__c;
                                billingAddress2     =    SelectedSubscriberDisplay.Addresses__r[i].Address_2__c;
                                billingCity         =    SelectedSubscriberDisplay.Addresses__r[i].City__c;
                                billingState        =    SelectedSubscriberDisplay.Addresses__r[i].State__c;
                                billingCountry      =    SelectedSubscriberDisplay.Addresses__r[i].Country__c;
                                billingZipCode      =    SelectedSubscriberDisplay.Addresses__r[i].Postal_Zipcode__c;
                                subscriberISOCode   =    SelectedSubscriberDisplay.Addresses__r[i].State_Province_ISO_Code__c;
                                
                    }else if(SelectedSubscriberDisplay.Addresses__r[i].Address_Type__c=='Airtime Services Billing'){
                                address1            =    SelectedSubscriberDisplay.Addresses__r[i].Address_1__c;
                                address2            =    SelectedSubscriberDisplay.Addresses__r[i].Address_2__c;
                                billingISOCode      =    SelectedSubscriberDisplay.Addresses__r[i].State_Province_ISO_Code__c;
                                Attention           =    SelectedSubscriberDisplay.Addresses__r[i].Attention__c;
                    }           
                }updateAddress = true;
        }
    }
    /** End : FinalSelectedSubscriber method **/
    /** 
    Method Name : addNewSubscriber
    Description : adding Subscribers 
    Parameter   : None
    Return Type : void
    **/
    public void addNewSubscriber(){
        
        ifExisting                                              =   false;
        //CreateNewChildSubscriber();
        thirdBlock                                              =   False;
        fourthBlock                                             =   true;
        updateSubscriber                                        =   true;
        newSubscriber                                           =   false;
        //Default Values
        
        SelectedSubscriberDisplay.Account_Status__c             =   'Active';
        SelectedSubscriberDisplay.Account_Effective_Date__c     =   system.today(); 
        SelectedSubscriberDisplay.RecordTypeId                  =   system.label.Account_DirectCustomer_RTID;
    }
    /** End : FinalSelectedSubscriber method **/
    /** 
    Method Name : CreateNewChildSubscriber
    Description : creating  Subscribers 
    Parameter   : None
    Return Type : void
    **/
    public void CreateNewChildSubscriber(){
        //Billing Setting varable
        billTo                                                  = False;
        mailTo                                                  = False;
        homeHub                                                 = True;
        billType                                                = True;
        billCorporate                                           = True;
        mailCorporate                                           = True;
        system.debug('I AM CALLING');
        
        thirdBlock                                              =   false;
        FourthBlock                                             =   true;
        updateSubscriber                                        =   true;
        newSubscriber                                           =   false;
        updateAddress                                           =   false;
        Account newAcc                                          =   SelectedSubscriberDisplay;
        newAcc.ID                                               =   null;
        newAcc.Custom_Call_Acct_ID__c                           =   null;
        SelectedSubscriberDisplay                               =   new Account();
        SelectedSubscriberDisplay                               =   newAcc;
        //Default Values
        SelectedSubscriberDisplay.Name                          =   '';
        SelectedSubscriberDisplay.Account_Status__c             =   'Active';
        SelectedSubscriberDisplay.Account_Type__c               =   'Customer';
        SelectedSubscriberDisplay.parentId                      =    selectedSubscriber;
        SelectedSubscriberDisplay.Account_Effective_Date__c     =    system.today(); 
        SelectedSubscriberDisplay.RecordTypeId                  =    system.label.Account_DirectCustomer_RTID;
        SelectedSubscriberDisplay.ownerID                       =    SelectedSubscriberDisplay.ownerID;
    }
    /** End : FinalSelectedSubscriber method **/
    /** 
    Method Name : NewSubscriber
    Description : creating new  Subscribers 
    Parameter   : None
    Return Type : void
    **/
    
    /** End : FinalSelectedSubscriber method **/
    /** 
    Method Name : CreateNewChildSubscriber
    Description : creating  Subscribers 
    Parameter   : None
    Return Type : void
    **/
    public void UpdatingExistingSubscriber(){
        IF(SelectedSubscriberDisplay.Account_Type__c == 'Corporate'){ billCorporate= False;mailCorporate = False;homeHub= False;
        }else{
            billCorporate                                           = True;
            mailCorporate                                           = True;
            homeHub                                                 = True;
            billTo                                                  = False;
            mailTo                                                  = False;
        }
        
        billType                                                =   True;
        thirdBlock                                              =   False;
        FourthBlock                                             =   true;
        updateSubscriber                                        =   true;
        newSubscriber                                           =   false;
        //Default Values
        SelectedSubscriberDisplay.Billing_Cycle__c              =   SelectedSubscriberDisplay.Billing_Cycle_picklist__c;
        SelectedSubscriberDisplay.Account_Status__c             =   'Active';
        SelectedSubscriberDisplay.Account_Effective_Date__c     =   system.today(); 
        SelectedSubscriberDisplay.RecordTypeId                  =   system.label.Account_DirectCustomer_RTID;
        SelectedSubscriberDisplay.ownerID                       =   SelectedSubscriberDisplay.ownerID;
        //SelectedSubscriberDisplay.parentId                    =   selectedSubscriber;
        /*Account newAcc = SelectedSubscriberDisplay;
        newAcc.ID = null;
        newAcc.Custom_Call_Acct_ID__c = null;
        SelectedSubscriberDisplay = new Account();
        SelectedSubscriberDisplay = newAcc;*/
    }
    /** End : FinalSelectedSubscriber method **/
    /** 
    Method Name : NewSubscriber
    Description : creating new  Subscribers 
    Parameter   : None
    Return Type : void
    **/
    public void NewSubscriber(){
        billTo                                                  = False;
        mailTo                                                  = False;
        homeHub                                                 = True;
        billType                                                = True;
        billCorporate                                           = True;
        mailCorporate                                           = True;
        
        thirdBlock                                              =   False;
        FourthBlock                                             =   true;
        updateSubscriber                                        =   false;
        newSubscriber                                           =   true;
        
        //Billing Address values becomes null
        billingAddress1                                         =   null;
        billingAddress2                                         =   null;
        billingState                                            =   null;
        billingCity                                             =   null;
        billingCountry                                          =   null;
        billingZipCode                                          =   null;
        
        //Subscriber Address
        address1                                                =   null;
        address2                                                =   null;
        
        
        
        SelectedSubscriberDisplay                               = new Account();
        //Default Values
        SelectedSubscriberDisplay.Account_Type__c               =   'Customer';
        SelectedSubscriberDisplay.Bill_Type__c                  =   'Email with pdf';
        SelectedSubscriberDisplay.Account_Status__c             = 'Active';
        SelectedSubscriberDisplay.Account_Effective_Date__c     = system.today(); 
        SelectedSubscriberDisplay.RecordTypeId                  = system.label.Account_DirectCustomer_RTID;
        //SelectedSubscriberDisplay.owner.name                  = userInfo.getuserName();
        SelectedSubscriberDisplay.ownerID                       = SelectedSubscriberDisplay.ownerID;
    }
    /** End : NewSubscriber method **/
    /** 
    Method Name : viewFinalScbscriber
    Description : viewing  Subscribers 
    Parameter   : None
    Return Type : void
    **/
    public void viewFinalScbscriber(){
        thirdBlock                                              =   False;
        FourthBlock                                             =   false;     
        User newUserOwner                                       =   [SELECT id,name 
                                                                    FROM user WHERE id=:SelectedSubscriberDisplay.ownerID];
        OwnerName                                               =   newUserOwner.name;
    }
    /** End : viewFinalScbscriber method **/
    /** 
    Method Name : customCancel
    Description :cancel method 
    Parameter   : None
    Return Type : void
    **/
    public pagereference customCancel(){
        pagereference returnToCase                              =   new pagereference('/'+CurrentURLCaseId);
        return returnToCase;
    }
    /** End : viewFinalScbscriber method **/
    /** 
    Method Name : Back
    Description :Back method 
    Parameter   : None
    Return Type : void
    **/
    public void Back(){
        FourthBlock = true;
    }
    /** End : Back method **/

    //Used to return subscriber after saving Record.

    public ID subscriberId                      {get;set;}public boolean subscriberBillingAddress     {get;set;}
    public String billingAddress1               {get;set;}
    public String billingAddress2               {get;set;}
    public String billingState                  {get;set;}
    public String billingCity                   {get;set;}
    public String billingCountry                {get;set;}
    public String billingZipCode                {get;set;}
    Public String Attention                     {get;set;}
    
    public String billingISOCode                {get;set;}
    public String subscriberISOCode             {get;set;}
    /** 
    Method Name : FinalSubmissionSubscriber
    Description :Final Subscriber commit
    Parameter   : None
    Return Type : void
    **/
    public pageReference FinalSubmissionSubscriber(){
        try{
            SelectedSubscriberDisplay.BillingStreet = address1+','+address2;
            system.debug('I AM OK1=>'+SelectedSubscriberDisplay);
            SelectedSubscriberDisplay.Billing_Cycle__c  =   SelectedSubscriberDisplay.Billing_Cycle_picklist__c;
            if(stateISOCode.ContainsKey(SelectedSubscriberDisplay.Billingstate)){
                SelectedSubscriberDisplay.ISO_Code__c = stateISOCode.get(SelectedSubscriberDisplay.Billingstate);
            }
            upsert SelectedSubscriberDisplay;
            subscriberId = SelectedSubscriberDisplay.id;
            selectedSubscriber = SelectedSubscriberDisplay.id;
            Case updateAccountNameinCase = [SELECT Id,AccountId,Platform_Asset_Account__c,Platform_Asset_Account__r.ParentID,AssetID 
                                            FROM Case WHERE Id=:apexpages.currentpage().getparameters().get('caseid')];
            if(SelectedSubscriberDisplay.parentID != null){ UpdateAccountNameinCase.AccountID = SelectedSubscriberDisplay.ID; UpdateAccountNameinCase.Platform_Asset_Account__r.parentID = SelectedSubscriberDisplay.ID;
            }else{
                UpdateAccountNameinCase.AccountID = SelectedSubscriberDisplay.ID;
            }
            UpdateAccountNameinCase.Create_Account_in_Salesforce__c = true;
            system.debug('I AM OK2=>'+updateAccountNameinCase);
            Update updateAccountNameinCase;

            Account acc = [SELECT id FROM Account WHERE Id=:updateAccountNameinCase.Platform_Asset_Account__c];
            acc.parentID = SelectedSubscriberDisplay.ID;
            update acc;
        List<Address__c> accountAddress = New List<Address__c>();  
        List<Address__c>  AccountAddresses= [SELECT Name, Account__c,Address_Type__c, Address_1__c, Address_2__c, City__c, Country__c, Postal_Zipcode__c,
                                         State__c, Zip_4__c,State_Province_ISO_Code__c FROM Address__c WHERE Account__c=:SelectedSubscriberDisplay.id];
        
        
        if(AccountAddresses.size()>0){
            for(integer i=0;i<AccountAddresses.size();i++){
                if(AccountAddresses[i].Address_Type__c             ==     system.label.AddressType){
                      Address__c subscriberAddress = subscriberAddressMapping(true,AccountAddresses[i]);
                      accountAddress.add(subscriberAddress);
                }else if(AccountAddresses[i].Address_Type__c       ==     system.label.AddressTypeService){
                      Address__c billingAddress = billingAddressMapping(true,AccountAddresses[i]);
                      accountAddress.add(billingAddress);
                }           
            }
        }else{Address__c subscriberAddress = subscriberAddressMapping(true,new address__c());accountAddress.add(subscriberAddress);Address__c billingAddress = billingAddressMapping(true,new address__c());accountAddress.add(billingAddress);            
        }
        upsert SelectedSubscriberDisplay;
        upsert accountAddress;
        
        finalwebserviceCall = true;    
            
            thirdBlock = true;
            FourthBlock = false;
            
            return null;
        }Catch(System.DmlException typeOfException){
            finalwebserviceCall = false;
            string properErrorMessage = '';
            if(properErrorMessage.contains('DUPLICATE')){ properErrorMessage = 'Duplicate values not allowed in "Custom Call Account ID" ';
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error Found:'+typeOfException.getDmlMessage(0))); 
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error Found:'+typeOfException.getLineNumber()));
            return null; }}public Pagereference confirmSubscriber(){ Case updateAccountNameinCase = [SELECT Id,AccountId,Platform_Asset_Account__c,Platform_Asset_Account__r.ParentID,AssetID  FROM Case WHERE Id=:CurrentURLCaseId];if(SelectedSubscriberDisplay.parentID != null){UpdateAccountNameinCase.AccountID = SelectedSubscriberDisplay.ID;UpdateAccountNameinCase.Platform_Asset_Account__r.parentID = SelectedSubscriberDisplay.ID;}else{UpdateAccountNameinCase.AccountID = SelectedSubscriberDisplay.ID;}UpdateAccountNameinCase.Create_Account_in_Salesforce__c = true;system.debug('I AM OK2=>'+updateAccountNameinCase);Update updateAccountNameinCase;pageReference pagRef = new Pagereference('/'+CurrentURLCaseId);return pagRef;}public void CallWebService(){ID     accountID   = SelectedSubscriberDisplay.ID;String accounType  = SelectedSubscriberDisplay.Account_Type__c;system.debug(accounType);String webservicemessage;try{Boolean webTopService;system.debug('I AM INSERT'+SelectedSubscriberDisplay.Custom_Call_Acct_ID__c+'AccountID:'+accountID+'AccountType:'+accounType);if(SelectedSubscriberDisplay.Custom_Call_Acct_ID__c == null){system.debug('I AM INSERT');webTopService = CCDS_WebtopServices.AddAccount(accountID,accounType);webservicemessage = 'Add Account sent to CCDS';}else{system.debug('I AM UPDATE');system.debug('I AM UPDATE ACCOUNT TYPE:'+accounType);webTopService = CCDS_CustomerHelper.UpdateAccount(AccountID,accounType);webservicemessage = 'Update Account sent to CCDS';}Account webserviceUpdate = [SELECT ID FROM Account where ID=:accountID];webserviceUpdate.Webservice_Response__c = webservicemessage;update webserviceUpdate;}catch(Exception ex){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error Found:Please contact system Adminstrator:'+ex)); ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,''+ex.getLineNumber()));
        }
    }
    
    public Boolean billTo{get;set;}
    public Boolean mailTo{get;set;}
    public Boolean homeHub{get;set;}
    public Boolean billType{get;set;}
    public Boolean billCorporate{get;set;}
    public Boolean mailCorporate{get;set;}public void CorporateCreation(){NewSubscriber();billTo = True;mailTo= True;homeHub= False;billType= False;billCorporate = False;mailCorporate = False; SelectedSubscriberDisplay.Account_Type__c =   'Corporate';
    }
    
    
    
    /** End : FinalSubmissionSubscriber method **/
    /** 
    Method Name : SearchAgain
    Description :searching Subscriber again
    Parameter   : None
    Return Type : void
    **/
    public void SearchAgain(){
        secondBlock     =   false;
        thirdBlock      =   false;
        fourthBlock     =   false;
    }
    /** End : FinalSubmissionSubscriber method **/
    /**Wrapper class for radio **/
    public class AccountWithRadioWrapperClass{
        public Boolean selectedSubscriberAccount    {get;set;}
        public Account properSubscriberAccount      {get;set;}
    }
    
    Public Address__c subscriberAddressMapping(boolean newAddress,Address__c addressUpdate){
        Address__c updateAddress;
        if(newAddress){
           updateAddress                            =      addressUpdate;
           updateAddress.Billing_Account__c         =      system.label.DefaultBillingAccount;
           updateAddress.Case_ID__c                 =      currentURLCaseId;
           updateAddress.Address_1__c               =      address1;
           updateAddress.Address_2__c               =      address2;
           updateAddress.City__c                    =      SelectedSubscriberDisplay.BillingCity;
           updateAddress.State__c                   =      SelectedSubscriberDisplay.Billingstate;
           updateAddress.Country__c                 =      SelectedSubscriberDisplay.BillingCountry;
           updateAddress.Postal_Zipcode__c          =      SelectedSubscriberDisplay.BillingPostalCode;
           updateAddress.Address_Type__c            =      system.label.AddressType;
           if(addressUpdate.id==null){ updateAddress.Account__c                 =      SelectedSubscriberDisplay.ID;
           }
           if(stateISOCode.ContainsKey(updateAddress.State__c)){
               updateAddress.State_Province_ISO_Code__c = stateISOCode.get(updateAddress.State__c);
               subscriberISOCode = stateISOCode.get(updateAddress.State__c);
           }     
        }
        return updateAddress;
    }
    
    Public Address__c billingAddressMapping(boolean newAddress,Address__c addressUpdate){
        Address__c updateAddress;
        if(newAddress){
            updateAddress                            =      addressUpdate;
            updateAddress.Billing_Account__c         =      system.label.DefaultBillingAccount;
            updateAddress.Case_ID__c                 =      currentURLCaseId;
            updateAddress.Address_1__c               =      billingAddress1;
            updateAddress.Address_2__c               =      billingAddress2;
            updateAddress.City__c                    =      billingCity;
            updateAddress.State__c                   =      billingState;
            updateAddress.Country__c                 =      billingCountry;
            updateAddress.Postal_Zipcode__c          =      billingZipCode;
            updateAddress.Attention__c               =      Attention;
            updateAddress.Address_Type__c            =      system.label.AddressTypeService;
            if(addressUpdate.id==null){updateAddress.Account__c                 =      SelectedSubscriberDisplay.ID;
            }
            if(stateISOCode.ContainsKey(updateAddress.State__c)){ updateAddress.State_Province_ISO_Code__c = stateISOCode.get(billingState); billingISOCode = stateISOCode.get(billingState);
            } else{
                updateAddress.State_Province_ISO_Code__c = null;
                billingISOCode = stateISOCode.get(billingState);
            }
        }
        return updateAddress; 
    }
}