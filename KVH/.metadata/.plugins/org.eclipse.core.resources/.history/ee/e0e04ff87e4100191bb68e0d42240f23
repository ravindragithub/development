/**********************************************
    Name    :    DownloadDocumentCtrl
    Description : This controller user to download the files from AWS and Salesforce
***********************************************/
public class DownloadDocumentCtrl{
    public boolean TC {get;set;}
    public boolean html {get;set;}
    public boolean down {get;set;}
    public boolean embed {get;set;}
    public Prod_Documents__c pd {get;set;}
    
    public DownloadDocumentCtrl(Apexpages.Standardcontroller ctrl){
        string pdid = ctrl.getId();
        pd = [SELECT Sub_Title__c, Insertion_Code__c, Revision__c, Title_Display_Name__c, File_Description__c, Terms_and_Conditions_1__r.Body__c, Created_Date__c, Terms_and_Conditions_1__r.Name__c, Display_Terms_and_Conditions_Page__c, Display_HTML_Page__c, Html_Field__c FROM Prod_Documents__c WHERE ID =: pdid ];
        if(pd.Display_HTML_Page__c && pd.Insertion_Code__c != null){
            html = true;
            embed = true;
            TC = false;
        } else if(pd.Display_HTML_Page__c){
            html = true;
            embed = false;
            TC = false;
        } else if(pd.Insertion_Code__c != null){
            embed = true;
            html = false;
            TC = false;
        } else if(pd.Display_Terms_and_Conditions_Page__c){
            TC = true;
            html = false;
            embed = false;
        } else if (!pd.Display_Terms_and_Conditions_Page__c && !pd.Display_HTML_Page__c && pd.Insertion_Code__c == null){
            download();
        }
    }
    public PageReference download() {
        PageReference pageref = new PageReference(Label.Community_URL + '/' + Label.Community_Prefix + '/downloaddocument?id=' + pd.Id);
        return pageref;
    }
    public PageReference cont(){
        if(pd.Display_Terms_and_Conditions_Page__c){
            TC = true;
            html = false;
            embed = false;
            return null;
        } else {
            PageReference pageref = download();
            return pageRef;
        }
    }
    public PageReference accept(){
            PageReference pageref = download();
            return pageRef;
    }
}