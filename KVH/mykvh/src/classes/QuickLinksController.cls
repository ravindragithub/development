public without sharing class QuickLinksController {

    @AuraEnabled
    public static List<Quick_Link__c> constructQuickLinks(){
        List<Quick_Link__c> linklst = new List<Quick_Link__c>();
        for(Quick_Link__c ql : [SELECT QuickLink_Label__c, Background_Color__c, Display_Order__c, Icon__c, Sales_Kit__c, Content_Type_s__c FROM Quick_Link__c ORDER BY Display_Order__c ]){
            if(ql.Sales_Kit__c == FALSE)
                linklst.add(ql);
        }
      /*  
        integer remaningItems = 0;
        if(linklst.size()>0){
            remaningItems = Math.mod(linklst.size(),4);
            System.debug('@@ remaningItems==>'+remaningItems);
            for(integer i=4;i>4-remaningItems;i--){
                linklst.add(new Quick_Link__c());
            }
        }
        System.debug('quicklinkslist'+remaningItems);*/
        return linklst;
    }

    @AuraEnabled
    public static Map<String,Object> quickLink(String quickLink, Boolean salesKit){
        Map<String,Object> resultMap = new Map<String,Object>();

        if(salesKit){
            List<Quick_Link__c> quick_links = [SELECT QuickLink_Label__c, Sales_Kit__c FROM Quick_Link__c WHERE Sales_Kit__c = true];
        }else{
            resultMap = buildQuickLink(quickLink);
        }
        return resultMap;
    }

    @AuraEnabled
    public static Map<String,Object> buildQuickLink(String quickLink){
        Map<String, Object> resultMap = new Map<String, Object>();
        Set<String> contentTypeSet = new set<String>();
        List<ProductSearchClass.DocumentType> docList = new List<ProductSearchClass.DocumentType>();
        List<ProductSearchClass.ProdLineSeries> lstProdLineSeriesTemp = new List<ProductSearchClass.ProdLineSeries>();
        List<Quick_Link__c> quick_links = [SELECT Content_Type_s__c FROM Quick_Link__c WHERE QuickLink_Label__c =: quickLink];
        List <string> qls = quick_links[0].Content_Type_s__c.split('; ');
        for (string ql : qls){
            contentTypeSet.add(ql);
        }
        if(!contentTypeSet.isEmpty()){
            docList = ProductSearchClass.fetchDocs(new Set<Id> {},contentTypeSet, null, null);
        }
        if(!docList.isEmpty()){
            Set<Id> productIdSet = new Set<Id>();
            productIdSet = doclist[0].prodIdSet;
            if(!productIdSet.isEmpty()){
                List<Product_Catalogue__c> tempCatalogues = new List<Product_Catalogue__c>();
                String whereClause = '';

                if (!productIdSet.isEmpty()) {
                    String productIdSetValue = '(';
                    for (Id so : productIdSet) {
                        productIdSetValue = productIdSetValue + '\'' + so + '\',' ;
                    }
                    productIdSetValue = productIdSetValue.removeEnd(',');
                    productIdSetValue = productIdSetValue + ')';
                    system.debug('***productIdSetValue()*****' + productIdSetValue);
                    whereClause = whereClause + ' AND Product_Market_Sector__r.Product__c  IN ' + productIdSetValue ;
                }

                User userRec = [SELECT
                                Id,
                                AccountId,
                                Portal_View__c
                        FROM User
                        WHERE Id =: UserInfo.getUserId()
                        LIMIT 1
                ] ;

                Id accountId = userRec.AccountId;
                String portalView = userRec.Portal_View__c;

                String productQuery = ' SELECT Name,Product_Line__c,Product_Series__c,Catalog_Display_Name__c,' +
                        ' Partner_Account__c,Product_Market_Sector__r.Product__c,Portal_View__c ' +
                        ' FROM Product_Catalogue__c ' +
                        ' WHERE Portal_View__c = \'' + portalView +'\' AND Partner_Account__c =\'' + accountId + '\' ' + whereClause + ' LIMIT 50';
                system.debug(productQuery);

                Set<Id> productIds = new Set<Id>();
                for(Product_Catalogue__c pc : Database.query(productQuery)){
                    tempCatalogues.add(pc);
                    productIds.add(pc.Product_Market_Sector__r.Product__c);
                }
                if(!tempCatalogues.isEmpty()){
                    lstProdLineSeriesTemp = ProductSearchClass.buildProductType(tempCatalogues,productIds);
                }
            }
        }
        resultMap.put('documents',docList);
        resultMap.put('products', lstProdLineSeriesTemp);
        return resultMap;
    }
    public class QuickLinksWrapper{
       @AuraEnabled
       public Integer rowNumber{get;set;}
       @AuraEnabled
       public List<Quick_Link__c> quicklinks{get;set;}
       @AuraEnabled
       public List<Quick_Link__c> toolkits{get;set;}
    }

}