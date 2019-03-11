@isTest
private class Populate_staticIp_hexIps_batch_test {
  
  private static final integer MAX_LOOP_COUNTER = 20;

  @testSetup static void setupTestData(){
    //setup common test data here
    //Need a bunch of HTS_Static_IPs__c....
    String baseIP = '66.66.66.';
    list<HTS_Static_IPs__c> insertList = new list<HTS_Static_IPs__c>();
    for(integer i = 0; i < MAX_LOOP_COUNTER; i++) {
      HTS_Static_IPs__c ip = new HTS_Static_IPs__c();
      ip.Channel_Id__c = '1703';
      ip.Name = baseIP + i;
      ip.Region__c = 'CONUS';
      insertList.add(ip);
    }
    insert insertList;
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
    //this will protect you from changes to workflow, process, and validation that break your test code!
    list<HTS_Static_IPs__c> readList = [SELECT Id, Name FROM HTS_Static_IPs__c];
    system.assertEquals(MAX_LOOP_COUNTER, readList.size());
  }
  
  static testMethod void test_batch(){
    for(HTS_Static_IPs__c readList : [SELECT Id, Name, HTS_IP_HEX_Address__c FROM HTS_Static_IPs__c]){
      system.assertEquals(null, readList.HTS_IP_HEX_Address__c);
    }
    test.startTest();
    Id jobId = database.executeBatch(new Populate_staticIp_hexIps_batch());
    test.stopTest();
    for(HTS_Static_IPs__c readList : [SELECT Id, Name, HTS_IP_HEX_Address__c FROM HTS_Static_IPs__c]){
      system.assertNotEquals(null, readList.HTS_IP_HEX_Address__c);
      system.assertNotEquals('', readList.HTS_IP_HEX_Address__c);
    }
  }
}