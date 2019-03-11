public class Act_Product_Summary_1_Component_Ctrl extends ActivationsBaseController {
    
    public string selectedTab           {get; set;} //current selected tab from vf page
    public Transient wrapReviewAllData objwrapReviewAllData  {get; set;}
    private String strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Activation System').getRecordTypeId();
    private map<String, list<String>> mapMarketANDSector; // Instead of this we can use Custom Setting

    /** Constructor - Start **/
    public Act_Product_Summary_1_Component_Ctrl(){
        ActivationOrderId = ApexPages.currentPage().getParameters().get('order');    //extract Order Id
        ActivationStatus = readActivationStatus(ActivationOrderId);             //get status record
        selectedTab = ActivationStatus.Services_Active_Tab__c;
        objwrapReviewAllData = New wrapReviewAllData();
        readActivationOrder(ActivationOrderId);
    }
    /** Constructor - End **/
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   12/05/2016
    * @description          :   readActivationOrder Method.
    *                           Create Activation Service If not present, else get Activation Service
    *                           And used in vf page.
    * @return               :   void
    * @invoke               :   From Constructor
    **/
    public void readActivationOrder(String strOrderId){
        objwrapReviewAllData = New wrapReviewAllData();
        objwrapReviewAllData.objActivationOrder = New Activation_Order__c();
        objwrapReviewAllData.objActivationAccount = New Activation_Subscriber__c();
        objwrapReviewAllData.objActivationMainContact = New Activation_Contact__c();
        objwrapReviewAllData.objActivationBillingRepresentative = New Activation_Contact__c();
        objwrapReviewAllData.objActivationSystemSupportContact = New Activation_Contact__c();
        objwrapReviewAllData.objActivationOnboardContact = New Activation_Contact__c();
        objwrapReviewAllData.lstAuthorizedRepresentatives = New List<Activation_Contact__c>();
        objwrapReviewAllData.lstInvoiceRecipients = New List<Activation_Contact__c>();
        objwrapReviewAllData.objActivationPlatform = New Activation_Platform__c();
        objwrapReviewAllData.objActivationDealer = New Activation_Dealer__c();
        objwrapReviewAllData.objActivationHardware = New Activation_Hardware__c();
        objwrapReviewAllData.lstPaymentProfiles = New List<Payment_Profile__c>();
        
        Activation_Order__c objActivationOrder = New Activation_Order__c();
        List<Activation_Order__c> lstActivationOrder = New List<Activation_Order__c>();
        lstActivationOrder= [SELECT Id,Contract_Term__c,HasMainContactRole__c,Activation_Type__c,Brazilian_Waters_Vessel__c,Payment_Method__c,Entertainment_News_Sports_Training_Term__c,Operation_Data_Services_Term__c,
                             Hardware_Purchased_or_Leased__c,Activation_Opportunity__c,Activation_Opportunity__r.AccountId,
                             (SELECT Id,Address__c,Corporate_Billing_Account__c,Contact__c,Subscriber_Address_Line_2__c,City__c,Postal_Zip_Code__c,State_Province__c,Country_Name__c,
                              Billing_Company__c,Preferred_Addressee__c ,Billing_Rep_Address__c,Billing_Rep_Address_Line_2__c,Billing_City__c,
                              Billing_Zip_Code__c,Bill_to__c,Billing_Country_Name__c,Billing_State_Province__c FROM Activation_Subscribers__r),
                             (SELECT id,Activation_Order__c,First_Name__c,Salutation__c,Last_Name__c,State__c,Address_1__c,Address_2__c,City__c,Postal_Zip_Code__c,
                              Email__c,Primary_Phone__c,Primary_Phone_Type__c,Job_Function__c,Job_Title__c,Account__c,Country__c,
                              Secondary_Phone__c, Secondary_Phone_Type__c,Contact_Role__c
                              FROM Activation_Contacts__r),
                             (SELECT Id, Name,Vessel_Info__c,Distance_between_antenna_and_sea_level__c,Maximum_Latitude__c,
                              Maximum_Longitude__c,Minimum_Latitude__c,Minimum_Longitude__c,Brazilian_system_operates_while_anchored__c	,
                              Confirm_if_boat_yacht_is_chartered__c, Activation_Order__c, Market__c, Market_Sector__c,Platform_Detail__c,
                              Flag__c,Vessel_Radio_Call_Sign__c,Vessel_IMO__c,Vessel_Length_ft_m__c,Vehicle_Model__c,
                              Industry_Designation__c,MMSI__c,Vehicle_Make_Model__c,Vehicle_Year__c,Having_IMO__c,Geograpical_coordinates_of_port_and_site__c
                              FROM Activation_Platforms__r),
                             (SELECT Id, Image_URL_Formulated__c, Image_path_name__c, 
                              Sequence__c, Static_Resource_Archive__c, Status__c,Below_Decks_Root_Asset__c, 
                              Title__c, isOptionalHardware__c, Antenna_Serial_Number__c, 
                              Below_Decks_Serial_Number__c,Activation_Order__c,System_Name_Group__c, 
                              Do_Not_Know_Serial_Number__c,System_Detail__c, System_Name__c,
                              Antenna_Root_Asset__c FROM Activation_Hardware__r WHERE RecordTypeId =: strActivationHardwareRecordTypeId),
                             (SELECT Primary_Phone_Type__c,Dealer_Phone__c, 
                              Id, Contact_Email__c, Contact_First_Name__c, Contact_Last_Name__c,
                              Contact_Phone__c, Contact_Salutation__c, Phone_Type__c,
                              Company__c, Activation_Order__c ,Country__c, State__c
                              FROM Activation_Dealers__r)
                             FROM Activation_Order__c 
                             WHERE Id=:strOrderId LIMIT 1];
        
        if(lstActivationOrder.size()>0){
            objwrapReviewAllData.objActivationOrder = lstActivationOrder[0];
            objActivationOrder = lstActivationOrder[0];
            for(Activation_Subscriber__c objActivationAccount : objActivationOrder.Activation_Subscribers__r){
                objwrapReviewAllData.objActivationAccount = objActivationAccount;
            }
            
            for(Activation_Contact__c objActivationContact : objActivationOrder.Activation_Contacts__r){
                if(objActivationContact.Contact_Role__c != null && objActivationContact.Contact_Role__c.containsIgnoreCase('Main Contact')){
                    objwrapReviewAllData.objActivationMainContact = objActivationContact;
                }
                if(objActivationContact.Contact_Role__c != null && objActivationContact.Contact_Role__c.containsIgnoreCase('Billing Representative')){
                    objwrapReviewAllData.objActivationBillingRepresentative = objActivationContact;
                }
                if(objActivationContact.Contact_Role__c != null && objActivationContact.Contact_Role__c.containsIgnoreCase('System Support Contact')){
                    objwrapReviewAllData.objActivationSystemSupportContact = objActivationContact;
                }
                if(objActivationContact.Contact_Role__c != null && objActivationContact.Contact_Role__c.containsIgnoreCase('Onboard Contact')){
                    objwrapReviewAllData.objActivationOnboardContact = objActivationContact;
                }
                if(objActivationContact.Contact_Role__c != null && objActivationContact.Contact_Role__c.containsIgnoreCase('Authorized Representative')){
                    objwrapReviewAllData.lstAuthorizedRepresentatives.add(objActivationContact);
                }
                if(objActivationContact.Contact_Role__c != null && objActivationContact.Contact_Role__c.containsIgnoreCase('Invoice Recipient') && !objActivationContact.Contact_Role__c.containsIgnoreCase('Billing Representative')){
                    objwrapReviewAllData.lstInvoiceRecipients.add(objActivationContact);
                }
            }
            
            for(Activation_Hardware__c objActivationHardware : objActivationOrder.Activation_Hardware__r){
                 objwrapReviewAllData.objActivationHardware = objActivationHardware;
            }
            
            for(Customer_Profile__c objCustomerProfile :[SELECT Id, Name,(SELECT Id,First_Name__c,State_Province_Territory__c,Country__c,Company__c,Email__c,Phone__c,Primary_Credit_Card__c,Card_Type__c,Expiration_Date__c,Last_Name__c,Credit_Card_Number__c,Customer_Profile__r.Customer_Profile_Id__c FROM Payment_Profiles__r ORDER BY CreatedDate ) FROM Customer_Profile__c WHERE Activation_Order__c =: strOrderId LIMIT 1]){
                for(Payment_Profile__c objPaymentProfile : objCustomerProfile.Payment_Profiles__r){
                   objwrapReviewAllData.lstPaymentProfiles.add(objPaymentProfile);
                }
            }
            
            for(Activation_Platform__c objActivationPlatform : objActivationOrder.Activation_Platforms__r){
                 objwrapReviewAllData.objActivationPlatform = objActivationPlatform;
            }
            
            for(Activation_Dealer__c objActivationDealer : objActivationOrder.Activation_Dealers__r){
                 objwrapReviewAllData.objActivationDealer = objActivationDealer;
            }
           // system.debug('objActivationMainContact' + objwrapReviewAllData.objActivationAccount);
        }
    }
    
    public class wrapReviewAllData {
        public  Activation_Order__c objActivationOrder {get; set;}
        public  Activation_Subscriber__c objActivationAccount {get; set;}
        public  Activation_Contact__c objActivationMainContact {get; set;}
        public  Activation_Contact__c objActivationBillingRepresentative {get; set;}
        public  List<Activation_Contact__c> lstAuthorizedRepresentatives {get; set;}
        public  List<Activation_Contact__c> lstInvoiceRecipients {get; set;}
        public  Activation_Contact__c objActivationSystemSupportContact {get; set;}
        public  Activation_Contact__c objActivationOnboardContact {get; set;}
        public  Activation_Platform__c objActivationPlatform {get; set;} 
        public  Activation_Dealer__c objActivationDealer {get; set;}
        public  Activation_Hardware__c objActivationHardware {get; set;}
        public  List<Payment_Profile__c> lstPaymentProfiles {get; set;}
    }
 
}