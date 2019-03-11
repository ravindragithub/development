@isTest
public class ProductEntryController_test {
    @testsetup
    static void testSetupData(){
        Integer integ;
        Account acc = new Account(Name = '1234', BillingCountry = 'Italy', Portal_View_s__c = 'Leisure Marine Systems');
        insert acc;
        Product2 prod = new Product2(Name = 'testprod', Catalog_Display_Name__c = 'testprod');
        insert prod;
        Product_Market_Sector__c pms1 = new Product_Market_Sector__c(Market__c = 'Commercial & OEM', Sector__c = 'Land Systems', Portal_View__c = 'Commercial & OEM Land Systems', Product_Line__c = 'Satellite Television', Product__c = prod.Id );
        insert pms1;
        Product_Market_Sector__c pms2 = new Product_Market_Sector__c(Market__c = 'Leisure', Sector__c = 'Marine Systems', Portal_View__c = 'Leisure Marine Systems', Product_Series__c = 'mini-VSAT Broadband', Product_Line__c = 'Satellite Communications', Product__c = prod.Id );
        insert pms2;
        Product_Market_Sector__c pms3 = new Product_Market_Sector__c(Market__c = 'Leisure', Sector__c = 'Marine Systems', Portal_View__c = 'Leisure Marine Systems', Product_Line__c = 'Satellite Television', Product_Series__c = 'TV-Series', Product__c = prod.Id );
        insert pms3;
        Product_Catalogue__c prodcat1 = new Product_Catalogue__c(Product_Market_Sector__c = pms1.Id, Partner_Account__c = acc.Id);
        Product_Catalogue__c prodcat2 = new Product_Catalogue__c(Product_Market_Sector__c = pms2.Id, Partner_Account__c = acc.Id);
        Product_Catalogue__c prodCat3 = new Product_Catalogue__c(Product_Market_Sector__c = pms3.Id, Partner_Account__c = acc.Id);
        insert prodcat1;
        insert prodCat2;
        insert prodCat3;
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(acc.id);
        req1.setSubmitterId(u.Id);
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('Partner_Onboarding_Sales');
        req1.setSkipEntryCriteria(true);
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
    }
    static testMethod void testaddRow(){
        Account acc = [SELECT Id FROM Account WHERE Name = '1234'];
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ProductEntryController pec = new ProductEntryController(sc);
        Integer integ = 1;
        pec.addCount = integ;
        pec.addRow();
        system.assertEquals(2, pec.wrappers.size());
        pec.addCount1 = integ;
        pec.addRow1();
        system.assertEquals(2, pec.cwraps.size());
    }
    static testMethod void testprodList(){
        Account acc = [SELECT Id, Portal_View_s__c FROM Account WHERE Name = '1234'];
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ProductEntryController pec = new ProductEntryController(sc);
        List <SelectOption> so = pec.getprodList();
        system.assertEquals(so.size(), 1);
        acc.Portal_View_s__c = null;
        update acc;
		sc = new ApexPages.StandardController(acc);
        pec = new ProductEntryController(sc);
        pec.acct = acc;
        so = pec.getprodList();
        system.assertEquals(so, null);  
    }
    static testMethod void testsaveRecords(){
        Account acc = [SELECT Id FROM Account WHERE Name = '1234'];
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ProductEntryController pec = new ProductEntryController(sc);
        Test.setCurrentPageReference(new PageReference('Page.AddProducts')); 
        System.currentPageReference().getParameters().put('id', acc.Id);
        Product_Catalogue__c pc1 = new Product_Catalogue__c(For_Admin_Use__c = 'testprod');
        Product_Catalogue__c pc2 = new Product_Catalogue__c(For_Admin_Use__c = 'badtestprod');
        Country__c ctry = new Country__c(Country__c = 'Italy'); 
        Integer i = 1;
        List <Integer> integs = new List <Integer>();
        integs.add(i);
        ProductEntryController.ProdWrapper pwrap = new ProductEntryController.ProdWrapper(i);
        List <ProductEntryController.ProdWrapper> pwraps = new List<ProductEntryController.ProdWrapper>();
        pwrap.prodCat = pc1;
        pwraps.add(pwrap);
        pec.wrappers = pwraps;
        ProductEntryController.CountWrapper cowrap = new ProductEntryController.CountWrapper(i);
        List <ProductEntryController.CountWrapper> cowraps = new List<ProductEntryController.CountWrapper>();
        cowrap.prodCount = ctry;
        cowraps.add(cowrap);
        pec.cwraps = cowraps;
        PageReference pageRef = pec.saveRecords();
        string s = pageRef.getUrl();
        system.assertEquals(s.left(10), '/p/process');
        cowrap = new ProductEntryController.CountWrapper(i);
        Country__c ctry2 = new Country__c(Country__c = 'United States');
        cowrap.prodCount = ctry2;
        
        cowraps.add(cowrap);
        pec.cwraps = cowraps;
        pec.noaction();
        system.assertEquals(true, pec.cwraps[1].rerender);
        pwrap.prodCat = pc2;
        pwraps.add(pwrap);
        pec.wrappers = pwraps;
        pageRef = pec.saveRecords();
        system.assertEquals(null, pageRef);
        pageRef = pec.nextPage();
        s = pageRef.getUrl();
        system.assertEquals(s.right(18), acc.id);
        pec.toDelIdent = i;
        pec.toDelIdent1 = i;
        pec.delWrapper();
        pec.delWrapper1();
        system.assertEquals(1, pec.wrappers.size());
		system.assertEquals(1, pec.cwraps.size());      
    }
    static testmethod void testsavechanges(){
        Account acc = [SELECT Id FROM Account WHERE Name = '1234'];
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ProductEntryController pec = new ProductEntryController(sc);
        Test.setCurrentPageReference(new PageReference('/apex/AddProducts/')); 
        System.currentPageReference().getParameters().put('id', acc.Id);
        PageReference pageref = pec.returning();
        string s = pageref.getUrl();
        system.assertEquals('&scontrolCaching=1', s.right(18));
        acc.Portal_View_s__c = null;
        pec.acct = acc;
        pec.saveChanges();
        system.assertEquals(true, ApexPages.hasMessages());   
    }
}