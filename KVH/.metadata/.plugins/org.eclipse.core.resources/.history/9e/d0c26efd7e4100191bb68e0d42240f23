public with sharing class HTS_ltgsvc_diagnostics {
  @AuraEnabled public string statusMessage {get;set;}
  @AuraEnabled public list<HTSOSS_hts_subscribers> activeSubscriptions {get;set;}
  @AuraEnabled public list<Asset> systemCollection {get;set;}
  @AuraEnabled public list<String> validationResults {get;set;}
  //constructor
  public HTS_ltgsvc_diagnostics() {
    statusMessage = 'INITIALIZED...';
    activeSubscriptions = new list<HTSOSS_hts_subscribers>();
    systemCollection = new list<Asset>();
    validationResults = new list<String>();
  }

  @AuraEnabled public static HTS_ltgsvc_diagnostics getActiveSubscriptions(string VTID){
    //Check for Traffic Identifiers with -00, -01, and -02 identifiers
    HTS_ltgsvc_diagnostics returnObj = new HTS_ltgsvc_diagnostics();
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    list<String> suffixes = new list<String>{'-00', '-01', '-02'}; //should only ever be these three
    //Try
    Try{
      for(string s : suffixes){
        system.debug(s);
        HTSOSS_hts_subscribers.subscribers_list_wrapper wrapper = util.getSubscribersList(null, VTID + s);
        HTSOSS_hts_subscribers foundSubscriber = new HTSOSS_hts_subscribers();
        system.debug('wrapper: ' + wrapper);
        if(wrapper.subscribers_list != null){
          if(wrapper.subscribers_list.size() == 1){ //we found one and only one, now get the details
            system.debug('wrapper.subscriber_list: ' + wrapper.subscribers_list);
            HTSOSS_hts_subscribers subToGet = new HTSOSS_hts_subscribers();
            subToGet.obj_id = wrapper.subscribers_list[0].obj_id;
            system.debug(subToGet);
            foundSubscriber = util.getSubscriber(subToGet);
            returnObj.activeSubscriptions.add(foundSubscriber);
          } else {
            returnObj.statusMessage = 'ERROR: duplicate subscribers for: ' + VTID + s + 'found in OSS';
          }
        }
      }
      returnObj.statusMessage = 'SUCCESS: analysis returned: ' + returnObj.activeSubscriptions.size() + ' active subscriptions';
    } Catch (Exception e) {
      returnObj.statusMessage = 'EXCEPTION: ' + e.getMessage();
    }

    system.debug(returnObj);
    return returnObj;
  }
  @AuraEnabled public static HTS_ltgsvc_diagnostics runDiagnostics(string VTID){
    HTS_ltgsvc_diagnostics returnObj = new HTS_ltgsvc_diagnostics();
    list<String> testResults = new list<String>();
    //Need to get the system related data first...
    returnObj.activeSubscriptions = HTS_ltgsvc_diagnostics.getActiveSubscriptions(VTID).activeSubscriptions;
    returnObj.systemCollection = HTS_ltgsvc_diagnostics.getSystemStatus(VTID).systemCollection;
    //Now we can start running tests and populating a temporary list with results
    testResults.add(returnObj.validateTermInNetwork(VTID));
    testResults.addAll(returnObj.validateSystemIsComplete(returnObj.systemCollection));
    //tests done, now we migrate the list to the return Class
    returnObj.validationResults = testResults;
    returnObj.statusMessage = 'SUCCESS: Diagnostics completed!';
    //system.debug(CalloutLogs.commitLogs());
    system.debug(returnObj);
    system.debug(CalloutLogs.commitLogs());
    return returnObj;
  }

  @AuraEnabled public static HTS_ltgsvc_diagnostics getSystemStatus(string VTID){
    //use Root Asset to get whole system hierarchy
    //RootAsset is SFDC standard field, Root_Asset__c is custom field...
    HTS_ltgsvc_diagnostics returnObj = new HTS_ltgsvc_diagnostics();
    //try to catch a SOQL exception?
    Try{
      list<Asset> systemComponents = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                      Product2.ProductCode, AccountId
                                      FROM Asset WHERE Name =: VTID];
      If(systemComponents.size() == 0){ //check for no data
        throw new QueryException('No data returned from query');
      }
      If(systemComponents.size() > 1){ //check for duplicates
        throw new QueryException(systemComponents.size() + ' Assets with duplicate names found!');
      }
      Asset a = systemComponents[0];  //there can be only one!
      systemComponents.clear();       //and we want it's whole hierarchy
      if(a.Root_Asset__c != null){
        systemComponents = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                            Product2.ProductCode, AccountId, HTS_REady__c
                            FROM Asset 
                            WHERE Root_Asset__c =: a.Root_Asset__c OR Id =: a.Root_Asset__c];
      } else {
        systemComponents.add(a);
      }
      
      returnObj.systemCollection = systemComponents;
      returnObj.statusMessage = 'SUCCESS: ';
    } Catch (Exception e){
      returnObj.statusMessage = 'EXCEPTION: ' + e.getMessage();
    }
    system.debug(returnObj);
    return returnObj;
  }

  
  @AuraEnabled public static HTS_ltgsvc_diagnostics getAssetDiagnostics(list<Asset> systemAssets){
    HTS_ltgsvc_diagnostics returnObj = new HTS_ltgsvc_diagnostics();
    returnObj.validationResults = returnObj.validateSystemIsComplete(systemAssets);
    returnObj.systemCollection = systemAssets;
    return returnObj;
  }

  public String validateTermInNetwork(String VTID){
    String returnString = 'Initializing...';
    HTSOSS_hts_terminals util = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals.terminals_list_wrapper wrapper = new HTSOSS_hts_terminals.terminals_list_wrapper();
    wrapper = util.getTerminals(null, VTID);
    if(wrapper.response_code == 200){ //OK, got something back from OSS
      if(wrapper.terminals_list.size() == 0){
        returnString = 'ERROR: Terminal not in Network';
      } else if (wrapper.terminals_list.size() > 1){
        returnString = 'ERROR: ' + wrapper.terminals_list.size() + ' duplicates returned from OSS';
      } else {  //This is the normal workflow for a single terminal returned
        if(wrapper.terminals_list[0].is_active == true){
          returnString = 'OK: Terminal is Active and in Network';
        } else {
          returnString = 'ERROR: Terminal is in Network, but not Active';
        }
      }
    } else {                          //Bad response from OSS
      returnString = 'ERROR: ' + wrapper.response_code + ' returned from OSS';
    }
    
    return returnString;
  }

  public list<String> validateSystemIsComplete(list<Asset> systemAssets){
    list<String> returnList = new list<String>();
    //Collect the system Map
    map<String, list<Asset>> systemMap = getSystemMap(systemAssets);
    //Find the System level part number, and make sure that there is only one Root Asset...
    String systemPartNumber = '';
    Integer rootCount = 0;
    for(asset a : systemAssets){
      if(a.Parent_Asset__c == null){
        rootCount = rootCount + 1;
        systemPartNumber = a.Product2.ProductCode;
      }
    }
    if(rootCount == 0){
      returnList.add('ERROR: No system level Asset detected!');
    } else if (rootCount > 1){
      returnList.add('ERROR: Multiple system level Assets detected!');
    } else {
      returnList.add('OK: System level Asset ' + systemPartNumber + ' detected!');
    }
    //Get the hierarchy template and compare
    //Probably need to force 01-0408 into getSystemTemplate....
    list<Asset_Hierarchy_Template__mdt> systemTemplate = getSystemTemplate(systemPartNumber.left(7));
    //Going to need a fuzzy matching....
    //Template based on root part numbers, actuals will have dash numbers....
    //this condition depends on the system level part number getting the right template...
    integer requiredElementCount = 0;
    for(Asset_Hierarchy_Template__mdt t : systemTemplate){
      system.debug(t);
      if(t.Type__c == 'Antenna'){ //handle antenna special case
        integer antennaCount = 0;  //reset a duplicate counter...
        //get the antenna part number (7) from the systemMap
        for(string assetPartNumber : systemMap.keySet()){ //loop through the Asset Keys (Part numbers, potentially with dash numbers!)
          system.debug('assetPartNumber: ' + assetPartNumber + ' t.Product_Code__c: ' + t.Product_Code__c);
          if(assetPartNumber.left(7).contains(t.Product_Code__c.left(7))){
            antennaCount = antennaCount + 1;  //increment requirement counter!
            list<Asset> existingElements = systemMap.get(assetPartNumber);
            if(existingElements.size() == 0){ //TODO: This condition might not be required...
              returnList.add('ERROR: Required ' + t.type__c + ' missing!');
            } else if(existingElements.size() > 1){
              returnList.add('ERROR: Required ' + t.type__c + ' multiples found!');
            } else {  //check for "HTS_REady__c"
              if(existingElements[0].HTS_REady__c == true){
                returnList.add('OK: Required ' + t.type__c + ' is HTS Ready!');
              } else {
                returnList.add('ERROR: Required ' + t.type__c + ' is NOT HTS Ready!');
              }
            } //end if
          } //end if
        } //end for

      } else if(t.is_Required__c){ //we need to find a required element....
        integer requiredKeyCount = 0;  //reset a duplicate counter...
        requiredElementCount = requiredElementCount + 1;  //increment requirement counter!
        for(string assetPartNumber : systemMap.keySet()){ //loop through the Asset Keys (Part numbers, potentially with dash numbers!)
          if(assetPartNumber.contains(t.Product_Code__c)){
            requiredKeyCount = requiredKeyCount + 1;
            list<Asset> existingElements = systemMap.get(assetPartNumber);
            if(existingElements.size() == 0){ //TODO: This condition might not be required...
              returnList.add('ERROR: Required element: ' + t.Product_Code__c + ' ' + t.type__c + ' missing!');
            } else if(existingElements.size() > 1){
              returnList.add('ERROR: Required element: ' + t.Product_Code__c + ' ' + t.type__c + ' multiples found!');
            } else {
              returnList.add('OK: Required element: ' + t.Product_Code__c + ' ' + t.type__c + ' detected!');
            } //end if
          } //end if
        } //end for
        //Check to see if we have a duplicate condition...
        //for example required 'abc' will match both 'abc-1' and 'abc-2'
        if(requiredKeyCount > 1){
          returnList.add('ERROR: Required element: ' + t.Product_Code__c + ' ' + requiredKeyCount + ' multiples found!');
        } else if(requiredKeyCount == 0){
          returnList.add('ERROR: Required element: ' + t.Product_Code__c + ' ' + t.type__c + ' missing!');
        }
      }// end if
    }// end for
    if(requiredElementCount == 0){
      returnList.add('ERROR: ZERO Required elements!');
    }
    system.debug(returnList);
    return returnList;
  }

  
  public map<String, list<Asset>> getSystemMap(list<Asset> systemAssets){
    //Using a map with a ProductCode Key and a list<Asset> value
    //Allows us to accomodate more than one of the same Product in a hierarchy
    //This is usually an Error condition, but might not always be
    map<String, list<Asset>> returnMap = new map<String, list<Asset>>();
    for(Asset a : systemAssets){
      list<Asset> tempList = new list<Asset>();
      if(returnMap.containsKey(a.Product2.ProductCode)){  //In case there is already one or more in the hierarchy
        tempList = returnMap.get(a.Product2.ProductCode); //get the existing list
      }
      tempList.add(a);
      returnMap.put(a.Product2.ProductCode, tempList);
    }
    return returnMap;
  }

  public list<Asset_Hierarchy_Template__mdt> getSystemTemplate(string systemPartNumber){
    list<Asset_Hierarchy_Template__mdt> returnList = new list<Asset_Hierarchy_Template__mdt>();
    returnList = [SELECT Id, Label, Root__c, Parent__c, Product_Code__c, is_Required__c, Type__c
                  FROM Asset_Hierarchy_Template__mdt WHERE Label LIKE: systemPartNumber + '%'];
    system.debug(returnList);
    return returnList;
  }
}