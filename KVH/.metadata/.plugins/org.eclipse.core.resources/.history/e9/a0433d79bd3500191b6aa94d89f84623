@IsTest
private class TestProductSearchClass {
    
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
        pd.File_Access__c = 'Public';
        pd.active__c = true;
        pd.Image_URL__c = 'https://test.com/test.pdf';
        pd.File_Extension__c = 'pdf';
        insert pd;
        
        Content_Type__c docType = PartnerCommunityTestData.createContentType('Advertising', pd.Id);
        insert docType ;
        
        Content_Type__c docType2 = PartnerCommunityTestData.createContentType('Brochures', pd.Id);
        insert docType2 ;
        
        Content_Type__c docType3 = new Content_Type__c (Product_Document__c = pd.Id, Content_Main_Type__c = 'Forms', Sales_Tool_Kit_s__c = 'OneCare Sales Toolkit');
        insert docType3 ;
        
        Content_Type__c docType4 = new Content_Type__c (Product_Document__c = pd.Id, Content_Main_Type__c = 'Videos', Sales_Tool_Kit_s__c = 'OneCare Sales Toolkit');
        insert docType4 ;
        
        Content_Type__c docType5 = new Content_Type__c (Product_Document__c = pd.Id, Content_Main_Type__c = 'Images', Content_Sub_Type__c = 'Main Image', Sales_Tool_Kit_s__c = 'OneCare Sales Toolkit');
        insert docType5 ;
        
        Prod_Doc_Library__c pdl = PartnerCommunityTestData.createProdDocLibrary(pms.Id,pd.Id);
        insert pdl;
        
        Prod_Doc_Library__c pdl2 = PartnerCommunityTestData.createProdDocLibrary(pms2.Id,pd.Id);
        insert pdl2;
        
        Quick_Link__c ql1 = new Quick_Link__c(Content_Type_s__c = 'Forms;', QuickLink_Label__c = 'Forms', Sales_Kit__c = true);
        Quick_Link__c ql2 = new Quick_Link__c(Content_Type_s__c = 'Forms;', QuickLink_Label__c = 'Forms', Sales_Kit__c = false);
        insert ql1;
        insert ql2;
        
    }
    @isTest static void buildquicklinkTest(){
        User u = [ SELECT Id, Portal_View__c FROM User WHERE Email = '123@123ANDtest.com'];
        system.runAs(u){
            Map<String,Object> objectMap = ProductSearchClass.quicklink('Forms', true);
            objectMap = QuickLinksController.quickLink('Forms', false);
            system.assertEquals(objectMap.size(), 2);
            objectMap = QuickLinksController.quickLink('Forms', true);
            system.assertEquals(objectMap.size(), 0);
        }
        
        
        ProductSearchClass.findIcon([Select id,Product_Document__r.Image_URL__c,Product_Document__r.File_Extension__c from Content_Type__c limit 1][0]);
        
    }
    @isTest static void quicklinkTest(){
        User u = [ SELECT Id, Portal_View__c FROM User WHERE Email = '123@123ANDtest.com'];
        u.Portal_View__c = '';
        update u;
        system.runAs(u){
            ProductSearchClass.portalChange('Leisure Marine Systems');
            u = [ SELECT Id, Portal_View__c FROM User WHERE Email = '123@123ANDtest.com'];
            system.assertEquals('Leisure Marine Systems', u.Portal_View__c);
            Map<String,Object> objectMap = ProductSearchClass.quicklink('Forms', true);
            system.assertEquals(objectMap.size(), 1);
            objectMap = ProductSearchClass.quicklink('Forms', false);
            system.assertEquals(objectMap.size(), 2);
            objectMap = QuickLinksController.buildQuickLink('Forms');
            system.assertEquals(objectMap.size(), 2);
        }
        
    }
    @isTest static void getProductTest(){
        User u = [ SELECT Id, Portal_View__c FROM User WHERE Email = '123@123ANDtest.com'];
        
        Product_Catalogue__c pcat = [SELECT Id FROM Product_Catalogue__c LIMIT 1];
        
        system.runAs(u) {
            
            Map<String,Object> getproduct = ProductSearchClass.getProducts('TracPhone 123',
                                                                           new List<String>{pcat.Id},
                                                                           new List<String>{'Advertising'});
            
            Map<String,Object> productDetail = ProductSearchClass.productDetail(pcat.Id);
            List<PartnerMainServiceWrapper> portalList = CommunityUtilityClass.constructTopOptions(
                'Commercial & OEM Maritime Systems',
                'Support Center-Support_Center__c;Partner Resources-Partner_Resources__c;Learning Center-Learning_Center__c');
            
            Map<String,Object> initViewTest = CommunityUtilityClass.initPortalView();
            List<PartnerAvailableServiceWrapper> availableServiceWrappers =
                CommunityUtilityClass.constructServices('Commercial & OEM Maritime Systems');
        }
    }
    
    @isTest static void communityUtilityClassTest(){
        User u = [ SELECT Id, Portal_View__c FROM User WHERE Email = '123@123ANDtest.com'];
        
        Contact con = [SELECT Id From Contact LIMIT 1];
        
        system.runAs(u) {
            
            List<PartnerMainServiceWrapper> portalList = CommunityUtilityClass.constructTopOptions(
                'Commercial & OEM Maritime Systems',
                'Support Center-Support_Center__c;Partner Resources-Partner_Resources__c;Learning Center-Learning_Center__c');
            
            Map<String,Object> initViewTest = CommunityUtilityClass.initPortalView();
            List<PartnerAvailableServiceWrapper> availableServiceWrappers =
                CommunityUtilityClass.constructServices('Commercial & OEM Maritime Systems');
            
            List<Quick_Link__c> quick_links = QuickLinksController.constructQuickLinks();
        }
    }
}