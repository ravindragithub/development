@isTest //(SeeAllData=true)
public class Test_RequestAQuoteClass {
    
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
                afghanAccount.Partner_Portal_Main_Contact__c = contact.id;
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
                usAccount.Partner_Portal_Main_Contact__c = contact.id;
                retAccount.add(usAccount);
            }
        }
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
                    afghanMarket.Product_Line__c = 'Satellite Television';
                    afghanMarket.Product_Series__c = 'HD-series';
                    afghanMarket.Product__c = pdct.Id;
                    retMarketSector.add(afghanMarket);
                }else if (country == 'United States'){
                    Product_Market_Sector__c usMarket = new Product_Market_Sector__c();
                    usMarket.Market__c = 'Leisure';
                    usMarket.Sector__c = 'Marine Systems';
                    usMarket.Product_Line__c = 'Satellite Television';
                    usMarket.Product_Series__c = 'HD-series';
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
                afghanProduct.Catalog_Display_Name__c = 'Test' + String.valueOf(count);
                retProduct.add(afghanProduct);
            }else if (country == 'United States'){
                Product2 usProduct = new Product2();
                usProduct.Name = 'TracVision HD11_';
                usProduct.Display_Product__c = 'Yes';
                usProduct.Catalog_Display_Name__c = 'Test' + String.valueOf(count);
                retProduct.add(usProduct);
            }
        }
        return retProduct;
    }
    
    

    public static TestMethod void testRequestAQuoteClass_getInformation(){
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        contact.MailingStreet = '13 Hall Ave';
        contact.MailingPostalcode = '02840';
        contact.MailingCountry = 'United States';
        contact.MailingCity = 'Newport';
        contact.MailingState = 'Rhode Island';
        insert contact;
        List<Account> retAccount = createAccountRecords('United States', 1, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('United States', 1);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('United States', 1, retProduct);
        insert retProductMarket;
        Map<String, Object> resultsMap = new Map<String, Object>();
        resultsMap.put('accountId', retAccount[0].Id);
        resultsMap.put('contactId', retAccount[0].Partner_Portal_Main_Contact__c);
        resultsMap.put('product', retProduct[0].Catalog_Display_Name__c);
        resultsMap.put('productLine', retProductMarket[0].Product_Line__c);
        resultsMap.put('productSeries', retProductMarket[0].Product_Series__c);
        resultsMap.put('market', retProductMarket[0].Market__c);
        resultsMap.put('sector', retProductMarket[0].Sector__c);
        resultsMap.put('accountName', retAccount[0].Name);
        resultsMap.put('accountStreet', retAccount[0].ShippingStreet);
        resultsMap.put('accountCity', retAccount[0].ShippingCity);
        resultsMap.put('accountState', retAccount[0].ShippingState);
        resultsMap.put('accountZip', retAccount[0].ShippingPostalcode);
        resultsMap.put('accountCountry', retAccount[0].ShippingCountry);
        
        Account insertAccount = new Account(name = 'test Account');
        insert insertAccount;
     
        DefaultAccounts__c insertSetting = new DefaultAccounts__c();
        //insertSetting.Account_ID__c = '001000000000000000';
        insertSetting.Account_ID__c = insertAccount.Id;
        insertSetting.Description__c = 'This is a list of Accounts used for special/default purposes. e.g. Activations in Progress, Default Assets, Replaced Assets....';
        insertSetting.Name = 'KVH_Official_Internal_Contacts';
        insert insertSetting;
        Map<String, Object> returnMap = RequestAQuoteClass.getInformation(retAccount[0].Id, retProduct[0].Id);
        System.assertEquals(resultsMap, returnMap);
    }
    
    

    public static TestMethod void testRequestAQuoteClass_getInformationDefaultAccount(){
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        contact.MailingStreet = '13 Hall Ave';
        contact.MailingPostalcode = '02840';
        contact.MailingCountry = 'United States';
        contact.MailingCity = 'Newport';
        contact.MailingState = 'Rhode Island';
        insert contact;
        List<Account> retAccount = createAccountRecords('United States', 1, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('United States', 1);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('United States', 1, retProduct);
        insert retProductMarket;
        Map<String, Object> resultsMap = new Map<String, Object>();
        resultsMap.put('accountId', retAccount[0].Id);
        resultsMap.put('contactId', retAccount[0].Partner_Portal_Main_Contact__c);
        resultsMap.put('product', retProduct[0].Catalog_Display_Name__c);
        resultsMap.put('productLine', retProductMarket[0].Product_Line__c);
        resultsMap.put('productSeries', retProductMarket[0].Product_Series__c);
        resultsMap.put('market', retProductMarket[0].Market__c);
        resultsMap.put('sector', retProductMarket[0].Sector__c);
        resultsMap.put('accountName', 'KVH Industries Inc.');
        resultsMap.put('accountStreet', retAccount[0].ShippingStreet);
        resultsMap.put('accountCity', retAccount[0].ShippingCity);
        resultsMap.put('accountState', retAccount[0].ShippingState);
        resultsMap.put('accountZip', retAccount[0].ShippingPostalcode);
        resultsMap.put('accountCountry', retAccount[0].ShippingCountry);
        
        DefaultAccounts__c insertSetting = new DefaultAccounts__c();
        //insertSetting.Account_ID__c = '001000000000000000';
        insertSetting.Account_ID__c = retAccount[0].Id;
        insertSetting.Description__c = 'This is a list of Accounts used for special/default purposes. e.g. Activations in Progress, Default Assets, Replaced Assets....';
        insertSetting.Name = 'KVH_Official_Internal_Contacts';
        insert insertSetting;
        Map<String, Object> returnMap = RequestAQuoteClass.getInformation(retAccount[0].Id, retProduct[0].Id);
        System.assertEquals(resultsMap, returnMap);
    }
    
    public static TestMethod void testRequestAQuoteClass_getInformationWithContact(){
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        contact.MailingStreet = '13 Hall Ave';
        contact.MailingPostalcode = '02840';
        contact.MailingCountry = 'United States';
        contact.MailingCity = 'Newport';
        contact.MailingState = 'Rhode Island';
        insert contact;
        List<Account> retAccount = createAccountRecords('United States', 1, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('United States', 1);
        insert retProduct;
        List<Product_Market_Sector__c> retProductMarket = createProductMarkterRecords('United States', 1, retProduct);
        insert retProductMarket;
        Map<String, Object> resultsMap = new Map<String, Object>();
        resultsMap.put('contactId', contact.Id);
        resultsMap.put('accountId', contact.AccountId);
        resultsMap.put('product', retProduct[0].Catalog_Display_Name__c); 
        resultsMap.put('productLine', retProductMarket[0].Product_Line__c);
        resultsMap.put('productSeries', retProductMarket[0].Product_Series__c);
        resultsMap.put('market', retProductMarket[0].Market__c);
        resultsMap.put('sector', retProductMarket[0].Sector__c);
        resultsMap.put('accountName', contact.FirstName + ' ' + contact.LastName);
        resultsMap.put('accountStreet', contact.MailingStreet);
        resultsMap.put('accountCity', contact.MailingCity);
        resultsMap.put('accountState', contact.MailingState);
        resultsMap.put('accountZip', contact.MailingPostalcode);
        resultsMap.put('accountCountry', contact.MailingCountry);
        Map<String, Object> returnMap = RequestAQuoteClass.getInformation(contact.Id, retProduct[0].Id);
        System.assertEquals(resultsMap, returnMap);
    }
    public static TestMethod void testRequestAQuoteClass_insertQuoteRequested(){
        Contact contact = new Contact();
        contact.FirstName = 'Ken';
        contact.LastName = 'Lowkey';
        contact.MailingStreet = '13 Hall Ave';
        contact.MailingPostalcode = '02840';
        contact.MailingCountry = 'United States';
        contact.MailingCity = 'Newport';
        contact.MailingState = 'Rhode Island';
        insert contact;
        List<Account> retAccount = createAccountRecords('United States', 1, contact);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('United States', 1);
        insert retProduct;
        String success = RequestAQuoteClass.insertQuoteRequested('Mr.', 'firstName', 'lastName', 'test@kvh.com', 'kvh', '4019009000', 'US', 'US-RI', 'comments', retProduct[0].Id, 'C100 Compass Engine', retAccount[0].Id, contact.Id, 'WhereToBuy', 'company','Military & Government','Fiber Optic Gyros, Inertial Navigation Systems & Compass Sensors');
        System.assertEquals(success, 'Success');
    }
}