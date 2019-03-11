public with sharing class HTS_ltgsvc_terminals {
  //Top level attributes to communicate with Lightning Components
  @AuraEnabled public string statusMessage;
  @AuraEnabled public list<Asset> assetCollection;

  @AuraEnabled public static HTS_ltgsvc_terminals provisionForTest(list<Asset> assetList, Boolean synchronous){
    HTS_ltgsvc_terminals returnClass = new HTS_ltgsvc_terminals();
    Helpers help = new Helpers();
    //Start from a map of Assets....
    System.debug(assetList);
    
    for (Asset a: assetList){
      //HTSSF-206 verify that the Asset_Id__c field is correct before proceeding....
      if(a.Asset_Id__c == null || a.Asset_Id__c == ''){  //This is a problem!
        returnClass.statusMessage = 'EXCEPTION: Asset_Id__c field is empty for: ' + a.Name;
        returnClass.assetCollection = new list<Asset>();
        return returnClass;   //bail out of loop immediately
      }
    } //All Assets check out OK!
       //This maps KVH Part Number (ProductCode) to Asset Object
    map<String, Asset> assetMap = help.buildAssetMap(assetList);
    system.debug(assetMap);
    //
    //Begin building 6 POST attributes in a map, including....
    /*{
        "coremodule_id": 0,
        "terminal_ip_address": "string",
        "mgmtipaddress": "string",
        "template_id": "string",
        "terminal_id": "string",
        "terminaltype_id": 0
    }*/
    //Setup and populate attributeMap
    map<String, String> attributeMap = new map<String, String>();
    // #1 Core Module Id... Need to convert to strings before adding to map
    //Integer CoreModuleId = help.getCoreModuleId(assetMap.get('19-0955').SerialNumber);  //TODO: migrate to static method
    HTS_ltgsvc_satrouters CoreModule = HTS_ltgsvc_shared.getCoreModuleFromOSS(assetMap.get('19-0955').SerialNumber); //Migrated to static method...
    attributeMap.put('coremodule_id', String.valueOf(CoreModule.satRouterMap.get('obj_id')));    //Will need to convert back to Int
    // #2, Terminal IP Address
    String  terminal_ip_address = assetMap.get('HTS IP Address').Name;
    attributeMap.put('terminal_ip_address', terminal_ip_address + '/24');
    // #3, management IP
    list<HTS_IP_Address__c> ipList = [SELECT Management_IP_Address__c FROM HTS_IP_Address__c WHERE HTS_IP_Address__c =: terminal_ip_address LIMIT 1];
    String  mgmtipaddress = ipList[0].Management_IP_Address__c; 
    attributeMap.put('mgmtipaddress', mgmtipaddress);
    // #4 Default Template Id
    //attributeMap.put('template_id', help.getDefaultTerminalTemplate());
    attributeMap.put('template_id', HTS_ltgsvc_shared.getDefaultTerminalTemplate()); //Migrated to static method...
    // #5 Terminal Id
    //attributeMap.put('terminal_id', assetMap.get('Virtual Terminal ID').Name);
    attributeMap.put('terminal_id', assetMap.get('Virtual Terminal ID').Name);
    // #6 Default Terminal Type Id
    Integer TerminalType = HTS_ltgsvc_shared.getDefaultTerminalTypeId();  //Migrated to static method...
    attributeMap.put('terminaltype_id', String.valueOf(TerminalType));  //Will need to convert back to Int
    // attributeMap setup complete
    system.debug(attributeMap);

    //Handle Asynch branching here...
    if(synchronous){
      returnClass = help.postTerminalSynchronous(attributeMap);
      system.debug('Returning from help.postTerminalSynchronous: ' + returnClass);
      if(returnClass.statusMessage.left(10) == 'EXCEPTION:'){
        system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
        return returnClass;
      }
    } else {
      returnClass = help.postTerminalasynchronous(attributeMap);
      system.debug('Returning from help.postTerminalasynchronous: ' + returnClass);
      if(returnClass.statusMessage.left(10) == 'EXCEPTION:'){
        system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
        return returnClass;
      }
    }

    //If we get this far, we successfully POSTed a Terminal... pressing on!
    //Setup Subscriber
    HTSOSS_hts_subscribers sub1 = new HTSOSS_hts_subscribers();
    sub1.subscriber_id = assetMap.get('Virtual Terminal ID').Name + '-00';
    list<String> sub_IP = new list<String>();
    sub_IP.add(terminal_ip_address + '/24');
    sub1.subscriber_ip_addresses = sub_IP;
    sub1.subscriber_plan_id = 'Enabled';    //TODO: replace with sObject lookup....
    //This is where we post
    //try
    sub1 = sub1.postSubscriber(sub1);
    if(sub1.response_code != 201){     //POST Successful??
      returnClass.statusMessage = 'EXCEPTION: Response Code: ' + sub1.response_code + ' Message: ' + sub1.message;
      returnClass.assetCollection = new list<Asset>();
      system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
      return returnClass;
    }
    //We got here, so both POSTs must have been successful!
    returnClass.statusMessage = 'SUCCESS: OSS returned ' + sub1.response_code;
    returnClass.assetCollection = new list<Asset>();
    //call assetList refresh method here...
    returnClass.assetCollection = help.refreshAssetList(assetList);
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return returnClass;
  }

  @AuraEnabled public static HTS_ltgsvc_terminals createTerminal(map<string, string> mfgSerialNumbers){
    system.debug(mfgSerialNumbers);
    HTS_ltgsvc_terminals returnClass = new HTS_ltgsvc_terminals();
    returnClass.statusMessage = 'Returning from method';
    returnClass.assetCollection = new list<Asset>();
    Helpers help = new Helpers();
    returnClass = help.handleSatRouter(mfgSerialNumbers.get('satRouter'));
    If(returnClass.assetCollection.size() != 1 || returnClass.statusMessage.left(6) == 'ERROR:'){
      return returnClass;
    }
    system.debug(returnClass.assetCollection[0]);
    Asset satRouter = returnClass.assetCollection[0];  //Create the SatRouter Asset to pass into the helper method
    returnClass.assetCollection.clear();        //Clear out the list of Assets
    mfgSerialNumbers.remove('satRouter');    //Remove the SatRouter serial number from the map
    returnClass = help.handleI2CM(mfgSerialNumbers, satRouter);  //Here's where we do the heavy lifting!
    System.debug('Return Class: ' + returnClass);
    return returnClass;
  }

  @AuraEnabled public static HTS_ltgsvc_terminals lookupAssets(list<String> searchList){
    //input a list of Assets Names (even one!) and it returns a List of Assets
    HTS_ltgsvc_terminals returnClass = new HTS_ltgsvc_terminals();
    returnClass.statusMessage = 'Returning from method';
    returnClass.assetCollection = new list<Asset>();
    returnClass.assetCollection = [SELECT Id, Name, Product2.ProductCode, Product2.Name, Asset_Id__c, 
                  SerialNumber, Parent_Asset__c, Root_Asset__c, ParentId, AccountId, RootAssetId 
                  FROM Asset WHERE Name IN: searchList];
    returnClass.statusMessage = 'SUCCESS: Returning ' + returnClass.assetCollection.size() + ' Assets';
    return returnClass;
  }
  @AuraEnabled public static HTS_ltgsvc_terminals findSatRouterBySerial(String searchSerialNum){
    //input a string and it returns a List of Assets with matching serial numbers (not names)
    HTS_ltgsvc_terminals returnClass = new HTS_ltgsvc_terminals();
    returnClass.statusMessage = 'Returning from method';
    returnClass.assetCollection = new list<Asset>();
    returnClass.assetCollection = [SELECT Id, Name, Product2.ProductCode, Product2.Name, Asset_Id__c, 
                  SerialNumber, Parent_Asset__c, Root_Asset__c, ParentId, RootAssetId 
                  FROM Asset 
                  WHERE SerialNumber =: searchSerialNum AND Product2.ProductCode = '19-0955'];
    returnClass.statusMessage = 'SUCCESS: Returning ' + returnClass.assetCollection.size() + ' Assets';
    return returnClass;
  }
  /*
   *
   *Helper Inner Class
   *
   */
  @testVisible private Class Helpers extends HTS_ltgsvc_shared{
    @testVisible private list<Asset> refreshAssetList(list<Asset> listToRefresh){
      list<Asset> returnList = new list<Asset>();
      if(listToRefresh.size() != 0){
        map<Id, Asset> assetMap = new map<Id, Asset>(listToRefresh);
        set<Id> assetSet = assetMap.keySet();
        returnList = [SELECT Name, Product2.ProductCode, Product2.Description, SerialNumber, 
                             AccountId, Parent_Asset__c, ParentId, Product2Id, Product2.Name
                      FROM Asset WHERE Id IN :assetSet];
      }
      return returnList;
    }
    @testVisible private HTS_ltgsvc_terminals postTerminalSynchronous(map<String, String> attributeMap){
      HTS_ltgsvc_terminals returnObj = new HTS_ltgsvc_terminals();

      HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
      //try
      term1.coremodule_id = integer.valueOf(attributeMap.get('coremodule_id'));
      term1.mgmtipaddress = attributeMap.get('mgmtipaddress');
      term1.template_id = attributeMap.get('template_id');
      term1.terminal_id = attributeMap.get('terminal_id');
      term1.terminal_ip_address = attributeMap.get('terminal_ip_address');  
      term1.terminaltype_id = integer.valueOf(attributeMap.get('terminaltype_id'));  
      system.debug(term1);

      //This is where we POST Terminal
      //try
      term1 = term1.postTerminal(term1);

      if(term1.response_code != 201){   //POST successful??
        returnObj.statusMessage = 'EXCEPTION: Response Code: ' + term1.response_code + ' Message: ' + term1.message;
        returnObj.assetCollection = new list<Asset>();
      } else {
        returnObj.statusMessage = 'SUCCESS: Response Code: ' + term1.response_code + ' returned from OSS. Terminal successfully created!';
        returnObj.assetCollection = new list<Asset>();
      }
      return returnObj;
    }
  @testVisible private HTS_ltgsvc_terminals postTerminalAsynchronous(map<String,String> attributeMap){
      HTS_ltgsvc_terminals returnObj = new HTS_ltgsvc_terminals();

      HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
      //try
      term1.coremodule_id = integer.valueOf(attributeMap.get('coremodule_id'));
      term1.mgmtipaddress = attributeMap.get('mgmtipaddress');
      term1.template_id = attributeMap.get('template_id');
      term1.terminal_id = attributeMap.get('terminal_id');
      term1.terminal_ip_address = attributeMap.get('terminal_ip_address');  
      term1.terminaltype_id = integer.valueOf(attributeMap.get('terminaltype_id'));  
      system.debug(term1);

      //This is where we POST Terminal
      //try
      term1 = term1.postTerminalAsynch(term1);

      if(term1.response_code != 200){   //POST successful??
        returnObj.statusMessage = 'EXCEPTION: Response Code: ' + term1.response_code + ' Message: ' + term1.message;
        returnObj.assetCollection = new list<Asset>();
      } else {
        returnObj.statusMessage = 'SUCCESS: Response Code: ' + term1.response_code + ' returned from OSS. Terminal successfully created!';
        returnObj.assetCollection = new list<Asset>();
      }
      return returnObj;
  }

    @testVisible private integer getCoreModuleId(string satRouter){
      integer returnInt = 0;
      HTS_ltgsvc_satrouters coreModule = getSatRouterFromOSS(satRouter);
      if(coreModule.statusMessage.left(8) == 'SUCCESS:'){
        returnInt = Integer.valueOf(coreModule.satRouterMap.get('obj_id'));
      } else {
        returnInt = -1;
      }
      return returnInt;
    }
    @testVisible private map<String, Asset> buildAssetMap(list<Asset> assetList){
      //Start from a map of Assets....
      System.debug(assetList);
      map<String, Asset> assetMap = new map<String, Asset>();   //This maps KVH Part Number (ProductCode) to Asset Object
      for (Asset a: assetList){
        string prodId = a.Asset_Id__c.substringBefore('_US_');
        assetMap.put(prodId, a);
      }
      system.debug(assetMap);
      return assetMap;
    }
    @testVisible private integer getTerminalType(){
      HTSOSS_hts_collections util = new HTSOSS_hts_collections();
      //Try
      HTSOSS_hts_collections.rtp s = util.getRtp();
      system.debug(s);
      integer returnInt = s.terminal_types[0].obj_id;
      return returnInt;
    }

    /*@testVisible private string getDefaultTerminalTemplate(){
      list<HTS_Terminal_Template__c> templateList = [SELECT Name, obj_id__c FROM HTS_Terminal_Template__c WHERE isDefault__c = true];
      system.assertEquals(1, templateList.size());
      return templateList[0].obj_id__c;
    }*/

    @testVisible private HTS_ltgsvc_terminals handleSatRouter(string satRouterSerNum){
      HTS_ltgsvc_terminals returnClass = new HTS_ltgsvc_terminals();
      returnClass.statusMessage = 'Returning from method';
      returnClass.assetCollection = new list<Asset>();
      HTS_ltgsvc_terminals satRouters = findSatRouterBySerial(satRouterSerNum);
      if(satRouters.assetCollection.size() == 1){
        if(satRouters.assetCollection[0].Parent_Asset__c != null){ //no parent per custom Hierarchy
          returnClass.statusMessage = 'ERROR: Satellite Router already used in system: ' + satRouters.assetCollection[0].Parent_Asset__c;
        } else {
          returnClass.assetCollection.add(satRouters.assetCollection[0]);
          returnClass.statusMessage = 'SUCCESS: Successfully found Satellite Router!';
        }
      } else if (satRouters.assetCollection.size() == 0){
        returnClass.statusMessage = 'ERROR: Satellite Router not found, Please create Satellite Router first!';
      } else {
        returnClass.statusMessage = 'ERROR: Multiple Satellite Routers with serial number ' + satRouterSerNum + ' found! This is bad!';
      }
      return returnClass;
    }

    @testVisible private HTS_ltgsvc_terminals handleI2CM(map<string, string> mfgSerialNumbers, Asset satRouter){
      //NOTE: the SatRouter has already been removed from map... Asset already exists typically!
      //NOTE: MTA Assets ALSO typically exist already! Need to "claim" them.
      HTS_ltgsvc_terminals returnClass = new HTS_ltgsvc_terminals();
      returnClass.statusMessage = 'Returning from method';
      returnClass.assetCollection = new list<Asset>();
      //Check for existing Assets
      HTS_ltgsvc_terminals existingAssets = lookupAssets(mfgSerialNumbers.values());

      list<Asset> childAssets = new list<Asset>(); //These are the child Assets of the hierarchy we are building...

      //check for ONE Asset and is it an MTA??
      if(existingAssets.assetCollection.size() == 1 && existingAssets.assetCollection[0].Product2.ProductCode == '19-0504'){
        system.debug('Found an MTA! ' + existingAssets.assetCollection[0]);
        Asset mtaCandidate = existingAssets.assetCollection[0];
        //Check that Asset has no parent and is in Default Account
        //Need an Account reference for the Asset. Get it from the Custom Setting
        DefaultAccounts__c defAcct =  DefaultAccounts__c.getValues('DefaultAssets');
        system.debug('Custom Setting: ' + defAcct.Account_ID__c);
        system.debug('mtaCandidate.AccountId: ' + mtaCandidate.AccountId);
        system.debug('mtaCandidate.Parent_Asset__c: ' + mtaCandidate.Parent_Asset__c);
        if(mtaCandidate.AccountId == (Id)defAcct.Account_ID__c && mtaCandidate.Parent_Asset__c == null){ //MTA available!
          system.debug('MTA can be claimed!! ' + mtaCandidate);
          //Add existing "claimable" MTA to child Assets list and remove MTA from mfgSerialNumbers map...
          childAssets.add(mtaCandidate);
          mfgSerialNumbers.remove('MTAMAC');
          system.debug(mfgSerialNumbers);
        } else {  //MTA in use!
          returnClass.assetCollection = existingAssets.assetCollection;
          returnClass.statusMessage = 'ERROR: Duplicates detected, MTA in use!';
          System.debug(returnClass.assetCollection);
          return returnClass;
        }
      } else if(existingAssets.assetCollection.size() != 0){
        returnClass.assetCollection = existingAssets.assetCollection;
        returnClass.statusMessage = 'ERROR: Duplicates detected!';
        System.debug(returnClass.assetCollection);
        return returnClass;
      }
      //create list of Part Numbers from Hierarchy template...
      list<Asset_Hierarchy_Template__mdt> hierarchyTemplate = HTS_assets.getHierarchyTemplate('02-2204-02');
      list<String> partNums = new list<String>();
      for(Asset_Hierarchy_Template__mdt a : hierarchyTemplate){
        partNums.add(a.Product_Code__c);
      }
      system.debug('partNums: ' + partNums);
      HTS_assets util = new HTS_Assets();
      map<String, Product2> productMap = util.getProduct2List(partNums);
      system.debug('productMap: ' + productMap);
      //Insert topAsset
      Asset topAsset = HTS_assets.create_generic_Asset(productMap.get('02-2204-02'), mfgSerialNumbers.get('systemSerialNumber'));
      system.debug('Created Top Asset: ' + topAsset);
      Insert topAsset;
      //Add *EXISTING* satRouter to childAsset list declared earlier....
      childAssets.add(satRouter);
      //Create IP and VTID Assets as children
      childAssets.add(handleHTSIp());
      childAssets.add(handleVTID());
      //Create all others as children
      childAssets.addAll(handleI2CMChildren(mfgSerialNumbers, productMap));
      for(Asset a : childAssets){  //re-parent all child Assets...
        a.Parent_Asset__c = topAsset.Id;
        a.ParentId = topAsset.Id;
      }
      upsert childAssets;
      //updated "pooled" identifiers...Need to add Asset Ids
      returnClass.assetCollection.add(topAsset);
      returnClass.assetCollection.addAll(childAssets);
      returnClass.statusMessage = 'SUCCESS: Successfully created Asset Hierarchy';
      return returnClass;
    }

    @testVisible private list<Asset> handleI2CMChildren(map<string, string> childParNums, map<string, Product2> productMap){
      system.debug(childParNums);
      list<Asset> returnList = new list<Asset>();
      if(childParNums.get('swSerialNumber') != null){
        returnList.add(HTS_assets.create_generic_Asset(productMap.get('CBX LICENSE'), childParNums.get('swSerialNumber')));
      }
      if(childParNums.get('adminIP') != null){
        returnList.add(HTS_assets.create_generic_Asset(productMap.get('ADMIN IP'), childParNums.get('adminIP')));
      }
      if(childParNums.get('MTAMAC') != null){
        returnList.add(HTS_assets.create_generic_Asset(productMap.get('19-0504'), childParNums.get('MTAMAC')));
      }
      //VTID and HTS IP Handled a little differently....
      return returnList;
    }

    @testVisible private Asset handleVTID(){
      HTS_virtual_terminal_ids HTS_VTID_util = new HTS_virtual_terminal_ids();
      HTS_Virtual_Terminal_ID__c nextAvailableVTID = HTS_VTID_util.getNextAvailableVTID();
      Asset vtidAsset = HTS_Assets.create_VTIDS_Asset(nextAvailableVTID);
      nextAvailableVTID.Date_Issued__c = DateTime.Now().dateGMT();
      update nextAvailableVTID;
      return vtidAsset;
    }

    @testVisible private Asset handleHTSIp(){
      HTS_ip_addresses HTS_IP_util = new HTS_ip_addresses();
      HTS_IP_Address__c nextAvailableIP = HTS_IP_util.getNextAvailableAddress();
      Asset htsIpAsset = HTS_Assets.create_HTS_IP_Asset(nextAvailableIP);
      nextAvailableIP.Date_Issued__c = DateTime.Now().dateGMT();
      update nextAvailableIP;
      return htsIpAsset;
    }
  }
}