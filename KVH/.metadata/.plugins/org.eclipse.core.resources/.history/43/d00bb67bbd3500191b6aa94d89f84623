@isTest
public class ToolKitsClass_test {
	@testSetup static void setupData() {
        
        Account acc = PartnerCommunityTestData.createAccount('PartnerCommS1E2');
        insert acc;
        Contact con = PartnerCommunityTestData.createContact(acc.Id);
        insert con;
        
        User admin = [SELECT Id FROM User WHERE isActive = true AND Profile.Name = 'System Administrator' LIMIT 1];
        
        system.runAs(admin){
            User u = PartnerCommunityTestData.createPartnerUser('Partner-Dealer', '123@123ANDtest.com');
            u.ContactId = con.Id;
            u.Portal_View__c = 'Leisure Marine Systems';
            insert u;
        }
        
        Product2 product = PartnerCommunityTestData.ceateProduct('V7IP W/ICM ANTENNA W/LABELS');
        insert product;

        Product_Market_Sector__c pms = new Product_Market_Sector__c();
        pms.Product__c = product.Id;
        pms.Market__c = 'Leisure';
        pms.Sector__c = 'Marine Systems';
        pms.Sales_Tool_Kit_s__c = 'OneCare Sales Toolkit';
        pms.Portal_View__c = 'Leisure Marine Systems';
        insert pms;
        
        Product_Catalogue__c pc = PartnerCommunityTestData.createProductCatalogue(acc.Id, pms.Id);
        insert pc;
        
        DocumentIconMapping__mdt dim = [SELECT MasterLabel, Lightning_Icon_Name__c
                                        FROM DocumentIconMapping__mdt LIMIT 1];
        
        Prod_Documents__c pd = PartnerCommunityTestData.createProdDocuments(dim.MasterLabel);
        pd.Partner_Portal__c = true;
        pd.Active__c = true;
        pd.File_Access__c = 'Public';
        insert pd;
        
        Content_Type__c docType = new Content_Type__c (Product_Document__c = pd.Id, Content_Main_Type__c = 'Forms', Sales_Tool_Kit_s__c = 'OneCare Sales Toolkit');
        insert docType ;
        
        Prod_Doc_Library__c pdl = PartnerCommunityTestData.createProdDocLibrary(pms.Id,pd.Id);
        insert pdl;
        
        Quick_Link__c ql1 = new Quick_Link__c(Sales_Kit__c = true, Sales_Tool_Kit_Label__c = 'OneCare Sales Toolkit');
        insert ql1;
        
        Quick_Link__c ql2 = new Quick_Link__c(Sales_Kit__c = true, Sales_Tool_Kit_Label__c = 'OneCare Sales Toolkit');
        insert ql2;
        
        Quick_Link__c ql3 = new Quick_Link__c(Sales_Kit__c = true, Sales_Tool_Kit_Label__c = 'OneCare Sales Toolkit');
        insert ql3;
        
        Quick_Link__c ql4 = new Quick_Link__c(Sales_Kit__c = true, Sales_Tool_Kit_Label__c = 'OneCare Sales Toolkit');
        insert ql4;
        
        Quick_Link__c ql5 = new Quick_Link__c(Sales_Kit__c = true, Sales_Tool_Kit_Label__c = 'OneCare Sales Toolkit');
        insert ql5;
        
        Quick_Link__c ql6 = new Quick_Link__c(Sales_Kit__c = true, Toolkit_Content_Type__c = 'Forms');
        insert ql6;
        
    }
    @isTest static void TKlandingTest(){
        User u = [ SELECT Id, Portal_View__c FROM User WHERE Email = '123@123ANDtest.com'];
        u.Portal_View__c = '';
        update u;
        system.runAs(u){
            ToolKitsClass.portalChange('Leisure Marine Systems');
            u = [ SELECT Id, Portal_View__c FROM User WHERE Email = '123@123ANDtest.com'];
            system.assertEquals('Leisure Marine Systems', u.Portal_View__c);
            List<Content_Type__c> cts = ToolKitsClass.CTypes();
            system.assertEquals(cts.size(), 1);
            List<Quick_Link__c> tks = ToolKitsClass.ToolKitLanding();
            system.assertEquals(tks.size(), 6);
            Map<string, object> objectMap = ToolKitsClass.buildToolKit('OneCare Sales Toolkit');
            system.assertEquals(objectMap.size(), 2);
        }
        
    }
}