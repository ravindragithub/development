public with sharing class Activation_Corporate_Controller extends ActivationsBaseController{
    //Page attributes
    public Activation_Subscriber__c newSubscriber;                                                      //The purpose of this page is to create one of these!
    
    public list<Activation_Contact__c> contlist;
    public list<SelectOption> SubscriberCountriesList = new list<SelectOption>();                       //List of Country Names for Subscriber Picklist
    public list<SelectOption> SubscriberStatesList = new list<SelectOption>();                          //List of State Names for Subscriber Picklist

    public string selectedTab {get;set;}
    public List<Activation_Subscriber__c> aSub{get;set;}
    public Boolean invoiceTypeSection{get;set;}
    //TAB Index variable can be get from custom settings
    public Map<String,Integer> disableAccsetupTabs {
        get { disableAccsetupTabs = New Map<String,Integer>();
             disableAccsetupTabs.put('Company_Information',1);
             disableAccsetupTabs.put('Authorized_Representatives',2);
             disableAccsetupTabs.put('Billing_Information',3);
             disableAccsetupTabs.put('Payment_Information',4);
             disableAccsetupTabs.put('Review',5);
             return disableAccsetupTabs; 
            }
        private set; 
    }
    
    //Constructor
    public Activation_Corporate_Controller(){

        system.debug('Invoking Constructor....');
        ActivationOrderId = ApexPages.currentPage().getParameters().get('order');       //extract Order Id
        ActivationStatus = readActivationStatus(ActivationOrderId);                     //get status record
        ActivationStatus.Active_Page__c = 'Activation_Corporate';                              //set Active Page 
        ActivationStatus.Account_Setup_Page__c = 'available';                           //set Page Available Status
        If (ActivationStatus.Account_Setup_Active_Tab__c == null){                      //set Active tab
            system.debug('set default tab....');
            selectedTab = 'Company_Information';
            ActivationStatus.Account_Setup_Active_Tab__c = selectedTab;
        } else {
            system.debug('use saved tab....');
            selectedTab = ActivationStatus.Account_Setup_Active_Tab__c;
        }
         if(ActivationStatus.Account_Setup_Last_Active_Tab_Index__c == null){
            ActivationStatus.Account_Setup_Last_Active_Tab_Index__c =1;
        }
        if(ActivationStatus.Account_Setup_Last_Active_Tab_Index__c < disableAccsetupTabs.get(selectedTab)){
            ActivationStatus.Account_Setup_Last_Active_Tab_Index__c = disableAccsetupTabs.get(selectedTab);
        }
        //Suubscriber Details Query Globally we can use
        aSub = [SELECT id,Subscriber_Custom_Call_AccountID__c,Parent_Account_Custom_Call_Account_ID__c,
                           Pay_from_sub_account_invoices__c,Pay_from_corporate_account_summary__c,Bill_to__c
                             
                                  FROM Activation_Subscriber__c WHERE Activation_Order__c=:ActivationOrderId LIMIT 1];
        if(aSub.size()>0){
            if(aSub[0].Subscriber_Custom_Call_AccountID__c == null && aSub[0].Parent_Account_Custom_Call_Account_ID__c==null){
                invoiceTypeSection = true;
            }
        }else{
            aSub = New List<Activation_Subscriber__c>();
        }
    }
    
    public pagereference InvRecipientAdd(){
        list<Activation_Contact__c> lstact= New list<Activation_Contact__c>();
        for(Activation_Contact__c acnt : [SELECT Id,Contact_Role__c	FROM Activation_Contact__c WHERE Activation_Order__c=:ActivationOrderId AND Contact_Role__c != null]){
            if(!acnt.Contact_Role__c.contains('Invoice Recipient'))
                acnt.Contact_Role__c += ',Invoice Recipient';
            lstact.add(acnt);
        }
        update lstact;
        return goToTab();
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
}