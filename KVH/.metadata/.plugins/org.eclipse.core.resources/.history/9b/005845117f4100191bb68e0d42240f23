/***********************************************************************************************************************
 Name: ReplacementAssetTest 
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "ReplacementAsset" class 
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      18/09/2014       Initial Development                                   
***********************************************************************************************************************/
@isTest

private class ReplacementAssetTest {
   static testMethod void ReplacementAsset() {
          test.StartTest();
          
           //Creating New Account
          Account newAcc = new Account();
          newAcc.name = 'NewTestCustomer';
          insert newAcc;
          
          //Creating NewContact
          
          Contact newCon   = new Contact();
          newCon.lastName  = 'NewTestContactName';
          newCon.AccountID = newAcc.id; 
          insert newCon;
          
          
          
          //Creating NewParentAsset
          
          Asset newParentAsset = new Asset();
          newParentAsset.name = '00112233444';
          newParentAsset.AccountID = newAcc.id;
          newParentAsset.ContactID = newCon.id;
          insert newParentAsset;
          
          
          
          
          
          //Creating NewAsset
          
          Asset newChildAsset = new Asset();
          newChildAsset.name = '00112233445';
          newChildAsset.AccountID = newAcc.id;
          newChildAsset.ContactID = newCon.id;
          newChildAsset.Parent_Asset__c = newParentAsset.id;
          insert newChildAsset;
          
          
          //Creating NewCase
          Case newCase = new Case();
          newCase.Modem_IP_2__c = newChildAsset.id;
          insert newCase;
          
          //Passing Current pageParameters from currentPageReference
          Test.setCurrentPageReference(new PageReference('Page.ReplacementAsset')); 
          System.currentPageReference().getParameters().put('CID', newCase.id);
          System.currentPageReference().getParameters().put('assetId', newChildAsset.id);
          System.currentPageReference().getParameters().put('CN', newCase.CaseNumber);
          
          
          Asset newReplacementAsset = new Asset();
          newReplacementAsset.name = '00112233424';
          newReplacementAsset.AccountID = newAcc.id;
          newReplacementAsset.ContactID = newCon.id;
          insert newReplacementAsset;
          
          
          ReplacementAsset replacementAsset = new ReplacementAsset();
          replacementAsset.assetID = newReplacementAsset.Id;
          replacementAsset.oldAssetIDFromVF = newChildAsset.id;
          
          replacementAsset.passSelectedID();
          replacementAsset.revertAsset = newChildAsset.id;
          replacementAsset.replacingAsset();
          replacementAsset.removeAsset();
          System.currentPageReference().getParameters().put('firstParam', newChildAsset.id);
          replacementAsset.removeAsset();
          
          test.StopTest();
      }
      static testMethod void FinalReplacementAsset() {
          test.StartTest();
          
           //Creating New Account
          Account newAcc = new Account();
          newAcc.name = 'NewTestCustomer';
          insert newAcc;
          
          //Creating NewContact
          
          Contact newCon   = new Contact();
          newCon.lastName  = 'NewTestContactName';
          newCon.AccountID = newAcc.id; 
          insert newCon;
          
          
          
          //Creating NewParentAsset
          
          Asset newParentAsset = new Asset();
          newParentAsset.name = '00112233444';
          newParentAsset.AccountID = newAcc.id;
          newParentAsset.ContactID = newCon.id;
          insert newParentAsset;
          
          
          
          
          
          //Creating NewAsset
          
          Asset newChildAsset = new Asset();
          newChildAsset.name = '00112233445';
          newChildAsset.AccountID = newAcc.id;
          newChildAsset.ContactID = newCon.id;
          newChildAsset.Parent_Asset__c = newParentAsset.id;
          insert newChildAsset;
          
          SBQQ__Subscription__c objSubscription = New SBQQ__Subscription__c();
          objSubscription.Asset__c = newChildAsset.Id;
          objSubscription.SBQQ__Quantity__c = 1;
          insert objSubscription;
          
          //Creating NewCase
          Case newCase = new Case();
          newCase.Modem_IP_2__c = newChildAsset.id;
          insert newCase;
          
          //Passing Current pageParameters from currentPageReference
          Test.setCurrentPageReference(new PageReference('Page.ReplacementAsset')); 
          System.currentPageReference().getParameters().put('CID', newCase.id);
          System.currentPageReference().getParameters().put('assetId', newChildAsset.id);
          System.currentPageReference().getParameters().put('CN', newCase.CaseNumber);
          
          
          Asset newReplacementAsset = new Asset();
          newReplacementAsset.name = '00112233424';
          newReplacementAsset.AccountID = newAcc.id;
          newReplacementAsset.ContactID = newCon.id;
          insert newReplacementAsset;
          
          
          ReplacementAsset replacementAsset = new ReplacementAsset();
          replacementAsset.searchAssetName = '00112233424';
          replacementAsset.assetID = newReplacementAsset.Id;
          replacementAsset.oldAssetNameFromVF = newChildAsset.id;
          replacementAsset.SearchAsset();
          
          system.assert(replacementAsset.SearchAssets.size()==1);
          
          
          replacementAsset.ClearAsset();
          
          system.assertNotEquals(replacementAsset.SearchAssets.size(),1);
          
          replacementAsset.passSelectedID();
          replacementAsset.FinalReplacement();
          replacementAsset.getFormTag();
          replacementAsset.getTextBox();
          replacementAsset.SubscriptionUpdateBySelection();
          replacementAsset.ReverseSubscriptionMove();
          //replacementAsset.SubscriptionMove();
          test.StopTest();
      }
}