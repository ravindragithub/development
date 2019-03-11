/***********************************************************************************************************************
 Name: CreatingNewAssetTest Trigger test
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "CreatingNewAsset" Trigger 
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      18/08/2014       Initial Development                                   
   2.0     John Thompson        05/02/2015       Refactor to use less SOQL, encapsulate test data
***********************************************************************************************************************/
@isTest

private class CreatingNewAssetTest {
   static testMethod void CreatingNewAsset() {
      //ARRANGE
      //Account Object Creation, All Assets need an Account!
          Account newAcc = new Account();
          newAcc.name = 'Cordland Marine AB Corp';
          newAcc.KVH_Sales_Office__c ='KE Satcom';
          newAcc.OwnerID = Userinfo.getUserId();
          newAcc.Account_Status__c ='Active';
          newAcc.BillingStreet ='abc';
          newAcc.BillingCountry= 'United States';
          newAcc.BillingCity= 'middletown-11';
          newAcc.Billingstate = 'Rhode Island';
          newAcc.BillingPostalCode ='02842';
          insert newAcc;
          //assert equals testing
          /* Not required....
          Account account =[SELECT id FROM Account
            WHERE CreatedDate = TODAY
            AND Id =: newAcc.id];
          System.assertEquals(newAcc.id, account.id);
         */
         //Contact Object Creation
         /* Don't need a Contact....
          Contact newCon   = new Contact();
          newCon.lastName  = 'NewTestContactName';
          newCon.AccountID = newAcc.id; 
          insert newCon;  
          
          //assert equals testing
          Contact contact =[SELECT id FROM Contact 
            WHERE CreatedDate = TODAY
            AND Id =: newCon.id];
          System.assertEquals(newCon.id, contact.id);
          */
          
          system.debug('SOQL used for Account Creation : ' + Limits.getQueries());	//Insert Account consumes 10 SOQL!
          
          //Asset,install and config,private Static ip Object Creation .
          //Create a three level Asset Hierarchy....
          Asset assetTOP = new Asset();
          assetTOP.name = 'TOP Asset';
          assetTOP.AccountID = newAcc.id;
          //assetTOP.ContactID = newCon.id;          
          insert assetTOP ;         
          system.debug('SOQL used for TOP Asset: ' + Limits.getQueries());
          
          Asset assetMIDDLE= new Asset();
          assetMIDDLE.name = 'MIDDLE Asset';
          assetMIDDLE.AccountID = newAcc.id;
          //assetMIDDLE.ContactID = newCon.id;
          assetMIDDLE.Parent_Asset__c = assetTOP.id;
          insert assetMIDDLE;
          system.debug('SOQL used for MIDDLE Asset (child) : ' + Limits.getQueries());
          
          Asset assetBOTTOM = new Asset();
          assetBOTTOM.name = 'BOTTOM Asset';
          assetBOTTOM.AccountID = newAcc.id;
          //assetBOTTOM.ContactID = newCon.id;
          assetBOTTOM.Parent_Asset__c = assetMIDDLE.id;
          insert assetBOTTOM;
          system.debug('SOQL used for BOTTOM Asset (grandchild): ' + Limits.getQueries());
          
          //Create Install and Config records for Child and Grandchild Asset records and insert them as a list
          List<Install_Config__c> listInstallConfig = New  List<Install_Config__c>(); 
          
          Install_Config__c icFirst = new Install_Config__c(); 
          icFirst.Account_Name__c=newAcc.id;
          icFirst.Asset__c=assetMIDDLE.id;
          listInstallConfig.add(icFirst);
          system.debug('SOQL used for first IC : ' + Limits.getQueries());
          
          Install_Config__c icSec = new Install_Config__c(); 
          icSec.Account_Name__c=newAcc.id;
          icSec.Asset__c=assetBOTTOM.id;
          listInstallConfig.add(icSec);
          system.debug('SOQL used for Second IC : ' + Limits.getQueries());
          
          insert listInstallConfig;
          system.debug('SOQL used for IC List insert : ' + Limits.getQueries());
                   
          //ACT
          test.startTest();				//This resets the governor limits !
          system.debug('SOQL used after startTest() method call : ' + Limits.getQueries());
          
          List<Private_Static_IP__c> privateStaticList = new List<Private_Static_IP__c >();
          for(Install_Config__c  ic:listInstallConfig){
              Private_Static_IP__c psiFifth= new Private_Static_IP__c();
              psiFifth.Name='199.199.199.199';
              psiFifth.Install_Config__c=ic.id;
              privateStaticList.add(psiFifth);
          }             
          insert privateStaticList;		//trigger runs, and creates new Assets
          system.debug('SOQL used by inserting PSIP list : ' + Limits.getQueries());
          
          //ASSERT
          list<Asset> PSIPAssets = new List<Asset>();
          //PSIPAssets = [SELECT Id, Name, Parent_Asset__c FROM Asset WHERE NAME = '199.199.199.199'];
          //system.assertEquals(listInstallConfig.size(), PSIPAssets.size());		//There should one for every Install and Config...
          integer counter = 0;
          for (Asset a : [SELECT Id, Name, Parent_Asset__c FROM Asset WHERE NAME = '199.199.199.199']){
          	system.assertEquals(assetTOP.id, a.Parent_Asset__c);					//ALL Assets should be a child of the root!
          	counter++;
          }
		  system.assertEquals(listInstallConfig.size(), counter);					//There should be one Asset for each Install and Config in the List!
		  /*TODO An additional test that should be implmented involves the application of the Static IP Type Field
		   *     and verifying that the correct Product2 is used as the basis for the Private Static IP
		   *     The use of Custom Settings is preferred over the use of Custom Lables. Custom Settings will need
		   *     to be created/inserted as part of the test data setup
		   */
          test.stopTest();
      
   }
}