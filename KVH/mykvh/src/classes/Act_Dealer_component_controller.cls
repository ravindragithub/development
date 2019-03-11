public class Act_Dealer_component_controller extends Act_Base_component_controller{
    CountryStateMethods             util        = new CountryStateMethods();      //Helper Class
    
    //Dealer Varibles
    public list<SelectOption> CountriesListBillInfo{get;set;} 
    public list<SelectOption>    StatesListBillInfo{get;set;} 
    
    public Activation_Dealer__c Dealer {get;set;}                   //The Activation Dealer related to the Order! 
    public String selectedTab {get; set;}
    public String parentContainer {get;set;} //Getting current component Id from VF Page
    public Activation_Order__c ActOrd{get;set;}
    public boolean isMainContact {get;set;}
    //Constructor
    public Act_Dealer_component_controller(){
        ActOrderId = ApexPages.currentPage().getParameters().get('order');
        ActOrd = [select id, Don_t_have_Dealer__c,Activation_Type__c,CreatedById,Main_Contact__c from Activation_Order__c where id=:ActOrderId];
        isMainContact = ActOrd.Main_Contact__c == [Select ContactId From User Where Id = :UserInfo.getUserId()][0].ContactId && ActOrd.Activation_Type__c == 'Activation on behalf of Customer' ;
        Dealer = new Activation_Dealer__c();
        Dealer = readActivationDealer();
        CountriesListBillInfo = new list<SelectOption>(); 
        StatesListBillInfo = new list<SelectOption>(); 
        CountryStateMethods util = new CountryStateMethods();
        CountriesListBillInfo = util.setupCountryPicklist();
        StatesListBillInfo = util.setupStatesPicklist();
        componentCountryChangeHandlerBilling();
    }
    
    public void componentCountryChangeHandlerBilling(){
        StatesListBillInfo = util.CountryChangeHandler(Dealer.Country__c, Dealer.State__c);
    }
    
    public void componentStateChangeHandlerBilling(){
        system.debug('Invoking State Change handler....');
    }
    public Activation_Dealer__c readActivationDealer(){
        list<Activation_Dealer__c> returnDealer = new list<Activation_Dealer__c>();
        returnDealer = [SELECT Primary_Phone_Type__c,Dealer_Phone__c, 
                        Id, Contact_Email__c, Contact_First_Name__c, Contact_Last_Name__c,
                        Contact_Phone__c, Contact_Salutation__c, Phone_Type__c,
                        Company__c, Activation_Order__c ,Country__c, State__c,Dealer_Distributor_Company__c
                        FROM Activation_Dealer__c 
                        WHERE Activation_Order__c =: ActOrderId ];
        //TODO what if we have more than one return?!?!
        if(returnDealer.size() == 0){                   //Nothing in database....
            Dealer.Activation_Order__c = ActOrderId;    //SO, Use Constructor object...
            
            list<Contact> lstContact = [Select Id, Salutation, FirstName, LastName, Phone, Email, Account.BillingState, Account.BillingCountry, Account.Name, Account.Phone,  AccountId From Contact
                       					Where Id In (Select ContactId From User Where Id = : ActOrd.CreatedById) ];
                if(lstContact.size() > 0 && ActOrd.Activation_Type__c == 'Activation on behalf of Customer' ){
                Dealer.Company__c = lstContact[0].Account.Name;
                Dealer.Phone_Type__c = 'Business';
                Dealer.Dealer_Phone__c = lstContact[0].Account.Phone;
                Dealer.Dealer_Distributor_Company__c = lstContact[0].AccountId;
                Dealer.Contact_Salutation__c = lstContact[0].Salutation;
                Dealer.Contact_First_Name__c = lstContact[0].FirstName;
                Dealer.Contact_Last_Name__c = lstContact[0].LastName;
                Dealer.Contact_Email__c = lstContact[0].Email;
                Dealer.Primary_Phone_Type__c = 'Business';
                Dealer.Contact_Phone__c = lstContact[0].Phone;
                list<KVH_Countries__mdt> ObjCountries = [SELECT Id, TrimmedName__c, IsoCode_2__c, IsoCode_3__c FROM KVH_Countries__mdt where TrimmedName__c=:lstContact[0].Account.BillingCountry limit 1];
            	Dealer.Country__c = ObjCountries.size()>0 ? ObjCountries[0].IsoCode_2__c : lstContact[0].Account.BillingCountry;
                list<KVH_States__mdt> ObjStates = [SELECT MasterLabel, TrimmedName__c FROM KVH_States__mdt WHERE IsoCode__c =: lstContact[0].Account.BillingState AND countryIsoCode_2__c =:Dealer.Country__c limit 1];
                Dealer.State__c =ObjStates.size()>0 ? ObjStates[0].TrimmedName__c :lstContact[0].Account.BillingState ;
                }
            returnDealer.add(Dealer);                   //add it back to the list...
        }
        return returnDealer[0];                         //and return the list!
    }
    
    public pageReference Save(){
        //Validate here!
        if(!ActOrd.Don_t_have_Dealer__c){
            upsert Dealer;
        }
        update ActOrd;
        // return to Selected Tab
        return gototab();
    }
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
    // Pagereference to Next Or Previous Tab
    public pageReference Back(){
        actStatus.Account_Setup_Active_Tab__c = selectedTab;
        update actStatus;
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        system.debug(returnPage.getURL());                       //YIKES! That's a problem!
        returnPage.getParameters().clear();                      //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActOrderId);     //add the order ID
        system.debug(returnPage.getURL());                       //much better!
        returnPage.setRedirect(true);                            //this causes the constructors to run again...
        return returnPage;
    } 
     public pageReference SaveSaveAndExit(){
        if(!ActOrd.Don_t_have_Dealer__c){
            upsert Dealer;
        }
         update ActOrd;
         return null;
    }
    @RemoteAction
    public static List<Account> getAccountData(String param){
        param = String.escapeSingleQuotes(param);
        return Database.query('Select Name, BillingCity, BillingState, BillingCountry, Phone, Id from Account where (RecordType.Name = \'Direct Partner\' OR RecordType.Name = \'Indirect Partner\') and name LIKE \'%'+param+'%\' LIMIT 10000');
    }
}