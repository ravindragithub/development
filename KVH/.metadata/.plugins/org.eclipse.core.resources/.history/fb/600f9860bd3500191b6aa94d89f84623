public with sharing class HTS_ltgsvc_hybrids {
  @AuraEnabled public string statusMessage {get;set;}
  @AuraEnabled public Contract parentContr {get;set;}
  @AuraEnabled public SBQQ__Subscription__c primarySub {get;set;}
  @AuraEnabled public SBQQ__Subscription__c secondarySub {get;set;}
  @AuraEnabled public Asset virtualTerminal {get;set;}

  public HTS_ltgsvc_hybrids() { 
    statusMessage = 'INITIALIZED...';
    parentContr = new Contract();
    primarySub = new SBQQ__Subscription__c();
    secondarySub = new SBQQ__Subscription__c();
    virtualTerminal = new Asset();
  }

  @AuraEnabled public static HTS_ltgsvc_hybrids getContract(string recId){
    HTS_ltgsvc_hybrids returnObj = new HTS_ltgsvc_hybrids();
    list<Contract> kList = [SELECT Id, ContractNumber, Name, Billing_Account__r.Name
                            FROM Contract
                            WHERE Id =: recId];
    //Count the records... should be only 1!
    if(kList.size() == 0){
      returnObj.statusMessage = 'ERROR: Contract not found!';
    } else if(kList.size() > 1){  //Not bloody likely!
      returnObj.statusMessage = 'ERROR: Multiple Contracts found!';
    } else if(kList.size() == 1){
      returnObj.statusMessage = 'SUCCESS: Contract found!';
      returnObj.parentContr = kList[0];
    } else {
      returnObj.statusMessage = 'ERROR: Unexpected Error occured';
    }
    return returnObj;
  }
  @AuraEnabled public static list<Product2> getHTSPlans(){
    list<Product2> returnList = new list<Product2>();
    returnList = [SELECT Id, Name, ProductCode, Description, 
                          HTS_Subscriber_Plan__r.Name, Airtime_Rate_Plan_Type__c 
                  FROM Product2 
                  WHERE HTS_Subscriber_Plan__c != null];
    return returnList;
  }
  @AuraEnabled public static list<HTS_Terminal_Template__c> getRegions(){
    list<HTS_Terminal_Template__c> returnList = new list<HTS_Terminal_Template__c>();
    returnList = [SELECT Name, isDefault__c, obj_id__c, Region__c, Status__c,
                         Version__c, isReleased__c
                  FROM HTS_Terminal_Template__c WHERE Region__c != null];
    return returnList;
  }
  @AuraEnabled public static HTS_ltgsvc_hybrids getTerminal(String searchString){
    HTS_ltgsvc_hybrids returnObj = new HTS_ltgsvc_hybrids();
    list<Asset> readList = [SELECT Id, Name, Product2.ProductCode FROM Asset WHERE Name =: searchString];
    if(readList.size() != 1){
      returnObj.statusMessage = 'ERROR: found ' + readList.size() + ' Assets named ' + searchString;
      return returnObj;
    }
    returnObj.statusMessage = 'SUCCESS: Returning one and only one Asset!';
    returnObj.virtualTerminal = readList[0];
    return returnObj;
  }
  @AuraEnabled public static HTS_ltgsvc_hybrids createTwoSubs(Contract kont, Asset asse, String priSubId, String secSubId, String region_obj_id){
    system.debug('Creating TWO subs...');
    system.debug(priSubId);
    system.debug(secSubId);
    system.debug(region_obj_id);
    HTS_ltgsvc_hybrids returnObj = new HTS_ltgsvc_hybrids();
    list<SBQQ__Subscription__c> subsList = new list<SBQQ__Subscription__c>();
    String trafficId_pri = asse.Name + '-01';
    returnObj.primarySub = createOneSub(kont, asse, priSubId, trafficId_pri, region_obj_id);
    subsList.add(returnObj.primarySub);

    String trafficId_sec = asse.Name + '-02';
    returnObj.secondarySub = createOneSub(kont, asse, secSubId, trafficId_sec, region_obj_id);
    subsList.add(returnObj.secondarySub);

    insert subsList;
    returnObj.statusMessage = 'SUCCESS: Inserted two Subscriptions!';
    return returnObj;
  }
  /*************************************************
   * Private Helper methods
   *************************************************/
  @testVisible private static SBQQ__Subscription__c createOneSub(Contract k, Asset a, String pId, String tid, String region_obj_id){
    system.debug('Creating ONE subs...');
    SBQQ__Subscription__c returnObj = new SBQQ__Subscription__c();
    returnObj.Traffic_Identifier__c = tid;
    returnObj.SBQQ__Contract__c = k.Id;
    returnObj.Asset__c = a.Id;
    returnObj.SBQQ__Product__c = pId;
    returnObj.SBQQ__Quantity__c = 12;
    returnObj.HTS_Egress_Region__c = region_obj_id;
    system.debug(returnObj);
    return returnObj;
  }
  @AuraEnabled public static HTS_ltgsvc_hybrids invokeServiceClass(SBQQ__Subscription__c primarySub, SBQQ__Subscription__c secondarySub){
    HTS_ltgsvc_hybrids returnObj = new HTS_ltgsvc_hybrids();
    list<SBQQ__Subscription__c> subsList = new list<SBQQ__Subscription__c>();
    subsList.add(primarySub);
    subsList.add(secondarySub);
    serviceResults log = Service_provisionHTSHybrids.provisionHybrid(subslist);
    system.debug(log);
    if(log.success != true){    //something went wrong!
      returnObj.statusMessage = 'ERROR: Service provisioning FAILED! See case: ' + log.srCase.Id + ' for details';
      return returnObj;
    }
    returnObj.statusMessage = 'SUCCESS: Service provisioning succeeded!';
    return returnObj;
  }
  @AuraEnabled public static HTS_ltgsvc_hybrids invokeTerminateService(SBQQ__Subscription__c primarySub, SBQQ__Subscription__c secondarySub){
    HTS_ltgsvc_hybrids returnObj = new HTS_ltgsvc_hybrids();
    list<SBQQ__Subscription__c> subsList = new list<SBQQ__Subscription__c>();
    subsList.add(primarySub);
    subsList.add(secondarySub);
    serviceResults log = Service_provisionHTSHybrids.terminateHybrid(subslist);
    system.debug(log);
    if(log.success != true){    //something went wrong!
      returnObj.statusMessage = 'ERROR: Service provisioning FAILED! See case: ' + log.srCase.Id + ' for details';
      return returnObj;
    }
    returnObj.statusMessage = 'SUCCESS: Service termination succeeded!';
    return returnObj;
  }
}