/**
* Class: ProductSearchClass
* This class handles the Product Search related logics
* Used with ProductSearchResult lightning component
*/
public without sharing class ProductSearchClass {

    /**
    * quickLink method fetches quick link from Quick_Link__c custom object
    * drives different logic for Sales Kit and non-Sales Kits
    * used in ProductSearchResult lightning component
    *
    * @param String, Boolean
    * @return Map<String,Object>
    */
    @AuraEnabled
    public static Map<String,Object> quickLink(String quickLink, Boolean salesKit){
        Map<String,Object> resultMap = new Map<String,Object>();
        if(salesKit){//running for Sales Toolkit?
            List<Quick_Link__c> quick_links = new List<Quick_Link__c>();
            for(Quick_Link__c ql : [SELECT Sales_Tool_Kit_Label__c, Image_URL__c, Sales_Kit__c FROM Quick_Link__c WHERE Sales_Kit__c = true]){
                quick_links.add(ql);
            }
            resultMap.put('saleskit', quick_links);
        }else{
            //return non-Sales toolkit Quick Links
            resultMap = ProductSearchClass.buildQuickLink(quickLink);
        }
        return resultMap;
    }

    /**
    * buildQuickLink method builds the list of non sales toolkit Quick Links
    * @param String
    * @return Map<String,Object>
    */
    @AuraEnabled
    public static Map<String,Object> buildQuickLink(String quickLink){
        Map<String, Object> resultMap = new Map<String, Object>();
        Set<String> contentTypeSet = new set<String>();
        List<ProductSearchClass.DocumentType> docList = new List<ProductSearchClass.DocumentType>();
        
        //Query Content Type custom object to collect the type of documents given quick link supports
        List <Quick_Link__c> qls = [SELECT Content_Type_s__c  FROM Quick_Link__c WHERE QuickLink_Label__c =: quickLink];
        for(Quick_Link__c ql: qls){
            contentTypeSet.addall(ql.Content_Type_s__c.split(';'));
        }
        system.debug(contentTypeSet);
        //get the list of DocumentType wrapper class
        //it holds the Document Type, subtype and it's related documents
        if(!contentTypeSet.isEmpty()){
            docList = fetchDocs(new Set<Id> {}, contentTypeSet, null, null);
        }

        //get ProductId's from DocumentType wrapper class
        //it is used to get the related Products for Quick Links
        //Products are shown based on Product Catalog associated with logged in user's partner account
        /*if(!docList.isEmpty()){
            Set<Id> productIdSet = docList[0].prodIdSet;
            if(!productIdSet.isEmpty()){
                List<Product_Catalogue__c> tempCatalogues = new List<Product_Catalogue__c>();
                String whereClause = ' AND ';

                if (!productIdSet.isEmpty()) {
                    String productIdSetValue = '(';
                    for (Id so : productIdSet) {
                        if(so != null){
                            productIdSetValue = productIdSetValue + '\'' + so + '\',' ;
                        }
                    }
                    productIdSetValue = productIdSetValue.removeEnd(',');
                    productIdSetValue = productIdSetValue + ')';
                    system.debug('***productIdSetValue()*****' + productIdSetValue);
                    whereClause = whereClause + ' Product_Market_Sector__r.Product__c  IN ' + productIdSetValue ;
                }

                User userRec = [SELECT Id, AccountId, Portal_View__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1] ;
                Id accountId = userRec.AccountId;
                if(accountId == null){
                    accountId = '001e0000013NkxOAAS';
                }
                String portalView = userRec.Portal_View__c;

                String productQuery = 'SELECT Name,Product_Line__c,Product_Series__c,Catalog_Display_Name__c,' +
                        ' Partner_Account__c,Product_Market_Sector__r.Product__c,Portal_View__c ' +
                        ' FROM Product_Catalogue__c ' +
                        ' WHERE Portal_View__c = \'' + portalView +'\' AND Partner_Account__c =\'' + accountId + '\' ' + whereClause + ' LIMIT 50';
                system.debug(productQuery);

                Set<Id> product_IDSet = new Set<Id>();
                //query Product Catalouge to get the product details
                for(Product_Catalogue__c pc : Database.query(productQuery)){
                    tempCatalogues.add(pc);
                    product_IDSet.add(pc.Product_Market_Sector__r.Product__c);
                }
                if(!tempCatalogues.isEmpty()){
                    lstProdLineSeriesTemp = ProductSearchClass.buildProductType(tempCatalogues,product_IDSet);
                }
            }
        }*/
        //return Documents and Products for given Quick Link
        List <String> ctypes = new List <String>();
        for(DocumentType dt : docList){
            system.debug(dt.doctype);
            if(dt.doctype != null){
                ctypes.add(dt.doctype);
            }  
        }
        resultMap.put('documents',docList);
        resultMap.put('contenttypes', ctypes);
        return resultMap;
    }
    @AuraEnabled
    public static void portalChange(string portalView){
        User userRec = [SELECT Id, Portal_View__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            if((String.isNotBlank(userRec.Portal_View__c) && !userRec.Portal_View__c.equalsIgnoreCase(portalView)) || String.isBlank(userRec.Portal_View__c)){
                userRec.Portal_View__c = portalView;
                update userRec ;
            }
    } 
    @AuraEnabled
    public static void fakeMethod(){}
    
    @AuraEnabled
    public static Map<String, Object> getProducts(String searchString, List<String> productIds, List<String> contentType) {
        Map<String, Object> productResultMap = new Map<String, Object>();
        User userRec = [SELECT Id, AccountId, Portal_View__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1] ;
        Id accountId = userRec.AccountId;
        String portalView = userRec.Portal_View__c;
        if (accountId == null) {
            DefaultAccounts__c da = [SELECT Account_ID__c FROM DefaultAccounts__c WHERE Name = 'KVH_Official_Internal_Contacts'];
            accountId = da.Account_ID__c;
        }
        List<DocumentType> wrapper = new List<DocumentType>();
        Set<Id> productIdSet = new Set<Id>();
        List<ProductSearchClass.ProdLineSeries> lstProdLineSeriesTemp = new List<ProductSearchClass.ProdLineSeries>();
        List<Product_Catalogue__c> tempCatalogues = new List<Product_Catalogue__c>();
        if (String.isNotBlank(searchString) || !productIds.isEmpty() || !contentType.isEmpty()) {
            Set<String> contentTypeSet = new Set<String>();
            Set<String> productNameSet = new Set<String>();
            Map<String, String> contentTypeMap = new Map<String, String>();
            Schema.DescribeFieldResult fieldResult = Content_Type__c.Content_Main_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f : ple) {
                contentTypeMap.put(f.getLabel().toUpperCase(), f.getLabel().toUpperCase()) ;
            }
            if (String.isNotBlank(searchString)) {
                for (String s : searchString.split(' ')) {
                    for (String contype : contentTypeMap.keySet()) {
                        if (contype.contains(s.toUpperCase())) {
                            contentTypeSet.add(contype) ;
                        } 
                    }
                    productNameSet.add(s) ;
                }
            }
            
            if (!contentType.isEmpty()) {
                contentTypeSet.addAll(contentType) ;
            }
            Boolean productFlag = false ;
            Boolean productIdFlag = false ;
            String whereClause = '' ;
            
            if (!productIds.isEmpty()) {
                productFlag = true ;
                productIdFlag = true ;
                String productIdSetValue = '(';
                for (String so : productIds) {
                    productIdSetValue = productIdSetValue + '\'' + so + '\',' ;
                }
                productIdSetValue = productIdSetValue.removeEnd(',');
                productIdSetValue = productIdSetValue + ')';
                system.debug('***productIdSetValue()*****' + productIdSetValue);
                whereClause = ' AND ( Product_Market_Sector__r.Product__c  IN ' + productIdSetValue ;
            }
            
            if (!productNameSet.isEmpty()) {
                productFlag = true ;
                if (String.isNotBlank(whereClause)) {
                    whereClause = whereClause + '  OR (' ;
                } else {
                    whereClause = whereClause + '  AND (' ;
                }
                Boolean firstFlag = false ;
                for (String s : productNameSet) {
                    if (!firstFlag) {
                        firstFlag = true ;
                        whereClause = whereClause + 'Catalog_Display_Name__c LIKE \'%' + String.escapeSingleQuotes(s) + '%\'  ' ;
                    } else {
                        whereClause = whereClause + 'OR Catalog_Display_Name__c LIKE \'%' + String.escapeSingleQuotes(s) + '%\'  ' ;
                    }
                }
                if (String.isNotBlank(whereClause)) {
                    whereClause = whereClause + ' )' ;
                }
            }
            
            if (String.isNotBlank(whereClause) && productIdFlag) {
                whereClause = whereClause + '  ) ' ;
            }
            
            if (productFlag) {
                String productQuery = 'SELECT Name,Product_Line__c,Product_Series__c,Catalog_Display_Name__c,' +
                    ' Partner_Account__c,Product_Market_Sector__r.Product__c,Product_Market_Sector__r.Product__r.Catalog_Long_Description__c,Portal_View__c' +
                    ' FROM Product_Catalogue__c ' +
                    ' WHERE Portal_View__c = \'' + portalView +'\' AND Partner_Account__c =\'' + accountId + '\' ' + whereClause + ' ORDER BY Catalog_Display_Name__c NULLS first LIMIT 50';
                system.debug(productQuery);
                
                for(Product_Catalogue__c pc : Database.query(productQuery)){
                    tempCatalogues.add(pc);
                    productIdSet.add(pc.Product_Market_Sector__r.Product__c);
                }
                
                if(!tempCatalogues.isEmpty()){
                    lstProdLineSeriesTemp = ProductSearchClass.buildProductType(tempCatalogues,productIdSet);
                }
                
                if (!contentType.isEmpty()) {
                    wrapper = ProductSearchClass.fetchDocs(productIdSet, contentTypeSet, null, searchString) ;
                } else{
                    contentTypeSet.clear();
                    for(string s : contentType){
                        contentTypeSet.add(s);
                    }
                    wrapper = ProductSearchClass.fetchDocs(productIdSet, contentTypeSet, null, searchString);
                }
                productResultMap.put('documents', wrapper);
            } else{
                wrapper = ProductSearchClass.fetchDocs(productIdSet, contentTypeSet, null, searchString) ;
                productResultMap.put('documents', wrapper);
            }
            productResultMap.put('products', lstProdLineSeriesTemp);
        } else{
            system.debug('i am here');
            tempCatalogues = [SELECT Name,Product_Line__c,Product_Series__c,Product_Market_Sector__r.Product__r.Catalog_Long_Description__c,Catalog_Display_Name__c, Partner_Account__c,Product_Market_Sector__r.Product__c,Portal_View__c FROM Product_Catalogue__c WHERE Portal_View__c =: portalView AND Partner_Account__c =: accountId ];
            for (Product_Catalogue__c pc : tempCatalogues){
                productIdSet.add(pc.Product_Market_Sector__r.Product__c);
            }
            wrapper = ProductSearchClass.fetchDocs(productIdSet, new Set<string> {}, null, null) ;
            productResultMap.put('documents', wrapper);
            lstProdLineSeriesTemp = ProductSearchClass.buildProductType(tempCatalogues,productIdSet);
            productResultMap.put('products', lstProdLineSeriesTemp);
        }
        system.debug(productResultMap);
        return productResultMap ;
    }
    
    public static List<ProductSearchClass.ProdLineSeries> buildProductType(List<Product_Catalogue__c> proCat, Set<Id> product_IDSet){
        List<ProductSearchClass.ProdLineSeries> lstProdLineSeriesTemp = new List<ProductSearchClass.ProdLineSeries>();
        Map<String, List<Product_Catalogue__c>> lineSeriesProdMap = new Map<String, List<Product_Catalogue__c>>();
        Map<String, String> prodId_URLMap = new Map<String, String>();
        
        //prepare Map for Product and it's related thumbnail images
        List<Content_Type__c> cts = [SELECT Product_Document__c FROM Content_Type__c WHERE Content_Sub_Type__c = 'Main Image'];
        List<Id> pds = new List<Id>();
        for(Content_Type__c ct : cts){
            pds.add(ct.Product_Document__c);
        }
        system.debug('pds: ' + pds + 'productIds: ' + product_IDSet);
        for(Prod_Doc_Library__c pdl : [SELECT Product_ID__c, AWS_URL__c FROM Prod_Doc_Library__c WHERE Filename__c IN: pds AND Product_ID__c IN: product_IDSet]){
            prodId_URLMap.put(pdl.Product_ID__c,pdl.AWS_URL__c);
        }
        system.debug('URL map' + prodId_URLMap);
        
        //prepare Map of ProductLine AND
        for (Product_Catalogue__c pc : proCat) {
            String tempLine = pc.Product_Line__c + ' > ' + pc.Product_Series__c ;
            if(lineSeriesProdMap.containsKey(tempLine)){
                List<Product_Catalogue__c> tempList = lineSeriesProdMap.get(tempLine);
                tempList.add(pc);
                lineSeriesProdMap.put(tempLine, tempList);
            }else{
                lineSeriesProdMap.put(tempLine, new List<Product_Catalogue__c>{pc});
            }
        }
        system.debug('URL Map: ' + prodId_URLMap);
        for(String line : lineSeriesProdMap.keySet()){
            List<ProductSearchClass.ProductResult> lstProductRecordsTemp = new List<ProductSearchClass.ProductResult>();
            for(Product_Catalogue__c p : lineSeriesProdMap.get(line)){
                if (prodId_URLMap.containsKey(p.Product_Market_Sector__r.Product__c)) {
                    lstProductRecordsTemp.add(new ProductResult(p, prodId_URLMap.get(p.Product_Market_Sector__r.Product__c))) ;
                } else {
                    lstProductRecordsTemp.add(new ProductResult(p, 'NoImage')) ;
                }
            }
            lstProdLineSeriesTemp.add(new ProdLineSeries(line, lstProductRecordsTemp));
        }
        system.debug(lstProdLineSeriesTemp);
        return lstProdLineSeriesTemp;
    }
    /**
    * fetchDocs method is build the list of Document Type and it's related Documents
    * wrapper class is used to gather Document list for each Document Type
    *
    * @param ProductId set, Document Types set
    * @return List<DocumentType>
    */
    
    public static List<DocumentType> fetchDocs(Set<Id> productIds, Set<String> contentTypeSet, string toolKit, string searchInput) {  
        User userRec = [SELECT Id, AccountId, Portal_View__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1] ;     
        String portalView = userRec.Portal_View__c;
        Id accountId = userRec.AccountId;
        if (accountId == null) {
            DefaultAccounts__c da = [SELECT Account_ID__c FROM DefaultAccounts__c WHERE Name = 'KVH_Official_Internal_Contacts'];
            accountId = da.Account_ID__c;
        }
        List<Product_Catalogue__c> pcats = new List<Product_Catalogue__c>();
        Set <string> titles = new Set<string>();
        system.debug('productids: '+ productids+';portalview: '+portalview+'; AccountId: '+accountId);
        if(productIds.size() > 0){
            pcats = [SELECT Catalog_Display_Name__c, Product_Line__c, Product_Series__c, Product_Market_Sector__c, Product_Market_Sector__r.Product_ID__c FROM Product_Catalogue__c WHERE Product_Market_Sector__r.Product__c IN : productIds AND Product_Market_Sector__r.Portal_View__c =: portalView AND Partner_Account__c =: accountId ORDER BY Catalog_Display_Name__c NULLS FIRST];
        } else{
            pcats = [SELECT Catalog_Display_Name__c, Product_Line__c, Product_Series__c, Product_Market_Sector__c, Product_Market_Sector__r.Product_ID__c FROM Product_Catalogue__c WHERE Product_Market_Sector__r.Portal_View__c =: portalView AND Partner_Account__c =: accountId ORDER BY Catalog_Display_Name__c NULLS FIRST];
        }
        system.debug('pcats: '+ pcats);
        Set<Id> pms = new Set<Id>();
        Set<Id> pds = new Set<Id>();
        Set<Id> prodIds = new Set<Id>();
        List<Prod_Doc_Library__c> pdls = new List<Prod_Doc_Library__c>();
        for(Product_Catalogue__c pc : pcats){
            pms.add(pc.Product_Market_Sector__c);
            prodIds.add(pc.Product_Market_Sector__r.Product_ID__c);
        } if(String.isBlank(searchInput)){
            pdls = [SELECT Filename__c FROM Prod_Doc_Library__c WHERE Filename__r.Partner_Portal__c = true AND Filename__r.Active__c = true AND Product_Market_Sector__c IN : pms];
            system.debug('pdls: '+ pdls);
        } else{
            List<string> inputs = searchInput.split(' ');
            Boolean firstFlag = true;
            string whereClause;
            for(string s : inputs){
                if(firstFlag == true){
                    whereClause = 'AND (FileName__r.Title_Display_Name__c LIKE \'%' + String.escapeSingleQuotes(s) + '%\' ';
                    firstFlag = false;
                } else{
                    whereClause += 'OR FileName__r.Title_Display_Name__c LIKE \'%' + String.escapeSingleQuotes(s) + '%\' ';
                }
            }
            system.debug('where ' + whereClause);
            if(!String.isBlank(whereClause)){
                whereClause = whereClause + ')';
            } 
            String Ids;
            firstFlag = true;
            for (Id pmktsect : pms){
                if(firstFlag == true){
                    Ids = '(\'' + pmktsect;
                    firstFlag = false;
                } else{
                    Ids = Ids + '\',\'' + pmktsect;
                }
                
            }
            if(!String.isBlank(Ids)){
                Ids = Ids + '\')';
            }
            string que = 'SELECT Filename__c FROM Prod_Doc_Library__c WHERE Filename__r.Partner_Portal__c = true AND Filename__r.Active__c = true AND Product_Market_Sector__c IN ' + Ids + ' '+ whereClause;
            system.debug('query '+ que);
            pdls = Database.query(que);
            
        }
        for(Prod_Doc_Library__c pdl : pdls){
            pds.add(pdl.Filename__c);
        }
        system.debug('content '+ contentTypeSet);
        List<Content_Type__c> cts = new List<Content_Type__c>();
        if(String.isBlank(toolKit) && contentTypeSet.isEmpty()){
            cts = [SELECT Content_Main_Type__c, Content_Sub_Type__c, Product_Document__r.Insertion_Code__c, Product_Document__r.Sub_Title__c, Product_Document__r.Created_Date__c, Product_Document__r.Language__c, Product_Document__r.Display_Terms_and_Conditions_Page__c, Product_Document__r.Display_HTML_Page__c, Product_Document__r.Associated_ProductIds__c, Product_Document__r.File_Extension__c, Product_Document__c, Product_Document__r.Revision__c, Product_Document__r.Size_Description__c, Product_Document__r.Image_URL__c, Product_Document__r.Sales_Aid__c, Product_Document__r.Title_Display_Name__c FROM Content_Type__c WHERE Product_Document__c IN :pds ORDER BY Content_Main_Type__c ASC, Content_Sub_Type__c, Product_Document__r.Title_Display_Name__c NULLS first];
        } else if(String.isBlank(toolKit)){
            cts = [SELECT Content_Main_Type__c, Content_Sub_Type__c, Product_Document__r.Insertion_Code__c, Product_Document__r.Sub_Title__c, Product_Document__r.Created_Date__c, Product_Document__r.Language__c, Product_Document__r.Display_Terms_and_Conditions_Page__c, Product_Document__r.Display_HTML_Page__c, Product_Document__r.Associated_ProductIds__c, Product_Document__r.File_Extension__c, Product_Document__c, Product_Document__r.Revision__c, Product_Document__r.Size_Description__c, Product_Document__r.Image_URL__c, Product_Document__r.Sales_Aid__c, Product_Document__r.Title_Display_Name__c FROM Content_Type__c WHERE Product_Document__c IN :pds AND Content_Main_Type__c IN :contentTypeSet ORDER BY Content_Main_Type__c ASC, Content_Sub_Type__c, Product_Document__r.Title_Display_Name__c NULLS first];
        } else{
            system.debug('here: '+ pds);
            cts = [SELECT Content_Main_Type__c, Content_Sub_Type__c, Product_Document__r.Insertion_Code__c, Product_Document__r.Sub_Title__c, Product_Document__r.Created_Date__c, Product_Document__r.Language__c, Product_Document__r.Display_Terms_and_Conditions_Page__c, Product_Document__r.Display_HTML_Page__c, Product_Document__r.Associated_ProductIds__c, Product_Document__r.File_Extension__c, Product_Document__c, Product_Document__r.Revision__c, Product_Document__r.Size_Description__c, Product_Document__r.Image_URL__c, Product_Document__r.Sales_Aid__c, Product_Document__r.Title_Display_Name__c FROM Content_Type__c WHERE Product_Document__c IN :pds AND Sales_Tool_Kit_s__c INCLUDES (:toolKit) ORDER BY Content_Main_Type__c ASC, Content_Sub_Type__c, Product_Document__r.Title_Display_Name__c NULLS first];
        }
        system.debug('cts: '+cts);
        // prepare the wrapper with the appropriate documents, subtypes and main types
        Map<string, List<DocumentResult>> drMap = new Map<string, List<DocumentResult>>();
        Map<string, Map<string, List<DocumentResult>>> dstMap = new Map<string, Map<string, List<DocumentResult>>>();
        for(Content_Type__c ct : cts){
            titles.add(ct.Product_Document__r.Title_Display_Name__c);
            List<DocumentResult> drs = new List<DocumentResult>();
            if(dstMap.containsKey(ct.Content_Main_Type__c)){
                drMap = dstMap.get(ct.Content_Main_Type__c);
                if(drMap.containsKey(ct.Content_Sub_Type__c)){
                    drs = drMap.get(ct.Content_Sub_Type__c);
                    drs.add(findIcon(ct));
                } else{
                    drs.add(findIcon(ct));
                }
                drMap.put(ct.Content_Sub_Type__c, drs);
                dstMap.put(ct.Content_Main_Type__c, drMap);
            } else{
                DocumentResult dr = findIcon(ct);
                drs.add(dr);
                dstMap.put(ct.Content_Main_Type__c, new Map<string, List<DocumentResult>>{ct.Content_Sub_Type__c => drs});
            }
        }
        system.debug('outerMap: ' + dstMap);
        List<DocumentType> dts = new List<DocumentType>();
        for(string mainkey : dstMap.keySet()){
            List<DocumentSubType> dsts = new List<DocumentSubType>();
            Map<string, List<DocumentResult>> tempMap = dstMap.get(mainkey);
            system.debug('@@ subkeys==>'+tempMap.keySet());
            for(string subkey : tempMap.keySet()){
                dsts.add(new DocumentSubType(subkey, tempMap.get(subkey)));
            }
            dts.add(new DocumentType(mainkey, dsts, prodIds, pcats, null));
            system.debug('doctype: ' + dts);
        } 
        return dts;
    }
    @AuraEnabled
    public static DocumentResult findIcon(Content_Type__c ct){
        Map<String, String> iconNameMap = new Map<String, String>();
        DocumentResult dr = new DocumentResult(null, null, null);
        //Collecting lightning icons for different document types
        for(DocumentIconMapping__mdt icon : [SELECT MasterLabel, Lightning_Icon_Name__c FROM DocumentIconMapping__mdt]){
            iconNameMap.put(icon.MasterLabel, icon.Lightning_Icon_Name__c);
        }
        //if Image URL is given then use it for thumbnail images for documents in search result
        if (String.isNotBlank(ct.Product_Document__r.Image_URL__c)) {
            dr = new DocumentResult(ct, ct.Product_Document__r.Image_URL__c, null);
        } else { //if no Image URL then use generic icons depending upon extension of file.
            if(iconNameMap.containsKey(ct.Product_Document__r.File_Extension__c)){
                dr = new DocumentResult(ct, 'NoIcon', iconNameMap.get(ct.Product_Document__r.File_Extension__c));
            }else{
                dr = new DocumentResult(ct, 'NoIcon', 'unknown');
            }
        }
        return dr;
    }
    /**
    * productDetail method fetches the details related to selected Product
    * gets product images, related documents, description, thumbnail image
    * used in ProductSearchResult lightning component
    *
    * @param String -> Product Id
    * @return Map<String,Object>
    */
    @AuraEnabled
    public static Map<String, Object> productDetail(String productId){ 
        Map<String, Object> productDetailMap = new Map<String, Object>();
        //collect all content types except product images
        Set< String> contentTypeSet = new Set<String>();
        Schema.DescribeFieldResult fieldResult = Content_Type__c.Content_Main_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pi : ple){
            if(pi.getLabel().contains('Product Image')){}
            else{
            contentTypeSet.add(pi.getLabel());
            }
        }        
        List<String> imageURLList = new List<String>();
        Set<String> imageURLSet = new Set<String>();
        Map<String, String> videoList = new Map<String, String>();
        Map<String, String> bannersList = new Map<String, String>();
        String prodMainImage;
        User userRec = [SELECT Id, AccountId, Portal_View__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        String portalView = userRec.Portal_View__c;
        Product_Catalogue__c prod = [SELECT Product_Market_Sector__r.Product__c, Product_Market_Sector__r.Product__r.Catalog_Long_Description__c, Catalog_Display_Name__c FROM Product_Catalogue__c WHERE Id =: productId];
        String product2Id = prod.Product_Market_Sector__r.Product__c ;
        List <Prod_Doc_Library__c> pdocs = [SELECT AWS_URL__c, FileName__c FROM Prod_Doc_Library__c WHERE Product_Market_Sector__r.Product__c =: product2Id AND Product_Market_Sector__r.Portal_View__c =: portalView];
        Set <Id> docums = new Set <Id>();
        for (Prod_Doc_Library__c p : pdocs){
            docums.add(p.FileName__c);
        }
        system.debug('docums: '+docums);
        List <Content_Type__c> cts = [SELECT Id, Content_Main_Type__c, Content_Sub_Type__c, Product_Document__c, Product_Document__r.Hosting_URL__c, Product_Document__r.Insertion_Code__c, Product_Document__r.Image_URL__c FROM Content_Type__c WHERE Product_Document__c IN: docums AND Content_Main_Type__c IN ('Images', 'Videos', 'Web Banners')];
        system.debug('cts: '+ cts);
        for(Content_Type__c conType : cts){
            if(conType.Content_Sub_Type__c != null){
                if(conType.Content_Sub_type__c =='Main Image'){
                    prodMainImage = conType.Product_Document__r.Image_URL__c;
                } 
            }
            if (conType.Content_Main_Type__c == 'Videos'){
                videoList.put(conType.Product_Document__r.Hosting_URL__c, conType.Product_Document__r.Insertion_Code__c);
            } else if(conType.Content_Main_Type__c == 'Web Banners'){
                bannersList.put(conType.Product_Document__r.Hosting_URL__c, conType.Product_Document__r.Insertion_Code__c);
            } else{
                imageURLSet.add(conType.Product_Document__r.Image_URL__c);
            }   
        }
        if(imageURLSet.contains(prodMainImage)){
            imageURLSet.remove(prodMainImage);
        }
        imageURLList.addAll(imageURLSet);
        system.debug(prodMainImage+ 'main image');
        productDetailMap.put('productimageurl', imageURLList);
        productDetailMap.put('banners', bannersList);
        productDetailMap.put('videos', videoList);
        system.debug('step 2: ' + productDetailMap);
        if (String.isNotBlank(prodMainImage)) {
            productDetailMap.put('product', new ProductResult(prod, prodMainImage));
        } else {
            productDetailMap.put('product', new ProductResult(prod, 'NoImage'));
        }
        List<DocumentType> wrapper = new List<DocumentType>();
        if (!contentTypeSet.isEmpty()) {
            wrapper = ProductSearchClass.fetchDocs(new Set<Id>{prod.Product_Market_Sector__r.Product__c}, contentTypeSet, null, null) ;
        }
        productDetailMap.put('documents', wrapper);
        return productDetailMap ;
    }    
   
    public class ProdLineSeries{
        @AuraEnabled public String prodLineSeries { get; set; }
        @AuraEnabled public List<ProductResult> productItemList;
        public ProdLineSeries(String prodLineSeries, List<ProductResult> productItemList) {
            this.prodLineSeries = prodLineSeries;
            this.productItemList = productItemList;
        }
    }

    public class ProductResult {
        @AuraEnabled public Product_Catalogue__c productItem;
        @AuraEnabled public String logoId;

        public ProductResult(Product_Catalogue__c productItem, String logoId) {
            this.productItem = productItem;
            this.logoId = logoId;
        }
    }

    public class DocumentType {
        @AuraEnabled public String doctype {get;set;}
        @AuraEnabled public List<Product_Catalogue__c> prodcats {get;set;}
        @AuraEnabled public Set<Id> prodIdSet {get;set;}
        @AuraEnabled public List<DocumentSubType> docSubs {get;set;}
        @AuraEnabled public String description {get;set;}
        
        public DocumentType(String doctype, List<DocumentSubType> docSubs, Set<Id> prodIdSet, List<Product_Catalogue__c> prodcats, String description) {
            this.doctype = doctype;
            this.prodcats = prodcats;
            this.docSubs = docSubs;
            this.prodIdSet = prodIdSet;
            this.description = description;
        }
    }
    public class DocumentSubType {
        @AuraEnabled public string subType {get;set;}
        @AuraEnabled public List<DocumentResult> documents { get; set;}

        public DocumentSubType(String subType, List<DocumentResult> documents) {
            this.subType = subType;
            this.documents = documents;
        }
    }
    public class DocumentResult {
        @AuraEnabled public Content_Type__c ct;
        @AuraEnabled public String logoId ;
        @AuraEnabled public String lightningIcon;

        public DocumentResult(Content_Type__c ct, String logoId, String lightningIcon){
            this.ct = ct;
            this.logoId = logoId;
            this.lightningIcon = lightningIcon;
        }
    }
    
}