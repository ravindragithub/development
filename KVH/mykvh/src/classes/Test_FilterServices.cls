@isTest //(SeeAllData=true)
public class Test_FilterServices {
    
    public static List<Product_Catalogue__c> createProductCatelogueRecords(String country, List<Product_Market_Sector__c> retMarketSector, List<Account> retAccount){
        List<Product_Catalogue__c> retProduct = new List<Product_Catalogue__c>();
        for (Product_Market_Sector__c mktSct: retMarketSector){
            for (Account acct: retAccount){
                if (country == 'Afghanistan'){
                    Product_Catalogue__c afghan = new Product_Catalogue__c();
                    afghan.Product_Market_Sector__c = mktSct.Id;
                    afghan.Partner_Account__c = acct.Id;
                    afghan.Sales__c = true;
                    afghan.CSN__c = true;
                    afghan.Services_Only__c = true;
                    retProduct.add(afghan);
                }else if (country == 'United States'){     
                    Product_Catalogue__c us = new Product_Catalogue__c();
                    us.Product_Market_Sector__c = mktSct.Id;
                    us.Partner_Account__c = acct.Id;
                    us.Sales__c = true;
                    us.CSN__c = true;
                    us.Services_Only__c = true;
                    retProduct.add(us);
                }
            }
        }
        return retProduct;
    }
    
    public static List<Account> createAccountRecords(String country, Integer count, Contact contact){
        List<Account> retAccount = new List<Account>();
        for (Integer i = 0; i < count; i++){
            if (country == 'Afghanistan'){
                Account afghanAccount = new Account();
                afghanAccount.Name = 'Seawide Dealer Marine Demo' + String.valueOf(i);
                afghanAccount.Latitude__c = 33.529508;
                afghanAccount.Longitude__c = -117.179986;
                afghanAccount.ShippingLatitude = 33.529508;
                afghanAccount.ShippingLongitude = -117.179986;
                afghanAccount.Info_Only__c = false;
                afghanAccount.Website = '';
                afghanAccount.ShippingCity = 'Murrieta';
                afghanAccount.ShippingState = 'CA';
                afghanAccount.ShippingPostalCode = '92562';
                afghanAccount.ShippingCountry = 'United States';
                afghanAccount.ShippingStreet = '41698 Eastman Drive';
                afghanAccount.Account_Status__c = 'Active';
                afghanAccount.Partner_Portal_Phone__c = '4010001000';
                afghanAccount.Partner_Portal_Email__c = 'test@gmail.com';
                afghanAccount.Partner_Role__c = 'Service Provider';
                afghanAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Customer').getRecordTypeId();
                retAccount.add(afghanAccount);
            }else if (country == 'United States'){
                Account usAccount = new Account();
                usAccount.Name = 'Seawide Dealer Marine Demo ' + String.valueOf(i);
                usAccount.Latitude__c = 33.529508;
                usAccount.Longitude__c = -117.179986;
                usAccount.ShippingLatitude = 33.529508;
                usAccount.ShippingLongitude = -117.179986;
                usAccount.Info_Only__c = false;
                usAccount.ShippingCity = 'Murrieta';
                usAccount.Website = '';
                usAccount.ShippingState = 'CA';
                usAccount.ShippingPostalCode = '92562';
                usAccount.ShippingCountry = 'United States';
                usAccount.ShippingStreet = '41698 Eastman Drive';
                usAccount.Account_Status__c = 'Active';
                usAccount.Partner_Role__c = 'Service Provider';
                usAccount.Partner_Portal_Phone__c = '4010001000';
                usAccount.Partner_Portal_Email__c = 'test@gmail.com';
                usAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Customer').getRecordTypeId();
                retAccount.add(usAccount);
            }
        }
        Account KVHAccount = new Account();
        KVHAccount.Name = 'KVH Industries';
        KVHAccount.Latitude__c = 41.5231787;
        KVHAccount.Longitude__c = -71.2971434;
        KVHAccount.ShippingCity = 'Middletown';
        KVHAccount.Website = '';
        KVHAccount.ShippingState = 'RI';
        KVHAccount.ShippingPostalCode = '02842';
        KVHAccount.ShippingCountry = 'United States';
        KVHAccount.ShippingStreet = '50 Enterprise Center';
        KVHAccount.Partner_Role__c = 'Representative';
        KVHAccount.Partner_Portal_Phone__c = '4010001000';
        KVHAccount.Partner_Portal_Email__c = 'test@gmail.com';
        KVHAccount.Partner_Portal_Main_Contact__c = contact.id;
        retAccount.add(KVHAccount);
        return retAccount;
    }
    
    public static List<Product_Market_Sector__c> createProductMarkterRecords(String country, Integer count, List<Product2> retProduct){
        List<Product_Market_Sector__c> retMarketSector = new List<Product_Market_Sector__c>();
        for (Product2 pdct: retProduct){
            for (Integer i = 0; i < count; i++){
                if (country == 'Afghanistan'){
                    Product_Market_Sector__c afghanMarket = new Product_Market_Sector__c();
                    afghanMarket.Market__c = 'Leisure';
                    afghanMarket.Sector__c = 'Marine Systems';
                    //afghanMarket.Product_Line__c = 'Satellite Television';
                   // afghanMarket.Product_Series__c = 'HD-Series';
                    afghanMarket.Product__c = pdct.Id;
                    retMarketSector.add(afghanMarket);
                }else if (country == 'United States'){
                    Product_Market_Sector__c usMarket = new Product_Market_Sector__c();
                    usMarket.Market__c = 'Leisure';
                    usMarket.Sector__c = 'Marine Systems';
                    //usMarket.Product_Line__c = 'Satellite Television';
                    //usMarket.Product_Series__c = 'HD-Series';
                    usMarket.Product__c = pdct.Id;
                    retMarketSector.add(usMarket);
                }
            }
        }
        return retMarketSector;
    }
    
    public static List<Product2> createProduct2Records(String country, Integer count){
        List<Product2> retProduct = new List<Product2>();
        for (Integer i = 0; i < count; i++){
            if (country == 'Afghanistan'){
                Product2 afghanProduct = new Product2();
                afghanProduct.Name = 'TracVision HD11_';
                afghanProduct.Display_Product__c = 'Yes';
                afghanProduct.Product_Line__c = 'Satellite Television';
                afghanProduct.Product_Series__c = 'HD-Series';
                retProduct.add(afghanProduct);
            }else if (country == 'United States'){
                Product2 usProduct = new Product2();
                usProduct.Name = 'TracVision HD11_';
                usProduct.Display_Product__c = 'Yes';
                usProduct.Product_Line__c = 'Satellite Television';
                usProduct.Product_Series__c = 'HD-Series';
                retProduct.add(usProduct);
            }
        }
        return retProduct;
    }
    
    public static TestMethod void testFilterServicesController_productSelection(){
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        insert contact;
        DefaultAccounts__c da = new DefaultAccounts__c(Description__c = '123', Name = 'KVH_Official_Internal_Contacts', Account_ID__c = '00130000016nhUAAAY');
        insert da;
        Prod_Documents__c prodDocs = new Prod_Documents__c();
        insert prodDocs;
        Content_Type__c content = new Content_Type__c ();
        content.Content_Main_Type__c  = 'Advertising ';
        content.Product_Document__c = prodDocs.Id;
        content.Content_Sub_Type__c  = 'Activation Process';
        insert content;
        List<Account> retAccount = createAccountRecords('United States', 1, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('United States', 1);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('United States', 1, retProduct);
        insert retProductMarket;
        List<Product_Catalogue__c> retProductCatalogue = createProductCatelogueRecords('United States', retProductMarket, retAccount);
        insert retProductCatalogue;
        List<FilterServices.ProductLineJSON> fitlerServices = FilterServices.productSelection('Retired Products');
        System.assertEquals(0, fitlerServices.size());
        fitlerServices = FilterServices.productSelection('Active Products');
        System.assertEquals(0, fitlerServices.size());
    }
    
    public static TestMethod void testFilterServicesController_loadContentFilter(){
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        insert contact;
        Prod_Documents__c doc = new Prod_Documents__c();
        doc.Name = 'Advertising';
        doc.File_Access__c = 'Public';
        doc.Associated_Content_Types__c = 'Advertising';
        insert doc;
        //Content_Type__c content = new Content_Type__c();
        //content.Content_Main_Type__c  = 'Advertising';
        //content.Content_Sub_Type__c  = 'Activation Process';
        //insert content;
        Prod_Documents__c prodDocs = new Prod_Documents__c();
        insert prodDocs;
        Content_Type__c content = new Content_Type__c();
        content.Content_Main_Type__c  = 'Advertising ';
        content.Product_Document__c = prodDocs.Id;
        content.Content_Sub_Type__c  = 'Activation Process';
        insert content;
        List<Account> retAccount = createAccountRecords('United States', 1, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('United States', 1);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('United States', 1, retProduct);
        insert retProductMarket;
        List<Product_Catalogue__c> retProductCatalogue = createProductCatelogueRecords('United States', retProductMarket, retAccount);
        insert retProductCatalogue;
        List<FilterServices.ProductLineJSON> fitlerServices = FilterServices.loadContentFilter();
        System.assertEquals(1, fitlerServices.size());
    }
    public static TestMethod void testFilterServicesController_whereToBuyFilterProductMarketSector(){
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        insert contact;
        //Content_Type__c content = new Content_Type__c ();
        //content.Content_Main_Type__c  = 'Advertising ';
        //content.Content_Sub_Type__c  = 'Activation Process';
        //insert content;
        Prod_Documents__c prodDocs = new Prod_Documents__c();
        insert prodDocs;
        Content_Type__c content = new Content_Type__c ();
        content.Content_Main_Type__c  = 'Advertising ';
        content.Product_Document__c = prodDocs.Id;
        content.Content_Sub_Type__c  = 'Activation Process';
        insert content;
        List<Account> retAccount = createAccountRecords('United States', 1, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('United States', 10);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('United States', 10, retProduct);
        insert retProductMarket;
        
        List<FilterServices.ProductLineJSON> fitlerServices = FilterServices.whereToBuyFilter(retProductMarket,null);
        //System.assertEquals(3, fitlerServices.size());
    }
    public static TestMethod void testFilterServicesController_whereToBuyFilterProductCatalog(){
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        insert contact;
        //Content_Type__c content = new Content_Type__c ();
        //content.Content_Main_Type__c  = 'Advertising ';
        //content.Content_Sub_Type__c  = 'Activation Process';
        //insert content;
        Prod_Documents__c prodDocs = new Prod_Documents__c();
        insert prodDocs;
        Content_Type__c content = new Content_Type__c ();
        content.Content_Main_Type__c  = 'Advertising ';
        content.Product_Document__c = prodDocs.Id;
        content.Content_Sub_Type__c  = 'Activation Process';
        insert content;
        List<Account> retAccount = createAccountRecords('United States', 1, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('United States', 1);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('United States', 1, retProduct);
        insert retProductMarket;        
        List<Product_Catalogue__c> retProductCatalogue = createProductCatelogueRecords('United States', retProductMarket, retAccount);
        insert retProductCatalogue;
        List<FilterServices.ProductLineJSON> fitlerServices = FilterServices.whereToBuyFilter(retProductCatalogue);
        System.assertEquals(3, fitlerServices.size());
    }

}