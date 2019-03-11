/***********************************************************************************************************************
 Name: Add_New_Global_StaticIPTest
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "Add_New_Global_StaticIP" class 
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      07/02/2014       Initial Development                                   
***********************************************************************************************************************/
@isTest
Private Class Add_New_Global_StaticIPTest{
     static testMethod void Add_New_Global_StaticIP(){
        test.startTest();
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
          
          Test.setCurrentPageReference(new PageReference('Page.Add_New_Global_StaticIP')); 
          System.currentPageReference().getParameters().put('id', newCase.id);
          
          ApexPages.StandardController CSC = New ApexPages.StandardController(newCase);
          
          
          Add_New_Global_StaticIP gsp = New Add_New_Global_StaticIP(CSC);
          
        test.stopTest();
     }
}