@isTest 
global class EventPortalComponentControllerTest{
    global class MockHttpResponseEventList  implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest req) {
           HttpResponse res = new HttpResponse();
           res.setHeader('Content-Type', 'text/xml');
           String eventdate = System.now().adddays(1).format('yyyyMMdd');
           String body = '<?xml version="1.0" standalone="no"?><IRXML CorpMasterID="70131"><Events PubDate="20170824" PubTime="16:45:21" CorpMasterID="70131">'
                            +'<Event EventID="1575961" EventType="21" EventDateEstimate="No" DLU="Jun 6 20071:16PM" EventStatus="0" AllowCalendarToDetailsDrilldown="Yes" TimeZone="GMT" EventStartDate="20070910" EventStartTime="" EventEndDate="20070916" EventEndTime="" EventDisplayFromDate="20070606" EventDisplayFromTime="13:16:56" EventDisplayToDate="20170606" EventDisplayToTime="13:16:56" MultiDay="Yes" TickerSymbol="KVHI" CompanyName="KVH Industries, Inc." DetailsPageTitle="">'
                            +'<EventTitle>Pennsylvania RV &amp; Camping Show</EventTitle>'
                            +'<DisplayableDatesTimes>'
                            +'<DisplayableDateTime TimeZone="" EventStartDate="' + eventdate + '" EventStartTime="" EventEndDate="' + eventdate + '" EventEndTime="" MultiDay="Yes" SpecialLabel="NST" />'
                            +'</DisplayableDatesTimes>'
                            +'<DrillDownOverridingLinkUrl Stream="No"></DrillDownOverridingLinkUrl>'
                            +'<EventEmailReminder DaysPrior="" />'
                            +'<Description></Description>'
                            +'<FutureEvents Title="Future Events:">To be notified by e-mail of future events such as quarterly conference calls and other investor meetings, please subscribe to the e-mail alert list located on our &lt;A HREF="phoenix.zhtml?c=70131&amp;p=irol-calendar"&gt;Calendar page&lt;/A&gt;.</FutureEvents>'
                            +'<AdditionalInformationContact></AdditionalInformationContact>'
                            +'<Location ID="206479">'
                            +'<LocationName></LocationName>'
                            +'<Address1>Booth # 120, 121</Address1>'
                            +'<Address2>Giant Center</Address2>'
                            +'<LocationRoom></LocationRoom>'
                            +'<City>Hershey</City>'
                            +'<State>PA</State>'
                            +'<Country>US</Country>'
                            +'<Zip></Zip>'
                            +'<LocationURL></LocationURL>'
                            +'</Location>'
                            +'</Event> '
                            +'<Event EventID="1575961" EventType="21" EventDateEstimate="No" DLU="Jun 6 20071:16PM" EventStatus="0" AllowCalendarToDetailsDrilldown="Yes" TimeZone="GMT" EventStartDate="20070910" EventStartTime="" EventEndDate="20070916" EventEndTime="" EventDisplayFromDate="20070606" EventDisplayFromTime="13:16:56" EventDisplayToDate="20170606" EventDisplayToTime="13:16:56" MultiDay="Yes" TickerSymbol="KVHI" CompanyName="KVH Industries, Inc." DetailsPageTitle="">'
                            +'<EventTitle>Pennsylvania RV &amp; Camping Show</EventTitle>'
                            +'<DisplayableDatesTimes>'
                            +'<DisplayableDateTime TimeZone="" EventStartDate="' + eventdate + '" EventStartTime="" EventEndDate="' + eventdate + '" EventEndTime="" MultiDay="Yes" SpecialLabel="NST" />'
                            +'</DisplayableDatesTimes>'
                            +'<DrillDownOverridingLinkUrl Stream="No"></DrillDownOverridingLinkUrl>'
                            +'<EventEmailReminder DaysPrior="" />'
                            +'<Description></Description>'
                            +'<FutureEvents Title="Future Events:">To be notified by e-mail of future events such as quarterly conference calls and other investor meetings, please subscribe to the e-mail alert list located on our &lt;A HREF="phoenix.zhtml?c=70131&amp;p=irol-calendar"&gt;Calendar page&lt;/A&gt;.</FutureEvents>'
                            +'<AdditionalInformationContact></AdditionalInformationContact>'
                            +'<Location ID="206479">'
                            +'<LocationName></LocationName>'
                            +'<Address1>Booth # 120, 121</Address1>'
                            +'<Address2>Giant Center</Address2>'
                            +'<LocationRoom></LocationRoom>'
                            +'<City>Hershey</City>'
                            +'<State>PA</State>'
                            +'<Country>US</Country>'
                            +'<Zip></Zip>'
                            +'<LocationURL></LocationURL>'
                            +'</Location>'
                            +'</Event> '
                            +'</Events>'
                            
                            +'</IRXML>';
           res.setBody(body);
           res.setStatusCode(200);
           return res;
        }
    }
    
    
    @isTest 
    static void unittest() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseEventList());
        EventPortalComponentController.getEventlist('Commercial & OEM Land Systems');
    }
   
 }