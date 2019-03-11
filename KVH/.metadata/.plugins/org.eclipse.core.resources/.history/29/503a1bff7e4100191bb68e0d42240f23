@isTest
private class HTS_nms_IP_test {

  @testSetup static void setupTestData(){
    //setup common test data here... 
    HTS_nms_IP__c insertOne = new HTS_nms_IP__c();
    insertOne.nms_IP__c = '10.242.1.1';
    insertOne.nms_IP_HEX__c = '0A.F2.01.01';
    insert insertOne;
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
    list<HTS_nms_IP__c> readnmsIPs = [SELECT Id, Name, nms_IP__c, nms_IP_HEX__c FROM HTS_nms_IP__c];
    system.assertEquals(1, readnmsIPs.size());
  }
  
  static testMethod void test_validateNmsIp(){
    //NOTE: IP addresses ending in .0 or .255 are invalid and cannot be used
    String goodIp = '10.242.20.1';
    String badIp1 = '10.242.20.0';
    String badIp2 = '10.242.20.255';
    String badIp3 = '10.299.20.255';
    HTS_nms_IP util = new HTS_nms_IP();
    test.startTest();
    system.assertEquals(true, util.validateNmsIP(goodIp));
    system.assertEquals(false, util.validateNmsIP(badIp1));
    system.assertEquals(false, util.validateNmsIP(badIp2));
    system.assertEquals(false, util.validateNmsIP(badIp3));
    test.stopTest();
  }
  static testMethod void test_generateNmsIps(){
    HTS_nms_IP util = new HTS_nms_IP();
    test.startTest();
    list<HTS_nms_IP__c> returned = util.generateNmsIPs('10.242.128.253', '10.242.129.8');
    test.stopTest();
    system.assertEquals(10, returned.size());
    for(HTS_nms_IP__c x : returned){
      system.assert(!x.nms_IP__c.endsWith('.0'));
      system.assert(!x.nms_IP__c.endsWith('.255'));
      system.assertNotEquals(null, x.Id);
    }
  }
  static testMethod void test_claimNextNmsIp(){
    HTS_nms_IP util = new HTS_nms_IP();
    test.startTest();
    String returned = util.claimNextNmsIp();
    test.stopTest();
    system.assertEquals('10.242.1.1', returned);
    list<HTS_nms_IP__c> returnList = [SELECT Id, nms_IP__c, nms_IP_HEX__c, isReserved__c, Date_Issued__c
                                      FROM HTS_nms_IP__c];
    system.assertEquals(1, returnList.size());
    system.assertEquals(dateTime.now().date(), returnList[0].Date_Issued__c.date());
  }
  static testMethod void test_reclaimNmsIp_OK(){
    //setup test record
    list<HTS_nms_IP__c> returnList = [SELECT Id, nms_IP__c, nms_IP_HEX__c, isReserved__c, Date_Issued__c
                                  FROM HTS_nms_IP__c];
    system.assertEquals(1, returnList.size());
    returnList[0].Date_Issued__c = dateTime.now();
    returnList[0].isReserved__c = true;
    update returnList[0];
    returnList.clear();
    //verify setup correct
    returnList = [SELECT Id, nms_IP__c, nms_IP_HEX__c, isReserved__c, Date_Issued__c
                                  FROM HTS_nms_IP__c];
    system.assertEquals(1, returnList.size());
    system.assertEquals(dateTime.now().date(), returnList[0].Date_Issued__c.date());
    String ipToReclaim = returnList[0].nms_IP__c;
    HTS_nms_IP util = new HTS_nms_IP();
    test.startTest();
    HTS_nms_IP__c returnedObj = util.reclaimNmsIp(ipToReclaim);
    test.stopTest();
    system.assertEquals(false, returnedObj.isReserved__c);
    system.assertEquals(null, returnedObj.Date_Issued__c);
  }
  static testMethod void test_reclaimNmsIp_FAIL1(){
    //setup test record
    list<HTS_nms_IP__c> returnList = [SELECT Id, nms_IP__c, nms_IP_HEX__c, isReserved__c, Date_Issued__c
                                  FROM HTS_nms_IP__c];
    system.assertEquals(1, returnList.size());
    String ipToReclaim = returnList[0].nms_IP__c;
    delete returnList[0];
    returnList.clear();
    //verify setup correct
    returnList = [SELECT Id, nms_IP__c, nms_IP_HEX__c, isReserved__c, Date_Issued__c
                                  FROM HTS_nms_IP__c];
    system.assertEquals(0, returnList.size());
    HTS_nms_IP util = new HTS_nms_IP();
    test.startTest();
    HTS_nms_IP__c returnedObj = util.reclaimNmsIp(ipToReclaim);
    test.stopTest();
    system.assertEquals(null, returnedObj.nms_IP__c);
    list<Case> caseList = [SELECT Id, subject, description, Origin, status
                          FROM Case];
    system.assertEquals(1, caseList.size());
    system.assertEquals('New', caseList[0].status);
    system.assertEquals('System Generated', caseList[0].Origin);
    system.assertEquals('Error while generating nms IPs', caseList[0].subject);
    system.assert(caseList[0].description.contains('Found 0 nms IPs matching: ' + ipToReclaim), caseList[0].description);
  }
  static testMethod void test_reclaimNmsIp_FAIL2(){
    String ipToReclaim = '10.242.1.0';
    HTS_nms_IP util = new HTS_nms_IP();
    test.startTest();
    HTS_nms_IP__c returnedObj = util.reclaimNmsIp(ipToReclaim);
    test.stopTest();
    system.assertEquals(null, returnedObj.nms_IP__c);
    list<Case> caseList = [SELECT Id, subject, description, Origin, status
                          FROM Case];
    system.assertEquals(1, caseList.size());
    system.assertEquals('New', caseList[0].status);
    system.assertEquals('System Generated', caseList[0].Origin);
    system.assertEquals('Error while generating nms IPs', caseList[0].subject);
    system.assert(caseList[0].description.contains('IP being reclaimed is invalid: ' + ipToReclaim), caseList[0].description);
  }
  static testMethod void test_insertWarningCase(){
    HTS_nms_IP util = new HTS_nms_IP();
    String error = 'The following error has occurred.	DUPLICATE_VALUE: duplicate value found: nms_IP__c duplicates value on record with id: a550m000000C2Ro, nms_IP_HEX__c duplicates value on record with id: a550m000000C2Ro	nms IP fields that affected this error: ()';
    test.startTest();
    util.insertWarningCase(error);
    test.stopTest();
    list<Case> readList = [SELECT ID, Subject, Description FROM Case];
    system.assertEquals(1, readList.size());
    system.assertEquals('Error while generating nms IPs', readList[0].subject);
    system.assert(readList[0].Description.contains('The following error has occurred.'), readList[0]);
  }
  static testMethod void test_generateNmsIPs2(){
    HTS_nms_IP util = new HTS_nms_IP();
    test.startTest();
    list<HTS_nms_IP__c> returnList = util.generateNmsIPs('10.242.1.0', '10.242.1.2');
    test.stopTest();
    system.assertEquals(2, returnList.size());      // 10.242.1.0 gets kicked out because it ends with .0
    system.assertEquals(null, returnList[0].Id);    // not inserted becuase it is a duplicate
    system.assertNotEquals(null, returnList[1].Id); // Should have a record Id
    
    list<Case> readList = [SELECT ID, Subject, Description FROM Case];
    system.assertEquals(1, readList.size());
    system.assertEquals('Error while generating nms IPs', readList[0].subject);
    system.assert(readList[0].Description.contains('The following error has occurred.'), readList[0]);
  
  }
}