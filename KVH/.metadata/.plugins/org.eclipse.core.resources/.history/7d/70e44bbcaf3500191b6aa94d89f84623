public without sharing class Act_Subscriber_component_controller extends Act_Base_component_controller{
    CountryStateMethods util = New CountryStateMethods();       //Helper Class
    public Activation_Subscriber__c newSubscriber;  //{get;set;}                    //The Activation Subscriber related to the Order! 
    public list<SelectOption> CountriesList = New list<SelectOption>();                     //List of Country Names for Subscriber Picklist
    public list<SelectOption> StatesList = New list<SelectOption>();                            //List of State Names for Subscriber Picklist
    public string selectedTab     {get;set;}
    public boolean checkFlag{get;set;}
    public string newProduct{get;set;} 
    public String parentContainer {get;set;} //Getting current component Id from VF Page
    private Id Customer_RECORD_TYPE_ID = Schema.SObjectType.Activation_Subscriber__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    private Set<String> setRoles = New Set<String>{'Airtime Main Contact'}; //(can be taken from custom setting)
        private static String strAddressTypeSubscriber = 'Airtime Services Subscriber';
    private static String strAddressTypeBilling = 'Airtime Services Billing';
    private Billing_Account__c objBillingAccount = New Billing_Account__c();
    Activation_Order__c objActivationOrder {get;set;}
    //Boolean for Internal User
    public boolean internalUser{
        set;
        get{
            if(internalUser == null)
            internalUser = [select contactId from User where id = :UserInfo.getUserId()].contactId == null;
            return internalUser;
        }
        
    }
    private Id strContactId;
    private Id strAccountId;
    Activation_Platform__c objActivationPlatform {get;set;}
    public Boolean isPartnerUserFlag;
    //Constructor
    public Act_Subscriber_component_controller(){
        CountriesList = util.setupCountryPicklist();
        StatesList = util.setupStatesPicklist();
    }
    
    //Getters and Setters
    public list<SelectOption> getCountriesList(){
        return CountriesList;
    }
    public list<SelectOption> getStatesList(){
        return StatesList;
    }
    
    public void componentCountryChangeHandler(){
        StatesList = util.CountryChangeHandler(newSubscriber.Country__c, newSubscriber.State_Province__c);
    }
    public void componentStateChangeHandler(){
        system.debug('Invoking State Change handler....');
    }
    
    public Activation_Subscriber__c getnewSubscriber(){     //reads subscriber details from the database
        system.debug('Invoking getnewSubscriber with Activation Order: ' + ActOrderId);     //handle a postback
        ActOrderId = ApexPages.currentPage().getParameters().get('order');  
        if(newSubscriber == null){
            objActivationOrder = New Activation_Order__c();
            List<Activation_Order__c> lstActivationOrder = New List<Activation_Order__c>();
            lstActivationOrder= [SELECT Id,Payment_Method__c,Case__c,Main_Contact__c,Hardware_Purchased_or_Leased__c,
                                 HasMainContactRole__c,Activation_Type__c,CreatedById, LastModifiedById,
                                 (SELECT Account__c, Contact__c, Website__c,
                                  Subscribing_Company__c,
                                  Subscriber_Phone_Type__c,
                                  Subscriber_Email__c,
                                  Subscriber_Contact_Salutation__c,
                                  Subscriber_Contact_Name__c,
                                  Subscriber_Contact_First_Name__c,
                                  Subscriber_Address_Line_2__c,
                                  State_Province__c,
                                  Secondary_Phone__c,
                                  Secondary_Phone_Type__c,
                                  Postal_Zip_Code__c,
                                  Phone_Number__c,
                                  Name,
                                  Id,
                                  Country__c,
                                  Country_Name__c,
                                  City__c,
                                  Address__c,
                                  Activation_Order__c,
                                  Pay_from_corporate_account_summary__c,
                                  Pay_from_sub_account_invoices__c,
                                  Bill_To_Corporate__c,
                                  Billing_Rep_Job_Title__c,
                                  Billing_Rep_Job_Function__c,
                                  Parent_Account_ID__c,
                                  Parent_Account_Custom_Call_Account_ID__c,
                                  RecordTypeId
                                  FROM Activation_Subscribers__r
                                  WHERE RecordTypeId =: Customer_RECORD_TYPE_ID)
                                 FROM Activation_Order__c 
                                 WHERE Id=:ActOrderId LIMIT 1];
            
            if(lstActivationOrder.size()>0){
                objActivationOrder = lstActivationOrder[0];
                list<Activation_Subscriber__c> act_subs  = New list<Activation_Subscriber__c>();
                act_subs = objActivationOrder.Activation_Subscribers__r;
                String mainContactId = ApexPages.currentPage().getParameters().get('mainContactId');
                if(act_subs.size() == 0 || (String.isBlank(mainContactId) && (lstActivationOrder[0].Activation_Type__c == 'Registration on behalf of Customer' || lstActivationOrder[0].Activation_Type__c == 'KVH Registration on behalf of Customer' ) && lstActivationOrder[0].CreatedById != UserInfo.getUserId() && lstActivationOrder[0].LastModifiedById != UserInfo.getUserId())){
                    // system.debug(act_subs.size() + ' Subscribers not found, creating a new one!');
                    newSubscriber = new Activation_Subscriber__c(Activation_Order__c = ActOrderId);//create a new subscriber
                    String CorporateAccountId = ApexPages.currentPage().getParameters().get('CorporateAccountId');
                    String AccountId = ApexPages.currentPage().getParameters().get('AccountId');
                    if(String.isBlank(mainContactId) && (lstActivationOrder[0].Activation_Type__c == 'Registration on behalf of Customer' || lstActivationOrder[0].Activation_Type__c == 'KVH Registration on behalf of Customer' ) && lstActivationOrder[0].CreatedById != UserInfo.getUserId()){
                        mainContactId = String.valueOf([SELECT ContactId FROM User WHERE ID =: UserInfo.getUserId()].ContactId);
                        AccountId = String.valueOf([SELECT AccountId FROM Contact WHERE ID =: mainContactId].AccountId);
                        if(act_subs.size()>0)
                            newSubscriber.Id = act_subs[0].Id;
                    }
                    // system.debug('mainContactId'+mainContactId);
                    
                    if(mainContactId != null && mainContactId != ''){
                        Contact objContact = contactRecord(mainContactId);
                        if(CorporateAccountId != null && CorporateAccountId != ''){
                            Map<String, Address__c> mapAddressType = accountRecord(CorporateAccountId);
                            //system.debug('mapAddressType'+mapAddressType);
                            if(mapAddressType.get(strAddressTypeSubscriber) != null){
                                newSubscriber.Address__c =  mapAddressType.get(strAddressTypeSubscriber).Address_1__c;
                                newSubscriber.Subscriber_Address_Line_2__c =  mapAddressType.get(strAddressTypeSubscriber).Address_2__c;
                                newSubscriber.City__c =  mapAddressType.get(strAddressTypeSubscriber).City__c;
                                newSubscriber.State_Province__c =  mapAddressType.get(strAddressTypeSubscriber).State__c;
                                newSubscriber.State_Province_ISO_Code__c =  mapAddressType.get(strAddressTypeSubscriber).State_Province_ISO_Code__c;   
                                newSubscriber.Country__c =  mapAddressType.get(strAddressTypeSubscriber).ISO_3166_2_Code__c;
                                newSubscriber.Country_Name__c = mapAddressType.get(strAddressTypeSubscriber).Country__c;
                                newSubscriber.Postal_Zip_Code__c =  mapAddressType.get(strAddressTypeSubscriber).Postal_ZipCode__c;
                            }
                            if(mapAddressType.get(strAddressTypeBilling) != null){
                                newSubscriber.Billing_Rep_Address__c =  mapAddressType.get(strAddressTypeBilling).Address_1__c;
                                newSubscriber.Billing_Rep_Address_Line_2__c =  mapAddressType.get(strAddressTypeBilling).Address_2__c;
                                newSubscriber.Billing_City__c =  mapAddressType.get(strAddressTypeBilling).City__c;
                                newSubscriber.Billing_State_Province__c =  mapAddressType.get(strAddressTypeBilling).State__c;
                                newSubscriber.Billing_State_Province_ISO_Code__c =  mapAddressType.get(strAddressTypeBilling).State_Province_ISO_Code__c; 
                                newSubscriber.Billing_Country__c =  mapAddressType.get(strAddressTypeBilling).ISO_3166_2_Code__c;
                                newSubscriber.Billing_Country_Name__c = mapAddressType.get(strAddressTypeBilling).Country__c;
                                newSubscriber.Billing_Zip_Code__c =  mapAddressType.get(strAddressTypeBilling).Postal_ZipCode__c;
                                newSubscriber.Preferred_Addressee__c =  mapAddressType.get(strAddressTypeBilling).Preferred_Addressee__c;  
                            }
                        }
                        
                        else if(AccountId != null && AccountId != ''){
                            list<Account> ObjAcc= [select BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry from account where id=:AccountId];
                            if(ObjAcc.size()>0){
                                list<KVH_Countries__mdt> ObjCountries = [SELECT Id, TrimmedName__c, IsoCode_2__c, IsoCode_3__c FROM KVH_Countries__mdt where TrimmedName__c=:ObjAcc[0].BillingCountry limit 1];
                                newSubscriber.Address__c =  ObjAcc[0].BillingStreet;
                                newSubscriber.City__c =  ObjAcc[0].BillingCity;
                                newSubscriber.Postal_Zip_Code__c =  ObjAcc[0].BillingPostalCode;
                                if(ObjCountries.size()>0)
                                    newSubscriber.Country__c =ObjCountries[0].IsoCode_2__c;
                                newSubscriber.Country_Name__c = ObjAcc[0].BillingCountry;
                                newSubscriber.State_Province__c =  ObjAcc[0].BillingState;  
                            }
                        }
                        
                        newSubscriber.Mail_to__c = objBillingAccount.Mail_to__c;
                        newSubscriber.Corp_Duplicate__c = objBillingAccount.Corp_Duplicate__c;
                        newSubscriber.Bill_to__c = objBillingAccount.Bill_to__c;
                        if(newSubscriber.Bill_to__c == 'Corporate'){
                            newSubscriber.Pay_from_corporate_account_summary__c = True;
                            newSubscriber.Pay_from_sub_account_invoices__c = False;
                            newSubscriber.Bill_To_Corporate__c = True;
                        }else{
                            newSubscriber.Pay_from_corporate_account_summary__c = False;
                            newSubscriber.Pay_from_sub_account_invoices__c = True;
                            newSubscriber.Bill_To_Corporate__c = False;
                        }
                        newSubscriber.Subscribing_Company__c = objBillingAccount.Name;
                        
                        newSubscriber.Subscriber_Contact_Salutation__c = objContact.Salutation;
                        newSubscriber.Subscriber_Contact_First_Name__c = objContact.FirstName;
                        newSubscriber.Subscriber_Contact_Name__c = objContact.LastName;
                        newSubscriber.Subscriber_Email__c = objContact.Email;
                        newSubscriber.Subscriber_Phone_Type__c = 'Business';
                        newSubscriber.Phone_Number__c = objContact.Phone;
                        newSubscriber.Billing_Rep_Job_Function__c = objContact.Job_Function__c;
                        newSubscriber.Billing_Rep_Job_Title__c = objContact.title;
                        if(objContact.MobilePhone != null)
                            newSubscriber.Secondary_Phone_Type__c = 'Mobile';
                        newSubscriber.Secondary_Phone__c = objContact.MobilePhone;
                        newSubscriber.Contact__c = mainContactId;
                        newSubscriber.Account__c = AccountId;
                        // system.debug('objContact' +objContact);
                    }
                    
                if(String.isNotBlank(newProduct)){
                    List<Activation_Subscriber__c> oldSubscriber = new List<Activation_Subscriber__c>();
                    oldSubscriber = [SELECT Id, Activation_Order__c, Address__c, Billing_City__c, Billing_Company__c, Billing_Country__c,
                                    Billing_Email__c, Billing_Fax_Number__c, Billing_Mobile_Phone__c, Billing_Phone_Number__c, 
                                    Billing_Phone_Type__c, Billing_Rep_Address_Line_2__c, Billing_Rep_Address__c, Billing_Rep_First_Name__c,
                                    Billing_Rep_Job_Function__c, Billing_Rep_Job_Title__c, Billing_Rep_Middle_Name__c, Billing_Rep_Name__c, 
                                    Billing_Rep_Salutation__c, Billing_Secondary_Phone_Type__c, Billing_Secondary_Phone__c, 
                                    Billing_State_Province__c, Billing_Zip_Code__c, City__c, Country__c, Fax_Number__c, KVH_Account_Number__c, 
                                    Phone_Number__c, Postal_Zip_Code__c, Secondary_Phone_Type__c, Secondary_Phone__c, State_Province__c, 
                                    Subscriber_Address_Line_2__c, Subscriber_Contact_First_Name__c, Subscriber_Contact_Middle_Name__c, 
                                    Subscriber_Contact_Name__c, Subscriber_Contact_Salutation__c, Subscriber_Email__c, Subscriber_Mobile_Phone__c, 
                                    Subscriber_Phone_Type__c, Subscribing_Company__c, Billing_Contact_Role__c, Contact_Role__c, Bill_to__c, 
                                    Pay_from_corporate_account_summary__c, Pay_from_sub_account_invoices__c, Parent_Account_Custom_Call_Account_ID__c, 
                                    Parent_Account_ID__c, Subscriber_Account_ID__c, Subscriber_Custom_Call_AccountID__c, Market_Sector__c, Market__c, 
                                    Website__c, Corp_Duplicate__c, Corporate_Billing_Account__c, Mail_to__c, Preferred_Addressee__c, 
                                    Billing_Country_Name__c, Country_Name__c, Same_as_Company_Address__c, Existing_Credit_Terms__c, Account__c, 
                                    Contact__c, Bill_To_Corporate__c, Mail_to_Corporate__c, Name FROM Activation_Subscriber__c
                                    WHERE Activation_Order__c =: newProduct];
                    system.debug(oldSubscriber.size()+'===oldSubscriber==='+oldSubscriber);
                    if(oldSubscriber.size() > 0)
                    newSubscriber = oldSubscriber[0];
                    newSubscriber.id = null;
                    newSubscriber.Activation_Order__c = ActOrderId;
                }
                } else {
                    // system.debug(act_subs.size() + ' Subscribers found, using existing record');
                    newSubscriber = act_subs[0];
                }
            }
            // system.debug('newSubscriber: ' + newSubscriber);
            componentCountryChangeHandler();
        }
        return newSubscriber;
    }
    
    @testVisible private void setnewSubscriber(){                       
        //system.debug('Invoking setnewSubscriber');
        save();
    }
    
    public PageReference Save(){
        //system.debug(newSubscriber);
        if(newSubscriber.Activation_Order__c == null){
            newSubscriber.Activation_Order__c = ActOrderId;
        }
        
        if(newSubscriber.Country__c != null){
            list<KVH_Countries__mdt> ObjCountries = [SELECT Id, TrimmedName__c, IsoCode_2__c, IsoCode_3__c FROM KVH_Countries__mdt where IsoCode_2__c=:newSubscriber.Country__c limit 1];
            if(ObjCountries.size()>0)newSubscriber.Country_Name__c = ObjCountries[0].TrimmedName__c;
        }
        String CorporateAccountId = ApexPages.currentPage().getParameters().get('CorporateAccountId');
        String CorporateAccountCCId = ApexPages.currentPage().getParameters().get('CorporateAccountCCId');
        String AccountId = ApexPages.currentPage().getParameters().get('AccountId');
        
        if(CorporateAccountId != null && CorporateAccountId != ''){
            newSubscriber.Parent_Account_ID__c = CorporateAccountId;
            newSubscriber.Parent_Account_Custom_Call_Account_ID__c = CorporateAccountCCId;
            newSubscriber.Corporate_Billing_Account__c = CorporateAccountId;
        }
        else if(AccountId != null && AccountId != ''){
            newSubscriber.Parent_Account_ID__c = AccountId;
        }
        newSubscriber.RecordTypeId = Customer_RECORD_TYPE_ID;
        
        /* if(objActivationOrder.Activation_Type__c == 'Activation on behalf of Customer'){ // && newSubscriber.Contact__c == null
contactGenerator(false);
newSubscriber.Contact__c = strContactId;
newSubscriber.Account__c = strAccountId;
//system.debug('strContactId'+strContactId);
//system.debug('strAccountId'+strAccountId);
}*/
        system.debug('===@@@newSubscriber@@@==='+newSubscriber);
        upsert newSubscriber;
        UpdateOrder();
        //setup to save Activation Subscriber and reload page.....
        PageReference reference = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        //system.debug(reference.getURL());                       //YIKES! That's a problem!
        reference.getParameters().clear();                      //BUT! we can just clear that stuff out...
        reference.getParameters().put('order', ActOrderId);     //add the order ID
        //system.debug(reference.getURL());                       //much better!
        reference.setRedirect(true);                            //this causes the constructors to run again...
        
        actStatus.Account_Setup_Active_Tab__c = selectedTab;    //Handle updates to Activation Status....
        update actStatus;
        return reference;
    }
    
    public void UpdateOrder(){
        if(newSubscriber.Contact__c != null){
            objActivationOrder.HasMainContactRole__c = false || (newSubscriber.Corporate_Billing_Account__c == null && newSubscriber.Contact__c == [SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1][0].ContactId) || objActivationOrder.Activation_Type__c == 'Airtime Case Activation' ;
            if(!Test.isRunningTest()){
                for(Billing_Account__c objBillingAccount : [SELECT ID FROM Billing_Account__c WHERE Main_Contact__c =: newSubscriber.Contact__c AND Id =: newSubscriber.Corporate_Billing_Account__c] ){
                    objActivationOrder.HasMainContactRole__c = true;
                }
            }
        }
        if(objActivationOrder != null){ 
            if((!objActivationOrder.HasMainContactRole__c && objActivationOrder.Activation_Type__c != 'Airtime Case Activation') && selectedTab != 'Installation_Type'){
                selectedTab = 'Billing_Information';
            }
            objActivationOrder.Payment_Method__c = newSubscriber.Bill_to__c == 'Corporate' ? 'Existing Credit Terms' : objActivationOrder.Payment_Method__c;
            update objActivationOrder;
        }     
    }
    public Contact contactRecord(String mainContactId){
        Contact objContact = [SELECT Id, Salutation,Job_Function__c,title, Phone, MobilePhone, Name, Email, FirstName, LastName FROM contact WHERE Id =: mainContactId];
        //system.debug('objContact' +objContact);
        return objContact;
    }
    
    public Map<String, Address__c> accountRecord(String accountId){
        //system.debug('accountId'+accountId);
        Map<String, Address__c> mapAddressType = New Map<String, Address__c>();
        for(Billing_Account__c objAccount : [SELECT Id, Name, Mail_to__c, Corp_Duplicate__c, Bill_to__c, (SELECT Id, Name, Address_1__c, Address_2__c, Address_Type__c, City__c, Postal_Zipcode__c, Country__c, State__c, State_Province_ISO_Code__c, Preferred_Addressee__c, ISO_3166_2_Code__c FROM Address__r WHERE (Address_Type__c =: strAddressTypeSubscriber OR Address_Type__c =: strAddressTypeBilling)) FROM Billing_Account__c WHERE Id =: accountId]){
            for(Address__c objAddress : objAccount.Address__r){
                mapAddressType.put(objAddress.Address_Type__c, objAddress);
            }
            objBillingAccount = objAccount;
        }
        //system.debug('mapAddressType' +mapAddressType);
        return mapAddressType;
    }
    
    public PageReference saveandExit(){
        // system.debug('selectedTab'+selectedTab);
        //setup to save Activation Contact and reload page.....
        // system.debug(newSubscriber);
        if(newSubscriber.Activation_Order__c == null){
            newSubscriber.Activation_Order__c = ActOrderId;
        }
        
        if(newSubscriber.Country__c != null){
            list<KVH_Countries__mdt> ObjCountries = [SELECT Id, TrimmedName__c, IsoCode_2__c, IsoCode_3__c FROM KVH_Countries__mdt where IsoCode_2__c=:newSubscriber.Country__c limit 1];
            if(ObjCountries.size()>0)newSubscriber.Country_Name__c = ObjCountries[0].TrimmedName__c;
        }
        String CorporateAccountId = ApexPages.currentPage().getParameters().get('CorporateAccountId');
        String CorporateAccountCCId = ApexPages.currentPage().getParameters().get('CorporateAccountCCId');
        String AccountId = ApexPages.currentPage().getParameters().get('AccountId');
        
        if(CorporateAccountId != null && CorporateAccountId != ''){
            newSubscriber.Parent_Account_ID__c = CorporateAccountId;
            newSubscriber.Parent_Account_Custom_Call_Account_ID__c = CorporateAccountCCId;
            newSubscriber.Corporate_Billing_Account__c = CorporateAccountId;
        }
        else if(AccountId != null && AccountId != ''){
            newSubscriber.Parent_Account_ID__c = AccountId;
        }
        newSubscriber.RecordTypeId = Customer_RECORD_TYPE_ID;
        upsert newSubscriber;
        UpdateOrder();
        return null;
    }
    
    
    //These variables used to create case
    private  String strSubject = '';
    private String strSymptom = '';
    private String strDescription = '';
    @future
    public static void createActOrderCase(String objJson){
        List<Activation_Order__c> lstobjActivationOrder = (List<Activation_Order__c>)Json.deserialize(objJson,List<Activation_Order__c>.class);
        Activation_Order__c actOrder = new Activation_Order__c();
        actOrder = lstobjActivationOrder[0];
        system.debug(lstobjActivationOrder+ '=====@@+==========' + actOrder.Case__c);
        if(actOrder.Case__c == null && actOrder.Main_Contact__c != null){
            Case actOrderCase = new Case();
            actOrderCase.Status = 'Pending Customer information';
            actOrderCase.Origin = 'Phone';
            actOrderCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airtime Service').getRecordTypeId();
            actOrderCase.Type = 'Product Registration';
            actOrderCase.Status = 'Pending Customer information';
            actOrderCase.Case_Symptom__c = 'Product Registration on-behalf of Customer';
            actOrderCase.Description = 'KVH - Registration on Behalf of Customer';
            actOrderCase.ContactId = actOrder.Main_Contact__c;
            
            try{
                insert actOrderCase; 
                actOrder.Case__c = actOrderCase.Id;    
                update actOrder; 
            }
            catch(exception ae){
            }
        }
    }
    public Boolean callfromOtherPage(Activation_Platform__c objActivationPlatform1, Boolean BoolIsCreateUser){
        objActivationPlatform = objActivationPlatform1;
        getnewSubscriber();
        system.debug('=====@@+=========='+BoolIsCreateUser );
        
        if((objActivationOrder.Activation_Type__c == 'Airtime Case Activation' || objActivationOrder.Activation_Type__c == 'Activation on behalf of Customer' || objActivationOrder.Activation_Type__c == 'Registration on behalf of Customer' || objActivationOrder.Activation_Type__c == 'KVH Registration on behalf of Customer') && (BoolIsCreateUser || (!BoolIsCreateUser && newSubscriber.Account__c == null))){ //&& newSubscriber.Account__c == null newSubscriber.Contact__c == null && 
            system.debug('=====@@Inside@@==========');
            Boolean boolIsErrorCase = contactGenerator(BoolIsCreateUser);
            if(!boolIsErrorCase){
                newSubscriber.Contact__c = strContactId;
                newSubscriber.Account__c = strAccountId;
                // system.debug('strContactId'+strContactId);
                // system.debug('strAccountId'+strAccountId);
                update newSubscriber;
            }else{
                system.debug('boolIsErrorCase'  +boolIsErrorCase);
                return true; //selfRegistrationException('showError', 'userFail'); //Maybe this is another tailored page..... 
            }
        } 
        return false;
    }
    public Boolean callfromOtherPage1(Activation_Platform__c objActivationPlatform1, Boolean BoolIsCreateUser,Boolean isPartnerUser){
    
        isPartnerUserFlag = isPartnerUser;
        objActivationPlatform = objActivationPlatform1;
        getnewSubscriber();
        if((objActivationOrder.Activation_Type__c == 'Airtime Case Activation' || objActivationOrder.Activation_Type__c == 'Activation on behalf of Customer' || objActivationOrder.Activation_Type__c == 'Registration on behalf of Customer' || objActivationOrder.Activation_Type__c == 'KVH Registration on behalf of Customer') && (BoolIsCreateUser || (!BoolIsCreateUser && newSubscriber.Account__c == null))){ //&& newSubscriber.Account__c == null newSubscriber.Contact__c == null && 
            Boolean boolIsErrorCase = contactGenerator(BoolIsCreateUser);
            if(!boolIsErrorCase){
                newSubscriber.Contact__c = strContactId;
                newSubscriber.Account__c = strAccountId;
                // system.debug('strContactId'+strContactId);
                // system.debug('strAccountId'+strAccountId);
                update newSubscriber;
            }else{
                system.debug('boolIsErrorCase'  +boolIsErrorCase);
                return true; //selfRegistrationException('showError', 'userFail'); //Maybe this is another tailored page..... 
            }
        } 
        return false;
    }
    
    
    public Boolean contactGenerator(Boolean BoolIsCreateUser){
    system.debug('Inside contactGenerator=========@@@===========================');
        List<List<SObject>> lstFound = searchObjects(newSubscriber.Subscriber_Email__c);
        List<User> foundUsers = ((List<User>)lstFound[0]);
        List<Contact> foundContacts  = ((List<Contact>)lstFound[1]);
        List<Lead> foundLeads = ((List<Lead>)lstFound[2]);
        system.debug(lstFound.size()+'lstFound=========@@@==========================='+lstFound);
        system.debug(foundUsers.size()+'foundUsers=========@@@==========================='+foundUsers);
        system.debug(foundContacts.size()+'foundContacts=========@@@==========================='+foundContacts);
        system.debug(foundLeads.size()+'foundLeads=========@@@==========================='+foundLeads);
        if(foundUsers.size() == 0){
            if(foundContacts.size() >1 && foundLeads.size() >1){
                strSubject = 'Review Multiple Contacts and Leads found for the Email :'+ newSubscriber.Subscriber_Email__c;
                strSymptom = 'New User Request';
                strDescription = 'Please investigate the duplicate contacts ('+foundContacts.size()+') and duplicate leads ('+foundContacts.size()+') with the same email address "'+newSubscriber.Subscriber_Email__c+'" that is attempting to complete Self-Registration';
                string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
                return true;
            }
            if(foundContacts.size() == 0){
                if(foundLeads.size() == 0){
                    if(objActivationPlatform != null){
                        Account objAccount = createPortalAccount();
                        if(objAccount.id != null){
                        system.debug('Outisde createCommunityContact=========@@@===========================');
                            Contact newContact = createCommunityContact(objAccount.Id);                     //We will have to create a Contact, THEN a User due to the fact that Contact.MailingCountry is required for RPS.
                            if(newContact.id != null ){
                                if(BoolIsCreateUser){
                                    User u = createCommunityUser(newContact.Id, 'ProdRegistration');
                                    system.debug(u);
                                    insertNewUser(u);
                                }
                                strContactId = newContact.id; 
                                strAccountId = newContact.AccountId; 
                            }else{
                                strSubject = 'Review Contact creation Error for the user Email :'+ newSubscriber.Subscriber_Email__c;
                                strSymptom = 'New User Request';
                                strDescription = '';
                                string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
                                return true;
                            }
                        }
                    }
                } else{ //one or more Leads....
                    return analyzeFoundLeads(foundLeads, BoolIsCreateUser); 
                }
            } else { //one or more Contacts....
                return analyzeFoundContacts(foundContacts, BoolIsCreateUser); 
            }
        } else { //one or more Users.....
            return analyzeFoundUsers(foundUsers, BoolIsCreateUser);
        }
        return false;
    }
    
    public List<List<SObject>> searchObjects(string queryParam){
        String strQuery = 'FIND \'' + queryParam + '\' IN ALL FIELDS RETURNING User(Id, Email, IsActive, username, lastName, firstName, contactId, Contact.AccountId, Contact.Email, Contact.Inactive_Contact__c WHERE username =: queryParam OR Email =: queryParam),Contact(Id, accountId, OwnerId, FirstName, LastName, Email, MailingCountry, Inactive_Contact__c WHERE Email =: queryParam), Lead(Id, Email, Country WHERE Email =: queryParam)'; 
        List<List<SObject>> lstSearch =search.query(strQuery);
        //system.debug('lstSearch' +strQuery);
        return lstSearch;
    }
    
    public Contact createCommunityContact(Id accountId){
        system.debug('createCommunityContact=========@@@' );
        Contact newContact = new Contact();
        newContact.accountId = accountId;
        newContact.MailingCountry = newSubscriber.Country__c;
        newContact.MailingState = newSubscriber.State_Province__c;
        newContact.FirstName = newSubscriber.Subscriber_Contact_First_Name__c;
        newContact.LastName = newSubscriber.Subscriber_Contact_Name__c;
        newContact.Email = newSubscriber.Subscriber_Email__c;
        newContact.MailingStreet = newSubscriber.Address__c;
        newContact.MailingCity = newSubscriber.City__c;
        newContact.Job_Function__c = newSubscriber.Billing_Rep_Job_Function__c;
        if(newSubscriber.Subscriber_Phone_Type__c == 'Mobile'){ 
            newContact.MobilePhone = newSubscriber.Secondary_Phone__c;
        }else{
            newContact.Phone = newSubscriber.Phone_Number__c;
        }
        newContact.MailingPostalCode = newSubscriber.Postal_Zip_Code__c;
        try{
            insert newContact;
        }catch(Exception E){
            //Exception may occur if we make some fields as mandatory in contact(future case)
            // system.debug('E.getMessage()'+E.getMessage());
            strSubject = 'Error while inserting Contact with Email :' + newSubscriber.Subscriber_Email__c;
            strSymptom = 'New User Request';
            strDescription = E.getMessage();
            string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
        }
        return newContact; 
    }
    
    public Account createPortalAccount(){
        Account objAccount = new Account();
        objAccount.Name = (newSubscriber.Subscribing_Company__c != '' && newSubscriber.Subscribing_Company__c != null ? newSubscriber.Subscribing_Company__c : (newSubscriber.Subscriber_Contact_First_Name__c +' '+ newSubscriber.Subscriber_Contact_Name__c));
        //objAccount.PersonEmail = newSubscriber.Subscriber_Email__c;
        objAccount.Phone = newSubscriber.Phone_Number__c;
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        objAccount.BillingStreet = newSubscriber.Address__c;
        objAccount.BillingCity = newSubscriber.City__c;
        objAccount.BillingState = newSubscriber.State_Province__c;
        objAccount.BillingCountry = newSubscriber.Country__c;
        objAccount.BillingPostalCode = newSubscriber.Postal_Zip_Code__c;
        //objAccount.Website = newSubscriber.Website__c;
        objAccount.Market__c =  objActivationPlatform.Market__c;
        objAccount.Market_Sector__c = objActivationPlatform.Market_Sector__c;
        try{
            insert objAccount;
        }catch(Exception E){
            strSubject = 'Error while inserting Account with Email :' + newSubscriber.Subscriber_Email__c;
            strSymptom = 'New User Request';
            strDescription = E.getMessage();
            string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
        }
        return objAccount; 
    }
    
    public User createCommunityUser(Id contactId, String strProfileName){                   //Creates User from Contact, but does not insert record
        system.debug(objActivationOrder.Activation_Type__c+'========123============');
        if(objActivationOrder.Activation_Type__c != 'KVH Registration on behalf of Customer'){
        //Need Portal Profile, myKVH Role... get from Custom Setting
        Contact portalContact = [SELECT Id, Name, FirstName, LastName, email FROM Contact WHERE Id =: contactId LIMIT 1];
        myKVH_new_User_Defaults__c defaultSettings = myKVH_new_User_Defaults__c.getValues(strProfileName); 
        // system.debug(defaultSettings);
        User userToCreate = new User();
        system.debug(defaultSettings +'========@@@==========');
        userToCreate.ProfileId = defaultSettings.SF_Profile_Id__c;          //set default profile first...
        //userToCreate.myKVH_Role__c = defaultSettings.myKVH_Role_Id__c;      //set default myKVH role first...
        userToCreate.ContactId = PortalContact.Id;
        userToCreate.username = portalContact.email;
        userToCreate.email = portalContact.email;
        userToCreate.LastName = newSubscriber.Subscriber_Contact_Name__c;
        userToCreate.FirstName = newSubscriber.Subscriber_Contact_First_Name__c;
        userToCreate.EmailEncodingKey = 'UTF-8';
        userToCreate.alias = newSubscriber.Subscriber_Contact_First_Name__c.substring(0,1) + newSubscriber.Subscriber_Contact_Name__c.substring(0,math.min(7,newSubscriber.Subscriber_Contact_Name__c.length()));
        //Nick Name length 40 only!
        String strnickname = newSubscriber.Subscriber_Contact_Name__c + '_'+ Math.random(); 
        userToCreate.communityNickname = strnickname.length() > 40 ? strnickname.substring(0, 40) : strnickname;
        //Copy Current Users details for a few attributes....
        userToCreate.LocaleSidKey = UserInfo.getLocale();
        userToCreate.LanguageLocaleKey = UserInfo.getLanguage();
        userToCreate.TimeZoneSidKey = UserInfo.getTimeZone().getId();
        return userToCreate;
        }
        else
        return null;
    }
    
    
    public Boolean analyzeFoundUsers(list<user> foundUsers, Boolean BoolIsCreateUser){        //This encapsulated method allows for complete testing
        //WE are already checking for a zero found users condition...
        system.debug(isPartnerUserFlag+'Inside analyzeFoundUsers=====@@'+foundUsers.size());
        List<User> lstUsersWithDupEmail = New List<User>();
        if (foundUsers.size() > 1){                           //found duplicate username! (tough to test!)
            strSubject = 'Review Duplicate Users for Self-Registration';
            strSymptom = 'New User Request';
            strDescription = 'Please investigate the duplicate users ('+foundUsers.size()+') with the same email address "'+foundUsers[0].Email+'" that is attempting to complete Self-Registration';
            string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
            return true;
        }else{       
        system.debug('Inside ELSE=====@@');    
             //Condition for InActive User and Inactive Contact 
             if(foundUsers[0].username == foundUsers[0].Email && foundUsers[0].IsActive == false && foundUsers[0].contactId != null && foundUsers[0].contact.Inactive_Contact__c == true){
                foundUsers[0].username = '_'+foundUsers[0].username;
                foundUsers[0].Email = '_'+foundUsers[0].Email;
                system.debug('Inside 1st ELSE IF=====@@'); 
                if(objActivationPlatform != null){
                    Account objAccount = createPortalAccount();
                    if(objAccount.id != null){
                        system.debug('Outisde createCommunityContact123=========@@@===========================');
                        Contact newContact = createCommunityContact(objAccount.id);
                        if(newContact.id != null && BoolIsCreateUser  && !isPartnerUserFlag){
                            system.debug('Not here inside====');
                            List<User> lstUpsertUsers = new List<User>();
                            lstUpsertUsers.add(foundUsers[0]);
                            User objUserToInsert = createCommunityUser(newContact.Id, 'ProdRegistration');
                            lstUpsertUsers.add(objUserToInsert);
                            ID jobIDUpsert = System.enqueueJob(new upsertUser(lstUpsertUsers));
                            sendContactEmailPortal(foundUsers[0]);
                        }
                        else if(newContact.id != null && BoolIsCreateUser  && isPartnerUserFlag){
                            sendContactEmailPartner(newContact); 
                        }
                        else{
                            strSubject = 'Review Contact creation Error for the user Email :'+ foundUsers[0].username;
                            strSymptom = 'New User Request';
                            strDescription ='User Record Id : '+foundUsers[0].Id;
                            string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
                            return true;
                        }
                    }
                }
            }
            //Condition for Active User and Active Contact 
            else if(foundUsers[0].username == foundUsers[0].Email && BoolIsCreateUser && foundUsers[0].IsActive == true && foundUsers[0].contactId != null && foundUsers[0].contact.Inactive_Contact__c == false){
                foundUsers[0].username = '_'+foundUsers[0].username;
                foundUsers[0].Email = '_'+foundUsers[0].Email;
                system.debug('Inside 2nd ELSE IF=====@@'); 
                if(objActivationPlatform != null){
                    //For Partner User
                    if(foundUsers[0] != null && BoolIsCreateUser  && isPartnerUserFlag){
                        List<Contact> newContlist = new List<Contact>();
                        newContlist = [select id,Name,Email,OwnerID from Contact where Id =: foundUsers[0].contactId limit 1];
                        sendContactEmailPartner(newContlist[0]); 
                    }
                    //For Customer Portal
                    else if(foundUsers[0] != null && BoolIsCreateUser  && !isPartnerUserFlag){
                        sendContactEmailPortal(foundUsers[0]); 
                    }
                    else{
                        strSubject = 'Review Contact creation Error for the user Email :'+ foundUsers[0].username;
                        strSymptom = 'New User Request';
                        strDescription ='User Record Id : '+foundUsers[0].Id;
                        string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
                        return true;
                    }
                }
            }
            //Condition for Active User and InActive Contact
            else if(foundUsers[0].username == foundUsers[0].Email && foundUsers[0].IsActive == false && foundUsers[0].contactId != null &&  foundUsers[0].contact.Inactive_Contact__c == false){
                system.debug('Inside 3rd ELSE IF=====@@'); 
                try{
                    foundUsers[0].IsActive = true;
                    foundUsers[0].ProfileId = myKVH_new_User_Defaults__c.getValues('ProdRegistration').SF_Profile_Id__c;
                    update foundUsers[0];
                    resetmyKVHPassword(foundUsers[0].Id);
                }catch(Exception E){
                    strSubject = 'Error while Updating User :' + foundUsers[0].username;
                    strSymptom = 'New User Request';
                    strDescription = E.getMessage();
                    string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
                    return true;
                }
            }else if(foundUsers[0].username != foundUsers[0].Email){
                system.debug('Inside 4th ELSE IF=====@@'); 
                strSubject = 'User name and Email Mismatch :' + newSubscriber.Subscriber_Email__c;
                strSymptom = 'New User Request';
                strDescription = 'User Record Id : '+foundUsers[0].Id;
                string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
                return true;
            }else if(foundUsers[0].username == foundUsers[0].Email && foundUsers[0].contactId == null){
                system.debug('Inside 5th ELSE IF=====@@'); 
                strSubject = 'Review No Contact for the Active User :'+ newSubscriber.Subscriber_Email__c;
                strSymptom = 'New User Request';
                strDescription = 'Please investigate the user(Id: '+foundUsers[0].Id+') which has no contact that is attempting to complete Self-Registration';
                string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
                return true;
            }else if(foundUsers[0].username == foundUsers[0].Email && foundUsers[0].IsActive == false){
                system.debug('Inside 6th ELSE IF=====@@'); 
                strSubject = 'Review Inactive User :' + newSubscriber.Subscriber_Email__c;
                strSymptom = 'New User Request';
                strDescription = 'Please investigate the Inactive User (Id: '+foundUsers[0].Id+') that is attempting to complete Self-Registration';
                string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
                return true;
            }
        }
        strContactId = foundUsers[0].contactId; 
        strAccountId = foundUsers[0].Contact.AccountId; 
        return false;
    }
    
    @testVisible private void insertNewUser(User objUser){
        try{
            // system.debug('objUser'+objUser);
            List<User> lstUpsertUsers = new List<User>();
            lstUpsertUsers.add(objUser);
            ID jobIDUpsert = System.enqueueJob(new upsertUser(lstUpsertUsers));   
        }catch(Exception E){
            //Exception may occur if we make some fields as mandatory in contact(future case)
            //system.debug('E.getMessage()'+E.getMessage());
            strSubject = 'Error while inserting User with Email :' + newSubscriber.Subscriber_Email__c;
            strSymptom = 'New User Request';
            strDescription = E.getMessage();
            string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
        }
    }
    
    private void sendContactEmailPartner(contact objContact){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(objContact.Id);
        mail.setWhatId(objActivationOrder.Id); 
        EmailTemplate objEmailTemplate=[SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName=:'Warranty_Registration_Submitted_on_Behalf_of'];
        mail.setTemplateId(objEmailTemplate.Id);
        OrgWideEmailAddress[] owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName  = 'Product Registration'];
        
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        String[] toAddresses = new String[] {objContact.Email};
        mail.setToAddresses(toAddresses); 
        mail.setUseSignature(false);
        mail.setBccSender(false);
        mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }
    private void sendContactEmailPortal(sObject objUser){
    /*
        system.debug('Portal Email=========');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Id ownerId = objUser.Id != null ? objUser.Id : userInfo.getUserId();
        mail.setTargetObjectId(ownerId);
        mail.setSenderDisplayName('Salesforce Support');
        mail.setUseSignature(false);
        mail.setBccSender(false);
        mail.setSaveAsActivity(false);
        EmailTemplate objEmailTemplate=[SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName=:'KVH_Registration_Submitted_on_Behalf_of'];
        mail.setTemplateId(objEmailTemplate.Id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        */
    }
    private void sendContactEmail(contact objContact){
        system.debug('Portal Email=========');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Id ownerId = objContact.OwnerID != null ? objContact.OwnerID : userInfo.getUserId();
        mail.setTargetObjectId(ownerId);
        mail.setSenderDisplayName('Salesforce Support');
        mail.setUseSignature(false);
        mail.setBccSender(false);
        mail.setSaveAsActivity(false);
        EmailTemplate objEmailTemplate=[SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName=:'KVH_Customer_Community_Contact'];
        mail.setTemplateId(objEmailTemplate.Id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }
    
    public Boolean analyzeFoundContacts(list<Contact> foundContacts, Boolean BoolIsCreateUser){
    system.debug('=======@@analyzeFoundContacts@@@====='+BoolIsCreateUser);
        //WE are already checking for a zero found contacts condition...
        if (foundContacts.size() > 1){ 
            //found duplicate contact email! 
            strSubject = 'Review Duplicate Contacts for Self-Registration';
            strSymptom = 'New User Request';
            strDescription = 'Please investigate the duplicate contacts ('+foundContacts.size()+') with the same email address "'+foundContacts[0].Email+'" that is attempting to complete Self-Registration';
            string caseNum = createCase(strSubject, strSymptom, strDescription);
            return true;
        } else {                                                    //found 1 and only 1 contact with that name :) 
            //system.debug(foundContacts[0]);
            if(foundContacts[0].AccountId == null && objActivationPlatform != null){ //orphan contact!!
            system.debug('=======@@Orphan@@@=====');
                Account objAccount = createPortalAccount();
                if(objAccount.id != null){
                    foundContacts[0].AccountId = objAccount.id;
                    update foundContacts[0];
                }
                if(BoolIsCreateUser && isPartnerUserFlag == false){
                    User objUser = createCommunityUser(foundContacts[0].Id, 'ProdRegistration');
                    List<User> lstUpsertUsers = new List<User>();
                    lstUpsertUsers.add(objUser);
                    ID jobIDUpsert = System.enqueueJob(new upsertUser(lstUpsertUsers));                       //update the User and asynchonously! TODO?? bulkify 
                    sendContactEmail(foundContacts[0]);
                    sendContactEmailPortal(foundContacts[0]);
                }
                else if(BoolIsCreateUser){
                sendContactEmailPartner(foundContacts[0]);
                }
            }else{
            system.debug('=======@@Not Orphan@@@====='+isPartnerUserFlag );
                if(BoolIsCreateUser && !isPartnerUserFlag){
                    User u = createCommunityUser(foundContacts[0].Id, 'ProdRegistration');
                    // system.debug(u);
                    insertNewUser(u);
                    sendContactEmailPortal(foundContacts[0]);
                }
                else if(BoolIsCreateUser){
                sendContactEmailPartner(foundContacts[0]);
                }
            }
        }
        strContactId = foundContacts[0].Id;
        strAccountId = foundContacts[0].AccountId;
        return false;
    }
    
    public Boolean analyzeFoundLeads(list<Lead> foundLeads, Boolean BoolIsCreateUser){
        //WE are already checking for a zero found leads condition...
        if (foundLeads.size() > 1){                              //found duplicate lead email! 
            strSubject = 'Review Duplicate Leads for Self-Registration';
            strSymptom = 'New User Request';
            strDescription = 'Please investigate the duplicate leads ('+foundLeads.size()+') with the same email address "'+foundLeads[0].Email+'" that is attempting to complete Self-Registration';
            string caseNum = createCase(strSubject, strSymptom, strDescription);
            return true;
        } else {                                                    //found 1 and only 1 contact with that name :) 
            // system.debug(foundLeads[0]);
            foundLeads[0].Country = newSubscriber.Country_Name__c;
            update foundLeads[0];
            Database.LeadConvert objLeadConvert = new database.LeadConvert();
            objLeadConvert.setLeadId(foundLeads[0].Id);
            objLeadConvert.setDoNotCreateOpportunity(True);
            objLeadConvert.setSendNotificationEmail(True);
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            objLeadConvert.setConvertedStatus(convertStatus.MasterLabel);
            try{
                Database.LeadConvertResult objLeadConvertResult = Database.convertLead(objLeadConvert);
                if(objLeadConvertResult.isSuccess()){
                    strContactId = objLeadConvertResult.getContactId();
                    strAccountId = objLeadConvertResult.getAccountId();
                    if(BoolIsCreateUser){
                        User u = createCommunityUser(objLeadConvertResult.getContactId(), 'ProdRegistration');
                        // system.debug(u);
                        insertNewUser(u);
                    }
                }else{
                    // system.debug(logginglevel.ERROR,'String.valueOf(objLeadConvertResult.getErrors()[0])'+String.valueOf(objLeadConvertResult.getErrors()[0]));
                    strSubject = 'Lead convertion failed with Email : ' + foundLeads[0].Email;
                    strSymptom = 'New User Request';
                    strDescription = String.valueOf(objLeadConvertResult.getErrors()[0]);
                    string caseNum = createCase(strSubject, strSymptom, strDescription);
                    return true;
                } 
            }catch(Exception E){
                //Exception may occur if we make some mandatory fields in lead(future case)
                // system.debug(logginglevel.ERROR,'E.getMessage()'+E.getMessage());
                strSubject = 'Error while converting lead with Email :' + foundLeads[0].Email;
                strSymptom = 'New User Request';
                strDescription = E.getMessage();
                string caseNum = createCase(strSubject, strSymptom, strDescription);
                return true;
            }
            
        }
        return false;
    }
    
    @testVisible private string createCase(string strSubject, String strSymptom, String strDescription){ //Used to create a case when something weird happens....
        final Id ServCloudCase_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
        final Group SvcCloudQueue = [SELECT Id FROM Group WHERE DeveloperName = 'Service_Cloud_Queue' and Type = 'Queue'];
        Case newCase = new Case();
        newCase.RecordTypeId = ServCloudCase_RECORD_TYPE_ID;
        //newCase.ContactId = currentUser.ContactId;
        newCase.Subject = strSubject;
        newCase.Origin = 'Web';
        newCase.Case_Symptom__c = strSymptom;
        newCase.Status = 'New';
        newCase.Description = strDescription + '(Login User : '+userInfo.getUserName()+') For Activation Order Id: ' + ActOrderId;
        newCase.OwnerId = SvcCloudQueue.Id;
        insert newCase;
        system.debug(newCase); 
        return newCase.Id;
    }
    
    public pageReference selfRegistrationException(String strParamName, String isShowMessage){
        pageReference returnPage = page.SelfRegException;
        returnPage.getParameters().put(strParamName,isShowMessage);
        returnPage.setRedirect(true);   
        return returnPage;
    }
    
    /* This Class was originally created to avoid a mixed DML Exception, but with appears to work OK in Spring '16
* Leaving this Class in, but commented out */
    
    public class upsertUser implements Queueable{         //Queueable Class to avoid Mixed DML
        private List<User> lstUpsertUsers = new List<User>();                    //Needs a User to create (should NOT have a record ID!)
        
        public upsertUser(List<User> communityUsers){            //constructor, handles input parameter
            this.lstUpsertUsers = communityUsers;                         // "u" is visible to Class now.
        }
        public void execute(QueueableContext context){  //Mandatory Execute method
            // upsert not allowed :(
            List<User> lstUpdateUsers = new List<User>();
            List<User> lstInsertUsers = new List<User>();
            if(lstUpsertUsers.size() > 0){
                for(Integer i=0;i<lstUpsertUsers.size();i++){
                    if(lstUpsertUsers[i].Id <> null){
                        lstUpdateUsers.add(lstUpsertUsers[i]);
                    }else{
                        lstInsertUsers.add(lstUpsertUsers[i]);
                    }
                }
            }
            if(lstUpdateUsers.size()>0){
                update lstUpdateUsers;
            }
            if(lstInsertUsers.size()>0){
                insert lstInsertUsers;
                resetmyKVHPassword(lstInsertUsers[0].Id);                   //send the email in an @future method!
            }
            //system.debug(lstUpdateUsers); 
            //system.debug(lstInsertUsers);
        }
    }
    
    @future static void resetmyKVHPassword(Id uId){     //Asynch method to reset password and send email (NOT part of inner Class!)
        system.resetPassword(uId, true);                //since we apparently can't do it from within the queueable execute method!
    }
    
    
}