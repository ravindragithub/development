global class PartnerRegistrationController {
    global apexpages.standardcontroller controller;
    global Partner_Portal_Access_Request__c req;
    CountryStateMethods util = New CountryStateMethods(); //Helper Class
    global Id rectype;
    global string country {get; set;}
    global string creditcountry {get; set;}
    global string addcountry {get; set;}
    global string bankcountry {get; set;}
    global string state {get; set;}
    global string creditstate {get; set;}
    global string addstate {get; set;}
    
    global list<SelectOption> CountriesList = New list<SelectOption>(); //List of Country Names for Subscriber Picklist
    global list<SelectOption> StatesList =New list<SelectOption>();
    global list<SelectOption> addCountriesList = New list<SelectOption>();
    global list<SelectOption> addStatesList =New list<SelectOption>();
    global list<SelectOption> credCountriesList = New list<SelectOption>();
    global list<SelectOption> credStatesList =New list<SelectOption>();
    global list<SelectOption> bankCountriesList = New list<SelectOption>();

    global list<Partner_Prospect_Address__c> addresses {get; set;}
    global boolean render1 {get; set;}
    global boolean render2 {get; set;}
    global boolean render3 {get; set;}
    global boolean render4 {get; set;}
    global boolean render5 {get; set;}
    global boolean render6 {get; set;}
    global boolean render7 {get; set;}
    global boolean tablerender {get; set;}
    global boolean applater {get; set;}
    global boolean forcreation {get; set;}
    global boolean dbaCheck {get; set;}
    
    global string mc {get; set;}
    public string distr {get; set;}
    global string servicequestion {get; set;}
    global string currentservice {get; set;}
    global string training {get; set;}
    global string stock {get; set;}
    global string travel {get; set;}
    global string travel2 {get; set;}
    global string allcust {get; set;}
    global string CompanyName {get; set;}
    global string dba {get; set;}
    global string locname {get; set;}
    global string add1 {get; set;}
    global string add2 {get; set;}
    global string city {get; set;}
    global string zip {get; set;}
    global string phone {get; set;}
    global string fax {get; set;}
    global integer integ;
    
    global PartnerRegistrationController(ApexPages.StandardController controller) {
        this.controller = controller;
        CountriesList = util.setupCountryPicklist();
        addCountriesList = util.setupCountryPicklist();
        bankCountriesList = util.setupCountryPicklist();
        addStatesList    = util.setupStatesPicklist();
        credCountriesList = util.setupCountryPicklist();
        credStatesList    = util.setupStatesPicklist();
        StatesList    = util.setupStatesPicklist();
        string ppacid = ApexPages.currentPage().getParameters().get('id');
        If (ppacid != null){
            Partner_Portal_Access_Request__c a = [SELECT Bank_Name__c, Credit_Company_Name__c, Credit_Country__c, Credit_State__c, DBA__c, Bank_Country__c, Travel_2_Hours__c, Training_Needed__c, Service_All_KVH_Customers__c, Is_Main_Contact__c, Stock_Service_Parts__c, Servicing_Other_Companies__c, Integer_Counter__c, Company_Country__c, Company_State__c, Willing_to_Travel__c, Auth_for_Service_Questions__c FROM Partner_Portal_Access_Request__c WHERE Id =: ppacid];
            creditcountry = a.Credit_Country__c;
            bankcountry = a.Bank_Country__c;
            country = a.Company_Country__c;
            CompanyName = a.Credit_Company_Name__c;
            dba = a.DBA__c;
            addresses = [SELECT Friendly_Address__c, Location_Name__c, Address_1__c, Address_2__c, City__c, Country__c, Fax__c, Phone__c, State__c, Zip_Postal_Code__c, Partner_Portal_Access_Request__c FROM Partner_Prospect_Address__c WHERE Partner_Portal_Access_Request__c =: ppacid];
            if(addresses.size() > 0){
                tablerender=true;
                integ=addresses.size() + 1;
            } else{
                integ=1;
            }
            if(a.Bank_Name__c != null){
                applater = true;
                render7 = true;
            } else {
                render7 = false;
                applater = false;
            }
            if(a.Company_State__c != null){  
                StatesList.clear();
                StatesList.add(new SelectOption(a.Company_State__c, a.Company_State__c));
                state = a.Company_State__c;
            } else {
                state = null;
                StatesList.clear();
            }
            if(a.Credit_State__c != null){  
                credStatesList.clear();
                credStatesList.add(new SelectOption(a.Company_State__c, a.Company_State__c));
                creditstate = a.Credit_State__c;
            } else {
                creditstate = null;
                credStatesList.clear();
            }
            travel = a.Willing_to_Travel__c;
            travel2 = a.Travel_2_Hours__c; 
            if(a.Is_Main_Contact__c == false){
                render1 = true;
                mc = 'No';
            } else {
                forcreation = true;
                mc = 'Yes';
            }
            if(a.Auth_for_Service_Questions__c){
                render3 = true;
                servicequestion = 'Yes';
            } else{
                servicequestion = 'No';
                render4 = true;
            }
            if(a.Willing_to_Travel__c == 'Yes'){
                render6 = true;
                travel = 'Yes';
            } else{
                travel = 'No';
            }
            if(a.Servicing_Other_Companies__c){
                render5 = true;
                currentservice = 'Yes';
            } else{
                currentservice = 'No';
            }if(a.Training_Needed__c){
                training = 'Yes';
            } else {
                training = 'No';
            }if(a.Stock_Service_Parts__c){
                stock = 'Yes';
            } else{
                stock = 'No';
            }if(a.Service_All_KVH_Customers__c){
                allcust = 'Yes';
            }else{
                allcust = 'No';
            }
        } else {
            render6 = false;
            render3 = false;
            render5 = false;
            render1 = false;
            render7 = false;
            applater = true;
            forcreation = false;
            tablerender = false;
            integ = 1;
        }
        rectype = Schema.SObjectType.Partner_Portal_Access_Request__c.getRecordTypeInfosByName().get('Indirect Partner').getRecordTypeId();
        render2 = false;
        dbacheck = false;
    }

    global Integer getinteg(){
        return integ;
    }
    global PageReference backtoreg(){
        this.controller = controller;
        controller.save();
        this.req = (Partner_Portal_Access_Request__c)controller.getRecord();
        system.debug(req);
        req.Credit_Company_Name__c = CompanyName;
        req.DBA__c = dba;
        req.Credit_Country__c = creditcountry;
        req.Credit_State__c = creditstate;
        req.Bank_Country__c = bankcountry;
        system.debug('years in business: ' + req.Years_in_Business__c);
        addLocation();
        try{
            insert addresses;
        } catch (Exception e){
            system.debug('insert addresses error: ' + e);
        }
        try{
            update req;
        } catch (Exception e){
            system.debug('UPDATE request error: ' + e);
        }
        PageReference pageref = new PageReference('/PartnerRegistration?id=' + req.id);
        return pageRef;
    }
    global PageReference updateppac(){
        if(creditcountry == 'Choose One'){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose a country for your Billing Information.');
            ApexPages.addMessage(myMsg1);
            return null;
        } else if(creditstate == 'Choose Country First' || creditstate == 'Choose One'){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose a state for your Billing Information.');
            ApexPages.addMessage(myMsg1);
            return null;
        } else if(bankcountry == 'Choose One'){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose a country for your Bank.');
            ApexPages.addMessage(myMsg1);
            return null;
        } else if(CompanyName == null){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a company name.');
            ApexPages.addMessage(myMsg1);
            return null;
        }
        this.req = (Partner_Portal_Access_Request__c)controller.getRecord();
		string ppacid = ApexPages.currentPage().getParameters().get('id');
        req.Id = ppacid;
        req.Credit_Company_Name__c = CompanyName;
        req.DBA__c = dba;
        req.Credit_Country__c = creditcountry;
        req.Credit_State__c = creditstate;
        req.Bank_Country__c = bankcountry;
        this.controller = controller;
        addLocation();
        try{
            insert addresses;
        } catch (Exception e){
            system.debug('insert addresses error: ' + e);
        }
        try{
            update req;
        } catch (Exception e){
            system.debug('UPDATE request error: ' + e);
        }
        PageReference pageref = new PageReference('/PartnerRegThanks');
        return pageref;       
    }
    global PageReference saveTech(){
        if(country == 'Choose One'){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose a country for your Company.');
            ApexPages.addMessage(myMsg1);
            return null;
        } else if(state == 'Choose Country First' || state == 'Choose One'){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose a state for your Company.');
            ApexPages.addMessage(myMsg1);
            return null;
        }
        this.req = (Partner_Portal_Access_Request__c)controller.getRecord();
        this.controller = controller;
        req.Company_Country__c = country;
        req.Company_State__c = state;
        try{
            insert req;
        } catch (Exception e){
            system.debug('UPDATE request error: ' + e);
        }
        PageReference pageref = new PageReference('/PartnerRegThanks');
        pageref.setRedirect(true);
        return pageref;       
    }
    global PageReference addLocation() {
        if(addcountry == 'Choose One'){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose a country for your Retail Location.');
            ApexPages.addMessage(myMsg1);
            return null;
        } else if(addstate == 'Choose Country First' || addstate == 'Choose One'){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose a state for your Retail Location.');
            ApexPages.addMessage(myMsg1);
            return null;
        }
        if(add1 == null){
            return null;
        }
        Partner_Prospect_Address__c curadd = new Partner_Prospect_Address__c();
        string ppacid = ApexPages.currentPage().getParameters().get('id');
        curadd.Location_Name__c = locname;
        curadd.Address_1__c = add1;
        curadd.Address_2__c = add2;
        curadd.City__c = city;
        curadd.Partner_Portal_Access_Request__c = ppacid;
        curadd.Country__c = addcountry;
        curadd.State__c = addstate;
        curadd.Zip_Postal_Code__c = zip;
        curadd.Phone__c = phone;
        curadd.Fax__c = fax;
        system.debug(curadd);
        addresses.add(curadd);
        incrementCounter(ppacid);
        system.debug('list of addresses is: ' + addresses);
        add1 = ' ';
        locname = ' ';
        phone = ' ';
        fax = ' ';
        add2 = ' ';
        city = ' ';
        addcountry = ' ';
        addstate = ' ';
        zip = ' ';
        tablerender=true;
        return null;
    }
    global PageReference render1set(){
        if(mc == 'No'){
            render1 = true;
            forcreation = false;
        } else {
            render1 = false;
            forcreation = true;
        }
        return null;
    }
    global PageReference render2set(){
        if(distr == 'Yes'){
            render2 = true;
        } else {
            render2 = false;
        }
        return null;
    }
    global PageReference render3set() {
        if(servicequestion == 'Yes') {
            render3 = true;
            render4 = false;
        } else{
            render3 = false;
            render4 = true;
        }
        return null;
    }
    global PageReference render5set() {
        if(currentservice == 'Yes') {
            render5 = true;
        } else{
            render5 = false;
        }
        
        return null;
    }
    global PageReference render6set() {
        if(travel == 'Yes') {
            render6 = true;
        } else {
            render6 = false;
        }
        return null;
    }
    global PageReference render7set() {
        if(applater == true) {
            render7 = true;
        } else {
            render7 = false;
        }
        return null;
    }
    global PageReference dbaset(){
        If(dbaCheck == true) {
            dba = CompanyName;
        } else {
            dba = null;
        }
        return null;       
    }
    global PageReference saveNewRecordCont(){
        if(country == 'Choose One'){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose a country for your Company.');
            ApexPages.addMessage(myMsg1);
            return null;
        } else if(state == 'Choose Country First' || state == 'Choose One'){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose a state for your Company.');
            ApexPages.addMessage(myMsg1);
            return null;
        }
        rectype = Schema.SObjectType.Partner_Portal_Access_Request__c.getRecordTypeInfosByName().get('Direct Partner').getRecordTypeId();
        string reqid =  ApexPages.currentPage().getParameters().get('id');
        PageReference pageref = new PageReference('/PartnerCreditApp?id=');
        if (reqid == null){
            pageref = saveNewRecord();
            reqid = req.Id;
        } else{
            this.req = (Partner_Portal_Access_Request__c)controller.getRecord();
            req.Id = reqid;
            req.Company_Country__c = country;
            req.Company_State__c = state;
            update req;
        }
        pageref = new PageReference('/PartnerCreditApp?id=' + reqid);
        return pageRef;       
    }
    global PageReference incrementCounter(string str) {
        	integ = integ + 1;
            Partner_Portal_Access_Request__c a = [SELECT Integer_Counter__c FROM Partner_Portal_Access_Request__c WHERE Id =: str LIMIT 1];
            a.Integer_Counter__c = integ;
            update a;
            return null;
    }

    global PageReference saveNewRecord(){
        if(country == 'Choose One'){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose a country for your Company.');
            ApexPages.addMessage(myMsg1);
            return null;
        } else if(state == 'Choose Country First' || state == 'Choose One'){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose a state for your Company.');
            ApexPages.addMessage(myMsg1);
            return null;
        }
        this.req = (Partner_Portal_Access_Request__c)controller.getRecord();
        req.RecordTypeId = rectype;
        Id uId = UserInfo.getUserId();
        req.Willing_to_Travel__c = travel;
        req.Travel_2_Hours__c = travel2;
        req.Company_Country__c = country;
        req.Company_State__c = state;
        req.Is_Main_Contact__c = forcreation;
        req.Has_Distributor__c = distr;
        req.Auth_for_Service_Questions__c = render3;
        req.Servicing_Other_Companies__c = render5;
        if(allcust == 'Yes'){
            req.Service_All_KVH_Customers__c = true;
        } else {
            req.Service_All_KVH_Customers__c = false;
        }
        if(stock == 'Yes'){
            req.Stock_Service_Parts__c = true;
        } else{
            req.Stock_Service_Parts__c = false;
        }
        if(training == 'Yes'){
            req.Training_Needed__c = true;
        } else {
            req.Training_Needed__c = false;
        }
        try {
            insert req;
        } catch (exception e){
            Case exceptCase = new Case();
            Id ppcase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Partner Portal').getRecordTypeId();
            Group caseQueue = [SELECT Id FROM Group WHERE DeveloperName = 'Partner_Portal' and Type = 'Queue' LIMIT 1];
            Id userid = UserInfo.getUserId();
            User cont = [SELECT Id, ContactId FROM User WHERE Id =: userid LIMIT 1];
            exceptCase.OwnerId = caseQueue.Id;
            exceptCase.Subject = 'Error when submitting Partner Access Request for ' + req.Contact_Email__c;
            exceptCase.ContactId = cont.ContactId;
            exceptCase.Description = E.getMessage() + '(User from: '+req.Company_Name__c+')';
            exceptCase.Origin = 'Web';
            exceptCase.Status = 'New';
            insert exceptCase;
        }
        PageReference pageref = new PageReference('/PartnerRegThanks');
        pageref.setRedirect(true);
        return pageref;
    }
    public list<SelectOption> getCountriesList(){
        return CountriesList;
    }
    public list<SelectOption> getStatesList(){
        return StatesList;
    }
    public list<SelectOption> getcredCountriesList(){
        return credCountriesList;
    }
    public list<SelectOption> getbankCountriesList(){
        return bankCountriesList;
    }
    public list<SelectOption> getcredStatesList(){
        return credStatesList;
    }
    public list<SelectOption> getaddCountriesList(){
        return addCountriesList;
    }
    public list<SelectOption> getaddStatesList(){
        return addStatesList;
    }
    public void componentCountryChangeHandlerBilling(){
        system.debug('country'  + country);
        StatesList = util.CountryChangeHandler(country, state);
    }
    public void componentaddCountryChangeHandlerBilling(){
        system.debug('country'  + addcountry);
        addStatesList = util.CountryChangeHandler(addcountry, addstate);
    }
    public void componentCreditCountryChangeHandlerBilling(){
        system.debug('country'  + creditcountry);
        StatesList = util.CountryChangeHandler(creditcountry, creditstate);
    }

}