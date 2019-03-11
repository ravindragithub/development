public class Service_LTE_activation_provisioning {
  public static serviceResults log {get; private set;}
  private static final Id AIRTIME_CASE_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airtime Service').getRecordTypeId();
  public Service_LTE_activation_provisioning() {
    
  }
  static {
    log = new serviceResults();
    log.success = true;       //optimistic initialization....
    log.message = DateTime.now() + '\t' + 'SERVICE_INITIALIZATION\t' + 'Initializing LTE Activation Provisioning Service';
  }
  public static serviceResults getLog(){
    return log;
  }

  /*****************************************************************************
   *Public Methods
   ****************************************************************************/
  //Main Method, provisioning
  public static serviceResults provisionLTE(SBQQ__Subscription__c rawSubscription, Asset rawDomeAsset){
    log.appendLog('METHOD_ENTRY', 'provisionLTE(SBQQ__Subscription__c rawSubscription, Asset rawDomeAsset)|Begin LTE provisioning process..');
    preProcessValidation(rawSubscription, rawDomeAsset);    //see HTSSF-595
    if(log.success == false){ return returnFatalError(); }
    SBQQ__Subscription__c cleanSubscription = getCleanSubscription(rawSubscription);  //see HTSSF-606
    if(log.success == false){ return returnFatalError(); }
    verifySubscription(cleanSubscription);  //see HTSSF-608
    if(log.success == false){ return returnFatalError(); }
    list<Asset> assetHierarchy =  getAssetHierarchy(rawDomeAsset);  //see HTSSF-607
    if(log.success == false){ return returnFatalError(); }
    map<String, Asset> assetMap =  createAssetMap(assetHierarchy);  //see HTSSF-610
    if(log.success == false){ return returnFatalError(); }
    validateAssetHierarchy(assetMap);  //HTSSF-611
    if(log.success == false){ return returnFatalError(); } 
    HTS_Virtual_Terminal_ID__c claimedVTID = getNextVTID();   //HTSSF-615
    if(log.success == false){ return returnFatalError(); } 

    Asset vtidAsset = createVTIDAsset(claimedVTID, assetMap); //BLOCKED by HTSSF-619
    if(log.success == false){ return returnFatalError(); }  

    // Now we start making API calls
    LTEOSS_lte_subscribers currentSubscriber = getSubscriberState(assetMap);
    if(log.success == false){ return returnFatalError(); }

    //Take actions based on the currentSubscriber.status (it's a "state" really...)
    if(currentSubscriber.status == 'shipped'){           //New "cold" SIM
      LTEOSS_lte_subscribers postSubscriberResults = postSubscriberToOss(assetMap);
      if(log.success == false){ return returnFatalError(); }  
    } else if(currentSubscriber.status == 'hibernate'){  //previously active SIM
      LTEOSS_lte_subscribers postSubscriberResults = restoreLTESubscriber(assetMap);
      if(log.success == false){ return returnFatalError(); }  
    } else {  //Unexpected state!!
      log.appendLog('METHOD_EXIT', 'provisionLTE(SBQQ__Subscription__c rawSubscription, Asset rawDomeAsset)|LTE Device ' 
                                  + assetMap.get('02-2280').Name 
                                  + ' appears to already be activated');
      log.appendLog('FATAL_ERROR', 'Device is already active!');
      log.success = false;
      return returnFatalError();
    }

    LTEOSS_lte_devices activeLTEDevice = updateLTEDevice(assetMap);
    if(log.success == false){ return returnFatalError(); }  

    //Done with API calls, now we can to DML
    //update VTID
    updateVTID(claimedVTID);
    if(log.success == false){ return returnFatalError(); }
    //insert vtidAsset
    insertVTIDAsset(vtidAsset);
    if(log.success == false){ return returnFatalError(); }
    //updateSubscription
    updateSubscription(cleanSubscription, vtidAsset);
    if(log.success == false){ return returnFatalError(); }
    //NEW REQUIREMENT! Update Case
    updateCaseFields(cleanSubscription);
    if(log.success == false){ return returnFatalError(); }

    log.appendLog('METHOD_EXIT', 'provisionLTE(SBQQ__Subscription__c rawSubscription, Asset rawDomeAsset)|LTE provisioning process finished for: ' + cleanSubscription.Name ); // need to include LTE Activaiton number
    if (log.success){
      if(log.srCase != null){
        log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
        insert log.srCase;
        log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
      }
      log.appendLog('SERVICE_FINISHED', 'SUCCESS: LTE Activation Provisioning Service completed successfully!');
    } else {
      return returnFatalError();
    }

    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return log;
    }
  //Main Method Overload
  public static serviceResults provisionLTE(SBQQ__Subscription__c rawSubscription){
    String methodName = 'preProcessValidation(SBQQ__Subscription__c rawSubscription)';
    log.appendLog('METHOD_ENTRY', 'provisionLTE(SBQQ__Subscription__c rawSubscription)|Begin LTE provisioning process..');
    if(rawSubscription.Id == null){
      log.appendLog('METHOD_EXIT', methodName + '|Input SBQQ__Subscription__c missing record Id!');
      log.appendLog('FATAL_ERROR', 'Pre-process validation failed. Input SBQQ__Subscription__c does not include record Ids');
      log.success = false;
      return returnFatalError();
    }
    if(rawSubscription.Asset__c == null){
      log.appendLog('METHOD_EXIT', methodName + '|Input SBQQ__Subscription__c missing Asset reference!');
      log.appendLog('FATAL_ERROR', 'Pre-process validation failed. Input SBQQ__Subscription__c does not include Asset reference');
      log.success = false;
      return returnFatalError();
    }
    Asset inputAsset = new Asset(Id = rawSubscription.Asset__c);
    return provisionLTE(rawSubscription, inputAsset);
  }
  //Main Method 2, Hibernation used for suspension and Termination
  public static serviceResults hibernateLTE(SBQQ__Subscription__c rawSubscription, Boolean isTermination){
    log.appendLog('METHOD_ENTRY', 'suspendLTE(SBQQ__Subscription__c rawSubscription)|Begin LTE suspension process..');
    preProcessValidation(rawSubscription); // maybe we need another PrePRocess validation!
    if(log.success == false){ return returnFatalError(); }
    SBQQ__Subscription__c cleanSubscription = getCleanSubscription(rawSubscription);
    if(log.success == false){ return returnFatalError(); }
    verifySubscription(cleanSubscription);
    if(log.success == false){ return returnFatalError(); }
    list<Asset> assetHierarchy =  getAssetHierarchy(new Asset(Id=cleanSubscription.Asset__c));
    if(log.success == false){ return returnFatalError(); }
    map<String, Asset> assetMap =  createAssetMap(assetHierarchy);
    if(log.success == false){ return returnFatalError(); }
    //validateAssetHierarchy(assetMap);
    //if(log.success == false){ return returnFatalError(); }
    // Now we start making API calls
    LTEOSS_lte_subscribers currentSubscriber = getSubscriberState(assetMap);
    if(log.success == false){ return returnFatalError(); }
    //Take actions based on the currentSubscriber.status (it's a "state" really...)
    if(currentSubscriber.status != 'active'){           //previously activated SIM
      log.appendLog('FATAL_ERROR', 'OSS reports invalid subscriber state: ' + currentSubscriber.status);
      log.appendLog('METHOD_EXIT', 'suspendLTE(SBQQ__Subscription__c rawSubscription)|LTE suspension process finished for: ' + cleanSubscription.Name );
      log.success = false;
      return returnFatalError();
    }
    //PUT subscription to hibernate
    LTEOSS_lte_subscribers returnedSubscriber = hibernateLTESubscriber(assetMap, isTermination);
    if(log.success == false){ return returnFatalError(); }
    //Call OSS to PUT device's virtual device id to be the same as the device SN
    LTEOSS_lte_devices updatedDevice = updateHibernatedDevice(assetMap, isTermination);
    //Done with API calls... update Subscription
    updateHibernatedSubscription(assetMap, isTermination, cleanSubscription);
    if(log.success == false){ return returnFatalError(); }

    log.appendLog('METHOD_EXIT', 'suspendLTE(SBQQ__Subscription__c rawSubscription)|LTE suspension process finished for: ' + cleanSubscription.Name );
    if (log.success){
      if(log.srCase != null){
        log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
        insert log.srCase;
        log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
      }
      log.appendLog('SERVICE_FINISHED', 'SUCCESS: LTE Suspension Service completed successfully!');
    } else {
      return returnFatalError();
    }

    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return log;
  }
  /*****************************************************************************
   *Private methods
   ****************************************************************************/
  @testVisible private static serviceResults returnFatalError(){
    if(log.srCase == null){
      Exception ex = new NullPointerException();  //Create, but do not throw an exception as an input to the method
      ex.setMessage('Fatal Error in Service_LTE_activation_provisioning Class');
      log.createCase(ex);
    }
    log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
    insert log.srCase;
    log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
    log.appendLog('SERVICE_FINISHED', 'ERROR: LTE Activation Provisioning Service failed to complete successfully. See log for details.');
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return log;
  }
  @testVisible private static void preProcessValidation(SBQQ__Subscription__c rawSubscription, Asset rawDomeAsset){
    String methodName = 'preProcessValidation(SBQQ__Subscription__c rawSubscription, Asset rawDomeAsset)';
    log.appendLog('METHOD_ENTRY', methodName + '|Validating input parameters');
      if(rawSubscription.Id == null){
        log.appendLog('METHOD_EXIT', methodName + '|Input SBQQ__Subscription__c missing record Id!');
        log.appendLog('FATAL_ERROR', 'Pre-process validation failed. Input SBQQ__Subscription__c does not include record Ids');
        log.success = false;
        return;
      }
      if(rawDomeAsset.Id == null){
        log.appendLog('METHOD_EXIT', methodName + '|Input Asset missing record Id!');
        log.appendLog('FATAL_ERROR', 'Pre-process validation failed. Input Asset does not include record Ids');
        log.success = false;
        return;
      }
    //See HTSSF-595... check that both have record Ids, if not, set log.success = false and return.
    log.appendLog('METHOD_EXIT', methodName + '|Validation for Subscription: ' + rawSubscription.Id + ' and ' + rawDomeAsset.Id + ' successful!');
    return;
  }
  @testVisible private static void preProcessValidation(SBQQ__Subscription__c rawSubscription){
    String methodName = 'preProcessValidation(SBQQ__Subscription__c rawSubscription)';
    log.appendLog('METHOD_ENTRY', methodName + '|Validating input parameters');
      if(rawSubscription.Id == null){
        log.appendLog('METHOD_EXIT', methodName + '|Input SBQQ__Subscription__c missing record Id!');
        log.appendLog('FATAL_ERROR', 'Pre-process validation failed. Input SBQQ__Subscription__c does not include record Ids');
        log.success = false;
        return;
      }
    //See HTSSF-595... check that both have record Ids, if not, set log.success = false and return.
    log.appendLog('METHOD_EXIT', methodName + '|Validation for Subscription: ' + rawSubscription.Id + ' successful!');
    return;
  }

  @testVisible private static SBQQ__Subscription__c getCleanSubscription(SBQQ__Subscription__c rawSubscription){
    String methodName = 'getCleanSubscription(SBQQ__Subscription__c rawSubscription)';
    log.appendLog('METHOD_ENTRY', methodName + '|query fields needed for subsequent Provisioning Service processing');
    try{
        SBQQ__Subscription__c cleanSubscription = [SELECT id, Name, SBQQ__Product__r.ProductCode, Asset__c, 
                                                  Traffic_Identifier__c, SBQQ__Contract__r.Id 
                                                  FROM SBQQ__Subscription__c 
                                                  WHERE ID =: rawSubscription.Id];
        log.appendLog('METHOD_EXIT', methodName + '|cleaned subscription retunred with needed fields.');
        return cleanSubscription;
    }catch(Exception ex){
        log.appendLog('METHOD_EXIT', methodName + '|Error in query subscription');
        log.appendLog('FATAL_ERROR', 'CleanSubscription failed. '+ex.getmessage());
        log.success = false;
        return null;
    }   
  }
  

  
  @testVisible private static void verifySubscription(SBQQ__Subscription__c cleanSubscription){
    String methodName = 'verifySubscription(SBQQ__Subscription__c cleanSubscription)';
    log.appendLog('METHOD_ENTRY', methodName + '|Validating critical values in the subscription');
      if(cleanSubscription.SBQQ__Product__r.ProductCode != 'LTE20GB'){
        log.appendLog('METHOD_EXIT', methodName + '|wrong subscription');
        log.appendLog('FATAL_ERROR', 'Subscription verification failed.Product code associated with this subscription is not related with the service.');
        log.success = false;
        return;
      }
      /*if(cleanSubscription.Asset__c != null){
        log.appendLog('METHOD_EXIT', methodName + '|Asset missing with subscription!');
        log.appendLog('FATAL_ERROR', 'Subscription verification failed. Subscription record has already been associated with asset.');
        log.success = false;
        return;
      }*/
      if(cleanSubscription.Traffic_Identifier__c != null){
        log.appendLog('METHOD_EXIT', methodName + '|Traffic Identifier missing with subscription!');
        log.appendLog('FATAL_ERROR', 'Subscription verification failed. Subscription record has already been associated with traffic identifier.');
        log.success = false;
        return;
      }
    //See HTSSF-608... verifySubscription needs examine critical values in the subscription record to ensure that ready for further processing. 
    log.appendLog('METHOD_EXIT', methodName + '|Verification for Subscription: ' + cleanSubscription.Id + ' successful!');
    return;
  }
  
  @testVisible private static list<Asset> getAssetHierarchy(Asset rawDomeAsset){
    String methodName = 'getAssetHierarchy(Asset rawDomeAsset)';
    log.appendLog('METHOD_ENTRY', methodName + '|get all the related assets');
    try{
        Asset temrawDomeAsset = [Select Root_Asset__c from Asset where ID =: rawDomeAsset.Id];
        String rootAssetId;
        if(temrawDomeAsset.Root_Asset__c == null){
            rootAssetId = rawDomeAsset.Id;
        }else{
            rootAssetId = temrawDomeAsset.Root_Asset__c;
        }
        List<Asset> assetHierarchy = [Select id, Product2.ProductCode, Name, 
                                      Parent_Asset__r.Product2.ProductCode, 
                                      Parent_Asset__c
                                      FROM Asset 
                                      WHERE Root_Asset__c =: rootAssetId OR ID =: rootAssetId];
        //See HTSSF-607... needs to query for and return All the Assets in the Asset Hierarchy related to the input Asset. 
        log.appendLog('METHOD_EXIT', methodName + '|getAssetHierarchy queried successfully.');
        return assetHierarchy;
    }catch(Exception ex){
        log.appendLog('METHOD_EXIT', methodName + '|Error in quering related assets');
        log.appendLog('FATAL_ERROR', 'getAssetHierarchy failed. '+ex.getmessage());
        log.success = false;
        return null;
    }
  }
  
  @testVisible private static map<String, Asset> createAssetMap(list<Asset> assetHierarchy){
    String methodName = 'createAssetMap(list<Asset> assetHierarchy)';
    log.appendLog('METHOD_ENTRY', methodName + '|prepare map of the assets with product code');
    try{
        Map<String,Asset> assetMap = new Map<String,Asset>();
        boolean FATAL_ERROR = false;
        for(Asset a: assetHierarchy){
          if(assetMap.containskey(a.Product2.ProductCode)){
            FATAL_ERROR = true;
            break;
          }else{
              assetMap.put(a.Product2.ProductCode, a);
          }          
        }
        if(FATAL_ERROR){
            log.appendLog('METHOD_EXIT', methodName + '|Error in creating asset map');
            log.appendLog('FATAL_ERROR', 'createAssetMap failed. Duplicate asset comes in the asset hierarchy.');
            log.success = false;
            return null;
        }
        
        for(Asset_Hierarchy_Template__mdt t : [SELECT Id, Product_Code__c, Parent__c, Root__c FROM Asset_Hierarchy_Template__mdt WHERE Root__c = '01-0419']){
            if(!assetMap.containsKey(t.Product_Code__c)){
              FATAL_ERROR = true;
              break;
            }
        }
        if(FATAL_ERROR){
            log.appendLog('METHOD_EXIT', methodName + '|Error in creating asset map');
            log.appendLog('FATAL_ERROR', 'createAssetMap failed. the actual hierarchy does not contain one of the required components.');
            log.success = false;
            return null;
        }
        //See HTSSF-610... return a map of Asset.ProductCode -> Asset to facilitate validation and further processing.
        log.appendLog('METHOD_EXIT', methodName + '|createAssetMap successfully completed.');
        return assetMap;
    }catch(Exception ex){
        log.appendLog('METHOD_EXIT', methodName + '|Error preparing the assets map with product code.');
        log.appendLog('FATAL_ERROR', 'createAssetMap failed. '+ex.getmessage());
        log.success = false;
        return null;
    }
  }
  
  @testVisible private static HTS_Virtual_Terminal_ID__c getNextVTID(){
    HTS_virtual_terminal_ids helper = new HTS_virtual_terminal_ids();
    
    String methodName = 'getNextVTID';
    log.appendLog('METHOD_ENTRY', methodName + '|get next VTID');
    try{
        HTS_Virtual_Terminal_ID__c claimedVTID = helper.getNextAvailableVTID();
        claimedVTID.Date_Issued__c = DateTime.now();
        
        //See HTSSF-615... get next VTID 
        log.appendLog('METHOD_EXIT', methodName + '|getNextVTID successfully completed.');
        return claimedVTID ;
    }catch(Exception ex){
        log.appendLog('METHOD_EXIT', methodName + '|Error in getting next VTID');
        log.appendLog('FATAL_ERROR', 'getNextVTID failed. '+ex.getmessage());
        log.success = false;
        return null;
    }
  }
  @testVisible private static LTEOSS_lte_subscribers getSubscriberState(map<String, Asset> assetMap){
    String methodName = 'getSubscriberState(map<String, Asset> assetMap)';
    log.appendLog('METHOD_ENTRY', methodName + '|GETing current subscriber ICCID state from OSS');
    LTEOSS_lte_subscribers returnObj = new LTEOSS_lte_subscribers();
    String iccid = assetMap.get('19-1035').Name;
    try{
      returnObj = LTEOSS_lte_subscribers.getLTESubscriberInfo(null, iccid);
      //200 or 404
      if(returnObj.response_code == 200){
        //ICCID found! happy path!
        log.appendLog('INFO', 'OSS reports ICCID: ' + iccid + ' is ' + returnObj.status);
        log.appendLog('METHOD_EXIT', methodName + '|OSS reports ICCID state for: ' + iccid 
                                + ' as ' + returnObj.status);
      } else if(returnObj.response_code == 404){
        //ICCID not found!
        log.appendLog('INFO', 'OSS reports ICCID: ' + iccid + ' is not found!');
        log.appendLog('METHOD_EXIT', methodName + '|ERROR: OSS returned ' + returnObj.response_code);
        log.appendLog('FATAL_ERROR', 'Could not get LTE Subscriber state from OSS for ICCID: ' + iccid );
        log.success = false;
      } else if(returnObj.response_code == 500){
        //OSS error
        log.appendLog('METHOD_EXIT', methodName + '|ERROR: OSS returned ' + returnObj.response_code);
        log.appendLog('FATAL_ERROR', 'Could not get LTE Subscriber state from OSS for ICCID: ' + iccid );
        log.success = false;
      }
    } catch(Exception e){
        log.appendLog('METHOD_EXIT', methodName + '|Exception caught: ' + e.getMessage());
        log.appendLog('FATAL_ERROR', 'Could not get LTE Subscriber state from OSS: ' + e.getStackTraceString());
        log.createCase(e);  //use the system thrown exception as an input to the method
        log.success = false;
        return returnObj;
    }
    return returnObj;
  }
  @testVisible private static LTEOSS_lte_subscribers postSubscriberToOss(map<String, Asset> assetMap){
    String methodName = 'postLTESubscriber(map<String, Asset> assetMap)';
    log.appendLog('METHOD_ENTRY', methodName + '|Preparing to POST subscriber to OSS');
    LTEOSS_lte_subscribers returnObj = new LTEOSS_lte_subscribers();
    String iccid = assetMap.get('19-1035').Name;
    String subscriber_id = assetMap.get('Virtual Terminal ID').Name.left(8) + '-11';
    String callPlan = '2GB US LTE';
    String region = 'CONUS';
    try{
      returnObj = LTEOSS_lte_subscribers.postLTESubscriber(callPlan, iccid, region, subscriber_id);
      if(returnObj.response_code != 201){
        log.appendLog('METHOD_EXIT', methodName + '|ERROR: OSS returned ' + returnObj.response_code);
        log.appendLog('FATAL_ERROR', 'Could not POST LTE Subscriber with ICCID ' + iccid + ' to OSS: ');
        log.success = false;
        return returnObj;
      }
    } catch(Exception e){
        log.appendLog('METHOD_EXIT', methodName + '|Exception caught: ' + e.getMessage());
        log.appendLog('FATAL_ERROR', 'Could not create LTE Subscriber in OSS: ' + e.getStackTraceString());
        log.createCase(e);  //use the system thrown exception as an input to the method
        log.success = false;
        return returnObj;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Successfully POSTed LTE Subscriber to OSS');
    return returnObj;
  }
  @testVisible private static LTEOSS_lte_devices updateLTEDevice(map<String, Asset> assetMap){
    String methodName = 'updateLTEDevice(map<String, Asset> assetMap)';
    LTEOSS_lte_devices returnObj = new LTEOSS_lte_devices();
    log.appendLog('METHOD_ENTRY', methodName + '|Preparing to update LTE device');
    try{
      //get device serial number from assetMap
      String deviceSN = assetMap.get('19-1027').Name;   //we update via device serial number (not Dome serial number)
      //GET group_id from /lte/organizations/{org_id}/groups
      LTEOSS_lte_organizations.Groups_list_wrapper groupsWrapper = LTEOSS_lte_organizations.getGroupByOrgId('defaul', deviceSN);
      if(groupsWrapper.groups.size() != 1){
        log.appendLog('METHOD_EXIT', methodName + '|OSS did not return one and only one Group ID for device: ' + deviceSN);
        log.appendLog('FATAL_ERROR', '|Could not isolate Group Id by device serial number');
        log.success = false;
        return returnObj;
      }
      Integer groupId = groupsWrapper.groups[0].Id;
      //GET /lte/devices/{org_id}/{group_id} for device Id
      LTEOSS_lte_devices.Devices_list_wrapper wrappedDevices = LTEOSS_lte_devices.getLTEDevices('defaul', groupId);
      if(wrappedDevices.devices.size() != 1){
        log.appendLog('METHOD_EXIT', methodName + '|OSS did not return one and only one Device ID for group: ' + groupId);
        log.appendLog('FATAL_ERROR', '|Could not isolate Device Id by Group Id');
        log.success = false;
        return returnObj;
      }
      Integer deviceId = wrappedDevices.devices[0].id;
      //PUT /lte/devices/{org_id}/{group_id}/{id} {"virtual_device_id": "<from assetMap>"}
      String vtid = assetMap.get('Virtual Terminal ID').Name;
      returnObj = LTEOSS_lte_devices.updateLTEDevice('defaul', groupId, deviceId, vtid);
      if(returnObj.response_code != 204){
        log.appendLog('METHOD_EXIT', methodName + '|OSS returned: ' + returnObj.response_code);
        log.appendLog('FATAL_ERROR', '|Could not update LTE Device in OSS');
        log.success = false;
        return returnObj;
      }
    } catch(Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|Exception caught: ' + e.getMessage());
      log.appendLog('FATAL_ERROR', 'Could not update LTE Device in OSS: ' +  + e.getLineNumber() + ' Message: ' + e.getMessage());
      log.createCase(e);  //use the system thrown exception as an input to the method
      log.success = false;
      return returnObj;
    }
    log.appendLog('METHOD_EXIT', methodName + '|LTE device successfully updated');
    return returnObj;
  }

  @testVisible private static LTEOSS_lte_devices updateHibernatedDevice(map<String, Asset> assetMap, Boolean isTermination){
    String methodName = 'updateHibernatedDevice(map<String, Asset> assetMap, Boolean isTermination)';
    LTEOSS_lte_devices returnObj = new LTEOSS_lte_devices();
    //IF terminating service, set virtual_device_id = device SN
    //otherwise it's a suspension, so make no changes.
    log.appendLog('METHOD_ENTRY', methodName + '|Preparing to update LTE device in OSS');
    if(!isTermination){ //If it's not a termiantion of service, don't update the device!
      log.appendLog('INFO', methodName + '|No updated to device are required. Termination: ' + isTermination);
      log.appendLog('METHOD_EXIT', methodName + '|No Update to LTE Device required');
      return returnObj;
    }
    try{
      //get device serial number from assetMap
      String deviceSN = assetMap.get('19-1027').Name;   //we update via device serial number (not Dome serial number)
      //GET group_id from /lte/organizations/{org_id}/groups
      LTEOSS_lte_organizations.Groups_list_wrapper groupsWrapper = LTEOSS_lte_organizations.getGroupByOrgId('defaul', deviceSN);
      if(groupsWrapper.groups.size() != 1){
        log.appendLog('METHOD_EXIT', methodName + '|OSS did not return one and only one Group ID for device: ' + deviceSN);
        log.appendLog('FATAL_ERROR', '|Could not isolate Group Id by device serial number');
        log.success = false;
        return returnObj;
      }
      Integer groupId = groupsWrapper.groups[0].Id;
      //GET /lte/devices/{org_id}/{group_id} for device Id
      LTEOSS_lte_devices.Devices_list_wrapper wrappedDevices = LTEOSS_lte_devices.getLTEDevices('defaul', groupId);
      if(wrappedDevices.devices.size() != 1){
        log.appendLog('METHOD_EXIT', methodName + '|OSS did not return one and only one Device ID for group: ' + groupId);
        log.appendLog('FATAL_ERROR', '|Could not isolate Device Id by Group Id');
        log.success = false;
        return returnObj;
      }
      Integer deviceId = wrappedDevices.devices[0].id;
      //PUT /lte/devices/{org_id}/{group_id}/{id} {"virtual_device_id": "<from assetMap>"}
      returnObj = LTEOSS_lte_devices.updateLTEDevice('defaul', groupId, deviceId, deviceSN);
      if(returnObj.response_code != 204){
        log.appendLog('METHOD_EXIT', methodName + '|OSS returned: ' + returnObj.response_code);
        log.appendLog('FATAL_ERROR', '|Could not update LTE Device in OSS');
        log.success = false;
        return returnObj;
      }
    } catch(Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|Exception caught: ' + e.getMessage());
      log.appendLog('FATAL_ERROR', 'Could not update LTE Device in OSS: ' +  + e.getLineNumber() + ' Message: ' + e.getMessage());
      log.createCase(e);  //use the system thrown exception as an input to the method
      log.success = false;
      return returnObj;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Successfully Updated LTE Device in OSS');
    return returnObj;
  }

  @testVisible private static LTEOSS_lte_subscribers restoreLTESubscriber(map<String, Asset> assetMap){
    String methodName = 'restoreLTESubscriber(map<String, Asset> assetMap)';
    log.appendLog('METHOD_ENTRY', methodName + '|Preparing to restore service to LTE Subscriber');
    LTEOSS_lte_subscribers returnObj = new LTEOSS_lte_subscribers();
    String iccid = assetMap.get('19-1035').Name;
    String subscriber_id = assetMap.get('Virtual Terminal ID').Name.left(8) + '-11';
    try{
      returnObj = LTEOSS_lte_subscribers.putLTESubscriberRestore(iccid, subscriber_id);
      if(returnObj.response_code != 204){
        log.appendLog('METHOD_EXIT', methodName + '|OSS returned: ' + returnObj.response_code);
        log.appendLog('FATAL_ERROR', '|Unable to restore LTE Service via OSS');
        log.success = false;
        return returnObj;
      }
    } catch(Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|Exception caught: ' + e.getMessage());
      log.appendLog('FATAL_ERROR', 'Could not restore LTE Service via OSS: ' + e.getStackTraceString());
      log.createCase(e);  //use the system thrown exception as an input to the method
      log.success = false;
      return returnObj;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Successfully restored service to LTE Subscriber');
    return returnObj;
  }

  @testVisible private static LTEOSS_lte_subscribers hibernateLTESubscriber(map<String, Asset> assetMap, Boolean isTermination){
    String methodName = 'hibernateLTESubscriber(map<String, Asset> assetMap, Boolean isTermination)';
    log.appendLog('METHOD_ENTRY', methodName + '|Preparing to hibernate LTE susbscriber. Termination: ' + isTermination);
    LTEOSS_lte_subscribers returnObj = new LTEOSS_lte_subscribers();
    String iccid = assetMap.get('19-1035').Name;
    String subscriber_id = '';
    if(!isTermination){ //subscriber_id attribute is required even if there is no change.
      subscriber_id = assetMap.get('Virtual Terminal ID').Name.left(8) + '-11';
    }
    try{
      returnObj = LTEOSS_lte_subscribers.putLTESubscriberHibernate(iccid, subscriber_id);
      if(returnObj.response_code != 204){
        log.appendLog('METHOD_EXIT', methodName + '|OSS returned: ' + returnObj.response_code);
        log.appendLog('FATAL_ERROR', '|Unable to hibernate LTE Service via OSS');
        log.success = false;
        return returnObj;
      }
    } catch(Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|Exception caught: ' + e.getMessage());
      log.appendLog('FATAL_ERROR', 'Could not hibernate LTE Service via OSS: ' + e.getStackTraceString());
      log.createCase(e);  //use the system thrown exception as an input to the method
      log.success = false;
      return returnObj;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Successfully hibernated LTE susbscriber. Termination: ' + isTermination);
    return returnObj;
  }

  @testVisible private static void validateAssetHierarchy(map<String, Asset> assetMap){
    String methodName = 'validateAssetHierarchy(map<String, Asset> assetMap)';
    log.appendLog('METHOD_ENTRY', methodName + '|Validating asset hierarchy');
    
    if(assetMap.containskey('Virtual Terminal ID')){
        log.appendLog('METHOD_EXIT', methodName + '|Error in asset hierarchy validation.');
        log.appendLog('FATAL_ERROR', 'validateAssetHierarchy failed. asset hierarchy contains Virtual Terminal ID');
        log.success = false;
        return;
    }
    Map<String,Asset_Hierarchy_Template__mdt> hierarchyTemplateMap = new Map<String,Asset_Hierarchy_Template__mdt>();
    for(Asset_Hierarchy_Template__mdt t : [SELECT Id, Product_Code__c, Parent__c, Root__c FROM Asset_Hierarchy_Template__mdt WHERE Root__c = '01-0419']){
        hierarchyTemplateMap.put(t.Product_Code__c,t);
    }
    Boolean FATAL_Error = false;
    for(Asset a : assetMap.values()){
        if(a.name == null){
            log.appendLog('METHOD_EXIT', methodName + '|Error in asset hierarchy validation.');
            log.appendLog('FATAL_ERROR', 'validateAssetHierarchy failed. asset '+ a.Id + ' name is blank');
            log.success = false;
            FATAL_Error = true;
            break;            
        }
        if(a.Product2.ProductCode == null){
            log.appendLog('METHOD_EXIT', methodName + '|Error in asset hierarchy validation.');
            log.appendLog('FATAL_ERROR', 'validateAssetHierarchy failed. asset '+ a.Id + ' does not have a Product Code reference.');
            log.success = false;
            FATAL_Error = true;
            break;           
        }
        system.debug('Template parent: ' + hierarchyTemplateMap.get(a.Product2.ProductCode).Parent__c + ' |  Asset Parent: ' + a.Parent_Asset__r.Product2.ProductCode);
        if(hierarchyTemplateMap.get(a.Product2.ProductCode).Parent__c != a.Parent_Asset__r.Product2.ProductCode){//HTSSF-695
            log.appendLog('METHOD_EXIT', methodName + '|Error in asset hierarchy validation.');
            log.appendLog('FATAL_ERROR', 'validateAssetHierarchy failed. asset '+ a.Id + ' hierarchy is not correct.');
            log.success = false;
            FATAL_Error = true;
            break;           
        }
    }
    if(FATAL_Error)
        return;
    //See HTSSF-611... validateAssetHierarchy
    log.appendLog('METHOD_EXIT', methodName + '|validateAssetHierarchy successfully completed.');
  }
  
  @testVisible private static Asset createVTIDAsset(HTS_Virtual_Terminal_ID__c claimedVTID, map<String, Asset> assetMap){
    String methodName = 'createVTIDAsset(HTS_Virtual_Terminal_ID__c claimedVTID, Asset rootAsset)';
    log.appendLog('METHOD_ENTRY', methodName + '|creating VTID Asset');
    try{
        Default_Identifier_Product__mdt deafultIdProduct = [Select Identifier_Product_reference__c,Legacy_Product_Id__c from Default_Identifier_Product__mdt where MasterLabel = 'Virtual Terminal Id'];
        Asset vtidAsset = new Asset();
        vtidAsset.Name = claimedVTID.Virtual_Terminal_Id__c + '-LTE';
        vtidAsset.SerialNumber = vtidAsset.Name;
        vtidAsset.Asset_ID__c = deafultIdProduct.Legacy_Product_Id__c + '_' + vtidAsset.Name;
        vtidAsset.Parent_Asset__c = assetMap.get('01-0419').Id;
        vtidAsset.Product2Id = deafultIdProduct.Identifier_Product_reference__c;           
        assetMap.put(deafultIdProduct.Legacy_Product_Id__c.removeEnd('_US'),vtidAsset);
        //See HTSSF-619... createVTIDAsset
        log.appendLog('METHOD_EXIT', methodName + '|createVTIDAsset successfully completed.');
        return vtidAsset;
    }catch(Exception e){
        log.appendLog('METHOD_EXIT', methodName + '|Exception caught: ' + e.getMessage());
        log.appendLog('FATAL_ERROR', 'Could not create VTIDAsset : ' + e.getStackTraceString());
        log.createCase(e);  //use the system thrown exception as an input to the method
        log.success = false;
        return null;
    }    
  }
  
  @testVisible private static void updateVTID(HTS_Virtual_Terminal_ID__c claimedVTID){
    String methodName = 'updateVTID(HTS_Virtual_Terminal_ID__c claimedVTID)';
    log.appendLog('METHOD_ENTRY', methodName + '|update the VTID');
    try{
      if(claimedVTID.Date_Issued__c == NULL){
        log.appendLog('METHOD_EXIT', methodName + '|Date issued is blank');
        log.appendLog('FATAL_ERROR', 'updateVTID failed. Date issued is blank');
        log.success = false;
        return;
      }
      if(claimedVTID.Virtual_Terminal_Id__c == NULL){
        log.appendLog('METHOD_EXIT', methodName + '|Virtual Terminal Id is blank');
        log.appendLog('FATAL_ERROR', 'updateVTID failed. Virtual Terminal Id is blank');
        log.success = false;
        return;
      }
      update claimedVTID;
      //See HTSSF-641... updateVTID
      log.appendLog('METHOD_EXIT', methodName + '|updateVTID successfully completed.');
    }catch(Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|Exception caught: ' + e.getMessage());
      log.appendLog('FATAL_ERROR', 'Could not update VTID : ' + e.getStackTraceString());
      log.createCase(e);  //use the system thrown exception as an input to the method
      log.success = false;        
    }
  }

  @testVisible private static void insertVTIDAsset(Asset vtidAsset){
    String methodName = 'insertVTIDAsset(map<String, Asset> assetMap)';
    log.appendLog('METHOD_ENTRY', methodName + '|Inserting VTID Asset');
    try{
      insert vtidAsset;
      log.appendLog('METHOD_EXIT', methodName + '|Successfully inserted ' + vtidAsset.Name);
    } catch(Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|Exception caught: ' + e.getMessage());
      log.appendLog('FATAL_ERROR', 'Insert of VTID Asset failed : ' + e.getStackTraceString());
      log.createCase(e);  //use the system thrown exception as an input to the method
      log.success = false;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Successfully inserted VTID Asset');
    return;
  }

  @testVisible private static void updateSubscription(SBQQ__Subscription__c cleanSubscription, Asset vtidAsset){
        String methodName = 'updateSubscription(SBQQ__Subscription__c cleanSubscription, map<String, Asset> assetMap)';
        log.appendLog('METHOD_ENTRY', methodName + '|update subscription');
        try{
            cleanSubscription.Asset__c = vtidAsset.Id;
            cleanSubscription.Traffic_Identifier__c = vtidAsset.Name.left(8) + '-11';
            update cleanSubscription;
            //See HTSSF-643... updateSubscription
            log.appendLog('METHOD_EXIT', methodName + '|update subscription successfully completed.');
        }Catch(Exception e){
            log.appendLog('METHOD_EXIT', methodName + '|Exception caught: ' + e.getMessage());
            log.appendLog('FATAL_ERROR', 'update subscription failed : ' + e.getStackTraceString());
            log.createCase(e);  //use the system thrown exception as an input to the method
            log.success = false;
        }
  }

  @testVisible private static Case updateCaseFields(SBQQ__Subscription__c cleanSubscription){
    String methodName = 'updateCaseFields(SBQQ__Subscription__c cleanSubscription)';
    Case cleanCase = new Case();
    log.appendLog('METHOD_ENTRY', methodName + '|Getting Case related to ' + cleanSubscription.Name + ' for updates ');
    //need to get the form related to the Contract
    list<LTE_activation__c> cleanForms = [SELECT Id, Name FROM LTE_activation__c WHERE Contract__c =: cleanSubscription.SBQQ__Contract__c];
    //should be only one
    if(cleanForms.size() != 1){ //Create a warning case
        log.appendLog('METHOD_EXIT', methodName + '|Unable to isolate Activation form related to ' + cleanSubscription.Name);
        log.appendLog('WARNING', 'Case Update failed. Activation form query returned ' + cleanForms.size() + ' forms!');
        Exception e = new NullPointerException();  //Create, but do not throw an exception as an input to the method
        log.createCase(e);  //use artificial exception to create case
        return null;
    }
    //need to get the Case now!
    try{
      list<Case> caseList = [SELECT Id, CaseNumber, RecordTypeId, Contract__r.Id, 
                                  LTE_Transform_Status__c, LTE_Provision_Status__c
                              FROM Case
                              WHERE LTE_activation__c =: cleanForms[0].Id];
      if(caseList.size() != 1){
        log.appendLog('METHOD_EXIT', methodName + '|Unable to isolate Case related to ' + cleanSubscription.Name);
        log.appendLog('WARNING', 'Case Update failed. Query returned ' + caseList.size() + ' cases!');
        Exception e = new NullPointerException();  //Create, but do not throw an exception as an input to the method
        log.createCase(e);  //use artificial exception to create case
        return null;
      }
      cleanCase = caseList[0];
      cleanCase.LTE_Provision_Status__c = 'Success';
      update cleanCase;
    } catch(Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|Error in Case query');
      log.appendLog('WARNING', 'Exception caught! '  + e.getLineNumber() + ' Message: ' + e.getMessage());
      log.success = false;
      return null;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Successfully updated Case: ' + cleanCase.CaseNumber);
    return cleanCase;
  }
  @testVisible private static void updateHibernatedSubscription(map<String, Asset> assetMap, Boolean isTermination, SBQQ__Subscription__c cleanSubscription){
    String methodName = 'updateHibernatedSubscription(map<String, Asset> assetMap, Boolean isTermination, SBQQ__Subscription__c cleanSubscription)';
    log.appendLog('METHOD_ENTRY', methodName + '|Preparing to update the Subscription');
    try{
      if(isTermination){ //we are terminating service!
        //need to move the VTID to the replaced Assets Account
        Asset retiredVTID = assetMap.get('Virtual Terminal ID');
        system.debug('Retired VTID: ' + retiredVTID);
        retiredVTID.Parent_Asset__c = null;
        //Need an Account reference for the Asset. Get it from the Custom Setting
        DefaultAccounts__c defAcct =  DefaultAccounts__c.getValues('ReplacedAssets');
        retiredVTID.AccountId = (Id)defAcct.Account_ID__c;
        update retiredVTID;
        //need to populate the SBQQ_TerminatedDate__c field with today's date
        cleanSubscription.SBQQ__TerminatedDate__c = Date.today();
        update cleanSubscription;
      } else {      //we are suspending service
        //Need more details from Airtime on what we want the end state to look like
        //Change subscription Product, populate suspended date
        //cleanSubscription.Suspended_Date__c = Date.today();
        //Need to grab that suspended Product 2 record
        //HTSSF_739
        //update cleanSubscription;
      }
    } catch(Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|Error updating Salesforce');
      log.appendLog('WARNING', 'Exception caught! '  + e.getLineNumber() + ' Message: ' + e.getMessage());
      log.success = false;
      return;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Subscription successfully updated');
    return;
  }
}