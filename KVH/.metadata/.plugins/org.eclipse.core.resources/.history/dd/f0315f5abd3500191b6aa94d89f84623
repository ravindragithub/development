/***********************************************************************************************************************
 Name: Create_addorUpdateContractRolesTest
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "Create_addorUpdateContractRoles" class 
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
private class Create_addorUpdateContractRolesTest {
    static testMethod void Create_addorUpdateContractRoles() {
         //Creating New Account
          Account newAcc = new Account();
          newAcc.name = 'NewTestCustomer';
          insert newAcc;
          
          //Creating NewContact
          
          Contact newCon   = new Contact();
          newCon.FirstName = 'NewTestContactName';
          newCon.LastName  = 'NewTest';
          newCon.Email     = 'test@test.com';
          newCon.AccountID = newAcc.id; 
          insert newCon;
          
          //Creating NewCase
          Case newCase = new Case();
          newCase.AccountID = newAcc.id;
          insert newCase;
          
          
          
          Account contractAccID = new Account();
          contractAccID.Name = 'TestName';
          insert contractAccID;
          
          
           //Passing Current pageParameters from currentPageReference
          Test.setCurrentPageReference(new PageReference('Page.Create_addorUpdateContractRoles')); 
          System.currentPageReference().getParameters().put('caseid', newCase.id);
          
          Create_addorUpdateContractRoles contactRoles = new Create_addorUpdateContractRoles();
          contactRoles.SelectedContractService();
          contactRoles.newContractBlockFunction();
          contactRoles.insertContractFunction();
          contactRoles.returnToCase();
    }
}