public without sharing class AddAttachmentController {
    
    /***********************************************
Name        :    FileSizeToString
Description :    Method to convert the attach file size in Bytes,KB,MB,GB
************************************************/
    public static String FileSizeToString(Long Value){
        if (Value < 1024)
            return string.valueOf(Value) + ' Bytes';
        else
            if (Value >= 1024 && Value < (1024*1024)){
                Decimal kb = Decimal.valueOf(Value);
                kb = kb.divide(1024,2);
                return string.valueOf(kb) + ' KB';
            }
        else
            if (Value >= (1024*1024) && Value < (1024*1024*1024)){
                Decimal mb = Decimal.valueOf(Value);
                mb = mb.divide((1024*1024),2);
                return string.valueOf(mb) + ' MB';
            }
        else{
            Decimal gb = Decimal.valueOf(Value);
            gb = gb.divide((1024*1024*1024),2);            
            return string.valueOf(gb) + ' GB';
        }    
    }
    /***********************************************
Name        :    getListCV
Description :    Method to get List of attachments from Content Version in Product Registration Form
************************************************/
    public static List<attachmentListWrapper> getListCV(List<Id> newSet) {
        system.debug('==newSet==' + newSet);
        List<ContentDocumentLink> lstCDocLink = new List<ContentDocumentLink>();
        List<Attachment> lstAttach = new List<Attachment>();
        List<attachmentListWrapper> lstAttachWrap = new List<attachmentListWrapper>();
        set<Id> contentDocIds = new set<Id>();
        Map<Id,Id> contentDocIdVerIdMap = new Map<Id,Id>();
        if(newSet.size() > 0){
            lstCDocLink = [SELECT ContentDocumentID,LinkedEntityId, ContentDocument.CreatedDate,ContentDocument.Title,  
                           ContentDocument.ContentSize,ContentDocument.FileType,ContentDocument.CreatedBy.Name, LinkedEntity.type, LinkedEntity.Name FROM ContentDocumentLink 
                           WHERE LinkedEntityId IN: newSet];
            for(ContentDocumentLink cvDocLink : lstCDocLink)
                contentDocIds.add(cvDocLink.ContentDocumentID);
            if(contentDocIds.size() > 0){
                for(ContentVersion cv : [SELECT Id, ContentDocumentId, RecordTypeId, IsLatest, ContentUrl, ContentBodyId, VersionNumber, Title, Description 
                                         FROM ContentVersion WHERE ContentDocumentId =: contentDocIds])
                    contentDocIdVerIdMap.put(cv.ContentDocumentId,cv.Id); 
            }
            
            for(ContentDocumentLink tempAttach : lstCDocLink ){
                attachmentListWrapper wrapAttach = new attachmentListWrapper();
                wrapAttach.attachId = tempAttach.ContentDocument.Id;
                wrapAttach.attachName = tempAttach.ContentDocument.Title;              
                wrapAttach.attachSize = AddAttachmentController.FileSizeToString(tempAttach.ContentDocument.ContentSize);                 
                wrapAttach.attachType = tempAttach.ContentDocument.FileType;  
                if(contentDocIdVerIdMap.containskey(tempAttach.ContentDocumentID))
                    wrapAttach.attachDocVerId = contentDocIdVerIdMap.get(tempAttach.ContentDocumentID);                        
                wrapAttach.attachsObject = 'Files';                        
                lstAttachWrap.add(wrapAttach);
            }   
            lstAttach = [SELECT Id, ParentId, Name, ContentType, BodyLength, Body, Description FROM Attachment
                         WHERE ParentId =: newSet];
            for(Attachment tempAttach : lstAttach){
                attachmentListWrapper wrapAttach = new attachmentListWrapper();
                wrapAttach.attachId = tempAttach.Id;
                wrapAttach.attachName = tempAttach.Name;              
                wrapAttach.attachSize = AddAttachmentController.FileSizeToString(tempAttach.BodyLength); 
                wrapAttach.attachType = tempAttach.ContentType;                         
                wrapAttach.attachsObject = 'Attachment';                                            
                lstAttachWrap.add(wrapAttach);
            }    
        }
        return lstAttachWrap;
    }
    /***********************************************
Name        :    deleteAttachmentList
Description :    Method to delete the Attachment in Product Registration Form
************************************************/
    @AuraEnabled 
    public static List<attachmentListWrapper> deleteAttachmentList(string CVId, string ProdRegId,string typeDoc){
        List<sObject> cd = new List<sObject>();
        if(typeDoc == 'Files')
            cd = [SELECT Id, PublishStatus, Title, LatestPublishedVersionId FROM ContentDocument where Id = : CVId];
        else
            cd = [SELECT Id FROM Attachment where Id = : CVId];
        if(cd.size() > 0)
            delete cd;
        
        List<attachmentListWrapper> lstAttachWrap = new List<attachmentListWrapper>();
        List<Id> newSet = new List<Id>();
        newSet.add(ProdRegId);
        if(newSet.size() > 0){            
            lstAttachWrap = AddAttachmentController.getListCV(newSet);  
        }        
        return lstAttachWrap;      
    }
    /***********************************************
Name        :    getListAttachment
Description :    Method to get List of attachments after upload in Product Registration Form 
************************************************/
    @AuraEnabled 
    public static List<attachmentListWrapper> getListAttachment(string ProdRegId){
        List<attachmentListWrapper> lstAttachWrap = new List<attachmentListWrapper>();
        List<Id> newSet = new List<Id>();
        newSet.add(ProdRegId);
        if(newSet.size() > 0)           
            lstAttachWrap = AddAttachmentController.getListCV(newSet);  
        return lstAttachWrap;      
    }
    
    public class attachmentListWrapper{
        @AuraEnabled public string attachId {get;set;}
        @AuraEnabled public string attachName {get;set;}        
        @AuraEnabled public string attachType {get;set;}
        @AuraEnabled public string attachSize {get;set;}     
        @AuraEnabled public string attachsObject {get;set;}   
        @AuraEnabled public string attachDocVerId {get;set;}           
    }    
}