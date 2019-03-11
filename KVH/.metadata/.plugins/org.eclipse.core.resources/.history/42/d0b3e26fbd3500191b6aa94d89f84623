@RestResource(urlMapping='/V1/platforms/*')
global with sharing class REST_platforms {
    
    private static string loadQueryString(){     //setup query string
        string s = 'SELECT Id, Name, myKVH_Parent_Account__c, RecordType.Name, ';
        s += 'Vessel_IMO__c, MMSI__c, Vessel_Radio_Call_Sign__c, ';
        s += 'Industry_Designation__c, Platform_Detail__c, Flag__c, ';
        //following fields added to support future features....
        s += 'myKVH_Parent_Override__c, myKVH_Parent_Manual_Selection__c, ';
        s += 'myKVH_Parent_Automatic_Selection__c, ';
        s += 'myKVH_Normal_State__c, myKVH_Element_Count__c, ';
        s += 'Parent.Name, Parent.Id, Market__c, Market_Sector__c, ';
        s += 'Vessel_Email__c, Do_No_Rebalance__c,  User_Defined_Account_Name__c ';
        s += 'FROM Account ';
        return s;
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
			res.statusCode = 400;		//Something bad happened... Should never get here!
										//recommended remedial action is try again!
		} else {
			Try {
			    Platforms = Database.query(queryString + 'WHERE Id = \'' + identifier + '\' AND RecordType.DeveloperName LIKE \'Platform%\'');
				if (Platforms.size()==0){
					res.statusCode = 404;
					system.debug('empty LIST !!!!!!!!!!!!!');
				}
			} Catch (Exception e) { res.statusCode = 500; }		//Something bad happened... Should never get here!
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
    //Given an Account ID, this Class returns the list of platforms
    global static platforms_return doPatch(platform_patch platform_update){
        string queryString = loadQueryString();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        REST_API_utilities.resultCode rc = new REST_API_utilities.resultCode(false, 'initialization');      //init result code for Payload class
        platforms_return updatedPlatform = new platforms_return(rc,null);   //init cases_return class....
        //get Platform to update TODO: refactor query into a method
        List<Account> Platforms = new List<Account>();
        //variables for Asset query
        String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if (identifier.left(3) != '001') {
            //We did not get an Account identifier
            res.statusCode = 400;       //Something bad happened... Should never get here!
                                        //recommended remedial action is try again!
            rc.success = false;                                     //Could not find platform!
            rc.exceptionMessage = 'Not a Platform or Account Id == ' + identifier;
            updatedPlatform.resultCode = rc;                        //Attach the resultCode Class to the return payload
        } else {
            Try {
                Platforms = Database.query(queryString + 'WHERE Id = \'' + identifier + '\' AND RecordType.DeveloperName LIKE \'Platform%\'');
                if (Platforms.size()==0){
                    res.statusCode = 404;
                    system.debug('empty LIST !!!!!!!!!!!!!');
                    rc.success = false;                                     //Could not find platform!
                    rc.exceptionMessage = 'Platform was not found with Id == ' + identifier;
                    updatedPlatform.resultCode = rc;                        //Attach the resultCode Class to the return payload
                } else {
                    Account JSONBody = new Account();
                    JSONBody = platform_update.platform_update_fields;
                    Platforms[0].User_Defined_Account_Name__c = JSONBody.User_Defined_Account_Name__c;
                    update Platforms[0];
                    rc.success = true;                                  //Everything (maybe) worked... 
                    rc.exceptionMessage = '';                           //no Exception Message, everything is cool!
                    updatedPlatform.resultCode = rc;                        //Attach the resultCode Class to the return payload
                    updatedPlatform.platform_id = Platforms[0].id;
                    updatedPlatform.friendly_name = Platforms[0].User_Defined_Account_Name__c;
                }
            } Catch (Exception e) { res.statusCode = 500; }     //Something bad happened... Should never get here!
                                                                //recommended remedial action is try again!
        }
        return updatedPlatform;
    }
	
	//Inner Classes for input and output
    global class platforms_return {                     //Used as return object for a PATCH call
        //public resultCode resultCode;                 //resultCode class...
        public REST_API_utilities.resultCode resultCode;            //resultCode class...
        public string platform_id;                      //record ID of updated Account (if PATCH successful)
        public string friendly_name;                    //Friendly name, supplied by user
        //Constructor for payload inner class
        public platforms_return(REST_API_utilities.resultCode RC_code, string platform_id){
            resultCode = RC_Code;
            platform_id = null;
            friendly_name = null;
        }
    }
    global class platform_patch {
        public Account platform_update_fields;                           //Account fields submitted in JSON
    }
}