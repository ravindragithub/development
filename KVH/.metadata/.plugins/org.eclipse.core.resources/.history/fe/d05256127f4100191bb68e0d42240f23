/**
* @createdby        :   Teertha prasad
* @createddate      :   10/25/2016
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   11/29/2016
* @description      :   Class Used In Review Activation Order Page for Activation Order update
*                       and for navigating between tabs.
**/

Public Class Review_Activation_Order_Controller extends ActivationsBaseController{
    public string selectedTab           {get; set;} //current selected tab from vf page
    
    /** Constructor - Start **/
    public Review_Activation_Order_Controller(){
        ActivationOrderId = ApexPages.currentPage().getParameters().get('order');    //extract Order Id
        ActivationStatus = readActivationStatus(ActivationOrderId);             //get status record
        ActivationStatus.Activate_Page__c = 'available';
        ActivationStatus.Active_Page__c = 'Review Activation Order';
        if(ActivationStatus.Activate_Active_Tab__c == null){                     //set Active tab
            selectedTab = 'Service_Summary';
            ActivationStatus.Activate_Active_Tab__c = selectedTab;
        } else {
            selectedTab = ActivationStatus.Activate_Active_Tab__c;
        }
    }
    /** Constructor - End **/
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   11/29/2016
* @description          :   goToTab Method.
*                           To update Activation status and navigate next Or Previous
*                           tab based on vf page 'selectedTab' param. And Also Upsert
*                           Activation Service
* @return               :   pageReference
* @invoke               :   (onclick) From Vf page
**/
    public pageReference goToTab(){
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        if(selectedTab == 'Subscriber_Information' || selectedTab == 'Authorized_Representatives' || selectedTab == 'Payment_Information' || selectedTab == 'Billing_Information'){
            ActivationStatus.Account_Setup_Active_Tab__c = selectedTab;
            ActivationStatus.Active_Page__c = 'Account Type';
            returnPage = page.Account_Setup;      //unfortunately, this returns the whole view state!
        }else if(selectedTab == 'Installation_Type' || selectedTab == 'IMO_Number' || selectedTab == 'Vessel_Details' || selectedTab == 'Onboard_Contact' || selectedTab == 'Antenna_System_Support_Contact' || selectedTab == 'Dealer_Distributor_Info'){
            ActivationStatus.Active_Page__c = 'Installation Type';              //set Active Page 
            ActivationStatus.Installation_Type_Active_Tab__c = selectedTab;
            returnPage = page.Installation_Type;      //unfortunately, this returns the whole view state!
        }else if(selectedTab == 'System_Type' || selectedTab == 'System_Selection' || selectedTab == 'System_Details'){
            ActivationStatus.System_Active_Tab__c = selectedTab;
            ActivationStatus.Active_Page__c = 'System';
            returnPage = page.ActivationSystemInfo;      //unfortunately, this returns the whole view state!
        }else if(selectedTab == 'Plan_Types' || selectedTab == 'Airtime_Plans' || selectedTab == 'Voice_Lines' || selectedTab == 'IP_MobileCast' || selectedTab == 'Additional_Plans_and_Services'){
            ActivationStatus.Services_Active_Tab__c = selectedTab;
            ActivationStatus.Active_Page__c = 'Subscriptions';
            returnPage = page.Services;      //unfortunately, this returns the whole view state!
        }else if(selectedTab == 'Technical_Assistance_Package' || selectedTab == 'Extended_Warranty'){
            ActivationStatus.OneCare_Active_Tab__c = selectedTab;
            ActivationStatus.Active_Page__c = 'OneCare';
            returnPage = page.ActivationOneCare; 
        }else if(selectedTab == 'Contract_Details'){
            ActivationStatus.Active_Page__c = 'Contract Details'; 
            ActivationStatus.Contract_Details_Active_Tab__c = selectedTab;
            returnPage = page.Contract_Details;      //unfortunately, this returns the whole view state!
        }else if(selectedTab == 'Service_Summary'){
            ActivationStatus.Activate_Active_Tab__c = selectedTab;
            ActivationStatus.Active_Page__c = 'Review Activation Order';
            returnPage = page.Review_Activation_Order; 
        }
        update ActivationStatus;
        returnPage.getParameters().clear();                         //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActivationOrderId); //add the order ID
        returnPage.setRedirect(true);                               //this causes the constructors to run again...
        return returnPage;
    }
    
}