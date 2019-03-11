/***********************************************************************************************************************
 Name: Find_or_Create_Contract_or_ServiceTest
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "Find_or_Create_Contract_or_Service" class 
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
private class Find_or_Create_Contract_or_ServiceTest {
    static testMethod void Find_or_Create_Contract_or_Service() {
        test.startTest();
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
          
           //Passing Current pageParameters from currentPageReference
          Test.setCurrentPageReference(new PageReference('Page.Find_or_Create_Contract_or_Service')); 
          System.currentPageReference().getParameters().put('id', newCase.id);
          
          ApexPages.StandardController controller = new ApexPages.StandardController(newCase);
          Find_or_Create_Contract_or_Service findContractService = new Find_or_Create_Contract_or_Service(controller);

        test.stopTest(); 
    }
}