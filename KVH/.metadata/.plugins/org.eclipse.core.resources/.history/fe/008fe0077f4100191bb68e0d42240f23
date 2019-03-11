global class NewTechPartnerClass {
    /*This method sends the message to skilljar and returns skilljar's response*/
    public static HttpResponse createResponse(string ema, string fn, string ln){
        string url;
        string uname;
        map<string,map<string, string> > umap = new map<string,map<string, string> >();
        map<String, String> attributeMap = new map<String, String>();
        Security__c secur = [SELECT Key__c FROM Security__c WHERE Name =: 'Skilljar1']; //grab API credentials
        uname = secur.Key__c; //username for skilljar
        attributeMap.put('email', ema);
        attributeMap.put('first_name', fn);
        attributeMap.put('last_name', ln);
        umap.put('user', attributeMap); //map in format required by skilljar
        Production_Org_Ids__c mySetting = new Production_Org_Ids__c();  //Create a new instance of the Custom Setting
        mySetting = Production_Org_Ids__c.getOrgDefaults();           //get the Org default dataset for our Production Org
        if(UserInfo.getOrganizationId() == mySetting.Org_Id_18_char__c){
            /*We are in Production! Use Production Instance of Skilljar!*/
            url = 'https://api.skilljar.com/v1/domains/kvh.skilljar.com/users';  //Production instance 
        } else {
            /*We are in Sandbox! Use DEV Instance of Skilljar!*/
            url = 'https://api.skilljar.com/v1/domains/kvhsandbox.skilljar.com/users';  //Development instance
        }
        //create the authorization header required by skilljar
        Blob headerValue = Blob.valueOf(uname);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        //create your request with it's appropriate parameters
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(url);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('content-type', 'application/json');
        req.setBody(JSON.serialize(umap));
        Http h = new Http();
        //send the request
        HttpResponse res = h.send(req);
        return res; //return the response
    }
    public static string parseResponse(HttpResponse res) {
        string responseBody = res.getbody();
        string resbodynow = responseBody.stripHtmlTags();
        string newId = resbodynow.substringBetween('"id": "', '"');
        system.debug('Id: ' + newId);
        system.debug(res.getStatusCode());
        return newId; 
    }
    public class insertUser implements Queueable{         //Queueable Class to avoid Mixed DML
        private List<User> lstInsertUsers = new List<User>();  //Needs a User to create (should NOT have a record ID!)
        
        public insertUser(List<User> communityUsers){     //constructor, handles input parameter
            this.lstInsertUsers = communityUsers;  // "u" is visible to Class now.
        }
        public void execute(QueueableContext context){  //Mandatory Execute method
            try{
                insert lstInsertUsers;
            } catch(Exception e){
                //creates a servcloud case if there was an error creating the portal user
                Id ServCloud_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
                Case returnCase = new Case();
                returnCase.RecordTypeId = ServCloud_RECORD_TYPE_ID;
                returnCase.Origin = 'System Generated';
                returnCase.status = 'New';
                returnCase.subject = 'Error Creating Portal User';
                returnCase.description = e.getMessage();
                returnCase.Case_Symptom__c = 'Salesforce Error';
                insert returnCase;
            }
        }       
    }
    //this method sets up the user based on the contact information, but does not insert it
    public static void createUser(string conId, string first, string last, string email, string profid) {
        User u = new User();
        u.ContactId = conId;
        u.Username = email;
        u.Email = email;
        u.IsActive = true;
        u.FirstName = first;
        u.LastName = last;
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = profid;
        u.LanguageLocaleKey = 'en_US';
        u.Alias = first.left(0) + last.left(7);
        List <User> listusers = new List <User>();
        listusers.add(u);
        ID jobIDUpsert = System.enqueueJob(new insertUser(listusers));//sets the insert as a queued job
    }
    //evaluates which groups to add the student to based on their account's product catalog, then creates the student in skilljar
    webservice static string createStudent(string s){
        string returnMessage;
        boolean landGroup = false;
        boolean tpGroup = false;
        boolean marineGroup = false;
        Contact con = [SELECT Account.Partner_Role__c, AccountId, FirstName, LastName, Email, Skilljar_Id__c FROM Contact WHERE Id =: s];
        Profile PortalProf = new Profile();
        if(con.Account.Partner_Role__c == 'Dealer'){
            PortalProf = [SELECT Id, Name FROM Profile WHERE Name =: 'Partner-Dealer' Limit 1];
        } else if (con.Account.Partner_Role__c == 'Distributor'){
            PortalProf = [SELECT Id, Name FROM Profile WHERE Name =: 'Partner-Distributor' Limit 1];
        } else if(con.Account.Partner_Role__c == 'Service Provider'){
            PortalProf = [SELECT Id, Name FROM Profile WHERE Name =: 'Partner-Service Provider' Limit 1];
        } else if(con.Account.Partner_Role__c == 'Manufacturer\'s Representative' || con.Account.Partner_Role__c == 'Representative' || con.Account.Partner_Role__c == 'Rep'){
            PortalProf = [SELECT Id, Name FROM Profile WHERE Name =: 'Partner - Rep' Limit 1];
        } else{
            returnMessage += 'Error: No associated Portal Profile.';
        }
        List <Product_Catalogue__c> prod = [SELECT  Product_Series__c, Market__c, Sector__c, Product_Line__c FROM Product_Catalogue__c WHERE Partner_Account__c =: con.AccountId];
        //loops through the account's product catalog to find one of the characteristics that put the students into groups
        for (Integer i = 0; i < prod.size(); i++) {
            if(prod[i].Product_Series__c == 'mini-VSAT Broadband'){
                tpGroup = true;
            }
            if(prod[i].Product_Line__c == 'Mobile Satellite TV' || prod[i].Product_Line__c == 'Satellite Television'){
                if(prod[i].Sector__c == 'Land Systems' || prod[i].Sector__c == 'RV & Auto Systems'){
                    landGroup = true;
                }
                else{
                    marineGroup = true;
                }
            }
        }
        try{
            //this callout adds the contact as a student.  Skilljar will then 
            HttpResponse res = createResponse(con.Email, con.FirstName, con.LastName);
            string newId = parseResponse(res);//translate response into form we can use
            con.Skilljar_Id__c = newId;
            returnMessage += 'New Student Success. ';
            if(landGroup == true){
                skilljar__Group__c landGroupId = [SELECT skilljar__Skilljar_Id__c FROM skilljar__Group__c WHERE skilljar__Name__c = 'TracVision Land'];
                returnMessage += addToGroup(con.Skilljar_Id__c, landGroupId.skilljar__Skilljar_Id__c);//add to tracvision land group in skilljar
            }
            if(tpGroup == true){
                skilljar__Group__c tpGroupId = [SELECT skilljar__Skilljar_Id__c FROM skilljar__Group__c WHERE skilljar__Name__c = 'TracPhone'];
                returnMessage += addToGroup(con.Skilljar_Id__c, tpGroupId.skilljar__Skilljar_Id__c);//add to tracphone group in skilljar
            }
            if(marineGroup == true){
                skilljar__Group__c marineGroupId = [SELECT skilljar__Skilljar_Id__c FROM skilljar__Group__c WHERE skilljar__Name__c = 'TracVision Marine'];
                returnMessage += addToGroup(con.Skilljar_Id__c, marineGroupId.skilljar__Skilljar_Id__c);//add to tracvision marine group in skilljar
            }
            List <User> uses = [SELECT Email FROM User WHERE Email =: con.Email];
            If(uses.size() > 0){
                returnMessage += 'User Already Exists. ';
            } else{
            createUser(con.Id, con.FirstName, con.LastName, con.Email, portalProf.Id);
            returnMessage += 'New Partner Portal User Being Created.';
            }
            update con;
        } catch(exception  e){
            returnMessage = 'Failed to Create New Student.  Please verify the name and email.  Error: ' + e.getMessage();
            return returnMessage;
        }
        return returnMessage;
    }
    webservice static string createContact(string s) {
        string returnMessage;
        Partner_Portal_Access_Request__c ppar = [SELECT Found_Account__c, Contact_Phone__c, First_Name__c, Last_Name__c, Contact_Email__c, Company_Address_1__c, Company_Address_2__c, Company_City__c, Company_State__c, Company_Country__c, Company_Postal_Zipcode__c, Salutation__c, Job_Title__c, Company_Functional_Group__c FROM Partner_Portal_Access_Request__c WHERE Name =: s LIMIT 1];
        If(ppar.Found_Account__c == null){ //verifies that the user has assigned or created an account for the contact
            returnMessage = 'Please enter an account for the contact.';
            return returnMessage;
        }
        boolean landGroup = false;
        boolean tpGroup = false;
        boolean marineGroup = false;
        Account acc = [SELECT Market_Sector__c, Partner_Role__c FROM Account WHERE Id =: ppar.Found_Account__c];
        Profile PortalProf = new Profile();
        if(acc.Partner_Role__c == 'Dealer'){
            PortalProf = [SELECT Id, Name FROM Profile WHERE Name =: 'Partner-Dealer' Limit 1];
        } else if (acc.Partner_Role__c == 'Distributor'){
            PortalProf = [SELECT Id, Name FROM Profile WHERE Name =: 'Partner-Distributor' Limit 1];
        } else if(acc.Partner_Role__c == 'Service Provider'){
            PortalProf = [SELECT Id, Name FROM Profile WHERE Name =: 'Partner-Service Provider' Limit 1];
        }
        List <Product_Catalogue__c> prod = [SELECT  Product_Series__c, Market__c, Sector__c, Product_Line__c FROM Product_Catalogue__c WHERE Partner_Account__c =: ppar.Found_Account__c];
        for (Integer i = 0; i < prod.size(); i++) {
            if(prod[i].Product_Series__c == 'mini-VSAT Broadband'){
                tpGroup = true;
            }
            if(prod[i].Product_Line__c == 'Mobile Satellite TV' || prod[i].Product_Line__c == 'Satellite Television'){
                if(prod[i].Sector__c == 'Land Systems' || prod[i].Sector__c == 'RV & Auto Systems'){
                    landGroup = true;
                }
                else{
                    marineGroup = true;
                }
            }
        }
        Contact con = new Contact();
        con.Salutation = ppar.Salutation__c;
        con.AccountId = ppar.Found_Account__c;
        con.FirstName = ppar.First_Name__c;
        con.Phone = ppar.Contact_Phone__c;
        con.LastName = ppar.Last_Name__c;
        con.Email = ppar.Contact_Email__c;
        con.MailingCity = ppar.Company_City__c;
        con.MailingCountry = ppar.Company_Country__c;
        con.MailingState = ppar.Company_State__c;
        con.MailingPostalCode = ppar.Company_Postal_Zipcode__c;
        List<Integer> charArr= new Integer[]{10};
            String convertedChar = String.fromCharArray(charArr);
        con.MailingStreet = ppar.Company_Address_1__c + convertedChar + ppar.Company_Address_2__c;
        con.Company_Functional_Group__c = ppar.Company_Functional_Group__c;
        try{
            HttpResponse res = createResponse(con.Email, con.FirstName, con.LastName);
            string newId = parseResponse(res);
            con.Skilljar_Id__c = newId;
            returnMessage = 'New Student Success. ';
            if(landGroup == true){
                skilljar__Group__c landGroupId = [SELECT skilljar__Skilljar_Id__c FROM skilljar__Group__c WHERE skilljar__Name__c = 'TracVision Land'];
                returnMessage += addToGroup(con.Skilljar_Id__c, landGroupId.skilljar__Skilljar_Id__c);
            }
            if(tpGroup == true){
                skilljar__Group__c tpGroupId = [SELECT skilljar__Skilljar_Id__c FROM skilljar__Group__c WHERE skilljar__Name__c = 'TracPhone'];
                returnMessage += addToGroup(con.Skilljar_Id__c, tpGroupId.skilljar__Skilljar_Id__c);
            }
            if(marineGroup == true){
                skilljar__Group__c marineGroupId = [SELECT skilljar__Skilljar_Id__c FROM skilljar__Group__c WHERE skilljar__Name__c = 'TracVision Marine'];
                returnMessage += addToGroup(con.Skilljar_Id__c, marineGroupId.skilljar__Skilljar_Id__c);
            }
            try{
                insert con;
                ppar.Found_Contact__c = con.Id;
                update ppar;
                returnMessage += 'Contact Creation Success.';
            } catch(exception  e){
                returnMessage = 'Contact could not be created.  Error: ' + e.getMessage();
            }
            createUser(con.Id, con.FirstName, con.LastName, con.Email, portalProf.Id);
            returnMessage += 'New Partner Portal User Being Created. ';
        } catch(exception  e){
            returnMessage = 'Failed to Create New Student.  Please verify the name and email.  Error: ' + e.getMessage();
            return returnMessage;
        }
        return returnMessage;
        
    }
    /*@InvocableMethod(label='Advanced Group' description='skdjfl')
    webservice static void addToAdvanced(List<string> stud){
        boolean tp;
        if(stud[0].left(2)=='tp'){
            tp = true;
        } else{
            tp = false;
        }
        string studId = stud[0].substring(2);
        string responseData;
        List<skilljar__Course_Progress__c> prog = new List<skilljar__Course_Progress__c>();
        skilljar__Group__c grp = new skilljar__Group__c();
        if(tp == true){
            prog = [SELECT Id, skilljar__Completed_At__c FROM skilljar__Course_Progress__c WHERE skilljar__Student__r.skilljar__Obfuscated_Id__c =: studId AND skilljar__Completed_At__c != null AND (skilljar__Course__r.Name = 'TracPhone V11-IP' OR skilljar__Course__r.Name = 'TracPhone V7-IP')];
            if(prog.size() < 2){
            } else {
                grp = [SELECT Id, skilljar__Skilljar_Id__c FROM skilljar__Group__c WHERE Name = 'TracPhone Advanced'];
            }
        } else {
            prog = [SELECT Id, skilljar__Completed_At__c FROM skilljar__Course_Progress__c WHERE skilljar__Student__r.skilljar__Obfuscated_Id__c =: studId AND skilljar__Completed_At__c != null AND (skilljar__Course__r.Name = 'TracVision HD7' OR skilljar__Course__r.Name = 'TracVision TV5, TV6, and TV8')];
            if(prog.size() < 2){
            } else {
                grp = [SELECT Id, skilljar__Skilljar_Id__c FROM skilljar__Group__c WHERE Name = 'TracVision Marine Advanced'];
            }
        }
        if(grp.skilljar__Skilljar_Id__c != null){
            If(Test.isRunningTest()){}
            else{ 
                addToGroupFuture(studId, grp.skilljar__Skilljar_Id__c); 
            }
        }
    }*/
    @future(callout=true)
    webservice static void addToGroupFuture(string s, string groupId){
        string responseData;
        string url = 'https://api.skilljar.com/v1/groups/' + groupId + '/users';
        string uname;
        map<String, map<String, String> > attributeMap = new map<String, map<String, String> >();
        map<String, String> userMap = new map<String, String>();
        Security__c secur = [SELECT Key__c FROM Security__c WHERE Name =: 'Skilljar1'];
        uname = secur.Key__c;
        userMap.put('id', s);
        attributeMap.put('user', userMap);
        Blob headerValue = Blob.valueOf(uname);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(url);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('content-type', 'application/json');
        req.setBody(JSON.serialize(attributeMap));
        HttpResponse res = h.send(req);
        string responseBody = res.getbody();
        integer code = res.getStatusCode();
        system.debug('code: ' + code);
        system.debug(res.getbody());
        string message;
        if(code > 199 && code < 300){
            message = 'Successfully added to group. ';
        } else{
            message = 'There was an error adding the contact to a group in SkillJar.  Error: ' + code;
        }
        if(Test.isRunningTest()){
            skillJar__Student__c student = [SELECT skilljar__Obfuscated_Id__c FROM skilljar__Student__c WHERE skilljar__Obfuscated_Id__c =: s LIMIT 1];
            student.skilljar__Obfuscated_Id__c = '12345678';
            update student;
        }
        system.debug(message);     
    }
    webservice static string addToGroup(string s, string groupId){
        string responseData;
        string url = 'https://api.skilljar.com/v1/groups/' + groupId + '/users';
        string uname;
        map<String, map<String, String> > attributeMap = new map<String, map<String, String> >();
        map<String, String> userMap = new map<String, String>();
        Security__c secur = [SELECT Key__c FROM Security__c WHERE Name =: 'Skilljar1'];
        uname = secur.Key__c;
        userMap.put('id', s);
        attributeMap.put('user', userMap);
        Blob headerValue = Blob.valueOf(uname);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(url);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('content-type', 'application/json');
        req.setBody(JSON.serialize(attributeMap));
        HttpResponse res = h.send(req);
        string responseBody = res.getbody();
        integer code = res.getStatusCode();
        system.debug('code: ' + code);
        system.debug(res.getbody());
        string message;
        if(code > 199 && code < 300){
            message = 'Successfully added to group. ';
        } else{
            message = 'There was an error adding the contact to a group in SkillJar.  Error: ' + code;
        }
        return message;      
    }
    webservice static string createAcctContact(string s) {
        Partner_Portal_Access_Request__c ppar = [SELECT Portal_View_s__c, Is_Main_Contact__c, MC_Phone__c, MC_First_Name__c, MC_Last_Name__c, MC_Salutation__c, MC_Email__c, Service_Manager_Last_Name__c, Service_Manager_First_Name__c, Auth_for_Service_Questions__c, Service_Manager_Email__c, Service_Manager_Phone__c, Service_Manager_Salutation__c, Company_Website__c, Partner_Role__c, Company_Phone__c, Company_Phone_2__c, Company_Name__c, Company_Email__c, Found_Account__c, Contact_Phone__c, First_Name__c, Last_Name__c, Contact_Email__c, Company_Address_1__c, Company_Address_2__c, Company_City__c, Company_State__c, Company_Country__c, Company_Postal_Zipcode__c, Salutation__c, Job_Title__c, Company_Functional_Group__c FROM Partner_Portal_Access_Request__c WHERE Name =: s LIMIT 1];
        Contact con = new Contact();
        string returnMessage;
        Account acc = new Account();
        acc.Name = ppar.Company_Name__c;
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        acc.Partner_Role__c = ppar.Partner_Role__c;
        acc.Prospect_Type__c = 'Partner';
        acc.Account_Status__c = 'In Review';
        acc.Website = ppar.Company_Website__c;
        acc.Phone = ppar.Company_Phone__c;
        acc.Secondary_Phone__c = ppar.Company_Phone_2__c;
        acc.Portal_View_s__c = ppar.Portal_View_s__c;
        acc.Main_Email__c = ppar.Company_Email__c;
        acc.BillingCountry = ppar.Company_Country__c;
        acc.BillingCity = ppar.Company_City__c;
        acc.BillingState = ppar.Company_State__c;
        acc.BillingPostalCode = ppar.Company_Postal_Zipcode__c;
        List<Integer> charArr= new Integer[]{10};
        String convertedChar = String.fromCharArray(charArr);
        acc.BillingStreet = ppar.Company_Address_1__c + convertedChar + ppar.Company_Address_2__c;
        try{
            insert acc;
            ppar.Found_Account__c = acc.Id;
            returnMessage = 'Account successfully created. ';
        } catch(Exception e){
            returnMessage = 'Could not create Account.  Please verify information.  Your error message is: ' + e.getMessage();
            return returnMessage;
        }
        
        con.Salutation = ppar.Salutation__c;
        con.AccountId = acc.Id;
        con.FirstName = ppar.First_Name__c;
        con.Phone = ppar.Contact_Phone__c;
        con.LastName = ppar.Last_Name__c;
        con.Email = ppar.Contact_Email__c;
        con.MailingCity = ppar.Company_City__c;
        con.MailingCountry = ppar.Company_Country__c;
        con.MailingState = ppar.Company_State__c;
        con.MailingPostalCode = ppar.Company_Postal_Zipcode__c;
        con.MailingStreet = ppar.Company_Address_1__c + convertedChar + ppar.Company_Address_2__c;
        con.Company_Functional_Group__c = ppar.Company_Functional_Group__c;
        
        if (ppar.Auth_for_Service_Questions__c == false){
            Contact con2 = new Contact();
            con2.Salutation = ppar.Service_Manager_Salutation__c;
            con2.AccountId = acc.Id;
            con2.FirstName = ppar.Service_Manager_First_Name__c;
            con2.Phone = ppar.Service_Manager_Phone__c;
            con2.LastName = ppar.Service_Manager_Last_Name__c;
            con2.Email = ppar.Service_Manager_Email__c;
            con2.MailingCity = ppar.Company_City__c;
            con2.MailingCountry = ppar.Company_Country__c;
            con2.MailingState = ppar.Company_State__c;
            con2.MailingPostalCode = ppar.Company_Postal_Zipcode__c;
            con2.MailingStreet = ppar.Company_Address_1__c + convertedChar + ppar.Company_Address_2__c;
            try{
                insert con2;
                ppar.Service_Manager__c = con2.Id;
                returnMessage += 'Service Manager successfully created. ';
            } catch(Exception e){
                returnMessage += ' Could not create Service Manager.  Please verify information.  Your error message is: ' + e.getMessage();
                return returnMessage;
            }
        }
        if (ppar.Is_Main_Contact__c == false){
            Contact con3 = new Contact();
            con3.Salutation = ppar.MC_Salutation__c;
            con3.AccountId = acc.Id;
            con3.FirstName = ppar.MC_First_Name__c;
            con3.Phone = ppar.MC_Phone__c;
            con3.LastName = ppar.MC_Last_Name__c;
            con3.Email = ppar.MC_Email__c;
            con3.MailingCity = ppar.Company_City__c;
            con3.MailingCountry = ppar.Company_Country__c;
            con3.MailingState = ppar.Company_State__c;
            con3.MailingPostalCode = ppar.Company_Postal_Zipcode__c;
            con3.MailingStreet = ppar.Company_Address_1__c + convertedChar + ppar.Company_Address_2__c;
            try{
                insert con3;
                ppar.Main_Contact__c = con3.Id;
                returnMessage += 'Main Contact successfully created. ';
            } catch(Exception e){
                returnMessage += ' Could not create Main Contact.  Please verify information.  Your error message is: ' + e.getMessage();
                return returnMessage;
            }
        }
        try{
            insert con;
            ppar.Found_Contact__c = con.Id;
            update ppar;
            returnMessage += 'Contact successfully created. ';
            } catch(Exception e){
                returnMessage += ' Could not create contact from form.  Please verify information.  Your error message is: ' + e.getMessage();
                return returnMessage;
            }
        return returnMessage;
    }
}