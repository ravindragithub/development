@IsTest
public class PartnerCommunityTestData {

    public static User createPartnerUser(String profileName, String email){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: profileName].Id;

        User user = new User(
                alias = 'robStark',
                Email= email,
                emailencodingkey ='UTF-8',
                LastName = 'Testing',
                languagelocalekey='en_US',
                localesidkey='en_US',
                ProfileId = profileId,
                Country='United States',
                IsActive =true,
                timezonesidkey='America/Los_Angeles',
                UserName='tester@noemail.com'
        );
        return user;
    }

    public static Account createAccount(String accName){
        RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Direct Partner'];
        Account accRec = new Account();
        accRec.Name = accName;
        accRec.Portal_View_s__c = 'Leisure Marine Systems; Commercial & OEM Maritime Systems; Commercial & OEM Land Systems; Leisure Auto & RV Systems';
        accRec.RecordTypeId = rt.Id;
        return accRec;
    }
    public static Content_Type__c createContentType(string doctype, string docId){
        Content_Type__c ct = new Content_Type__c (Content_Main_Type__c = doctype, Product_Document__c = docId);
 		return ct;       
    }

    public static Contact createContact(Id accountId){
        Contact conRec = new Contact();
        conRec.FirstName = 'Rob';
        conRec.LastName = 'Stark';
        conRec.AccountId = accountId;
        return conRec;
    }

    public static Product2 ceateProduct(String prodName){
        Product2 prod = new Product2(Name = prodName);
        prod.IsActive = true;
        prod.Catalog_Display_Name__c = 'TracPhone V7-IP';
        prod.ProductCode = '01-0283-15';
        prod.Display_Product__c = 'Yes';
        return prod;
    }

    public static Product_Market_Sector__c createProductMarketSector(String prodId){
        Product_Market_Sector__c pms = new Product_Market_Sector__c();
        pms.Product__c = prodId;
        pms.Market__c = 'Commercial & OEM';
        pms.Sector__c = 'Maritime Systems';
        pms.Portal_View__c = 'Commercial & OEM Maritime Systems';
        pms.Product_Line__c = 'Satellite Communications';
        pms.Product_Series__c = 'mini-VSAT Broadband';
        return pms;
    }

    public static Product_Catalogue__c createProductCatalogue(String accId, String pmsId){
        Product_Catalogue__c pc = new Product_Catalogue__c();
        pc.Partner_Account__c = accId;
        if(String.isNotBlank(pmsId)){
            pc.Product_Market_Sector__c = pmsId;
        }
        return pc;
    }

    public static Prod_Documents__c createProdDocuments(String fileExtension){
        Prod_Documents__c pd = new Prod_Documents__c();
        pd.Name = 'prod_v7IP';
        pd.File_Extension__c = fileExtension;
        pd.Hosting_URL__c='http://www.kvh.com/~/media/Images/KVH/Product/TracPhone/TracPhone%20V7IP%20ICM/prod_v7IP.jpg?bc=white';
        return pd;
    }

    public static Prod_Doc_Library__c createProdDocLibrary(String prodId, String prodDocId){
        Prod_Doc_Library__c pdl = new Prod_Doc_Library__c(Filename__c = prodDocId, Product_Market_Sector__c = prodId);
        return pdl;
    }
}