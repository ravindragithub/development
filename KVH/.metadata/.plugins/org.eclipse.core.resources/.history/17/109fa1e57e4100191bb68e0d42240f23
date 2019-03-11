public class Act_CommBox_Component_Controller{
    
    public List<SelectOption> lstSelectOptionEnterprise {get; set;} 
    public Activation_Service__c objActivationService ;
    private static String 	strPlanName 	=	'CommBox Bundles';
    private static String 	strHubFeature 	=	'%Hub%';
    private Map<String, String> mapHubEnterpriseProducts {get; set;} 
    public String strFeatureIds 	{get; set;} 
    public String 			strSelectedProductName 			{get; set;} // Used to get selected value from Component
    public String 			strSelectedRatePlanTemp 		{get; set;} 
    public Boolean 			boolHubShow		{get; set;}
    
    public void setobjActivationService(Activation_Service__c ActivationService){
        if(objActivationService == null){ 
            objActivationService = ActivationService;
            String strProductbundleId = Activation_Product_Bundle__c.getValues(strPlanName).Product_Bundle_Id__c;
            for(SBQQ__ProductFeature__c objProductFeature : [SELECT Id,Name FROM SBQQ__ProductFeature__c WHERE SBQQ__ConfiguredSKU__c =: strProductbundleId ORDER BY SBQQ__Number__c]){
                strFeatureIds = (strFeatureIds == null ? String.valueOf(objProductFeature.Id) : (strFeatureIds + '@@' + String.valueOf(objProductFeature.Id)));
            }
            strFeatureIds = strFeatureIds.removeEnd('@@');
            if(objActivationService != null && objActivationService.CommBox_Product__c != null && objActivationService.CommBox_Product__r.Name.containsIgnoreCase('Enterprise')){
                boolHubShow = true;
                loadDynamicRatePlanTableHub();
            }
        }
    }
    
    public Activation_Service__c getobjActivationService(){
        return objActivationService; 
    }
    
    
    /** Constructor - Start **/
    public Act_CommBox_Component_Controller(){
        boolHubShow = false;
    }
    /** Constructor - End **/
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   11/08/2016
* @description          :   updateActivationService Method.
*                           Upsert Activation Service
* @return               :   void
* @invoke               :   From action method of Vf page
**/
    public pagereference updateActivationService(){
        objActivationService.CommBox_Selected__c = true;
        update objActivationService; 
        return null;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   09/20/2016
* @description          :   clearActivationService Method.
*                           Upsert Activation Service
* @return               :   void
* @invoke               :   From action method of Vf page
**/
    public pagereference clearActivationService(){
        objActivationService.CommBox_Selected__c = false;
        objActivationService.CommBox_Product__c = null;
        objActivationService.CommBox_Hub_Hosting_Id__c = null;
        boolHubShow = false;
        update objActivationService; 
        return null;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   09/20/2016
* @description          :   updateActivationServiceValue Method.
*                           update Activation Service
* @return               :   pageReference
* @invoke               :   From action method of Vf component
**/
    public pageReference updateActivationServiceValueCommBox(){
        boolHubShow = false;
        If(objActivationService != null){
            objActivationService.CommBox_Product__c = strSelectedProductName;
            if(strSelectedRatePlanTemp.containsIgnoreCase('Enterprise')){
                loadDynamicRatePlanTableHub();
                boolHubShow = true;
            }
            objActivationService.CommBox_Selected__c = false;
            objActivationService.CommBox_Hub_Hosting_Id__c = null; 
            update objActivationService;
        }
        return null;
    }
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   09/20/2016
* @description          :   updateActivationServiceValue Method.
*                           Upsert Activation Service
* @return               :   pageReference
* @invoke               :   From action method of Vf component
**/
    public pageReference updateActivationServiceValueHub(){
        boolHubShow = true; 
        If(objActivationService != null){
            update objActivationService;
        }
        return null;
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
    public void loadDynamicRatePlanTableHub(){
        mapHubEnterpriseProducts = New Map<String, String>();
        Map<String, SBQQ__ProductOption__c> mapProductOptionsMainHub = New Map<String, SBQQ__ProductOption__c>();
        Map<String, List<SBQQ__ProductOption__c>> mapProductOptionsFeatureHub = New Map<String, List<SBQQ__ProductOption__c>>();
        Set<String> strOptionalSKUProductHub = New Set<String>();
        for(SBQQ__ProductOption__c objProductOption : [SELECT Id, Name,SBQQ__Feature__r.Name, SBQQ__ConfiguredSKU__c,SBQQ__Bundled__c, SBQQ__OptionalSKU__c,SBQQ__OptionalSKU__r.RecordType.Name, SBQQ__OptionalSKU__r.Name, SBQQ__OptionalSKU__r.Amount_Free__c FROM SBQQ__ProductOption__c WHERE SBQQ__OptionalSKU__c != null AND SBQQ__ConfiguredSKU__c != null  AND SBQQ__ConfiguredSKU__c =: objActivationService.CommBox_Product__c AND SBQQ__Feature__r.Name LIKE: strHubFeature ORDER BY SBQQ__Number__c]){
            strOptionalSKUProductHub.add(objProductOption.SBQQ__OptionalSKU__c);
            mapProductOptionsMainHub.put(objProductOption.SBQQ__OptionalSKU__c, objProductOption);
            String strTempKey = objProductOption.SBQQ__OptionalSKU__c + '@@' + objProductOption.SBQQ__Feature__c;
            if(!mapProductOptionsFeatureHub.containsKey(strTempKey)){
                mapProductOptionsFeatureHub.put(strTempKey, New List<SBQQ__ProductOption__c>{objProductOption});
            }else{
                List<SBQQ__ProductOption__c> lstProductFeatures = mapProductOptionsFeatureHub.get(strTempKey);
                lstProductFeatures.add(objProductOption);
                mapProductOptionsFeatureHub.put(strTempKey, lstProductFeatures);
            }
        }
        
        Map<String, PricebookEntry> mapPricebookEntryProductHub = New Map<String, PricebookEntry>();
        for(PricebookEntry objPricebookEntry : [SELECT ID,Product2Id, Product2.Name, UnitPrice FROM PricebookEntry WHERE Product2Id IN: strOptionalSKUProductHub AND IsActive = true]){
            if(!mapPricebookEntryProductHub.containsKey(objPricebookEntry.Product2Id) && objPricebookEntry.UnitPrice != 0){
                mapPricebookEntryProductHub.put(objPricebookEntry.Product2Id, objPricebookEntry);
            }
        }

        Map<String, String> mapEachPlanHub = New Map<String, String>();
        for(String strKey : mapProductOptionsMainHub.keySet()){
            for(String strKeyFeature : mapProductOptionsFeatureHub.keySet()){
                for(SBQQ__ProductOption__c objProductOption : mapProductOptionsFeatureHub.get(strKeyFeature)){
                    mapHubEnterpriseProducts.put(mapProductOptionsMainHub.get(strKey).SBQQ__OptionalSKU__r.Name, strKey);
                    mapEachPlanHub.put(strKey +'@@'+mapProductOptionsMainHub.get(strKey).SBQQ__OptionalSKU__r.Name, ((!mapPricebookEntryProductHub.isEmpty() && mapPricebookEntryProductHub.get(strKey) != null) ? '$'+ mapPricebookEntryProductHub.get(strKey).UnitPrice : '$'+'0'));
                }
            }
        }
        
        lstSelectOptionEnterprise = New List<SelectOption>();
        for(String strKey : mapEachPlanHub.keySet()){
            String[] strsplitId = strKey.split('@@');
            if(strsplitId.size()>1){
                lstSelectOptionEnterprise.add(New SelectOption(strsplitId[0] , (strsplitId[1].containsIgnoreCase('Private') ? 'Private Hub - '+ mapEachPlanHub.get(strKey) + '/month' : 'KVH-hosted Hub - ' + mapEachPlanHub.get(strKey) + '/month')));
            }
        }    
    }
    
}