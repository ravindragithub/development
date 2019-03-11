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
private class HTSOSS_hts_terminals_test {

  @testSetup static void setupTestData(){ 
    //setup common test data here
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
  }

  /* Test GET Services */
  static testMethod void test_terminals_GET_list_of_1_OK(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_GET());
    HTSOSS_hts_terminals util = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals.terminals_list_wrapper mockRes = util.getTerminals(1, null);
    system.assertEquals(1, mockRes.terminals_list.size());                           //we got two (per mock), right?
    system.assertEquals(200, mockRes.response_code);                  //We got a 200 (per mock)
    for(HTSOSS_hts_terminals ts : mockRes.terminals_list){ //assertions rely *entirely* on Mock response!
      system.assertEquals(2046, ts.obj_id);                
      system.assertEquals('Pulse Network Terminals:Terminal:2080', ts.obj_name); 
    }
    test.stopTest();
  }
  static testMethod void test_terminals_GET_list_of_1_FAIL(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(500));
    HTSOSS_hts_terminals util = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals.terminals_list_wrapper mockRes = util.getTerminals(1, null);
    system.assertEquals(0, mockRes.terminals_list.size());                           //we got Zero (per mock), right?
    system.assertEquals(500, mockRes.response_code);                  //We got a 500 (per mock)
    test.stopTest();
  }

  static testMethod void test_terminals_GET_list_of_2_OK(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_GET());
    HTSOSS_hts_terminals util = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals.terminals_list_wrapper mockRes = util.getTerminals(2, null);
    system.assertEquals(2, mockRes.terminals_list.size());                           //we got two (per mock), right?
    system.assertEquals(200, mockRes.response_code);                  //We got a 200 (per mock)
    for(HTSOSS_hts_terminals ts : mockRes.terminals_list){ //assertions rely *entirely* on Mock response!
      system.assertEquals('204', string.valueOf(ts.obj_id).left(3)); //convert integer to string, return first three digits!//system.assertEquals('212', ts.obj_id.format().left(3)); //convert integer to string, return first three digits!
      system.assertEquals('Pulse Network Terminals:', ts.obj_name.left(24)); 
    }
    test.stopTest();
  }
  static testMethod void test_terminals_GET_list_of_2_FAIL(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(500));
    HTSOSS_hts_terminals util = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals.terminals_list_wrapper mockRes = util.getTerminals(2, null);
    system.assertEquals(0, mockRes.terminals_list.size());                           //we got 0 (per mock), right?
    system.assertEquals(500, mockRes.response_code);                  //We got a 500 (per mock)
    for(HTSOSS_hts_terminals ts : mockRes.terminals_list){ //assertions rely *entirely* on Mock response!
      system.assertEquals('204', string.valueOf(ts.obj_id).left(3)); //convert integer to string, return first three digits!//system.assertEquals('212', ts.obj_id.format().left(3)); //convert integer to string, return first three digits!
      system.assertEquals('Pulse Network Terminals:', ts.obj_name.left(24)); 
    }
    test.stopTest();
  }
  static testMethod void test_terminals_GET_list_by_name_OK(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_GET());
    HTSOSS_hts_terminals util = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals.terminals_list_wrapper mockRes = util.getTerminals(null, 'Pulse Network Terminals:Terminal:2080');
    system.assertEquals(1, mockRes.terminals_list.size());                           //we got two (per mock), right?
    system.assertEquals(200, mockRes.response_code);                  //We got a 200 (per mock)
    for(HTSOSS_hts_terminals ts : mockRes.terminals_list){ //assertions rely *entirely* on Mock response!
      system.assertEquals(2046, ts.obj_id);                
      system.assertEquals('Pulse Network Terminals:Terminal:2080', ts.obj_name); 
    }
    test.stopTest();
  }
  static testMethod void test_terminals_GET_list_by_Core_OK(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_GET());
    HTSOSS_hts_terminals util = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals.terminals_list_wrapper mockRes = util.getTerminals(null, null, 3541);
    system.assertEquals(1, mockRes.terminals_list.size());                           //we got two (per mock), right?
    system.assertEquals(200, mockRes.response_code);                  //We got a 200 (per mock)
    for(HTSOSS_hts_terminals ts : mockRes.terminals_list){ //assertions rely *entirely* on Mock response!
      system.assertEquals(2046, ts.obj_id);                
      system.assertEquals('Pulse Network Terminals:Terminal:2080', ts.obj_name); 
    }
    test.stopTest();
  }
  static testMethod void test_terminals_GET_by_id_OK(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_GET_by_id());
    HTSOSS_hts_terminals util = new HTSOSS_hts_terminals();
    util.obj_id = 3605;
    HTSOSS_hts_terminals mockRes = util.getTerminal(util);
    system.assertEquals(200, mockRes.response_code);                  //We got a 200 (per mock)
    system.assertEquals('10.243.0.1', mockRes.mgmtipaddress);
  }
  static testMethod void test_terminals_GET_by_id_FAIL_400(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(404));
    HTSOSS_hts_terminals util = new HTSOSS_hts_terminals();
    //util.obj_id = 3605;
    HTSOSS_hts_terminals responseTerm = util.getTerminal(util);
    system.assertEquals(400, responseTerm.response_code);                  //We got a 400 (per validation method)
    system.assertEquals('INVALID', responseTerm.message.left(7));
    test.stopTest();
  }
  static testMethod void test_terminals_GET_by_id_FAIL_404(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(404));
    HTSOSS_hts_terminals util = new HTSOSS_hts_terminals();
    util.obj_id = 3605;
    HTSOSS_hts_terminals responseTerm = util.getTerminal(util);
    system.assertEquals(404, responseTerm.response_code);                  //We got a 404 (per mock)
    system.assertEquals('Terminal not found', responseTerm.message);
    test.stopTest();
  }
  static testMethod void test_terminals_GET_by_id_FAIL_500(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(500));
    HTSOSS_hts_terminals util = new HTSOSS_hts_terminals();
    util.obj_id = 3605;
    HTSOSS_hts_terminals responseTerm = util.getTerminal(util);
    system.assertEquals(500, responseTerm.response_code);                  //We got a 500 (per mock)
    system.assertEquals('Failed to GET Terminal', responseTerm.message);
    test.stopTest();
  }
  /* Test POST services */
  static testMethod void test_terminals_POST_OK(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_POST_OK());
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    term1.coremodule_id = 1234;
    term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'TEMPLATE_1';
    term1.terminal_ip_address = '10.64.14.0/24';
    term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    term1 = term1.postTerminal(term1);
    
    system.assertEquals(201, term1.response_code);                  //We got a 201 (per mock)
    test.stopTest();
  }
  static testMethod void test_terminals_POST_FAIL_500(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(500));
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    term1.coremodule_id = 1234;
    term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'TEMPLATE_1';
    term1.terminal_ip_address = '10.64.14.0/24';
    term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    HTSOSS_hts_terminals responseTerm = term1.postTerminal(term1);
    
    system.assertEquals(500, responseTerm.response_code);                  //We got a 500 (per mock)
    system.assertEquals('Failed to Create Terminal', responseTerm.message);
    test.stopTest();
  }
  static testMethod void test_terminals_POST_FAIL_400(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(400));
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    term1.coremodule_id = 1234;
    term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'TEMPLATE_1';
    //term1.terminal_ip_address = '10.64.14.0/24';
    term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    HTSOSS_hts_terminals responseTerm = term1.postTerminal(term1);
    
    system.assertEquals(400, responseTerm.response_code);                  //We got a 400 (per validation method)
    system.assertEquals('INVALID, Missing terminal_ip_address ', responseTerm.message, responseTerm.message);
    test.stopTest();
  }
  
  /* Test PUT Services (no PATCH :( )*/
  static testMethod void test_terminals_PUT_OK(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_NO_BODY(204));
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    term1.obj_id = 12345;
    term1.is_active = false;
    term1.obj_revision = 2;
    term1.coremodule_id = 2931;
    term1.enablestaticroutes = true;
    term1.static_ip_data_channel_id = 1703;

    HTSOSS_hts_terminals responseTerm = term1.putTerminal(term1);          //Does not return a body doc, just a response code
    system.assertEquals(204, responseTerm.response_code);                  //We got a 204 (per mock)

    test.stopTest();
  }
  static testMethod void test_terminals_PUT_FAIL(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(400));
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    //term1.obj_id = 12345; 
    term1.is_active = false;
    term1.obj_revision = 2;
    
    HTSOSS_hts_terminals responseTerm = term1.putTerminal(term1);          
    system.debug(term1.message);
    system.assertEquals(400, responseTerm.response_code);                  //We got a 400 (per mock)
    system.assertEquals('INVALID', responseTerm.message.left(7));
    test.stopTest();
  }
  static testMethod void test_terminals_PUT_FAIL_404(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(404));
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    term1.obj_id = 12345; 
    term1.is_active = false;
    term1.obj_revision = 2;
    
    HTSOSS_hts_terminals responseTerm = term1.putTerminal(term1);          
    system.debug(term1.message);
    system.assertEquals(404, responseTerm.response_code);                  //We got a 400 (per mock)
    system.assertEquals('Terminal not found', responseTerm.message);
    test.stopTest();
  }
  static testMethod void test_terminals_PUT_FAIL_500(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(500));
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    term1.obj_id = 12345; 
    term1.is_active = false;
    term1.obj_revision = 2;
    
    HTSOSS_hts_terminals responseTerm = term1.putTerminal(term1);          
    system.debug(term1.message);
    system.assertEquals(500, responseTerm.response_code);                  //We got a 400 (per mock)
    system.assertEquals('Failed to Update Terminal', responseTerm.message);
    test.stopTest();
  }
  static testMethod void test_terminals_PUT_FAIL_staticRoutes(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(500));
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    term1.obj_id = 12345; 
    term1.obj_revision = 2;
    //term1.enablestaticroutes = true;
    term1.static_ip_data_channel_id = 1703;
    
    HTSOSS_hts_terminals responseTerm = term1.putTerminal(term1);          
    system.debug(term1.message);
    system.assertEquals(400, responseTerm.response_code);                  //We got a 400 (per mock)
    system.assert(responseTerm.message.contains('Missing enablestaticroutes'), responseTerm);
    test.stopTest();
  }
  static testMethod void test_terminals_PUT_FAIL_dataChannel(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(500));
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    term1.obj_id = 12345; 
    term1.obj_revision = 2;
    term1.enablestaticroutes = true;
    //term1.static_ip_data_channel_id = 1703;
    
    HTSOSS_hts_terminals responseTerm = term1.putTerminal(term1);          
    system.debug(term1.message);
    system.assertEquals(400, responseTerm.response_code);                  //We got a 400 (per mock)
    system.assert(responseTerm.message.contains('Missing static_ip_data_channel_id'), responseTerm);
    test.stopTest();
  }
  /* Test DELETE services */
  static testMethod void test_terminals_DELETE_OK(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_NO_BODY(204)); 
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    term1.obj_id = 12345;
    
    term1 = term1.deleteTerminal(term1);          //Does not return a body doc, just a response code
    system.assertEquals(204, term1.response_code);                  //We got a 204 (per mock)
    test.stopTest();
  }
  static testMethod void test_terminals_DELETE_FAIL_404(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(404)); 
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    term1.obj_id = 12345;
    
    term1 = term1.deleteTerminal(term1);          //Does not return a body doc, just a response code
    system.assertEquals(404, term1.response_code);                  //We got a 204 (per mock)
    system.debug(term1.message);
    test.stopTest();
  }
  static testMethod void test_terminals_DELETE_FAIL_500(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(500)); 
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    term1.obj_id = 12345;
    
    term1 = term1.deleteTerminal(term1);          //Does not return a body doc, just a response code
    system.assertEquals(500, term1.response_code);                  //We got a 204 (per mock)
    system.debug(term1.message);
    test.stopTest();
  }
  static testMethod void test_terminals_DELETE_FAIL_400(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(400)); 
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    //term1.obj_id = 12345;
    
    HTSOSS_hts_terminals responseTerm  = term1.deleteTerminal(term1);          //Does not return a body doc, just a response code
    system.assertEquals(400, responseTerm.response_code);                  //We got a 400 (per validation method)
    system.assertEquals('INVALID', responseTerm.message.left(7));
    system.debug(responseTerm.message);
    test.stopTest();
  }
  static testMethod void test_validationMethods(){
    HTSOSS_hts_terminals testTerminal = new HTSOSS_hts_terminals();
    string validationResults = testTerminal.validateTerminalForPOST(testTerminal);
    system.assertEquals('INVALID', validationResults.left(7));
    validationResults = '';
    validationResults = testTerminal.validateTerminalForPUT(testTerminal);
    system.assertEquals('INVALID', validationResults.left(7));
    validationResults = '';
    validationResults = testTerminal.validateTerminalForDELETE(testTerminal);
    system.assertEquals('INVALID', validationResults.left(7));
  }
  static testMethod void test_Attributes(){
    HTSOSS_hts_terminals testTerminal = new HTSOSS_hts_terminals();
    testTerminal.accessbitmask = 123;                          //||     |    |GET<id>|       |          ||11111111
    /*SoOoO.... "activate" is a reserved work in Apex :(
     *we get "is_active" :)*/
    //public boolean activate {get;set;}                       //||GET[]|    |GET<id>|       |          ||
    testTerminal.adminpassword = 'string';                     //||     |    |GET<id>|       |          ||"iDirect"
    testTerminal.auto_route_to_remotes = 'string';             //||     |    |GET<id>|       |          ||"Inherit"
    testTerminal.contactmail = 'string';                       //||     |    |GET<id>|       |          ||""
    testTerminal.contactname = 'string';                       //||     |    |GET<id>|       |          ||""
    testTerminal.contactnote = 'string';                       //||     |POST|GET<id>|       |          ||""
    testTerminal.contactphone = 'string';                      //||     |    |GET<id>|       |          ||""
    testTerminal.coremodule_id = 123;                          //||     |POST|GET<id>|       |          ||1882
    testTerminal.customer_id = 'string';                       //||     |POST|GET<id>|       |          ||""
    list<HTSOSS_hts_terminals.channel> cList = new list<HTSOSS_hts_terminals.channel>();
    HTSOSS_hts_terminals.channel c = new HTSOSS_hts_terminals.channel();
    c.obj_id = '1703';
    c.enablestaticroutes = true;
    cList.add(c);
    testTerminal.data_channels = cList;
    testTerminal.enableauthentication = true;                  //||     |    |GET<id>|       |          ||true
    testTerminal.enableconnectionacceleration = true;          //||     |    |GET<id>|       |          ||true
    testTerminal.enablertpcompression = true;                  //||     |    |GET<id>|       |          ||true
    testTerminal.enablestaticroutes = true;                    //||     |    |GET<id>|PUT<id>|          ||
    testTerminal.enabletcpcompression = true;                  //||     |    |GET<id>|       |          ||true
    testTerminal.enabletcpacceleration = true;                 //||     |    |GET<id>|       |          ||true
    testTerminal.enabletcpheadercompression = true;            //||     |    |GET<id>|       |          ||true
    testTerminal.enableudpcompression = true;                  //||     |    |GET<id>|       |          ||true
    testTerminal.enableudppayloadcompression = true;           //||     |    |GET<id>|       |          ||true
    testTerminal.enable_multicast = true;                      //||     |    |       |PUT<id>|          ||
    testTerminal.encivlen = 'string';                          //||     |    |GET<id>|       |          ||"128 bit"
    testTerminal.forcelogout = true;                           //||     |    |GET<id>|       |          ||true
    testTerminal.freqoffsetmax = '20';                         //||     |    |GET<id>|       |          ||"20"
    testTerminal.inboundkeyrollperiodsec = 123;                //||     |    |GET<id>|       |          ||7200
    testTerminal.initialpower = 'string';                      //||     |    |GET<id>|       |          ||"-20"
    testTerminal.is_active = true;                             //||GET[]|    |GET<id>|PUT<id>|          ||true "activate" in pulse...
    testTerminal.linkencryption = true;                        //||     |    |GET<id>|       |          ||false
    testTerminal.maxaccelerationsession = 'string';            //||     |    |GET<id>|       |          ||""
    testTerminal.maxlinkimpairement = 'string';                //||     |    |GET<id>|       |          ||"10"
    testTerminal.maxpower = 'string';                          //||     |    |GET<id>|       |          ||"-10"
    testTerminal.maxtcpstream = '100';                         //||     |    |GET<id>|       |          ||"100"
    testTerminal.mgmtgateway = '10.242.20.13';                 //||     |    |GET<id>|       |          ||"10.242.20.13"
    testTerminal.mgmtipaddress = '10.242.20.13';               //||     |    |GET<id>|       |          ||"10.242.20.13"
    testTerminal.mgmtsubnetmask = 'string';                    //||     |    |GET<id>|       |          ||"255.255.255.0"
    testTerminal.minbytescompression = 'string';               //||     |    |GET<id>|       |          ||"255.255.255.0"
    testTerminal.mincompressioncycles = 'string';              //||     |    |GET<id>|       |          ||"255.255.255.0"
    testTerminal.nominalmodcod = 'string';                     //||     |    |GET<id>|       |          ||"QPSK-9/10"
    testTerminal.obj_id = 123;                                 //||GET[]|    |GET<id>|PUT<id>|DELETE<id>||2045 (path attribute)
    testTerminal.obj_name = 'string';                          //||GET[]|POST|GET<id>|       |          ||"KVH-Lab Term-036874"
    testTerminal.obj_parentid = 123;                           //||     |    |GET<id>|       |          ||57
    testTerminal.obj_revision = 123;                           //||GET[]|    |GET<id>|PUT<id>|          ||1
    testTerminal.onedbcompression = 'string';                  //||     |    |GET<id>|       |          ||""
    testTerminal.ospassword = 'string';                        //||     |    |GET<id>|       |          ||"iDirect"
    testTerminal.radiuspassword = 'string';                    //||     |    |GET<id>|       |          ||"iDirect"
    testTerminal.radiususername = 'string';                    //||     |    |GET<id>|       |          ||"idirect"
    testTerminal.rtpportrange = 'string';                      //||     |    |GET<id>|       |          ||""
    testTerminal.snrmetricadvertisement = 'string';            //||     |    |GET<id>|       |          ||""
    testTerminal.static_ip_data_channel_id = 1703;             //||     |    |       |       |          ||
    testTerminal.statsmanagementprofile_id = 'string';         //||     |    |GET<id>|       |          ||""
    testTerminal.tcpcompressionportrange = 'string';           //||     |    |GET<id>|       |          ||""
    testTerminal.tcpheadercompressionportrange = 'string';     //||     |    |GET<id>|       |          ||""
    testTerminal.tcpportrange = 'string';                      //||     |    |GET<id>|       |          ||""
    testTerminal.template_id = 'CONUS_STANDARD';               //||     |POST|GET<id>|       |          ||
    testTerminal.template_version = '0001';                    //||     |    |GET<id>|       |          ||
    testTerminal.terindetification = '(test, test)';           //||     |    |GET<id>|       |          ||"10.83.13.1"
    testTerminal.terminal_id = '87654321';                     //||GET[]|POST|GET<id>|       |          ||12345678
    testTerminal.terminal_ip_address = '10.82.13.1';           //||     |POST|       |       |          ||
    testTerminal.terminal_service_ip = 'string';               //||     |    |GET<id>|       |          ||"10.83.13.1"
    testTerminal.terminaltype_id = 123;                        //||     |POST|GET<id>|       |          ||1828
    testTerminal.thresholdprofile_id = '1655';                 //||     |    |GET<id>|       |          ||"10.83.13.1"
    testTerminal.udpcompressionmethod = 'string';              //||     |    |GET<id>|       |          ||"ECRTP(1)"
    testTerminal.udppayloadportrange = 'string';               //||     |    |GET<id>|       |          ||""
    testTerminal.udppayloadsize = 123;                         //||     |    |GET<id>|       |          ||100
    testTerminal.udpportrange = 'string';                      //||     |    |GET<id>|       |          ||""
    testTerminal.updateprofile_id = 123;                       //||     |    |GET<id>|       |          ||349
    testTerminal.userpassword = 'string';                      //||     |    |GET<id>|       |          ||"iDirect"
  }
}