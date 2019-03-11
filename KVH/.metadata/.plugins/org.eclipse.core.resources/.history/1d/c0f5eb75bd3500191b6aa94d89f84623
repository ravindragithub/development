public with sharing class Service_provisionHTSHybrids {
  //Some of the common elements will migrate into Service_base
  public static serviceResults log {get; private set;}
  public static map<String, String> ipRanges {get; private set;}
  public static String ipBase {get; private set;}

  public Service_provisionHTSHybrids() {
    
  }
  static {
    log = new serviceResults();
    log.success = true;       //optimistic initialization....
    log.message = DateTime.now() + '\t' + 'SERVICE_INITIALIZATION\t' + 'Initializing HTS Hybrids Provisioning Service';
    ipRanges = new map<String, String>();
    ipRanges = getipRanges();
    ipBase = 'xxx.xxx.xxx.xxx';
  }
  public static serviceResults getLog(){
    return log;
  }
  //Main Method
  public static serviceResults provisionHybrid(list<SBQQ__Subscription__c> subsList){
    log.appendLog('METHOD_ENTRY', 'provisionHybrid(list<SBQQ__Subscription__c> subsList)|Begin provisioning process..');

    preProcessValidation(subsList);
    if(log.success == false){ return returnFatalError(); }
    list<SBQQ__Subscription__c> cleanSubs = getCleanSubs(subsList);
    if(log.success == false){ return returnFatalError(); }
    list<Asset> assetMoves = moveIdentifiersToChildOfRoot(cleanSubs[0].Asset__r.Name);
    if(log.success == false){ return returnFatalError(); }
    ipBase = getIPfromVTID(cleanSubs[0]);
    if(log.success == false){ return returnFatalError(); }
    map<String, HTSOSS_hts_subscribers> provisioningMap = getSubsMap(cleanSubs);
    if(log.success == false){ return returnFatalError(); }
    //need to update obj_ids via calls to OSS...

    list<HTSOSS_hts_subscribers> provisionedSubs = provisionTwoSubs(provisioningMap.values());
    if(log.success == false){ return returnFatalError(); }
    //delete enabled plan (if exists...)
    String cleanupResults = deleteEnabledTID(cleanSubs[0]);
    if(log.success == false){ return returnFatalError(); }
    //callouts done! Marshal SF data
    //update subs with termination dates
    list<SBQQ__Subscription__c> activatedSubs = applyActiveFlag(cleanSubs);
    if(log.success == false){ return returnFatalError(); }
    //commit changes to database
    //TODO: this block could become a method "updateSF(list<SBQQ_Subscription__c> updateSubs, list<Asset> updateAssets, String methodName)"
    //HTSSF-394
    try{
      update activatedSubs;
      log.appendLog('INFO', 'provisionHybrid(list<SBQQ__Subscription__c> subsList)|Successfully updated Subscriptions in Salesforce.');
      update assetMoves;
      log.appendLog('INFO', 'provisionHybrid(list<SBQQ__Subscription__c> subsList)|Successfully updated Assets in Salesforce.');
    } catch (exception e){
      log.appendLog('METHOD_EXIT', 'provisionHybrid(list<SBQQ__Subscription__c> subsList)|Exception caught: ' + e.getMessage());
      log.appendLog('FATAL_ERROR', 'Could not update records in Salesforce: ' + e.getStackTraceString());
      log.createCase(e);  //use the system thrown exception as an input to the method
      log.success = false;
    }
    if(log.success == false){ return returnFatalError(); }
    log.appendLog('METHOD_EXIT', 'provisionHybrid(list<SBQQ__Subscription__c> subsList)|Hybrid Plan Provisioning finished for: ' + cleanSubs[0].Traffic_Identifier__c + ' and ' + cleanSubs[1].Traffic_Identifier__c);
    if (log.success){
        if(log.srCase != null){
        log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
        insert log.srCase;
        log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
      }
      log.appendLog('SERVICE_FINISHED', 'SUCCESS: HTS Hybrids Provisioning Service completed successfully!');
    } else {
      return returnFatalError();
    }
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return log;
  } //PHEW!
  //Main Method 2
  public static serviceResults terminateHybrid(list<SBQQ__Subscription__c> subsList){
    log.appendLog('METHOD_ENTRY', 'terminateHybrid(list<SBQQ__Subscription__c> subsList)|Begin termination process..');
    preProcessValidation(subsList);
    if(log.success == false){ return returnFatalError(); }
    list<SBQQ__Subscription__c> cleanSubs = getCleanSubs(subsList);
    if(log.success == false){ return returnFatalError(); }
    list<Asset> assetMoves = retireIdentifiers(cleanSubs[0].Asset__r.Name);
    if(log.success == false){ return returnFatalError(); }
    //vacuum the I2CM out of the assetMoves list
    Asset I2CMAsset = new Asset();
    String baseProductCode = '02-2204';                                         //I2CM family... could probably read from CMT
    Pattern regex = Pattern.compile('[UuSs]?' + baseProductCode + '-0[123]');   //handle "U" and "S" parts 
    for(Integer i = 0; i < assetMoves.size(); i++){
      Matcher ma = regex.matcher(assetMoves[i].Product2.ProductCode); 
      if(ma.matches()){ //This is the I2CM!
        I2CMAsset = assetMoves.remove(i);
      }
    }
    //DEL OSS subscribers
    removeSubsFromOSS(cleanSubs);
    if(log.success == false){ return returnFatalError(); }
    //DEL OSS terminal
    deleteTerminal(cleanSubs[0].Asset__r.Name);
    if(log.success == false){ return returnFatalError(); }
    //callouts done! Marshal SF data
    //update subs with termination dates
    list<SBQQ__Subscription__c> terminatedSubs = applyTerminatedDate(cleanSubs);
    if(log.success == false){ return returnFatalError(); }
    //commit changes to database
    try{
      update terminatedSubs;
      log.appendLog('INFO', 'terminateHybrid(list<SBQQ__Subscription__c> subsList)|Successfully updated Subscriptions in Salesforce.');
      update assetMoves;
      log.appendLog('INFO', 'terminateHybrid(list<SBQQ__Subscription__c> subsList)|Successfully updated Assets in Salesforce.');
    } catch (exception e){
      log.appendLog('METHOD_EXIT', 'terminateHybrid(list<SBQQ__Subscription__c> subsList)|Exception caught: ' + e.getMessage());
      log.appendLog('FATAL_ERROR', 'Could not update records in Salesforce: ' + e.getStackTraceString());
      log.createCase(e);  //use the system thrown exception as an input to the method
      log.success = false;
    }
    if(log.success == false){ return returnFatalError(); }
    
    //Invoke Asynch job to make removed/old item testable again here.
    Id jobID = enqueueIdentifiersJob(I2CMAsset); //need to obtain the I2CM record ID to pass to job...
    if(log.success == false){ return returnFatalError(); }

    log.appendLog('METHOD_EXIT', 'provisionHybrid(list<SBQQ__Subscription__c> subsList)|Hybrid Plan Termination finished for: ' + cleanSubs[0].Traffic_Identifier__c + ' and ' + cleanSubs[1].Traffic_Identifier__c);
    if (log.success){
      if(log.srCase != null){
        log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
        insert log.srCase;
        log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
      }
      log.appendLog('INFO', 'terminateHybrid(list<SBQQ__Subscription__c> subsList)|Consumed ' + Limits.getQueries() + ' SOQL queries.');
      log.appendLog('SERVICE_FINISHED', 'SUCCESS: HTS Hybrids Termination Service completed successfully!');
    } else {
      return returnFatalError();
    }
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return log;
  }
  //Main Method 3
  public static serviceResults convertHybrid(list<SBQQ__Subscription__c> subsList){
    log.appendLog('METHOD_ENTRY', 'convertHybrid(list<SBQQ__Subscription__c> subsList)|Begin termination process..');
    preProcessValidation(subsList);
    if(log.success == false){ return returnFatalError(); }
    list<SBQQ__Subscription__c> cleanSubs = getCleanSubs(subsList);
    if(log.success == false){ return returnFatalError(); }
    //collect that base IP address!
    ipBase = getIPfromVTID(cleanSubs[0]);
    if(log.success == false){ return returnFatalError(); }
    //DEL OSS subscribers
    removeSubsFromOSS(cleanSubs);
    if(log.success == false){ return returnFatalError(); }
    //setup hybrid mapping (2 * /25s....)
    map<String, HTSOSS_hts_subscribers> provisioningMap = getSubsMap(cleanSubs);
    if(log.success == false){ return returnFatalError(); }
    //re-provision OSS subscribers
    list<HTSOSS_hts_subscribers> provisionedSubs = provisionTwoSubs(provisioningMap.values());
    if(log.success == false){ return returnFatalError(); }
    log.appendLog('METHOD_EXIT', 'convertHybrid(list<SBQQ__Subscription__c> subsList)|Hybrid Plan conversion finished for: ' + cleanSubs[0].Traffic_Identifier__c + ' and ' + cleanSubs[1].Traffic_Identifier__c);
    if (log.success){
      if(log.srCase != null){
        log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
        insert log.srCase;
        log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
      }
      log.appendLog('SERVICE_FINISHED', 'SUCCESS: HTS Hybrids Conversion Service completed successfully!');
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
      ex.setMessage('Fatal Error in Service_provisionHTSHybrids Class');
      log.createCase(ex);
    }
    log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
    insert log.srCase;
    log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
    log.appendLog('SERVICE_FINISHED', 'ERROR: HTS Hybrid Plans Service failed to complete successfully. See log for details.');
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return log;
  }
  public static map<String, String> getipRanges(){
    log.appendLog('METHOD_ENTRY', 'getipRanges()|Reading IP provisioning ranges from Custom Metadata Type');
    map<String, String> returnMap = new map<String, String>();
    Integer i = 0;
    for(HTS_Hybrid_Plan_IP_Ranges__mdt r : [SELECT DeveloperName, CIDR_range__c
                                            FROM HTS_Hybrid_Plan_IP_Ranges__mdt]){
      returnMap.put(r.DeveloperName, r.CIDR_range__c);
      i++;
    }
    log.appendLog('METHOD_EXIT', 'getipRanges()|Read ' + i + ' IP provisioning ranges from Custom Metadata Type');
    return returnMap;
  }
  @testVisible private static void preProcessValidation(list<SBQQ__Subscription__c> subsList){
    log.appendLog('METHOD_ENTRY', 'preProcessValidation(list<SBQQ__Subscription__c> subsList)|Validating subscriptions submitted');
    //Check that there are two and only two subs..
    if(subsList.size() != 2){
      log.appendLog('METHOD_EXIT', 'preProcessValidation(list<SBQQ__Subscription__c> subsList)|Service requires two and only two Subscriptions!');
      log.appendLog('FATAL_ERROR', subsList.size() + ' Subscriptions submitted');
      log.success = false;
      return;
    }
    if(subsList[0].Id == null || subsList[1].Id == null){
      log.appendLog('METHOD_EXIT', 'preProcessValidation(list<SBQQ__Subscription__c> subsList)|Service requires two and only two Subscriptions!');
      log.appendLog('FATAL_ERROR', 'One or both Subscriptions missing Record Id');
      log.success = false;
      return;
    }
    log.appendLog('METHOD_EXIT', 'preProcessValidation(list<SBQQ__Subscription__c> subsList)|Validation of subscriptions submitted complete');
    return;
  }
  @testVisible private static list<SBQQ__Subscription__c> getCleanSubs(list<SBQQ__Subscription__c> subsList){
    list<SBQQ__Subscription__c> returnList = new list<SBQQ__Subscription__c>();
    log.appendLog('METHOD_ENTRY', 'getCleanSubs(list<SBQQ__Subscription__c> subsList)|Getting Clean copy of Subscriptions');
    returnList = [SELECT Asset__r.Name, Asset__r.Parent_Asset__c, Asset__r.Parent_Asset__r.Id,
                         Asset__r.Product2.ProductCode, Asset__c, Asset__r.Account.RecordType.DeveloperName,
                         Traffic_Identifier__c, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                  FROM SBQQ__Subscription__c WHERE Id in: subsList];
    if(returnList.size() != 2){
      log.appendLog('METHOD_EXIT', 'getCleanSubs(list<SBQQ__Subscription__c> subsList)|Service requires two and only two Subscriptions!');
      log.appendLog('FATAL_ERROR', 'Query for Clean Subscriptions returned ' + returnList.size() + ' Should be two and only two!');
      log.success = false;
      return returnList;
    }
    if(returnList[0].SBQQ__Product__r.HTS_Subscriber_Plan__r.Name == null || returnList[1].SBQQ__Product__r.HTS_Subscriber_Plan__r.Name == null){
      log.appendLog('METHOD_EXIT', 'getCleanSubs(list<SBQQ__Subscription__c> subsList)|One or Both Subscription Products are missing the Shaping Policy!');
      log.appendLog('FATAL_ERROR', 'Query for Clean Subscriptions returned non HTS Hybrid services!');
      log.success = false;
      return returnList;
    }
    if(returnList[0].Traffic_Identifier__c == null || returnList[1].Traffic_Identifier__c == null){
      log.appendLog('METHOD_EXIT', 'getCleanSubs(list<SBQQ__Subscription__c> subsList)|One or Both Subscriptions are missing the Traffic Identifier!');
      log.appendLog('FATAL_ERROR', 'Query for Clean Subscriptions returned non HTS Hybrid services!');
      log.success = false;
      return returnList;
    }
    if(returnList[0].Asset__c != returnList[1].Asset__c){
      log.appendLog('METHOD_EXIT', 'getCleanSubs(list<SBQQ__Subscription__c> subsList)|Both Subscription must have the Same Asset!');
      log.appendLog('FATAL_ERROR', 'Clean Subscriptions returned min-matched Assets!');
      log.success = false;
      return returnList;
    }
    if(returnList[0].Asset__r.Account.RecordType.DeveloperName.left(9) != 'Platform_'){
      log.appendLog('METHOD_EXIT', 'getCleanSubs(list<SBQQ__Subscription__c> subsList)|Assets must be related to Platforms!');
      log.appendLog('FATAL_ERROR', 'Clean Subscriptions detected Asset not related to Platform!');
      log.success = false;
      return returnList;
    }
    log.appendLog('METHOD_EXIT', 'getCleanSubs(list<SBQQ__Subscription__c> subsList)|Two Clean Subscriptions');
    return returnList;
  }
  @testVisible private static map<String, HTSOSS_hts_subscribers> getSubsMap(list<SBQQ__Subscription__c> cleanSubs){
    map<String, HTSOSS_hts_subscribers> returnMap = new map<String, HTSOSS_hts_subscribers>();
    Boolean primaryFound = false;
    Boolean secondaryFound = false;
    log.appendLog('METHOD_ENTRY', 'getSubsMap(list<SBQQ__Subscription__c> cleanSubs)|Setting up Traffic Identifier Map');
    log.appendLog('INFO', 'getSubsMap(list<SBQQ__Subscription__c> cleanSubs)|Processing ' + cleanSubs.size() + ' subscriptions');
    for(SBQQ__Subscription__c s : cleanSubs){
      if(s.Traffic_Identifier__c.right(3) == '-01'){        //so-called Primary, big map
        log.appendLog('INFO', 'getSubsMap(list<SBQQ__Subscription__c> cleanSubs)|Primary Traffic Identifier detected');
        primaryFound = true;
        HTSOSS_hts_subscribers sub01 = new HTSOSS_hts_subscribers();
        sub01.subscriber_id = s.Traffic_Identifier__c;
        sub01.subscriber_plan_id = s.SBQQ__Product__r.HTS_Subscriber_Plan__r.Name;
        sub01.subscriber_ip_addresses = new list<String>();
        String ipThreeOctets = ipBase.substringBeforeLast('.') + '.';
        sub01.subscriber_ip_addresses.add(ipThreeOctets + ipRanges.get('Top_V2').substringAfterLast('.'));
        returnMap.put('highSpeed', sub01);
      } else if(s.Traffic_Identifier__c.right(3) == '-02'){ //so-called Secondary, smaller map
        log.appendLog('INFO', 'getSubsMap(list<SBQQ__Subscription__c> cleanSubs)|Secondary Traffic Identifier detected');
        secondaryFound = true;
        HTSOSS_hts_subscribers sub02 = new HTSOSS_hts_subscribers();
        sub02.subscriber_id = s.Traffic_Identifier__c;
        sub02.subscriber_plan_id = s.SBQQ__Product__r.HTS_Subscriber_Plan__r.Name;
        sub02.subscriber_ip_addresses = new list<String>();
        String ipThreeOctets = ipBase.substringBeforeLast('.') + '.';
        sub02.subscriber_ip_addresses.add(ipThreeOctets + ipRanges.get('Bottom_V2').substringAfterLast('.'));
         returnMap.put('unLimited', sub02);
      } else {
        //Traffic Identifier wierdness!
        log.appendLog('METHOD_EXIT', 'getSubsMap(list<SBQQ__Subscription__c> cleanSubs)|Traffic Identifier Error detected! Check BOTH subscriptions');
        log.appendLog('FATAL_ERROR', 'One Traffic Identifier needs to end with -01, the other with -02');
        log.success = false;
        return returnMap;
      }
    } //end of FOR loop...
    if(!(primaryFound && secondaryFound)){  // we did not get the right Traffic Identifiers!! Both -01??
      //Traffic Identifier wierdness... should never get here...
      log.appendLog('METHOD_EXIT', 'getSubsMap(list<SBQQ__Subscription__c> cleanSubs)|Unable to distinguish Primary and Secondary Plans, Check BOTH subscriptions');
      log.appendLog('FATAL_ERROR', 'One Traffic Identifier needs to end with -01, the other with -02');
      log.success = false;
      return returnMap;
    }
    log.appendLog('METHOD_EXIT', 'getSubsMap(list<SBQQ__Subscription__c> cleanSubs)|Traffic Identifier Map complete');
    return returnMap;
  }
  @testVisible private static String getIPfromVTID(SBQQ__Subscription__c sub){
    String returnString ='Initializing...';
    system.debug(sub);
    Id parentAsset = sub.Asset__r.Parent_Asset__r.Id;
    system.debug('ID: ' + parentAsset);
    log.appendLog('METHOD_ENTRY', 'getIPfromVTID(String VTID)|Getting HTS IP Address range for the Virtual Terminal Id');
    list<Asset> readList = [SELECT Name FROM Asset 
                             WHERE Parent_Asset__c =: parentAsset
                             AND Product2.ProductCode = 'HTS IP Address'];
    //check sizes...
    if(readList.size() != 1){
      log.appendLog('METHOD_EXIT', 'getIPfromVTID(String VTID)|Query returned ' + readList.size() + ' IP Addresses!');
      log.appendLog('FATAL_ERROR', 'There should be one and only one HTS IP Address!');
      log.success = false;
      return returnString;
    } else {
      returnString = readList[0].Name;
    }
    log.appendLog('METHOD_EXIT', 'getIPfromVTID(String VTID)|Returning ' + returnString + ' from Asset Hierarchy');
    return returnString;
  }
  @testVisible private static list<HTSOSS_hts_subscribers> provisionTwoSubs(list<HTSOSS_hts_subscribers> subsList){
    log.appendLog('METHOD_ENTRY', 'provisionTwoSubs(list<HTSOSS_hts_subscribers> subsList)|');
    list<HTSOSS_hts_subscribers> returnList = new list<HTSOSS_hts_subscribers>();
    integer i = 0;
    for(HTSOSS_hts_subscribers sub : subsList){
      try{
        returnList.add(sub.postSubscriber(sub));
        if(sub.response_code != 201){
          log.appendLog('INFO', 'provisionTwoSubs(list<HTSOSS_hts_subscribers> subsList)|Successfully POSTed ' + i + ' Subscribers to OSS!');
          log.appendLog('METHOD_EXIT', 'provisionTwoSubs(list<HTSOSS_hts_subscribers> subsList)|ERROR: OSS returned ' + sub.response_code);
          log.appendLog('FATAL_ERROR', 'Cound not POST Subscriber: ' + sub.subscriber_id + ' to OSS!');
          log.success = false;
          return returnList;
        }
        i++;    // a successful POST!
      } catch(exception e){
        log.appendLog('INFO', 'provisionTwoSubs(list<HTSOSS_hts_subscribers> subsList)|Successfully POSTed' + i + ' Subscribers to OSS!');
        log.appendLog('METHOD_EXIT', 'provisionTwoSubs(list<HTSOSS_hts_subscribers> subsList)|Exception caught: ' + e.getMessage());
        log.appendLog('FATAL_ERROR', 'Could not create Subscriber in OSS: ' + e.getStackTraceString());
        log.createCase(e);  //use the system thrown exception as an input to the method
        log.success = false;
        return returnList;
      }
    }
    log.appendLog('METHOD_EXIT', 'provisionTwoSubs(list<HTSOSS_hts_subscribers> subsList)|Successfully POSTed ' + i + ' Subscribers to OSS!');
    return returnList;
  }
  @testVisible private static String deleteEnabledTID(SBQQ__Subscription__c payableSub){
    //Need to delete the xxxxxxxx-00 subscriber from OSS, use one of the real subs for reference
    String returnString = 'Initializing...';
    log.appendLog('METHOD_ENTRY', 'deleteEnabledTID(SBQQ__Subscription__c payableSub)|Based on: ' + payableSub.Traffic_Identifier__c);
    string enabledTID = payableSub.Traffic_Identifier__c.left(8) + '-00';
    HTSOSS_hts_subscribers objToDel = new HTSOSS_hts_subscribers();
    //get filtered list from OSS
    //TRY
    HTSOSS_hts_subscribers.subscribers_list_wrapper ossList = objToDel.getSubscribersList(null, enabledTID);
    //should be only one!
    system.debug(ossList.subscribers_list);
    integer size = ossList.subscribers_list.size();
    if(size == 0){
      system.debug('Found zero: ' + size);
      returnString = 'Failed to find ' + enabledTID + ' in OSS /subscribers!';
      log.appendLog('WARNING', 'deleteEnabledTID(SBQQ__Subscription__c payableSub)|Unexpected Behavior, Failed to Find: ' + enabledTID + ' in OSS!');
      log.appendLog('METHOD_EXIT', 'deleteEnabledTID(SBQQ__Subscription__c payableSub)|Failed to delete: ' + enabledTID + ' from OSS!');
      Exception ex = new NoDataFoundException();  //Create, but do not throw an exception as an input to the method
      ex.setMessage('Unexpected behavior in Service_provisionHTSHybrids Class');
      log.createCase(ex);
      return returnString;
    } else if(size > 1){
      system.debug('Found more than one: ' + size);
      returnString = 'Found multiple instances of ' + enabledTID + ' in OSS /subscribers!';
      log.appendLog('WARNING', 'deleteEnabledTID(SBQQ__Subscription__c payableSub)|Unexpected Behavior, Found multiple instances of: ' + enabledTID + ' in OSS!');
      log.appendLog('METHOD_EXIT', 'deleteEnabledTID(SBQQ__Subscription__c payableSub)|Failed to delete: ' + enabledTID + ' from OSS!');
      Exception ex = new NoDataFoundException();  //Create, but do not throw an exception as an input to the method
      ex.setMessage('Unexpected behavior in Service_provisionHTSHybrids Class');
      log.createCase(ex);
      return returnString;
    }

    system.debug('Found one and only one: ' + size);
    HTSOSS_hts_subscribers subToDelete = new HTSOSS_hts_subscribers();
    subToDelete.obj_id = ossList.subscribers_list[0].obj_id;
    subToDelete = subToDelete.deleteSubscriber(subToDelete);
    if(subToDelete.response_code != 204){ //Callout Failed....
      returnString = 'OSS error related to: ' + enabledTID ;
      log.appendLog('WARNING', 'deleteEnabledTID(SBQQ__Subscription__c payableSub)|Unexpected Behavior, OSS returned ' + subToDelete.response_code);
      log.appendLog('METHOD_EXIT', 'deleteEnabledTID(SBQQ__Subscription__c payableSub)|Failed to delete: ' + enabledTID + ' from OSS!');
      Exception ex = new NoDataFoundException();  //Create, but do not throw an exception as an input to the method
      ex.setMessage('Unexpected behavior in Service_provisionHTSHybrids Class');
      log.createCase(ex);
      return returnString;
    }
    returnString = 'Successfully Deleted: ' + enabledTID + ' from OSS!';
    log.appendLog('METHOD_EXIT', 'deleteEnabledTID(SBQQ__Subscription__c payableSub)|Successfully Deleted: ' + enabledTID + ' from OSS!');
    return returnString;

  }
  @testVisible private static list<Asset> moveIdentifiersToChildOfRoot(string VTID){
    log.appendLog('METHOD_ENTRY', 'moveIdentifiersToChildOfRoot(string VTID)|Using Virtual Terminal Id: ' + VTID);
    //Need to compare the Parents vs. Root Assets of the VTID and IP 
    HTS_ltgsvc_diagnostics diagObj = HTS_ltgsvc_diagnostics.getSystemStatus(VTID);
    list<Asset> assetList = diagObj.systemCollection;
    list<Asset> updateList = new list<Asset>();
    for(Asset a : assetList){
      //Loop through Assets, looking for VTID and HTS IP
      if(a.Product2.ProductCode == 'HTS IP Address' || a.Product2.ProductCode == 'Virtual Terminal ID'){
        //Figure out if Asset is NOT child of root
        if(a.Root_Asset__c != a.Parent_Asset__c){
          //Move it!
          a.Parent_Asset__c = a.Root_Asset__c;
          system.debug('Asset detail: ' + a.Parent_Asset__c +' | '+ a.Root_Asset__c);
          updateList.add(a);
        } 
      }
    }
    log.appendLog('METHOD_EXIT', 'moveIdentifiersToChildOfRoot(string VTID)|Returning updated Asset List');
    return updateList;
  }
  @testVisible private static list<SBQQ__Subscription__c> applyActiveFlag(list<SBQQ__Subscription__c> subsList){
    log.appendLog('METHOD_ENTRY', 'applyActiveFlag(list<SBQQ__Subscription__c subsList)|Preparing to apply Active Flag to ' + subsList.size() + ' Subscriptions');
    for(SBQQ__Subscription__c s : subslist){
      s.Status__c = 'Active';
    }
    log.appendLog('METHOD_EXIT', 'applyActiveFlag(list<SBQQ__Subscription__c subsList)|Applied Active Flag to ' + subsList.size() + ' Subscriptions');
    return subslist;
  }
  /****************************************
   * DEPROVISIONING specific methods      *
   ****************************************/
  @testVisible private static list<Asset> retireIdentifiers(string VTID){
    log.appendLog('METHOD_ENTRY', 'retireIdentifiers(string VTID)|Using Virtual Terminal Id: ' + VTID);
    //Need to compare the Parents vs. Root Assets of the VTID and IP 
    HTS_ltgsvc_diagnostics diagObj = HTS_ltgsvc_diagnostics.getSystemStatus(VTID);
    list<Asset> assetList = diagObj.systemCollection;
    list<Asset> updateList = new list<Asset>();
    DefaultAccounts__c defaultAssets = DefaultAccounts__c.getInstance('DefaultAssets');
    //get AccountId from Custom Setting....
    String baseProductCode = '02-2204';                                         //I2CM family... could probably read from CMT
    Pattern regex = Pattern.compile('[UuSs]?' + baseProductCode + '-0[123]');   //regex to handle "U" and "S" parts
    for(Asset a : assetList){
      //Loop through Assets, looking for VTID and HTS IP
      Matcher ma = regex.matcher(a.Product2.ProductCode);               //compare input Asset ProductCode to regex
      if(a.Product2.ProductCode == 'HTS IP Address' || a.Product2.ProductCode == 'Virtual Terminal ID'){
        //Move it!
        a.Parent_Asset__c = null;
        a.AccountId = (Id)defaultAssets.Account_ID__c;
        system.debug('Asset detail: ' + a.Parent_Asset__c +' | '+ a.AccountId);
        updateList.add(a);
      } else if(ma.matches()){  //it's the I2CM!!
        updateList.add(a);
      }
    }
    log.appendLog('METHOD_EXIT', 'retireIdentifiers(string VTID)|Returning updated Asset List');
    return updateList;
  }
  @testVisible private static void removeSubsFromOSS(list<SBQQ__Subscription__c> subslist){
    log.appendLog('METHOD_ENTRY', 'removeSubsFromOSS(list<SBQQ__Subscription__c> subslist)|');
    integer i = 0;
    for(SBQQ__Subscription__c sub : subsList){
      try{
        //get subscribers obj_id using traffic ID
        HTSOSS_hts_subscribers oneSub = new HTSOSS_hts_subscribers();
        HTSOSS_hts_subscribers.subscribers_list_wrapper OSSsubs = new HTSOSS_hts_subscribers.subscribers_list_wrapper(); 
        OSSsubs = oneSub.getSubscribersList(null, sub.Traffic_Identifier__c);
        if(OSSsubs.subscribers_list.size() != 1){  // duplicate Traffic IDs.. .fatal error
          log.appendLog('METHOD_EXIT', 'removeSubsFromOSS(list<SBQQ__Subscription__c> subslist)|Found ' + OSSsubs.subscribers_list.size() + ' Terminals named: ' + sub.Traffic_Identifier__c);
          log.appendLog('FATAL_ERROR', OSSsubs.subscribers_list.size() + ' Terminals found in OSS!');
          log.success = false;
          return;
        }
        //delete Subscriber
        oneSub = oneSub.deleteSubscriber(OSSsubs.subscribers_list[0]);
        if(oneSub.response_code == 204){  
          log.appendLog('INFO', 'removeSubsFromOSS(list<SBQQ__Subscription__c> subslist)|Successfully DELETE-ed subscriber ' + oneSub.subscriber_id + ' from OSS!');
          i++;    //a successful DELETE!
        } else if(oneSub.response_code == 404 || oneSub.response_code == 500){ //sub not found!!
          log.appendLog('METHOD_EXIT', 'removeSubsFromOSS(list<SBQQ__Subscription__c> subslist)|ERROR: OSS returned ' + oneSub.response_code);
          log.appendLog('FATAL_ERROR', 'Cound not DELETE Subscriber: ' + oneSub.subscriber_id + ' from OSS!');
          log.success = false;
        }  else { //should never get here
          log.appendLog('METHOD_EXIT', 'removeSubsFromOSS(list<SBQQ__Subscription__c> subslist)|An Unexpected Error has Occurred ' + oneSub.response_code + ' returned from OSS!');
          log.appendLog('FATAL_ERROR', 'Cound not DELETE Subscriber: ' + oneSub.subscriber_id + ' from OSS!');
          log.success = false;
        }
      } catch(exception e){
        log.appendLog('INFO', 'removeSubsFromOSS(list<SBQQ__Subscription__c> subslist)|Successfully DELETE-ed ' + i + ' Subscribers from OSS!');
        log.appendLog('METHOD_EXIT', 'removeSubsFromOSS(list<SBQQ__Subscription__c> subslist)|Exception caught: ' + e.getMessage());
        log.appendLog('FATAL_ERROR', 'Could not delete Subscriber from OSS: ' + e.getStackTraceString());
        log.createCase(e);  //use the system thrown exception as an input to the method
        log.success = false;
        return;
      }
    }
    log.appendLog('INFO', 'removeSubsFromOSS(list<SBQQ__Subscription__c> subslist)|Successfully DELETE-ed ' + i + ' Subscribers from OSS!');
    log.appendLog('METHOD_EXIT', 'removeSubsFromOSS(list<SBQQ__Subscription__c> subslist)|');
    return;
  }
  @testVisible private static void deleteTerminal(string VTID){
    log.appendLog('METHOD_ENTRY', 'deleteTerminal(string VTID)|With input parameter: ' + VTID);
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals.terminals_list_wrapper terminalList = new HTSOSS_hts_terminals.terminals_list_wrapper();
    try{
      terminalList = term1.getTerminals(null, VTID, null);
      //Get the list of (One) Terminals
      if(terminalList.terminals_list.size() != 1){    //verify only ONE!
        log.appendLog('METHOD_EXIT', 'deleteTerminal(string VTID)|Failed to find one and only one Terminal in OSS!');
        log.appendLog('FATAL_ERROR', terminalList.terminals_list.size() + ' Terminals found in OSS!');
        log.success = false;
        return;
      }
      term1.obj_id = terminalList.terminals_list[0].obj_id;
      term1.obj_revision = terminalList.terminals_list[0].obj_revision;
      term1.is_active = false;
      //Put the one Terminal off-line
      term1 = term1.putTerminal(term1);
      if(term1.response_code != 204){   //TODO: handle 404 and 500 seperately...
        log.appendLog('INFO', 'deleteTerminal(string VTID)|Unable to PUT inactive state to Terminal: ' + term1);
        log.appendLog('METHOD_EXIT', 'deleteTerminal(string VTID)|Unable to PUT inactive state to Terminal: ' + term1);
        log.appendLog('FATAL_ERROR', 'Could not PUT Terminal to inactive state!');
        log.success = false;
        return;
      }
      //Then delete it!
      term1 = term1.deleteTerminal(term1);
      if(term1.response_code != 204){   //TODO: handle 404 and 500 seperately...
        log.appendLog('INFO', 'deleteTerminal(string VTID)|Unable to DELETE Terminal: ' + term1);
        log.appendLog('METHOD_EXIT', 'deleteTerminal(string VTID)|Unable to DELETE Terminal: ' + term1);
        log.appendLog('FATAL_ERROR', 'Could not DELETE Terminal!');
        log.success = false;
        return;
      }
      log.appendLog('INFO', 'deleteTerminal(string VTID)|Successfully DELETE-ed Terminal: ' + term1);
    } catch(exception e){
      log.appendLog('INFO', 'deleteTerminal(string VTID)|Failed to  DELETE ' + VTID + ' from OSS!');
      log.appendLog('METHOD_EXIT', 'deleteTerminal(string VTID)|Exception caught: ' + e.getMessage());
      log.appendLog('FATAL_ERROR', 'Could not delete Subscriber from OSS: ' + e.getStackTraceString());
      log.createCase(e);  //use the system thrown exception as an input to the method
      log.success = false;
      return;
    }
    log.appendLog('METHOD_EXIT', 'deleteTerminal(string VTID)|Successfully DELETE-ed Terminal Named: ' + VTID);
    return;
  }
  @testVisible private static list<SBQQ__Subscription__c> applyTerminatedDate(list<SBQQ__Subscription__c> subsList){
    log.appendLog('METHOD_ENTRY', 'applyTerminatedDate(list<SBQQ__Subscription__c subsList)|Preparing to apply Date Terminated to ' + subsList.size() + ' Subscriptions');
    for(SBQQ__Subscription__c s : subslist){
      s.SBQQ__TerminatedDate__c = date.today();
    }
    log.appendLog('METHOD_EXIT', 'applyTerminatedDate(list<SBQQ__Subscription__c subsList)|Applied Date Terminated to ' + subsList.size() + ' Subscriptions');
    return subslist;
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