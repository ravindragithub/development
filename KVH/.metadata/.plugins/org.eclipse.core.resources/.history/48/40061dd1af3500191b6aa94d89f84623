/**
* @createdby        :   Teertha prasad
* @createddate      :   10/25/2016
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   02/15/2017
* @description      :   Class Used In Contract Details Page for Activation Order update
*                       and for navigating between tabs.
**/

Public Class Contract_Details_Controller extends ActivationsBaseController{
    public string selectedTab           {get; set;} //current selected tab from vf page
    public Activation_Order__c objActivationOrder {get; set;} 
    public Activation_Service__c objActivationService {get; set;}
    private Map<String,String> mapMonthToInteger  = New Map<String,String> { 'Jan'  => '1', 'Feb'  => '2', 'Mar'  => '3',  'Apr'  => '4', 'May'  => '5', 'Jun'  => '6',  'Jul'  => '7',  'Aug'  => '8', 'Sep'  => '9',  'Oct'  => '10',  'Nov'  => '11', 'Dec'  => '12'};
    private Map<String,String> mapIntegerToMonth  = New Map<String,String> { '1' => 'Jan', '2' => 'Feb', '3' => 'Mar',   '4' => 'Apr',  '5' => 'May', '6' => 'Jun', '7' => 'Jul', '8' => 'Aug', '9' => 'Sep', '10' => 'Oct', '11' => 'Nov', '12' => 'Dec' };
    public String strServiceStartDate {get;set;}
    public String strServicePreActivationDate {get;set;}
    private Static String strIridium = 'Iridium';
    private Static String strV3 = 'V3';
    private Static String strFlex = 'Flex';
    private String strIridiumProductPlans = 'Iridium Rate Plans';
    public Boolean boolIridiumDisableEdit {get;set;}   
    public Boolean boolShowPreActivationDate {get;set;}
    private Id Customer_RECORD_TYPE_ID = Schema.SObjectType.Activation_Subscriber__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

    /** Constructor - Start **/
    public Contract_Details_Controller(){
        ActivationOrderId = ApexPages.currentPage().getParameters().get('order');    //extract Order Id
        ActivationStatus = readActivationStatus(ActivationOrderId);             //get status record
        objActivationOrder = readActivationOrder(ActivationOrderId);       //get Order record
        ActivationStatus.Active_Page__c = 'Contract Details'; 
        ActivationStatus.Contract_Details_Page__c = 'available';
        if(ActivationStatus.Contract_Details_Active_Tab__c == null){                     //set Active tab
            selectedTab = 'Contract_Details';
            ActivationStatus.Contract_Details_Active_Tab__c = selectedTab;
        } else {
            selectedTab = ActivationStatus.Contract_Details_Active_Tab__c;
        }
        
        strServiceStartDate = objActivationOrder.Service_Start_Date__c != null ? String.valueOf(objActivationOrder.Service_Start_Date__c) : '';
        if(strServiceStartDate != ''){
            String[] strSplit = strServiceStartDate.split('-');
            strSplit[1] = mapIntegerToMonth.get(string.valueOf(integer.valueOf(strSplit[1])));
            strServiceStartDate = strSplit[0] +'-'+ strSplit[1] +'-'+ strSplit[2];
        }
        
        strServicePreActivationDate = objActivationOrder.Pre_Activation_Date__c != null ? String.valueOf(objActivationOrder.Pre_Activation_Date__c) : '';
        if(strServicePreActivationDate != ''){
            String[] strSplit = strServicePreActivationDate.split('-');
            strSplit[1] = mapIntegerToMonth.get(string.valueOf(integer.valueOf(strSplit[1])));
            strServicePreActivationDate = strSplit[0] +'-'+ strSplit[1] +'-'+ strSplit[2];
        }
    }
    /** Constructor - End **/
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   09/20/2016
* @description          :   readActivationOrder Method.
*                           Create Activation Order If not present, else get Activation Order
*                           And used in vf page.
* @return               :   Activation_Order__c Object
* @invoke               :   From Constructor
**/
    public Activation_Order__c readActivationOrder(String strOrderId){
        boolIridiumDisableEdit = false;
        boolShowPreActivationDate = false;
        Activation_Order__c objActivationOrderTemp = New Activation_Order__c();
        objActivationService = New Activation_Service__c();
        List<Activation_Order__c> lstActivationOrder = New List<Activation_Order__c>();
        lstActivationOrder= [SELECT Id,Contract_Term__c,Pre_Activation_Date__c,Entertainment_News_Sports_Training_Term__c,Operation_Data_Services_Term__c,
                             Promotional_Code__c,Service_Start_Date__c,Lease_Term__c,Hardware_Purchased_or_Leased__c,
                             (SELECT Id,Account__c,Corporate_Billing_Account__c FROM Activation_Subscribers__r 
                              WHERE Corporate_Billing_Account__c != null AND RecordTypeId =: Customer_RECORD_TYPE_ID),
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
                              Activation_Rate_Plan__c,Special_Instructions__c, Product__c, Product__r.Name, Product__r.SBQQ__SubscriptionTerm__c,
                              VSAT_Antenna_Hardware__c,Is_Selected__c FROM Activation_Services__r)
                             FROM Activation_Order__c 
                             WHERE Id=: strOrderId LIMIT 1];
        
        if(lstActivationOrder.size()>0){
            objActivationOrderTemp = lstActivationOrder[0];
            objActivationOrderTemp.Contract_Term__c = (objActivationOrderTemp.Lease_Term__c != null && objActivationOrderTemp.Lease_Term__c != 0 ? objActivationOrderTemp.Lease_Term__c : objActivationOrderTemp.Contract_Term__c);
            objActivationOrderTemp.Entertainment_News_Sports_Training_Term__c = (objActivationOrderTemp.Lease_Term__c != null && objActivationOrderTemp.Lease_Term__c != 0 ? objActivationOrderTemp.Lease_Term__c : objActivationOrderTemp.Entertainment_News_Sports_Training_Term__c);
            List<Activation_Service__c> lstActivationService = New List<Activation_Service__c>();
            lstActivationService = lstActivationOrder[0].Activation_Services__r;
            if(lstActivationService.size() >0){
                objActivationService = lstActivationService[0];
                if(objActivationService.Product__c != null && objActivationService.Activation_Plan_Type__c != null && objActivationService.Activation_Plan_Type__c != '' && objActivationService.Activation_Plan_Type__c == strIridiumProductPlans &&  objActivationService.VSAT_Antenna_Hardware__c != '' && objActivationService.VSAT_Antenna_Hardware__c != null && objActivationService.VSAT_Antenna_Hardware__c.containsIgnoreCase(strV3) && objActivationService.VSAT_Antenna_Hardware__c.containsIgnoreCase(strIridium)){
                    objActivationOrderTemp.Contract_Term__c = objActivationService.Product__r.SBQQ__SubscriptionTerm__c;
                    boolIridiumDisableEdit = true;
                }
                if(objActivationService.Product__c != null && objActivationService.Activation_Plan_Type__c != null && objActivationService.Activation_Plan_Type__c != '' && objActivationService.Activation_Rate_Plan__c != null && objActivationService.Activation_Rate_Plan__c != '' && objActivationService.Activation_Rate_Plan__c.containsIgnoreCase(strFlex) && objActivationOrderTemp.Hardware_Purchased_or_Leased__c == 'Purchased' && objActivationOrderTemp.Contract_Term__c == Null){
                    objActivationOrderTemp.Contract_Term__c = 12;
                }
            }
            boolShowPreActivationDate = false;
            for(Activation_Subscriber__c objActivationSubscriber1 : lstActivationOrder[0].Activation_Subscribers__r){
                boolShowPreActivationDate = true;
            }
        }
        return objActivationOrderTemp;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   10/25/2016
* @description          :   updateActivationOrderContract Method.
*                           Upsert Activation Order
* @return               :   void
* @invoke               :   From action method of Vf page
**/
    public pagereference updateActivationOrderContract(){
        String strServiceStartDateTemp = strServiceStartDate.replaceFirst(strServiceStartDate.substringBetween('-', '-'), mapMonthToInteger.get(strServiceStartDate.substringBetween('-', '-')));
        String[] strParsing = strServiceStartDateTemp.split('-');
        Date convertedDate= Date.newInstance(Integer.valueOf(strParsing[0]),Integer.valueOf(strParsing[1]), Integer.valueOf(strParsing[2]));
        objActivationOrder.Service_Start_Date__c = convertedDate;
        
        if(strServicePreActivationDate != '' && strServicePreActivationDate != null){
            String strServicePreActivationDateTemp = strServicePreActivationDate.replaceFirst(strServicePreActivationDate.substringBetween('-', '-'), mapMonthToInteger.get(strServicePreActivationDate.substringBetween('-', '-')));
            String[] strParsing1 = strServicePreActivationDateTemp.split('-');
            Date convertedDate1= Date.newInstance(Integer.valueOf(strParsing1[0]),Integer.valueOf(strParsing1[1]), Integer.valueOf(strParsing1[2]));
            objActivationOrder.Pre_Activation_Date__c = convertedDate1;
        }
        upsert objActivationOrder;
        return null;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   09/20/2016
* @description          :   goToTab Method.
*                           To update Activation status and navigate next Or Previous
*                           tab based on vf page 'selectedTab' param. And Also Upsert
*                           Activation Service
* @return               :   pageReference
* @invoke               :   (onclick) From Vf page
**/
    public pageReference goToTab(){
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        if(selectedTab == 'Extended_Warranty'){
            ActivationStatus.Active_Page__c = 'OneCare';
            ActivationStatus.OneCare_Page__c ='available';                           //set Page Available Status
            ActivationStatus.OneCare_Active_Tab__c = selectedTab;
            returnPage = page.ActivationOneCare;      //unfortunately, this returns the whole view state!
        }
        else if(selectedTab == 'Service_Summary'){
            ActivationStatus.Activate_Page__c = 'available';
            ActivationStatus.Activate_Active_Tab__c = selectedTab;
            
            ActivationStatus.Active_Page__c = 'Review Activation Order';
            returnPage = page.Review_Activation_Order; 
        }
        else{
            ActivationStatus.Contract_Details_Active_Tab__c = selectedTab;
        }
        update ActivationStatus;
        
        returnPage.getParameters().clear();                         //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActivationOrderId); //add the order ID
        returnPage.setRedirect(true);                               //this causes the constructors to run again...
        return returnPage;
    }
    
}