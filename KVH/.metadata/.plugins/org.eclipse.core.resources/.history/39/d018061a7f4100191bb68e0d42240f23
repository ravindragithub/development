@isTest //(SeeAllData=true)
public class TestWhereToBuyController {

    public static List<Country__c> createCountryRecords(String country, List<Product_Catalogue__c> retProduct){
        List<Country__c> retCountry = new List<Country__c>();
        for (Product_Catalogue__c prdCtlg: retProduct){
            if (country == 'Afghanistan'){
                Country__c afghan = new Country__c();
                afghan.Country__c = 'Afghanistan';
                afghan.Product_Catalog__c = prdCtlg.Id;
                retCountry.add(afghan);
            }else if (country == 'United States'){
                Country__c us = new Country__c();
                us.Country__c = 'United States';
                us.State__c = 'California;Rhode Island';
                us.Product_Catalog__c = prdCtlg.Id;
                retCountry.add(us);
                Country__c us2 = new Country__c();
                us2.Country__c = 'United States';
                us2.State__c = 'Vermont;Florida';
                us2.Product_Catalog__c = prdCtlg.Id;
                retCountry.add(us2);
            }
        }
        return retCountry;
    }
    
    
    public static List<Country__c> createCountryRecords(String country, List<Product_Catalogue__c> retProduct, Sales_Representative__c salesRep){
        List<Country__c> retCountry = new List<Country__c>();
        for (Product_Catalogue__c prdCtlg: retProduct){
            if (country == 'Afghanistan'){
                Country__c afghan = new Country__c();
                afghan.Country__c = 'Afghanistan';
                afghan.Product_Catalog__c = prdCtlg.Id;
                retCountry.add(afghan);
            }else if (country == 'United States'){
                Country__c us = new Country__c();
                us.Country__c = 'United States';
                us.State__c = 'California;Rhode Island';
                us.Product_Catalog__c = prdCtlg.Id;
                us.Sales_Representative__c = salesRep.Id;
                retCountry.add(us);
                Country__c us2 = new Country__c();
                us2.Country__c = 'United States';
                us2.Sales_Representative__c = salesRep.Id;
                us2.State__c = 'Vermont;Florida';
                us2.Product_Catalog__c = prdCtlg.Id;
                retCountry.add(us2);
            }
        }
        return retCountry;
    }
    
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
                    afghan.CSN_Level__c = 'Basic';
                    retProduct.add(afghan);
                }else if (country == 'United States'){     
                    Product_Catalogue__c us = new Product_Catalogue__c();
                    us.Product_Market_Sector__c = mktSct.Id;
                    us.Partner_Account__c = acct.Id;
                    us.Sales__c = true;
                    us.CSN__c = true; 
                    us.Services_Only__c = true;
                    us.CSN_Level__c = 'Basic';
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
                afghanAccount.Display_on_Where_to_Get_Service__c = true;
                afghanAccount.Display_on_Where_to_Buy__c = true;
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
                usAccount.Display_on_Where_to_Get_Service__c = true;
                usAccount.Display_on_Where_to_Buy__c = true;
                usAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Customer').getRecordTypeId();
                retAccount.add(usAccount);
                
                Account usAccount2 = new Account();
                usAccount2.Name = 'Seawide Dealer Marine Demo ' + String.valueOf(i);
                usAccount2.Latitude__c = 33.529508;
                usAccount2.Longitude__c = -117.179986;
                usAccount2.ShippingLatitude = 33.529508;
                usAccount2.ShippingLongitude = -117.179986;
                usAccount2.Info_Only__c = false;
                usAccount2.ShippingCity = 'Murrieta';
                usAccount2.Website = '';
                usAccount2.ShippingState = 'CA';
                usAccount2.ShippingPostalCode = '92562';
                usAccount2.ShippingCountry = 'United States';
                usAccount2.ShippingStreet = '41698 Eastman Drive';
                usAccount2.Account_Status__c = 'Active';
                usAccount2.Partner_Role__c = 'Rep';
                usAccount2.Partner_Portal_Phone__c = '4010001000';
                usAccount2.Partner_Portal_Main_Contact__c = contact.id;
                usAccount2.Partner_Portal_Email__c = 'test@gmail.com';
                usAccount2.Display_on_Where_to_Get_Service__c = true;
                usAccount2.Display_on_Where_to_Buy__c = true;
                usAccount2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Customer').getRecordTypeId();
                retAccount.add(usAccount2);
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
        Account insertAccount = new Account(name = 'test Account');
        insert insertAccount;
        DefaultAccounts__c insertSetting = new DefaultAccounts__c();
        //insertSetting.Account_ID__c = '001000000000000000';
        insertSetting.Account_ID__c = insertAccount.Id;
        insertSetting.Description__c = 'This is a list of Accounts used for special/default purposes. e.g. Activations in Progress, Default Assets, Replaced Assets....';
        insertSetting.Name = 'KVH_Official_Internal_Contacts';
        insert insertSetting;
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
                    //afghanMarket.Product_Series__c = 'HD-series';
                    afghanMarket.Product__c = pdct.Id;
                    retMarketSector.add(afghanMarket);
                }else if (country == 'United States'){
                    Product_Market_Sector__c usMarket = new Product_Market_Sector__c();
                    usMarket.Market__c = 'Leisure';
                    usMarket.Sector__c = 'Marine Systems';
                    //usMarket.Product_Line__c = 'Satellite Television';
                    //usMarket.Product_Series__c = 'HD-series';
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
                retProduct.add(afghanProduct);
            }else if (country == 'United States'){
                Product2 usProduct = new Product2();
                usProduct.Name = 'TracVision HD11_';
                usProduct.Display_Product__c = 'Yes';
                retProduct.add(usProduct);
            }
        }
        return retProduct;
    }
                                                              
    public static TestMethod void testWhereToBuyController_loadOptions(){
        Test.startTest();
        Map<String,Object> loadOptions = WhereToBuyController.loadOptions(208);
        Test.stopTest();
        System.assertEquals(3, loadOptions.size());
    }

                                                              
    public static TestMethod void testWhereToBuyController_searchMarketSectorBuy(){
        List<Product2> retProduct = createProduct2Records('United States', 1);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('United States', 1, retProduct);
        insert retProductMarket;
        
        List<Product_Market_Sector__c> expectedMktSct1 = [SELECT Market__c, Sector__c, Product_Line__c, Product_Series__c, Product__c, Catalog_Display_Name__c FROM Product_Market_Sector__c];
        Test.startTest();
        List<Product_Market_Sector__c> actualMktSct1 = WhereToBuyController.searchMarketSector('Leisure','Marine Systems', 'WhereToBuy');
        Test.stopTest();
        System.assertEquals(retProductMarket, actualMktSct1);
    }
                                                              
    public static TestMethod void testWhereToBuyController_searchMarketSectorService(){
        List<Product2> retProduct = createProduct2Records('United States', 1);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('United States', 1, retProduct);
        insert retProductMarket;
        
        List<Product_Market_Sector__c> expectedMktSct1 = [SELECT Market__c, Sector__c, Product_Line__c, Product_Series__c, Product__c, Catalog_Display_Name__c FROM Product_Market_Sector__c];
        Test.startTest();
        List<Product_Market_Sector__c> actualMktSct1 = WhereToBuyController.searchMarketSector('Leisure','Marine Systems', 'WhereToGetService');
        Test.stopTest();
        System.assertEquals(retProductMarket, actualMktSct1);
    }
                                                              
    public static TestMethod void testWhereToBuyController_searchPartnerCorrectZipAndStateMiles(){
        SingleRequestMock fakeZipCheck = new SingleRequestMock(200,'Complete','{"results":[{"address_components":[{"long_name":"92562","short_name":"92562","types":["postal_code"]},{"long_name":"Murrieta","short_name":"Murrieta","types":["locality","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"UnitedStates","short_name":"US","types":["country","political"]}],"formatted_address":"Murrieta,CA92562,USA","geometry":{"bounds":{"northeast":{"lat":33.71725,"lng":-117.1682409},"southwest":{"lat":33.464879,"lng":-117.509725}},"location":{"lat":33.5262326,"lng":-117.3381427},"location_type":"APPROXIMATE","viewport":{"northeast":{"lat":33.61323,"lng":-117.1682409},"southwest":{"lat":33.464879,"lng":-117.509725}}},"partial_match":true,"place_id":"ChIJb77m9XWE3IAR2Ilt9HFHgdg","types":["postal_code"]}],"status":"OK"}',null);
        SingleRequestMock fakeDestinationCheck = new SingleRequestMock(200,'Complete','{ "destination_addresses" : [ "41633-41665 Eastman Dr, Murrieta, CA 92562, USA" ], "origin_addresses" : [ "41514 Cll Andalucia, Murrieta, CA 92562, USA" ], "rows" : [{ "elements" : [{ "distance" : {"text" : "18.4 mi","value" : 29583 }, "duration" : {"text" : "29 mins","value" : 1761 }, "status" : "OK"} ]} ], "status" : "OK"}',null);
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('http://maps.googleapis.com/maps/api/geocode/json?address=United States,92562&sensor=false',fakeZipCheck);
        endpoint2TestResp.put('https://maps.googleapis.com/maps/api/distancematrix/json?origins=33.5262326,-117.3381427&destinations=33.5295,-117.1800|0.000000,0.000000&mode=driving&language=en&units=imperial',fakeDestinationCheck);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        contact.MailingCity = 'Murrieta';
        contact.MailingState = 'CA';
        contact.MailingPostalCode = '92562';
        contact.MailingCountry = 'United States';
        contact.MailingStreet = '41698 Eastman Drive';
        contact.Partner_Portal_Email__c = 'ktholmes9@yahoo.com';
        contact.Partner_Portal_Phone__c = '4018350422';
        insert contact;
        Sales_Representative__c salesRep = new Sales_Representative__c();
        salesRep.Sales_Rep_Contact__c = contact.id;
        insert salesRep;
        List<Account> retAccount = createAccountRecords('United States', 1, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('United States', 1);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('United States', 1, retProduct);
        insert retProductMarket;
        List<Product_Catalogue__c> retProductCatalogue = createProductCatelogueRecords('United States', retProductMarket, retAccount);
        insert retProductCatalogue;
        List<Product_Catalogue__c> retProductCatalogue2 = createProductCatelogueRecords('United States', retProductMarket, retAccount);
        insert retProductCatalogue2;
        List<Country__c> dbCountryQuery = createCountryRecords('United States', retProductCatalogue, salesRep);
        insert dbCountryQuery;
        Test.startTest();
        Map<String,Object>  searchPartner1 = WhereToBuyController.searchPartner('92562', 'United States', 'Leisure', 'Marine Systems', retProduct[0].ID, '25', 'miles', 'WhereToGetService', 'California');
        Test.stopTest();
        System.assertEquals(3, searchPartner1.size());
    }              
    
    public static TestMethod void testWhereToBuyController_searchPartnerCorrectCountryNoZipOrStateKilometer(){
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        insert contact;
        List<Account> retAccount = createAccountRecords('Afghanistan', 10, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('Afghanistan', 5);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('Afghanistan', 10, retProduct);
        insert retProductMarket;
        List<Product_Catalogue__c> retProductCatalogue = createProductCatelogueRecords('United States', retProductMarket, retAccount);
        insert retProductCatalogue;
        List<Product_Catalogue__c> retProductCatalogue2 = createProductCatelogueRecords('United States', retProductMarket, retAccount);
        insert retProductCatalogue2;
        List<Country__c> dbCountryQuery = createCountryRecords('Afghanistan', retProductCatalogue);
        insert dbCountryQuery;
        Test.startTest();
        Map<String,Object> searchPartner2 = WhereToBuyController.searchPartner('', 'Afghanistan', 'Leisure', 'Marine Systems', 'None', '50', 'km', 'WhereToBuy', null);
        Test.stopTest();
        System.assertEquals(2, searchPartner2.size());
    }         
    
    public static TestMethod void testWhereToBuyController_searchPartnerCorrectZipNoStateKilometer(){
        SingleRequestMock fakeZipCheck = new SingleRequestMock(200,'Complete','{"results":[{"address_components":[{"long_name":"92562","short_name":"92562","types":["postal_code"]},{"long_name":"Murrieta","short_name":"Murrieta","types":["locality","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"UnitedStates","short_name":"US","types":["country","political"]}],"formatted_address":"Murrieta,CA92562,USA","geometry":{"bounds":{"northeast":{"lat":33.71725,"lng":-117.1682409},"southwest":{"lat":33.464879,"lng":-117.509725}},"location":{"lat":33.5262326,"lng":-117.3381427},"location_type":"APPROXIMATE","viewport":{"northeast":{"lat":33.61323,"lng":-117.1682409},"southwest":{"lat":33.464879,"lng":-117.509725}}},"partial_match":true,"place_id":"ChIJb77m9XWE3IAR2Ilt9HFHgdg","types":["postal_code"]}],"status":"OK"}',null);
        SingleRequestMock fakeDestinationCheck = new SingleRequestMock(200,'Complete','{ "destination_addresses" : [ "41633-41665 Eastman Dr, Murrieta, CA 92562, USA" ], "origin_addresses" : [ "41514 Cll Andalucia, Murrieta, CA 92562, USA" ], "rows" : [{ "elements" : [{ "distance" : {"text" : "18.4 mi","value" : 29583 }, "duration" : {"text" : "29 mins","value" : 1761 }, "status" : "OK"} ]} ], "status" : "OK"}',null);
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('http://maps.googleapis.com/maps/api/geocode/json?address=United States,92562&sensor=false',fakeZipCheck);
        endpoint2TestResp.put('https://maps.googleapis.com/maps/api/distancematrix/json?origins=33.5262326,-117.3381427&destinations=33.5295,-117.1800|0.000000,0.000000&mode=driving&language=en&units=imperial',fakeDestinationCheck);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        contact.MailingCity = 'Murrieta';
        contact.MailingState = 'CA';
        contact.MailingPostalCode = '92562';
        contact.MailingCountry = 'United States';
        contact.MailingStreet = '41698 Eastman Drive';
        contact.Partner_Portal_Email__c = 'ktholmes9@yahoo.com';
        contact.Partner_Portal_Phone__c = '4018350422';
        insert contact;
        Sales_Representative__c salesRep = new Sales_Representative__c();
        salesRep.Sales_Rep_Contact__c = contact.id;
        insert salesRep;
        List<Account> retAccount = createAccountRecords('United States', 1, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('United States', 1);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('United States', 1, retProduct);
        insert retProductMarket;
        List<Product_Catalogue__c> retProductCatalogue = createProductCatelogueRecords('United States', retProductMarket, retAccount);
        insert retProductCatalogue;
        List<Product_Catalogue__c> retProductCatalogue2 = createProductCatelogueRecords('United States', retProductMarket, retAccount);
        insert retProductCatalogue2;
        List<Country__c> dbCountryQuery = createCountryRecords('United States', retProductCatalogue, salesRep);
        insert dbCountryQuery;
        Test.startTest();
        Map<String,Object> searchPartner6 = WhereToBuyController.searchPartner('92562', 'United States', 'Leisure', 'Marine Systems', retProduct[0].ID, '50', 'km', 'WhereToGetService', null);
        Test.stopTest();
        System.assertEquals(3, searchPartner6.size());
    }

    public static TestMethod void testWhereToBuyController_searchPartnerCorrectStateNoZipMiles(){
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        insert contact;
        List<Account> retAccount = createAccountRecords('United States', 10, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('United States', 10);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('United States', 1, retProduct);
        insert retProductMarket;
        List<Product_Catalogue__c> retProductCatalogue = createProductCatelogueRecords('United States', retProductMarket, retAccount);
        insert retProductCatalogue;
        List<Product_Catalogue__c> retProductCatalogue2 = createProductCatelogueRecords('United States', retProductMarket, retAccount);
        insert retProductCatalogue2;
        List<Country__c> dbCountryQuery = createCountryRecords('United States', retProductCatalogue);
        insert dbCountryQuery;
        Test.startTest();
        Map<String,Object> searchPartner3 = WhereToBuyController.searchPartner('', 'United States', 'Leisure', 'Marine Systems', 'None', '25', 'miles', 'WhereToGetService', 'California');
        Test.stopTest();
        System.assertEquals(3, searchPartner3.size());
    }

    public static TestMethod void testWhereToBuyController_searchPartnerIncorrectStateToCountryMiles(){
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        insert contact;
        List<Account> retAccount = createAccountRecords('Afghanistan', 10, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('Afghanistan', 10);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('Afghanistan', 10, retProduct);
        insert retProductMarket;
        List<Product_Catalogue__c> retProductCatalogue = createProductCatelogueRecords('Afghanistan', retProductMarket, retAccount);
        insert retProductCatalogue;
        List<Product_Catalogue__c> retProductCatalogue2 = createProductCatelogueRecords('Afghanistan', retProductMarket, retAccount);
        insert retProductCatalogue2;
        List<Country__c> dbCountryQuery = createCountryRecords('Afghanistan', retProductCatalogue);
        insert dbCountryQuery;
        Test.startTest();
        Map<String,Object> searchPartner4 = WhereToBuyController.searchPartner('', 'Afghanistan', 'Leisure', 'Marine Systems', 'None', '25', 'miles', 'WhereToBuy', 'California');
        Test.stopTest();
        System.assertEquals(3, searchPartner4.size());
    }
    
    public static TestMethod void testWhereToBuyController_searchPartnerNoDataLoaded(){
        Test.startTest();
        Map<String,Object> searchPartner4 = WhereToBuyController.searchPartner('', 'Afghanistan', 'Leisure', 'Marine Systems', 'None', '25', 'miles', 'WhereToBuy', 'California');
        Test.stopTest();
        System.assertEquals(3, searchPartner4.size());
    }
    
    public static TestMethod void testWhereToBuyController_searchPartnerIncorrectZipToCountryMiles(){
        SingleRequestMock fakeZipCheck = new SingleRequestMock(200,'Complete','{"results":[],"status":"ZERO_RESULTS"}',null);
        SingleRequestMock fakeZipCheck2 = new SingleRequestMock(200,'Complete','{"results":[{"address_components":[{"long_name":"92562","short_name":"92562","types":["postal_code"]},{"long_name":"Murrieta","short_name":"Murrieta","types":["locality","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"UnitedStates","short_name":"US","types":["country","political"]}],"formatted_address":"Murrieta,CA92562,USA","geometry":{"bounds":{"northeast":{"lat":33.71725,"lng":-117.1682409},"southwest":{"lat":33.464879,"lng":-117.509725}},"location":{"lat":33.5262326,"lng":-117.3381427},"location_type":"APPROXIMATE","viewport":{"northeast":{"lat":33.61323,"lng":-117.1682409},"southwest":{"lat":33.464879,"lng":-117.509725}}},"partial_match":true,"place_id":"ChIJb77m9XWE3IAR2Ilt9HFHgdg","types":["postal_code"]}],"status":"OK"}',null);
        SingleRequestMock fakeDestinationCheck = new SingleRequestMock(200,'Complete','{ "destination_addresses" : [ "41633-41665 Eastman Dr, Murrieta, CA 92562, USA" ], "origin_addresses" : [ "41514 Cll Andalucia, Murrieta, CA 92562, USA" ], "rows" : [{ "elements" : [{ "distance" : {"text" : "18.4 mi","value" : 29583 }, "duration" : {"text" : "29 mins","value" : 1761 }, "status" : "OK"} ]} ], "status" : "OK"}',null);
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('http://maps.googleapis.com/maps/api/geocode/json?address=Afghanistan,92562&sensor=false',fakeZipCheck);
        endpoint2TestResp.put('http://maps.googleapis.com/maps/api/geocode/json?address=92562&sensor=false',fakeZipCheck2);
        endpoint2TestResp.put('https://maps.googleapis.com/maps/api/distancematrix/json?origins=33.5262326,-117.3381427&destinations=33.5295,-117.1800&mode=driving&language=en&units=imperial',fakeDestinationCheck);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        insert contact;
        List<Account> retAccount = createAccountRecords('Afghanistan', 1, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('Afghanistan', 1);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('Afghanistan', 1, retProduct);
        insert retProductMarket;
        List<Product_Catalogue__c> retProductCatalogue = createProductCatelogueRecords('Afghanistan', retProductMarket, retAccount);
        insert retProductCatalogue;
        List<Product_Catalogue__c> retProductCatalogue2 = createProductCatelogueRecords('Afghanistan', retProductMarket, retAccount);
        insert retProductCatalogue2;
        List<Country__c> dbCountryQuery = createCountryRecords('Afghanistan', retProductCatalogue);
        insert dbCountryQuery;
        Test.startTest();
        Map<String,Object> searchPartner5 = WhereToBuyController.searchPartner('92562', 'Afghanistan', 'Leisure', 'Marine Systems', retProduct[0].ID, '25', 'miles', 'WhereToBuy', null);
        Test.stopTest();
        System.assertEquals(3, searchPartner5.size());
    } 

    public static TestMethod void testWhereToBuyController_searchPartnerIncorrectZipAndStateToCountryMiles(){
        SingleRequestMock fakeZipCheck = new SingleRequestMock(200,'Complete','{"results":[],"status":"OVER_QUERY_LIMIT"}',null);
        SingleRequestMock fakeZipCheck2 = new SingleRequestMock(200,'Complete','{"results":[{"address_components":[{"long_name":"92562","short_name":"92562","types":["postal_code"]},{"long_name":"Murrieta","short_name":"Murrieta","types":["locality","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"UnitedStates","short_name":"US","types":["country","political"]}],"formatted_address":"Murrieta,CA92562,USA","geometry":{"bounds":{"northeast":{"lat":33.71725,"lng":-117.1682409},"southwest":{"lat":33.464879,"lng":-117.509725}},"location":{"lat":33.5262326,"lng":-117.3381427},"location_type":"APPROXIMATE","viewport":{"northeast":{"lat":33.61323,"lng":-117.1682409},"southwest":{"lat":33.464879,"lng":-117.509725}}},"partial_match":true,"place_id":"ChIJb77m9XWE3IAR2Ilt9HFHgdg","types":["postal_code"]}],"status":"OK"}',null);
        SingleRequestMock fakeDestinationCheck = new SingleRequestMock(200,'Complete','{ "destination_addresses" : [ "41633-41665 Eastman Dr, Murrieta, CA 92562, USA" ], "origin_addresses" : [ "41514 Cll Andalucia, Murrieta, CA 92562, USA" ], "rows" : [{ "elements" : [{ "distance" : {"text" : "18.4 mi","value" : 29583 }, "duration" : {"text" : "29 mins","value" : 1761 }, "status" : "OK"} ]} ], "status" : "OK"}',null);
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('http://maps.googleapis.com/maps/api/geocode/json?address=Afghanistan,92562&sensor=false',fakeZipCheck);
        endpoint2TestResp.put('http://maps.googleapis.com/maps/api/geocode/json?address=92562&sensor=false',fakeZipCheck2);
        endpoint2TestResp.put('https://maps.googleapis.com/maps/api/distancematrix/json?origins=33.5262326,-117.3381427&destinations=33.5295,-117.1800&mode=driving&language=en&units=imperial',fakeDestinationCheck);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        insert contact;
        List<Account> retAccount = createAccountRecords('Afghanistan', 1, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('Afghanistan', 1);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('Afghanistan', 1, retProduct);
        insert retProductMarket;
        List<Product_Catalogue__c> retProductCatalogue = createProductCatelogueRecords('Afghanistan', retProductMarket, retAccount);
        insert retProductCatalogue;
        List<Product_Catalogue__c> retProductCatalogue2 = createProductCatelogueRecords('Afghanistan', retProductMarket, retAccount);
        insert retProductCatalogue2;
        List<Country__c> dbCountryQuery = createCountryRecords('Afghanistan', retProductCatalogue);
        insert dbCountryQuery;
        Test.startTest();
        Map<String,Object> searchPartner5 = WhereToBuyController.searchPartner('92562', 'Afghanistan', 'Leisure', 'Marine Systems', retProduct[0].ID, '25', 'miles', 'WhereToBuy', 'California');
        Test.stopTest();
        System.assertEquals(3, searchPartner5.size());
    }
    
    public static TestMethod void DistanceWrapper_test(){
        List<DistanceWrapper> dwlist = new List<DistanceWrapper>();
        
        DistanceWrapper dw = new DistanceWrapper(new set<String>(),new Account(),null,'Advanced',true,false);
        dw.accountRecordType = 'Indirect Partner';
        dwlist.add(dw);
        
        DistanceWrapper dw2 = new DistanceWrapper(new set<String>(),new Account(),null,'Basic',true,false);
        dw2.accountRecordType = 'Direct Partner';
        dwlist.add(dw2);
        
        DistanceWrapper dw3 = new DistanceWrapper(new set<String>(),new Account(),null,'Master',true,false);
        dw3.accountRecordType = 'Direct Partner';
        dwlist.add(dw3);
        
        DistanceWrapper dw4 = new DistanceWrapper(new set<String>(),new Account(),null,'Master',true,false);
        dw4.accountRecordType = 'Direct Partner';
        dwlist.add(dw4);
        
        dwlist.sort();
        
        System.assertEquals('Master', dwlist[0].CSN);
        System.assertEquals('Basic', dwlist[2].CSN);
        
        WhereToBuyController.searchType = 'WhereToService';
        dwlist.sort();
        System.assertEquals('Direct Partner', dwlist[0].accountRecordType);
      
    }
    
}