public with sharing class ProductAttributesTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI = false;
    
    public ProductAttributesTriggerHandler (boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    public void OnBeforeInsert(List<Product_Attribute__c> newsObjectList) {
        getProductDetails(newsObjectList);
    }
    public void OnBeforeUpdate( List<Product_Attribute__c> newsObjectList, List<Product_Attribute__c> oldsObjectList, Map<ID, Product_Attribute__c> newsObjectMap , Map<ID, Product_Attribute__c> oldsObjectMap ) {
        getProductDetails(newsObjectList);
    }
    
    public void getProductDetails( List<Product_Attribute__c> newsObjectList) {
        set<string> configIds = new set<string>();
        if (newsObjectList.size() > 0) {
            for (Product_Attribute__c temp : newsObjectList) {
                if (temp.get('Configured_SKU__c') != null)
                    configIds.add(string.valueOf(temp.get('Configured_SKU__c')));
            }
        }
        Map<Id, Product2> configProduct = new Map<Id, Product2>([Select Id, Catalog_Display_Name__c, Catalog_Long_Description__c, Display_Product__c, IsActive From Product2 Where Id = : configIds]);
        for (Product_Attribute__c temp : newsObjectList) {
            if (configProduct.containsKey(temp.Configured_SKU__c) ) {
                temp.Configured_Sku_Catalog_Display_Name__c = configProduct.get(temp.Configured_SKU__c).Catalog_Display_Name__c;
                temp.Configured_Sku_Catalog_Long_Description__c = configProduct.get(temp.Configured_SKU__c).Catalog_Long_Description__c;
                temp.Configured_Sku_Display_Product__c = configProduct.get(temp.Configured_SKU__c).Display_Product__c;
                temp.Configured_Sku_IsActive__c = configProduct.get(temp.Configured_SKU__c).IsActive;
            } else {
                temp.Configured_Sku_Catalog_Display_Name__c = '';
                temp.Configured_Sku_Catalog_Long_Description__c = '';
                temp.Configured_Sku_Display_Product__c = 'No';
                temp.Configured_Sku_IsActive__c = false;
            }
        }
    }
}