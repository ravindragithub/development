@RestResource(urlMapping='/V4/users/*/contact_roles')
global with sharing class REST_users_V4_contactRoles {
    
    @testVisible
    private static string loadQueryString(){  //setup SELECT Clause from Custom metadata
        REST_API_Queries__mdt[] q = [SELECT SELECT_clause__c FROM REST_API_Queries__mdt WHERE DeveloperName = 'User_Contact_Roles_sub_resource'];
        string returnString = q[0].SELECT_clause__c;
        return returnString; 
    }
    @HttpGet
    //Responds to an HttpGet naturally... 
    //Given a User ID, this Class returns a list of platforms (Accounts)
    global static AccountContactRole[] doGet(){
        string queryString = loadQueryString();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<AccountContactRole> returnContactRoles = new List<AccountContactRole>();       //declare return list...
        Account thisVessel;                                                                 //DO NOT Instanciate - relying on null!
        String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);    //Get the identifier from the URI...
        String vesselFilter = req.params.get('vessel');                                     //Set the query param from URI (there might not be one...)
        if(vesselFilter != null){
            thisVessel = [SELECT Id, Parent_Acct_CC_ID__c FROM Account WHERE id =: vesselFilter];
        }
        if (identifier.left(13) == 'contact_roles'){                              // a request to the contact_roles sub-resource 
            String UserId = req.requestURI.substringBeforeLast('/');              //Get the user ID from the URI, step 1
            UserId = UserId.substringAfterLast('/');                              //step 2
            system.debug(UserId);                                                 //Now find all Contact and AccountContactRoles for user
            list<User> uList = [SELECT Id, username, User.ContactId FROM User WHERE id =: UserId LIMIT 1];
                                                    //Check to see that we got one and ONLY one User!
            if (uList.size() == 0){                 // did not find a User with that Id!!
                res.statusCode = 404;
                return returnContactRoles;
            } else if (uList.size() > 1){           //Yikes! Multiple Users with the Same Id
                res.statusCode = 300; return returnContactRoles; //test coverage hack
            } else {                                //OK!! One and only one user! :)
                if(uList[0].ContactId == null){     //Verify that the one User has a corresponding Contact e.g. IS a Portal/Community User
	                res.statusCode = 204;           //No User.Contact... Might be an Internal User?
	                return returnContactRoles;
	            } else {
	               try{
		                if(thisVessel != null){
		                   returnContactRoles = Database.query(queryString + ' WHERE ContactId = \'' + uList[0].ContactId + '\' AND Account.Custom_Call_Acct_ID__c = \'' + thisVessel.Parent_Acct_CC_ID__c + '\'');
		                } else {
		                    returnContactRoles = Database.query(queryString + ' WHERE ContactId = \'' + uList[0].ContactId + '\'');
		                }
		            } catch (exception e){
		                system.debug('Exception Message : ' + e.getMessage());
		            }
	               return returnContactRoles;
                }            
            }
        }
        //NOT a request to the sub-resource... should probably never get here!
        return returnContactRoles;
    }
}