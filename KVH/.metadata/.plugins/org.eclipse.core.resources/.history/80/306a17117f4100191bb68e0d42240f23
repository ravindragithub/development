/*******************************************************
    Name        :    RemoveDocumentController
    Description :    Controller for remove document
*********************************************************/
public class RemoveDocumentController{
    public String productDocId{get;set;}
    public Prod_Documents__c prodDoc{get;set;}
    public boolean isError{get;set;}
    
    public RemoveDocumentController(){
        init();
    }
    
    public void init(){        
        prodDoc = new Prod_Documents__c();
    } 
    
    public void fetchProdDocumentObject(){
        if(productDocId != null){
            prodDoc = [Select id,Name,Gated_Document__c,KVH_com__c, Production_URL__c,Internal_Document_Record__c, Content_Link__c,Sales_Aid__c, Active__c, HTML_Field__c, Display_HTML_Page__c, Display_Terms_and_Conditions_Page__c, Size_Description__c, Insertion_Code__c, Alternate_Text__c,File_Access__c,File_Description__c,File_Extension__c,Height__c,Hide_for_Partner_Type__c,
                       Hosting_URL__c,Filename_in_AWS__c,Image_URL__c,Language__c,Marketo_URL__c,Partner_Portal__c,Press_Room__c,Product_Pages__c,Revision__c,Site_Core_URL__c,
                       Sub_Title__c,Support_Section__c,Terms_and_Conditions_1__c,Title_Display_Name__c,Width__c from Prod_Documents__c where ID =: productDocId];
            
            productDocId = null;
        }           
    }
    
    public PageReference saveRecords(){  
        isError = false;  
        try{
            if(prodDoc != null && prodDoc.Id != null){
                delete prodDoc;
                PageReference pageRef = new PageReference('/apex/adminLandingPage');
                return null;
            }else{               
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Product Document'));
            	return null;
            }
        }catch(Exception ex){          
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getmessage()));
            isError = true;
            return null;
        }
    }
    
    @remoteaction
    public static void deleteContent(string cvid){
        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cvid];
        ContentDocument cd = [SELECT Id FROM ContentDocument WHERE Id =: cv.ContentDocumentId];
        delete cd;
    }
    
    @remoteaction
    public static Security__c fetchCredentials(){  
        Security__c keys = [SELECT Bucket__c, Name, Algorithm__c, Key__c FROM Security__c WHERE Name = 'PublicAWS'];
		return keys;
    }
}