/*********************************************************
    Name        :        UploadDocumentsController
    Date        :        April, 10th 2017
    Description :        This is the controller for upload documents to AWS
*********************************************************/
public without sharing class UploadDocumentsControllerbackup{
    public Prod_Doc_Library__c prodDocLib{get;set;}
    public Prod_Documents__c prodDoc{get;set;}
    public boolean isPrivate{get;set;}
    public List<SelectOption> leftOptions{get;set;}
    public List<SelectOption> rightOptions{get;set;}
    
    
    public UploadDocumentsControllerbackup(){
        init();
    }
    
    public void init(){ 
        defaultPortalViews();
        isPrivate = false;
        prodDocLib = new Prod_Doc_Library__c();
        prodDoc = new Prod_Documents__c();
    }
    
    public void defaultPortalViews(){
        leftOptions = new List<SelectOption>();
        for(Schema.PicklistEntry f : Product_Market_Sector__c.Portal_View__c.getDescribe().getPicklistValues()){
            if(f.getValue() != 'None')
             leftOptions.add(new SelectOption(f.getLabel(), f.getValue()));  
        }       
        rightOptions = new List<SelectOption>();
    }
    
    public void saveRecords(){    
        System.debug('@@ rightOptions==>'+rightOptions + prodDocLib.Product_Id__c );
        String selectedProduct = prodDocLib.Product_Id__c;
        
        insert prodDoc;
        List<Prod_Doc_Library__c> docliblst = new List<Prod_Doc_Library__c>();
        
        List<Product_Market_Sector__c> marketsectorlst = new List<Product_Market_Sector__c>();
        if(selectedProduct == null || selectedProduct == ''){
            for(SelectOption so : rightOptions){
                marketsectorlst.add(new Product_Market_Sector__c(Name = prodDoc.Name + ' - ' +so.getValue(),Portal_View__c = so.getValue()));
            }
        }else if(rightOptions.size()>0){
            for(SelectOption so : rightOptions){
                docliblst.add(new Prod_Doc_Library__c(Name = prodDoc.Name + ' - ' +so.getValue()));
            }
        }
        
        if(marketsectorlst.size()>0)
            insert marketsectorlst;
        
        if(docliblst.size()>0)
            insert docliblst;
    }
    
    public List<SelectOption> getDocumentTypes(){
        List<SelectOption> documentTypeOpts = new List<SelectOption>();
        Set <string> str;
        documentTypeOpts.add(new SelectOption('','None'));
        for(Content_Type__c dt : [select Content_Main_Type__c from Content_Type__c limit 1000]){
            str.add(dt.Content_Main_Type__c);
        }
        for(string s : str){
            documentTypeOpts.add(new SelectOption(s,s));
        }
        return documentTypeOpts;
    }
    
   
    public void fetchPortalViews(){
        
        leftOptions = new List<SelectOption>();
        rightOptions = new List<SelectOption>();
        for(Product_Market_Sector__c pm : [Select id,Portal_View__c from Product_Market_Sector__c where Product__c =: prodDocLib.Product_Id__c AND Portal_View__c != null]){
            
            leftOptions.add(new SelectOption(pm.Portal_View__c,pm.Portal_View__c));
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