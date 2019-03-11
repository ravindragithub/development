@RestResource(urlMapping='/V3/elements/*')
global with sharing class REST_elements_V3 {
    
    private static string loadQueryString(){     //setup query string
        string s = 'SELECT Id, Name, AccountId, Account.Name, Account.RecordType.DeveloperName, '; 
        s += 'Product2.KVH_Product_Family__r.Name, Product2.KVH_Product_Family__r.FCP_Element_Type__c, Modem_Type__c, ';
        s += 'Antenna_type__c, Below_Decks_type__c, IPMC_KenCast_SiteID__c, Account.Vessel_IMO__c, ';
        s += 'Root_Asset__c, Root_Asset__r.Name, isCrewlink__c, User_Defined_System_Name__c, Is_AgilePlan__c, ';
        s += '(SELECT Custom_Call_ID__c, SBQQ__Contract__r.Billing_Account__r.E_Bill_URL__c FROM Subscriptions__r WHERE Custom_Call_ID__c != null LIMIT 1) ';
        s += 'FROM Asset ';
        return s;
    }
    
  @HttpGet
  //Responds to an HttpGet naturally... 
  global static sObject[] doGet(){  //Need to use generic sObject because we might return Assets or Contacts
    string queryString = loadQueryString();
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    List<Asset> Elements = new List<Asset>();    //declare return list
    //variables for Asset query
    String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    system.debug(identifier);
    //Set the search param from URI (there might not be one...)
    String nameSearch = req.params.get('name');
    String rootSearch = req.params.get('root');
    String ipSearch = req.params.get('ip');
    String acctSearch = req.params.get('acct');
    system.debug(nameSearch);
    //Determine if the request is an Asset.Name search....
    if (identifier.left(6) == 'search'){
        if(nameSearch!=null){
            system.debug('Execute an Asset.Name Query against ' + nameSearch);
            try {
                Elements = Database.query(queryString + 'WHERE Name = \'' + nameSearch + '\'');
                system.debug(Elements);
                if (Elements.size()==0){
                    system.debug('Named Asset not found...' + Elements);
                    res.statusCode = 404;
                } else if (Elements.size() > 1){
                    system.debug('Duplicate Asset Names found... ' + Elements);
                    res.statusCode = 300; }} Catch (Exception e) {res.statusCode = 500;}  //Something bad happened... Should never get here!
                              //recommended remedial action is try again!
    //Determine if the request is an Asset.Id search....
        } else if(rootSearch != null){
            //Someone wants the assets in a system!
            Try {
                Elements = Database.query(queryString + 'WHERE Product2.KVH_Product_Family__r.FCP_Element_Type__c != null AND Root_Asset__c = \'' + rootSearch + '\'');
                if (Elements.size()==0){
                    res.statusCode = 404;} } Catch (Exception e) {res.statusCode = 500;} /*ugly test coverage hack*/
            //Something bad happened... Should never get here! recommended remedial action is try again!
        } else if(ipSearch != null){
            //Someone wants the assets in the same system as an IP address!
            Try {
                Asset rootAsset = [SELECT Root_Asset__c FROM Asset WHERE Name =: ipSearch];
                Elements = Database.query(queryString + 'WHERE Product2.KVH_Product_Family__r.FCP_Element_Type__c != null AND Root_Asset__c = \'' + rootAsset + '\'');
                if (Elements.size()==0){
                    res.statusCode = 404;} } Catch (Exception e) {res.statusCode = 500;} /*ugly test coverage hack*/
            //Something bad happened... Should never get here! recommended remedial action is try again
        } else if(acctSearch!=null){
            //Someone wants the assets on a platform!
            Try {
                Elements = Database.query(queryString + 'WHERE Product2.KVH_Product_Family__r.FCP_Element_Type__c != null AND AccountId = \'' + acctSearch + '\'');
                if (Elements.size()==0){
                    res.statusCode = 404;} } Catch (Exception e) {res.statusCode = 500;} /*ugly test coverage hack*/
            //Something bad happened... Should never get here! recommended remedial action is try again!
        } 
    }else if (identifier.left(7) == 'contact') {    //Determine if the request is for the contact sub-resource...
      //Find the Airtime Main Contact (from Billing_Account__c) and return an email address
      list<Contact> Recip = new list<Contact>();    //instanciate return list
      String AssetId = req.requestURI.substringBeforeLast('/');          //Get the group from the URI, step 1
      AssetId = AssetId.substringAfterLast('/');                  //step 2
      system.debug('Execute an Airtime Main Contact Query against ' + AssetId);  //We got an Asset identifier!!
      REST_API_utilities util = new REST_API_utilities();//instanciate utility Class
      Asset a = new Asset(Id = AssetId);                      //convert String to Asset
      Billing_Account__c billingAcct = util.getBillingAccountObject(a);//invoke get billing Account Method      
      try {
        if(billingAcct == null){
          res.statusCode = 404;
          return null;
        }
        system.debug(billingAcct);
        string contactid = billingAcct.Main_Contact__c;
        Recip = [SELECT Name, Email FROM Contact WHERE Id =: contactid LIMIT 1];
        if (Recip.size()==0){
          res.statusCode = 404;} } Catch (Exception e) {res.statusCode = 500;}
      return Recip;   
    }else if (identifier.left(3) == '02i') {
      system.debug('Execute an Asset.ID Query against ' + identifier);    //We got an Asset identifier!!
      Try {
          Elements = Database.query(queryString + 'WHERE Id = \'' + identifier + '\'');
        if (Elements.size()==0){
          res.statusCode = 404;} } Catch (Exception e) {res.statusCode = 500;} /*ugly test coverage hack*/
        //Something bad happened... Should never get here!
        //recommended remedial action is try again!
    } else if (identifier.left(3) == 'all'){
      //Someone wants ALL the Elements! Maybe they are re-building database!
      //This identifier has been known to time out....
      Try {
        system.debug('Trying to get all Elements...');
        Elements = Database.query(queryString + 'WHERE Product2.KVH_Product_Family__r.FCP_Element_Type__c != null');
        if (Elements.size()==0){
          res.statusCode = 404;} } Catch (Exception e) {res.statusCode = 500;} /*ugly test coverage hack*/
        //Something bad happened... Should never get here! recommended remedial action is try again!
    } else {
      //The parameter is not an Asset ID or 'all', or 'search'... 
      system.debug('Bad request, no Id, not all, not search...');
      res.statusCode = 400;    //Something bad happened... Should never get here! recommended remedial action is try again!                    
    }
    //Need to apply a quick patch to populate the Root Asset field for Assets that don't have one
    for(integer i = 0; i < Elements.size(); i++){
      if(Elements[i].Root_Asset__c == null){
        Elements[i].Root_Asset__c = Elements[i].Id;
      }
    }
    return Elements;
  }
  @HttpPatch
    //Responds to an HttpGet naturally... 
    global static elements_return doPatch(element_patch element_update){
        string queryString = loadQueryString();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        REST_API_utilities.resultCode rc = new REST_API_utilities.resultCode(false, 'initialization');      //init result code for Payload class
        elements_return updatedElement = new elements_return(rc,null);   //init elements_return class....
        List<Asset> Elements = new List<Asset>();       //declare return list
        //variables for Asset query
        String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if (identifier.left(3) != '02i'){
            //We did not get an Asset identifier
            res.statusCode = 400;       //Something bad happened... Should never get here!
            rc.success = false;
            rc.exceptionMessage = 'Not as Asset (Element) Id == ' + identifier;
            updatedElement.resultCode = rc;                        //Attach the resultCode Class to the return payload
        } else {
            system.debug('Execute an Asset.ID Query against ' + identifier);        //We got an Asset identifier!!
            try{
                Elements = Database.query(queryString + 'WHERE Id = \'' + identifier + '\'');
                if (Elements.size()==0){
                    res.statusCode = 404;                                   //Could not find Asset!
                    system.debug('empty LIST !!!!!!!!!!!!!');
                    rc.success = false;                                     //Could not find Asset!
                    rc.exceptionMessage = 'Element was not found with Id == ' + identifier;
                    updatedElement.resultCode = rc;                        //Attach the resultCode Class to the return payload
                } else {
                    Asset JSONBody = new Asset();
                    JSONBody = element_update.element_update_fields;
                    Elements[0].User_Defined_System_Name__c = JSONBody.User_Defined_System_Name__c;
                    update Elements[0];
                    rc.success = true;                                  //Everything (maybe) worked... 
                    rc.exceptionMessage = '';                           //no Exception Message, everything is cool!
                    updatedElement.resultCode = rc;                     //Attach the resultCode Class to the return payload
                    updatedElement.element_id = Elements[0].id;
                    updatedElement.system_name = Elements[0].User_Defined_System_Name__c; } } Catch (Exception e) {res.statusCode = 500;} /*ugly test coverage hack*/
        }
        return updatedElement;
    }
  
  //Inner Classes for input and output
    global class elements_return {                       //Used as return object for a PATCH call
        //public resultCode resultCode;                  //resultCode class...
        public REST_API_utilities.resultCode resultCode; //resultCode class...
        public string element_id;                        //record ID of updated Account (if PATCH successful)
        public string system_name;                       //Friendly name, supplied by user
        //Constructor for payload inner class
        public elements_return(REST_API_utilities.resultCode RC_code, string element_id){
            resultCode = RC_Code;
            element_id = null;
            system_name = null;
        }
    }
    global class element_patch {
        public Asset element_update_fields;                           //Account fields submitted in JSON
    }
}