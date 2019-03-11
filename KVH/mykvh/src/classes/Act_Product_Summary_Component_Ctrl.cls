/**
* @createdby        :   Teertha prasad
* @createddate      :   11/29/2016
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   05/15/2017
* @description      :   Class Used In Activation_Product_Summary Component for Activation update
*                       and for navigating between tabs.
**/
public class Act_Product_Summary_Component_Ctrl extends ActivationsBaseController {
    
    public string selectedTab  {get; set;} //current selected tab from vf page
    public Activation_Service__c objActivationServiceComp       {get; set;}
    public Activation_Order__c objActivationOrder      {get; set;}
    private Map<String, SBQQ__ProductOption__c> mapProductOptionsMain = New Map<String, SBQQ__ProductOption__c>();
    private Map<String, List<SBQQ__ProductOption__c>> mapProductOptions = New Map<String, List<SBQQ__ProductOption__c>>();
    public List<Activation_Hardware__c> lstActivationHardwareIntegrated  {get; set;}
    private Static String FeatureDataRate = 'Data Rate'; //can be taken from custom labels
    private Static String strVirtualVoiceLine1Feature = 'Virtual Line - Voice Line 1'; //can be taken from custom labels
    private Static String strVirtualVoiceLine2Feature = 'Virtual Line - Voice Line 2'; //can be taken from custom labels
    private Static String strCommBox = 'CommBox'; //can be taken from custom labels
    private Static String strHub = 'Hub'; //can be taken from custom labels

    private Set<String> setstrRatePlanName = New Set<String>();
    private List<String> setstrSelectedProduct = New List<String>();
    private Set<String> setstrPlanName = New Set<String>();
    public Boolean boolSuccesscheck {get; set;}
    private String strActivationHardwareRecordTypeIdSystem = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Activation System').getRecordTypeId();
    private String strActivationHardwareRecordTypeIdIntegrated = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Integrated Product').getRecordTypeId();
    private String strActivationHardwareRecordTypeIdMedia = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Media Hardware').getRecordTypeId();
    
    // keys to validate GSM modem whether to include or not for metered plans
    private Static String strIridium = 'Iridium';
    private Static String strV3 = 'V3';
    private Static String strGSMModem = 'GSM Modem';
    public List<SBQQ__QuoteLine__c> lstSBQQQuoteLines {get; set;}
    private String strQuoteId = '';
    
    public Decimal decOneTimeTotal {get; set;}
    public Decimal decMonthlyTotal {get; set;}
    
    public Boolean boolIsShowEdit {get; set;}
    
    /** Constructor - Start **/
    public Act_Product_Summary_Component_Ctrl(){
        decOneTimeTotal = 0;
        decMonthlyTotal = 0;
        lstSBQQQuoteLines = New List<SBQQ__QuoteLine__c>();
        ActivationOrderId = ApexPages.currentPage().getParameters().get('order');    //extract Order Id
        ActivationStatus = readActivationStatus(ActivationOrderId);             //get status record
        selectedTab = ActivationStatus.Services_Active_Tab__c;
        readActivationServiceComp(ActivationOrderId);
    }
    /** Constructor - End **/
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   11/29/2016
* @description          :   readActivationServiceComp Method.
*                           Create Activation Service If not present, else get Activation Service
*                           And used in vf page.
* @return               :   void
* @invoke               :   From Constructor
**/
    public void readActivationServiceComp(String strOrderId){
        
        objActivationOrder = New Activation_Order__c();
        List<Activation_Order__c> lstActivationOrder = New List<Activation_Order__c>();
        lstActivationHardwareIntegrated = New List<Activation_Hardware__c>();
        lstActivationOrder= [SELECT Id,CreatedById,Activation_Type__c,Order_Status__c,Contract_Term__c,Pre_Activation_Date__c,Airtime_Services_to_Review_Order__c,
                             Quote__c ,Service_Start_Date__c,Entertainment_News_Sports_Training_Term__c,Lease_Contract__c,
                             Operation_Data_Services_Term__c,Hardware_Purchased_or_Leased__c,Activation_Opportunity__c,
                             Activation_Opportunity__r.AccountId,
                             (SELECT Id, Image_URL_Formulated__c, Image_path_name__c, RecordTypeId,
                              Sequence__c, Static_Resource_Archive__c, Status__c,Below_Decks_Root_Asset__c, 
                              Title__c, isOptionalHardware__c, Antenna_Serial_Number__c,Integrated_Product_Type__c,
                              Below_Decks_Serial_Number__c,Activation_Order__c,System_Name_Group__c, 
                              Do_Not_Know_Serial_Number__c,System_Detail__c, System_Name__c,
                              Antenna_Root_Asset__c FROM Activation_Hardware__r),
                             (SELECT Id, Vessel_Info__c,Name, Activation_Order__c, Market__c, Market_Sector__c,Platform_Detail__c,Confirm_if_boat_yacht_is_chartered__c,
                              Flag__c,Vessel_Radio_Call_Sign__c,Vessel_IMO__c,Vessel_Length_ft_m__c,Vehicle_Model__c
                              FROM Activation_Platforms__r),
                             (SELECT Id,Media_Server_Serial_Number__c,Crew_Calling_Cards_25_Product__c,Crew_Calling_Cards_100_Product__c,
                              Purchase_CREWLink_Calling_Cards__c,Crew_Calling_Cards_25_Quantity__c,Crew_Calling_Cards_100_Quantity__c,
                              Activation_Contact__c,Activation_Contact__r.Contact_Role__c,OneCare_Technical_Assistance_Package__r.Name,OneCare_Technical_Assistance_Package__c,Extended_Warranty_Product__c,Viewing_Option_Product__c,Pilot_SIM_Card_Number__c ,Pilot_Firmware_Version__c,Pilot_IMEI_Number__c,
                              Iridium_OpenPort_Product__r.Name,Independent_Entertainment_Channels__c,Operations_Data_Services__c,
                              Special_Event_Channels__c,Training_Packages__c,Entertainment_Programming_Selected__c,More_than_one_global_static_IP_addresses__c,
                              Entertainment_Programming_Product__c,Voice2_Code3__c,Voice2_Code4__c,Voice2_Code5__c,Voice2_Country1__c,
                              Voice2_Country2__c,Voice2_Country3__c,Voice2_Country4__c,Voice2_Country5__c,Voice2_User_Country__c,
                              Voice2_User_Specified_Code__c,Activation_Contact__r.Last_Name__c,Activation_Contact__r.First_Name__c,Voice2_Code1__c,Voice2_Code2__c,CommBox_Product__r.Name,Additional_Comments__c,
                              World_Region__c,Inbound_Applications__c ,Inbound_IPs_ranges__c ,Voice1_User_Country__c,Voice1_User_Specified_Code__c,
                              Voice_Line_2_Type__c,Iridium_OpenPort_Product__c,Iridium_OpenPort_Selected__c,Global_Static_IP_Product__c,
                              Global_Static_IP_Selected__c,CommBox_Product__c,CommBox_Selected__c,Voice_1_Product__c,Voice_2_Product__c,
                              Voice1_Country1__c,Voice1_Code1__c,Voice1_Country2__c,Voice1_Code2__c,Voice1_Country3__c,Voice1_Code3__c,
                              Voice1_Country4__c,Voice1_Code4__c,Voice1_Country5__c,Voice1_Code5__c,Voice_Line_1_Type__c,CommBox_Hub_Hosting_Id__c,
                              CommBox_Hub_Hosting_Id__r.Name, CommBox_Serial_Number__c , Activation_Plan_Type__c, Activation_Rate_Plan__c,
                              Special_Instructions__c, Product__c, Product__r.Name, VSAT_Antenna_Hardware__c, Is_Selected__c FROM Activation_Services__r)
                             FROM Activation_Order__c WHERE Activation_Opportunity__c != null AND Quote__c != Null
                             AND Id=:strOrderId LIMIT 1];
        boolIsShowEdit = true;
        if(lstActivationOrder.size()>0){
            objActivationOrder = lstActivationOrder[0];
            List<User> objUser = New List<User>();
            objUser = [SELECT Id,contactId FROM User WHERE Id =: UserInfo.getUserId()];
            if(objUser.size()>0){
                boolIsShowEdit = (objUser[0].contactId != null && ( objActivationOrder.Order_Status__c == 'Submitted' || (objActivationOrder.CreatedById == userInfo.getUserId() && objActivationOrder.Order_Status__c == 'Pending Customer Confirmation' ) ) ) ? false : true;
            }            
            objActivationServiceComp = New Activation_Service__c();
            objActivationServiceComp.Activation_Order__c = strOrderId;
            
            for(Activation_Hardware__c objActivationHardwareTemp : objActivationOrder.Activation_Hardware__r){
                if(objActivationHardwareTemp.RecordTypeId == strActivationHardwareRecordTypeIdIntegrated){
                    lstActivationHardwareIntegrated.add(objActivationHardwareTemp);
                }
            }
            for(Activation_Service__c ActivationService  : objActivationOrder.Activation_Services__r){
                objActivationServiceComp = ActivationService;
                if(ActivationService.Product__c != null && ActivationService.Is_Selected__c)
                    setstrSelectedProduct.add(ActivationService.Product__c);
                if(ActivationService.Voice_1_Product__c != null)
                    setstrSelectedProduct.add(ActivationService.Voice_1_Product__c);
                if(ActivationService.Voice_2_Product__c != null)
                    setstrSelectedProduct.add(ActivationService.Voice_2_Product__c);
                if(ActivationService.Entertainment_Programming_Product__c != null && ActivationService.Entertainment_Programming_Selected__c)
                    setstrSelectedProduct.add(ActivationService.Entertainment_Programming_Product__c);
                
                List<String> lstProductlines = New List<String>();
                if(ActivationService.Independent_Entertainment_Channels__c != null && ActivationService.Independent_Entertainment_Channels__c != ''){
                    lstProductlines = ActivationService.Independent_Entertainment_Channels__c.trim().split(';');
                    for(String strKey : lstProductlines){
                        List<String> lstProductline = strKey.trim().split('<-->');
                        setstrSelectedProduct.add(lstProductline[1].trim());
                    }
                }
                lstProductlines = New List<String>();
                if(ActivationService.Special_Event_Channels__c != null && ActivationService.Special_Event_Channels__c != ''){
                    lstProductlines = ActivationService.Special_Event_Channels__c.trim().split(';');
                    for(String strKey : lstProductlines){
                        List<String> lstProductline = strKey.trim().split('<-->');
                        setstrSelectedProduct.add(lstProductline[1].trim());
                    }
                }
                lstProductlines = New List<String>();
                if(ActivationService.Training_Packages__c != null && ActivationService.Training_Packages__c != ''){
                    lstProductlines = ActivationService.Training_Packages__c.trim().split(';');
                    for(String strKey : lstProductlines){
                        List<String> lstProductline = strKey.trim().split('<-->');
                        setstrSelectedProduct.add(lstProductline[1].trim());
                    }
                }
                lstProductlines = New List<String>();
                if(ActivationService.Operations_Data_Services__c != null && ActivationService.Operations_Data_Services__c != ''){
                    lstProductlines = ActivationService.Operations_Data_Services__c.trim().split(';');
                    for(String strKey : lstProductlines){
                        List<String> lstProductline = strKey.trim().split('<-->');
                        setstrSelectedProduct.add(lstProductline[1].trim());
                    }
                }
                
                if(ActivationService.Viewing_Option_Product__c != null)
                    setstrSelectedProduct.add(ActivationService.Viewing_Option_Product__c);
                if(ActivationService.Global_Static_IP_Product__c != null && ActivationService.Global_Static_IP_Selected__c)
                    setstrSelectedProduct.add(ActivationService.Global_Static_IP_Product__c);
                if(ActivationService.Iridium_OpenPort_Product__c != null && ActivationService.Iridium_OpenPort_Selected__c)
                    setstrSelectedProduct.add(ActivationService.Iridium_OpenPort_Product__c);
                if(ActivationService.CommBox_Product__c != null && ActivationService.CommBox_Selected__c)
                    setstrSelectedProduct.add(ActivationService.CommBox_Product__c);
                if(ActivationService.Purchase_CREWLink_Calling_Cards__c){
                    if(ActivationService.Crew_Calling_Cards_25_Product__c != null){
                        setstrSelectedProduct.add(ActivationService.Crew_Calling_Cards_25_Product__c);
                    }
                    if(ActivationService.Crew_Calling_Cards_100_Product__c != null){
                        setstrSelectedProduct.add(ActivationService.Crew_Calling_Cards_100_Product__c);
                    }
                }
                if(ActivationService.OneCare_Technical_Assistance_Package__c != null)
                    setstrSelectedProduct.add(ActivationService.OneCare_Technical_Assistance_Package__c);
                if(ActivationService.Extended_Warranty_Product__c != null)
                    setstrSelectedProduct.add(ActivationService.Extended_Warranty_Product__c);
                
                // system.debug('setstrSelectedProduct' + setstrSelectedProduct);
            }
        }
    }
    
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   09/26/2016
* @description          :   loadDynamicRatePlanTableP Method.
*                           To load current selected product bundle from data
* @return               :   void
* @invoke               :   From selectedProductBundle Method
**/
    public void loadDynamicRatePlanTableP(){
        mapProductOptionsMain = New Map<String, SBQQ__ProductOption__c>();
        mapProductOptions = New Map<String, List<SBQQ__ProductOption__c>>();
        Set<String> strOptionalSKUProduct = New Set<String>();
        
        for(SBQQ__ProductOption__c objProductOption : [SELECT Id, Name,Monthly_Contract_Term__c, SBQQ__QuoteLineVisibility__c, SBQQ__OptionalSKU__r.Family, SBQQ__ConfiguredSKU__r.Family, SBQQ__OptionalSKU__r.SBQQ__SubscriptionType__c, SBQQ__ConfiguredSKU__r.SBQQ__SubscriptionType__c, SBQQ__ConfiguredSKU__c,SBQQ__Type__c,SBQQ__ProductDescription__c,SBQQ__OptionalSKU__r.VSAT_Antenna_Hardware__c,SBQQ__Bundled__c, SBQQ__OptionalSKU__c,SBQQ__OptionalSKU__r.RecordType.Name, SBQQ__OptionalSKU__r.Name  FROM SBQQ__ProductOption__c WHERE SBQQ__OptionalSKU__c =: setstrSelectedProduct ORDER BY SBQQ__Feature__r.SBQQ__Number__c, SBQQ__Number__c]){
            strOptionalSKUProduct.add(objProductOption.SBQQ__OptionalSKU__c);
            mapProductOptionsMain.put(objProductOption.SBQQ__OptionalSKU__c, objProductOption);
        }
        
        Set<Id> setFilterDataRateFeature = New Set<Id>();
        Set<Id> setFilterDataRateFeatureProduct = New Set<Id>();
        for(SBQQ__ProductOption__c objProductOption : [SELECT Id,SBQQ__OptionalSKU__c,SBQQ__Feature__r.Name,SBQQ__Required__c,SBQQ__Selected__c FROM SBQQ__ProductOption__c WHERE SBQQ__ConfiguredSKU__c IN: strOptionalSKUProduct AND SBQQ__QuoteLineVisibility__c != 'Never' AND SBQQ__Feature__c != null ORDER BY SBQQ__Feature__r.SBQQ__Number__c, SBQQ__Number__c]){
            if(objProductOption.SBQQ__Feature__r.Name.trim().containsIgnoreCase(FeatureDataRate)){
                    setFilterDataRateFeatureProduct.add(objProductOption.SBQQ__OptionalSKU__c);
                    if(objProductOption.SBQQ__Required__c && objProductOption.SBQQ__Selected__c){
                        setFilterDataRateFeature.add(objProductOption.SBQQ__OptionalSKU__c);
                    }
                }
        }
        
        for(SBQQ__ProductAction__c objSBQQProductAction : [SELECT Id, Name,VSAT_Antenna_Hardware__c, SBQQ__Rule__c,SBQQ__Product__r.Name FROM SBQQ__ProductAction__c WHERE SBQQ__Type__c = 'Show & Add' AND SBQQ__Rule__r.SBQQ__Active__c = true AND SBQQ__Product__c IN: setFilterDataRateFeatureProduct ]){
                Set<String> setVSAT = New Set<String>();
                setVSAT.addAll((objSBQQProductAction.VSAT_Antenna_Hardware__c != null ? objSBQQProductAction.VSAT_Antenna_Hardware__c.trim().split(';') : New List<String>{null}));
                for(String strVSATKEY : setVSAT){
                    if(strVSATKEY == objActivationServiceComp.VSAT_Antenna_Hardware__c){
                        setFilterDataRateFeature.add(objSBQQProductAction.SBQQ__Product__c);
                    }
                }
            }
        
        for(SBQQ__ProductOption__c objProductOption : [SELECT Id, Name,Monthly_Contract_Term__c, SBQQ__QuoteLineVisibility__c,SBQQ__OptionalSKU__r.Family, SBQQ__ConfiguredSKU__r.Family, SBQQ__OptionalSKU__r.SBQQ__SubscriptionType__c, SBQQ__ConfiguredSKU__r.SBQQ__SubscriptionType__c,SBQQ__ConfiguredSKU__r.Name,SBQQ__Type__c, SBQQ__ProductDescription__c,SBQQ__OptionalSKU__r.VSAT_Antenna_Hardware__c,SBQQ__Bundled__c,SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c,SBQQ__Feature__r.Name, SBQQ__OptionalSKU__r.Name, SBQQ__OptionalSKU__r.RecordType.Name FROM SBQQ__ProductOption__c WHERE SBQQ__ConfiguredSKU__c IN: strOptionalSKUProduct AND SBQQ__QuoteLineVisibility__c != 'Never' ORDER BY SBQQ__Feature__r.SBQQ__Number__c, SBQQ__Number__c]){
            if(!objProductOption.SBQQ__ConfiguredSKU__r.Name.ContainsIgnoreCase(strCommBox)){
                Set<String> setVSAT = New Set<String>();
                setVSAT.addAll((objProductOption.SBQQ__OptionalSKU__r.VSAT_Antenna_Hardware__c != null ? objProductOption.SBQQ__OptionalSKU__r.VSAT_Antenna_Hardware__c.trim().split(';') : New List<String>{null}));
                if(!objActivationServiceComp.VSAT_Antenna_Hardware__c.containsIgnoreCase(strV3) || (objActivationServiceComp.VSAT_Antenna_Hardware__c.containsIgnoreCase(strV3) && objActivationServiceComp.VSAT_Antenna_Hardware__c.containsIgnoreCase(strIridium)) || (objActivationServiceComp.VSAT_Antenna_Hardware__c.containsIgnoreCase(strV3) && !objActivationServiceComp.VSAT_Antenna_Hardware__c.containsIgnoreCase(strIridium) && !objProductOption.SBQQ__OptionalSKU__r.Name.containsIgnoreCase(strGSMModem))){
                    if(!mapProductOptions.containsKey(objProductOption.SBQQ__ConfiguredSKU__c)){
                        if(objProductOption.SBQQ__Feature__c != null && !objProductOption.SBQQ__Feature__r.Name.containsIgnoreCase(FeatureDataRate)){
                            mapProductOptions.put(objProductOption.SBQQ__ConfiguredSKU__c, New List<SBQQ__ProductOption__c>{objProductOption});
                        }else{
                            for(String strVSATKEY : setVSAT){
                                if(strVSATKEY == objActivationServiceComp.VSAT_Antenna_Hardware__c && !setFilterDataRateFeature.isEmpty() && setFilterDataRateFeature.contains(objProductOption.SBQQ__OptionalSKU__c)){
                                    mapProductOptions.put(objProductOption.SBQQ__ConfiguredSKU__c, New List<SBQQ__ProductOption__c>{objProductOption});
                                }
                            }
                        }
                    }else{
                        if(objProductOption.SBQQ__Feature__c != null && !objProductOption.SBQQ__Feature__r.Name.containsIgnoreCase(FeatureDataRate)){
                            mapProductOptions.get(objProductOption.SBQQ__ConfiguredSKU__c).add(objProductOption);                
                        }else{
                            for(String strVSATKEY : setVSAT){  
                                if(strVSATKEY == objActivationServiceComp.VSAT_Antenna_Hardware__c && !setFilterDataRateFeature.isEmpty() && setFilterDataRateFeature.contains(objProductOption.SBQQ__OptionalSKU__c)){
                                    mapProductOptions.get(objProductOption.SBQQ__ConfiguredSKU__c).add(objProductOption);                
                                }
                            }
                        }
                    }
                }
            }
            if(objProductOption.SBQQ__ConfiguredSKU__r.Name.ContainsIgnoreCase(strCommBox)){
                if(!mapProductOptions.containsKey(objProductOption.SBQQ__ConfiguredSKU__c)){
                    if(objProductOption.SBQQ__OptionalSKU__r.Name.ContainsIgnoreCase(strHub)){
                        if(objProductOption.SBQQ__OptionalSKU__c == objActivationServiceComp.CommBox_Hub_Hosting_Id__c && objActivationServiceComp.CommBox_Product__c != null){
                            mapProductOptions.put(objProductOption.SBQQ__ConfiguredSKU__c, New List<SBQQ__ProductOption__c>{objProductOption});
                        }
                    }else{
                        mapProductOptions.put(objProductOption.SBQQ__ConfiguredSKU__c, New List<SBQQ__ProductOption__c>{objProductOption});
                    }
                }else{
                    if(objProductOption.SBQQ__OptionalSKU__r.Name.ContainsIgnoreCase(strHub)){
                        if(objProductOption.SBQQ__OptionalSKU__c == objActivationServiceComp.CommBox_Hub_Hosting_Id__c && objActivationServiceComp.CommBox_Product__c != null){
                            mapProductOptions.get(objProductOption.SBQQ__ConfiguredSKU__c).add(objProductOption);                          
                        }
                    }else{
                        mapProductOptions.get(objProductOption.SBQQ__ConfiguredSKU__c).add(objProductOption);                       
                    }
                }
            }
        }
        // system.debug('mapProductOptionsMain'+mapProductOptionsMain.size());
        //  system.debug('mapProductOptions'+mapProductOptions);
        
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   09/20/2016
* @description          :   selectedProductBundle Method.
*                           To load current selected product bundle data records.
*                           and to update selected product on Activation Service
*                           and to create Quote and QuoteLineItems from selected bundle.
* @return               :   pagereference
* @invoke               :   From updateActivationServiceValue Method
**/
    public pagereference selectedProductBundle(){
        List<Activation_Order__c> lstActivationOrder = New List<Activation_Order__c>();
        lstActivationOrder= [SELECT Id,Contract_Term__c,Quote__c,Entertainment_News_Sports_Training_Term__c,Operation_Data_Services_Term__c,Hardware_Purchased_or_Leased__c,Activation_Opportunity__c,Activation_Opportunity__r.AccountId
                             FROM Activation_Order__c 
                             WHERE Activation_Opportunity__c != null AND Quote__c != Null AND Id=:ActivationOrderId LIMIT 1];
        
        if(lstActivationOrder.size()>0){
            loadDynamicRatePlanTableP();
            List<SBQQ__QuoteLine__c> lstQuoteLinesChild = New List<SBQQ__QuoteLine__c>();
            Map<String, SBQQ__QuoteLine__c> maplstQuoteLinesParent = New Map<String, SBQQ__QuoteLine__c>();
            Map<String, List<SBQQ__QuoteLine__c>> maplstQuoteLinesChild = New Map<String, List<SBQQ__QuoteLine__c>>();
            
            SBQQ__Quote__c objQuote = New SBQQ__Quote__c();
            for(SBQQ__Quote__c objQuot : [SELECT Id,SBQQ__Opportunity2__c,CommBox_Option__c,Hub_Maintenance__c,SBQQ__Account__c,SBQQ__DeliveryMethod__c,SBQQ__PaymentTerms__c,
                                          (SELECT Id FROM SBQQ__LineItems__r)
                                          FROM SBQQ__Quote__c 
                                          WHERE Id =: objActivationOrder.Quote__c Limit 1]){
                                              objQuote=  objQuot;
                                              lstQuoteLinesChild = objQuot.SBQQ__LineItems__r; 
                                          }
            objQuote.Activation_Services__c = objActivationServiceComp.Id;
            objQuote.Static_IP_Additional_Comments__c = objActivationServiceComp.Additional_Comments__c;
            objQuote.Static_Inbound_Applications__c = objActivationServiceComp.Inbound_Applications__c;
            objQuote.Rate_Plan_Special_Instructions__c = objActivationServiceComp.Special_Instructions__c;
            objQuote.Print_Rate_Plan_Instructions__c = objActivationServiceComp.Special_Instructions__c != '' && objActivationServiceComp.Special_Instructions__c != null ? true : false;
            
            if(lstActivationHardwareIntegrated.size()>0){
                objQuote.System_2__c = lstActivationHardwareIntegrated[0].Id;
                if(lstActivationHardwareIntegrated.size()>1){
                    objQuote.System_3__c = lstActivationHardwareIntegrated[1].Id;
                }
                if(lstActivationHardwareIntegrated.size()>2){
                    objQuote.System_4__c = lstActivationHardwareIntegrated[2].Id;
                }
            }
            
            objQuote.SBQQ__StartDate__c = objActivationOrder.Service_Start_Date__c;
            objQuote.SBQQ__Opportunity2__c = objActivationOrder.Activation_Opportunity__c;
            objQuote.SBQQ__Account__c = objActivationOrder.Activation_Opportunity__r.AccountId;
            //objQuote.SBQQ__DeliveryMethod__c = 'Ship'; 
            //objQuote.SBQQ__PaymentTerms__c = 'Net 30';
            objQuote.Voice_Line1_Type__c = (objActivationServiceComp  != null && objActivationServiceComp.Voice_Line_1_Type__c !=null ? objActivationServiceComp.Voice_Line_1_Type__c.trim() : '');
            // objQuote.Voice_Line2_Type__c = (objActivationServiceComp  != null && objActivationServiceComp.Voice_Line_2_Type__c !=null ? objActivationServiceComp.Voice_Line_2_Type__c.trim() : '');
            objQuote.VSAT_Antenna_Hardware__c = objActivationServiceComp.VSAT_Antenna_Hardware__c;
            objQuote.CommBox_Option__c =(objActivationServiceComp  != null && objActivationServiceComp.CommBox_Product__c !=null && objActivationServiceComp.CommBox_Product__r.Name.containsIgnoreCase('Enterprise') ? 'Enterprise' : (objActivationServiceComp  != null && objActivationServiceComp.CommBox_Product__c !=null && objActivationServiceComp.CommBox_Product__r.Name.containsIgnoreCase('Standard') ? 'Standard' : ''));
            objQuote.Hub_Maintenance__c =(objActivationServiceComp  != null && objActivationServiceComp.CommBox_Hub_Hosting_Id__c !=null ? objActivationServiceComp.CommBox_Hub_Hosting_Id__r.Name.trim() : '');
            
            try{
                if(lstQuoteLinesChild.size()>0){
                    delete lstQuoteLinesChild;
                }
                upsert objQuote;
                
                Map<String, SBQQ__Dimension__c> mapDimensions = New Map<String, SBQQ__Dimension__c>();
                Set<String> setProductKey = New Set<String>();
                
                for(String strKey : mapProductOptionsMain.keySet()){
                    if(mapProductOptions.containsKey(strKey)){
                        for(SBQQ__ProductOption__c objProductOption : mapProductOptions.get(strKey)){
                            setProductKey.add(objProductOption.SBQQ__OptionalSKU__c);
                        }
                    }
                }
                
                for(SBQQ__Dimension__c objDimension : [SELECT Id, SBQQ__Product__c FROM SBQQ__Dimension__c WHERE (SBQQ__Product__c IN: setProductKey)]){
                    mapDimensions.put(objDimension.SBQQ__Product__c, objDimension);
                }
                
                Integer i = 1;
                Boolean boolVoice1_Country1 = false;
                Boolean boolVoice1_Country2 = false;
                Boolean boolVoice1_Country3 = false;
                Boolean boolVoice1_Country4 = false;
                Boolean boolVoice1_Country5 = false;
                Boolean boolVoice2_Country1 = false;
                Boolean boolVoice2_Country2 = false;
                Boolean boolVoice2_Country3 = false; 
                Boolean boolVoice2_Country4 = false;
                Boolean boolVoice2_Country5 = false;
                for(String strKey : setstrSelectedProduct){
                    if(!mapProductOptionsMain.isEmpty() && mapProductOptionsMain.containsKey(strKey)){
                        SBQQ__QuoteLine__c objQuoteLineP = New SBQQ__QuoteLine__c();
                        objQuoteLineP.SBQQ__Product__c = mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__c;
                        objQuoteLineP.SBQQ__Bundle__c = true;
                        objQuoteLineP.SBQQ__Number__c = i;
                        objQuoteLineP.SBQQ__Dimension__c = (!mapDimensions.isEmpty() && mapDimensions.containsKey(mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__c)) ? mapDimensions.get(mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__c).Id : null;
                        objQuoteLineP.SBQQ__Quantity__c = ((mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.SBQQ__SubscriptionType__c <> 'One-time' && mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Family != '' && mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Family != null) ? ((mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Family.trim() == 'Airtime' || mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Family.trim() == 'OneCare' ) ? objActivationOrder.Contract_Term__c : ((mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Family.trim() == 'Media' && mapProductOptionsMain.get(strKey).Monthly_Contract_Term__c != true) ? objActivationOrder.Entertainment_News_Sports_Training_Term__c :(mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Family.trim() == 'File Services' || (mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Family.trim() == 'Media' && mapProductOptionsMain.get(strKey).Monthly_Contract_Term__c == true) ? objActivationOrder.Operation_Data_Services_Term__c : 1))) : 1);
                        if(mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Name.containsIgnoreCase('CREW CALLING')){
                            objQuoteLineP.Quantity_Online_Activation__c = '(Qty ' + (mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Name.containsIgnoreCase('25') ? Integer.valueOf(objActivationServiceComp.Crew_Calling_Cards_25_Quantity__c) :  Integer.valueOf(objActivationServiceComp.Crew_Calling_Cards_100_Quantity__c)) + ')';
                        }
                            objQuoteLineP.SBQQ__Description__c =  mapProductOptionsMain.get(strKey).SBQQ__ProductDescription__c;
                        if(!maplstQuoteLinesParent.containsKey(strKey))
                            maplstQuoteLinesParent.put(strKey, objQuoteLineP);
                        
                        i++;
                        if(mapProductOptions.containsKey(strKey)){
                            for(SBQQ__ProductOption__c objProductOption : mapProductOptions.get(strKey)){
                                SBQQ__QuoteLine__c objQuoteLine = New SBQQ__QuoteLine__c();
                                objQuoteLine.SBQQ__Product__c = objProductOption.SBQQ__OptionalSKU__c;
                                objQuoteLine.SBQQ__ProductOption__c = objProductOption.Id;
                                objQuoteLine.SBQQ__Quantity__c = ((mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.SBQQ__SubscriptionType__c <> 'One-time' && mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Family != '' && mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Family != null) ? ((mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Family.trim() == 'Airtime' || mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Family.trim() == 'OneCare' ) ? objActivationOrder.Contract_Term__c : ((mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Family.trim() == 'Media' && mapProductOptionsMain.get(strKey).Monthly_Contract_Term__c != true) ? objActivationOrder.Entertainment_News_Sports_Training_Term__c :(mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Family.trim() == 'File Services' || (mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Family.trim() == 'Media' && mapProductOptionsMain.get(strKey).Monthly_Contract_Term__c == true) ? objActivationOrder.Operation_Data_Services_Term__c : 1))) : 1);
                                objQuoteLine.SBQQ__OptionLevel__c = 1;
                                objQuoteLine.SBQQ__Dimension__c = (!mapDimensions.isEmpty() && mapDimensions.containsKey(strKey)) ? mapDimensions.get(strKey).Id : null;
                                objQuoteLine.SBQQ__OptionType__c = objProductOption.SBQQ__Type__c;
                                objQuoteLine.SBQQ__Number__c = i;
                                objQuoteLine.SBQQ__Bundled__c = objProductOption.SBQQ__Bundled__c;
                                objQuoteLine.SBQQ__Description__c = objProductOption.SBQQ__ProductDescription__c;
                                if(objProductOption.SBQQ__Feature__r.Name != strVirtualVoiceLine1Feature && objProductOption.SBQQ__Feature__r.Name != strVirtualVoiceLine2Feature){
                                    if(!maplstQuoteLinesChild.containsKey(strKey)){
                                        maplstQuoteLinesChild.put(strKey, New List<SBQQ__QuoteLine__c>{objQuoteLine});
                                    }else{
                                        maplstQuoteLinesChild.get(strKey).add(objQuoteLine);
                                    }
                                }else if(objProductOption.SBQQ__Feature__r.Name.equalsIgnoreCase(strVirtualVoiceLine1Feature)){
                                    // find better logic for below
                                    if(objActivationServiceComp.Voice1_Country1__c != null && !boolVoice1_Country1){
                                        if(!maplstQuoteLinesChild.containsKey(strKey)){
                                            maplstQuoteLinesChild.put(strKey, New List<SBQQ__QuoteLine__c>{objQuoteLine});
                                        }else{
                                            maplstQuoteLinesChild.get(strKey).add(objQuoteLine);
                                        } 
                                        boolVoice1_Country1 = true;
                                    }
                                    else if(objActivationServiceComp.Voice1_Country2__c != null && !boolVoice1_Country2){
                                        if(!maplstQuoteLinesChild.containsKey(strKey)){
                                            maplstQuoteLinesChild.put(strKey, New List<SBQQ__QuoteLine__c>{objQuoteLine});
                                        }else{
                                            maplstQuoteLinesChild.get(strKey).add(objQuoteLine);
                                        }  
                                        boolVoice1_Country2 = true;
                                    }
                                    else if(objActivationServiceComp.Voice1_Country3__c != null && !boolVoice1_Country3){
                                        if(!maplstQuoteLinesChild.containsKey(strKey)){
                                            maplstQuoteLinesChild.put(strKey, New List<SBQQ__QuoteLine__c>{objQuoteLine});
                                        }else{
                                            maplstQuoteLinesChild.get(strKey).add(objQuoteLine);
                                        }  
                                        boolVoice1_Country3 = true;
                                    }
                                    else if(objActivationServiceComp.Voice1_Country4__c != null && !boolVoice1_Country4){
                                        if(!maplstQuoteLinesChild.containsKey(strKey)){
                                            maplstQuoteLinesChild.put(strKey, New List<SBQQ__QuoteLine__c>{objQuoteLine});
                                        }else{
                                            maplstQuoteLinesChild.get(strKey).add(objQuoteLine);
                                        } 
                                        boolVoice1_Country4 = true;
                                    }
                                    else if(objActivationServiceComp.Voice1_Country5__c != null && !boolVoice1_Country5){
                                        if(!maplstQuoteLinesChild.containsKey(strKey)){
                                            maplstQuoteLinesChild.put(strKey, New List<SBQQ__QuoteLine__c>{objQuoteLine});
                                        }else{
                                            maplstQuoteLinesChild.get(strKey).add(objQuoteLine);
                                        } 
                                        boolVoice1_Country5 = true;
                                    } 
                                    
                                }else if(objProductOption.SBQQ__Feature__r.Name.equalsIgnoreCase(strVirtualVoiceLine2Feature)){ 
                                    if(objActivationServiceComp.Voice2_Country1__c != null && !boolVoice2_Country1){
                                        if(!maplstQuoteLinesChild.containsKey(strKey)){
                                            maplstQuoteLinesChild.put(strKey, New List<SBQQ__QuoteLine__c>{objQuoteLine});
                                        }else{
                                            maplstQuoteLinesChild.get(strKey).add(objQuoteLine);
                                        } 
                                        boolVoice2_Country1 = true;
                                    }
                                    else if(objActivationServiceComp.Voice2_Country2__c != null && !boolVoice2_Country2){
                                        if(!maplstQuoteLinesChild.containsKey(strKey)){
                                            maplstQuoteLinesChild.put(strKey, New List<SBQQ__QuoteLine__c>{objQuoteLine});
                                        }else{
                                            maplstQuoteLinesChild.get(strKey).add(objQuoteLine);
                                        }  
                                        boolVoice2_Country2 = true;
                                    }
                                    else if(objActivationServiceComp.Voice2_Country3__c != null && !boolVoice2_Country3){
                                        if(!maplstQuoteLinesChild.containsKey(strKey)){
                                            maplstQuoteLinesChild.put(strKey, New List<SBQQ__QuoteLine__c>{objQuoteLine});
                                        }else{
                                            maplstQuoteLinesChild.get(strKey).add(objQuoteLine);
                                        }  
                                        boolVoice2_Country3 = true;
                                    }
                                    else if(objActivationServiceComp.Voice2_Country4__c != null && !boolVoice2_Country4){
                                        if(!maplstQuoteLinesChild.containsKey(strKey)){
                                            maplstQuoteLinesChild.put(strKey, New List<SBQQ__QuoteLine__c>{objQuoteLine});
                                        }else{
                                            maplstQuoteLinesChild.get(strKey).add(objQuoteLine);
                                        } 
                                        boolVoice2_Country4 = true;
                                    }
                                    else if(objActivationServiceComp.Voice2_Country5__c != null && !boolVoice2_Country5){
                                        if(!maplstQuoteLinesChild.containsKey(strKey)){
                                            maplstQuoteLinesChild.put(strKey, New List<SBQQ__QuoteLine__c>{objQuoteLine});
                                        }else{
                                            maplstQuoteLinesChild.get(strKey).add(objQuoteLine);
                                        } 
                                        boolVoice2_Country5 = true;
                                    }
                                }
                                i++;
                            }
                        }
                    }
                }
                // system.debug('maplstQuoteLinesChild'+maplstQuoteLinesChild.values());
                
                boolSuccesscheck = false;
                if(!maplstQuoteLinesParent.isEmpty()){
                    for(String strKey : maplstQuoteLinesParent.keySet()){
                        maplstQuoteLinesParent.get(strKey).SBQQ__Quote__c = objQuote.Id;
                    }
                    insert maplstQuoteLinesParent.values();
                    lstQuoteLinesChild.clear();
                    for(String strKey : maplstQuoteLinesChild.keySet()){    
                        for(SBQQ__QuoteLine__c objQuoteLine : maplstQuoteLinesChild.get(strKey)){
                            objQuoteLine.SBQQ__Quote__c = objQuote.Id;
                            objQuoteLine.SBQQ__RequiredBy__c = maplstQuoteLinesParent.get(strKey).Id;
                            lstQuoteLinesChild.add(objQuoteLine);
                        }  
                    }
                    if(lstQuoteLinesChild.size() > 0){
                        insert lstQuoteLinesChild;
                        boolSuccesscheck = true;
                        strQuoteId = objQuote.Id;
                    }else{
                        boolSuccesscheck = true;
                        strQuoteId = objQuote.Id;
                    }
                    
                }
                // system.debug('objQuote'+ objQuote);
            }catch(Exception E){
                system.debug('Exception'+ E);
            }
        }
        return null; //goToTab();
    }
    
    private Integer intCounter = 0;
    public PageReference incrementCounter() {
        intCounter++;
        for(SBQQ__Quote__c objQuote : [SELECT Id,SBQQ__Opportunity2__c,SBQQ__RegularAmount__c,SBQQ__CustomerAmount__c,
                                       SBQQ__ListAmount__c,SBQQ__NetAmount__c,CommBox_Option__c,Hub_Maintenance__c,
                                       SBQQ__Account__c,SBQQ__DeliveryMethod__c,SBQQ__PaymentTerms__c
                                       FROM SBQQ__Quote__c 
                                       WHERE Id =: strQuoteId AND SBQQ__NetAmount__c != 0 ]){
                                           boolSuccesscheck = false;
                                           retrieveQuoteLines(objQuote);
                                           //  system.debug('objQuote' + objQuote);
                                       }
        
        if(intCounter >= 5 && boolSuccesscheck){
            boolSuccesscheck = false;
            retrieveQuoteLines([SELECT Id,SBQQ__Opportunity2__c,SBQQ__RegularAmount__c,SBQQ__CustomerAmount__c,
                                SBQQ__ListAmount__c,SBQQ__NetAmount__c,CommBox_Option__c,Hub_Maintenance__c,
                                SBQQ__Account__c,SBQQ__DeliveryMethod__c,SBQQ__PaymentTerms__c
                                FROM SBQQ__Quote__c 
                                WHERE Id =: strQuoteId]);
        }
        
        return null;
    }   
    
    public pageReference retrieveQuoteLines(SBQQ__Quote__c objQuote){
        decOneTimeTotal = 0;
        decMonthlyTotal = 0;
        lstSBQQQuoteLines = New List<SBQQ__QuoteLine__c>();
        for(SBQQ__QuoteLine__c objQuoteLine : [SELECT Id,SBQQ__RequiredBy__c,Quantity_Online_Activation__c,Bill_Type__c,Discount_for_quote__c,SBQQ__Discount__c,SBQQ__CustomerPrice__c, Name,SBQQ__Product__r.Name,SBQQ__Product__c,SBQQ__Quantity__c ,SBQQ__OptionType__c ,SBQQ__Number__c,SBQQ__Description__c,SBQQ__ListPrice__c,SBQQ__NetTotal__c,SBQQ__CustomerTotal__c,SBQQ__TotalDiscountRate__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c =: objQuote.Id ORDER BY SBQQ__Number__c]){
            // system.debug('objQuoteLine' + objQuoteLine);
            decOneTimeTotal += (objQuoteLine.Bill_Type__c != null &&  objQuoteLine.Bill_Type__c != '' && objQuoteLine.Bill_Type__c.containsIgnoreCase('One-Time')) ? (objQuoteLine.SBQQ__CustomerPrice__c != null ? objQuoteLine.SBQQ__CustomerPrice__c : 0) : 0;
            decMonthlyTotal += (objQuoteLine.Bill_Type__c != null &&  objQuoteLine.Bill_Type__c != '' && objQuoteLine.Bill_Type__c.containsIgnoreCase('Monthly')) ? (objQuoteLine.SBQQ__CustomerPrice__c != null ? objQuoteLine.SBQQ__CustomerPrice__c : 0) : 0;
            lstSBQQQuoteLines.add(objQuoteLine);
        }
        return null;
    }
    
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   12/08/2016
* @description          :   goToTab Method.
*                           To Reload current page
* @return               :   pageReference
* @invoke               :   (onclick) From Vf component And from selectedProductBundle Method
**/
    public pageReference goToTab(){
        pageReference returnPage = page.Services;      //unfortunately, this returns the whole view state!
        ActivationStatus.Active_Page__c = 'Subscriptions';
        ActivationStatus.Services_Page__c = 'available';
        ActivationStatus.Services_Active_Tab__c = 'Plan_Types';
        ActivationStatus.Services_Type_Last_Active_Tab_Index__c =1;
        ActivationStatus.OneCare_Last_Active_Tab_Index__c = 1;
        ActivationStatus.OneCare_Page__c = 'Inhibited';
        ActivationStatus.Contract_Details_Page__c = 'Inhibited';
        ActivationStatus.Contract_Details_Last_Active_Tab_Index__c = 1;
        ActivationStatus.Activate_Page__c = 'Inhibited';
        update ActivationStatus;
        returnPage.getParameters().clear();                         //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActivationOrderId); //add the order ID
        returnPage.setRedirect(true);                               //this causes the constructors to run again...
        return returnPage;
    }
    
    
    public pagereference orderValidationDealer(){
        orderUpdate();
        objActivationOrder.Order_Status__c = 'Pending Customer Confirmation';
        update objActivationOrder;
        Activation_Platform__c objActivationPlatform = New Activation_Platform__c();
        for(Activation_Platform__c objActivationPlatformTemp : objActivationOrder.Activation_Platforms__r){
            objActivationPlatform = objActivationPlatformTemp;
        }
        
        Act_Subscriber_component_controller objActSubscribercomponentcontroller = New Act_Subscriber_component_controller();
        Boolean BoolIsError = objActSubscribercomponentcontroller.callfromOtherPage(objActivationPlatform, true);
        if(BoolIsError){
            return objActSubscribercomponentcontroller.selfRegistrationException('showError', 'userFail'); //Maybe this is another tailored page.....
        }
        
        ActivationStatus.Active_Page__c = 'Account Setup';
        ActivationStatus.Account_Setup_page__c  = 'inhibited';
        ActivationStatus.Installation_Type_Page__c  = 'inhibited';
        ActivationStatus.System_Page__c  = 'inhibited';
        ActivationStatus.First_Review_Page__c = 'inhibited';
        ActivationStatus.Services_Page__c = 'inhibited';
        ActivationStatus.OneCare_Page__c = 'inhibited';
        ActivationStatus.Contract_Details_Page__c = 'inhibited';
        ActivationStatus.Activate_Page__c = 'inhibited';
        update ActivationStatus;
        
        pageReference returnPage = page.Activation_ThankYou;      //unfortunately, this returns the whole view state!
        returnPage.getParameters().clear();                         //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActivationOrderId); //add the order ID
        returnPage.setRedirect(true);                               //this causes the constructors to run again...
        return returnPage;
        //return null;
    }
    
    public void orderUpdate(){
        Activation_Hardware__c objActivationHardwareSystem = New Activation_Hardware__c();
        List<Activation_Hardware__c> lstActivationHardwareIntegrated = New List<Activation_Hardware__c>();
        for(Activation_Hardware__c objActivationHardwareTemp : objActivationOrder.Activation_Hardware__r){
            if(objActivationHardwareTemp.RecordTypeId == strActivationHardwareRecordTypeIdSystem){
                objActivationHardwareSystem = objActivationHardwareTemp;
            }else if(objActivationHardwareTemp.RecordTypeId == strActivationHardwareRecordTypeIdIntegrated){
                lstActivationHardwareIntegrated.add(objActivationHardwareTemp);
            }
        }
        if((objActivationOrder.Hardware_Purchased_or_Leased__c == 'Leased' && objActivationOrder.Lease_Contract__c == null) || objActivationHardwareSystem.Do_Not_Know_Serial_Number__c == true || (objActivationServiceComp.Special_Instructions__c != '' && objActivationServiceComp.Special_Instructions__c != null) || lstActivationHardwareIntegrated.size() >0 || (objActivationServiceComp.Additional_Comments__c != null && objActivationServiceComp.Additional_Comments__c != '') ){
            objActivationOrder.Airtime_Services_to_Review_Order__c = true;
        }
        else{
            objActivationOrder.Airtime_Services_to_Review_Order__c = false;
        }
        
        for(SBQQ__Quote__c objQuote : [SELECT Id,SBQQ__Status__c,SBQQ__Primary__c
                                       FROM SBQQ__Quote__c 
                                       WHERE Id =: strQuoteId ]){
                                           objQuote.SBQQ__Status__c = 'In Review';
                                           // objQuote.SBQQ__Primary__c = true;
                                           // Only one record for sure, so doing update here
                                           update objQuote;
                                       } 
        
    }
    
    public pagereference orderValidation(){
        pageReference returnPage = page.Activation_ThankYou;      //unfortunately, this returns the whole view state!
        orderUpdate();
        objActivationOrder.Order_Status__c = 'Submitted';
        update objActivationOrder;
        ActivationStatus.Active_Page__c = 'Thank You';
        ActivationStatus.Account_Setup_page__c  = 'complete';
        ActivationStatus.Installation_Type_Page__c  = 'complete';
        ActivationStatus.System_Page__c  = 'complete';
        ActivationStatus.First_Review_Page__c = 'complete';
        ActivationStatus.Services_Page__c = 'complete';
        ActivationStatus.OneCare_Page__c = 'complete';
        ActivationStatus.Contract_Details_Page__c = 'complete';
        ActivationStatus.Activate_Page__c = 'complete';
        update ActivationStatus;
        
        returnPage.getParameters().clear();                         //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActivationOrderId); //add the order ID
        returnPage.setRedirect(true);                               //this causes the constructors to run again...
        return returnPage;
    }
}