@isTest 
public class Test_DistanceWrapper {
    public static List<Account> createAccountRecords(String country, Integer count){
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
        retAccount.add(KVHAccount);
        return retAccount;
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
    
    public static TestMethod void testCompareTo_DistanceWrapper(){
        List<Account> retAccount = createAccountRecords('United States', 25);
        insert retAccount;
        List<Product2> retProduct = createProduct2Records('United States', 25);
        insert retProduct;
        List<DistanceWrapper> dw = new List<DistanceWrapper>();
        List<Integer> ints = new List<Integer>();
        for (Account acct : retAccount){
            for (Product2 prod : retProduct){
                Double dbRnd = Math.random() * 100;
                Integer t = (Integer) dbRnd;
                ints.add(t);
                DistanceWrapper testingVar = new DistanceWrapper();
                testingVar.srnumber = t;
                testingVar.productId = new Set<String> {prod.id};
                testingVar.account = acct;
                testingVar.accountId = acct.id;
                testingVar.durationInSeconds = t;
                testingVar.distance = '5';
                testingVar.duration = '25';
                testingVar.desination = 'RI';
                testingVar.CSN = 'Basic';
                testingVar.Sales = true;
                testingVar.ServicesOnly = true;
                dw.add(testingVar);
            }
        }
        dw.sort();
        System.assertEquals(650, dw.size());
    }
}