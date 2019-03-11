/**
    * @createdby        :
    * @createddate      :
    * @last modifiedby  :   Teertha prasad
    * @last modifieddate:   03/28/2017
    * @description      :   Class Used In Installation_Type Page for Activation platform Creation 
    *                       update and for navigating between tabs.
    **/ 

public with sharing class InstallationTypeController extends ActivationsBaseController{
    
    //Page attributes
    public string selectedTab {get;set;}
    public string selectedMarketType {get;set;}
    public string havingIMO {get;set;}
    public string Prevtab {get;set;}
    public boolean isSkipValidation {get; set;}
    public Activation_Platform__c objActivationPlatform  {get;set;}
    public Activation_Order__c objActivationOrder  {get;set;}
     List<Activation_Subscriber__c> Actsub;
   // public Activation_Platform__c objActivationPlatformIMO     {get;set;} // needed to map IMO tab values since it was override by
                                                                        // other last tab same field value!!
    
    private map<String, list<String>> mapMarketANDSector; // Instead of this we can use Custom Setting
    
    private static String strAntennaSystemSupportTab = 'Antenna_System_Support_Contact';
    private static String strSystemSupportContactRole = 'System Support Contact';
    private static String strOnboardContactTab = 'Onboard_Contact';
    private static String strOnboardContactRole = 'Onboard Contact';
    
    //TAB Index variable can be get from custom settings
    public Map<String,Integer> mapdisableInstallationTypeTabs {
        get { mapdisableInstallationTypeTabs = New Map<String,Integer>();
             mapdisableInstallationTypeTabs.put('Installation_Type',1);
             mapdisableInstallationTypeTabs.put('IMO_Number',2);
             mapdisableInstallationTypeTabs.put('Vessel_Details',3);
             mapdisableInstallationTypeTabs.put('Onboard_Contact',4);
             mapdisableInstallationTypeTabs.put('Antenna_System_Support_Contact',5);
             mapdisableInstallationTypeTabs.put('Dealer_Distributor_Info',6);
             return mapdisableInstallationTypeTabs; 
            }
        private set; 
    }
    
    CountryStateMethods util = New CountryStateMethods(); //Helper Class
    public list<SelectOption> CountriesList = New list<SelectOption>();  //List of Country Names for Subscriber Picklist
    
    
    /** Constructor - Start **/
    public InstallationTypeController(){
        selectedMarketType = '';
        havingIMO = '';
       // objActivationPlatformIMO = New Activation_Platform__c();
        createMarketANDSectorData();
        CountriesList = util.setupCountryPicklist();
        ActivationOrderId = ApexPages.currentPage().getParameters().get('order');       //extract Order Id
        ActivationStatus = readActivationStatus(ActivationOrderId);                     //get status record
        ActivationStatus.Active_Page__c = 'Installation Type';                              //set Active Page 
        ActivationStatus.Installation_Type_Page__c = 'available';                           //set Page Available Status
        Actsub =  [SELECT Id,Name, Activation_Order__c, Bill_to__c FROM  Activation_Subscriber__c WHERE Activation_Order__c=:ActivationOrderId];
        if(Actsub.size()>0 && Actsub[0].Bill_to__c == 'Corporate')
         Prevtab = 'Billing_Information';
        else
        Prevtab = 'Payment_Information';
        If (ActivationStatus.Installation_Type_Active_Tab__c == null){                      //set Active tab
            selectedTab = 'Installation_Type';
            ActivationStatus.Installation_Type_Active_Tab__c = selectedTab;
        } else {
            selectedTab = ActivationStatus.Installation_Type_Active_Tab__c;
            String strActivationContact = ApexPages.currentPage().getParameters().get('conActID');
            if((ApexPages.currentPage().getParameters().get('Record') != 'New' && strActivationContact ==null) &&(selectedTab == strAntennaSystemSupportTab || selectedTab == strOnboardContactTab)){
                goToCurrentContactTab();
            }
        }
        if(ActivationStatus.Installation_Type_Last_Active_Tab_Index__c == null){
            ActivationStatus.Installation_Type_Last_Active_Tab_Index__c =1;
        }
        if(ActivationStatus.Installation_Type_Last_Active_Tab_Index__c < mapdisableInstallationTypeTabs.get(selectedTab)){
            ActivationStatus.Installation_Type_Last_Active_Tab_Index__c = mapdisableInstallationTypeTabs.get(selectedTab);
        }
        objActivationOrder = [SELECT Id,Activation_Type__c, Brazilian_Waters_Vessel__c, CreatedById FROM Activation_Order__c WHERE id =: ActivationOrderId];
        //list<Activation_Order__c> lstForSkipValidation = [SELECT Id,Activation_Type__c FROM Activation_Order__c WHERE id =: ActivationOrderId and Activation_Type__c = 'Activation on behalf of Customer' and CreatedById =: UserInfo.getUserId()];
        isSkipValidation = objActivationOrder.Activation_Type__c == 'Activation on behalf of Customer' && objActivationOrder.CreatedById == UserInfo.getUserId();
    }
    /** Constructor - End **/
    
    //Getters and Setters
    public list<SelectOption> getCountriesList(){
        list<SelectOption> Options = new list<SelectOption>();
        for(SelectOption SOption:CountriesList)Options.add(new SelectOption(SOption.getLabel() ,SOption.getLabel()));
        return Options;
    }

    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   08/07/2016
    * @description          :   createMarketANDSectorData Method.
    *                           Custom Data to map vessel type to market and market sector.
    *                           (Can be removed by using custom setting)
    * @return               :   void
    * @invoke               :   From constructor 
    **/   
    private void createMarketANDSectorData(){
        mapMarketANDSector = New map<String, list<String>> ();
        list<String> lsttemp = New list<String>();
        lsttemp.add('Commercial/SATCOM* TV & Network Mgmt');
        lsttemp.add('Maritime');
        mapMarketANDSector.put('Commercial Vessel', lsttemp);
        
        lsttemp = New list<String>();
        lsttemp.add('Leisure');
        lsttemp.add('Marine');
        mapMarketANDSector.put('Leisure Vessel', lsttemp);
        
        lsttemp = New list<String>();
        lsttemp.add('Mil/Gov');
        lsttemp.add('Maritime');
        mapMarketANDSector.put('Military/Government Vessel', lsttemp);
        
        lsttemp = New list<String>();
        lsttemp.add('Commercial/SATCOM* TV & Network Mgmt');
        lsttemp.add('Land');
        mapMarketANDSector.put('Commercial Vehicle/Platform', lsttemp);
        
        lsttemp = New list<String>();
        lsttemp.add('Mil/Gov');
        lsttemp.add('Land');
        mapMarketANDSector.put('Military/Government Vehicle/Platform', lsttemp);
        
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   08/07/2016
    * @description          :   loadActivationPlatform Method.
    *                           Create Activation Platform If not present, else get Activation Platform
    *                           And used in vf page.Also set default selected vesseltype if any.
    * @return               :   pagereference, null
    * @invoke               :   From action method of Vf page
    **/
    public pagereference loadActivationPlatform(){
        //System.debug('Activation Platform');
        objActivationPlatform = New Activation_Platform__c();
       // objActivationPlatformIMO = New Activation_Platform__c();
        List<Activation_Platform__c> lstActivationPlatform = New List<Activation_Platform__c>();
        lstActivationPlatform = [SELECT Id, Vessel_Info__c,Name, Activation_Order__c, Market__c, Market_Sector__c,Platform_Detail__c,Confirm_if_boat_yacht_is_chartered__c,
                                 Flag__c,Vessel_Radio_Call_Sign__c,Vessel_IMO__c,Vessel_Length_ft_m__c,Vehicle_Model__c,
                                 Industry_Designation__c,MMSI__c,Vehicle_Make_Model__c,Vehicle_Year__c,Having_IMO__c, Distance_between_antenna_and_sea_level__c, Brazilian_system_operates_while_anchored__c,
                                 Geograpical_coordinates_of_port_and_site__c, Maximum_Latitude__c, Maximum_Longitude__c, Minimum_Latitude__c, Minimum_Longitude__c, Activation_Order__r.Brazilian_Waters_Vessel__c
                                 FROM Activation_Platform__c 
                                 WHERE Activation_Order__c =: ActivationOrderId];
        
        if(lstActivationPlatform.size()==0){
            objActivationPlatform.Name = 'TBD';
            objActivationPlatform.Activation_Order__c = ActivationOrderId;
            insert objActivationPlatform;
        }else{
            objActivationPlatform = lstActivationPlatform[0];
            CountriesList = util.setupCountryPicklist(objActivationPlatform.Flag__c);
        }
        objActivationPlatform.Name = objActivationPlatform.Name == 'TBD' ? '' : objActivationPlatform.Name;
        //system.debug('objActivationPlatform'+objActivationPlatform);
        /** To map already selected vessel type in any and show that vessel type as 'Selected' in vf page - Start **/
        list<String> lsttemp = New list<String>();
        /** We cant store string with comma in list, so we are replacing ',' with '*'  **/
        if(objActivationPlatform.Market__c != null)
            lsttemp.add(objActivationPlatform.Market__c.replace(',','*'));
        if(objActivationPlatform.Market_Sector__c != null)
            lsttemp.add(objActivationPlatform.Market_Sector__c.replace(',','*'));
        
        for(String strKey :mapMarketANDSector.keySet()){
            set<String> setTemp = New set<String>();
            setTemp.addAll(mapMarketANDSector.get(strKey));
            if(lsttemp.size()>0 && setTemp.containsAll(lsttemp)){
                selectedMarketType = strKey;
                // system.debug('selectedMarketType'+selectedMarketType);
            }
        }
        /** To map already selected vessel type in any and show that vessel type as 'Selected' in vf page - End **/
        return null;
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   03/04/2017
    * @description          :   updateActivationPlatformMarket Method.
    *                           To update Activation Platform market and market sector 
    *                           based on selected vessel type in vf page
    * @return               :   pagereference
    * @invoke               :   (onclick) From Vf page and also from goToTab method
    **/
    public pagereference updateActivationPlatformMarket(){
        /** We are replacing ',' with '*' , it will give actual value! And update activation platform  **/
        //system.debug('havingIMO'+havingIMO);
        if(selectedMarketType != ''){
            String strTemp = mapMarketANDSector.get(selectedMarketType)[0];
            objActivationPlatform.Market__c = strTemp.replace('*',',');
            strTemp = mapMarketANDSector.get(selectedMarketType)[1];
            objActivationPlatform.Market_Sector__c =strTemp.replace('*',',');
            if(objActivationPlatform.Vessel_Info__c != selectedMarketType){
                ActivationStatus.Installation_Type_Last_Active_Tab_Index__c =1;
                ActivationStatus.System_Page__c = 'inhibited';
                ActivationStatus.System_Type_Last_Active_Tab_Index__c = 1;
                ActivationStatus.First_Review_Page__c = 'inhibited';
                update ActivationStatus;
            }
        }
        if(havingIMO != ''){
            objActivationPlatform.Having_IMO__c = havingIMO;
        }
        
        //system.debug('objActivationPlatform' + objActivationPlatform);
        objActivationPlatform.Name = (objActivationPlatform.Name == '' || objActivationPlatform.Name == null) ? 'TBD' : objActivationPlatform.Name;
        update objActivationPlatform;
        
        if(objActivationPlatform.Market_Sector__c == 'Marine' || objActivationPlatform.Market_Sector__c.containsIgnoreCase('Maritime')){
           list<Account> acc1=[Select id,Vessel_IMO__c from account where Vessel_IMO__c =: objActivationPlatform.Vessel_IMO__c and Vessel_IMO__c !=null and RecordType.Name != 'KV Vessel' limit 1];  
            if(acc1.size()==0){
                list<Account> acc2=[Select id,Vessel_Radio_Call_Sign__c from account where Vessel_Radio_Call_Sign__c =: objActivationPlatform.Vessel_Radio_Call_Sign__c and Vessel_Radio_Call_Sign__c != null and RecordType.Name != 'KV Vessel' limit 1];
             if(acc2.size()==0){
                list<Account> acc3=[Select id,MMSI__c from account where MMSI__c =: objActivationPlatform.MMSI__c and MMSI__c != null and RecordType.Name != 'KV Vessel' limit 1];
                if(acc3.size()>0){
               Activation_Order__c ActOrd3=new Activation_Order__c();
                ActOrd3.Id=ActivationOrderId;
                ActOrd3.Account__c=acc3[0].id;
                update ActOrd3;
            }
             }
            else{
               Activation_Order__c ActOrd2=new Activation_Order__c();
                ActOrd2.Id=ActivationOrderId;
                ActOrd2.Account__c=acc2[0].id;
                update ActOrd2;
            }
            }
            else{
               Activation_Order__c ActOrd1=new Activation_Order__c();
                ActOrd1.Id=ActivationOrderId;
                ActOrd1.Account__c=acc1[0].id;
                update ActOrd1;
            }
        }
        
        Act_Subscriber_component_controller objActSubscribercomponentcontroller = New Act_Subscriber_component_controller();
        Boolean BoolIsError = objActSubscribercomponentcontroller.callfromOtherPage(objActivationPlatform, false);
        if(BoolIsError){
            return objActSubscribercomponentcontroller.selfRegistrationException('showError', 'userFail'); //Maybe this is another tailored page.....
        }
       
        return null;
    }

    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   18/05/2016
    * @description          :   goToNextTab Method.
    *                           To update Activation status and navigate Next 
    *                           tab based on vf page 'selectedTab' param 
    * @return               :   pageReference
    * @invoke               :   (onclick) From Vf page
    **/
    public pageReference goToNextTab(){
        pageReference objpageReference = updateActivationPlatformMarket();
        if(objpageReference != null){
            return objpageReference;
        }
        return goToTab();
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   18/05/2016
    * @description          :   goToTab Method.
    *                           To update Activation status and navigate next Or Previous
    *                           tab based on vf page 'selectedTab' param 
    * @return               :   pageReference
    * @invoke               :   (onclick) From Vf page and goToNextTab method
    **/
    public pageReference goToTab(){
        //system.debug('TAB'+ selectedTab);
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        if(selectedTab == 'Payment_Information' || selectedTab == 'Billing_Information'){
            /** Inside means we should navigate to Account_setup page **/
            /** We are updating activation status relevent Account_setup fields **/
            ActivationStatus.Account_Setup_Active_Tab__c = selectedTab;
            ActivationStatus.Active_Page__c = 'Account Type';
            returnPage = page.Account_Setup;      //unfortunately, this returns the whole view state!
        }
        else{
            ActivationStatus.Installation_Type_Active_Tab__c = selectedTab;
            if(ActivationStatus.Installation_Type_Last_Active_Tab_Index__c < mapdisableInstallationTypeTabs.get(selectedTab)){
                ActivationStatus.Installation_Type_Last_Active_Tab_Index__c = mapdisableInstallationTypeTabs.get(selectedTab);
            }
        }
        update ActivationStatus;
        returnPage.getParameters().clear();                         //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActivationOrderId); //add the order ID
        if(selectedTab == strAntennaSystemSupportTab){
            String strselectedContact = selectedContact(strSystemSupportContactRole);
            if(strselectedContact != null)
                returnPage.getParameters().put(strselectedContact.split('@@')[0], strselectedContact.split('@@')[1]);    
        }else if(selectedTab == strOnboardContactTab){
            String strselectedContact = selectedContact(strOnboardContactRole);
            if(strselectedContact != null)
                returnPage.getParameters().put(strselectedContact.split('@@')[0], strselectedContact.split('@@')[1]);  
        }
        returnPage.setRedirect(true);                               //this causes the constructors to run again...
        return returnPage;
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   07/06/2016
    * @description          :   goToCurrentContactTab Method.
    *                           Called when the Active tab is Onboard_Contact OR Antenna_System_Support_Contact 
    * @return               :   pageReference
    * @invoke               :   From Constructor only
    **/
    public pageReference goToCurrentContactTab(){
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        returnPage.getParameters().clear();                         //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActivationOrderId); //add the order ID
        if(selectedTab == strAntennaSystemSupportTab){
            String strselectedContact = selectedContact(strSystemSupportContactRole);
            if(strselectedContact != null)
                returnPage.getParameters().put(strselectedContact.split('@@')[0], strselectedContact.split('@@')[1]);    
        }else if(selectedTab == strOnboardContactTab){
            String strselectedContact = selectedContact(strOnboardContactRole);
            if(strselectedContact != null)
                returnPage.getParameters().put(strselectedContact.split('@@')[0], strselectedContact.split('@@')[1]);  
        }
        returnPage.setRedirect(true);                               //this causes the constructors to run again...
        return returnPage;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   07/06/2016
* @description          :   selectedContact Method.
*                           Load Current Tab Previously Edited Record Based on Contact Role 
* @return               :   String
* @param                :   String (Passing Current Contact Role)
* @invoke               :   From goToCurrentContactTab Method And goToTab Method
**/
    public String selectedContact(String ContactRole){
        List<Activation_Contact__c> lstContacts = New List<Activation_Contact__c>();
        String strQuery = 'SELECT Id,LastModifiedDate FROM Activation_Contact__c WHERE Activation_Order__c =:ActivationOrderId AND Contact_Role__c != null AND Contact_Role__c LIKE \'%'+ContactRole+'%\' ORDER BY LastModifiedDate DESC LIMIT 1';
        lstContacts = Database.query(strQuery);
        return (lstContacts.size()>0  ? 'conActID@@'+lstContacts[0].Id :  null);
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   07/22/2016
* @description          :   getTypes Method.
*                           Load Confirm_if_boat_yacht_is_chartered__c picklist values
* @return               :   List<SelectOption>
* @invoke               :   getter method
**/   
    
    public List<SelectOption> getTypes(){
        Schema.sObjectType objsObjectType = Activation_Platform__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribeSObjectResult = objsObjectType.getDescribe();
        Map<String, Schema.SObjectField> mapSObjectFields = objDescribeSObjectResult.fields.getMap();
        List<Schema.PicklistEntry> lstPicklistEntries = mapSObjectFields.get('Confirm_if_boat_yacht_is_chartered__c').getDescribe().getPickListValues();
        List<selectOption> lstOptions = new List<selectOption>();
        for (Schema.PicklistEntry objPicklistEntry : lstPicklistEntries) {
            lstOptions.add(new selectOption(objPicklistEntry.getLabel(), objPicklistEntry.getValue()));
        }
        return lstOptions;
    }
    
    public pagereference BrazilianWatersVessel(){
        update objActivationOrder;
        update objActivationPlatform;
        return null;
    }
    
    public pagereference saveandExit(){
        updateActivationPlatformMarket();
        return null;
    }
    
}