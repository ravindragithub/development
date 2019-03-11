/**
* @createdby        :   
* @createddate      :   
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   /06/2016
* @description      :   Class Used In Activation_Contact for upserting Activation Contacts
*                       AND Activation_Onboard_Contact for Activation platform fields 
*                       update AND for navigating between Tabs.
**/ 

public Class Act_Contact_Component_Controller extends Act_Base_component_controller{
    
    public Activation_Contact__c actCon{get;set;}       //The ONE Activation Contact that we are creating/editing
    CountryStateMethods   objCountryStateMethods        = new CountryStateMethods(); //Helper Class to load Country ans relevent State
    
    //Contact Varibles
    public list<SelectOption> CountriesList = new list<SelectOption>();      
    public list<SelectOption> StatesList = new list<SelectOption>();
    public string selectedTab {get; set;}
    public String parentContainer{get; set;}
    public String strContactRole {get; set;}
    public boolean isSkipValidation {get; set;}
    
    private static String strInvoicingPreferencesTab = 'Invoicing_Preferences';
	private static String strBillingInformationTab = 'Billing_Information';
    private static String strInvoiceRecipientRole = 'Invoice Recipient'; // Contact InvoiceRecipient Role can be taken from custom labels later
    private static String strGroupRole = 'Group Invoice Recipient';                       // Contact Group Email Role can be taken from custom labels later
    private static String strAuthorizedRepRole = 'Authorized Representative';      // Contact Authorized Rep Role can be taken from custom labels later
    
    //URL Variables
    Public String strActivationContact{get; set;}
    
     /** Constructor - Start **/
    public Act_Contact_component_controller (){
        System.Debug('Parent Component Container-->'+parentContainer);
        actCon = New Activation_Contact__c();
        CountryStateMethods objCountryStateMethods = new CountryStateMethods();
        CountriesList = objCountryStateMethods.setupCountryPicklist();
        StatesList = objCountryStateMethods.setupStatesPicklist();
        strActivationContact = ApexPages.currentPage().getParameters().get('conActID');
        ActOrderId = ApexPages.currentPage().getParameters().get('order');
        actCon = (strActivationContact !=null && strActivationContact != '') ? readActivationContact(strActivationContact) : New Activation_Contact__c();
        componentCountryChangeHandler();
        list<Activation_Order__c> lstForSkipValidation = [SELECT Id,Activation_Type__c FROM Activation_Order__c WHERE id =: ActOrderId and Activation_Type__c = 'Activation on behalf of Customer' and CreatedById =: UserInfo.getUserId()];
        if(lstForSkipValidation.size() > 0)
            isSkipValidation = true;
    }
    /** Constructor - End **/
    //Getters and Setters
    public list<SelectOption> getCountriesList(){
        list<SelectOption> Options = new list<SelectOption>();
        for(SelectOption SOption:CountriesList)Options.add(new SelectOption(SOption.getLabel() ,SOption.getLabel()));
        return Options;
    }
    
    public list<SelectOption> getStatesList(){
        return StatesList;
    }
    
    public void componentCountryChangeHandler(){
        string strCountry = '';
        for(SelectOption SOption:CountriesList){
            if(SOption.getLabel() == actCon.Country__c)strCountry = SOption.getValue();
        }
        StatesList = objCountryStateMethods.CountryChangeHandler(strCountry, actCon.State__c);
    }
    
    public void componentStateChangeHandler(){
        system.debug('Invoking State Change handler....');
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
        actCon = New Activation_Contact__c();
        if(strActivationContact!=null && strActivationContact !=''){
            actCon = [SELECT id,Activation_Order__c,First_Name__c,Salutation__c,Last_Name__c,State__c,Address_1__c,Address_2__c,City__c,Postal_Zip_Code__c,
                                        Email__c,Primary_Phone__c,Primary_Phone_Type__c,Job_Function__c,Job_Title__c,Account__c,Country__c,
                                        Secondary_Phone__c, Secondary_Phone_Type__c,Contact_Role__c,Contact__c
                                        FROM Activation_Contact__c  WHERE  id=:strActivationContact];
        }
        return actCon;
    }
    
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   03/06/2016
    * @description          :   SaveFromAccountSetup Method.
    *                           Upsert contact's contact role to based on current tab.
    * @return               :   pagereference, calling gototab method
    * @invoke               :   From action method of Activation_contact component
    **/
    public pageReference SaveFromAccountSetup(){
        system.debug('parentContainer--'+parentContainer);
        system.debug(actCon);
        if(actCon.Activation_Order__c == null){ 
            actCon.Activation_Order__c = ActOrderId; 
        }
        // Checking if role is Group OR Current tab is Invoice
        String strRole = ApexPages.currentPage().getParameters().get('Role');
        actStatus = [SELECT Account_Setup_Active_Tab__c FROM Activation_Status__c WHERE Activation_Order__c =: ActOrderId];
        
        if(strRole == 'Group' || (actStatus != null && (actStatus.Account_Setup_Active_Tab__c == strInvoicingPreferencesTab || actStatus.Account_Setup_Active_Tab__c == strBillingInformationTab))){
            if(actCon.Contact_Role__c == '' || actCon.Contact_Role__c == null){  
                actCon.Contact_Role__c = strGroupRole;//+', '+strInvoiceRecipientRole;
            }else{ 
                if(!actCon.Contact_Role__c.containsIgnoreCase(strGroupRole)){
                    String strTempRole = actCon.Contact_Role__c.trim().removeEnd(',');
                    actCon.Contact_Role__c = strGroupRole; //strTempRole + ', '+ ;
                }
               /* if(!actCon.Contact_Role__c.containsIgnoreCase(strInvoiceRecipientRole)){
                    String strTempRole = actCon.Contact_Role__c.trim().removeEnd(',');
                    actCon.Contact_Role__c = strTempRole + ', '+ strInvoiceRecipientRole;
                }*/
            }
        }
       /* else if(strRole == 'Individual' || actStatus.Account_Setup_Active_Tab__c == 'Invoicing_Preferences'){
                 if(actCon.Contact_Role__c == null){
                    actCon.Contact_Role__c = strInvoiceRecipientRole;
            }else if(!actCon.Contact_Role__c.containsIgnoreCase(strInvoiceRecipientRole)){
                    String strTempRole = actCon.Contact_Role__c.trim().removeEnd(',');
                    actCon.Contact_Role__c = strTempRole + ','+ strInvoiceRecipientRole';
            }
        }*/
        else if(actCon.Contact_Role__c == null){
            actCon.Contact_Role__c = strAuthorizedRepRole +', '+strInvoiceRecipientRole;
        }
        else if(!actCon.Contact_Role__c.containsIgnoreCase(strAuthorizedRepRole) && actStatus.Account_Setup_Active_Tab__c =='Authorized_Representatives'){
            actCon.Contact_Role__c = actCon.Contact_Role__c+', '+strAuthorizedRepRole;
        }
        system.debug('actCon'+actCon);
        upsert actCon;
        //setup to save Activation Contact and reload page.....
        PageReference reference = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        system.debug(reference.getURL());                       //YIKES! That's a problem!
        reference.getParameters().clear();                      //BUT! we can just clear that stuff out...
        reference.getParameters().put('order', ActOrderId);     //add the order ID
        system.debug(reference.getURL());                       //much better!
        reference.setRedirect(true);                            //this causes the constructors to run again...
        return reference;
    }
    
    /**
    * @last modified by     :   Koka Gopi
    * @last modified date   :   22/08/2016
    * @description          :   SaveFromCorporateSetup Method.
    *                           Upsert contact's contact role to based on current tab.
    * @return               :   pagereference, calling gototab method
    * @invoke               :   From action method of Activation_contact component
    **/
    public pageReference SaveFromCorporateSetup(){
        system.debug('parentContainer--'+parentContainer);
        system.debug(actCon);
        if(actCon.Activation_Order__c == null){ 
            actCon.Activation_Order__c = ActOrderId; 
        }
        // Checking if role is Group OR Current tab is Invoice
        String strRole = ApexPages.currentPage().getParameters().get('Role');
        actStatus = [SELECT Account_Setup_Active_Tab__c FROM Activation_Status__c WHERE Activation_Order__c =: ActOrderId];
       // actCon.Contact_Role__c = strAuthorizedRepRole;
         /*if(strRole == 'Group' || (actStatus != null && actStatus.Account_Setup_Active_Tab__c == strInvoicingPreferencesTab)){
            if(actCon.Contact_Role__c == '' || actCon.Contact_Role__c == null){  
                //+', '+strInvoiceRecipientRole;
            }
        }
       else if(strRole == 'Individual' || actStatus.Account_Setup_Active_Tab__c == 'Invoicing_Preferences'){
                 if(actCon.Contact_Role__c == null){
                    actCon.Contact_Role__c = strInvoiceRecipientRole;
            }else if(!actCon.Contact_Role__c.containsIgnoreCase(strInvoiceRecipientRole)){
                    String strTempRole = actCon.Contact_Role__c.trim().removeEnd(',');
                    actCon.Contact_Role__c = strTempRole + ','+ strInvoiceRecipientRole';
            }
        }*/
        if(actCon.Contact_Role__c == null){
            actCon.Contact_Role__c = strAuthorizedRepRole ;//+', '+strInvoiceRecipientRole;
        }
        system.debug('actCon'+actCon);
        upsert actCon;
        //setup to save Activation Contact and reload page.....
        PageReference reference = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        system.debug(reference.getURL());                       //YIKES! That's a problem!
        reference.getParameters().clear();                      //BUT! we can just clear that stuff out...
        reference.getParameters().put('order', ActOrderId);     //add the order ID
        system.debug(reference.getURL());                       //much better!
        reference.setRedirect(true);                            //this causes the constructors to run again...
        return reference;
    }
    
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   08/06/2016
    * @description          :   SaveFromInstallationType Method. |USED IN Invoice_preferences TAB also|
    *                           Update subscriber contact role to based on current tab.
    *                           Upsert contact's contact role to based on current tab.
    * @return               :   pagereference, calling gototab method
    * @invoke               :   From action method of component
    **/
    public pageReference SaveFromInstallationType(){
        system.debug(actCon);
       //system.debug('strActivationSubscriber--'+strActivationSubscriber);
       //system.debug('strActivationContact--'+strActivationContact);
       system.debug('parentContainer--'+parentContainer);
        if(actCon.Contact_Role__c!=null && actCon.Contact_Role__c!=''){
            if(!actCon.Contact_Role__c.containsIgnoreCase(strContactRole)){
                actCon.Contact_Role__c += ', '+strContactRole;
            }
        }else{
           actCon.Contact_Role__c = strContactRole;
        }
        
        if(actCon.Activation_Order__c == null)
            actCon.Activation_Order__c = ActOrderId;
        upsert actCon;
        //return to  Selected Tab
        return gototab();
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   08/06/2016
    * @description          :   goToTab Method.
    *                           To update Activation status and navigate next Or Previous
    *                           tab based on component 'selectedTab' param 
    * @return               :   pageReference
    * @invoke               :   From SaveFromInstallationType method
    **/
    public pageReference gototab(){
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        if(selectedTab == 'System_Type'){
            actStatus.Active_Page__c = 'System';               
            actStatus.System_Page__c ='available'; 
            actStatus.System_Active_Tab__c = selectedTab;
            returnPage = page.ActivationSystemInfo;
        }else{
           actStatus.Installation_Type_Active_Tab__c = selectedTab; 
        }
        update actStatus;
        //system.debug(returnPage.getURL());                       //YIKES! That's a problem!
        returnPage.getParameters().clear();                      //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActOrderId);     //add the order ID
        returnPage.setRedirect(true);                            //this causes the constructors to run again...
        return returnPage;
    }
    
     /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   08/06/2016
    * @description          :   gotospecifictab Method.
    *                           To update Activation status and navigate next Or Previous
    *                           tab based on component 'selectedTab' param 
    * @return               :   pageReference
    * @invoke               :   From VF Page
    **/
    public pageReference gotospecifictab(){
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        returnPage.getParameters().clear();                      //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActOrderId);     //add the order ID
        returnPage.setRedirect(true);                            //this causes the constructors to run again...
        return returnPage;
    }
    public void SaveFromAccountSetupSaveAndExit(){
        if(actCon.Activation_Order__c == null){ 
            actCon.Activation_Order__c = ActOrderId; 
        }
        String strRole = ApexPages.currentPage().getParameters().get('Role');
        actStatus = [SELECT Account_Setup_Active_Tab__c FROM Activation_Status__c WHERE Activation_Order__c =: ActOrderId];
        
        if(strRole == 'Group' || (actStatus != null && (actStatus.Account_Setup_Active_Tab__c == strInvoicingPreferencesTab || actStatus.Account_Setup_Active_Tab__c == strBillingInformationTab))){
            if(actCon.Contact_Role__c == '' || actCon.Contact_Role__c == null){  
                actCon.Contact_Role__c = strGroupRole;//+', '+strInvoiceRecipientRole;
            }else{ 
                if(!actCon.Contact_Role__c.containsIgnoreCase(strGroupRole)){
                    String strTempRole = actCon.Contact_Role__c.trim().removeEnd(',');
                    actCon.Contact_Role__c = strGroupRole; //strTempRole + ', '+ ;
                }
               /* if(!actCon.Contact_Role__c.containsIgnoreCase(strInvoiceRecipientRole)){
                    String strTempRole = actCon.Contact_Role__c.trim().removeEnd(',');
                    actCon.Contact_Role__c = strTempRole + ', '+ strInvoiceRecipientRole;
                }*/
            }
        }
       /* else if(strRole == 'Individual' || actStatus.Account_Setup_Active_Tab__c == 'Invoicing_Preferences'){
                 if(actCon.Contact_Role__c == null){
                    actCon.Contact_Role__c = strInvoiceRecipientRole;
            }else if(!actCon.Contact_Role__c.containsIgnoreCase(strInvoiceRecipientRole)){
                    String strTempRole = actCon.Contact_Role__c.trim().removeEnd(',');
                    actCon.Contact_Role__c = strTempRole + ','+ strInvoiceRecipientRole';
            }
        }*/
        else if(actCon.Contact_Role__c == null){
            actCon.Contact_Role__c = strAuthorizedRepRole +', '+strInvoiceRecipientRole;
        }
        system.debug('actCon'+actCon);
        upsert actCon;
        
    }
    
   
    
    public pageReference SaveFromInstallationTypeSaveAndExit(){
       
       system.debug('parentContainer--'+parentContainer);
        if(actCon.Contact_Role__c!=null && actCon.Contact_Role__c!=''){
            if(!actCon.Contact_Role__c.containsIgnoreCase(strContactRole)){
                actCon.Contact_Role__c += ', '+strContactRole;
            }
        }else{
           actCon.Contact_Role__c = strContactRole;
        }
        
        if(actCon.Activation_Order__c == null)
            actCon.Activation_Order__c = ActOrderId;
        upsert actCon;
        return null;

    }
    

}