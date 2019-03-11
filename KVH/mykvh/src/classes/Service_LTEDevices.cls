public class Service_LTEDevices {
  //Some of the common elements will migrate into Service_base
  public static serviceResults log {get; private set;}
  public static Case warningCase {get; private set;}
  public static final String ORG_ID = 'defaul';

  @testVisible private static list<Asset_Hierarchy_Template__mdt> lteHierarchyTemplate; 

  public Service_LTEDevices() {
    
  }

  static {
    log = new serviceResults();
    log.success = true;       //optimistic initialization....
    log.message = DateTime.now() + '\t' + 'SERVICE_INITIALIZATION\t' + 'Initializing LTE Devices Management Service';
    lteHierarchyTemplate = [SELECT Product_Code__c, Root__c, Parent__c, DeveloperName, Type__c
                  FROM Asset_Hierarchy_Template__mdt
                  WHERE Root__c = '01-0419'
                  ORDER BY DeveloperName];
  }
  public static serviceResults getLog(){
    return log;
  }
  public static Case getWarningCase(){
    return warningCase;
  }
  @testVisible private static list<Asset_Hierarchy_Template__mdt> getlteHierarchyTemplate(){
    return lteHierarchyTemplate;
  }
  //Main Method
  public static serviceResults postLTEDeviceToOSS(list<Asset> inputList){
    String methodName = 'postLTEDeviceToOSS(list<Asset> inputList)';
    log.appendLog('METHOD_ENTRY', methodName + '|Begin LTE Device POSTing Process...');
    preProcessValidation(inputList);
    if(log.success == false){ return returnFatalError(); }
    list<Asset> cleanHierarchy = getCleanAssets(inputList);
    if(log.success == false){ return returnFatalError(); }
    Boolean validationResults = validateCleanHierarchy(cleanHierarchy);
    if(log.success == false){ return returnFatalError(); }
    Asset lteDevice = isolateLTEDevice(cleanHierarchy);
    if(log.success == false){ return returnFatalError(); }
    Integer groupId = getGroupId(lteDevice.Name);
    if(log.success == false){ return returnFatalError(); }
    LTEOSS_lte_devices postedDevice = postToOSS(groupId, lteDevice.Name);
    if(log.success == false){ return returnFatalError(); }
    //Wrap it all up!
    log.appendLog('METHOD_EXIT', methodName + '|LTE Device Successfully POSTed to OSS');
    if (log.success){
      if(log.srCase != null){
        log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
        insert log.srCase;
        log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
      }
      log.appendLog('SERVICE_FINISHED', 'SUCCESS: LTE Device POSTing Process completed successfully!');
    } else {
      return returnFatalError();
    }
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return log;
  }

  //Private methods
  @testVisible private static serviceResults returnFatalError(){
    if(log.srCase == null){
      Exception ex = new NoDataFoundException();  //Create, but do not throw an exception as an input to the method
      ex.setMessage('Fatal Error in Service_LTEDevices Class');
      log.createCase(ex);
    }
    log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
    insert log.srCase;
    log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
    log.appendLog('SERVICE_FINISHED', 'ERROR: LTE Devices Service failed to complete successfully. See log for details.');
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return log;
  }
  @testVisible private static void preProcessValidation(list<Asset> hierarchy){
    String methodName = 'preProcessValidation(list<Asset> hierarchy)';
    log.appendLog('METHOD_ENTRY', methodName + '|Beginning Pre-Process Validation of Asset Hierarchy');
    //Verify that the input list has some members...
    if(hierarchy.size() <= 1){
      log.appendLog('METHOD_EXIT', methodName + '|Input Asset Hierarchy incomplete!');
      log.appendLog('FATAL_ERROR', 'Pre-process validation failed. Input Asset Hierarchy has only '
                                   + hierarchy.size() + ' members!');
      log.success = false;
      return;
    }
    for(Asset a : hierarchy){
      if(a.Id == null){
        log.appendLog('METHOD_EXIT', methodName + '|Input Asset Hierarchy missing record Ids!');
        log.appendLog('FATAL_ERROR', 'Pre-process validation failed. Input Asset Hierarchy does not include record Ids');
        log.success = false;
        return;
      }
    }
    //Verify that we have the *right* members (Asset Hierarchy Template CMT??)
    
    log.appendLog('METHOD_EXIT', methodName + '|Pre-Process Validation of Asset Hierarchy Complete');
    return;
  }
  @testVisible private static list<Asset> getCleanAssets(list<Asset> hierarchy){
    String methodName = 'getCleanAssets(list<Asset> hierarchy)';
    list<Asset> cleanHierarchy = new list<Asset>();
    log.appendLog('METHOD_ENTRY', methodName + '|Getting clean list of Assets from Salesforce');
    try{
      Map<Id, Asset> assetMap = new Map<Id, Asset>(hierarchy);
      Set<Id> assetIds = assetMap.keySet();
      cleanHierarchy = [SELECT Id, Name, Asset_Id__c, Product2.ProductCode,
                                Parent_Asset__c, Parent_Asset__r.Product2.ProductCode 
                        FROM Asset 
                        WHERE Id IN: assetIds];
      log.appendLog('METHOD_EXIT', methodName + '|Successfully obtained clean list of Assets from Salesforce');
    } catch(Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
      log.appendLog('FATAL_ERROR', 'Could not obtain clean list of Assets from Salesforce. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
      log.success = false;
      log.createCase(e);  //use the system thrown exception as an input to the method
      return cleanHierarchy;
    }
    return cleanHierarchy;
  }
  @testVisible private static Boolean validateCleanHierarchy(list<Asset> cleanHierarchy){
    String methodName = 'validateCleanHierarchy(list<Asset> cleanHierarchy)';
    Boolean returnBool = true;  //optomistic
    log.appendLog('METHOD_ENTRY', methodName + '|Validating LTE Asset Hierarchy');
    try{
      //Need to ensure that all items in Template are included in Asset Hierarchy
      //Need a map of Part Number (using Product_Id__c) to Asset (AFTER insert... so we can upsert parent details)
      map<String, Asset> assetMap = new map<String, Asset>();
      for(Asset a : cleanHierarchy){
        assetMap.put(a.Asset_Id__c.substringBefore('_US_'), a);
      }
      //Need a map of Part Number to Asset Hierarchy Template data to figure out 
      //which assets are parented by which
      map<String, Asset_Hierarchy_Template__mdt> templateMap 
        = new map<String, Asset_Hierarchy_Template__mdt>();
      for(Asset_Hierarchy_Template__mdt aht : lteHierarchyTemplate){
        templateMap.put(aht.Product_Code__c, aht);
      }
      //Now match them up...
      for(String partNum : assetMap.keySet()){
        system.debug(partNum);
        if(templateMap.get(partNum).Parent__c == null){ 
          //skip the root...
        } else if(templateMap.get(partNum).Parent__c != assetMap.get(partNum).Parent_Asset__r.Product2.ProductCode){
          returnBool = false;
          log.appendLog('METHOD_EXIT', methodName + '|LTE Asset Hierarchy Parent-Child relationships incorrect.');
          log.appendLog('FATAL_ERROR', 'LTE Asset Hierarchy Validation failed.');
          log.success = false;
          return returnBool;
        }
      }
    } catch(Exception e){
      returnBool = false;
      log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
      log.appendLog('FATAL_ERROR', 'LTE Asset Hierarchy Validation failed. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
      log.success = false;
      log.createCase(e);  //use the system thrown exception as an input to the method
      system.debug(log);
      return returnBool;
    }
    log.appendLog('METHOD_EXIT', methodName + '|LTE Asset Hierarchy validation successful');
    return returnBool;
  }
  @testVisible private static Asset isolateLTEDevice(list<Asset> cleanHierarchy){
    String methodName = 'isolateLTEDevice(list<Asset> cleanHierarchy)';
    log.appendLog('METHOD_ENTRY', methodName + '|Isolating LTE Device from Asset Hierarchy');
    Boolean foundLTEDevice = false;
    Asset returnAsset = new Asset();
    for(Asset a : cleanHierarchy){
      if(a.Product2.ProductCode == '19-1027'){ //Found it!
        foundLTEDevice = true;
        returnAsset = a;
        break;                        //break out of this loop, we are DONE!
      }
    }
    if(foundLTEDevice == false){
      log.appendLog('METHOD_EXIT', methodName + '|Failed to find LTE Device in Asset Hierarchy!');
      for(Asset a : cleanHierarchy){
        log.appendLog('INFO', 'Asset.Name: ' + a.Name 
                              + ' Asset.Product2.ProductCode: ' 
                              + a.Product2.ProductCode);
      }
      log.appendLog('FATAL_ERROR', 'Input Asset Hierarchy does not appear to include a 19-1027 LTE Device!');
      log.success = false;
    }
    if(returnAsset.Name == null || returnAsset.Name == ''){
      log.appendLog('METHOD_EXIT', methodName + '|LTE Device Serial number missing or blank!');
      log.appendLog('FATAL_ERROR', '19-1027 LTE Device Name error!');
      log.success = false;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Successfully Isolated LTE Device');
    return returnAsset;
  }
  @testVisible private static Integer getGroupId(String deviceSN){
    String methodName = 'getGroupId(String deviceSN)';
    Integer returnInt = 0;
    log.appendLog('METHOD_ENTRY', methodName + '|Preparing to get Group Id from OSS');
    LTEOSS_lte_organizations.Groups_list_wrapper returnedWrapper 
      = new LTEOSS_lte_organizations.Groups_list_wrapper();
    try{
      returnedWrapper = LTEOSS_lte_organizations.getGroupByOrgId(ORG_ID, deviceSN);
      //The unhappy path start here...
      if(returnedWrapper.response_code != 200){      //Check response code
        log.appendLog('METHOD_EXIT', methodName + '|OSS Return Code: ' 
                                   + returnedWrapper.response_code
                                   + ' Message: '
                                   + returnedWrapper.message);
        log.appendLog('FATAL_ERROR', 'OSS Error');
        log.success = false;
        return -1;
      }
      if(returnedWrapper.groups.size() == 0){      //Check size of returned array (should be ONE)
        //try to POST to importDevices, success will return group_id
        log.appendLog('METHOD_EXIT', methodName + '|Unable to find Group within Oganization: '
                                   + ORG_ID
                                   + ' named: ' + deviceSN);
        return importNewDevice(deviceSN);
        /*
        log.appendLog('FATAL_ERROR', 'Group not found');
        log.success = false;
        return -1;*/
      } else if(returnedWrapper.groups.size() > 1){
        log.appendLog('METHOD_EXIT', methodName + '|Multiple Groups within Organization: '
                                   + ORG_ID
                                   + ' named: ' + deviceSN);
        log.appendLog('FATAL_ERROR', 'Multiple Groups found');
        log.success = false;
        return -1;
      }
      //Oh joy! we are back on the happy path!
      returnInt = returnedWrapper.groups[0].id;    //Get the Group ID of element [0]

    } catch(Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
      log.appendLog('FATAL_ERROR', 'Exception while getting Group ID from OSS Line number: ' 
                                 + e.getLineNumber() 
                                 + ' Message: ' + e.getMessage());
      log.success = false;
      log.createCase(e);  //use the system thrown exception as an input to the method
      system.debug(log);
      return -1;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Successfully obtained Group ID from OSS');
    return returnInt;
  }
  @testVisible private static LTEOSS_lte_devices postToOSS (Integer groupId, String deviceName){
    String methodName = 'postToOSS (Integer groupId, String deviceName)';
    log.appendLog('METHOD_ENTRY', methodName + '|Preparing to POST device to OSS');
    LTEOSS_lte_devices returnObj = new LTEOSS_lte_devices();
    try{
      returnObj = LTEOSS_lte_devices.postLTEDevice(ORG_ID, groupId, deviceName, deviceName);
      if(returnObj.response_code != 201){
        log.appendLog('METHOD_EXIT', methodName + '|OSS Return Code: ' 
                                   + returnObj.response_code
                                   + ' Message: '
                                   + returnObj.message);
        log.appendLog('FATAL_ERROR', 'Unable to POST LTE Device to OSS');
        log.success = false;
      } else {
        log.appendLog('METHOD_EXIT', methodName + '|Successfully POSTed Device to OSS');
      }
    } catch(Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
      log.appendLog('FATAL_ERROR', 'Exception while POSTing LTE Device to OSS: ' 
                                 + e.getLineNumber() 
                                 + ' Message: ' + e.getMessage());
      log.success = false;
      log.createCase(e);  //use the system thrown exception as an input to the method
    }
    return returnObj;
  }
  @testVisible private static Integer importNewDevice(String deviceSN){
    String methodName = 'importNewDevice(String deviceSN)';
    Integer returnInt = 0;
    log.appendLog('METHOD_ENTRY', methodName + '|Preparing to import: ' + deviceSN + ' and obtain group ID');
    //import a single device, and then return the group ID
    LTEOSS_lte_organizations.ImportedDeviceWrapper returnedWrapper 
      = new LTEOSS_lte_organizations.ImportedDeviceWrapper();
    try{
      returnedWrapper = LTEOSS_lte_organizations.postToImportDevices(deviceSN);
      if(returnedWrapper.response_code != 201){
        log.appendLog('METHOD_EXIT', methodName + '|OSS Return Code: ' 
                                    + returnedWrapper.response_code
                                    + ' Message: '
                                    + returnedWrapper.message);
        log.appendLog('FATAL_ERROR', 'OSS Error, could not import: ' + deviceSN);
        log.success = false;
        return -1;
      } else {
        returnInt = returnedWrapper.imported_devices[0].group_id;
        log.appendLog('METHOD_EXIT', methodName + '|Device Importation Successful!');
      }

    } catch(Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
      log.appendLog('FATAL_ERROR', 'Exception while Importing LTE Device: ' 
                                 + deviceSN + ' to OSS! '
                                 + e.getLineNumber() 
                                 + ' Message: ' + e.getMessage());
      log.success = false;
      log.createCase(e);  //use the system thrown exception as an input to the method
      returnInt = -1;
    }
    return returnInt;
  }
}