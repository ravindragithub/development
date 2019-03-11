public class ToolKitsClass {
    
    @AuraEnabled
    public static List<Content_Type__c> CTypes(){
        User userRec = [SELECT Id, AccountId, Portal_View__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1] ;     
        String portalView = userRec.Portal_View__c;
        Id accountId = userRec.AccountId;
        if (accountId == null) {
            DefaultAccounts__c da = [SELECT Account_ID__c FROM DefaultAccounts__c WHERE Name = 'KVH_Official_Internal_Contacts'];
            accountId = da.Account_ID__c;
        }
        List<Product_Catalogue__c> pcats = new List<Product_Catalogue__c>();
        Set <string> titles = new Set<string>();
        system.debug('portalview: '+portalview+'; AccountId: '+accountId);
        pcats = [SELECT Catalog_Display_Name__c, Product_Line__c, Product_Series__c, Product_Market_Sector__c, Product_Market_Sector__r.Product_ID__c FROM Product_Catalogue__c WHERE Product_Market_Sector__r.Portal_View__c =: portalView AND Partner_Account__c =: accountId];
        system.debug('pcats: '+ pcats);
        Set<Id> pms = new Set<Id>();
        Set<Id> pds = new Set<Id>();
        Set<Id> prodIds = new Set<Id>();
        List<Prod_Doc_Library__c> pdls = new List<Prod_Doc_Library__c>();
        for(Product_Catalogue__c pc : pcats){
            pms.add(pc.Product_Market_Sector__c);
            prodIds.add(pc.Product_Market_Sector__r.Product_ID__c);
        }
        pdls = [SELECT Filename__c FROM Prod_Doc_Library__c WHERE Filename__r.Partner_Portal__c = true AND Filename__r.Active__c = true AND Product_Market_Sector__c IN : pms];
        system.debug('pdls: '+ pdls);
        for(Prod_Doc_Library__c pdl : pdls){
            pds.add(pdl.Filename__c);
        }
        List<Content_Type__c> cts = new List<Content_Type__c>();
        cts = [SELECT Content_Main_Type__c, Sales_Tool_Kit_s__c, Content_Sub_Type__c, Product_Document__r.Insertion_Code__c, Product_Document__r.Sub_Title__c, Product_Document__r.Created_Date__c, Product_Document__r.Language__c, Product_Document__r.Display_Terms_and_Conditions_Page__c, Product_Document__r.Display_HTML_Page__c, Product_Document__r.Associated_ProductIds__c, Product_Document__r.File_Extension__c, Product_Document__c, Product_Document__r.Revision__c, Product_Document__r.Size_Description__c, Product_Document__r.Image_URL__c, Product_Document__r.Sales_Aid__c, Product_Document__r.Title_Display_Name__c FROM Content_Type__c WHERE Product_Document__c IN :pds AND Sales_Tool_Kit_s__c != null ORDER BY Content_Main_Type__c ASC, Content_Sub_Type__c ASC, Product_Document__r.Title_Display_Name__c ASC NULLS first];
        system.debug('cts: '+cts);
        return cts;
    }
    /* This method returns the ToolKits that the user has associated documents for.  
    * If the user does not have any associated content types, that toolkit will not display.*/
    @AuraEnabled
    public static List<Quick_Link__c> ToolKitLanding(){
        List<Content_Type__c> cts = ToolKitsClass.CTypes();
        List<Quick_Link__c> tks = new List<Quick_Link__c>();
        Set<String> setQLs = new Set<String>();
        for(Content_Type__c ct : cts){
            for(String s : ct.Sales_Tool_Kit_s__c.split(';')){
                setQLs.add(s);
            }
        }
        tks = [SELECT Image_URL__c, Sales_Tool_Kit_Label__c FROM Quick_Link__c WHERE Sales_Kit__c = true AND Sales_Tool_Kit_Label__c IN: setQLs AND Toolkit_Content_Type__c = null];
        integer remaningItems = 0;
        if(tks.size()>4){
            remaningItems = Math.mod(tks.size(),4);
            System.debug('@@ remaningItems==>'+remaningItems);
            for(integer i=4;i>4-remaningItems;i--){
                tks.add(new Quick_Link__c());
            }
        }
        return tks;
    }
    
    @AuraEnabled
    public static Map<String, Object> buildToolKit(string toolKitName){
        Map<String, Object> resultMap = new Map<String, Object>();
        List<ProductSearchClass.DocumentType> docList = ProductSearchClass.fetchDocs(new Set<Id> {}, null, toolKitName, null);
        List<Product_Market_Sector__c> pms = [SELECT Product_ID__c FROM Product_Market_Sector__c WHERE Sales_Tool_Kit_s__c INCLUDES (: toolKitName)];
        Set<Id> productIds = new Set<Id>();
        Set<String> contypes = new Set<String>();
        for(ProductSearchClass.DocumentType dt : docList){
            contypes.add(dt.doctype);
        }
        List<Quick_Link__c> qls = [SELECT Toolkit_Content_Type__c, Content_Type_Description__c FROM Quick_Link__c WHERE Toolkit_Content_Type__c IN: contypes];
        for(ProductSearchClass.DocumentType dt : docList){
            for(Quick_Link__c ql : qls){
                if(ql.Toolkit_Content_Type__c == dt.doctype){
                    dt.description = ql.Content_Type_Description__c;
                }
            }
        }
        for(Product_Market_Sector__c pmsId : pms){
            if(docList[0].prodIdSet.Contains(pmsId.Product_ID__c)){
                productIds.add(pmsId.Product_ID__c);
            }
        }
        List<Product_Catalogue__c> procats = new List<Product_Catalogue__c>();
        for (Product_Catalogue__c pc : doclist[0].prodcats){
            if(productIds.contains(pc.Product_Market_Sector__r.Product_ID__c)){
                procats.add(pc);
            }
        } 
        procats = [SELECT Name,Product_Line__c,Product_Series__c,Catalog_Display_Name__c, Partner_Account__c,Product_Market_Sector__r.Product__c,Portal_View__c FROM Product_Catalogue__c WHERE Id IN: procats];
        List<ProductSearchClass.ProdLineSeries> lstProdLineSeriesTemp = ProductSearchClass.buildproducttype(procats, productIds);
        resultMap.put('documents', docList);
        resultMap.put('products', lstProdLineSeriesTemp);
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

}