@RestResource(urlMapping='/V1/userfields/*') 
global with sharing class REST_userfields {
    @HttpGet
    //Responds to an HttpGet naturally... 
    global static myKVH_User_Field__c[] doGet() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //declare return list
        List<myKVH_User_Field__c> UserFields = new List<myKVH_User_Field__c>();
        //Get the identifier from the URI
        String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        system.debug(identifier);
        if (identifier.left(3) == 'a1m') {//a1m is prefix for myKVH User Fields, returns a single field
            Try {
                UserFields = [SELECT Id, Name, Description__c, myKVH_Feature__c, Default_Read__c, Default_Edit__c, Order_Weight__c FROM myKVH_User_Field__c WHERE Id=:identifier];
                if (UserFields.size()==0){
                    res.statusCode = 404;
                }
            } Catch (Exception e) {res.statusCode = 500;}   //Something bad happened... Should never get here!
                                                            //recommended remidial action is try again!
        } else if (identifier.left(3) == 'all') {   //try to get ALL the User Fields
            Try {
                UserFields = [SELECT Id, Name, Description__c, myKVH_Feature__c, Default_Read__c, Default_Edit__c, Order_Weight__c FROM myKVH_User_Field__c];
                if (UserFields.size()==0){
                    res.statusCode = 404;
                }
            } Catch (Exception e) {res.statusCode = 500;}   //Something bad happened... Should never get here!
                                                            //recommended remidial action is try again!
        } else if (identifier.left(3) == 'a1i') {   //try to get ALL the User Fields for a given feature (a1i is a Feature prefix)
            Try {
                UserFields = [SELECT Id, Name, Description__c, myKVH_Feature__c, Default_Read__c, Default_Edit__c, Order_Weight__c FROM myKVH_User_Field__c WHERE myKVH_Feature__c =:identifier];
                if (UserFields.size()==0){
                    res.statusCode = 404;
                }
            } Catch (Exception e) {res.statusCode = 500;}   //Something bad happened... Should never get here!
                                                            //recommended remidial action is try again!
        } else {
            //We did not get an identifier
            res.statusCode = 400;       //Something bad happened... Should never get here!
                                        //recommended remedial action is try again!
        }
        
        return UserFields;
    }
}