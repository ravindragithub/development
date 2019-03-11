/**
* @createdby        :   Teertha Prasad
* @createddate      :	09/18/2016
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   04/10/2017
* @description      :   Class Used In Services Page for Selecting the Product (Shown as table) 
*                       and update Activation Service and upsert Quote and QLI (CPQ).
**/

public class Act_RateplanTable_Component_Ctrl extends ActivationsBaseController {
    
    public List<wrapDynamicRatePlanTable> lstwrapDynamicRatePlanTables {get;set;} 
    public wrapDynamicRatePlanTableMasterColumn objwrapDynamicRatePlanTableMasterColumn {get;set;}
    
    private String FeatureDataRate = 'Data Rate';
    private String FeatureIridiumDataRate = 'Iridium Data Rate';
    private String FeatureData = 'Data';
    private String strIridiumProductPlans = 'Iridium Rate Plans';
    private String strCommercialMarket = 'Commercial/SATCOM, TV & Network Mgmt'; //'Commercial';
    private String strMaritimeMarketSector = 'Maritime';
    private String strBronzePackage = 'Bronze Package';
    
    public String 			strSelectedProductName 			{get; set;} // Used to get selected value from Component
    public String 			strSelectedRatePlanTemp 		{get; set;}
    public String 			strSelectedPlanTypeTab 			{get; set;}
    public Activation_Service__c objActivationServiceComp	{get; set;}
    public String strSelectedProductBundle 					{get; set;}
    public Activation_Platform__c objActivationPlatform  {get;set;}
    
    // keys to validate GSM modem whether to include as a row for metered plans
    private Static String strIridium = 'Iridium';
    private Static String strV3 = 'V3';
    private Static String strGSMModem = 'GSM Modem';
    
    public String strSelectedRatePlan; // very important to pass vf component "attribute" value to controller 
    
    public void setstrSelectedRatePlan(String SelectedRatePlan){
        if(strSelectedRatePlan == null){
            strSelectedRatePlan = SelectedRatePlan;
            ActivationOrderId = ApexPages.currentPage().getParameters().get('order');    //extract Order Id
            loadDynamicRatePlanTable();
        }
    } 
    
    public String getstrSelectedRatePlan(){
        return strSelectedRatePlan; 
    }
    
    
    /** Constructor - Start **/
    public Act_RateplanTable_Component_Ctrl(){
    }
    /** Constructor - End **/
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   09/20/2016
* @description          :   updateActivationServiceValue Method.
*                           Upsert Activation Service
* @return               :   pageReference
* @invoke               :   From action method of Vf component
**/
    public pageReference updateActivationServiceValueRate(){
        if(objActivationServiceComp != null){
            objActivationServiceComp.Is_Selected__c = true;
            objActivationServiceComp.Activation_Rate_Plan__c = strSelectedRatePlanTemp;
            if(strSelectedRatePlanTemp != '' && strSelectedRatePlanTemp != null && strSelectedRatePlanTemp.containsIgnoreCase('Flex')){
                objActivationServiceComp.Entertainment_Programming_Product__c = null;
                objActivationServiceComp.Entertainment_Programming_Selected__c = false;
                objActivationServiceComp.Independent_Entertainment_Channels__c = '';
                objActivationServiceComp.Media_Server__c = null;
                objActivationServiceComp.Media_Server_Serial_Number__c = '';
                objActivationServiceComp.Operations_Data_Services__c = '';
                objActivationServiceComp.Special_Event_Channels__c = '';
                objActivationServiceComp.Viewing_Option_Product__c = null;
                objActivationServiceComp.Viewing_Options__c = '';
                objActivationServiceComp.Training_Packages__c = '';
            }
            objActivationServiceComp.Product__c = strSelectedProductName;
            upsert objActivationServiceComp;
        }
        return null;
    }
    
    public class wrapDynamicRatePlanTable{
        public String strPlanProduct {get; set;}
        public String strSelectedRatePlan {get; set;}
        public String strPlanProductId {get; set;}
        public Map<String, String> mapEachPlan {get; set;}
    } 
    
    public class wrapDynamicRatePlanTableMasterColumn{
        public List<String> setPlanNames {get; set;}
    } 
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   11/08/2016
* @description          :   loadDynamicRatePlanTable Method.
*                           To load current selected product bundle data records.
* 							Will create Wrapper data as well as MAP data
* @return               :   void
* @invoke               :   From setstrSelectedRatePlan Method onload
**/
    public void loadDynamicRatePlanTable(){
        if(strSelectedRatePlan != null){
            objActivationPlatform = New Activation_Platform__c();
            Activation_Order__c objActivationOrder = New Activation_Order__c();
            List<Activation_Order__c> lstActivationOrder = New List<Activation_Order__c>();
            lstActivationOrder= [SELECT Id,Contract_Term__c,Hardware_Purchased_or_Leased__c,Activation_Opportunity__c,Activation_Opportunity__r.AccountId,
                                 (SELECT Id, Name,Confirm_if_boat_yacht_is_chartered__c, Activation_Order__c, Market__c, Market_Sector__c,Platform_Detail__c,
                                  Flag__c,Vessel_Radio_Call_Sign__c,Vessel_IMO__c,Vessel_Length_ft_m__c,Vehicle_Model__c,
                                  Industry_Designation__c,MMSI__c,Vehicle_Make_Model__c,Vehicle_Year__c,Having_IMO__c
                                  FROM Activation_Platforms__r)
                                 FROM Activation_Order__c 
                                 WHERE Id=:ActivationOrderId LIMIT 1];
            
            if(lstActivationOrder.size()>0){
                objActivationOrder = lstActivationOrder[0];
                List<Activation_Platform__c> lstActivationPlatform = New List<Activation_Platform__c>();
                lstActivationPlatform = objActivationOrder.Activation_Platforms__r;
                if(lstActivationPlatform.size()>0){
                    objActivationPlatform = lstActivationPlatform[0];
                }
            }
        
            Set<String> setFeatureIds = New Set<String>();
            strSelectedProductBundle = (strSelectedProductBundle != null && strSelectedProductBundle != '' ? strSelectedProductBundle : objActivationServiceComp.Activation_Plan_Type__c);
            setFeatureIds.addAll(strSelectedRatePlan.split('@@'));
            Map<String, SBQQ__ProductOption__c> mapProductOptionsMain = New Map<String, SBQQ__ProductOption__c>();
            Map<String, List<SBQQ__ProductOption__c>> mapProductOptionsFeature = New Map<String, List<SBQQ__ProductOption__c>>();
            String strProductbundleId = Activation_Product_Bundle__c.getValues(strSelectedProductBundle).Product_Bundle_Id__c;
            Set<String> strOptionalSKUProduct = New Set<String>();
            
            String strQuery = 'SELECT Id, Name,SBQQ__Feature__r.Name, SBQQ__MinQuantity__c, SBQQ__ConfiguredSKU__c,SBQQ__Bundled__c, SBQQ__OptionalSKU__c,SBQQ__OptionalSKU__r.RecordType.Name, SBQQ__OptionalSKU__r.Name, SBQQ__OptionalSKU__r.Amount_Free__c  FROM SBQQ__ProductOption__c WHERE SBQQ__OptionalSKU__c != null AND SBQQ__ConfiguredSKU__c != null AND SBQQ__ConfiguredSKU__c =: strProductbundleId AND SBQQ__Feature__c != null AND SBQQ__Feature__c IN: setFeatureIds ';
            if(objActivationPlatform != null && objActivationPlatform.Market__c != null && objActivationPlatform.Market__c.containsIgnoreCase(strCommercialMarket) && objActivationPlatform.Market_Sector__c != null && objActivationPlatform.Market_Sector__c.containsIgnoreCase(strMaritimeMarketSector) && objActivationServiceComp.VSAT_Antenna_Hardware__c != null && objActivationServiceComp.VSAT_Antenna_Hardware__c.containsIgnoreCase(strV3) && strSelectedPlanTypeTab != null && strSelectedPlanTypeTab.containsIgnoreCase('Entertainment')){
                String strFilter = Activation_Product_Bundle__c.getValues(strBronzePackage).Product_Bundle_Id__c;
                strQuery += ' AND SBQQ__OptionalSKU__c =: strFilter ';
            }
            strQuery += ' ORDER BY SBQQ__Number__c ';
            
            for(SBQQ__ProductOption__c objProductOption : Database.query(strQuery)){ 
                strOptionalSKUProduct.add(objProductOption.SBQQ__OptionalSKU__c);
                 if(strSelectedProductBundle == strIridiumProductPlans && objProductOption.SBQQ__MinQuantity__c != 12 && objActivationOrder.Hardware_Purchased_or_Leased__c == 'Leased'){
                    mapProductOptionsMain.put(objProductOption.SBQQ__OptionalSKU__c, objProductOption);
                }else if((strSelectedProductBundle == strIridiumProductPlans && objActivationOrder.Hardware_Purchased_or_Leased__c == 'Purchased') || strSelectedProductBundle != strIridiumProductPlans){
                    mapProductOptionsMain.put(objProductOption.SBQQ__OptionalSKU__c, objProductOption);
                }
            }
            
            Set<Id> setFilterDataRateFeature = New Set<Id>();
            Set<Id> setFilterDataRateFeatureProduct = New Set<Id>();
            for(SBQQ__ProductOption__c objProductOption : [SELECT Id, Name,Option_Description__c,SBQQ__ConfiguredSKU__r.Name,SBQQ__Bundled__c, SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c, SBQQ__Feature__c, SBQQ__OptionalSKU__r.Name,SBQQ__OptionalSKU__r.VSAT_Antenna_Hardware__c, SBQQ__OptionalSKU__r.Service_Description__c,SBQQ__OptionalSKU__r.RecordType.Name,SBQQ__Feature__r.Name, SBQQ__OptionalSKU__r.Amount_Free__c, SBQQ__Required__c, SBQQ__Selected__c  FROM SBQQ__ProductOption__c WHERE SBQQ__ConfiguredSKU__c IN: strOptionalSKUProduct AND SBQQ__Feature__c != null ORDER BY SBQQ__Number__c]){
                strOptionalSKUProduct.add(objProductOption.SBQQ__OptionalSKU__c);
                String strTempKey = objProductOption.SBQQ__ConfiguredSKU__c + '@@' + objProductOption.SBQQ__Feature__c;
                if(!mapProductOptionsFeature.containsKey(strTempKey)){
                    mapProductOptionsFeature.put(strTempKey, New List<SBQQ__ProductOption__c>{objProductOption});
                }else{
                    List<SBQQ__ProductOption__c> lstProductFeatures = mapProductOptionsFeature.get(strTempKey);
                    lstProductFeatures.add(objProductOption);
                    mapProductOptionsFeature.put(strTempKey, lstProductFeatures);
                }
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

            Map<String, PricebookEntry> mapPricebookEntryProduct = New Map<String, PricebookEntry>();
            for(PricebookEntry objPricebookEntry : [SELECT ID,Product2Id, Product2.Name, UnitPrice FROM PricebookEntry WHERE Product2Id IN: strOptionalSKUProduct AND IsActive = true]){
                if(!mapPricebookEntryProduct.containsKey(objPricebookEntry.Product2Id) && objPricebookEntry.UnitPrice != 0){
                    mapPricebookEntryProduct.put(objPricebookEntry.Product2Id, objPricebookEntry);
                }
            }
            lstwrapDynamicRatePlanTables = New  List<wrapDynamicRatePlanTable>();
            objwrapDynamicRatePlanTableMasterColumn = New wrapDynamicRatePlanTableMasterColumn();
            
            List<Activation_Rate_Plan_Table__c> lstActivationRatePlanTables = New List<Activation_Rate_Plan_Table__c>();
            lstActivationRatePlanTables = Activation_Rate_Plan_Table__c.getAll().values();
            List<String> lstOrders = New List<String>();
            Map<String, Activation_Rate_Plan_Table__c> mapActivationRatePlanTable = New Map<String, Activation_Rate_Plan_Table__c>();
            
            Map<String, String> mapEachPlanTemplate = New Map<String, String>();
            
            for(Activation_Rate_Plan_Table__c objActivationRatePlanTable : lstActivationRatePlanTables){
                if(strSelectedProductBundle != null && objActivationRatePlanTable.Plan_Type__c != null && objActivationRatePlanTable.Plan_Type__c.ContainsIgnoreCase(strSelectedProductBundle) && objActivationServiceComp.VSAT_Antenna_Hardware__c != null && (!objActivationServiceComp.VSAT_Antenna_Hardware__c.containsIgnoreCase(strV3) || objActivationRatePlanTable.OptionalSKU_Name__c == null ||  (objActivationServiceComp.VSAT_Antenna_Hardware__c.containsIgnoreCase(strV3) && objActivationServiceComp.VSAT_Antenna_Hardware__c.containsIgnoreCase(strIridium)) || (objActivationServiceComp.VSAT_Antenna_Hardware__c.containsIgnoreCase(strV3) && !objActivationServiceComp.VSAT_Antenna_Hardware__c.containsIgnoreCase(strIridium) && objActivationRatePlanTable.OptionalSKU_Name__c != null && !objActivationRatePlanTable.OptionalSKU_Name__c.containsIgnoreCase(strGSMModem)))){
                    mapActivationRatePlanTable.put(String.valueOf(objActivationRatePlanTable.Order__c), objActivationRatePlanTable);
                    lstOrders.add(String.valueOf(objActivationRatePlanTable.Order__c));
                    mapEachPlanTemplate.put(objActivationRatePlanTable.Name, '');
                }
            }
            lstOrders.sort();
            List<String> lstMeteredPlanNames = New List<String>();
            for(String strKey : lstOrders){
                lstMeteredPlanNames.add(mapActivationRatePlanTable.get(strKey).Name);
            }
            
            objwrapDynamicRatePlanTableMasterColumn.setPlanNames =  lstMeteredPlanNames;
            
            for(String strKey : mapProductOptionsMain.keySet()){
                wrapDynamicRatePlanTable objwrapDynamicRatePlanTable = New wrapDynamicRatePlanTable();
                objwrapDynamicRatePlanTable.strPlanProduct = mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__r.Name;
                objwrapDynamicRatePlanTable.strSelectedRatePlan = mapProductOptionsMain.get(strKey).SBQQ__Feature__r.Name;
                objwrapDynamicRatePlanTable.strPlanProductId = mapProductOptionsMain.get(strKey).SBQQ__OptionalSKU__c;
                Map<String, String> mapEachPlan1 = mapEachPlanTemplate.Clone();
                
                for(String strKeyFeature : mapProductOptionsFeature.keySet()){
                    String[] strKeyFeatureTempSplit  = strKeyFeature.split('@@');
                    if(strKeyFeatureTempSplit.size()>1 && strKeyFeatureTempSplit[0] == strKey){
                        for(SBQQ__ProductOption__c objProductOption : mapProductOptionsFeature.get(strKeyFeature)){
                            for(String strKeyMainRow : mapEachPlan1.keySet()){
                                if(strSelectedProductBundle != null && Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Plan_Type__c != null && Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Plan_Type__c.ContainsIgnoreCase(strSelectedProductBundle)){
                                    if(Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Feature_Name__c == null || (Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Feature_Name__c != null && objProductOption.SBQQ__Feature__r.Name.ContainsIgnoreCase(Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Feature_Name__c))){
                                        if((Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).OptionalSKU_Name__c == null || objProductOption.SBQQ__OptionalSKU__r.Name.trim().containsIgnoreCase(Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).OptionalSKU_Name__c.trim())) && Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Map_Value_Type__c != null){
                                            if(Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Map_Value_Type__c.trim().equalsIgnoreCase('Price')){
                                                if(Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Feature_Name__c == null){
                                                    mapEachPlan1.put(strKeyMainRow, ((!mapPricebookEntryProduct.isEmpty() && mapPricebookEntryProduct.get(strKey) != null) ? '$'+ mapPricebookEntryProduct.get(strKey).UnitPrice : '$'+'0'));
                                                }else{
                                                    mapEachPlan1.put(strKeyMainRow, ((!mapPricebookEntryProduct.isEmpty() && mapPricebookEntryProduct.get(objProductOption.SBQQ__OptionalSKU__c) != null) ? '$'+ mapPricebookEntryProduct.get(objProductOption.SBQQ__OptionalSKU__c).UnitPrice : '$'+'0'));
                                                }
                                            }else if(Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Map_Value_Type__c.trim().equalsIgnoreCase('Other')){
                                                if(objProductOption.SBQQ__Feature__c != null && Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Feature_Name__c != null  && ((objProductOption.SBQQ__Feature__r.Name.trim().equalsIgnoreCase(FeatureDataRate) && Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Feature_Name__c.trim().equalsIgnoreCase(FeatureDataRate)) || (objProductOption.SBQQ__Feature__r.Name.trim().equalsIgnoreCase(FeatureIridiumDataRate) && Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Feature_Name__c.trim().equalsIgnoreCase(FeatureIridiumDataRate)))){
                                                    Set<String> setVSAT = New Set<String>();
                                                    setVSAT.addAll((objProductOption.SBQQ__OptionalSKU__r.VSAT_Antenna_Hardware__c != null ? objProductOption.SBQQ__OptionalSKU__r.VSAT_Antenna_Hardware__c.trim().split(';') : New List<String>{null}));
                                                    for(String strVSATKEY : setVSAT){
                                                        if(strVSATKEY == objActivationServiceComp.VSAT_Antenna_Hardware__c && !setFilterDataRateFeature.isEmpty() && setFilterDataRateFeature.contains(objProductOption.SBQQ__OptionalSKU__c)){
                                                            mapEachPlan1.put(strKeyMainRow,(objProductOption.SBQQ__OptionalSKU__r.Service_Description__c != null ? String.valueOf(objProductOption.SBQQ__OptionalSKU__r.Service_Description__c) : ''));  
                                                        }
                                                    }
                                                }else if(objProductOption.SBQQ__Feature__c != null && objProductOption.SBQQ__Feature__r.Name.trim().equalsIgnoreCase(FeatureData) && Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Feature_Name__c != null && Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Feature_Name__c.trim().equalsIgnoreCase(FeatureData)){
                                                    mapEachPlan1.put(strKeyMainRow, (objProductOption.SBQQ__OptionalSKU__r.Amount_Free__c != null ? String.valueOf(objProductOption.SBQQ__OptionalSKU__r.Amount_Free__c) : '0'));
                                                }
                                            }else if(Activation_Rate_Plan_Table__c.getValues(strKeyMainRow).Map_Value_Type__c.trim().equalsIgnoreCase('Entertainment')){
                                                mapEachPlan1.put(strKeyMainRow, (objProductOption.Option_Description__c != null ? String.valueOf(objProductOption.Option_Description__c) : ' - '));
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
                objwrapDynamicRatePlanTable.mapEachPlan = mapEachPlan1;
                lstwrapDynamicRatePlanTables.add(objwrapDynamicRatePlanTable);
            }
        }
    }
    
}