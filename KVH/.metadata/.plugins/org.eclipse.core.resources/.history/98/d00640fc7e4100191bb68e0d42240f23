@isTest //Only used during tests....
public with sharing class HTSOSS_hts_terminals_status_mocks {
  //bunch of inner Classes that implement the HttpCalloutMock interface (e.g. "respond" method)
  public class mock_terminals_status implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setBody(getTerminalsStatusResponse());
      res.setStatusCode(200);
      return res;
    }
    
    private string getTerminalsStatusResponse(){
      string response = '';
      response += '{';
      response += '"message": "mock test message",';
      response += '"activation_state": "activated",';
      response += '"config_state": "nominal",';
      response += '"detail_message": "",';
      response += '"distress_state": "ok",';
      response += '"obj_id": 3238,';
      response += '"obj_name": "KVH-Terminal-AWMTEST14",';
      response += '"obj_parentid": 57,';
      response += '"operational_state": "Unknown",';
      response += '"operational_state_detail": "",';
      response += '"operational_state_id": "0",';
      response += '"performance_state": "Unknown",';
      response += '"performance_state_detail": "",';
      response += '"performance_state_id": "0",';
      response += '"state_calculation_done": "1",';
      response += '"update_state": "Unknown",';
      response += '"update_state_detail": "",';
      response += '"update_state_id": "0"';
      response += '}';
      return response;
    }
  }
}