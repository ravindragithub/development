/***********************************************************************************************************************
 Name: add_Identifier_ProductTest
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "add_Identifier_Product" class 
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      17/06/2014       Initial Development                                   
***********************************************************************************************************************/
@isTest
private class  add_Identifier_ProductTest {
   static testMethod void Add_Identifier_Product() {
      
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
      System.currentPageReference().getParameters().put('caseid', aCase.id);                
      add_Identifier_Product aip= new add_Identifier_Product();
      aip.newAsset.Name = 'TestNewAsset';
      aip.assetSave();
   }
}