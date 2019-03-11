@isTest
private class beams_xml_TEST_CLASS{
    
    static testMethod void test_Beams_Xml (){
        
	/** 
	UNUSED Test an After Insert, After Update trigger   
	Beam__c b = new Beam__c(Name='TESTBEAM', ACU_Name__c = 'Test Beam ACU', Feed_Designator__c = 'Test Beam Feed Desgn', Frequency_KU_Downlink_MHz__c=1234567,
                           Map_Name__c='Test Map Name', SAT_Long__c=180.0, SAT_Name__c='Test Sat Name', Status__c='Active');
    insert b; 
	**/

// Works 1        
    beam_to_beams_XML myBmXML = new beam_to_beams_XML();
        
	String beams_Version_OUT =  myBmXML.Version_Increment('8');
    system.assertEquals('8.1', beams_Version_OUT);
        
	beams_Version_OUT =  myBmXML.Version_Increment('8.A');
    system.assertEquals('8.1', beams_Version_OUT);
        
	beams_Version_OUT =  myBmXML.Version_Increment('6');
    system.assertEquals('7.1', beams_Version_OUT);
        
	beams_Version_OUT =  myBmXML.Version_Increment('.9');
    system.assertEquals('7.1', beams_Version_OUT); 

	beams_Version_OUT =  myBmXML.Version_Increment('5.');
    system.assertEquals('7.1', beams_Version_OUT); 
        
	beams_Version_OUT =  myBmXML.Version_Increment('7.1');
    system.assertEquals('7.2', beams_Version_OUT);        

	beams_Version_OUT =  myBmXML.Version_Increment('7.999');
    system.assertEquals('7.1000', beams_Version_OUT); 
        
	beams_Version_OUT =  myBmXML.Version_Increment('8.9');
    system.assertEquals('8.10', beams_Version_OUT);         
        
    myBmXML.Schedule_This();        

	String FileVerXML=
            '<ipacu_response>' +
                '<message name="latest_beam_table" error="0"/>' +
                '<version>12345</version>' +
                '<file_size>5565</file_size>' +
                '<date>2014-02-12T19:32:48Z</date>' +
                '<url>http://www.kvhupdate.com/VSAT/Beams/beams.xml</url>' +
            '</ipacu_response>';
 
    String FileDate =myBmXML.Parse_Beams_XML_Date(FileVerXML);
    System.assertEquals('2014-02-12T19:32:48Z', FileDate);         
        
 	String VerStr = myBmXML.Parse_Beams_XML_Version(FileVerXML);       
    System.assertEquals('12345', VerStr);       

	FileVerXML=
            '<ipacu_response>' +
                '<message name="latest_beam_table" error="0"/>' +
                '<version>12345.6</version>' +
                '<file_size>5565</file_size>' +
                '<date>2014-02-12T19:32:48Z</date>' +
                '<url>http://www.kvhupdate.com/VSAT/Beams/beams.xml</url>' +
            '</ipacu_response>';
        
 	VerStr = myBmXML.Parse_Beams_XML_Version(FileVerXML);       
    System.assertEquals('12345.6', VerStr);          

	FileVerXML=
            '<ipacu_response>' +
                '<message name="latest_beam_table" error="0"/>' +
                '<version>12345.99</version>' +
                '<file_size>5565</file_size>' +
                '<date>2014-02-12T19:32:48Z</date>' +
                '<url>http://www.kvhupdate.com/VSAT/Beams/beams.xml</url>' +
            '</ipacu_response>';
        
 	VerStr = myBmXML.Parse_Beams_XML_Version(FileVerXML);       
    System.assertEquals('12345.99', VerStr);  

        
    // well-formed XML but version and date are missing so as to exercise some "else" code.
FileVerXML = '<ipacu_response>' +
                '<message name="latest_beam_table" error="0"/>' +
                '<xersion>12345</xersion>' +
                '<file_size>5565</file_size>' +
                '<yate>2014-02-12T19:32:48Z</yate>' +
                '<url>http://www.kvhupdate.com/VSAT/Beams/beams.xml</url>' +
            '</ipacu_response>';

 
    FileDate =myBmXML.Parse_Beams_XML_Date(FileVerXML);
    System.assertEquals('2000-01-01T00:00:00Z', FileDate);         
        
 	VerStr = myBmXML.Parse_Beams_XML_Version(FileVerXML);       
    System.assertEquals('7.1', VerStr); 
    
    datetime ExpectedDT;
    dateTime testDt = datetime.newInstanceGmt(2014, 2, 27, 01, 02, 03);        
    String TestStr = myBmXML.Convert_DateTime_to_KVH_Str(testDt);
    System.assertEquals('2014-02-27T01:02:03Z', TestStr);  
    
  // Add some test data to the Beams object.        
      Beam__c myBm = new Beam__c();
      myBm.ACU_Name__c = 'Test ACU Beam';
      myBm.Name='TESTBEAM';
      myBm.Frequency_KU_Downlink_MHz__c = 12345.6;
      myBm.Frequency_Band__c='Ku';
      myBM.SAT_Name__c='Test Sat Name';
      myBm.Map_Name__c='Test Map Name';
      myBm.Feed_Designator__c='Test Feed Designator';
      myBm.Modulation__c='VCSM';
      myBm.Return_Link_simacs__c=12;
      myBm.Allot_Forward_Link_Limit__c=10;
      myBm.Allot_Return_Link_Limit__c=11;
      myBm.Google_Designator__c='GOGL';
      myBm.Status__c='Active';
  	  myBm.SAT_Long__c=90.0;
        
      Database.INSERT(myBM);
  // Hopefully the above puts a record into Beam_History

      myBM.ACU_Name__c='ACU Name Mod';
      database.update(myBM);
        
	List<Beam__History> myBH = [SELECT Field, OldValue, NewValue, CreatedDate from Beam__History
    		WHERE 
             Field = 'ACU_Name__c' or
             Field = 'Frequency_KU_Downlink_MHz__c' or 
             Field = 'Frequency_Band__c' or
             Field = 'Google_Designator__c' or
             Field = 'SAT_Long__c' or
             Field = 'SAT_Name__c' or
             Field = 'Status__c'
             order by createddate desc
             LIMIT 1];
        
         
        if (!myBH.isEmpty()) {
            for (Beam__History myOneBH : myBH) {
                ExpectedDT=myOneBH.CreatedDate;
                system.debug('A Beam History Record exists, ExpectedDT: ' + ExpectedDT);
            }
        }
        else {
            system.debug('Darn, No Beam History record exists. ExpectedDT: ' + ExpectedDT);
            ExpectedDT = date.newInstance(2000, 1, 1);
        }        
 
    String XML_to_POST = myBmXML.make_ACU_XML_str('54321.99');
	System.assert(XML_to_POST.left(32) == '<beams version="54321.99" date="');        


// Works 2  
    testDt = myBmXML.Get_DateTime_when_OUR_fields_Last_Changed();
    system.debug('testDT coming out of Get_DateTime_when_OUR_fields_Last_Changed ' + testDt);
    System.assertEquals(ExpectedDT, testDt);

    String XML_fr_KVHUpdate = myBmXML.GET_Beams_File_Version_XML_From_KVHUpDate();
    System.assertEquals('<ipacu_response><message name="latest_beam_table" error="0"/><version>12345.99</version><file_size>5565</file_size><date>2014-02-12T19:32:48Z</date><url>http://www.kvhupdate.com/VSAT/Beams/beams.xml</url></ipacu_response>',
                        XML_fr_KVHUpdate);
               
  
    Integer ResponStatus= 0;
    ResponStatus = myBmXML.POST_Beams_XML_To_KVHUpDate(XML_to_POST);
    System.assert(ResponStatus==200);

        
	}
}