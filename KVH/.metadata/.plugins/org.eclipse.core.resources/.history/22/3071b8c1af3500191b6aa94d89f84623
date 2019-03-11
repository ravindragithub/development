/***********************************************************************************************************************
 Name: add_Identifier_Product
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: 1) This is used to create new child Asset for existing case Asset.
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      13/06/2014       Initial Development                                   
***********************************************************************************************************************/
public class Add_Identifier_Product{

    public Asset newAsset{get;set;}
    public ID CaseID{get;set;}
    public Case updateParentAsset;
    public Add_Identifier_Product(){
        newAsset = new Asset();
        CaseID = apexpages.currentpage().getparameters().get('caseid');
        updateParentAsset = [select id,AccountId,AssetID,Modem_IP_2__c from Case where id=:CaseId];
    }
    
    public pageReference assetSave(){
        if(updateParentAsset.AssetID != null){
            Asset parentAsset = [select id,Parent_Asset__c from Asset where id=:updateParentAsset.AssetID];
            if(parentAsset.Parent_Asset__c != null){
                newAsset.Parent_Asset__c = parentAsset.Parent_Asset__c;
            }else{
                newAsset.Parent_Asset__c = updateParentAsset.AssetID;
            }
        }
        newAsset.AccountId = updateParentAsset.AccountID;
        insert newAsset;
        pageReference pagRef = new pageReference('/'+CaseID);
        return pagRef;
    }
}