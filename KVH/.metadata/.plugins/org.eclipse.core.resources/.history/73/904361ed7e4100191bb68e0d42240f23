public class AgilePlan_ltgsvc_indicator {

  @AuraEnabled public static Boolean checkIsAgilePlan(string caseId){
    Boolean returnBool = false;
    Case activeCase = [SELECT Id, Asset.Is_AgilePlan__c FROM Case WHERE Id =: caseId];
    if(activeCase.Asset.Is_AgilePlan__c){
      returnBool = true;
    } //else... it's already false!
    return returnBool;
  }
}