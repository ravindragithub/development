public with sharing class Service_I2CMFieldSwap{
  //Some of the common elements will migrate into Service_base
  public static serviceResults log {get; private set;}
  @testVisible private static list<Asset> updateList {get; private set;}
  // default constructor
  public Service_I2CMFieldSwap() { }
  //static block
  static {
    log = new serviceResults();
    log.success = true;       //optimistic initialization....
    log.message = DateTime.now() + '\t' + 'SERVICE_INITIALIZATION\t' + 'Initializing I2CM Field Swap Service';
    updateList = new list<Asset>();
  }
  //Mandatory method 
  //TODO: create interface? Migrate to virtual base Class??
  public static serviceResults getLog(){
    return log;
  }
  //public static method for test/dev purposes...
  //TODO: rename main method!
  public static serviceResults swapI2CMs(Asset removed, Asset installed){
    log.appendLog('METHOD_ENTRY', 'swapI2CMs(Asset removed, Asset installed)|Processing I2CM Swap for removed/old I2CM: ' + removed + ' installed/new I2CM: ' + installed);
    //VAlidate inputs....
    preProcessValidation(removed, installed);
    if(log.success == false){ return returnFatalError(); }

    Boolean replacementValidated = validateNewI2CM(installed);
    if(log.success == false){ return returnFatalError(); }

    String installationStatus = validateOldI2CM(removed);
    if(log.success == false){ return returnFatalError(); }
    //Should be 'Active', 'Enabled', or 'Error'.... and 'Error' sets log.success to false!
    map<String, Asset> assetMap = buildAssetMap(removed, installed);
    if(log.success == false){ return returnFatalError(); }
    //With assetMap successfully done, no we can decide to simply swap hardware or make OSS calls...
    if(installationStatus == 'Enabled'){  //https://kvhdev.atlassian.net/browse/HTSSF-450
      //just swap the Assets and return....
      system.assertEquals('Enabled', installationStatus);
      list<Asset> assetsToUpdate = swapEnabledHardware(assetMap.get('removed'), assetMap.get('installed'));
      update assetsToUpdate;
    } else {
      //Pre-Process validation complete, Release Core Module from "Installed"
      integer installedCoreId = getCoreId(assetMap.get('installed'));
      if(log.success == false){ return returnFatalError(); }
      HTSOSS_hts_terminals installedTerminal = getOSSTerminalParams(installedCoreId);
      if(log.success == false){ return returnFatalError(); }
      putTerminalInactive(installedTerminal);
      if(log.success == false){ return returnFatalError(); }
      deleteTerminal(installedTerminal);
      if(log.success == false){ return returnFatalError(); }
      deleteExistingSubscribers(installedTerminal);
      if(log.success == false){ return returnFatalError(); }
      //Core Module is now Available, Implement swap
      integer removedCoreId = getCoreId(assetMap.get('removed'));
      if(log.success == false){ return returnFatalError(); }
      HTSOSS_hts_terminals removedTerminal = getOSSTerminalParams(removedCoreId);
      if(log.success == false){ return returnFatalError(); }
      removedTerminal = updateTerminal(removedTerminal, installedTerminal);
      if(log.success == false){ return returnFatalError(); }
      //Callouts to OSS completed, time to deal with SF Assets....
      list<Asset> assetsToUpdate = swapAssetHardware(assetMap.get('removed'), assetMap.get('installed'));
      update assetsToUpdate;
      //Invoke Asynch job to make removed/old item testable again here.
      Id jobID = enqueueIdentifiersJob(assetMap.get('removed'));
      if(log.success == false){ return returnFatalError(); }
    }

    log.appendLog('METHOD_EXIT', 'swapI2CMs(Asset removed, Asset installed)|I2CM Swap finished for removed/old I2CM: ' + removed + ' installed/new I2CM: ' + installed);

    if (log.success){
      log.appendLog('SERVICE_FINISHED', 'SUCCESS: I2CM Field Swap Service completed successfully!');
    } else {
      return returnFatalError();
    }
    
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return log;
  } //PHEW!

  @testVisible private static serviceResults returnFatalError(){
    if(log.srCase == null){
      Exception ex = new NoDataFoundException();  //Create, but do not throw an exception as an input to the method
      ex.setMessage('Fatal Error in Service_I2CMFieldSwap Class');
      log.createCase(ex);
    }
    log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
    insert log.srCase;
    log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
    log.appendLog('SERVICE_FINISHED', 'ERROR: I2CM Field Swap Service failed to complete successfully. See log for details.');
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return log;
  }
  @testVisible private static void preProcessValidation(Asset removed, Asset installed){
    //interface method??
    //This method is to contain the validation steps required prior to entery into the process
    log.appendLog('METHOD_ENTRY', 'preProcessValidation(Asset removed, Asset installed)|Validating input parameters for removed: ' + removed.Name + ' and installed: ' + installed.Name);
    //Both Assets must in database
    if(removed.Id == null || installed.Id == null){
      log.appendLog('METHOD_EXIT', 'getAssetMap(Asset removed, Asset installed)|Invalid Input');
      log.appendLog('FATAL_ERROR', 'Null Asset Record Id detected!');
      log.success = false;
      return;
    }
    //Must not be same Asset
    if(removed.Id == installed.Id){
      log.appendLog('METHOD_EXIT', 'getAssetMap(Asset removed, Asset installed)|Invalid Input');
      log.appendLog('FATAL_ERROR', 'Removed and Installed Assets cannot be the same Asset!');
      log.success = false;
      return;
    }
    //Must BOTH be I2CMs (validated while building Asset map)
    //The removed Asset must be a child of an HTS system (validated while building Asset map)
    log.appendLog('METHOD_EXIT', 'preProcessValidation(Asset removed, Asset installed)|Validation complete for removed: ' + removed.Name + ' and installed: ' + installed.Name);
    return;
  }
  @testVisible private static map<String, Asset> buildAssetMap(Asset removed, Asset installed){
    log.appendLog('METHOD_ENTRY', 'getAssetMap(Asset removed, Asset installed)|Building Asset Map for removed: ' + removed.Name + ' and installed: ' + installed.Name);
    map<String, Asset> returnMap = new map<String, Asset>();
    list<Id> filterList = new list<Id>();
    filterList.add(removed.Id);
    filterList.add(installed.Id);
    for(Asset a : [SELECT Id, Name, Product2.ProductCode, Parent_Asset__c, 
                          Parent_Asset__r.Product2.ProductCode, AccountId
                   FROM Asset WHERE Id IN: filterList]){
      //installed and Removed Must BOTH be I2CMs
      if(!a.Product2.ProductCode.endsWithIgnoreCase('02-2204-02')){ //It's NOT an I2CM....
        log.appendLog('FATAL_ERROR', 'Input Parameter is not an I2CM: ' + a);
        log.success = false;
        return returnMap;
      }
      //Make some checks on the removed/old I2CM...
      if(a.Id == removed.Id && a.Parent_Asset__c == null){ //HTSSF-453
        //The removed Asset is the child of an HTS system
        //TODO: migrate the conditional criteria to a Custom Setting or MDT...
        log.appendLog('FATAL_ERROR', 'Removed I2CM ' + a.Name + ' is not the Child of an HTS System: ' + a.Parent_Asset__r.Product2.ProductCode);
        log.success = false;
        return returnMap;
      } else if(a.Id == removed.Id && a.Parent_Asset__c != null){
        returnMap.put('removed', a);
      }
      //Make some checks on the installed/new I2CM
      if(a.Id == installed.Id && a.Parent_Asset__c != null){
        log.appendLog('FATAL_ERROR', 'Installed I2CM ' + a.Name + ' is not a Top Level Asset!');
        log.success = false;
        return returnMap;
      } else if(a.Id == installed.Id && a.Parent_Asset__c == null){
        returnMap.put('installed', a);
      }
    }
    log.appendLog('METHOD_EXIT', 'getAssetMap(Asset removed, Asset installed)|Returning Asset Map with ' + returnMap.size() + ' members');
    if(returnMap.size() != 2){
      log.appendLog('FATAL_ERROR', 'Could not build Asset Map with exactly 2 members!');
      log.success = false;
    }
    return returnMap;
  }
  @testVisible private static Boolean validateNewI2CM(Asset newI2CM){
    Boolean returnBool = true;
    log.appendLog('METHOD_ENTRY', 'validateNewI2CM(Asset newI2CM)|Validating replacement I2CM details for: ' + newI2CM.Name);
    map<String, Asset> I2CMStructure = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Product2.ProductCode, Parent_Asset__c, 
                          Parent_Asset__r.Product2.ProductCode
                   FROM Asset WHERE Id =: newI2CM.Id OR Root_Asset__c =: newI2CM.Id]){
      I2CMStructure.put(a.Product2.ProductCode, a);
    }
    system.debug(I2CMStructure);
    if(I2CMStructure.get('Virtual Terminal ID') == null){
      log.appendLog('FATAL_ERROR', 'Replacement I2CM missing Virtual Terminal Id');
      returnBool = false;
    }
    if(I2CMStructure.get('HTS IP Address') == null){
      log.appendLog('FATAL_ERROR', 'Replacement I2CM missing HTS IP Address');
      returnBool = false;
    }
    if(I2CMStructure.get('19-0955') == null){
      log.appendLog('FATAL_ERROR', 'Replacement I2CM missing 19-0955 (iDirect PCB)');
      returnBool = false;
    }
    if(returnBool == false){
      log.appendLog('METHOD_EXIT', 'validateNewI2CM(Asset newI2CM)|Invalid Replacement I2CM');
      log.appendLog('FATAL_ERROR', 'Replacement I2CM Validation Failed, missing key components!');
      log.success = false;
    }
    log.appendLog('METHOD_EXIT', 'validateNewI2CM(Asset newI2CM)|Replacement I2CM Validated OK: ' + newI2CM.Name);
    return returnBool;
  }
  @testVisible private static String validateOldI2CM(Asset oldI2CM){
    String methodName = 'validateOldI2CM(Asset oldI2CM)';
    String returnString = 'Validating...';
    log.appendLog('METHOD_ENTRY', methodName + '|Validating removed/old I2CM details for: ' + oldI2CM.Name);
    map<String, Asset> I2CMStructure = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Product2.ProductCode, Parent_Asset__c, 
                      Parent_Asset__r.Product2.ProductCode
                FROM Asset WHERE Id =: oldI2CM.Id OR Parent_Asset__c =: oldI2CM.Id]){
      I2CMStructure.put(a.Product2.ProductCode, a);
    }
    if(I2CMStructure.get('Virtual Terminal ID') != null && I2CMStructure.get('HTS IP Address') != null){
      log.appendLog('INFO', 'Replacing an un-activated I2CM!');
      returnString = 'Enabled';
    } else {
      log.appendLog('INFO', 'Replacing an activated I2CM!');
      returnString = 'Active';
    }
    system.debug('HERE IT IS >>>> ' + I2CMStructure);
    if(I2CMStructure.get('19-0955') == null){
      log.appendLog('FATAL_ERROR', 'Removed/old I2CM missing 19-0955 (iDirect PCB)');
      returnString = 'Error';
    }
    if(returnString == 'Error'){
      log.appendLog('METHOD_EXIT', methodName + '|Invalid I2CM Installation');
      log.appendLog('FATAL_ERROR', 'Removed/old I2CM Validation Failed, missing key components!');
      log.success = false;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Removed/old I2CM Validated OK: ' + oldI2CM.Name);
    return returnString;
  }

  //Need to get Core Module ID from an Asset...
  @testVisible private static Integer getCoreId(Asset I2CM){
    log.appendLog('METHOD_ENTRY', 'getCoreId(Asset I2CM)|Getting Core Module Id for: ' + I2CM);
    Integer returnInt = 0;
    //try getting one and only one iDirect serial number from Salesforce...
    list<Asset> readList = [SELECT Id, Name, SerialNumber FROM Asset 
                            WHERE Parent_Asset__c =: I2CM.Id AND Product2.ProductCode = '19-0955'];
    if(readList.size() == 0){       //fatal error, no core module!
      log.appendLog('METHOD_EXIT', 'getCoreId(Asset I2CM)|Returning ' + returnInt + ' No Core Module in: ' + I2CM);
      log.appendLog('FATAL_ERROR', 'Missing iDirect Modem!');
      log.success = false;
      return -1;
    } else if(readList.size() > 1){ //fatal error, multiple core modules!
      log.appendLog('METHOD_EXIT', 'getCoreId(Asset I2CM)|Returning multiple iDirect Modems in: ' + I2CM);
      log.appendLog('FATAL_ERROR', 'Multiple iDirect Modems!');
      log.success = false;
      return -1;
    }
    HTSOSS_hts_satelliterouters coreModule = new HTSOSS_hts_satelliterouters();
    HTSOSS_hts_satelliterouters.satelliterouters_list_wrapper coresWrapper = new HTSOSS_hts_satelliterouters.satelliterouters_list_wrapper();
    coresWrapper = coreModule.getSatelliteRouters(readList[0].SerialNumber);
    returnInt = coresWrapper.satelliterouters_list[0].obj_id;
    log.appendLog('METHOD_EXIT', 'getCoreId(Asset I2CM)|Returning ' + returnInt + ' as Core Module Id for: ' + I2CM);
    return returnInt;
  }

  @testVisible private static HTSOSS_hts_terminals getOSSTerminalParams(Integer coreId){
    log.appendLog('METHOD_ENTRY', 'getOSSTerminalParams(Integer coreId)|Getting Terminal Parameters for Core Module: ' + coreId);
    HTSOSS_hts_terminals returnObj = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals.terminals_list_wrapper readList = new HTSOSS_hts_terminals.terminals_list_wrapper();
    readList = returnObj.getTerminals(null, null, coreId);
    if(readList.terminals_list.size() == 1){
      HTSOSS_hts_terminals readTerm = returnObj.getTerminal(readList.terminals_list[0]);
      returnObj.obj_id  = readTerm.obj_id;
      returnObj.obj_revision = readTerm.obj_revision;
      returnObj.mgmtipaddress = readTerm.mgmtipaddress;
      returnObj.terminal_id = readTerm.terminal_id;
      returnObj.terminal_ip_address = readTerm.terminal_service_ip.substringBeforeLast('.') + '.0/24';
      returnObj.terminaltype_id = readTerm.terminaltype_id;
      returnObj.template_id = readTerm.template_id; 
      returnObj.coremodule_id = readTerm.coremodule_id;
      returnObj.message = readTerm.message;
      returnObj.response_code = readTerm.response_code;
    } else {
      log.appendLog('METHOD_EXIT', 'getOSSTerminalParams(Integer coreId)|Failed to GET one and only one Terminal with Core Module Id: ' + coreId);
      log.appendLog('FATAL_ERROR', 'Could not get Terminal parameters!');
      log.success = false;
    }
    log.appendLog('METHOD_EXIT', 'getOSSTerminalParams(Integer coreId)|Returning Terminal Parameters: ' + returnObj);
    return returnObj;
  }
  @testVisible private static HTSOSS_hts_terminals putTerminalInactive(HTSOSS_hts_terminals termToPut){
    log.appendLog('METHOD_ENTRY', 'putTerminalInactive(HTSOSS_hts_terminals termToPut)|Returning Terminal Parameters: ' + termToPut);
    termToPut.is_active = false;
    termToPut = termToPut.putTerminal(termToPut);
    if(termToPut.response_code != 204){   //TODO: handle 404 and 500 seperately...
      log.appendLog('METHOD_EXIT', 'putTerminalInactive(HTSOSS_hts_terminals termToPut)|Unable to PUT inactive state to Terminal: ' + termToPut);
      log.appendLog('FATAL_ERROR', 'Could not PUT Terminal to inactive state!');
      log.success = false;
      return termToPut;
    }
    log.appendLog('METHOD_EXIT', 'putTerminalInactive(HTSOSS_hts_terminals termToPut)|Returning Terminal Parameters: ' + termToPut);
    return termToPut;
  }
  @testVisible private static HTSOSS_hts_terminals deleteTerminal(HTSOSS_hts_terminals termToDel){
    log.appendLog('METHOD_ENTRY', 'deleteTerminal(HTSOSS_hts_terminals termToDel)|Returning Terminal Parameters: ' + termToDel);
    termToDel = termToDel.deleteTerminal(termToDel);
    if(termToDel.response_code != 204){   //TODO: handle 404 and 500 seperately...
      log.appendLog('METHOD_EXIT', 'deleteTerminal(HTSOSS_hts_terminals termToDel)|Unable to DELETE Terminal: ' + termToDel);
      log.appendLog('FATAL_ERROR', 'Could not DELETE Terminal!');
      log.success = false;
      return termToDel;
    }
    log.appendLog('METHOD_EXIT', 'deleteTerminal(HTSOSS_hts_terminals termToDel)|Returning Terminal Parameters: ' + termToDel);
    return termToDel;
  }
  @testVisible private static HTSOSS_hts_subscribers deleteSubscriber(HTSOSS_hts_subscribers subToDelete){
    log.appendLog('METHOD_ENTRY', 'deleteSubscriber(HTSOSS_hts_subscribers subToDelete)|Deleting Subscriber: ' + subToDelete);
    subToDelete = subToDelete.deleteSubscriber(subToDelete);
    if(subToDelete.response_code != 204){   //TODO: handle 404 and 500 seperately...
      log.appendLog('METHOD_EXIT', 'deleteSubscriber(HTSOSS_hts_subscribers subToDelete)|Unable to DELETE Subscriber: ' + subToDelete);
      log.appendLog('FATAL_ERROR', 'Could not DELETE Subscriber!');
      log.success = false;
      return subToDelete;
    }
    log.appendLog('METHOD_EXIT', 'deleteSubscriber(HTSOSS_hts_subscribers subToDelete)|Returning Subscriber Attributes: ' + subToDelete);
    return subToDelete;
  }
  @testVisible private static integer deleteExistingSubscribers(HTSOSS_hts_terminals installedTerminal){
    log.appendLog('METHOD_ENTRY', 'deleteExistingSubscribers(HTSOSS_hts_terminals installedTerminal)|Processing Subscriber Deletions for: ' + installedTerminal);
    Integer returnInt = -1;
    HTS_ltgsvc_diagnostics subsList = HTS_ltgsvc_diagnostics.getActiveSubscriptions(installedTerminal.terminal_id);
    returnInt = subsList.activeSubscriptions.size();
    if (returnInt == 0){
      //TODO: Handle system not "Enabled"
      log.appendLog('WARNING', 'deleteExistingSubscribers(HTSOSS_hts_terminals installedTerminal)|Found zero existing subscriptions for: ' + installedTerminal);
    } else if(returnInt > 1){
      //TODO: Handle multiple subs.... with a WARNING!
      log.appendLog('WARNING', 'deleteExistingSubscribers(HTSOSS_hts_terminals installedTerminal)|Found ' + returnInt + ' existing subscriptions for: ' + installedTerminal);
      for(HTSOSS_hts_subscribers sub : subsList.activeSubscriptions){
        HTSOSS_hts_subscribers deletedSub = new HTSOSS_hts_subscribers();
        deletedSub = Service_I2CMFieldSwap.deleteSubscriber(sub);
      }
    } else {  //One and only one subscriber :)
      HTSOSS_hts_subscribers deletedSub = new HTSOSS_hts_subscribers();
      deletedSub = Service_I2CMFieldSwap.deleteSubscriber(subsList.activeSubscriptions[0]);
    }
    log.appendLog('METHOD_EXIT', 'deleteExistingSubscribers(HTSOSS_hts_terminals installedTerminal)|Processed ' + returnInt + ' Subscriber Deletions for: ' + installedTerminal);
    return returnInt;
  }
  @testVisible private static list<Asset> swapEnabledHardware(Asset removed, Asset installed){
    String methodName = 'swapEnabledHardware(Asset removed, Asset installed)';
    log.appendLog('METHOD_ENTRY', methodName + '|Processing Asset Migrations (ONLY) for: ' + installed.Name  + ' and ' + removed.Name);
    list<Asset> returnList = new list<Asset>();
    map<String, DefaultAccounts__c> settingsMap = DefaultAccounts__c.getAll();
    Id replacedAssets = settingsMap.get('ReplacedAssets').Account_ID__c;
    Id systemAsset = removed.Parent_Asset__c;
    //First move removed/old Item to the replaced assets Account
    removed.Parent_Asset__c = null;
    removed.AccountId = replacedAssets;
    returnList.add(removed);

    //Next "install" installed/new item as child of system
    installed.Parent_Asset__c = systemAsset;
    returnList.add(installed);
    
    log.appendLog('METHOD_EXIT', methodName + '|Asset Migrations (ONLY) Completed!');
    return returnList;
  }
  @testVisible private static list<Asset> swapAssetHardware(Asset removed, Asset installed){
    log.appendLog('METHOD_ENTRY', 'swapAssetHardware(Asset removed, Asset installed)|Processing Asset Migrations for: ' + installed.Name  + ' and ' + removed.Name);
    list<Asset> returnList = new list<Asset>();
    map<String, DefaultAccounts__c> settingsMap = DefaultAccounts__c.getAll();
    Id replacedAssets = settingsMap.get('ReplacedAssets').Account_ID__c;
    Id systemAsset = removed.Parent_Asset__c;
    //First move removed/old Item to the replaced assets Account
    system.debug(removed);
    removed.Parent_Asset__c = null;
    removed.AccountId = replacedAssets;
    returnList.add(removed);
    //Next, retire the vtid and IP by moving them to the replaced Assets Account....
    returnList.addAll(Service_I2CMFieldSwap.retireIdentifiers(installed, replacedAssets));
    //Finally Move the installed/New to the Asset Hierarchy
    installed.Parent_Asset__c = systemAsset;
    returnList.add(installed);
    log.appendLog('METHOD_EXIT', 'swapAssetHardware(Asset removed, Asset installed)|Asset Migrations Completed!');
    return returnList;
  }
  @testVisible private static list<Asset> retireIdentifiers(Asset installed, Id replacedAssets){
    log.appendLog('METHOD_ENTRY', 'retireIdentifiers(Asset installed, Id replacedAssets)|Retiring Identifiers for ' + installed.Name);
    list<Asset> returnList = new list<Asset>();
    //map<String, Asset> identifiersToRetire = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Product2.ProductCode, Parent_Asset__c, AccountId
                   FROM Asset
                   WHERE Parent_Asset__c =: installed.Id]){
      if(a.Product2.ProductCode == 'Virtual Terminal ID' || a.Product2.ProductCode == 'HTS IP Address'){
        a.Parent_Asset__c = null;
        a.AccountId = replacedAssets;
        returnList.add(a);
      }
    }
    if(returnList.size() != 2){
      log.appendLog('WARNING', 'retireIdentifiers(Asset installed, Id replacedAssets)|Found ' + returnList.size() + ' Identifiers (should be 2)!');
    }
    log.appendLog('METHOD_EXIT', 'retireIdentifiers(Asset installed, Id replacedAssets)|Identifiers for ' + installed.Name + ' Retired!');
    return returnList;
  }

  @testVisible private static HTSOSS_hts_terminals updateTerminal(HTSOSS_hts_terminals removedTerminal, HTSOSS_hts_terminals installedTerminal){
    log.appendLog('METHOD_ENTRY', 'updateTerminal(HTSOSS_hts_terminals updated)|Updating via PUT: ' 
                  + removedTerminal.terminal_id + ' with Core Module Id: ' 
                  + installedTerminal.coremodule_id);
    HTSOSS_hts_terminals returnObj = new HTSOSS_hts_terminals();
    returnObj.obj_id = removedTerminal.obj_id;
    returnObj.coremodule_id = installedTerminal.coremodule_id;
    returnObj.obj_revision = removedTerminal.obj_revision;
    returnObj.is_active = true;
    try{
      returnObj = returnObj.putTerminal(returnObj);
      //TODO: throw custom exception for 500 returned from OSS callout....
      //until then...
      if(returnObj.response_code == 404){          //not found
        log.appendLog('FATAL_ERROR', 'Could not find terminal to update OSS: ' + returnObj.message);
        log.appendLog('METHOD_EXIT', 'updateTerminal(HTSOSS_hts_terminals removedTerminal, HTSOSS_hts_terminals installedTerminal)|OSS returned: ' + returnObj.response_code);
        log.success = false;
      } else if(returnObj.response_code != 204){   //unexpected error
        log.appendLog('FATAL_ERROR', 'Could not update terminal in OSS: ' + returnObj.message);
        log.appendLog('METHOD_EXIT', 'updateTerminal(HTSOSS_hts_terminals removedTerminal, HTSOSS_hts_terminals installedTerminal)|OSS returned: ' + returnObj.response_code);
        log.success = false;
      } else {                                     // success!!
        log.appendLog('METHOD_EXIT', 'updateTerminal(HTSOSS_hts_terminals removedTerminal, HTSOSS_hts_terminals installedTerminal)|Successfully updated terminal');
      }
    } catch (Exception e){
      log.appendLog('FATAL_ERROR', 'Could not update terminal in OSS: ' + e.getStackTraceString());
      log.appendLog('METHOD_EXIT', 'updateTerminal(HTSOSS_hts_terminals updated)|Exception caught: ' + e.getMessage());
      log.createCase(e);  //use the system thrown exception as an input to the method
      log.success = false;
    }
    return returnObj;
  }
  @testVisible private static Id enqueueIdentifiersJob(Asset toBeReturned){
    log.appendLog('METHOD_ENTRY', 'enqueueIdentifiersJob(Asset toBeReturned)|Assinging Identifiers for ' + toBeReturned.Name);
    Id jobID;
    try{
      jobID = system.enqueueJob(new I2CMAssignIdentifiers_queueable(toBeReturned));
    } catch (exception e){
      log.appendLog('FATAL_ERROR', 'Could not enqueue Job: ' + e.getStackTraceString());
      log.appendLog('METHOD_EXIT', 'enqueueIdentifiersJob(Asset toBeReturned)|Exception caught: ' + e.getMessage());
      log.createCase(e);  //use the system thrown exception as an input to the method
      log.success = false;
    }
    log.appendLog('METHOD_EXIT', 'enqueueIdentifiersJob(Asset toBeReturned)|Successful Job ID: ' + jobId);
    return jobID;
  }
}