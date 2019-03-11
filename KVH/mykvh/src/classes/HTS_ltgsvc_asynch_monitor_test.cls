@isTest
private class HTS_ltgsvc_asynch_monitor_test {

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
    HTSOSS_hts_terminals_asynch returned = HTS_ltgsvc_asynch_monitor.getAsynchStatusByObjId('75a0f8c1-9684-49df-b649-070bfb5a0912');
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
    HTSOSS_hts_terminals_asynch returned = HTS_ltgsvc_asynch_monitor.getAsynchStatusByObjId('75a0f8c1-9684-49df-b649-070bfb5a0912');
    test.stopTest();
    //system.assertEquals(true, returned.complete);
    //system.assertEquals(true, returned.result);
    system.assertEquals(404, returned.response_code);
    system.assertEquals('Task obj_id does not exist', returned.message.left(26));
    
  }
}