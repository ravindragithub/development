@isTest 
private class TestDownloadDocumentCtrl {
    @isTest 
    static void unittest() {
        
        Prod_Documents__c pd1 = new Prod_Documents__c(Name = 'test', File_Access__c = 'Public', Display_Terms_and_Conditions_Page__c = true, Display_HTML_Page__c = true);
        insert pd1;
        Prod_Documents__c pd2 = new Prod_Documents__c(Name = 'test', File_Access__c = 'Public', Display_Terms_and_Conditions_Page__c = true, Display_HTML_Page__c = false);
        insert pd2;
        Prod_Documents__c pd3 = new Prod_Documents__c(Name = 'test', File_Access__c = 'Public', Display_Terms_and_Conditions_Page__c = false, Display_HTML_Page__c = true, Insertion_Code__c = '1235');
        insert pd3;
        Prod_Documents__c pd4 = new Prod_Documents__c(Name = 'test', File_Access__c = 'Public', Display_Terms_and_Conditions_Page__c = false, Display_HTML_Page__c = false, Insertion_Code__c = '1235');
        insert pd4;
        Prod_Documents__c pd5 = new Prod_Documents__c(Name = 'test', File_Access__c = 'Public', Display_Terms_and_Conditions_Page__c = false, Display_HTML_Page__c = false);
        insert pd5;
        
        Content_Type__c docType = new Content_Type__c(Product_Document__c = pd1.Id, Content_Main_Type__c = 'Advertising', Content_Sub_Type__c = 'FleetBroadband');
        insert docType;
        
       	DownloadDocumentCtrl ctrl1 = new DownloadDocumentCtrl(new Apexpages.Standardcontroller(pd1));
        PageReference pageref = ctrl1.cont();
        system.assertEquals(null, pageref);
		pageref = ctrl1.accept();        
        system.assertNOTEquals(null, pageref);
        
        DownloadDocumentCtrl ctrl2 = new DownloadDocumentCtrl(new Apexpages.Standardcontroller(pd2));
        pageref = ctrl2.cont();        
        system.assertEquals(null, pageref);
        pageref = ctrl2.accept();
        system.assertNOTEquals(null, pageref);
        
        DownloadDocumentCtrl ctrl3 = new DownloadDocumentCtrl(new Apexpages.Standardcontroller(pd3));
        pageref = ctrl3.cont();
		system.assertEquals(null, ctrl3.down);
        
        DownloadDocumentCtrl ctrl4 = new DownloadDocumentCtrl(new Apexpages.Standardcontroller(pd4));
        pageref = ctrl4.cont();
		system.assertNOTEquals(null, pageref);
        
        DownloadDocumentCtrl ctrl5 = new DownloadDocumentCtrl(new Apexpages.Standardcontroller(pd5));
        pageref = ctrl5.cont();
		system.assertNOTEquals(null, pageref);
    }
}