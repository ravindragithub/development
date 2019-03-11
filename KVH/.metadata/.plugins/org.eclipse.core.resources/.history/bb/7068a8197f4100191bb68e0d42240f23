@isTest 
private class TestRemoveDocumentController {
    @isTest
    static void unittest() {
        Security__c key = new Security__c();
        key.Name = 'PublicAWS';
        key.Bucket__c = 'partnerportal';
        key.Algorithm__c = '9383739849';
        insert key;
        
        Product2 pro = new Product2(Name = 'test product',Product_Series__c = 'mini-VSAT Broadband', Product_Line1__c = 'Mobile Communications', Catalog_Display_Name__c = 'test',Display_Product__c = 'Yes');
        insert pro;
        
        Product_Market_Sector__c pms = new Product_Market_Sector__c(Portal_View__c = 'Commercial & OEM Land Systems', Product__c = pro.Id);
        insert pms;
        
        Prod_Documents__c doc = new Prod_Documents__c(Name = 'Test.pdf',Hosting_URL__c = 'www.test.com',File_Access__c = 'Private');
        insert doc;
        
        Content_Type__c docType = new Content_Type__c(Content_Main_Type__c = 'Advertising', Content_Sub_Type__c = 'FleetBroadband', Product_Document__c = doc.Id);
        insert docType; 
        
        Prod_Doc_Library__c doclib = new Prod_Doc_Library__c(name = 'test',Filename__c = doc.Id, Product_Market_Sector__c = pms.Id);
        insert doclib;
        string s = '12345';
        Blob b = Blob.valueOf(s);
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = b;
        cv.Title = '123';
        cv.PathOnClient = '123';
        insert cv;
        
        RemoveDocumentController ctrl = new RemoveDocumentController();
        ctrl.productDocId = doc.id;
        ctrl.fetchProdDocumentObject();
        ctrl.saveRecords();
        Security__c keytest = RemoveDocumentController.fetchCredentials();
        system.assertEquals('PublicAWS', keytest.Name);
        RemoveDocumentController.deleteContent(cv.id);
        List <ContentVersion> cvs = [SELECT Id FROM ContentVersion WHERE Id =: cv.Id];
        system.assertEquals(cvs.size(), 0);
    }
}