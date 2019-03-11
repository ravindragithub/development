@istest
public class NewonthePortalController_test {
    @testsetup
    static void testSetupData(){
        Product2 prod = new Product2(Name = 'TracPhone V7-IP Bundle', Catalog_Display_Name__c = 'TracPhone V7-IP Bundle', IsActive = true, Display_Product__c = 'Yes');
        insert prod;
        Product_Market_Sector__c pms = new Product_Market_Sector__c(Product__c = prod.Id, Portal_View__c = 'Commercial & OEM Maritime Systems');
        insert pms;
        Prod_Documents__c prodDoc = new Prod_Documents__c(Hosting_URL__c = 'https://www.kvh.com', Active__c = true, Partner_Portal__c = true);
        insert prodDoc;
		Content_Type__c docType = new Content_Type__c(Content_Main_Type__c = 'Advertising', Product_Document__c = prodDoc.Id);
        insert docType;
		Prod_Doc_Library__c pdl = new Prod_Doc_Library__c(Filename__c = prodDoc.Id, Product_Market_Sector__c = pms.Id);
        insert pdl;
        }
    static testMethod void testprodlist(){
        List <Prod_Documents__c> prodDocs = NewonthePortalController.Documentlistget('Commercial & OEM Maritime Systems');
        system.assertEquals(1, prodDocs.size());
    }
    static testMethod void testprodlistCommMarine(){
        User u = [SELECT Portal_View__c FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
        u.Portal_View__c = 'Commercial & OEM Maritime Systems';
        update u;
        List <Prod_Documents__c> prodDocs = new List <Prod_Documents__c> ();
        system.runAs(u){
        prodDocs = NewonthePortalController.Documentlistgetall(u.Portal_View__c);
        }
        system.assertEquals(1, prodDocs.size());
        prodDocs.clear();
        u.Portal_View__c = 'Commercial & OEM Gyroscopes';
        update u;
        system.runAs(u){
        prodDocs = NewonthePortalController.Documentlistgetall(u.Portal_View__c);
        }
        system.assertEquals(0, prodDocs.size());
    }
}