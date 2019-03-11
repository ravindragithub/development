/***********************************************
    Name        :    SalesAidsController
    Description :    Search sales aids documents
    
***********************************************/
public class SalesAidsController{

    @AuraEnabled
    public static SalesAidsDocuments fetchSalesAids(String searchString, List<String> selectedProducts, List<String> selectedContentTypes){
        
        System.debug('@@ selectedContentTypes==>'+selectedContentTypes.size() + ' searchString==>'+  searchString + 'selectedProducts==>'+selectedProducts.size());
        SalesAidsDocuments salesAidsDocmentSObj = new SalesAidsDocuments();
        
       
        String accountId,Portalview,contactId;
        
        //get account id and portal view
        List<User> userlst = [Select id,ContactId,Contact.AccountId,Default_Account_ID__c,Portal_View__c from User where ID =: userinfo.getuserId()];
        if(userlst.size()>0 && userlst[0].ContactId != null){
            accountId = userlst[0].Contact.AccountId;
            contactId = userlst[0].ContactId;
        }else if(userlst.size()>0 && userlst[0].Default_Account_ID__c != null){
           accountId = userlst[0].Default_Account_ID__c;
        }
        
        //get portal name
        if(userlst.size()>0 && userlst[0].Portal_View__c != null)
            Portalview = userlst[0].Portal_View__c;
        
        String query = 'Select Product_Market_Sector__c from Product_Catalogue__c where ';
        String whereclause = ' Portal_View__c = \'' + Portalview + '\'';
        whereclause += ' AND Partner_Account__c =\'' + accountId + '\'';
        
        //if product id passed
        Set<String> productIds = new Set<String>();
        if(!selectedProducts.isEmpty()){
            for(String pId : selectedProducts){
                if(pId.length()>3)
                    productIds.add(pId);
            }
            
            if(productIds.size()>0)
              whereclause += ' AND Product_Market_Sector__r.Product__c IN : productIds';  
        }
        
        //if search string passed
        if(String.isNotBlank(searchString)){
            whereclause += ' AND ( ';
            integer count = 1;
            for(String str : searchString.split(' ')){
                 if(count == 1){
                     whereclause += ' Name LIKE \'%' + String.escapeSingleQuotes(str) + '%\'  ' ;
                 }else{
                     whereclause += 'OR Name LIKE \'%' + String.escapeSingleQuotes(str) + '%\'  ' ;
                 }
                 count++;
            }
            whereclause += ') ';
        }
        query = query + whereclause ;
        system.debug('@@ ' + query);
        Set<String> productMarketsectorIds = new Set<String>();
        for(Product_Catalogue__c pc : Database.query(query)){
            productMarketsectorIds.add(pc.Product_Market_Sector__c);
        }
        
        if(productMarketsectorIds.size() > 0){            
            //query prod doc libraries
            Set<String> prodDocIDs = new Set<String>();
            for(Prod_Doc_Library__c pdl : [Select id,Filename__c from Prod_Doc_Library__c where Filename__r.Sales_Aid__c = TRUE AND Filename__r.Active__c = TRUE AND Filename__r.Partner_Portal__c = TRUE AND Product_Market_Sector__c IN : productMarketsectorIds]){
                prodDocIDs.add(pdl.Filename__c);
            }
            
            //query prod documents and it's content type
            if(prodDocIDs.size()>0){
                //fetch sales order id for the login user which is in pending status
                List<Sales_Aid_Order__c> salesorderlist = [Select id from Sales_Aid_Order__c where Partner__c =: contactId AND Status__c = 'In Progress' limit 1];
                Map<String,Sales_Aid_Order_Line__c> salesOrderLineMap = new Map<String,Sales_Aid_Order_Line__c>();
                if(salesorderlist.size()>0){
                    for(Sales_Aid_Order_Line__c sol : [Select id,Quantity__c,Product_Document__c from Sales_Aid_Order_Line__c
                                                     where Product_Document__c IN : prodDocIDs 
                                                     AND Sales_Aid_Order__c =: salesorderlist[0].Id AND Status__c = 'Pending' ]){
                        salesOrderLineMap.put(sol.Product_Document__c,sol);
                    }
                }
                Set<String> contentTypeSet = new Set<String>();
                if(!selectedContentTypes.isEmpty()){
                    for(String ct : selectedContentTypes){
                            if(ct.length()>3)
                                contentTypeSet.add(ct);                
                    }
                }
                
                
                
                //category map
                Map<String,CategoryWrapper> categoryMap = new Map<String,CategoryWrapper>();
                Map<String,List<SalesAidsWrapper>> tempsalesAidsMap = new Map<String,List<SalesAidsWrapper>>();
                
                String contentTypeQuery = 'Select Content_Main_Type__c,Content_Sub_Type__c,Product_Document__c,' 
                                           +' Product_Document__r.name,Product_Document__r.Image_URL__c,Product_Document__r.Hosting_URL__c,'
                                           +' Product_Document__r.File_Description__c,Product_Document__r.Sub_Title__c,'
                                           +' Product_Document__r.Title_Display_Name__c, Product_Document__r.Language__c'
                                           +' from Content_Type__c where Product_Document__c IN : prodDocIDs';
                if(contentTypeSet.size()>0)
                    contentTypeQuery  += ' AND Content_Main_Type__c IN : contentTypeSet';
                System.debug('@@ contentTypeQuery ==>'+contentTypeQuery  );
                for(Content_Type__c ct : Database.query(contentTypeQuery)){
                    
                    SalesAidsWrapper salesAidsObj = salesAidsDocmentSObj.salesAidsMap.get(ct.Product_Document__c);
                    if(salesAidsObj == null){
                        
                        salesAidsObj  = new SalesAidsWrapper(ct.Product_Document__r.Sub_Title__c,ct.Product_Document__r.Image_URL__c,ct.Product_Document__r.Hosting_URL__c,
                                                                        ct.Product_Document__r.Title_Display_Name__c,ct.Product_Document__r.Language__c,ct.Product_Document__c,ct.Product_Document__r.File_Description__c,
                                                                        '',0.0);
                        //if this document already in cart with pending status adding it's added quantity and line itme id,so again click on add to cart update line item not create new one.
                        if(salesOrderLineMap.containskey(ct.Product_Document__c)){
                            Sales_Aid_Order_Line__c sol = salesOrderLineMap.get(ct.Product_Document__c);
                            salesAidsObj.salesOrderItemId =sol.Id;
                            salesAidsObj.quantity = sol.Quantity__c != null ? Integer.valueOf(sol.Quantity__c) : 0;
                        }
                        salesAidsDocmentSObj.salesAidsMap.put(ct.Product_Document__c,salesAidsObj);
                    }
                    
                    
                    //fetch main category
                    String category = ct.Content_Main_Type__c != null ? ct.Content_Main_Type__c : 'Blank';
                    CategoryWrapper categoryObj = categoryMap.get(category);
                    if(categoryObj == null){
                        categoryObj = new CategoryWrapper(category);
                        categoryMap.put(category,categoryObj);
                        salesAidsDocmentSObj.categorylist.add(categoryObj);
                    }
                    
                    //fetch subcategory
                    String subcategory = ct.Content_Sub_Type__c != null ? ct.Content_Sub_Type__c : 'Blank';
                    subCategoryWrapper subCategoryobj = categoryObj.subcategoryMap.get(subcategory);
                    if(subCategoryobj == null){
                        subCategoryobj = new subCategoryWrapper(subcategory);
                        categoryObj.subcategoryMap.put(subcategory,subCategoryobj);
                        categoryObj.subcategorylist.add(subCategoryobj);                        
                    }
                    
                    String key = category + '#' + subcategory;
                    
                    List<SalesAidsWrapper> salesAidslist = tempsalesAidsMap.get(key);
                    if(salesAidslist == null){
                        salesAidslist = new List<SalesAidsWrapper>();                           
                    }
                    
                    salesAidslist.add(salesAidsObj);
                    tempsalesAidsMap.put(key,salesAidslist);
                }
                
                integer count = 0;
                integer totalSalesAids = 0;
                integer totalrows = 0;
                                
                // if there are sales aids found
                if(salesAidsDocmentSObj.categorylist.size()>0){
                    for(CategoryWrapper ct : salesAidsDocmentSObj.categorylist){
                       
                        for(subCategoryWrapper subcat : ct.subcategorylist){
                            count = 0;
                            totalrows = 0;
                            
                            String key = ct.categoryName + '#' + subcat.subcategoryName;
                            List<SalesAidsWrapper> salesAidslist = tempsalesAidsMap.get(key);
                            totalSalesAids = salesAidslist.size();
                            totalrows = (totalSalesAids/5);
                            if( Math.mod(totalSalesAids,5) > 0){
                                totalrows++;    
                            }
                            
                            for(integer i=1;i<=totalrows;i++){
                                Row newrow = new Row();      
                                
                                while(newrow.salesAidslist.size()<5){
                                    System.debug(' totalrows ==>'+totalrows + ' count==>'+count + ' totalSalesAids==>'+totalSalesAids);                          
                                    if(count < totalSalesAids){
                                        newrow.salesAidslist.add(salesAidslist[count]);                                   
                                     }else{
                                         newrow.salesAidslist.add(new SalesAidsWrapper());                                   
                                     }
                                     count++;
                                    
                                }                                
                                subcat.rows.add(newrow);
                                system.debug('@@ subcat==>'+subcat);
                            }
                            
                        }
                    }
                }
                
            }
        }
        
        
        return salesAidsDocmentSObj;
    }
    
    //add product inot current cart of the login user
    @AuraEnabled
    public static SalesAidsWrapper addToCart(String salesAidsjson){
       SalesAidsWrapper salesAids = (SalesAidsWrapper)JSON.deserialize(salesAidsjson,SalesAidsWrapper.class);
       try{
           
           System.debug('@@@ salesAids==>'+salesAids);
            salesAids.isError = false;
            User loginUser = [Select id,contactId from User where ID =: userinfo.getUserId()];
            if(loginUser.contactId != null){
                List<Sales_Aid_Order__c> salesorderlist = [Select id from Sales_Aid_Order__c where Partner__c =: loginUser.contactId AND Status__c = 'In Progress' limit 1];
                ID salesOrderId;
                if(salesorderlist.size()>0){
                    salesOrderId = salesorderlist[0].Id;
                }else{
                    //create new sales order id
                    Sales_Aid_Order__c newSalesAidOrder = new Sales_Aid_Order__c(Partner__c = loginUser.contactId,Status__c = 'In Progress');
                    insert newSalesAidOrder;
                    salesOrderId = newSalesAidOrder.Id;
                }
                
                //create new sales Aids line item
                boolean isUpdate = false;
                Sales_Aid_Order_Line__c lineItem;
                if(salesAids.salesOrderItemId != null){
                     lineItem = new Sales_Aid_Order_Line__c(id = salesAids.salesOrderItemId);
                     isUpdate = true;
                }else{
                     lineItem = new Sales_Aid_Order_Line__c();
                     lineItem.Sales_Aid_Order__c = salesOrderId;
                }
                
                
                lineItem.Quantity__c = salesAids.quantity;
                lineItem.Price__c = salesAids.quantity * salesAids.unitprice;
                lineItem.Product_Document__c = salesAids.productDocId;
                lineItem.Status__c = 'Pending';
                upsert lineItem;
                salesAids.salesOrderItemId = lineItem.Id;
                if(isUpdate){
                    salesAids.message = 'Item(s) successfully updated ✓';                    
                }else{
                    salesAids.message = 'Item(s) successfully added to order ✓';
                }
            }else{
                salesAids.message = 'You are logged in as an internal user. For help ordering sales aids, please contact Marketing or partnerportal@kvh.com with your order.';
                salesAids.isError = true;
            }
        }catch(Exception ex){
            salesAids.message = ex.getMessage();
            salesAids.isError = true;
        }
        return salesAids;
    }
    
     /************************************************
        Name     :     FetchOrderLine
        Descripiton :  fetch the passed prod_document's sales order line
                       for sales aids popup
    ******************************************************/
    @AuraEnabled
    public static SalesAidsWrapper fetchOrderLine(String docId){
        SalesAidsWrapper linewrapper;
        List<User> userObj = [Select contactId from User where id =: userinfo.getuserid()];
        List<Prod_Documents__c> prodDoclst = [Select id,Sub_Title__c,File_Description__c,Title_Display_Name__c,Image_URL__c,Hosting_URL__c,Language__c from Prod_Documents__c where ID =: docId];
        Prod_Documents__c prodDoc = prodDoclst.size()>0 ? prodDoclst[0] : new Prod_Documents__c();
        linewrapper = new SalesAidsWrapper(prodDoc.Sub_Title__c,prodDoc.Image_URL__c,prodDoc.Hosting_URL__c,prodDoc.Title_Display_Name__c,prodDoc.Language__c,prodDoc.id,prodDoc.File_Description__c,'',0.0);
        if(userObj[0].contactId != null){
            List<Sales_Aid_Order_Line__c> ordelines = [Select id, Quantity__c,Price__c,Sales_Aid_Order__c
                                                        from Sales_Aid_Order_Line__c where Product_Document__c =: docId 
                                                        AND Sales_Aid_Order__r.Status__c = 'In Progress' 
                                                        AND Sales_Aid_Order__r.Partner__c =: userObj[0].contactId limit 1];
            Sales_Aid_Order_Line__c orderline = ordelines.size()>0 ? ordelines[0] : new Sales_Aid_Order_Line__c(Product_Document__c = docId,Quantity__c = 1,Price__c = 0.0);
            linewrapper.quantity = orderline.Quantity__c != null ? Integer.valueof(orderline.Quantity__c) : 1;
            linewrapper.salesOrderItemId = orderline.Id;
        }
        return linewrapper;
        
    }
   
    public class SalesAidsDocuments{
        @AuraEnabled
        public List<CategoryWrapper> categorylist;
        @AuraEnabled
        public Map<String,SalesAidsWrapper> salesAidsMap;        
        
        
        public SalesAidsDocuments(){
            this.categorylist = new List<CategoryWrapper>();
            this.salesAidsMap = new Map<String,SalesAidsWrapper>();
          
        }
    }
    
    public class CategoryWrapper{
        @AuraEnabled
        public String categoryName {get;set;}       
        @AuraEnabled
        public List<subCategoryWrapper> subcategorylist{get;set;}
        
        public Map<String,subCategoryWrapper> subcategoryMap;
        
        public CategoryWrapper(String categoryName){
            this.categoryName = categoryName;            
            this.subcategorylist = new List<subCategoryWrapper>();
            this.subcategoryMap = new Map<String,subCategoryWrapper>();
        }     
    }
    
    public class subCategoryWrapper{
        @AuraEnabled
        public String subcategoryName {get;set;}
        @AuraEnabled
        public List<Row> rows{get;set;}
        
        //public List<SalesAidsWrapper> tempsalesAidslist;
        
        public subCategoryWrapper(String subcategoryName){
            this.subcategoryName = subcategoryName;
            this.rows = new List<Row>();           
        }
    }
    
    public class Row{
        @AuraEnabled
        public List<SalesAidsWrapper> salesAidslist;
        public Row(){
            this.salesAidslist = new List<SalesAidsWrapper>();            
        }
    }
    
   
    public class SalesAidsWrapper{
        @AuraEnabled
        public String productName;
        @AuraEnabled
        public String subtitle;
        @AuraEnabled
        public String imageURL;
        @AuraEnabled
        public String hostingURL;
        @AuraEnabled
        public String productDocId;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String size;
        @AuraEnabled
        public integer quantity;
        @AuraEnabled
        public decimal unitprice;
        @AuraEnabled
        public decimal totalcost;
        @AuraEnabled
        public String language;
        
        @AuraEnabled
        public String salesOrderItemId;
        @AuraEnabled
        public String message;        
        @AuraEnabled
        public boolean isError;
        
        public SalesAidsWrapper(){
           
            this.productName = 'blank column';
            this.imageURL = 'noimage';
            this.isError = false;
        }
        public SalesAidsWrapper(String subtitle,String imageURL,String hostingURL,String productName,String language,String productDocId,String description,String size,decimal unitprice){
            this.productName = productName;
            this.productDocId = productDocId;
            this.description = description;
            this.size = size;
            this.unitprice = unitprice;
            this.quantity = 1;
            this.totalcost = 0.0;
            this.hostingURL = hostingURL;
            this.imageURL = (imageURL == null ? 'noimage' : imageURL );
            this.isError = false;
            this.language = language;
            this.subtitle = subtitle;
        }
    }
}