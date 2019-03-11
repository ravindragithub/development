/***********************************************************************************************************************
 Name: add_Identifier_Product
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to Util Class for Contact triggers.
          
          a) To Inactive Portal user(Created New feild IsActiveProxy__c on User Object)
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      01/09/2015       Initial Development                                   
***********************************************************************************************************************/
Public Class UtilClassForContactTriggers{
    
    Public Static Void InActiveCustomPortalUser(List<Contact> allContacts){
        Map<Id,Boolean> conIds = New Map<Id,Boolean>();
        for(Contact ConObj:allContacts){
            conIds.put(ConObj.id,ConObj.Inactive_Contact__c);
        }
        InactiveUser(conIds);
    }
    
   
    Private Static Void InactiveUser(Map<Id,Boolean> conIds){
        //Inactive Customer Portal User.
        List<User> inactivePortalUsers = [Select Id,IsActiveProxy__c,ContactID From User Where ContactID=:conIds.keySet()];
        
        if(inactivePortalUsers.size()>0){
            for(User updateusers:inactivePortalUsers){
                updateusers.IsActiveProxy__c = conIds.get(updateusers.ContactID);
            }
            update inactivePortalUsers;
        } 
    }
    
}