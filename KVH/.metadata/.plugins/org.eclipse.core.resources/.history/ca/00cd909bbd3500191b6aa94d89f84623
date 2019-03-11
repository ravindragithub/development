/***********************************************************************************************************************
 Name: CreatingNewAsset
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: 1) This is used to create new Asset while Creating PrivateStatic IP
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      08/18/2014       Initial Development                                   
***********************************************************************************************************************/

Trigger CreatingNewAsset on Private_Static_IP__c (after insert){
        /*
        1) StopCreatingNewAssetTgr Label: Used to Stop Trigger when we needs from Cutom labels.
        2) Trigger fires when insert new static IP.
        3) UtilClassCreatingNewAsset : Utility Class for while Creating New Asset.
        */
    
    if((Trigger.IsInsert || Trigger.IsAfter) && Boolean.valueOf(system.label.stopCreatingNewAssetTgr)){
        UtilClassCreatingNewAsset.ExecuteAssetCreation(Trigger.New);
    }
}