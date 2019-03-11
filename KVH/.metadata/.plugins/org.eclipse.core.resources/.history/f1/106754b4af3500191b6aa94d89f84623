/**
* @createdby        :   
* @createddate      :   
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   06/23/2017
* @description      :   Class Used In Activation_Billing component for updating Activation Subscriber
*                       AND for upserting Activation contacts 
*                       AND for navigating between Tabs.
**/ 
public class Act_Billing_component_controller extends Act_Base_component_controller{
    CountryStateMethods             util        = new CountryStateMethods();      //Helper Class
    
    //BillingInformation Varibles
    public list<SelectOption> CountriesListBillInfo{get;set;} 
    public list<SelectOption>    StatesListBillInfo{get;set;}             
    public string Billto{get;set;}
    public boolean hasMainContactrole {get;set;}
    // public Activation_Contact__c objContact   {get; set;}    //The Activation Contact related to the Order!
    public Activation_Subscriber__c objSubscriber   {get; set;}    //The Activation Subscriber related to the Order!
    public Integer intCountBillRep {get; set;}
    public boolean isSkipValidation {get; set;}
    
    public string selectedTab {get; set;}
    public String parentContainer{get; set;}
    public String strContactRole {get; set;} // TAB relevent Role passed from Page
    private static String strBillingRepresentativeRole = '%Billing Representative%';      // Subscriber Billing Representative Role can be taken from custom labels later
    public Boolean boolBillingSelection {get; set;}
    public Boolean boolBillingSaved {get;set;}
    
    private static String strInvoiceRecipientRole = 'Invoice Recipient'; // Contact InvoiceRecipient Role can be taken from custom labels later
    
    //Used to CopySubscriberAddress
    Public Boolean copySubscriberAddress{get;set;}
    
    //For address Mapping if same as subscriber Address
    List<Activation_Subscriber__c> addressMapping;
    
    /** Constructor - Start **/
    public Act_Billing_component_controller(){
        objSubscriber = New Activation_Subscriber__c();
        CountriesListBillInfo = new list<SelectOption>(); 
        StatesListBillInfo = new list<SelectOption>(); 
        system.debug('Invoking Act_Billing_component_controller Constructor....');
        
        CountryStateMethods util = new CountryStateMethods();
        CountriesListBillInfo = util.setupCountryPicklist();
        StatesListBillInfo = util.setupStatesPicklist();
        
        //strActivationContact = ApexPages.currentPage().getParameters().get('conActID');
        ActOrderId = ApexPages.currentPage().getParameters().get('order');
        list<Activation_Order__c> lstOrder = [Select HasMainContactRole__c,Activation_Type__c from Activation_Order__c where id =: ActOrderId LIMIT 1];
        if(lstOrder.size()>0)hasMainContactrole = lstOrder[0].HasMainContactRole__c || lstOrder[0].Activation_Type__c == 'Airtime Case Activation';
        boolBillingSelection = false;
        for(Activation_Contact__c objActivationContact: 
            [SELECT id,Contact_Role__c,Activation_Order__c,Company_Main_Contact__c
             FROM Activation_Contact__c WHERE  (Activation_Order__c =: ActOrderId AND Contact_Role__c LIKE :strBillingRepresentativeRole) LIMIT 1 ]){
                 boolBillingSelection = true;
             }
        intCountBillRep = [SELECT count() FROM Activation_Contact__c WHERE Activation_Order__c=:ActOrderId AND Contact_Role__c LIKE '%Billing Representative%'];
        addressMapping =  [SELECT Id, Name, Activation_Order__c,Subscriber_Address_Line_2__c,Billing_Rep_Address_Line_2__c ,City__c,Country__c,Billing_City__c,Billing_State_Province__c,Preferred_Addressee__c,Corporate_Billing_Account__c , contact__c,
                           State_Province__c,Postal_Zip_Code__c,Billing_Zip_Code__c ,Address__c,Billing_Rep_Address__c,Billing_Country__c,Billing_Contact_Role__c,Same_as_Company_Address__c,Bill_to__c,Corporate_Billing_Account__r.Bill_to__c
                           FROM  Activation_Subscriber__c 
                           WHERE Activation_Order__c=:ActOrderId];
        
        if(addressMapping.size()>0){
            if(addressMapping[0].Corporate_Billing_Account__c == null && addressMapping[0].contact__c == [SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1][0].ContactId)
              hasMainContactrole = true;  
            Billto=addressMapping[0].Bill_to__c;
            objSubscriber = addressMapping[0].clone(true,true);
        }
        
        componentCountryChangeHandlerBilling();
        list<Activation_Order__c> lstForSkipValidation = [SELECT Id,Activation_Type__c FROM Activation_Order__c WHERE id =: ActOrderId and Activation_Type__c = 'Activation on behalf of Customer' and CreatedById =: UserInfo.getUserId()];
        if(lstForSkipValidation.size() > 0)
            isSkipValidation = true;
    }
    /** Constructor - End **/
    
    public void componentCountryChangeHandlerBilling(){
        StatesListBillInfo = util.CountryChangeHandler(objSubscriber.Billing_Country__c, objSubscriber.Billing_State_Province__c);
    }
    
    public void componentStateChangeHandlerBilling(){
        system.debug('Invoking State Change handler....');
    }
    
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   11/06/2016
* @description          :   callDisableFunction Method.
*                           Load appropriate record data based on copySubscriberAddress checkbox value.
* @return               :   void
* @invoke               :   From action method of Activation_Billinng component
**/
    Public void callDisableFunction(){
        system.debug('copySubscriberAddress'+copySubscriberAddress);
        if(objSubscriber.Same_as_Company_Address__c){
            mapAddressMapping();
        }else{
           // objSubscriber = addressMapping[0].clone(true,true);
           // StatesListBillInfo = util.CountryChangeHandler(objSubscriber.Billing_Country__c, objSubscriber.Billing_State_Province__c);
        } 
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   11/06/2016
* @description          :   Save Method.
*                           Update subscriber to based on current tab.
* @return               :   pagereference, calling gototab method
* @invoke               :   From action method of component
**/
    public pageReference Save(){
        if(objSubscriber.id==null && addressMapping.size()>0){
            objSubscriber.id = addressMapping[0].id;
            objSubscriber.Billing_Contact_Role__c = addressMapping[0].Billing_Contact_Role__c;
        }
        if(objSubscriber.Same_as_Company_Address__c){
            mapAddressMapping();
        }
        system.debug('objSubscriber'+objSubscriber);
        if((objSubscriber.Billing_Contact_Role__c!=null && objSubscriber.Billing_Contact_Role__c!='') && !objSubscriber.Billing_Contact_Role__c.containsIgnoreCase(strContactRole)){
            objSubscriber.Billing_Contact_Role__c += ', '+strContactRole;
        }
        if(objSubscriber.Billing_Contact_Role__c==null || objSubscriber.Billing_Contact_Role__c==''){
            objSubscriber.Billing_Contact_Role__c = strContactRole+', '+strInvoiceRecipientRole;
        }
        if(objSubscriber.Billing_Country__c != null){
            list<KVH_Countries__mdt> ObjCountries = [SELECT Id, TrimmedName__c, IsoCode_2__c, IsoCode_3__c FROM KVH_Countries__mdt where IsoCode_2__c=:objSubscriber.Billing_Country__c limit 1];
            if(ObjCountries.size()>0)objSubscriber.Billing_Country_Name__c = ObjCountries[0].TrimmedName__c;
        }
        
        update objSubscriber;
        
        //return to  Selected Tab
        return gototab();
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   07/09/2016
* @description          :   goToTab Method.
*                           To update Activation status and navigate next Or Previous
*                           tab based on component 'selectedTab' param 
* @return               :   pageReference
* @invoke               :   From Save method
**/
    public pageReference gototab(){
        pageReference returnPage = ApexPages.currentPage(); //unfortunately, this returns the whole view state!
        if(selectedTab == 'Installation_Type'){
            actStatus.Active_Page__c = 'Installation Type';              //set Active Page 
            actStatus.Installation_Type_Page__c = 'available';
            actStatus.Installation_Type_Active_Tab__c = selectedTab;
            returnPage = page.Installation_Type;      //unfortunately, this returns the whole view state!
        }else{
            actStatus.Account_Setup_Active_Tab__c = selectedTab;
        }
        update actStatus;
        
        system.debug(returnPage.getURL());                       //YIKES! That's a problem!
        returnPage.getParameters().clear();                      //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActOrderId);     //add the order ID
        system.debug(returnPage.getURL());                       //much better!
        returnPage.setRedirect(true);                            //this causes the constructors to run again...
        return returnPage;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   11/06/2016
* @description          :   mapAddressMapping Method.
*                           Load appropriate record data to the component.
* @return               :   void
* @invoke               :   From callDisableFunction method and Save method
**/
    @testvisible
    private void mapAddressMapping(){
        if(addressMapping.size()>0){
			objSubscriber.Preferred_Addressee__c = '';          
            objSubscriber.Billing_Rep_Address__c = addressMapping[0].Address__c;
            objSubscriber.Billing_Rep_Address_Line_2__c = addressMapping[0].Subscriber_Address_Line_2__c;
            objSubscriber.Billing_City__c = addressMapping[0].City__c;
            objSubscriber.Billing_State_Province__c = addressMapping[0].State_Province__c;
            objSubscriber.Billing_Country__c = addressMapping[0].Country__c;
            objSubscriber.Billing_Zip_Code__c = addressMapping[0].Postal_Zip_Code__c;
            StatesListBillInfo = util.CountryChangeHandler(objSubscriber.Billing_Country__c, objSubscriber.Billing_State_Province__c);
        }
    }  
    public pageReference saveandExit(){
        
        if(objSubscriber.id==null && addressMapping.size()>0){
            objSubscriber.id = addressMapping[0].id;
            objSubscriber.Billing_Contact_Role__c = addressMapping[0].Billing_Contact_Role__c;
        }
        if(objSubscriber.Same_as_Company_Address__c){
            mapAddressMapping();
        }
        system.debug('objSubscriber'+objSubscriber);
        if((objSubscriber.Billing_Contact_Role__c!=null && objSubscriber.Billing_Contact_Role__c!='') && !objSubscriber.Billing_Contact_Role__c.containsIgnoreCase(strContactRole)){
            objSubscriber.Billing_Contact_Role__c += ', '+strContactRole;
        }
        if(objSubscriber.Billing_Contact_Role__c==null || objSubscriber.Billing_Contact_Role__c==''){
            objSubscriber.Billing_Contact_Role__c = strContactRole+', '+strInvoiceRecipientRole;
        }
        if(objSubscriber.Billing_Country__c != null){
            list<KVH_Countries__mdt> ObjCountries = [SELECT Id, TrimmedName__c, IsoCode_2__c, IsoCode_3__c FROM KVH_Countries__mdt where IsoCode_2__c=:objSubscriber.Billing_Country__c limit 1];
            if(ObjCountries.size()>0)objSubscriber.Billing_Country_Name__c = ObjCountries[0].TrimmedName__c;
        }
        update objSubscriber;
        boolBillingSaved = true;
        return null;
    }
}