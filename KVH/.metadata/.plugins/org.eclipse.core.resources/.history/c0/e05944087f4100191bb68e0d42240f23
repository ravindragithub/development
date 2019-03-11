@isTest
private class OSS_base_test {
  @testSetup static void setupTestData(){
    //setup common test data here
    //We need to setup the Custom Setting here... 
    string org_id = UserInfo.getOrganizationId();// This sets up the Current Org as the "Production" Org regardless of instance....
    Production_Org_Ids__c mySetting = Production_Org_Ids__c.getOrgDefaults();
    mySetting.Org_Id_18_char__c = org_id;
    mySetting.Org_Id_15_char__c = org_id.left(15);
    upsert mySetting;
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
    //This just verifies that the Current Org Id (Production or Sandbox) got setup in the Custom Setting as the Production Org Id....
    string org_id = UserInfo.getOrganizationId();
    Production_Org_Ids__c mySetting = Production_Org_Ids__c.getOrgDefaults();
    system.assertEquals(org_id, mySetting.Org_Id_18_char__c);
    
  }
  static testMethod void test_ProductionInstanceAwareness(){
    //We already setup the the Current Org Id (Production or Sandbox) in the Custom Setting as Production Org Id
    //So this should work regardless of the instance that we are running in
    //This tests should exhibit Production Behaviour regardless of where run
    system.assertEquals('callout:HTSOSS', OSS_base.getbase_endpoint());
  }
  static testMethod void test_SandboxInstanceAwareness(){
    string mockProductionOrgId = '00D000000000000AAA';  //not a real Org Id!
    Production_Org_Ids__c mySetting = Production_Org_Ids__c.getOrgDefaults();
    mySetting.Org_Id_18_char__c = mockProductionOrgId;
    mySetting.Org_Id_15_char__c = mockProductionOrgId.left(15);
    upsert mySetting;  //but we are going to pretend it is for test purposes by putting it in the Custom Setting
    //This test should exhibit SANDBOX Behaviour regardless of where run
    system.assertEquals('callout:HTSOSS_dev', OSS_base.getbase_endpoint());
  }
  static testMethod void test_getHttpRequestTemplate(){
    HttpRequest req = OSS_base.getHttpRequestObj('POST', '/hts/satelliterouters/');
    system.assertEquals('callout:HTSOSS' + '/hts/satelliterouters/', req.getEndpoint());
    system.assertEquals('POST', req.getMethod());
    system.assertEquals(UserInfo.getUserId(), req.getHeader('x-oss-remote-user'));
    system.assertEquals('application/json', req.getHeader('Content-Type'));
  }
  static testMethod void test_stringify_qparams() {
    // TO DO: implement unit test
    Map<string, String> m1 = new Map<string, String>();
    m1.put('1', 'First item');
    m1.put('2', 'Second+item');
    m1.put('3', 'Third item');
    m1.put('4', 'Fourth+item');
    
    string qparams = OSS_base.stringify_qparams(m1);
    system.debug(qparams);
    //URL Encoding does not seem to work super good....
    system.assertEquals('?1=First+item&2=Second%2Bitem&3=Third+item&4=Fourth%2Bitem', qparams);
    
    Map<string, String> m2 = new Map<string, String>();
    qparams = OSS_base.stringify_qparams(m2);
    system.debug(qparams);
    system.assertEquals('', qparams);
  }
}