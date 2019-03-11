public class ThumbnailController {
    public Prod_Documents__c prodDoc {get;set;}
    public String productDocId{get;set;}
    
    public ThumbnailController(ApexPages.StandardController controller){
        prodDoc = (Prod_Documents__c)controller.getRecord();
        init();
    }
    
    public PageReference gotonew(){
        PageReference pageref = new PageReference('apex/adminlandingpage');
        return pageref;
    }
    
    public void updateDoc(){
        update prodDoc;
    }
    
    public void init(){ 
        if(prodDoc.Id != null){
            prodDoc = [Select id,Name,Content_Link__c,Sales_Aid__c, Active__c, HTML_Field__c, Display_HTML_Page__c, Display_Terms_and_Conditions_Page__c, Size_Description__c, Insertion_Code__c, Alternate_Text__c,File_Access__c,File_Description__c,File_Extension__c,Height__c,Hide_for_Partner_Type__c,
                       Hosting_URL__c,KVH_com__c, Image_URL__c,Language__c,Marketo_URL__c,Partner_Portal__c,Press_Room__c,Product_Pages__c,Revision__c,Site_Core_URL__c,
                       Sub_Title__c,Support_Section__c,Terms_and_Conditions_1__c,Title_Display_Name__c,Width__c from Prod_Documents__c where ID =: prodDoc.Id];
        }        
    }
    
    public void fetchProdDocumentObject(){
        if(productDocId != null){
            prodDoc = [Select id,Name,Content_Link__c,Sales_Aid__c, Active__c, HTML_Field__c, Display_HTML_Page__c, Display_Terms_and_Conditions_Page__c, Size_Description__c, Insertion_Code__c, Alternate_Text__c,File_Access__c,File_Description__c,File_Extension__c,Height__c,Hide_for_Partner_Type__c,
                       Hosting_URL__c,KVH_com__c, Image_URL__c,Language__c,Marketo_URL__c,Partner_Portal__c,Press_Room__c,Product_Pages__c,Revision__c,Site_Core_URL__c,
                       Sub_Title__c,Support_Section__c,Terms_and_Conditions_1__c,Title_Display_Name__c,Width__c from Prod_Documents__c where ID =: productDocId];
            productDocId = null;
        }           
    }
    
    @remoteaction
    public static Security__c fetchCredentials(){  
        Security__c keys = [SELECT Bucket__c, Name, Algorithm__c, Key__c FROM Security__c WHERE Name = 'PublicAWS'];
		return keys;
    }
    
}