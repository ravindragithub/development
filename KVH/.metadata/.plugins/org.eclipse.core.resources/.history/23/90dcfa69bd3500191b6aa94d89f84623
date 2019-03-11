/*
Description    :    Test class for PRDReg_Controller 
*/

@isTest
public class PRDReg_Controller_Test{
    
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
            Product_Line1__c = 'Satellite Television'
        );
        insert prod;
        Product2 prod2 = new Product2(
            Name = 'Laptop X200', 
            isActive = TRUE, 
            Display_Product__c = 'Yes',
            Retired__c = FALSE,
            Family = 'Hardware',
            Product_Line1__c = 'Satellite Television'
        );
        insert prod2;
        
        Platform_Market_Sector__c test = new Platform_Market_Sector__c(
        	Platform_Type__c = 'Vessel',
            Market__c = 'Leisure',
            Account_Vessel_type__c = 'Military',
            Sector__c = 'Land Systems'
        );
        insert test;
        Platform_Market_Sector__c test2 = new Platform_Market_Sector__c(
        	Platform_Type__c = 'Vessel',
            Market__c = 'Leisure',
            Account_Vessel_type__c = 'Conversion Van',
            Sector__c = 'RV & Auto Systems'
        );
        insert test2;
        Platform_Market_Sector__c test3 = new Platform_Market_Sector__c(
        	Platform_Type__c = 'Vessel',
            Market__c = 'Military & Government',
            Account_Vessel_type__c = 'Fishing',
            Sector__c = 'Land Systems'
        );
        insert test3;
    }
    
    // Test Method to cover FileSizeToString
    @isTest static void testFileSizeToString(){
        String fileSize = PRDReg_Controller.FileSizeToString(1024);
        system.assertEquals(fileSize, '1.00 KB');
        fileSize = PRDReg_Controller.FileSizeToString(1024*1024);
        system.assertEquals(fileSize, '1.00 MB');
        fileSize = PRDReg_Controller.FileSizeToString(1024*1024*1024);
        system.assertEquals(fileSize, '1.00 GB');
    }
    
    // Test Method to cover getListCV
    @isTest
    public static void testgetListCV(){
        list<Product_Registration__c> prdReg = [SELECT Id FROM Product_Registration__c LIMIT 1];
        list<PRDReg_Controller.attachmentListWrapper> attList = PRDReg_Controller.getListCV(new list<Id>{prdReg[0].Id});
    }
    
    // Test Method to cover deleteAttachmentList
    @isTest
    public static void testdeleteAttachmentList(){
        list<ContentDocument> contentDocs =  [SELECT Id FROM ContentDocument LIMIT 1];
        list<Product_Registration__c> prdReg = [SELECT Id FROM Product_Registration__c LIMIT 1];
        List<PRDReg_Controller.attachmentListWrapper> attList = PRDReg_Controller.deleteAttachmentList(contentDocs[0].Id, prdReg[0].Id);
    }
    
    // Test Method to cover getListAttachment
    @isTest
    public static void testgetListAttachment(){
        list<Product_Registration__c> prdReg = [SELECT Id FROM Product_Registration__c LIMIT 1];
        list<ContentDocument> contentDocs =  [SELECT Id FROM ContentDocument LIMIT 1];
        List<PRDReg_Controller.attachmentListWrapper> attList = PRDReg_Controller.getListAttachment(prdReg[0].Id, contentDocs[0].Id, 'Test');
    }
    
    // Test Method to cover SaveProductRegistration
    @isTest
    public static void testSaveProductRegistration(){
        list<Product_Registration__c> prdReg = [SELECT Id FROM Product_Registration__c LIMIT 1];
        PRDReg_Controller.SaveProductRegistration(prdReg[0]);
    }
    
    // Test Method to cover getProductReg
    @isTest
    public static void testgetProductReg(){
        Product_Registration__c prdReg = PRDReg_Controller.getProductReg();
    }
    
    // Test Method to cover getCountry
    @isTest
    public static void testgetCountry(){
        List<KVH_Countries__mdt> countryData = PRDReg_Controller.getCountry();
    }
    
    // Test Method to cover getStateMap
    @isTest
    public static void testgetStateMap(){
        List<string> stateMap = PRDReg_Controller.getStateMap('US');
    }
    
    // Test Method to cover getContactInfo
    @isTest
    public static void testgetContactInfo(){
        Map<String, Object> returnMap = PRDReg_Controller.getContactInfo();
    }
    
    // Test Method to cover getProductLineMap
    @isTest
    public static void testgetProductLineMap(){
        Map<string,List<String>> returnMap = PRDReg_Controller.getProductLineMap();
    }
    
    // Test Method to cover getVesselTypeMap
    @isTest
    public static void testgetVesselTypeMap(){
        Map<string,Map<string,List<String>>> returnMap = PRDReg_Controller.getVesselTypeMap();
    }
}