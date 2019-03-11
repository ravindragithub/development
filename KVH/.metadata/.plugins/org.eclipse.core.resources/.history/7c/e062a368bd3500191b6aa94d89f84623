public without sharing class MyProfileController{
    public static boolean stopuserRecord = false;
    

    // edit on line 96
    @AuraEnabled
    public static ProfileWrapper getUserDetails(){
        ProfileWrapper profileObj = new ProfileWrapper();
        Contact con = new Contact();
        List<User> userlst = [Select id,contactId from User where ID =: userinfo.getUserId()];
        
        String conId = userlst[0].ContactId;
        
        if(conId != null){
            List<Contact> conlst = [Select id,Salutation,Firstname,lastname,email,Phone,Title,Job_Function__c,
                                    MailingStreet,MailingCity,MailingState,MailingCountry,
                                    MailingPostalCode,Account.Portal_View_s__c,Account.Name,Account.BillingStreet,Account.BillingCity,
                                    Account.BillingState,Agree_to_myKVH_Terms_and_Conditions__c,Account.BillingPostalCode,Account.BillingCountry,Account.Phone,Account.Partner_Portal_Email__c  
                                    from Contact Where ID =: conId];
            if(conlst.size()>0)
                con = conlst[0];
            profileObj.con = con;
            if(con.Account.Portal_View_s__c != null){
                profileObj.portalViews = new List<String>();
                for(String pv : con.Account.Portal_View_s__c.split(';')){
                    profileObj.portalViews.add(pv);
                }
            }
            profileObj.accountName = con.Account.Name;
            profileObj.accAddressStreet = con.Account.BillingStreet;
            profileObj.accAddressCity = con.Account.BillingCity;
            profileObj.accAddressState = con.Account.BillingState;
            profileObj.accAddressPostalCode = con.Account.BillingPostalCode;
            profileObj.accAddressCountry = con.Account.BillingCountry;
            profileObj.accPhone = con.Account.Phone;
            profileObj.accEmail = con.Account.Partner_Portal_Email__c;
            profileObj.salutationOptions = getPicklistOptions('Contact','Salutation',con.Salutation);
            profileObj.jobfunctionOptions = getPicklistOptions('Contact','Job_Function__c',con.Job_Function__c);
            //profileObj.countryOtions = getPicklistOptions('Country__c','Country__c',con.MailingCountry);
            Map<String,String> optionMap = getCountryOptions(con.MailingCountry);
            profileObj.countryOtions = optionMap.get('picklistoption');
            profileObj.con.MailingCountry = optionMap.get('selectContryISOCode');
            //profileObj.stateoptions = PicklistFieldController.getDependentOptionsImpl('Country__c','Country__c','State__c');  
            
            profileObj.stateoptions =   getstateOptions();  
            profileObj.Terms_of_Use = conlst[0].Agree_to_myKVH_Terms_and_Conditions__c;
        }
        
       
        return profileObj;
    }
    
    private static String getPicklistOptions(String objectName,String fieldName,String selectedValue){
        Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(new String[]{objectName});
        Schema.DescribeFieldResult fieldResult = descResult[0].fields.getMap().get(fieldName).getDescribe();
        String picklistOptions = '';
        for(Schema.PicklistEntry ple : fieldResult.getPicklistValues()){
            picklistOptions += '{';
            picklistOptions += '"label": "' + ple.getLabel() + '",';
            picklistOptions += '"value": "' + ple.getValue() + '"';
                            if(ple.getValue() == selectedValue)
                                picklistOptions  += ',"selected": "true"';
            picklistOptions += '},';
        }
        
        return '[' + picklistOptions.substring(0,picklistOptions.length()-1) + ']';
    }
    
        
    @AuraEnabled
    public static string updateUserRecord(String userdetailJson){
              return updateUserContactRecord(userdetailJson,false);
    }
    
    @AuraEnabled
    public static string agreeTC(String userdetailJson){
              return updateUserContactRecord(userdetailJson,true);
    }
    
    private static string updateUserContactRecord(String userdetailJson,boolean fromAgreepopup){
        try{
            
            boolean updateRecord = false;
            boolean emailmodified = false;
            ProfileWrapper userDetail = (ProfileWrapper) JSON.deserialize(userdetailJson, ProfileWrapper.class);
            
            User oldUserObj = [Select id,contactId,email,firstname,lastname,phone,title,street,city,state,country,
                                postalcode from user where ID =: userinfo.getuserId()];
            Contact oldCon = [Select id,Job_Function__c,Salutation  from Contact where Id = : oldUserObj.contactId];
            Contact con = new Contact(Id = oldUserObj.contactId);
            
            
            
            // Marcos edit, this is where it will update it on the contact instead
            User userObj = new User(id = userinfo.getuserId());
            if(fromAgreepopup){
                con.Agree_to_myKVH_Terms_and_Conditions__c= 'Accept';
                updateRecord = true;
            }
            //user email updated so need to update the username and email and sent change user name and email notificate to user
            if(oldUserObj.email != userDetail.con.email){
               // userObj.email = userDetail.con.email;
                emailmodified = true;
                //userObj.username = userDetail.con.email;
                 
            }
            if(oldUserObj.Firstname != userDetail.con.FirstName){
                userObj.Firstname = userDetail.con.FirstName;
                con.Firstname = userDetail.con.FirstName;
                updateRecord = true;
            }
            if(oldUserObj.LastName != userDetail.con.LastName){ 
                userObj.LastName = userDetail.con.LastName;
                con.LastName = userDetail.con.LastName;
                updateRecord = true;
            }
            if(oldUserObj.Phone != userDetail.con.Phone){
                userObj.Phone = userDetail.con.Phone;
                con.Phone = userDetail.con.Phone;
                updateRecord = true;
            }
            if(oldUserObj.Title != userDetail.con.Title){
                userObj.Title = userDetail.con.Title;
                con.Title = userDetail.con.Title;
                updateRecord = true;
            }
            if(oldUserObj.Street != userDetail.con.MailingStreet){
                userObj.Street = userDetail.con.MailingStreet;
                con.MailingStreet = userDetail.con.MailingStreet;
                updateRecord = true;
            }
            if(oldUserObj.City != userDetail.con.MailingCity){
                userObj.City = userDetail.con.MailingCity;
                con.MailingCity = userDetail.con.MailingCity;
                updateRecord = true;
            }
            if(oldUserObj.State != userDetail.con.MailingState){
                
                List<KVH_States__mdt> statelist = [Select label from KVH_States__mdt where FullIsoCode__c =: userDetail.con.MailingState limit 1];
                String state;
                if(statelist.size()>0){
                    state = statelist[0].label;
                }else{
                    state = userDetail.con.MailingState;
                }
                userObj.State = state;
                con.MailingState = state;
                updateRecord = true;
            }
            if(oldUserObj.Country != userDetail.con.MailingCountry){
                List<KVH_Countries__mdt> countrylist = [Select label from KVH_Countries__mdt where IsoCode_2__c =: userDetail.con.MailingCountry limit 1];
                String country;
                if(countrylist.size()>0){
                    country = countrylist[0].label;
                }else{
                    country = userDetail.con.MailingCountry;
                }
                userObj.Country = country;
                con.MailingCountry = country;
                updateRecord = true;
            }
            if(oldUserObj.PostalCode != userDetail.con.MailingPostalCode){
                userObj.PostalCode = userDetail.con.MailingPostalCode;
                con.MailingPostalCode = userDetail.con.MailingPostalCode;
                updateRecord = true;
            }
            if(oldCon.Salutation != userDetail.con.Salutation){                
                con.Salutation = userDetail.con.Salutation;
                updateRecord = true;
            }
            if(oldCon.Job_Function__c != userDetail.con.Job_Function__c){                
                con.Job_Function__c = userDetail.con.Job_Function__c;
                updateRecord = true;
            }
            
            if(emailmodified){
                Id portalCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Partner Portal').getRecordTypeId();
                Case newCase = new Case();
                newCase.recordTypeId = portalCaseRecordTypeId;
               
                String descr = 'User ' + userDetail.con.FirstName + ' ' + userDetail.con.LastName +' has requested to change her email address from the KVH Partner Portal.';
                descr += '\n\n';
                descr += 'Old Email Address: ' + oldUserObj.email + '\n';
                descr += 'New Email Address: ' + userDetail.con.email + '\n\n';
                descr += 'Please review this request and update the contact and user records in Salesforce.';
                newCase.Description = descr;
                newCase.subject = '"My Profile" Email Update Request from ' + userDetail.con.FirstName + ' ' + userDetail.con.LastName + ' (' + userDetail.con.Email + ')';
                
                
                Database.DMLOptions dmlOpts = new Database.DMLOptions();
                dmlOpts.assignmentRuleHeader.useDefaultRule= true;
                newCase.setOptions(dmlOpts); 
                newCase.Origin = 'Web';
                insert newCase;
            }
            
                       
            if(updateRecord){
                MyProfileController.stopuserRecord = true;
                update con;
                update userObj;
                MyProfileController.stopuserRecord = false;               
               
            }
        }catch(Exception ex){
            return ex.getmessage();
        }
        if(fromAgreepopup){
            return 'Successfully agreed';  
        }else{
            return 'User record updated successfully.';  
        }        
    }
    
    //get cournry options
    private static Map<String,String> getCountryOptions(String selectedCountry){
        Map<String,String> optionMap = new Map<String,String>();
        String selectContryISOCode;
        System.debug('@@@ selectedCountry==>'+selectedCountry);
        String picklistOptions = '';
        picklistOptions += '{';
        picklistOptions += '"label": "' + '--None--' + '",';
        picklistOptions += '"value": "' + '' + '"';                        
        picklistOptions += '}';
        list<KVH_Countries__mdt> contrylist = [Select Label,IsoCode_2__c from KVH_Countries__mdt order by Label];
        for(KVH_Countries__mdt c : contrylist ){
            picklistOptions += ',{';
            picklistOptions += '"label": "' + c.Label + '",';
            picklistOptions += '"value": "' + c.IsoCode_2__c + '"';
                            if(selectedCountry != null && (c.Label.equalsIgnoreCase(selectedCountry) || c.IsoCode_2__c.equalsIgnoreCase(selectedCountry))){
                                picklistOptions  += ',"selected": "true"';
                                selectContryISOCode = c.IsoCode_2__c;
                            }
            picklistOptions += '}';
        }
        optionMap.put('selectContryISOCode',selectContryISOCode);
        optionMap.put('picklistoption','[' + picklistOptions + ']');
        return optionMap;
    }
    
    //get cournry options
    private static Map<String,List<KVH_States__mdt>> getstateOptions(){        
        Map<String,List<KVH_States__mdt>> stateOptions = new Map<String,List<KVH_States__mdt>>();
      
        for(KVH_States__mdt s : [Select Label,CountryIsoCode_2__c,IsoCode__c,FullIsoCode__c from KVH_States__mdt order by CountryIsoCode_2__c,Label]){
           List<KVH_States__mdt> states = stateOptions.get(s.CountryIsoCode_2__c);
           if(states == null)
               states = new List<KVH_States__mdt>();
           states.add(s);
           stateOptions.put(s.CountryIsoCode_2__c,states);
        }
       
        return stateOptions;
    }
}