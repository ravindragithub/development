/*
    Description    :    Controller for myKVH_ProductRegistration Lightning Component
*/

public class myKVH_ProductRegistrationController{

    //Method to intialize component on load
    @AuraEnabled
    public static map<string, Object> getIntiData(){
        try{
            map<string, Object> responseMap = new map<string, Object>();
            Product_Registration__c prdReg = getProductRegistration();
            responseMap.put('prodRegistration',prdReg);
            responseMap.put('attList',getAttachments(prdReg.Id));
            responseMap.put('vesselTypeMap',getVesselTypeMap());
            responseMap.put('productLineMap',getProductLineMap());
            getCountryState(responseMap);
            return responseMap;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    //Method to add suffix(_POP or _CkList) to the File Name
    @AuraEnabled
    public static list<attachmentListWrapper> updateFileName(string prodRegId, string documentId, string documentName){
        list<attachmentListWrapper> lstAttachWrap = new list<attachmentListWrapper>();
        if(documentId!=null && documentName!=null){
            ContentDocument cDoc = new ContentDocument(
                Id = documentId,
                Title = documentName
            );
            update cDoc;    
        }
        if(prodRegId!=null){
            lstAttachWrap = getAttachments(prodRegId);
        }
        return lstAttachWrap;
    }
    
    //Method to delete content document
    @AuraEnabled 
    public static List<attachmentListWrapper> deleteAttachment(string docId, string prdRegId){
        list<ContentDocument> contentDocs =  [SELECT Id FROM ContentDocument where Id =: docId];
        if(contentDocs.size()>0){
            delete contentDocs;
        }
        
        List<attachmentListWrapper> lstAttachWrap = new List<attachmentListWrapper>();
        if(prdRegId!=null){
            lstAttachWrap = getAttachments(prdRegId);
        }        
        return lstAttachWrap;      
    }
    
    //Method to save the Product Registration record
    @AuraEnabled 
    public static string saveProductRegistration(Product_Registration__c updateProdReg){
        try{
            /*list<Product_Registration__c> prdRegList = getExistingProdRegistrations(updateProdReg);
            if(prdRegList.size()>0){
                return System.Label.myKVH_Product_Registration_Already_Exist;
            }*/
            
            list<Group> newGrp = new list<Group>([SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Airtime_Services_Queue']);
            Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airtime Service').getRecordTypeId();
            list<User> userInformation = [SELECT Contact.Id,Serial_Number__c,Destination__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
            
            Case newCase = new Case();
            if(newGrp.size() > 0){
                newCase.OwnerId = newGrp[0].Id;
            }
            newCase.RecordTypeId = devRecordTypeId;
            newCase.ContactId = userInformation[0].Contact.Id;
            newCase.Origin = 'myKVH Customer Portal';
            newCase.Subject =  'New Product Registration Submission';  
            insert newCase;
            
            updateProdReg.Case__c = newCase.Id;
            update updateProdReg;
            
            if(userInformation[0].Serial_Number__c!=null || userInformation[0].Destination__c!=null){
                userInformation[0].Serial_Number__c = '';
                userInformation[0].Destination__c = '';
                update userInformation[0];
            }
            
            return 'Success';
        }catch(Exception e){
            throw new AuraHandledException('Darn it! Something went wrong: '+ e.getMessage());    
        }
    }
    
    //Method to check for other Product Registrations with the same serial number
    @AuraEnabled
    public static string checkExistingProdRegistrations(Product_Registration__c prdReg){
        set<string> tvSeries = new set<string>{'TracVision TV8','TracVision TV6','TracVision TV5','TracVision TV3','TracVision TV1','TracVision RV1','TracVision A9'};
        set<string> hdSeries = new set<string>{'TracVision HD7','TracVision HD11'};
        list<Product_Registration__c> prdRegList = new list<Product_Registration__c>();
        if(prdReg.Product_Line__c!=null && prdReg.Product__c!=null){
            string queryStr = 'SELECT Id FROM Product_Registration__c WHERE ';
            if(prdReg.Product_Line__c=='Satellite Television' && tvSeries.contains(prdReg.Product__c)){
                if(prdReg.Antenna_Serial_No__c!=null && prdReg.TV_Hub_Serial_No__c!=null){
                    queryStr += 'Antenna_Serial_No__c = \''+prdReg.Antenna_Serial_No__c+'\' OR TV_Hub_Serial_No__c = \''+prdReg.TV_Hub_Serial_No__c+'\'';
                }
            }else if(prdReg.Product_Line__c=='Satellite Television' && hdSeries.contains(prdReg.Product__c)){
                if(prdReg.Antenna_Serial_No__c!=null && prdReg.IPACU_Serial_No__c!=null){
                    queryStr += 'Antenna_Serial_No__c = \''+prdReg.Antenna_Serial_No__c+'\' OR IPACU_Serial_No__c = \''+prdReg.IPACU_Serial_No__c+'\'';
                }
            }else if(prdReg.Product_Line__c=='Satellite Television' && prdReg.Product__c=='Other'){
                if(prdReg.Antenna_Serial_No__c!=null){
                    queryStr += 'Antenna_Serial_No__c = \''+prdReg.Antenna_Serial_No__c+'\'';
                }
            }else{
                if(prdReg.Serial_No__c!=null){
                    queryStr += 'Serial_No__c = \''+prdReg.Serial_No__c+'\'';
                }
            }
            prdRegList = database.query(queryStr);
        }
        if(prdRegList.size()>0){
            return 'yes';
        }
        return 'no';
    }
    
    //Method to get Contact Information of the logged in User
    private static Contact getContactInfo(){
        List<Contact> contactList = new List<Contact>();
        List<User> userInformation = [Select Contact.Id, Serial_Number__c From User Where Id =: UserInfo.getUserId() LIMIT 1];
        if(userInformation.size()>0){
            contactList = [SELECT Id, Email, Phone, FirstName,MailingCountry,MailingState, LastName, LTE_Antenna_Number__c 
                           FROM Contact 
                           WHERE Id =: userInformation.get(0).Contact.Id 
                           LIMIT 1];
            if(contactList.size()>0){
                return contactList[0];    
            }
        }
        return null;
    }
    
    //Method to get Platform Types(Platform_Type__c), Application(Market__c) and Application Type(Vessel_Type__c) 
    private static map<string, map<string, list<string>>> getVesselTypeMap(){
        
        map<string, map<string, list<string>>> vesselTypeMap = new map<string, map<string, list<string>>>();
        set<string> forDuplicate = new set<string>();
        
        list<Platform_Market_Sector__c> platformMarktSectors = [SELECT Id,Name, Market__c,Vessel_Type__c,
                                                                Sector__c, LTE_Vessel_Card__c,Platform_Type__c 
                                                                FROM Platform_Market_Sector__c
                                                                WHERE (Platform_Type__c = 'Vehicle' AND (Sector__c = 'Land Systems' OR Sector__c = 'RV & Auto Systems'))
                                                                OR (Platform_Type__c = 'Vessel' AND (Sector__c = 'Marine Systems' OR Sector__c = 'Maritime Systems'))
                                                                ORDER BY Name ASC];
        if(platformMarktSectors.size()>0){
            for(Platform_Market_Sector__c pms: platformMarktSectors){
                if(pms.Platform_Type__c!=null){
                    if(!vesselTypeMap.containsKey(pms.Platform_Type__c)){
                        vesselTypeMap.put(pms.Platform_Type__c, new map<string, list<string>>());
                    }
                    map<string, list<string>> applicationMap = vesselTypeMap.get(pms.Platform_Type__c);
                    if(pms.Market__c!=null && !applicationMap.containsKey(pms.Market__c)){
                        applicationMap.put(pms.Market__c, new list<string>());
                    }
                    if(pms.Vessel_Type__c!=null){
                        if(!forDuplicate.contains(pms.Platform_Type__c+pms.Market__c+pms.Vessel_Type__c)){
                            applicationMap.get(pms.Market__c).add(pms.Vessel_Type__c);
                            forDuplicate.add(pms.Platform_Type__c+pms.Market__c+pms.Vessel_Type__c);
                        }
                    }
                }
            }
        }
        return vesselTypeMap;
    }
    
    //Method to get/create Product Registration
    private static Product_Registration__c getProductRegistration(){
        
        User loginUser = [Select Id,Name,ContactId,Serial_Number__c From User Where Id =: UserInfo.getUserId()];
        List<Product_Registration__c> lstProdReg = new List<Product_Registration__c>();
        lstProdReg = [SELECT Id, Status__c, Subscriber_Country__c, Installer_Country__c, Billing_Country__c, Shipping_Country__c
                      FROM Product_Registration__c
                      Where Portal_Contact__c =: loginUser.ContactId AND Status__c = 'In Progress'];
        if(lstProdReg.size() == 0 && loginUser.ContactId != null){
            Product_Registration__c prodReg = new Product_Registration__c();
            prodReg.Portal_Contact__c = loginUser.ContactId;
            prodReg.Status__c = 'In Progress';
            prodReg.Shipping_Country__c = 'United States';
            prodReg.Subscriber_Country__c = 'United States';
            prodReg.Installer_Country__c = 'United States';
            prodReg.Billing_Country__c = 'United States';
            insert prodReg;
            lstProdReg.add(prodReg);
        }
        Contact con = getContactInfo();
        if(con!=null){
            lstProdReg[0].Contact__c = con.Id;
            lstProdReg[0].Subscriber_First_Name__c = con.FirstName!=null ? con.FirstName : '';
            lstProdReg[0].Subscriber_Last_Name__c = con.LastName!=null ? con.LastName : '';
            lstProdReg[0].Subscriber_Email__c = con.Email!=null ? con.Email : '';
            lstProdReg[0].Contact_email__c = con.Email!=null ? con.Email : '';
            lstProdReg[0].Subscriber_Phone__c = con.Phone!=null ? con.Phone : '';
            lstProdReg[0].Subscriber_Country__c = con.MailingCountry!=null ? con.MailingCountry : '';
            lstProdReg[0].Subscriber_State_Province_Territory__c = con.MailingState!=null ? con.MailingState : '';
        }
        
        return lstProdReg[0];
    }
    
    //Method to get fetching the country and state
    private static map<string, Object> getCountryState(map<string, Object> responseMap){
        map<string,list<string>> countryStateMap = new map<string,list<string>>();
        list<KVH_Countries__mdt> countires = [SELECT Id, TrimmedName__c, IsoCode_2__c, IsoCode_3__c 
                                              FROM KVH_Countries__mdt
                                              WHERE (Enabled__c =: true AND IsObsolete__c =: false)
                                              ORDER BY TrimmedName__c ASC];
        if(countires.size()>0){
            responseMap.put('countries',countires);
            for(KVH_Countries__mdt contry: countires){
                if(contry.IsoCode_2__c!=null){
                    countryStateMap.put(contry.IsoCode_2__c,new list<string>());    
                }
            }
            if(countryStateMap.size()>0){
                for(KVH_States__mdt state: [SELECT Id, CountryIsoCode_2__c,IsoCode__c,TrimmedName__c FROM KVH_States__mdt WHERE CountryIsoCode_2__c =: countryStateMap.keySet() ORDER BY TrimmedName__c ASC]){
                    if(countryStateMap.containsKey(state.CountryIsoCode_2__c)){
                        countryStateMap.get(state.CountryIsoCode_2__c).add(state.TrimmedName__c);
                        (countryStateMap.get(state.CountryIsoCode_2__c)).sort();
                    }
                }
                responseMap.put('countryStateMap',countryStateMap);
            }
        }
        return responseMap;
    }
    
    //Method to get all Product Line and Products
    private static map<string,list<string>> getProductLineMap(){
        map<string,list<string>> prodLineMap = new map<string,list<string>>();
        list<Product2> products = [SELECT Id,Name,Catalog_Display_Name__c,Product_Line1__c 
                                   FROM Product2
                                   WHERE (Product_Line1__c = 'Satellite Television' OR Product_Line1__c = 'Compasses') 
                                   AND isActive = TRUE 
                                   AND Display_Product__c = 'Yes' 
                                   AND Retired__c = FALSE
                                   ORDER BY Name ASC];
        if(products.size()>0){
            for(Product2 prd: products){
                if(!prodLineMap.containsKey(prd.Product_Line1__c)){
                    prodLineMap.put(prd.Product_Line1__c, new list<string>());
                }
                if(prd.Catalog_Display_Name__c!=null){
                    prodLineMap.get(prd.Product_Line1__c).add(prd.Catalog_Display_Name__c);    
                }
            }
        }
        return prodLineMap;
    }
    
    //Method to get list of attachments of Product Registration
    private static list<attachmentListWrapper> getAttachments(string prdRegId){
        list<ContentDocumentLink> lstConDocLink = new list<ContentDocumentLink>();
        list<attachmentListWrapper> lstAttachWrap = new list<attachmentListWrapper>();
        set<Id> contentDocIds = new set<Id>();
        map<Id,Id> contentDocIdVerIdMap = new map<Id,Id>();
        if(prdRegId!=null){
            lstConDocLink = [SELECT ContentDocumentID,LinkedEntityId, ContentDocument.CreatedDate,ContentDocument.Title,  
                             ContentDocument.ContentSize,ContentDocument.FileType,ContentDocument.CreatedBy.Name, LinkedEntity.type,LinkedEntity.Name 
                             FROM ContentDocumentLink 
                             WHERE LinkedEntityId =: prdRegId];
            for(ContentDocumentLink cvDocLink : lstConDocLink)
                contentDocIds.add(cvDocLink.ContentDocumentID);
            if(contentDocIds.size() > 0){
                for(ContentVersion cv: [SELECT Id, ContentDocumentId, RecordTypeId, IsLatest, ContentUrl, ContentBodyId, VersionNumber, Title, Description 
                                        FROM ContentVersion 
                                        WHERE ContentDocumentId =: contentDocIds])
                    contentDocIdVerIdMap.put(cv.ContentDocumentId,cv.Id); 
            }
            
            for(ContentDocumentLink tempAttach: lstConDocLink){
                attachmentListWrapper wrapAttach = new attachmentListWrapper();
                wrapAttach.attachId = tempAttach.ContentDocument.Id;
                wrapAttach.attachName = tempAttach.ContentDocument.Title;              
                wrapAttach.attachSize = FileSizeToString(tempAttach.ContentDocument.ContentSize);                 
                wrapAttach.attachType = tempAttach.ContentDocument.FileType;  
                if(contentDocIdVerIdMap.containskey(tempAttach.ContentDocumentID))
                    wrapAttach.attachDocVerId = contentDocIdVerIdMap.get(tempAttach.ContentDocumentID);                        
                wrapAttach.attachsObject = 'Files';                        
                lstAttachWrap.add(wrapAttach);
            }
        }
        return lstAttachWrap;
    }
    
    //Method to convert the attach file size in Bytes,KB,MB,GB
    @TestVisible
    private static String FileSizeToString(Long Value){
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
    
    public class attachmentListWrapper{
        @AuraEnabled public string attachId {get;set;}
        @AuraEnabled public string attachName {get;set;}        
        @AuraEnabled public string attachType {get;set;}
        @AuraEnabled public string attachSize {get;set;}     
        @AuraEnabled public string attachsObject {get;set;}   
        @AuraEnabled public string attachDocVerId {get;set;}           
    }
}