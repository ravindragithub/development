public with sharing class HTS_ltgsvc_contract_controls {
  @AuraEnabled public string statusMessage {get;set;}
  @AuraEnabled public Contract parentContract {get;set;}
  @AuraEnabled public list<SBQQ__Subscription__c> subsList {get; private set;}
  public HTS_ltgsvc_contract_controls() {
    
  }
  @AuraEnabled public static HTS_ltgsvc_contract_controls getControlObject(String recId){
    HTS_ltgsvc_contract_controls returnObj = new HTS_ltgsvc_contract_controls();
    returnObj.statusMessage = 'Initializing...';
    returnObj.parentContract = getCleanContract(recId);
    returnObj.subsList = getSubscriptions(returnObj.parentContract);
    returnObj.statusMessage = 'SUCCESS: Returning Subscriptions List';
    return returnObj;
  }
  @AuraEnabled public static HTS_ltgsvc_contract_controls setupStaticIP(SBQQ__Subscription__c parentSub){
    HTS_ltgsvc_contract_controls returnObj = new HTS_ltgsvc_contract_controls();
    returnObj.statusMessage = 'Invoking Service Class...';
    serviceResults log = Service_staticIP.provisionStaticIP(parentSub);
    returnObj.statusMessage = log.message;
    return returnObj;
  }
  @testVisible private static Contract getCleanContract(String recId){
    Contract returnContract = new Contract();
    returnContract = [SELECT Id, ContractNumber, Billing_Account__r.Name FROM Contract WHERE Id =: recId LIMIT 1];
    return returnContract;
  }
  @testVisible private static list<SBQQ__Subscription__c> getSubscriptions(Contract kontrakt){
    list<SBQQ__Subscription__c> returnList = new list<SBQQ__Subscription__c>();
    returnList = [SELECT Id, SBQQ__Product__c, SBQQ__Product__r.Name, SBQQ__Product__r.HTS_Subscriber_Plan__c, 
                         Asset__c, Asset__r.Name, 
                         Traffic_Identifier__c, Name, SBQQ__Contract__r.ContractNumber,
                         SBQQ__StartDate__c, SBQQ__EndDate__c, SBQQ__TerminatedDate__c
                  FROM SBQQ__Subscription__c
                  WHERE SBQQ__Contract__c =: kontrakt.Id];
    return returnList;
  }
}