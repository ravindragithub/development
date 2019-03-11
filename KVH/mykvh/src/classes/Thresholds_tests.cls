@isTest
private class Thresholds_tests {
    
	@testSetup static void setupTestData(){
        // setup common test data here. Every test method in this class gets a fresh copy of this data when the method starts
        // Insert Num_Of_Test_Records_to_INS records with CreatedDate from yesterday to Num_Of_Test_Records_to_INS days ago.
        // Vary the values in the various fields using the record number.
        Threshold_of_record_count__mdt[] myMetaRecs = [SELECT DeveloperName,Low_Limit__c FROM Threshold_of_record_count__mdt WHERE DeveloperName='HTS_Static_IPs'];
        system.AssertEquals(1, myMetaRecs.size());
        Integer Lower_Limit_HTS_Static_IPs = (Integer)myMetaRecs[0].Low_Limit__c;
        system.Assert(Lower_Limit_HTS_Static_IPs <= 42); //make sure that out test data generation isn't going to blow up!
        system.assertNotEquals(0,Lower_Limit_HTS_Static_IPs,'Error in Custom Metadata Type!');
		System.Debug('In setupTestData Lower_Limit_HTS_Static_IPs=' + String.valueOf(Lower_Limit_HTS_Static_IPs));
        
        //The CONUS region uses channels 1703 and 1704
        //The EMEA region uses channels 1705 and 1706
        //The ASIA region uses channels 1707 and 1708

        List<String> myRegions = new List<String> {'ASIA','CONUS','EMEA'};
        List<HTS_Static_IPs__c> testRecs = new List<HTS_Static_IPs__c>(); 

        List<String> myChannels = new List<String> {'1703','1704','1705','1706','1707','1708'};
        for(String aChannel:myChannels){                                //For each of the data channels....
            for(Integer i = 0; i < Lower_Limit_HTS_Static_IPs + 1; i++){    // We want to be *just* above the threshold
                String channelRegion = '';
                if(aChannel == '1703' || aChannel == '1704'){
                    channelRegion = 'CONUS';
                } else if(aChannel == '1705' || aChannel == '1706'){
                    channelRegion = 'EMEA';
                } else if(aChannel == '1707' || aChannel == '1708'){
                    channelRegion = 'ASIA';
                } else {
                    system.assert(false,'There is something wrong... Invalid channel in test Data setup for Thresholds_tests');
                }
                testRecs.add(generateStaticIP('10.225.23.' + i, channelRegion, aChannel));  //a little risk here if the threshold is > 42!
                                                                                            //2 channels * 3 regions * 43 lowlimit = 258
                                                                                            //... we want valid IP Addresses!
            }
        }
        insert testRecs;
	}

    static testMethod void test_setupData(){
        test.startTest();
        Threshold_of_record_count__mdt[] myMetaRecs = [SELECT DeveloperName,Low_Limit__c FROM Threshold_of_record_count__mdt WHERE DeveloperName='HTS_Static_IPs'];
        system.AssertEquals(1, myMetaRecs.size());
        Integer threshold = (Integer)myMetaRecs[0].Low_Limit__c;
        system.Assert(threshold <= 42); //make sure that out test data generation isn't going to blow up!
        list<HTS_Static_IPs__c> readList = [SELECT Id, Name, isReserved__c, Channel_Id__c, Region__c, Date_Issued__c
                                            FROM HTS_Static_IPs__c];
        //The number of Static IPs we generated and inserted is just ONE above the threshold for 2 channnels * 3 regions
        system.AssertEquals((threshold + 1) * 6, readList.size());
        test.stopTest();
    }

    static testMethod void test_getHTSStaticIP_Lower_Limit_OK(){
        test.startTest();
        Integer returnedInt = Thresholds.getHTSStaticIP_Lower_Limit();
        test.stopTest();
        system.assertNotEquals(0, returnedInt);
    }

    static testMethod void test_getHTSStaticIPCount(){
        Threshold_of_record_count__mdt[] myMetaRecs = [SELECT DeveloperName,Low_Limit__c FROM Threshold_of_record_count__mdt WHERE DeveloperName='HTS_Static_IPs'];
        system.AssertEquals(1, myMetaRecs.size());
        Integer lowLimit = (Integer)myMetaRecs[0].Low_Limit__c;

        test.startTest();    
        Integer ASIA_1707_Avail_Cnt = Thresholds.getHTSStaticIPCount('ASIA', '1707');
        system.assertEquals(lowLimit + 1, ASIA_1707_Avail_Cnt);
        Integer ASIA_1708_Avail_Cnt = Thresholds.getHTSStaticIPCount('ASIA', '1708');
        system.assertEquals(lowLimit + 1, ASIA_1708_Avail_Cnt);

        Integer CONUS_1703_Avail_Cnt = Thresholds.getHTSStaticIPCount('CONUS', '1703');
        system.assertEquals(lowLimit + 1, CONUS_1703_Avail_Cnt);
        Integer CONUS_1704_Avail_Cnt = Thresholds.getHTSStaticIPCount('CONUS', '1704');
        system.assertEquals(lowLimit + 1, CONUS_1704_Avail_Cnt);

        Integer EMEA_1705_Avail_Cnt = Thresholds.getHTSStaticIPCount('EMEA', '1705');
        system.assertEquals(lowLimit + 1, EMEA_1705_Avail_Cnt);
        Integer EMEA_1706_Avail_Cnt = Thresholds.getHTSStaticIPCount('EMEA', '1706');
        system.assertEquals(lowLimit + 1, EMEA_1706_Avail_Cnt); 
        test.stopTest();
    }

    
    static testMethod void test_getHTSStaticIPCount2() {
        // Get all of the available records and update them to be NOT available
        list<HTS_Static_IPs__c> updateList = new list<HTS_Static_IPs__c>();
        for(HTS_Static_IPs__c ip : [SELECT Id, Name, Date_Issued__c, isReserved__c FROM HTS_Static_IPs__c]){
            Integer lastOctet = Integer.valueOf(ip.Name.substringAfterLast('.'));   //look at the last Octet of the IP...
            if(math.mod(lastOctet,2)==0){           //"issue" the even ones...
                ip.Date_Issued__c = DateTime.Now();
            } else {
                ip.isReserved__c = true;            //"reserve" the odd ones....
            }
            updateList.add(ip);
        }
        update updateList;                          //NONE (like ZERO) should be available now!
        test.startTest();
        // There are now zero available HTS_Static_IPs__c records
        Integer ASIA_1707_Avail_Cnt = Thresholds.getHTSStaticIPCount('ASIA', '1707');
        system.assertEquals(0, ASIA_1707_Avail_Cnt);
        Integer ASIA_1708_Avail_Cnt = Thresholds.getHTSStaticIPCount('ASIA', '1708');
        system.assertEquals(0, ASIA_1708_Avail_Cnt);

        Integer CONUS_1703_Avail_Cnt = Thresholds.getHTSStaticIPCount('CONUS', '1703');
        system.assertEquals(0, CONUS_1703_Avail_Cnt);
        Integer CONUS_1704_Avail_Cnt = Thresholds.getHTSStaticIPCount('CONUS', '1704');
        system.assertEquals(0, CONUS_1704_Avail_Cnt);

        Integer EMEA_1705_Avail_Cnt = Thresholds.getHTSStaticIPCount('EMEA', '1705');
        system.assertEquals(0, EMEA_1705_Avail_Cnt);
        Integer EMEA_1706_Avail_Cnt = Thresholds.getHTSStaticIPCount('EMEA', '1706');
        system.assertEquals(0, EMEA_1706_Avail_Cnt); 
        test.stopTest();
    }
    static testMethod void test_getHTSStaticIPCount3() {
        // Get all of the available records and delete them
        list<HTS_Static_IPs__c> updateList = [SELECT Id, Name, Date_Issued__c, isReserved__c FROM HTS_Static_IPs__c];
        delete updateList;                          //NONE (like ZERO) should be available now!
        test.startTest();
        // There are now zero available HTS_Static_IPs__c records
        Integer ASIA_1707_Avail_Cnt = Thresholds.getHTSStaticIPCount('ASIA', '1707');
        system.assertEquals(0, ASIA_1707_Avail_Cnt);
        Integer ASIA_1708_Avail_Cnt = Thresholds.getHTSStaticIPCount('ASIA', '1708');
        system.assertEquals(0, ASIA_1708_Avail_Cnt);

        Integer CONUS_1703_Avail_Cnt = Thresholds.getHTSStaticIPCount('CONUS', '1703');
        system.assertEquals(0, CONUS_1703_Avail_Cnt);
        Integer CONUS_1704_Avail_Cnt = Thresholds.getHTSStaticIPCount('CONUS', '1704');
        system.assertEquals(0, CONUS_1704_Avail_Cnt);

        Integer EMEA_1705_Avail_Cnt = Thresholds.getHTSStaticIPCount('EMEA', '1705');
        system.assertEquals(0, EMEA_1705_Avail_Cnt);
        Integer EMEA_1706_Avail_Cnt = Thresholds.getHTSStaticIPCount('EMEA', '1706');
        system.assertEquals(0, EMEA_1706_Avail_Cnt); 
        test.stopTest();
    }
    static testMethod void test_getHTSStaticIPCount4(){
        Threshold_of_record_count__mdt[] myMetaRecs = [SELECT DeveloperName,Low_Limit__c FROM Threshold_of_record_count__mdt WHERE DeveloperName='HTS_Static_IPs'];
        system.AssertEquals(1, myMetaRecs.size());
        Integer lowLimit = (Integer)myMetaRecs[0].Low_Limit__c;

        test.startTest();
        //Using invalid combinations or Region and Data Channel to test conditional code   
        Integer ASIA_1707_Avail_Cnt = Thresholds.getHTSStaticIPCount('ASIA', '1703');
        system.assertEquals(0, ASIA_1707_Avail_Cnt);
        Integer ASIA_1708_Avail_Cnt = Thresholds.getHTSStaticIPCount('ASIA', '1704');
        system.assertEquals(0, ASIA_1708_Avail_Cnt);
        test.stopTest();
    }
    static testMethod void test_checkHTSStaticIpAvaiability_OK(){
        test.startTest();
        Thresholds util = new Thresholds();
        util.checkHTSStaticIpAvaiability();
        test.stopTest();
        list<Case> casesCreated = [SELECT Id FROM Case];
        system.assertEquals(0,casesCreated.size());
    }

    static testMethod void test_checkHTSStaticIpAvaiability_LOW(){
        list<HTS_Static_IPs__c> updateList = new list<HTS_Static_IPs__c>();
        list<HTS_Static_IPs__c> readList = [SELECT Id, Name, Date_Issued__c, isReserved__c, Channel_Id__c
                                                FROM HTS_Static_IPs__c
                                                WHERE Region__c = 'CONUS' AND Channel_Id__c = '1703'];
        for(Integer i = 0; i < 2; i++){     //Issue TWO to get us below the Threshold
            Integer lastOctet = Integer.valueOf(readList[i].Name.substringAfterLast('.'));   //look at the last Octet of the IP...
            if(math.mod(lastOctet,2)==0){           //"issue" the even ones...
                readList[i].Date_Issued__c = DateTime.Now();
            } else {
                readList[i].isReserved__c = true;            //"reserve" the odd ones....
            }
            updateList.add(readList[i]);
        }
        update updateList;  
        test.startTest();
        Thresholds util = new Thresholds();
        util.checkHTSStaticIpAvaiability();
        test.stopTest();
        list<Case> casesCreated = [SELECT Id FROM Case];
        system.assertEquals(1,casesCreated.size());
    }

    // Helper methods
    Static HTS_Static_IPs__c generateStaticIP(String ip, String region, String dataChannel){
        HTS_Static_IPs__c returnObj = new HTS_Static_IPs__c();
        returnObj.Channel_Id__c  = dataChannel;
        returnObj.Name = ip;
        returnObj.Private_Static_IP__c = null;
        returnObj.Region__c = region;
        return returnObj;
    }
}