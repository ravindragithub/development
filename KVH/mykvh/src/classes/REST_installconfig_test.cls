/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class REST_installconfig_test {
    private static final integer MAX_LOOP_COUNTER = 4; //Max 255!!
    private static final Id vsat_RECORD_TYPE_ID = Schema.SObjectType.Install_Config__c.getRecordTypeInfosByName().get('VSAT').getRecordTypeId();
    @testSetup static void setupTestData(){
        //Need some Public IPs, Proviste IPS... and Install & Configs
        //Also need an Account to hang everything from....
        Account testAcct = new Account(name='Test Account');
        insert testAcct;
        //Need "Root" Assets....
        list<Asset> parentAssets = new list<Asset>();
        system.debug('parentAssets.size() == ' + parentAssets.size());
        for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
            Asset testAsset = new Asset(AccountId = testAcct.Id);
            testAsset.Name = 'Parent Asset ' + i;
            parentAssets.add(testAsset);
            system.debug('Index: ' + i + ' Parent Asset: ' + testAsset);
        }
        insert parentAssets;
        //Need Install & Config records, related to those "Root" Assets....
        list<Install_Config__c> insertList = new list<Install_Config__c>();
        for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
            Install_Config__c oneIC = new Install_Config__c();
            oneIC.RecordTypeId = vsat_RECORD_TYPE_ID;
            oneIC.Account_Name__c = testAcct.Id;
            oneIC.Asset__c = parentAssets[i].Id;
            insertList.add(oneIC);
            system.debug('Index: ' + i + ' Install & Config: ' + oneIC);
        }
        insert insertList;
        //Need "IP Addresss" Assets (just force Item__c which is normally populated via workflow in Production)
        list<Asset> insertAssets = new list<Asset>();
        system.debug('insertAssets.size() == ' + insertAssets.size());
        for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
            Asset testAsset = new Asset(AccountId = testAcct.Id);
            testAsset.Name = '10.61.0.' + i;
            testAsset.Item__c = 'IP Address';
            insertAssets.add(testAsset);
            system.debug('Index: ' + i + ' Modem Asset: ' + testAsset);
        }
        insert insertAssets;
        //Now we have to relate these Modems to the Parent/Root to get the Process Builder to fire
        //"Process Builder - Update Root Asset with IP"
        for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
            insertAssets[i].Parent_Asset__c = parentAssets[i].Id;
            system.debug('Index: ' + i + ' Modem Asset: ' + insertAssets[i]);
        }
        update insertAssets;
        //The Update then sets that critical field (also named Modem_IP_Address__c) in the Install & Config Record
        //The API resource allows a search against that field!
    }
    static testMethod void testSetupData(){
        //use this method to validate that you have test data setup correctly
        list<Install_Config__c> readList = new list<Install_Config__c>();
        readList = [SELECT Id, Modem_IP_Address__c FROM Install_Config__c];
        system.assertEquals(MAX_LOOP_COUNTER, readList.size());
        Asset keyAsset = [SELECT Id, Name, Modem_IP_Address__c FROM Asset WHERE Name = '10.61.0.0'];
        system.debug('keyAsset: ' + keyAsset);
        Install_Config__c keyIC = [SELECT Id, Modem_IP_Address__c FROM Install_Config__c WHERE Modem_IP_Address__c = '10.61.0.0'];
        system.debug('keyIC: ' + keyIC);
    }
    static testMethod void test_REST_installconfig() {
        // TO DO: implement unit test
        string instance = ''; //empty string to replace instance....
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
         
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/installconfig/';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //test to ensure an API call with no record ID returns an empty list
        List<Install_Config__c> ICs = new List<Install_Config__c>();
        ICs = REST_installconfig.doGet();
        System.assert(ICs.isEmpty());
        //TODO Check Header
        Map<string, string> resHeaders = res.headers;
        system.assertEquals('Record Id Required for GET', resHeaders.get('Error'));
        
        //reset
        ICs.clear();
        req = new RestRequest(); 
        res = new RestResponse();
        list<Install_Config__c> readList = [SELECT Id, Modem_IP_Address__c FROM Install_Config__c LIMIT 1];
        
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/installconfig/' + readList[0].id;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //test to ensure an API call with a proper record ID returns a list
        ICs = REST_installconfig.doGet();
        system.assertEquals(1, ICs.size());
        //TODO Check contents
        system.assertEquals(readList[0].id, ICs[0].id);
        
        //reset
        ICs.clear();
        req = new RestRequest(); 
        res = new RestResponse();
        
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/installconfig/a0H000000000000000';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //test to ensure an API call with a proper record ID returns a list
        ICs = REST_installconfig.doGet();
        system.assertEquals(0, ICs.size());
        
        //reset
        ICs.clear();
        req = new RestRequest(); 
        res = new RestResponse();

        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/installconfig/search';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        req.addParameter('ip', '10.61.0.0');
        RestContext.response = res;
        //test to ensure an API call with a proper search param ID returns a list
        ICs = REST_installconfig.doGet();
        system.assertEquals(1, ICs.size());
        //TODO Check contents
        system.assertEquals('10.61.0.0', ICs[0].Modem_IP_Address__c);
        
        //reset
        ICs.clear();
        req = new RestRequest(); 
        res = new RestResponse();

        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/installconfig/search';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        req.addParameter('ip', '127.0.0.0');
        //test to ensure an API call with a bogus search param ID returns an empty list
        ICs = REST_installconfig.doGet();
        system.assertEquals(0, ICs.size());
        
        
    }
    static testMethod void test_duplicateICs(){
        List<Install_Config__c> ICs = new List<Install_Config__c>();
        
        string instance = ''; //empty string to replace instance....
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //rig an asset as a dupe (good luck!)
        Asset a = [SELECT Id, Name FROM Asset WHERE Name = '10.61.0.1'];
        a.Name = '10.61.0.0';
        update a; 
        
        test.startTest();
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/installconfig/search';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        req.addParameter('ip', '10.61.0.0');
        RestContext.response = res;
        //test to ensure an API call with a proper search param ID with duplicates in the database returns a list
        ICs = REST_installconfig.doGet();
        system.assertEquals(2, ICs.size());
        //TODO Check contents
        system.assertEquals('10.61.0.0', ICs[0].Modem_IP_Address__c);
        system.assertEquals('10.61.0.0', ICs[1].Modem_IP_Address__c);
        test.stopTest();
    }
}