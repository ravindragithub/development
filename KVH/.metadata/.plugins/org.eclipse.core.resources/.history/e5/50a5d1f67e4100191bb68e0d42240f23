/***********************************************************************************************************************
 Name: Create_New_Identifier_Asset
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to validate if there is no system asset listed on the case
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      6/13/2014       Initial Development                                
***********************************************************************************************************************/
public class Create_New_Identifier_Asset{
    public ID CaseID{get;set;}
    public boolean assetvalidation{get;set;}
    public Create_New_Identifier_Asset(ApexPages.StandardController controller) {
        CaseID = apexpages.currentpage().getparameters().get('id');
        Case AssetCheck = [select id,AssetId from case where id=:CaseID];
        if(AssetCheck.AssetId!=null){
            assetvalidation = true;
        }else
        {
            assetvalidation = false;
        }
    }
}