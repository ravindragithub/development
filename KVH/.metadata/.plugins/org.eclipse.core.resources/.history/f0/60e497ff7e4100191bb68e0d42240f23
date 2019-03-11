public with sharing class HTS_terminal_templates {
  //TODO implment base Class
  //TODO extend Base Class to this and HTS_subscriber_Templates
  public HTS_terminal_templates() {
    
  }
  public HTSOSS_hts_collections.rtp getCollectionsFromOss() { 
    HTSOSS_hts_collections returnObj = new HTSOSS_hts_collections();
    HTSOSS_hts_collections.rtp s = returnObj.getRtp();
    system.debug(s);
    return s;
  }
  public list < HTSOSS_hts_collections.terminal_templates > getTerminalTemplatesFromOSS() {
    list < HTSOSS_hts_collections.terminal_templates > returnList = new list < HTSOSS_hts_collections.terminal_templates > ();
    HTSOSS_hts_collections.rtp collections = getCollectionsFromOss();
    //TODO: check responseCode, Message and handle failed Callout
    returnList = collections.terminal_templates;
    return returnList;
  }
  public list < HTS_Terminal_Template__c > getTerminalTemplatesFromSalesforce() {
    list < HTS_Terminal_Template__c > sfTemplates = new list < HTS_Terminal_Template__c > ();
    sfTemplates = [SELECT Id, Name, obj_id__c, Status__c, Region__c, Version__c, SystemModStamp 
                   FROM HTS_Terminal_Template__c];
    return sfTemplates;
  }
  public string synchronizeHTSTemplatesWithOSS(){
    //Read from sf and Convert to Map
    list<HTS_Terminal_Template__c> sfTemplates = getTerminalTemplatesFromSalesforce();
    map<String, HTS_Terminal_Template__c> sfMap = new map<String, HTS_Terminal_Template__c>();
    for(HTS_Terminal_Template__c p : sfTemplates){
      sfMap.put(p.obj_id__c, p);
    }
    system.debug(sfMap);

    //Read from OSS and convert to Map
    list <HTSOSS_hts_collections.terminal_templates> ossTemplates = getTerminalTemplatesFromOSS();
    map<String, HTSOSS_hts_collections.terminal_templates> ossMap= new map<String, HTSOSS_hts_collections.terminal_templates>();
    for(HTSOSS_hts_collections.terminal_templates p : ossTemplates){
      ossMap.put(p.obj_id, p);
    }
    system.debug(ossMap);

    //Add new Templates from OSS
    list<HTS_Terminal_Template__c> newTemplates = new list<HTS_Terminal_Template__c>();
    for(HTSOSS_hts_collections.terminal_templates p : ossTemplates){  //iterate through OSS plans
      if(! sfMap.containsKey(p.obj_id)){                      //see if no match in SF
        newTemplates.add(new HTS_Terminal_Template__c(obj_id__c = p.obj_id, Name = p.obj_name, Version__c = p.version));
      }
    }
    system.debug(newTemplates);
    insert newTemplates;

    //Change modified or removed OSS Templates
    list<HTS_Terminal_Template__c> modifiedTemplates = new list<HTS_Terminal_Template__c>();
    for(HTS_Terminal_Template__c p : sfTemplates){     //iterate through SF Plans
      if(! ossMap.containsKey(p.obj_id__c)){    //see if no match in OSS
        HTS_Terminal_Template__c moddedTemplate = p;
        if(moddedTemplate.status__c != 'Deprecated'){
          moddedTemplate.status__c = 'Deprecated';                  //must match picklist!!
          modifiedTemplates.add(moddedTemplate);
        } //else it's already deprecated!
      //check for changes...
      } else if(p.Name != ossMap.get(p.obj_id__c).obj_name ||
                p.Version__c != ossMap.get(p.obj_id__c).version){
        HTS_Terminal_Template__c updateTemplate = p;
        updateTemplate.status__c = 'Updated from OSS';
        updateTemplate.Version__c = ossMap.get(p.obj_id__c).version;
        updateTemplate.Name = ossMap.get(p.obj_id__c).obj_name;
        modifiedTemplates.add(updateTemplate);
      }
    }
    system.debug(modifiedTemplates);
    update modifiedTemplates;
    return 'Synchronize HTS Templates with OSS Job Complete. ADDED: ' + newTemplates.size() + ' new OSS Templates to Salesforce. MODIFIED: ' + modifiedTemplates.size() + ' existing Templates in Salesforce.';
  }
}