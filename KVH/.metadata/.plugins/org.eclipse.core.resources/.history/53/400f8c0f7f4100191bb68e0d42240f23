@RestResource(urlMapping='/V2/platforms/*')
global with sharing class REST_platforms_V2 {
    
    private static string loadQueryString(){     //setup query string
        string s = 'SELECT Id, Name, myKVH_Parent_Account__c, RecordType.Name, ';
        s += 'Vessel_IMO__c, MMSI__c, Vessel_Radio_Call_Sign__c, ';
        s += 'Industry_Designation__c, Platform_Detail__c, Flag__c, ';
        //following fields added to support future features....
        s += 'myKVH_Parent_Override__c, myKVH_Parent_Manual_Selection__c, ';
        s += 'myKVH_Parent_Automatic_Selection__c, ';
        s += 'myKVH_Normal_State__c, myKVH_Element_Count__c, ';
        s += 'Parent.Name, Parent.Id, Market__c, Market_Sector__c, ';
        s += 'Vessel_Email__c, Do_No_Rebalance__c,  User_Defined_Account_Name__c, ';
        s += 'Premium_Tracking_Enabled__c ';
        s += 'FROM Account ';
        return s;
    }
    @testVisible
    //This method constrains the PATCHable fields to the few that are allowed
    private static list<Account> apply_patch_security(list<Account> platform_list){
        list<Account> return_list = new list<Account>();
        map<Id, Account> account_map = new map<Id,Account>(platform_list);
        set<Id> account_ids = account_map.keySet();
        for(Account a : [SELECT Id, RecordType.DeveloperName, Premium_Tracking_Enabled__c, User_Defined_Account_Name__c FROM Account WHERE Id IN :account_ids ]){
            if(a.RecordType.DeveloperName.left(9) == 'Platform_'){
                Account b = new Account(Id = a.id, 
                                        Premium_Tracking_Enabled__c = account_map.get(a.Id).Premium_Tracking_Enabled__c,
                                        User_Defined_Account_Name__c = account_map.get(a.Id).User_Defined_Account_Name__c);
                return_list.add(b);
            }
        }
        return return_list;
    }
    @HttpGet
    //Responds to an HttpGet naturally... 
    //Given an Account ID, this Class returns the list of platforms
    global static Account[] doGet(){
        string queryString = loadQueryString();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //declare return list
        List<Account> Platforms = new List<Account>();
        //variables for Asset query
        String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if (identifier.left(3) != '001') {
            //We did not get an Account identifier
            res.statusCode = 400;       //Something bad happened... Should never get here!
                                        //recommended remedial action is try again!
        } else {
            Try {
                Platforms = Database.query(queryString + 'WHERE Id = \'' + identifier + '\' AND RecordType.DeveloperName LIKE \'Platform%\'');
                if (Platforms.size()==0){
                    res.statusCode = 404;
                    system.debug('empty LIST !!!!!!!!!!!!!');
                }
            } Catch (Exception e) { res.statusCode = 500; }     //Something bad happened... Should never get here!
                                                                //recommended remidial action is try again!
            //Check for missing myKVH Parent IDs
            //Should probably add these accounts to a list that will update 
            for (Account a : Platforms) {
                //Convert text fields to case safe IDs
                Id tempIdParent = a.myKVH_Parent_Account__c;
                Id tempIDAutoSelect = a.myKVH_Parent_Automatic_Selection__c;
                //manual select is already an ID!
                if (a.myKVH_Parent_Override__c == true && (tempIdParent != a.myKVH_Parent_Manual_Selection__c)) {
                    //Use manual selection, but fix it first!
                    a.myKVH_Parent_Account__c = a.myKVH_Parent_Manual_Selection__c;
                } else if (a.myKVH_Parent_Override__c == false && (tempIdParent != tempIDAutoSelect)) {
                    //Use Automatic Selection....
                    a.myKVH_Parent_Account__c = tempIDAutoSelect;
                }
            }
        }
        return Platforms;
    }
    
    @HttpPatch
    //Responds to an HttpGet naturally... 
    //Given a list of Accounts (Platforms), makes updates, and returns a list of Account Ids, Changes wrapped up with a result Code
    global static platforms_return doPatch(platform_patch platform_update){
	    //setup return Object
	    REST_API_utilities.resultCode rc = new REST_API_utilities.resultCode(false, 'initialization');      //init result code for Payload class
	    list<Account> return_list = new list<Account>();
	    platforms_return return_object = new platforms_return(rc, return_list);
	    //setup Request and Response contexts
	    string queryString = loadQueryString();
	    RestRequest req = RestContext.request;
	    RestResponse res = RestContext.response;
	    List<Account> Platforms = new List<Account>();
	    Platforms = platform_update.platforms_to_update;
	    system.debug(Platforms);
	    try {
	        list<Account> safe_list = apply_patch_security(Platforms);
	        update safe_list;
	        if(safe_list.size() == 0){
	            res.statusCode = 400;
	            throw new noPlatformsException('The request body did not include any Platform records');
	        }
	        rc.success = true;
            rc.exceptionMessage = '';
            return_object.resultCode = rc;
	        return_object.platforms_updated = safe_list;
	    } catch (Exception e) {
            if(res.statusCode != 400){
                res.statusCode = 500;
            }
	        rc.exceptionMessage = e.getMessage();
            return_object.resultCode = rc;
            return_object.platforms_updated = new list<Account>();
	    } 
	    
	    return return_object;
    }
    

    
    //Inner Classes for input and output
    global class platforms_return {                             //Used as return object for a PATCH call
        public REST_API_utilities.resultCode resultCode;        //resultCode class...
        public list<Account> platforms_updated;
        //Constructor for payload inner class
        public platforms_return(REST_API_utilities.resultCode RC_code, Account[] platforms){
            resultCode = RC_Code;
            platforms_updated = platforms;
        }
    }
    
    global class platform_patch {
        public list<Account> platforms_to_update;                //Account details submitted in JSON
    }
    public class noPlatformsException extends Exception {}
}