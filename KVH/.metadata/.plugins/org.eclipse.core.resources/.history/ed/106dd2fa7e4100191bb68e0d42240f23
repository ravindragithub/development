@isTest //Only used during tests....
public class HTSOSS_hts_satelliterouters_mocks {
  //bunch of inner Classes that implement the HttpCalloutMock interface (e.g. "respond" method)
    public class mock_satelliterouters_GET implements HttpCalloutMock{
      public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock Interface Method!
        HttpResponse res = new HttpResponse();
        res.setBody(SatelliteRoutersResponse_GET());
        res.setStatusCode(200);
        return res;
      }
      private string SatelliteRoutersResponse_GET(){
        string response = '';
        response += '[';
        response += '{"chip_sn": "1111111111", "model": "X7", "obj_id": 2120, "obj_name": "A_SROUTE_TEST_0000001", "obj_revision": 1, "serialnumber": 66666},';
        response += '{"chip_sn": "1111111112", "model": "X7", "obj_id": 2121, "obj_name": "A_SROUTE_TEST_0000002", "obj_revision": 1, "serialnumber": 66667}';
        response += ']';
        return response;
      }
    }
    
    public class mock_satelliterouters_GET_by_name implements HttpCalloutMock{
      public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock Interface Method!
        HttpResponse res = new HttpResponse();
        res.setBody(SatelliteRoutersResponse_GET());
        res.setStatusCode(200);
        return res;
      }
      private string SatelliteRoutersResponse_GET(){
        string response = '';
        response += '[';
        response += '{"chip_sn": "1111111112", "model": "X7", "obj_id": 2121, "obj_name": "A_SROUTE_TEST_0000002", "obj_revision": 1, "serialnumber": 66667}';
        response += ']';
        return response;
      }
    }
    
    public class mock_satelliterouters_GET_by_Id_success implements HttpCalloutMock{
      public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock Interface Method!
        HttpResponse res = new HttpResponse();
        res.setBody(SatelliteRoutersResponse_GET());
        res.setStatusCode(200);
        return res;
      }
      private string SatelliteRoutersResponse_GET(){
        string response = '';
        response += '{"chip_sn": "1111111111", "model": "X7", "obj_id": 2120, "obj_name": "A_SROUTE_TEST_0000001", "obj_revision": 1, "serialnumber": 66666}';
        return response;
      }
    }
    
    public class mock_satelliterouters_GET_by_Id_fail implements HttpCalloutMock{
      public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock Interface Method!
        HttpResponse res = new HttpResponse();
        res.setStatusCode(500);
        res.setBody('{"message": "500 Server Error: Internal Server Error for url: https://192.168.224.12/api/1.0/config/element/satelliterouter"}');
        return res;
      }
    }
    
    public class mock_satelliterouters_POST_success implements HttpCalloutMock{ 
      public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock Interface Method!
        HttpResponse res = new HttpResponse();  
        res.setStatusCode(201); //no body returned unless error
        return res;
      }
    }
    
    public class mock_satelliterouters_POST_fail implements HttpCalloutMock{
      public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock Interface Method!
        HttpResponse res = new HttpResponse();
        res.setStatusCode(500);
        res.setBody('{"message": "500 Server Error: Internal Server Error for url: https://192.168.224.12/api/1.0/config/element/satelliterouter"}');
        return res;
      }
    }
    
    public class mock_satelliterouters_NO_BODY_success implements HttpCalloutMock{
      integer http_status;
      public mock_satelliterouters_NO_BODY_success(integer response_code){
        http_status = response_code;
      }
      public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock Interface Method!
        HttpResponse res = new HttpResponse();
        res.setStatusCode(http_status);
        return res;
      }
    }
}