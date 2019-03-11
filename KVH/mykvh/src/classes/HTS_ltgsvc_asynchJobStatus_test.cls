@isTest
private class HTS_ltgsvc_asynchJobStatus_test {
  //A common Loop Counter for bulikification purposes
  /*private static final integer MAX_LOOP_COUNTER = 200;*/
    
    @testSetup static void setupTestData(){
      //setup common test data here
      Callout_Log__c insertLog = new Callout_Log__c();
      insertLog.Res_Body__c = '{"obj_id": "75a0f8c1-9684-49df-b649-070bfb5a0912"}';
      insertLog.Req_Method__c = 'POST';
      insertLog.HTS_Terminal_Id__c = '99996464';
      insertLog.Req_Endpoint__c = 'callout:HTSOSS_dev/hts/terminals/async';
      insertLog.Time_Stamp__c = DateTime.now();
      insertLog.User_Id__c = UserInfo.getUserId();
      insert insertLog;
    }
    
    static testMethod void testSetupData(){
      //use this method to validate that you have test data setup correctly
      //this will protect you from changes to workflow, process, and validation that break your test code!
      list<Callout_Log__c> readLogs = 
        [SELECT Id, Name, HTS_Terminal_Id__c, Res_Body__c, 
                Req_Endpoint__c, Req_Method__c
         FROM Callout_Log__c];
      system.assertEquals(1, readLogs.size());
      system.assertEquals('99996464', readLogs[0].HTS_Terminal_Id__c);
    }

    static testMethod void test_getAsynchStatusByVtid(){
      //setup mock callout
      QueueHttpMock mock = new QueueHttpMock();
      HttpResponse res1 = new HttpResponse();
      //FIRST get a core module ID
      res1.setStatusCode(200);
      string responseBody = '{"complete": true,"obj_id": "75a0f8c1-9684-49df-b649-070bfb5a0912","result": true}';
      res1.setBody(responseBody);
      mock.addResponse(res1);
      Test.setMock(HttpCalloutMock.class, mock);
      //Mock responses setup!

      test.startTest();
      HTSOSS_hts_terminals_asynch returned = HTS_ltgsvc_asynchJobStatus.getAsynchStatusByVtid('99996464');
      test.stopTest();
      
      system.assertEquals(200, returned.response_code);
      system.assertEquals(true, returned.complete);
      system.assertEquals(true, returned.result);

    }

    static testMethod void test_getAsynchStatusByVtid_404(){
      //setup mock callout
      QueueHttpMock mock = new QueueHttpMock();
      HttpResponse res1 = new HttpResponse();
      //FIRST get a core module ID
      res1.setStatusCode(404);
      string responseBody = '{"message": "Task obj_id does not exist. You have requested this URI [/api/1.0/hts/terminals/async/status] but did you mean /api/1.0/hts/terminals/async/status or /api/1.0/hts/terminals/<int:id>/status or /api/1.0/hts/terminals/async ?"}';
      res1.setBody(responseBody);
      mock.addResponse(res1);
      Test.setMock(HttpCalloutMock.class, mock);
      //Mock responses setup!

      test.startTest();
      HTSOSS_hts_terminals_asynch returned = HTS_ltgsvc_asynchJobStatus.getAsynchStatusByVtid('99996464');
      test.stopTest();
      
      //system.assertEquals(true, returned.complete);
      //system.assertEquals(true, returned.result);
      system.assertEquals(404, returned.response_code);
      system.assertEquals('Task obj_id does not exist', returned.message.left(26));
      
    }

    static testMethod void test_SOQLNoRows(){
      list<Callout_Log__c> readLogs = [SELECT Id FROM Callout_Log__c];
      delete readLogs;
      test.startTest();
      HTSOSS_hts_terminals_asynch returned = HTS_ltgsvc_asynchJobStatus.getAsynchStatusByVtid('99996464');
      test.stopTest();
      system.assertEquals(400, returned.response_code);
      system.assertEquals('ERROR:', returned.message.left(6));

    }
}