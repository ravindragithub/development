public class Act_CREWlink_Component_Ctrl{
    
    public Activation_Service__c objActivationService {get; set;} 
    public Activation_Order__c objActivationOrder {get; set;} 
    private String strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('CREWLink MTA').getRecordTypeId();
    public Activation_Hardware__c objActivationHardware  {get; set;}
    private static String strFeatureName = 'CREWlink Cards';
    private static String strPlanName 	=	'CREWlink Services';
    public List<wrapCrewLinkProductTable> lstwrapCrewLinkProductTable {get; set;} 
    
    /** Constructor - Start **/
    public Act_CREWlink_Component_Ctrl(){
        lstwrapCrewLinkProductTable = New List<wrapCrewLinkProductTable>();
        String ActivationOrderId = ApexPages.currentPage().getParameters().get('order');    //extract Order Id
        objActivationOrder = New Activation_Order__c();
        objActivationService = New Activation_Service__c();
        objActivationHardware = New Activation_Hardware__c();
        objActivationHardware.RecordTypeId = strActivationHardwareRecordTypeId;
        objActivationHardware.Activation_Order__c = ActivationOrderId;
        List<Activation_Order__c> lstActivationOrder = New List<Activation_Order__c>();
        lstActivationOrder= [SELECT Id,CREWLink_Basic_Selected__c,CREWLINK_ConnectTwo_Selected__c,CrewLink_Gateway_Selected__c,
                             (SELECT Id,Viewing_Options__c,Crew_Calling_Cards_100_Product__c,Crew_Calling_Cards_100_Quantity__c,
                              Crew_Calling_Cards_25_Product__c,	Crew_Calling_Cards_25_Quantity__c,CREWLink_Gateway_Serial_Number__c,Viewing_Option_Product__c,Media_Server_Serial_Number__c,
                              Media_Server__c,Purchase_CREWLink_Calling_Cards__c,Activation_Order__c,Entertainment_Programming_Product__r.Name,
                              Bandwidth_Management_Control_Interval__c,More_than_one_global_static_IP_addresses__c,
                              Independent_Entertainment_Channels__c,Operations_Data_Services__c,Special_Event_Channels__c,
                              Training_Packages__c,Entertainment_Programming_Selected__c,Entertainment_Programming_Product__c,
                              Voice2_Code3__c,Voice2_Code4__c,Voice2_Code5__c,Voice2_Country1__c,Voice2_Country2__c,
                              Voice2_Country3__c,Voice2_Country4__c,Voice2_Country5__c,Voice2_User_Country__c,Voice2_User_Specified_Code__c,
                              Voice2_Code1__c,Voice2_Code2__c,Inbound_IPs_ranges__c,Other_Inbound_Applications__c,
                              Additional_Comments__c,Activation_Contact__c,World_Region__c,Inbound_Applications__c,
                              CommBox_Product__r.Name,Voice1_User_Country__c,Voice1_User_Specified_Code__c,Voice_Line_2_Type__c,
                              Pilot_Firmware_Version__c,Pilot_SIM_Card_Number__c,Pilot_IMEI_Number__c,Iridium_OpenPort_Product__c,
                              Iridium_OpenPort_Selected__c,Global_Static_IP_Product__c,Global_Static_IP_Selected__c,CommBox_Product__c,
                              CommBox_Selected__c,Voice_1_Product__c,Voice_2_Product__c,Voice1_Country1__c,Voice1_Code1__c,
                              Voice1_Country2__c,Voice1_Code2__c,Voice1_Country3__c,Voice1_Code3__c,Voice1_Country4__c,Voice1_Code4__c,
                              Voice1_Country5__c,Voice1_Code5__c,Voice_Line_1_Type__c,CommBox_Hub_Hosting_Id__c, Activation_Plan_Type__c,
                              Activation_Rate_Plan__c,Special_Instructions__c, Product__c, Product__r.Name, VSAT_Antenna_Hardware__c,
                              Is_Selected__c FROM Activation_Services__r),
                             (SELECT Id,Below_Decks_Serial_Number__c, Below_Decks_Root_Asset__c, Root_Asset_Product_Group__c, System_Detail__c, System_Name__c 
                              FROM Activation_Hardware__r WHERE RecordTypeId =: strActivationHardwareRecordTypeId )
                             FROM Activation_Order__c 
                             WHERE Id=: ActivationOrderId LIMIT 1];
        
        if(lstActivationOrder.size()>0){
            objActivationOrder = lstActivationOrder[0];
            for(Activation_Hardware__c objActivationHardwareTemp : lstActivationOrder[0].Activation_Hardware__r){
                objActivationHardware = objActivationHardwareTemp;
            }
            
            for(Activation_Service__c objActivationServiceTemp : lstActivationOrder[0].Activation_Services__r){
                objActivationService = objActivationServiceTemp;
            }
            
            String strProductbundleId = Activation_Product_Bundle__c.getValues(strPlanName).Product_Bundle_Id__c;
            for(SBQQ__ProductOption__c objProductOption : [SELECT Id, Name,SBQQ__Feature__r.Name,SBQQ__MinQuantity__c,SBQQ__Feature__r.Id, SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c, SBQQ__OptionalSKU__r.Name FROM SBQQ__ProductOption__c WHERE SBQQ__OptionalSKU__c != null AND SBQQ__ConfiguredSKU__c != null AND SBQQ__ConfiguredSKU__c =: strProductbundleId AND SBQQ__Feature__r.Name =: strFeatureName ORDER BY SBQQ__Number__c]){ 
                wrapCrewLinkProductTable objwrapCrewLinkProductTable = New wrapCrewLinkProductTable();
                objwrapCrewLinkProductTable.strPlanProductId = objProductOption.SBQQ__OptionalSKU__c;
                objwrapCrewLinkProductTable.strPlanProductName = objProductOption.SBQQ__OptionalSKU__r.Name;
                objwrapCrewLinkProductTable.intQuantity = ((objProductOption.SBQQ__OptionalSKU__c == objActivationService.Crew_Calling_Cards_25_Product__c && objActivationService.Crew_Calling_Cards_25_Quantity__c != 0) ? Integer.valueOf(objActivationService.Crew_Calling_Cards_25_Quantity__c) : ((objProductOption.SBQQ__OptionalSKU__c == objActivationService.Crew_Calling_Cards_100_Product__c && objActivationService.Crew_Calling_Cards_100_Quantity__c != 0) ? Integer.valueOf(objActivationService.Crew_Calling_Cards_100_Quantity__c): null));
                objwrapCrewLinkProductTable.intMinQuantity = Integer.valueOf(objProductOption.SBQQ__MinQuantity__c);
                lstwrapCrewLinkProductTable.add(objwrapCrewLinkProductTable);   
            }
        }
       // system.debug('objActivationService' + objActivationService.Purchase_CREWLink_Calling_Cards__c);
    }
    /** Constructor - End **/
    
  /**
* @last modified by     :   Teertha prasad
* @last modified date   :   02/28/2017
* @description          :   wrapCrewLinkProductTable Wrapper Class.
* @invoke               :   Data Generated From Constructor
**/   
    
     public class wrapCrewLinkProductTable{
        public String strPlanProductId  {get; set;}
        public String strPlanProductName  {get; set;}
        public Integer intQuantity {get; set;}
        public Integer intMinQuantity {get; set;}
    } 
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   02/20/2017
* @description          :   updateActivationServiceCREWlink Method.
*                           Upsert Activation Service
* @return               :   void
* @invoke               :   From action method of Vf page
**/
    public pagereference updateActivationServiceCREWlink(){
        //system.debug('objActivationService.Crew_Calling_Cards_25_Product__c' +  objActivationService.Crew_Calling_Cards_25_Product__c);
        //system.debug('objActivationService.Crew_Calling_Cards_100_Product__c' +  objActivationService.Crew_Calling_Cards_100_Product__c);
        Map<String, Asset> mapAssets = New Map<String, Asset>();
        String strQuery = 'SELECT Id,Name,Item__c,Product2Id,Product2.Markets__c FROM Asset WHERE ';
        strQuery +=  objActivationHardware.Below_Decks_Serial_Number__c !='' ? ' (Name = \''+objActivationService.CREWLink_Gateway_Serial_Number__c + '\' OR Name = \''+ objActivationHardware.Below_Decks_Serial_Number__c + '\' ) ' : ' Name = \''+ objActivationService.CREWLink_Gateway_Serial_Number__c +'\'' ;
        
        for(Asset objAsset : Database.query(strQuery)){
            mapAssets.put(objAsset.Name, objAsset);
        }
        
       // objActivationService.Media_Server__c = !mapAssets.isEmpty() && mapAssets.containsKey(objActivationService.CREWLink_Gateway_Serial_Number__c) ? mapAssets.get(objActivationService.CREWLink_Gateway_Serial_Number__c).Id : null;
        objActivationHardware.Below_Decks_Serial_Number__c = objActivationService.CREWLink_Gateway_Serial_Number__c;
        objActivationHardware.Do_Not_Know_Serial_Number__c = (objActivationService.CREWLink_Gateway_Serial_Number__c == '' || mapAssets.isEmpty() || !mapAssets.containsKey(objActivationService.CREWLink_Gateway_Serial_Number__c)) ? true : false;
        //objActivationHardware.Antenna_Root_Asset__c = !mapAssets.isEmpty() && mapAssets.containsKey(objActivationService.CREWLink_Gateway_Serial_Number__c) ? mapAssets.get(objActivationService.CREWLink_Gateway_Serial_Number__c).Id : null;
        objActivationHardware.Below_Decks_Root_Asset__c = !mapAssets.isEmpty() && mapAssets.containsKey(objActivationHardware.Below_Decks_Serial_Number__c) ? mapAssets.get(objActivationHardware.Below_Decks_Serial_Number__c).Id : null;
        objActivationHardware.Root_Assets_Do_NOT_Match__c = objActivationHardware.Below_Decks_Root_Asset__c == objActivationHardware.Antenna_Root_Asset__c ? false : true ;
        
        updateActivationServicePurchaseCREWlinkCallingCards();
        
        update objActivationOrder;
        upsert objActivationHardware;
        return null;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   02/27/2017
* @description          :   clearActivationService Method.
*                           Upsert Activation Service
* @return               :   void
* @invoke               :   From action method of Vf page
**/
    public pagereference clearActivationService(){
        objActivationOrder.CREWLink_Basic_Selected__c = false;
        objActivationOrder.CREWLINK_ConnectTwo_Selected__c = false;
        objActivationOrder.CrewLink_Gateway_Selected__c = false;
        update objActivationOrder;
        
        objActivationService.CREWLink_Gateway_Serial_Number__c = '';
        objActivationService.Purchase_CREWLink_Calling_Cards__c = false;
        objActivationService.Crew_Calling_Cards_100_Product__c = null;
        objActivationService.Crew_Calling_Cards_100_Quantity__c = null;
        objActivationService.Crew_Calling_Cards_25_Product__c = null;
        objActivationService.Crew_Calling_Cards_25_Quantity__c = null;
        update objActivationService; 
        return null;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   02/27/2017
* @description          :   updateActivationServicePurchaseCREWlinkCallingCards Method.
*                           Upsert Activation Service
* @return               :   void
* @invoke               :   From action method of Vf page
**/
    public pagereference updateActivationServicePurchaseCREWlinkCallingCards(){
       // system.debug('objActivationService' + objActivationService.Purchase_CREWLink_Calling_Cards__c);
        objActivationService.CREWLink_Gateway_Serial_Number__c =  objActivationService.Purchase_CREWLink_Calling_Cards__c == false ? '' : objActivationService.CREWLink_Gateway_Serial_Number__c;
        objActivationService.Crew_Calling_Cards_100_Product__c =  objActivationService.Purchase_CREWLink_Calling_Cards__c == false ? null : objActivationService.Crew_Calling_Cards_100_Product__c;
        objActivationService.Crew_Calling_Cards_100_Quantity__c =  objActivationService.Purchase_CREWLink_Calling_Cards__c == false ? null : objActivationService.Crew_Calling_Cards_100_Quantity__c;
        objActivationService.Crew_Calling_Cards_25_Product__c =  objActivationService.Purchase_CREWLink_Calling_Cards__c == false ? null : objActivationService.Crew_Calling_Cards_25_Product__c;
        objActivationService.Crew_Calling_Cards_25_Quantity__c =  objActivationService.Purchase_CREWLink_Calling_Cards__c == false ? null : objActivationService.Crew_Calling_Cards_25_Quantity__c;

        update objActivationService;
        return null;
    }
    
}