public without sharing class HTS_ltgsvc_satrouters {
	//Top level atributes to communicate with Lightning Components
	@AuraEnabled public string statusMessage;
	@AuraEnabled public list<Asset> assetCollection;
  @AuraEnabled public map<String, String> satRouterMap;
    /* Need to return a map of <string, string> like
     *  {
     *    "obj_id":"3065",
     *    "obj_revision":"1",
     *    "serialnumber":"12345",
     *    "obj_name":"KVH:SR:12345"
     *  }
     * NOTE: obj_id & obj_revision native data type is INTEGER! type conversions required!!!
     */

  @AuraEnabled public static HTS_ltgsvc_satrouters lookupSatRouter(string serial){
    HTS_ltgsvc_satrouters returnObj = new HTS_ltgsvc_satrouters();
    Helpers help = new Helpers();
    returnObj.statusMessage = 'Status pending....';
    returnObj.satRouterMap = new map<String, String>();
    returnObj.assetCollection = new list<Asset>();

    Boolean noOSSDupes = false;
    //HTS_ltgsvc_satrouters returnFromOSS = help.getSatRouterFromOSS(serial); //TODO: create new local method to get SatRouter by serial number
    HTS_ltgsvc_satrouters returnFromOSS = getSatRouterFromOSS(null, null, null, integer.valueOf(serial), null); 
    noOSSDupes = returnFromOSS.statusMessage.startsWith('NOT FOUND:'); //sets to True if no dupes!

    Boolean noSFDCDupes = false;
    HTS_ltgsvc_satrouters returnFromSFDC = help.getSatRouterFromSFDC(serial);
    noSFDCDupes = returnFromSFDC.statusMessage.startsWith('NOT FOUND:'); //sets to True if no dupes!

    if(noOSSDupes && noSFDCDupes){ //Cool! No duplicates!
      returnObj.statusMessage = 'SUCCESS: No Duplicates Detected!';
    } else {
      returnObj.statusMessage = 'ERROR: Duplicates Detected!';
    }
    returnObj.assetCollection = returnFromSFDC.assetCollection;
    returnObj.satRouterMap = returnFromOSS.satRouterMap;
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method 
    return returnObj;
  }

  @AuraEnabled public static HTS_ltgsvc_satrouters insertSatRouter(map<string, string> cmp_values){
    HTS_ltgsvc_satrouters returnObj = new HTS_ltgsvc_satrouters();
    returnObj.statusMessage = 'Status pending....';
    returnObj.satRouterMap = new map<String, String>();
    returnObj.assetCollection = new list<Asset>();
    
    Helpers help = new Helpers();
    //HTSSF-275 check for dupes...
    returnObj = help.checkProvKeyForDupes(cmp_values.get('provisioningKey'));
    if(returnObj.statusMessage.left(6) == 'ERROR:'){
      system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
      return returnObj;
    } else {  //re-initialize returnObj....
      returnObj.statusMessage = 'Status pending....';
      returnObj.satRouterMap = new map<String, String>();
      returnObj.assetCollection = new list<Asset>();
    }
    string resultCode = help.createSatRouterInOSS(cmp_values);
    if(resultCode == '201'){ //this is good!
      //Create the two Assets, parent and Child TODO wrap in try-catch
      returnObj.assetCollection = help.createSatRouterAssetsHelper(cmp_values);  /*<--------------------*/
      system.debug('Returned from HTS_Assets Class: ' + returnObj.assetCollection);
      returnObj.statusMessage = 'SUCCESS: ' + resultCode + ' returned from OSS';
      system.debug('returnObj Class: ' + returnObj);
    } else { //this is bad...
      returnObj.statusMessage = 'ERROR: ' + resultCode + ' returned from OSS';
    }
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return returnObj;
  }
  //Local privates...
  @testVisible private static HTS_ltgsvc_satrouters getSatRouterFromOSS(string obj_name, integer max_records, String model, integer serialnumber, String chip_sn){
    HTS_ltgsvc_satrouters returnObj = new HTS_ltgsvc_satrouters();
    returnObj.satRouterMap = new map<string,string>();
    returnObj.assetCollection = new list<Asset>();
    HTSOSS_hts_satelliterouters oneSatRouter = new HTSOSS_hts_satelliterouters();
    HTSOSS_hts_satelliterouters.satelliterouters_list_wrapper sr_list = new HTSOSS_hts_satelliterouters.satelliterouters_list_wrapper();
    sr_list = oneSatRouter.getSatelliteRouters(null, null, null, serialnumber, null);
    system.debug('A list of one SatRouter: ' + sr_list);
    if(sr_list.satelliterouters_list.size() == 0){
      returnObj.satRouterMap.put('obj_id','NOT FOUND:SatRouter not found...');
      returnObj.satRouterMap.put('obj_revision','NOT FOUND:SatRouter not found...');
      returnObj.satRouterMap.put('serialnumber','NOT FOUND:SatRouter not found...');
      returnObj.satRouterMap.put('obj_name','NOT FOUND:SatRouter not found...');
      returnObj.statusMessage = 'NOT FOUND: SatRouter not found in OSS';
    } else if(sr_list.satelliterouters_list.size() > 1){
      returnObj.satRouterMap.put('obj_id','ERROR:Multiple SatRouters found. This is bad');
      returnObj.satRouterMap.put('obj_revision','ERROR:Multiple SatRouters found. This is bad');
      returnObj.satRouterMap.put('serialnumber','ERROR:Multiple SatRouters found. This is bad');
      returnObj.satRouterMap.put('obj_name','ERROR:Multiple SatRouters found. This is bad');
      returnObj.statusMessage = 'ERROR:Multiple SatRouters found. This is bad';
    } else {
      returnObj.satRouterMap.put('obj_id',String.valueOf(sr_list.satelliterouters_list[0].obj_id));              //here's that type conversion!
      returnObj.satRouterMap.put('obj_revision',String.valueOf(sr_list.satelliterouters_list[0].obj_revision));  //here's that type conversion!
      returnObj.satRouterMap.put('serialnumber',String.valueOf(sr_list.satelliterouters_list[0].serialnumber));  //here's that type conversion!
      returnObj.satRouterMap.put('obj_name',sr_list.satelliterouters_list[0].obj_name);
      returnObj.statusMessage = 'SUCCESS: Single, unique SatRouter found in OSS';
    }
    system.debug(returnObj);
    return returnObj;
  }

  //Helper Classes below....
  @testVisible private Class Helpers extends HTS_ltgsvc_shared{
    @testVisible private HTS_ltgsvc_satrouters checkProvKeyForDupes(String provKey){
      //setup returnObj
      HTS_ltgsvc_satrouters returnObj = new HTS_ltgsvc_satrouters();
      returnObj.statusMessage = 'Status pending....';
      returnObj.satRouterMap = new map<String, String>();
      returnObj.assetCollection = new list<Asset>();
      list<Asset> dupesList = new list<Asset>();
      //check Salesforce for dupes and if there are change value of returnObj.statusMessage;
      dupesList = [SELECT Id, Name, Product2.ProductCode, Product2.Name FROM Asset WHERE Name =: provKey];
      if(dupesList.size() != 0){  //There are dupes! 
        returnObj.statusMessage = 'ERROR: ' + provKey + ' is already in use!';
        returnObj.assetCollection = dupesList;
        map<String, String> returnMap = new map<String, String>();
        returnMap.put('Provisioning Key', provKey);
        returnObj.satRouterMap = returnMap;
      }
      return returnObj;
    }

    @testVisible private list<Asset> createSatRouterAssetsHelper(map <string, string> cmp_values){

      list<Asset> returnList = new list<Asset>();
      //need Account (from Custom Settings), and Product Ids (from Custom Metatdata) 
      map<String, Asset_Hierarchy_Template__mdt> hierarchyMap = HTS_assets.getHierarchyMap('19-0955');
      Asset parentAsset = HTS_assets.getAssetTemplate('Satellite_Router');
      //parentAsset.AccountId = settings.Account_ID__c;
      //parentAsset.Product2Id = productIdMap.get('Satellite_Router');
      parentAsset.SerialNumber = cmp_values.get('serialNumber');
      parentAsset.name = 'KVH-SR-' + cmp_values.get('serialNumber');
      parentAsset.Revision_No__c = cmp_values.get('revision');
      parentAsset.Asset_Id__c = parentAsset.Asset_Id__c + '_' + cmp_values.get('serialNumber'); //yuck! XP TODO: fix this assignment!
      system.debug('parentAsset: ' + parentAsset);
      insert parentAsset; //Need parent Asset Id for child
      
      Asset childAsset = HTS_assets.getAssetTemplate('iDirect_Provisioning_Key');
      childAsset.SerialNumber = cmp_values.get('provisioningKey');
      childAsset.name = cmp_values.get('provisioningKey');
      //get a clean Product Code...
      String prodCode = childAsset.Asset_Id__c.removeEnd('_US');
      system.debug(prodCode);
      //get the sequence number...
      system.debug(hierarchyMap.get(prodCode).Sequence__c);
      childAsset.Sequence_No__c = hierarchyMap.get(prodCode).Sequence__c;
      childAsset.Asset_Id__c = childAsset.Asset_Id__c + '_' + cmp_values.get('provisioningKey'); //yuck! XP TODO: fix this assignment!
      childAsset.Parent_Asset__c = parentAsset.Id;
      system.debug('childAsset: ' + childAsset);
      insert childAsset;
      
      returnList.add(parentAsset);
      returnList.add(childAsset);
      returnList = [SELECT Id, Name, Product2.ProductCode, Product2.Name, Asset_Id__c, Revision_No__c, AccountId, 
                           SerialNumber, Parent_Asset__c, Root_Asset__c, ParentId, RootAssetId, Product2Id 
                    FROM Asset WHERE Id IN :returnList];
      return returnList;
    }

    @testVisible private HTS_ltgsvc_satrouters getSatRouterFromSFDC(string SatRouter){
      //TODO: rename per HTSSF-104
      HTS_ltgsvc_satrouters returnObj = new HTS_ltgsvc_satrouters();
      returnObj.satRouterMap = new map<string,string>();
      returnObj.assetCollection = new list<Asset>();
      map<string,string> returnMap = new map<string,string>();
      returnObj.assetCollection = [SELECT Id, Name, Product2.ProductCode, Product2.Name, Asset_Id__c, 
									                        SerialNumber, Parent_Asset__c, Root_Asset__c, ParentId, RootAssetId 
                                   FROM Asset WHERE SerialNumber =: SatRouter]; //NOT Asset.Name!
      if(returnObj.assetCollection.size() == 0){
        returnObj.statusMessage = 'NOT FOUND:Asset not found...';
      } else if(returnObj.assetCollection.size() > 1){
        returnObj.statusMessage = 'ERROR:Multiple Assets found. This is bad';
      } else {
        returnObj.statusMessage = 'SUCCESS: Single, unique SatRouter found in Salesforce';
      }
      return returnObj;
    }

    @testVisible private string createSatRouterInOSS(map<string, string> cmp_values){
      string returnString = 'initializing...';
      HTSOSS_hts_satelliterouters sr1 = new HTSOSS_hts_satelliterouters();
			sr1.chip_sn = '1111111';
			sr1.model = 'X7';
			sr1.obj_name = 'KVH-SR-' + cmp_values.get('serialNumber'); 
			sr1.serialnumber = integer.valueOf(cmp_values.get('serialNumber'));
			system.debug(JSON.serialize(sr1, true));
			sr1 = sr1.postSatelliteRouter(sr1);
			system.debug(sr1.response_code);
			returnString = string.valueOf(sr1.response_code);
      return returnString;
    }
  }
}