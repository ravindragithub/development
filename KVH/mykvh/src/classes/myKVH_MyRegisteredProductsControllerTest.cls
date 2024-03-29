/*******************************************************************
    Name        :    myKVH_MyRegisteredProductsController_Test 
    Description :    Test class for myKVH_MyRegisteredProductsController
********************************************************************/
@isTest
private class myKVH_MyRegisteredProductsControllerTest {
  @testSetup
  static void setupTestData(){
      Account acc = new Account(name = 'Parent Account');
      insert acc;
      List<String> recordTypeIds = Label.mykvh_My_Registered_Product_Platform_Account_Record_Type_IDs.split(';');
       
      Account acc2 = new Account(name = 'Platform Account',recordTypeId = recordTypeIds[0],parentId = acc.Id);
      insert acc2;
      
      Product2 prod = new Product2(name = 'Test Product');
      insert prod;
      
      Asset assetObj = new Asset(AccountId = acc2.Id,Product2Id = prod.Id,Item__c = '01-0346-01',Name = 'Test Asset');
      insert assetObj;
      
      Product_Registration__c regObj = new Product_Registration__c(Found_Asset__c = assetObj.Id);
      insert regObj;
      
       ContentVersion contentVersion = new ContentVersion(
          Title = 'Penguins_POP',
          PathOnClient = 'Penguins.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = regObj.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
      
        Contact con = new Contact (
            AccountId = acc.id,
            LastName = 'portalTestUser'
        );
        insert con;
        User thisUser = [ select Id,UserRoleId from User where UserRoleId != null AND
                        Profile.Name = 'System Administrator' AND isActive = true limit 1];
         
        System.runAs ( thisUser ) {
          
            Profile p = [select Id,name from Profile WHERE name = 'myKVH Customer Community User' limit 1];
             
            User newUser = new User(       
            profileId = p.id,
            username = 'newUser@yahoo.com.kvh',
            email = 'pb@ff.com',
            emailencodingkey = 'UTF-8',
            localesidkey = 'en_US',
            languagelocalekey = 'en_US',
            timezonesidkey = 'America/Los_Angeles',
            alias='nuser',
            lastname='lastname',
            contactId = con.id
            
            );
            insert newUser;            
        }
  }
  
  static testMethod void initializeComponent_test() {
      User commUser = [Select id from User where username = 'newUser@yahoo.com.kvh'];
      System.runAs (commUser){
          Map<String,Object> resultMap  = myKVH_MyRegisteredProductsController.initializeComponent();
          system.assertequals(((List<myKVH_MyRegisteredProductsController.AccountModal>)resultMap.get('accountlist')).size(),1);
      }      
  }
  
  static testMethod void createSupportCase_test() {
      User commUser = [Select id from User where username = 'newUser@yahoo.com.kvh'];
      List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
      System.runAs (commUser){
          myKVH_MyRegisteredProductsController.createSupportCase('Test Case','testing',new List<String>{documents[0].Id},'Airtime Service');
          List<Case> caselist = [Select id from Case];
          system.assertequals(caselist.size(),1);
      }      
  }
  
   static testMethod void deleteDocuments_test() {
       List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
       myKVH_MyRegisteredProductsController.deleteDocuments(new List<String>{documents[0].Id});
   }
  
  static testMethod void fetechProductRegistratoinDetails_test() {
       List<Product_Registration__c> prodReglist = [Select id from Product_Registration__c limit 1];
       myKVH_MyRegisteredProductsController.fetechProductRegistratoinDetails(prodReglist[0].Id);     
  }
  
  static testMethod void updateNewDocuemntSuffix_test() {
       List<Product_Registration__c> prodReglist = [Select id from Product_Registration__c limit 1];
         ContentVersion contentVersion = new ContentVersion(
          Title = 'New_POP',
          PathOnClient = 'New.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;
      
       List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE Title = 'New_POP'];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = prodReglist[0].id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        
       
       myKVH_MyRegisteredProductsController.updateNewDocuemntSuffix('POP',documents[0].Id,prodReglist[0].Id);     
  }
  
  
}