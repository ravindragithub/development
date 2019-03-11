public with sharing class ProductFeatureTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI = false;

    public ProductFeatureTriggerHandler (boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    public void OnBeforeInsert(List<SBQQ__ProductFeature__c> newsObjectList) {
        getProductDetails(newsObjectList);
    }
    public void OnBeforeUpdate( List<SBQQ__ProductFeature__c> newsObjectList, List<SBQQ__ProductFeature__c> oldsObjectList, Map<ID, SBQQ__ProductFeature__c> newsObjectMap , Map<ID, SBQQ__ProductFeature__c> oldsObjectMap ) {
        getProductDetails(newsObjectList);
    }
    public void OnAfterUpdate( List<SBQQ__ProductFeature__c> newsObjectList, List<SBQQ__ProductFeature__c> oldsObjectList, Map<ID, SBQQ__ProductFeature__c> newsObjectMap , Map<ID, SBQQ__ProductFeature__c> oldsObjectMap ) {
        changeChildProductDetails(newsObjectMap, oldsObjectMap);
    }
    public void OnBeforeDelete(Map<ID, SBQQ__ProductFeature__c > oldsObjectMap) {
        deleteChildProductDetails(oldsObjectMap);
    }

    //Method to update product Feature fields on creation/ update of feature
    public void getProductDetails( List<SBQQ__ProductFeature__c> newsObjectList) {
        set<string> configIds = new set<string>();
        if (newsObjectList.size() > 0) {
            for (SBQQ__ProductFeature__c temp : newsObjectList) {
                if (temp.get('SBQQ__ConfiguredSKU__c') != null)
                    configIds.add(string.valueOf(temp.get('SBQQ__ConfiguredSKU__c')));
            }
        }
        Map<Id, Product2> configProduct = new Map<Id, Product2>([Select Id, Catalog_Display_Name__c, Catalog_Long_Description__c, Display_Product__c, IsActive From Product2 Where Id = : configIds]);
        for (SBQQ__ProductFeature__c temp : newsObjectList) {
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
        }
    }

    //Method to update the Child Product option list on Product feature update
    public void changeChildProductDetails( Map<ID, SBQQ__ProductFeature__c > newsObjectMap , Map<ID, SBQQ__ProductFeature__c > oldsObjectMap ) {
        Set<Id> prodfeatureIds = new Set<Id>();
        List<SBQQ__ProductOption__c> listUpdateProdOpt = new List<SBQQ__ProductOption__c>();

        for (Id productId : newsObjectMap.keyset())
            prodfeatureIds.add(productId);
        List<SBQQ__ProductFeature__c> listExistingProduct = new List<SBQQ__ProductFeature__c>([Select Id, Name,
                (Select Id, Name, SBQQ__Feature__c, Feature_Name__c From SBQQ__ProductOptions__r) From SBQQ__ProductFeature__c Where Id = : prodfeatureIds]);
        for (SBQQ__ProductFeature__c temp : listExistingProduct) {
            for (SBQQ__ProductOption__c tempChild : temp.SBQQ__ProductOptions__r) {
                if (
                    oldsObjectMap.containskey(tempChild.SBQQ__Feature__c)
                ) {
                    tempChild.Feature_Name__c = temp.Name;
                } else {
                    tempChild.Feature_Name__c = '';
                    tempChild.SBQQ__Feature__c = null;
                }
                listUpdateProdOpt.add(tempChild);
            }
        }
        if (listUpdateProdOpt.size() > 0)
            update listUpdateProdOpt;
    }

    //Method to delete the Child Product option list on Product feature update
    public void deleteChildProductDetails( Map<ID, SBQQ__ProductFeature__c > oldsObjectMap ) {
        Set<Id> prodfeatureIds = new Set<Id>();
        List<SBQQ__ProductOption__c> listUpdateProdOpt = new List<SBQQ__ProductOption__c>();

        for (Id productId : oldsObjectMap.keyset())
            prodfeatureIds.add(productId);
        List<SBQQ__ProductFeature__c> listExistingProduct = new List<SBQQ__ProductFeature__c>([Select Id, Name,
                (Select Id, Name, SBQQ__Feature__c, Feature_Name__c From SBQQ__ProductOptions__r) From SBQQ__ProductFeature__c Where Id = : prodfeatureIds]);
        for (SBQQ__ProductFeature__c temp : listExistingProduct) {
            for (SBQQ__ProductOption__c tempChild : temp.SBQQ__ProductOptions__r) {
                tempChild.SBQQ__Feature__c = null;
                listUpdateProdOpt.add(tempChild);
            }
        }
        if (listUpdateProdOpt.size() > 0)
            update listUpdateProdOpt;
    }
}