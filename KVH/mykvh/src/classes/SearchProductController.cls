/*********************************************************
    Name        :        SearchProductController
    Date        :        April, 8th 2017
    Description :        This is the controller which search
                         the products by passed term string in name
                         and description field
*********************************************************/
public without sharing class SearchProductController{
    public string getProducts(){
        String jsonstr = '';
        String term = apexpages.currentpage().getparameters().get('term');
        List<DataWrapper> productlst = new List<DataWrapper>();
        if(term != null & term.trim().length() >0){
           /* term = term.replaceAll('\\\\','/');
            term = term.replaceAll('\\?','\\\\?').replaceAll('\\&','\\\\&').replaceAll('\\|','\\\\|').replaceAll('\\!','\\\\!').replaceAll('\\{','\\\\{');
            term = term.replaceAll('\\}','\\\\}').replaceAll('\\[','\\\\[').replaceAll('\\]','\\\\]').replaceAll('\\(','\\\\(').replaceAll('\\)','\\\\)');
            term = term.replaceAll('\\^','\\\\^').replaceAll('\\~','\\\\~').replaceAll('\\*','\\\\*').replaceAll('\\:','\\\\:');
            term = term.replaceAll('\\"','\\\\"').replaceAll('\\\'','\\\'').replaceAll('\\+','\\\\+').replaceAll('\\-','\\\\-');
            String query = 'Find {' + term +'} IN ALL FIELDS RETURNING Product2(ID,NAME,Product_ID__c,Catalog_Display_Name__c)'; 
            System.debug('@@ query==>'+query);
            List<List<SObject>>searchList = search.query(query);
            System.debug('@@ searchList ==>'+searchList);     */
            term = '%' + term + '%';
            List<Product2> allproductlst = [Select ID,NAME,Product_ID__c,Catalog_Display_Name__c from Product2 where Display_Product__c = 'Yes' AND (Catalog_Display_Name__c like : term  OR Product_ID__c like : term)];      
            if(allproductlst.size()>0){
                for(Product2 p : allproductlst){
                    productlst.add(new DataWrapper(p.Product_ID__c + '-' + p.Catalog_Display_Name__c,p.id));
                }
            }else{
                productlst.add(new DataWrapper('No Result found',NULL));
            }
            
            if(productlst.size()>0)
                jsonstr = json.serialize(productlst);
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