public class beam_to_beams_XML{

    Public void Schedule_This() 
    {
        // Despite the name of this method, it turns out this cannot be scheduled because it does two
        // callouts to http://KVHUpdate.com and the second callout depends on the results returned by the
        // first callout.  Scheduled Apex skips callouts unless marked @Future.  @Future cannot easily be used
        // because the methods can't return any results other than void.
        // 
        // If this class was split into two classes where the @Future method in the first class scheduled the second class
        // it might be able to be schedulable.
        // 
        // Get XML from KVHUpdate.com with <date> and <version> tags.
        String XML_fr_KVHUpdate = GET_Beams_File_Version_XML_From_KVHUpDate();
        
        // Parse value of the <date> as string
        String KVHUpDate_ModDate_Str = Parse_Beams_XML_Date(XML_fr_KVHUpdate);
        
        // Query SalesForce Beams_History for the lastest change to our fields
        Datetime SF_ModDate = Get_DateTime_when_OUR_fields_Last_Changed();
        
        // Convert the SalesForce Date to a string in the KVH format.
        String SF_ModDate_Str = Convert_DateTime_to_KVH_Str(SF_ModDate);
                
        System.debug(SF_ModDate_Str + 'In Schedule_This SF_ModDate_Str.'); 
        System.debug(KVHUpDate_ModDate_Str + 'In Schedule_This KVHUpDate_ModDate_Str.'); 

        String[] toAddresses = new String[] {};
            
        user[] usersToEmail =  [Select email from user where (firstname='Andrew' and Lastname='Magruder') 
                                or (firstname='Jacob' and Lastname='George') or (firstname='Marc' and Lastname='Edwards')];
        
        if (!usersToEmail.isEmpty()) {
            for (user myOneUser : usersToEmail)
            {   
                toAddresses.add(myOneUser.email);
            }
        }
        
        if (SF_ModDate_Str != KVHUpDate_ModDate_Str){
            // The KVHUpdate Date and the latest Beams_History CreatedDate differ.
            // Increment the version and POST the Beams.XML contents to KVHUpdate.com .
            String beams_Version = Parse_Beams_XML_Version(XML_Fr_KVHUpdate);
            
            beams_Version = Version_Increment(beams_Version);
            
            // Thus call generates the XML that will become the contents of Beams.XML .
            String XML_to_POST = make_ACU_XML_str(beams_Version);
            // http POST it to KVHUpdate.com
            integer HttpStatus = POST_Beams_XML_To_KVHUpDate(XML_to_POST);
            
            if (HttpStatus == 200)
            {
                Messaging.SingleEmailMessage mailGood = new Messaging.SingleEmailMessage();          
            
                mailGood.setSubject('Successfully http POST\'ed Beams.XML to KVHUpdate.com.');
                
                String msgBody = 'A new Beams.xml was generated and http POST\'ed to KVHUpdate.com by SalesForce.   At least one of the relevant SalesForce Beam fields had a data change on at least one record, or a new record was added on: ' + SF_ModDate_Str +
                    '   The new version is: ' + string.valueof(beams_Version);                
                
                mailGood.setPlainTextBody(msgBody);
                
                // String[] toAddresses = new String[] {'amagruder@kvh.com'};
                mailGood.setToAddresses(toAddresses);
                mailGood.setReplyTo('amagruder@kvh.com');
                mailGood.setSenderDisplayName('SalesForce Apex class beam_to_beams_XML');
                
                if (! Test.isRunningTest()) Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailGood });                
            }
            else
            {
                Messaging.SingleEmailMessage mailPOSTFailed = new Messaging.SingleEmailMessage();          
            
                mailPOSTFailed.setSubject('The http POST of Beams.XML to KVHUpdate.com failed.');

                String msgBody = 'An attempt was made to http POST Beams.XML with <date> tag value: ' + SF_ModDate_Str +
                    '   and version: ' + string.valueof(beams_Version).replace(',','') + ' but the http status returned was ' + string.valueOf(HttpStatus);                
                
                mailPOSTFailed.setPlainTextBody(msgBody);

                mailPOSTFailed.setToAddresses(toAddresses);
                mailPOSTFailed.setReplyTo('amagruder@kvh.com');
                mailPOSTFailed.setSenderDisplayName('SalesForce Apex class beam_to_beams_XML');
                
                if (! Test.isRunningTest()) Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailPOSTFailed });                
            }
        }
        else
        {
            // The KVHUpdate <date> value and the latest Beams_History CreatedDate are the same.
            // Do nothing but send an email to Andy.
            Messaging.SingleEmailMessage mailNoChg = new Messaging.SingleEmailMessage();          
        
            mailNoChg.setSubject('No change to SF Beams records vs. KVHUpDate.com Beams.XML.');
            mailNoChg.setPlainTextBody('FYI, SalesForce has had no change to Beams since this KVHUpdate beams.xml was POST\'ed: ' + XML_fr_KVHUpdate);

            mailNoChg.setToAddresses(toAddresses);
            mailNoChg.setReplyTo('amagruder@kvh.com');
            mailNoChg.setSenderDisplayName('SalesForce Apex class beam_to_beams_XML');
            
            if (! Test.isRunningTest()) Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailNoChg });            
        }
   }    

    Public String make_ACU_XML_str(String beams_Version_NEW)
    {

        String ACU_XML_str ='<beams version="' + beams_Version_NEW + '" date="';
        
        Datetime ModDt = Get_DateTime_when_OUR_fields_Last_Changed();
        
        ACU_XML_str += Convert_DateTime_to_KVH_Str(ModDt) + '">';
 
        List<Beam__c> myBeams = [SELECT Orbital_Location__c,Frequency_KU_Downlink_MHz__c,ACU_Name__c,Google_Designator__c,SAT_Name__c,Frequency_Band__c 
                        from Beam__c where Status__c = 'Active' order by Id];
        
        String sat_orb_slot_Str = '';
        decimal sat_orb_slot_DB = 00000.000;
        decimal sat_orb_slot_dec = 00000;        
        integer sat_orb_slot_int = 0;
        
        for (Beam__c myOneBeam: myBeams)
        {
            sat_orb_slot_DB = myOneBeam.Orbital_Location__c;
            sat_orb_slot_dec = sat_orb_slot_DB.divide(10, 0, System.RoundingMode.DOWN);
            sat_orb_slot_int = integer.valueOf(sat_orb_slot_dec);
            sat_orb_slot_Str = String.valueOf(sat_orb_slot_int);
            
            sat_orb_slot_Str.replace(',', '');
            
            ACU_XML_str += '<beam><sat_orb_slot>' + sat_orb_slot_Str + '</sat_orb_slot>' +
            '<sat_fwd_link>' + myOneBeam.Frequency_KU_Downlink_MHz__c * 10 + '</sat_fwd_link>' +
            '<acu_desig>' + myOneBeam.Google_Designator__c + '</acu_desig>' +
            '<web_desig>' + myOneBeam.ACU_Name__c + '</web_desig>' +
            '<satellite>' + myOneBeam.SAT_Name__c + '</satellite>' +
            '<band>' + myOneBeam.Frequency_Band__c + '</band></beam>';
        }
        
        ACU_XML_str += '</beams>';
        
        Return ACU_XML_str;
    }

    Public String Convert_DateTime_to_KVH_Str (DateTime ModDt)
    {
        
        String YearStr =  ModDt.yearGmt().format();
        Yearstr = YearStr.replace(',', '');
        
        String MonthStr =  ModDt.monthGmt().format();
        if (MonthStr.length() == 1) {MonthStr = '0' + MonthStr;}
            
        String DayStr = ModDt.dayGmt().format();
        if (DayStr.length() == 1) {DayStr = '0' + DayStr;}
            
        String HourStr =  ModDt.hourGmt().format();
        if (HourStr.length() == 1) {HourStr = '0' + HourStr;}  
            
        String MinuteStr =  ModDt.minuteGmt().format();
        if (MinuteStr.length() == 1) {MinuteStr = '0' + MinuteStr;}
            
        String SecondStr = ModDt.secondGmt().format();       
        if (SecondStr.length() == 1) {SecondStr = '0' + SecondStr;}
            
        Return  YearStr + '-' + MonthStr + '-' + DayStr + 'T' + HourStr + ':' + MinuteStr + ':' + SecondStr + 'Z' ;
                      
    }

    Public Datetime Get_DateTime_when_OUR_fields_Last_Changed ()
    {
    
/**   Not going to work in a trigger because the history file has NOT been updated
      yet when the trigger runs according to the Apex Code Developers Guide PDF. **/
        
        Datetime Dt_newest;
        Dt_newest = Datetime.newInstanceGmt(2000, 1, 1, 0, 0, 0);
        
        List<Beam__History> myBH = [SELECT Field, OldValue, NewValue, CreatedDate from Beam__History
            WHERE 
             Field = 'ACU_Name__c' or
             Field = 'Frequency_KU_Downlink_MHz__c' or 
             Field = 'Frequency_Band__c' or
             Field = 'Google_Designator__c' or
             Field = 'SAT_Long__c' or
             Field = 'SAT_Name__c' or
             Field = 'Status__c'];
        
         
        if (!myBH.isEmpty()) {
            for (Beam__History myOneBH : myBH)
            {   
                if (Dt_newest < myOneBH.CreatedDate) {Dt_newest=myOneBH.CreatedDate;}
            }
        }

        system.debug('In Get_DateTime_when_OUR_fields_Last_Changed  Dt_newest: ' + Dt_newest);        
        
        return Dt_newest;    
    }
    
    Public String Parse_Beams_XML_Version (String Ver_XML_Fr_KVHUpdate)
    {
        /**
            Parse the 12345 out of <version>12345</version>
            See http://wiki.kvhinternal.kvhi/pages/viewpage.action?spaceKey=SoftEng&title=Beam+Table+Dynamic+Update&src=search

            <ipacu_response>
                <message name="latest_beam_table" error="0"/>
                <version>12345</version>
                <file_size>5565</file_size>
                <date>2014-02-12T19:32:48Z</date>
                <url>http://www.kvhupdate.com/VSAT/Beams/beams.xml</url>
            </ipacu_response>

        **/
        String VerTagText = '';        
        XmlStreamReader reader = new XmlStreamReader(Ver_XML_Fr_KVHUpdate);
      
        while(reader.hasnext()) {
            reader.next();
            if (reader.getEventType() == XmlTag.START_ELEMENT){
                // System.debug(reader.getLocalName());
                if ('version' == reader.getLocalName()) {
                    reader.next();
                    if (reader.isWhitespace() && reader.hasnext()) {reader.next();}
                    if (reader.getEventType() == XmlTag.CHARACTERS) 
                    {
                        VerTagText = reader.getText();
                        // System.debug('Version Text: ' + VerTagText);
                        Return VerTagText;
                    }
                } 
            } // START_ELEMENT
        } // While   
        Return '7.1';  // No <version> tag found
    }
    
    Public String GET_Beams_File_Version_XML_From_KVHUpDate () 
    {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
    
        req.setEndpoint('http://www.kvhupdate.com/VSAT/Beams/portalMain.php/latest_beam_table');
        req.setMethod('GET');
    
        try 
        {
            if (Test.isRunningTest())
                // This line of code is only run for unit tests to reach the 75% coverage
                return '<ipacu_response><message name="latest_beam_table" error="0"/><version>12345.99</version><file_size>5565</file_size><date>2014-02-12T19:32:48Z</date><url>http://www.kvhupdate.com/VSAT/Beams/beams.xml</url></ipacu_response>';
            else
                res = http.send(req);
            Return res.getBody();            
        } catch(System.CalloutException e) 
        {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
            Return '';
        }
    }
    

    Public Integer POST_Beams_XML_To_KVHUpDate (String MyBody) 
    {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
    
        req.setEndpoint('http://www.kvhupdate.com/VSAT/Beams/portalMain.php/set_beam_table');
        req.setMethod('POST');
        req.setBody(MyBody);
        
        try 
        {
            if (Test.isRunningTest())
                // For unit testing only
                return 200; 
            else
                res = http.send(req);
            
            system.debug(res.getBody());
            
            Return res.getStatusCode();
        } catch(System.CalloutException e) 
        {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
            Return -999;
        }
    }    
   
    Public String Parse_Beams_XML_Date (String Ver_XML_Fr_KVHUpdate)
    {
        /**
            Parse the 2014-02-12T19:32:48Z out of <date>2014-02-12T19:32:48Z</date>
            See http://wiki.kvhinternal.kvhi/pages/viewpage.action?spaceKey=SoftEng&title=Beam+Table+Dynamic+Update&src=search

            <ipacu_response>
                <message name="latest_beam_table" error="0"/>
                <version>12345</version>
                <file_size>5565</file_size>
                <date>2014-02-12T19:32:48Z</date>
                <url>http://www.kvhupdate.com/VSAT/Beams/beams.xml</url>
            </ipacu_response>

        **/
        String TagName = '';
        String DateTagText = '';        
        XmlStreamReader reader = new XmlStreamReader(Ver_XML_Fr_KVHUpdate);
      
        while(reader.hasnext()) {
            reader.next();
            // System.debug('In Parse_Beams_XML_Date getEventType after outer next: ' + reader.getEventType());
            if (reader.getEventType() == XmlTag.START_ELEMENT){
                TagName=reader.getLocalName();
                // System.debug('In Parse_Beams_XML_Date START_ELEMENT Tag: ' + TagName);
                if ('date' == TagName) {
                    reader.next();
                    if (reader.isWhitespace() && reader.hasnext()) {reader.next();}
                    if (reader.getEventType() == XmlTag.CHARACTERS) 
                    {
                        DateTagText = reader.getText();
                        Return DateTagText;
                    }
                } 
            } // START_ELEMENT
        } // While   
        Return '2000-01-01T00:00:00Z';  // No <version> tag found
    }
    
    Public String Version_Increment (String beams_Version_IN)
    {
        // The major version indicates data format changes to beams.xml or the fields.
        // It will stay at 7 forever until someone changes this code.
        String beams_Version_OUT;
        
        Integer PeriodLoc;
        Integer LenVer;
        
        PeriodLoc = beams_Version_IN.indexOf('.');
        LenVer= beams_Version_IN.length();
        
        if (beams_Version_IN == '6'){
            // One-time advance from 6 to 7.1 at Jacob George's request.
            beams_Version_OUT = '7.1';
        }
        else if(PeriodLoc == -1){
            beams_Version_OUT = beams_Version_IN + '.1';
        }
        else if (PeriodLoc == 0){
            // Handle completely unexpected condition to prevent math errors.
            beams_Version_OUT = '7.1';    
        }
        else if (PeriodLoc == LenVer-1) {
            // Handle unexpected condition, the period is the last character, to prevent math errors.
            beams_Version_OUT = '7.1';    
        }        
        else
        {
            // Handle a normal version like 7.1, 7.9, 7.10, 7.100  etc.
            // Increment the minor version.
            String VerMinor_Str;
            String Ver_MAJOR_Str;
            Ver_MAJOR_Str = beams_Version_IN.left(PeriodLoc);
            VerMinor_Str = beams_Version_IN.substring(PeriodLoc + 1);
            
            
            if(VerMinor_Str.isNumeric())
            {
                Integer VerMinor;
                VerMinor = Integer.valueOf(VerMinor_Str);
                VerMinor += 1;
                VerMinor_Str = String.valueOf(VerMinor);
                VerMinor_Str = VerMinor_Str.replace(',', '');
                beams_Version_OUT = Ver_MAJOR_Str + '.' + VerMinor_Str;
            }
            else
            {
                beams_Version_OUT = Ver_MAJOR_Str + '.1';
            }    
        }
        
   
        Return beams_Version_OUT;        
    }

}