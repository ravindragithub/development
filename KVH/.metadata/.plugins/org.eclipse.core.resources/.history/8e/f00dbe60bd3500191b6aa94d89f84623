public with sharing class HTS_ltgsvc_rebuildTerminal {
  //Top level atributes to communicate with Lightning Components
  @AuraEnabled public string statusMessage {get;set;}
  @AuraEnabled public list<Asset> assetCollection {get;set;}
  @AuraEnabled public HTSOSS_hts_terminals term {get;set;}

  //Constructor
	public HTS_ltgsvc_rebuildTerminal() {
		
	}

  @AuraEnabled public static HTS_ltgsvc_rebuildTerminal verifyAssetType(string recId){
    HTS_ltgsvc_rebuildTerminal returnObj = new HTS_ltgsvc_rebuildTerminal();
    returnObj.statusMessage = 'DEFAULT: No Results'; //default return value
    //Need a Product2 reference for the Asset. Get it from the Custom Metadata Type
    Default_Identifier_Product__mdt VTIDproduct = [SELECT Identifier_Product_reference__c, Legacy_Product_Id__c
                                                    FROM Default_Identifier_Product__mdt 
                                                    WHERE DeveloperName =: 'Virtual_Terminal_Id'];
    system.debug('MDT Product Id: ' + VTIDproduct.Identifier_Product_reference__c);
    try{
      returnObj.assetCollection = [SELECT Id, Name, Product2Id FROM Asset WHERE Id =: recId];
      system.debug('Asset Product Id: ' + returnObj.assetCollection[0].Product2Id);
      if(VTIDproduct.Identifier_Product_reference__c != returnObj.assetCollection[0].Product2Id){
        returnObj.statusMessage  = 'ERROR: This is not a Virtual Terminal Id';
      } else {
        returnObj.statusMessage  = 'SUCCESS: Virtual Terminal Id verified';
      }
    } catch(Exception e){
      returnObj.statusMessage  = 'EXCEPTION: Salesforce threw an exception';
    }
    return returnObj;
  }

  @AuraEnabled public static HTS_ltgsvc_rebuildTerminal getTerminalFromOSS(string VTID){
    HTS_ltgsvc_rebuildTerminal returnObj = new HTS_ltgsvc_rebuildTerminal();
    returnObj.statusMessage = 'DEFAULT: No Results'; //default return value
    try{
      HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
      system.debug('Step 2a. GET Terminals (a list of ONE filtered by NAME)');
      HTSOSS_hts_terminals.terminals_list_wrapper terminalList = new HTSOSS_hts_terminals.terminals_list_wrapper();
      terminalList = term1.getTerminals(null, VTID);
      //We might get one, or none... probably shouldn't get two!
      system.debug('A list of one Terminal: ' + terminalList);
      term1.obj_id = terminalList.terminals_list[0].obj_id;
      term1.obj_revision = terminalList.terminals_list[0].obj_revision;
      returnObj.term = term1;
      system.debug(returnObj.term);
      //initiate rebuild process here!
      returnObj.statusMessage = 'SUCCESS: retrieved results for one Terminal';
    } catch (exception e){
      returnObj.statusMessage  = 'EXCEPTION: Salesforce threw an exception';
    }
    system.debug(returnObj);
    system.debug(CalloutLogs.commitLogs());
    return returnObj;
  }

  @AuraEnabled public static HTS_ltgsvc_rebuildTerminal rebuildTerminalInOSS_old(map<String, Decimal> termMap){
    //Must be map<sting, decimal> per trial and error!
    system.debug(termMap);
    system.debug('invoking method...');
    HTS_ltgsvc_rebuildTerminal returnObj = new HTS_ltgsvc_rebuildTerminal();
    HTSOSS_hts_terminals terminal = new HTSOSS_hts_terminals();
    HTS_ltgsvc_rebuildTerminal.Helpers help = new HTS_ltgsvc_rebuildTerminal.Helpers();

    terminal.obj_id = integer.valueOf(termMap.get('obj_id'));
    terminal.obj_revision = integer.valueOf(termMap.get('obj_revision'));

    //FIRST get all the details about the terminal
    terminal = help.getTerminalDetails(terminal);
    returnObj.statusMessage = 'SUCCESS: collected terminal details from OSS';
    system.debug(returnObj);
    //SECOND PUT to Teminals setting is_Active to false
    returnObj.term = help.putTerminalInActive(terminal);
    if(returnObj.term.response_code == 204){
      returnObj.statusMessage = 'SUCCESS: Set Terminal to Inactive via PUT';
    } else {
      returnObj.statusMessage = 'EXCEPTION: Could not PUT Terminal to Inactive';
    }
    
    system.debug(returnObj);
    //THIRD DELETE to Terminals removing from OSS
    returnObj.term = help.deleteTerminal(terminal);
    if(returnObj.term.response_code == 204){
      returnObj.statusMessage = 'SUCCESS: Deleted Terminal from OSS';
    } else {
      returnObj.statusMessage = 'EXCEPTION: Could not DELETE Terminal';
    }
    system.debug(returnObj);
    //FOURTH POST terminal back to OSS
    //terminal_service_ip looks like "10.64.31.1"... but we want "10.64.31.0/24" for POST!
    terminal.terminal_ip_address = terminal.terminal_service_ip.substringBeforeLast('.') + '.0/24';


    HTSOSS_hts_terminals_asynch termAsync = new HTSOSS_hts_terminals_asynch();
    //map attributes...
    termAsync.coremodule_id = terminal.coremodule_id;
    termAsync.mgmtipaddress = terminal.mgmtipaddress;
    termAsync.template_id = terminal.template_id;
    termAsync.terminal_ip_address = terminal.terminal_ip_address;
    termAsync.terminal_id = terminal.terminal_id;
    termAsync.terminaltype_id = terminal.terminaltype_id;

    termAsync = help.helpPostTerminalAsynch(termAsync);
    if(termAsync.response_code == 200){
      returnObj.statusMessage = 'SUCCESS: ' + termAsync.obj_id + ' Enqueued in OSS';
    } else {
      returnObj.statusMessage = 'EXCEPTION: Could not POST Terminal';
    }
    
    system.debug(returnObj);
    //FOURTH Create Subscriber as needed
    //FIFTH Delete Subscriber as needed
    system.debug(returnObj);
    system.debug(CalloutLogs.commitLogs());
    return returnObj;
  }

  @AuraEnabled public static HTS_ltgsvc_rebuildTerminal rebuildTerminalInOSS(map<String, Decimal> termMap){
    //Must be map<sting, decimal> per trial and error!
    system.debug(termMap);
    system.debug('invoking method...');
    HTS_ltgsvc_rebuildTerminal returnObj = new HTS_ltgsvc_rebuildTerminal();
    HTSOSS_hts_terminals terminal = new HTSOSS_hts_terminals();
    HTS_ltgsvc_rebuildTerminal.Helpers help = new HTS_ltgsvc_rebuildTerminal.Helpers();

    terminal.obj_id = integer.valueOf(termMap.get('obj_id'));
    terminal.obj_revision = integer.valueOf(termMap.get('obj_revision'));

    //FIRST get all the details about the terminal
    terminal = help.getTerminalDetails(terminal);
    returnObj.statusMessage = 'SUCCESS: collected terminal details from OSS';
    system.debug(returnObj);

    terminal.terminal_ip_address = terminal.terminal_service_ip.substringBeforeLast('.') + '.0/24';

    HTSOSS_hts_terminals_asynch termAsync = new HTSOSS_hts_terminals_asynch();
    //map attributes...
    termAsync.coremodule_id = terminal.coremodule_id;
    termAsync.mgmtipaddress = terminal.mgmtipaddress;
    termAsync.template_id = terminal.template_id;
    termAsync.terminal_ip_address = terminal.terminal_ip_address;
    termAsync.terminal_id = terminal.terminal_id;
    termAsync.terminaltype_id = terminal.terminaltype_id;

    //Create "replace" instance...
    HTSOSS_hts_terminals_replace termRepl = new HTSOSS_hts_terminals_replace();
    termRepl.terminals.add(termAsync);

    termRepl = termRepl.postTerminalsToReplace(termRepl);
    if(termRepl.response_code == 202 && termRepl.terminals.size() == 1){
      returnObj.statusMessage = 'SUCCESS: ' + termRepl.terminals[0].obj_id + ' Enqueued in OSS';
    } else if(termRepl.response_code == 202 && termRepl.terminals.size() > 1){
      returnObj.statusMessage = 'SUCCESS: ' + termRepl.terminals.size() + ' jobs Enqueued in OSS';
    }else {
      returnObj.statusMessage = 'EXCEPTION: Could not POST Terminal';
    }
    
    system.debug(returnObj);
    system.debug(CalloutLogs.commitLogs());
    return returnObj;
  }
  
  //HELPERS
  @testVisible private class Helpers{
    @testVisible private HTSOSS_hts_terminals getTerminalDetails(HTSOSS_hts_terminals term1){
      HTSOSS_hts_terminals returnTerm = new HTSOSS_hts_terminals();
      returnTerm = term1.getTerminal(term1);
      return returnTerm;
    }
    @testVisible private HTSOSS_hts_terminals putTerminalInActive(HTSOSS_hts_terminals term1){
      HTSOSS_hts_terminals returnTerm = new HTSOSS_hts_terminals();
      term1.is_active = false;
      returnTerm = term1.putTerminal(term1);
      return returnTerm;
    }
    @testVisible private HTSOSS_hts_terminals deleteTerminal(HTSOSS_hts_terminals term1){
      HTSOSS_hts_terminals returnTerm = new HTSOSS_hts_terminals();
      returnTerm = term1.deleteTerminal(term1);
      return returnTerm;
    }
    @testVisible private HTSOSS_hts_terminals postTerminal(HTSOSS_hts_terminals term1){
      HTSOSS_hts_terminals returnTerm = new HTSOSS_hts_terminals();
      //Check Template Status
      if(term1.template_id != 'CONUS_STANDARD'){
        //TODO refactor to handle obsolete templates... handle default, etc. "region" based management
        term1.template_id = 'CONUS_STANDARD';
      }
      returnTerm = term1.postTerminal(term1);
      return returnTerm;
    }
    @testVisible private HTSOSS_hts_terminals_asynch helpPostTerminalAsynch(HTSOSS_hts_terminals_asynch term1){
      HTSOSS_hts_terminals_asynch  returnTerm = new HTSOSS_hts_terminals_asynch ();
      returnTerm = term1.postTerminalAsynch(term1);
      return returnTerm;
    }
  }


}