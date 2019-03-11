global class Populate_staticIp_hexIps_batch implements Database.Batchable<sObject> {
  
  global Populate_staticIp_hexIps_batch() {
    
  }
  
  global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator([SELECT Id, Name, HTS_IP_HEX_Address__c 
                                        FROM HTS_Static_IPs__c
                                        WHERE HTS_IP_HEX_Address__c = '']);
  }

  global void execute(Database.BatchableContext BC, List<sObject> scope) {
    HTS_ip_addresses util = new HTS_ip_addresses();
    system.debug(scope.size());
    for(sObject s : scope){
      HTS_Static_IPs__c h = (HTS_Static_IPs__c)s;
      h.HTS_IP_HEX_Address__c = util.getHexIP(h.Name);
    }
    update scope;
  }
  
  global void finish(Database.BatchableContext BC) {
    
  }
  
}