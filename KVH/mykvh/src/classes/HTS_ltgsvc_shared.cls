/**
 * See https://github.com/financialforcedev/fflib-apex-common for more info
 *
 * Install library via
 *   https://githubsfdeploy.herokuapp.com/app/githubdeploy/financialforcedev/fflib-apex-common
 */

/**
 * Encapsulates all service layer logic for a given function or module in the application
 * 
 * For more guidelines and details see 
 *   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Service_Layer
 *
 **/
public virtual class HTS_ltgsvc_shared{

  public map<string,string> getTerminalFromOSS(string VTID){
    map<string,string> returnMap = new map<string,string>();
    HTSOSS_hts_terminals oneTerminal = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals.terminals_list_wrapper terminalList = new HTSOSS_hts_terminals.terminals_list_wrapper();
    terminalList = oneTerminal.getTerminals(null, VTID);
    //system.assertEquals(1, terminalList.terminals_list.size(), 'More than one Satellite Router with the same name!!');
    system.debug('A list of one Terminal: ' + terminalList);
    if(terminalList.terminals_list.size() == 0){
      returnMap.put('obj_id','ERROR:Terminal not found...');
      returnMap.put('obj_revision','ERROR:Terminal not found...');
    } else if(terminalList.terminals_list.size() > 1){
      returnMap.put('obj_id','ERROR:Multiple Terminals found. This is bad');
      returnMap.put('obj_revision','ERROR:Multiple Terminals found. This is bad');
    } else {
      returnMap.put('obj_id',String.valueOf(terminalList.terminals_list[0].obj_id));              //here's that type conversion!
      returnMap.put('obj_revision',String.valueOf(terminalList.terminals_list[0].obj_revision));  //here's that type conversion!
    }
    return returnMap;
  }
  public HTS_ltgsvc_satrouters getSatRouterFromOSS(string serialNumber){
    //TODO: migrate to HTS_ltgsvc_shared - DONE
    HTS_ltgsvc_satrouters returnObj = new HTS_ltgsvc_satrouters();
    returnObj.satRouterMap = new map<string,string>();
    returnObj.assetCollection = new list<Asset>();
    HTSOSS_hts_satelliterouters oneSatRouter = new HTSOSS_hts_satelliterouters();
    HTSOSS_hts_satelliterouters.satelliterouters_list_wrapper sr_list = new HTSOSS_hts_satelliterouters.satelliterouters_list_wrapper();
    sr_list = oneSatRouter.getSatelliteRouters(serialNumber);
    //system.assertEquals(1, terminalList.terminals_list.size(), 'More than one Satellite Router with the same name!!');
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

  @AuraEnabled public static HTSOSS_hts_terminals createTerminalFromAssets(list<Asset> assetList){
    HTSOSS_hts_terminals returnTerm = new HTSOSS_hts_terminals();
    //Need a 19-0955, a Virtual Terminal ID, and a HTS IP Address
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : assetList){
      if(a.Product2.ProductCode != null){
        assetMap.put(a.Product2.ProductCode, a);
      } else {
        returnTerm.message = 'ERROR: Input Assets must have Product2.ProductCode populated';
        returnTerm.response_code = 400;
        return returnTerm;
      }
    }
    if(assetMap.get('19-0955') == null){
      returnTerm.message = 'ERROR: iDirect Modem part number 19-0955 required';
      returnTerm.response_code = 400;
      return returnTerm;
    }
    if(assetMap.get('19-0955').SerialNumber == null){
      returnTerm.message = 'ERROR: iDirect Modem 19-0955 requires Serial Number field to be populated';
      returnTerm.response_code = 400;
      return returnTerm;
    }
    if(assetMap.get('Virtual Terminal ID') == null){
      returnTerm.message = 'ERROR: Virtual Terminal Id required';
      returnTerm.response_code = 400;
      return returnTerm;
    }
    if(assetMap.get('HTS IP Address') == null){
      returnTerm.message = 'ERROR: HTS IP Address required';
      returnTerm.response_code = 400;
      return returnTerm;
    }

    HTS_ltgsvc_satrouters returnedCore = getCoreModuleFromOSS(assetMap.get('19-0955').SerialNumber);
    if(! returnedCore.statusMessage.contains('SUCCESS:')){  //couldn't get Core Module Id, fatal error
      returnTerm.message = returnedCore.statusMessage;
      returnTerm.response_code = 400;
      return returnTerm;
    }
    returnTerm.coremodule_id = Integer.valueOf(returnedCore.satRouterMap.get('obj_id'));

    list<HTS_Terminal_Type__mdt> termTypes = [SELECT terminal_type_id__c FROM HTS_Terminal_Type__mdt WHERE is_default__c = true LIMIT 1];
    returnTerm.terminaltype_id = (Integer)termTypes[0].terminal_type_id__c;
    returnTerm.terminal_id = assetMap.get('Virtual Terminal ID').Name;
    //Deal with the IPs
    String svcIP = assetMap.get('HTS IP Address').Name;
    returnTerm.terminal_ip_address = svcIP + '/24';
    //need mgmt IP...
    list<String> inputList = new list<String>();
    inputList.add(svcIP);
    map<String, String> mgmtIPMap = getMgmtIPs(inputList);
    returnTerm.mgmtipaddress = mgmtIPMap.get(svcIP);
    //need Default Terminal Template
    returnTerm.template_id = getDefaultTerminalTemplate();
    return returnTerm;
  }


  public static String getDefaultTerminalTemplate(){
    list<HTS_Terminal_Template__c> templateList = [SELECT Name, obj_id__c FROM HTS_Terminal_Template__c WHERE isDefault__c = true];
    //system.assertEquals(1, templateList.size());
    return templateList[0].obj_id__c;
  }
  public static HTS_ltgsvc_satrouters getCoreModuleFromOSS(string serialNumber){
    HTS_ltgsvc_shared helper = new HTS_ltgsvc_shared();
    return helper.getSatRouterFromOSS(serialNumber);
  }
  public static map<String, String> getMgmtIPs (list<String> HTSIPs){
    map<String, String> returnMap = new map<String, String>();
    for(HTS_IP_Address__c ip : [SELECT HTS_IP_Address__c, Management_IP_Address__c 
                                FROM HTS_IP_Address__c
                                WHERE HTS_IP_Address__c IN: HTSIPs]){
      returnMap.put(ip.HTS_IP_Address__c, ip.Management_IP_Address__c);
    }
    return returnMap;
  }
  public static Integer getDefaultTerminalTypeId(){
    list<HTS_Terminal_Type__mdt> termTypes = [SELECT terminal_type_id__c FROM HTS_Terminal_Type__mdt WHERE is_default__c = true LIMIT 1];
    return (Integer)termTypes[0].terminal_type_id__c;
  }
}