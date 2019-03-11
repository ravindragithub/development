@isTest
private class SubscriptionAssgnLightningCont_Test{
    
    public static List<Asset> lstAsset;
    public static List<SBQQ__Subscription__c> lstSub;
    public static Product2 prod;
    public static SBQQ__Subscription__c subNew;
    public static Case newCase; 
    public static Asset asstAnt;
    static void setupdata()
    {       
        //Product Creation
        final Id Service_RECORD_TYPE_ID = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        
        prod = new Product2();
        prod.Name = '02-2103';
        prod.ProductCode = '02-2103';
        prod.RecordTypeId = Service_RECORD_TYPE_ID ;
        insert prod; 
                
        //Parent Asset Creation
        lstAsset = new List<Asset>();
        Asset asstParent= new Asset();
        asstParent.Name ='Parent Asset';
        asstParent.Date_Shipped__c = system.today();
        insert asstParent;
        
        //Child Asset Creation
        for(Integer i=0 ;i <10;i++)
        {
            Asset asst= new Asset();
            asst.Name ='Asset '+i;
            asst.Date_Shipped__c = system.today();
            asst.Parent_Asset__c = asstParent.id;
            lstAsset.add(asst);
        }
        insert lstAsset;
        //Insert Antenna Asset
        Product2 prodI2CM = new Product2();
        prodI2CM.Name = '02-1925';
        prodI2CM.ProductCode = '02-1925';
        prodI2CM.RecordTypeId = Service_RECORD_TYPE_ID ;
        insert prodI2CM; 
        
        asstAnt = new Asset();
        asstAnt.Name ='Asset';
        asstAnt.HTS_REady__c = true;
        asstAnt.Parent_Asset__c = lstAsset[0].id;
        asstAnt.Root_Asset__c = lstAsset[1].id;
        asstAnt.Product2Id = prodI2CM.id;
        insert asstAnt;
        
        //Subscription Creaion
        lstSub = new List<SBQQ__Subscription__c>();
        for(Integer i=0 ;i <10;i++){
            SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
            sub.Asset__c = lstAsset[i].Id;
            sub.SBQQ__Product__c = prod.id;
            sub.SBQQ__SubscriptionStartDate__c = system.today();
            sub.SBQQ__SubscriptionEndDate__c = system.today(); 
            sub.SBQQ__Quantity__c = 1;
            lstSub.add(sub);
        }
        insert lstSub ;
        
        subNew = new SBQQ__Subscription__c();
        subNew.Asset__c = lstAsset[0].Id;
        subNew.SBQQ__Product__c = prod.id;
        subNew.SBQQ__SubscriptionStartDate__c = system.today();
        subNew.SBQQ__SubscriptionEndDate__c = system.today(); 
        subNew.SBQQ__Quantity__c = 1;
        
        //Creating NewCase
        final Id AirtimeServiceCase_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airtime Service').getRecordTypeId();
        newCase = new Case();
        newCase.Modem_IP_2__c = lstAsset[0].Id;
        newCase.RecordTypeId = AirtimeServiceCase_RECORD_TYPE_ID;
        newCase.Subject = 'Update Subscriptions for Replacement Assets';
        newCase.AssetId = asstParent.Id;
        newCase.Origin = 'Web';
        newCase.Status = 'New';
        newCase.Description = 'Review the Subscriptions that are Replacement Assets for the Parent Case. They will need to be updated as the asset was moved to other subscriptions.';
                
        insert newCase;
    }
    
    static testmethod void SubscriptionAssgLightningContMethod()
    {    
        Test.startTest();
        //Call the test data creation method
        setupdata();
        SubscriptionAssigmentLightningController.getSubscription(lstAsset[0].Id);
        SubscriptionAssigmentLightningController.createNewSubscription(subNew,lstSub[0]);
        SubscriptionAssigmentLightningController.fetchProduct('02-2103','Asset Replacement');
        SubscriptionAssigmentLightningController.fetchProduct('02-2103','Update_Subscription');
        Test.stopTest();
    }
    static testmethod void Update_AssetSubscriptionControllerMethod()
    {    
        Test.startTest();
        //Call the test data creation method
        setupdata();
        Update_AssetSubscriptionController.getAllSubscription(lstAsset[0].Id);
        Update_AssetSubscriptionController.getAssetHierarchy(lstAsset[0].Id);
        Update_AssetSubscriptionController.fetchAsset('Asset 1');
        Update_AssetSubscriptionController.getCaseAssetMove(lstAsset[0].Id,newCase.Id);
        Test.stopTest();
    }
    static testmethod void Update_AssetSubscriptionControllerMethod2()
    {    
        Test.startTest();
        //Call the test data creation method
        setupdata();
        Update_AssetSubscriptionController.updateAssetReplacement(newCase.Id,lstAsset[0],lstAsset[1],'Add',null,'Customer','ready',asstAnt);
        Test.stopTest();
    }
    static testmethod void Update_AssetSubscriptionControllerMethod3()
    {    
        Test.startTest();
        //Call the test data creation method
        setupdata();
        Update_AssetSubscriptionController.updateAssetReplacement(newCase.Id,lstAsset[2],lstAsset[3],'Replace',null,'Customer','not ready',asstAnt);
        Test.stopTest();
    }
    static testmethod void Update_AssetSubscriptionControllerMethod4()
    {    
        Test.startTest();
        //Call the test data creation method
        setupdata();
        Update_AssetSubscriptionController.updateSubscriptionList(lstSub);
        Update_AssetSubscriptionController.getObjectAccessMethod();
        Update_AssetSubscriptionController.deleteAssetReplacement(lstAsset[0],newCase.Id);
        Test.stopTest();
    }
}