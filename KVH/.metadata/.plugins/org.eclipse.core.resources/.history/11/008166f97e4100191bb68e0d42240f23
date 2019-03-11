public without sharing class FilterServices {
    @AuraEnabled
    public static List<ProductLineJSON> productSelection(string section){
        List<ProductLineJSON> productLineJSONList = new List<ProductLineJSON>() ;
        User userRec = [SELECT Id, AccountId, Portal_View__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1 ] ;
        String portalView = userRec.Portal_View__c ;
        Id accountId = userRec.AccountId ;
        if(accountId == null){
            DefaultAccounts__c da = [SELECT Account_ID__c FROM DefaultAccounts__c WHERE Name = 'KVH_Official_Internal_Contacts'];
            accountId = da.Account_ID__c;
        }
        List<Product_Catalogue__c> Product_CatalogueList = new List<Product_Catalogue__c>();
        if (section == 'Retired Products'){
            Product_CatalogueList = [SELECT Product_Market_Sector__r.Product__c, Catalog_Display_Name__c, Display_Product__c, Portal_View__c, Product_Line__c, Product_Series__c, Partner_Account__c FROM Product_Catalogue__c WHERE Product_Market_Sector__r.Product__r.IsActive = true AND  Product_Market_Sector__r.Product__r.Retired__c = true AND Portal_View__c =: portalView AND Partner_Account__c =: accountId AND Display_Product__c = true];
        } else if (section == 'Active Products'){
            Product_CatalogueList = [SELECT Product_Market_Sector__r.Product__c, Catalog_Display_Name__c, Display_Product__c, Portal_View__c, Product_Line__c, Product_Series__c, Partner_Account__c FROM Product_Catalogue__c WHERE Product_Market_Sector__r.Product__r.IsActive = true AND  Product_Market_Sector__r.Product__r.Retired__c = false AND Portal_View__c =: portalView AND Partner_Account__c =: accountId AND Display_Product__c = true];
        }
        system.debug(Product_CatalogueList);
        productLineJSONList = FilterServices.build_JSTreeFilter(Product_CatalogueList);
        return productLineJSONList;
    }

    @AuraEnabled
    public static List<FilterServices.ProductLineJSON> whereToBuyFilter(List<Product_Market_Sector__c> filterCollection,String defaultProductId){
        List<FilterServices.ProductLineJSON> productLineJSONList = new List<FilterServices.ProductLineJSON>();
        Map<String, Product_Market_Sector__c> tempMap = new Map<String, Product_Market_Sector__c>();
        for(Product_Market_Sector__c p : filterCollection){
            if(!tempMap.containsKey(p.Catalog_Display_Name__c)){
                tempMap.put(p.Catalog_Display_Name__c, p);
            }
        }
        productLineJSONList = FilterServices.build_WhereToBuyJSTreeFilter(tempMap.values(),defaultProductId);
        return productLineJSONList;
    }
    
    
    @AuraEnabled
    public static List<FilterServices.ProductLineJSON> whereToBuyFilter(List<Product_Catalogue__c> filterCollection){
        List<FilterServices.ProductLineJSON> productLineJSONList = new List<FilterServices.ProductLineJSON>();
        Map<String, Product_Catalogue__c> tempMap = new Map<String, Product_Catalogue__c>();
        for(Product_Catalogue__c p : filterCollection){
            if(!tempMap.containsKey(p.Catalog_Display_Name__c)){
                tempMap.put(p.Catalog_Display_Name__c, p);
            }
        }
        productLineJSONList = FilterServices.build_JSTreeFilter(tempMap.values());
        return productLineJSONList;
    }

    public static List<ProductLineJSON> build_WhereToBuyJSTreeFilter(List<Product_Market_Sector__c> pcList,String defaultProductId) {
        Map<String, Map<String, List<Product_Market_Sector__c>>> productMappingMap = new Map<String, Map<String, List<Product_Market_Sector__c>>>() ;
        for(Product_Market_Sector__c pc : pcList) {
            if (pc.Product_Line1__c != null && pc.Product_Series1__c != null && productMappingMap.containsKey(pc.Product_Line1__c)) {
                Map<String, List<Product_Market_Sector__c>> tempExistingMap = productMappingMap.get(pc.Product_Line1__c) ;
                Map<String, List<Product_Market_Sector__c>> tempNewMap = new Map<String, List<Product_Market_Sector__c>>() ;
                
                if (tempExistingMap.keySet().contains(pc.Product_Series1__c)) {
                    List<Product_Market_Sector__c> tempNameList = tempExistingMap.get(pc.Product_Series1__c) ;
                    tempNameList.add(pc) ;
                    tempExistingMap.put(pc.Product_Series1__c, tempNameList) ;
                    productMappingMap.put(pc.Product_Line1__c, tempExistingMap) ;
                } else {
                    tempExistingMap.put(pc.Product_Series1__c, new List<Product_Market_Sector__c>{pc}) ;
                    productMappingMap.put(pc.Product_Line1__c, tempExistingMap) ;
                }
            } else if (pc.Product_Line1__c != null && pc.Product_Series1__c!= null){
                Map<String, List<Product_Market_Sector__c>> tempMap = new Map<String, List<Product_Market_Sector__c>>() ;
                tempMap.put(pc.Product_Series1__c, new List<Product_Market_Sector__c>{pc});
                productMappingMap.put(pc.Product_Line1__c, tempMap);
            }
        }
        system.debug(productMappingMap);
        //List<ProductLine> productLineList = new List<ProductLine>() ;
        List<ProductLineJSON> productLineJSONList = new List<ProductLineJSON>() ;

        for (String prodLine : productMappingMap.keySet()) {
            //List<ProductSeries> productSeriesList = new List<ProductSeries>() ;
            productLineJSONList.add(new ProductLineJSON(prodLine, '#', prodLine, new TreeState(true,false), null, new TreeData('prodLine:' + prodLine))) ;
            for (String prodSeries : productMappingMap.get(prodLine).keySet()) {
                productLineJSONList.add(new ProductLineJSON(prodLine + '||' + prodSeries, prodLine, prodSeries, new TreeState(true,false), null, new TreeData('prodSeries:' + prodSeries))) ;

                //List<Product> productsList = new List<Product>() ;
                for (Product_Market_Sector__c prod : productMappingMap.get(prodLine).get(prodSeries)) {
                    boolean selected = prod.Product__c == defaultProductId ? true : false;
                    productLineJSONList.add(new ProductLineJSON(prodLine + '||' + prodSeries + '||' +  prod.Catalog_Display_Name__c, prodLine + '||' + prodSeries, prod.Catalog_Display_Name__c, new TreeState(false,selected), null, new TreeData('prodId:' + prod.Product__c))) ;

                    //Product prouctTemp = new Product(prod) ;
                    //productsList.add(prouctTemp) ;
                }
                //ProductSeries prodSeriesTemp = new ProductSeries(prodSeries, productsList);
                //productSeriesList.add(prodSeriesTemp) ;
            }
            //ProductLine prodLineTemp = new ProductLine(prodLine, productSeriesList);
            //productLineList.add(prodLineTemp) ;
        }
        //system.debug(productLineList);
        return productLineJSONList ;
    }

    public static List<ProductLineJSON> build_JSTreeFilter(List<Product_Catalogue__c> pcList) {
        Map<String, Map<String, List<Product_Catalogue__c>>> productMappingMap = new Map<String, Map<String, List<Product_Catalogue__c>>>() ;
        for(Product_Catalogue__c pc : pcList) {
            if (productMappingMap.containsKey(pc.Product_Line__c)) {
                Map<String, List<Product_Catalogue__c>> tempExistingMap = productMappingMap.get(pc.Product_Line__c) ;
                Map<String, List<Product_Catalogue__c>> tempNewMap = new Map<String, List<Product_Catalogue__c>>() ;
                
                if (tempExistingMap.keySet().contains(pc.Product_Series__c)) {
                    List<Product_Catalogue__c> tempNameList = tempExistingMap.get(pc.Product_Series__c) ;
                    tempNameList.add(pc) ;
                    tempExistingMap.put(pc.Product_Series__c, tempNameList) ;
                    productMappingMap.put(pc.Product_Line__c, tempExistingMap) ;
                } else {
                    tempExistingMap.put(pc.Product_Series__c, new List<Product_Catalogue__c>{pc}) ;
                    productMappingMap.put(pc.Product_Line__c, tempExistingMap) ;
                }
            } else {
                Map<String, List<Product_Catalogue__c>> tempMap = new Map<String, List<Product_Catalogue__c>>() ;
                tempMap.put(pc.Product_Series__c, new List<Product_Catalogue__c>{pc});
                productMappingMap.put(pc.Product_Line__c, tempMap);
            }
        }
        system.debug(productMappingMap);
        //List<ProductLine> productLineList = new List<ProductLine>() ;
        List<ProductLineJSON> productLineJSONList = new List<ProductLineJSON>() ;

        for (String prodLine : productMappingMap.keySet()) {
            //List<ProductSeries> productSeriesList = new List<ProductSeries>() ;
            productLineJSONList.add(new ProductLineJSON(prodLine, '#', prodLine, new TreeState(true,false), null, new TreeData('prodLine:' + prodLine))) ;
            for (String prodSeries : productMappingMap.get(prodLine).keySet()) {
                productLineJSONList.add(new ProductLineJSON(prodLine + '||' + prodSeries, prodLine, prodSeries, new TreeState(true,false), null, new TreeData('prodSeries:' + prodSeries))) ;

                //List<Product> productsList = new List<Product>() ;
                for (Product_Catalogue__c prod : productMappingMap.get(prodLine).get(prodSeries)) {                    
                    productLineJSONList.add(new ProductLineJSON(prodLine + '||' + prodSeries + '||' +  prod.Catalog_Display_Name__c, prodLine + '||' + prodSeries, prod.Catalog_Display_Name__c, new TreeState(false,false), null, new TreeData('prodId:' + prod.Product_Market_Sector__r.Product__c))) ;

                    //Product prouctTemp = new Product(prod) ;
                    //productsList.add(prouctTemp) ;
                }
                //ProductSeries prodSeriesTemp = new ProductSeries(prodSeries, productsList);
                //productSeriesList.add(prodSeriesTemp) ;
            }
            //ProductLine prodLineTemp = new ProductLine(prodLine, productSeriesList);
            //productLineList.add(prodLineTemp) ;
        }
        //system.debug(productLineList);
        return productLineJSONList ;
    }

    @AuraEnabled
    public static List<ProductLineJSON> loadContentFilter() {
        List<ProductLineJSON> productLineJSONList = new List<ProductLineJSON>() ;
        List<Content_Type__c> cts = [SELECT Id, Content_Main_Type__c FROM Content_Type__c WHERE Content_Main_Type__c NOT IN ('Product Image 3','Product Image 1','Product Image 2')];
        Set<string> maintypes = new Set<string>();
        for (Content_Type__c ct : cts) {
            maintypes.add(ct.Content_Main_Type__c);
        }
        for (string d : maintypes) {
            productLineJSONList.add(new ProductLineJSON(
                    d,
                    '#',
                    d,
                    new TreeState(false,false),
                    new TreeClass('Calibri'),
                    new TreeData('contentname:' + d))) ;

        }
        return productLineJSONList ;
    }

    public class ProductLineJSON {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String parent { get; set; }
        @AuraEnabled public String text { get; set; }
        @AuraEnabled public TreeState state { get; set; }
        @AuraEnabled public TreeClass a_attr { get; set; }
        @AuraEnabled public TreeData data { get; set; }

        public ProductLineJSON(String id, String parent, String text,
                TreeState state, TreeClass a_attr, TreeData data) {
            this.id = id ;
            this.parent = parent ;
            this.text = text ;
            this.state = state ;
            this.a_attr = a_attr ;
            this.data = data;
        }
    }

    public class TreeState {
        @AuraEnabled public Boolean opened { get; set; }
        @AuraEnabled public Boolean selected { get; set; }
        
        public TreeState(Boolean opened,Boolean selected) {
            this.opened = opened ;
            this.selected = selected;
        }
    }

    public class TreeData {
        @AuraEnabled public String uniqueID { get; set; }
        public TreeData(String uniqueID) {
            this.uniqueID = uniqueID ;
        }
    }

    public class TreeClass {
        @AuraEnabled public String font { get; set; }

        public TreeClass(String font) {
            this.font = font ;
        }
    }
}