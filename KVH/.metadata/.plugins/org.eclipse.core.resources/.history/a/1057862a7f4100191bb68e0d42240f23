@isTest
private class testattachmentmove {
    static testMethod void testattach()
    {
        Account a = new Account();
        a.Name = 'testacct';
        insert a;
        
        Contract b = new Contract();
        b.RecordTypeId = '012a0000001WE81';
        b.StartDate = date.today();
        b.AccountId = a.Id;
        insert b;
        
        Contract c = new Contract();
        c.RecordTypeId = '01213000001ZTzj';
        c.StartDate = date.today();
        c.AccountId = a.Id;
        c.Service_Contract__c = b.Id;
        insert c;
        
        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.RecordTypeId = '01213000001FuAd';
        q.SBQQ__Account__c = a.Id;
        q.SBQQ__MasterContract__c = c.Id;
        insert q;
            
        Attachment att1 = new Attachment();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        att1.Body = bodyBlob;
        att1.ParentId = q.Id;
        att1.Name = 'Unit Test 1';
        insert att1;
        
        Attachment att2 = new Attachment();
        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body'); 
        att2.Body = bodyBlob2;
        att2.ParentId = q.Id;
        att2.Name = 'Unit Test 2';
        insert att2;
        
        SBQQ__QuoteDocument__c qd1 = new SBQQ__QuoteDocument__c();
        qd1.Name = 'testme1.pdf';
        qd1.SBQQ__Quote__c = q.Id;
        qd1.SBQQ__AttachmentId__c = att1.Id;
        qd1.SBQQ__Template__c = 'Master Service Partner Agreement';
        insert qd1;
        
        SBQQ__QuoteDocument__c qd2 = new SBQQ__QuoteDocument__c();
        qd2.Name = 'testme2.pdf';
        qd2.SBQQ__Quote__c = q.Id;
        qd2.SBQQ__AttachmentId__c = att2.Id;
        qd2.SBQQ__Template__c = 'Partner Agreement';
        insert qd2;
        
        List<Attachment> attachments1=[select id, name from Attachment where parent.id=:c.id]; 
        System.assertEquals(1, attachments1.size()); 
        
        List<Attachment> attachments2=[select id, name from Attachment where parent.id=:b.id]; 
        System.assertEquals(1, attachments2.size()); 
    }

}