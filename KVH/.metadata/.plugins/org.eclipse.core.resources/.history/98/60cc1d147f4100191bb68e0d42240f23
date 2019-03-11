/***********************************************************************************************************************
 Name: SearchForSubscriberTest 
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "SearchForSubscriber" class 
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      28/04/2014       Initial Development                                   
***********************************************************************************************************************/
@isTest
private class SearchForSubscriberTest {
    static testMethod void SearchForSubscriber() {
         
        test.StartTest();
          //Creating New Account
          Account newAcc = new Account();
          newAcc.name = 'NewTestCustomer';
          newAcc.OwnerID = Userinfo.getUserId();
          newAcc.BillingStreet ='abc';
          newAcc.BillingCountry= 'United States';
          newAcc.BillingCity= 'middletown-11';
          newAcc.Billingstate = 'Rhode Island';
          newAcc.BillingPostalCode ='02842';
          insert newAcc;
          
          
          Account newAcc1 = new Account();
          newAcc1.name = 'NewTestCustomer1';
          newAcc1.OwnerID = Userinfo.getUserId();
          newAcc1.BillingStreet ='abc';
          newAcc1.BillingCountry= 'United States';
          newAcc1.BillingCity= 'middletown-11';
          newAcc1.Billingstate = 'Rhode Island';
          newAcc1.BillingPostalCode ='02842';
          insert newAcc1;
          
         //setup a billing account
        Billing_Account__c objBillingAccountCorporate = New Billing_Account__c();
        objBillingAccountCorporate.Account__c = newAcc.id;
        objBillingAccountCorporate.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
        objBillingAccountCorporate.Billing_Account_ID__c = '00';
        insert objBillingAccountCorporate;
        System.assert(objBillingAccountCorporate != null); 
        
          address__c a1 = new address__c();
            a1.Billing_Account__c =objBillingAccountCorporate.Id;
            a1.country__c='Canada';
            a1.state__c='NB';
            a1.Account__c=newAcc.id;
            a1.Address_Type__c='Airtime Services Billing';
            insert a1; 
            
          address__c a2 = new address__c();
            a2.country__c='Canada';
            a2.Billing_Account__c =objBillingAccountCorporate.Id;
            a2.state__c='NB';
            a2.Account__c=newAcc.id;
            a2.Address_Type__c='Airtime Services Subscriber';
            insert a2;   
          
         pw_ccpro__CountryObject__c pco = New pw_ccpro__CountryObject__c();
         pco.name = 'United States';
         pco.pw_ccpro__IsoCode_2__c = 'is';
         pco.pw_ccpro__IsoCode_3__c = 'iso';
         insert pco;
         
         pw_ccpro__State__c pst = new pw_ccpro__State__c();
         pst.name = 'Rhode Island';
         pst.pw_ccpro__Country__c = pco.id;
         pst.pw_ccpro__IsoCode__c = 'RI';
         insert pst;
          
            
          newAcc.id=newAcc.id;       
          newAcc.Account_Status__c = 'Active';
          newAcc.BillingStreet='Abc';
          newAcc.Account_Effective_Date__c = system.today(); 
          update newAcc;        
          
          
          //Creating NewContact
          Contact newCon   = new Contact();
          newCon.FirstName = 'NewTestContactName';
          newCon.LastName  = 'NewTest';
          newCon.Email     = 'test@test.com';
          newCon.AccountID = newAcc.id;
          insert newCon;
          
          Asset asset= new Asset();
            asset.Name='pa1';
            asset.AccountId=newAcc.id;
            asset.Asset_ID__c='123456789123456789789789';
            insert asset;
          
          //Creating NewCase
          Case newCase = new Case();
          newCase.AssetId= asset.id;
          newCase.Platform_Asset_Account__c = newAcc1.id;
          insert newCase;
          
          //Passing Current pageParameters from currentPageReference 
          Test.setCurrentPageReference(new PageReference('Page.SearchForSubscriber')); 
          System.currentPageReference().getParameters().put('caseid', newCase.id);
          System.currentPageReference().getParameters().put('subscriber', newAcc.id);
          System.currentPageReference().getParameters().put('subscriberId', newAcc.id);
          System.currentPageReference().getParameters().put('SelectedSubscriberDisplay', newAcc.id);
         
          
          ApexPages.StandardController controller = new ApexPages.StandardController(newCase);
          
          SearchForSubscriber subscriberSearch = new SearchForSubscriber(controller);
          subscriberSearch.AccountName = 'NewTest';          
          subscriberSearch.searchSubscriberAccount();
          subscriberSearch.SelectedSubscriber();
          subscriberSearch.FinalSelectedSubscriber();
          subscriberSearch.UpdatingExistingSubscriber();
          subscriberSearch.customCancel();
          subscriberSearch.Back();
          subscriberSearch.FinalSubmissionSubscriber();
          subscriberSearch.CreateNewChildSubscriber();
          subscriberSearch.SearchAgain();
          
          
          ApexPages.StandardController controllerNew = new ApexPages.StandardController(newCase);
          SearchForSubscriber subscriberSearchNew = new SearchForSubscriber(controllerNew);
          subscriberSearchNew.addNewSubscriber();
          subscriberSearchNew.NewSubscriber();
          subscriberSearchNew.FinalSubmissionSubscriber();
          //subscriberSearchNew.confirmSubscriber();
          
       test.StopTest();
    }
    static testMethod void SearchForSubscriberSec() {
         
        test.StartTest();
          //Creating New Account
          Account newAcc = new Account();
          newAcc.name = 'NewTestCustomer2';
          newAcc.OwnerID = Userinfo.getUserId();
          newAcc.BillingStreet ='abc';
          newAcc.BillingCountry= 'United States';
          newAcc.BillingCity= 'middletown-11';
          newAcc.Billingstate = 'Rhode Island';
          newAcc.BillingPostalCode ='02842';
          insert newAcc;
          
          
          Account newAcc1 = new Account();
          newAcc1.name = 'NewTestCustomer3';
          newAcc1.OwnerID = Userinfo.getUserId();
          newAcc1.BillingStreet ='abc';
          newAcc1.BillingCountry= 'United States';
          newAcc1.BillingCity= 'middletown-11';
          newAcc1.Billingstate = 'Rhode Island';
          newAcc1.BillingPostalCode ='02842';
          insert newAcc1;
          
         //setup a billing account
        Billing_Account__c objBillingAccountCorporate = New Billing_Account__c();
        objBillingAccountCorporate.Account__c = newAcc1.id;
        objBillingAccountCorporate.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
        objBillingAccountCorporate.Billing_Account_ID__c = '00';
        insert objBillingAccountCorporate;
        System.assert(objBillingAccountCorporate != null); 
        
          address__c a1 = new address__c();
            a1.country__c='Canada';
            a1.Billing_Account__c =objBillingAccountCorporate.Id;
            a1.state__c='NB';
            a1.Account__c=newAcc1.id;
            a1.Address_Type__c='Airtime Services Billing';
            insert a1; 
            
          address__c a2 = new address__c();
            a2.country__c='Canada';
            a2.state__c='NB';
            a2.Billing_Account__c =objBillingAccountCorporate.Id;
            a2.Account__c=newAcc.id;
            a2.Address_Type__c='Airtime Services Subscriber';
            insert a2; 
          
         pw_ccpro__CountryObject__c pco = New pw_ccpro__CountryObject__c();
         pco.name = 'United States';
         pco.pw_ccpro__IsoCode_2__c = 'is';
         pco.pw_ccpro__IsoCode_3__c = 'iso';
         insert pco;
         
         pw_ccpro__State__c pst = new pw_ccpro__State__c();
         pst.name = 'Rhode Island';
         pst.pw_ccpro__Country__c = pco.id;
         pst.pw_ccpro__IsoCode__c = 'RI';
         insert pst;
            
            
          newAcc.id=newAcc.id;       
          newAcc.Account_Status__c = 'Active';
          newAcc.BillingStreet='Abc';
          newAcc.Account_Effective_Date__c = system.today(); 
          update newAcc;        
          
          
          //Creating NewContact
          Contact newCon   = new Contact();
          newCon.FirstName = 'NewTestContactName';
          newCon.LastName  = 'NewTest';
          newCon.Email     = 'test@test.com';
          newCon.AccountID = newAcc.id;
          insert newCon;
          
          Asset asset= new Asset();
            asset.Name='pa1';
            asset.AccountId=newAcc.id;
            asset.Asset_ID__c='123456789123456789789789';
            insert asset;
          
          //Creating NewCase
          Case newCase = new Case();
          newCase.AssetId= asset.id;
          newCase.Platform_Asset_Account__c = newAcc1.id;
          insert newCase;
          
          //Passing Current pageParameters from currentPageReference 
          Test.setCurrentPageReference(new PageReference('Page.SearchForSubscriber')); 
          System.currentPageReference().getParameters().put('caseid', newCase.id);
          System.currentPageReference().getParameters().put('subscriber', newAcc.id);
          System.currentPageReference().getParameters().put('subscriberId', newAcc.id);
          System.currentPageReference().getParameters().put('SelectedSubscriberDisplay', newAcc.id);
         
          ApexPages.StandardController controllerNew = new ApexPages.StandardController(newCase);
          SearchForSubscriber subscriberSearch = new SearchForSubscriber(controllerNew);
          subscriberSearch.AccountName = 'NewTest';          
          subscriberSearch.searchSubscriberAccount();
          subscriberSearch.SelectedSubscriber();
          subscriberSearch.UpdatingExistingSubscriber();
          subscriberSearch.customCancel();
          subscriberSearch.Back();
          subscriberSearch.updateAddress=false;
          subscriberSearch.FinalSubmissionSubscriber();
          subscriberSearch.CreateNewChildSubscriber();
          subscriberSearch.SearchAgain();
          subscriberSearch.viewFinalScbscriber();
          
       test.StopTest();
    }
}