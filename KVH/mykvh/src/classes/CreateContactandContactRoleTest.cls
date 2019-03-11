/***********************************************************************************************************************
Name: CreateContactandContactRoleTest 
Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
Purpose: This is used to test "CreateContactandContactRole" class 
------------------------------------------------------------------------------------------------------------------------
Utilized in(Called in):
-----------------------

========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0     Gopi Kishore. K      18/05/2014       Initial Development                                   
***********************************************************************************************************************/
@isTest

private class CreateContactandContactRoleTest {
    
    @testSetup
    static void Setuptestdata(){
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
        newCon.FirstName  = 'FirstName';
        newCon.lastName  = 'NewTestContactName';
        newCon.Email  = 'NewTestContactName@gmail.com';
        newCon.AccountID = newAcc.id; 
        insert newCon;
        
        Asset newParentAsset = new Asset();
        newParentAsset.name = '001122344';
        newParentAsset.AccountID = newAcc.id;
        newParentAsset.ContactID = newCon.id;
        insert newParentAsset;
        
        Asset newAsset = new Asset();
        newAsset.name = '001122344';
        newAsset.AccountID = newAcc.id;
        newAsset.ContactID = newCon.id;
        newAsset.Parent_Asset__c = newParentAsset.id;
        insert newAsset;
        
        Case newCase = new Case(Origin='Phone',Action_Plan__c='Follow-up',Status='New',AssetID=newAsset.id,Modem_IP_2__c=newAsset.id); insert newCase;
    }
    static testMethod void PositiveCreateContactandContactRole() {
        test.StartTest();
        
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
        
        
        //Passing Current pageParameters from currentPageReference
        Test.setCurrentPageReference(new PageReference('Page.CreateContactandContactRole')); 
        System.currentPageReference().getParameters().put('caseid', aCase.id);
        System.currentPageReference().getParameters().put('id', newCon.id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(aCase);
        CreateContactandContactRole conSquareRole = new CreateContactandContactRole(controller);
        
        conSquareRole.ContactName = 'FirstName NewTestContactName';
        conSquareRole.ContactEmail = 'NewTestContactName@gmail.com';
        conSquareRole.getContactRoleValues();
        conSquareRole.SearchforContact();
        conSquareRole.SelectedContact();
        conSquareRole.createNewContactAndContactRole();
        conSquareRole.newContactRole();
        conSquareRole.CreateAdditionContactRole();
        conSquareRole.contactRolesave();
        conSquareRole.returnToCase();
        
        test.Stoptest();
        
    }
    
    static testMethod void NegativeCreateContactandContactRole() {
        test.StartTest();
        
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
        newCon.FirstName  = 'FirstName';
        newCon.lastName  = 'NewTestContactName';
        newCon.Email  = 'NewTestContactName@gmail.com';
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
        
        Case newCase = new Case(Origin='Phone',Action_Plan__c='Follow-up',Status='New',AssetID=newAsset.id,Modem_IP_2__c=newAsset.id); insert newCase;
        
        
        //Passing Current pageParameters from currentPageReference
        Test.setCurrentPageReference(new PageReference('Page.CreateContactandContactRole')); 
        System.currentPageReference().getParameters().put('caseid', newCase.id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(newCase);
        CreateContactandContactRole conSquareRole = new CreateContactandContactRole(controller);
        conSquareRole.ContactName = 'tetest';
        conSquareRole.SearchforContact();
        conSquareRole.contactRolesave();
        
        test.StopTest();
    }
    static testMethod void ConvertedUserFormContact() {
        test.StartTest();
        Case newCase = [SELECT Id from Case LIMIT 1];
        Contact newCon = [ SELECT FirstName ,lastName ,Email  ,AccountID FROM Contact LIMIT 1];
        Test.setCurrentPageReference(new PageReference('Page.CreateContactandContactRole')); 
        System.currentPageReference().getParameters().put('caseid', newCase.id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(newCase);
        CreateContactandContactRole conSquareRole = new CreateContactandContactRole(controller);
        conSquareRole.getConvertedUserFormContact(newCon);
        test.StopTest();
    }
}