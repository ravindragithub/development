/***********************************************************************************************************************
 Name: ContactRoleWindowTest
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "ContactRoleWindow" class 
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      04/06/2014       Initial Development                                   
***********************************************************************************************************************/
@isTest
private class ContactRoleWindowTest {
    static testMethod void ContactRoleWindow() {
        test.startTest();
         //Creating New Account
          Account newAcc = new Account();
          newAcc.name = 'NewTestCustomer';
          insert newAcc;
          
          //Creating NewContact
          
          Contact newCon   = new Contact();
          newCon.FirstName = 'test';
          newCon.LastName  = 'test';
          newCon.Email     = 'test@test.com';
          newCon.AccountID = newAcc.id; 
          insert newCon;
          
         
          //ContactRole Creation
          
          AccountContactRole ACR = new AccountContactRole();
          ACR.ContactID = newCon.id;
          ACR.role = 'MyNewRole';
          ACR.AccountID = newAcc.id;
          insert ACR;
          
          
          //Creating NewCase
          Case newCase = new Case();
          newCase.AccountID = newAcc.id;
          insert newCase;
          
           //Passing Current pageParameters from currentPageReference
          Test.setCurrentPageReference(new PageReference('Page.ContactRoleWindow')); 
          System.currentPageReference().getParameters().put('accId', newAcc.id);
          System.currentPageReference().getParameters().put('lksrch', 'test');
          
          ContactRoleWindow CRW = new ContactRoleWindow(); 
          CRW.searchString = 'test';
          CRW.search();
          CRW.getFormTag();
          CRW.getTextBox();
     }
}