/*******************************************************************
    Name        :    myKVH_MyRegisteredProductsController
    Description :    Controller for my-registered-products page
********************************************************************/
public without sharing class myKVH_MyRegisteredProductsController{
    
    /******************************************
        Name        :    initialize
        Description :    intialize component on load
    *******************************************/
    @AuraEnabled
    public static Map<String,Object> initializeComponent(){
        Map<String,Object> resultMap = new Map<String,Object>();
        User userObj = getLoginUserRecord();
        resultMap.put('userObj',userObj);
        Map<String,Object> resultMap2 = getRegisteredProducts(userObj.accountId);
        resultMap.put('accountlist',resultMap2.get('accountlist'));
        resultMap.put('ckListMap',resultMap2.get('ckListMap'));
        resultMap.put('popMap',resultMap2.get('popMap'));
        resultMap.put('productRegInProgress',getProductRegistrationStatus(userObj.ContactId));
        return resultMap;
    }
    
    /******************************************
        Name        :    fetechProductRegistratoinDetails
        Description :    get list of product registration 
                         form details
    *******************************************/
     @AuraEnabled
    public static Product_Registration__c fetechProductRegistratoinDetails(String prodRegId){
        List<Product_Registration__c> prodReglist = [Select id,name,Subscriber_First_Name__c,Subscriber_Last_Name__c,Subscriber_Address__c,
                        Subscriber_City__c,Subscriber_Company_Name__c,Subscriber_Country__c,Subscriber_Email__c,
                        Subscriber_State_Province_Territory__c,Subscriber_Phone__c,Subscriber_Postal_Zip_Code__c,
                        Platform_Type__c,Application__c,Application_Type__c,RV_or_Vehicle_Make_Model__c,
                        Vessel_Name__c,Installer_Information__c,Installer_Contact_Name__c,Installer_Address__c,Installer_Country__c,
                        Installer_Zip_Code__c,Installer_State_Province_Territory__c,Installer_City__c,Installer_Manufacture__c,
                        Product_Line__c,Product__c,Serial_No__c,Other_System__c,Antenna_Serial_No__c,IPACU_Serial_No__c,
                        TV_Hub_Serial_No__c,Purchase_Date__c,Scheduled_Installation_Date__c,Purchased_From__c,
                        Free_DirectTV_or_DISH_receiver_requested__c,Other_Installation__c,Satellite_TV_Provider__c,
                        DIRECTV_Subscriber_Status__c,DIRECTV_Account_Number__c from Product_Registration__c WHERE ID =: prodRegId];
        if(prodReglist.size()>0)
            return prodReglist[0];
        return null;
    }
    
    /******************************************
        Name        :    getLoginUserRecord
        Description :    get login user object record
    *******************************************/
    private static user getLoginUserRecord(){
        return [Select id,myKVH_Role__c,accountId,Name,Firstname,ContactId from User where ID =: userinfo.getuserId()];
    }
    
    /******************************************
        Name        :    getProductRegistrationStatus
        Description :    get login user's product registration 
                        status
    *******************************************/
    private static Boolean getProductRegistrationStatus(String contactid){
       List<Product_Registration__c> prodReglist = [Select Id,Status__c from Product_Registration__c WHERE Portal_Contact__c =: contactid AND Status__c IN ('Processing','Submitted')];
        if(prodReglist.size() > 0){
            return true;
        }else{
            return false;
        }
    }
    
    /******************************************
        Name        :    getRegisteredProducts
        Description :    get list of registered products
    *******************************************/
    private static Map<String,Object> getRegisteredProducts(String useraccountId){
        Map<String,Object> resultMap = new Map<String,Object>();
        
        Set<String> accountIds = getPlatformAccounts(useraccountId);
        
        Map<String,Vessel> vesselMap = new Map<String,Vessel>();
        Map<String,FleetAccount> fleetAccountMap = new Map<String,FleetAccount>();
        Map<String,AccountModal> accountModalMap = new Map<String,AccountModal>();
        String vesselId,fleetid,mainAccountId;
        boolean newVesseladded = false;
        boolean newFleetadded = false;
        Set<String> productRegistrationIds = new Set<String>();
        
        //fetch assets and Registration
        List<Asset> assetlist =  [Select id,Product2Id,Product2.Catalog_Display_Name__c,Product2.ProductCode,SerialNumber,Product2.Name,
                                    Account.Id,Account.Name,Account.Parent.Id,Account.Parent.Name,Account.Parent.Parent.Parent.ID,
                                    Account.Parent.Parent.Parent.Name,
                                    Account.Parent.Parent.ID,Account.Parent.Parent.Name,
                                    Dealer_Distributor__r.Name,Service_Activation_Date__c,
                                    (Select id,name from Product_Registrations__r limit 1)
                                    FROM Asset
                                    WHERE AccountId IN : accountIds AND Item__c LIKE '01%'];
        for(Asset a :assetlist){
            if(a.Product_Registrations__r != null && a.Product_Registrations__r.size()>0){
                 productRegistrationIds.add(a.Product_Registrations__r[0].Id);
            }
        }
        
        Map<String,DocumentWrapper> popMap = new Map<String,DocumentWrapper>();
        Map<String,DocumentWrapper> ckListMap = new Map<String,DocumentWrapper>();
        if(productRegistrationIds.size()>0){
            Map<String,String> contentDocumentMap = new Map<String,String>();
            for(ContentDocumentLink doc : [Select ContentDocumentId,LinkedEntityId from ContentDocumentLink WHERE LinkedEntityId IN : productRegistrationIds]){
                contentDocumentMap.put(doc.ContentDocumentId, doc.LinkedEntityId);
            }
            for(ContentVersion doc : [SELECT ID,ContentDocumentId,ContentDocument.title FROM ContentVersion 
                                           WHERE ContentDocumentId IN : contentDocumentMap.keyset() AND IsLatest = true]){
                
                DocumentWrapper docWrapper = new DocumentWrapper(doc);
                if(doc.ContentDocument.title.endsWithIgnoreCase('_CkList')){
                       ckListMap.put(contentDocumentMap.get(doc.ContentDocumentId),docWrapper);                            
                }else if(doc.ContentDocument.title.endsWithIgnoreCase('_POP')){
                      popMap.put(contentDocumentMap.get(doc.ContentDocumentId),docWrapper);                            
                }
            }
        }
        
        for(Asset a :assetlist){
            DocumentWrapper popDocument;
        	DocumentWrapper ckListDocument;
            if(a.Product_Registrations__r != null && a.Product_Registrations__r.size()>0){
                if(popMap.containskey(a.Product_Registrations__r[0].Id)){
                    popDocument = popMap.get(a.Product_Registrations__r[0].Id);
                }
                if(ckListMap.containskey(a.Product_Registrations__r[0].Id)){
                    ckListDocument = ckListMap.get(a.Product_Registrations__r[0].Id);
                }
            }
            vesselId = a.Account.Id + '#' + a.Account.Parent.Parent.Id + '#' + a.Account.Parent.Parent.Parent.ID;
            fleetid = a.Account.Parent.Parent.Id + '#' + a.Account.Parent.Parent.ID;
            mainAccountId = a.Account.Parent.Parent.Parent.ID;
            Vessel vesselObj = vesselMap.get(vesselId);
            if(vesselObj == null){
                vesselObj = new Vessel();
                vesselObj.vesselId = vesselId;
                vesselObj.vesselAccountId = a.Account.Id;
                vesselObj.vesselName = a.Account.Name;
                newVesseladded = true;
            }
            RegisteredAsset assetObj = new RegisteredAsset(a,popDocument,ckListDocument);
            vesselObj.assetlist.add(assetObj);
            vesselMap.put(vesselId,vesselObj);
            
            FleetAccount fleetAccountObj = fleetAccountMap.get(fleetid);
            if(fleetAccountObj == null){
                fleetAccountObj = new FleetAccount();
                fleetAccountObj.fleetId = fleetid;
                fleetAccountObj.fleetAccountId = a.Account.Parent.Parent.Id;
                fleetAccountObj.fleetAccountName = a.Account.Parent.Parent.Name;
                newFleetadded = true;
            }
            if(newVesseladded){
                fleetAccountObj.vessellist.add(vesselObj); 
                fleetAccountMap.put(fleetid,fleetAccountObj);
            }
            newVesseladded = false;
                
            AccountModal accountModalObj = accountModalMap.get(mainAccountId);
            if(accountModalObj == null){
                accountModalObj = new AccountModal();
                accountModalObj.accountId = mainAccountId;
                accountModalObj.accountName = a.Account.Parent.Parent.Parent.Name;
            }
            if(newFleetadded){
                accountModalObj.fleetAccountlist.add(fleetAccountObj);
                accountModalMap.put(mainAccountId,accountModalObj);
            }
            newFleetadded = false;
        }
        
        
        
        if(accountModalMap.size()>0){
            resultMap.put('accountlist',accountModalMap.values());
        }else{
            resultMap.put('accountlist',new List<AccountModal>());
        }
        
        resultMap.put('ckListMap',ckListMap);
        resultMap.put('popMap',popMap);
        return resultMap;
    }
    
    /******************************************
        Name        :    getAccounthierarchy
        Description :    get set login users account hierarchy
    *******************************************/
    private static Set<String> getPlatformAccounts(String useraccountId){
        
       Set<String> platformRecordTypes = getPlatformAccountRecordTypes();
        //first fetch accounts which come in the login user's account hierarchy
        AccountHierarchyUtility util = new AccountHierarchyUtility();
        AccountHierarchyUtility.ObjectStructureMap[] accStructure = util.formatObjectStructure(useraccountId,false);
        Set<String> accountIds = new Set<String>();
        if(accStructure != null && accStructure.size()>0){
            for(AccountHierarchyUtility.ObjectStructureMap asobj : accStructure){
                if(asobj.account != null && asobj.account.RecordTypeId != null){
                    String recordTypeID = String.valueOf(asobj.account.RecordTypeId);
                    if(recordTypeID.length()>15){
                        recordTypeID = recordTypeID.substring(0,15);
                        if(platformRecordTypes.contains(recordTypeID))
                            accountIds.add(asobj.account.Id);
                    }
                    
                    
                }
            }
        }
        
        return accountIds;
    }
    
    /******************************************
        Name        :    getPlatformAccountRecordTypes
        Description :    get the set of Platform Account record Type ids
    *******************************************/
    private static Set<String> getPlatformAccountRecordTypes(){
        Set<String> recordTypes = new Set<String>();
        for(String rId : Label.mykvh_My_Registered_Product_Platform_Account_Record_Type_IDs.split(';')){
            if(rId != null)
                recordTypes.add(rId.trim());
        }
        return recordTypes;
    }
    
     /******************************************
        Name        :    createSupportCase
        Description :    creating support case
    *******************************************/
    @AuraEnabled
    public static void createSupportCase(String subject, String description,List<String> documentIds,String caseRecordTypeName){
        try{
            Case newCase = new Case();
            Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(caseRecordTypeName).getRecordTypeId();
            newCase.recordTypeId = devRecordTypeId;
            
            newCase.Description = description;
            newCase.subject = subject;
            
            
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.useDefaultRule= true;
            newCase.setOptions(dmlOpts); 
            newCase.Origin = 'Web';
            insert newCase;
            
            //create document link object if there are attachments
            if(documentIds.size()>0){
                List<ContentDocumentLink> doclinks = new List<ContentDocumentLink>();
                for(String docId : documentIds){
                    ContentDocumentLink dLink = new ContentDocumentLink();
                    dLink.ContentDocumentId = docId;
                    dLink.LinkedEntityId = newCase.ID;
                    dLink.ShareType = 'V';
                    doclinks.add(dLink);                    
                }
                if(doclinks.size()>0)
                    insert doclinks;
            }
        }catch(Exception ex){
           throw new AuraHandledException(ex.getMessage());
        }
    }
    
    /******************************************
        Name        :    deleteDocuments
        Description :    delete docuemnts by passed IDs
    *******************************************/
    @AuraEnabled
    public static void deleteDocuments(List<String> docIds){
        list<ContentDocument> contentDocs =  [SELECT Id FROM ContentDocument where Id IN : docIds];
        if(contentDocs.size()>0){
            delete contentDocs;
        }
    }
    
    
     /******************************************
        Name        :    updateNewDocuemntSuffix
        Description :    creating support case
    *******************************************/
    @AuraEnabled
    public static String updateNewDocuemntSuffix(String suffix, String documentId,String prodRegId){
        try{
            String newDocuemntVersionId;
            List<ContentDocument> documentlist =[Select id,title from ContentDocument WHERE ID =: documentId];
            
            Set<String> deleteDocIds = new Set<String>();
            for(ContentDocumentLink doc :  [Select ContentDocumentId,LinkedEntityId,ContentDocument.Title
                                        from ContentDocumentLink WHERE LinkedEntityId =: prodRegId]){
              if(doc.ContentDocument.title.endsWithIgnoreCase('_'+suffix) && doc.ContentDocumentId != documentId){
                    deleteDocIds.add(doc.ContentDocumentId);                            
              }              
            }
            
            if(documentlist.size() > 0){
                documentlist[0].title = documentlist[0].title+'_'+suffix;
                update documentlist[0];       
                if(deleteDocIds.size()>0){
                    List<ContentDocument> deletelist = [Select id from ContentDocument WHERE ID IN : deleteDocIds];    
                    if(deletelist.size()>0)
                        delete deletelist;
                }
                List<ContentVersion> contentVersionId = [Select id from ContentVersion WHERE ContentDocumentID =: documentId AND IsLatest = true LIMIT 1];
                if(contentVersionId.size()>0)
                    newDocuemntVersionId = contentVersionId[0].Id;
                return newDocuemntVersionId;
            }
        }catch(Exception ex){
           throw new AuraHandledException(ex.getMessage());
        }
        return null;
    }
    
    
    //wrapper class for main accounts
    public class AccountModal{
        @AuraEnabled
        public String accountId{get;set;}
        @AuraEnabled
        public String accountName{get;set;}
        @AuraEnabled
        public List<FleetAccount> fleetAccountlist{get;set;}
        
        public AccountModal(){
            this.fleetAccountlist = new List<FleetAccount>();
        }
    }
    
    //wrapper class for FleetAccount
    public class FleetAccount{
    @AuraEnabled
        public String fleetId{get;set;}
        @AuraEnabled
        public String fleetAccountId{get;set;}
        @AuraEnabled
        public String fleetAccountName{get;set;}
        @AuraEnabled
        public List<Vessel> vessellist{get;set;}
        
        public FleetAccount(){
            this.vessellist = new List<Vessel>();
        }
    }
    
    //wrapper class for Vessel
    public class Vessel{
        @AuraEnabled
        public String vesselId{get;set;}
        @AuraEnabled
        public String vesselName{get;set;}
        @AuraEnabled
        public String vesselAccountId{get;set;}
        @AuraEnabled
        public List<RegisteredAsset> assetlist{get;set;}
        
        public Vessel(){
            this.assetlist = new List<RegisteredAsset>();
        }
    }
    
    //wrapper class for Asset
    public class RegisteredAsset{
        @AuraEnabled
        public String productId{get;set;}
        @AuraEnabled
        public String productDisplayName{get;set;}
        @AuraEnabled
        public String serialNumber;
        @AuraEnabled
        public String purchasedFrom;
        @AuraEnabled
        public Date activationDate;
        @AuraEnabled
        public boolean showICMserialNumber;
        @AuraEnabled
        public Product_Registration__c prodReg;     
        @AuraEnabled
        public DocumentWrapper popDocument;
        @AuraEnabled
        public DocumentWrapper ckListDocument;
        
        public RegisteredAsset(Asset a,DocumentWrapper popDocument,DocumentWrapper ckListDocument){
            this.productId = a.Product2Id;
            //this.productDisplayName = a.Product2.Catalog_Display_Name__c;
            this.productDisplayName = a.Product2.Name;
            this.serialNumber = a.SerialNumber;
            this.purchasedFrom = a.Dealer_Distributor__r.Name;
            this.activationDate = a.Service_Activation_Date__c;
            if(a.Product2.productcode != null && (a.Product2.ProductCode.startswith('02-2008') 
                                                  || a.Product2.ProductCode.startswith('02-2204'))){
                this.showICMserialNumber = true;
            }else{
                this.showICMserialNumber = false;
            }
            if(a.Product_Registrations__r != null && a.Product_Registrations__r.size()>0){
                this.prodReg = a.Product_Registrations__r[0];
            }
            this.popDocument = popDocument;
            this.ckListDocument = ckListDocument;
        }
    }
    
     //wrapper class for Docuemnts
    public class DocumentWrapper{
        @AuraEnabled
        public String documentId;
        @AuraEnabled
        public String doucmentName;        
        public DocumentWrapper(ContentVersion doc){
            this.documentId = doc.Id;
            this.doucmentName = doc.ContentDocument.title;
        }
    }
}