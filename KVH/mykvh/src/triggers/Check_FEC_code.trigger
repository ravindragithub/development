/***********************************************************************************************************************
 Name: Check_FEC_code
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: 1) This is used to Update FEC Code values if any Value coming like eg: 34 trigger will update with '3/4'
          2) If any small Change done in data minor version will be changed. 
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      11/03/2014       Initial Development                                   
***********************************************************************************************************************/



trigger Check_FEC_code on SatInfoMaster__c (before insert, before update)
{
   if(trigger.isbefore)
   {
       if(trigger.isInsert){
           for(SatInfoMaster__c sm : trigger.new) 
           {    
               //This is used to Update FEC Code values if any Value coming like eg: 34 trigger will update with '3/4'
               utilClassfor_Check_FEC_code_Trigger.properValueUpdateinFECCode(sm);
               sm.Minor_Version__c = true;
           }
       }
       
       if(trigger.isupdate)
       {
           for(integer i = 0;i<trigger.new.size();i++)
           {
               if(trigger.new[i] != trigger.old[i])
               {
                   if(SatInfoXMLController.stopTrigger){
                   trigger.new[i].Minor_Version__c = true;
                   }
               }
           }
       }
   } 
}