/**
* @createdby        :   Teertha prasad
* @createddate      :   28/05/2016
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   03/06/2016
* @description      :   Class Used In Activation_Onboard_Contact for Activation platform fields 
*                       update and for navigating between tabs.
**/ 

public class Act_Onboard_Contact_component_controller  extends Act_Base_component_controller{
    CountryStateMethods   objCountryStateMethods        = new CountryStateMethods(); //Helper Class to load Country ans relevent State
    
    //Contact Varibles
    public list<SelectOption> CountriesList = new list<SelectOption>();      
    public list<SelectOption> StatesList = new list<SelectOption>();
    public Activation_Contact__c objOnboardAntennaContact   {get; set;}     //The Contact related to the Order!
    public string selectedTab {get; set;}
    public String parentContainer{get; set;}
    
    //URL Variables
    String strActivationSubscriber;
    String strActivationContact;
    
    /** Constructor - Start **/
    public Act_Onboard_Contact_component_controller(){
        CountryStateMethods objCountryStateMethods = new CountryStateMethods();
        CountriesList = objCountryStateMethods.setupCountryPicklist();
        StatesList = objCountryStateMethods.setupStatesPicklist();
        
        strActivationSubscriber = ApexPages.currentPage().getParameters().get('subsActID');
        strActivationContact = ApexPages.currentPage().getParameters().get('conActID');
        ActOrderId = ApexPages.currentPage().getParameters().get('order');
        objOnboardAntennaContact = strActivationSubscriber !=null ? readActivationSubscriber(strActivationSubscriber) : readActivationContact(strActivationContact);
        componentCountryChangeHandler();
    }
    /** Constructor - End **/
    
    //Getters and Setters
    public list<SelectOption> getCountriesList(){
        return CountriesList;
    }
    
    public list<SelectOption> getStatesList(){
        return StatesList;
    }
    
    public void componentCountryChangeHandler(){
        StatesList = objCountryStateMethods.CountryChangeHandler(objOnboardAntennaContact.Country__c, objOnboardAntennaContact.State__c);
    }
    
    public void componentStateChangeHandler(){
        system.debug('Invoking State Change handler....');
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   03/06/2016
    * @description          :   readActivationSubscriber Method.
    *                           Load Selected Activation Subscriber on edit layout
    *                           And used in component.
    * @return               :   Activation_Contact__c, object - selected subscriber 
    * @invoke               :   From construction
    **/
    public Activation_Contact__c readActivationSubscriber(String strActivationSubscriber){
        objOnboardAntennaContact = New Activation_Contact__c();
        Activation_Subscriber__c actsubscriber = New Activation_Subscriber__c();
        if(strActivationSubscriber!=null){
            actsubscriber = [SELECT Id, Name, Activation_Order__c,Subscriber_Address_Line_2__c,City__c,Country__c ,State_Province__c ,
                             Billing_Zip_Code__c, Billing_State_Province__c, Billing_Secondary_Phone__c, 
                             Billing_Secondary_Phone_Type__c, Billing_Rep_Salutation__c, Billing_Rep_Name__c, 
                             Billing_Rep_Middle_Name__c, Billing_Rep_Job_Title__c, Billing_Rep_Job_Function__c, 
                             Billing_Rep_First_Name__c, Billing_Rep_Address__c, Billing_Rep_Address_Line_2__c, 
                             Billing_Phone_Type__c, Billing_Phone_Number__c, Billing_Mobile_Phone__c, Postal_Zip_Code__c,
                             Billing_Fax_Number__c, Billing_Email__c, Billing_Country__c, Billing_Company__c, Billing_City__c,Address__c,
                             Subscriber_Contact_Salutation__c,Subscriber_Contact_First_Name__c,Subscriber_Contact_Middle_Name__c,
                             Subscriber_Contact_Name__c,Subscribing_Company__c,Subscriber_Email__c,Secondary_Phone_Type__c,
                             Subscriber_Phone_Type__c,Phone_Number__c,Secondary_Phone__c,Contact_Role__c
                             FROM Activation_Subscriber__c
                             WHERE Id =: strActivationSubscriber]; 
            
            objOnboardAntennaContact.Salutation__c = actsubscriber.Subscriber_Contact_Salutation__c;
            objOnboardAntennaContact.First_Name__c = actsubscriber.Subscriber_Contact_First_Name__c;
            objOnboardAntennaContact.Middle_Name__c = actsubscriber.Subscriber_Contact_Middle_Name__c;
            objOnboardAntennaContact.Last_Name__c = actsubscriber.Subscriber_Contact_Name__c;
            objOnboardAntennaContact.Secondary_Phone__c = actsubscriber.Secondary_Phone__c;
            objOnboardAntennaContact.Secondary_Phone_Type__c = actsubscriber.Secondary_Phone_Type__c;
            objOnboardAntennaContact.Primary_Phone__c = actsubscriber.Phone_Number__c;
            objOnboardAntennaContact.Primary_Phone_Type__c = actsubscriber.Subscriber_Phone_Type__c;
            objOnboardAntennaContact.Email__c = actsubscriber.Subscriber_Email__c;
            objOnboardAntennaContact.Job_Title__c = actsubscriber.Billing_Rep_Job_Title__c;
            objOnboardAntennaContact.Account__c = actsubscriber.Billing_Company__c;
            objOnboardAntennaContact.Job_Function__c = actsubscriber.Billing_Rep_Job_Function__c; 
            objOnboardAntennaContact.State__c = actsubscriber.State_Province__c;
            objOnboardAntennaContact.Country__c = actsubscriber.Country__c;
            objOnboardAntennaContact.Contact_Role__c = actsubscriber.Contact_Role__c;
        }
        return objOnboardAntennaContact;
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   03/06/2016
    * @description          :   readActivationContact Method.
    *                           Load Selected Activation Contact on edit layout And used in component.
    *                           If nothing is selected, new initialization of activation contact.
    * @return               :   Activation_Contact__c, object - selected contact 
    * @invoke               :   From construction
    **/
    public Activation_Contact__c readActivationContact(String strActivationContact){
        objOnboardAntennaContact = New Activation_Contact__c();
        if(strActivationContact!=null){
            objOnboardAntennaContact = [SELECT id,Activation_Order__c,First_Name__c,Salutation__c,Last_Name__c,Middle_Name__c,State__c,
                                        Email__c,Primary_Phone__c,Primary_Phone_Type__c,Job_Function__c,Job_Title__c,Account__c,Country__c,
                                        Secondary_Phone__c, Secondary_Phone_Type__c,Contact_Role__c
                                        FROM Activation_Contact__c  WHERE  id=:strActivationContact];
        }
        return objOnboardAntennaContact;
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   03/06/2016
    * @description          :   loadActivationPlatform Method.
    *                           Update subscriber contact role to based on current tab.
    *                           Upsert contact's contact role to based on current tab.
    * @return               :   pagereference, calling gototab method
    * @invoke               :   From action method of component
    **/
    public pageReference Save(){
       //system.debug('strActivationSubscriber--'+strActivationSubscriber);
       //system.debug('strActivationContact--'+strActivationContact);
       //system.debug('parentContainer--'+parentContainer);
        String strContactRole ='';
        if(parentContainer.containsIgnoreCase('onboardcontact')){
            strContactRole = 'Onboard Contact';
        }else{
            strContactRole = 'System Support Contact';
        }
        if(objOnboardAntennaContact.Contact_Role__c!=null && objOnboardAntennaContact.Contact_Role__c!=''){
            if(!objOnboardAntennaContact.Contact_Role__c.containsIgnoreCase(strContactRole)){
                objOnboardAntennaContact.Contact_Role__c += ', '+strContactRole;
            }
        }else{
           objOnboardAntennaContact.Contact_Role__c = strContactRole;
        }
        if(strActivationSubscriber != null){
            Activation_Subscriber__c objactsubscriber = New Activation_Subscriber__c();
            objactsubscriber.Id = strActivationSubscriber;
            objactsubscriber.Subscriber_Contact_Salutation__c = objOnboardAntennaContact.Salutation__c;
            objactsubscriber.Subscriber_Contact_First_Name__c = objOnboardAntennaContact.First_Name__c;
            objactsubscriber.Subscriber_Contact_Middle_Name__c = objOnboardAntennaContact.Middle_Name__c;
            objactsubscriber.Subscriber_Contact_Name__c = objOnboardAntennaContact.Last_Name__c;
            objactsubscriber.Secondary_Phone__c = objOnboardAntennaContact.Secondary_Phone__c;
            objactsubscriber.Secondary_Phone_Type__c = objOnboardAntennaContact.Secondary_Phone_Type__c;
            objactsubscriber.Phone_Number__c = objOnboardAntennaContact.Primary_Phone__c;
            objactsubscriber.Subscriber_Phone_Type__c = objOnboardAntennaContact.Primary_Phone_Type__c;
            objactsubscriber.Subscriber_Email__c = objOnboardAntennaContact.Email__c;
            objactsubscriber.Billing_Rep_Job_Title__c = objOnboardAntennaContact.Job_Title__c;
            objactsubscriber.Billing_Company__c= objOnboardAntennaContact.Account__c;
            objactsubscriber.Billing_Rep_Job_Function__c= objOnboardAntennaContact.Job_Function__c;
            objactsubscriber.State_Province__c = objOnboardAntennaContact.State__c;
            objactsubscriber.Country__c =  objOnboardAntennaContact.Country__c;
            objactsubscriber.Contact_Role__c = objOnboardAntennaContact.Contact_Role__c;
          //  system.debug('objactsubscriber'+objactsubscriber);
            update objactsubscriber;
        }
        else{
          //  system.debug('objOnboardAntennaContact'+objOnboardAntennaContact);
            if(objOnboardAntennaContact.Activation_Order__c == null)
                objOnboardAntennaContact.Activation_Order__c = ActOrderId;
             upsert objOnboardAntennaContact;
        }
        //return to  Selected Tab
        return gototab();
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   03/06/2016
    * @description          :   goToTab Method.
    *                           To update Activation status and navigate next Or Previous
    *                           tab based on component 'selectedTab' param 
    * @return               :   pageReference
    * @invoke               :   From Save method
    **/
    public pageReference gototab(){
        Activation_Status__c actStatus = [SELECT Account_Setup_Active_Tab__c FROM Activation_Status__c WHERE Activation_Order__c =: ActOrderId];
        actStatus.Installation_Type_Active_Tab__c = selectedTab;
        /*if(selectedTab == 'Antenna_System_Support_Contact'){
         actStatus.Active_Page__c = 'System';               
         actStatus.System_Page__c = 'available';
         actStatus.System_Active_Tab__c = selectedTab;
         actStatus.Account_Setup_Page_FinalTab__c = true;
        // returnPage = page.System;
        }*/
        update actStatus;
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        system.debug(returnPage.getURL());                       //YIKES! That's a problem!
        returnPage.getParameters().clear();                      //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActOrderId);     //add the order ID
        system.debug(returnPage.getURL());                       //much better!
        returnPage.setRedirect(true);                            //this causes the constructors to run again...
        return returnPage;
    }
}