public class myKVHEventPortalController {

    @AuraEnabled
    public static List<EventWrapper> fetchEvents(){
        List<EventWrapper> eventlst = new List<EventWrapper>();
        return eventlst;
    }
    
    @AuraEnabled
    public static List<EventWrapper> getEventlist(){
      //  System.debug('@@ selectedPortalview==>'+selectedPortalview);
        String eventIds;
        Integer futureDays;
        Integer pastdays;
            List<myKVH_Customer_Community_Settings__mdt> portalconfigurationlst = [Select Event_Id__c,Event_Past_Days__c,Event_Future_Days__c 
                                                                      From myKVH_Customer_Community_Settings__mdt];
            if(portalconfigurationlst.size()>0){
                eventIds = portalconfigurationlst[0].Event_Id__c;
                futureDays = portalconfigurationlst[0].Event_Future_Days__c != null ? (Integer)portalconfigurationlst[0].Event_Future_Days__c  : 60;
                pastdays = portalconfigurationlst[0].Event_Past_Days__c != null ? (Integer)portalconfigurationlst[0].Event_Past_Days__c : 60;
            }
        List<EventWrapper> eventlst = new List<EventWrapper>();
        if(test.isRunningtest()){
            eventIds = '21';
            pastdays = 1;
            futureDays = 1;
        }
        if(eventIds != null){
            Set<String> eventIdset = new Set<String>();
            for(String eId : eventIds.split(',')){
                eventIdset.add(eId);
            }
            
            if(eventIdset.size()>0){
                 HttpRequest req = new HttpRequest();
                 req.setEndpoint(Label.Event_Web_Service_End_Point);
                 req.setMethod('GET');
                 Http http = new Http();
                 HTTPResponse res = new HTTPResponse();
                 res = http.send(req);  
                 System.debug('@@ res==>'+res.getbody());
                 if(res.getstatuscode() == 200){
                    eventlst = parseResponse(res,eventIdset,futureDays,pastdays);
                 }
            }
        }
       
        return eventlst;
    }
    
    public static List<EventWrapper> parseResponse(HTTPResponse res,Set<String> eventIdset,Integer futureDays,Integer pastdays){ 
       
        Date pastdate = Date.today().adddays(-1*pastdays);
        Date futuredate = Date.today().adddays(futureDays);
        //system.debug('@@ response==>'+res.getbody());      
        List<EventWrapper> eventlst = new List<EventWrapper>();
        Dom.Document doc = res.getBodyDocument();
        Dom.XMLNode rootNode = doc.getRootElement();
        //System.debug('@@ rootNode==>'+rootNode );
        List<Dom.XMLNode> eventnodelst;
        if(rootNode != null){
            Dom.XMLNode eventsnode = rootNode.getChildElement('Events',null);
            if(eventsnode != null){
                eventnodelst = eventsnode.getChildElements();
            } 
        }
        System.debug('@@ eventnodelst==>'+eventnodelst);
        if(eventnodelst != null && eventnodelst.size()>0){
            for(Dom.XMLNode enode : eventnodelst){
                EventWrapper event = new EventWrapper();
                String EventType = enode.getAttribute('EventType',null);
                if(eventIdset.contains(EventType)){
                    event.fromdate = enode.getAttribute('EventStartDate',null);
                    if(event.fromdate != null){
                        event.fromdatetype = converttodate(event.fromdate);
                        event.fromdate = dateparse(event.fromdate);
                        
                    }
                    event.todate = enode.getAttribute('EventEndDate',null);
                    if(event.todate != null){
                        event.enddatetype = converttodate(event.todate);
                        event.todate = dateparse(event.todate);
                        
                    }
                    for(Dom.XMLNode cnode : enode.getChildElements()){
                        String elmType = cnode.getName();
                        String elmValue = cnode.getText();
                        if(elmType == 'EventTitle'){
                            event.EventTitle = elmValue;
                        }else if(elmType == 'Location'){
                            for(Dom.XMLNode addnode : cnode.getChildElements()){
                                String addelmType = addnode.getName();
                                String addelmValue = addnode.getText();
                                System.debug('@@' + addelmType + '==>' +addelmValue);
                                if(addelmType == 'Address1'){
                                    event.address1 = addelmValue;
                                }else if(addelmType == 'Address2'){
                                    event.address2 = addelmValue;
                                }else if(addelmType == 'City'){
                                    event.city = addelmValue;
                                }else if(addelmType == 'State'){
                                    event.state = addelmValue;
                                }else if(addelmType == 'Country'){
                                    event.country = addelmValue;
                                }else if(addelmType == 'Zip'){
                                    event.zip = addelmValue;
                                }else if(addelmType == 'LocationName'){
                                    event.LocationName = addelmValue;
                                }else if(addelmType == 'LocationRoom'){
                                    event.LocationRoom = addelmValue;
                                }
                            }
                          
                        }
                    } 
                    if(event.enddatetype >= pastdate && event.enddatetype <=  futuredate) 
                    eventlst.add(event); 
                }        
            }
        }
        if(eventlst.size()>0)
            eventlst.sort();
        return eventlst;
    }
    
    
    private static Date converttodate(String datestr){
        System.debug('@@ datestr==>'+datestr);
        String year = datestr.substring(0,4);
        String month = datestr.substring(4,6);
        String day = datestr.substring(6,8);
        month = month.length() == 1 ? ('0'+month) : month;
        
        Date newdate = Date.newinstance(integer.valueOf(year),integer.valueOf(month),integer.valueOf(day));
        return newdate;
    }
    
    private static String dateparse(String datestr){
        String formatteddate = '';
        String year = datestr.substring(0,4);
        String month = datestr.substring(4,6);
        String day = datestr.substring(6,8);
        month = month.length() == 1 ? ('0'+month) : month;
        if(month == '01'){
            month = 'January';
        }else if(month == '02'){
            month = 'February';
        }else if(month == '03'){
            month = 'March';
        }else if(month == '04'){
            month = 'April';
        }else if(month == '05'){
            month = 'May';
        }else if(month == '06'){
            month = 'June';
        }else if(month == '07'){
            month = 'July';
        }else if(month == '08'){
            month = 'August';
        }else if(month == '09'){
            month = 'September';
        }else if(month == '10'){
            month = 'October';
        }else if(month == '11'){
            month = 'November';
        }else if(month == '12'){
            month = 'December';
        }
        formatteddate = day + ' ' + month + ' ' + year;
        return formatteddate;
    }
    
   
     
    public class EventWrapper implements Comparable{
        public @AuraEnabled String EventTitle;
        public @AuraEnabled String fromdate;
        public @AuraEnabled String todate;        
        public @AuraEnabled String address1;
        public @AuraEnabled String address2;
        public @AuraEnabled String city;
        public @AuraEnabled String state;
        public @AuraEnabled String country;
        public @AuraEnabled String zip;
        public @AuraEnabled String LocationName;
        public @AuraEnabled String LocationRoom;
        public @AuraEnabled Date fromdatetype;
        public @AuraEnabled Date enddatetype;
        
        // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {
            EventWrapper event = (EventWrapper)compareTo;
            if (fromdatetype == event.fromdatetype) return 0;
            if (fromdatetype  > event.fromdatetype) return 1;
            return -1;        
        }
    }
}