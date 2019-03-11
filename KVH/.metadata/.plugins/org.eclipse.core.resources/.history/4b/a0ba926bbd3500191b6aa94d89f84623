@isTest 
global class PortalNewsComponentCtrlTest{
    global class MockHttpResponseNewsList  implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest req) {
           HttpResponse res = new HttpResponse();
           res.setHeader('Content-Type', 'text/xml');
           String body = '<?xml version="1.0" standalone="no"?><IRXML CorpMasterID="70131"><NewsReleases PubDate="20170908" PubTime="02:45:35">'
                            +'<NewsCategory Category="NA">'
                            +'<NewsRelease ReleaseID="2290947" DLU="20170802 11:06:17" ArchiveStatus="Current">'
                            +'<Title>KVH Industries Reports Second Quarter 2017 Results</Title>'
                            +'<ExternalURL>http://phx.corporate-ir.net/external.file?t=2&amp;item=o8hHt16027g9XhJTr8+weNRYaV9bFc2rMd0Q/AXw4zv2aQtdepnjhJElVy0TEbFhWsxvGblVxWqDvFLppUBrzvHJ4s7R8pzLJRr27r6YFfIFtKF7lEPuZGS3bnbLRyZXmaLY0XlagLMLzNVh1gI0FQ==&amp;cb=636372687779251446</ExternalURL>'
                            +'<Date Date="20170802" Time="07:02:00">8/2/2017 7:02:00 AM</Date>'
                            +'<DisplayDateStart Date="20170802" Time="07:06:17">Aug 02 2017 07:06</DisplayDateStart>'
                            +'<DisplayDateEnd Date="99991231" Time="00:00:00">Dec 31 9999 12:00</DisplayDateEnd>'
                            +'<ContentNetworkingLinks />'
                            +'</NewsRelease>'
                            +'</NewsCategory>'
                            +'</NewsReleases></IRXML>';
           res.setBody(body);
           res.setStatusCode(200);
           return res;
        }
    }
    
    global class MockHttpResponseNewsDetail  implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest req) {
           HttpResponse res = new HttpResponse();
           res.setHeader('Content-Type', 'text/xml');
           String body = '<?xml version="1.0" standalone="no"?>'
                        +'<IRXML CorpMasterID="70131">'
                        +'<NewsReleaseText PubDate="20040105" PubTime="13:46:58" ReleaseID="84135" DLU="20000404 13:24:00">'
                        +'<Title>KVH Puts Lock On Mobile Satellite TV With DVB-integrated TracVision 4</Title>'
                        +'<Date Date="20000217" Time="00:00:00">2/17/2000</Date>'
                        +'<ReleaseText><![CDATA[test]]></ReleaseText>'
                        +'</NewsReleaseText></IRXML>';
           res.setBody(body);
           res.setStatusCode(200);
           return res;
        }
    }
   
    
    @isTest 
    static void unittest() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseNewsList());
        PortalNewsComponentCtrl.getNewslist();
    }
    
    @isTest 
    static void unittest2() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseNewsDetail());
        PortalNewsDetailController.getNewsDetail('84135');
    }
 }