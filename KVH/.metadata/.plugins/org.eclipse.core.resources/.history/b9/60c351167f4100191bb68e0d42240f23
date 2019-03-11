public with sharing class Service_staticIP {
  //Some of the common elements will migrate into Service_base
  public static serviceResults log {get; private set;}
  public static Case warningCase {get; private set;}

  public Service_staticIP() {
    
  }
  static {
    log = new serviceResults();
    log.success = true;       //optimistic initialization....
    log.message = DateTime.now() + '\t' + 'SERVICE_INITIALIZATION\t' + 'Initializing HTS Static IP Management Service';

  }
  public static serviceResults getLog(){
    return log;
  }
  public static Case getWarningCase(){
    return warningCase;
  }
  //Main Method
  public static serviceResults provisionStaticIP(SBQQ__Subscription__c parentSub){
    String methodName = 'provisionStaticIP(SBQQ__Subscription__c parentSub)';
    log.appendLog('METHOD_ENTRY', methodName + '|Begin HTS Static IP Provisioning process..');

    preProcessValidation(parentSub);
    if(log.success == false){ return returnFatalError(); }
    SBQQ__Subscription__c cleanSub = getCleanSub(parentSub);
    if(log.success == false){ return returnFatalError(); }
    Integer dataChannel = getDataChannel(cleanSub);
    if(log.success == false){ return returnFatalError(); }
    HTSOSS_hts_terminals activeTerminal = getActiveTerminal(cleanSub.Asset__r.Name);
    if(log.success == false){ return returnFatalError(); }
    Boolean isEnabled = getDataChannelStatus(dataChannel, activeTerminal);
    if(log.success == false){ return returnFatalError(); }
    if(!isEnabled){
      updateDataChannel(dataChannel, activeTerminal, true);
      if(log.success == false){ return returnFatalError(); }
    }
    HTSOSS_hts_terminals_staticips.staticip_list_wrapper existingStatics = getExistingStatics(activeTerminal);
    if(log.success == false){ return returnFatalError(); }
    String privateIP = getNextPrivateIP(dataChannel, activeTerminal, existingStatics.staticip_list);
    if(log.success == false){ return returnFatalError(); }
    HTS_Static_IPs__c publicIP = getPublicStaticIp(dataChannel, activeTerminal.template_id.substringBefore('_'));
    if(log.success == false){ return returnFatalError(); }
    //POST Static IP to OSS,,
    HTSOSS_hts_terminals_staticips postedStaticIP = postStaticIP(dataChannel, activeTerminal, publicIP.Name, privateIP);
    if(log.success == false){ return returnFatalError(); }
    //Callouts finished!! Maybe it's warnings from here on out.....
    publicIP = updateSFStaticIP(publicIP, privateIP);
    if(log.success == false){ return returnFatalError(); }
    //Create and insert Asset
    Asset toBeCloned = new Asset(id = cleanSub.Asset__c, 
                                 ParentId = cleanSub.Asset__r.ParentId ,
                                 Parent_Asset__c = cleanSub.Asset__r.Parent_Asset__c );
    Asset gsipAsset = createAsset(toBeCloned, postedStaticIP);
    if(log.success == false){ return returnFatalError(); }
    //Create and insert Subscription
    SBQQ__Subscription__c gsipSub = createSubscription(cleanSub, gsipAsset);
    if(log.success == false){ return returnFatalError(); }
    //Wrap it all up!

    log.appendLog('METHOD_EXIT', methodName + '|HTS Static IP Provisioning process finished for: ' + cleanSub.Traffic_Identifier__c);
    if (log.success){
      if(log.srCase != null){
        log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
        insert log.srCase;
        log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
      }
      log.appendLog('SERVICE_FINISHED', 'SUCCESS: HTS Hybrids Static IP Service completed successfully!');
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
      ex.setMessage('Fatal Error in Service_staticIP Class');
      log.createCase(ex);
    }
    log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
    insert log.srCase;
    log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
    log.appendLog('SERVICE_FINISHED', 'ERROR: HTS Static IP Management Service failed to complete successfully. See log for details.');
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return log;
  }
  @testVisible private static void preProcessValidation(SBQQ__Subscription__c parentSub){
    String methodName = 'preProcessValidation(SBQQ__Subscription__c parentSub)';
    log.appendLog('METHOD_ENTRY', methodName + '|Validating subscription submitted');
    //Check that sub has record ID ..
    if(parentSub.id == null){
      log.appendLog('METHOD_EXIT', methodName + '|Record Id for input Subscription not found!');
      log.appendLog('FATAL_ERROR', 'Pre-process validation failed. Database query inhibited');
      log.success = false;
      return;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Validation of subscription submitted complete');
    return;
  }
  @testVisible private static SBQQ__Subscription__c getCleanSub(SBQQ__Subscription__c parentSub){
    String methodName = 'getCleanSub(SBQQ__Subscription__c parentSub)';
    list<SBQQ__Subscription__c> readList = new list<SBQQ__Subscription__c>();
    log.appendLog('METHOD_ENTRY', methodName + '|Getting Clean copy of Subscription');
    readList = [SELECT Name, Asset__r.Name, Asset__r.Parent_Asset__c, Asset__r.Parent_Asset__r.Id,
                         Asset__r.Product2.ProductCode, Asset__c, Asset__r.Account.RecordType.DeveloperName,
                         SBQQ__Quantity__c, Asset__r.ParentId, SBQQ__StartDate__c, SBQQ__TerminatedDate__c,
                         SBQQ__EndDate__c, SBQQ__Contract__c, Status__c, 
                         Traffic_Identifier__c, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name, HTS_Egress_Region__c
                  FROM SBQQ__Subscription__c WHERE Id =: parentSub.Id];

    if(readList.size() != 1){
      log.appendLog('METHOD_EXIT', methodName + '|Service requires one and only one Subscriptions!');
      log.appendLog('FATAL_ERROR', 'Query for Clean Subscriptions returned ' + readList.size() + ' Should be one and only one!');
      log.success = false;
      return new SBQQ__Subscription__c();
    }
    if(readList[0].SBQQ__Product__r.HTS_Subscriber_Plan__r.Name == null){
      log.appendLog('METHOD_EXIT', methodName + '|The Subscription Product is missing the Shaping Policy!');
      log.appendLog('FATAL_ERROR', 'Query for Clean Subscription returned non HTS Hybrid service!');
      log.success = false;
      return readList[0];
    }
    if(readList[0].Traffic_Identifier__c == null){
      log.appendLog('METHOD_EXIT', methodName + '|The Subscription is missing the Traffic Identifier!');
      log.appendLog('FATAL_ERROR', 'Query for Clean Subscriptions returned non HTS Hybrid services!');
      log.success = false;
      return readList[0];
    }
    if(readList[0].Asset__r.Account.RecordType.DeveloperName.left(9) != 'Platform_'){
      log.appendLog('METHOD_EXIT', methodName + '|Assets must be related to Platforms!');
      log.appendLog('FATAL_ERROR', 'Clean Subscription detected Asset not related to Platform!');
      log.success = false;
      return readList[0];
    }
    log.appendLog('METHOD_EXIT', methodName + '|Subscription submitted appears to be in high order');
    return readList[0];
  }
  @testVisible private static void secondaryValidation(SBQQ__Subscription__c cleanSub){
    String methodName = 'secondaryValidation(SBQQ__Subscription__c cleanSub)';
    log.appendLog('METHOD_ENTRY', methodName + '|Validating Subscription Details for: ' + cleanSub.Name);
    //Asset must be VTID
    if(cleanSub.Asset__r.Product2.ProductCode != 'Virtual Terminal Id'){
      log.appendLog('METHOD_EXIT', methodName + '|The Subscription Asset does not appear to be a Virtual Terminal Id!');
      log.appendLog('FATAL_ERROR', 'Cannot proceed with Static IP Service Provisioning');
      log.success = false;
      return;
    }
    //Traffic ID regex
    if (!Pattern.matches('^([1-9]{1}[0-9]{6}[1-9]{1})-0([1-2]{1})$',cleanSub.Traffic_Identifier__c)){
      log.appendLog('METHOD_EXIT', methodName + '|The Subscription Traffic Identifier appears to be non-standard: ' + cleanSub.Traffic_Identifier__c);
      log.appendLog('FATAL_ERROR', 'Cannot proceed with Static IP Service Provisioning');
      log.success = false;
      return;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Asset and Traffic Identifier appear to be in high order.');
    return;
  }
  @testVisible private static Integer getDataChannel(SBQQ__Subscription__c parentSub){
    //CONUS HS = 1703, CONUS UL = 1704
    // EMEA HS = 1705,  EMEA UL = 1706
    // ASIA HS = 1707,  ASIA UL = 1708
    Integer returnInt = 0;
    String methodName = 'getDataChannel(SBQQ__Subscription__c parentSub)';
    log.appendLog('METHOD_ENTRY', methodName + '|Getting Data Channel Id for region: ' + parentSub.HTS_Egress_Region__c + ' and Hybrid Component: ' + parentSub.Traffic_Identifier__c.right(3));
    if(parentSub.HTS_Egress_Region__c == 'CONUS_STANDARD' && parentSub.Traffic_Identifier__c.right(3) == '-01'){
      returnInt = 1703;
    } else if(parentSub.HTS_Egress_Region__c == 'CONUS_STANDARD' && parentSub.Traffic_Identifier__c.right(3) == '-02'){
      returnInt = 1704;
    } else if(parentSub.HTS_Egress_Region__c == 'EMEA_STANDARD' && parentSub.Traffic_Identifier__c.right(3) == '-01'){
      returnInt = 1705;
    } else if(parentSub.HTS_Egress_Region__c == 'EMEA_STANDARD' && parentSub.Traffic_Identifier__c.right(3) == '-02'){
      returnInt = 1706;
    } else if(parentSub.HTS_Egress_Region__c == 'ASIA_STANDARD' && parentSub.Traffic_Identifier__c.right(3) == '-01'){
      returnInt = 1707;
    } else if(parentSub.HTS_Egress_Region__c == 'ASIA_STANDARD' && parentSub.Traffic_Identifier__c.right(3) == '-02'){
      returnInt = 1708;
    }
    if(returnInt < 1703 || returnInt > 1708){
      log.appendLog('METHOD_EXIT', methodName + '|Cannot Determine Data Channel!');
      log.appendLog('FATAL_ERROR', 'Data Channel Indeterminate');
      log.success = false;
      return returnInt;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Returning Data Channel: ' + returnInt);
    return returnInt;
  }
  @testVisible private static HTSOSS_hts_terminals getActiveTerminal(String VTID){
    HTSOSS_hts_terminals returnTerm = new HTSOSS_hts_terminals();
    String methodName = 'getActiveTerminal(String VTID)';
    log.appendLog('METHOD_ENTRY', methodName + '|Getting Active Terminal based on: ' + VTID);
    HTSOSS_hts_terminals.terminals_list_wrapper returnList = new HTSOSS_hts_terminals.terminals_list_wrapper();
    try{
      returnList = returnTerm.getTerminals(null, VTID, null);
      if(returnList.response_code != 200 || returnList.terminals_list.size() == 0){ //OR empty list!!
        log.appendLog('METHOD_EXIT', methodName + '|Failed to GET Terminal from OSS using: ' + VTID);
        log.appendLog('FATAL_ERROR', 'Could not GET Terminal from OSS. Response Code: ' + returnList.response_code + ' Message: ' + returnList.message);
        log.success = false;
        return returnTerm;
      }
      log.appendLog('INFO', methodName + '|Got a filtered list of Terminals using: ' + VTID);
      returnTerm = returnTerm.getTerminal(returnList.terminals_list[0]);
      if(returnTerm.response_code != 200){
        log.appendLog('METHOD_EXIT', methodName + '|Failed to GET Terminal from OSS using: ' + VTID);
        log.appendLog('FATAL_ERROR', 'Could not GET Terminal from OSS. Response Code: ' + returnTerm.response_code + ' Message: ' + returnTerm.message);
        log.success = false;
        return returnTerm;
      }
    } catch (Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
      log.appendLog('FATAL_ERROR', 'Could not GET Terminal from OSS. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
      log.success = false;
      log.createCase(e);  //use the system thrown exception as an input to the method
      return returnTerm;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Found Terminal in Network, obj_id: ' + returnTerm.obj_id);
    return returnTerm;
  }
  @testVisible private static Boolean getDataChannelStatus(Integer vlan, HTSOSS_hts_terminals activeTerm){
    String methodName = 'getDataChannelStatus(Integer vlan, HTSOSS_hts_terminals activeTerm)';
    Boolean returnBool = false;
    log.appendLog('METHOD_ENTRY', methodName + '|Enabling Data Channel: ' + vlan + ' for: ' + activeTerm.terminal_id);
    list<HTSOSS_hts_terminals.channel> channels = new list<HTSOSS_hts_terminals.channel>();
    channels = activeTerm.data_channels;
    String vlanString = String.valueOf(vlan);
    if(channels.size() == 0){ //check for empty array returned from OSS HTSSF-433
      log.appendLog('METHOD_EXIT', methodName + '|OSS returned empty Data Channel array!');
      log.appendLog('WARNING', 'Data Channel or Region Error');
      return returnBool;
    }
    if(channels[0].obj_id == vlanString){         //input vlan should match one...
      returnBool = channels[0].enablestaticroutes;
    } else if(channels[1].obj_id == vlanString){  //or the other data channel returned.
      returnBool = channels[1].enablestaticroutes;
    } else {                                      //unless something is WRONG!!
      log.appendLog('METHOD_EXIT', methodName + '|OSS Data Channels do not correspond with input Data Channel!');
      log.appendLog('FATAL_ERROR', 'Data Channel or Region Error');
      log.success = false;
      return returnBool;
    }
    if(returnBool){
      log.appendLog('INFO', methodName + '|Data Channel: ' + vlanString + ' for: ' + activeTerm.terminal_id + ' is already enabled');
    }
    log.appendLog('METHOD_EXIT', methodName + '|');
    return returnBool;
  }
  @testVisible private static HTSOSS_hts_terminals updateDataChannel(Integer vlan, HTSOSS_hts_terminals activeTerm, Boolean isEnabled){
    String methodName = 'updateDataChannel(Integer vlan, HTSOSS_hts_terminals activeTerm)';
    log.appendLog('METHOD_ENTRY', methodName + '|');
    HTSOSS_hts_terminals termToPut = new HTSOSS_hts_terminals();
    termToPut.obj_id = activeTerm.obj_id;
    termToPut.obj_revision = activeTerm.obj_revision;
    termToPut.enablestaticroutes = isEnabled;
    termToPut.static_ip_data_channel_id = vlan;
    try{
      termToPut = termToPut.putTerminal(termToPut);
      if(termToPut.response_code != 204){
        log.appendLog('METHOD_EXIT', methodName + '|Failed to Enable Static Data Channel for Terminal: ' + activeTerm.terminal_id);
        log.appendLog('FATAL_ERROR', 'Could not PUT Terminal to OSS. Response Code: ' + termToPut.response_code + ' Message: ' + termToPut.message);
        log.success = false;
        return termToPut;
      }
    } catch (Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
      log.appendLog('FATAL_ERROR', 'Could not PUT Terminal to OSS. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
      log.success = false;
      log.createCase(e);  //use the system thrown exception as an input to the method
      return termToPut;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Successfully Enabled Static Data Channel for Terminal: ' + activeTerm.terminal_id);
    return termToPut;
  }
  @testVisible private static HTSOSS_hts_terminals_staticips.staticip_list_wrapper getExistingStatics(HTSOSS_hts_terminals activeTerm){
    String methodName = 'getExistingStatics(Integer vlan, HTSOSS_hts_terminals activeTerm)';
    HTSOSS_hts_terminals_staticips.staticip_list_wrapper returnObj = new HTSOSS_hts_terminals_staticips.staticip_list_wrapper();
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    log.appendLog('METHOD_ENTRY', methodName + '|Getting Existing Static IPs for: ' + activeTerm.terminal_id);
    try{
      returnObj = util.getStaticIps(activeTerm);
      if (returnObj.response_code == 404){
        log.appendLog('METHOD_EXIT', methodName + '|Cannot find Terminal in OSS: ' + activeTerm.terminal_id);
        log.appendLog('FATAL_ERROR', 'Terminal not found. Response Code: ' + returnObj.response_code + ' Message: ' + returnObj.message);
        log.success = false;
        return returnObj;
      } else if(returnObj.response_code != 200){ 
        log.appendLog('METHOD_EXIT', methodName + '|Failed to GET Static IPs for Terminal: ' + activeTerm.terminal_id);
        log.appendLog('FATAL_ERROR', 'Could not GET Static IPs for Terminal. Response Code: ' + returnObj.response_code + ' Message: ' + returnObj.message);
        log.success = false;
        return returnObj;
      }
    } catch (Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
      log.appendLog('FATAL_ERROR', 'Could not GET Static IPs from OSS. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
      log.success = false;
      log.createCase(e);  //use the system thrown exception as an input to the method
      return returnObj;
    }
    log.appendLog('METHOD_EXIT', methodName + '|' + returnObj.staticip_list.size() + ' Static IPs obtained');
    return returnObj;
  }
  @testVisible private static String getNextPrivateIP(Integer vlan, HTSOSS_hts_terminals activeTerminal, 
                                                  list<HTSOSS_hts_terminals_staticips.staticIp> existingStatics){
    String methodName = 'getNextPrivateIP(Integer vlan, HTSOSS_hts_terminals_staticips.staticip_list_wrapper existingStatics)';
    log.appendLog('METHOD_ENTRY', methodName + '|Determining next available Private Static IP for: ' + activeTerminal.terminal_id + ' on Channel: ' + vlan);
    String returnString = '0.0.0.0';
    Integer staticIpAllocation = 13;
    system.debug('---->' + activeTerminal);
    String ipBase = activeTerminal.terminal_service_ip.substringBeforeLast('.') + '.';
    String vlanString = String.valueOf(vlan);
    Integer startingOctet = 0;
    if(vlan == 1703 || vlan == 1705 || vlan == 1707){
      startingOctet = 82;
    } else if (vlan == 1704 || vlan == 1706 || vlan == 1708){
      startingOctet = 146;
    } else {      //WTF! return fatal error!
      log.appendLog('METHOD_EXIT', methodName + '|Input VLAN: ' + vlan+ ' is out of range.');
      log.appendLog('FATAL_ERROR', 'Input VLAN Error');
      log.success = false;
      return returnString;
    }
    map<String, HTSOSS_hts_terminals_staticips.staticIp> staticsMap = 
           new map<String, HTSOSS_hts_terminals_staticips.staticIp>();
    for(HTSOSS_hts_terminals_staticips.staticIp s : existingStatics){
      if(s.channel_id == vlanString){
        staticsMap.put(s.obj_id.substringAfterLast('.'), s);
      }
    }
    if(staticsMap.size() == 13){  //no more statics available for channel!!
      log.appendLog('METHOD_EXIT', methodName + '|There are already' + 
                     staticIpAllocation + ' static IPs setup for: ' + 
                     activeTerminal.terminal_id + ' on Channel: ' + vlanString);
      log.appendLog('FATAL_ERROR', 'No More Static IPs available for channel!');
      log.success = false;
      return returnString;
    }
    for(Integer i = startingOctet; i < startingOctet + staticIpAllocation; i++){
      String octet4 = String.valueOf(i);
      if(staticsMap.get(octet4) == null){
        returnString = ipBase  + octet4;
        break;
      }
    }
    log.appendLog('METHOD_EXIT', methodName + '|Returning the next available Private Static IP: ' + returnString);
    return returnString;
  }
  @testVisible private static HTS_Static_IPs__c getPublicStaticIp(integer vlan, String region){
    String methodName = 'getPublicStaticIp(integer vlan, String region)';
    HTS_Static_IPs__c returnObj = new HTS_Static_IPs__c();
    log.appendLog('METHOD_ENTRY', methodName + '|Getting next available Public Static IP for region: ' + region + ' and Channel: ' + vlan);
    String vlanString = String.valueOf(vlan);
    Integer publicIpCount;
    try{
      list<HTS_Static_IPs__c> readList = [SELECT Id, Name, Channel_Id__c, Date_Issued__c, Private_Static_IP__c, Region__c, isReserved__c
                                          FROM HTS_Static_IPs__c
                                          WHERE Region__c =: region
                                          ORDER BY SystemModStamp ASC, HTS_IP_HEX_Address__c ASC];
      //Check size, issue warning if needed...
      publicIpCount = readList.size();
      if(publicIpCount == 0){
        log.appendLog('METHOD_EXIT', methodName + '|There are no more available Public Static IPs for region: ' + region + ' and Channel: ' + vlan);
        log.appendLog('FATAL_ERROR', 'Could not claim Public Static IP for Terminal.');
        log.success = false;
        return returnObj;
      } //Check for low level. see https://kvhdev.atlassian.net/browse/ITBOSPT-40 and https://kvhdev.atlassian.net/browse/ITBOSPT-41
      if(publicIpCount <= 16){ //Create warning...
        log.appendLog('WARNING', methodName + '|Only ' + publicIpCount + ' Public Static IPs left for region: ' + region + ' and Channel: ' + vlan);
        Exception ex = new NoDataFoundException();  //Create, but do not throw an exception as an input to the method
        ex.setMessage('WARNING! Only ' + publicIpCount + ' Public Static IPs left for region: ' + region + ' and Channel: ' + vlan);
        Id ServCloud_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
        Case returnCase = new Case();
        returnCase.RecordTypeId = ServCloud_RECORD_TYPE_ID;
        returnCase.Origin = 'System Generated';
        returnCase.status = 'New';
        returnCase.subject = ex.getMessage();
        returnCase.description = ex.getStackTraceString();
        //Custom Fields....
        returnCase.Case_Symptom__c = 'Salesforce Error';
        warningCase = returnCase;
      }
      returnObj = readList[0];
    } catch(Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
      log.appendLog('FATAL_ERROR', 'Problem claiming Public Static IP from Salesforce. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
      log.success = false;
      log.createCase(e);  //use the system thrown exception as an input to the method
      return returnObj;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Returning Public Static IP: ' + returnObj.Name );
    return returnObj;
  }
  @testVisible private static HTSOSS_hts_terminals_staticips postStaticIP(Integer vlan, HTSOSS_hts_terminals activeTerminal, String publicIP, String privateIP){
    String methodName = 'postStaticIP(Integer vlan, HTSOSS_hts_terminals activeTerminal, String publicIP, String privateIP)';
    HTSOSS_hts_terminals_staticips returnObj = new HTSOSS_hts_terminals_staticips();
    log.appendLog('METHOD_ENTRY', methodName + '|POSTing Static IP details to OSS');
    returnObj.data_channel_id = vlan;
    returnObj.static_ip_address = publicIP;
    returnObj.terminal_ip_address = privateIP;
    try{
      returnObj = returnObj.postStaticIp(activeTerminal, returnObj);
      //Replace Attributes wiped out by POST call....
      returnObj.data_channel_id = vlan;
      returnObj.static_ip_address = publicIP;
      returnObj.terminal_ip_address = privateIP;
      if(returnObj.response_code != 201){
        log.appendLog('METHOD_EXIT', methodName + '|Failed to POST Static IP details to OSS: ' + vlan + '/' + publicIP + '/' + privateIP);
        log.appendLog('FATAL_ERROR', 'Could not POST Static IP details to OSS. Response Code: ' + returnObj.response_code + ' Message: ' + returnObj.message);
        log.success = false;
        return returnObj;
      }
    } catch(Exception e){
      log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
      log.appendLog('FATAL_ERROR', 'Could not POST Static IP details to OSS. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
      log.success = false;
      log.createCase(e);  //use the system thrown exception as an input to the method
      return returnObj;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Successfully POSTed Static IP details to OSS');
    return returnObj;
  }
  @testVisible private static HTS_Static_IPs__c updateSFStaticIP(HTS_Static_IPs__c publicIP, String privateIP){
    String methodName = 'updateSFStaticIP(HTS_Static_IPs__c publicIP, String privateIP)';
    HTS_Static_IPs__c returnObj = publicIP;
    log.appendLog('METHOD_ENTRY', methodName + '|Preparing to update Static IP Record in Salesforce.');
    //This could move...
    returnObj.Date_Issued__c = DateTime.now();
    returnObj.Private_Static_IP__c = privateIP;
    try{
      update returnObj;
    } catch(Exception e){
        log.appendLog('FATAL_ERROR', 'Could not update ecord in Salesforce: ' + e.getStackTraceString());
        log.appendLog('METHOD_EXIT', methodName + '|Failed to update Static IP Record in Salesforce.');
        log.createCase(e);  //use the system thrown exception as an input to the method
        log.success = false;
        return returnObj;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Succesfully updated Static IP Record in Salesforce.');
    return returnObj;
  }
  @testVisible private static Asset createAsset(Asset vtidAsset, HTSOSS_hts_terminals_staticips publicIP){
    String methodName = 'createAsset(Asset vtidAsset)';
    log.appendLog('METHOD_ENTRY', methodName + '|Creating Asset to represent the Static IP');
    //Need a Product2 reference for the Asset. Get it from the Custom Metadata Type
    Default_Identifier_Product__mdt GSIPproduct = [SELECT Identifier_Product_reference__c, Legacy_Product_Id__c
                                                    FROM Default_Identifier_Product__mdt 
                                                    WHERE DeveloperName = 'Global_Static_IP'];
    Asset returnAsset = vtidAsset.clone(false, true, false, false);
    returnAsset.Name = publicIP.terminal_ip_address + ' - ' + publicIP.static_ip_address;
    returnAsset.SerialNumber = returnAsset.Name;
    returnAsset.Product2Id = (id)GSIPproduct.Identifier_Product_reference__c;
    returnAsset.Asset_ID__c = GSIPproduct.Legacy_Product_Id__c + returnAsset.Name;
    try{
      insert returnAsset;
    } catch(Exception e){
      log.appendLog('FATAL_ERROR', 'Could not insert record in Salesforce: ' + e.getStackTraceString());
      log.appendLog('METHOD_EXIT', methodName + '|Failed to insert new Asset Record in Salesforce.');
      log.createCase(e);  //use the system thrown exception as an input to the method
      log.success = false;
      return returnAsset;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Created new Asset: ' + returnAsset.Name);
    return returnAsset;
  }
  @testVisible private static SBQQ__Subscription__c createSubscription(SBQQ__Subscription__c cleanSub, Asset gsipAsset){
    String methodName = 'createSubscription(SBQQ__Subscription__c cleanSub)';
    log.appendLog('METHOD_ENTRY', methodName + '|Creating Subscription to represent the Static IP');
    //Need a Product2 reference for the Asset. Get it from the Custom Metadata Type
    Default_Identifier_Product__mdt GSIPproduct = [SELECT Identifier_Product_reference__c, Legacy_Product_Id__c
                                                    FROM Default_Identifier_Product__mdt 
                                                    WHERE DeveloperName = 'Global_Static_IP'];
    system.debug('Clean Sub -->' + cleanSub);
    SBQQ__Subscription__c returnSub = cleanSub.clone(false, true, false, false);
    system.debug('Return Sub -->' + returnSub);
    returnSub.SBQQ__Product__c = (id)GSIPproduct.Identifier_Product_reference__c;
    returnSub.SBQQ__Quantity__c = cleanSub.SBQQ__Quantity__c;
    returnSub.Asset__c = gsipAsset.Id;
    try{
      insert returnSub;
    } catch (Exception e){
      log.appendLog('FATAL_ERROR', 'Could not insert record in Salesforce: ' + e.getStackTraceString());
      log.appendLog('METHOD_EXIT', methodName + '|Failed to insert new Subscription Record in Salesforce.');
      log.createCase(e);  //use the system thrown exception as an input to the method
      log.success = false;
      return returnSub;
    }
    log.appendLog('METHOD_EXIT', methodName + '|Created new Subscription for: ' + returnSub.Traffic_Identifier__c);
    return returnSub;
  }
}