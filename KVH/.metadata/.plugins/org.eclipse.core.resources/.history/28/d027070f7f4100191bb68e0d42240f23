@RestResource(urlMapping='/V1/iccid_maps/*')
global with sharing class REST_iccid_maps {
  @HttpGet
  //responds to an HTTP GET naturally...
  global static IccidMappings doGet(){
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    IccidMappings returnObj = new IccidMappings();
    returnObj.time_stamp = String.valueOfGmt(DateTime.now());
    returnObj.iccid_mappings = new list<IccidMap>();
    //Need to get all Assets where root_Asset__c.Product2.Name == 01-0419
    //and coerce them into a map of maps
    list<Asset> readList = [SELECT Id, Name, Product2.ProductCode, Root_Asset__r.Id 
                            FROM ASSET 
                            WHERE Root_Asset__r.Product2.ProductCode = '01-0419'
                            ORDER BY Root_Asset__c ASC];
    map<Id, map<String, Asset>> systemMap = new map<Id, map<String, Asset>>();
    for(Asset a : readList){
      if(systemMap.get(a.Root_Asset__r.Id) == null){
        map<String, Asset> newMap = new map<String, Asset>();
        newMap.put(a.Product2.ProductCode, a);
        systemMap.put(a.Root_Asset__r.Id, newMap);
      } else {
        systemMap.get(a.Root_Asset__r.Id).put(a.Product2.ProductCode, a);
      }
    }
    //Ideally we get all subscriptions where Traffic_id ends with -11
    //but we are instead going to derive that for now.
    //and put them into the maps
    for(Id i : systemMap.keySet()){
      if(systemMap.get(i).get('Virtual Terminal ID') == null){  //not provisioned
        continue;                                               //skip this one
      }
      IccidMap simMap = new IccidMap();
      simMap.iccid = systemMap.get(i).get('19-1035').Name;
      simMap.traffic_id = systemMap.get(i).get('Virtual Terminal ID').Name.left(8) + '-11';
      returnObj.iccid_mappings.add(simMap);
    }
    return returnObj;
  }
  //Inner Class to be returned
  global Class IccidMappings {
    public String time_stamp {get; set;}
    public list<IccidMap> iccid_mappings {get; set;}
  }
  global Class IccidMap{
    public String iccid {get; set;}
    public String traffic_id {get; set;}
  }
}