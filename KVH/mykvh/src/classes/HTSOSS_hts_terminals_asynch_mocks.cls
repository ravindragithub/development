@isTest //Only used during tests....
public with sharing class HTSOSS_hts_terminals_asynch_mocks {

  //bunch of inner Classes that implement the HttpCalloutMock interface (e.g. "respond" method)
  public class mock_terminals_asynch_POST_OK implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setStatusCode(200); 
      res.setBody('{"obj_id": "2a501c37-09cf-474a-93f5-198d47b17680"}');
      return res;
    }
  }
  public class mock_terminals_asynch_GET_OK implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setStatusCode(200); 
      res.setBody('{"complete": true,"obj_id": "b96e0041-676b-4728-97cf-9f1b1a73f7c0","result": true}');
      return res;
    }
  }
  public class mock_terminals_asynch_GET_404 implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setStatusCode(404); 
      res.setBody('{"message": "Task obj_id does not exist. You have requested this URI [/api/1.0/hts/terminals/async/status] but did you mean /api/1.0/hts/terminals/async/status or /api/1.0/hts/terminals/<int:id>/status or /api/1.0/hts/terminals/async ?"}');
      return res;
    }
  }
}