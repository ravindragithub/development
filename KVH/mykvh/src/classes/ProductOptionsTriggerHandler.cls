public with sharing class ProductOptionsTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI = false;
    
    public ProductOptionsTriggerHandler (boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    public void OnBeforeInsert(List<SBQQ__ProductOption__c> newsObjectList) {
        getProductDetails(newsObjectList);
    }
    public void OnBeforeUpdate( List<SBQQ__ProductOption__c> newsObjectList, List<SBQQ__ProductOption__c> oldsObjectList, Map<ID, SBQQ__ProductOption__c> newsObjectMap , Map<ID, SBQQ__ProductOption__c> oldsObjectMap ) {
        getProductDetails(newsObjectList);
    }
    
    public void getProductDetails( List<SBQQ__ProductOption__c> newsObjectList) {
        set<string> configIds = new set<string>();
        set<string> optionIds = new set<string>();
        set<string> featureIds = new set<string>();
        if (newsObjectList.size() > 0) {
            for (SBQQ__ProductOption__c temp : newsObjectList) {
                if (temp.get('SBQQ__ConfiguredSKU__c') != null)
                    configIds.add(string.valueOf(temp.get('SBQQ__ConfiguredSKU__c')));
                if (temp.get('SBQQ__OptionalSKU__c') != null)
                    optionIds.add(string.valueOf(temp.get('SBQQ__OptionalSKU__c')));
                if (temp.get('SBQQ__Feature__c') != null)
                    featureIds.add(string.valueOf(temp.get('SBQQ__Feature__c')));
            }
        }
        Map<Id, Product2> configProduct = new Map<Id, Product2>([Select Id, Catalog_Display_Name__c, Catalog_Long_Description__c, Display_Product__c, IsActive From Product2 Where Id = : configIds]);
        Map<Id, Product2> optionProduct = new Map<Id, Product2>([Select Id, Catalog_Display_Name__c, Catalog_Long_Description__c, Display_Product__c, IsActive From Product2 Where Id = : optionIds]);
        Map<Id, SBQQ__ProductFeature__c> optionfeature = new Map<Id, SBQQ__ProductFeature__c>([Select Id, Name From SBQQ__ProductFeature__c Where Id = : featureIds]);
        for (SBQQ__ProductOption__c temp : newsObjectList) {
            if (configProduct.containsKey(temp.SBQQ__ConfiguredSKU__c) ) {
                temp.Configured_Sku_Catalog_Display_Name__c = configProduct.get(temp.SBQQ__ConfiguredSKU__c).Catalog_Display_Name__c;
                temp.Configured_Sku_Catalog_Long_Description__c = configProduct.get(temp.SBQQ__ConfiguredSKU__c).Catalog_Long_Description__c;
                temp.Configured_Sku_Display_Product__c = configProduct.get(temp.SBQQ__ConfiguredSKU__c).Display_Product__c;
                temp.Configured_Sku_IsActive__c = configProduct.get(temp.SBQQ__ConfiguredSKU__c).IsActive;
            } else {
                temp.Configured_Sku_Catalog_Display_Name__c = '';
                temp.Configured_Sku_Catalog_Long_Description__c = '';
                temp.Configured_Sku_Display_Product__c = 'No';
                temp.Configured_Sku_IsActive__c = false;
            }
            if (optionProduct.containsKey(temp.SBQQ__OptionalSKU__c)) {
                temp.Optional_Sku_Catalog_Display_Name__c = optionProduct.get(temp.SBQQ__OptionalSKU__c).Catalog_Display_Name__c;
                temp.Optional_Sku_Catalog_Long_Description__c = optionProduct.get(temp.SBQQ__OptionalSKU__c).Catalog_Long_Description__c;
                temp.Optional_Sku_Display_Product__c = optionProduct.get(temp.SBQQ__OptionalSKU__c).Display_Product__c;
                temp.Optional_Sku_IsActive__c = optionProduct.get(temp.SBQQ__OptionalSKU__c).IsActive;
            } else {
                temp.Optional_Sku_Catalog_Display_Name__c = '';
                temp.Optional_Sku_Catalog_Long_Description__c = '';
                temp.Optional_Sku_Display_Product__c = 'No';
                temp.Optional_Sku_IsActive__c = false;
            }
            if (optionfeature.containsKey(temp.SBQQ__Feature__c)) {
                temp.Feature_Name__c = optionfeature.get(temp.SBQQ__Feature__c).Name;
            } else {
                temp.Feature_Name__c = '';
            }
        }
    }
}