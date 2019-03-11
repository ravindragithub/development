@isTest 
private class TestUpdateDocumentController {
    @isTest 
    static void unittest() {
        Security__c key = new Security__c();
        key.Name = 'PublicAWS';
        key.Bucket__c = 'partnerportal';
        key.Algorithm__c = '9383739849';
        insert key;
        
        Prod_Documents__c doc = new Prod_Documents__c(Name = 'Test.pdf',Hosting_URL__c = 'www.test.com',File_Access__c = 'Private');
        insert doc;
        
        string str = '1234';
        Blob bl = Blob.valueOf(str);
        String enStr = EncodingUtil.base64Encode(bl);
        
        //ContentWorkspace lib = [SELECT Id FROM ContentWorkspace WHERE Name = 'Partner Portal Private'];
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = EncodingUtil.base64Decode(enStr);
        cv.Title = str;
        cv.PathOnClient = str;
        //cv.FirstPublishLocationId = lib.Id;
        
        insert cv;
        
        Prod_Documents__c doc2 = new Prod_Documents__c(Name = 'Test.pdf',Hosting_URL__c = 'www.test.com',File_Access__c = 'Private', Internal_Document_Record__c = cv.Id);
        insert doc2;
        
        Content_Type__c docType = new Content_Type__c(Content_Main_Type__c = 'Advertising', Content_Sub_Type__c = 'FleetBroadband', Product_Document__c = doc.Id);
        insert docType;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(doc2);
        UpdateDocumentController ctrl = new UpdateDocumentController(sc);
        ctrl.productDocId = doc.id;
        ctrl.fetchProdDocumentObject();
        ctrl.saveRecords();
        UpdateDocumentController.fetchCredentials();
        
        ctrl = new UpdateDocumentController(sc);
        ctrl.productDocId = doc.id;
        ctrl.fetchProdDocumentObject();
        ctrl.deleteDocument = true;
        ctrl.saveRecords();
        ctrl.addRow();
        ctrl.delWrapper();
        ctrl.updateConLink();
        Id docId = doc2.Id;
        String fileName = '123file';
        Blob fileBlob = Blob.valueOf(fileName);
        String encodeString = EncodingUtil.base64Encode(fileBlob);
        UpdateDocumentController.updatecontent(fileName, encodeString, null, docId);
        
    }
}