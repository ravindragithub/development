public class myKVH_Product_RegistrationController{
    
    @AuraEnabled
    public static map<string, Object> getIntiData(){
        try{
            map<string, Object> responseMap = new map<string, Object>();
            Product_Registration__c prdReg = getProductRegistration();
            responseMap.put('prodRegistration',prdReg);
            responseMap.put('attList',getAttachments(new list<Id>{prdReg.Id}));
            getCountryState(responseMap);
            return responseMap;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    //Method to get list of attachments of Product Registration
    @AuraEnabled
    public static list<attachmentListWrapper> getAttachments(list<Id> prdRegIds){
        list<ContentDocumentLink> lstConDocLink = new list<ContentDocumentLink>();
        list<attachmentListWrapper> lstAttachWrap = new list<attachmentListWrapper>();
        set<Id> contentDocIds = new set<Id>();
        map<Id,Id> contentDocIdVerIdMap = new map<Id,Id>();
        if(prdRegIds.size() > 0){
            lstConDocLink = [SELECT ContentDocumentID,LinkedEntityId, ContentDocument.CreatedDate,ContentDocument.Title,  
                             ContentDocument.ContentSize,ContentDocument.FileType,ContentDocument.CreatedBy.Name, LinkedEntity.type,LinkedEntity.Name 
                             FROM ContentDocumentLink 
                             WHERE LinkedEntityId IN: prdRegIds];
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
                wrapAttach.attachSize = PRDReg_Controller.FileSizeToString(tempAttach.ContentDocument.ContentSize);                 
                wrapAttach.attachType = tempAttach.ContentDocument.FileType;  
                if(contentDocIdVerIdMap.containskey(tempAttach.ContentDocumentID))
                    wrapAttach.attachDocVerId = contentDocIdVerIdMap.get(tempAttach.ContentDocumentID);                        
                wrapAttach.attachsObject = 'Files';                        
                lstAttachWrap.add(wrapAttach);
            }
        }
        return lstAttachWrap;
    }
    
    //Method to add suffix(_POP or _CkList) to the File Name
    @AuraEnabled
    public static list<attachmentListWrapper> updateFileName(string prodRegId, string documentId, string documentName){
        list<attachmentListWrapper> lstAttachWrap = new list<attachmentListWrapper>();
        list<Id> prodRegIds = new list<Id>();
        prodRegIds.add(prodRegId);
        if(prodRegIds.size() > 0){
            if(documentId!=null && documentName!=null){
                ContentDocument cDoc = new ContentDocument(
                    Id = documentId,
                    Title = documentName
                );
                update cDoc;    
            }
            lstAttachWrap = getAttachments(prodRegIds);
        }  
        return lstAttachWrap;
    }
    
    //Method to get Contact Information of the Loggedin User
    @AuraEnabled 
    public static Contact getContactInfo(){
        List<Contact> contactList = new List<Contact>();
        List<User> userInformation = [Select Contact.Id, Serial_Number__c From User Where Id =: UserInfo.getUserId() LIMIT 1];
        if(userInformation.size()>0){
            contactList = [SELECT Id, Email, Phone, FirstName,MailingCountry,MailingState, LastName, LTE_Antenna_Number__c 
                           FROM Contact 
                           WHERE Id =: userInformation.get(0).Contact.Id 
                           LIMIT 1];
            return contactList[0];
        }
        return null;
    }
    
    //Method to get/create Product Registration
    private static Product_Registration__c getProductRegistration(){
        
        User loginUser = [Select Id,Name,ContactId,Serial_Number__c From User Where Id =: UserInfo.getUserId()];
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
        if(loginUser!=null && loginUser.Serial_Number__c!=null){
            lstProdReg[0].Antenna_Serial_No__c = loginUser.Serial_Number__c!=null ? loginUser.Serial_Number__c : '';
            //lstProdReg[0].Is_serial_was_passed__c = true;    
        }
        return lstProdReg[0];
    }
    
    //Method to get fetching the country and state
    private static map<string, Object> getCountryState(map<string, Object> responseMap){
        map<String,list<KVH_States__mdt>> stateMap = new map<String,list<KVH_States__mdt>>();
        set<String> stateEnabledCoutries = new set<String>(); 
        map<String,String> countryIsoCodeMap = new map<String,String>();
        
        list<KVH_Countries__mdt> countires = [SELECT Id,Label,TrimmedName__c,IsoCode_2__c,IsoCode_3__c,IsStateMandatory__c
                                              FROM KVH_Countries__mdt 
                                              ORDER BY Label];
        
        for(KVH_Countries__mdt contry: countires){
            countryIsoCodeMap.put(contry.IsoCode_2__c,contry.Label);         
            if(contry.IsStateMandatory__c){
                stateEnabledCoutries.add(contry.IsoCode_2__c);    
            }
        }
        
        if(stateEnabledCoutries.size()>0){
            for(KVH_States__mdt s : [Select Label,FullIsoCode__c,CountryIsoCode_2__c from KVH_States__mdt where CountryIsoCode_2__c IN : stateEnabledCoutries Order by CountryIsoCode_2__c, Label]){
                List<KVH_States__mdt> statelist = stateMap.get(s.CountryIsoCode_2__c);
                if(statelist == null)
                    statelist = new List<KVH_States__mdt>();
                if(s.Label != 'District of Columbia' && s.Label != 'N/A')
                    statelist.add(s);
                stateMap.put(s.CountryIsoCode_2__c,statelist);
            }
        }
        responseMap.put('countries',countires);
        responseMap.put('stateMap',stateMap);
        responseMap.put('countryIsoCodeMap',countryIsoCodeMap);
        return responseMap;
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