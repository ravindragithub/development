public class NewonthePortalController {  
    
    @AuraEnabled
    public static List<Prod_Documents__c> Documentlistget(string selectedView){
        Date create = system.today() - 60;
        List <Prod_Doc_Library__c> doclist = [SELECT Filename__r.Id FROM Prod_Doc_Library__c WHERE Product_Market_Sector__r.Portal_View__c =: selectedView AND Filename__r.Active__c = true AND Filename__r.Partner_Portal__c = true AND (LastModifiedDate >: create OR Filename__r.LastModifiedDate >: create) ORDER BY Filename__r.LastModifiedDate DESC LIMIT 49000];
        Set <Id> ids = new Set<Id>();
        for (Prod_Doc_Library__c doc : docList){
            ids.add(doc.Filename__r.id);
        }
        List<Prod_Documents__c> docListModified = [SELECT Id, Associated_Content_Types__c, Display_HTML_Page__c, Display_Terms_and_Conditions_Page__c, Title_Display_Name__c, Name, Created_Date__c, LastModifiedDate FROM Prod_Documents__c WHERE Active__c = true AND Partner_Portal__c = true AND Id IN: ids ORDER BY LastModifiedDate DESC LIMIT 3];
        return docListModified;
    }
    @AuraEnabled
    public static List<Prod_Documents__c> Documentlistgetall(string selectedView){
        if(String.isBlank(selectedView)){
            User cUser = [Select Portal_View__c from user where ID =: userinfo.getUserId()];
            selectedView = cUser.Portal_View__c;
        }
            
        Date create = system.today() - 60;
        List <Prod_Doc_Library__c> doclist = [SELECT Filename__r.Id FROM Prod_Doc_Library__c WHERE Product_Market_Sector__r.Portal_View__c =: selectedView AND Filename__r.Active__c = true AND Filename__r.Partner_Portal__c = true AND (LastModifiedDate >: create OR Filename__r.LastModifiedDate >: create) ORDER BY Filename__r.LastModifiedDate DESC LIMIT 49000];
        Set <Id> ids = new Set<Id>();
        for (Prod_Doc_Library__c doc : doclist){
            ids.add(doc.Filename__r.id);
        }
        List<Prod_Documents__c> docListModified = [SELECT Id, Associated_Content_Types__c, Display_HTML_Page__c, Display_Terms_and_Conditions_Page__c, Title_Display_Name__c, Name, Created_Date__c, LastModifiedDate FROM Prod_Documents__c WHERE Active__c = true AND Partner_Portal__c = true AND Id IN: ids ORDER BY LastModifiedDate DESC LIMIT 20];
        return docListModified;
    }
    
}