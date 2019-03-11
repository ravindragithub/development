public with sharing class AccountSetupController extends ActivationsBaseController{
    //Page attributes
    public Activation_Subscriber__c newSubscriber;                                                      //The purpose of this page is to create one of these!
    
    public list<SelectOption> SubscriberCountriesList = new list<SelectOption>();                       //List of Country Names for Subscriber Picklist
    public list<SelectOption> SubscriberStatesList = new list<SelectOption>();                          //List of State Names for Subscriber Picklist
    public boolean hasMainContactrole {get;set;}
    public string selectedTab {get;set;}
    public List<Activation_Subscriber__c> aSub{get;set;}
    public Boolean invoiceTypeSection{get;set;}
    Public String subBillTo{get;set;}
    public string strCorpduplicate {get;set;}
    //TAB Index variable can be get from custom settings
    public Map<String,Integer> disableAccsetupTabs {
        get { disableAccsetupTabs = New Map<String,Integer>();
             disableAccsetupTabs.put('Subscriber_Information',1);
             disableAccsetupTabs.put('Authorized_Representatives',2);
             disableAccsetupTabs.put('Dealer_Distributor_Info',3);
             disableAccsetupTabs.put('Billing_Information',4);
             disableAccsetupTabs.put('Payment_Information',5);
             return disableAccsetupTabs; 
            }
        private set; 
    }
    
    //Constructor
    public AccountSetupController(){
        aSub = New List<Activation_Subscriber__c>();
        system.debug('Invoking Constructor....');
        ActivationOrderId = ApexPages.currentPage().getParameters().get('order');       //extract Order Id
        ActivationStatus = readActivationStatus(ActivationOrderId);                     //get status record
        ActivationStatus.Active_Page__c = 'Account Setup';                              //set Active Page 
        ActivationStatus.Account_Setup_Page__c = 'available';                           //set Page Available Status
        If (ActivationStatus.Account_Setup_Active_Tab__c == null){                      //set Active tab
            selectedTab = 'Subscriber_Information';
            ActivationStatus.Account_Setup_Active_Tab__c = selectedTab;
        } else {
            selectedTab = ActivationStatus.Account_Setup_Active_Tab__c;
        }
         if(ActivationStatus.Account_Setup_Last_Active_Tab_Index__c == null){
            ActivationStatus.Account_Setup_Last_Active_Tab_Index__c =1;
        }
        if(ActivationStatus.Account_Setup_Last_Active_Tab_Index__c < disableAccsetupTabs.get(selectedTab)){
            ActivationStatus.Account_Setup_Last_Active_Tab_Index__c = disableAccsetupTabs.get(selectedTab);
        }
        //Suubscriber Details Query Globally we can use
        list<Activation_Order__c> lstOrder = [Select HasMainContactRole__c,Activation_Type__c from Activation_Order__c where id =: ActivationOrderId LIMIT 1];
        if(lstOrder.size()>0)hasMainContactrole = lstOrder[0].HasMainContactRole__c || lstOrder[0].Activation_Type__c == 'Airtime Case Activation' ;
        aSub = [SELECT id,Subscriber_Custom_Call_AccountID__c,Parent_Account_Custom_Call_Account_ID__c,Corporate_Billing_Account__c, contact__c, Corporate_Billing_Account__r.Corp_Duplicate__c,Corporate_Billing_Account__r.Billing_Contact__c,Corporate_Billing_Account__r.Bill_to__c,
                           Pay_from_sub_account_invoices__c,Pay_from_corporate_account_summary__c,Bill_to__c
                             
                                  FROM Activation_Subscriber__c WHERE Activation_Order__c=:ActivationOrderId LIMIT 1];
        if(aSub.size()>0){
            if(aSub[0].Corporate_Billing_Account__c == null && aSub[0].contact__c == [SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1][0].ContactId)
              hasMainContactrole = true;   
            if(aSub[0].Subscriber_Custom_Call_AccountID__c == null && aSub[0].Parent_Account_Custom_Call_Account_ID__c==null){
                invoiceTypeSection = true;
            }
            subBillTo = aSub[0].Bill_to__c;
        strCorpduplicate = aSub[0].Corporate_Billing_Account__r.Corp_Duplicate__c;
        if(aSub[0].Corporate_Billing_Account__r.Billing_Contact__c != null && (aSub[0].Corporate_Billing_Account__r.Bill_to__c == 'Corporate' || aSub[0].Corporate_Billing_Account__r.Corp_Duplicate__c == 'No'))
			strCorpduplicate = 'No'; 
        }
    }
    
    public pageReference goToTab(){
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        // Installation_Type page and tab redirection
        if(selectedTab == 'Installation_Type'){
            ActivationStatus.Active_Page__c = 'Installation Type';              //set Active Page 
            ActivationStatus.Installation_Type_Page__c = 'available';
            ActivationStatus.Installation_Type_Active_Tab__c = selectedTab;
            returnPage = page.Installation_Type;      //unfortunately, this returns the whole view state!
        }
        else{
            ActivationStatus.Account_Setup_Active_Tab__c = selectedTab;
             if(ActivationStatus.Account_Setup_Last_Active_Tab_Index__c < disableAccsetupTabs.get(selectedTab)){
            ActivationStatus.Account_Setup_Last_Active_Tab_Index__c = disableAccsetupTabs.get(selectedTab);
        }
        }
        upsert ActivationStatus;
        
        system.debug(returnPage.getURL());                       //YIKES! That's a problem!
        returnPage.getParameters().clear();                      //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActivationOrderId);     //add the order ID
        system.debug(returnPage.getURL());                       //much better!
        returnPage.setRedirect(true);                            //this causes the constructors to run again...
        return returnPage;
    }
    
     public pagereference saveandExit(){
        return null;
    }
}