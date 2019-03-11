public class Act_Invoice_component_controller extends Act_Base_component_controller {
    /* Use Activations Components Base Class...*/
    CountryStateMethods util = new CountryStateMethods();       //Helper Class
    public list<SelectOption> CountriesList = new list<SelectOption>();      
    public list<SelectOption> StatesList = new list<SelectOption>();
    private static String strInvoiceRecipientRole = 'Invoice Recipient'; // Contact InvoiceRecipient Role can be taken from custom labels later
    public string selectedTab {get; set;}
    public String  ActivationOrderId {get; set;}
    public Activation_subscriber__c objActivationSubscriber {get; set;}
    public String parentContainer {get; set;}
    public Boolean boolCorporateSummary {get; set;}
    public Boolean boolBillingSelection {get; set;}
    private static String strBillingRepresentativeRole = '%Billing Representative%';  //Billing Representative Role can be taken from custom labels later

    public Integer intCountBillRep {get; set;}
    //Used to CopySubscriberAddress
    Public Boolean copySubscriberAddress{get;set;}
    
    //For address Mapping if same as subscriber Address
    List<Activation_Subscriber__c> addressMapping;
    
    //Constructor
    public Act_Invoice_component_controller (){
        intCountBillRep = 0;
        boolBillingSelection = false;
        boolCorporateSummary = false;
        util = new CountryStateMethods();
        CountriesList = util.setupCountryPicklist();
        StatesList = util.setupStatesPicklist();
        ActOrderId = ApexPages.currentPage().getParameters().get('order');
        objActivationSubscriber = New Activation_Subscriber__c();
        
        intCountBillRep = [SELECT count() FROM Activation_Contact__c WHERE Activation_Order__c=:ActOrderId AND Contact_Role__c LIKE '%Billing Representative%'];
        addressMapping =  [SELECT Id, Name, Activation_Order__c,Subscriber_Address_Line_2__c,Billing_Rep_Address_Line_2__c ,City__c,Country__c,Billing_City__c,Billing_State_Province__c,
                           State_Province__c,Postal_Zip_Code__c,Billing_Zip_Code__c ,Preferred_Addressee__c,Mail_to__c ,Corp_Duplicate__c,Address__c,Billing_Rep_Address__c,Billing_Country__c,Billing_Contact_Role__c,Same_as_Company_Address__c 
                           FROM  Activation_Subscriber__c 
                           WHERE Activation_Order__c=:ActOrderId];
        for(Activation_Contact__c objActivationContact: 
            [SELECT id,Contact_Role__c,Activation_Order__c,Company_Main_Contact__c
             FROM Activation_Contact__c WHERE  (Activation_Order__c =: ActOrderId AND Contact_Role__c LIKE :strBillingRepresentativeRole) LIMIT 1 ]){
                 boolBillingSelection = true;
             }
        /*if(addressMapping.size() >0 && addressMapping[0].Mail_to__c == null){
           addressMapping[0].Mail_to__c = 'Customer';
        }*/
        if(addressMapping.size() >0 && addressMapping[0].Mail_to__c == 'Both'){
            boolCorporateSummary = true;
        }
        objActivationSubscriber = addressMapping.size() >0 ? addressMapping[0] : New Activation_Subscriber__c(); 
        system.debug('objActivationSubscriber' + objActivationSubscriber);
        componentCountryChangeHandler(); 
    }
    //Getters and Setters
    public list<SelectOption> getCountriesList(){
        return CountriesList;
    }
    public list<SelectOption> getStatesList(){
        return StatesList;
    }
    
    public void componentCountryChangeHandler(){
        StatesList = util.CountryChangeHandler(objActivationSubscriber.Billing_Country__c,objActivationSubscriber.Billing_State_Province__c);
    }
    public void componentStateChangeHandler(){
        system.debug('Invoking State Change handler....');
    }
    
    public pageReference updateSubscriber(){
        system.debug('objActivationSubscriber' + objActivationSubscriber);
        if(objActivationSubscriber != null && objActivationSubscriber.id != null){
            system.debug('objActivationSubscriber' + objActivationSubscriber.Corp_Duplicate__c); 
            objActivationSubscriber.Billing_Country__c = null;
            objActivationSubscriber.Bill_to__c = 'Corporate';
            if(boolCorporateSummary)
                objActivationSubscriber.Mail_to__c = 'Both';
            update objActivationSubscriber;
        }
        return gototab();
    }
    
    public pageReference gototab(){
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        actStatus.Account_Setup_Active_Tab__c = selectedTab;
        update actStatus;
        //system.debug(returnPage.getURL());                       //YIKES! That's a problem!
        returnPage.getParameters().clear();                      //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActOrderId);     //add the order ID
        returnPage.setRedirect(true);                            //this causes the constructors to run again...
        return returnPage;
    }
    
     Public void callDisableFunction(){
        system.debug('copySubscriberAddress'+copySubscriberAddress);
        if(objActivationSubscriber.Same_as_Company_Address__c){
                    mapAddressMapping();
        }else{
            objActivationSubscriber = addressMapping[0].clone(true,true);
            StatesList = util.CountryChangeHandler(objActivationSubscriber.Billing_Country__c, objActivationSubscriber.Billing_State_Province__c);
        } 
    }
    public pagereference save(){
        update objActivationSubscriber;
        return gototab();
    }
     @testvisible
      private void mapAddressMapping(){
      if(addressMapping.size()>0){
            objActivationSubscriber.Billing_Rep_Address__c = addressMapping[0].Address__c;
            objActivationSubscriber.Billing_Rep_Address_Line_2__c = addressMapping[0].Subscriber_Address_Line_2__c;
            objActivationSubscriber.Billing_City__c = addressMapping[0].City__c;
            objActivationSubscriber.Billing_State_Province__c = addressMapping[0].State_Province__c;
            objActivationSubscriber.Billing_Country__c = addressMapping[0].Country__c;
            objActivationSubscriber.Billing_Zip_Code__c = addressMapping[0].Postal_Zip_Code__c;
            StatesList = util.CountryChangeHandler(objActivationSubscriber.Billing_Country__c, objActivationSubscriber.Billing_State_Province__c);
        }
    }
    public pagereference saveandExit(){
        update objActivationSubscriber;
        return null;
    }
}