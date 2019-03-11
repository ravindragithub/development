/***********************************************************************************************************************
 Name: utilClassfor_Check_FEC_code_Trigger
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: 1) properValueUpdateinFECCode       : This is used to Update FEC Code values if any Value coming like 
                                                eg: 34 trigger will update with '3/4'.
          2) tuner2UpdationIf_InstallHD11NULL : If HD11 field not null then "Tuner1" Values copied to "Tuner2"
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      18/03/2014       Initial Development                                   
***********************************************************************************************************************/

public class utilClassfor_Check_FEC_code_Trigger
{
    
    //This is used to Update FEC Code values if any Value coming like eg: 34 trigger will update with '3/4'.
    public static void properValueUpdateinFECCode(SatInfoMaster__c sm)
    {
        try
        {
          if(sm.FEC_Code_VH__c != null && !sm.FEC_Code_VH__c.contains('/')) {
             if(sm.FEC_Code_VH__c.length() >= 3)
                  sm.FEC_Code_VH__c = sm.FEC_Code_VH__c.substring(0,1) + '/' +  sm.FEC_Code_VH__c.substring(1,3);
             else
               sm.FEC_Code_VH__c = sm.FEC_Code_VH__c.substring(0,1) + '/' +  sm.FEC_Code_VH__c.substring(1,2);
          }
          if(sm.FEC_Code_HH__c != null && !sm.FEC_Code_HH__c.contains('/')) {
             if( sm.FEC_Code_HH__c.length() >=3)
              sm.FEC_Code_HH__c = sm.FEC_Code_HH__c.substring(0,1) + '/' +  sm.FEC_Code_HH__c.substring(1,3);
             else
               sm.FEC_Code_HH__c = sm.FEC_Code_HH__c.substring(0,1) + '/' +  sm.FEC_Code_HH__c.substring(1,2);
          }
          if(sm.FEC_Code_VL__c != null && !sm.FEC_Code_VL__c.contains('/')) {
             if(sm.FEC_Code_VL__c.length() >=3)
               sm.FEC_Code_VL__c = sm.FEC_Code_VL__c.substring(0,1) + '/' +  sm.FEC_Code_VL__c.substring(1,3);
             else
               sm.FEC_Code_VL__c = sm.FEC_Code_VL__c.substring(0,1) + '/' +  sm.FEC_Code_VL__c.substring(1,2);
          }
          if(sm.FEC_Code_HL__c != null && !sm.FEC_Code_HL__c.contains('/')) {
             if(sm.FEC_Code_HL__c.length() >= 3)
               sm.FEC_Code_HL__c = sm.FEC_Code_HL__c.substring(0,1) + '/' +  sm.FEC_Code_HL__c.substring(1,3);
             else
               sm.FEC_Code_HL__c = sm.FEC_Code_HL__c.substring(0,1) + '/' +  sm.FEC_Code_HL__c.substring(1,2);
          }
          if(sm.FEC_Code_VHalt__c != null && !sm.FEC_Code_VHalt__c.contains('/')) {
             if(sm.FEC_Code_VHalt__c.length() >=3)
               sm.FEC_Code_VHalt__c = sm.FEC_Code_VHalt__c.substring(0,1) + '/' +  sm.FEC_Code_VHalt__c.substring(1,3);
             else
               sm.FEC_Code_VHalt__c = sm.FEC_Code_VHalt__c.substring(0,1) + '/' +  sm.FEC_Code_VHalt__c.substring(1,2);
          }
          if(sm.FEC_Code_HHalt__c != null && !sm.FEC_Code_HHalt__c.contains('/')) {
             if(sm.FEC_Code_HHalt__c.length() >= 3)
               sm.FEC_Code_HHalt__c = sm.FEC_Code_HHalt__c.substring(0,1) + '/' +  sm.FEC_Code_HHalt__c.substring(1,3);
             else
               sm.FEC_Code_HHalt__c = sm.FEC_Code_HHalt__c.substring(0,1) + '/' +  sm.FEC_Code_HHalt__c.substring(1,2);
          }
          if(sm.FEC_Code_VLalt__c != null && !sm.FEC_Code_VLalt__c.contains('/')) {
             if(sm.FEC_Code_VLalt__c.length() >=3)
               sm.FEC_Code_VLalt__c = sm.FEC_Code_VLalt__c.substring(0,1) + '/' +  sm.FEC_Code_VLalt__c.substring(1,3);
             else
               sm.FEC_Code_VLalt__c = sm.FEC_Code_VLalt__c.substring(0,1) + '/' +  sm.FEC_Code_VLalt__c.substring(1,2);
          }
          if(sm.FEC_Code_HLalt__c != null && !sm.FEC_Code_HLalt__c.contains('/')) {
             if(sm.FEC_Code_HLalt__c.length() >=3)
               sm.FEC_Code_HLalt__c = sm.FEC_Code_HLalt__c.substring(0,1) + '/' +  sm.FEC_Code_HLalt__c.substring(1,3);
             else
               sm.FEC_Code_HLalt__c = sm.FEC_Code_HLalt__c.substring(0,1) + '/' +  sm.FEC_Code_HLalt__c.substring(1,2);
          }
        }
        Catch(Exception e)
        {}
    }  
}