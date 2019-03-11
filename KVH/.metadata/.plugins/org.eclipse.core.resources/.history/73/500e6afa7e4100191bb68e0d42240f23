/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class HTSOSS_base_test {

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
    HTSOSS_base util = new HTSOSS_base();
    //Constructor should exhibit Production Behaviour
    system.assertEquals('callout:HTSOSS', HTSOSS_base.base_endpoint);
    system.assertEquals('callout:HTSOSS', util.getbase_endpoint());
  }
  static testMethod void test_SandboxInstanceAwareness(){
    string mockProductionOrgId = '00D000000000000AAA';  //not a real Org Id!
    Production_Org_Ids__c mySetting = Production_Org_Ids__c.getOrgDefaults();
    mySetting.Org_Id_18_char__c = mockProductionOrgId;
    mySetting.Org_Id_15_char__c = mockProductionOrgId.left(15);
    upsert mySetting;  //but we are going to pretend it is for test purposes byt putting it in the Custom Setting
    HTSOSS_base util = new HTSOSS_base();
    //Constructor should exhibit Sandbox Behaviour
    system.assertEquals('callout:HTSOSS_dev', HTSOSS_base.base_endpoint);
    system.assertEquals('callout:HTSOSS_dev', util.getbase_endpoint());
  }
  static testMethod void test_getHttpRequestTemplate(){
    HTSOSS_base util = new HTSOSS_base();
    HttpRequest req = util.getHttpRequestObj('POST', '/hts/satelliterouters/');
    system.assertEquals(HTSOSS_base.base_endpoint + '/hts/satelliterouters/', req.getEndpoint());
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
    
    HTSOSS_base util = new HTSOSS_base();
    string qparams = util.stringify_qparams(m1);
    system.debug(qparams);
    //URL Encoding does not seem to work super good....
    system.assertEquals('?1=First+item&2=Second%2Bitem&3=Third+item&4=Fourth%2Bitem', qparams);
    
    Map<string, String> m2 = new Map<string, String>();
    qparams = util.stringify_qparams(m2);
    system.debug(qparams);
    system.assertEquals('', qparams);
  }
  static testMethod void test_stringifyErrors(){
    HTSOSS_base util = new HTSOSS_base();
    list<string> testList = new list<string>();
    string validationResults = util.stringifyErrors(testList);
    system.assertEquals('VALID', validationResults);
    testList.add('One stringy-dingy');
    testList.add('Two stringy-dingys');
    testList.add('Three stringy-dingys');
    validationResults = util.stringifyErrors(testList);
    system.assertEquals('INVALID', validationResults.left(7));
  }
  static testMethod void test_terminals_async_POST_Validation_FAIL(){
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    
    term1.coremodule_id = 1234;
    term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'CONUS_STANDARD';
    term1.terminal_ip_address = '10.64.14.0/24';
    //term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    test.startTest();
    HTSOSS_base util = new HTSOSS_base();
    String results = util.validateTerminalForPOST(term1);
    
    system.assert(results.contains('INVALID'), results);
    test.stopTest();
  }
  static testMethod void test_terminals_POST_Validation_FAIL(){
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    term1.coremodule_id = 1234;
    term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'CONUS_STANDARD';
    term1.terminal_ip_address = '10.64.14.0/24';
    //term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    test.startTest();
    HTSOSS_base util = new HTSOSS_base();
    String results = util.validateTerminalForPOST(term1);
    
    system.assert(results.contains('INVALID'), results);
    test.stopTest();
  }
  static testMethod void test_validateTerminalBase(){
    map<String, String> testMap = new map<String, String>();
    HTSOSS_base util = new HTSOSS_base();
    //sequence critical...
    system.assert(util.validateTerminalBase(testMap).contains('Missing coremodule_id'));
    testMap.put('coremodule_id','1a34');
    system.assert(util.validateTerminalBase(testMap).contains('Non-numeric coremodule_id'));
    testMap.put('coremodule_id','1234'); //valid attribute
    
    system.assert(util.validateTerminalBase(testMap).contains('Missing mgmtipaddress'));
    testMap.put('mgmtipaddress','10.242..2');
    system.assert(util.validateTerminalBase(testMap).contains('Invalid mgmtipaddress'));
    testMap.put('mgmtipaddress','10.242.2.');
    system.assert(util.validateTerminalBase(testMap).contains('Invalid mgmtipaddress'));
    testMap.put('mgmtipaddress','10.242.2.1/24');
    system.assert(util.validateTerminalBase(testMap).contains('Invalid mgmtipaddress'));
    testMap.put('mgmtipaddress','10.242.2.2'); //valid attribute

    system.assert(util.validateTerminalBase(testMap).contains('Missing template_id'));
    testMap.put('template_id','CONUS_STANDARD'); //valid attribute

    system.assert(util.validateTerminalBase(testMap).contains('Missing terminal_id'));
    testMap.put('terminal_id','123456789');
    system.assert(util.validateTerminalBase(testMap).contains('Invalid terminal_id'));
    testMap.put('terminal_id','02345678');
    system.assert(util.validateTerminalBase(testMap).contains('Invalid terminal_id'));
    testMap.put('terminal_id','12345670');
    system.assert(util.validateTerminalBase(testMap).contains('Invalid terminal_id'));
    testMap.put('terminal_id','123a5678');
    system.assert(util.validateTerminalBase(testMap).contains('Invalid terminal_id'));
    testMap.put('terminal_id','2345678');
    system.assert(util.validateTerminalBase(testMap).contains('Invalid terminal_id'));
    testMap.put('terminal_id','12305678'); //valid attribute

    system.assert(util.validateTerminalBase(testMap).contains('Missing terminal_ip_address'));
    testMap.put('terminal_ip_address','10.64.14.0');
    system.assert(util.validateTerminalBase(testMap).contains('Invalid terminal_ip_address'));
    testMap.put('terminal_ip_address','10.64.14.0/25');
    system.assert(util.validateTerminalBase(testMap).contains('Invalid terminal_ip_address'));
    testMap.put('terminal_ip_address','10.64..0/25');
    system.assert(util.validateTerminalBase(testMap).contains('Invalid terminal_ip_address'));
    testMap.put('terminal_ip_address','10.64.14.0/24'); //valid attribute

    system.assert(util.validateTerminalBase(testMap).contains('Missing terminaltype_id'));
    testMap.put('terminaltype_id','18a8');
    system.assert(util.validateTerminalBase(testMap).contains('Non-numeric terminaltype_id'));
    testMap.put('terminaltype_id','1828'); //valid attribute
    system.assert(util.validateTerminalBase(testMap).contains('VALID'));
  }
}