/*********************************************************
    Name        :        Prod_DocSearchController
    Date        :        April, 8th 2017
    Description :        This is the controller which search
                         the products by passed term string in name
                         and description field
*********************************************************/
public without sharing class Prod_DocSearchController{
    public string getProdDocuments(){
        String jsonstr = '';
        String term = apexpages.currentpage().getparameters().get('term');
        List<DataWrapper> wrapperlst = new List<DataWrapper>();
        if(term != null & term.trim().length() >0){
          
            term = '%' + term + '%';
            List<Prod_Documents__c> documentlst = [Select ID,Title_Display_Name__c, Language__c,Associated_Content_Types__c from Prod_Documents__c where NAME LIKE : term OR Title_Display_Name__c LIKE : term];      
            if(documentlst.size()>0){
                for(Prod_Documents__c d : documentlst){
                    string s;
                    if(d.Language__c != 'English' && d.Language__c != '' && d.Language__c != null && d.Associated_Content_Types__c != null){
                        s = ' (' + d.Language__c + ') - (' + d.Associated_Content_Types__c + ')';
                    } else if(d.Language__c != 'English' && d.Language__c != '' && d.Language__c != null){
                        s = ' (' + d.Language__c + ') - No content types';
                    } else if(d.Associated_Content_Types__c != null){
                        s = ' - (' + d.Associated_Content_Types__c + ')';
                    } else{
                        s = ' - No content types';
                    }
                    wrapperlst.add(new DataWrapper(d.Title_Display_Name__c + s,d.id));
                }
            }else{
                wrapperlst.add(new DataWrapper('No Result found',NULL));
            }
            
            if(wrapperlst.size()>0)
                jsonstr = json.serialize(wrapperlst);
        }
        return jsonstr;
    } 
    
    public string getContentLinks(){
        String jsonstr = '';
        String term = apexpages.currentpage().getparameters().get('term');
        List<DataWrapper> wrapperlst = new List<DataWrapper>();
        if(term != null & term.trim().length() >0){
          
            term = '%' + term + '%';
            List<Prod_Documents__c> documentlst = [Select ID,Title_Display_Name__c, Language__c,Associated_Content_Types__c from Prod_Documents__c where Content_Link__c != null AND (NAME LIKE : term OR Title_Display_Name__c LIKE : term)];      
            if(documentlst.size()>0){
                for(Prod_Documents__c d : documentlst){
                    string s;
                    if(d.Language__c != 'English' && d.Language__c != '' && d.Language__c != null && d.Associated_Content_Types__c != null){
                        s = ' (' + d.Language__c + ') - (' + d.Associated_Content_Types__c + ')';
                    } else if(d.Language__c != 'English' && d.Language__c != '' && d.Language__c != null){
                        s = ' (' + d.Language__c + ') - No content types';
                    } else if(d.Associated_Content_Types__c != null){
                        s = ' - (' + d.Associated_Content_Types__c + ')';
                    } else{
                        s = ' - No content types';
                    }
                    wrapperlst.add(new DataWrapper(d.Title_Display_Name__c + s,d.id));
                }
            }else{
                wrapperlst.add(new DataWrapper('No Result found',NULL));
            }
            
            if(wrapperlst.size()>0)
                jsonstr = json.serialize(wrapperlst);
        }
        return jsonstr;
    }
    
    public string getContentFiles(){
        String jsonstr = '';
        String term = apexpages.currentpage().getparameters().get('term');
        List<DataWrapper> wrapperlst = new List<DataWrapper>();
        if(term != null & term.trim().length() >0){
          
            term = '%' + term + '%';
            List<Prod_Documents__c> documentlst = [Select ID,Title_Display_Name__c, Language__c, Associated_Content_Types__c from Prod_Documents__c where Content_Link__c = null AND (NAME LIKE : term OR Title_Display_Name__c LIKE : term)];      
            if(documentlst.size()>0){
                for(Prod_Documents__c d : documentlst){
                    string s;
                    if(d.Language__c != 'English' && d.Language__c != '' && d.Language__c != null && d.Associated_Content_Types__c != null){
                        s = ' (' + d.Language__c + ') - (' + d.Associated_Content_Types__c + ')';
                    } else if(d.Language__c != 'English' && d.Language__c != '' && d.Language__c != null){
                        s = ' (' + d.Language__c + ') - No content types';
                    } else if(d.Associated_Content_Types__c != null){
                        s = ' - (' + d.Associated_Content_Types__c + ')';
                    } else{
                        s = ' - No content types';
                    }
                    wrapperlst.add(new DataWrapper(d.Title_Display_Name__c + s,d.id));
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