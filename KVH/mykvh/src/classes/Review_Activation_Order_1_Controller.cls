/**
* @createdby        :   Teertha prasad
* @createddate      :   10/25/2016
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   23/03/2017
* @description      :   Class Used In Review Activation Order Page for Activation Order update
*                       and for navigating between tabs.
**/

Public without sharing Class Review_Activation_Order_1_Controller extends ActivationsBaseController{
    public string selectedTab       {get; set;} //current selected tab from vf page
    public boolean isSkipValidation {get; set;}
    private Activation_Order__c objActivationOrder = New Activation_Order__c();
    /** Constructor - Start **/
    public Review_Activation_Order_1_Controller(){
        selectedTab = '';
        isSkipValidation = false;
        ActivationOrderId = ApexPages.currentPage().getParameters().get('order');    //extract Order Id
        ActivationStatus = readActivationStatus(ActivationOrderId);             //get status record
        ActivationStatus.First_Review_Page__c = 'available';
        ActivationStatus.Active_Page__c = 'First Review';
        for(Activation_Order__c objActivationOrderTemp : [SELECT Id,Activation_Type__c,CreatedById FROM Activation_Order__c WHERE id =: ActivationOrderId] ){
            objActivationOrder = objActivationOrderTemp;
            if(objActivationOrder.Activation_Type__c == 'Activation on behalf of Customer' && objActivationOrder.CreatedById == UserInfo.getUserId()){
                isSkipValidation = true;
            }
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
        }else if(selectedTab == 'Plan_Types'){
            if(!isSkipValidation){
                ActivationStatus.Account_Setup_page__c = 'complete';
                ActivationStatus.Installation_Type_Page__c = 'complete';
                ActivationStatus.System_Page__c = 'complete';
            }
            if(ActivationStatus.Services_Page__c == 'inhibited' && !Test.isRunningTest()){
                ID jobIDFlow = System.enqueueJob(New callFlowMethod(ActivationOrderId, (objActivationOrder.Activation_Type__c == 'Activation on behalf of Customer' && objActivationOrder.CreatedById != UserInfo.getUserId()) ? 'Update' : 'Insert'));
            }
            ActivationStatus.Services_Page__c = 'available';
            ActivationStatus.Services_Active_Tab__c = selectedTab;
            ActivationStatus.Active_Page__c = 'Subscriptions';
            returnPage = page.Services;      //unfortunately, this returns the whole view state!
        }
        update ActivationStatus;
        returnPage.getParameters().clear();                         //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActivationOrderId); //add the order ID
        returnPage.setRedirect(true);                               //this causes the constructors to run again...
        return returnPage;
    }
    
    public pageReference updateStatus(){
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        ActivationStatus.Services_Page__c = 'available';
        ActivationStatus.Services_Active_Tab__c = 'Plan_Types';
        ActivationStatus.Active_Page__c = 'Subscriptions';
        returnPage = page.Services;      //unfortunately, this returns the whole view state!
        update ActivationStatus;
        returnPage.getParameters().clear();                         //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActivationOrderId); //add the order ID
        returnPage.setRedirect(true);                               //this causes the constructors to run again...
        return returnPage;
    }
    
    public class callFlowMethod implements Queueable{ 
        private String ActivationOrderId;
        private String strDMLKey;
        
        public callFlowMethod(String ActivationOrderId, String strDMLKey){            //constructor, handles input parameter
            this.ActivationOrderId = ActivationOrderId;
            this.strDMLKey = strDMLKey;
        }
        
        public void execute(QueueableContext context){  //Mandatory Execute method
            Map<String, Object> params = new Map<String, Object>();
            params.put('actid', ActivationOrderId);
            if(strDMLKey == 'Insert'){
                Flow.Interview.Create_Acct_etc CallFlowInsert = new Flow.Interview.Create_Acct_etc(params); CallFlowInsert.start();
            }else if(strDMLKey == 'Update'){
                Flow.Interview.Update_Acct_etc CallFlowUpdate = new Flow.Interview.Update_Acct_etc(params); CallFlowUpdate.start(); 
            }
        }
    }
}