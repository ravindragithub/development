public class Service_I2CMAssignIdentifers {
  //Some of the common elements will migrate into Service_base
  public static serviceResults log {get; private set;}
  public static list<Asset> upsertList {get; private set;}
  public static HTS_Virtual_Terminal_ID__c claimedVTID {get; private set;}
  public static HTS_IP_Address__c claimedHTSIP {get; private set;}
  public Service_I2CMAssignIdentifers() {
    
  }
  static {
    log = new serviceResults();
    log.success = true;       //optimistic initialization....
    log.message = DateTime.now() + '\t' + 'SERVICE_INITIALIZATION\t' + 'Initializing I2CM Identifier Assignment Service';
    upsertList = new list<Asset>();
    HTS_Virtual_Terminal_ID__c claimedVTID = new HTS_Virtual_Terminal_ID__c();
    HTS_IP_Address__c claimedHTSIP = new HTS_IP_Address__c();
  }
  public static serviceResults getLog(){
    return log;
  }
  //Main Method
  public static serviceResults assignIdentifiers(Asset I2CM){
    log.appendLog('METHOD_ENTRY', 'assignIdentifiers(Asset I2CM)|Adding I2CM Identifiers for I2CM: ' + I2CM);
    preProcessValidation(I2CM);
    if(log.success == false){ return returnFatalError(); }
    Asset cleanI2CM = assetAnalysis(I2CM);
    if(log.success == false){ return returnFatalError(); }
    map<String, Asset> hierarchyMap = assetHierarchyAnalysis(cleanI2CM);
    if(log.success == false){ return returnFatalError(); }
    hierarchyMap.put('Virtual Terminal ID', getVirtualTerminalId(cleanI2CM));
    if(log.success == false){ return returnFatalError(); }
    hierarchyMap.put('HTS IP Address', getHTSIp(cleanI2CM));
    if(log.success == false){ return returnFatalError(); }
    list<Asset> upsertList = hierarchyMap.values();
    //go from hierarchy map<Part Number, Asset> to Attribute Map <key, value(as String)
    map<String, String> attributeMap = buildAttributeMap(hierarchyMap);
    if(log.success == false){ return returnFatalError(); }
    //go from attributeMap to HTSOSS_hts_terminal_asynch
    HTSOSS_hts_terminals_asynch termToPost = buildAsynchTerminal(attributeMap);
    if(log.success == false){ return returnFatalError(); }
    //Then POST away!
    HTSOSS_hts_terminals_asynch postedTerm = postTerminalAsynch(termToPost);
    if(log.success == false){ return returnFatalError(); }
    //Now POST a subscriber based on the posted Term....
    HTSOSS_hts_subscribers returnedSub = postDefaultSubscriber(postedTerm);
    if(log.success == false){ return returnFatalError(); }
    //If we got here, everything is OK!
    log.appendLog('METHOD_EXIT', 'assignIdentifiers(Asset I2CM)|I2CM Identifiers assigned Terminal Id: ' + postedTerm.terminal_id + ' HTS IP Address: ' + returnedSub.subscriber_ip_addresses);
    if (log.success){
      log.appendLog('INFO', 'terminateHybrid(list<SBQQ__Subscription__c> subsList)|Consumed ' + Limits.getQueries() + ' SOQL queries.');
      log.appendLog('SERVICE_FINISHED', 'SUCCESS: I2CM Identifier Assignment Service completed!');
    } else {
      return returnFatalError();
    }
    //Make DML updates just before return!
    update claimedVTID;
    update claimedHTSIP;
    upsert upsertList;
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return log;
  } //PHEW!

  @testVisible private static serviceResults returnFatalError(){
    //TODO: open a case!!
    if(log.srCase == null){
      Exception ex = new NoDataFoundException();  //Create, but do not throw an exception as an input to the method
      ex.setMessage('Fatal Error in Service_I2CMAssignIdentifers Class');
      log.createCase(ex);
    }
    log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
    insert log.srCase;
    log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
    log.appendLog('SERVICE_FINISHED', 'ERROR: I2CM Identifier Assignment Service failed to complete successfully. See log for details.');
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return log;
  }
  @testVisible private static void preProcessValidation(Asset I2CM){
    //This method is to contain the validation steps required prior to entery into the process
    log.appendLog('METHOD_ENTRY', 'preProcessValidation(Asset I2CM)|Validating input parameter for I2CM: ' + I2CM.Name);
    //Asset must in database
    if(I2CM.Id == null){
      log.appendLog('METHOD_EXIT', 'preProcessValidation(Asset I2CM)|Invalid Input');
      log.appendLog('FATAL_ERROR', 'Null Asset Record Id detected!');
      log.success = false;
      return;
    } else {
      log.appendLog('METHOD_EXIT', 'preProcessValidation(Asset I2CM)|Input OK');
    }
  }
  @testVisible private static Asset assetAnalysis(Asset I2CM){
    log.appendLog('METHOD_ENTRY', 'assetAnalysis(Asset I2CM)|Validating Asset details for I2CM: ' + I2CM.Name);
    Asset returnAsset = new Asset();
    list<Asset> readList = [SELECT Id, Name, Product2.ProductCode, Parent_Asset__c, 
                              Parent_Asset__r.Product2.ProductCode, AccountId
                            FROM Asset WHERE Id =: I2CM.Id];
    If(readList.size() == 0){
      log.appendLog('METHOD_EXIT', 'assetAnalysis(Asset I2CM)|Zero rows returned from Query');
      log.appendLog('FATAL_ERROR', 'Could not obtain Asset record from database');
      log.success = false;
      return returnAsset;
    } else if(readList.size() > 1){ //difficult to test...
      log.appendLog('METHOD_EXIT', 'assetAnalysis(Asset I2CM)|Multiple rows returned from Query');
      log.appendLog('FATAL_ERROR', 'Duplicate Assets found in database');
      log.success = false;
      return returnAsset;
    }
    returnAsset = readList[0];
    String baseProductCode = '02-2204';                                         //I2CM family... could probably read from CMT
    Pattern regex = Pattern.compile('[UuSs]?' + baseProductCode + '-0[123]');   //handle "U" and "S" parts
    Matcher ma = regex.matcher(returnAsset.Product2.ProductCode);               //compare input Asset ProductCode to regex
    if(!ma.matches()){                  //not a match, fatal error... not an I2CM...
      log.appendLog('METHOD_EXIT', 'assetAnalysis(Asset I2CM)|' + returnAsset.Name + ' is not an I2CM: ' + returnAsset.Product2.ProductCode);
      log.appendLog('FATAL_ERROR', 'Identifiers can only be assigned to I2CMs');
      log.success = false;
      return returnAsset;
    }
    log.appendLog('METHOD_EXIT', 'assetAnalysis(Asset I2CM)|Returing Asset: ' + returnAsset.Name + ' Ready for further processing');
    return returnAsset;
  }
  @testVisible private static map<String, Asset> assetHierarchyAnalysis(Asset I2CM){
    log.appendLog('METHOD_ENTRY', 'assetHierarchyAnalysis(Asset I2CM)|Validating Asset hierarchy details for I2CM: ' + I2CM.Name);
    map<String, Asset> returnMap = new map<String, Asset>();
    list<Asset> readList = [SELECT Id, Name, Product2.ProductCode, Parent_Asset__c, 
                              Parent_Asset__r.Product2.ProductCode, AccountId, SerialNumber
                            FROM Asset WHERE Parent_Asset__c =: I2CM.Id];
    
    for(Asset a : readList){  //Populate returnMap....
      returnMap.put(a.Product2.ProductCode, a);
    }
    if(returnMap.containsKey('Virtual Terminal ID')){ //fatal error
      log.appendLog('METHOD_EXIT', 'assetHierarchyAnalysis(Asset I2CM)|I2CM already has a Virtual Terminal Id: ' + returnMap.get('Virtual Terminal ID'));
      log.appendLog('FATAL_ERROR', 'I2CM must not have a Virtual Terminal Id');
      log.success = false;
      return returnMap;
    }
    if(returnMap.containsKey('HTS IP Address')){  //fatal error
      log.appendLog('METHOD_EXIT', 'assetHierarchyAnalysis(Asset I2CM)|I2CM already has an HTS IP Address: ' + returnMap.get('HTS IP Address'));
      log.appendLog('FATAL_ERROR', 'I2CM must not have an HTS IP Address');
      log.success = false;
      return returnMap;
    }
    if(!returnMap.containsKey('19-0955')){ //must have sat router! fatal error
      log.appendLog('METHOD_EXIT', 'assetHierarchyAnalysis(Asset I2CM)|I2CM must have an installed iDirect Modem!');
      log.appendLog('FATAL_ERROR', 'I2CM does not have an installed iDirect Modem!');
      log.success = false;
      return returnMap;
    }
    log.appendLog('METHOD_EXIT', 'assetHierarchyAnalysis(Asset I2CM)|I2CM Asset Hierarchy OK');
    return returnMap;
  }
  @testVisible private static Asset getVirtualTerminalId(Asset cleanI2CM){
    log.appendLog('METHOD_ENTRY', 'getVirtualTerminalId()|Getting next available VTID');
    Asset returnAsset = new Asset();
    //Try... HTS_virtual_terminal_ids could throw an Exception in the constructor!
    HTS_virtual_terminal_ids helper = new HTS_virtual_terminal_ids();
    claimedVTID = helper.getNextAvailableVTID();
    claimedVTID.Date_Issued__c = DateTime.now();
    returnAsset = HTS_assets.create_VTIDS_Asset(claimedVTID);
    returnAsset.Parent_Asset__c = cleanI2CM.Id;
    system.debug(claimedVTID);
    log.appendLog('METHOD_EXIT', 'getVirtualTerminalId()|Returning VTID Asset: '  + returnAsset.Name);
    return returnAsset;
  }
  @testVisible private static Asset getHTSIp(Asset cleanI2CM){
    log.appendLog('METHOD_ENTRY', 'getHTSIp()|Getting next available VTID');
    //TODO: be prepared for re-cycled HTS IPs...
    Asset returnAsset = new Asset();
    HTS_ip_addresses helper = new HTS_ip_addresses ();
    claimedHTSIP = helper.getNextAvailableAddress();
    claimedHTSIP.Date_Issued__c = DateTime.now();
    returnAsset = HTS_assets.create_HTS_IP_Asset(claimedHTSIP);
    returnAsset.Parent_Asset__c = cleanI2CM.Id;
    system.debug(claimedHTSIP);
    log.appendLog('METHOD_EXIT', 'getHTSIp()|Returning HTS IP Asset: ' + returnAsset.Name);
    return returnAsset;
  }

  @testVisible private static map<String, String> buildAttributeMap(map<String, Asset> hierarchyMap){
    log.appendLog('METHOD_ENTRY', 'buildAttributeMap(map<String, Asset> hierarchyMap)|Creating Attribute Map from Assets');
    //Setup and populate attributeMap
    map<String, String> returnMap = new map<String, String>();
    //Begin building 6 POST attributes in a map, including....
    /*{
        "coremodule_id": 0,
        "terminal_ip_address": "string",
        "mgmtipaddress": "string",
        "template_id": "string",
        "terminal_id": "string",
        "terminaltype_id": 0
    }*/
    //Verify that required Assets are included in hierarchyMap https://kvhdev.atlassian.net/browse/HTSSF-311
    try{
      // #1 Core Module Id... Need to convert to strings before adding to map
      HTS_ltgsvc_satrouters CoreModule = HTS_ltgsvc_shared.getCoreModuleFromOSS(hierarchyMap.get('19-0955').SerialNumber); //Migrated to static method...
      returnMap.put('coremodule_id', String.valueOf(CoreModule.satRouterMap.get('obj_id')));    //Will need to convert back to Int
      // #2, Terminal IP Address
      String  terminal_ip_address = hierarchyMap.get('HTS IP Address').Name;
      returnMap.put('terminal_ip_address', terminal_ip_address + '/24');
      // #3, management IP
      list<HTS_IP_Address__c> ipList = [SELECT Management_IP_Address__c FROM HTS_IP_Address__c WHERE HTS_IP_Address__c =: terminal_ip_address LIMIT 1];
      String  mgmtipaddress = ipList[0].Management_IP_Address__c; 
      returnMap.put('mgmtipaddress', mgmtipaddress);
      // #4 Default Template Id
      returnMap.put('template_id', HTS_ltgsvc_shared.getDefaultTerminalTemplate()); //Migrated to static method...
      // #5 Terminal Id
      returnMap.put('terminal_id', hierarchyMap.get('Virtual Terminal ID').Name);
      // #6 Default Terminal Type Id
      Integer TerminalType = HTS_ltgsvc_shared.getDefaultTerminalTypeId();  //Migrated to static method...
      returnMap.put('terminaltype_id', String.valueOf(TerminalType));    //Will need to convert back to Int
      // attributeMap setup complete
      system.debug(returnMap);
    } catch (exception e){ //fatal error
      log.appendLog('METHOD_EXIT', 'buildAttributeMap(map<String, Asset> hierarchyMap)|An Exception has been caught.');
      log.appendLog('FATAL_ERROR', 'Could not build Attribute Map. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
      log.success = false;
      log.createCase(e);  //use the system thrown exception as an input to the method
      return returnMap;
    }
    log.appendLog('METHOD_EXIT', 'buildAttributeMap(map<String, Asset> hierarchyMap)|Returning Attribute Map built from Assets');
    return returnMap;
  }
  @testVisible private static HTSOSS_hts_terminals_asynch buildAsynchTerminal(map<String,String> attributeMap){
    log.appendLog('METHOD_ENTRY', 'buildAsynchTerminal(map<String,String> attributeMap)|Building an HTS Terminal for Aynchronous POSTing');
    HTSOSS_hts_terminals_asynch returnObj = new HTSOSS_hts_terminals_asynch();
    //try
    returnObj.coremodule_id = integer.valueOf(attributeMap.get('coremodule_id'));
    returnObj.mgmtipaddress = attributeMap.get('mgmtipaddress');
    returnObj.template_id = attributeMap.get('template_id');
    returnObj.terminal_id = attributeMap.get('terminal_id');
    returnObj.terminal_ip_address = attributeMap.get('terminal_ip_address');  
    returnObj.terminaltype_id = integer.valueOf(attributeMap.get('terminaltype_id'));  
    system.debug(returnObj);
    log.appendLog('METHOD_EXIT', 'buildAsynchTerminal(map<String,String> attributeMap)|Returning an HTS Terminal for Asynchronous POSTing');
    return returnObj;
  }
  @testVisible private static HTSOSS_hts_terminals_asynch postTerminalAsynch(HTSOSS_hts_terminals_asynch termToPost){
    log.appendLog('METHOD_ENTRY', 'postTerminalAsynch(HTSOSS_hts_terminals_asynch termToPost)|POSTing HTS Terminal to OSS for Asynchronous processing');
    HTSOSS_hts_terminals_asynch returnTerm = new HTSOSS_hts_terminals_asynch();
    try{
      returnTerm = termToPost.postTerminalAsynch(termToPost);
      //migrate input attributes to output object...
      returnTerm.coremodule_id = termToPost.coremodule_id;
      returnTerm.terminal_ip_address = termToPost.terminal_ip_address;
      returnTerm.mgmtipaddress = termToPost.mgmtipaddress;
      returnTerm.template_id = termToPost.template_id;
      returnTerm.terminal_id = termToPost.terminal_id;
      returnTerm.terminaltype_id = termToPost.terminaltype_id;
    } catch (exception e){
      log.appendLog('METHOD_EXIT', 'postTerminalAsynch(HTSOSS_hts_terminals_asynch termToPost)|An Exception has been caught.');
      log.appendLog('FATAL_ERROR', 'Could not POST to OSS. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
      log.success = false;
      log.createCase(e);  //use the system thrown exception as an input to the method
      return returnTerm;
    }
    log.appendLog('METHOD_EXIT', 'postTerminalAsynch(HTSOSS_hts_terminals_asynch termToPost)|POSTed HTS Terminal to OSS Asynchronous job ID: ' + returnTerm.obj_id);
    return returnTerm;
  }
  @testVisible private static HTSOSS_hts_subscribers postDefaultSubscriber(HTSOSS_hts_terminals_asynch postedTerm){
    log.appendLog('METHOD_ENTRY', 'postDefaultSubscriber(HTSOSS_hts_terminals_asynch postedTerm)|POSTing an HTS Subscriber on the Enabled Plan');
    HTSOSS_hts_subscribers returnSub = new HTSOSS_hts_subscribers();
    returnSub.subscriber_id = postedTerm.terminal_id + '-00';
    list<String> sub_IP = new list<String>();
    sub_IP.add(postedTerm.terminal_ip_address);
    returnSub.subscriber_ip_addresses = sub_IP;
    returnSub.subscriber_plan_id = 'Enabled';    //TODO: replace with sObject lookup....
    //This is where we post
    try{
      returnSub = returnSub.postSubscriber(returnSub);
      if(returnSub.response_code != 201){
        log.appendLog('METHOD_EXIT', 'postDefaultSubscriber(HTSOSS_hts_terminals_asynch postedTerm)|Failed to POST a Subscriber');
        log.appendLog('FATAL_ERROR', 'Could not POST Subscriber to OSS. Response Code: ' + returnSub.response_code + ' Message: ' + returnSub.message);
        log.success = false;
        return returnSub;
      }
    } catch (exception e){
      log.appendLog('METHOD_EXIT', 'postDefaultSubscriber(HTSOSS_hts_terminals_asynch postedTerm)|An Exception has been caught.');
      log.appendLog('FATAL_ERROR', 'Could not POST to OSS. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
      log.success = false;
      log.createCase(e);  //use the system thrown exception as an input to the method
      return returnSub;
    }
    log.appendLog('METHOD_EXIT', 'postDefaultSubscriber(HTSOSS_hts_terminals_asynch postedTerm)|Successfully POSTed subscriber with Id: ' + returnSub.subscriber_id);
    return returnSub;
  }
}