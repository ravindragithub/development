public class Act_Individual_Plan_Table_Controller{
    
    public List<wrapDynamicRatePlanTableMaster> lstwrapDynamicRatePlanTableMaster {get;set;}
    
    public Activation_Service__c objActivationService	{get; set;}
    public  List<String>  stIndividualBundles ;

// keys to validate NEWSlink whether to include or not for Independent plans
    private Static String strV7 = 'V7';
    private Static String strV3 = 'V3';
    private Static String strV11 = 'V11';
    private Static String strPremium = 'Premium';
    private Static String strNEWSlink = 'NEWSlink';
    private Static String strSPORTSlink = 'SPORTSlink';
    private Static String strNEWSlinkTV = 'NEWSlink TV';
    private Static String strMarket = 'Leisure';
    private Static String strChartered = 'Yes';
     private String strCommercialMarket = 'Commercial/SATCOM, TV & Network Mgmt'; //'Commercial';
    private String strMaritimeMarketSector = 'Maritime';

    
    // One-time Activation Fee feature for Operations Data Services
    private Static String strFeatureNameAct = 'Activation Fee';
    
    public void setstIndividualBundles(List<String> IndividualBundles){
        //if(stIndividualBundles == null){
        //   system.debug('IndividualBundles' + IndividualBundles);
        stIndividualBundles = IndividualBundles;
        loadDynamicRatePlanTableEntertainment();
        // }
    } 
    
    public List<String> getstIndividualBundles(){
        return stIndividualBundles; 
    }
    
    
    /** Constructor - Start **/
    public Act_Individual_Plan_Table_Controller(){
        lstwrapDynamicRatePlanTableMaster = New List<wrapDynamicRatePlanTableMaster>(); 
    }
    /** Constructor - End **/
    
    public class wrapDynamicRatePlanTable{
        public String strPlanProductId {get; set;}
        public String strPlanProductName {get; set;}
        public String strPlanProductDescription {get; set;}
        public String strPlanProductPrice {get; set;}
        public String strSelectedActivationFee {get; set;}
        public Boolean boolIsSelectedProduct {get; set;}
    } 
    
    public class wrapDynamicRatePlanTableMaster{
        public String strMainProductName {get; set;}
        public String strFeatureName {get; set;}
        public List<wrapDynamicRatePlanTable> lstwrapDynamicRatePlanTable {get; set;}
    } 
    
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   10/27/2016
* @description          :   loadDynamicRatePlanTableEntertainment Method.
*                           To load current selected product bundle data records.
*                           Will create Wrapper data
* @return               :   void
* @invoke               :   From setobjActivationService Method onload
**/
    public void loadDynamicRatePlanTableEntertainment(){
        if(stIndividualBundles != null){
            Boolean boolrenderSuperOnly = false;
            Boolean boolrenderBonzeOnly = false;
            List<Activation_Order__c> lstActivationOrder = New List<Activation_Order__c>();
            lstActivationOrder= [SELECT Id,Contract_Term__c,Hardware_Purchased_or_Leased__c,Activation_Opportunity__c,Activation_Opportunity__r.AccountId,
                                 (SELECT Id, Name,Confirm_if_boat_yacht_is_chartered__c, Activation_Order__c, Market__c, Market_Sector__c,Platform_Detail__c,
                                  Flag__c,Vessel_Radio_Call_Sign__c,Vessel_IMO__c,Vessel_Length_ft_m__c,Vehicle_Model__c,
                                  Industry_Designation__c,MMSI__c,Vehicle_Make_Model__c,Vehicle_Year__c,Having_IMO__c
                                  FROM Activation_Platforms__r)
                                 FROM Activation_Order__c 
                                 WHERE Id=: objActivationService.Activation_Order__c LIMIT 1];
            
            if(lstActivationOrder.size()>0){
                List<Activation_Platform__c> lstActivationPlatform = New List<Activation_Platform__c>();
                lstActivationPlatform = lstActivationOrder[0].Activation_Platforms__r;
                if(lstActivationPlatform.size()>0){
                    if(lstActivationPlatform[0].Confirm_if_boat_yacht_is_chartered__c == strChartered && lstActivationPlatform[0].Market__c != null && lstActivationPlatform[0].Market__c.containsIgnoreCase(strMarket) && objActivationService.VSAT_Antenna_Hardware__c != '' && objActivationService.VSAT_Antenna_Hardware__c != null && (objActivationService.VSAT_Antenna_Hardware__c.containsIgnoreCase(strV11) || objActivationService.VSAT_Antenna_Hardware__c.containsIgnoreCase(strV7))) {
                        boolrenderSuperOnly = true;
                    }
                    else if(lstActivationPlatform[0] != null && lstActivationPlatform[0].Market__c != null && lstActivationPlatform[0].Market__c.containsIgnoreCase(strCommercialMarket) && lstActivationPlatform[0].Market_Sector__c !=null && lstActivationPlatform[0].Market_Sector__c.containsIgnoreCase(strMaritimeMarketSector) && objActivationService.VSAT_Antenna_Hardware__c != null && objActivationService.VSAT_Antenna_Hardware__c.containsIgnoreCase(strV3)){
                        boolrenderBonzeOnly = true;  
                    }
                }
            }
            
            Map<String, String> mapProductOptionsFeatureName = New Map<String, String>();
            Map<String, List<SBQQ__ProductOption__c>> mapProductOptionsFeature = New Map<String, List<SBQQ__ProductOption__c>>();
            Map<String, SBQQ__ProductOption__c> mapProductOptionsFeatureInner = New Map<String, SBQQ__ProductOption__c>();
            
            Set<String> strOptionalSKUProduct = New Set<String>();
            Set<String> strOptionalSKUProductInner = New Set<String>();
            Map<String, SBQQ__ProductOption__c> mapProductBundles = New Map<String, SBQQ__ProductOption__c>();

            for(SBQQ__ProductOption__c objProductOption : [SELECT Id, Name,Option_Description__c,SBQQ__ConfiguredSKU__r.Name,SBQQ__Bundled__c, SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c, SBQQ__Feature__c, SBQQ__OptionalSKU__r.Name,SBQQ__OptionalSKU__r.VSAT_Antenna_Hardware__c, SBQQ__OptionalSKU__r.Service_Description__c,SBQQ__OptionalSKU__r.RecordType.Name,SBQQ__Feature__r.Name, SBQQ__OptionalSKU__r.Amount_Free__c FROM SBQQ__ProductOption__c WHERE SBQQ__ConfiguredSKU__c != null AND SBQQ__Feature__c =: stIndividualBundles ORDER BY SBQQ__Number__c]){
                mapProductBundles.put(objProductOption.SBQQ__ConfiguredSKU__c, objProductOption);
                strOptionalSKUProduct.add(objProductOption.SBQQ__OptionalSKU__c);
                strOptionalSKUProductInner.add(objProductOption.SBQQ__OptionalSKU__c);
                String strTempKey = objProductOption.SBQQ__ConfiguredSKU__c + '@@' + objProductOption.SBQQ__Feature__c;
                if((!objProductOption.SBQQ__Feature__r.Name.containsIgnoreCase(strNEWSlink) && boolrenderBonzeOnly && !objProductOption.SBQQ__Feature__r.Name.containsIgnoreCase(strSPORTSlink)) || (!objProductOption.SBQQ__Feature__r.Name.containsIgnoreCase(strNEWSlink) && boolrenderSuperOnly) || (!boolrenderSuperOnly && !boolrenderBonzeOnly) || (objProductOption.SBQQ__Feature__r.Name.containsIgnoreCase(strNEWSlink) && objProductOption.SBQQ__OptionalSKU__r.Name.containsIgnoreCase(strNEWSlinkTV) && !objProductOption.SBQQ__OptionalSKU__r.Name.containsIgnoreCase(strPremium) && boolrenderSuperOnly) || (objProductOption.SBQQ__Feature__r.Name.containsIgnoreCase(strNEWSlink) && !objProductOption.SBQQ__OptionalSKU__r.Name.containsIgnoreCase(strNEWSlinkTV) && boolrenderBonzeOnly)){
                    if(!mapProductOptionsFeature.containsKey(strTempKey)){
                        mapProductOptionsFeature.put(strTempKey, New List<SBQQ__ProductOption__c>{objProductOption});
                    }else{
                        List<SBQQ__ProductOption__c> lstProductFeatures = mapProductOptionsFeature.get(strTempKey);
                        lstProductFeatures.add(objProductOption);
                        mapProductOptionsFeature.put(strTempKey, lstProductFeatures);
                    }
                }
                mapProductOptionsFeatureName.put(objProductOption.SBQQ__Feature__c, objProductOption.SBQQ__Feature__r.Name);
                
            }
            
            for(SBQQ__ProductOption__c objProductOption : [SELECT Id, Name,Option_Description__c,SBQQ__ConfiguredSKU__r.Name,SBQQ__Bundled__c, SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c, SBQQ__Feature__c, SBQQ__OptionalSKU__r.Name,SBQQ__OptionalSKU__r.VSAT_Antenna_Hardware__c, SBQQ__OptionalSKU__r.Service_Description__c,SBQQ__OptionalSKU__r.RecordType.Name,SBQQ__Feature__r.Name, SBQQ__OptionalSKU__r.Amount_Free__c FROM SBQQ__ProductOption__c WHERE SBQQ__ConfiguredSKU__c IN: strOptionalSKUProductInner AND SBQQ__Feature__c != null  AND SBQQ__Feature__r.Name =: strFeatureNameAct ORDER BY SBQQ__Number__c]){
                strOptionalSKUProduct.add(objProductOption.SBQQ__OptionalSKU__c);
                String strTempKey = objProductOption.SBQQ__ConfiguredSKU__c;
                if(!mapProductOptionsFeatureInner.containsKey(strTempKey)){
                    mapProductOptionsFeatureInner.put(strTempKey, objProductOption);
                }
            }
            
            Map<String, PricebookEntry> mapPricebookEntryProduct = New Map<String, PricebookEntry>();
            for(PricebookEntry objPricebookEntry : [SELECT ID,Product2Id, Product2.Name, UnitPrice FROM PricebookEntry WHERE Product2Id IN: strOptionalSKUProduct AND IsActive = true]){
                if(!mapPricebookEntryProduct.containsKey(objPricebookEntry.Product2Id) && objPricebookEntry.UnitPrice != 0){
                    mapPricebookEntryProduct.put(objPricebookEntry.Product2Id, objPricebookEntry);
                }
            }
            
            lstwrapDynamicRatePlanTableMaster = New List<wrapDynamicRatePlanTableMaster>(); 
            
            for(String strKey : mapProductBundles.keySet()){
                for(String strKeyFeature : mapProductOptionsFeature.keySet()){
                    String[] strKeyFeatureTempSplit  = strKeyFeature.split('@@');
                    if(strKeyFeatureTempSplit.size()>1 && strKeyFeatureTempSplit[0] == strKey){
                        wrapDynamicRatePlanTableMaster objwrapDynamicRatePlanTableMaster= New wrapDynamicRatePlanTableMaster();
                        List<wrapDynamicRatePlanTable> lstwrapDynamicRatePlanTables = New List<wrapDynamicRatePlanTable>();
                        objwrapDynamicRatePlanTableMaster.strMainProductName = mapProductBundles.get(strKey).SBQQ__ConfiguredSKU__r.Name;
                        objwrapDynamicRatePlanTableMaster.strFeatureName = (!mapProductOptionsFeatureName.isEmpty() ? mapProductOptionsFeatureName.get(strKeyFeatureTempSplit[1]) : '');
                        for(SBQQ__ProductOption__c objProductOption : mapProductOptionsFeature.get(strKeyFeature)){
                            wrapDynamicRatePlanTable objwrapDynamicRatePlanTable = New wrapDynamicRatePlanTable();
                            objwrapDynamicRatePlanTable.strPlanProductName = objProductOption.SBQQ__OptionalSKU__r.Name;
                            objwrapDynamicRatePlanTable.strPlanProductId = objProductOption.SBQQ__OptionalSKU__c;
                            objwrapDynamicRatePlanTable.strPlanProductDescription = (objProductOption.SBQQ__OptionalSKU__r.Service_Description__c != null ? String.valueOf(objProductOption.SBQQ__OptionalSKU__r.Service_Description__c) : '');
                            objwrapDynamicRatePlanTable.strPlanProductPrice = ((!mapProductOptionsFeatureInner.isEmpty() && mapProductOptionsFeatureInner.get(objProductOption.SBQQ__OptionalSKU__c) != null && mapProductOptionsFeatureInner.get(objProductOption.SBQQ__OptionalSKU__c).SBQQ__OptionalSKU__c != null && !mapPricebookEntryProduct.isEmpty() && mapPricebookEntryProduct.get(mapProductOptionsFeatureInner.get(objProductOption.SBQQ__OptionalSKU__c).SBQQ__OptionalSKU__c) != null) ? '$'+ mapPricebookEntryProduct.get(mapProductOptionsFeatureInner.get(objProductOption.SBQQ__OptionalSKU__c).SBQQ__OptionalSKU__c).UnitPrice : '$'+'0');
                            objwrapDynamicRatePlanTable.strSelectedActivationFee = ((!mapPricebookEntryProduct.isEmpty() && mapPricebookEntryProduct.get(objProductOption.SBQQ__OptionalSKU__c) != null) ? '$'+ mapPricebookEntryProduct.get(objProductOption.SBQQ__OptionalSKU__c).UnitPrice : '$'+'0');
                            objwrapDynamicRatePlanTable.boolIsSelectedProduct = (objActivationService.Independent_Entertainment_Channels__c != null && objActivationService.Independent_Entertainment_Channels__c != '' && objActivationService.Independent_Entertainment_Channels__c.Contains(objProductOption.SBQQ__OptionalSKU__c) ? true : (objActivationService.Special_Event_Channels__c != null && objActivationService.Special_Event_Channels__c != '' && objActivationService.Special_Event_Channels__c.Contains(objProductOption.SBQQ__OptionalSKU__c) ? true : (objActivationService.Training_Packages__c != null && objActivationService.Training_Packages__c != '' && objActivationService.Training_Packages__c.Contains(objProductOption.SBQQ__OptionalSKU__c) ? true : (objActivationService.Operations_Data_Services__c != null && objActivationService.Operations_Data_Services__c != '' && objActivationService.Operations_Data_Services__c.Contains(objProductOption.SBQQ__OptionalSKU__c) ? true : false ))));
                            lstwrapDynamicRatePlanTables.add(objwrapDynamicRatePlanTable);
                        }
                        objwrapDynamicRatePlanTableMaster.lstwrapDynamicRatePlanTable = lstwrapDynamicRatePlanTables;
                        lstwrapDynamicRatePlanTableMaster.add(objwrapDynamicRatePlanTableMaster);
                    }
                }
            }
        }
    }
}