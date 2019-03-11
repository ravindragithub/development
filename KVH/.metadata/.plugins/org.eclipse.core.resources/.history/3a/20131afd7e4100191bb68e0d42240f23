public with sharing class HTS_ltgsvc_asynch_monitor {
  public HTS_ltgsvc_asynch_monitor() {
    
  }
  @AuraEnabled public static HTSOSS_hts_terminals_asynch getAsynchStatusByObjId(string obj_id){
    HTSOSS_hts_terminals_asynch returnObj = new HTSOSS_hts_terminals_asynch();
    //We can make the callout here...
    HTSOSS_hts_terminals_asynch paramObj = new HTSOSS_hts_terminals_asynch();
    paramObj.obj_id = obj_id;
    try{
      returnObj = returnObj.getAsyncStatus(paramObj);
    } catch(exception e){
      returnObj.response_code = 500;
      returnObj.message = e.getMessage();
    }
    system.debug(returnObj);
    system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
    return returnObj;
  }
}