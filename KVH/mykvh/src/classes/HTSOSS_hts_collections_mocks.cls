@isTest  //only used for tests :)
public class HTSOSS_hts_collections_mocks {
  //bunch of inner Classes that implement the HttpCalloutMock interface (e.g. "respond" method)
  public class mock_rtp implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setBody(getKvhhtsResponse());
      res.setStatusCode(200);
      res.setStatus('OK');
      return res;
    }
    
    private string getKvhhtsResponse(){
      string response = '';
      response += '{"subscriber_plans":[{"obj_name": "OP2K","upload_cir": "0.2560","out_bmc_download_mir": "10.0000","download_cir": "1.0000","in_bmc_download_mir": "1.0000","out_bmc_upload_mir": "3.0000","obj_id": "OP2K","in_bmc_upload_mir": "0.2560"}],';
      response += '"satellite_router_types":[{"obj_name":"980","obj_id":"980"},{"obj_name":"CX780","obj_id":"CX780"},{"obj_name":"CX700","obj_id":"CX700"},{"obj_name":"X7","obj_id":"X7"}],';
      response += '"terminal_templates":[{"obj_id":"TEMPLATE_1","obj_name":"TEMPLATE_1"},{"obj_id":"TEMPLATE_2","obj_name":"TEMPLATE_2"}],';
      response += '"terminal_types":[{"obj_name":"KVH-Lab TermType","obj_id":1828},{"obj_name":"KVH-Lab TermType_DC","obj_id":1854}]}';
      return response;
    }
  }
  public class mock_terminalnetworks implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setBody(getTermNetworksResponse());
      res.setStatusCode(200);
      res.setStatus('OK');
      return res;
    }
    private string getTermNetworksResponse(){
      string response = '';
      response += '[';
      response += '{"obj_parentid": 13018,"eth0ip": "10.64.24.1"},';
      response += '{"obj_parentid": 8784,"eth0ip": "10.64.12.1"},';
      response += '{"obj_parentid": 9343,"eth0ip": "10.64.20.1"},';
      response += '{"obj_parentid": 9376,"eth0ip": "10.64.21.1"},';
      response += '{"obj_parentid": 3954,"eth0ip": "10.64.7.2"},';
      response += '{"obj_parentid": 8683,"eth0ip": "10.64.11.1"},';
      response += '{"obj_parentid": 4206,"eth0ip": "10.64.8.1"},';
      response += '{"obj_parentid": 10111,"eth0ip": "10.64.19.1"},';
      response += '{"obj_parentid": 10921,"eth0ip": "10.64.18.1"},';
      response += '{"obj_parentid": 8751,"eth0ip": "10.64.4.1"},';
      response += '{"obj_parentid": 5736,"eth0ip": "10.64.15.1"},';
      response += '{"obj_parentid": 3595,"eth0ip": "10.64.3.1"},';
      response += '{"obj_parentid": 13199,"eth0ip": "10.64.10.1"},';
      response += '{"obj_parentid": 3914,"eth0ip": "10.64.6.2"},';
      response += '{"obj_parentid": 3350,"eth0ip": "10.64.2.2"},';
      response += '{"obj_parentid": 3805,"eth0ip": "10.64.5.2"},';
      response += '{"obj_parentid": 4161,"eth0ip": "10.64.9.1"},';
      response += '{"obj_parentid": 5931,"eth0ip": "10.64.16.1"},';
      response += '{"obj_parentid": 5660,"eth0ip": "10.64.14.1"},';
      response += '{"obj_parentid": 6462,"eth0ip": "10.64.17.1"},';
      response += '{"obj_parentid": 2959,"eth0ip": "10.64.1.1"},';
      response += '{"obj_parentid": 5319,"eth0ip": "10.64.13.1"},';
      response += '{"obj_parentid": 7164,"eth0ip": ""},';
      response += '{"obj_parentid": 12302,"eth0ip": "10.64.23.1"}';
      response += ']';
      system.debug('Mock response: ' + response);
      return response;
    }
  }
}