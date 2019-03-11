/**
* @createdby        :   Teertha prasad
* @createddate      :   06/01/2017
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   06/16/2017
* @description      :   Class Used In Product_Registration_Review Component to review registered product and submit
**/ 
public class Product_Registration_Review_Ctrl {
    
    private String strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Product Registration').getRecordTypeId();
    private String strActivationOrderRecordTypeId = Schema.SObjectType.Activation_Order__c.getRecordTypeInfosByName().get('Product Registration').getRecordTypeId();
    private static String strAuthorizedRepRole = 'Authorized Representative';      // Contact Authorized Rep Role can be taken from custom labels later
    public Transient List<wrapAllRegisteredProductsDetail> lstwrapAllRegisteredProductsDetail {get; set;}
    private map<String, list<String>> mapMarketANDSector; // Instead of this we can use Custom Setting
    public Transient String selectedMarketType {get; set;}
    
    public Product_Registration_Review_Ctrl(){
        String strOrderId =  ApexPages.currentPage().getParameters().get('order');       //extract Order Id
        createMarketANDSectorData();
        lstwrapAllRegisteredProductsDetail = New List<wrapAllRegisteredProductsDetail> ();
        Set<Id> setActivationHardwareIds = New Set<Id>();
        for(Activation_Order__c objActivationOrderTemp : [SELECT Id,Installed_By__c,Contract_Term__c,Hardware_Purchased_or_Leased__c,Activation_Type__c,
                                                          Activation_Opportunity__c,Activation_Opportunity__r.AccountId, Don_t_have_Dealer__c,Main_Contact__c,
                                                          (SELECT Id, Name,Confirm_if_boat_yacht_is_chartered__c, Activation_Order__c, Market__c, Market_Sector__c,
                                                           Flag__c,Vessel_Radio_Call_Sign__c,Vessel_IMO__c,Vessel_Length_ft_m__c,Vehicle_Model__c,Vessel_Info__c,
                                                           Industry_Designation__c,MMSI__c,Vehicle_Make_Model__c,Vehicle_Year__c,Having_IMO__c,Platform_Detail__c
                                                           FROM Activation_Platforms__r),
                                                          (SELECT Id,Address__c,Corporate_Billing_Account__c,Contact__c,Subscriber_Address_Line_2__c,City__c,
                                                           Postal_Zip_Code__c,State_Province__c,Country_Name__c,Billing_Company__c,Preferred_Addressee__c ,
                                                           Billing_Rep_Address__c,Billing_Rep_Address_Line_2__c,Billing_City__c,
                                                           Billing_Zip_Code__c,Bill_to__c,Billing_Country_Name__c,Billing_State_Province__c 
                                                           FROM Activation_Subscribers__r),
                                                          (SELECT Dealer_Phone__c, Id,Installed_By_Boat_Builder__c,
                                                           Company__c, Activation_Order__c ,Country__c, State__c,Dealer_Distributor_Company__c,
                                                           Installing_Dealer_Company__c,Installing_Dealer_Country__c,Installing_Dealer_Name__c,
                                                           Installing_Dealer_State__c,Same_as_Purchase_Dealer__c
                                                           FROM Activation_Dealers__r),
                                                          (SELECT id,First_Name__c,Salutation__c,Last_Name__c,State__c,Primary_Phone_Type__c,
                                                           Email__c,Primary_Phone__c,Job_Function__c,Job_Title__c,Account__c,Country__c,
                                                           Secondary_Phone__c, Secondary_Phone_Type__c,Contact_Role__c,Contact__c
                                                           FROM Activation_Contacts__r WHERE (Contact_Role__c LIKE '%Authorized Representative%' OR Contact_Role__c LIKE '%Main Contact%')),
                                                          (SELECT Id, Root_Asset_Product_Group__c,Do_Not_Know_Serial_Number__c,Have_Proof_of_Purchase__c,
                                                           Below_Decks_Root_Asset__c,Root_Assets_Do_NOT_Match__c,Antenna_Root_Asset__r.Product2.Name,
                                                           Below_Decks_Serial_Number__c,Antenna_Root_Asset__c,Antenna_Serial_Number__c,Purchase_Date__c,System_Detail__c, Product_Line__c, Product_Catalog_Name__c 
                                                           FROM Activation_Hardware__r WHERE RecordTypeId =: strActivationHardwareRecordTypeId ORDER BY CreatedDate ASC LIMIT 1)
                                                          FROM Activation_Order__c WHERE RecordTypeId =: strActivationOrderRecordTypeId AND Id =: strOrderId]){ //  Main_Contact__c != null AND Main_Contact__c IN (SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId()) ORDER BY LastModifieddate DESC
                                                              wrapAllRegisteredProductsDetail objwrapAllRegisteredProductsDetail = New wrapAllRegisteredProductsDetail();
                                                              objwrapAllRegisteredProductsDetail.objActivationOrder = New Activation_Order__c();
                                                              objwrapAllRegisteredProductsDetail.lstActivationContact = New List<Activation_Contact__c>();
                                                              objwrapAllRegisteredProductsDetail.objActivationPlatform = New Activation_Platform__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationHardware = New Activation_Hardware__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationDealer = New Activation_Dealer__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationmainContact = New Activation_Contact__c();
                                                              objwrapAllRegisteredProductsDetail.objActivationSubscriber = New Activation_Subscriber__c();
															  
                                                              objwrapAllRegisteredProductsDetail.objActivationOrder = objActivationOrderTemp;
                                                              
                                                              for(Activation_Dealer__c objActivationDealer1 : objActivationOrderTemp.Activation_Dealers__r){
                                                                  objwrapAllRegisteredProductsDetail.objActivationDealer = objActivationDealer1;
                                                              }
															  
                                                              for(Activation_Subscriber__c objActivationSubscriber1 : objActivationOrderTemp.Activation_Subscribers__r){
                                                                  objwrapAllRegisteredProductsDetail.objActivationSubscriber  = objActivationSubscriber1;
                                                              }
															  
                                                              for(Activation_Platform__c objActivationPlatform1 : objActivationOrderTemp.Activation_Platforms__r){
                                                                  list<String> lsttemp = New list<String>();
                                                                  if(objActivationPlatform1.Market__c != null){
                                                                      lsttemp.add(objActivationPlatform1.Market__c.replace(',','*'));
                                                                  }
                                                                  if(objActivationPlatform1.Market_Sector__c != null){
                                                                      lsttemp.add(objActivationPlatform1.Market_Sector__c.replace(',','*'));
                                                                  }
                                                                  for(String strKey :mapMarketANDSector.keySet()){
                                                                      set<String> setTemp = New set<String>();
                                                                      setTemp.addAll(mapMarketANDSector.get(strKey));
                                                                      if(lsttemp.size()>0 && setTemp.containsAll(lsttemp)){
                                                                          selectedMarketType = strKey;
                                                                      }
                                                                  }
                                                                  objwrapAllRegisteredProductsDetail.objActivationPlatform  = objActivationPlatform1;
                                                                  
                                                              }
                                                              for(Activation_Hardware__c objActivationHardware1 : objActivationOrderTemp.Activation_Hardware__r){
                                                                  objwrapAllRegisteredProductsDetail.objActivationHardware = objActivationHardware1;
                                                                  setActivationHardwareIds.add(objActivationHardware1.Id);
                                                              }
                                                              for(Activation_Contact__c objActivationContact1 : objActivationOrderTemp.Activation_Contacts__r){
                                                                  if(objActivationContact1.Contact_Role__c.ContainsIgnoreCase('Main Contact'))
                                                                      objwrapAllRegisteredProductsDetail.objActivationmainContact = objActivationContact1;
                                                                  else
                                                                      objwrapAllRegisteredProductsDetail.lstActivationContact.add(objActivationContact1);
                                                              }
                                                              objwrapAllRegisteredProductsDetail.lstAttachment = New List<Attachment>();
                                                              lstwrapAllRegisteredProductsDetail.add(objwrapAllRegisteredProductsDetail);
                                                          }
        
        for( Attachment objAttachmentTemp : [SELECT Id,Name,ContentType,Body,ParentId FROM Attachment WHERE ParentId IN: setActivationHardwareIds]){
            for(wrapAllRegisteredProductsDetail objwrapAllRegisteredProductsDetail : lstwrapAllRegisteredProductsDetail ){
                if(objwrapAllRegisteredProductsDetail.objActivationHardware.Id == objAttachmentTemp.parentId){
                    objwrapAllRegisteredProductsDetail.lstAttachment.add(objAttachmentTemp);
                }
            }
        }
    }
    
    public class wrapAllRegisteredProductsDetail{
        public Transient Activation_Order__c objActivationOrder {get; set;}
        public Transient List<Activation_Contact__c> lstActivationContact {get; set;}
        public Transient Activation_Platform__c objActivationPlatform {get; set;}
        public Transient Activation_Contact__c objActivationmainContact {get; set;}
		public Transient Activation_Subscriber__c objActivationSubscriber {get; set;}
        public Transient Activation_Hardware__c objActivationHardware {get; set;} 
        public Transient Activation_Dealer__c objActivationDealer {get; set;} 
        public Transient List<Attachment> lstAttachment {get; set;}
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   08/07/2016
* @description          :   createMarketANDSectorData Method.
*                           Custom Data to map vessel type to market and market sector.
*                           (Can be removed by using custom setting)
* @return               :   void
* @invoke               :   From constructor 
**/   
    private void createMarketANDSectorData(){
        mapMarketANDSector = New map<String, list<String>> ();
        list<String> lsttemp = New list<String>();
        lsttemp.add('Commercial & OEM');
        lsttemp.add('Maritime');
        mapMarketANDSector.put('Commercial Vessel', lsttemp);
        
        lsttemp = New list<String>();
        lsttemp.add('Leisure');
        lsttemp.add('Marine');
        mapMarketANDSector.put('Leisure Vessel', lsttemp);
        
        lsttemp = New list<String>();
        lsttemp.add('Mil/Gov');
        lsttemp.add('Maritime');
        mapMarketANDSector.put('Military/Government Vessel', lsttemp);
        
        lsttemp = New list<String>();
        lsttemp.add('Commercial & OEM');
        lsttemp.add('Land');
        mapMarketANDSector.put('Commercial Vehicle/Platform', lsttemp);
        
        lsttemp = New list<String>();
        lsttemp.add('Leisure');
        lsttemp.add('RV');
        mapMarketANDSector.put('Leisure RV', lsttemp);
        
        lsttemp = New list<String>();
        lsttemp.add('Leisure');
        lsttemp.add('Auto/12V');
        mapMarketANDSector.put('Leisure Automobiler', lsttemp);
        
        lsttemp = New list<String>();
        lsttemp.add('Mil/Gov');
        lsttemp.add('Land');
        mapMarketANDSector.put('Military/Government Vehicle/Platform', lsttemp);
        
    }
    
}