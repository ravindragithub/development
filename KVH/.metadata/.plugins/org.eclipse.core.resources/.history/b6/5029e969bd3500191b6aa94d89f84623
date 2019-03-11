public without sharing class PRDReg_Controller {
    
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
        //List<Attachment> lstAttach = new List<Attachment>();
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
                wrapAttach.attachSize = PRDReg_Controller.FileSizeToString(tempAttach.ContentDocument.ContentSize);                 
                wrapAttach.attachType = tempAttach.ContentDocument.FileType;  
                if(contentDocIdVerIdMap.containskey(tempAttach.ContentDocumentID))
                    wrapAttach.attachDocVerId = contentDocIdVerIdMap.get(tempAttach.ContentDocumentID);                        
                wrapAttach.attachsObject = 'Files';                        
                lstAttachWrap.add(wrapAttach);
            }   
            /*lstAttach = [SELECT Id, ParentId, Name, ContentType, BodyLength, Body, Description FROM Attachment
                         WHERE ParentId =: newSet];
            for(Attachment tempAttach : lstAttach){
                attachmentListWrapper wrapAttach = new attachmentListWrapper();
                wrapAttach.attachId = tempAttach.Id;
                wrapAttach.attachName = tempAttach.Name;              
                wrapAttach.attachSize = PRDReg_Controller.FileSizeToString(tempAttach.BodyLength); 
                wrapAttach.attachType = tempAttach.ContentType;                         
                wrapAttach.attachsObject = 'Attachment';                                            
                lstAttachWrap.add(wrapAttach);
            }*/
        }
        return lstAttachWrap;
    }
    /***********************************************
Name        :    deleteAttachmentList
Description :    Method to delete the Attachment in Product Registration Form
************************************************/
    @AuraEnabled 
    public static List<attachmentListWrapper> deleteAttachmentList(string docId, string ProdRegId){
        list<ContentDocument> contentDocs =  [SELECT Id FROM ContentDocument where Id = : docId];
        if(contentDocs.size() > 0){
            delete contentDocs;
        }
        
        List<attachmentListWrapper> lstAttachWrap = new List<attachmentListWrapper>();
        List<Id> newSet = new List<Id>();
        newSet.add(ProdRegId);
        if(newSet.size() > 0){            
            lstAttachWrap = PRDReg_Controller.getListCV(newSet);  
        }        
        return lstAttachWrap;      
    }
    /***********************************************
Name        :    getListAttachment
Description :    Method to get List of attachments after upload in Product Registration Form 
************************************************/
    @AuraEnabled 
    public static List<attachmentListWrapper> getListAttachment(string ProdRegId, string documentId, string documentName){
        List<attachmentListWrapper> lstAttachWrap = new List<attachmentListWrapper>();
        List<Id> newSet = new List<Id>();
        newSet.add(ProdRegId);
        if(newSet.size() > 0){
            if(documentId!=null && documentName!=null){
                updateFileName(documentId, documentName);    
            }
            lstAttachWrap = PRDReg_Controller.getListCV(newSet);
        }  
        return lstAttachWrap;      
    }
    
    /***********************************************
Name        :    updateFileName
Description :    Method to add suffix(_POP or _CkList) to the File Name
************************************************/
    private static void updateFileName(string documentId, string documentName){
        ContentDocument cDoc = new ContentDocument(
            Id = documentId,
            Title = documentName
        );
        update cDoc;
    }
    
    /***********************************************
Name        :    SaveProductRegistration
Description :    Method to save the Product Registration SObject 
************************************************/
    @AuraEnabled 
    public static void SaveProductRegistration(Product_Registration__c updateProdReg){  
        
        try { 
            
            List<Group> newGrp = new List<Group>([Select Id from Group where Type = 'Queue' AND DeveloperNAME = 'Airtime_Services_Queue']);
            Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airtime Service').getRecordTypeId();
            List<User> userInformation = [Select Contact.Id,Serial_Number__c From User Where Id =: UserInfo.getUserId() LIMIT 1];
            
            Case newCase = new Case();
            if(newGrp.size() > 0)
                newCase.OwnerId = newGrp[0].Id;
            newCase.RecordTypeId = devRecordTypeId;
            newCase.ContactId = userInformation[0].Contact.Id;
            newCase.Origin = ' myKVH Customer Portal';
            newCase.Subject =  'New Product Registration Submission';  
            insert newCase;
            system.debug('===newCase===' + newCase);            
            
            system.debug('==updateProdReg==' + updateProdReg);
            updateProdReg.Case__c = newCase.Id;
            update updateProdReg; 
        }
        catch (Exception e) {
            throw new AuraHandledException('Darn it! Something went wrong: '
                                           + e.getMessage());    
        }
        finally {
        }      
    }
    /***********************************************
Name        :    getProductReg
Description :    Method to get the pending / Create new Production Registration for Loggedin user
************************************************/
    @AuraEnabled 
    public static Product_Registration__c getProductReg(){
        
        User u = [Select Id,Name,ContactId From User Where Id =: UserInfo.getUserId()];
        List<Product_Registration__c> lstProdReg = new List<Product_Registration__c>();
        lstProdReg = [SELECT Id, Account__c, Platform_Account__c, Contact__c, Subscriber_First_Name__c, Installer_Zip_Code__c,
                      Subscriber_Company_Name__c, Subscriber_Email__c, Subscriber_Phone__c, Agreed_to_Receive_Texts__c, 
                      Contact_email__c, Device__c, Subscriber_Address__c, Subscriber_City__c, Subscriber_Country__c, 
                      Subscriber_State_Province_Territory__c, Subscriber_Postal_Zip_Code__c, Subscriber_Last_Name__c, 
                      Vessel_Name__c, Flag__c, Vessel_Length__c, MMSI__c, IMO_Registration_No__c, Market__c, Sector__c, 
                      Vessel_Type__c, Installer_Information__c, Installer_Contact_Name__c, Installer_Country__c, 
                      Installer_State_Province_Territory__c, Installer_Manufacture__c, Purchased_From__c, Sim_Serial_No__c, 
                      Antenna_Serial_No__c, Purchase_Date__c, Portal_Contact__c, Status__c, Installer_Address__c, 
                      Installer_City__c, Platform_Type__c, Application__c, Application_Type__c, Other_Installation__c, 
                      RV_or_Vehicle_Make_Model__c, Other_System__c, TV_Hub_Serial_No__c, IPACU_Serial_No__c, Serial_No__c,
                      Scheduled_Installation_Date__c, Product_Line__c, Product__c, Billing_Address__c, Billing_City__c, 
                      Billing_Country__c, Billing_State_Province_Territory__c, Billing_Postal_Zip_Code__c, Credit_Card_No__c, 
                      Exp_Date__c, Name_on_Card__c, Shipping_Addressee__c, Shipping_Address__c, Shipping_City__c, 
                      Shipping_Country__c, Shipping_State_Province_Territory__c, Shipping_Postal_Zip_Code__c, 
                      Satellite_TV_Provider__c, Dish_Network_Subscriber_Status__c, DIRECTV_Subscriber_Status__c, 
                      DIRECTV_Account_Number__c, CreatedDate, LastModifiedDate FROM Product_Registration__c
                      Where Portal_Contact__c =: u.ContactId AND Status__c = 'In Progress'];
        if(lstProdReg.size() == 0 && u.ContactId != null){
            Product_Registration__c prodReg = new Product_Registration__c();
            prodReg.Portal_Contact__c = u.ContactId;
            prodReg.Status__c = 'In Progress';
            prodReg.Shipping_Country__c = 'United States';
            prodReg.Subscriber_Country__c = 'United States';
            prodReg.Installer_Country__c = 'United States';
            prodReg.Billing_Country__c = 'United States';
            insert prodReg;
            lstProdReg.add(prodReg);
        }
        return lstProdReg[0];
    }
    /***********************************************
Name        :    getCountry
Description :    Method to get Country List from KVH_Countries__mdt metadata
************************************************/
    @AuraEnabled 
    public static List<KVH_Countries__mdt> getCountry(){
        List<KVH_Countries__mdt> countryValues = [SELECT Id, TrimmedName__c, IsoCode_2__c, IsoCode_3__c 
                                                  FROM KVH_Countries__mdt
                                                  WHERE (Enabled__c =: true AND IsObsolete__c =: false)
                                                  ORDER BY TrimmedName__c ASC];
        return countryValues;
    }
    /***********************************************
Name        :    getStateMap
Description :    Method to get State Map from KVH_States__mdt metadata based on Country selected in Form
************************************************/
    @AuraEnabled 
    public static List<string> getStateMap(string countryCode){
        List<string> stateValues = new List<string>();
        for(KVH_States__mdt tempState : [SELECT Id, CountryIsoCode_2__c,IsoCode__c,TrimmedName__c
                                         FROM KVH_States__mdt WHERE CountryIsoCode_2__c =: countryCode ORDER BY TrimmedName__c ASC])
            stateValues.add(tempState.TrimmedName__c);                           
        
        return stateValues;
    }
    /***********************************************
Name        :    getContactInfo
Description :    Method to get Contact Information of the Loggedin USer
************************************************/
    @AuraEnabled 
    public static Map<String, Object> getContactInfo(){
        UserInfo.getUserId();
        List<Contact> contactId = new List<Contact>();
        List<User> userInformation = [Select Contact.Id,Serial_Number__c From User Where Id =: UserInfo.getUserId() LIMIT 1];
        if (userInformation.size() > 0){
            system.debug(userInformation.get(0).Contact.Id);
            contactId = [Select Id, Email, Phone, FirstName,MailingCountry,MailingState, LastName, LTE_Antenna_Number__c From Contact Where Id =: userInformation.get(0).Contact.Id LIMIT 1];
        }
        Map<String, Object> returnMap = new Map<String, Object>();
        returnMap.put('email','');
        returnMap.put('mobilePhone','');
        returnMap.put('firstName','');
        returnMap.put('lastName','');
        returnMap.put('serialNumber','');
        returnMap.put('Id','');
        returnMap.put('contact','');
        if (contactId.size() > 0){
            Contact cntct = contactId.get(0);
            returnMap.put('email',cntct.Email);
            returnMap.put('mobilePhone',cntct.Phone);
            returnMap.put('firstName',cntct.FirstName);
            returnMap.put('lastName',cntct.LastName);
            returnMap.put('serialNumber',userInformation[0].Serial_Number__c);
            returnMap.put('Id',cntct.Id);
            returnMap.put('contact',cntct);
            returnMap.put('country',cntct.MailingCountry);
            returnMap.put('state',cntct.MailingState);
        }
        return returnMap;
    }
    
    /***********************************************
Name        :    getProductLineMap
Description :    Method to get all Product Line and Products from the salesforce system
************************************************/
    @AuraEnabled 
    public static Map<string,List<String>> getProductLineMap(){
        Map<string,List<String>> newProdLineProdMap = new Map<string,List<String>>();
        List<Product2> lstProduct2 = new List<Product2>([SELECT Id,Name,Catalog_Display_Name__c,Product_Line1__c FROM Product2
                                                         WHERE (Product_Line1__c =: 'Satellite Television' OR Product_Line1__c =: 'Compasses' ) AND (isActive = TRUE AND Display_Product__c =: 'Yes' AND Retired__c = FALSE)
                                                         ORDER BY Name ASC]);
        for(Product2 tempProd : lstProduct2){
            if(tempProd.Product_Line1__c != null){
                if(newProdLineProdMap.containsKey(tempProd.Product_Line1__c)) {
                    List<String> displayName = newProdLineProdMap.get(tempProd.Product_Line1__c);
                    displayName.add(tempProd.Catalog_Display_Name__c);
                    newProdLineProdMap.put(tempProd.Product_Line1__c, displayName);
                } else {
                    newProdLineProdMap.put(tempProd.Product_Line1__c, new List<String> { tempProd.Catalog_Display_Name__c });
                }
            }
        }
        return newProdLineProdMap;
    }
    /***********************************************
Name        :    getVesselTypeMap
Description :    Method to get all Vessel Type data from the salesforce system
************************************************/
    @AuraEnabled 
    public static Map<string,Map<string,List<String>>> getVesselTypeMap(){
        Map<string,Map<string,List<String>>> newVesselTypeMap = new Map<string,Map<string,List<String>>>();
        List<Platform_Market_Sector__c> lstPlatformMS = new List<Platform_Market_Sector__c>([SELECT Id,Name, Market__c,Account_Vessel_type__c,
                                                                                             Sector__c, LTE_Vessel_Card__c,Platform_Type__c 
                                                                                             FROM Platform_Market_Sector__c 
                                                                                             ORDER BY Name ASC]);
        for(Platform_Market_Sector__c tempMS : lstPlatformMS){
            if(tempMS.Platform_Type__c != null){
                if(newVesselTypeMap.containskey(tempMS.Platform_Type__c)){
                    Map<string,List<String>> innerMap = newVesselTypeMap.get(tempMS.Platform_Type__c);
                    if(innerMap.containskey(tempMS.Market__c)){
                        List<String> lstName = innerMap.get(tempMS.Market__c);
                        lstName.add(tempMS.Account_Vessel_type__c);
                        innerMap.put(tempMS.Market__c, lstName);
                    } else {
                        innerMap.put(tempMS.Market__c, new List<String> { tempMS.Account_Vessel_type__c });
                    }
                    if(tempMS.Platform_Type__c != null)
                        newVesselTypeMap.put(tempMS.Platform_Type__c, innerMap);
                }
                else{
                    Map<string,List<String>> tempMap = new Map<string,List<String>>();
                    if(tempMap.containskey(tempMS.Market__c)){
                        List<String> lstName = tempMap.get(tempMS.Market__c);
                        lstName.add(tempMS.Account_Vessel_type__c);
                        tempMap.put(tempMS.Market__c, lstName);
                    } else {
                        tempMap.put(tempMS.Market__c, new List<String> { tempMS.Account_Vessel_type__c });
                    }
                    if(tempMS.Platform_Type__c != null)
                        newVesselTypeMap.put(tempMS.Platform_Type__c, tempMap);
                }   
            }
        }
        return newVesselTypeMap;
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