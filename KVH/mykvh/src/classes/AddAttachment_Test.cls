/*
Description    :    Test class for AddAttachmentController 
*/
@isTest
public class AddAttachment_Test {
    static testMethod void test_AddAttachment() {
        List<Account> accList = TestDataFactory.createAccountRecords(1, null,'Prospect',false,false,'','',null,'');
        insert accList;  
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = accList[0].Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        Blob b = Blob.valueOf('Test Data');        
        Attachment attachment = new Attachment();
        attachment.ParentId = accList[0].Id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;        
        insert attachment;
        AddAttachmentController.getListAttachment(accList[0].Id);
        AddAttachmentController.FileSizeToString(1025);
        AddAttachmentController.FileSizeToString(1024*1024);
        AddAttachmentController.FileSizeToString(1024*1024);
        AddAttachmentController.FileSizeToString(1024*1024*1024*2);
        AddAttachmentController.deleteAttachmentList(contentVersion.Id,accList[0].Id,'Files'); 
    }
    
}