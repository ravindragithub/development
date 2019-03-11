/*
    Description    :    Test class for myKVH_ProductRegistrationController 
*/

@isTest
public class myKVH_ProductRegistrationController_Test{
    
    @TestSetup
    static void setup(){
        ContentVersion contentVrsn = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVrsn;
        
        Product_Registration__c prodReg = new Product_Registration__c(
            Status__c = 'In Progress'
        );
        insert prodReg;
        
        list<ContentVersion> conDoc = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: contentVrsn.Id];
        ContentDocumentLink docLink = new ContentDocumentLink(
            LinkedEntityId = prodReg.Id,
            ContentDocumentId = conDoc[0].ContentDocumentId,
            shareType = 'V'
        );
        insert docLink;
        
        Product2 prod = new Product2(
            Name = 'Laptop X200', 
            isActive = TRUE, 
            Display_Product__c = 'Yes',
            Retired__c = FALSE,
            Family = 'Hardware',
            Product_Line1__c = 'Satellite Television',
            Catalog_Display_Name__c = 'Test'
        );
        insert prod;
        Product2 prod2 = new Product2(
            Name = 'Laptop X200', 
            isActive = TRUE, 
            Display_Product__c = 'Yes',
            Retired__c = FALSE,
            Family = 'Hardware',
            Product_Line1__c = 'Satellite Television',
            Catalog_Display_Name__c = 'Test2'
        );
        insert prod2;
        
        Platform_Market_Sector__c test = new Platform_Market_Sector__c(
            Platform_Type__c = 'Vehicle',
            Market__c = 'Leisure',
            Vessel_Type__c = 'Military',
            Sector__c = 'Land Systems'
        );
        insert test;
        Platform_Market_Sector__c test2 = new Platform_Market_Sector__c(
            Platform_Type__c = 'Vessel',
            Market__c = 'Leisure',
            Vessel_Type__c = 'Conversion Van',
            Sector__c = 'Marine Systems'
        );
        insert test2;
        Platform_Market_Sector__c test3 = new Platform_Market_Sector__c(
            Platform_Type__c = 'Vessel',
            Market__c = 'Military & Government',
            Vessel_Type__c = 'Fishing',
            Sector__c = 'Land Systems'
        );
        insert test3;
        
        Account acc = new Account(name = 'Parent Account');
        insert acc;
        
        Contact con = new Contact (
            AccountId = acc.id,
            LastName = 'portalTestUser'
        );
        insert con;
        User thisUser = [SELECT Id,UserRoleId 
                         FROM User 
                         WHERE UserRoleId!=null 
                         AND Profile.Name = 'System Administrator' 
                         AND isActive = true limit 1];
         
        System.runAs ( thisUser ) {
            Profile p = [SELECT Id,name FROM Profile WHERE name = 'myKVH Customer Community User' limit 1];
            
            User newUser = new User(       
                profileId = p.id,
                username = 'newUser@test.com.kvh',
                email = 'pb@ff.com',
                emailencodingkey = 'UTF-8',
                localesidkey = 'en_US',
                languagelocalekey = 'en_US',
                timezonesidkey = 'America/Los_Angeles',
                alias='nuser',
                lastname='lastname',
                contactId = con.id,
                Serial_Number__c = '123123',
                Destination__c = 'Test'
            );
            insert newUser;            
        }
    }
    
    // Test Method to cover getIntiData
    @isTest static void testgetIntiData(){
        User commUser = [SELECT id FROM User WHERE username = 'newUser@test.com.kvh'];
        System.runAs (commUser){
            map<string, Object> responseMap = myKVH_ProductRegistrationController.getIntiData();
            system.assertEquals(responseMap.size(), 6);
        }
    }
    
    // Test Method to cover updateFileName
    @isTest static void testupdateFileName(){
        list<Product_Registration__c> prdReg = [SELECT Id FROM Product_Registration__c LIMIT 1];
        list<ContentDocument> contentDocs =  [SELECT Id FROM ContentDocument LIMIT 1];
        list<myKVH_ProductRegistrationController.attachmentListWrapper> attList = myKVH_ProductRegistrationController.updateFileName(prdReg[0].Id, contentDocs[0].Id, 'Test');
        system.assertEquals(attList[0].attachName, 'Test');
    }
    
    // Test Method to cover deleteAttachmentList
    @isTest
    public static void testdeleteAttachmentList(){
        list<ContentDocument> contentDocs =  [SELECT Id FROM ContentDocument LIMIT 1];
        list<Product_Registration__c> prdReg = [SELECT Id FROM Product_Registration__c LIMIT 1];
        List<myKVH_ProductRegistrationController.attachmentListWrapper> attList = myKVH_ProductRegistrationController.deleteAttachment(contentDocs[0].Id, prdReg[0].Id);
        system.assertEquals(attList.size(), 0);
    }
    
    // Test Method to cover SaveProductRegistration
    @isTest
    public static void testSaveProductRegistration(){
        User commUser = [SELECT id FROM User WHERE username = 'newUser@test.com.kvh'];
        System.runAs (commUser){
            list<Product_Registration__c> prdReg = [SELECT Id FROM Product_Registration__c LIMIT 1];
            prdReg[0].Product_Line__c = 'Satellite Television';
            prdReg[0].Product__c = 'TracVision TV5';
            prdReg[0].Antenna_Serial_No__c = '123456789';
            prdReg[0].TV_Hub_Serial_No__c = '123456789';
            myKVH_ProductRegistrationController.SaveProductRegistration(prdReg[0]);
            prdReg[0].Product_Line__c = 'Satellite Television';
            prdReg[0].Product__c = 'TracVision HD11';
            prdReg[0].Antenna_Serial_No__c = '123456789';
            prdReg[0].IPACU_Serial_No__c = '123456789';
            myKVH_ProductRegistrationController.SaveProductRegistration(prdReg[0]);
            prdReg[0].Product_Line__c = 'Satellite Television';
            prdReg[0].Product__c = 'Other';
            prdReg[0].Antenna_Serial_No__c = '123456789';
            myKVH_ProductRegistrationController.SaveProductRegistration(prdReg[0]);
            prdReg[0].Product_Line__c = 'Compasses';
            prdReg[0].Product__c = 'Other';
            prdReg[0].Serial_No__c = '123456789';
            myKVH_ProductRegistrationController.SaveProductRegistration(prdReg[0]);
        }
    }
    
    // Test Method to cover FileSizeToString
    @isTest static void testFileSizeToString(){
        String fileSize = myKVH_ProductRegistrationController.FileSizeToString(1024);
        system.assertEquals(fileSize, '1.00 KB');
        fileSize = myKVH_ProductRegistrationController.FileSizeToString(1024*1024);
        system.assertEquals(fileSize, '1.00 MB');
        fileSize = myKVH_ProductRegistrationController.FileSizeToString(1024*1024*1024);
        system.assertEquals(fileSize, '1.00 GB');
    }
}