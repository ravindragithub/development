@isTest public with sharing class HTSOSS_hts_terminals_replace_mocks {
  //bunch of inner Classes that implement the HttpCalloutMock interface (e.g. "respond" method)
  public class mock_terminals_POST_1_OK implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setStatusCode(202); 
      res.setBody('[{"obj_id": "65fda444-84fc-43cf-be80-c2987dc31b2e"}]');
      return res;
    }
  }
  public class mock_terminals_POST_4_OK implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setStatusCode(202); 
      String resBodyString = '[{"obj_id": "65fda444-84fc-43cf-be80-c2987dc31b2e"},';
      resBodyString += '{"obj_id": "be91f58f-8292-4548-9dfd-a4a091585287"},';
      resBodyString += '{"obj_id": "1984f21f-d67d-4ab7-bcdd-eeda0f4a7908"},';
      resBodyString += '{"obj_id": "d88da9af-2103-47a0-9982-fdb9c3b3ea02"}]';
      res.setBody(resBodyString);
      return res;
    }
  }
  public class mock_terminals_POST_FAIL implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setStatusCode(500);
      res.setBody('Some sort of error message');
      return res;
    }
  }
  public class mock_terminals_POST_FAIL_400 implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setStatusCode(400);
      res.setBody('Some sort of error message');
      return res;
    }
  }
}