public with sharing class Product2TriggerHandler {

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI = false;

    public Product2TriggerHandler (boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnAfterInsert(List<Product2> newsObjectList) {
        BIG_ProdToPricebookMethod(newsObjectList);
    }
    public void OnAfterUpdate( List<Product2 > newsObjectList, List<Product2 > oldsObjectList, Map<ID, Product2 > newsObjectMap , Map<ID, Product2 > oldsObjectMap ) {
        changeChildProductDetails(newsObjectMap, oldsObjectMap);
        BIG_ProdToPricebookMethod(newsObjectList);
    }
    public void OnBeforeDelete(Map<ID, Product2 > oldsObjectMap) {
        deleteChildProductDetails(oldsObjectMap);
    }


    //Method to update the Child Product list on Product update
    public void changeChildProductDetails( Map<ID, Product2 > newsObjectMap , Map<ID, Product2 > oldsObjectMap ) {
        Set<Id> productIds = new Set<Id>();
        List<SBQQ__ProductOption__c> listUpdateProdOpt = new List<SBQQ__ProductOption__c>();
        List<SBQQ__ProductFeature__c> listUpdateProdFeature = new List<SBQQ__ProductFeature__c>();
        List<Product_Attribute__c> listUpdateProdAttribute = new List<Product_Attribute__c>();

        for (Id productId : newsObjectMap.keyset())
            productIds.add(productId);

        List<Product2> listExistingProduct = new List<Product2>([Select Id, Catalog_Display_Name__c, Catalog_Long_Description__c, Display_Product__c, IsActive,
                (Select Id, Name, SBQQ__ConfiguredSKU__c, Configured_Sku_Catalog_Display_Name__c, Configured_Sku_Catalog_Long_Description__c, Configured_Sku_IsActive__c,
                 Configured_Sku_Display_Product__c, Optional_Sku_Catalog_Display_Name__c, Optional_Sku_Catalog_Long_Description__c,
                 Optional_Sku_IsActive__c, Optional_Sku_Display_Product__c From SBQQ__Options__r),
                (Select Id, Name, SBQQ__OptionalSKU__c, Configured_Sku_Catalog_Display_Name__c, Configured_Sku_Catalog_Long_Description__c, Configured_Sku_IsActive__c,
                 Configured_Sku_Display_Product__c, Optional_Sku_Catalog_Display_Name__c, Optional_Sku_Catalog_Long_Description__c,
                 Optional_Sku_IsActive__c, Optional_Sku_Display_Product__c From SBQQ__OptionalFor__r),
                (Select Id, Name, SBQQ__ConfiguredSKU__c, Configured_Sku_Catalog_Display_Name__c, Configured_Sku_Catalog_Long_Description__c, Configured_Sku_IsActive__c,
                 Configured_Sku_Display_Product__c From SBQQ__Features__r),
                (Select Id, Name, Configured_SKU__c, Configured_Sku_Catalog_Display_Name__c, Configured_Sku_Catalog_Long_Description__c, Configured_Sku_IsActive__c,
                 Configured_Sku_Display_Product__c From Product_Attribute__r) From Product2 Where Id = : productIds]);
        for (Product2 temp : listExistingProduct) {
            for (SBQQ__ProductOption__c tempChild : temp.SBQQ__Options__r) {
                if (
                    oldsObjectMap.containskey(tempChild.SBQQ__ConfiguredSKU__c)
                ) {
                    tempChild.Configured_Sku_Catalog_Display_Name__c = temp.Catalog_Display_Name__c;
                    tempChild.Configured_Sku_Catalog_Long_Description__c = temp.Catalog_Long_Description__c;
                    tempChild.Configured_Sku_Display_Product__c = temp.Display_Product__c;
                    tempChild.Configured_Sku_IsActive__c = temp.IsActive;
                } else {
                    tempChild.SBQQ__ConfiguredSKU__c = null;
                    tempChild.SBQQ__Feature__c = null;
                }
                listUpdateProdOpt.add(tempChild);
            }
            for (SBQQ__ProductOption__c tempChild : temp.SBQQ__OptionalFor__r) {
                if (
                    oldsObjectMap.containskey(tempChild.SBQQ__OptionalSKU__c)
                ) {
                    tempChild.Optional_Sku_Catalog_Display_Name__c = temp.Catalog_Display_Name__c;
                    tempChild.Optional_Sku_Catalog_Long_Description__c = temp.Catalog_Long_Description__c;
                    tempChild.Optional_Sku_Display_Product__c = temp.Display_Product__c;
                    tempChild.Optional_Sku_IsActive__c = temp.IsActive;
                } else {
                    tempChild.SBQQ__OptionalSKU__c = null;
                    tempChild.SBQQ__Feature__c = null;
                }
                listUpdateProdOpt.add(tempChild);
            }
            for (SBQQ__ProductFeature__c tempChild : temp.SBQQ__Features__r) {
                if (
                    oldsObjectMap.containskey(tempChild.SBQQ__ConfiguredSKU__c)
                ) {
                    tempChild.Configured_Sku_Catalog_Display_Name__c = temp.Catalog_Display_Name__c;
                    tempChild.Configured_Sku_Catalog_Long_Description__c = temp.Catalog_Long_Description__c;
                    tempChild.Configured_Sku_Display_Product__c = temp.Display_Product__c;
                    tempChild.Configured_Sku_IsActive__c = temp.IsActive;
                } else {
                    tempChild.SBQQ__ConfiguredSKU__c = null;
                }
                listUpdateProdFeature.add(tempChild);
            }
            for (Product_Attribute__c tempChild : temp.Product_Attribute__r) {
                if (
                    oldsObjectMap.containskey(tempChild.Configured_SKU__c)
                ) {
                    tempChild.Configured_Sku_Catalog_Display_Name__c = temp.Catalog_Display_Name__c;
                    tempChild.Configured_Sku_Catalog_Long_Description__c = temp.Catalog_Long_Description__c;
                    tempChild.Configured_Sku_Display_Product__c = temp.Display_Product__c;
                    tempChild.Configured_Sku_IsActive__c = temp.IsActive;
                } else {
                    tempChild.Configured_SKU__c = null;
                }
                listUpdateProdAttribute.add(tempChild);
            }
        }
        system.debug(listUpdateProdOpt + '======listUpdateProdOpt======');
        if (listUpdateProdOpt.size() > 0)
            update listUpdateProdOpt;
        if (listUpdateProdFeature.size() > 0)
            update listUpdateProdFeature;
        if (listUpdateProdAttribute.size() > 0)
            update listUpdateProdAttribute;
    }
    //Method to delete the Child Product list on Product update
    public void deleteChildProductDetails( Map<ID, Product2 > oldsObjectMap ) {
        Set<Id> productIds = new Set<Id>();
        List<SBQQ__ProductOption__c> listUpdateProdOpt = new List<SBQQ__ProductOption__c>();
        List<SBQQ__ProductFeature__c> listUpdateProdFeature = new List<SBQQ__ProductFeature__c>();
        List<Product_Attribute__c> listUpdateProdAttribute = new List<Product_Attribute__c>();

        for (Id productId : oldsObjectMap.keyset())
            productIds.add(productId);

        List<Product2> listExistingProduct = new List<Product2>([Select Id, Catalog_Display_Name__c, Catalog_Long_Description__c, Display_Product__c, IsActive,
                (Select Id, Name, SBQQ__ConfiguredSKU__c, Configured_Sku_Catalog_Display_Name__c, Configured_Sku_Catalog_Long_Description__c, Configured_Sku_IsActive__c,
                 Configured_Sku_Display_Product__c, Optional_Sku_Catalog_Display_Name__c, Optional_Sku_Catalog_Long_Description__c,
                 Optional_Sku_IsActive__c, Optional_Sku_Display_Product__c From SBQQ__Options__r),
                (Select Id, Name, SBQQ__OptionalSKU__c, Configured_Sku_Catalog_Display_Name__c, Configured_Sku_Catalog_Long_Description__c, Configured_Sku_IsActive__c,
                 Configured_Sku_Display_Product__c, Optional_Sku_Catalog_Display_Name__c, Optional_Sku_Catalog_Long_Description__c,
                 Optional_Sku_IsActive__c, Optional_Sku_Display_Product__c From SBQQ__OptionalFor__r),
                (Select Id, Name, SBQQ__ConfiguredSKU__c, Configured_Sku_Catalog_Display_Name__c, Configured_Sku_Catalog_Long_Description__c, Configured_Sku_IsActive__c,
                 Configured_Sku_Display_Product__c From SBQQ__Features__r),
                (Select Id, Name, Configured_SKU__c, Configured_Sku_Catalog_Display_Name__c, Configured_Sku_Catalog_Long_Description__c, Configured_Sku_IsActive__c,
                 Configured_Sku_Display_Product__c From Product_Attribute__r) From Product2 Where Id = : productIds]);
        for (Product2 temp : listExistingProduct) {
            for (SBQQ__ProductOption__c tempChild : temp.SBQQ__Options__r) {
                tempChild.SBQQ__ConfiguredSKU__c = null;
                tempChild.SBQQ__Feature__c = null;
                listUpdateProdOpt.add(tempChild);
            }
            for (SBQQ__ProductOption__c tempChild : temp.SBQQ__OptionalFor__r) {
                tempChild.SBQQ__OptionalSKU__c = null;
                listUpdateProdOpt.add(tempChild);
            }
            for (SBQQ__ProductFeature__c tempChild : temp.SBQQ__Features__r) {
                tempChild.SBQQ__ConfiguredSKU__c = null;
                listUpdateProdFeature.add(tempChild);
            }
            for (Product_Attribute__c tempChild : temp.Product_Attribute__r) {
                tempChild.Configured_SKU__c = null;
                listUpdateProdAttribute.add(tempChild);
            }
        }
        if (listUpdateProdOpt.size() > 0)
            update listUpdateProdOpt;
        if (listUpdateProdFeature.size() > 0)
            update listUpdateProdFeature;
        if (listUpdateProdAttribute.size() > 0)
            update listUpdateProdAttribute;
    }
    public void BIG_ProdToPricebookMethod(List<Product2 > newsObjectList) {
        string StID = '01s30000000JCI0AAO';
        string keID = '01s30000000VArwAAG';
        string kuID = '01s30000000VArrAAG';
        string milID = '01s30000000VAs1AAG';


        List<id> prod_ids = new List<id>();
        PricebookEntry pbooke;
        List<PricebookEntry> spbe_n = new List<PricebookEntry>();
        List<PricebookEntry> spbe_d = new List<PricebookEntry>();
        List<PricebookEntry> pbe_e = new List<PricebookEntry>();
        List<PricebookEntry> pbe_u = new List<PricebookEntry>();
        List<PricebookEntry> pbe_n = new List<PricebookEntry>();
        List<PricebookEntry> pbe_d = new List<PricebookEntry>();
        Map<string, PricebookEntry> st_ents = new Map<String, PricebookEntry>();
        Map<String, PricebookEntry> ke_ents = new Map<String, PricebookEntry>();
        Map<String, PricebookEntry> ku_ents = new Map<String, PricebookEntry>();
        Map<String, PricebookEntry> mil_ents = new Map<String, PricebookEntry>();
        for (Product2 p : newsObjectList) {
            prod_ids.add(p.id);
        }
        System.debug('Prod ids=' + prod_ids.size().format());
        pbe_e = [SELECT ID, Pricebook2id, UnitPrice, Product2id, isActive, Pricebook2.Name from PricebookEntry WHERE Product2id in :prod_ids];
        if (!pbe_e.isEmpty()) {
            for (PricebookEntry pb : pbe_e) {
                if (pb.Pricebook2.Name == 'KE/KN/KS Sat Comm Pricebook')
                    ke_ents.put(pb.Product2ID, pb);
                if (pb.Pricebook2.Name == 'KU Sat Comm Pricebook')
                    ku_ents.put(pb.Product2id, pb);
                if (pb.Pricebook2.Name == 'Standard Price Book')
                    st_ents.put(pb.Product2id, pb);
                if (pb.Pricebook2.Name == 'MIlitary/FOG Pricebook')
                    mil_ents.put(pb.Product2id, pb);
            }
        }
        for (Product2 pr : newsObjectList) {
            if (pr.Standard_Pricebook_Price__c != null) {
                if (st_ents.containskey(pr.id)) {
                    pbooke = st_ents.get(pr.id);
                    pbooke.UnitPrice = pr.Standard_Pricebook_price__c;
                    pbooke.isActive = pr.isActive;
                    pbe_u.add(pbooke);
                }
                if (!st_ents.containskey(pr.id)) {
                    spbe_n.add(new PricebookEntry(IsActive = pr.isActive, Pricebook2Id = stID, Product2id = pr.id, UnitPrice = pr.Standard_Pricebook_Price__c));

                }
                if (pr.KE_KN_KS_Sat_Comm_Price__c == null) {
                    if (ke_ents.containskey(pr.id)) {
                        pbooke = ke_ents.get(pr.id);
                        pbe_d.add(pbooke);
                    }
                }
                if (pr.KE_KN_KS_Sat_Comm_Price__c != null) {
                    if (ke_ents.containskey(pr.id)) {
                        pbooke = ke_ents.get(pr.id);
                        pbooke.UnitPrice = pr.KE_KN_KS_Sat_Comm_Price__c;
                        pbooke.isActive = pr.isActive;
                        pbe_u.add(pbooke);
                    } else {
                        pbe_n.add(new PricebookEntry(UnitPrice = pr.KE_KN_KS_Sat_Comm_Price__c, isActive = pr.isActive, Pricebook2Id = keID, Product2id = pr.id));

                    }
                }
                if (pr.KU_Sat_Comm_Price__c == null) {
                    if (ku_ents.containskey(pr.id)) {
                        pbooke = ku_ents.get(pr.id);
                        pbe_d.add(pbooke);
                    }
                }
                if (pr.KU_Sat_Comm_Price__c != null) {
                    if (ku_ents.containskey(pr.id)) {
                        pbooke = ku_ents.get(pr.id);
                        pbooke.UnitPrice = pr.KU_Sat_Comm_Price__c;
                        pbooke.isActive = pr.isActive;
                        pbe_u.add(pbooke);
                    } else {
                        pbe_n.add(new PricebookEntry(UnitPrice = pr.KU_Sat_Comm_Price__c, isActive = pr.isActive, Pricebook2Id = kuID, Product2id = pr.id));

                    }
                }
                if (pr.MIlitary_FOG_Price__c == null) {
                    if (mil_ents.containskey(pr.id)) {
                        pbooke = mil_ents.get(pr.id);
                        pbe_d.add(pbooke);
                    }
                }
                if (pr.MIlitary_FOG_Price__c != null) {
                    if (mil_ents.containskey(pr.id)) {
                        pbooke = mil_ents.get(pr.id);
                        pbooke.UnitPrice = pr.MIlitary_FOG_Price__c;
                        pbooke.isActive = pr.isActive;
                        pbe_u.add(pbooke);

                    } else {
                        pbe_n.add(new PricebookEntry(UnitPrice = pr.MIlitary_FOG_Price__c, isActive = pr.isActive, Pricebook2Id = milID, Product2id = pr.id));
                    }
                }
            }
            if (pr.Standard_Pricebook_Price__c == null) {
                System.debug('Entering Delete');
                if (st_ents.containskey(pr.id)) {
                    pbooke = st_ents.get(pr.id);
                    spbe_d.add(pbooke);
                }
                if (ke_ents.containskey(pr.id)) {
                    pbooke = ke_ents.get(pr.id);
                    pbe_d.add(pbooke);
                }
                if (ku_ents.containskey(pr.id)) {
                    pbooke = ku_ents.get(pr.id);
                    pbe_d.add(pbooke);

                }
                if (mil_ents.containskey(pr.id)) {
                    pbooke = mil_ents.get(pr.id);
                    pbe_d.add(pbooke);
                }
            }
        }
        System.debug('standard pbe to delete=' + spbe_d.size().format());
        System.debug('pbe to delete=' + pbe_d.size().format());
        System.debug('pbe to update=' + pbe_u.size().format());
        System.debug('Standard pbe to insert=' + spbe_n.size().format());
        System.debug('pbe to insert=' + pbe_n.size().format());
        if (!pbe_d.isEmpty()) {
            System.debug('pbe to delete=' + pbe_d.size().format());
            delete pbe_d;
        }
        if (!spbe_d.isEmpty()) {
            System.debug('standard pbe to delete=' + spbe_d.size().format());
            delete spbe_d;
        }
        if (!pbe_u.isEmpty()) {
            System.debug('pbe to update=' + pbe_u.size().format());
            update pbe_u;
        }
        if (!spbe_n.isEmpty()) {
            System.debug('Standard pbe to insert=' + spbe_n.size().format());
            insert spbe_n;
        }
        if (!pbe_n.isEmpty()) {
            System.debug('pbe to insert=' + pbe_n.size().format());
            insert pbe_n;
        }
    }

}