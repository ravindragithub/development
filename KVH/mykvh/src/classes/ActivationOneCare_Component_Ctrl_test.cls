@isTest
Private Class ActivationOneCare_Component_Ctrl_test{
    
    @testSetup static void setupTestData(){
        Activation_Order__c testActOrder = new Activation_Order__c();
        testActOrder.isSelf_Activation__c = true;
        testActOrder.User_Agent_String__c = 'test User-Agent string';
        insert testActOrder;
             
        Account acct = New Account();
        acct.Name = 'TestAccName';
        insert acct;
        
        Product2 SystemRoot = new Product2();
        SystemRoot.Name = 'V11IP';
        insert SystemRoot;
        
        Asset Assetroot = new Asset();
        Assetroot.Name = '123456789';
        Assetroot.Product2Id = SystemRoot.Id;
        Assetroot.AccountId = acct.Id;
        insert Assetroot;
        
        Asset firstLevel = new Asset();
        firstLevel.Name = '123457689';
        firstLevel.Product2Id = SystemRoot.Id;
        firstLevel.AccountId = acct.Id;
        firstLevel.Parent_Asset__c = Assetroot.id;
        insert firstLevel;
        
        Asset secondLevel = new Asset();
        secondLevel.Name = '123456798';
        secondLevel.Product2Id = SystemRoot.Id;
        secondLevel.AccountId = acct.Id;
        secondLevel.Parent_Asset__c = firstLevel.id;
        insert secondLevel;
        
        Asset thridLevel = new Asset();
        thridLevel.Name = '123456978';
        thridLevel.Product2Id = SystemRoot.Id;
        thridLevel.AccountId = acct.Id;
        thridLevel.Parent_Asset__c = secondLevel.id;
        insert thridLevel;
        
        Asset fourthLevel = new Asset();
        fourthLevel.Name = '123459678';
        fourthLevel.Product2Id = SystemRoot.Id;
        fourthLevel.AccountId = acct.Id;
        fourthLevel.Parent_Asset__c = thridLevel.id;
        insert fourthLevel;  
        
        Activation_Hardware__c ActHardware=new Activation_Hardware__c();
        ActHardware.Antenna_Serial_Number__c='123456978';
        ActHardware.Activation_Order__c =testActOrder.id ;
        insert ActHardware;
        
      	Activation_System_Hardware__c objActivationSystemHardware = New Activation_System_Hardware__c();
        objActivationSystemHardware.Name = 'Test Hardware V3111';
        objActivationSystemHardware.Image_Name__c = 'Test Image';
        objActivationSystemHardware.Image_URL__c = '/Image/Path/Test.jpg';
        objActivationSystemHardware.Order__c = 99;
        objActivationSystemHardware.Last_Name__c = 'Hardware V3111';
        objActivationSystemHardware.First_Name__c = 'Test';
        objActivationSystemHardware.Product_Group__c = 'V3111';
        insert objActivationSystemHardware;
        
    }
    static testMethod void ActivationOneCare_Component_Ctrl(){
        test.startTest();
        Activation_Order__c ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Hardware__c ObjActHardware = [SELECT Id, Name FROM Activation_Hardware__c where Activation_Order__c=:ActOrder.id  LIMIT 1];
        PageReference thePage = page.ActivationOneCare;     
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        
        ActivationOneCare_Component_Ctrl asi = New ActivationOneCare_Component_Ctrl();
        asi.currenttab = 'Technical_Assistance_Package';
        asi.getProductTypeList();
        //V11IP
        Product2 P = [SELECT id FROM Product2 limit 1];
        P.Name = 'V11IP';
        update p;
        
        asi.actProd.Antenna_Serial_Number__c = '123459678';
        asi.actProd.Below_Decks_Serial_Number__c = '123459678';
        asi.SearchAsset();
        
        //V3IP
        P.Name = 'V3IP';
        update p;
        
        asi.actProd.Antenna_Serial_Number__c = '123456978';
        asi.SearchAsset();
        
        
        //V7
        P.Name = 'V7';
        update p;
        
        asi.actProd.Antenna_Serial_Number__c = '123456798';
        asi.SearchAsset();
        
        //V7IP
        P.Name = 'V7IP';
        update p;
        
        asi.actProd.Antenna_Serial_Number__c = '123457689';
        asi.SearchAsset();
        asi.actProd.Antenna_Serial_Number__c = '123456789';
        asi.SearchAsset();
        asi.actProd.System_Name__c = 'Test Hardware V3111';
        asi.ProductSave();
        asi.getActivationProductList();
        asi.strActivationProduct = (string)ObjActHardware.id; 
        asi.EditProduct();
        asi.reloadprodtactlist();
        asi.RemoveProduct();
        test.stopTest();
    }
}