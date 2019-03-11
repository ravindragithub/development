/*
Description    :    Test class for LTEAct_Controller 
*/
@isTest
public class LTEAct_ControllerTest {
    static testMethod void test_getContactInfo() {
        List<Account> accList = TestDataFactory.createAccountRecords(1, null,'Prospect',false,false,'','',null,'');
        insert accList;  
        Contact con = TestDataFactory.createContactRecords('testFCon','testLCon', 'test@email.com');
        con.AccountId = accList[0].Id;
        insert con;  
        Id p = [select id from profile where name='LTE Activation User'].id;
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                             ContactId = con.Id,
                             timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert user;
        List<LTE_Activation__c> lstLTEAct = new List<LTE_Activation__c>();
        system.runAs(user) {
            LTE_Activation__c lteAct = new LTE_Activation__c();
            Map<String, Object> testgetContInfo = LTEAct_Controller.getContactInfo();
            system.assertEquals('testFCon', testgetContInfo.get('firstName'));
            LTEAct_Controller.SaveLTERegistration(lteAct);
            List<LTE_Activation__c> testLstLTEAct = new List<LTE_Activation__c>([Select Id,Name From LTE_Activation__c]);
            system.assertEquals(1, testLstLTEAct.size());
        }
        
    }
    
    static testMethod void test_getCountry() {
        List<KVH_Countries__mdt> countryValues = LTEAct_Controller.getCountry();
        for(KVH_Countries__mdt i: countryValues){
            System.assertEquals(i.TrimmedName__c.length() > 0, True);
            System.assertEquals(i.IsoCode_2__c.length() > 0, True);
            System.assertEquals(i.IsoCode_3__c.length() > 0, True);
        }
    }
    
    static testMethod void test_getState() {
        List<string> stateValues = LTEAct_Controller.getStateMap('IN');
        for(string i: stateValues){
            System.assertEquals(i.length() > 0, True);
        }
        
    }
    
    static testMethod void test_getVesselTypeMap() {
        Platform_Market_Sector__c test = new Platform_Market_Sector__c();
        test.Name = 'Test';
        test.Market__c = 'Leisure';
        test.Sector__c = 'Marine Systems';
        Platform_Market_Sector__c test2 = new Platform_Market_Sector__c();
        test2.Name = 'Test2';
        test2.Market__c = 'Military & Government';
        test2.Sector__c = 'Maritime Systems';
        Platform_Market_Sector__c test3 = new Platform_Market_Sector__c();
        test3.Name = 'Test3';
        test3.Market__c = 'Military & Government';
        test3.Sector__c = 'Maritime Systems';
        insert test;
        insert test2;
        insert test3;
        
        Map<string,Map<string,List<String>>> vesselMapValues = LTEAct_Controller.getVesselTypeMap();
        System.assertEquals(vesselMapValues.keySet().size() == 2, True);
        for(string i: vesselMapValues.keySet()){
            Map<string,List<String>> sectorValues = vesselMapValues.get(i);
            for(string j: sectorValues.keySet()){
                for(string k: sectorValues.get(j)){
                    System.assertEquals(k.length() > 0, True);
                }
            }
        }
        
    }
    
}