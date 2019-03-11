public without sharing class SelfRegisteredUserWelcomePage_Ctrl extends ActivationsBaseController {
    public contact objContact {get;set;}
    public boolean boolAgreeTerms{get;set;}
    public boolean ActivationOrderTerms {get;set;}
    public String strActivationOrderTerms {get;set;}
    public list<ActivationOrderTable> lstActivationOrderTable {get;set;}
    public Id ActOrderId {get;set;}
    CountryStateMethods util = New CountryStateMethods();               //Helper Class
    public list<SelectOption> CountriesList = New list<SelectOption>(); //List of Country Names for Subscriber Picklist
    public list<SelectOption>    StatesList =New list<SelectOption>();
    public SelfRegisteredUserWelcomePage_Ctrl(){
        list<contact> lstContact = [SELECT Id, Salutation, CreatedById,OwnerId,  Marketing_Communications__c,FirstName, LastName, Email, Phone, MailingStreet, MailingCity, MailingCountry, MailingState, MailingPostalCode,Agree_to_myKVH_Terms_and_Conditions__c, account.CPI__c, accountId,account.OwnerId, account.Market__c, account.Market_Sector__c FROM contact WHERE Id In (Select ContactId From User Where Id =: UserInfo.getUserId()) LIMIT 1];
        objContact = lstContact.size() > 0 ? lstContact[0] : new contact();
        lstActivationOrderTable = new list<ActivationOrderTable>();
        list<KVH_Countries__mdt> ObjCountries = [SELECT Id, TrimmedName__c, IsoCode_2__c, IsoCode_3__c FROM KVH_Countries__mdt where TrimmedName__c=:objContact.MailingCountry limit 1];
        if(ObjCountries.size()>0)objContact.MailingCountry = ObjCountries[0].IsoCode_2__c;
        CountriesList = util.setupCountryPicklist();
        StatesList    = util.setupStatesPicklist();
        componentCountryChangeHandlerBilling();
        RedirectActOrder();
    }
    
    public list<SelectOption> getCountriesList(){
        return CountriesList;
    }
    public list<SelectOption> getStatesList(){
        return StatesList;
    }
    public void componentCountryChangeHandlerBilling(){
        StatesList = util.CountryChangeHandler(objContact.MailingCountry , objContact.MailingState);
    }
    
    public void updateUserContact(){
    Account objAccount = new Account();
    if(ApexPages.currentPage().getParameters().get('URLReference') == 'Self'){
    objAccount.Name = objContact.FirstName + ' ' + objContact.LastName;
    objAccount.Prospect_Type__c = 'Customer';
    objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
    objAccount.BillingStreet = objContact.MailingStreet;
    objAccount.BillingCity = objContact.MailingCity;
    objAccount.BillingState = objContact.MailingState;
    objAccount.BillingCountry = objContact.MailingCountry;
    objAccount.BillingPostalCode = objContact.MailingPostalCode;
    objAccount.Account_Status__c = 'In Review;';
    objAccount.Phone = objContact.Phone;
    objAccount.OwnerId = objContact.account.OwnerId;
    system.debug(objAccount+'===========@@@===========');
    }
        try{
            if(ApexPages.currentPage().getParameters().get('URLReference') == 'Self'){
            insert objAccount;
            objContact.AccountId = objAccount.Id;
            }
            objContact.Agree_to_myKVH_Terms_and_Conditions__c = boolAgreeTerms ? 'Accept' : 'Denied';
            objContact.Marketing_Communications__c = objContact.Agree_to_myKVH_Terms_and_Conditions__c;
            update objContact;
            system.debug(objAccount+'===========@@@==========='+objContact);
        }
        catch(exception e){
            System.debug(e.getMessage()+'===========@@@===========');
        }
    }
    
    public pageReference userRedirectPage(){
        user objUser = [SELECT Id, Agree_to_myKVH_Terms_and_Conditions__c, myKVH_Role__c, Start_URL__c FROM user WHERE id = :UserInfo.getUserId()]; 
        for (Landing_Page_Setting__mdt objLandingPageSettingmdt : [Select DeveloperName,MasterLabel, URL_Reference__c FROM Landing_Page_Setting__mdt WHERE DeveloperName =: ApexPages.currentPage().getParameters().get('URLReference')]){
            objUser.Start_URL__c = objLandingPageSettingmdt.URL_Reference__c;
            // Only one record
            update objUser;
        }
        list<myKVH_new_User_Defaults__c> defaultSettings = myKVH_new_User_Defaults__c.getall().values();
        Set<Id> setProfileId = New Set<Id>();
        for(myKVH_new_User_Defaults__c UserDefaults : defaultSettings)
            setProfileId.add(UserDefaults.SF_Profile_Id__c);
        PageReference pageRef = new PageReference('/home/home.jsp');
        system.debug('objUser===' + objUser);
        system.debug(setProfileId+'===setProfileId===' + setProfileId.contains(userinfo.getProfileId()));
        if(objUser.Agree_to_myKVH_Terms_and_Conditions__c != 'Accept' && setProfileId.contains(userinfo.getProfileId()))
            return null;
        else if(ApexPages.currentPage().getParameters().get('URLReference') == 'Self' && objUser.Agree_to_myKVH_Terms_and_Conditions__c != 'Accept')
            return null;
        else if(ApexPages.currentPage().getParameters().get('URLReference') != null && ApexPages.currentPage().getParameters().get('URLReference') != '' && objUser.Agree_to_myKVH_Terms_and_Conditions__c != 'Accept' ){
            return null;
        }
        else if(ApexPages.currentPage().getParameters().get('URLReference') != null && ApexPages.currentPage().getParameters().get('URLReference') != '' ){
            pageRef = new PageReference(string.escapeSingleQuotes(objUser.Start_URL__c));
            if(ApexPages.currentPage().getParameters().get('URLReference') == 'Shipboard_User' && String.isBlank(objUser.myKVH_Role__c)){
                pageRef = new PageReference('/home/home.jsp');
            }
        }
        system.debug('pageRef===' + pageRef);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public pageReference RedirectActOrder(){
        list<Activation_Subscriber__c> lstActivationSubscriber = [SELECT Contact__c,Activation_Order__r.Id,Activation_Order__r.Name, Activation_Order__r.Activation_Type__c, Activation_Order__r.Order_Status__c, Activation_Order__r.CreatedBy.Name,Activation_Order__r.CreatedDate FROM Activation_Subscriber__c WHERE Activation_Order__r.Activation_Type__c = 'Activation on behalf of Customer' and Activation_Order__r.Order_Status__c = 'Pending Customer Confirmation' and Contact__c In (Select ContactId From User Where Id = :UserInfo.getUserId())];
        if(lstActivationSubscriber.size() > 0){
            Set<Id> setActOrderId = New Set<Id>();
            Map<Id,String> mapActivationPlatform = New Map<Id,String>();
            Map<Id,String> mapActivationHardware = New Map<Id,String>();
            for(Activation_Subscriber__c lstSub:lstActivationSubscriber) setActOrderId.add(lstSub.Activation_Order__r.Id); 
            for(Activation_Platform__c objActivationPlatform : [SELECT Name,Activation_Order__r.id FROM Activation_Platform__c WHERE Activation_Order__r.id in :setActOrderId])
                mapActivationPlatform.put(objActivationPlatform.Activation_Order__r.id, objActivationPlatform.Name);
            for(Activation_Hardware__c objActivationHardware : [SELECT Root_Asset_Product_Group__c, Activation_Order__r.id FROM Activation_Hardware__c WHERE Activation_Order__r.id in :setActOrderId AND Recordtype.Name = 'Activation System'])
                mapActivationHardware.put(objActivationHardware.Activation_Order__r.id, objActivationHardware.Root_Asset_Product_Group__c);
            for(Activation_Subscriber__c lstSub:lstActivationSubscriber){
                ActivationOrderTable OrderTable = new ActivationOrderTable();
                OrderTable.Order = lstSub.Activation_Order__r.Name;
                OrderTable.OrderId = lstSub.Activation_Order__r.Id;
                OrderTable.CreatedBy = lstSub.Activation_Order__r.CreatedBy.Name;
                OrderTable.CreatedDate = lstSub.Activation_Order__r.CreatedDate.format('yyyy-MMM-dd');
                OrderTable.Platform=mapActivationPlatform.containsKey(lstSub.Activation_Order__r.Id) ? mapActivationPlatform.get(lstSub.Activation_Order__r.Id):'';
                OrderTable.SystemName=mapActivationHardware.containsKey(lstSub.Activation_Order__r.Id)?mapActivationHardware.get(lstSub.Activation_Order__r.Id):'';
                lstActivationOrderTable.add(OrderTable);
            }
        }
        return null; 
    }
        public pageReference Navigate(){
        ActivationStatus = readActivationStatus(ActOrderId);                     //get status record
        ActivationStatus.Active_Page__c = 'account setup';                              //set Active Page 
        ActivationStatus.Account_Setup_page__c = 'available'; 
        ActivationStatus.Account_Setup_Active_Tab__c = 'Subscriber_Information';
        ActivationStatus.Account_Setup_Last_Active_Tab_Index__c = 1;
        update ActivationStatus;
        //ActivationOrderTerms = false;
        PageReference pageRef = new PageReference('/apex/account_setup?order='+ActOrderId); 
        pageRef.setRedirect(true);
        return null; 
    }
    
    public pageReference AgreeActivationOrderTerms(){
        if(objContact.account.CPI__c == null){
            ActivationOrderTerms = true;
            return null;
        }
        else
            return Navigate();
    }
    
    public pageReference updateActivationOrderTerms(){
        Account objAccount = New Account();
        objAccount.Id = objContact.accountId;
        objAccount.CPI__c = strActivationOrderTerms;
        update objAccount;
        return Navigate();
    }
    
    public class ActivationOrderTable{
        Public String Order{get;set;}
        public Id OrderId{get;set;}
        Public String Platform{get;set;}
        Public String SystemName{get;set;}
        Public String CreatedBy{get;set;}
        Public String CreatedDate{get;set;}
    }
}