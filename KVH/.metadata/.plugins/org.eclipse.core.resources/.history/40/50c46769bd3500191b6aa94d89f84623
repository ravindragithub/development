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
 /* 1/17/2013 handled removal of "{" and "}" from rolled up text fields jthom */
 /* 5/18/2017 updated API version, removed seeAllData=true, added PriceBook improvements */
@isTest
private class OpportunityLineItemTriggerTests {

    static testMethod void OLIUnitTest() {
    // TO DO: implement unit test
    /* We need:
        An Account (to attach Opportunities to)
        A Pricebook (standard Pricebook OK)
        Lots of Products with KVH Product Family data
        Lots of Pricebook Entries (standard Pricebook OK)
        Opportunities to:
        Add products to,
            Update products in,
            Delete products from.
        */
    Account testAccount = new Account();
    testAccount.name='Test Company Name';
    /*testAccount.KVH_Sales_Office__c = 'KU – Satcom';
    testAccount.BillingCity = 'San Fransisco';  
    testAccount.billingState='CA';
    testAccount.BillingCountry = 'USA';*/
    insert testAccount;
    
    List<KVH_Product_Family__c> ProdFams = new List<KVH_Product_Family__c>();
    KVH_Product_family__c tstV1 = new KVH_Product_family__c();
    tstV1.Name = 'tstV1';
    tstV1.Opportunity_Family__c = 'VSAT';
    ProdFams.add(tstV1);
    
    KVH_Product_family__c tstV2 = new KVH_Product_family__c();
    tstV2.Name = 'tstV2';
    tstV2.Opportunity_Family__c = 'VSAT';
    ProdFams.add(tstV2);
    
    KVH_Product_family__c tstV3 = new KVH_Product_family__c();
    tstV3.Name = 'tstV3';
    tstV3.Opportunity_Family__c = 'VSAT';
    ProdFams.add(tstV3);
    //Airtime
    KVH_Product_family__c Air1 = new KVH_Product_family__c();
    Air1.Name = 'Air1';
    Air1.Opportunity_Family__c = 'Airtime';
    ProdFams.add(Air1);
    
    KVH_Product_family__c Air2 = new KVH_Product_family__c();
    Air2.Name = 'Air2';
    Air2.Opportunity_Family__c = 'Airtime';
    ProdFams.add(Air2);
    
    KVH_Product_family__c Air3 = new KVH_Product_family__c();
    Air3.Name = 'Air3';
    Air3.Opportunity_Family__c = 'Airtime';
    ProdFams.add(Air3);
    //CommBox
    KVH_Product_family__c CBX1 = new KVH_Product_family__c();
    CBX1.Name = 'CBX1';
    CBX1.Opportunity_Family__c = 'CommBox';
    ProdFams.add(CBX1);
    
    KVH_Product_family__c CBX2 = new KVH_Product_family__c();
    CBX2.Name = 'CBX2';
    CBX2.Opportunity_Family__c = 'CommBox';
    ProdFams.add(CBX2);
    
    KVH_Product_family__c CBX3 = new KVH_Product_family__c();
    CBX3.Name = 'CBX3';
    CBX3.Opportunity_Family__c = 'CommBox';
    ProdFams.add(CBX3);
    
    insert ProdFams;     

    List<Product2> ProdsToInsert = new List<Product2>();     
    for (Integer i = 0; i < 60; i++){   //Add some VSAT Products.. 60 to be exact!
        Product2 tstVSAT = new Product2();
        tstVSAT.Name = 'tstVSAT' + i;
        If (i<20){
            tstVSAT.KVH_Product_Family__c = tstV1.Id;
            tstVSAT.Standard_Pricebook_Price__c = 101;
        }else if (i>=20 && i<=39)   {   //between 20 and 39
            tstVSAT.KVH_Product_Family__c = tstV2.Id;
            tstVSAT.Standard_Pricebook_Price__c = 102;
        }else if (i>=40 && i<=59)   {   //between 40 and 59
            tstVSAT.KVH_Product_Family__c = tstV3.Id;
            tstVSAT.Standard_Pricebook_Price__c = 103;
        }else {                         // we should never get here....
            tstVSAT.KVH_Product_Family__c = tstV3.Id;
            tstVSAT.Standard_Pricebook_Price__c = 103;
        }
        ProdsToInsert.Add(tstVSAT);
        }
    
    for (Integer i = 0; i < 60; i++){   //Add some Airtime Products.. 60 to be exact!
        Product2 tstAIR = new Product2();
        tstAIR.Name = 'tstAIR' + i;
        If (i<20){
            tstAIR.KVH_Product_Family__c = AIR1.Id;
            tstAIR.Standard_Pricebook_Price__c = 111;
        }else if (i>=20 && i<=39)   {   //between 20 and 39
            tstAIR.KVH_Product_Family__c = AIR2.Id;
            tstAIR.Standard_Pricebook_Price__c = 112;
        }else if (i>=40 && i<=59)   {   //between 40 and 59
            tstAIR.KVH_Product_Family__c = AIR3.Id;
            tstAIR.Standard_Pricebook_Price__c = 113;
        }else {                         // we should never get here....
            tstAIR.KVH_Product_Family__c = AIR3.Id;
            tstAIR.Standard_Pricebook_Price__c = 113;
        }
        ProdsToInsert.Add(tstAIR);
        }
        
    for (Integer i = 0; i < 60; i++){   //Add some CommBox Products.. 60 to be exact!
        Product2 tstCBX = new Product2();
        tstCBX.Name = 'tstCBX' + i;
        If (i<20){
            tstCBX.KVH_Product_Family__c = CBX1.Id;
            tstCBX.Standard_Pricebook_Price__c = 121;
        }else if (i>=20 && i<=39)   {   //between 20 and 39
            tstCBX.KVH_Product_Family__c = CBX2.Id;
            tstCBX.Standard_Pricebook_Price__c = 122;
        }else if (i>=40 && i<=59)   {   //between 40 and 59
            tstCBX.KVH_Product_Family__c = CBX3.Id;
            tstCBX.Standard_Pricebook_Price__c = 123;
        }else {                         // we should never get here....
            tstCBX.KVH_Product_Family__c = CBX3.Id;
            tstCBX.Standard_Pricebook_Price__c = 123;
        }
        ProdsToInsert.Add(tstCBX);
        }

    for (Integer i = 0; i < 60; i++){   //Add some CommBox Products.. 60 to be exact!
        Product2 tstOTHER = new Product2();
        tstOTHER.Name = 'tstOTHER' + i;
        If (i<20){
            
            tstOTHER.Standard_Pricebook_Price__c = 121;
        }else if (i>=20 && i<=39)   {   //between 20 and 39
            
            tstOTHER.Standard_Pricebook_Price__c = 122;
        }else if (i>=40 && i<=59)   {   //between 40 and 59
            
            tstOTHER.Standard_Pricebook_Price__c = 123;
        }else {                         // we should never get here....
            
            tstOTHER.Standard_Pricebook_Price__c = 123;
        }
        ProdsToInsert.Add(tstOTHER);
        }

   
    Id pricebookId = Test.getStandardPricebookId();
    insert ProdsToInsert;
    //Make some lists with the different Opportunity families... VSAT, Airtime, CommBox, and *OTHER*
    List<PricebookEntry> VSAT_PBEs = new List<PricebookEntry>();
    for (PricebookEntry PBE : [SELECT UseStandardPrice, UnitPrice, ProductCode, Product2Id, Name, Id, isActive FROM PricebookEntry
                                WHERE product2.KVH_Product_Family__r.name IN ('tstV1', 'tstV2', 'tstV3')])    {
        PBE.IsActive=true;
        VSAT_PBEs.add(PBE);
        }
    update VSAT_PBEs;
    
    List<PricebookEntry> Airtime_PBEs = new List<PricebookEntry>();
    for (PricebookEntry PBE : [SELECT UseStandardPrice, UnitPrice, ProductCode, Product2Id, Name, Id, isActive FROM PricebookEntry
                                WHERE product2.KVH_Product_Family__r.name IN ('AIR1', 'AIR2', 'AIR3')])   {
        PBE.IsActive=true;
        Airtime_PBEs.add(PBE);
        }
    update Airtime_PBEs;
    
    List<PricebookEntry> CBX_PBEs = new List<PricebookEntry>();
    for (PricebookEntry PBE : [SELECT UseStandardPrice, UnitPrice, ProductCode, Product2Id, Name, Id, isActive FROM PricebookEntry
                                WHERE product2.KVH_Product_Family__r.name IN ('CBX1', 'CBX2', 'CBX3')])   {
        PBE.IsActive=true;
        CBX_PBEs.add(PBE);
        }
    update CBX_PBEs;

    List<PricebookEntry> OTHER_PBEs = new List<PricebookEntry>();
    for (PricebookEntry PBE : [SELECT UseStandardPrice, UnitPrice, ProductCode, Product2Id, Name, Id, isActive FROM PricebookEntry
                                WHERE product2.KVH_Product_Family__c = '' LIMIT 20]) {
        PBE.IsActive=true;
        OTHER_PBEs.add(PBE);
        }
    update OTHER_PBEs;
    
    //system.debug(PBEs);
    /*Setup Complete! Need to start adding Opportunities, OLIs, and system.assert checks*/
    
    //Pricebook2  standardPb = ([select id, name, isActive from Pricebook2 where IsStandard = true limit 1]);
    
    Opportunity TestOpp1 = new Opportunity();
    TestOpp1.Name = 'tstOpp1';
    TestOpp1.AccountId = testAccount.Id;
    TestOpp1.Type = 'Sale';
    TestOpp1.CloseDate = system.today();
    TestOpp1.StageName = 'Quote';
    TestOpp1.LeadSource = 'Other';
    TestOpp1.Pricebook2Id = pricebookId;
    insert TestOpp1;
    system.debug(TestOpp1);
    
    /* This section verifies that products not in the 3 families do not roll up....*/
    OpportunityLineItem OLI1 = new OpportunityLineItem();
    OLI1.OpportunityId = TestOpp1.Id;
    OLI1.PricebookEntryId = OTHER_PBEs[0].id;   //"OTHER" PBEs should not end up in a Summary field
    OLI1.Quantity=1;
    OLI1.TotalPrice=OTHER_PBEs[0].UnitPrice;
    insert OLI1;
    TestOpp1 = ([SELECT id, name, Summary_VSAT_Products__c, Summary_Airtime_Plans__c, Summary_CommBox_Plans__c
                FROM Opportunity WHERE name LIKE 'tstOpp1%' LIMIT 1]);
    //None of the text rollup fields should have a value
    String Rollups = TestOpp1.Summary_VSAT_Products__c + TestOpp1.Summary_Airtime_Plans__c + TestOpp1.Summary_CommBox_Plans__c;
    system.debug(Rollups);
    system.assertEquals(null, TestOpp1.Summary_VSAT_Products__c);
    system.assertEquals(null, TestOpp1.Summary_Airtime_Plans__c);
    system.assertEquals(null, TestOpp1.Summary_CommBox_Plans__c);

    
    /* This section verifies that products in the VSAT family roll up properly....*/
    OpportunityLineItem OLI2 = new OpportunityLineItem();
    OLI2.OpportunityId = TestOpp1.Id;
    OLI2.PricebookEntryId = VSAT_PBEs[0].id;    //"VSAT" PBEs should end up in a Summary field
    OLI2.Quantity=1;
    OLI2.TotalPrice=VSAT_PBEs[0].UnitPrice;
    insert OLI2;
    TestOpp1 = ([SELECT id, name, Summary_VSAT_Products__c, Summary_Airtime_Plans__c, Summary_CommBox_Plans__c
                FROM Opportunity WHERE name LIKE 'tstOpp1%' LIMIT 1]);
    //only the VSAT rollup fields should have a value
    Rollups = TestOpp1.Summary_VSAT_Products__c + TestOpp1.Summary_Airtime_Plans__c + TestOpp1.Summary_CommBox_Plans__c;
    system.debug(Rollups);
    Boolean VSATresult = TestOpp1.Summary_VSAT_Products__c.contains('tstV');
    System.assertEquals(VSATresult, true);
    //system.assertEquals('{}', TestOpp1.Summary_VSAT_Products__c);
    system.assertEquals(null, TestOpp1.Summary_Airtime_Plans__c);
    system.assertEquals(null, TestOpp1.Summary_CommBox_Plans__c);
    
    /* This section verifies that products in the Airtime family roll up properly....*/
    OpportunityLineItem OLI3 = new OpportunityLineItem();
    OLI3.OpportunityId = TestOpp1.Id;
    OLI3.PricebookEntryId = Airtime_PBEs[0].id; //"CommBox" PBEs should end up in a Summary field
    OLI3.Quantity=1;
    OLI3.TotalPrice=Airtime_PBEs[0].UnitPrice;
    insert OLI3;
    TestOpp1 = ([SELECT id, name, Summary_VSAT_Products__c, Summary_Airtime_Plans__c, Summary_CommBox_Plans__c
                FROM Opportunity WHERE name LIKE 'tstOpp1%' LIMIT 1]);
    //only the VSAT rollup fields should have a value
    Rollups = TestOpp1.Summary_VSAT_Products__c + TestOpp1.Summary_Airtime_Plans__c + TestOpp1.Summary_CommBox_Plans__c;
    system.debug(Rollups);
    VSATresult = TestOpp1.Summary_VSAT_Products__c.contains('tstV');
    System.assertEquals(VSATresult, true);
    //system.assertEquals('{}', TestOpp1.Summary_VSAT_Products__c);
    Boolean AIRresult = TestOpp1.Summary_Airtime_Plans__c.contains('AIR'); //(PricebookEntry.NAME...)
    System.assertEquals(AIRresult, true);   
    //system.assertEquals('{}', TestOpp1.Summary_Airtime_Plans__c);
    system.assertEquals(null, TestOpp1.Summary_CommBox_Plans__c);
    
    /* This section verifies that products in the Airtime family roll up properly....*/
    OpportunityLineItem OLI4 = new OpportunityLineItem();
    OLI4.OpportunityId = TestOpp1.Id;
    OLI4.PricebookEntryId = CBX_PBEs[0].id; //"CommBox" PBEs should end up in a Summary field
    OLI4.Quantity=1;
    OLI4.TotalPrice=CBX_PBEs[0].UnitPrice;
    insert OLI4;
    TestOpp1 = ([SELECT id, name, Summary_VSAT_Products__c, Summary_Airtime_Plans__c, Summary_CommBox_Plans__c
                FROM Opportunity WHERE name LIKE 'tstOpp1%' LIMIT 1]);
    //only the VSAT rollup fields should have a value
    Rollups = TestOpp1.Summary_VSAT_Products__c + TestOpp1.Summary_Airtime_Plans__c + TestOpp1.Summary_CommBox_Plans__c;
    system.debug(Rollups);
    VSATresult = TestOpp1.Summary_VSAT_Products__c.contains('tstV');
    System.assertEquals(VSATresult, true);
    //system.assertEquals('{}', TestOpp1.Summary_VSAT_Products__c);
    AIRresult = TestOpp1.Summary_Airtime_Plans__c.contains('AIR'); //(PricebookEntry.NAME...)
    System.assertEquals(AIRresult, true);   
    //system.assertEquals('{}', TestOpp1.Summary_Airtime_Plans__c);
    Boolean CBXresult = TestOpp1.Summary_CommBox_Plans__c.contains('CBX'); //(PricebookEntry.NAME...)
    System.assertEquals(CBXresult, true);   
    //system.assertEquals('{}', TestOpp1.Summary_CommBox_Plans__c);
    
    /*This section tests the after update trigger*/
    OLI1.Quantity=2;
    update OLI1;
    OLI2.Quantity=2;
    update OLI2;
    OLI3.Quantity=2;
    update OLI3;
    OLI4.Quantity=2;
    update OLI4;
    TestOpp1 = ([SELECT id, name, Summary_VSAT_Products__c, Summary_Airtime_Plans__c, Summary_CommBox_Plans__c
                FROM Opportunity WHERE name LIKE 'tstOpp1%' LIMIT 1]);
    //only the VSAT rollup fields should have a value
    Rollups = TestOpp1.Summary_VSAT_Products__c + TestOpp1.Summary_Airtime_Plans__c + TestOpp1.Summary_CommBox_Plans__c;
    system.debug(Rollups);
    VSATresult = TestOpp1.Summary_VSAT_Products__c.contains('tstV');
    System.assertEquals(VSATresult, true);
    //system.assertEquals('{}', TestOpp1.Summary_VSAT_Products__c);
    AIRresult = TestOpp1.Summary_Airtime_Plans__c.contains('AIR'); //(PricebookEntry.NAME...)
    System.assertEquals(AIRresult, true);   
    //system.assertEquals('{}', TestOpp1.Summary_Airtime_Plans__c);
    CBXresult = TestOpp1.Summary_CommBox_Plans__c.contains('CBX'); //(PricebookEntry.NAME...)
    System.assertEquals(CBXresult, true);
    
    /*This section tests the after delete trigger*/
    delete OLI2;
    delete OLI3;
    delete OLI4;
    TestOpp1 = ([SELECT id, name, Summary_VSAT_Products__c, Summary_Airtime_Plans__c, Summary_CommBox_Plans__c
                FROM Opportunity WHERE name LIKE 'tstOpp1%' LIMIT 1]);
    //None of the rollup fields should have a value
    Rollups = TestOpp1.Summary_VSAT_Products__c + TestOpp1.Summary_Airtime_Plans__c + TestOpp1.Summary_CommBox_Plans__c;
    system.debug(Rollups);

    System.assert(String.isBlank(TestOpp1.Summary_VSAT_Products__c)); //WORKS!!!!
    System.assert(String.isBlank(TestOpp1.Summary_Airtime_Plans__c));   
    System.assert(String.isBlank(TestOpp1.Summary_CommBox_Plans__c));
    }
}