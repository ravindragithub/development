public with sharing class ProductAttributesCreate_Controller {
    public string retriveJSON {get; set;}
    public string abc {get; set;}
    public string efg {get; set;}
    public integer totalProduct {get; set;}
    public integer totalProductFound {get; set;}
    public integer totalProductJSON {get; set;}
    public integer totalProdAttFound {get; set;}
    public integer totalProdAttInsert {get; set;}
    public void ProductAttributesCreate_Method() {
        List<ContentVersion> existingCV = new List<ContentVersion>([Select Id, Title, VersionData
                From ContentVersion where Title = : 'ProductsWithSpecsProd' limit 1]);
        String afterblob = EncodingUtil.base64Encode(existingCV[0].VersionData);
        blob finalblob = EncodingUtil.base64Decode(afterblob);
        string inputJSON = finalblob.toString();
        retriveJSON = inputJSON;
        Map<string, List<ProductAttributes>> prodAttrListMap = new Map<string, List<ProductAttributes>>();
        List<ProductAttributes> attrList2 = new List<ProductAttributes>();
        List<string> productNameLst = new List<string>();
        if (inputJSON != null && inputJSON != '') {
            //Deserialize the JSON Input into a Class Object.
            List<ProductAttributes_Z> jsonObj = (List<ProductAttributes_Z>)JSON.deserialize(inputJSON, List<ProductAttributes_Z>.class);
            for (ProductAttributes_Z temp : jsonObj ) {
                productNameLst.add(temp.ProductName);
                List<ProductAttributes> attrList = new List<ProductAttributes>();
                set<string> productAttName = new set<string>();
                set<string> productAttPubName = new set<string>();
                set<string> productAttVal = new set<string>();
                if (prodAttrListMap.containsKey(temp.ProductName)) {
                    attrList = prodAttrListMap.get(temp.ProductName);
                    for (ProductAttributes attr : attrList) {
                        productAttName.add(attr.ProductAttributeName);
                        productAttPubName.add(attr.ProductAttributePublicName);
                        productAttVal.add(attr.ProductAttributeValue);
                    }
                }
                for (ProductAttributes tempChild : temp.ProductAttributes) {
                    if (
                        !productAttName.contains(tempChild.ProductAttributeName) ||
                        !productAttPubName.contains(tempChild.ProductAttributePublicName) ||
                        !productAttVal.contains(tempChild.ProductAttributeValue)
                    ) {
                        ProductAttributes attr = new ProductAttributes();
                        attr.ProductAttributeName = tempChild.ProductAttributeName;
                        attr.ProductAttributePublicName = tempChild.ProductAttributePublicName;
                        attr.ProductAttributeValue = tempChild.ProductAttributeValue;
                        attrList.add(attr);
                    }
                }
                if (attrList.size() > 0)
                    prodAttrListMap.put(temp.ProductName, attrList);
            }
        }
        Map<string, string> productNameIdMap = new Map<string, string>();
        Map<string, string> productCatNameIdMap = new Map<string, string>();
        Map<string, Product2> productNameMap = new Map<string, Product2>();
        Map<string, Product2> productCatNameMap = new Map<string, Product2>();
        set<string> productNameFound = new set<string>();
        List<Product_Attribute__c> updateProdAttList = new List<Product_Attribute__c>();
        List<Product_Attribute__c> finalUpdateProdAttList = new List<Product_Attribute__c>();
        Map<string, Product2> lstPrdMap = new Map<string, Product2>([Select Id, Name, Catalog_Display_Name__c, Product_Line1__c, Product_Series__c from Product2
                Where Name = : prodAttrListMap.keySet() OR Catalog_Display_Name__c = : prodAttrListMap.keySet()]);
        for (Product2 pro : lstPrdMap.values() ) {
            productNameMap.put(pro.Name, pro);
            productCatNameMap.put(pro.Catalog_Display_Name__c, pro);
            if (prodAttrListMap.containsKey(pro.Name))
                productNameIdMap.put(pro.Name, pro.Id);
            if (prodAttrListMap.containsKey(pro.Catalog_Display_Name__c))
                productCatNameIdMap.put(pro.Catalog_Display_Name__c, pro.Id);
        }
        system.debug(productNameIdMap.size() + 'productNameIdMap===========');
        system.debug(productCatNameIdMap.size() + 'productNameIdMap===========');
        for (string temp : prodAttrListMap.keySet()) {
            for (ProductAttributes proattExist :  prodAttrListMap.get(temp)) {
                if (productNameIdMap.containsKey(temp)) {
                    Product_Attribute__c prodAtt = new Product_Attribute__c();
                    prodAtt.Configured_SKU__c = productNameIdMap.get(temp);
                    prodAtt.Name = proattExist.ProductAttributeName;
                    prodAtt.Product_Attribute_Public_Name__c = proattExist.ProductAttributePublicName;
                    prodAtt.Product_Attribute_Value__c = proattExist.ProductAttributeValue;
                    updateProdAttList.add(prodAtt);
                }
                if (productCatNameIdMap.containsKey(temp)) {
                    Product_Attribute__c prodAtt = new Product_Attribute__c();
                    prodAtt.Configured_SKU__c = productCatNameIdMap.get(temp);
                    prodAtt.Name = proattExist.ProductAttributeName;
                    prodAtt.Product_Attribute_Public_Name__c = proattExist.ProductAttributePublicName;
                    prodAtt.Product_Attribute_Value__c = proattExist.ProductAttributeValue;
                    updateProdAttList.add(prodAtt);
                }
                if (!productNameIdMap.containsKey(temp) || !productCatNameIdMap.containsKey(temp)) {
                    productNameFound.add(temp);
                }
                attrList2.add(proattExist);
            }
        }
        /*
        Map<string, Product_Attribute__c> lstPrdAttrMap = new Map<string, Product_Attribute__c>([Select Id, Name, Configured_SKU__c, Configured_SKU__r.Name,
                Configured_SKU__r.Catalog_Display_Name__c, Product_Attribute_Public_Name__c, Product_Attribute_Value__c from Product_Attribute__c ]);
        Map<string, Product_Attribute__c> lstNamePrdAttrMap = new Map<string, Product_Attribute__c>();
        if (lstPrdAttrMap.keySet().size() > 0) {
            for (string Ids : lstPrdAttrMap.keySet()) {
                lstNamePrdAttrMap.put(lstPrdAttrMap.get(Ids).Configured_SKU__c, lstPrdAttrMap.get(Ids));
            }
            for (Product_Attribute__c updateLst : updateProdAttList) {
                if (
                    lstNamePrdAttrMap.containsKey(updateLst.Configured_SKU__c) &&
                    (lstNamePrdAttrMap.get(updateLst.Configured_SKU__c).Name != updateLst.Name &&
                     lstNamePrdAttrMap.get(updateLst.Configured_SKU__c).Product_Attribute_Public_Name__c == updateLst.Product_Attribute_Public_Name__c &&
                     lstNamePrdAttrMap.get(updateLst.Configured_SKU__c).Product_Attribute_Value__c == updateLst.Product_Attribute_Value__c)
                )
                    system.debug('===***===');
                else
                    finalUpdateProdAttList.add(updateLst);
            }

        }
        else{
            finalUpdateProdAttList.addAll(updateProdAttList);
        }
        */

        /*
        for (Id prodId : lstPrdMap.keyset() ) {
            if (prodAttrListMap.containsKey(lstPrdMap.get(prodId).Name)) {
                for (ProductAttributes proattExist :  prodAttrListMap.get(lstPrdMap.get(prodId).Name)) {
                    Product_Attribute__c prodAtt = new Product_Attribute__c();
                    prodAtt.Configured_SKU__c = prodId;
                    prodAtt.Name = proattExist.ProductAttributeName;
                    prodAtt.Product_Attribute_Public_Name__c = proattExist.ProductAttributePublicName;
                    prodAtt.Product_Attribute_Value__c = proattExist.ProductAttributeValue;
                    updateProdAttList2.add(prodAtt);
                }
            }
            if (prodAttrListMap.containsKey(lstPrdMap.get(prodId).Catalog_Display_Name__c)) {
                for (ProductAttributes proattExist :  prodAttrListMap.get(lstPrdMap.get(prodId).Catalog_Display_Name__c)) {
                    Product_Attribute__c prodAtt = new Product_Attribute__c();
                    prodAtt.Configured_SKU__c = prodId;
                    prodAtt.Name = proattExist.ProductAttributeName;
                    prodAtt.Product_Attribute_Public_Name__c = proattExist.ProductAttributePublicName;
                    prodAtt.Product_Attribute_Value__c = proattExist.ProductAttributeValue;
                    updateProdAttList2.add(prodAtt);
                }
            }
        }
        */
        //////////////Check upsert for attributes///////////////////////////
        system.debug(updateProdAttList.size() + '===updateProdAttList====' );
        system.debug(finalUpdateProdAttList.size() + '===finalUpdateProdAttList====' );
        insert updateProdAttList;
        //////////////////////////////////////////////////////////////////
        abc = '';
        for (String s : productNameFound)
            abc += (abc == '' ? '' : ',') + s;
        totalProductFound  = productNameMap.keySet().size();
        totalProduct = prodAttrListMap.values().size();
        totalProductJSON = productNameLst.size();
        totalProdAttFound = attrList2.size();
        totalProdAttInsert = updateProdAttList.size();
        //////////////////////////////////////////////////////////////////
    }



    public class ProductAttributes {
        public String ProductAttributeName;
        public String ProductAttributePublicName;
        public String ProductAttributeValue;
    }
    public class ProductAttributes_Z {
        public String ProductLine;
        public String ProductSeries;
        public String ProductName;
        public List<ProductAttributes> ProductAttributes;
    }

}