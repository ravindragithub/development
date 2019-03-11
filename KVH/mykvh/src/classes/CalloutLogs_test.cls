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
private class CalloutLogs_test{
  static HttpRequest testRequest = new HttpRequest();
  static HttpResponse testResponse = new HttPResponse();
  static Integer Num_Of_Test_Records_to_INS = 200;   // Pick a number divisible by 4 so the arithmetic feeding the expected 
                                                     // values for the record count asserts will come out right.
  static Time timeZEROs = Time.newInstance(0,0,0,0);
  static Date DtToday = Date.today();  
  static Date DtYesterday = DtToday.addDays(-1);

	@testSetup static void setupTestData(){
  // setup common test data here. Every test method in this class gets a fresh copy of this data when the method starts
  // Insert Num_Of_Test_Records_to_INS records with CreatedDate from yesterday to Num_Of_Test_Records_to_INS days ago.
  // Vary the values in the various fields using the record number.

    // Pick a user who is unlikely to ever be disabled.
    // list<USER> uSER1 = [SELECT Id From USER WHERE LASTNAME = 'Magruder' and FIRSTNAME='Andrew'];
    list<USER> uSER1 = [SELECT Id From USER WHERE Alias = 'KVHAdmin'];
    Id myUId = uSER1[0].Id;
      
    List<Callout_Log__c> testRecs = new List<Callout_Log__c>(); 

    DateTime CreatedDT = null;  
    String strRC = '';

    For(Integer RecCnt=1; RecCnt <= Num_Of_Test_Records_to_INS; RecCnt++)
    {
        strRC = string.valueOf(RecCnt);
        CreatedDT = DateTime.newInstance(DtToday.addDays(-RecCnt), timeZEROs);
        string tmpstr = 'RecCnt: ' + strRC + '.   About to be INSERTED as CreatedDate: ' + string.valueOf(CreatedDT) + '   HTS Term: ' +   '00000000'.substring(0,8-strRC.length()) + strRC;
        System.debug(tmpstr);

        Callout_Log__c myRec = new Callout_Log__c();

        // Vary the contents of all the fields with the record counter, just for the hell of it.
        myRec.CreatedDate = CreatedDT;
        myRec.Attempt_Counter__c =  RecCnt;
        myRec.Body__c =  'aBody' + strRC;
        //    myRec.CreatedById =  '';
        myRec.CreatedDate =  CreatedDT;
        //    myRec.CurrencyIsoCode =  '';
        myRec.HTS_Terminal_Id__c =  '00000000'.substring(0,8-strRC.length()) + strRC;
        //    myRec.LastModifiedById =  '';
        //    myRec.LastModifiedDate =  '';
        //    myRec.LastReferencedDate =  '';
        //    myRec.LastViewedDate =  '';
        myRec.Method_Name__c =  'POST';
        //  not writeable  myRec.Name =  '';
        //    myRec.OwnerId =  '';
        myRec.Req_Body__c =  'aReq_Body' + strRC;
        myRec.Req_Endpoint__c =  'aReq_EndPoint' + strRC;
        myRec.Req_Method__c =  'POST';
        myRec.Res_Body__c =  'aRes_Body' + strRC;
        myRec.Res_Headers__c =  'aRes_Header' + strRC;
        myRec.Res_Status__c =  'aRes_Status' + strRC;
        myRec.Res_Status_Code__c =  '123';
        myRec.Response_Message__c =  'aRes_Message' + strRC;
        myRec.Success__c =  True;
        // might be DBAmp add-on    myRec.SystemModstamp =  CreatedDT;
        myRec.Time_Stamp__c =  CreatedDT;   // Required
        myRec.User_Id__c = myUId;
        
        testRecs.add(myRec);
      }

    insert testRecs;

	}
	
	static testMethod void testSetupData(){
		//use this method to validate that you have test data setup correctly

    AggregateResult[] aggQryOut;
    aggQryOut = [SELECT MIN(CreatedDate) minCreated, MAX(CreatedDate) maxCreated, Count(id) RecCnt FROM Callout_Log__c];
    // Originally coded the record creation date comparisons with DateTime.addDays(x) but I encountered
    // spurious non-zero time values that caused some assertEquals(DateExpected, CreatedDate) to fail despite 
    // my setting the times explicitly to 0,0,0,0.
    // I reprogrammed using Date types and DateTime.date().

    // see https://success.salesforce.com/ideaView?id=08730000000YpPWAA0    excerpt below:
        // I'll use a pop quiz to start the idea:  what should be the debug result of this code?
        // datetime myDate = datetime.newInstance(2009, 11, 1);
        // datetime newDate = mydate.addDays(2);
        // system.debug(newDate.format('yyyy-MM-dd'));
        // Hint: I'm running this in a US time zone org.  For those of who think it should be 2009-11-03, please read on.


    Date minDT1 = DateTime.valueOf(aggQryOut[0].get('minCreated')).date();
    Date maxDT1 = DateTime.valueOf(aggQryOut[0].get('maxCreated')).date();
    Integer myRecordCount = Integer.valueOf(aggQryOut[0].get('RecCnt'));
    Date Expected_Max_Date_in_Recs_to_DEL = DtToday.addDays(-Num_Of_Test_Records_to_INS);

    System.assertEquals(Expected_Max_Date_in_Recs_to_DEL, minDT1,'In testSetupData expected test records earliest CreatedDate failed.');
    System.assertEquals(DtYesterday, maxDT1,'In testSetupData expected test records CreatedDate of yesterday failed.');    
    System.assertEquals(Num_Of_Test_Records_to_INS,myRecordCount,'In testSetupData expected record count failed.');

	}



  static testMethod void test_processTerminalId(){
    //setup test request body
    String testBody = '{"terminaltype_id":2931,';
    testBody = testBody + '"terminal_ip_address":"10.64.51.0/24",';
    testBody = testBody + '"terminal_id":"46435168",';
    testBody = testBody + '"template_id":"CONUS_STANDARD",';
    testBody = testBody + '"mgmtipaddress":"10.242.1.51",';
    testBody = testBody + '"coremodule_id":21852}';
    string processedVTID = CalloutLogs.processTerminalId(testBody);
    System.assertEquals('46435168', processedVTID);

    testBody = '{"terminaltype_id":2931,';
    testBody = testBody + '"terminal_ip_address":"10.64.51.0/24",';
    testBody = testBody + '"terminal_id":"46435A68",';
    testBody = testBody + '"template_id":"CONUS_STANDARD",';
    testBody = testBody + '"mgmtipaddress":"10.242.1.51",';
    testBody = testBody + '"coremodule_id":21852}';
    processedVTID = CalloutLogs.processTerminalId(testBody);
    System.assertEquals('', processedVTID);

    testBody = '{"terminaltype_id":2931,';
    testBody = testBody + '"terminal_ip_address":"10.64.51.0/24",';
    testBody = testBody + '"template_id":"CONUS_STANDARD",';
    testBody = testBody + '"mgmtipaddress":"10.242.1.51",';
    testBody = testBody + '"coremodule_id":21852}';
    processedVTID = CalloutLogs.processTerminalId(testBody);
    System.assertEquals('', processedVTID);

    testBody = '{"terminaltype_id":2931,';
    testBody = testBody + '"terminal_ip_address":"10.64.51.0/24",';
    testBody = testBody + '"terminal_id":"4643516",';
    testBody = testBody + '"template_id":"CONUS_STANDARD",';
    testBody = testBody + '"mgmtipaddress":"10.242.1.51",';
    testBody = testBody + '"coremodule_id":21852}';
    processedVTID = CalloutLogs.processTerminalId(testBody);
    System.assertEquals('', processedVTID);
  }
	static testMethod void test_processHeaders(){
	  //setup testResponse...
    testResponse.setBody('{"key" : "value"}'); 
    testResponse.setStatus('OK');
    testResponse.setStatusCode(200);
    //setup a bunch of headers...
    testResponse.setHeader('server','nginx/1.10.0 (Ubuntu)');
    testResponse.setHeader('date','Mon, 13 Feb 2017 18:00:26 GMT');
    testResponse.setHeader('content-type','application/json');
    testResponse.setHeader('content-length','856');
    testResponse.setHeader('connection','keep-alive');
    //CalloutLogs util = new CalloutLogs();
    string headerString = CalloutLogs.processHeaders(testResponse);
    System.debug('Header String length: ' + headerString.length());
	}

  static testMethod void test_log(){
	  //setup testRequest....
    testRequest.setEndpoint('http://www.notarealendpoint.com/service');
    testRequest.setMethod('GET');
    testRequest.setBody('{"key" : "value"}');
    //setup testResponse...
    testResponse.setBody('{"key" : "value"}'); 
    testResponse.setStatus('OK');
    testResponse.setStatusCode(200);
    //setup a bunch of headers...
    testResponse.setHeader('server','nginx/1.10.0 (Ubuntu)');
    testResponse.setHeader('date','Mon, 13 Feb 2017 18:00:26 GMT');
    testResponse.setHeader('content-type','application/json');
    testResponse.setHeader('content-length','856');
    testResponse.setHeader('connection','keep-alive');

    Callout_Log__c returnLog = CalloutLogs.log(testRequest, testResponse);
    System.assertEquals(returnLog.Req_Endpoint__c,'http://www.notarealendpoint.com/service');
    System.assertEquals(1,CalloutLogs.logEntries.size());
	}
  static testMethod void test_log_multi(){
	  //setup testRequest....
    testRequest.setEndpoint('http://www.notarealendpoint.com/service');
    testRequest.setMethod('GET');
    testRequest.setBody('{"reqKey" : "reqValue"}');
    //setup testResponse...
    testResponse.setBody('{"resKey" : "resValue"}'); 
    testResponse.setStatus('OK');
    testResponse.setStatusCode(200);
    //setup a bunch of headers...
    testResponse.setHeader('server','nginx/1.10.0 (Ubuntu)');
    testResponse.setHeader('date','Mon, 13 Feb 2017 18:00:26 GMT');
    testResponse.setHeader('content-type','application/json');
    testResponse.setHeader('content-length','856');
    testResponse.setHeader('connection','keep-alive');
    test.startTest();
    Callout_Log__c returnLog0 = CalloutLogs.log(testRequest, testResponse);
    Callout_Log__c returnLog1 = CalloutLogs.log(testRequest, testResponse);
    Callout_Log__c returnLog2 = CalloutLogs.log(testRequest, testResponse);
    Callout_Log__c returnLog3 = CalloutLogs.log(testRequest, testResponse);
    Callout_Log__c returnLog4 = CalloutLogs.log(testRequest, testResponse);

    String results = CalloutLogs.commitLogs();
    test.stopTest();
    //check conversions
    System.assertEquals(returnLog1.Req_Endpoint__c,'http://www.notarealendpoint.com/service');
    System.assertEquals(returnLog2.Res_Body__c,'{"resKey" : "resValue"}');
    System.assertEquals(5,CalloutLogs.logEntries.size());
    //check commits
    System.assertEquals('Committed 5 Callout Log Entries', results);
    list<Callout_Log__c> readList = [SELECT Id, Req_Endpoint__c, Req_Body__c FROM Callout_Log__c];
    // testSetupDate inserted Num_Of_Test_Records_to_INS records and this method inserted 5.
    System.assertEquals(Num_Of_Test_Records_to_INS + 5, readList.size());
    
    //TODO check the values returned by the query
    list<Callout_Log__c> readList_FIVE = [SELECT Id, Req_Endpoint__c, Req_Body__c FROM Callout_Log__c Order By CreatedDate DESC LIMIT 5];    
    for(Callout_Log__c c : readList_FIVE){
      System.assertEquals('http://www.notarealendpoint.com/service', c.Req_Endpoint__c);
      System.assertEquals('{"reqKey" : "reqValue"}', c.Req_Body__c);
    }
	}
  static testMethod void test_nullLogEntries(){
    test.startTest();
    String results = CalloutLogs.commitLogs();
    test.stopTest();
    System.assertEquals('No Callout Logs to commit...', results);
  }
  static testMethod void test_log_reqOnly(){
	  //setup testRequest....
    testRequest.setEndpoint('http://www.notarealendpoint.com/service');
    testRequest.setMethod('GET');
    testRequest.setBody('{"key" : "value"}');
    //setup testResponse...
    testResponse.setBody('{"key" : "value"}'); 
    testResponse.setStatus('OK');
    testResponse.setStatusCode(200);
    //setup a bunch of headers...
    testResponse.setHeader('server','nginx/1.10.0 (Ubuntu)');
    testResponse.setHeader('date','Mon, 13 Feb 2017 18:00:26 GMT');
    testResponse.setHeader('content-type','application/json');
    testResponse.setHeader('content-length','856');
    testResponse.setHeader('connection','keep-alive');
    test.startTest();
    Callout_Log__c returnLog = CalloutLogs.log(testRequest, null);
    String results = CalloutLogs.commitLogs();
    test.stopTest();
    System.assertEquals(returnLog.Req_Endpoint__c,'http://www.notarealendpoint.com/service');
    System.assertEquals(1,CalloutLogs.logEntries.size());
    System.assertEquals('Committed 1 Callout Log Entries', results);
	}
  static testMethod void test_logWithTerminalId(){
    //setup testRequest....
    testRequest.setEndpoint('http://www.notarealendpoint.com/hts/terminals/');
    testRequest.setMethod('POST');
    String testBody = '{"terminaltype_id":2931,';
    testBody = testBody + '"terminal_ip_address":"10.64.51.0/24",';
    testBody = testBody + '"terminal_id":"46435168",';
    testBody = testBody + '"template_id":"CONUS_STANDARD",';
    testBody = testBody + '"mgmtipaddress":"10.242.1.51",';
    testBody = testBody + '"coremodule_id":21852}';
    testRequest.setBody(testBody);
    //setup testResponse...
    testResponse.setBody('{"key" : "value"}'); 
    testResponse.setStatus('OK');
    testResponse.setStatusCode(200);
    //setup a bunch of headers...
    testResponse.setHeader('server','nginx/1.10.0 (Ubuntu)');
    testResponse.setHeader('date','Mon, 13 Feb 2017 18:00:26 GMT');
    testResponse.setHeader('content-type','application/json');
    testResponse.setHeader('content-length','856');
    testResponse.setHeader('connection','keep-alive');

    test.startTest();
    Callout_Log__c returnLog = CalloutLogs.log(testRequest, testResponse);
    String results = CalloutLogs.commitLogs();
    test.stopTest();

    //check commits
    System.assertEquals('Committed 1 Callout Log Entries', results);
    list<Callout_Log__c> readList = [SELECT Id, HTS_Terminal_Id__c FROM Callout_Log__c Order By CreatedDate Desc];
    // testSetupDate inserted Num_Of_Test_Records_to_INS records and this method inserted 1.
    System.assertEquals(Num_Of_Test_Records_to_INS + 1, readList.size());
    System.assertEquals('46435168', readList[0].HTS_Terminal_Id__c);
  }


  static testMethod void test_getRecordsToPurgeHALF()
  {
    
  // Retention_Policy__mdt is a "Custom MetaData Type".  As of 2017-09-12 the one record has Days__c set to 90.
  // Make sure it exists in this Sandbox or Production, but don't otherwise use its value in tests as it could change.
       List<Retention_Policy__mdt> myRetentionPol = [SELECT Days__c FROM Retention_Policy__mdt WHERE DeveloperName='Callout_Log_c'];
       System.assert(myRetentionPol != null);
       Integer Dummmy_Days_To_Retain = Integer.valueOf(myRetentionPol[0].Days__c);
       System.assert(Dummmy_Days_To_Retain != 0);

  // SetupTestData INSERTED Num_Of_Test_Records_to_INS records with CreatedDates starting yesterday and incremented day-1

    // This is the function we are testing. Delete half the test records, by going back halfway into the date range.
    List<Callout_Log__c> toDel1 = CalloutLogs.getRecordsToPurge(Num_Of_Test_Records_to_INS/2);

    Date maxDT1 = Date.newInstance(2000,01,01);
    Date minDT1 = Date.today().addDays(100);

    For (Callout_Log__c oneCLRec : toDel1)
    {
      if(oneCLRec.CreatedDate.date() > maxDT1) maxDT1= oneCLRec.CreatedDate.date();
  
      if(oneCLRec.CreatedDate.date() < minDT1) minDT1= oneCLRec.CreatedDate.date();
    }

    System.debug('Half toDel1: ' + string.valueOf(maxDt1) + '    ' + string.valueOf(minDt1) + '  Count: ' + string.valueOf(toDel1.size()) );

    Date Expected_Max_Date_in_Recs_to_DEL1 = DTToday.addDays(-Num_Of_Test_Records_to_INS/2-1);
    System.assertEquals(Expected_Max_Date_in_Recs_to_DEL1, maxDT1,'maxDT1 of toDel1 half failed.');

    Date Expected_Min_Date_in_Recs_to_DEL1 = DTToday.addDays(-Num_Of_Test_Records_to_INS);
    System.assertEquals(Expected_Min_Date_in_Recs_to_DEL1, minDT1,'minDT1 of toDel1 half compared to Date.today().addDays(-Num_Of_Test_Records_to_INS)  failed');

    System.assertEquals(Num_Of_Test_Records_to_INS/2, toDel1.size(),'Record count to purge not half of test records');

// Now purge the records and verify what's left in Callout_Log__c.
    Delete toDel1;

    List<Callout_Log__c> remaining_Undeleted_Recs = [SELECT CreatedDate, Id from Callout_Log__c order by CreatedDate];
    Date maxDT2 = Date.newInstance(2000,01,01);
    Date minDT2 = Date.today().addDays(100);

    For (Callout_Log__c oneCLRec : remaining_Undeleted_Recs)
    {
      if(oneCLRec.CreatedDate.date() > maxDT2) maxDT2= oneCLRec.CreatedDate.date();
  
      if(oneCLRec.CreatedDate.date() < minDT2) minDT2 = oneCLRec.CreatedDate.date();
    }

    System.debug('Half remaining_Undeleted_Recs: ' + string.valueOf(maxDt2) + '    ' + string.valueOf(minDt2) + '  Count: ' + string.valueOf(remaining_Undeleted_Recs.size()) );

    Date Expected_Min_Date_in_Recs_to_Keep =  DTToday.addDays(-Num_Of_Test_Records_to_INS/2);
    System.assertEquals(Expected_Min_Date_in_Recs_to_Keep, minDT2,'minDT2 of remaining_Undeleted_Recs half compared to Date.today().addDays(-Num_Of_Test_Records_to_INS/2)  failed');

    System.assertEquals(DtYesterday, maxDT2,'maxDT2 of remaining_Undeleted_Recs half not yesterday.');
    System.assertEquals(Num_Of_Test_Records_to_INS/2, remaining_Undeleted_Recs.size(),'Record count remaining after purge not half of test records');
  }





static testMethod void test_getRecordsToPurge3Fourths()
  {
    
  // Retention_Policy__mdt is a "Custom MetaData Type".  As of 2017-09-12 the one record has Days__c set to 90.
  //  Someone might change it, so DON"T use it in testing     List<Retention_Policy__mdt> myRetentionPol = [SELECT Days__c FROM Retention_Policy__mdt WHERE DeveloperName='Callout_Log_c'];
  //  Someone might change it, so DON"T use it in testing     Integer Days_To_Retain = Integer.valueOf(myRetentionPol[0].Days__c);

  // SetupTestData INSERTED Num_Of_Test_Records_to_INS records with CreatedDates starting yesterday and incremented day-1

    // This is the function we are testing. Delete the oldest 1/4 of the records leaving 3/4 by going back 3/4 of the date range.
    List<Callout_Log__c> toDel1 = CalloutLogs.getRecordsToPurge(3*Num_Of_Test_Records_to_INS/4);

    Date maxDT1 = Date.newInstance(2000,01,01);
    Date minDT1 = Date.today().addDays(100);

    For (Callout_Log__c oneCLRec : toDel1)
    {
      if(oneCLRec.CreatedDate.date() > maxDT1) maxDT1= oneCLRec.CreatedDate.date();
  
      if(oneCLRec.CreatedDate.date() < minDT1) minDT1= oneCLRec.CreatedDate.date();
    }

    System.debug('One Fourth toDel1: ' + string.valueOf(maxDt1) + '    ' + string.valueOf(minDt1) + '  Count: ' + string.valueOf(toDel1.size()) );

    Date Expected_Max_Date_in_Recs_to_DEL1 = DTToday.addDays(-3*Num_Of_Test_Records_to_INS/4-1);
    System.assertEquals(Expected_Max_Date_in_Recs_to_DEL1, maxDT1,'maxDT1 of toDel1 1/4 failed.');

    Date Expected_Min_Date_in_Recs_to_DEL1 = DTToday.addDays(-Num_Of_Test_Records_to_INS);
    System.assertEquals(Expected_Min_Date_in_Recs_to_DEL1, minDT1,'minDT1 of toDel1 1/4 compared to Date.today().addDays(-Num_Of_Test_Records_to_INS)  failed');
    
    System.assertEquals(Num_Of_Test_Records_to_INS/4, toDel1.size(),'Record count to purge not 1/4 of test records');

// Now purge the records and verify what's left in Callout_Log__c.
    Delete toDel1;

    List<Callout_Log__c> remaining_Undeleted_Recs = [SELECT CreatedDate, Id from Callout_Log__c order by CreatedDate];
    Date maxDT2 = Date.newInstance(2000,01,01);
    Date minDT2 = Date.today().addDays(100);

    For (Callout_Log__c oneCLRec : remaining_Undeleted_Recs)
    {
      if(oneCLRec.CreatedDate.date() > maxDT2) maxDT2= oneCLRec.CreatedDate.date();
  
      if(oneCLRec.CreatedDate.date() < minDT2) minDT2 = oneCLRec.CreatedDate.date();
    }

    System.debug('Three Fourths remaining_Undeleted_Recs: ' + string.valueOf(maxDt2) + '    ' + string.valueOf(minDt2) + '  Count: ' + string.valueOf(remaining_Undeleted_Recs.size()) );

    Date Expected_Min_Date_in_Recs_to_Keep = DTToday.addDays(-3*Num_Of_Test_Records_to_INS/4);
    System.assertEquals(Expected_Min_Date_in_Recs_to_Keep, minDT2,'minDT2 of remaining_Undeleted_Recs 3/4 compared to Date.today().addDays(-3*Num_Of_Test_Records_to_INS/4)  failed');

    System.assertEquals(DtYesterday, maxDT2,'maxDT2 of remaining_Undeleted_Recs 3/4 not yesterday.');
    System.assertEquals(3*Num_Of_Test_Records_to_INS/4, remaining_Undeleted_Recs.size(),'Record count remaining after purge not 3/4 of test records');
  }

}