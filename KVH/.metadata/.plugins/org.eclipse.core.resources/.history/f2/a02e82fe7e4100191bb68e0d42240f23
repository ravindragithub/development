public with sharing class HTS_ltgsvc_subscriptions {
  //Top level atributes to communicate with Lightning Components
  //Probably want:
  //  list<SBQQ__Subscription__c>  ...typically only one 
  //  statusMessage
  @AuraEnabled public string statusMessage {get;set;}
  @AuraEnabled public list<SBQQ__Subscription__c> subscriptions {get;set;}
  @AuraEnabled public string shapingPolicy {get;set;}

  public HTS_ltgsvc_subscriptions() {
    subscriptions = new list<SBQQ__Subscription__c>();
  }
  @AuraEnabled public static HTS_ltgsvc_subscriptions getSubscription(string recId){
    HTS_ltgsvc_subscriptions returnObj = new HTS_ltgsvc_subscriptions();
    returnObj.subscriptions = [SELECT Id, Name, SBQQ__Contract__r.Account.Name, SBQQ__Contract__r.ContractNumber, SBQQ__Contract__r.Status,
                                      Asset__c, Asset__r.Name, Traffic_Identifier__c,
                                      SBQQ__Product__c, SBQQ__Product__r.Name, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                               FROM SBQQ__Subscription__c WHERE Id=:recId];
    If(returnObj.subscriptions.size() == 0){
      //Did not find any SBQQ Subscriptions
      returnObj.statusMessage = 'ERROR: No records found';
    } else if(returnObj.subscriptions.size() > 1){
      //Found more than one SBQQ Subscriptions!
      returnObj.statusMessage = 'ERROR: More than one record found';
    } else {
      returnObj.statusMessage = 'SUCCESS: Single Subscription Record returned';
    }
    return returnObj;
  }
  @AuraEnabled public static HTS_ltgsvc_subscriptions updateSubscription(String obj_id, String TID, SBQQ__Subscription__c shapingPolicy){
    HTS_ltgsvc_subscriptions returnObj = new HTS_ltgsvc_subscriptions();
    returnObj.statusMessage = 'Initializing...';
    //setup object for callout... TID to be applied later
    HTSOSS_hts_subscribers sub = new HTSOSS_hts_subscribers();

    //Need to compare existing OSS TID to expected TID (based on subscription)
    string anticipatedTID = returnObj.generateTID(shapingPolicy);
    system.debug(anticipatedTID);
    if(anticipatedTID != TID){  //need to execute the Create then Delete workflow
      //Use Create then Delete workflow
      sub.obj_id = obj_id;                  //use the provided obj_id to...
      sub = sub.getSubscriber(sub);         //GET the subscriber from OSS...
      system.debug('SUBy: ' + sub);
      sub.subscriber_id = anticipatedTID;   //replacing the changed attributes....
      sub.subscriber_ip_addresses = getIpRangeByTID(sub); //ensure the appropriate range is set!
      sub.subscriber_plan_id = shapingPolicy.SBQQ__Product__r.HTS_Subscriber_Plan__r.Name;
      system.debug(sub);
      //Try-Catch??
      sub = returnObj.replaceOSSSubscriber(sub); //Make the POST & DELETE Callouts...
      returnObj.statusMessage = sub.message;    //migrate the status message to our returnObj message...
      returnObj.shapingPolicy = sub.subscriber_plan_id;
      shapingPolicy.Traffic_Identifier__c = anticipatedTID; //update Traffic Identifier...
      update shapingPolicy;                                 //and post Update to SF. This might need to move to a client-side callback...
    } else {  //Need to execute the change workflow
      //Use change workflow. Changing IP Address range is not supported.
      sub.obj_id = obj_id;      //Need the obj_id and the Shaping Policy for a PUT (change) callout...
      sub.subscriber_plan_id = shapingPolicy.SBQQ__Product__r.HTS_Subscriber_Plan__r.Name;
      system.debug(sub);
      //Try-Catch??
      sub = returnObj.updateOSSSubscriber(sub); //Make the callout..
      returnObj.statusMessage = sub.message;    //migrate the status message to our returnObj message...
      returnObj.shapingPolicy = sub.subscriber_plan_id;
    }
    returnObj.moveIdentifiersToChildOfRoot(TID.left(8));
    system.debug(CalloutLogs.commitLogs());
    return returnObj;
  }
  @AuraEnabled public static HTS_ltgsvc_subscriptions getSubscriptionList(string asset_name){
    HTS_ltgsvc_subscriptions returnObj = new HTS_ltgsvc_subscriptions();
    returnObj.subscriptions = [SELECT Id, Name, SBQQ__Contract__r.ContractNumber, SBQQ__Product__r.Name,
                                       SBQQ__StartDate__c, SBQQ__EndDate__c
                               FROM SBQQ__Subscription__c
                               WHERE Asset__r.Name=:asset_name AND SBQQ__TerminatedDate__c = null]; //and terminated date is blank!
    If(returnObj.subscriptions.size() == 0){
      //Did not find any SBQQ Subscriptions
      returnObj.statusMessage = 'SUCCESS: No records found';
    } else if(returnObj.subscriptions.size() > 1){
      //Found more than one SBQQ Subscriptions!
      returnObj.statusMessage = 'SUCCESS: More than one record found';
    } else {
      returnObj.statusMessage = 'SUCCESS: Single record found';
    }
    return returnObj;
  }
  //Helper methods below.....
  @testVisible private HTSOSS_hts_subscribers replaceOSSSubscriber(HTSOSS_hts_subscribers subscriberToReplace){
    //Clone and Create first, then delete!
    HTSOSS_hts_subscribers returnObj = new HTSOSS_hts_subscribers();
    try{
      returnObj = returnObj.postSubscriber(subscriberToReplace);              //POST the new subscriber with the new TID
      system.debug('returnObj status code after POST: ' + returnObj.response_code);
      //Cleanup....
      subscriberToReplace = subscriberToReplace.deleteSubscriber(subscriberToReplace);  //delete the old subscriber
      system.debug('returnObj status code after DELETE: ' + returnObj.response_code);
      //Handle non-exception exceptions, process response code...
      returnObj.message = processResponseCode(returnObj.response_code);

    } catch(exception e){
      returnObj.message = 'ERROR: ' + e.getMessage();
    }
    return returnObj;
  }
  @testVisible private HTSOSS_hts_subscribers updateOSSSubscriber(HTSOSS_hts_subscribers subscriberToModify){
    HTSOSS_hts_subscribers returnObj = new HTSOSS_hts_subscribers();
    try{
      returnObj = returnObj.putSubscriber(subscriberToModify);
      //Handle non-exception exceptions...
      returnObj.message = processResponseCode(returnObj.response_code);
    } catch(exception e){
      returnObj.message = 'ERROR: ' + e.getMessage();
    }
    return returnObj;
  }

  @testVisible private string processResponseCode(integer respCode){
    string returnString = 'Initializing...';
      if(respCode == 201){ //POST successful!
        returnString = 'SUCCESS: OSS returned: ' + respCode;
      } else if (respCode == 204){ //Update successful!
        returnString  = 'SUCCESS: OSS returned: '  + respCode;
      } else if (respCode == 404){ //obj_id not found (not likely)
        returnString  = 'ERROR: OSS returned: ' + respCode + ' Subscriber not found!';
      } else if (respCode == 500){ //OSS server error (not likely)
        returnString  = 'ERROR: OSS returned: ' + respCode + ' OSS failed to update Subscriber!';
      }
    return returnString;
  }
  @testVisible private string generateTID(SBQQ__Subscription__c subscription){
    string returnString = 'Initializing...';
    //What should the TID suffix be??
    if(subscription.SBQQ__Product__r.HTS_Subscriber_Plan__r.Name == 'Enabled'){ //Only shaping policy that should have -00 TID suffix!
      returnString = subscription.Asset__r.Name + '-00';
    } else {
      returnString = subscription.Traffic_Identifier__c;
    }
    return returnString;
  }
  @testVisible private void moveIdentifiersToChildOfRoot(string VTID){
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
    update updateList;
  }
  @testVisible private static list<String> getIpRangeByTID(HTSOSS_hts_subscribers sub){
    list<String> returnList = new list<String>();
    map<String, String> ipRanges = new map<String, String>();
    for(HTS_Hybrid_Plan_IP_Ranges__mdt r : [SELECT DeveloperName, CIDR_range__c
                                            FROM HTS_Hybrid_Plan_IP_Ranges__mdt]){
      ipRanges.put(r.DeveloperName, r.CIDR_range__c);
    }
    system.debug('SUBx: ' + sub);
    String subIp = sub.subscriber_ip_addresses[0];
    String ipThreeOctets = subIp.substringBeforeLast('.') + '.';
    if(sub.subscriber_id.right(3) == '-01'){        //so-called Primary, big map
      returnList.add(ipThreeOctets + ipRanges.get('Basic_Top').substringAfterLast('.'));
      returnList.add(ipThreeOctets + ipRanges.get('Primary_NAT').substringAfterLast('.'));
      returnList.add(ipThreeOctets + ipRanges.get('Primary_STATIC').substringAfterLast('.'));
      returnList.add(ipThreeOctets + ipRanges.get('Basic_Bottom').substringAfterLast('.'));
    } else if(sub.subscriber_id.right(3) == '-02'){ //so-called Secondary, smaller map
      returnList.add(ipThreeOctets + ipRanges.get('Secondary_NAT').substringAfterLast('.'));
      returnList.add(ipThreeOctets + ipRanges.get('Secondary_STATIC').substringAfterLast('.'));
    }
    return returnList;
  }
}