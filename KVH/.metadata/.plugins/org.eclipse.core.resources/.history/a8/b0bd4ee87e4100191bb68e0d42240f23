/**
* @createdby        :   Teertha prasad
* @createddate      :   05/17/2017
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   07/13/2017
* @description      :   Class Used In Activation_Product_Registration Page to register existing products by users
**/ 

public class Act_Product_Registration_Controller {
    public Activation_Order__c objActivationOrder  {get; set;}
    public Activation_Subscriber__c objActivationSubscriber {get; set;} 
    public Activation_Hardware__c objActivationHardware {get; set;} 
    private Id Customer_RECORD_TYPE_ID = Schema.SObjectType.Activation_Subscriber__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    private String strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Product Registration').getRecordTypeId();
    
    public String strSelectedCurrentProduct {get; set;}
    public String strSelectedRetiredProduct {get; set;}
    public List<SelectOption> lstCurrent {get; set;}
    public List<SelectOption> lstRetired {get; set;}
    
    public Integer intCounter {get; set;}
    public String strAttachmentId  {get; set;}
    public Transient List<Attachment> lstAttachments  {get; set;}
    public Transient String strFirstSerialNumberName {get; set;}
    public Transient String strSecondSerialNumberName {get; set;}
    
    public Transient String strfilename {get; set;}
    public Transient String strbody {get; set;}
    public Transient String strAttachmentType {get; set;}
    
    
    public String strServiceStartDate {get;set;}
    private Map<String,String> mapMonthToInteger  = New Map<String,String> { 'Jan'  => '1', 'Feb'  => '2', 'Mar'  => '3',  'Apr'  => '4', 'May'  => '5', 'Jun'  => '6',  'Jul'  => '7',  'Aug'  => '8', 'Sep'  => '9',  'Oct'  => '10',  'Nov'  => '11', 'Dec'  => '12'};
    private Map<String,String> mapIntegerToMonth  = New Map<String,String> { '1' => 'Jan', '2' => 'Feb', '3' => 'Mar',   '4' => 'Apr',  '5' => 'May', '6' => 'Jun', '7' => 'Jul', '8' => 'Aug', '9' => 'Sep', '10' => 'Oct', '11' => 'Nov', '12' => 'Dec' };
            
    public Product_Registration_Management__c objProductRegistrationManagement {get; set;}
    public string selectedTab {get;set;}
    public string selectedMarketType {get;set;}
    public Activation_Platform__c objActivationPlatform  {get;set;}
    public Activation_Status__c objActivationStatus {get;set;}
    public Activation_Contact__c objActivationContact{get;set;}       //The ONE Activation Contact that we are creating/editing
    private static String strAuthorizedRepRole = 'Authorized Representative';      // Contact Authorized Rep Role can be taken from custom labels later
    
    private map<String, list<String>> mapMarketANDSector; // Instead of this we can use Custom Setting
    
    CountryStateMethods objCountryStateMethods = New CountryStateMethods(); //Helper Class
    public list<SelectOption> CountriesList = New list<SelectOption>();  //List of Country Names for Subscriber Picklist
    public list<SelectOption> StatesList = new list<SelectOption>();
    public list<SelectOption> StatesListDeal = new list<SelectOption>();
    public list<SelectOption> StatesListInstalling = new list<SelectOption>();
    
    public Activation_Dealer__c objActivationDealer {get; set;}                   //The Activation Dealer related to the Order! 
    //Boolean to Partner User/On behave customer
    public boolean checkFlag{
        set;
        get{
            if(checkFlag == null && objActivationOrder != null){
                checkFlag = true;
                Map<string, string> profileTemp = new Map<string, string>();
                for(PortalProfile__c temp : PortalProfile__c.getAll().values())
                profileTemp.put(temp.Profile_Name__c,temp.Profile_Type__c);
                string profileName = [select Profile.Name, Id, Name from User where id = :UserInfo.getUserId()].Profile.Name;
                if(profileTemp.containsKey(profileName) && objActivationOrder.Activation_Type__c == 'Registration on behalf of Customer'){
                    if(profileTemp.get(profileName) == 'Customer Portal Profile')
                    checkFlag = false;
                    else
                    checkFlag = true;
                }
                else if(objActivationOrder.Activation_Type__c == 'KVH Registration on behalf of Customer')
                checkFlag = false;
            }
            return checkFlag;
        }
    } 
    //Boolean for Internal User
    public boolean internalUser{
        set;
        get{
            if(internalUser == null)
            internalUser = [select contactId from User where id = :UserInfo.getUserId()].contactId == null;
            return internalUser;
        }
        
    }
    public string antennaSerialNum {get;set;}
    public string newProduct{get;set;} 
    //TAB Index variable can be get from custom settings
    public Map<String,Integer> mapdisableProductRegistrationTabs {
        get { mapdisableProductRegistrationTabs = New Map<String,Integer>();
             mapdisableProductRegistrationTabs.put('Subscriber_Information',1);
             mapdisableProductRegistrationTabs.put('Installation_Type',2);
             mapdisableProductRegistrationTabs.put('Product',3);
             mapdisableProductRegistrationTabs.put('Platform',4);
             mapdisableProductRegistrationTabs.put('Purchase_Details',5);
             mapdisableProductRegistrationTabs.put('Authorized_Representative',6);
             mapdisableProductRegistrationTabs.put('Review',7);
             return mapdisableProductRegistrationTabs; 
            }
        private set; 
    }
    
    // Constructor - Start
    public Act_Product_Registration_Controller(){
        selectedMarketType = '';
        intCounter = 0;
        strServiceStartDate ='';
        objActivationContact = New Activation_Contact__c();
        objActivationDealer = New Activation_Dealer__c();
        
        CountriesList = objCountryStateMethods.setupCountryPicklist();
        StatesList = objCountryStateMethods.setupStatesPicklist();
        StatesListDeal = objCountryStateMethods.setupStatesPicklist();
        StatesListInstalling = objCountryStateMethods.setupStatesPicklist();
        objProductRegistrationManagement = New Product_Registration_Management__c(); 
        objActivationStatus = New Activation_Status__c();
        lstCurrent = New list<SelectOption>{New Selectoption('', 'Select a Current Product')};
        lstRetired = New list<SelectOption>{New Selectoption('', 'Select a Retired Product')};
        createMarketANDSectorData();
        
        String strActivationContact = ApexPages.currentPage().getParameters().get('conActID');
        objActivationContact = (String.isNotBlank(strActivationContact)) ? readActivationContact(strActivationContact) : New Activation_Contact__c();
        componentCountryChangeHandler();
    }
    // Constructor - End
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   05/26/2017
* @description          :   readActivationContact Method.
*                           Load Selected Activation Contact on edit layout And used in component.
*                           If nothing is selected, new initialization of activation contact.
* @return               :   Activation_Contact__c, object - selected contact 
* @invoke               :   From construction
**/
    public Activation_Contact__c readActivationContact(String strActivationContact){
        Activation_Contact__c objActivationContactTemp = New Activation_Contact__c();
        if(strActivationContact!=null && strActivationContact !=''){
            objActivationContactTemp = [SELECT id,Activation_Order__c,First_Name__c,Salutation__c,Last_Name__c,State__c,Address_1__c,Address_2__c,City__c,Postal_Zip_Code__c,
                                        Email__c,Primary_Phone__c,Primary_Phone_Type__c,Job_Function__c,Job_Title__c,Account__c,Country__c,
                                        Secondary_Phone__c, Secondary_Phone_Type__c,Contact_Role__c,Contact__c
                                        FROM Activation_Contact__c  WHERE  id=:strActivationContact];
        }
        return objActivationContactTemp;
    }
    
    /**
* @last modified by     :   Theertha
* @last modified date   :   05/26/2017
* @description          :   upsertActivationContact Method.
*                           Upsert contact's contact role to based on current tab.
* @return               :   pagereference, calling gototab method
* @invoke               :   From action method of Page
**/
    public pageReference upsertActivationContact(){
        if(objActivationContact.Activation_Order__c == null){ 
            objActivationContact.Activation_Order__c = objActivationOrder.Id; 
        }
        if(objActivationContact.Contact_Role__c == null){
            objActivationContact.Contact_Role__c = strAuthorizedRepRole ;
        }
        //system.debug('objActivationContact'+objActivationContact);
        upsert objActivationContact;
        return goToTab();
    }
    
    //Getters and Setters
    public list<SelectOption> getCountriesList(){
        list<SelectOption> Options = new list<SelectOption>();
        for(SelectOption SOption:CountriesList)Options.add(new SelectOption(SOption.getLabel() ,SOption.getLabel()));
        return Options;
    }
    public list<SelectOption> getStatesList(){
        return StatesList;
    }
    public list<SelectOption> getStatesListDeal(){
        return StatesListDeal;
    }
    public list<SelectOption> getStatesListInstalling(){
        return StatesListInstalling;
    }
    /*
    public pagereference createActivitionOrderCase(){
    
    return null;
    }*/
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   03/04/2017
* @description          :   updateActivationPlatformMarket Method.
*                           To update Activation Platform market and market sector 
*                           based on selected vessel type in vf page
* @return               :   pagereference
* @invoke               :   (onclick) From Vf page and also from goToTab method
**/
    public pagereference updateActivationPlatformMarket(){
        /** We are replacing ',' with '*' , it will give actual value! And update activation platform  **/
        if(selectedMarketType != ''){
            String strTemp = mapMarketANDSector.get(selectedMarketType)[0];
            objActivationPlatform.Market__c = strTemp.replace('*',',');
            strTemp = mapMarketANDSector.get(selectedMarketType)[1];
            objActivationPlatform.Market_Sector__c =strTemp.replace('*',',');
        }
        //system.debug('objActivationPlatform'  +objActivationPlatform);
        objActivationPlatform.Name = (objActivationPlatform.Name == '' || objActivationPlatform.Name == null) ? 'TBD' : objActivationPlatform.Name;
        upsert objActivationPlatform;
        
        if(selectedTab == 'Installation_Type'){
            objActivationHardware.Product_Line__c = '';
            objActivationHardware.Product_Catalog_Name__c = '';
            objActivationHardware.Secondary_Serial_Label__c = '';
            objActivationHardware.Primary_Serial_Label__c = '';
            objActivationHardware.Antenna_Root_Asset__c = null;
            objActivationHardware.Do_Not_Know_Serial_Number__c = false;
            objActivationHardware.Antenna_Serial_Number__c = '';
            upsert objActivationHardware;
        }
        
        Act_Subscriber_component_controller objActSubscribercomponentcontroller = New Act_Subscriber_component_controller();
        system.debug('====callfromOtherPage==========@@=======');
        Boolean BoolIsError = objActSubscribercomponentcontroller.callfromOtherPage(objActivationPlatform, false);
        system.debug('=======@@======='+objActivationOrder.Main_Contact__c);
        if(BoolIsError){
            return objActSubscribercomponentcontroller.selfRegistrationException('showError', 'userFail'); //Maybe this is another tailored page.....
        }
        return null;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   05/26/2017
* @description          :   updateActivationPlatformMarketTab Method.
* @return               :   Pagereference 
* @invoke               :   From VF Page
**/
    
    public Pagereference updateActivationPlatformMarketTab(){
        updateActivationPlatformMarket();
        return goToTab();
    }
    
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   05/26/2017
* @description          :   upsertActivationHardwareTab Method.
* @return               :   Pagereference 
* @invoke               :   From VF Page
**/
    
    public Pagereference upsertActivationHardwareTab(){
        upsertActivationHardware(true);
        return goToTab();
    }
    
    public Pagereference upsertActivationHardware(Boolean validbool){
        if(strServiceStartDate != ''){
            String strServiceStartDateTemp = strServiceStartDate.replaceFirst(strServiceStartDate.substringBetween('-', '-'), mapMonthToInteger.get(strServiceStartDate.substringBetween('-', '-')));
            String[] strParsing = strServiceStartDateTemp.split('-');
            Date convertedDate= Date.newInstance(Integer.valueOf(strParsing[0]),Integer.valueOf(strParsing[1]), Integer.valueOf(strParsing[2]));
            objActivationHardware.Purchase_Date__c = convertedDate;
        }
        if(validbool){
            objActivationHardware.Product_Line__c = objProductRegistrationManagement.Product_Line__c;
            objActivationHardware.Product_Catalog_Name__c = String.IsNotBlank(strSelectedCurrentProduct) ? strSelectedCurrentProduct : strSelectedRetiredProduct;
            objActivationHardware.Secondary_Serial_Label__c = ApexPages.currentPage().getParameters().get('secondnumberlabel'); 
            objActivationHardware.Primary_Serial_Label__c = ApexPages.currentPage().getParameters().get('firstnumberlabel'); 
        }
        saveAttachment();
        return null;
    }
    
    public Pagereference saveAttachment(){
        upsert objActivationHardware;
        upsert objActivationOrder;
        
        if(String.IsNotBlank(strfilename) && String.IsNotBlank(strbody)){
            Attachment objAttachment = New Attachment();
            objAttachment.Name= strfilename;
            objAttachment.ContentType = strAttachmentType;
            objAttachment.Body = EncodingUtil.base64Decode(strbody);
            objAttachment.Parentid = objActivationOrder.Id; //Needs to add your record id below which you need attachment ;
            insert objAttachment;
            removeAttachment();
        }
        return null;
    }
    
    public pagereference removeAttachment(){
        if(String.IsNotBlank(strAttachmentId)){
            delete [SELECT Id FRom Attachment WHERE Id =:strAttachmentId];
        }
        allAttachhments();
        strAttachmentId ='';
        return null;
    }
    
    public void allAttachhments(){
        lstAttachments = New List<Attachment>();
        for( Attachment objAttachment : [SELECT Id,Name,ContentType,Body,Parentid FROM Attachment WHERE Parentid=: objActivationOrder.Id ORDER BY CreatedDate ASC]){
            lstAttachments.add(objAttachment);
        }
    }
    
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   05/26/2017
* @description          :   upsertDealer Method.
* @return               :   Pagereference 
* @invoke               :   From VF Page
**/
    
    public Pagereference upsertDealer(){
        //system.debug('objActivationDealer'  + objActivationDealer); 
        for(Account objAccount : [SELECT Id, BillingCountry, BillingState FROM Account WHERE Id =: objActivationDealer.Dealer_Distributor_Company__c ]){ //AND Name =: 'No Dealer'
            objActivationDealer.Country__c = objAccount.BillingCountry; 
            objActivationDealer.State__c = objAccount.BillingState; 
        }
        for(Account objAccount : [SELECT Id, BillingCountry, BillingState FROM Account WHERE Id =: objActivationDealer.Installing_Dealer_Company__c ]){ //AND Name =: 'No Dealer'
            objActivationDealer.Installing_Dealer_Country__c = objAccount.BillingCountry; 
            objActivationDealer.Installing_Dealer_State__c = objAccount.BillingState; 
        }
        if(objActivationDealer.Same_as_Purchase_Dealer__c){
            objActivationDealer.Installing_Dealer_Country__c = objActivationDealer.Country__c; 
            objActivationDealer.Installing_Dealer_State__c = objActivationDealer.State__c; 
        }
        
        upsert objActivationDealer;
        update objActivationOrder;
        return goToTab();
    }
    
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   05/26/2017
* @description          :   fetchCurrentRetired Method.
* @return               :   Pagereference 
* @invoke               :   From VF Page
**/
    
    public Pagereference fetchCurrentRetired(){
        //system.debug('insinde');
        objActivationHardware.Antenna_Root_Asset__c = null;
        objActivationHardware.Do_Not_Know_Serial_Number__c = false;
        objActivationHardware.Antenna_Serial_Number__c = '';
        strSelectedRetiredProduct = '';
        strSelectedCurrentProduct = '';
        lstCurrent = New list<SelectOption>{New Selectoption('', 'Select a Current Product')};
            lstRetired = New list<SelectOption>{New Selectoption('', 'Select a Retired Product')};
                for(Product_Registration_Management__c objProductRegistrationManagementTemp : [SELECT Id,Hidden_Dependency_Product__c,Hidden_Visible_Lines__c,Product_Line__c,Market__c,Market_Sector__c,Current_Products__c,Retired_Products__c FROM Product_Registration_Management__c WHERE Market__c =: objProductRegistrationManagement.Market__c AND Market_Sector__c =: objProductRegistrationManagement.Market_Sector__c AND Product_Line__c =: objProductRegistrationManagement.Product_Line__c LIMIT 1]){
                    if(objProductRegistrationManagementTemp.Current_Products__c != null){
                        for(String strKey : objProductRegistrationManagementTemp.Current_Products__c.split(';')){
                            lstCurrent.add(New Selectoption(strKey, strKey));
                        }
                    }
                    if(objProductRegistrationManagementTemp.Retired_Products__c != null){
                        for(String strKey : objProductRegistrationManagementTemp.Retired_Products__c.split(';')){
                            lstRetired.add(New Selectoption(strKey, strKey));
                        }
                    }
                    objProductRegistrationManagement.Hidden_Dependency_Product__c= '';
                    objProductRegistrationManagement.Hidden_Visible_Lines__c = '';
                }
        //system.debug('lstCurrent' + lstCurrent);
        //system.debug('lstRetired' + lstRetired);
        return null;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   05/26/2017
* @description          :   onchangeCurrent Method.
* @return               :   Pagereference 
* @invoke               :   From VF Page
**/
    
    public Pagereference onchangeCurrent(){
        if(String.IsNotBlank(strSelectedCurrentProduct)){
            objActivationHardware.Antenna_Root_Asset__c = null;
            objActivationHardware.Antenna_Serial_Number__c = '';
            objActivationHardware.Do_Not_Know_Serial_Number__c = false;
            strSelectedRetiredProduct = ''; 
        }
        return null;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   05/26/2017
* @description          :   onchangeRetired Method.
* @return               :   Pagereference 
* @invoke               :   From VF Page
**/
    
    public Pagereference onchangeRetired(){
        if(String.IsNotBlank(strSelectedRetiredProduct)){
            objActivationHardware.Antenna_Root_Asset__c = null;
            objActivationHardware.Do_Not_Know_Serial_Number__c = false;
            objActivationHardware.Antenna_Serial_Number__c = '';
            strSelectedCurrentProduct = '';
        }
        return null;
    }
    
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   05/26/2017
* @description          :   validateAsset Method.
* @return               :   Pagereference 
* @invoke               :   From VF Page
**/
    public Pagereference validateAsset(){
        objActivationHardware.Antenna_Root_Asset__c = null;
        Map<String, Asset> mapAssets = New Map<String, Asset>();
        system.debug('==@@=='+strSelectedCurrentProduct);
        if(checkFlag == true && strSelectedCurrentProduct != null)
        intCounter = 0;
        String strSelectedProduct = strSelectedCurrentProduct != '' ? strSelectedCurrentProduct : strSelectedRetiredProduct;
        String strQuery = 'SELECT Id,Name,Item__c,Product2Id,Product2.Markets__c,Product2.Catalog_Display_Name__c FROM Asset WHERE ';
        //commented on 7/13/2017
        //strQuery +=  ' Product2.Catalog_Display_Name__c =\''+ strSelectedProduct + '\' AND ';
        //commented on 7/13/2017
        strQuery +=  objActivationHardware.Below_Decks_Serial_Number__c !='' ? ' (Name = \''+objActivationHardware.Antenna_Serial_Number__c + '\' OR Name = \''+ objActivationHardware.Below_Decks_Serial_Number__c + '\' ) ' : ' Name = \''+ objActivationHardware.Antenna_Serial_Number__c +'\'' ;
        //system.debug('strQuery'+strQuery);
        for(Asset objAsset : Database.query(strQuery)){
            mapAssets.put(objAsset.Name, objAsset);
            objActivationHardware.Antenna_Root_Asset__c = objAsset.id;
        }
        objActivationHardware.Antenna_Root_Asset__c = !mapAssets.isEmpty() && mapAssets.containsKey(objActivationHardware.Antenna_Serial_Number__c) ? mapAssets.get(objActivationHardware.Antenna_Serial_Number__c).Id : null;
        objActivationHardware.Do_Not_Know_Serial_Number__c = objActivationHardware.Antenna_Root_Asset__c == null ? true : false;
        objActivationHardware.Below_Decks_Root_Asset__c = !mapAssets.isEmpty() && mapAssets.containsKey(objActivationHardware.Below_Decks_Serial_Number__c) ? mapAssets.get(objActivationHardware.Below_Decks_Serial_Number__c).Id : null;
        objActivationHardware.Root_Assets_Do_NOT_Match__c = objActivationHardware.Below_Decks_Root_Asset__c == objActivationHardware.Antenna_Root_Asset__c ? false : true ;
        
        if(objActivationHardware.Antenna_Root_Asset__c == null){
            intCounter++;
        }
        system.debug(objActivationHardware.Antenna_Root_Asset__c+'mapAssets'+mapAssets);
        return null;
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
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   08/07/2016
* @description          :   componentCountryChangeHandler Method.
* @return               :   void
* @invoke               :   From Method And VF page 
**/
    
    public void componentCountryChangeHandler(){
        string strCountry = '';
        for(SelectOption SOption:CountriesList){
            if(SOption.getLabel() == objActivationContact.Country__c)strCountry = SOption.getValue();
        }
        StatesList = objCountryStateMethods.CountryChangeHandler(strCountry, objActivationContact.State__c);
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   08/07/2016
* @description          :   componentCountryChangeHandlerInstalling Method.
* @return               :   void
* @invoke               :   From Method And VF page 
**/
    
    public void componentCountryChangeHandlerInstalling(){
        string strCountry = '';
        for(SelectOption SOption:CountriesList){
            if(SOption.getLabel() == objActivationDealer.Installing_Dealer_Country__c)strCountry = SOption.getValue();
        }
        StatesListInstalling = objCountryStateMethods.CountryChangeHandler(strCountry, objActivationDealer.Installing_Dealer_State__c);
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   08/07/2016
* @description          :   componentCountryChangeHandlerPurchase Method.
* @return               :   void
* @invoke               :   From Method And VF page 
**/
    
    public void componentCountryChangeHandlerPurchase(){
        string strCountry = '';
        for(SelectOption SOption:CountriesList){
            if(SOption.getLabel() == objActivationDealer.Country__c)strCountry = SOption.getValue();
        }
        StatesListDeal = objCountryStateMethods.CountryChangeHandler(strCountry, objActivationDealer.State__c);
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   02/03/2017
* @description          :   readActivationService Method.
*                           Create Activation Order If not present, else get Activation Order
*                           And used in vf page.
* @return               :   Activation_Order__c Object
* @invoke               :   From Constructor
**/
    public Pagereference readActivationOrder(){
    String us = userinfo.getUserType(); 
        String strOrderId =  ApexPages.currentPage().getParameters().get('order');       //extract Order Id
        String tabName =  ApexPages.currentPage().getParameters().get('tabName'); 
        String strActivationContact = ApexPages.currentPage().getParameters().get('conActID');
        if(ApexPages.currentPage().getParameters().get('newProduct') != null)
        newProduct= ApexPages.currentPage().getParameters().get('newProduct');   
        system.debug(newProduct+'===newProduct===');
        objActivationPlatform = New Activation_Platform__c();
        objActivationOrder = New Activation_Order__c();
        objActivationSubscriber = New Activation_Subscriber__c();
        if(String.isNotBlank(strOrderId)){
            objActivationHardware = New Activation_Hardware__c(RecordTypeId = strActivationHardwareRecordTypeId, Activation_Order__c = strOrderId);
            objActivationSubscriber = New Activation_Subscriber__c(RecordTypeId = strActivationHardwareRecordTypeId, Activation_Order__c = strOrderId);
            
            ActivationsBaseController objActivationsBaseController = New ActivationsBaseController();
            objActivationStatus = objActivationsBaseController.readActivationStatus(strOrderId); 
            //Code to land in Produc tab from Pending Customer Confirmation View
            if(String.isNotBlank(tabName)){
            selectedTab = tabName;
            objActivationStatus.Account_Setup_Active_Tab__c= selectedTab;
            } 
            else
            selectedTab = objActivationStatus.Account_Setup_Active_Tab__c; //get status record
            //End
            if(objActivationStatus.Account_Setup_Last_Active_Tab_Index__c == null){
                objActivationStatus.Account_Setup_Last_Active_Tab_Index__c =1;
            }
            if(objActivationStatus.Account_Setup_Last_Active_Tab_Index__c < mapdisableProductRegistrationTabs.get(selectedTab)){
                objActivationStatus.Account_Setup_Last_Active_Tab_Index__c = mapdisableProductRegistrationTabs.get(selectedTab);
            }
            List<Activation_Order__c> lstActivationOrder = New List<Activation_Order__c>();
            lstActivationOrder= [SELECT Id,Installed_By__c,Case__c,Return_URL__c,Main_Contact__c,Order_Status__c,Contract_Term__c,Hardware_Purchased_or_Leased__c,CreatedById,
                                 Activation_Opportunity__c,Activation_Opportunity__r.AccountId,Don_t_have_Dealer__c,Activation_Type__c ,
                                 (SELECT Id, Name,Confirm_if_boat_yacht_is_chartered__c, Activation_Order__c, Market__c, Market_Sector__c,Platform_Detail__c,
                                  Flag__c,Vessel_Radio_Call_Sign__c,Vessel_IMO__c,Vessel_Length_ft_m__c,Vehicle_Model__c,   Vessel_Info__c,
                                  Industry_Designation__c,MMSI__c,Vehicle_Make_Model__c,Vehicle_Year__c,Having_IMO__c
                                  FROM Activation_Platforms__r),
                                 (SELECT Dealer_Phone__c, Id,Installed_By_Boat_Builder__c,
                                  Company__c, Activation_Order__c ,Country__c, State__c,Dealer_Distributor_Company__c,
                                  Installing_Dealer_Company__c,Installing_Dealer_Country__c,Installing_Dealer_Name__c,
                                  Installing_Dealer_State__c,Same_as_Purchase_Dealer__c
                                  FROM Activation_Dealers__r),
                                 (SELECT Id, Root_Asset_Product_Group__c,Do_Not_Know_Serial_Number__c,Have_Proof_of_Purchase__c,
                                  Below_Decks_Root_Asset__c,Root_Assets_Do_NOT_Match__c,Antenna_Root_Asset__r.Product2.Name,
                                  Below_Decks_Serial_Number__c,Antenna_Root_Asset__c,Antenna_Serial_Number__c,Purchase_Date__c,
                                  System_Detail__c, Product_Line__c, Product_Catalog_Name__c,Activation_Order__c
                                  FROM Activation_Hardware__r WHERE RecordTypeId =: strActivationHardwareRecordTypeId ORDER BY CreatedDate ASC LIMIT 1)
                                 FROM Activation_Order__c 
                                 WHERE Id =: strOrderId LIMIT 1];
            
            if(lstActivationOrder.size()>0){ 
                objActivationOrder = lstActivationOrder[0];
                //if(ApexPages.currentPage().getParameters().get('returl') != '')
                Activation_Order__c tempActivation_Order = new Activation_Order__c();
                tempActivation_Order.id = objActivationOrder.id;
                if(Site.getBaseUrl() != '')
                tempActivation_Order.Return_URL__c = Site.getBaseUrl();
                upsert tempActivation_Order;
                //Get Current user Account for Purchasing Dealer Name field
                List<User> u = new List<User>();
                //u = [SELECT Id,ContactId, Contact.AccountId, Contact.Account.Name FROM User WHERE Id = :'0051b000000P8N9' limit 1];
                u = [SELECT Id,ContactId, Contact.AccountId, Contact.Account.Name,Contact.Account.BillingState, Contact.Account.BillingCountry,Contact.Account.Phone, 
                    Contact.Account.BillingCity FROM User WHERE Id = :UserInfo.getUserId()  limit 1];
                if(u.size() > 0 && checkflag == true){
                
                objActivationDealer.Company__c = u[0].Contact.Account.Name;
                objActivationDealer.Country__c = u[0].Contact.Account.BillingCountry ;
                objActivationDealer.Dealer_Distributor_Company__c = u[0].Contact.AccountId ;
                objActivationDealer.Dealer_Phone__c= u[0].Contact.Account.Phone ;
                objActivationDealer.Company__c = u[0].Contact.Account.Name;
                objActivationDealer.State__c= u[0].Contact.Account.BillingState ;
                
                }
                //End
                Boolean boolIsActPlatform = false;
                objActivationDealer.Activation_Order__c = lstActivationOrder[0].Id;
                for(Activation_Dealer__c objActivationDealer1 : lstActivationOrder[0].Activation_Dealers__r){
                    objActivationDealer = objActivationDealer1;
                }
                
                for(Activation_Platform__c objActivationPlatform1 : lstActivationOrder[0].Activation_Platforms__r){
                    objActivationPlatform = objActivationPlatform1;
                    boolIsActPlatform = true;
                }
                
                if(!boolIsActPlatform){
                    objActivationPlatform.Name = 'TBD';
                    objActivationPlatform.Activation_Order__c = objActivationOrder.Id;
                    insert objActivationPlatform;
                }else if(String.isBlank(strActivationContact)){
                    CountriesList = objCountryStateMethods.setupCountryPicklist(objActivationPlatform.Flag__c);
                }
                objActivationPlatform.Name = objActivationPlatform.Name == 'TBD' ? '' : objActivationPlatform.Name;
                /** To map already selected vessel type in any and show that vessel type as 'Selected' in vf page - Start **/
                list<String> lsttemp = New list<String>();
                /** We cant store string with comma in list, so we are replacing ',' with '*'  **/
                if(objActivationPlatform.Market__c != null){
                    objProductRegistrationManagement.Market__c = objActivationPlatform.Market__c.replace(',','*').trim();
                    lsttemp.add(objActivationPlatform.Market__c.replace(',','*'));
                }
                if(objActivationPlatform.Market_Sector__c != null){
                    objProductRegistrationManagement.Market_Sector__c = objActivationPlatform.Market_Sector__c.replace(',','*').trim();
                    lsttemp.add(objActivationPlatform.Market_Sector__c.replace(',','*'));
                }
                //system.debug('mapMarketANDSector' + mapMarketANDSector);
                for(String strKey :mapMarketANDSector.keySet()){
                    set<String> setTemp = New set<String>();
                    setTemp.addAll(mapMarketANDSector.get(strKey));
                    system.debug('setTemp' + setTemp);
                    system.debug('lsttemp' + lsttemp);
                    if(lsttemp.size()>0 && setTemp.containsAll(lsttemp)){
                        selectedMarketType = strKey;
                    }
                }
                /** To map already selected vessel type in any and show that vessel type as 'Selected' in vf page - End **/
                
                for(Activation_Hardware__c objActivationHardware1 : lstActivationOrder[0].Activation_Hardware__r){
                    if(selectedTab == 'Product'){
                        objProductRegistrationManagement.Product_Line__c = objActivationHardware1.Product_Line__c;
                        //only one record query!!!
                        fetchCurrentRetired();
                        objProductRegistrationManagement.Hidden_Dependency_Product__c = objActivationHardware1.Product_Catalog_Name__c;
                        for(SelectOption objSelectOption : lstCurrent){
                            if(objActivationHardware1.Product_Catalog_Name__c == objSelectOption.getLabel()){
                                strSelectedCurrentProduct = objActivationHardware1.Product_Catalog_Name__c; 
                            }
                        }
                        for(SelectOption objSelectOption : lstRetired){
                            if(objActivationHardware1.Product_Catalog_Name__c == objSelectOption.getLabel()){
                                strSelectedRetiredProduct = objActivationHardware1.Product_Catalog_Name__c;
                            }
                        }
                    }
                    objActivationHardware = objActivationHardware1;
                }
                allAttachhments();
                
                strServiceStartDate = objActivationHardware.Purchase_Date__c != null ? String.valueOf(objActivationHardware.Purchase_Date__c) : '';
                if(strServiceStartDate != ''){
                    String[] strSplit = strServiceStartDate.split('-');
                    strSplit[1] = mapIntegerToMonth.get(string.valueOf(integer.valueOf(strSplit[1])));
                    strServiceStartDate = strSplit[0] +'-'+ strSplit[1] +'-'+ strSplit[2];
                }
                componentCountryChangeHandlerInstalling();
                componentCountryChangeHandlerPurchase();
                system.debug('===mapdisableProductRegistrationTabs==='+mapdisableProductRegistrationTabs);
            }
            return null;
        }else{
            createNewActOrder(String.isNotBlank(ApexPages.currentPage().getParameters().get('onbehalf')) ? false : true);
            PageReference returnPage = page.Activation_Product_Registration;       //start building the page reference....
            returnPage.getParameters().put('order', objActivationOrder.Id); 
            if(newProduct != null)
            returnPage.getParameters().put('newProduct', newProduct);      //add the order ID
            returnPage.setRedirect(true);                                   //set to redirect
            return returnPage; 
        }
        
    }
    
    public Contact contactRecord(String mainContactId){
        Contact objContact = [SELECT Id, Salutation,Job_Function__c, Phone, MobilePhone, Name, Email, FirstName, LastName,Account.Name, AccountId, Account.BillingStreet, Account.BillingCity, Account.BillingState,Account.BillingCountry, Account.BillingPostalCode FROM contact WHERE Id =: mainContactId];
        return objContact;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   08/07/2016
* @description          :   createNewActOrder Method.
* @return               :   void
* @invoke               :   From Method 
**/
    public void createNewActOrder(boolean selfRegistration){        
        if(selfRegistration){                                             //set the self activation flag
            objActivationOrder.Activation_Type__c = 'Self Registration';
            // objActivationOrder.isSelf_Activation__c = true;
        }else{
            objActivationOrder.Activation_Type__c = 'Registration on behalf of Customer';
        }
        if(internalUser)
            objActivationOrder.Activation_Type__c = 'KVH Registration on behalf of Customer';
        objActivationOrder.User_Agent_String__c = ApexPages.currentPage().getHeaders().get('User-Agent');
        Id RECORD_TYPE_ID = Schema.SObjectType.Activation_Order__c.getRecordTypeInfosByName().get('Product Registration').getRecordTypeId();
        objActivationOrder.RecordTypeId = RECORD_TYPE_ID; 
        objActivationOrder.Order_Status__c = 'In Progress';
        //if(ApexPages.currentPage().getParameters().get('isPartner') == 'partner')
        //objActivationOrder.isPartner__c = true; // Logic to check is the Act Order is Partner and Registration on behalf of Customer
        //if(ApexPages.currentPage().getParameters().get('returl') != '')
        if(Site.getBaseUrl() != '')
        objActivationOrder.Return_URL__c = Site.getBaseUrl();
        
        upsert objActivationOrder;//add the new Activation to the database
        objActivationStatus.Activation_Order__c = objActivationOrder.Id;     //assoicate a new Status with the Order
        objActivationStatus.Active_Page__c = 'Account Setup';                              //set Active Page 
        objActivationStatus.Account_Setup_Page__c = 'available';                           //set Page Available Status
        If (objActivationStatus.Account_Setup_Active_Tab__c == null){                      //set Active tab
            selectedTab = selfRegistration ? 'Installation_Type' : 'Subscriber_Information';
            objActivationStatus.Account_Setup_Active_Tab__c = selectedTab;
        } else {
            selectedTab = objActivationStatus.Account_Setup_Active_Tab__c;
        }
        if(objActivationStatus.Account_Setup_Last_Active_Tab_Index__c == null){
            objActivationStatus.Account_Setup_Last_Active_Tab_Index__c =1;
        }
        if(objActivationStatus.Account_Setup_Last_Active_Tab_Index__c < mapdisableProductRegistrationTabs.get(selectedTab)){
            objActivationStatus.Account_Setup_Last_Active_Tab_Index__c = mapdisableProductRegistrationTabs.get(selectedTab);
        }
        upsert objActivationStatus;                                     //insert that into the database
        if(selfRegistration){     
            createSubscriber();
        }
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   08/07/2016
* @description          :   createSubscriber Method.
* @return               :   void
* @invoke               :   From Method 
**/
    public void createSubscriber(){
        objActivationSubscriber = New Activation_Subscriber__c(Activation_Order__c = objActivationOrder.Id);//create a new subscriber
        String mainContactId = String.valueOf([SELECT Id, ContactId FROM User WHERE Id =: UserInfo.getUserId()].ContactId); //ApexPages.currentPage().getParameters().get('mainContactId');
        if(mainContactId != null && mainContactId != ''){
            Contact objContact = contactRecord(mainContactId);
            if(objContact.AccountId != null){
                list<KVH_Countries__mdt> ObjCountries = [SELECT Id, TrimmedName__c, IsoCode_2__c, IsoCode_3__c FROM KVH_Countries__mdt WHERE TrimmedName__c =: objContact.Account.BillingCountry LIMIT 1];
                objActivationSubscriber.Address__c =  objContact.Account.BillingStreet;
                objActivationSubscriber.City__c =  objContact.Account.BillingCity;
                objActivationSubscriber.Postal_Zip_Code__c =  objContact.Account.BillingPostalCode;
                if(ObjCountries.size()>0)
                    objActivationSubscriber.Country__c =ObjCountries[0].IsoCode_2__c;
                objActivationSubscriber.Country_Name__c = objContact.Account.BillingCountry;
                objActivationSubscriber.State_Province__c =  objContact.Account.BillingState; 
                objActivationSubscriber.Subscribing_Company__c = objContact.Account.Name;
            }
            objActivationSubscriber.RecordTypeId = Customer_RECORD_TYPE_ID;
            objActivationSubscriber.Subscriber_Contact_Salutation__c = objContact.Salutation;
            objActivationSubscriber.Subscriber_Contact_First_Name__c = objContact.FirstName;
            objActivationSubscriber.Subscriber_Contact_Name__c = objContact.LastName;
            objActivationSubscriber.Subscriber_Email__c = objContact.Email;
            objActivationSubscriber.Subscriber_Phone_Type__c = 'Business';
            objActivationSubscriber.Phone_Number__c = objContact.Phone;
            objActivationSubscriber.Billing_Rep_Job_Function__c = objContact.Job_Function__c;
            objActivationSubscriber.Secondary_Phone__c = objContact.MobilePhone;
            objActivationSubscriber.Contact__c = mainContactId;
            objActivationSubscriber.Account__c = objContact.AccountId;
            // system.debug('objActivationSubscriber' +objActivationSubscriber);
            upsert objActivationSubscriber;
        }
    }
    
    public Pagereference savesubmitflow(){
        system.debug('======Inside Save and confirm=========');
        flowcall();
        createUserValidator();
        list<contact> lstContact = new list<contact>();
        lstContact = [SELECT Id, Salutation,   Marketing_Communications__c,FirstName, LastName, Email, Phone, MailingStreet, MailingCity, MailingCountry, MailingState, MailingPostalCode,Agree_to_myKVH_Terms_and_Conditions__c, account.CPI__c, accountId, account.Market__c, account.Market_Sector__c FROM contact WHERE Id In (Select ContactId From User Where Id =: UserInfo.getUserId()) LIMIT 1];
        
        if(lstContact.size() > 0){
        lstContact[0].account.Market__c = objActivationPlatform.Market__c; 
        lstContact[0].account.Market_Sector__c = objActivationPlatform.Market_Sector__c; 
        update lstContact[0].account;
        }
        if(checkFlag == true){
        objActivationStatus.Account_Setup_Active_Tab__c = 'Product';
        
        update objActivationStatus;
        }
        if(!internalUser){
            PageReference returnPage = Page.Product_Registration_ThankYou;
            returnPage.getParameters().put('order', objActivationOrder.Id);
            if(checkflag)
            returnPage.getParameters().put('isdtp', 'mn');
            if(objActivationOrder.Activation_Type__c == 'Registration on behalf of Customer' && objActivationOrder.CreatedById == userInfo.getUserId() && objActivationOrder.Order_Status__c == 'Pending Customer Confirmation'){
                returnPage.getParameters().put('onbehalf', 'true'); //add onbehalf
            }
            returnPage.setRedirect(true);                               //this causes the constructors to run again...
            return returnPage; 
        }
        else{
            PageReference returnPage = new PageReference('/'+objActivationOrder.Id);
            returnPage.setRedirect(true);                               //this causes the constructors to run again...
            return returnPage; 
        }
        
                                      
    }
    
    public void flowcall(){
        if(objActivationOrder.Activation_Type__c == 'Registration on behalf of Customer' && objActivationOrder.CreatedById == userInfo.getUserId()){
            objActivationOrder.Order_Status__c = 'Pending Customer Confirmation';
        }else{
            objActivationOrder.Order_Status__c ='Submitted';
        }
        update objActivationOrder;
        if(objActivationOrder.Order_Status__c == 'Submitted'){
            ID jobIDFlow = System.enqueueJob(New callFlowMethod(objActivationPlatform.Id));
        }
    }
    
    
    public Pagereference savesubmitaddflow(){
        flowcall();
        createUserValidator();
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        returnPage.getParameters().clear();
        returnPage.setRedirect(true);                               //this causes the constructors to run again...
        return returnPage;
    }
    
    public Pagereference createUserValidator(){
        if(objActivationOrder.Activation_Type__c == 'Registration on behalf of Customer' && objActivationOrder.CreatedById == userInfo.getUserId() && objActivationOrder.Order_Status__c == 'Pending Customer Confirmation' ){
            Act_Subscriber_component_controller objActSubscribercomponentcontroller = New Act_Subscriber_component_controller();
            system.debug('====callfromOtherPage123==========@@=======');
            Boolean BoolIsError = objActSubscribercomponentcontroller.callfromOtherPage1(objActivationPlatform, true,checkFlag);
            if(BoolIsError){
                return objActSubscribercomponentcontroller.selfRegistrationException('showError', 'userFail'); //Maybe this is another tailored page.....
            }
        }
        else if(objActivationOrder.Activation_Type__c == 'KVH Registration on behalf of Customer' && objActivationOrder.CreatedById == userInfo.getUserId() && objActivationOrder.Order_Status__c == 'Submitted' && internalUser){
            Act_Subscriber_component_controller objActSubscribercomponentcontroller = New Act_Subscriber_component_controller();
            system.debug('====InternalUser==========@@=======');
            Boolean BoolIsError = objActSubscribercomponentcontroller.callfromOtherPage1(objActivationPlatform, true,checkFlag);
            if(BoolIsError){
                return objActSubscribercomponentcontroller.selfRegistrationException('showError', 'userFail'); //Maybe this is another tailored page.....
            }
        }
        return null;
    }
    
    public pagereference saveandExit(){
        
        if(selectedMarketType != ''){
            String strTemp = mapMarketANDSector.get(selectedMarketType)[0];
            objActivationPlatform.Market__c = strTemp.replace('*',',');
            strTemp = mapMarketANDSector.get(selectedMarketType)[1];
            objActivationPlatform.Market_Sector__c =strTemp.replace('*',',');
        }
        //system.debug('objActivationPlatform'  +objActivationPlatform);
        objActivationPlatform.Name = (objActivationPlatform.Name == '' || objActivationPlatform.Name == null) ? 'TBD' : objActivationPlatform.Name;
        upsert objActivationPlatform;
        
        if(selectedTab == 'Product')
            upsertActivationHardware(true);
        else
            upsertActivationHardware(false);
        upsert objActivationDealer;
        upsert objActivationOrder;
        if(checkFlag){
            if(Site.getBaseUrl() != ''){
            PageReference pageRef = new PageReference(Site.getBaseUrl());
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
            else if(objActivationOrder.Return_URL__c != ''){
            PageReference pageRef = new PageReference(objActivationOrder.Return_URL__c);
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
            else return null;
        }
        else{
            if(Site.getBaseUrl() != ''){
            PageReference pageRef = new PageReference(Site.getBaseUrl()+'/home/home.jsp');
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
            else if(objActivationOrder.Return_URL__c != ''){
            PageReference pageRef = new PageReference('/home/home.jsp');
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
            else{
            PageReference pageRef = new PageReference('/home/home.jsp');
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
        }
    }
    
    public class callFlowMethod implements Queueable{ 
        private String ActivationPlatformId;
        
        public callFlowMethod(String ActivationPlatformId){            //constructor, handles input parameter
            this.ActivationPlatformId = ActivationPlatformId;
        }
        
        public void execute(QueueableContext context){  //Mandatory Execute method
            Map<String, Object> params = new Map<String, Object>();
            params.put('ActivationPlatformID', ActivationPlatformId);
            Flow.Interview.Product_Registration CallFlow = new Flow.Interview.Product_Registration(params); CallFlow.start();
        }
    }
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   18/05/2016
* @description          :   goToTab Method.
*                           To update Activation status and navigate next Or Previous
*                           tab based on vf page 'selectedTab' param 
* @return               :   pageReference
* @invoke               :   (onclick) From Vf page and goToNextTab method
**/
    public pageReference goToTab(){
        //system.debug('TAB'+ selectedTab);
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        returnPage.getParameters().clear();                         //BUT! we can just clear that stuff out...
        objActivationStatus.Account_Setup_Active_Tab__c = selectedTab;
        if(objActivationStatus.Account_Setup_Last_Active_Tab_Index__c < mapdisableProductRegistrationTabs.get(selectedTab)){
            objActivationStatus.Account_Setup_Last_Active_Tab_Index__c = mapdisableProductRegistrationTabs.get(selectedTab);
        } 
        returnPage.getParameters().put('order', objActivationOrder.Id); //add the order ID
        update objActivationStatus;
        returnPage.setRedirect(true);                               //this causes the constructors to run again...
        return returnPage;
    }
    public pageReference returnHome(){
    system.debug('======@@@+==========='+checkFlag );
        if(checkFlag == true){
            if(Site.getBaseUrl() != ''){
            PageReference pageRef = new PageReference(Site.getBaseUrl());
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
            else if(objActivationOrder.Return_URL__c != ''){
            PageReference pageRef = new PageReference(objActivationOrder.Return_URL__c);
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
            else return null;
        }
        else{
            system.debug('======@@@+==========='+Site.getBaseUrl());
            if(Site.getBaseUrl() != ''){
            PageReference pageRef = new PageReference(Site.getBaseUrl()+'/home/home.jsp');
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
            else if(objActivationOrder.Return_URL__c != ''){
            PageReference pageRef = new PageReference('/home/home.jsp');
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
            else{
            PageReference pageRef = new PageReference('/home/home.jsp');
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
        }
    }
    public pageReference cancelProcess(){
        objActivationOrder.Order_Status__c = 'Canceled';
        update objActivationOrder;
        if(checkFlag == true  && !internalUser){
            if(Site.getBaseUrl() != ''){
            PageReference pageRef = new PageReference(Site.getBaseUrl());
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
            else if(objActivationOrder.Return_URL__c != '' & objActivationOrder.Return_URL__c != null && objActivationOrder.Activation_Type__c != 'KVH Registration on behalf of Customer'){
            PageReference pageRef = new PageReference(objActivationOrder.Return_URL__c);
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
            else if(objActivationOrder.Activation_Type__c == 'KVH Registration on behalf of Customer'){
            PageReference pageRef = new PageReference(Site.getBaseUrl()+'/home/home.jsp');
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
            else return null;
        }
        else if(internalUser){
            return null;
        }
        else{
            if(Site.getBaseUrl() != ''){
            PageReference pageRef = new PageReference(Site.getBaseUrl()+'/home/home.jsp');
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
            else{
            PageReference pageRef = new PageReference('/home/home.jsp');
            pageRef.setRedirect(true);                               //this causes the constructors to run again...
            return pageRef;
            }
        }
    }
    @RemoteAction
    public static string getAssetValue(String param,String param2,String param3){
        param = String.escapeSingleQuotes(param);
        param = String.escapeSingleQuotes(param2);
        param = String.escapeSingleQuotes(param3);
        List<Asset> listAsset = new List<Asset>();
        if(param != '' ){
            listAsset = [select id,name,Product2.Name from Asset where Name =: param AND (Product2.Name =: param2 OR Product2.Name =: param3)];
        }
        if(listAsset.size()> 0)
        return listAsset[0].Name;
        else return null;
    }
    @RemoteAction
    public static List<Account> getAccountData(String param){
        param = String.escapeSingleQuotes(param);
        return Database.query('Select Name, BillingCity, BillingState, BillingCountry, Phone, Id from Account where (RecordType.Name = \'Direct Partner\' OR RecordType.Name = \'Indirect Partner\') and name LIKE \'%'+param+'%\' LIMIT 10000');
    }
    @RemoteAction
    public static Account getUnknowDealer(){
        List<Account> lstAccount= new List<Account>();
        lstAccount = [select id,Name,BillingCountry,Phone,BillingState from Account where Name =: 'Unknown Dealer'];
        if(lstAccount.size() > 0)
        return lstAccount[0];
        else
        return null;
    }
}