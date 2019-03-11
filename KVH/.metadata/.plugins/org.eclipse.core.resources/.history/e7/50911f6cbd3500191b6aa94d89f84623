global class ProductAmazonDocument_BatchClass implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global final String folderName;
    global final String masterFileName;

    //Work In progress for Product Document whole class
    global ProductAmazonDocument_BatchClass() {
        folderName = 'Public-Documents';
        masterFileName = 'Documents.json';
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string queryStr;
        queryStr = 'Select Id,Name,Active__c ';
        queryStr += 'From Prod_Documents__c limit 1';
        return Database.getQueryLocator(queryStr);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        string cvTitle = masterFileName;
        List<ContentVersion> existingCV = new List<ContentVersion>([Select Id, Title, VersionData From ContentVersion where Title = : cvTitle limit 1]);
        string existingListQuery;
        set<id> existingId = new set<id>();
        if (existingCV.size() > 0 )
            existingId = ProductAmazonJSONGeneratorHelper.getExistingIds(existingCV[0], folderName);
        existingListQuery = 'Select Id, Name,Title_Display_Name__c,Sub_Title__c,File_Access__c,File_Extension__c,Size_Description__c,';
        existingListQuery += 'Revision__c,Language__c,Image_URL__c,Alternate_Text__c, Hosting_URL__c,Marketo_URL__c,Gated_Document__c,';
        existingListQuery += 'Site_Core_URL__c,Insertion_Code__c ,Active__c,Display_HTML_Page__c,Html_Field__c,Display_Terms_and_Conditions_Page__c,';
        existingListQuery += 'Terms_and_Conditions_1__c,Sales_Aid__c,Associated_Content_Types__c,File_Description__c,KVH_com__c,LastModifiedDate ';
        existingListQuery += 'From Prod_Documents__c ';
        existingListQuery += 'Where ((Id IN (Select Filename__c from Prod_Doc_Library__c)) AND ';
        existingListQuery += '( (KVH_com__c = true AND Active__c = true AND File_Access__c = \'Public\') ';
        existingListQuery += 'OR ( (KVH_com__c = false OR Active__c = false OR File_Access__c != \'Public\') ';
        existingListQuery += 'AND Id =: existingId) ) )';
        existingListQuery += 'ORDER BY CreatedDate DESC Limit 49999';

        system.debug(existingListQuery + '=====existingListQuery====' );
        Map <Id, Prod_Documents__c> prodDocMap = new Map<Id, Prod_Documents__c>((List<Prod_Documents__c>)Database.query(existingListQuery));
        system.debug(prodDocMap.size() + '===prodDocMap===');
        List<Prod_Documents__c> sendListProdDoc = new List<Prod_Documents__c>();
        ////////////////////////////////////////////////////////////////////////////////////
        Map <Id, boolean> prodDocCheckMap = new Map<Id, boolean>(); // Product Document vs Product IsActive/Display Product
        Set<String> setProductMSId = new Set<String>();
        //Get Content Type
        Map <Id, List<Content_Type__c>> prodContentTypeMap = new Map <Id, List<Content_Type__c>>();
        for (Content_Type__c temp : [Select Id, Name, Content_Main_Type__c, Content_Sub_Type__c, Product_Document__c
                                     from Content_Type__c Where Product_Document__c = : prodDocMap.keySet() Limit 49999]) {
            if (prodContentTypeMap.containsKey(temp.Product_Document__c)) {
                List<Content_Type__c> prodContType = prodContentTypeMap.get(temp.Product_Document__c);
                prodContType.add(temp);
                prodContentTypeMap.put(temp.Product_Document__c, prodContType);
            } else {
                prodContentTypeMap.put(temp.Product_Document__c, new List<Content_Type__c> { temp });
            }
        }
        system.debug(prodContentTypeMap.size() + '===prodContentTypeMap===' + prodContentTypeMap);


        //Check the Active/Display Product of any related product of product market sector of Product Doc Library
        for (Prod_Doc_Library__c temp : [Select Id, Name, Filename__c, Product_Market_Sector__c, Product_Market_Sector__r.Product__r.isActive,
                                         Product_Market_Sector__r.Product__r.Display_Product__c From Prod_Doc_Library__c
                                         Where Filename__c = : prodDocMap.keySet() Limit 49999]) {
            if (prodDocCheckMap.get(temp.Filename__c) == false || prodDocCheckMap.get(temp.Filename__c) == null) {
                if (temp.Product_Market_Sector__r.Product__r.isActive == true &&
                        temp.Product_Market_Sector__r.Product__r.Display_Product__c == 'Yes')
                    prodDocCheckMap.put(temp.Filename__c, true);
                else
                    prodDocCheckMap.put(temp.Filename__c, false);
            }
            setProductMSId.add(temp.Product_Market_Sector__c);
        }
        system.debug(prodDocCheckMap.size() + '===prodDocCheckMap===' + prodDocCheckMap);

        //Get the Taxnomy data of Product Market Sector

        Map <Id, List<sObject>> prodDocIdProdDocMap = new Map<Id, List<sObject>>(); //Product Document vs Market sector Ids
        Map <Id, List<string>> prodDocIdProdDocStringMap = new Map<Id, List<string>>(); //Product Document vs Market sector Ids

        Map <Id, Product_Market_Sector__c> prodMarketSectMap = new Map <Id, Product_Market_Sector__c>([Select Id, Name, Market__c, Sector__c, Product_Line__c, Active__c,  Product_Series__c,
                Catalog_Display_Name__c, Product_Name__c, Display_Product__c, Product__c, Product_ID__c from Product_Market_Sector__c
                Where Id = : setProductMSId AND Active__c = : 'YES' AND Display_Product__c = true]);
        if (prodMarketSectMap != null) {
            for (Prod_Doc_Library__c temp : [Select Id, Name, Filename__c, Product_Market_Sector__c, Product_Market_Sector__r.Product__r.isActive,
                                             Product_Market_Sector__r.Product__r.Display_Product__c From Prod_Doc_Library__c
                                             Where Filename__c = : prodDocMap.keySet() Limit 49999]) {
                if (prodDocIdProdDocMap.containsKey(temp.Filename__c)) {
                    List<sObject> prodMSList = prodDocIdProdDocMap.get(temp.Filename__c);
                    if (prodMarketSectMap.get(temp.Product_Market_Sector__c) != null && prodMarketSectMap.get(temp.Product_Market_Sector__c).Product_ID__c != null)
                        prodMSList.add(prodMarketSectMap.get(temp.Product_Market_Sector__c));
                    prodDocIdProdDocMap.put(temp.Filename__c, prodMSList);
                } else {
                    List<sObject> prodMSProd = new List<sObject> ();
                    if (prodMarketSectMap.get(temp.Product_Market_Sector__c) != null && prodMarketSectMap.get(temp.Product_Market_Sector__c).Product_ID__c != null)
                        prodMSProd.add(prodMarketSectMap.get(temp.Product_Market_Sector__c));
                    prodDocIdProdDocMap.put(temp.Filename__c, prodMSProd);
                }
            }
        }
        system.debug(prodDocIdProdDocMap + '===prodDocIdProdDocMap===');
        for (Prod_Documents__c proDoc : prodDocMap.values()) {
            if (
                prodDocCheckMap.containsKey(proDoc.Id) &&
                prodDocCheckMap.get(proDoc.Id)
            ) {
                sendListProdDoc.add(proDoc);
            }
        }
        if (existingCV.size() == 0 && sendListProdDoc.size() > 0) {
            string binaryString = '';
            binaryString = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(sendListProdDoc, folderName, 'amazons3', prodDocIdProdDocMap, prodContentTypeMap);
            //Rest callout class
            ProductAmazon_RestClass restCall = new ProductAmazon_RestClass();
            //Callout to amazon s3
            boolean checkFlag = restCall.ProductAmazon_RestMethod(binaryString, folderName, masterFileName);
            //create the JSON in salesforce content file
            if (checkFlag) {
                string binarySFDCString = '';
                binarySFDCString = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(sendListProdDoc, folderName, 'sfdc', prodDocIdProdDocMap, prodContentTypeMap);
                ModificationJSON_Helper.createContentVersion(binarySFDCString, cvTitle);
            }
        } else if (sendListProdDoc.size() > 0) {
            Map<string, string> modificationList = new Map<string, string>();
            modificationList = ProductDoc_ModificationJSON_Helper.ProductDocModificationJSONMethod(sendListProdDoc, folderName, existingCV[0], prodDocIdProdDocMap, prodContentTypeMap );
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
    }

    global void finish(Database.BatchableContext BC) {
    }
}