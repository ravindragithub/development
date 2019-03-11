/**
* @createdby        :   Teertha prasad
* @createddate      :   07/16/2016
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   01/03/2017
* @description      :   Class Used In Services Page for Activation Services Creation 
*                       update and for navigating between tabs.
**/

Public Class Services_Controller extends ActivationsBaseController{
    public string selectedTab           {get; set;} //current selected tab from vf page
    public String strPlanName 			{get; set;}
    public Activation_Service__c objActivationService {get; set;} 
    public Activation_Platform__c objActivationPlatform {get; set;} 
    public Activation_Subscriber__c objActivationSubscriber {get; set;} 
    public Boolean boolHasCustomRatePlan {get; set;}
    public List<SBQQ__ProductFeature__c> lstProductFeatures {get; set;}
    private String strFixedRatePlan = 'Fixed Rate Plans';
    private String strMeteredRatePlan = 'Metered Rate Plans';
    private String strIridiumRatePlan = 'Iridium Rate Plans';
    private String strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Activation System').getRecordTypeId();
    private Id Customer_RECORD_TYPE_ID = Schema.SObjectType.Activation_Subscriber__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

    //TAB Index variable can be get from custom settings
    public Map<String,Integer> mapdisableActivationServiceTabs {
        get { mapdisableActivationServiceTabs = New Map<String,Integer>();
             mapdisableActivationServiceTabs.put('Plan_Types',1);
             mapdisableActivationServiceTabs.put('Airtime_Plans',2);   
             mapdisableActivationServiceTabs.put('Voice_Lines',3);
             mapdisableActivationServiceTabs.put('IP_MobileCast',4);
             mapdisableActivationServiceTabs.put('Additional_Plans_and_Services',5);
             return mapdisableActivationServiceTabs; 
            }
        private set; 
    }
    
    /** Constructor - Start **/
    public Services_Controller(){
        lstProductFeatures = New List<SBQQ__ProductFeature__c>();
        ActivationOrderId = ApexPages.currentPage().getParameters().get('order');    //extract Order Id
        ActivationStatus = readActivationStatus(ActivationOrderId);             //get status record
        objActivationService = readActivationService(ActivationOrderId);       //get service record
        ActivationStatus.Active_Page__c = 'Subscriptions'; 
        ActivationStatus.Services_Page__c ='available';                           //set Page Available Status
        if(ActivationStatus.Services_Active_Tab__c == null){                   //set Active tab
            selectedTab = 'Plan_Types';
            if(objActivationService != null && objActivationService.VSAT_Antenna_Hardware__c !=null && objActivationService.VSAT_Antenna_Hardware__c != '' && objActivationService.VSAT_Antenna_Hardware__c.containsIgnoreCase('V3')){
                selectedTab = 'Airtime_Plans';
                objActivationService.Activation_Plan_Type__c = objActivationService.VSAT_Antenna_Hardware__c.containsIgnoreCase('Iridium') ? strIridiumRatePlan : strMeteredRatePlan;
            }
        }else {
            selectedTab = ActivationStatus.Services_Active_Tab__c;
            if(objActivationService != null && objActivationService.VSAT_Antenna_Hardware__c !=null && objActivationService.VSAT_Antenna_Hardware__c != '' && objActivationService.VSAT_Antenna_Hardware__c.containsIgnoreCase('V3')){
                if(ActivationStatus.Services_Active_Tab__c == 'Plan_Types'){
                    selectedTab = 'Airtime_Plans';
                }
                if(selectedTab == 'Airtime_Plans'){
                    objActivationService.Activation_Plan_Type__c = objActivationService.VSAT_Antenna_Hardware__c.containsIgnoreCase('Iridium') ? strIridiumRatePlan : strMeteredRatePlan;
                } 
            } else if(objActivationService != null && (objActivationService.Activation_Plan_Type__c == null || objActivationService.Activation_Plan_Type__c == '')){
                selectedTab = 'Plan_Types';
                ActivationStatus.Services_Type_Last_Active_Tab_Index__c = 1;
                ActivationStatus.Services_Active_Tab__c = selectedTab;
            }
        }
        ActivationStatus.Services_Active_Tab__c = selectedTab;
        
        if(ActivationStatus.Services_Type_Last_Active_Tab_Index__c == null){
            ActivationStatus.Services_Type_Last_Active_Tab_Index__c = 1;
        }
        if(ActivationStatus.Services_Type_Last_Active_Tab_Index__c < mapdisableActivationServiceTabs.get(selectedTab)){
            ActivationStatus.Services_Type_Last_Active_Tab_Index__c = mapdisableActivationServiceTabs.get(selectedTab);
        }
        
        if(objActivationService != null && objActivationService.Activation_Plan_Type__c != null && objActivationService.Activation_Plan_Type__c != ''){
            strPlanName = objActivationService.Activation_Plan_Type__c;
            if(Activation_Product_Bundle__c.getValues(objActivationService.Activation_Plan_Type__c) != null){
                String strProductbundleId = Activation_Product_Bundle__c.getValues(objActivationService.Activation_Plan_Type__c).Product_Bundle_Id__c;
                String strQuery = 'SELECT Id,Name FROM SBQQ__ProductFeature__c WHERE SBQQ__ConfiguredSKU__c =: strProductbundleId ';
                if(objActivationService.Activation_Plan_Type__c != strFixedRatePlan){
                    strQuery += ' ORDER BY SBQQ__Number__c '; 
                }else{
                    String tempInput ='\'%' + objActivationService.Bandwidth_Management_Control_Interval__c  + '%\'';
                    strQuery += 'AND Name LIKE ' + tempInput + ' ORDER BY SBQQ__Number__c ';
                }
                lstProductFeatures = Database.query(strQuery);
            }
        } 
    }
    /** Constructor - End **/
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   02/03/2017
* @description          :   readActivationService Method.
*                           Create Activation Service If not present, else get Activation Service
*                           And used in vf page.
* @return               :   Activation_Service__c Object
* @invoke               :   From Constructor
**/
    public Activation_Service__c readActivationService(String strOrderId){
        Activation_Service__c objActivationServiceTemp = New Activation_Service__c();
        objActivationServiceTemp.Activation_Order__c = strOrderId;
        objActivationPlatform = New Activation_Platform__c();
        objActivationSubscriber = New Activation_Subscriber__c();
        List<Activation_Order__c> lstActivationOrder = New List<Activation_Order__c>();
        lstActivationOrder= [SELECT Id,Contract_Term__c,Hardware_Purchased_or_Leased__c,Activation_Opportunity__c,Activation_Opportunity__r.AccountId,
                             (SELECT Id,Account__c,Corporate_Billing_Account__c,Corporate_Billing_Account__r.Has_Custom_Rate_Plan__c 
                              FROM Activation_Subscribers__r 
                              WHERE Corporate_Billing_Account__c != null AND Corporate_Billing_Account__r.Has_Custom_Rate_Plan__c = true AND RecordTypeId =: Customer_RECORD_TYPE_ID),
                             (SELECT Id, Name,Confirm_if_boat_yacht_is_chartered__c, Activation_Order__c, Market__c, Market_Sector__c,Platform_Detail__c,
                              Flag__c,Vessel_Radio_Call_Sign__c,Vessel_IMO__c,Vessel_Length_ft_m__c,Vehicle_Model__c,
                              Industry_Designation__c,MMSI__c,Vehicle_Make_Model__c,Vehicle_Year__c,Having_IMO__c
                              FROM Activation_Platforms__r),
                             (SELECT Id,Viewing_Options__c,Viewing_Option_Product__c,Media_Server_Serial_Number__c,
                              Media_Server__c,Activation_Order__c,Entertainment_Programming_Product__r.Name,
                              Bandwidth_Management_Control_Interval__c,More_than_one_global_static_IP_addresses__c,
                              Independent_Entertainment_Channels__c,Operations_Data_Services__c,Special_Event_Channels__c,
                              Training_Packages__c,Entertainment_Programming_Selected__c,Entertainment_Programming_Product__c,
                              Voice2_Code3__c,Voice2_Code4__c,Voice2_Code5__c,Voice2_Country1__c,Voice2_Country2__c,
                              Voice2_Country3__c,Voice2_Country4__c,Voice2_Country5__c,Voice2_User_Country__c,Voice2_User_Specified_Code__c,
                              Voice2_Code1__c,Voice2_Code2__c,Inbound_IPs_ranges__c,Other_Inbound_Applications__c,
                              Additional_Comments__c,Activation_Contact__c,World_Region__c,Inbound_Applications__c,
                              CommBox_Product__r.Name,Voice1_User_Country__c,Voice1_User_Specified_Code__c,Voice_Line_2_Type__c,
                              Pilot_Firmware_Version__c,Pilot_SIM_Card_Number__c,Pilot_IMEI_Number__c,Iridium_OpenPort_Product__c,
                              Iridium_OpenPort_Selected__c,Global_Static_IP_Product__c,Global_Static_IP_Selected__c,CommBox_Product__c,
                              CommBox_Selected__c,Voice_1_Product__c,Voice_2_Product__c,Voice1_Country1__c,Voice1_Code1__c,
                              Voice1_Country2__c,Voice1_Code2__c,Voice1_Country3__c,Voice1_Code3__c,Voice1_Country4__c,Voice1_Code4__c,
                              Voice1_Country5__c,Voice1_Code5__c,Voice_Line_1_Type__c,CommBox_Hub_Hosting_Id__c, Activation_Plan_Type__c,
                              Activation_Rate_Plan__c,Special_Instructions__c, Product__c, Product__r.Name, VSAT_Antenna_Hardware__c,
                              Is_Selected__c FROM Activation_Services__r),
                             (SELECT Id, Root_Asset_Product_Group__c, System_Detail__c, System_Name__c 
                              FROM Activation_Hardware__r WHERE RecordTypeId =: strActivationHardwareRecordTypeId)
                             FROM Activation_Order__c 
                             WHERE Id=: strOrderId LIMIT 1];
        
        if(lstActivationOrder.size()>0){ 
            for(Activation_Service__c objActivationService1 : lstActivationOrder[0].Activation_Services__r){
                objActivationServiceTemp = objActivationService1;
            }
            for(Activation_Platform__c objActivationPlatform1 : lstActivationOrder[0].Activation_Platforms__r){
                objActivationPlatform = objActivationPlatform1;
            }
            boolHasCustomRatePlan = false;
            for(Activation_Subscriber__c objActivationSubscriber1 : lstActivationOrder[0].Activation_Subscribers__r){
                boolHasCustomRatePlan = true;
                objActivationSubscriber = objActivationSubscriber1;
            }
            
            List<Activation_Hardware__c> lstActivationHardware = New List<Activation_Hardware__c>();
            lstActivationHardware =  lstActivationOrder[0].Activation_Hardware__r;
            if(lstActivationHardware.size()>0){
                if(objActivationServiceTemp.VSAT_Antenna_Hardware__c != lstActivationHardware[0].Root_Asset_Product_Group__c){
                    objActivationServiceTemp.VSAT_Antenna_Hardware__c = lstActivationHardware[0].Root_Asset_Product_Group__c;
                    ActivationStatus.Services_Type_Last_Active_Tab_Index__c = 1;
                    ActivationStatus.Services_Active_Tab__c = 'Plan_Types';
                }
            }
        }
          return objActivationServiceTemp;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   09/20/2016
* @description          :   updateActivationService Method.
*                           Upsert Activation Service
* @return               :   void
* @invoke               :   From action method of Vf page
**/
    public void updateActivationService(){
        objActivationService.Activation_Plan_Type__c = strPlanName;
        objActivationService.Product__c = null;
        objActivationService.Is_Selected__c = false;
        upsert objActivationService;
    } 
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   09/20/2016
* @description          :   updateActivationService1 Method.
*                           Upsert Activation Service
* @return               :   void
* @invoke               :   From action method of Vf page
**/
    public void updateActivationService1(){
        upsert objActivationService;
    } 
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   11/10/2016
* @description          :   bandwidthManagementControl get method.
* @return               :   void
* @invoke               :   From Vf page on render
**/
    public List<SelectOption> bandwidthManagementControl{
        get {
            List<SelectOption> options = new List<SelectOption>();
            for(Schema.PicklistEntry objPickList : Activation_Service__c.Bandwidth_Management_Control_Interval__c.getDescribe().getPicklistValues()) {
                options.add(new SelectOption(objPickList.getValue(), objPickList.getLabel()));
            } 
            return options;
        }  
        set;
    }
    
 
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   12/05/2016
* @description          :   goToTab Method.
*                           To update Activation status and navigate next Or Previous
*                           tab based on vf page 'selectedTab' param. And Also Upsert
* 							Activation Service
* @return               :   pageReference
* @invoke               :   (onclick) From Vf page
**/
    public pageReference goToTab(){
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        if(selectedTab == ''){
            ActivationStatus.First_Review_Page__c ='available';     
            ActivationStatus.Active_Page__c = 'First Review';
            returnPage = page.Review_Activation_Order_1;      //unfortunately, this returns the whole view state!
        }
        else if(selectedTab == 'Technical_Assistance_Package'){
            ActivationStatus.OneCare_Page__c = 'available';
            ActivationStatus.OneCare_Active_Tab__c = selectedTab;
            ActivationStatus.Active_Page__c = 'OneCare';
            returnPage = page.ActivationOneCare; 
        }
        else{
            ActivationStatus.Services_Active_Tab__c = selectedTab;
            if(ActivationStatus.Services_Type_Last_Active_Tab_Index__c < mapdisableActivationServiceTabs.get(selectedTab)){
                ActivationStatus.Services_Type_Last_Active_Tab_Index__c = mapdisableActivationServiceTabs.get(selectedTab);
            }
        }
        update ActivationStatus;
        
        returnPage.getParameters().clear();                         //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActivationOrderId); //add the order ID
        returnPage.setRedirect(true);                               //this causes the constructors to run again...
        return returnPage;
    }
    
}