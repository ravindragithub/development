/***********************************************************************************************************************
 Name: add_Identifier_Product
 Copyright © 2015 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose:  To Inactive Portal user(Created New feild IsActiveProxy__c on User Object)
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


Trigger UserObjectTrigger on User (Before update) {
    if(Trigger.isBefore && Trigger.isUpdate){
        for(Integer i=0;i<trigger.new.size();i++){
            if(trigger.new[i].IsActiveProxy__c != trigger.old[i].IsActiveProxy__c){
                trigger.new[i].IsActive = trigger.new[i].IsActiveProxy__c;
            }
        }
    }
}