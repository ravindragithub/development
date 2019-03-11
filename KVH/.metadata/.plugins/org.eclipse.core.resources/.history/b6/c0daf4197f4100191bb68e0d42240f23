@isTest 
private class TestUploadDocumentsController {
    @isTest 
    static void unittest() {
        Security__c key = new Security__c();
        key.Name = 'PublicAWS';
        key.Bucket__c = 'partnerportal';
        key.Algorithm__c = '9383739849';
        insert key;
        
        Prod_Documents__c doc = new Prod_Documents__c(Title_Display_Name__c = '123', Name = 'Test.pdf',Hosting_URL__c = 'www.test.com',File_Access__c = 'Public');
        insert doc;

        Content_Type__c docType = new Content_Type__c(Content_Main_Type__c = 'Advertising', Content_Sub_Type__c = 'FleetBroadband');
        
        Product2 pro = new Product2(Name = 'test product',Product_Series__c = 'mini-VSAT Broadband', Product_Line1__c = 'Mobile Communications', Catalog_Display_Name__c = 'test',Display_Product__c = 'Yes');
        insert pro;
        
        Product_Market_Sector__c marketSector = new Product_Market_Sector__c(Product__c = pro.id,Market__c = 'Leisure', Sector__c = 'Marine Systems',
                                                                             Portal_View__c = 'Leisure Marine Systems');
        insert marketSector;
        
        Content_Type__c ct = new Content_Type__c(Content_Main_Type__c = 'Advertising', Product_Document__c = doc.Id);
        insert ct;
        
        Prod_Doc_Library__c pdl = new Prod_Doc_Library__c(Filename__c = doc.Id,Product_Market_Sector__c = marketSector.Id );
        insert pdl;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(doc);
        UploadDocumentsController ctrl = new UploadDocumentsController(sc);
        Security__c keytest = UploadDocumentsController.fetchCredentials();
        system.assertEquals(keytest.Name, 'PublicAWS');
        ctrl.market = 'Leisure';
        ctrl.sector = 'Marine Systems';
        ctrl.productline = 'Satellite Communications';
        ctrl.productseries = 'mini-VSAT Broadband';
        SelectOption so = new SelectOption(pro.Catalog_Display_Name__c, pro.Catalog_Display_Name__c);
        ctrl.productrightOptions.add(so);
        ctrl.rightOptions.add(new SelectOption('Leisure Marine Systems','Leisure Marine Systems'));
        ctrl.fetchProducts();
        ctrl.prodDocLib = new Prod_Doc_Library__c();
        ctrl.prodDoc = doc;
        ctrl.prod = pro;
        ctrl.prodDoc.Hosting_URL__c = 'www.google.com';
        ctrl.prodDocLib.Product_Market_Sector__c = marketSector.Id;
        ctrl.updateDoc();
        ctrl.productrightOptions.add(new SelectOption(pro.Id,pro.name));
        ctrl.addCount = 1;
        ctrl.addRow();
        system.assertEquals(ctrl.wrappers.size(), 2);
        ctrl.toDelIdent = 1;
        ctrl.delWrapper();
        system.assertEquals(ctrl.wrappers.size(), 1);
        UploadDocumentsController.ContentWrapper cw = new UploadDocumentsController.ContentWrapper(1);
        doctype.Content_Main_Type__c = 'Advertising';
        cw.ct = doctype;
        ctrl.wrappers.add(cw);
        Content_Type__c ct2 = new Content_Type__c(Content_Main_Type__c = 'Forms');
        cw.ct = ct2;
        ctrl.wrappers.add(cw);
        ctrl.saveAllRecords();
        List <Content_Type__c> cts = [SELECT Id FROM Content_Type__c];
        system.assertEquals(cts.size(), 1);
        PageReference pageref = ctrl.gotonew();
        ctrl.fetchProdDocumentObject();
        List <Prod_Doc_Library__c> pdls = [SELECT Id FROM Prod_Doc_Library__c WHERE Filename__c =: doc.id];
        system.assertEquals(pdls.size(), 2);
        ctrl.libs = pdls;
        ctrl.deleteoldlibraries();
        pdls = [SELECT Id FROM Prod_Doc_Library__c WHERE Filename__c =: doc.id];
        system.assertEquals(pdls.size(), 1);
        
    }
    @isTest
    static void unittest2() {
        Prod_Documents__c doc2 = new Prod_Documents__c(Name = '', Title_Display_Name__c = '456',Hosting_URL__c = 'www.test.com',File_Access__c = 'Private');
        ApexPages.StandardController sc2 = new ApexPages.StandardController(doc2);
        UploadDocumentsController ctrl2 = new UploadDocumentsController(sc2);
        ctrl2.createPD();
        ctrl2.setpdid(doc2.Id);
        Id docId = ctrl2.getpdid();
        String fileName = '123file';
        Blob fileBlob = Blob.valueOf(fileName);
        String encodeString = EncodingUtil.base64Encode(fileBlob);
        String s = UploadDocumentsController.createContent(fileName, encodeString, 'contentType', null, docId);
        system.assertEquals('success', s);

        
        
    }
}