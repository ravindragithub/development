@isTest
public class ThumbnailController_test {
    @isTest
	static void unittest() {
        Security__c key = new Security__c();
        key.Name = 'PublicAWS';
        key.Bucket__c = 'partnerportal';
        key.Algorithm__c = '9383739849';
        insert key;
        
        Prod_Documents__c doc = new Prod_Documents__c(Title_Display_Name__c = '123', Name = 'Test.pdf',Hosting_URL__c = 'www.test.com',File_Access__c = 'Public');
        insert doc;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(doc);
        ThumbnailController ctrl = new ThumbnailController(sc);
        Security__c keytest = ThumbnailController.fetchCredentials();
        system.assertEquals(keytest.Name, 'PublicAWS');

        ctrl.prodDoc = doc;
        ctrl.prodDoc.Image_URL__c = 'www.google.com';
        ctrl.updateDoc();
        
        ctrl.productDocId = doc.Id;
		ctrl.fetchProdDocumentObject();
        system.assertEquals(ctrl.productDocId, null);
        
        PageReference pageref = ctrl.gotonew();
        system.assertEquals(pageref.getUrl().right(4), 'page');

        
    }
}