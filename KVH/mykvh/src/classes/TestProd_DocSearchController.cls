@isTest 
private class TestProd_DocSearchController {
    @isTest 
    static void unittest() {
       List<Api_Keys__c> keylst = new List<Api_Keys__c>();
       keylst.add(new Api_Keys__c(Name = 'Private',Bucket_Name__c='test',Client_Id__c='test',Client_Secret__c='test',Region__c='test'));
       keylst.add(new Api_Keys__c(Name = 'Public',Bucket_Name__c='test',Client_Id__c='test',Client_Secret__c='test',Region__c='test'));
       keylst.add(new Api_Keys__c(Name = 'S3DownloadUser_Private',Bucket_Name__c='test',Client_Id__c='test',Client_Secret__c='test',Region__c='test'));
       keylst.add(new Api_Keys__c(Name = 'S3FileDownloadUser_Public',Bucket_Name__c='test',Client_Id__c='test',Client_Secret__c='test',Region__c='test'));
       insert keylst;
       
        Prod_Documents__c doc = new Prod_Documents__c(Name = 'Test.pdf',Hosting_URL__c = 'www.test.com',File_Access__c = 'Private');
       insert doc;
        
        Content_Type__c docType = new Content_Type__c(Content_Main_Type__c = 'Advertising', Content_Sub_Type__c = 'FleetBroadband', Product_Document__c = doc.Id);
        insert docType;
        
        Product2 pro = new Product2(Name = 'test product',Product_Series__c = 'mini-VSAT Broadband', Product_Line1__c = 'Mobile Communications', Catalog_Display_Name__c = 'test',Display_Product__c = 'Yes');
        insert pro;
           
        Product_Market_Sector__c pms = new Product_Market_Sector__c(Portal_View__c = 'Commercial & OEM Land Systems', Product__c = pro.Id);
       insert pms;
 
       Prod_Doc_Library__c doclib = new Prod_Doc_Library__c(name = 'test',Filename__c = doc.Id, Product_Market_Sector__c = pms.Id);
       insert doclib;
        apexpages.currentpage().getparameters().put('term','test');
        Prod_DocSearchController ctrl = new Prod_DocSearchController();
        ctrl.getProdDocuments();
        ctrl.getContentFiles();
        ctrl.getContentLinks();
    }
}