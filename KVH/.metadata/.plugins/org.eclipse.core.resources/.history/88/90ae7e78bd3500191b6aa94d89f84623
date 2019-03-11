@IsTest
private class TestCourseProgressTrigger {
    
    @testSetup static void setupData() {
        
        Account acc = PartnerCommunityTestData.createAccount('PartnerCommS1E2');
        insert acc;
        Contact con = PartnerCommunityTestData.createContact(acc.Id);
        insert con;
        
        skilljar__Student__c std = new skilljar__Student__c();
        std.name = con.lastname;
        std.skilljar__Email__c = 'test@tt.com';
        std.skilljar__Obfuscated_Id__c = '123456';
        std.skilljar__Contact__c = con.Id;
        insert std;
        
        skilljar__Published_Course__c course = new skilljar__Published_Course__c();
        course.skilljar__Course_Title__c = 'Test Course';
        course.skilljar__Domain__c = 'kvh.skilljar.com';
        course.skilljar__Course_URL__c = 'http://kvh.skilljar.com/tracphone-v11-ip';
        course.skilljar__Obfuscated_Id__c = '123';
        course.Name = 'Testing course';
        course.skilljar__Lesson_Count__c = 1;
        insert course;
        
        skilljar__Course_Progress__c coursePro = new skilljar__Course_Progress__c();
        coursePro.Name = 'Testing cour';
        coursePro.skilljar__Student__c = std.Id;        
        coursePro.skilljar__Published_Course__c = course.Id;
        coursePro.skilljar__Obfuscated_Id__c = '123';      
        coursePro.skilljar__Contact__c = con.Id; 
        insert coursePro;
        
  
        Product2 product = PartnerCommunityTestData.ceateProduct('V7IP W/ICM ANTENNA W/LABELS');
        product.Master_Certification_Course__c = course.Id;
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
        
   }
   
   @isTest static void unittest(){
       skilljar__Course_Progress__c coursePro = [Select id,skilljar__Completed_At__c  from skilljar__Course_Progress__c limit 1];
       coursePro.skilljar__Completed_At__c = System.now();
       update coursePro;
       
       for(Product_Catalogue__c pc : [Select id,CSN_Level__c from Product_Catalogue__c]){
           System.assertEquals(pc.CSN_Level__c,'Master');
       }
       
       
   }
   
    @isTest static void unittest2(){
       skilljar__Published_Course__c course = [Select id from skilljar__Published_Course__c limit 1];
       Product2 product = [Select id,Master_Certification_Course__c,Advanced_Certification_Course__c from Product2 where name = 'V7IP W/ICM ANTENNA W/LABELS' limit 1];
       product.Advanced_Certification_Course__c = course.Id;
       product.Master_Certification_Course__c = null;
       update product;
       
       skilljar__Course_Progress__c coursePro = [Select id,skilljar__Completed_At__c  from skilljar__Course_Progress__c limit 1];
       coursePro.skilljar__Completed_At__c = System.now();
        
       update coursePro;
       
       for(Product_Catalogue__c pc : [Select id,CSN_Level__c from Product_Catalogue__c]){
           System.assertEquals(pc.CSN_Level__c,'Advanced');
       }
   }
   
    @isTest static void unittest3(){
       
       skilljar__Published_Course__c course = [Select id from skilljar__Published_Course__c limit 1];
       Product2 product = [Select id,Master_Certification_Course__c,Related_Certification_Course__c from Product2 where name = 'V7IP W/ICM ANTENNA W/LABELS' limit 1];
       product.Related_Certification_Course__c = course.Id;
       product.Master_Certification_Course__c = null;
       update product;
       
       skilljar__Course_Progress__c coursePro = [Select id,skilljar__Completed_At__c  from skilljar__Course_Progress__c limit 1];
       coursePro.skilljar__Completed_At__c = System.now();
        
       update coursePro;
       
       for(Product_Catalogue__c pc : [Select id,CSN_Level__c from Product_Catalogue__c]){
           System.assertEquals(pc.CSN_Level__c,'Basic');
       }
   }
}