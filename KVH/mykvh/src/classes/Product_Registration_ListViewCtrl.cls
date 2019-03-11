/**
* @createdby        :   Teertha prasad
* @createddate      :   06/21/2017
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   06/29/2017
* @description      :   Class Used In Product_Registration_Listview to view registered products
**/ 
public without sharing class Product_Registration_ListViewCtrl {
    public List<wrapAllRegisteredProductsDetail> lstwrapAllRegisteredProductsDetail {get;set;}
    private Id Customer_RECORD_TYPE_ID = Schema.SObjectType.Activation_Subscriber__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    private Id strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Product Registration').getRecordTypeId();
    private Id strActivationOrderRecordTypeId = Schema.SObjectType.Activation_Order__c.getRecordTypeInfosByName().get('Product Registration').getRecordTypeId();
    private Set<String> setRecordTypeDeveoperNames = New Set<String>{'Platform_Vessel_Maritime','Platform_Vehicle_Commercial_MIL_GOV','Platform_Demo_Test_Monitor','Platform_Vehicle_Leisure_Auto_12Volt','Platform_Vehicle_Leisure_RV','Platform_Vessel_Leisure'};
        
        
        public List<Asset> lstAssets {get; set;}
    public String strSelectedType {get; set;}
    
    public List<SelectOption> getRegistrationTypes() {
        List<SelectOption> lstSelectOptions = New List<SelectOption>();
        lstSelectOptions.add(new SelectOption('Registered_Products','Registered Products'));
        lstSelectOptions.add(new SelectOption('Registrations_In_Progress','Registrations In Progress'));
        lstSelectOptions.add(new SelectOption('Customer_Pending_Confirmation','Pending Customer Confirmation'));
        lstSelectOptions.add(new SelectOption('Submitted_Registrations','Submitted Registrations'));
        return lstSelectOptions;
    }
    
    public Product_Registration_ListViewCtrl(){
        strSelectedType = 'Registered_Products';
        onchangeType();
    }
    
    public pageReference ProductRegistrationLists(){
        for(Activation_Order__c objActivationOrderTemp : [SELECT Id,Installed_By__c,Contract_Term__c,Hardware_Purchased_or_Leased__c,Order_Status__c,
                                                          CreatedBy.Name,Activation_Opportunity__c,Activation_Opportunity__r.AccountId, Don_t_have_Dealer__c,Main_Contact__c,
                                                          (SELECT Id, Name,Confirm_if_boat_yacht_is_chartered__c, Activation_Order__c, Market__c, Market_Sector__c,
                                                           Flag__c,Vessel_Radio_Call_Sign__c,Vessel_IMO__c,Vessel_Length_ft_m__c,Vehicle_Model__c,Vessel_Info__c,
                                                           Industry_Designation__c,MMSI__c,Vehicle_Make_Model__c,Vehicle_Year__c,Having_IMO__c,Platform_Detail__c
                                                           FROM Activation_Platforms__r),
                                                          (SELECT Id,Contact__c,Account__c,Account__r.Name FROM Activation_Subscribers__r
                                                           WHERE RecordTypeId =: Customer_RECORD_TYPE_ID),
                                                          (SELECT Id, Root_Asset_Product_Group__c,Do_Not_Know_Serial_Number__c,Have_Proof_of_Purchase__c,
                                                           Below_Decks_Root_Asset__c,Root_Assets_Do_NOT_Match__c,Antenna_Root_Asset__r.Product2.Name,
                                                           Below_Decks_Serial_Number__c,Antenna_Root_Asset__c,Antenna_Serial_Number__c,Purchase_Date__c,
                                                           System_Detail__c, Product_Line__c, Product_Catalog_Name__c 
                                                           FROM Activation_Hardware__r WHERE RecordTypeId =: strActivationHardwareRecordTypeId ORDER BY CreatedDate ASC LIMIT 1)
                                                          FROM Activation_Order__c WHERE RecordTypeId =: strActivationOrderRecordTypeId AND IsContactLoggedIn__c = 1 AND ((Order_Status__c = 'Pending Customer Confirmation' AND CreatedById !=: UserInfo.getUserId()) OR (Order_Status__c = 'In Progress' AND CreatedById =: UserInfo.getUserId())) ORDER BY CreatedDate DESC]){ 
                                                              wrapAllRegisteredProductsDetail objwrapAllRegisteredProductsDetail = New wrapAllRegisteredProductsDetail();
                                                              objwrapAllRegisteredProductsDetail.objActivationOrder = New Activation_Order__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationPlatform = New Activation_Platform__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationHardware = New Activation_Hardware__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationSubscriber = New Activation_Subscriber__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationOrder = objActivationOrderTemp;
                                                              
                                                              for(Activation_Subscriber__c objActivationSubscriber1 : objActivationOrderTemp.Activation_Subscribers__r){
                                                                  objwrapAllRegisteredProductsDetail.objActivationSubscriber  = objActivationSubscriber1;
                                                              }
                                                              for(Activation_Platform__c objActivationPlatform1 : objActivationOrderTemp.Activation_Platforms__r){
                                                                  objwrapAllRegisteredProductsDetail.objActivationPlatform  = objActivationPlatform1;
                                                              }
                                                              for(Activation_Hardware__c objActivationHardware1 : objActivationOrderTemp.Activation_Hardware__r){
                                                                  objwrapAllRegisteredProductsDetail.objActivationHardware = objActivationHardware1;
                                                              }
                                                              lstwrapAllRegisteredProductsDetail.add(objwrapAllRegisteredProductsDetail);
                                                          }
        
        return null; 
    }
    
    public class wrapAllRegisteredProductsDetail{
        public Transient Activation_Order__c objActivationOrder {get; set;}
        public Transient Activation_Subscriber__c objActivationSubscriber {get; set;}
        public Transient Activation_Platform__c objActivationPlatform {get; set;}
        public Transient Activation_Hardware__c objActivationHardware {get; set;} 
    }
    
    public Pagereference registeredProductsLoad(){
        // system.debug('registeredProductsLoad');
        String strAccountId = '';
        strAccountId = String.valueOf([SELECT AccountId FROM Contact WHERE Id =: String.valueOf([SELECT Id, ContactId FROM User WHERE Id =: UserInfo.getUserId()].ContactId)].AccountId) ;
        if(String.isNotBlank(strAccountId)){
            for(Asset objAsset : [SELECT Id, Account.Name, AccountId, Description, Account.RecordType.DeveloperName, Name, Product2.Name, Product2.Description FROM Asset where accountId != null AND Product2.Id != null AND Parent_Asset__c = null  AND Account.RecordType.DeveloperName  IN: setRecordTypeDeveoperNames AND (AccountId =: strAccountId OR Account.Parent.Id =: strAccountId OR Account.Parent.Parent.Id =: strAccountId OR Account.Parent.Parent.Parent.Id =: strAccountId OR Account.Parent.Parent.Parent.Parent.Id =: strAccountId) ORDER BY Account.Name DESC]){
                lstAssets.add(objAsset);
            }
        }
        return null;
    }
    
    public pageReference ProductRegistrationListsSubmitted(){
        List<User> usr = [select id,contactid from user where id=:userinfo.getuserid() limit 1];
        for(Activation_Order__c objActivationOrderTemp : [SELECT Id,Installed_By__c,Contract_Term__c,Hardware_Purchased_or_Leased__c,Order_Status__c,
                                                          CreatedBy.Name,Activation_Opportunity__c,Activation_Opportunity__r.AccountId, Don_t_have_Dealer__c,Main_Contact__c,
                                                          (SELECT Id, Name,Confirm_if_boat_yacht_is_chartered__c, Activation_Order__c, Market__c, Market_Sector__c,
                                                           Flag__c,Vessel_Radio_Call_Sign__c,Vessel_IMO__c,Vessel_Length_ft_m__c,Vehicle_Model__c,Vessel_Info__c,
                                                           Industry_Designation__c,MMSI__c,Vehicle_Make_Model__c,Vehicle_Year__c,Having_IMO__c,Platform_Detail__c
                                                           FROM Activation_Platforms__r),
                                                          (SELECT Id,Contact__c,Account__c,Account__r.Name FROM Activation_Subscribers__r
                                                           WHERE RecordTypeId =: Customer_RECORD_TYPE_ID),
                                                          (SELECT Id, Root_Asset_Product_Group__c,Do_Not_Know_Serial_Number__c,Have_Proof_of_Purchase__c,
                                                           Below_Decks_Root_Asset__c,Root_Assets_Do_NOT_Match__c,Antenna_Root_Asset__r.Product2.Name,
                                                           Below_Decks_Serial_Number__c,Antenna_Root_Asset__c,Antenna_Serial_Number__c,Purchase_Date__c,
                                                           System_Detail__c, Product_Line__c, Product_Catalog_Name__c 
                                                           FROM Activation_Hardware__r WHERE RecordTypeId =: strActivationHardwareRecordTypeId ORDER BY CreatedDate ASC LIMIT 1)
                                                          FROM Activation_Order__c WHERE RecordTypeId =: strActivationOrderRecordTypeId AND IsContactLoggedIn__c = 1 AND Order_Status__c = 'Submitted' AND Main_Contact__c =: usr[0].contactid ORDER BY CreatedDate DESC]){ 
                                                              wrapAllRegisteredProductsDetail objwrapAllRegisteredProductsDetail = New wrapAllRegisteredProductsDetail();
                                                              objwrapAllRegisteredProductsDetail.objActivationOrder = New Activation_Order__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationPlatform = New Activation_Platform__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationHardware = New Activation_Hardware__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationSubscriber = New Activation_Subscriber__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationOrder = objActivationOrderTemp;
                                                              
                                                              for(Activation_Subscriber__c objActivationSubscriber1 : objActivationOrderTemp.Activation_Subscribers__r){
                                                                  objwrapAllRegisteredProductsDetail.objActivationSubscriber  = objActivationSubscriber1;
                                                              }
                                                              for(Activation_Platform__c objActivationPlatform1 : objActivationOrderTemp.Activation_Platforms__r){
                                                                  objwrapAllRegisteredProductsDetail.objActivationPlatform  = objActivationPlatform1;
                                                              }
                                                              for(Activation_Hardware__c objActivationHardware1 : objActivationOrderTemp.Activation_Hardware__r){
                                                                  objwrapAllRegisteredProductsDetail.objActivationHardware = objActivationHardware1;
                                                              }
                                                              lstwrapAllRegisteredProductsDetail.add(objwrapAllRegisteredProductsDetail);
                                                          }
        
        return null; 
    }
    public pageReference ProductPendingConfirmation(){
        
        List<User> usr = [select id,contactid from user where id=:userinfo.getuserid() limit 1];
        for(Activation_Order__c objActivationOrderTemp : [SELECT Id,Installed_By__c,CreatedDate,Contract_Term__c,Hardware_Purchased_or_Leased__c,Order_Status__c,Activation_Type__c ,
                                                          CreatedBy.Name,Activation_Opportunity__c,Activation_Opportunity__r.AccountId, Don_t_have_Dealer__c,Main_Contact__c,
                                                          (SELECT Id, Name,Confirm_if_boat_yacht_is_chartered__c, Activation_Order__c, Market__c, Market_Sector__c,
                                                           Flag__c,Vessel_Radio_Call_Sign__c,Vessel_IMO__c,Vessel_Length_ft_m__c,Vehicle_Model__c,Vessel_Info__c,
                                                           Industry_Designation__c,MMSI__c,Vehicle_Make_Model__c,Vehicle_Year__c,Having_IMO__c,Platform_Detail__c
                                                           FROM Activation_Platforms__r),
                                                          (SELECT Id,Contact__c,Account__c,Account__r.Name FROM Activation_Subscribers__r
                                                           WHERE RecordTypeId =: Customer_RECORD_TYPE_ID),
                                                          (SELECT Id, Root_Asset_Product_Group__c,Do_Not_Know_Serial_Number__c,Have_Proof_of_Purchase__c,
                                                           Below_Decks_Root_Asset__c,Root_Assets_Do_NOT_Match__c,Antenna_Root_Asset__r.Product2.Name,
                                                           Below_Decks_Serial_Number__c,Antenna_Root_Asset__c,Antenna_Serial_Number__c,Purchase_Date__c,
                                                           System_Detail__c, Product_Line__c, Product_Catalog_Name__c 
                                                           FROM Activation_Hardware__r WHERE RecordTypeId =: strActivationHardwareRecordTypeId ORDER BY CreatedDate ASC LIMIT 1)
                                                          FROM Activation_Order__c WHERE (RecordTypeId =: strActivationOrderRecordTypeId AND Main_Contact__c =: usr[0].contactid AND Activation_Type__c =: 'Registration on behalf of Customer' AND Order_Status__c = 'Pending Customer Confirmation' ) ORDER BY CreatedDate DESC]){ 
                                                              wrapAllRegisteredProductsDetail objwrapAllRegisteredProductsDetail = New wrapAllRegisteredProductsDetail();
                                                              objwrapAllRegisteredProductsDetail.objActivationOrder = New Activation_Order__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationPlatform = New Activation_Platform__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationHardware = New Activation_Hardware__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationSubscriber = New Activation_Subscriber__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationOrder = objActivationOrderTemp;
                                                              
                                                              for(Activation_Subscriber__c objActivationSubscriber1 : objActivationOrderTemp.Activation_Subscribers__r){
                                                                  objwrapAllRegisteredProductsDetail.objActivationSubscriber  = objActivationSubscriber1;
                                                              }
                                                              for(Activation_Platform__c objActivationPlatform1 : objActivationOrderTemp.Activation_Platforms__r){
                                                                  objwrapAllRegisteredProductsDetail.objActivationPlatform  = objActivationPlatform1;
                                                              }
                                                              for(Activation_Hardware__c objActivationHardware1 : objActivationOrderTemp.Activation_Hardware__r){
                                                                  objwrapAllRegisteredProductsDetail.objActivationHardware = objActivationHardware1;
                                                              }
                                                              lstwrapAllRegisteredProductsDetail.add(objwrapAllRegisteredProductsDetail);
                                                          }
        
        return null; 
    }
    public Pagereference onchangeType(){
        lstwrapAllRegisteredProductsDetail = New List<wrapAllRegisteredProductsDetail>();
        lstAssets = New List<Asset>();
        if(strSelectedType == 'Registered_Products'){
            return registeredProductsLoad();
        }else if(strSelectedType == 'Submitted_Registrations'){
            return ProductRegistrationListsSubmitted();
        }else if(strSelectedType == 'Customer_Pending_Confirmation'){
            return ProductPendingConfirmation();
        }else{
            return ProductRegistrationLists();
        }
    }
}