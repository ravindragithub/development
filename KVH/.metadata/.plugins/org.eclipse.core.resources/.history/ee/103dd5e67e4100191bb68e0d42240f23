public class Act_Entertainment_Programming_Ctrl{
    
    private static String   strCustomSettingType    =   'Entertainment Viewing Option';
    private static String   strCustomSettingMoreThan100     =   'More than 100';
    private static String   strContactKVH   =   'KVH will contact for pricing';
    //private static String strIntegratedType =  'IP-MobileCast Media Server';
    public List<wrapDynamicMediaRatePlanTable> lstwrapDynamicMediaRatePlanTable {get; set;} 
    public Activation_Service__c objActivationService ;
    public Activation_Hardware__c objActivationHardware  {get; set;}
    public Activation_Platform__c objActivationPlatform {get; set;}
    private String strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Media Hardware').getRecordTypeId();

    public String strPlanName  {get; set;}
    private static String   strPlanFeature  =   'Commercial - Entertainment and News Packages';
    public String strFeatureIds     {get; set;} 
    
    private Static String strV7 = 'V7';
    private Static String strV11 = 'V11';
    private Static String strMarket = 'Leisure';
    private Static String strChartered = 'Yes';

    
    public List<String> setIndividualBundles {
        get { 
            List<String> lstTemp = New List<String>();
            String strProductbundleId = Activation_Product_Bundle__c.getValues('Entertainment Packages').Product_Bundle_Id__c;
            for(SBQQ__ProductFeature__c objProductFeature : [SELECT Id,Name FROM SBQQ__ProductFeature__c WHERE SBQQ__ConfiguredSKU__c =: strProductbundleId AND Name =: 'Training Package' ORDER BY SBQQ__Number__c]){
                lstTemp.add(objProductFeature.Id);
            }
            return lstTemp;
        } 
        set;
    }
    
    public void setobjActivationService(Activation_Service__c ActivationService){
        if(objActivationService == null){ 
            objActivationService = ActivationService;
            strPlanName = 'Entertainment Packages';            
            objActivationPlatform = New Activation_Platform__c();
            objActivationHardware = New Activation_Hardware__c();
            objActivationHardware.RecordTypeId = strActivationHardwareRecordTypeId;
            objActivationHardware.Activation_Order__c = ActivationService.Activation_Order__c;
            //objActivationHardware.Integrated_Product_Type__c = strIntegratedType;

            List<Activation_Order__c> lstActivationOrder = New List<Activation_Order__c>();
            lstActivationOrder= [SELECT Id,Contract_Term__c,Hardware_Purchased_or_Leased__c,Activation_Opportunity__c,Activation_Opportunity__r.AccountId,
                                 (SELECT Id, Name,Confirm_if_boat_yacht_is_chartered__c, Activation_Order__c, Market__c, Market_Sector__c,Platform_Detail__c,
                                  Flag__c,Vessel_Radio_Call_Sign__c,Vessel_IMO__c,Vessel_Length_ft_m__c,Vehicle_Model__c,
                                  Industry_Designation__c,MMSI__c,Vehicle_Make_Model__c,Vehicle_Year__c,Having_IMO__c
                                  FROM Activation_Platforms__r),
                                 (SELECT Id, Integrated_Product_Type__c,Below_Decks_Serial_Number__c, Below_Decks_Root_Asset__c, Root_Asset_Product_Group__c, System_Detail__c, System_Name__c 
                                  FROM Activation_Hardware__r WHERE RecordTypeId =: strActivationHardwareRecordTypeId ) //AND Integrated_Product_Type__c =: strIntegratedType
                                 FROM Activation_Order__c 
                                 WHERE Id=: ActivationService.Activation_Order__c LIMIT 1];
            
            if(lstActivationOrder.size()>0){
                List<Activation_Platform__c> lstActivationPlatform = New List<Activation_Platform__c>();
                lstActivationPlatform = lstActivationOrder[0].Activation_Platforms__r;
                if(lstActivationPlatform.size()>0){
                    objActivationPlatform = lstActivationPlatform[0];
                    if(lstActivationPlatform[0].Confirm_if_boat_yacht_is_chartered__c == strChartered && lstActivationPlatform[0].Market__c != null && lstActivationPlatform[0].Market__c.containsIgnoreCase(strMarket) && objActivationService.VSAT_Antenna_Hardware__c != '' && objActivationService.VSAT_Antenna_Hardware__c != null && (objActivationService.VSAT_Antenna_Hardware__c.containsIgnoreCase(strV11) || objActivationService.VSAT_Antenna_Hardware__c.containsIgnoreCase(strV7))) {
                        strPlanFeature = 'Leisure - Entertainment and News Package';
                        strPlanName = 'Entertainment Core Packages';
                    }
                }
                List<Activation_Hardware__c> lstActivationHardware = New List<Activation_Hardware__c>();
                lstActivationHardware =  lstActivationOrder[0].Activation_Hardware__r;
                if(lstActivationHardware.size()>0){
                    objActivationHardware = lstActivationHardware[0];
                }
            }
            
            String strProductbundleId = Activation_Product_Bundle__c.getValues(strPlanName).Product_Bundle_Id__c;
            for(SBQQ__ProductFeature__c objProductFeature : [SELECT Id,Name FROM SBQQ__ProductFeature__c WHERE SBQQ__ConfiguredSKU__c =: strProductbundleId AND Name =: strPlanFeature ORDER BY SBQQ__Number__c]){
                strFeatureIds = (strFeatureIds == null ? String.valueOf(objProductFeature.Id) : (strFeatureIds + '@@' + String.valueOf(objProductFeature.Id)));
            }
            strFeatureIds = strFeatureIds != null ? strFeatureIds.removeEnd('@@') : strFeatureIds;
        }
        loadDynamicMediaRatePlan();
    }
    
    public Activation_Service__c getobjActivationService(){
        return objActivationService; 
    }
    
    
    /** Constructor - Start **/
    public Act_Entertainment_Programming_Ctrl(){
    }
    /** Constructor - End **/
    
    public class wrapDynamicMediaRatePlanTable{
        public String strPlanProductId {get; set;}
        public String strPlanProductName {get; set;}
        public String strPlanProductPrice {get; set;}
        public Boolean boolIsSelectedProduct {get; set;}
    } 
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   09/20/2016
* @description          :   updateActivationServiceValueEnter Method.
*                           Upsert Activation Service
* @return               :   void
* @invoke               :   From action method of Vf page
**/
    public pagereference updateActivationServiceValueEnter(){
        Map<String, Asset> mapAssets = New Map<String, Asset>();
        String strQuery = 'SELECT Id,Name,Item__c,Product2Id,Product2.Markets__c from Asset WHERE ';
        strQuery +=  objActivationHardware.Below_Decks_Serial_Number__c !='' ? ' (Name = \''+objActivationService.Media_Server_Serial_Number__c + '\' OR Name = \''+ objActivationHardware.Below_Decks_Serial_Number__c + '\' ) ' : ' Name = \''+ objActivationService.Media_Server_Serial_Number__c +'\'' ;
        
        for(Asset objAsset : Database.query(strQuery)){
            mapAssets.put(objAsset.Name, objAsset);
        }
        
        objActivationService.Media_Server__c = !mapAssets.isEmpty() && mapAssets.containsKey(objActivationService.Media_Server_Serial_Number__c) ? mapAssets.get(objActivationService.Media_Server_Serial_Number__c).Id : null;
        objActivationHardware.Antenna_Serial_Number__c = objActivationService.Media_Server_Serial_Number__c;
        objActivationHardware.Do_Not_Know_Serial_Number__c = (objActivationService.Media_Server_Serial_Number__c == '' || mapAssets.isEmpty() || !mapAssets.containsKey(objActivationService.Media_Server_Serial_Number__c)) ? true : false;
        objActivationHardware.Antenna_Root_Asset__c = !mapAssets.isEmpty() && mapAssets.containsKey(objActivationService.Media_Server_Serial_Number__c) ? mapAssets.get(objActivationService.Media_Server_Serial_Number__c).Id : null;
        objActivationHardware.Below_Decks_Root_Asset__c = !mapAssets.isEmpty() && mapAssets.containsKey(objActivationHardware.Below_Decks_Serial_Number__c) ? mapAssets.get(objActivationHardware.Below_Decks_Serial_Number__c).Id : null;
        objActivationHardware.Root_Assets_Do_NOT_Match__c = objActivationHardware.Below_Decks_Root_Asset__c == objActivationHardware.Antenna_Root_Asset__c ? false : true ;
        update objActivationService;
        upsert objActivationHardware;
        return null;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   11/21/2016
* @description          :   loadDynamicMediaRatePlan Method.
*                           To load current selected product bundle data records.
*                           Will create Wrapper data as well as MAP data
* @return               :   void
* @invoke               :   From setobjActivationService Method onload
**/
    public void loadDynamicMediaRatePlan(){
        lstwrapDynamicMediaRatePlanTable = New List<wrapDynamicMediaRatePlanTable>();
        List<Activation_Product_Bundle__c> lstActivationProductBundle = Activation_Product_Bundle__c.getall().values();
        Map<String, Activation_Product_Bundle__c> mapMediaProductCustomsetting = New Map<String, Activation_Product_Bundle__c>();
        Set<String> setMediaProductIds = New Set<String>();
        for(Activation_Product_Bundle__c objActivationProductBundle : lstActivationProductBundle){
            if(objActivationProductBundle.Where_Used__c == strCustomSettingType){
            if(objActivationProductBundle.Product_Bundle_Id__c.startsWith(Product2.sobjectType.getDescribe().getKeyPrefix())){
                setMediaProductIds.add(objActivationProductBundle.Product_Bundle_Id__c);
            }
            mapMediaProductCustomsetting.put(objActivationProductBundle.Name,objActivationProductBundle);
        }
        }
        
        Map<String, PricebookEntry> mapPricebookEntryProduct = New Map<String, PricebookEntry>();
        for(PricebookEntry objPricebookEntry : [SELECT ID,Product2Id, Product2.Name, UnitPrice FROM PricebookEntry WHERE Product2Id IN: setMediaProductIds AND IsActive = true]){
            if(!mapPricebookEntryProduct.containsKey(objPricebookEntry.Product2Id) && objPricebookEntry.UnitPrice != 0){
                mapPricebookEntryProduct.put(objPricebookEntry.Product2Id, objPricebookEntry);
            }
        }
        
        for(Schema.PicklistEntry objPickList : Activation_Service__c.Viewing_Options__c.getDescribe().getPicklistValues()) {
            if(!mapMediaProductCustomsetting.isEmpty() && mapMediaProductCustomsetting.containsKey(objPickList.getValue()) &&  mapMediaProductCustomsetting.get(objPickList.getValue()) != null){
                wrapDynamicMediaRatePlanTable objwrapDynamicMediaRatePlanTable = New wrapDynamicMediaRatePlanTable();
                String strProductId = mapMediaProductCustomsetting.get(objPickList.getValue()).Product_Bundle_Id__c.startsWith(Product2.sobjectType.getDescribe().getKeyPrefix()) ? mapMediaProductCustomsetting.get(objPickList.getValue()).Product_Bundle_Id__c : '';
                objwrapDynamicMediaRatePlanTable.strPlanProductId = strProductId;
                objwrapDynamicMediaRatePlanTable.strPlanProductName = objPickList.getValue();
                objwrapDynamicMediaRatePlanTable.strPlanProductPrice = (objPickList.getValue().containsIgnoreCase(strCustomSettingMoreThan100) ? strContactKVH  : (!mapPricebookEntryProduct.isEmpty() && mapPricebookEntryProduct.containsKey(strProductId) ? '$ '+mapPricebookEntryProduct.get(strProductId).UnitPrice : '-'));
                objwrapDynamicMediaRatePlanTable.boolIsSelectedProduct = (objActivationService.Viewing_Options__c != null && objActivationService.Viewing_Options__c.equalsIgnoreCase(objPickList.getValue()) ? true : false);
                lstwrapDynamicMediaRatePlanTable.add(objwrapDynamicMediaRatePlanTable);
            }
        } 
    }
    
    
}