@isTest
private class ProductTrigger_TestClass {
    static void createDocData() {
        //Product Doc
        Map<Id,Prod_Documents__c> lstProdDoc = new Map<Id,Prod_Documents__c>([Select Id, Name,Title_Display_Name__c,Sub_Title__c,File_Access__c,File_Extension__c,Size_Description__c,
                                                                              Revision__c,Language__c,Image_URL__c,Alternate_Text__c, Hosting_URL__c,Marketo_URL__c,Gated_Document__c,Site_Core_URL__c,Insertion_Code__c,
                                                                              Active__c,Display_HTML_Page__c,Html_Field__c,Display_Terms_and_Conditions_Page__c,Terms_and_Conditions_1__c,Sales_Aid__c,
                                                                              Associated_Content_Types__c,File_Description__c,KVH_com__c,LastModifiedDate From Prod_Documents__c]);
        
        Set<String> setProductMSId = new Set<String>();
        //Check the Active/Display Product of any related product of product market sector of Product Doc Library
        for (Prod_Doc_Library__c temp : [Select Id, Name, Filename__c, Product_Market_Sector__c, Product_Market_Sector__r.Product__r.isActive,
                                         Product_Market_Sector__r.Product__r.Display_Product__c From Prod_Doc_Library__c
                                         Where Filename__c = : lstProdDoc.keySet() Limit 49999]) {
                                             setProductMSId.add(temp.Product_Market_Sector__c);
                                         }
        Map <Id, List<sObject>> prodDocIdProdDocMap = new Map<Id, List<sObject>>(); //Product Document vs Market sector Ids
        Map <Id, Product_Market_Sector__c> prodMarketSectMap = new Map <Id, Product_Market_Sector__c>([Select Id, Name, Market__c, Sector__c, Product_Line__c, Active__c,  Product_Series__c,
                                                                                                       Catalog_Display_Name__c, Product_Name__c,Product_ID__c,Display_Product__c, Product__c from Product_Market_Sector__c
                                                                                                       Where Id = : setProductMSId AND Active__c = : 'YES' AND Display_Product__c = true]);
        if (prodMarketSectMap != null) {
            for (Prod_Doc_Library__c temp : [Select Id, Name, Filename__c, Product_Market_Sector__c, Product_Market_Sector__r.Product__r.isActive,
                                             Product_Market_Sector__r.Product__r.Display_Product__c From Prod_Doc_Library__c
                                             Where Filename__c = : lstProdDoc.keySet() Limit 49999]) {
                                                 if (prodDocIdProdDocMap.containsKey(temp.Filename__c)) {
                                                     List<sObject> prodMSList = prodDocIdProdDocMap.get(temp.Filename__c);
                                                     if(prodMarketSectMap.get(temp.Product_Market_Sector__c) != null && prodMarketSectMap.get(temp.Product_Market_Sector__c).Product_ID__c != null)
                                                         prodMSList.add(prodMarketSectMap.get(temp.Product_Market_Sector__c));
                                                     prodDocIdProdDocMap.put(temp.Filename__c, prodMSList);
                                                 } else {
                                                     List<sObject> prodMSProdId = new List<sObject> ();
                                                     if(prodMarketSectMap.get(temp.Product_Market_Sector__c) != null && prodMarketSectMap.get(temp.Product_Market_Sector__c).Product_ID__c != null)
                                                         prodMSProdId.add(prodMarketSectMap.get(temp.Product_Market_Sector__c)); 
                                                     prodDocIdProdDocMap.put(temp.Filename__c,prodMSProdId);
                                                 }
                                             }
        }
        //End
        //Insert Content Version
        Map<string, string> contentData = new Map<string, string>();
        string productDocJSON = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(lstProdDoc.values() , 'Public-Documents', 'sfdc',prodDocIdProdDocMap,null);
        contentData.put('Documents.json', productDocJSON);
        List<ContentVersion> cvLst = new List<ContentVersion>();
        for (string temp : contentData.keySet()) {
            if (contentData.containsKey(temp)) {
                ContentVersion cv = new ContentVersion();
                cv.versionData = blob.valueOf(contentData.get(temp));
                cv.Title = temp;
                cv.pathOnClient = temp;
                cvLst.add(cv);
            }
        }
        insert cvLst;
    }
    static void createData() {
        List<Product2> lstProd = new List<Product2>([SELECT Id, Name, Catalog_Display_Name__c,Catalog_Long_Description__c,
                                                     ProductCode,Display_Product__c,IsActive,Product_Line1__c,Product_Series__c,Retired__c,Retired_Date__c,LastModifiedDate,
                                                     (Select Id,Name,Market__c,Product__c,Sector__c,Product_ID__c,Product_Line__c,Product_Series__c,Product_Name__c,Catalog_Display_Name__c From Product_Markets_Sectors__r) FROM Product2]);
        system.debug(lstProd +'========lstProd ======'+lstProd.size());
        //Insert Content Version
        Map<string, string> contentData = new Map<string, string>();
        string productJSON = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(lstProd, 'Products', 'sfdc',null,null);
        system.debug(productJSON +'========productJSON ======');
        contentData.put('Products.json', productJSON);
        string productOptJSON  = '{"Product-Options":[{"Record ID":"a6U1B0000008VXPUA2","Configured SKU":"01t1B000005hc2VQAQ","Configured Sku Catalog Display Name":"Azimuth 1000 Test","Configured Sku Catalog Long Description":"Azimuth","Configured Sku IsActive":true,"Configured Sku Display Product":"Yes","Optional Sku Catalog Display Name":"","Optional Sku Catalog Long Description":"","Optional Sku IsActive":true,"Optional Sku Display Product":"Yes","Display in Catalog":true,"Feature":"a6T1B0000008ap8UAA","Feature Name":"System(s)","Number":60,"KVH P/N":"01-0148-01","Product ID (18-char)":"01t30000001uv23AAA","Last Modified Date":"2018-03-28T08:51:13.000Z"}]}';
        contentData.put('Options.json', productOptJSON);
        string productFeaJSON  = '{"Product-Features":[{"Record ID":"a6T1B0000008asMUAQ","Feature Name":"Accessories","Configured SKU":"01t1B000005hc2VQAQ","Configured Sku Display Product":"Yes","Configured Sku IsActive":true,"Configured Sku Catalog Display Name":"Azimuth 1000 Test","Configured Sku Catalog Long Description":"Azimuth","Number":30,"Last Modified Date":"2018-03-28T08:51:13.000Z"}]}';
        contentData.put('Features.json', productFeaJSON);
        string productAttJSON  = '{"Product-Attributes":[{"Record ID":"a8L2D0000004EJuUAM","Product Attribute Name":"Description Leisure","Configured SKU":"01t1B000005hc2VQAQ","Configured Sku Display Product":"Yes","Configured Sku IsActive":true,"Configured Sku Catalog Display Name":"Azimuth 1000","Configured Sku Catalog Long Description":"","Product Attribute Public Name":"","Product Attribute Value":"","Last Modified Date":"2018-04-03T11:10:03.000Z"}]}';
        contentData.put('Attributes.json', productAttJSON);
        string attJSON  = '[{"ProductLine":"Television","ProductSeries":"HD series","ProductName":"Test Product1","ProductAttributes":[{"ProductAttributeName":"Description Leisure","ProductAttributePublicName":"Description ","ProductAttributeValue":"The ultimate global 1 meter satellite TV solution for Ku- and Ka-band services. For yachts 80+ ft."},{"ProductAttributeName":"Description Leisure","ProductAttributePublicName":"Description","ProductAttributeValue":"The ultimate global 1 meter satellite TV solution for Ku- and Ka-band services. For yachts 80+ ft."}]},{"ProductLine":"Television","ProductSeries":"HD series","ProductName":"Test Product Display1","ProductAttributes":[{"ProductAttributeName":"Description Leisure","ProductAttributePublicName":"Description 22","ProductAttributeValue":"The ultimate global 1 meter satellite TV solution for Ku- and Ka-band services. For yachts 80+ ft."},{"ProductAttributeName":"Description Leisure","ProductAttributePublicName":"Description","ProductAttributeValue":"The ultimate global 1 meter satellite TV solution for Ku- and Ka-band services. For yachts 80+ ft."}]}]';
        contentData.put('ProductsWithSpecsProd', attJSON);
        List<ContentVersion> cvLst = new List<ContentVersion>();
        for (string temp : contentData.keySet()) {
            if (contentData.containsKey(temp)) {
                ContentVersion cv = new ContentVersion();
                cv.versionData = blob.valueOf(contentData.get(temp));
                cv.Title = temp;
                cv.pathOnClient = temp;
                cvLst.add(cv);
            }
        }
        insert cvLst;
    }
    @testSetup static void setup() {
        //Insert Custom Setting
        AmazonS3_Integration__c amz = new AmazonS3_Integration__c();
        amz.Name = 'Credential';
        amz.Key__c = 'test key';
        amz.Secret__c = 'test secret';
        amz.Bucketname__c = 'kvh-product-data-sandbox';
        amz.Host__c = 's3.us-east-1.amazonaws.com';
        
        insert amz;
        //Insert Product
        List<Product2> lstProd = new List<Product2>();
        for (integer i = 0 ; i < 5; i++) {
            Product2 prod = new Product2(Name = 'Test Product' + i, ProductCode = 'KVH', Catalog_Display_Name__c = 'Test Product Display' + i,
                                         Catalog_Long_Description__c = 'Test Product Display' + i, Display_Product__c = 'Yes', isActive = true);
            lstProd.add(prod);
        }
        insert lstProd;
        //Insert Product-Feature
        List<SBQQ__ProductFeature__c> lstProdFeature = new List<SBQQ__ProductFeature__c>();
        for (integer i = 0 ; i < 2; i++) {
            SBQQ__ProductFeature__c Feature = new SBQQ__ProductFeature__c(Name = 'Test ' + i, SBQQ__Number__c = i + 10, SBQQ__ConfiguredSKU__c = lstProd[0].Id);
            lstProdFeature.add(Feature);
        }
        insert lstProdFeature;
        //Insert Product-Option
        List<SBQQ__ProductOption__c> lstProdOption = new List<SBQQ__ProductOption__c>();
        for (integer i = 0 ; i < 2; i++) {
            SBQQ__ProductOption__c Option = new SBQQ__ProductOption__c(SBQQ__Number__c = i + 10, SBQQ__ConfiguredSKU__c = lstProd[0].Id,
                                                                       SBQQ__OptionalSKU__c = lstProd[1].Id, Display_in_Catalog__c = true);
            lstProdOption.add(Option);
        }
        for (integer i = 0 ; i < 2; i++) {
            SBQQ__ProductOption__c Option = new SBQQ__ProductOption__c(SBQQ__Number__c = i + 10, SBQQ__OptionalSKU__c = lstProd[0].Id,
                                                                       SBQQ__ConfiguredSKU__c = lstProd[1].Id, Display_in_Catalog__c = true);
            lstProdOption.add(Option);
        }
        insert lstProdOption;
        
        //Insert Product-Attributes
        List<Product_Attribute__c> lstProdAttribute = new List<Product_Attribute__c>();
        for (integer i = 0 ; i < 2; i++) {
            Product_Attribute__c Attribute = new Product_Attribute__c(Name = 'Test ' + i, Configured_SKU__c = lstProd[0].Id);
            lstProdAttribute.add(Attribute);
        }
        insert lstProdAttribute;
        
        //Insert Product-Market Sector
        List<Product_Market_Sector__c> lstProdMS = new List<Product_Market_Sector__c>();
        for (integer i = 0 ; i < 10; i++) {
            Product_Market_Sector__c pMS = new Product_Market_Sector__c(Name = 'Test ' + i, Product__c = lstProd[0].Id, Market__c = 'Commercial & OEM',
                                                                        Sector__c = 'Maritime Systems', Product_Line__c = 'Satellite Communications', Product_Series__c = 'Inmarsat');
            lstProdMS.add(pMS);
        }
        insert lstProdMS;
        
        //Insert Product-Document Sector
        List<Prod_Documents__c> lstProdDoc = new List<Prod_Documents__c>();
        for (integer i = 0 ; i < 10; i++) {
            Prod_Documents__c pDoc = new Prod_Documents__c(Name = 'Test Doc' + i,File_Access__c = 'Public',Active__c = true,KVH_com__c = true);
            lstProdDoc.add(pDoc);
        }
        insert lstProdDoc;
        
        //Insert Product-Document-Lib Sector
        List<Prod_Doc_Library__c> lstProdDocLib = new List<Prod_Doc_Library__c>();
        for (integer i = 0 ; i < 10; i++) {
            Prod_Doc_Library__c pDocLib = new Prod_Doc_Library__c(Name = 'Test Doc Lib' + i,Filename__c = lstProdDoc[i].Id,Product_Market_Sector__c = lstProdMS[i].Id);
            lstProdDocLib.add(pDocLib);
        }
        insert lstProdDocLib;
    }
    
    public static testMethod void ProductTrigger_Method1() {
        List<Product2> lstProd = new List<Product2>([SELECT Id, Name, Catalog_Display_Name__c FROM Product2]);
        List<SBQQ__ProductFeature__c> lstProdFeature = new List<SBQQ__ProductFeature__c>([SELECT Id, Name
                                                                                          FROM SBQQ__ProductFeature__c]);
        
        //Update Product
        lstProd[0].Catalog_Display_Name__c = '';
        update lstProd[0];
        
        //Delete product and features
        delete lstProd[0];
        delete lstProdFeature[0];
    }
    
    public static testMethod void ProductTrigger_Method2() {
        String CRON_EXP = '0 0 0 15 3 ? *';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HttpResponse res = ProductIntegrationCalloutClass.getInfoFromExternalService();
        String jobId = System.schedule('ProductIntegration_Job',  CRON_EXP, new ProductIntegration_SchedularClass());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
    
    public static testMethod void ProductTrigger_Method3() {
        createData();
        String CRON_EXP = '0 0 0 15 3 ? *';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HttpResponse res = ProductIntegrationCalloutClass.getInfoFromExternalService();
        
        String jobId = System.schedule('ProductIntegration_Job2',  CRON_EXP, new ProductIntegration_SchedularClass());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
    public static testMethod void ProductTrigger_Method4() {
        createData();
        Test.startTest();
        ProductAttributesCreate_Controller tempContrllr = new ProductAttributesCreate_Controller();
        tempContrllr.ProductAttributesCreate_Method();
        Test.stopTest();
    }
    public static testMethod void ProductTrigger_Method5() {
        String CRON_EXP = '0 0 0 15 3 ? *';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HttpResponse res = ProductIntegrationCalloutClass.getInfoFromExternalService();
        String jobId = System.schedule('ProductIntegration_Job',  CRON_EXP, new ProductIntegration_SchedularClass());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
    public static testMethod void ProductTrigger_Method6() {
        createDocData();
        String CRON_EXP = '0 0 0 15 3 ? *';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HttpResponse res = ProductIntegrationCalloutClass.getInfoFromExternalService();
        String jobId = System.schedule('ProductIntegration_Job',  CRON_EXP, new ProductIntegration_SchedularClass());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
    /*
    public static testMethod void ProductTrigger_Method7() {
    List<Product2> lstProd = new List<Product2>([SELECT Id, Name, Catalog_Display_Name__c,Catalog_Long_Description__c,
                                                     ProductCode,Display_Product__c,IsActive,Product_Line1__c,Product_Series__c,Retired__c,Retired_Date__c,LastModifiedDate
                                                     FROM Product2]);
    lstProd[0].Display_Product__c = 'No';
    lstProd[1].Catalog_Display_Name__c = 'Hello';
    lstProd[2].Retired_Date__c = system.today();
    update lstProd;
    delete lstProd[3];
    createData();
    String CRON_EXP = '0 0 0 15 3 ? *';
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    HttpResponse res = ProductIntegrationCalloutClass.getInfoFromExternalService();
    
    String jobId = System.schedule('ProductIntegration_Job2',  CRON_EXP, new ProductIntegration_SchedularClass());
    CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
    System.assertEquals(CRON_EXP, ct.CronExpression);
    System.assertEquals(0, ct.TimesTriggered);
    Test.stopTest();
    }
    */                  
}