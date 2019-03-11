/***********************************************************************************************************************
 Name: Add_New_Global_StaticIPImplentationTest
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "Add_New_Global_StaticIPImplentation" class 
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
Private Class Add_New_Global_StaticIPImplentationTest{
    static testMethod void Add_New_Global_StaticIPImplentation(){
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
          
          
          //Private static IP Creation 
          
          Private_Static_IP__c psip = new Private_Static_IP__c();
          psip.Name = '00112233444';
          psip.Static_IP_Type__c = 'Global Static IP';
          psip.Region__c = 'Americas';
          insert psip;
          
          
          Asset replacementAssetnew = new Asset();
          replacementAssetnew.name = '120938';
          replacementAssetnew.AccountID = newAcc.id;
          replacementAssetnew.ContactID = newCon.id;
          insert replacementAssetnew;
          
          
          Test.setCurrentPageReference(new PageReference('Page.Add_New_Global_StaticIPImplentation')); 
          System.currentPageReference().getParameters().put('caseid', newCase.id);
          System.currentPageReference().getParameters().put('firstParam', replacementAssetnew.id);
        
          Add_New_Global_StaticIPImplentation angs = New Add_New_Global_StaticIPImplentation();
          angs.selectedRegion = 'Americas';
          angs.getFormTag();
          angs.getTextBox();
          angs.NewFunction();
          angs.RemoveFunction();
          angs.searchNextPrivateStaticIP();
          angs.CreateInstallConfigRecord();
          angs.findGlobalIpAddress();
          angs.saveAsset();
          angs.replacementAsset();
          angs.finalReplacementAsset();
          System.currentPageReference().getParameters().put('Assetremove', replacementAssetnew.id);
          angs.removeAsset();
          
       
          
        
        test.stopTest();
    }
}