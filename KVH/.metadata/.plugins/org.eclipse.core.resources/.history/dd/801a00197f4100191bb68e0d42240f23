/*********************************************************
    Name            :    TestDataFactory
    Description     :    Utitility class for creating test data in test class
*********************************************************/
@isTest
public class TestDataFactory {         
    private static final Id DIRECTPARTNER_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Partner').getRecordTypeId();
    private static final Id INDIRECTPARTNER_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Partner').getRecordTypeId();
    private static final Id DIRECTCUSTRECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    private static final Id CC_RECORD_TYPE_ID = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
    
    public static List<Account> createAccountRecords(Integer count, Contact contact, String recordTypename,
                                                    boolean service,Boolean sales,String partnerRole,String baancusterId,
                                                    Account parent,String sitecodeId){
        List<Account> retAccount = new List<Account>();
        for (Integer i = 0; i < count; i++){
            Account acc = new Account();
            acc.Name = String.valueOf(i) + 'Seawide ' + partnerRole + ' Marine Demo ';            
            acc.Info_Only__c = false;
            acc.ShippingCity = 'Middletown';            
            acc.ShippingState = 'Rhode Island';
            acc.ShippingPostalCode = '02842';
            acc.ShippingCountry = 'United States';
            acc.ShippingStreet = '50 Enterprise Center';
            acc.ShippingLatitude = 41.5218;
            acc.ShippingLongitude = -71.2912;
            acc.Account_Status__c = 'Active';
            acc.Partner_Portal_Phone__c = '4010001000';
            acc.Partner_Portal_Email__c = 'test@gmail.com';
            acc.Display_on_Where_to_Get_Service__c = service;
            acc.Display_on_Where_to_Buy__c = sales;
            acc.Partner_Role__c = partnerRole;
            //acc.Partner_Role_Display_Name__c = partnerRole;
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypename).getRecordTypeId();
            acc.Baan_Customer_ID__c = baancusterId;
            if(parent != null){
                acc.ParentId = parent.Id;                
            }
            acc.Sitecore_Company_ID__c = sitecodeId;
            acc.Approved_Partner_by_Service__c = 'Yes';
            acc.Approved_Partner_by_Sales__c = 'Yes';
            retAccount.add(acc);
        }
        return retAccount;
    }
    
    public static Contact createContactRecords(String firstname, String lastnamed, String email){
        Contact contact = new Contact();
        contact.FirstName = firstname;
        contact.LastName = lastnamed;
        contact.MailingCity = 'Middletown';
        contact.MailingState = 'Rhode Island';
        contact.MailingPostalCode = '02842';
        contact.MailingCountry = 'United States';
        contact.MailingLatitude = 41.5218;
        contact.MailingLongitude = -71.2912;
        contact.MailingStreet = '41698 Eastman Drive';
        contact.Partner_Portal_Email__c = email;
        contact.Partner_Portal_Phone__c = '4018350422';
        contact.email = email;
        return contact;
    }
    
    public static Account createDefaultKCHAccountRecords(Contact con){
        Account KVHAccount = new Account();
        KVHAccount.Name = 'KVH Industries';        
        KVHAccount.ShippingCity = 'Middletown';
        KVHAccount.Website = '';
        KVHAccount.ShippingState = 'RI';
        KVHAccount.ShippingPostalCode = '02842';
        KVHAccount.ShippingCountry = 'United States';
        KVHAccount.ShippingStreet = '50 Enterprise Center';
        KVHAccount.Partner_Role__c = 'Representative';
        KVHAccount.Partner_Portal_Phone__c = '4010001000';
        KVHAccount.Partner_Portal_Email__c = 'test@gmail.com';
        KVHAccount.Partner_Portal_Main_Contact__c = con.id;
        insert KVHAccount;
        
        DefaultAccounts__c insertSetting = new DefaultAccounts__c();        
        insertSetting.Account_ID__c = KVHAccount.Id;
        insertSetting.Description__c = 'This is a list of Accounts used for special/default purposes. e.g. Activations in Progress, Default Assets, Replaced Assets....';
        insertSetting.Name = 'KVH_Official_Internal_Contacts';
        insert insertSetting;
        return KVHAccount;
    }
    
    public static List<Product_Market_Sector__c> createProductMarkterRecords(String portalview,String country, String market,String sector,
                                                                    Integer count, List<Product2> retProduct,
                                                                    Map<String,Decimal> externalIdMap){
        system.debug('@@ externalIdMap==>'+externalIdMap);
        system.debug('@@ retProduct==>'+retProduct);
        List<Product_Market_Sector__c> retMarketSector = new List<Product_Market_Sector__c>();
        for (Product2 pdct: retProduct){
            for (Integer i = 0; i < count; i++){
                Product_Market_Sector__c marketObj = new Product_Market_Sector__c();
                marketObj.Market__c = market;
                marketObj.Sector__c = sector;  
                marketObj.Portal_View__c = portalview;                  
                marketObj.Product__c = pdct.Id;
                if(externalIdMap.containskey(pdct.Id+portalview)){
                    marketObj.External_ProductID__c = externalIdMap.get(pdct.Id+portalview);
                }                    
                retMarketSector.add(marketObj);
               
            }
        }
        return retMarketSector;
    }
    
    public static List<Product2> createProduct2Records(String productname,String country, Integer count,String productLine,String productSeries){
        List<Product2> retProduct = new List<Product2>();
        for (Integer i = 0; i < count; i++){
            Product2 productObj = new Product2();
            productObj.Name = productname + '_' + country + '_'+i;
            productObj.Display_Product__c = 'Yes';
            productObj.Product_Line1__c = productLine;
            productObj.Product_Series__c = productSeries;
            retProduct.add(productObj);
        }
        return retProduct;
    }
    
    public static List<Product_Catalogue__c> createProductCatalogueRecords(String csnLevel,Boolean sales,Boolean service,
                                                                 List<Product_Market_Sector__c> retMarketSector,
                                                                  List<Account> retAccount){
        List<Product_Catalogue__c> retProduct = new List<Product_Catalogue__c>();
        for (Product_Market_Sector__c mktSct: retMarketSector){
            for (Account acct: retAccount){
                Product_Catalogue__c pc = new Product_Catalogue__c();
                pc.Product_Market_Sector__c = mktSct.Id;
                pc.Partner_Account__c = acct.Id;
                pc.Sales__c = sales;
                pc.CSN__c = true; 
                pc.Services_Only__c = service;
                pc.CSN_Level__c = csnLevel;
                retProduct.add(pc);
            }
        }
        return retProduct;
    }
    
    public static List<Country__c> createSalesServiceRegionRecords(String country,String state, List<Product_Catalogue__c> retProduct,Sales_Representative__c salesRep){
        List<Country__c> retCountry = new List<Country__c>();
        for (Product_Catalogue__c prdCtlg: retProduct){
            Country__c region = new Country__c();
            region.Country__c = country;
            region.State__c = state;
            region.Product_Catalog__c = prdCtlg.Id;
            if(salesRep != null)
                region.Sales_Representative__c = salesRep.Id;
            retCountry.add(region);
        }
        return retCountry;
    }    
    
    public static Sales_Representative__c createSalesRepresentativeRecord(Contact con,String repType){
        Sales_Representative__c rep = new Sales_Representative__c();
        rep.Sales_Rep_Contact__c = con.Id;
        rep.Representative_Type__c = repType;
        insert rep;
        return rep;
    } 
    
      public static List<Account> createAccount(Integer numAccts, String recordType) {
        List<Account> accts = new List<Account>();
        
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='estAcc' + i );
            if(recordType == 'Direct Partner'){
                a.RecordTypeId = DIRECTPARTNER_RECORD_TYPE_ID;
            }
            Else if(recordType == 'Indirect Partner'){
                a.RecordTypeId = INDIRECTPARTNER_RECORD_TYPE_ID;
            }
            else if(recordType == 'Direct Customer' ){
                a.RecordTypeId = DIRECTCUSTRECORD_TYPE_ID;
            }
            else{
                a.RecordTypeId = INDIRECTPARTNER_RECORD_TYPE_ID;
            }    
            
            a.Partner_Role__c = 'Dealer';
            a.KVH_Sales_Office__c = 'KU Satcom';
            a.Account_Status__c = 'Active';
            a.Market__c = 'Leisure';
            a.Market_Sector__c = 'Marine';
            a.Custom_Call_Acct_ID__c = String.valueOf(54321 + i);
            a.Account_Effective_Date__c = Date.newInstance(2016, 12, 9);
            a.Revenue_Category__c = 'VSAT';
            
            accts.add(a);
        }
        insert accts;
        
        system.assertEquals(numAccts, accts.size());
        return accts;
        
    }
    public static List<Order_Line_Delivery__c> createSalesOrder(integer num) {
        List<Order_Line_Delivery__c> salesOrderDeliveryList = new List<Order_Line_Delivery__c>();
        List<Order_Line__c> orderLineList = new List<Order_Line__c>();
        List<Sales_Order__c> ordersList = new List<Sales_Order__c>();
        
        
        //please look at https://salesforce.stackexchange.com/questions/160434/accessing-the-parent-sobject-from-the-child-sobject on the master detail of the sales order. also saved on computer
        
        for(Integer i=0 ; i<num ;i++) {
            Sales_Order__c order = new Sales_Order__c(Name='TestOrder ' + i, Is_AgilePlans_Order__c = TRUE);
            order.Is_AgilePlans_Order__c =TRUE;
            ordersList.add(order);
        }
        insert ordersList;
        
        
        for(Integer i=0 ; i<num ;i++) {
            Order_Line__c orderLine = new Order_Line__c(Name='TestOrderLine ' + i, Sales_Order__c = ordersList[i].Id, Sales_Order__r = ordersList[i]);
            orderLineList.add(orderLine);
        }
        insert orderLineList;
        system.debug('');
        
        
        for(Integer i=0 ; i<num ;i++) {
            Order_Line_Delivery__c orderLineDelivery = new Order_Line_Delivery__c(Name='TestOrderDelivery ' + i, Order_Line__c = orderLineList[i].Id, Order_Line__r = orderLineList[i]);
            salesOrderDeliveryList.add(orderLineDelivery); 
        }
        
                
        insert salesOrderDeliveryList;
        system.debug('Salesorder = ' + ordersList[0]);
        system.debug('Salesorderline = ' + orderLineList[0]);
        system.debug('Salesorderlinedelive = ' + salesOrderDeliveryList[0]);
        system.debug('Salesorderlinedelive id = ' + salesOrderDeliveryList[0].order_line__r.sales_order__r.id);
        system.debug('Salesorder id = ' + salesOrderDeliveryList[0].order_line__r.sales_order__r.Is_AgilePlans_Order__c);
        
        
        system.assertEquals(num, salesOrderDeliveryList.size());
        
        return salesOrderDeliveryList;
        
    }
    
    public static List<billing_Account__c> createCCBillingAccount(Integer num) {
        List<billing_Account__c> billingAcctsList = new List<billing_Account__c>();
        List<Account> accList = new List<Account>();
        
        
        integer num1 = 12345; 
        for(Integer i=0; i<num;i++) {
            Account a = new Account(RecordTypeId = DIRECTPARTNER_RECORD_TYPE_ID , Name='estAcc' + i ,Partner_Role__c = 'Dealer', KVH_Sales_Office__c = 'KU Satcom', Account_Status__c = 'Active', Market__c = 'Leisure', Market_Sector__c = 'Marine', Custom_Call_Acct_ID__c = String.valueOf(num1 + i), Account_Effective_Date__c = Date.newInstance(2016, 12, 9), Revenue_Category__c = 'VSAT');
            accList.add(a);  
        }  
        
        insert accList;
        
        for (Billing_Account__c b : [SELECT Id, Account__r.Custom_Call_Acct_ID__c, Account__r.Name,  Name, Agile_In_Billing__c, Billing_Account_ID__c, Account_Effective_Date__c, Account__c, Revenue_Category__c FROM Billing_Account__c WHERE Account__r.Id IN: accList]) {
            billingAcctsList.add(b);  
        }
        
        system.debug('Billing Account  = ' + billingAcctsList[0]);
        system.debug(' account = ' + accList[0]);
        system.debug('Billing_Account_ID__c = ' + billingAcctsList[0].Billing_Account_ID__c);
        system.debug('Account__c = ' + billingAcctsList[0].Account__c);
        system.debug('Account__r.Custom_Call_Acct_ID__c = ' + billingAcctsList[0].Account__r.Custom_Call_Acct_ID__c);  
        system.assertEquals(num, billingAcctsList.size());
        
        return billingAcctsList;
        
    }
    public static List<Asset> createAsset(Integer num) {
        List<Asset> assetList = new List<Asset>();
        
        for(Integer i=0 ; i<num ;i++) {
            Asset a = new Asset();
            a.Name = String.valueOf('Tesst_12' + i);
            a.SerialNumber = String.valueOf('12' + i);
            
            assetList.add(a);
        }
        insert assetList;
        system.assertEquals(num, assetList.size());
        return assetList;
    }
    
    static testMethod void testMethod1() {
        Test.startTest();
        TestDataFactory.createSalesOrder(1); 
        TestDataFactory.createCCBillingAccount(1); 
        Test.stopTest();
        
    }
    
}