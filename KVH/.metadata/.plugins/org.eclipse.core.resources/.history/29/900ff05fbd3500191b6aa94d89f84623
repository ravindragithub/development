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
 * test line...
 */
@isTest
private class HTS_ip_addresses_test { 

  @testSetup static void setupTestData(){
    //setup common test data here, Need at least ONE HTS IP Address
    list<HTS_IP_Address__c> insertList = new list<HTS_IP_Address__c>();
    insertList.add(new HTS_IP_Address__c(Management_IP_Address__c = '10.242.2.1', HTS_IP_Address__c = '10.65.1.0', HTS_IP_HEX_Address__c = '0A.41.01.00'));
    insertList.add(new HTS_IP_Address__c(Management_IP_Address__c = '10.242.2.2', HTS_IP_Address__c = '10.65.2.0', HTS_IP_HEX_Address__c = '0A.41.02.00'));
    insertList.add(new HTS_IP_Address__c(Management_IP_Address__c = '10.242.2.3', HTS_IP_Address__c = '10.65.3.0', HTS_IP_HEX_Address__c = '0A.41.03.00'));
    insertList.add(new HTS_IP_Address__c(Management_IP_Address__c = '10.242.2.4', HTS_IP_Address__c = '10.65.4.0', HTS_IP_HEX_Address__c = '0A.41.04.00'));
    insertList.add(new HTS_IP_Address__c(Management_IP_Address__c = '10.242.2.5', HTS_IP_Address__c = '10.65.5.0', HTS_IP_HEX_Address__c = '0A.41.05.00'));
    insert insertList;
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
    list<HTS_IP_Address__c> readList = [SELECT Id, HTS_IP_Address__c, Management_IP_Address__c, HTS_IP_HEX_Address__c 
                                  FROM HTS_IP_Address__c 
                                  WHERE HTS_IP_HEX_Address__c != '' 
                                  ORDER BY HTS_IP_HEX_Address__c ASC 
                                  LIMIT 1]; //difficult query to optimize....
    system.assertEquals(1, readList.size());
    system.assertEquals('10.65.1.0', readList[0].HTS_IP_Address__c);
  }

  static testMethod void test_constructor() {
    HTS_ip_addresses util = new HTS_ip_addresses();
    system.assertEquals('0A', util.lookupHex.get(10).Hexadecimal__c);
    system.assertEquals('10', util.lookupHex.get(16).Hexadecimal__c);
    system.assertEquals('FF', util.lookupHex.get(255).Hexadecimal__c);
  }
  static testMethod void test_getMaxAddress(){
    HTS_ip_addresses util = new HTS_ip_addresses();
    HTS_IP_Address__c maxAddress = util.getMaxAddress();
    system.assertEquals('10.65.5.0', maxAddress.HTS_IP_Address__c);
    system.assertEquals('10.242.2.5', maxAddress.Management_IP_Address__c);
    system.assertEquals('0A.41.05.00', maxAddress.HTS_IP_HEX_Address__c);
  }
  static testMethod void test_getHexIP(){
    HTS_ip_addresses util = new HTS_ip_addresses();
    string HexIP = util.getHexIP('10.65.1.0');
    system.assertEquals('0A.41.01.00', HexIP);
  }
  static testMethod void test_composeIpAddress(){
    list<integer> numericIP = new list<integer> {10, 65, 1, 0};
    HTS_ip_addresses util = new HTS_ip_addresses();
    string stringIp = util.composeIpAddress(numericIP);
    system.assertEquals('10.65.1.0', stringIp);
  }
  static testMethod void test_parseIpAddress(){
    HTS_ip_addresses util = new HTS_ip_addresses();
    integer[] octets = new integer[4];
    octets = util.parseIpAddress('10.65.1.0');
    system.assertEquals(octets[0], 10);
    system.assertEquals(octets[1], 65);
    system.assertEquals(octets[2], 1);
    system.assertEquals(octets[3], 0);
  }
  static testMethod void test_incrementIpAddress(){
    HTS_ip_addresses util = new HTS_ip_addresses();
    string returnedIP = util.incrementIpAddress(3,'10.65.255.0');
    system.assertEquals('10.66.0.0', returnedIP);
    returnedIP = util.incrementIpAddress(4,'10.65.1.0');
    system.assertEquals('10.65.1.1', returnedIP);
    returnedIP = util.incrementIpAddress(4,'10.65.255.255');
    system.assertEquals('10.66.0.0', returnedIP);
    returnedIP = util.incrementIpAddress(4,'10.255.255.255');
    system.assertEquals(null, returnedIP);
    returnedIP = util.incrementIpAddress(2,'10.65.1.0');
    system.assertEquals(null, returnedIP);
  }
  static testMethod void test_generateIpAddresses(){
    HTS_ip_addresses util = new HTS_ip_addresses();
    system.assertEquals('Generator limited to 1000 or less', util.generateIpAddresses(1001));
    system.assertEquals('Created : 1000 Out of : 1000', util.generateIpAddresses(1000));
    list<HTS_IP_Address__c> readList = [SELECT Id, HTS_IP_Address__c, Management_IP_Address__c, HTS_IP_HEX_Address__c 
                                    FROM HTS_IP_Address__c 
                                    WHERE HTS_IP_HEX_Address__c != '' 
                                    ORDER BY HTS_IP_HEX_Address__c ASC]; //difficult query to optimize....
    system.assertEquals(1005, readList.size());
  }
  static testMethod void test_getNextAvailableAddress(){
    HTS_ip_addresses util = new HTS_ip_addresses();
    //system.assertEquals('Created : 2 Out of : 2', util.generateIpAddresses(2));
    list<HTS_IP_Address__c> readList = [SELECT Id, HTS_IP_Address__c, Management_IP_Address__c, HTS_IP_HEX_Address__c, isReserved__c, Date_Issued__c 
                                    FROM HTS_IP_Address__c 
                                    WHERE HTS_IP_HEX_Address__c != '' 
                                    ORDER BY HTS_IP_HEX_Address__c ASC]; //difficult query to optimize....
    system.assertEquals(5, readList.size());
    readlist[0].isReserved__c = true;
    readList[1].Date_Issued__c = DateTime.now();
    string nextAvaiable = readList[2].HTS_IP_Address__c;
    update readList;
    HTS_IP_Address__c nextIP = util.getNextAvailableAddress();
    system.assertEquals(nextAvaiable, nextIP.HTS_IP_Address__c);
  }
  static testMethod void test_getMgmtIPs(){    
    map<String, String> returnedMap = new map<String, String>();
    list<String> inputList = new list<String>();
    inputList.add('10.65.1.0');
    inputList.add('10.65.2.0');
    inputList.add('10.65.3.0');
    inputList.add('10.65.4.0');
    inputList.add('10.65.5.0');
    test.startTest();
    HTS_ip_addresses util = new HTS_ip_addresses();
    returnedMap = util.getMgmtIPs(inputList);
    test.stopTest();
    system.assertEquals('10.242.2.1', returnedMap.get('10.65.1.0'));
    system.assertEquals('10.242.2.2', returnedMap.get('10.65.2.0'));
    system.assertEquals('10.242.2.3', returnedMap.get('10.65.3.0'));
    system.assertEquals('10.242.2.4', returnedMap.get('10.65.4.0'));
    system.assertEquals('10.242.2.5', returnedMap.get('10.65.5.0'));
  }
}