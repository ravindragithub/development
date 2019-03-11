global without sharing class myKVH_LightningSelfRegisterController {
    public string urlvalue{get;set;}
    
    @AuraEnabled 
    public static List<KVH_Countries__mdt> getCountry(){
        List<KVH_Countries__mdt> countryValues = [SELECT Id, TrimmedName__c, IsoCode_2__c, IsoCode_3__c 
                                                  FROM KVH_Countries__mdt 
                                                  WHERE (Enabled__c =: true AND IsObsolete__c =: false)
                                                  ORDER BY TrimmedName__c ASC];
        return countryValues;
    }
    @AuraEnabled 
    public static List<string> getStateMap(string countryCode){
        system.debug('==countryCode=='+countryCode);
        List<string> stateValues = new List<string>();
        for(KVH_States__mdt tempState : [SELECT Id, CountryIsoCode_2__c,IsoCode__c,TrimmedName__c
                                         FROM KVH_States__mdt WHERE CountryIsoCode_2__c =: countryCode ORDER BY TrimmedName__c ASC]){
                                             stateValues.add(tempState.TrimmedName__c);                           
                                         }
        system.debug('==stateValues=='+stateValues.size());
        return stateValues;
    }
    public myKVH_LightningSelfRegisterController() {
        
        
    }
    @TestVisible 
    private static boolean isValidPassword(String password, String confirmPassword) {
        return password == confirmPassword;
    }
    
    @TestVisible 
    private static boolean siteAsContainerEnabled(String communityUrl) {
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(communityUrl,'');
        return authConfig.isCommunityUsingSiteAsContainer();
    }
    
    @TestVisible 
    private static void validatePassword(User u, String password, String confirmPassword) {
        if(!Test.isRunningTest()) {
            Site.validatePassword(u, password, confirmPassword);
        }
        return;
    }
    
    @AuraEnabled
    public static String selfRegister(String firstname, String lastname, String email, String password, String confirmPassword, String accountId, String regConfirmUrl, String extraFields, String startUrl, Boolean includePassword, String serialNumber, Boolean emailValue, Boolean postalValue, Boolean telephoneValue, Boolean declineValue,string countryValue,string stateValue,string destination) {
        system.debug('selfRegister==='+accountId);
        
        
        Savepoint sp = null;
        try {
            sp = Database.setSavepoint();
            
            if (lastname == null || String.isEmpty(lastname)) {
                return Label.Site.lastname_is_required;
            }
            
            if (email == null || String.isEmpty(email)) {
                return Label.Site.email_is_required;
            }
            
            
            email = email.toLowerCase();
            
            User u = new User();
            u.Username = email;
            u.put('Email',email);
            
            u.FirstName = firstname;
            u.LastName = lastname;
            u.Country = countryValue;
            u.State = stateValue;                           
            u.uas__Sync_to_Contact__c = false;
            u.Destination__c = destination;
            u.Serial_Number__c = serialNumber;
            
            //u.Department = 'testingmarcos';
            //u.Potential_Antenna_Number__c = serialNumber;
            
            String networkId = Network.getNetworkId();
            
            // If using site to host the community the user should not hit s1 after logging in from mobile.
            if(networkId != null && siteAsContainerEnabled(Network.getLoginUrl(networkId))) {
                u.put('UserPreferencesHideS1BrowserUI',true);
            }
            
            String nickname = ((firstname != null && firstname.length() > 0) ? firstname.substring(0,1) : '' ) + lastname.substring(0,1);
            nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
            u.put('CommunityNickname', nickname);
            
            if (extraFields != null) {
                List<Object> extraFieldsList = (List<Object>) JSON.deserializeUntyped(extraFields);        
                for (Object thisFieldObject : extraFieldsList) {
                    Map<String,Object> thisField = (Map<String,Object>) thisFieldObject;
                    Schema.SObjectField sof = Schema.SObjectType.User.fields.getMap().get((String) thisField.get('fieldPath'));
                    u.put(sof, thisField.get('value'));
                }
            }
            
            if (includePassword) {    
                if (!isValidPassword(password, confirmPassword)) {
                    return Label.site.passwords_dont_match;
                }
                validatePassword(u, password, confirmPassword);
            }
            else {
                password = null;
            }
            
            // lastName is a required field on user, but if it isn't specified, we'll default it to the username
            system.debug('u: ' + u);
            system.debug('accountId: ' + accountId);
            system.debug('password: ' + password);
            system.debug('email: ' + email);
            List<User> existingUser = new List<User>([select id,name,email from User where email =: email]);
            List<Contact> existingContact = [SELECT Id, AccountId FROM Contact  where email =: email];
            system.debug('existingContact 123: ' + existingContact );
            String userId;
            string errorMessage;
            //For No user, 1 contact record found
            if(existingContact.size() == 1 && existingUser.size() == 0 ){      
                //Profile portalProfile = [select Id from Profile where Name = 'myKVH Customer Portal Profile' limit 1];
                //u.ProfileId = portalProfile.Id;
                u.ContactId = existingContact[0].Id; 
                system.debug('ContactOnly========='+u);
                userId = Site.createExternalUser(u, accountId, password,true);
                errorMessage = '[No User Found,only contact record found]';
            }
            //For 1 user, 1 contact record found
            else if(existingContact.size() == 1 && existingUser.size() == 1 ){
                userId = 'userExist';
                string wdw = 'https://www.surveymonkey.co.uk';
                errorMessage = '[We recognize you already have a myKVH account. Please click the "Already a myKVH user?" button at the bottom of the page to log in. KVH Airtime Services Hours: 6:00 PM Sunday to 5:00 PM Friday (ET) Phone: +1 401.851.3862  Email: airtimeservices@kvh.com]';
            }
            //For No user, No contact record found
            else if(existingContact.size() == 0 && existingUser.size() == 0){
                system.debug('====123====');
                userId = Site.createExternalUser(u, accountId, password);
                errorMessage = userId;
                system.debug('====567===='+userId);
            }
            //For multiple contact records found
            else{
                userId = 'multiple';
                errorMessage = '[We recognize you have multiple contacts in our system. Please contact KVH Airtime Services to activate your TracPhone LTE‌-1. KVH Airtime Services Hours: 6:00 PM Sunday to 5:00 PM Friday (ET) Phone: +1 401.851.3862  Email: airtimeservices@kvh.com]';
            }
            if(userId != 'multiple' && userId != 'userExist'){                
                system.debug('existingContact 123: ' + existingContact );
                system.debug('userId: ' + userId);
                // create a fake userId for test.
                /*if (Test.isRunningTest()) {
userId = 'fakeUserId';           
}*/
                if (userId != null) { 
                    if (password != null && password.length() > 1) {
                        ApexPages.PageReference lgn = Site.login(email, password, startUrl);
                        if(!Test.isRunningTest()) {
                            aura.redirect(lgn);
                        }
                    }
                    else {
                        ApexPages.PageReference confirmRef = new PageReference(regConfirmUrl);
                        if(!Test.isRunningTest()) {
                            aura.redirect(confirmRef);
                        }
                        
                    }
                }
                system.debug(existingContact+'in this line: ' + existingContact.size());                
                if(existingContact.size() < 2){
                    updateContact(u.username,u.FirstName ,u.LastName, emailValue, postalValue, telephoneValue, declineValue, serialNumber,countryValue,stateValue);
                    updateContactPhone(u.username, emailValue, postalValue, telephoneValue, declineValue, serialNumber,userId);
                }
                system.debug('userId: ' + userId);                
                return null;
            }
            else{
                return errorMessage;
            }
        }
        catch(Exception ex) {
            system.debug(ex+'===='+ ex.getMessage());
            string expStr = '[' + ex.getMessage() + ']';
            return expStr;
        }
    }
    
    
    @future
    public static void updateContact(String email,String FirstName,String LastName, Boolean emailValue, Boolean postalValue, Boolean telephoneValue, Boolean declineValue, String serialNumber,string countryValue,string stateValue){
        system.debug('updateContact');
        List<contact> theContact = new List<contact>();
        //theContact = [SELECT Id, Title, CSN_Patch_Sent__c, Telephone_Opted_In__c, Email_Opted_In__c, Phone, Postal_Mail_Opted_In__c, FirstName, LastName FROM contact  WHERE email =: email AND FirstName =: FirstName AND LastName =: LastName ORDER BY  LastModifiedDate  LIMIT 1];
        theContact = [SELECT Id, Title, CSN_Patch_Sent__c, Telephone_Opted_In__c,MailingCountry, MailingState ,Email_Opted_In__c, Phone, Postal_Mail_Opted_In__c, FirstName, LastName FROM contact  WHERE email =: email ORDER BY  LastModifiedDate  LIMIT 1];
        system.debug('theContact ==='+theContact );
        if(theContact.size() > 0){
            if(emailValue == true){
                theContact[0].Email_Opted_In__c = 'Agree'  ;          
            }
            if(postalValue == true){
                theContact[0].Postal_Mail_Opted_In__c = 'Agree'  ;          
            }
            if(telephoneValue == true){
                theContact[0].Telephone_Opted_In__c = 'Agree'  ;          
            }
            if(declineValue == true){
                theContact[0].Email_Opted_In__c = 'Decline'  ;
                theContact[0].Postal_Mail_Opted_In__c = 'Decline';
                theContact[0].Telephone_Opted_In__c = 'Decline'  ; 
            }
            theContact[0].LTE_Antenna_Number__c = serialNumber;
            theContact[0].MailingCountry = countryValue;
            theContact[0].MailingState = stateValue;        
            update theContact[0];
        }
    }
    @future
    public static void updateContactPhone(String email, Boolean emailValue, Boolean postalValue, Boolean telephoneValue, Boolean declineValue, String serialNumber, string userId){
        system.debug('updateContact');
        user theUser = [SELECT Id, contact.Id,MobilePhone  from user where Id =: userId LIMIT 1];
        system.debug(theUser.Id);
        system.debug(theUser.contact.Id);
        //system.debug(emailValue);
        contact theContact = [SELECT Id, Title,CSN_Patch_Sent__c, Telephone_Opted_In__c,Email_Opted_In__c,Phone, Postal_Mail_Opted_In__c FROM contact WHERE email =: email];
        
        theContact.Phone =  theUser.MobilePhone;
        //theContact.LTE_Antenna_Number__c = serialNumber;
        
        update theContact;
    }
    
    
    
    @AuraEnabled
    public static List<Map<String,Object>> getExtraFields(String extraFieldsFieldSet) { 
        List<Map<String,Object>> extraFields = new List<Map<String,Object>>();
        Schema.FieldSet fieldSet = Schema.SObjectType.User.fieldSets.getMap().get(extraFieldsFieldSet);
        if(!Test.isRunningTest()) {
            if (fieldSet != null) {
                for (Schema.FieldSetMember f : fieldSet.getFields()) {
                    Map<String, Object> fieldDetail = new Map<String, Object>();
                    fieldDetail.put('dbRequired', f.getDBRequired());
                    fieldDetail.put('fieldPath', f.getFieldPath());
                    fieldDetail.put('label', f.getLabel());
                    fieldDetail.put('required', f.getRequired());
                    fieldDetail.put('type', f.getType());
                    fieldDetail.put('value', '');   // client will populate
                    extraFields.add(fieldDetail);
                }}}
        system.debug('extraFields===='+extraFields);
        return extraFields;
    }
    
    @AuraEnabled
    global static String setExperienceId(String expId) {
        // Return null if there is no error, else it will return the error message 
        try {
            if (expId != null) {
                Site.setExperienceId(expId);   
            }
            return null; 
        } catch (Exception ex) {
            return ex.getMessage();            
        }        
    }  
}