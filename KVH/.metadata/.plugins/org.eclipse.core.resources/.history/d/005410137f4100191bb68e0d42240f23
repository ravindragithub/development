@IsTest 
private class SalesAidsControllerTest {
    
    @testSetup static void setupData() {
        
        Account acc = PartnerCommunityTestData.createAccount('PartnerCommS1E2');
        insert acc;
        Contact con = PartnerCommunityTestData.createContact(acc.Id);
        insert con;
        
        User admin = [SELECT Id FROM User WHERE isActive = true AND Profile.Name = 'System Administrator' LIMIT 1];
        
        system.runAs(admin){
            User u = PartnerCommunityTestData.createPartnerUser('Partner-Dealer', '123@123ANDtest.com');
            u.ContactId = con.Id;
            u.Portal_View__c = 'Leisure Marine Systems';
            insert u;
        }
        
        Product2 product = PartnerCommunityTestData.ceateProduct('V7IP W/ICM ANTENNA W/LABELS');
        insert product;
        
        
        Product_Market_Sector__c pms = PartnerCommunityTestData.createProductMarketSector(product.Id);
        insert pms;
        
        Product_Market_Sector__c pms2 = new Product_Market_Sector__c();
        pms2.Product__c = product.Id;
        pms2.Market__c = 'Leisure';
        pms2.Sector__c = 'Marine Systems';
        pms2.Sales_Tool_Kit_s__c = 'OneCare Sales Toolkit';
        pms2.Portal_View__c = 'Leisure Marine Systems';
        insert pms2;
        
        List<Product_Catalogue__c> pcList = new List<Product_Catalogue__c>();
        Product_Catalogue__c pc = PartnerCommunityTestData.createProductCatalogue(acc.Id, pms.Id);
        Product_Catalogue__c pc2 = PartnerCommunityTestData.createProductCatalogue(acc.Id, pms2.Id);
        pcList.add(pc);
        pcList.add(pc2);
        insert pcList;
        
        DocumentIconMapping__mdt dim = [SELECT MasterLabel, Lightning_Icon_Name__c
                                        FROM DocumentIconMapping__mdt LIMIT 1];
        
        Prod_Documents__c pd = PartnerCommunityTestData.createProdDocuments(dim.MasterLabel);
        pd.Partner_Portal__c = true;
        pd.Sales_Aid__c = true;
        pd.File_Access__c = 'Public';
        pd.Active__c = true;
        pd.Partner_Portal__c = true;
        insert pd;
        
        Content_Type__c docType = PartnerCommunityTestData.createContentType('Advertising', pd.Id);
        insert docType ;
        
        Content_Type__c docType2 = PartnerCommunityTestData.createContentType('Brochures', pd.Id);
        insert docType2 ;
        
      
        
        Prod_Doc_Library__c pdl = PartnerCommunityTestData.createProdDocLibrary(pms.Id,pd.Id);
        insert pdl;
        
        Prod_Doc_Library__c pdl2 = PartnerCommunityTestData.createProdDocLibrary(pms2.Id,pd.Id);
        insert pdl2;
       
    }
    @isTest static void unittest(){
         User u = [ SELECT Id, Portal_View__c FROM User WHERE Email = '123@123ANDtest.com'];
         system.runAs(u){
             String productId = [Select id from Product2 where name = 'V7IP W/ICM ANTENNA W/LABELS' limit 1][0].ID;
             Prod_Documents__c pd = [Select id from Prod_Documents__c limit 1];
             SalesAidsController.SalesAidsDocuments salesAidsDocmentSObj = SalesAidsController.fetchSalesAids('',new List<String>{productId },new List<String>{'Advertising'});
             for(String key : salesAidsDocmentSObj.salesAidsMap.keyset()){
                 SalesAidsController.addToCart(JSON.serialize(salesAidsDocmentSObj.salesAidsMap.get(key)));
             }
             
             SalesAidsCartController.SalesAidsCartWrapper cartObj = SalesAidsCartController.getSaleAidsCart();
             SalesAidsCartController.updateLineItem(JSON.serialize(cartObj.lineItems[0]),JSON.serialize(cartObj));
             SalesAidsCartController.submitOrder(JSON.serialize(cartObj));
             SalesAidsCartController.deleteLineItem(cartObj.lineItems[0].id,JSON.serialize(cartObj));
             SalesAidsController.fetchOrderLine(pd.Id);
         }
    }
}