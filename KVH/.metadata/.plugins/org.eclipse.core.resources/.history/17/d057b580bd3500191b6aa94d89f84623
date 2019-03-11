@isTest(SeeAllData=true)
private class  create_New_Identifier_AssetTest {
   static testMethod void  Create_New_Identifier_Asset() {
      
      Account newAcc = new Account();
      newAcc.name = 'NewTestCustomer';
      newAcc.KVH_Sales_Office__c ='KE Satcom';
      newAcc.Prospect_Type__c='Customer';
      newAcc.Market__c='Not Applicable';
      newAcc.BillingState = 'Rhode Island';
      newAcc.BillingCountry='United States';
      insert newAcc;
      
      //Creating NewContact
      
      Contact newCon   = new Contact();
      newCon.lastName  = 'NewTestContactName';
      newCon.MailingCountry = 'Italy';
      newCon.AccountID = newAcc.id; 
      insert newCon;
       
       
      
      //Creating NewParentAsset
      
      Asset newParentAsset = new Asset();
      newParentAsset.name = '001122344';
      newParentAsset.AccountID = newAcc.id;
      newParentAsset.ContactID = newCon.id;
      insert newParentAsset;
      
      
      
      //Creating NewAsset
      
      Asset newAsset = new Asset();
      newAsset.name = '001122344';
      newAsset.AccountID = newAcc.id;
      newAsset.ContactID = newCon.id;
      newAsset.Parent_Asset__c = newParentAsset.id;
      insert newAsset;
        
      Case aCase = new Case(Origin='Phone',Action_Plan__c='Follow-up',Status='New',AssetID=newAsset.id,Modem_IP_2__c=newAsset.id); insert aCase;
        
        Test.setCurrentPageReference(new PageReference('Page.create_New_Identifier_Asset')); 
        System.currentPageReference().getParameters().put('id', aCase.id);
        
        
        ApexPages.StandardController sc = new ApexPages.standardController(aCase);
        Create_New_Identifier_Asset cnia = new Create_New_Identifier_Asset(sc);
   }
   static testMethod void  Create_New_Identifier_Asset_True() {
        
        //Creating New Account
      Account newAcc = new Account();
      newAcc.name = 'NewTestCustomer';
      newAcc.KVH_Sales_Office__c ='KE Satcom';
      newAcc.Prospect_Type__c='Customer';
      newAcc.Market__c='Not Applicable';
      newAcc.BillingState = 'Rhode Island';
      newAcc.BillingCountry='United States';
      insert newAcc;
      
      //Creating NewContact
      
      Contact newCon   = new Contact();
      newCon.lastName  = 'NewTestContactName';
      newCon.MailingCountry = 'Italy';
      newCon.AccountID = newAcc.id; 
      insert newCon;
     
       //Creating NewParentAsset
      
      Asset newParentAsset = new Asset();
      newParentAsset.name = '001122344';
      newParentAsset.AccountID = newAcc.id;
      newParentAsset.ContactID = newCon.id;
      insert newParentAsset;
      
      
      //Creating NewAsset
      
      Asset newAsset = new Asset();
      newAsset.name = '001122344';
      newAsset.AccountID = newAcc.id;
      newAsset.ContactID = newCon.id;
      newAsset.Parent_Asset__c = newParentAsset.id;
      insert newAsset;
        
      Case aCase = new Case(Origin='Phone',Action_Plan__c='Follow-up',Status='New',AssetID=newAsset.id,Modem_IP_2__c=newAsset.id); insert aCase;
        
      Test.setCurrentPageReference(new PageReference('Page.create_New_Identifier_Asset')); 
      System.currentPageReference().getParameters().put('id', aCase.id);
        
        
      ApexPages.StandardController sc = new ApexPages.standardController(aCase);
      Create_New_Identifier_Asset cnia = new Create_New_Identifier_Asset(sc);
   }
}