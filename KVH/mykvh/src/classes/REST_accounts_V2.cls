@RestResource(urlMapping='/V2/accounts/*')
global with sharing class REST_accounts_V2 {
  @HttpGet
  //Responds to an HttpGet naturally... 
  //Given an Account ID, this Class returns the list of platforms
  global static Account[] doGet(){
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    //declare return list
    List<Account> Accounts = new List<Account>();
    //variables for Asset query
    String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    if (identifier.left(3) != '001') {
      //We did not get an Account identifier
      res.statusCode = 400;    //Something bad happened... Should never get here!
                    //recommended remedial action is try again!
    } else {
      Try {
        Accounts = [SELECT Id, Name, myKVH_Parent_Account__c,
              RecordType.Name,
              //following fields added to support future features....
              myKVH_Parent_Override__c, myKVH_Parent_Manual_Selection__c, 
              myKVH_Parent_Automatic_Selection__c,
              myKVH_Normal_State__c, myKVH_Element_Count__c
              FROM Account WHERE Id=:identifier AND BillingCountry<>'Platform'];
        if (Accounts.size()==0){
          res.statusCode = 404; }} Catch (Exception e) { res.statusCode = 500;    //Something bad happened... Should never get here!
      }
      //Check for missing myKVH Parent IDs
      //Should probably add these accounts to a list that will update 
      for (Account a : Accounts) {
        //Convert text fields to case safe IDs
        Id tempIdParent = a.myKVH_Parent_Account__c;
        Id tempIDAutoSelect = a.myKVH_Parent_Automatic_Selection__c;
        Id tempIdManual = a.myKVH_Parent_Manual_Selection__c;
        //manual select is already an ID!
        if (a.myKVH_Parent_Override__c == true && (tempIdParent != tempIdManual)) { a.myKVH_Parent_Account__c = tempIdManual;
          //Use manual selection, but fix it first!
        } else if (a.myKVH_Parent_Override__c == false && (tempIdParent != tempIDAutoSelect)) { a.myKVH_Parent_Account__c = tempIDAutoSelect;
          //Use Automatic Selection....
        }
      }
    }
    return Accounts;  
  }
}