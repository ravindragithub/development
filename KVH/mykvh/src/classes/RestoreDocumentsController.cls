/*******************************************************
    Name        :    RestoreDocumentsController
    Description :    Controller for remove document
*********************************************************/
public class RestoreDocumentsController{
    public String productDocId{get;set;}
    public String hostingurl{get;set;}
    public Prod_Documents__c prodDoc{get;set;}
    public boolean isError{get;set;}
    
    public RestoreDocumentsController(){
        init();
    }
    
    public void init(){        
        prodDoc = new Prod_Documents__c();
    }
    
    public void fetchProdDocumentObject(){
        if(productDocId != null){
            prodDoc = [Select id,Name,Alternate_Text__c,File_Access__c,File_Description__c,File_Extension__c,Height__c,Hide_for_Partner_Type__c,
                        Hosting_URL__c,Image_URL__c,Language__c,Marketo_URL__c,Partner_Portal__c,Press_Room__c,Product_Pages__c,Revision__c,Site_Core_URL__c,
                        Sub_Title__c,Support_Section__c,Terms_and_Conditions__c,Title_Display_Name__c,Width__c from Prod_Documents__c where ID =: productDocId];
            
            productDocId = null;
            
        }           
    }
    
   
    
    public void saveRecords(){  
        isError = false;  
        Savepoint sp = Database.setsavepoint();
        try{
            if(prodDoc != null && prodDoc.Id != null){
                Deleted_Doc__c delDoc = new Deleted_Doc__c(Name = prodDoc.Name,Alternate_Text__c = prodDoc.Alternate_Text__c, File_Access__c = prodDoc.File_Access__c, File_Description__c= prodDoc.File_Description__c, File_Extension__c = prodDoc.File_Extension__c,
                                    Height__c = prodDoc.Height__c, Hide_for_Partner_Type__c= prodDoc.Hide_for_Partner_Type__c,Hosting_URL__c = hostingurl,
                                    Image_URL__c = prodDoc.Image_URL__c, Language__c = prodDoc.Language__c, Marketo_URL__c = prodDoc.Marketo_URL__c, Partner_Portal__c = prodDoc.Partner_Portal__c,
                                    Press_Room__c = prodDoc.Press_Room__c, Product_Pages__c = prodDoc.Product_Pages__c, Revision__c = prodDoc.Revision__c, Site_Core_URL__c = prodDoc.Site_Core_URL__c,
                                    Sub_Title__c = prodDoc.Sub_Title__c, Support_Section__c = prodDoc.Support_Section__c,
                                    Terms_and_Conditions__c = prodDoc.Terms_and_Conditions__c, Title_Display_Name__c = prodDoc.Title_Display_Name__c, Width__c = prodDoc.Width__c);
            
                insert delDoc;
                
                List<Deleted_Prod_Doc_Library__c> delDocliblst = new List<Deleted_Prod_Doc_Library__c>();
                for(Prod_Doc_Library__c lib : [Select id,Name,  Product_Market_Sector__r.Portal_View__c,Product_Id__c from Prod_Doc_Library__c where Filename__c =: prodDoc.Id]){
                    delDocliblst.add(new Deleted_Prod_Doc_Library__c(Name = lib.Name,Deleted_Doc__c = delDoc.Id,Portal_View__c = lib.Product_Market_Sector__r.Portal_View__c,
                                            Product_Name__c = lib.Product_Id__c));
                }
                
                if(delDocliblst.size()>0)
                    insert delDocliblst;
                delete prodDoc;
            }else{               
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a prod_Doc'));
            }
        }catch(Exception ex){
            Database.rollback(sp);            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getmessage()));
            isError = true;
        }
        
       
    }
    
    
    @remoteaction
    public static Api_Keys__c fetchCredentials(string isPrivate){     
       System.debug('@@ isPrivate==>'+isPrivate);
       Api_Keys__c keys;
       if(isPrivate == 'Private'){
           keys = Api_Keys__c.getValues('Private');
       }else{
           keys = Api_Keys__c.getValues('Public');         
       }     
       return keys;
    }
}