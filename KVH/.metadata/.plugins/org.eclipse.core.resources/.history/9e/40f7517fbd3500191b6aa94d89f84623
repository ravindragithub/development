/***********************************************************************************************************************
 Name: UtilClassCreatingNewAsset(Utitlity Class for CreatingNewAsset)
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
   1.1     Gopi Kishore. K      10/09/2014       Changes Done for creating new Asset for global static IP     
***********************************************************************************************************************/

public Class UtilClassCreatingNewAsset{
    //Static Method used while Creating New Asset.
    public Static void ExecuteAssetCreation(List<Private_Static_IP__c> assetCreation){
        SET<ID> AssetIds = NEW SET<ID>();
        List<Asset> NewAsssets = new List<Asset>();
        
        for(Private_Static_IP__c PSI:assetCreation){
           if(PSI.Install_Config__c!=null){
               AssetIds.add(PSI.AssetID__c);
           }
        }
        
        MAP<ID,ID> multipleAssetIds = AssetStructure.GetTopMultipleElements(AssetIds);
        for(Private_Static_IP__c PSI:assetCreation){
            if(multipleAssetIds.containsKey(PSI.AssetID__c)){
                Asset newAsset           = New Asset();
                newAsset.Name            = PSI.Name;
                if(PSI.Static_IP_Type__c == 'VSAT Static IP'){
                    newAsset.Product2ID      = system.label.CreatingNewAssetProduct2ID;
                }else
                if(PSI.Static_IP_Type__c == 'Global Static IP'){
                    newAsset.Product2ID      = system.label.CreatingNewAssetProduct2ID_GlobalStaticIP;
                }
                
                newAsset.InstallDate     = System.Today();
                newAsset.Parent_Asset__c = multipleAssetIds.get(PSI.AssetID__c);
                NewAsssets.add(newAsset);
            }
        } 
        insert NewAsssets;
    }
}