/***********************************************************************************************************************
 Name: FindandAddAccounttoAssetTest 
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "FindandAddAccounttoAsset" class 
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      25/04/2014       Initial Development                                   
***********************************************************************************************************************/
@isTest
private class FindandAddAccounttoAssetTest {

    static testMethod void FindandAddAccounttoAssetxml() {
      
      //Start Test
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
      
      //Creating NewCase
      Case newCase = new Case();
      insert newCase;
      
      //Creating NewAsset
      
      Asset newAsset = new Asset();
      newAsset.name = '0011223344';
      newAsset.AccountID = newAcc.id;
      newAsset.ContactID = newCon.id;
      insert newAsset;
      
      //Passing Current pageParameters from currentPageReference
      Test.setCurrentPageReference(new PageReference('Page.FindandAddAccounttoAsset')); 
      System.currentPageReference().getParameters().put('caseid', newCase.id);
      System.currentPageReference().getParameters().put('id', newAsset.id);
      System.currentPageReference().getParameters().put('firstParam', newAsset.id);
        
      //Asserting Values to Check SelectedAssetid and Current pageAssetID
      system.assertEquals(newAsset.id,System.currentPageReference().getParameters().put('id', newAsset.id));
      
      //Calling Controller Class for Testing 
      FindandAddAccounttoAsset findAssetClass = new FindandAddAccounttoAsset();
      
      //if Selected ID NotEquals then Covering elseCondition on mainClass 
      findAssetClass.SerialNumber = '0011223345';
      findAssetClass.searchAsset();
      
      
      //If Selected ID contains in Asset List
      
      findAssetClass.SerialNumber = '0011223344';
      findAssetClass.searchAsset();
      
      system.assertEquals(findAssetClass.searchAssets[0].name,findAssetClass.SerialNumber);
      
      
      //Selected Asset on TreeView
      findAssetClass.selectAsset();
      
      // After selecting any Asset on Treeview
      findAssetClass.saveAsset();
      
      //Cancel button with redirect page to caseID Page
      findAssetClass.Cancel();
      
      //Stopping TestClass     
      test.StopTest();
      }
}