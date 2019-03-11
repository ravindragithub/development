trigger MoveAttachmentsToContract on SBQQ__QuoteDocument__c (after insert) {
    for (SBQQ__QuoteDocument__c a : trigger.new){
            //Select the Contract from the Quote
            SBQQ__Quote__c parent = [SELECT SBQQ__MasterContract__c, RecordTypeId, Account_Name__c FROM SBQQ__Quote__c WHERE ID = :a.SBQQ__Quote__c]; 
            Attachment body = [SELECT Body, IsPrivate, ContentType, Description, OwnerId FROM Attachment WHERE Id = :a.SBQQ__ViewRecordId__c];             
            if (parent.SBQQ__MasterContract__c != null && parent.RecordTypeId == '01213000001FuAd'){
                Contract sc = [SELECT Service_Contract__c FROM Contract WHERE ID = :parent.SBQQ__MasterContract__c];
                if(a.SBQQ__Template__c == 'Master Service Partner Agreement' && sc.Service_Contract__c != null){
                    //Create a new Attachment on Service Contract
                Attachment newS = New Attachment(
                    Name = a.SBQQ__Template__c + ' - ' + parent.Account_Name__c + '.pdf',
                    Body = body.Body,
                    IsPrivate = body.IsPrivate,
                    ContentType = body.ContentType,
                    Description = body.Description,
                    OwnerId = body.OwnerId,
                    //Connect the Attachment to the Contract
                    parentId = sc.Service_Contract__c);
                    //Insert the new Attachment
                    insert newS;
                }
                else{
                //Create a new Attachment on Master Contract
                Attachment newA = New Attachment(
                    Name = a.SBQQ__Template__c + ' - ' + parent.Account_Name__c + '.pdf',
                    Body = body.Body,
                    IsPrivate = body.IsPrivate,
                    ContentType = body.ContentType,
                    Description = body.Description,
                    OwnerId = body.OwnerId,
                    //Connect the Attachment to the Contract
                    parentId = parent.SBQQ__MasterContract__c);
                //Insert the new Attachment
                insert newA; }
            }
    }
}