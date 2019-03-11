Public Class AccountAirtimeSubcriber{
    Public Account SelectedSubscriberDisplay    {get;set;}
    Public Boolean ifExisting                   {get;set;}
    Public Boolean billCorporate                {get;set;}
    Public Boolean mailCorporate                {get;set;}
    Public Boolean homeHub                      {get;set;}
    public String  defaultRecordType            {get;set;}
    
    public String billingAddress1               {get;set;}
    public String billingAddress2               {get;set;}
    public String billingState                  {get;set;}
    public String billingCity                   {get;set;}
    public String billingCountry                {get;set;}
    public String billingZipCode                {get;set;}
    public String billingISOCode                {get;set;}
    public String subscriberISOCode             {get;set;}
    Public String address1                      {get;set;}
    Public String address2                      {get;set;}
    Public String Attention                     {get;set;}
    
    
    public Boolean billTo                       {get;set;}
    public Boolean mailTo                       {get;set;}
    public Boolean billType                     {get;set;}
    public boolean subscriberBillingAddress     {get;set;}
    
    //Redirect And Storing current page accountID
    public String accID                         {get;set;}
    //Hiding Blocks
    
    Public Boolean firstBlock                    {get;set;}
    Public Boolean secondBlock                   {get;set;}
    
    Map<String,String> stateISOCode;
    
    Public AccountAirtimeSubcriber(){
        /*Blocks Hiding variables*/
        firstBlock = true;
        secondBlock = false;
        /*Block Hiding variables */
        accID = apexpages.currentpage().getparameters().get('accID');
        if(accID!=null){
            SelectedSubscriberDisplay = [SELECT Id,Name,Billing_Cycle_picklist__c,IsPersonAccount,BillingStreet,OwnerID,BillingCity,Billingstate,BillingPostalCode
                                     ,BillingCountry,KVH_Sales_Office__c,Commission_Dealer__c ,Market__c,Market_Sector__c,Custom_Call_Acct_ID__c,
                                     Account_Effective_Date__c,Revenue_Category__c,Parent.name,Country_Code__c,Account_Status__c,Billing_Cycle__c,
                                     Account_Type__c,Recordtype.Name,Owner.name,Bill_To_Corporate__c,Mail_to_Corporate__c,Bill_to__c,
                                     Mail_to__c,Home_Hub__c,Bill_Type__c,CC_Integration_Errors__c,CC_Prospect_Acct_ID__c,CC_Reseller_Account_ID__c,
                                         (SELECT Name, Account__c,Attention__c,Address_Type__c, Address_1__c, Address_2__c, City__c, Country__c, Postal_Zipcode__c,
                                         State__c, Zip_4__c,State_Province_ISO_Code__c FROM Addresses__r) 
                                     FROM Account WHERE id=:accID];
             if(SelectedSubscriberDisplay.Account_Type__c == 'Corporate'){
                billCorporate                                           = False;
                mailCorporate                                           = False;
                homeHub                                                 = False;
                ifExisting                                              = true;
            }else{
                billCorporate                                           = True;
                mailCorporate                                           = True;
                homeHub                                                 = True;
                ifExisting                                              = True;
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
                }
            }
        }
        
        //CustomSetting Properties
        stateISOCode = New Map<String,String>();
        List<pw_ccpro__State__c> stateCodes = [SELECT ID,pw_ccpro__IsoCode__c,name FROM pw_ccpro__State__c];
        for(pw_ccpro__State__c ISOCode:stateCodes){
                stateISOCode.PUT(ISOCode.name,ISOCode.pw_ccpro__IsoCode__c);
        }
    }
    
    
    
    Public void EditSubscriber(){
        /*Blocks Hiding variables*/
        firstBlock = false;
        secondBlock = true;
        /*Block Hiding variables */
        
        iF(SelectedSubscriberDisplay.Account_Type__c == 'Corporate'){
            billCorporate                                           = False;
            mailCorporate                                           = False;
            homeHub                                                 = False;
            billTo                                                  = True;
            mailTo                                                  = True;
            billType                                                = False;
        }else{
            billCorporate                                           = True;
            mailCorporate                                           = True;
            billTo                                                  = True;
            mailTo                                                  = True;
            homeHub                                                 = True;
            billType                                                = True;
        }
        
    }
    
    
    
    Public void finalSaveFunction(){
        /*Blocks Hiding variables*/
            firstBlock = true;
            secondBlock = false;
        /*Block Hiding variables */
        
        List<Address__c> accountAddress = New List<Address__c>();
        
        List<Address__c>  AccountAddresses= [SELECT Name, Account__c,Address_Type__c, Address_1__c, Address_2__c, City__c, Country__c, Postal_Zipcode__c,
                                         State__c, Zip_4__c,State_Province_ISO_Code__c FROM Address__c WHERE Account__c=:accID];
        
        
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
        }else{
            Address__c subscriberAddress = subscriberAddressMapping(true,new address__c());
            accountAddress.add(subscriberAddress);
            Address__c billingAddress = billingAddressMapping(true,new address__c());
            accountAddress.add(billingAddress);            
        }
        update SelectedSubscriberDisplay;
        upsert accountAddress;
    }
    
    
    public pageReference CallWebService(){
        ID     accountID   = SelectedSubscriberDisplay.ID;
        String accounType  = SelectedSubscriberDisplay.Account_Type__c;
        String webservicemessage;
        boolean showMessage;
        try{
            Boolean webTopService;
            showMessage = true;
            if(SelectedSubscriberDisplay.Custom_Call_Acct_ID__c == null){
                webTopService = CCDS_WebtopServices.AddAccount(accountID,accounType);
                webservicemessage = 'Add Account sent to CCDS';
            }else{
                webTopService = CCDS_CustomerHelper.UpdateAccount(AccountID,accounType);
                webservicemessage = 'Update Account sent to CCDS';
            }
            Account webserviceUpdate = [SELECT ID FROM Account where ID=:accountID];
            webserviceUpdate.Webservice_Response__c = webservicemessage;
            update webserviceUpdate;
        }catch(Exception ex){
            showMessage = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error Found:Please contact system Adminstrator:'+ex)); 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,''+ex.getLineNumber()));
        }
        if(showMessage){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Updated Subscriber in WebtopServices'));
        }
        return null;
    }
    
    Public Address__c subscriberAddressMapping(boolean newAddress,Address__c addressUpdate){
        Address__c updateAddress;
        if(newAddress){
           updateAddress                            =      addressUpdate;
           updateAddress.Billing_Account__c         =      system.label.DefaultBillingAccount;
           //updateAddress.Case_ID__c                 =      currentURLCaseId;
           updateAddress.Address_1__c               =      address1;
           updateAddress.Address_2__c               =      address2;
           updateAddress.City__c                    =      SelectedSubscriberDisplay.BillingCity;
           updateAddress.State__c                   =      SelectedSubscriberDisplay.Billingstate;
           updateAddress.Country__c                 =      SelectedSubscriberDisplay.BillingCountry;
           updateAddress.Postal_Zipcode__c          =      SelectedSubscriberDisplay.BillingPostalCode;
           updateAddress.Address_Type__c            =      system.label.AddressType;
           if(addressUpdate.id==null){
               updateAddress.Account__c                 =      SelectedSubscriberDisplay.ID;
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
            //updateAddress.Case_ID__c                 =      currentURLCaseId;
            updateAddress.Address_1__c               =      billingAddress1;
            updateAddress.Address_2__c               =      billingAddress2;
            updateAddress.City__c                    =      billingCity;
            updateAddress.State__c                   =      billingState;
            updateAddress.Country__c                 =      billingCountry;
            updateAddress.Postal_Zipcode__c          =      billingZipCode;
            updateAddress.Attention__c               =      Attention;
            updateAddress.Address_Type__c            =      system.label.AddressTypeService;
            if(addressUpdate.id==null){
               updateAddress.Account__c                 =      SelectedSubscriberDisplay.ID;
            }
            if(stateISOCode.ContainsKey(updateAddress.State__c)){
                updateAddress.State_Province_ISO_Code__c = stateISOCode.get(billingState);
                billingISOCode = stateISOCode.get(billingState);
            } else{
                updateAddress.State_Province_ISO_Code__c = null;
                billingISOCode = stateISOCode.get(billingState);
            }
        }
        return updateAddress; 
    }
    
    
}