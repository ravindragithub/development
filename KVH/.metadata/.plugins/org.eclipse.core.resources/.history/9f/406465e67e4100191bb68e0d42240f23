/**
* @createdby        :   Teertha Prasad
* @createddate      :	02/03/2017
* @last modifiedby  :   Teertha prasad
* @last modifieddate:  	02/06/2017
* @description      :   Class Used In Services Page for Selecting the Product (Shown as table) 
*                       and update Activation Service and upsert Quote and QLI (CPQ).
**/

public without sharing class Act_CustomRateplanTable_Comp_Ctrl extends ActivationsBaseController {
    public Activation_Service__c objActivationServiceComp	{get; set;}
    public String strSelectedCustomRatePlanAccount; // very important to pass vf component "attribute" value to controller 
    public String strSelectedProductName 					{get; set;} // Used to get selected value from Component
    
    public void setstrSelectedCustomRatePlanAccount(String SelectedRatePlanAccount){
        if(strSelectedCustomRatePlanAccount == null){
            strSelectedCustomRatePlanAccount = SelectedRatePlanAccount;
            ActivationOrderId = ApexPages.currentPage().getParameters().get('order');    //extract Order Id
            system.debug('SelectedRatePlanAccount' + SelectedRatePlanAccount);
            loadDynamicRatePlanTable();
        }
    } 
    
    public String getstrSelectedCustomRatePlanAccount(){
        return strSelectedCustomRatePlanAccount; 
    }
    
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   02/06/2017
* @description          :   updateActivationServiceValueRate Method.
*                           Upsert Activation Service
* @return               :   pageReference
* @invoke               :   From action method of Vf component
**/
    public pageReference updateActivationServiceValueRate(){
        if(objActivationServiceComp != null){
            objActivationServiceComp.Is_Selected__c = true;
            objActivationServiceComp.Activation_Rate_Plan__c = '';
            objActivationServiceComp.Product__c = strSelectedProductName;
            upsert objActivationServiceComp;
        }
        return null;
    }
    
    
    
    public List<wrapDynamicRatePlanTableMaster> lstwrapDynamicRatePlanTableMaster {get;set;}
    
    /** Constructor - Start **/
    public Act_CustomRateplanTable_Comp_Ctrl(){
        lstwrapDynamicRatePlanTableMaster = New List<wrapDynamicRatePlanTableMaster>(); 
    }
    /** Constructor - End **/
    
    public class wrapDynamicRatePlanTable{
        public String strPlanProductId {get; set;}
        public String strPlanProductName {get; set;}
        public String strPlanProductDescription {get; set;}
        public String strPlanProductPrice {get; set;}
        public Boolean boolIsSelectedProduct {get; set;}
    } 
    
    public class wrapDynamicRatePlanTableMaster{
        public String strFeatureName {get; set;}
        public List<wrapDynamicRatePlanTable> lstwrapDynamicRatePlanTable {get; set;}
    } 
    
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   02/06/2017
* @description          :   loadDynamicRatePlanTable Method.
*                           To load current selected product bundle data records.
* 							Will create Wrapper data as well as MAP data
* @return               :   void
* @invoke               :   From setstrSelectedCustomRatePlanAccount Method onload
**/
    public void loadDynamicRatePlanTable(){
        Map<Id, SBQQ__ContractedPrice__c> mapContractedPrices = New Map<Id, SBQQ__ContractedPrice__c>();
        if(strSelectedCustomRatePlanAccount != null){
            for(SBQQ__ContractedPrice__c objSBQQContractedPrices : [SELECT Id, Name, SBQQ__Price__c, SBQQ__Product__c, SBQQ__Product__r.Name, SBQQ__Description__c FROM SBQQ__ContractedPrice__c WHERE SBQQ__Account__c =: strSelectedCustomRatePlanAccount AND Contracted_Price_Type__c = 'Custom Rate Plan']){
                mapContractedPrices.put(objSBQQContractedPrices.SBQQ__Product__c, objSBQQContractedPrices);
            }
            
            String strProductbundleId = Activation_Product_Bundle__c.getValues('Customer Specific Rate Plans').Product_Bundle_Id__c;

            lstwrapDynamicRatePlanTableMaster = New List<wrapDynamicRatePlanTableMaster>(); 
            
            Map<Id, Set<Id>> mapFeaturesSetProducts = New Map<Id, Set<Id>>();
            Map<Id, String> mapProductOptionsFeatureName = New Map<Id, String>();
            
            for(SBQQ__ProductOption__c objProductOption : [SELECT Id, SBQQ__OptionalSKU__c, SBQQ__Feature__c,SBQQ__Feature__r.Name FROM SBQQ__ProductOption__c WHERE SBQQ__OptionalSKU__c IN: mapContractedPrices.keySet() AND SBQQ__ConfiguredSKU__c =: strProductbundleId ORDER BY SBQQ__Number__c]){ //  AND SBQQ__ConfiguredSKU__c =: '01t1b0000007UnG' AND SBQQ__Feature__c =: 'a6Z1b000000Cbm9''a6Z1b000000Cblz'
                if(!mapFeaturesSetProducts.containsKey(objProductOption.SBQQ__Feature__c)){
                    mapFeaturesSetProducts.put(objProductOption.SBQQ__Feature__c, New Set<Id>{objProductOption.SBQQ__OptionalSKU__c});
                }else{
                    mapFeaturesSetProducts.get(objProductOption.SBQQ__Feature__c).add(objProductOption.SBQQ__OptionalSKU__c); 
                }
                mapProductOptionsFeatureName.put(objProductOption.SBQQ__Feature__c, objProductOption.SBQQ__Feature__r.Name);
            }
            
            system.debug('mapFeaturesSetProducts' + mapFeaturesSetProducts);
            system.debug('mapContractedPrices' + mapContractedPrices);
            
            for(String strKeyFeature : mapFeaturesSetProducts.keySet()){
                wrapDynamicRatePlanTableMaster objwrapDynamicRatePlanTableMaster= New wrapDynamicRatePlanTableMaster();
                List<wrapDynamicRatePlanTable> lstwrapDynamicRatePlanTables = New List<wrapDynamicRatePlanTable>();
                objwrapDynamicRatePlanTableMaster.strFeatureName = (!mapProductOptionsFeatureName.isEmpty() ? mapProductOptionsFeatureName.get(strKeyFeature) : '');
                for(String strKeyProduct : mapFeaturesSetProducts.get(strKeyFeature)){
                    if(!mapContractedPrices.isEmpty() && mapContractedPrices.containsKey(strKeyProduct)){
                        wrapDynamicRatePlanTable objwrapDynamicRatePlanTable = New wrapDynamicRatePlanTable();
                        objwrapDynamicRatePlanTable.strPlanProductName = mapContractedPrices.get(strKeyProduct).SBQQ__Product__r.Name;
                        objwrapDynamicRatePlanTable.strPlanProductId = strKeyProduct;
                        objwrapDynamicRatePlanTable.strPlanProductDescription = mapContractedPrices.get(strKeyProduct).SBQQ__Description__c;
                        objwrapDynamicRatePlanTable.strPlanProductPrice = mapContractedPrices.get(strKeyProduct).SBQQ__Price__c != Null ? ('$'+string.valueOf(mapContractedPrices.get(strKeyProduct).SBQQ__Price__c)) : '$ 0';
                        objwrapDynamicRatePlanTable.boolIsSelectedProduct = (objActivationServiceComp.Product__c == mapContractedPrices.get(strKeyProduct).SBQQ__Product__c ? true : false );
                        lstwrapDynamicRatePlanTables.add(objwrapDynamicRatePlanTable);
                    }
                    objwrapDynamicRatePlanTableMaster.lstwrapDynamicRatePlanTable = lstwrapDynamicRatePlanTables;
                }
                lstwrapDynamicRatePlanTableMaster.add(objwrapDynamicRatePlanTableMaster);
                
            }
            system.debug('lstwrapDynamicRatePlanTableMaster' + lstwrapDynamicRatePlanTableMaster);
        }
    }
    
}