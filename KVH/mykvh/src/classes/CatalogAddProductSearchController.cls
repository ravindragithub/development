/*This is for Autocomplete on the product entry page of the admin tool*/
public without sharing class CatalogAddProductSearchController{
    public string getproducts(){
        String jsonstr = '';
        String term = apexpages.currentpage().getparameters().get('term');
        List<DataWrapper> wrapperlst = new List<DataWrapper>();
        if(term != null & term.trim().length() >0){
          
            term = '%' + term + '%';//add the LIKE characteristic
            
            //Search for only inactive partner portal products
            List<Product2> productlst = [Select ID,NAME,Product_ID__c,Catalog_Display_Name__c from Product2 where IsActive = TRUE AND Display_Product__c = 'No' 
                                        AND (NAME LIKE : term OR Product_ID__c LIKE : term OR ProductCode LIKE : term OR Catalog_Display_Name__c LIKE : term)
                                        AND (NOT Name LIKE '%Bundle%') ];      
            if(productlst.size()>0){
                for(Product2 p : productlst){
                    wrapperlst.add(new DataWrapper(p.Catalog_Display_Name__c+' - '+p.Product_ID__c,p.id));
                }
            }else{
                wrapperlst.add(new DataWrapper('No Result found',NULL));
            }
            
            if(wrapperlst.size()>0)
                jsonstr = json.serialize(wrapperlst);
        }
        return jsonstr;
    }
                                                               
    public string gettableProducts(){
        String jsonstr = '';
        String term = apexpages.currentpage().getparameters().get('term');
        List<DataWrapper> wrapperlst = new List<DataWrapper>();
        if(term != null & term.trim().length() >0){
          
            term = '%' + term + '%';
            List<Product2> productlst = [Select ID,NAME,Product_ID__c,Catalog_Display_Name__c from Product2 where (NAME LIKE : term OR Product_ID__c LIKE : term OR ProductCode LIKE : term OR Catalog_Display_Name__c LIKE : term)
                                        AND Name LIKE '%Bundle%' ];      
            if(productlst.size()>0){
                for(Product2 p : productlst){
                    if(p.Catalog_Display_Name__c.right(6) == 'Bundle'){
                        p.Catalog_Display_Name__c = p.Catalog_Display_Name__c.removeEnd(' Bundle');
                    }
                    wrapperlst.add(new DataWrapper(p.Catalog_Display_Name__c,p.id));
                }
            }else{
                wrapperlst.add(new DataWrapper('No Result found',NULL));
            }
            
            if(wrapperlst.size()>0)
                jsonstr = json.serialize(wrapperlst);
        }
        return jsonstr;
    }
    
    //wrapper class
    public class DataWrapper{
        public String value;
        public String data;
       
        
        public DataWrapper(String value,String data){
            this.value = value;
            this.data = data;            
        }
    }  
}