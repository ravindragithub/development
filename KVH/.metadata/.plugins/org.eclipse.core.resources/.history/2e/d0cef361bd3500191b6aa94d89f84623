public with sharing class HTS_subscriber_plans {
  public HTS_subscriber_plans() {

  }
  public HTSOSS_hts_collections.rtp getCollectionsFromOss() {
    HTSOSS_hts_collections returnObj = new HTSOSS_hts_collections();
    HTSOSS_hts_collections.rtp s = returnObj.getRtp();
    system.debug(s);
    return s;
  }
  public list < HTSOSS_hts_collections.subscriber_plans > getSubscriberPlansFromOSS() {
    list < HTSOSS_hts_collections.subscriber_plans > returnList = new list < HTSOSS_hts_collections.subscriber_plans > ();
    HTSOSS_hts_collections.rtp collections = getCollectionsFromOss();
    //TODO: check responseCode, Message and handle failed Callout
    returnList = collections.subscriber_plans;
    return returnList;
  }
  public list < HTS_subscriber_plans__c > getSuscriberPlansFromSalesforce() {
    list < HTS_subscriber_plans__c > sfPlans = new list < HTS_subscriber_plans__c > ();
    sfPlans = [SELECT Id, Name, API_Name__c, Status__c, SystemModStamp,
                      download_cir__c, upload_cir__c, 
                      in_bmc_download_mir__c, in_bmc_upload_mir__c,
                      out_bmc_download_mir__c, out_bmc_upload_mir__c
                      FROM HTS_subscriber_plans__c];
    return sfPlans;
  }
  public string synchronizeHTSPlansWithOss(){
    //Read from sf and Convert to Map
    list<HTS_subscriber_plans__c> sfPlans = getSuscriberPlansFromSalesforce();
    map<String, HTS_subscriber_plans__c> sfMap = new map<String, HTS_subscriber_plans__c>();
    for(HTS_subscriber_plans__c p : sfPlans){
      sfMap.put(p.API_Name__c, p);
    }
    system.debug(sfMap);

    //Read from OSS and convert to Map
    list <HTSOSS_hts_collections.subscriber_plans> ossPlans = getSubscriberPlansFromOSS();
    map<String, HTSOSS_hts_collections.subscriber_plans> ossMap= new map<String, HTSOSS_hts_collections.subscriber_plans>();
    for(HTSOSS_hts_collections.subscriber_plans p : ossPlans){
      ossMap.put(p.obj_id, p);
    }
    system.debug(ossMap);

    //Add new plans from OSS
    list<HTS_subscriber_plans__c> newPlans = new list<HTS_subscriber_plans__c>();
    for(HTSOSS_hts_collections.subscriber_plans p : ossPlans){  //iterate through OSS plans
      if(! sfMap.containsKey(p.obj_id)){                      //see if no match in SF
        newPlans.add(new HTS_subscriber_plans__c(API_Name__c = p.obj_id, Name = p.obj_name,
                                                 download_cir__c = p.download_cir,
                                                 in_bmc_download_mir__c = p.in_bmc_download_mir,
                                                 in_bmc_upload_mir__c = p.in_bmc_upload_mir,
                                                 out_bmc_download_mir__c = p.out_bmc_download_mir,
                                                 out_bmc_upload_mir__c = p.out_bmc_upload_mir,
                                                 upload_cir__c = p.upload_cir));
      }
    }
    system.debug(newPlans);
    insert newPlans;

    //Change modified or removed OSS plans
    list<HTS_subscriber_plans__c> updatedPlans = new list<HTS_subscriber_plans__c>();
    for(HTS_subscriber_plans__c p : sfPlans){     //iterate through SF Plans
      if(! ossMap.containsKey(p.API_Name__c)){    //see if no match in OSS
        HTS_subscriber_plans__c deprecPlan = p;
        if(deprecPlan.status__c != 'Deprecated'){
          deprecPlan.status__c = 'Deprecated';      //must match picklist!!
          updatedPlans.add(deprecPlan);
        } //else it's already deprecated!
      //check for changes....
      } else if (p.Name != ossMap.get(p.API_Name__c).obj_name ||
                 p.download_cir__c != ossMap.get(p.API_Name__c).download_cir ||
                 p.in_bmc_download_mir__c != ossMap.get(p.API_Name__c).in_bmc_download_mir ||
                 p.in_bmc_upload_mir__c != ossMap.get(p.API_Name__c).in_bmc_upload_mir ||
                 p.out_bmc_download_mir__c != ossMap.get(p.API_Name__c).out_bmc_download_mir ||
                 p.out_bmc_upload_mir__c != ossMap.get(p.API_Name__c).out_bmc_upload_mir ||
                 p.upload_cir__c != ossMap.get(p.API_Name__c).upload_cir){  //look for changes from OSS...
        HTS_subscriber_plans__c updatPlan = p;
        updatPlan.status__c = 'Updated from OSS';  //must match picklist!!
        updatPlan.Name = ossMap.get(p.API_Name__c).obj_name;
        updatPlan.download_cir__c = ossMap.get(p.API_Name__c).download_cir;
        updatPlan.in_bmc_download_mir__c = ossMap.get(p.API_Name__c).in_bmc_download_mir;
        updatPlan.in_bmc_upload_mir__c = ossMap.get(p.API_Name__c).in_bmc_upload_mir;
        updatPlan.out_bmc_download_mir__c = ossMap.get(p.API_Name__c).out_bmc_download_mir;
        updatPlan.out_bmc_upload_mir__c = ossMap.get(p.API_Name__c).out_bmc_upload_mir;
        updatPlan.upload_cir__c = ossMap.get(p.API_Name__c).upload_cir;
        updatedPlans.add(updatPlan);
      }
    }
    system.debug(updatedPlans);
    update updatedPlans;
    return 'Synchronize HTS Plans with OSS Job Complete. ADDED: ' + newPlans.size() + ' new OSS Plans to Salesforce. MODIFIED: ' + updatedPlans.size() + ' existing Plans in Salesforce.';
  }
}