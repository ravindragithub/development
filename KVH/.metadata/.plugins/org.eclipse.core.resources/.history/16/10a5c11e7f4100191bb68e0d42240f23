/*********************************************************
    Name        :        UploadDocumentsController
    Date        :        April, 10th 2017
    Description :        This is the controller for upload documents to AWS
*********************************************************/
public without sharing class UploadDocumentsController{
    public Prod_Doc_Library__c prodDocLib{get;set;} 
    public Prod_Documents__c prodDoc {get;set;}
    public Product2 prod {get;set;}
    public String productDocId{get;set;}
    public boolean isPrivate{get;set;}
    public string pdid;
    public List<SelectOption> leftOptions{get;set;}
    public List<SelectOption> rightOptions{get;set;}
    public Product_Market_Sector__c marketSector{get;set;}
    public List<SelectOption> productleftOptions{get;set;}
    public List<SelectOption> productrightOptions{get;set;}
    public List<Prod_Doc_Library__c> libs {get; set;}
    public String market{get;set;}
    public String sector{get;set;}
    public String productline{get;set;}
    public String productseries{get;set;}
    public Integer toDelIdent {get; set;}
    public Integer addCount {get; set;}
    private Integer nextIdent=1;
    public List<ContentWrapper> wrappers {get; set;}
    public String prodIds {get;set;}
    
    private String query;
    private boolean firedefaultPortalview;
    
    public UploadDocumentsController(ApexPages.StandardController sc){
        prodDoc = (Prod_Documents__c)sc.getRecord();
        init();
    }
    
    public void init(){ 
        wrappers = new List<ContentWrapper>();
        for (Integer idx=0; idx<1; idx++) {
            wrappers.add(new ContentWrapper(nextIdent++));
        }
        marketSector = new Product_Market_Sector__c();
        defaultPortalViews();
        isPrivate = false;
        prodDocLib = new Prod_Doc_Library__c();
        
        productleftOptions = new List<SelectOption>();
        productrightOptions = new List<SelectOption>(); 
        if(prodDoc.Id != null){
            productDocId = prodDoc.Id;
            prodDoc = [Select id,Name,Content_Link__c,Sales_Aid__c, Active__c, HTML_Field__c, Display_HTML_Page__c, Display_Terms_and_Conditions_Page__c, Size_Description__c, Insertion_Code__c, Alternate_Text__c,File_Access__c,File_Description__c,File_Extension__c,Height__c,Hide_for_Partner_Type__c,
                       Hosting_URL__c,Image_URL__c,Language__c,Marketo_URL__c,Partner_Portal__c,Press_Room__c,Product_Pages__c,Revision__c,Site_Core_URL__c,
                       Sub_Title__c,Support_Section__c,Terms_and_Conditions_1__c,Title_Display_Name__c,Width__c from Prod_Documents__c where ID =: prodDoc.Id];
            libs = [SELECT PortalView__c, Product_Market_Sector__r.Product__r.Catalog_Display_Name__c, Product_Market_Sector__r.Product__r.Product_Series__c, Product_Market_Sector__r.Product__r.Product_Line1__c, Market__c, Sector__c, Product_Catalog_Display_Name__c FROM Prod_Doc_Library__c WHERE Filename__c =:prodDoc.Id ORDER BY PortalView__c ASC, Product_Market_Sector__r.Product__r.Product_Series__c ASC, Product_Market_Sector__r.Product__r.Catalog_Display_Name__c];
        }
    }
    public void addRow() {
        for (Integer idx=0; idx<addCount; idx++) {
            wrappers.add(new ContentWrapper(nextIdent++));
        }
    }
    public void delWrapper() {
        Integer toDelPos=-1;
        for (Integer idx=0; idx<wrappers.size(); idx++) {
            if (wrappers[idx].ident==toDelIdent) {
                toDelPos=idx;
            }
        }
   
        if (-1!=toDelPos) {
            wrappers.remove(toDelPos);
        }
    }
    
    public void defaultPortalViews(){
        leftOptions = new List<SelectOption>();
        for(Schema.PicklistEntry f : Product_Market_Sector__c.Portal_View__c.getDescribe().getPicklistValues()){
            if(f.getValue() != 'None')
             leftOptions.add(new SelectOption(f.getLabel(), f.getValue()));  
        }       
        rightOptions = new List<SelectOption>();
    }
    public void updateDoc(){
        system.debug(prodDoc);
        update prodDoc;
    }
    public PageReference gotonew(){
        PageReference pageRef = new PageReference('/apex/adminlandingpage');
        return pageRef;
    }
    public void deleteoldlibraries(){
        delete libs;
        saveNewLibraries();
    }
    public void saveNewLibraries(){
        String selectedProduct = prodDocLib.Product_Id__c;
        if(productrightOptions.size()>0){            
            Set<String> selectedProductIds = new Set<String>();
            Set<String> selectedportalViews = new Set<String>();
            List<Prod_Doc_Library__c> docliblst = new List<Prod_Doc_Library__c>();
            
            for(SelectOption opt : productrightOptions){
                selectedProductIds.add(opt.getvalue());
                if(prodIds == null){
                    prodIds = opt.getvalue();
                } else{
                    prodIds = prodIds + ', ' + opt.getValue();
                } 
            }
            for(SelectOption so : rightOptions){
                selectedportalViews.add(so.getvalue());
            }
            system.debug(selectedportalViews + '/' + selectedProductIds );
            List<Product_Market_Sector__c> mss = [Select id,Portal_View__c,Product__c from Product_Market_Sector__c where Portal_View__c IN : selectedportalViews 
                                                AND Product__c IN : selectedProductIds];
            for(Product_Market_Sector__c ms : mss){
                String pdName = prodDoc.Name.left(30);
                string pv = ms.Portal_View__c.left(30);
                 docliblst.add(new Prod_Doc_Library__c(Name = pdName + ' - ' +pv,Product_Market_Sector__c = ms.Id,
                    Filename__c = prodDoc.Id));
            }
            Prod_Documents__c pd = [SELECT Hosting_URL__c FROM Prod_Documents__c WHERE Id =: prodDoc.Id];
            pd.Associated_ProductIds__c = prodIds;
            update pd;
            if(docliblst.size()>0)
                insert docliblst;
        }
    }
    public void fetchProdDocumentObject(){
        if(productDocId != null){
            prodDoc = [Select id,Name,Content_Link__c,Sales_Aid__c, Active__c, HTML_Field__c, Display_HTML_Page__c, Display_Terms_and_Conditions_Page__c, Size_Description__c, Insertion_Code__c, Alternate_Text__c,File_Access__c,File_Description__c,File_Extension__c,Height__c,Hide_for_Partner_Type__c,
                       Hosting_URL__c,Image_URL__c,Language__c,Marketo_URL__c,Partner_Portal__c,Press_Room__c,Product_Pages__c,Revision__c,Site_Core_URL__c,
                       Sub_Title__c,Support_Section__c,Terms_and_Conditions_1__c,Title_Display_Name__c,Width__c from Prod_Documents__c where ID =: productDocId];
            productDocId = null;
        }           
    }
    public void saveAllRecords(){ 
        saveNewLibraries();
        String selectedContent;
        List <Content_Type__c> cts = new List <Content_Type__c>();
        if(wrappers.size()>0 ){
            if(wrappers[0].ct.Content_Main_Type__c != null){
                for(ContentWrapper wrap : wrappers ){
                    wrap.ct.Product_Document__c = prodDoc.Id;
                    cts.add(wrap.ct);
                    if(selectedContent == null){
                        selectedContent = wrap.ct.Content_Main_Type__c;
                    } else{
                        selectedContent = selectedContent + ', ' + wrap.ct.Content_Main_Type__c;
                    }
                }
                insert cts;
            }
        }
            Prod_Documents__c pd = [SELECT Associated_ProductIds__c,Hosting_URL__c FROM Prod_Documents__c WHERE Id =: prodDoc.Id];
            pd.Associated_Content_Types__c = selectedContent;
            update pd;
    }
    
    // Pulls in all the appropriate product selections from the user's input of market/sector/line/series
    public void fetchProducts(){
        Set<String> allProductIds = new Set<String>();
             
        Set<String> selectedProductIds = new Set<String>();
        for(SelectOption opt : productrightOptions){
            selectedProductIds.add(opt.getvalue());
        }
        productleftOptions = new List<SelectOption>();
        List<SelectOption> duplicateproductrightOptions  = new List<SelectOption>();
        duplicateproductrightOptions.addall(productrightOptions);
        productrightOptions = new List<SelectOption>();   
        system.debug('@@ selectedProductIds==>'+selectedProductIds);
        query = 'Select id,Portal_View__c,Product__c,Product__r.Product_ID__c,Product__r.Catalog_Display_Name__c from Product_Market_Sector__c ';
        String filters = 'Product__r.Display_Product__c = \'Yes\'';       
        if(market != null && market.trim().length()>0 && market != '__'){
            filters += ' AND Market__c =\'' + market + '\'';
        }   
        if(sector != null && sector.trim().length() >0 && sector != '__'){
            filters += ' AND Sector__c =\'' + sector + '\'';
        }
        system.debug(productline);
        if(productline != null && productline.trim().length() > 0 && productline != '__'){
                filters += ' AND Product__r.Product_Line1__c =\'' + productline + '\'';
        }   
        if(productseries != null && productseries.trim().length() > 0 && productseries != '__'){
            filters += ' AND Product__r.Product_Series__c =\'' + productseries + '\'';
        }  
        if(filters.length() > 0){
            query = query + ' where ' + filters;
        }              
        system.debug('@@ query==>'+query);
        
        for(Product_Market_Sector__c ms : Database.query(query)){
            System.debug('@@ ms.Product__c==>'+ms.Product__c);
            if(selectedProductIds.contains(ms.Product__c) && !allProductIds.contains(ms.Product__c)){
                productrightOptions.add(new SelectOption(ms.Product__c,ms.Product__r.Catalog_Display_Name__c));
            }else if(!allProductIds.contains(ms.Product__c)){
                productleftOptions.add(new SelectOption(ms.Product__c,ms.Product__r.Catalog_Display_Name__c));
            } 
            allProductIds.add(ms.Product__c);           
        }
        //add already selected products
        for(SelectOption opt : duplicateproductrightOptions){
            if(!allProductIds.contains(opt.getvalue())){
                productrightOptions.add(opt);
            }
            allProductIds.add(opt.getvalue()); 
        }
        
        firedefaultPortalview = false;
        fetchPortalViews();
        firedefaultPortalview = true;
       
    }

    public void fetchPortalViews(){
        
        leftOptions = new List<SelectOption>();
        List<SelectOption> temrightOptions = new List<SelectOption>();
        Set<String> selectedPortalviews = new Set<String>();
        if(rightOptions.size()>0){
            temrightOptions.addall(rightOptions);
            
            for(SelectOption opt : rightOptions){
                selectedPortalviews.add(opt.getvalue());
            }
            rightOptions = new List<SelectOption>();
        }
        
        
        Set<String> portalViews = new Set<String>();
        Set<String> productIds = new Set<String>();
        if(productrightOptions.size()>0 || firedefaultPortalview == false){
            
            for(SelectOption opt : productrightOptions){
                productIds.add(opt.getvalue());
            }
            String tempquery = '';
            if(productIds.size()>0){
                tempquery = query + ' AND Product__c IN : productIds';
            }else{
                tempquery = query;
            }
                
            
            for(Product_Market_Sector__c pm : Database.query(tempquery)){            
                if(!portalViews.contains(pm.Portal_View__c) && !selectedPortalviews.contains(pm.Portal_View__c)){
                    leftOptions.add(new SelectOption(pm.Portal_View__c,pm.Portal_View__c));
                }else if(!portalViews.contains(pm.Portal_View__c)){
                    rightOptions.add(new SelectOption(pm.Portal_View__c,pm.Portal_View__c));
                }
                portalViews.add(pm.Portal_View__c);
            }
            
            //add already selected portal views
            for(SelectOption opt : temrightOptions){
                if(!portalViews.contains(opt.getvalue()))
                    rightOptions.add(opt);
                portalViews.add(opt.getvalue());
            }
        }else if(firedefaultPortalview){
           defaultPortalViews(); 
        }
        
    }
    
    @remoteaction
	public static string createContent(string fileName, string base64Data, string contentType, string contentDocumentId, string pdid){

        ContentWorkspace lib = [SELECT Id FROM ContentWorkspace WHERE Name = 'Partner Portal Private'];
        system.debug(lib);
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.Title = fileName;
        cv.PathOnClient = filename;
        cv.FirstPublishLocationId = lib.Id;
        
        insert cv;              
        
        Prod_Documents__c prodDoc =[SELECT Internal_Document_Record__c, Associated_ProductIds__c, Hosting_URL__c FROM Prod_Documents__c WHERE Id =: pdid];
        prodDoc.Internal_Document_Record__c = cv.Id;
        String URL = Label.Community_URL;
        string comm = Label.Community_Prefix;
        prodDoc.Hosting_URL__c = 'https://kvhcommunity.force.com/partnerportal/sfc/servlet.shepherd/version/download/' + cv.Id;
        system.debug('url:' + prodDoc.Hosting_URL__c);
        update prodDoc;
        
        return 'success';
    }
    
    public string getpdid(){
        return pdid;
    }
    public void setpdid(string s){
        pdid = s;
    }
    public class ContentWrapper {
        public Content_Type__c ct {get; set;}
        public Integer ident {get; set;}
        public ContentWrapper(Integer inIdent) {
            ident = inIdent;
            ct = new Content_Type__c();
        }
    }
    public void createPD(){
        String pdname = prodDoc.Name;
        if(pdname.left(3) == 'a7T' || pdname.left(3) == 'a4M' || pdname == null || pdname == ''){
            prodDoc.Name = prodDoc.Title_Display_Name__c;
        }
        system.debug('prodDoc.Name: ' + prodDoc.Name);
        insert prodDoc;
        pdid = prodDoc.Id;
    }
    
    @remoteaction
    public static Security__c fetchCredentials(){  
        Security__c keys = [SELECT Bucket__c, Name, Algorithm__c, Key__c FROM Security__c WHERE Name = 'PublicAWS'];
		return keys;
    }
 
}