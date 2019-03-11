public /*with sharing*/ class SelfRegRegisterController {
    
    private static Id PORTAL_ACCOUNT_ID =  DefaultAccounts__c.getInstance('SelfRegisteredAccount').Account_ID__c; //Account ID for self registered Users
    CountryStateMethods util = New CountryStateMethods();               //Helper Class
    
    public list<SelectOption> CountriesList = New list<SelectOption>(); //List of Country Names for Subscriber Picklist
    public list<SelectOption>    StatesList =New list<SelectOption>();
    public String username {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String country {get; set;}
    public String state {get; set;}
    
    //These variables used to create case
    public  String strSubject = '';
    public String strSymptom = '';
    public String strDescription = '';
    
    //Constructor...
    public SelfRegRegisterController() {
        CountriesList = util.setupCountryPicklist();
        StatesList    = util.setupStatesPicklist();
    }
    public list<SelectOption> getCountriesList(){
        return CountriesList;
    }
    public list<SelectOption> getStatesList(){
        return StatesList;
    }
    public void componentCountryChangeHandlerBilling(){
        system.debug('country'  +country);
        StatesList = util.CountryChangeHandler(country, state);
    }
     public void componentStateChangeHandlerBilling(){
       // system.debug('Invoking State Change handler....');
    }
    public PageReference registerUser() {
        //system.debug('SelfRegRegisterController.Invoking registerUser()....');
        
        string queryParam = username;
        List<User> foundUsers = [SELECT Id, Email, IsActive, username, lastName, firstName, contactId, Contact.AccountId, Contact.Email, Contact.Inactive_Contact__c FROM User WHERE (username =: queryParam OR Email =: queryParam) AND usertype != 'Standard'];
        List<Contact> foundContacts  = [SELECT Id, accountId, OwnerId, FirstName, LastName, Email, MailingCountry, Inactive_Contact__c FROM Contact WHERE Email =: queryParam];
        List<Lead> foundLeads = [SELECT Id, Email, Country from Lead WHERE Email =: queryParam];
        system.debug('foundUsers '+foundUsers.size());
        system.debug('foundContacts '+foundContacts.size());
        system.debug('foundLeads '+foundLeads.size());
        if(foundUsers.size() == 0){
            if(foundContacts.size() >=1 && foundLeads.size() >=1){
                strSubject = 'Review Multiple Contacts and Leads found for the Email :'+ username;
                strSymptom = 'New User Request';
                strDescription = 'Please investigate the duplicate contacts ('+foundContacts.size()+') and duplicate leads ('+foundContacts.size()+') with the same email address "'+username+'" that is attempting to complete Self-Registration';
                string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
            }
            if(foundContacts.size() == 0){
                if(foundLeads.size() == 0){
                    //We will have to create a Contact, THEN a User due to the fact that Contact.MailingCountry is required for RPS.
                    Contact newContact = createCommunityContact(PORTAL_ACCOUNT_ID);
                    system.debug(newContact+'==============');
                    if(newContact.id != null){
                        User u = createCommunityUser(newContact.Id, 'SelfRegisteredDefaults');
                      //  system.debug(u);
                        return insertNewUser(u);
                    }else{
                        strSubject = 'Review Contact creation Error for the user Email :'+ username;
                        strSymptom = 'New User Request';
                        strDescription = '';
                        string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
                        return selfRegistrationException('showError', 'contactFail');
                    }
                }else{ //one or more Leads....
                    return analyzeFoundLeads(foundLeads); 
                }
            } else { //one or more Contacts....
                return analyzeFoundContacts(foundContacts); 
            }
        } else { //one or more Users.....
            return analyzeFoundUsers(foundUsers);
        }
        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'User Search returned ' + foundUsers.size() + ' Users...'));
    }
    
    public Contact createCommunityContact(Id accountId){
       // system.debug('country ' + country);
        Contact newContact = new Contact();
        newContact.accountId = accountId;
        newContact.MailingCountry = country;
        newContact.MailingState = state;
        newContact.FirstName = firstName;
        newContact.LastName = lastName;
        newContact.email = username;
        try{
            insert newContact;
        }catch(Exception E){
            //Exception may occur if we make some fields as mandatory in contact(future case)
           // system.debug('E.getMessage()'+E.getMessage());
            strSubject = 'Error while inserting Contact with Email :' + username;
            strSymptom = 'New User Request';
            strDescription = E.getMessage();
            string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
        }
        return newContact; 
    }
    
    public User createCommunityUser(Id contactId, String strProfileName){                   //Creates User from Contact, but does not insert record
        //Need Portal Profile, myKVH Role... get from Custom Setting
        Contact portalContact = [SELECT Id, Name, FirstName, LastName, email FROM Contact WHERE Id =: contactId LIMIT 1];
       // system.debug(defaultSettings);
        User userToCreate = new User();
        string launch = ApexPages.currentPage().getParameters().get('reg');
        if (launch == null){
            myKVH_new_User_Defaults__c defaultSettings = myKVH_new_User_Defaults__c.getValues(strProfileName); 
            userToCreate.ProfileId = defaultSettings.SF_Profile_Id__c;
        } else {
            Profile ProfId = [SELECT Id FROM Profile WHERE Name = 'Customer Portal - Product Registration Only' LIMIT 1];
            userToCreate.ProfileId = ProfId.Id;
        }
                  //set default profile first...
        //userToCreate.myKVH_Role__c = defaultSettings.myKVH_Role_Id__c;      //set default myKVH role first...
        userToCreate.ContactId = PortalContact.Id;
        userToCreate.username = portalContact.email;
        userToCreate.email = portalContact.email;
        userToCreate.LastName = lastName;
        userToCreate.FirstName = firstName;
        userToCreate.EmailEncodingKey = 'UTF-8';
        userToCreate.alias = firstName.substring(0,1) + lastName.substring(0,math.min(7,lastName.length()));
        //Nick Name length 40 only!
        String strnickname = lastName + '_'+ Math.random(); 
        userToCreate.communityNickname = strnickname.length() > 40 ? strnickname.substring(0, 40) : strnickname;
        //Copy Current Users details for a few attributes....
        userToCreate.LocaleSidKey = UserInfo.getLocale();
        userToCreate.LanguageLocaleKey = UserInfo.getLanguage();
        userToCreate.TimeZoneSidKey = UserInfo.getTimeZone().getId();
        return userToCreate;
    }
    
    public pageReference analyzeFoundUsers(list<user> foundUsers){        //This encapsulated method allows for complete testing
        //WE are already checking for a zero found users condition...
        
        List<User> lstUsersWithDupEmail = New List<User>();
        if (foundUsers.size() > 1){                           //found duplicate username! (tough to test!)
            strSubject = 'Review Duplicate Users for Self-Registration';
            strSymptom = 'New User Request';
            strDescription = 'Please investigate the duplicate users ('+foundUsers.size()+') with the same email address "'+foundUsers[0].Email+'" that is attempting to complete Self-Registration';
            string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
            return selfRegistrationException('showError', 'moreUsers');  //Maybe we make a page tailored to "username not available"
        }else{
            if(foundUsers[0].username == foundUsers[0].Email && foundUsers[0].IsActive == false && foundUsers[0].Contact.Id != null && foundUsers[0].contact.Inactive_Contact__c == true){
                foundUsers[0].username = '_'+foundUsers[0].username;
                foundUsers[0].Email = '_'+foundUsers[0].Email;
                Contact newContact = createCommunityContact(PORTAL_ACCOUNT_ID);
                if(newContact.id != null){
                    List<User> lstUpsertUsers = new List<User>();
                    lstUpsertUsers.add(foundUsers[0]);
                    User objUserToInsert = createCommunityUser(newContact.Id, 'SelfRegisteredDefaults');
                    lstUpsertUsers.add(objUserToInsert);
                    ID jobIDUpsert = System.enqueueJob(new upsertUser(lstUpsertUsers));                       //update the User and asynchonously! TODO?? bulkify 
                    return selfRegistrationConfirm('login','true'); 
                }else{
                    strSubject = 'Review Contact creation Error for the user Email :'+ foundUsers[0].username;
                    strSymptom = 'New User Request';
                    strDescription ='User Record Id : '+foundUsers[0].Id;
                    string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
                    return selfRegistrationException('showError', 'contactFail'); 
                }
            }else if(foundUsers[0].username == foundUsers[0].Email && foundUsers[0].IsActive == false && foundUsers[0].ContactId != null &&  foundUsers[0].contact.Inactive_Contact__c == false){
                try{
                    foundUsers[0].IsActive = true;
                    foundUsers[0].ProfileId = myKVH_new_User_Defaults__c.getValues('LimitedCustomerUser').SF_Profile_Id__c;
                    update foundUsers[0];
                    resetmyKVHPassword(foundUsers[0].Id);
                }catch(Exception E){
                    //system.debug('Exception' + E.getMessage());
                    strSubject = 'Error while Updating User :' + foundUsers[0].username;
                    strSymptom = 'New User Request';
                    strDescription = E.getMessage();
                    string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
                    return selfRegistrationException('showError', 'userUpdateFail');  //Maybe this is another tailored page..... 
                }
                return selfRegistrationConfirm('login','true');
            }else if(foundUsers[0].username != foundUsers[0].Email){
                strSubject = 'User name and Email Mismatch :' + username;
                strSymptom = 'New User Request';
                strDescription = 'User Record Id : '+foundUsers[0].Id;
                string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
                return selfRegistrationException('showError', 'userMismatch');  //Maybe this is another tailored page..... 
            }else if(foundUsers[0].username == foundUsers[0].Email && foundUsers[0].Contact.Id == null){
                strSubject = 'Review No Contact for the Active User :'+ username;
                strSymptom = 'New User Request';
                strDescription = 'Please investigate the user(Id: '+foundUsers[0].Id+') which has no contact that is attempting to complete Self-Registration';
                string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
                return selfRegistrationException('showError', 'noContact'); //Maybe this is another tailored page..... 
            }else if(foundUsers[0].username == foundUsers[0].Email && foundUsers[0].IsActive == false){
                strSubject = 'Review Inactive User :' + username;
                strSymptom = 'New User Request';
                strDescription = 'Please investigate the Inactive User (Id: '+foundUsers[0].Id+') that is attempting to complete Self-Registration';
                string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
                return selfRegistrationException('showError', 'inactiveUser'); //Maybe this is another tailored page..... 
            }else{
                // User with same username already exists!!
                return selfRegistrationLogin('true');
            }
        }
    }
    
    @testVisible private pageReference insertNewUser(User objUser){
        try{
            List<User> lstUpsertUsers = new List<User>();
            lstUpsertUsers.add(objUser);
            ID jobIDUpsert = System.enqueueJob(new upsertUser(lstUpsertUsers));   
           // insert objUser;
           // resetmyKVHPassword(objUser.Id);                   //send the email in an @future method!
            string launch = ApexPages.currentPage().getParameters().get('reg');
            if( launch == 'true' ) {
                return selfRegistrationConfirm('reg','true');              
                    }
            else if(launch == 'onbehalf'){
                return selfRegistrationConfirm('reg','onbehalf');
            }
            else if(launch == 'Self'){
                return selfRegistrationConfirm('reg','Self');
            }
            else {
                return selfRegistrationConfirm('login','true'); 
                    }
        }catch(Exception E){
            //Exception may occur if we make some fields as mandatory in contact(future case)
            //system.debug('E.getMessage()'+E.getMessage());
            strSubject = 'Error while inserting User with Email :' + username;
            strSymptom = 'New User Request';
            strDescription = E.getMessage();
            string caseNum = createCase(strSubject, strSymptom, strDescription); //should NEVER happen!!!
            return selfRegistrationException('showError', 'userFail'); //Maybe this is another tailored page..... 
        }
    }
    
    @testVisible private pageReference selfRegistrationLogin(String isFound){
        pageReference returnPage = page.SelfRegLogin;
        if(ApexPages.currentPage().getParameters().get('reg') == 'onBehalf'){
            string orderId = ApexPages.currentPage().getParameters().get('orderId');
            returnPage.getParameters().put('reg', 'onBehalf');
            returnPage.getParameters().put('orderId', orderId);            
        } else if(ApexPages.currentPage().getParameters().get('reg') == 'true'){
            returnPage.getParameters().put('reg', 'true');
        }
        returnPage.getParameters().put('isFound',isFound);
        returnPage.setRedirect(true);   
        return returnPage;
    }
    
    private pageReference selfRegistrationConfirm(String strParamName, String isShowMessage){
        pageReference returnPage = page.SelfRegRegisterConfirm;
        if(isShowMessage == 'onbehalf') {
            string orderId = ApexPages.currentPage().getParameters().get('orderId');
            returnPage.getParameters().put('orderId', orderId);
            returnPage.getParameters().put('reg', 'onBehalf');
            returnPage.setRedirect(true); 
            return returnPage;
        } else if(strParamName == 'reg' && isShowMessage != 'Self') {
            returnPage.getParameters().put('reg', 'true');
            returnPage.setRedirect(true);   
            return returnPage; 
        } else if(strParamName == 'reg' && isShowMessage == 'Self') {
            returnPage.getParameters().put('reg', 'Self');
            returnPage.setRedirect(true);   
            return returnPage; 
        } 
        else {
        returnPage.getParameters().put(strParamName,isShowMessage);
        returnPage.setRedirect(true);   
        return returnPage; 
        }
    }
    
    public string gotoLogin() {
        string returnPage;
        string launch = ApexPages.currentPage().getParameters().get('reg');
        if ( launch == 'true') {
            returnPage = '/SiteLoginProduct?reg=true';
        } else if(launch == 'onbehalf') {
            string orderId = ApexPages.currentPage().getParameters().get('orderId');
            returnPage = '/SiteLoginProduct?reg=onBehalf&orderId=' + orderId;
        } 
        else if(launch == 'Self') {
            returnPage = '/SiteLoginProduct?reg=Self';
        } 
        else {
            returnPage = '/SiteLoginProduct';        
        }
        return returnPage;        
    }
    private pageReference selfRegistrationException(String strParamName, String isShowMessage){
        pageReference returnPage = page.SelfRegException;
        returnPage.getParameters().put(strParamName,isShowMessage);
        returnPage.setRedirect(true);   
        return returnPage;
    }
    
    private void sendContactEmail(contact objContact){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Id ownerId = objContact.OwnerID != null ? objContact.OwnerID : userInfo.getUserId();
        mail.setTargetObjectId(ownerId);
        mail.setSenderDisplayName('Salesforce Support');
        mail.setUseSignature(false);
        mail.setBccSender(false);
        mail.setSaveAsActivity(false);
        EmailTemplate objEmailTemplate=[SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName=:'KVH_Customer_Community_Contact'];
        String strplainBody = objEmailTemplate.Body;
        strplainBody = strplainBody.replace('{!Contact.Link}', URL.getSalesforceBaseUrl().toExternalForm()+'/'+objContact.Id);
        mail.setTemplateId(objEmailTemplate.Id);
        mail.setPlainTextBody(strplainBody);
        //system.debug('mail--'+mail);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }
    
    public pageReference analyzeFoundContacts(list<Contact> foundContacts){
        //WE are already checking for a zero found contacts condition...
        if (foundContacts.size() > 1){ 
            //found duplicate contact email! 
            strSubject = 'Review Duplicate Contacts for Self-Registration';
            strSymptom = 'New User Request';
            strDescription = 'Please investigate the duplicate contacts ('+foundContacts.size()+') with the same email address "'+foundContacts[0].Email+'" that is attempting to complete Self-Registration';
            string caseNum = createCase(strSubject, strSymptom, strDescription);
            return selfRegistrationException('showError', 'moreContacts');    //Maybe we make a page tailored to "processing request"
        } else {                                                    //found 1 and only 1 contact with that name :) 
            //system.debug(foundContacts[0]);
            if(foundContacts[0].AccountId == null){ //orphan contact!!
                //string caseNum = createCase('Found Orphan Contact with Email = ' + foundContacts[0].Email, '');
                foundContacts[0].AccountId = PORTAL_ACCOUNT_ID;
                update foundContacts[0];
                User objUser = createCommunityUser(foundContacts[0].Id, 'SelfRegisteredDefaults');
                List<User> lstUpsertUsers = new List<User>();
                lstUpsertUsers.add(objUser);
                ID jobIDUpsert = System.enqueueJob(new upsertUser(lstUpsertUsers));                       //update the User and asynchonously! TODO?? bulkify 
                sendContactEmail(foundContacts[0]);
                return selfRegistrationConfirm('login','true');
            }else{
                User u = createCommunityUser(foundContacts[0].Id, 'LimitedCustomerUser');
                //system.debug(u);
                return insertNewUser(u);
            }
        }
    }
    
    public pageReference analyzeFoundLeads(list<Lead> foundLeads){
        //WE are already checking for a zero found leads condition...
        if (foundLeads.size() > 1){                              //found duplicate lead email! 
            strSubject = 'Review Duplicate Leads for Self-Registration';
            strSymptom = 'New User Request';
            strDescription = 'Please investigate the duplicate leads ('+foundLeads.size()+') with the same email address "'+foundLeads[0].Email+'" that is attempting to complete Self-Registration';
            string caseNum = createCase(strSubject, strSymptom, strDescription);
            return selfRegistrationException('showError', 'moreLeads');    //Maybe we make a page tailored to "processing request"
        } else {                                                    //found 1 and only 1 contact with that name :) 
           // system.debug(foundLeads[0]);
            foundLeads[0].Country = country;
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
                    User u = createCommunityUser(objLeadConvertResult.getContactId(), 'LimitedCustomerUser');
                    //system.debug(u);
                    return insertNewUser(u);
                }else{
                   // system.debug(logginglevel.ERROR,'String.valueOf(objLeadConvertResult.getErrors()[0])'+String.valueOf(objLeadConvertResult.getErrors()[0]));
                    strSubject = 'Lead conversion failed with Email : ' + foundLeads[0].Email;
                    strSymptom = 'New User Request';
                    strDescription = String.valueOf(objLeadConvertResult.getErrors()[0]);
                    string caseNum = createCase(strSubject, strSymptom, strDescription);
                    return selfRegistrationException('showError', 'leadFail');    //Maybe we make a page tailored to "processing request"
                } 
            }catch(Exception E){
                //Exception may occur if we make some mandatory fields in lead(future case)
               // system.debug(logginglevel.ERROR,'E.getMessage()'+E.getMessage());
                strSubject = 'Error while converting lead with Email :' + foundLeads[0].Email;
                strSymptom = 'New User Request';
                strDescription = E.getMessage();
                string caseNum = createCase(strSubject, strSymptom, strDescription);
                return selfRegistrationException('showError', 'leadFail');    //Maybe we make a page tailored to "processing request"
            }
            
        }
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
        newCase.Description = strDescription + '(Login User : '+userInfo.getUserName()+')';
        newCase.OwnerId = SvcCloudQueue.Id;
        insert newCase;
        //system.debug(newCase); 
        return newCase.Id;
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
            for(Integer i=0;i<lstUpsertUsers.size();i++){
                if(lstUpsertUsers[i].Id <> null){
                    lstUpdateUsers.add(lstUpsertUsers[i]);
                }else{
                    lstInsertUsers.add(lstUpsertUsers[i]);
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