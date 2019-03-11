/*******************************************************
Name        :    UpdateDocumentController
Description :    Controller for update document
*********************************************************/
public class UpdateDocumentController{
    public String productDocId{get;set;}
    public boolean deleteDocument{get;set;}
    public Prod_Documents__c prodDoc{get;set;}
    public String delhostingurl{get;set;}
    public String contenttype{get;set;}
    public String newFileName{get;set;}
    private String query;
    private boolean firedefaultPortalview;
    public Integer toDelIdent {get; set;}
    public Integer addCount {get; set;}
    private Integer nextIdent=1;
    public List<ContentWrapper> wrappers {get; set;}
    public List<Prod_Doc_Library__c> libs {get; set;}
    public List<Content_Type__c> cts {get;set;}
    public string access {get;set;}
    public string url {get;set;}
    
    
    public UpdateDocumentController(ApexPages.StandardController sc){
        prodDoc = (Prod_Documents__c)sc.getRecord();
        init();
    }
    
    public void init(){ 
        wrappers = new List<ContentWrapper>();
        for (Integer idx=0; idx<1; idx++) {
            wrappers.add(new ContentWrapper(nextIdent++));
        }
        if(prodDoc.Id != null){
            prodDoc = [Select id,Name,Gated_Document__c,Production_URL__c, KVH_com__c, Content_Link__c,Sales_Aid__c, Active__c, HTML_Field__c, Display_HTML_Page__c, Display_Terms_and_Conditions_Page__c, Size_Description__c, Insertion_Code__c, Alternate_Text__c,File_Access__c,File_Description__c,File_Extension__c,Height__c,Hide_for_Partner_Type__c,
                       Hosting_URL__c,Filename_in_AWS__c, Image_URL__c,Language__c,Marketo_URL__c,Partner_Portal__c,Press_Room__c,Product_Pages__c,Revision__c,Site_Core_URL__c,
                       Sub_Title__c,Support_Section__c,Terms_and_Conditions_1__c,Title_Display_Name__c,Width__c from Prod_Documents__c where ID =: prodDoc.Id];
            cts = [SELECT Content_Main_Type__c, Sales_Tool_Kit_s__c, Content_Sub_Type__c FROM Content_Type__c WHERE Product_Document__c =: prodDoc.Id];
            if(cts.size()>0){
                wrappers.clear();
                for(Content_Type__c contype: cts){
                    ContentWrapper cw = new ContentWrapper(nextIdent++);
                    cw.ct = contype;
                    wrappers.add(cw);
                }
            }
            libs = [SELECT PortalView__c, Product_Catalog_Display_Name__c FROM Prod_Doc_Library__c WHERE Filename__c =:prodDoc.Id];
            access = prodDoc.File_Access__c;
        }
        deleteDocument = false;
        
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
    
    public void fetchProdDocumentObject(){
        if(productDocId != null){
            wrappers.clear();
            prodDoc = [Select id,Name,Gated_Document__c,KVH_com__c, Content_Link__c,Sales_Aid__c, Active__c, HTML_Field__c, Display_HTML_Page__c, Display_Terms_and_Conditions_Page__c, Size_Description__c, Insertion_Code__c, Alternate_Text__c,File_Access__c,File_Description__c,File_Extension__c,Height__c,Hide_for_Partner_Type__c,
                       Hosting_URL__c,Filename_in_AWS__c, Image_URL__c,Language__c,Marketo_URL__c,Partner_Portal__c,Press_Room__c,Product_Pages__c,Revision__c,Site_Core_URL__c,
                       Sub_Title__c,Support_Section__c,Terms_and_Conditions_1__c,Title_Display_Name__c,Width__c from Prod_Documents__c where ID =: productDocId];
            cts = [SELECT Content_Main_Type__c, Sales_Tool_Kit_s__c, Content_Sub_Type__c FROM Content_Type__c WHERE Product_Document__c =: productDocId];
            for(Content_Type__c contype: cts){
                ContentWrapper cw = new ContentWrapper(nextIdent++);
                cw.ct = contype;
                wrappers.add(cw);
                
            }
            productDocId = null;
        }           
    }
    public void updateConLink(){  
        List <Content_Type__c> cts = [SELECT Content_Main_Type__c, Content_Sub_Type__c FROM Content_Type__c WHERE Product_Document__c =: prodDoc.Id];
        delete cts;
        String selectedContent;
        List <Content_Type__c> newcts = new List<Content_Type__c>();
        if(wrappers.size()>0 ){ 
            for(ContentWrapper wrap : wrappers ){
            	if(wrap.ct.Content_Main_Type__c != null){
                    Content_Type__c tempCT = new Content_Type__c(Content_Main_Type__c = wrap.ct.Content_Main_Type__c, Content_Sub_Type__c = wrap.ct.Content_Sub_Type__c,Sales_Tool_Kit_s__c = wrap.ct.Sales_Tool_Kit_s__c, Product_Document__c = prodDoc.Id);
                    newcts.add(tempCT);
                    if(selectedContent == null){
                        selectedContent = wrap.ct.Content_Main_Type__c;
                    } else{
                        selectedContent = selectedContent + ', ' + wrap.ct.Content_Main_Type__c;
                    }
                }
            }
            system.debug(newcts);
            insert newcts;
        }
        prodDoc.Associated_Content_Types__c = selectedContent;
        update prodDoc; 
    }
    

    public void saveRecords(){ 
        system.debug(prodDoc.Name);
        update prodDoc;
        Prod_Documents__c tempprodDoc =[SELECT Internal_Document_Record__c, Hosting_URL__c FROM Prod_Documents__c WHERE Id =: prodDoc.Id];
        List <Content_Type__c> cts = [SELECT Content_Main_Type__c, Content_Sub_Type__c FROM Content_Type__c WHERE Product_Document__c =: prodDoc.Id];
        delete cts;
        String selectedContent;
        List <Content_Type__c> newcts = new List<Content_Type__c>();
        if(wrappers.size()>0 ){ 
            for(ContentWrapper wrap : wrappers ){
            	if(wrap.ct.Content_Main_Type__c != null){
                    Content_Type__c tempCT = new Content_Type__c(Content_Main_Type__c = wrap.ct.Content_Main_Type__c, Content_Sub_Type__c = wrap.ct.Content_Sub_Type__c,Sales_Tool_Kit_s__c = wrap.ct.Sales_Tool_Kit_s__c, Product_Document__c = prodDoc.Id);
                    newcts.add(tempCT);
                    if(selectedContent == null){
                        selectedContent = wrap.ct.Content_Main_Type__c;
                    } else{
                        selectedContent = selectedContent + ', ' + wrap.ct.Content_Main_Type__c;
                    }
                }
            }
            system.debug(newcts);
            insert newcts;
        }
        prodDoc.Associated_Content_Types__c = selectedContent;
        prodDoc.Internal_Document_Record__c = tempprodDoc.Internal_Document_Record__c;
        prodDoc.Hosting_URL__c = tempprodDoc.Hosting_URL__c;
        update prodDoc;        
    }
    
    public class ContentWrapper {
        public Content_Type__c ct {get; set;}
        public Integer ident {get; set;}
        public ContentWrapper(Integer inIdent) {
            ident = inIdent;
            ct = new Content_Type__c();
        }
    }
    @remoteaction
	public static void updatecontent(string fileName, string base64Data, string contentType, string pdid){
        Prod_Documents__c prodDoc =[SELECT Internal_Document_Record__c, Hosting_URL__c FROM Prod_Documents__c WHERE Id =: pdid];
        ContentVersion convers = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: prodDoc.Internal_Document_Record__c];
        ContentWorkspace lib = [SELECT Id FROM ContentWorkspace WHERE Name = 'Partner Portal Private'];
        system.debug(lib);
        ContentVersion cv = new ContentVersion();
        cv.ContentDocumentId = convers.ContentDocumentId;
        cv.ContentLocation = 'S';
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.Title = fileName;
        cv.PathOnClient = filename;
        insert cv;

        prodDoc.Internal_Document_Record__c = cv.Id;
        prodDoc.Hosting_URL__c = 'https://kvhcommunity.force.com/partnerportal/sfc/servlet.shepherd/version/download/' + cv.Id;
        system.debug('url:' + prodDoc.Hosting_URL__c);
        update prodDoc;

    }
    
    @remoteaction
    public static Security__c fetchCredentials(){  
        Security__c keys = [SELECT Bucket__c, Name, Algorithm__c, Key__c FROM Security__c WHERE Name = 'PublicAWS'];
		return keys;
    }
}