public class Activation_Corporate_Company extends Act_Base_component_controller{
    CountryStateMethods util = New CountryStateMethods();       //Helper Class
    public Activation_Subscriber__c newSubscriber;  //{get;set;}                    //The Activation Subscriber related to the Order! 
    public list<SelectOption> CountriesList = New list<SelectOption>();                     //List of Country Names for Subscriber Picklist
    public list<SelectOption> StatesList = New list<SelectOption>();                            //List of State Names for Subscriber Picklist
    public string selectedTab       {get;set;}
    public String parentContainer {get;set;} //Getting current component Id from VF Page
    public Static Boolean onlyActivationSubuscriber = true;
    Public ID corporateRTID;
        private static String strAuthorizedRepRole = 'Main Contact,Billing Representative';      // Contact Authorized Rep Role can be taken from custom labels later

    //Constructor
    public Activation_Corporate_Company(){
        CountriesList = util.setupCountryPicklist();
        StatesList = util.setupStatesPicklist();
        corporateRTID = Schema.SObjectType.Activation_Subscriber__c.RecordTypeInfosByName.get('Corporate').RecordTypeId;
    }
    
    //Getters and Setters
    public list<SelectOption> getCountriesList(){
        return CountriesList;
    }
    public list<SelectOption> getStatesList(){
        return StatesList;
    }
    
    public void componentCountryChangeHandler(){
        StatesList = util.CountryChangeHandler(newSubscriber.Country__c, newSubscriber.State_Province__c);
    }
    public void componentStateChangeHandler(){
        system.debug('Invoking State Change handler....');
    }
    
    public Activation_Subscriber__c getnewSubscriber(){     //reads subscriber details from the database
        system.debug('Invoking getnewSubscriber with Activation Order: ' + ActOrderId);     //handle a postback
        if(newSubscriber == null){
            system.debug('null test for new subscriber positive.....');
            list<Activation_Subscriber__c> act_subs = [SELECT 
                                                       Subscribing_Company__c,
                                                       Subscriber_Phone_Type__c,
                                                       Subscriber_Email__c,
                                                       Subscriber_Contact_Salutation__c,
                                                       Subscriber_Contact_Name__c,
                                                       Subscriber_Contact_First_Name__c,
                                                       Subscriber_Address_Line_2__c,
                                                       State_Province__c,
                                                       Secondary_Phone__c,
                                                       Secondary_Phone_Type__c,
                                                       Postal_Zip_Code__c,
                                                       Phone_Number__c,
                                                       Name,
                                                       Id,
                                                       Country__c,
                                                       City__c,
                                                       Address__c,
                                                       Contact_Role__c,
                                                       Activation_Order__c,
                                                       Billing_Rep_Job_Title__c,
                                                       Billing_Rep_Job_Function__c,
                                                       Parent_Account_ID__c,
                                                       Parent_Account_Custom_Call_Account_ID__c,
                                                       Market__c,
                                                       Market_Sector__c,
                                                       Website__c
                                                       FROM Activation_Subscriber__c
                                                       WHERE Activation_Order__c =: ActOrderId AND RecordTypeID=:corporateRTID];
            //system.debug(act_subs.size());
            if(act_subs.size() == 0){
                system.debug(act_subs.size() + ' Subscribers found, creating a new one!');
                newSubscriber = new Activation_Subscriber__c(Activation_Order__c = ActOrderId);//create a new subscriber
            } else {
                system.debug(act_subs.size() + ' Subscribers found, using existing record');
                newSubscriber = act_subs[0];
                componentCountryChangeHandler();
            }
        }
        system.debug('newSubscriber: ' + newSubscriber);
        return newSubscriber;
    }
    @testVisible private void setnewSubscriber(){                       
        system.debug('Invoking setnewSubscriber');
        save();
        //upsert newSubscriber;
    }
    
    public PageReference Save(){
        system.debug('selectedTab'+selectedTab);
        //setup to save Activation Contact and reload page.....
        system.debug(newSubscriber);
        if(newSubscriber.Activation_Order__c == null){
            newSubscriber.Activation_Order__c = ActOrderId;
        }
        String CorporateAccountId = ApexPages.currentPage().getParameters().get('CorporateAccountId');
        String CorporateAccountCCId = ApexPages.currentPage().getParameters().get('CorporateAccountCCId');
        
        if(CorporateAccountId != null && CorporateAccountId != ''){
            newSubscriber.Parent_Account_ID__c = CorporateAccountId;
            newSubscriber.Parent_Account_Custom_Call_Account_ID__c = CorporateAccountCCId;
        }
        if(newSubscriber.Contact_Role__c == null){
            newSubscriber.Contact_Role__c = 'Corporate Account'; 
        }
        newSubscriber.RecordTypeID = corporateRTID;
        onlyActivationSubuscriber = false;
        upsert newSubscriber;
        createFirstAuthorizedRepContact();
        //setup to save Activation Subscriber and reload page.....
        PageReference reference = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        system.debug(reference.getURL());                       //YIKES! That's a problem!
        reference.getParameters().clear();                      //BUT! we can just clear that stuff out...
        reference.getParameters().put('order', ActOrderId);     //add the order ID
        system.debug(reference.getURL());                       //much better!
        reference.setRedirect(true);                            //this causes the constructors to run again...
        
        actStatus.Account_Setup_Active_Tab__c = selectedTab;    //Handle updates to Activation Status....
        //if(selectedTab == 'Invoicing_Preferences'){
        //   actStatus.Account_Setup_Page_FinalTab__c = true;
        //}
        update actStatus;
        return reference;
    }
    
    public void createFirstAuthorizedRepContact(){
        String mainContactId = ApexPages.currentPage().getParameters().get('mainContactId');
        List<Activation_Contact__c> lstActivationContacts = New List<Activation_Contact__c>();
        lstActivationContacts = [SELECT id,Activation_Order__c,First_Name__c,Salutation__c,Last_Name__c,State__c,
                                 Email__c,Primary_Phone__c,Primary_Phone_Type__c,Job_Function__c,Job_Title__c,Account__c,Country__c,
                                 Secondary_Phone__c, Secondary_Phone_Type__c,Contact_Role__c
                                 FROM Activation_Contact__c  WHERE Activation_Order__c =: ActOrderId AND Contact_Role__c LIKE '%Authorized Representative%'];
        
        if(lstActivationContacts.size() == 0 && mainContactId != null && mainContactId != ''){
            Activation_Contact__c objActivationContact = New Activation_Contact__c();
            for(Contact objContact : [SELECT Id, Salutation, Phone, MobilePhone, Name, Email, FirstName, LastName FROM contact WHERE Id =: mainContactId]){
                objActivationContact.Salutation__c = objContact.Salutation;
                objActivationContact.First_Name__c = objContact.FirstName;
                objActivationContact.Last_Name__c = objContact.LastName;
                objActivationContact.Email__c = objContact.Email;
                objActivationContact.Primary_Phone_Type__c = 'Business';
                objActivationContact.Primary_Phone__c = objContact.Phone;
                objActivationContact.Secondary_Phone_Type__c = 'Mobile';
                objActivationContact.Secondary_Phone__c = objContact.MobilePhone;
                objActivationContact.Contact_Role__c = strAuthorizedRepRole;
                objActivationContact.Activation_Order__c = ActOrderId;
                insert objActivationContact;
            }
        }
    }
    
    public PageReference saveandExit(){
       system.debug('selectedTab'+selectedTab);
        //setup to save Activation Contact and reload page.....
        system.debug(newSubscriber);
        if(newSubscriber.Activation_Order__c == null){
            newSubscriber.Activation_Order__c = ActOrderId;
        }
        String CorporateAccountId = ApexPages.currentPage().getParameters().get('CorporateAccountId');
        String CorporateAccountCCId = ApexPages.currentPage().getParameters().get('CorporateAccountCCId');
        
        if(CorporateAccountId != null && CorporateAccountId != ''){
            newSubscriber.Parent_Account_ID__c = CorporateAccountId;
            newSubscriber.Parent_Account_Custom_Call_Account_ID__c = CorporateAccountCCId;
        }
        if(newSubscriber.Contact_Role__c == null){
            newSubscriber.Contact_Role__c = 'Corporate Account'; 
        }
        newSubscriber.RecordTypeID = corporateRTID;
        onlyActivationSubuscriber = false;
        upsert newSubscriber;
        createFirstAuthorizedRepContact();
         return null;
    }
    
}