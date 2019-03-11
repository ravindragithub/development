@isTest //Only used during tests....
public class HTSOSS_hts_subscribers_mocks {
  //bunch of inner Classes that implement the HttpCalloutMock interface (e.g. "respond" method)
  public class mock_subscribers_GET_OK implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock required Interface Method "respond"!
	    HttpResponse res = new HttpResponse();
	    res.setBody(subscribersResponse_GET_OK());
	    res.setStatusCode(200);
	    return res;
    }
	  private string subscribersResponse_GET_OK(){
	    string response = '';
	    response += '[';
	    response += '  { "obj_id": "00000000-0000-0001-0000-000000000001", "status": "Active", "subscriber_id": "10.64.2", "subscriber_plan_id": "PLAN_2" },';
	    response += '{ "obj_id": "00000000-0000-0001-0000-000000000002", "status": "Active", "subscriber_id": "10.64.1", "subscriber_plan_id": "PLAN_2" }';
	    response += ']';
	    return response;
	  }
  }
  public class mock_subscribers_GET_filtered_OK implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock required Interface Method "respond"!
      HttpResponse res = new HttpResponse();
      res.setBody(subscribersResponse_GET_OK());
      res.setStatusCode(200);
      return res;
    }
    private string subscribersResponse_GET_OK(){
      string response = '';
      response += '[';
      //response += '  { "obj_id": "00000000-0000-0001-0000-000000000001", "status": "Active", "subscriber_id": "10.64.2", "subscriber_plan_id": "" },';
      response += '{ "obj_id": "00000000-0000-0001-0000-000000000002", "status": "Active", "subscriber_id": "10.64.1", "subscriber_plan_id": "PLAN_1" }';
      response += ']';
      return response;
    }
  }
  public class mock_subscribers_GET_FAIL implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock required Interface Method "respond"!
      HttpResponse res = new HttpResponse();
      res.setBody(subscribersResponse_GET_FAIL());
      res.setStatusCode(500);
      return res;
    }
    private string subscribersResponse_GET_FAIL(){
      string response = '';
      response += '{"message": "The specified subscriber does not exist. You have requested this URI [/api/1.0/hts/subscribers/] but did you mean /api/1.0/hts/subscribers/<string:id> or /api/1.0/hts/cacher/subscribers or /api/1.0/hts/cacher/subscriberattributes ?"}';
      return response;
    }
  }
  public class mock_subscribers_GET_FAIL_404 implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock required Interface Method "respond"!
      HttpResponse res = new HttpResponse();
      res.setBody(subscribersResponse_GET_FAIL());
      res.setStatusCode(404);
      return res;
    }
    private string subscribersResponse_GET_FAIL(){
      string response = '';
      response += '{"message": "The specified subscriber does not exist. You have requested this URI [/api/1.0/hts/subscribers/] but did you mean /api/1.0/hts/subscribers/<string:id> or /api/1.0/hts/cacher/subscribers or /api/1.0/hts/cacher/subscriberattributes ?"}';
      return response;
    }
  }
  public class mock_subscribers_GET_byId_OK implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock required Interface Method "respond"!
      HttpResponse res = new HttpResponse();
      res.setBody(subscriberResponse_GET_OK());
      res.setStatusCode(200);
      return res;
    }
    private string subscriberResponse_GET_OK(){
      string response = '';
      //response += '[';
      //response += '  { "obj_id": "00000000-0000-0001-0000-000000000001", "status": "Active", "subscriber_id": "10.64.2", "subscriber_plan_id": "" },';
      response += '{ "obj_id": "00000000-0000-0001-0000-000000000002", "status": "Active", "subscriber_id": "10.64.1", "subscriber_plan_id": "PLAN_1" }';
      //response += ']';
      return response;
    }
  }
	public class mock_subscribers_NO_BODY implements HttpCalloutMock{
	  integer http_status;
	  public mock_subscribers_NO_BODY(integer response_code){
	    http_status = response_code;
	  }
	  public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock Interface Method!
	    HttpResponse res = new HttpResponse();
	    res.setStatusCode(http_status);
	    return res;
	  }
	}
  
}