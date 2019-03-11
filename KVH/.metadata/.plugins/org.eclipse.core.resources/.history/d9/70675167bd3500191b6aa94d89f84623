public class LTE_devices_mfg {
  //We will probably be returning an instance of this Class to the SPA
  @AuraEnabled public list<Asset> lteAssets = new list<Asset>();
  @AuraEnabled public String serverResults;

  //Need a collection (set?) of all unique part numbers so we can populate...
  @testVisible private static set<String> partNumSet = new set<String>();
  //... a map of Part Number to Product2 to use an Asset.Product2 reference
  @testVisible private static map<String, Product2> productMap = new map<String, Product2>();

  @AuraEnabled public static list<Asset_Hierarchy_Template__mdt> templateSearch(String templateRoot){
    list<Asset_Hierarchy_Template__mdt> returnList = new list<Asset_Hierarchy_Template__mdt>();
    returnList = [SELECT Product_Code__c, Root__c, Parent__c, DeveloperName, Type__c
                  FROM Asset_Hierarchy_Template__mdt
                  WHERE Root__c =: templateRoot
                  ORDER BY DeveloperName];

    return returnList;
  }
  @AuraEnabled public static LTE_devices_mfg createAssets(String objList){
    LTE_devices_mfg returnObj = new LTE_devices_mfg();
    list<AssetDetails> detailsList = (list<AssetDetails>)JSON.deserialize(objList, list<AssetDetails>.class);
    list<Asset> dupesList = checkForDupeAssets(detailsList);
    if(dupesList.size() != 0){
      returnObj.lteAssets = dupesList;
      returnObj.serverResults = 'DUPLICATES FOUND:';
      return returnObj;
    }
    populatePartNumSet(detailsList);
    populateProductMap(partNumSet);
    list<Asset> insertList = new list<Asset>();

    for(AssetDetails i :detailsList){
      insertList.add(generateOneAsset(i));
    }
    insert insertList;
    list<Asset> tempList = setupHierarchy(insertList, detailsList);
    system.debug(tempList);
    update tempList;
    returnObj.lteAssets = tempList;
    returnObj.serverResults = 'SUCCESS:';
    return returnObj;
  }
  @AuraEnabled public static String postLTEDevice(list<Asset> inputHierarchy){
    String returnString = 'INITIALIZING';
    serviceResults returnResults = Service_LTEDevices.postLTEDeviceToOSS(inputHierarchy);
    system.debug(returnResults);
    if(returnResults.success == true){
      returnString = 'SUCCESS: Successfully POSTed LTE Device to OSS!';
    } else {
      returnString = 'ERROR: Could not POST LTE Device to OSS!\n' + 
                    'Refer to Case Id: ' + returnResults.srCase.Id;
    }
    return returnString;
  }
  @testVisible private static set<String> populatePartNumSet(list<AssetDetails> assetDetailsList){
    set<String> returnSet = new set<String>();
    //populate part number set....
    for(AssetDetails i :assetDetailsList){ 
      returnSet.add(i.partNumber);
      if(i.parentPartNumber != null){
        returnSet.add(i.parentPartNumber);
      }
    }
    partNumSet = returnSet;
    return returnSet;
  }
  @testVisible private static map<String, Product2> populateProductMap(set<String> partNumSet){
    map<String, Product2> returnMap = new map<String, Product2>();
    for(Product2 p : [SELECT Id, Name, ProductCode, Product_Id__c
                      FROM Product2 
                      WHERE ProductCode IN: partNumSet AND Product_Id__c LIKE '%_US']){
      returnMap.put(p.ProductCode, p);
    }
    productMap = returnMap;
    return returnMap;
  }

  @testVisible private static Asset generateOneAsset(AssetDetails detailsList){
    Asset returnAsset = new Asset();
    //Need an Account reference for the Asset. Get it from the Custom Setting
    DefaultAccounts__c defAcct =  DefaultAccounts__c.getValues('DefaultAssets');
    returnAsset.AccountId = defAcct.Account_ID__c;
    returnAsset.Name = detailsList.Name;
    returnAsset.SerialNumber = detailsList.Name;
    returnAsset.Product2Id = productMap.get(detailsList.partNumber).Id;
    returnAsset.Asset_Id__c = productMap.get(detailsList.partNumber).Product_Id__c + '_' + detailsList.Name;
    system.debug(returnAsset);
    return returnAsset;
  }
  @testVisible private static list<Asset> setupHierarchy(list<asset> assetList, list<AssetDetails> detailsList){
    list<Asset> returnList = new list<Asset>();
    //Need a map of Part Number (using Product_Id__c) to Asset (AFTER insert... so we can upsert parent details)
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : assetList){
      assetMap.put(a.Asset_Id__c.substringBefore('_US_'), a);
    }
    //Need a map of Part Number to Asset Hierarchy Template data to figure out which assets
    //are parented by which... start with root Asset
    String rootAssetPartNum;
    for(AssetDetails a : detailsList){
      system.debug(a);
      if(a.parentPartNumber == null){
        rootAssetPartNum = a.partNumber;
      }
    }
    system.debug(rootAssetPartNum);
    list<Asset_Hierarchy_Template__mdt> hierarchyTemplate 
      = templateSearch(rootAssetPartNum);
    system.debug(hierarchyTemplate);
    map<String, Asset_Hierarchy_Template__mdt> templateMap 
      = new map<String, Asset_Hierarchy_Template__mdt>();
    for(Asset_Hierarchy_Template__mdt aht : hierarchyTemplate){
      templateMap.put(aht.Product_Code__c, aht);
    }
    system.debug(templateMap);
    for(String partNum : assetMap.keySet()){
      if(templateMap.get(partNum).Parent__c != null){ //check metadata row for parent....
        String parentPartNum = templateMap.get(partNum).Parent__c;
        assetMap.get(partNum).Parent_Asset__c = assetMap.get(parentPartNum).Id;
      }
      returnList.add(assetMap.get(partNum));
    }
    return returnList;
  }
  @testVisible private static list<Asset> checkForDupeAssets(list<AssetDetails> inputList){
    list<Asset> returnList = new list<Asset>();
    list<String> namedAssets = new list<String>();
    for(AssetDetails ad : inputList){
      namedAssets.add(ad.name);
    }
    returnList = [SELECT Id, Name FROM Asset WHERE Name IN: namedAssets];
    return returnList;
  }
  @AuraEnabled public static LTE_devices_mfg getHierarchy(String recordId){
    LTE_devices_mfg returnObj = new LTE_devices_mfg();
    //Need to get the single Asset, then the hierarchy
    list<Asset> inputAsset = [SELECT Id, Root_Asset__c FROM Asset WHERE Id =: recordId];
    if(inputAsset.size() != 1){
      returnObj.serverResults = 'COULD NOT ISOLATE INPUT ASSET!';
      returnObj.lteAssets = new list<Asset>();
      return returnObj;
    }
    if(inputAsset[0].Root_Asset__c == null){          //This IS the root asset!
      inputAsset[0].Root_Asset__c = inputAsset[0].Id; //make it it's own root for the moment...
    }
    try{
      returnObj.lteAssets = [SELECT Id, Name, Asset_ID__c, Root_Asset__c FROM Asset 
                              WHERE Root_Asset__c =: inputAsset[0].Root_Asset__c
                              OR Id =: inputAsset[0].Root_Asset__c];
      returnObj.serverResults = 'ASSET LIST RETURNED FROM SERVER';
    } catch(Exception e){
      returnObj.serverResults = 'Exception Caught: ' + e.getMessage() + ' ' + e.getStackTraceString();
      returnObj.lteAssets = new list<Asset>();
    }
    return returnObj;
  }
  // inner class These are the details returned from the UI
  public class AssetDetails{
    public String partNumber;
    public String description;
    public String parentPartNumber;
    public String name;
  }
}