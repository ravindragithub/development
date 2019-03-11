public with sharing class HTS_ltgsvc_asynchJobStatus {

  @AuraEnabled public static HTSOSS_hts_terminals_asynch getAsynchStatusByVtid(string termId){
    //query SF CalloutLogs for POST to terminals/asynch
    HTSOSS_hts_terminals_asynch returnObj = new HTSOSS_hts_terminals_asynch();
    list<Callout_Log__c> readList = new list<Callout_Log__c>();
    readList = [SELECT Id, HTS_Terminal_Id__c, Res_Body__c FROM Callout_Log__c
                WHERE HTS_Terminal_Id__c =: termId 
                AND Req_Method__c = 'POST' 
                AND Req_Endpoint__c LIKE '%/hts/terminals/async' 
                ORDER BY Name DESC LIMIT 1];
    if(readList.size() == 0){ //NO RECORDS RETURNED!!
      returnObj.response_code = 400;
      returnObj.message ='ERROR: Asynchronous Job for Terminal ID ' + termId + ' not found!';
      return returnObj;
    }
    //We can make the callout here...
    HTSOSS_hts_terminals_asynch paramObj = new HTSOSS_hts_terminals_asynch();
    paramObj.obj_id = readList[0].Res_Body__c.substringBeforeLast('"').right(36);
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
  /*Temporary method that returns a mock result for testing JS and ltg*/
  @AuraEnabled public static HTSOSS_hts_terminals_asynch getAsynchStatusByVtid_mock(string termId){
    HTSOSS_hts_terminals_asynch returnObj = new HTSOSS_hts_terminals_asynch();
    //'{"complete": true,"obj_id": "75a0f8c1-9684-49df-b649-070bfb5a0912","result": true}'
    returnObj.complete = false;
    returnObj.result = false;
    returnObj.obj_id = '75a0f8c1-9684-49df-b649-070bfb5a0912';
    returnObj.response_code = 200;
    return returnObj;
  }
  /*END termporary method */
}