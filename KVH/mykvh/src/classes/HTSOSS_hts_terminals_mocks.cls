@isTest //Only used during tests....
public with sharing class HTSOSS_hts_terminals_mocks {
  //bunch of inner Classes that implement the HttpCalloutMock interface (e.g. "respond" method)
  public class mock_terminals_POST_OK implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setStatusCode(201); //no body returned unless error
      return res;
    }
  }
  
  public class mock_terminals_NO_BODY implements HttpCalloutMock{
    integer http_status;
    public mock_terminals_NO_BODY(integer response_code){
      http_status = response_code;
    }
    public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock Interface Method!
      HttpResponse res = new HttpResponse();
      res.setStatusCode(http_status);
      return res;
    }
  }
  public class mock_terminals_general_fail implements HttpCalloutMock{
    integer http_status;
    public mock_terminals_general_fail(integer response_code){
      http_status = response_code;
    }
    public HTTPResponse respond(HTTPRequest req){ //HttpCalloutMock Interface Method!
      HttpResponse res = new HttpResponse();
      res.setStatusCode(http_status);
      res.setBody('{"message": "500 Server Error: Internal Server Error for url: https://192.168.224.12/api/1.0/config/element/satelliterouter"}');
      return res;
    }
  }
  
  public class mock_terminals_GET implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      string endpoint = req.getEndpoint();
      system.debug(endpoint);
      if(endpoint.contains('limit=1') || endpoint.contains('terminal_id=') || endpoint.contains('coremodule_id=')){
        res.setBody(terminals_GET1());
      } else {
        res.setBody(terminals_GET_via_list());
      }
      res.setStatusCode(200);
      return res;
    }
    
    private string terminals_GET_via_list(){
      string response = '';
      response += '[';
      response += '{"activate": true, "obj_id": 2045, "obj_name": "Pulse Network Terminals:KVH-Lab Term-036874", "coremodule_id": 3541},';
      response += '{"activate": false, "obj_id": 2046, "obj_name": "Pulse Network Terminals:Terminal:2080", "coremodule_id": 3542}';
      response += ']';
      return response;
    }
    
    private string terminals_GET1(){
      string response = '';
      response += '[';
      response += '{"activate": false, "obj_id": 2046, "obj_name": "Pulse Network Terminals:Terminal:2080", "coremodule_id": 3541}';
      response += ']';
      return response;
    }
  }
  public class mock_terminals_GET_by_id implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
      HttpResponse res = new HttpResponse();
      res.setStatusCode(200);
      res.setBody(mock_terminal());
      return res;
    }
    
    private string mock_terminal(){
      string response = '{';
      
      response = response + '"accessbitmask": 11111111,';
      response = response + '"activate": true,';
      response = response + '"adminpassword": "iDirect",';
      response = response + '"auto_route_to_remotes": "Inherit",';
      response = response + '"contactmail": "",';
      response = response + '"contactname": "",';
      response = response + '"contactnote": "KVH_PLAN2",';
      response = response + '"contactphone": "",';
      response = response + '"coremodule_id": 3541,';
      response = response + '"customer_id": "",';
      response = response + '"data_channels": [{"obj_id": "1703","enablestaticroutes": true}, {"obj_id": "1704","enablestaticroutes": false}],';
      response = response + '"enableauthentication": true,';
      response = response + '"enableconnectionacceleration": false,';
      response = response + '"enablertpcompression": false,';
      response = response + '"enabletcpacceleration": true,';
      response = response + '"enabletcpcompression": false,';
      response = response + '"enabletcpheadercompression": false,';
      response = response + '"enableudpcompression": false,';
      response = response + '"enableudppayloadcompression": false,';
      response = response + '"encivlen": "128 bit",';
      response = response + '"forcelogout": false,';
      response = response + '"freqoffsetmax": "20",';
      response = response + '"inboundkeyrollperiodsec": 7200,';
      response = response + '"initialpower": "-20",';
      response = response + '"is_active": true,';
      response = response + '"linkencryption": false,';
      response = response + '"maxaccelerationsession": "",';
      response = response + '"maxlinkimpairement": "10",';
      response = response + '"maxpower": "-10",';
      response = response + '"maxtcpstream": "100",';
      response = response + '"mgmtgateway": "10.243.0.1",';
      response = response + '"mgmtipaddress": "10.243.0.1",';
      response = response + '"mgmtsubnetmask": "255.255.255.0",';
      response = response + '"minbytescompression": "",';
      response = response + '"mincompressioncycles": "",';
      response = response + '"nominalmodcod": "QPSK-9/10",';
      response = response + '"obj_id": 3605,';
      response = response + '"obj_name": "KVH-Lab Term-98763456",';
      response = response + '"obj_parentid": 57,';
      response = response + '"obj_revision": 2,';
      response = response + '"onedbcompression": "",';
      response = response + '"ospassword": "iDirect",';
      response = response + '"plan_id": "KVH_PLAN2",';
      response = response + '"radiuspassword": "iDirect",';
      response = response + '"radiususername": "idirect",';
      response = response + '"rtpportrange": "",';
      response = response + '"snrmetricadvertisement": "",';
      response = response + '"statsmanagementprofile_id": "1107",';
      response = response + '"subscriber_service_ip": "",';
      response = response + '"tcpcompressionportrange": "",';
      response = response + '"tcpheadercompressionportrange": "",';
      response = response + '"tcpportrange": "",';
      response = response + '"terindetification": "",';
      response = response + '"terminal_id": "98763456",';
      response = response + '"terminaltype_id": 1828,';
      response = response + '"thresholdprofile_id": "1655",';
      response = response + '"udpcompressionmethod": "ECRTP(1)",';
      response = response + '"udppayloadportrange": "",';
      response = response + '"udppayloadsize": 100,';
      response = response + '"udpportrange": "",';
      response = response + '"updateprofile_id": 349,';
      response = response + '"userpassword": "iDirect"}';

      return response;
    }
  }

}