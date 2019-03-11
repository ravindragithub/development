@isTest
public class CreateAssetTest {
    static testMethod void createTestMethod(){
        
        
        RecordType recid1= [SELECT id, Name FROM RecordType WHERE  Name = 'Prospect' LIMIT 1];
        
        Account acc = new Account();
        acc.RecordTypeId = recid1.id ;
        acc.Name = 'test account';
        acc.Account_Type__c = 'Partner';
        acc.KVH_Sales_Office__c = 'KB Satcom' ;
        insert acc;
        
         DefaultAccounts__c accname = new DefaultAccounts__c();
        accname.Name = 'DefaultAssets';
        accname.Description__c = 'DefaultAssets';
        accname.Account_ID__c = acc.id ;
        insert accname;
        
        RecordType recid = [SELECT id, Name FROM RecordType WHERE  Name = 'Hardware' LIMIT 1];
        
        Product2 prd = new Product2();
        prd.Name = 'Test Product';
        prd.IsActive = True;
        prd.CurrencyIsoCode = 'USD';
        prd.RecordTypeId = recid.id ;
        prd.ProductCode = '1234';
        insert prd ;
        
        Asset ast = new  Asset();
        ast.Product2Id = prd.id ;
        ast.AccountId = acc.id ;
        ast.Name = 'test asset' ;
        ast.Sequence_No__c = 'test seq';
        ast.SerialNumber = '1234';
        insert ast ;
        
        
        Test.setCurrentPageReference(new PageReference('Page.CreateAsset_VF')); 
        System.currentPageReference().getParameters().put('ProductId', prd.id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(prd);
        CreateAsset_Class createAsst = new CreateAsset_Class();
        createAsst.itemNumber = prd.ProductCode;
        createAsst.sequenceName = ast.SerialNumber;
        createAsst.createAsset();
        
        Test.setCurrentPageReference(new PageReference('Page.CreateAsset_VF')); 
        System.currentPageReference().getParameters().put('assetID', ast.id);
        
        ApexPages.StandardController controller1 = new ApexPages.StandardController(prd);
        CreateAsset_Class createChildAsst = new CreateAsset_Class();
        createAsst.itemNumber = prd.ProductCode;
        createChildAsst.sequenceName = ast.SerialNumber;
        createChildAsst.createAsset();
        
        
        
    }
}