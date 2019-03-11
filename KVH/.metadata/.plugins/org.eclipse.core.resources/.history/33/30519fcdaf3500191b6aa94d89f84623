/***********************************************************
    Name        :        CatalogAddProductController
    Description :        Add product to catelog
***********************************************************/
public class CatalogAddProductController{
    public String productId{get;set;}
    public Product2 prod{get;set;}
    public Id pid{get;set;}
    public string retURL{get;set;}
    public List<Product_Market_Sector__c> marketSectorlst{get;set;}
    public integer rownumber{get;set;}
    public boolean isSuccess{get;set;}
    public boolean apply{get;set;}  
    public List<Product2> relprods{get;set;}
    
    private Set<Id> deleteMarketSectorIds;
    public CatalogAddProductController(){
        init();
         productId = ApexPages.currentPage().getParameters().get('productId');
         retURL = ApexPages.currentPage().getParameters().get('retURL');
        if(productId != null){
             fetchProductdetails();
        }
    }
    
    public void init(){
        isSuccess = false;
        deleteMarketSectorIds = new Set<Id>();
        productId = '';
        prod = new Product2();
        marketSectorlst = new List<Product_Market_Sector__c>();
        relprods = new List<Product2>();
    }

    public Pagereference saveRecords(){
         Savepoint sp = Database.setsavepoint();
        try{
            // Delete Market sector if any        
            if(deleteMarketSectorIds.size()>0){
                List<Product_Market_Sector__c> deletelst = [Select id from Product_Market_Sector__c where ID IN : deleteMarketSectorIds];
                if(deletelst.size()>0)
                    delete deletelst;
            }
            
            string pname = prod.Name.right(6);
            //add Bundle to the end of the product name if it is not there already
            if(pname != 'Bundle'){
                prod.Name = prod.Name + ' Bundle';
            }
            update prod;
            
            //upsert the market/sector list            
            if(marketSectorlst.size()>0){
                for(Product_Market_Sector__c ms : marketSectorlst){
                }
                upsert marketSectorlst;
            }
            isSuccess = true;
        }catch(Exception ex){           
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getmessage()));
            Database.rollback(sp);      
        }        
        return null;
    }
    
    public void createProduct(){
        try{
            string pname = prod.Name.right(6);
            if(pname != 'Bundle'){
                prod.Name = prod.Name + ' Bundle';
            }
            insert prod;
            if(marketSectorlst.size()>0){
                for(Product_Market_Sector__c ms : marketSectorlst){
                	ms.Product__c = prod.Id;
                }
                insert marketSectorlst;
            }
            if(apply && relprods.size() > 0){
                Set <string> pviews = new Set<string>();
                for(Product_Market_Sector__c pms : marketSectorlst){
                    pviews.add(pms.Portal_View__c);
                }
                List <Product_Catalogue__c> prodCats = [SELECT 	CSN_Level__c, Services_Only__c, Sales__c, Partner_Account__c, Portal_View__c, Product_Market_Sector__c, Id FROM Product_Catalogue__c WHERE Product_Market_Sector__r.Portal_View__c IN :pviews AND Product_Market_Sector__r.Product__c IN : relprods];
                List <Product_Catalogue__c> newProdCats = new List<Product_Catalogue__c>();
                for(Product_Catalogue__c pc : prodCats){
                    for(Product_Market_Sector__c pms : marketSectorlst){
                        if(pc.Portal_View__c == pms.Portal_View__c){
                            Product_Catalogue__c tempPC = new Product_Catalogue__c();
                            tempPC.Product_Market_Sector__c = pms.Id;
                            tempPC.Partner_Account__c = pc.Partner_Account__c;
                            tempPC.CSN_Level__c = pc.CSN_Level__c;
                            tempPC.Services_Only__c = pc.Services_Only__c;
                            tempPC.Sales__c = pc.Sales__c;
                            newProdCats.add(tempPC);
                        }
                        
                    }
                    
                }
                insert newProdCats;
            }
            isSuccess = true;  
        } catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getmessage()));
        }   
         
    }
    
    public void addProduct(){
        try{
            insert prod;
            if(marketSectorlst.size()>0){
                for(Product_Market_Sector__c ms : marketSectorlst){
                	ms.Product__c = prod.Id;
                }
                insert marketSectorlst;
            }
        } catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getmessage()));
        }   
        isSuccess = true;   
    }
    
    public void addProdToTable(){
        string passedParam1 = Apexpages.currentPage().getParameters().get('pid');
        Product2 temp = [SELECT Id, Catalog_Display_Name__c FROM Product2 WHERE Id =: passedParam1];
		relprods.add(temp);
    }
    
    public void fetchProductdetails(){
        prod = [Select id,IsActive, Product_Line1__c, Product_ID_18_char__c, Product_Series__c, name,Product_ID__c,Catalog_Display_Name__c,Catalog_Long_Description__c,Display_Product__c
                from Product2 where ID =: productId];
        if(prod.name.right(6) == 'Bundle'){
            prod.Name = prod.Name.removeEnd(' Bundle');
        }
        marketSectorlst = [Select id,Name,Market__c,Portal_View__c,Product__c,Product_Line__c,Product_Series__c,Sector__c
                             from Product_Market_Sector__c where Product__c =: prod.Id];
        if(marketSectorlst.size() == 0){
            addnewMarketsector();
        }
    }
    
    public void addnewMarketsector(){
        marketSectorlst.add(new Product_Market_Sector__c(Product__c = productId));
    }
    
    public void removeMarketsector(){
        if(rownumber != null){
           Product_Market_Sector__c ms = marketSectorlst.remove(rownumber);
           if(ms.ID != null)
               deleteMarketSectorIds.add(ms.Id);
        }
    }
}