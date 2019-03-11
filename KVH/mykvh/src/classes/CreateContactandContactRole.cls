/***********************************************************************************************************************
Name: CreateContactandContactRole 
Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
Purpose: This is used to search "CreateContactandContactRole" class 
------------------------------------------------------------------------------------------------------------------------
Utilized in(Called in):
-----------------------

========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0     Gopi Kishore. K      09/05/2014       Initial Development                                   
***********************************************************************************************************************/


public class CreateContactandContactRole {
    public String ContactName{get;set;}
    public String ContactEmail{get;set;}
    public ID CaseID{get;set;}
    //Prepopulate Subscriber values when we are creating contact and contactRoles
    
    public String accountName{get;set;}
    public String customCallID{get;set;}
    
    public String titleOfNewContactRole{get;set;}
    
    //for Search ContactRecordsBlock
    public Boolean ContactRecordsBlock{get;set;}
    public Boolean ifRecordsNotFound{get;set;}
    public Boolean newContactAndContactRole{get;set;}
    public boolean listOfFieldsView{get;set;}
    public Boolean onlyNewContactFlds{get;set;}
    public Boolean onceClicked{get;set;}
    public Boolean searchAgainButton{get;set;}
    public Boolean roleDependentField{get;set;}
    // Displaying AccountDetails whenCreating newContact and ContactRoles
    public String selectedContactRole{get;set;}
    public List<ContactWithRadioWrapperClass> ContactSearchRecords{get;set;}
    public Contact newRecContactandContactRole{get;set;}
    public AccountContactRole newAccContactRole{get;set;}
    
    //Enable customer portaluser Button
    
    public boolean CPU{get;set;}
    
    
    
    Case currentCaseDetails;
    public CreateContactandContactRole(ApexPages.StandardController controller) {
        //Visible Variables
        roleDependentField = false;
        listOfFieldsView = false;
        ContactRecordsBlock = false;
        newContactAndContactRole = false;
        listOfFieldsView = false;
        onlyNewContactFlds = true;
        onceClicked = true;
        searchAgainButton = true;
        newRecContactandContactRole = new Contact();
        //newAccountContactRole for current caseSubscriber
        newAccContactRole = new AccountContactRole();
        CaseID = apexpages.currentpage().getparameters().get('caseid');
        //Case Subscriber Account Name and Customer Default values
        currentCaseDetails = [select id,Account.name,Account.Custom_Call_Acct_ID__c,AccountID,Account.Account_Type__c,Account.Revenue_Category__c from Case where id=:apexpages.currentpage().getparameters().get('caseid')];
        accountName  = currentCaseDetails.Account.Name;
        customCallID = currentCaseDetails.Account.Custom_Call_Acct_ID__c;
        
        //Default Values
        newRecContactandContactRole.Receive_Network_Service_Notifications__c = true;
        newRecContactandContactRole.AccountID = currentCaseDetails.AccountID;
        newAccContactRole.AccountID = currentCaseDetails.AccountID;
    }
    
    
    public List<selectOption> getContactRoleValues() {   
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('--None--','--None--'));
        options.add(new selectOption('Airtime Services Main Contact','Airtime Services Main Contact'));
        options.add(new selectOption('Airtime Services Authorized Rep','Airtime Services Authorized Rep'));
        options.add(new selectOption('Airtime Service Billing Contact','Airtime Service Billing Contact'));
        return options;
    }
    public List<selectOption> getAirtimeServiceOrder() {   
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('--None--','--None--'));
        Schema.DescribeFieldResult fieldResult = Contact.User_Activation_Order_Terms__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }     
        return options;
    }
    public List<selectOption> getTPersonalInfo() {  
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('--None--','--None--'));
        Schema.DescribeFieldResult fieldResult = Contact.Transfer_of_Personal_Information__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }     
        return options;
    }
    
    
    
    public void SearchforContact(){
        
        String Contacts;
        if(ContactName!=null)
            Contacts = 'select id,Name,email,Phone,Privacy_Policy_Paper__c,User_Activation_Order_Terms__c,Account.name,AccountID,Account.Account_Status__c,Account.Custom_Call_Acct_ID__c,Account.Account_Type__c,Account.recordtype.name from Contact where ';
        
        if(ContactName!=null && ContactName!=''){
            Contacts += ' Name LIKE \''+String.escapeSingleQuotes(ContactName)+'%\''+' '; Contacts += 'AND';
        }
        
        if(ContactEmail!=null && ContactEmail!=''){
            Contacts +=  ' Email LIKE \'%'+ContactEmail+'\''+' '; Contacts += 'AND';
        }
        
        Contacts = Contacts.Substring(0,Contacts.length()-3);
        
        
        Contacts += 'LIMIT 1000';
        
        ContactSearchRecords = new List<ContactWithRadioWrapperClass>();
        List<Contact> RelatedContacts = database.query(Contacts);
        if(RelatedContacts.size()>0){
            ContactRecordsBlock = true;
            ifRecordsNotFound = false;
            for(Contact allcontacts:RelatedContacts){
                ContactWithRadioWrapperClass ContactwithRadio = new ContactWithRadioWrapperClass();
                ContactwithRadio.selectedContact = false;
                ContactwithRadio.properSubscriberContact = allcontacts;
                ContactSearchRecords.add(ContactwithRadio);
            }
        }else{
            ContactRecordsBlock = false;  
            ifRecordsNotFound = true;
            searchAgainButton = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'No Contact Found'));
        }
    }
    
    
    Public ID selectedContactId;
    public void SelectedContact(){
        selectedContactId = System.currentPagereference().getParameters().get('id');
    }
    
    
    public void createNewContactAndContactRole(){
        //visibility for new contact and contactrole block
        onceClicked = false;
        newContactAndContactRole = true;
        titleOfNewContactRole = 'New Contact and ContactRole';
    }
    
    
    public void newContactRole(){
        //visibility for new contact and contactrole block
        newContactAndContactRole = true;
        onlyNewContactFlds = false;
        onceClicked = false;
        titleOfNewContactRole = 'New Contact Role';
        
        newRecContactandContactRole = [select id,FirstName,LastName,Email,Account.CPI__c,Transfer_of_Personal_Information__c,OtherPhone,phone,Receive_Network_Service_Notifications__c,Job_Function__c,Network_Notification_Type__c,Privacy_Policy_Paper__c,User_Activation_Order_Terms__c from Contact where id=:selectedContactId];
        //newRecContactandContactRole.Network_Notification_Type__c = 'Receive network notifications ONLY for outages LONGER than 4 hrs';
    }
    
    
    public void CreateAdditionContactRole(){
        newAccContactRole = new AccountContactRole();
        newAccContactRole.AccountID = currentCaseDetails.AccountID;
        onlyNewContactFlds = false;
        newContactAndContactRole = true;
        listOfFieldsView = false;
        system.Debug('ERROR AccounID:'+newAccContactRole);
    }
    
    public List<User> findCustomerPortalUser{get;set;}
    public void contactRolesave(){
        try{
            system.debug('===newRecContactandContactRole==='+newRecContactandContactRole);
            system.debug('===newRecContactandContactRole.User_Activation_Order_Terms__c==='+newRecContactandContactRole.User_Activation_Order_Terms__c);
            if(selectedContactRole != '--None--'&& selectedContactRole != '--None--'){
                if(selectedContactRole == 'Airtime Services Main Contact' && (newRecContactandContactRole.User_Activation_Order_Terms__c == '--None--' || newRecContactandContactRole.Transfer_of_Personal_Information__c == '--None--')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select Airtime Services Order Terms and Transfer of Personal Information'));
                }
                else{
                    if(newRecContactandContactRole.User_Activation_Order_Terms__c == '--None--')
                    newRecContactandContactRole.User_Activation_Order_Terms__c = '';
                    if(newRecContactandContactRole.Transfer_of_Personal_Information__c == '--None--')
                    newRecContactandContactRole.Transfer_of_Personal_Information__c = '';    
                    
                    //update Case contactandrole check box 
                    currentCaseDetails.Add_or_Update_Contacts_and_Roles__c = true;
                    update currentCaseDetails;
                    
                    //creation of newcontact/update contact
                    
                    if(newRecContactandContactRole.id == null && currentCaseDetails.Account.Revenue_Category__c=='VSAT' && selectedContactRole == 'Airtime Services Main Contact'){
                        newRecContactandContactRole.Network_Notification_Type__c = 'Receive network notifications ONLY for outages LONGER than 4 hrs';
                    }else{
                        if(selectedContactRole == 'Airtime Services Main Contact' && currentCaseDetails.Account.Revenue_Category__c=='VSAT' && newRecContactandContactRole.Network_Notification_Type__c == null){
                            newRecContactandContactRole.Network_Notification_Type__c = 'Receive network notifications ONLY for outages LONGER than 4 hrs';
                        }
                    }
                    
                    upsert newRecContactandContactRole;
                    
                    List<Account> updateContactAcc = new List<Account>([Select Id,Name,CPI__c from Account where Id =: newRecContactandContactRole.AccountId limit 1]);
                    if(updateContactAcc.size() > 0){
                        updateContactAcc[0].CPI__c = newRecContactandContactRole.User_Activation_Order_Terms__c;
                        update updateContactAcc[0];
                    }
                    system.debug(updateContactAcc[0]+'=====updateContactAcc[0]');
                    //New ContactRole Insert
                    newAccContactRole.contactID = newRecContactandContactRole.id;
                    newAccContactRole.Role = selectedContactRole;
                    insert newAccContactRole;
                    
                    validatingPortalUser(newRecContactandContactRole.id);
                    
                    //Calling Webservice Method while saving contactRole.
                    CallWebServiceMethod.callMethod(currentCaseDetails.AccountID,currentCaseDetails.Account.Account_Type__c);
                    
                    //blocks hiding variables
                    newContactAndContactRole = false;
                    listOfFieldsView = true;
                }
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select role'));
            }
        }catch(System.DmlException ex){
            system.debug('ERROR:'+ex);
            String exceptionchk = String.valueOF(ex);
            if(exceptionchk.contains('DUPLICATE_VALUE')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Contact has already been added in that Contact Role'));
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error:'+ex));
            }
        }
    }
    
    public void EnableCustomerPortalMethod(){
        getConvertedUserFormContact(newRecContactandContactRole);
    }
    
    
    public String myKVHUser{get;set;}
    public User getConvertedUserFormContact(Contact objContact){    
        system.debug(objContact);
        if(objContact != null){
            String kvhRoleNames;
            List<MyKVH_Direct_Customer_User__c> kvhRoles = [SELECT Name FROM MyKVH_Direct_Customer_User__c];
            for(MyKVH_Direct_Customer_User__c portalUserNames:kvhRoles){
                if(kvhRoleNames == null && kvhRoleNames ==''){
                    kvhRoleNames = portalUserNames.Name;
                }else{
                    kvhRoleNames = kvhRoleNames +','+portalUserNames.Name;
                }
            }
            if(kvhRoleNames!=null && kvhRoleNames!=''){
                kvhRoleNames = kvhRoleNames.replaceAll('null,', '');
            }
            //Select Exist Customer portel User's profile
            Profile pf = [SELECT Id FROM profile 
                          WHERE name='Customer Portal - Read/Write Case Access (all cases in accounts in hierarchy)' limit 1];   
            //Create user 
            User mockUser = new User(contactId=objContact.Id, 
                                     username=objContact.Email, 
                                     firstname=objContact.FirstName,
                                     lastname=objContact.LastName, 
                                     email=objContact.Email,
                                     communityNickname = objContact.LastName + '_'+Math.random(),
                                     alias = string.valueof(objContact.FirstName.substring(0,1) + 
                                                            objContact.LastName.substring(0,1)), 
                                     profileid = pf.Id, emailencodingkey='UTF-8',
                                     languagelocalekey='en_US', 
                                     localesidkey='en_US',
                                     myKVH_Role__c = kvhRoleNames, 
                                     timezonesidkey='America/Los_Angeles',UserPreferencesDisableAllFeedsEmail = false); 
            
            insert mockUser;
            
            System.resetPassword(mockUser.id,true);
            
            ID templateID = system.label.Portal_Email_Template_ID;
            ID OrgID      = UserInfo.getOrganizationId();
            ID userID     = mockUser.ID;
            ID contactID  = objContact.Id;
            
            /*Messaging.Singleemailmessage singleEmail = PortalUserEmail.GetTemplatedEmail(templateID,OrgID,contactID,CaseID,true);

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { singleEmail }); */
            
            validatingPortalUser(objContact.id);
            
            return mockUser;
        }
        
        return null;
    }
    
    public boolean portaluserDisable{get;set;}
    public void validatingPortalUser(ID userId){
        //Creating customer portalUser
        myKVHUser = 'Customer User';
        
        findCustomerPortalUser = [select id,Name,profile.Name,IsActive,UserRole.Name,myKVH_Role__c from user where ContactID=:userId];
        if(findCustomerPortalUser.size()== 0){
            Contact updateAccountCustomSharing = [select id,Account.Apply_Custom_Sharing__c from contact where ID=:userId];
            if(!updateAccountCustomSharing.Account.Apply_Custom_Sharing__c){
                updateAccountCustomSharing.Account.Apply_Custom_Sharing__c = true;
                update updateAccountCustomSharing.Account;
            }
            CPU = false;
            portaluserDisable = true;
            if(newAccContactRole.Role == 'Airtime Services Authorized Rep' || newAccContactRole.Role == 'Airtime Service Billing Contact'){
                portaluserDisable = false;
            }
        }else{
            CPU = true;
            portaluserDisable = false; 
        }
    }
    public pagereference pickListProcess(){
        if(selectedContactRole == 'Airtime Services Main Contact')
        roleDependentField = true;
        else
            roleDependentField = false;
        return null;
    }
    public pagereference returnToCase(){
        pagereference pagref = new pagereference('/'+currentCaseDetails.id);
        return pagref;
    }
    public class ContactWithRadioWrapperClass{
        public Boolean selectedContact{get;set;}
        public Contact properSubscriberContact{get;set;}
    }
}