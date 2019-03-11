public with sharing class HTS_ltgsvc_region_selector {

  public HTS_ltgsvc_region_selector() {
    
  }
  @AuraEnabled public static list<HTS_Terminal_Template__c> getRegions(){
    list<HTS_Terminal_Template__c> returnList = new list<HTS_Terminal_Template__c>();
    returnList = [SELECT Name, isDefault__c, obj_id__c, Region__c, Status__c,
                         Version__c, isReleased__c
                  FROM HTS_Terminal_Template__c WHERE Region__c != null];
    return returnList;
  }
  @AuraEnabled public static HTSOSS_hts_terminals getTerminal(String vtid){
    HTSOSS_hts_terminals returnObj = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals util = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals.terminals_list_wrapper terminalList = new HTSOSS_hts_terminals.terminals_list_wrapper();
    terminalList = util.getTerminals(null, vtid, null);
    util.obj_id = terminalList.terminals_list[0].obj_id;
    returnObj = util.getTerminal(util);
    //terminal_service_ip looks like "10.64.31.1"... but we want "10.64.31.0/24" for POST!
    returnObj.terminal_ip_address = returnObj.terminal_service_ip.substringBeforeLast('.') + '.0/24';
    //log those callouts!
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return returnObj;
  }
  @AuraEnabled public static String updateTerminal(String terminal_id,
                                                   String terminal_ip_address,
                                                   String template_id,
                                                   Decimal terminaltype_id){
    //Need to use Decimal data type becuase Salesforce.com chokes on Integer!
    String returnString = 'Initializing...';
    //Try - catch
    serviceResults returnedLog = Service_HTSRegions.updateTerminal(
                                  terminal_id,
                                  terminal_ip_address,
                                  template_id,
                                  terminaltype_id);
    Integer indexOfJobId = returnedLog.message.indexOf('Job ID: ');
    returnString = returnedLog.message.substring(indexOfJobId + 8, indexOfJobId + 8 + 36);
    return returnString;
  }
}