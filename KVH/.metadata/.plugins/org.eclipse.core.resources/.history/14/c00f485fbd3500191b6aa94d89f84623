public with sharing class HTSOSS_hts_terminals_staticips_mocks {
  //bunch of inner Classes that implement the HttpCalloutMock interface (e.g. "respond" method)
  public class mock_staticips_GET_404 implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setStatusCode(404); 
      String bodyString = '{"message":';
      bodyString += ' "404 Client Error: Not Found for url: https://192.168.224.12/api/1.0/config/element/terminal/2046. ';
      bodyString += 'You have requested this URI [/api/1.0/hts/terminals/2046/staticips]';
      bodyString += ' but did you mean /api/1.0/hts/terminals/<int:id>/staticips or /api/1.0/hts/terminals/<int:id>/status or /api/1.0/hts/terminals/async/status ?",';
      bodyString += '"remote_message": ';
      bodyString += '"{\"errors\":[{\"source\":\"\",\"errors\":[],\"severity\":0,\"silent\":0,\"code\":404,\"message\":\"Requested resource is not found\"}]}"';
      res.setBody(bodyString);
      return res;
    }
  }
  public class mock_staticips_GET_500 implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setStatusCode(500); 
      String bodyString = '{"message": "unknown message"}';
      res.setBody(bodyString);
      return res;
    }
  }
  public class mock_staticips_GET_200 implements HttpCalloutMock{ 
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setStatusCode(200); 
      String bodyString = '[{"ip_address": "199.244.86.192","obj_id": "15970894-10.64.10.66", "channel_id": "1703"}]';
      res.setBody(bodyString); 
      return res;
    }
  }
  public class mock_staticips_GET_200_multi implements HttpCalloutMock{ 
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setStatusCode(200); 
      String bodyString = '[{"ip_address": "199.244.86.192","obj_id": "15970894-10.64.10.66", "channel_id": "1703"},';
      bodyString += '{"ip_address": "199.244.86.193","obj_id": "15970894-10.64.10.128", "channel_id": "1704"}]';
      res.setBody(bodyString); 
      return res;
    }
  }
	public class mock_staticips_NO_BODY implements HttpCalloutMock{
	  integer http_status;
	  public mock_staticips_NO_BODY(integer response_code){
	    http_status = response_code;
	  }
	  public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock Interface Method!
	    HttpResponse res = new HttpResponse();
	    res.setStatusCode(http_status);
	    return res;
	  }
	}
}