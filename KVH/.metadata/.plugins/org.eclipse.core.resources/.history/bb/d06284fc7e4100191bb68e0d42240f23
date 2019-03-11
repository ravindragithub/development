public with sharing class HTS_assets {
  //Handlers for "pooled" entities
	@AuraEnabled public static Asset create_VTIDS_Asset(HTS_Virtual_Terminal_ID__c VTID){
	  //start building the Asset
	  Asset returnAsset = getAssetTemplate('Virtual_Terminal_Id');
	  returnAsset.Name = VTID.Virtual_Terminal_Id__c;
	  returnAsset.SerialNumber = VTID.Virtual_Terminal_Id__c;
	  //TODO: append Asset_Id with name??
	  returnAsset.Asset_Id__c = returnAsset.Asset_Id__c + '_' + VTID.Virtual_Terminal_Id__c;
	  return returnAsset;
	}
	@AuraEnabled public static Asset create_HTS_IP_Asset(HTS_IP_Address__c HTSip){
    //start building the Asset
	  Asset returnAsset = getAssetTemplate('HTS_IP_Address');
    returnAsset.Name = HTSip.HTS_IP_Address__c;
    returnAsset.SerialNumber = HTSip.HTS_IP_Address__c;
    //TODO: append Asset_Id with name??
    returnAsset.Asset_Id__c = returnAsset.Asset_Id__c + '_' + HTSip.HTS_IP_Address__c;
    system.debug(returnAsset);
	  return returnAsset;
	}
	
  //generic Methods (typically overloaded)
  @AuraEnabled public static Asset create_generic_Asset(string IdentifierProductName, string assetName){
    //start building the Asset
    Asset returnAsset = getAssetTemplate(IdentifierProductName);
    returnAsset.Name = assetName;
    returnAsset.SerialNumber = assetName;
    returnAsset.Asset_Id__c = returnAsset.Asset_Id__c + '_' + assetName;
    system.debug('Generic Asset Created: ' + returnAsset);
    return returnAsset;
  }
  @AuraEnabled public static Asset create_generic_Asset(Product2 productReference, string assetName){
    //start building the Asset
    Asset returnAsset = getAssetTemplate(productReference);
    returnAsset.Name = assetName;
    returnAsset.SerialNumber = assetName;
    returnAsset.Asset_Id__c = returnAsset.Asset_Id__c + '_' + assetName;
    system.debug('Generic Asset Created: ' + returnAsset);
    return returnAsset;
  }
  
  @AuraEnabled public static list<Asset_Hierarchy_Template__mdt> getHierarchyTemplate(string partNumber){
    list<Asset_Hierarchy_Template__mdt> returnList = new list<Asset_Hierarchy_Template__mdt>();
    returnList = [SELECT Parent__c, Product_Code__c, Root__c, Sequence__c FROM Asset_Hierarchy_Template__mdt WHERE Root__c =: partNumber];
    return returnList;
  }
  
  public map<string, Product2> getProduct2List(list<string> partNumbers){
    map<string, Product2> returnMap = new map<string, Product2>();
    for(Product2 p : [SELECT Id, Product_Id__c, ProductCode FROM Product2
                      WHERE ProductCode IN: partNumbers AND Product_Id__c LIKE '%_US']){
      returnMap.put(p.ProductCode, p);
    }
    return returnMap;
  }

  public static Asset getAssetTemplate(string identifierProduct){
    Asset returnAsset = new Asset();
    //Need an Account reference for the Asset. Get it from the Custom Setting
    DefaultAccounts__c defAcct =  DefaultAccounts__c.getValues('DefaultAssets');
    //Need a Product2 reference for the Asset. Get it from the Custom Metadata Type
    Default_Identifier_Product__mdt VTIDproduct = [SELECT Identifier_Product_reference__c, Legacy_Product_Id__c
                                                    FROM Default_Identifier_Product__mdt 
                                                    WHERE DeveloperName =: identifierProduct];
    //returnAsset.AccountId = defaultAssetAccount.Id;
    returnAsset.AccountId = defAcct.Account_ID__c;
    returnAsset.Product2Id = VTIDproduct.Identifier_Product_reference__c;
    returnAsset.Asset_Id__c = VTIDproduct.Legacy_Product_Id__c;
    return returnAsset;
  }
  public static Asset getAssetTemplate(Product2 productReference){
    Asset returnAsset = new Asset();
    //Need an Account reference for the Asset. Get it from the Custom Setting
    DefaultAccounts__c defAcct =  DefaultAccounts__c.getValues('DefaultAssets');
    returnAsset.AccountId = defAcct.Account_ID__c;
    returnAsset.Product2Id = productReference.Id;
    returnAsset.Asset_Id__c = productReference.Product_Id__c;
    return returnAsset;
  }
  public static map<String, Asset_Hierarchy_Template__mdt> getHierarchyMap(String partNumber){
    //Returns a Map of Product Code to Asset Hierarchy Template Row
    map<String, Asset_Hierarchy_Template__mdt> returnMap = new map<String, Asset_Hierarchy_Template__mdt>();
    for(Asset_Hierarchy_Template__mdt h : [SELECT Parent__c, Product_Code__c, Root__c, Sequence__c FROM Asset_Hierarchy_Template__mdt WHERE Root__c =: partNumber]){
      returnMap.put(h.Product_Code__c, h);
    }
    return returnMap;
  }
}