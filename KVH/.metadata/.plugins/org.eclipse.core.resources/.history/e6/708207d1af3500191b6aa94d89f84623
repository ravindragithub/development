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
private class ContractUtilities_test {

    static testMethod void testRecTypeDescribe(){
        RecordType IPMCcontractRecordType = [SELECT Id, DeveloperName FROM RecordType WHERE Name = 'IP-MobileCast' LIMIT 1];
        ContractUtilities Util = new ContractUtilities();
        system.debug('IPMC_CONTRACT_RECORD_TYPE_ID: ' + Util.IPMC_CONTRACT_RECORD_TYPE_ID); 
        system.assertEquals(IPMCcontractRecordType.Id, Util.IPMC_CONTRACT_RECORD_TYPE_ID);               //need to monitor this assertion as we deploy through Production....
        //system.debug('AIRTIME_CONTRACT_RECORD_TYPE_ID: ' + Util.AIRTIME_CONTRACT_RECORD_TYPE_ID);
        //system.assertEquals('012a0000001VzyhAAC', Util.AIRTIME_CONTRACT_RECORD_TYPE_ID);
        
    }
    
    static testMethod void testAssetUtilities() {
        //need a test Account
        Account WriteAcct = makeMockAcct();  
        //Need Services to reference in the ContractedService...
        createTestPackage();
        //Need an Asset(&Account &Product...)...
        createMockAssets(WriteAcct);
        //Now create Contract..
        Contract Kontrakt = new Contract();
        Kontrakt.Name = 'testKontrakt';
        Kontrakt.AccountId = WriteAcct.Id;
        //Kontrakt.RecordTypeId = RT.Id;
        Kontrakt.StartDate = date.today();
        Kontrakt.ContractTerm = 12;
        insert Kontrakt;
        Kontrakt = [SELECT Id, Name FROM Contract WHERE Name = 'testKontrakt'];
        //Now add some services to the Kontrakt
        List<Contracted_Services__c> ConSvcs = new List<Contracted_Services__c>();
        //Set<Product2> SVCs = new Set<Product2>();
        Product2[] SVCs = [SELECT Id, Name FROM Product2 WHERE Name = 'IP-MobileCast Bronze'];
        Asset[] toActivate = [SELECT id, Name FROM Asset];
        system.assertEquals(2, toActivate.size());
        system.debug(SVCs);
        for (Product2 p : SVCs) {
            Contracted_Services__c conserv = new Contracted_Services__c(Name = p.Name, Contract__c = Kontrakt.Id, 
                                                                        Asset__c = toActivate[0].Id, Service_Item__c = p.id);
            ConSvcs.add(conserv);
        }
        system.debug(ConSvcs);
        insert ConSvcs;
        //OK data should be all set!
        
        ContractUtilities Util = new ContractUtilities();
        //Reset
        ConSvcs.clear();
        //test Single Asset Method
        ConSvcs = Util.ServicesByAssets(toActivate[0]);
        system.assertEquals(1, ConSvcs.size());
        system.assertEquals('IP-MobileCast Bronze', ConSvcs[0].Name);
        
        //Reset
        ConSvcs.clear();
        //test Asset List Method
        ConSvcs = Util.ServicesByAssets(toActivate);
        system.assertEquals(1, ConSvcs.size()); //Should still be only one...
        system.assertEquals('IP-MobileCast Bronze', ConSvcs[0].Name);
    }
    static void createMockAssets(Account WriteAcct){    //test data...
        //?? TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();
        
        //Quick test for Media Server "MS LICENSE"
        Product2 prod = new Product2(Name='MS LICENSE');    //need a product...
        insert prod;
        prod = [SELECT id, Name FROM Product2 WHERE Name = 'MS LICENSE' LIMIT 1];
        system.assertEquals('MS LICENSE', prod.Name);
        //need a test Asset to Activate
        Asset toActivate = new Asset(Name='1401U9999', SerialNumber='1401U9999'); //mock asset
        toActivate.AccountId = WriteAcct.id;
        toActivate.Product2Id = prod.Id;
        insert toActivate;          //kind of real now...
        toActivate = [SELECT id, Name FROM Asset WHERE Name='1401U9999' LIMIT 1];
        system.debug(toActivate);
        //need a test Asset to DE-Activate
        Asset toDEActivate = new Asset(Name='1402U9999', SerialNumber='1402U9999', IPMC_KenCast_SiteID__c = '170612'); //mock asset
        toDEActivate.AccountId = WriteAcct.id;
        toDEActivate.Product2Id = prod.Id;
        insert toDEActivate;            //kind of real now...
    }
    
    static void createTestPackage() {
        KVH_Product_Family__c fam = new KVH_Product_Family__c();
        fam.Name = 'IPMC Package';
        insert fam;
        fam = [SELECT Id, Name FROM KVH_Product_Family__c];
        Product2 prod2 = new Product2(Name='IP-MobileCast Bronze', KVH_Product_Family__c=fam.Id);       //need a product...
        insert prod2;
        prod2 = [SELECT id, Name from Product2 WHERE Name = 'IP-MobileCast Bronze' LIMIT 1];    
        system.assertEquals('IP-MobileCast Bronze', prod2.Name);        //got a Product!
        
        List<String> pkgKindNames = new List<String> {'kvh.vod.tv.series.bronze',       //Need some Package Kinds...
                                        'kvh.vod.movie.bronze',
                                        'kvh.print.news.special_interest',
                                        'kvh.print.news.international',
                                        'kvh.vod.music.muzo',
                                        'kvh.vod.movie.trailer.bronze'};
        List<IPMC_Package_Kinds__c> testPkgKinds = new List<IPMC_Package_Kinds__c>();
        for (string s : PkgKindNames) {
            IPMC_Package_Kinds__c pk = new IPMC_Package_Kinds__c();
            pk.PackageKind__c = s;
            testPkgKinds.add(pk);
        }
        insert testPkgKinds;
        testPkgKinds = [SELECT id, Name, PackageKind__c FROM IPMC_Package_Kinds__c];    //got some Package Kinds!
        
        List<Package_Kinds_by_Product__c> Bundle = new List<Package_Kinds_by_Product__c>(); //Need a Bundle...
        for (IPMC_Package_Kinds__c pk : testPkgKinds) {
            Package_Kinds_by_Product__c Prod_vs_pkgKind = new Package_Kinds_by_Product__c();
            Prod_vs_pkgKind.Product__c = prod2.id;
            Prod_vs_pkgKind.IPMC_Package_Kind__c = pk.Id;
            Bundle.add(Prod_vs_pkgKind);
        }
        insert Bundle;
        Bundle = [SELECT Id, Product__c, IPMC_Package_Kind__c, Package_Kind__c FROM Package_Kinds_by_Product__c];   //got a Bundle!
    }
    static Account makeMockAcct() {
        Account WriteAcct = new Account();
        WriteAcct.Name = 'Positive Flag';
        WriteAcct.Account_Type__c = 'Corporate';
        WriteAcct.Custom_Call_Acct_ID__c = '998';
        WriteAcct.Account_Effective_Date__c = Date.today();
        WriteAcct.Revenue_Category__c = 'VSAT';
        WriteAcct.BillingCountry = 'Italy';
        WriteAcct.Send_to_myKVH_Physical__c = false;    //should change to true
        WriteAcct.Account_Status__c = 'Active';
        Database.Saveresult Parent1 = Database.insert(WriteAcct);
        WriteAcct = [SELECT Id, Name FROM Account WHERE Name = 'Positive Flag' LIMIT 1];
        system.debug(WriteAcct);
        return WriteAcct;
    } /* End of Utility Methods */
}