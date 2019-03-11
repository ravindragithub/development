global class ProductAmazon_BatchClass implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    //ProductAmazon_BatchClass b1 = new ProductAmazon_BatchClass('Product');
    //ID batchprocessid = Database.executeBatch(b1,2000);
    //ProductAmazon_BatchClass b1 = new ProductAmazon_BatchClass('Product-Options');
    //ID batchprocessid = Database.executeBatch(b1,2000);
    //ProductAmazon_BatchClass b1 = new ProductAmazon_BatchClass('Product-Features');
    //ID batchprocessid = Database.executeBatch(b1,2000);
    global final String folderName;
    global final String masterFileName;
    public List<Exception> errors = new Exception[0];
    global ProductAmazon_BatchClass(String f) {
        folderName = f;
        if (folderName == 'Products')
            masterFileName = 'Products.json';
        else if (folderName == 'Product-Options')
            masterFileName = 'Options.json';
        else if (folderName == 'Product-Features')
            masterFileName = 'Features.json';
        else if (folderName == 'Product-Attributes')
            masterFileName = 'Attributes.json';
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string queryStr;
        queryStr = 'Select Id, Catalog_Display_Name__c,Catalog_Long_Description__c,ProductCode ';
        queryStr += 'From Product2 limit 1';
        return Database.getQueryLocator(queryStr);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
            string cvTitle = masterFileName;
            List<ContentVersion> existingCV = new List<ContentVersion>([Select Id, Title, VersionData From ContentVersion where Title = : cvTitle limit 1]);
            string existingListQuery;
            set<id> existingId = new set<id>();
            List<sObject> existingList = new List<sObject>();
            if (existingCV.size() > 0 )
                existingId = ProductAmazonJSONGeneratorHelper.getExistingIds(existingCV[0], folderName);
            if (folderName == 'Products') {
                existingListQuery = 'Select Id,Name, Catalog_Display_Name__c,Catalog_Long_Description__c,ProductCode,Product_Series__c,';
                existingListQuery += 'Display_Product__c,Retired__c,Retired_Date__c,IsActive, Product_Line1__c,LastModifiedDate,';
                existingListQuery += '(Select Id,Name,Market__c,Product_Name__c,Product_ID__c,Product__c,Sector__c,Product_Line__c,Product_Series__c,Catalog_Display_Name__c From Product_Markets_Sectors__r) ';
                existingListQuery += 'From Product2 ';
                existingListQuery += 'Where ((Id IN (Select Product__c from Product_Market_Sector__c)) AND ';
                existingListQuery += '((Display_Product__c =\'Yes\' AND IsActive = true) OR ';
                existingListQuery += '((Display_Product__c =\'No\' OR IsActive = false) AND Id =: existingId))) ';
            } else if (folderName == 'Product-Options') {
                existingListQuery = 'Select Id,SBQQ__ConfiguredSKU__c,Configured_Sku_Catalog_Display_Name__c,Configured_Sku_Catalog_Long_Description__c,';
                existingListQuery += 'Configured_Sku_IsActive__c,Configured_Sku_Display_Product__c,Optional_Sku_Catalog_Display_Name__c,Optional_Sku_Catalog_Long_Description__c,';
                existingListQuery += 'Optional_Sku_IsActive__c,Optional_Sku_Display_Product__c,Feature_Name__c,SBQQ__Feature__c,Display_in_Catalog__c,';
                existingListQuery += 'SBQQ__Number__c,KVH_P_N__c,Product_ID_18_char__c,LastModifiedDate ';
                existingListQuery += 'From SBQQ__ProductOption__c ';
                existingListQuery += 'Where ( ( (Configured_Sku_Display_Product__c =\'Yes\' AND Configured_Sku_IsActive__c = true) ';
                existingListQuery += 'AND (Optional_Sku_Display_Product__c =\'Yes\' AND Optional_Sku_IsActive__c = true) ';
                existingListQuery += 'AND Display_in_Catalog__c = true) ';
                existingListQuery += 'OR ( ( (Configured_Sku_Display_Product__c =\'No\' OR Configured_Sku_IsActive__c = false) ';
                existingListQuery += 'OR (Optional_Sku_Display_Product__c =\'No\' OR Optional_Sku_IsActive__c = false) ';
                existingListQuery += 'OR Display_in_Catalog__c = false) ';
                existingListQuery += 'AND Id =: existingId) )';
            } else if (folderName == 'Product-Features') {
                existingListQuery = 'Select Id,Name,Configured_Sku_IsActive__c,Configured_Sku_Display_Product__c,';
                existingListQuery += 'Configured_Sku_Catalog_Display_Name__c,Configured_Sku_Catalog_Long_Description__c,';
                existingListQuery += 'SBQQ__ConfiguredSKU__c,SBQQ__Number__c,LastModifiedDate ';
                existingListQuery += 'From SBQQ__ProductFeature__c ';
                existingListQuery += 'Where (  (Configured_Sku_Display_Product__c =\'Yes\' AND Configured_Sku_IsActive__c = true) ';
                existingListQuery += 'OR ( (Configured_Sku_Display_Product__c =\'No\' OR Configured_Sku_IsActive__c = false) ';
                existingListQuery += 'AND Id =: existingId) )';
            } else if (folderName == 'Product-Attributes') {
                existingListQuery = 'Select Id,Name,Configured_Sku_IsActive__c,Configured_Sku_Display_Product__c,';
                existingListQuery += 'Configured_Sku_Catalog_Display_Name__c,Configured_Sku_Catalog_Long_Description__c,';
                existingListQuery += 'Configured_SKU__c,Product_Attribute_Public_Name__c,Product_Attribute_Value__c,LastModifiedDate ';
                existingListQuery += 'From Product_Attribute__c ';
                existingListQuery += 'Where (  (Configured_Sku_Display_Product__c =\'Yes\' AND Configured_Sku_IsActive__c = true) ';
                existingListQuery += 'OR ( (Configured_Sku_Display_Product__c =\'No\' OR Configured_Sku_IsActive__c = false) ';
                existingListQuery += 'AND Id =: existingId) )';
            }
            system.debug(existingListQuery + '=====existingListQuery====' );
            existingListQuery += 'ORDER BY CreatedDate DESC';
            if (existingListQuery != null)
                existingList = Database.query(existingListQuery);
            //system.debug(existingList.size() + '=====existingList====' + existingList);
            //Create main JSON file and send to Amazon S3 for first time
            if (existingCV.size() == 0 && existingList.size() > 0) {
                system.debug(folderName + '=========folderName=====');
                //JSON Generator
                string binaryString = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(existingList, folderName, 'amazons3', null,null);
                //Rest callout class
                ProductAmazon_RestClass restCall = new ProductAmazon_RestClass();
                //Callout to amazon s3
                boolean checkFlag = restCall.ProductAmazon_RestMethod(binaryString, folderName, masterFileName);
                //create the JSON in salesforce content file
                if (checkFlag) {
                    string binarySFDCString = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(existingList, folderName, 'sfdc', null,null);
                    ModificationJSON_Helper.createContentVersion(binarySFDCString, cvTitle);
                }
            }
            //Modification done in salesforce
            else if (existingList.size() > 0) {
                //Modified value in Salesforce - JSON
                Map<string, string> modificationList = new Map<string, string>();
                modificationList = ModificationJSON_Helper.ModificationJSONMethod(existingList, folderName, existingCV[0]);
                if (modificationList != null && modificationList.keySet().size() > 0) {
                    //Get today date for modifed file name
                    String sToday = ModificationJSON_Helper.getTodayDate();
                    string modifiedfileName = sToday + '-' + masterFileName;
                    //Send the modified JSON file
                    ProductAmazon_RestClass restCall = new ProductAmazon_RestClass();
                    if (modificationList.get('modifedJSON') != null) {
                        restCall.ProductAmazon_RestMethod(modificationList.get('modifedJSON'), folderName, modifiedfileName);
                        //Send the main JSON file
                        boolean checkFlag = restCall.ProductAmazon_RestMethod(modificationList.get('mainString'), folderName, masterFileName);
                        if (checkFlag) {
                            List<ContentDocument> cd = new List<ContentDocument>([SELECT Id, PublishStatus, Title, LatestPublishedVersionId
                                    FROM ContentDocument where LatestPublishedVersionId = : existingCV[0].Id]);
                            delete cd;
                            if (modificationList.get('mainStringSFDC') != null)
                                ModificationJSON_Helper.createContentVersion(modificationList.get('mainStringSFDC'), cvTitle);
                        }
                    }
                }
            }
        
         try {
            }catch (Exception e) {
            system.debug('Exception :: ' + e);
            system.debug(e.getCause() + ':: Exception Cause :: ' + e.getLineNumber());
            errors.add(e);
        }

    }

    global void finish(Database.BatchableContext BC) {
        if (!errors.isEmpty()) {
            ModificationJSON_Helper.wrapperBatchError wrap = new ModificationJSON_Helper.wrapperBatchError();
            wrap.className = 'ProductAmazon_BatchClass';
            wrap.errorsWrapper = errors[0];
            wrap.errorType = 'Batch Class';
            ModificationJSON_Helper.sendMailToAdmin(wrap);
        }
    }
}