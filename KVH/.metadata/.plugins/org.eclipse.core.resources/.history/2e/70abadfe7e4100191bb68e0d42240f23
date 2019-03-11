public with sharing class HTS_ltgsvc_termStatus {
  @AuraEnabled public static map<string,string> lookupVTID(string VTID){
    /* Need to return a map of <string, string> like
	   *  {
		 *	  "obj_id":"8787",
		 *    "obj_revision":"2",
		 *	  "VTID_id":"a7b130000008rgHAAQ",
		 *	  "asset_id":"02i1300000Ay9yiAAB",
     *    "configTemplate":"CONUS_STANDARD.0009"
		 *	}
		 * NOTE: obj_id & obj_revision native data type is INTEGER! type conversions required!!!
		 */
		map<string,string> returnMap = new map<string,string>();
		Helpers help = new Helpers();
		returnMap.putAll(help.getTerminalFromOSS(VTID));
		returnMap.putAll(help.getAssetIdFromSFDC(VTID));
		returnMap.putAll(help.getVTIDidFromSFDC(VTID));
		return returnMap;
  }
  @AuraEnabled public static list<HTSOSS_hts_subscribers> getSubscriberFromOSS(string VTID){
    list<HTSOSS_hts_subscribers> returnList = new list<HTSOSS_hts_subscribers>();
    HTS_ltgsvc_diagnostics diag = HTS_ltgsvc_diagnostics.getActiveSubscriptions(VTID);
    returnList = diag.activeSubscriptions;
    return returnList;
  }
  @AuraEnabled public static HTSOSS_hts_terminals_status getStatusbyId(string obj_id_string){
    HTSOSS_hts_terminals_status returnStatus = new HTSOSS_hts_terminals_status();
    HTSOSS_hts_terminals oneTerminal = new HTSOSS_hts_terminals();
    oneTerminal.obj_id = integer.valueOf(obj_id_string);
    //TODO: handle different responses, empty, 500...
    try{
      returnStatus = returnStatus.getTerminalStatus(oneTerminal);
      if(returnStatus.response_code == 200){
        returnStatus.message = 'Terminal Status returned from HTSOSS';
      } else if(returnStatus.response_code == 404){
        returnStatus.message = 'Terminal Status not found...';
      } else {
        returnStatus.message = 'Unexpected Error...';
      }
    } catch (Exception e) {
      returnStatus.response_code = 500;
      returnStatus.message = e.getMessage();
      system.debug(returnStatus.message);
    }
    return returnStatus;
  }

  /* Helper Class */
  @testVisible private Class Helpers{
	  @testVisible private map<string,string> getTerminalFromOSS(string VTID){
	    map<string,string> returnMap = new map<string,string>();
	    HTSOSS_hts_terminals oneTerminal = new HTSOSS_hts_terminals();
	    HTSOSS_hts_terminals.terminals_list_wrapper terminalList = new HTSOSS_hts_terminals.terminals_list_wrapper();
	    terminalList = oneTerminal.getTerminals(null, VTID);
	    //system.assertEquals(1, terminalList.terminals_list.size(), 'More than one Satellite Router with the same name!!');
	    system.debug('A list of one Terminal: ' + terminalList);
	    if(terminalList.terminals_list.size() == 0){
	      returnMap.put('obj_id','ERROR:Terminal not found...');
	      returnMap.put('obj_revision','ERROR:Terminal not found...');
        returnMap.put('configTemplate','ERROR:Terminal not found...');
	    } else if(terminalList.terminals_list.size() > 1){
	      returnMap.put('obj_id','ERROR:Multiple Terminals found. This is bad');
	      returnMap.put('obj_revision','ERROR:Multiple Terminals found. This is bad');
        returnMap.put('configTemplate','ERROR:Multiple Terminals found. This is bad');
	    } else {
	      returnMap.put('obj_id',String.valueOf(terminalList.terminals_list[0].obj_id));              //here's that type conversion!
	      returnMap.put('obj_revision',String.valueOf(terminalList.terminals_list[0].obj_revision));  //here's that type conversion!
        returnMap.put('configTemplate',terminalList.terminals_list[0].template_id); 
	    }
	    return returnMap;
	  }
	  @testVisible private map<string,string> getAssetIdFromSFDC(string VTID){
	    map<string,string> returnMap = new map<string,string>();
	    list<Asset> assetList = [SELECT Id FROM Asset WHERE Name =: VTID];
      if(assetList.size() == 0){
        returnMap.put('asset_id','ERROR:Asset not found...');
      } else if(assetList.size() > 1){
        returnMap.put('asset_id','ERROR:Multiple Assets found. This is bad');
      } else {
        returnMap.put('asset_id',assetList[0].Id);              
      }
	    return returnMap;
	  }
	  @testVisible private map<string,string> getVTIDidFromSFDC(string VTID){
      map<string,string> returnMap = new map<string,string>();
      list<HTS_Virtual_Terminal_ID__c> VTIDlist = [SELECT Id FROM HTS_Virtual_Terminal_ID__c WHERE Virtual_Terminal_Id__c =: VTID];
      if(VTIDlist.size() == 0){
        returnMap.put('VTID_id','ERROR:Virtual Terminal Id not found...');
      } else if(VTIDlist.size() > 1){
        returnMap.put('VTID_id','ERROR:Multiple Virtual Terminal Ids found. This is bad');
      } else {
        returnMap.put('VTID_id',VTIDlist[0].Id);
      }
      return returnMap;
    }
  }
  /* End of Helper Class */
}