@isTest 
global class TestGenerateAWSSignedURLBatch {
    global class MockHttpResponseSuccess  implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest req) {
           HttpResponse res = new HttpResponse();
           res.setHeader('Content-Type', 'application/json');
           res.setBody('{"foo":"bar"}');
           res.setStatusCode(200);
           return res;
        }
    }
    
    global class MockHttpResponseError  implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest req) {
           HttpResponse res = new HttpResponse();
           res.setHeader('Content-Type', 'text/xml');
           res.setBody('<Error>404</Error><Message>The specified key does not exist.</Message>');
           res.setStatusCode(404);
           return res;
        }
    }
   
    
    @isTest 
    static void unittest() {
        List<Api_Keys__c> keylst = new List<Api_Keys__c>();
        keylst.add(new Api_Keys__c(Name = 'Private',Bucket_Name__c='test',Client_Id__c='test',Client_Secret__c='test',Region__c='test'));
        keylst.add(new Api_Keys__c(Name = 'Public',Bucket_Name__c='test',Client_Id__c='test',Client_Secret__c='test',Region__c='test'));
        keylst.add(new Api_Keys__c(Name = 'S3DownloadUser_Private',Bucket_Name__c='test',Client_Id__c='test',Client_Secret__c='test',Region__c='test'));
        keylst.add(new Api_Keys__c(Name = 'S3FileDownloadUser_Public',Bucket_Name__c='test',Client_Id__c='test',Client_Secret__c='test',Region__c='test'));
        insert keylst;
        
        
        Prod_Documents__c doc = new Prod_Documents__c(Name = 'test.pdf',File_Extension__c = 'pdf',Hosting_URL__c = 'www.test.com',File_Access__c = 'Private');
        insert doc;
        
        Content_Type__c docType = new Content_Type__c(Product_Document__c = doc.Id, Content_Main_Type__c = 'Advertising');
        insert docType;
        
        Product2 pro = new Product2(Name = 'test product',Catalog_Display_Name__c = 'test');
        insert pro;
        
        Product_Market_Sector__c marketSecotr = new Product_Market_Sector__c(Product__c = pro.id,Name = 'test',Market__c = 'Leisure', Sector__c = 'Marine Systems',
                                    Portal_View__c = 'Commercial & OEM Maritime Systems');
        insert marketSecotr;
        
        AWSFileURLGenrationCtrl ctrl = new AWSFileURLGenrationCtrl(new Apexpages.standardsetcontroller(new List<Prod_Documents__c>{doc}));
        ctrl.startbatch();
        
        Apexpages.standardsetcontroller stdctrl = new Apexpages.standardsetcontroller(new List<Prod_Documents__c>());
        stdctrl.setSelected(new List<Prod_Documents__c>{doc});
        
        
        Test.setMock(HttpCalloutMock.class, new TestGenerateAWSSignedURLBatch.MockHttpResponseSuccess());
        ctrl = new AWSFileURLGenrationCtrl(stdctrl);
        ctrl.startbatch();
       

    }
    
     @isTest 
    static void unittest2() {
        List<Api_Keys__c> keylst = new List<Api_Keys__c>();
        keylst.add(new Api_Keys__c(Name = 'Private',Bucket_Name__c='test',Client_Id__c='test',Client_Secret__c='test',Region__c='test'));
        keylst.add(new Api_Keys__c(Name = 'Public',Bucket_Name__c='test',Client_Id__c='test',Client_Secret__c='test',Region__c='test'));
        keylst.add(new Api_Keys__c(Name = 'S3DownloadUser_Private',Bucket_Name__c='test',Client_Id__c='test',Client_Secret__c='test',Region__c='test'));
        keylst.add(new Api_Keys__c(Name = 'S3FileDownloadUser_Public',Bucket_Name__c='test',Client_Id__c='test',Client_Secret__c='test',Region__c='test'));
        insert keylst;
        
        Prod_Documents__c doc = new Prod_Documents__c(Name = 'test.pdf',File_Extension__c = 'pdf',Hosting_URL__c = 'www.test.com',File_Access__c = 'Private');
        insert doc;
        
        Content_Type__c docType = new Content_Type__c(Product_Document__c = doc.Id, Content_Main_Type__c = 'Advertising');
        insert docType;
        
        Product2 pro = new Product2(Name = 'test product',Catalog_Display_Name__c = 'test');
        insert pro;
        
        Product_Market_Sector__c marketSecotr = new Product_Market_Sector__c(Product__c = pro.id,Name = 'test',Market__c = 'Leisure', Sector__c = 'Marine Systems',
                                    Portal_View__c = 'Commercial & OEM Maritime Systems');
        insert marketSecotr;

        ApexPages.currentPage().getParameters().put('retURL','Home');
        
        AWSFileURLGenrationCtrl ctrl = new AWSFileURLGenrationCtrl(new Apexpages.standardsetcontroller(new List<Prod_Documents__c>{doc}));
        ctrl.startbatch();
        
        Apexpages.standardsetcontroller stdctrl = new Apexpages.standardsetcontroller(new List<Prod_Documents__c>());
        stdctrl.setSelected(new List<Prod_Documents__c>{doc});
        
       
        Test.setMock(HttpCalloutMock.class, new TestGenerateAWSSignedURLBatch.MockHttpResponseError());
        ctrl = new AWSFileURLGenrationCtrl(stdctrl);
        ctrl.startbatch();
        
        ctrl.redirectToListview();
    }
}