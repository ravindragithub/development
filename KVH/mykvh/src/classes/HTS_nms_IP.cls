public with sharing class HTS_nms_IP {
  Pattern nmsIpPattern {get; private set;}

  public HTS_nms_IP() {
    nmsIpPattern = Pattern.compile('^([0-9]{1,3}\\.){3}[0-9]{1,3}$');
  }

  public list<HTS_nms_IP__c> generateNmsIPs(String startingIP, String endingIP){
    list<HTS_nms_IP__c> returnList = new list<HTS_nms_IP__c>();
    integer counter = 0;
    HTS_ip_addresses util = new HTS_ip_addresses(); //need to borrow a few methods...
    String currentIp = startingIp;
    while(currentIp != endingIP){
      if(validateNmsIP(currentIp)){     //need to skip IPs that end in .0 or .255 or fail regex match
        HTS_nms_IP__c returnIP = new HTS_nms_IP__c();
        returnIp.nms_IP__c = currentIp;
        returnIp.nms_IP_HEX__c = util.getHExIp(currentIp);
        returnList.add(returnIp);
        counter++;
      }
      currentIp = util.incrementIpAddress(4, currentIp);
    }
    //don't forget tp process the endingIP!!
    if(validateNmsIP(currentIp)){
      HTS_nms_IP__c returnIP = new HTS_nms_IP__c();
      returnIp.nms_IP__c = currentIp;
      returnIp.nms_IP_HEX__c = util.getHExIp(currentIp);
      returnList.add(returnIp);
      counter++;
    }
    system.debug('Total gererated NMS Ips: ' + counter);
    returnList = insertNmsIps(returnList);
    return returnList;
  }
  public String claimNextNmsIp(){
    HTS_nms_IP__c returnIP = new HTS_nms_IP__c();
    returnIP = [SELECT Id, nms_IP__c, nms_IP_HEX__c, isReserved__c, Date_Issued__c
                FROM HTS_nms_IP__c
                WHERE isReserved__c = false AND Date_Issued__c = null 
                ORDER BY SystemModStamp ASC, nms_IP_HEX__c ASC
                LIMIT 1];
    returnIP.Date_Issued__c = datetime.now();
    update returnIP;
    return returnIP.nms_IP__c;
  }
  public HTS_nms_IP__c reclaimNmsIp(String reclaimedIP){
    //validate input....
    system.debug('Reclaiming IP: ' + reclaimedIP);
    system.debug('REGEX validation results: ' + validateNmsIP(reclaimedIP));
    HTS_nms_IP__c returnIP = new HTS_nms_IP__c();
    if(!validateNmsIP(reclaimedIP)){
      insertWarningCase('IP being reclaimed is invalid: ' + reclaimedIP);
      return returnIP;
    }
    list<HTS_nms_IP__c> nmsIpList = [SELECT Id, nms_IP__c, nms_IP_HEX__c, isReserved__c, Date_Issued__c
                FROM HTS_nms_IP__c
                WHERE nms_IP__c =: reclaimedIP];
    //validate only one!
    system.debug('List of nms IPs: ' + returnIP);
    if(nmsIpList.size() == 1){  //happy path
      nmsIpList[0].isReserved__c = false;
      nmsIpList[0].Date_Issued__c = null;
      update nmsIpList[0];
      returnIP = nmsIpList[0];
    } else {  //Houston, we have a problem
      insertWarningCase('Found ' + nmsIpList.size() + ' nms IPs matching: ' + reclaimedIP);
    }
    return returnIP;
  } 
  @testVisible private list<HTS_nms_IP__c> insertNmsIps(list<HTS_nms_IP__c> insertList){
    Database.SaveResult[] srList = Database.insert(insertList, false);
    String errorDetails = '';
    // Iterate through each returned result
    for (Database.SaveResult sr : srList) {
      if (!sr.isSuccess()) {
        // Operation failed, so get all errors                
        for(Database.Error err : sr.getErrors()) {
            errorDetails = errorDetails + 'The following error has occurred.\t';                    
            errorDetails = errorDetails + err.getStatusCode() + ': ' + err.getMessage() +'\t';
            errorDetails = errorDetails + ' nms IP fields that affected this error: ' + err.getFields() +'\n';
        }
      }
    }
    if(errorDetails != ''){
      insertWarningCase(errorDetails);
    }
    system.debug(errorDetails);
    return insertList;
  }

  @testVisible private Boolean validateNmsIP(String currentIp){
    Boolean returnBool = true; //optimistic processing
    //regex for testing IP pattern
    Matcher isIP = nmsIpPattern.matcher(currentIp);
    //kickout for ending in .0, .255, or not a valid IP
    if((!isIP.matches()) || (currentIp.endsWith('.0') || currentIp.endsWith('.255'))){
      returnBool = false;
    }
    return returnBool;
  }
  @testVisible private void insertWarningCase(String errorDetails){
    Id ServCloud_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
    Case returnCase = new Case();
    returnCase.RecordTypeId = ServCloud_RECORD_TYPE_ID;
    returnCase.Origin = 'System Generated';
    returnCase.status = 'New';
    returnCase.subject = 'Error while generating nms IPs';
    returnCase.description = errorDetails;
    //Custom Fields....
    returnCase.Case_Symptom__c = 'Salesforce Error';
    insert returnCase;
    return;
  }
}