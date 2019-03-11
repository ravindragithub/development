/***********************************************************************************************************************
 Name: Add_or_Update_Airtime_ContactRolesTest 
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "Add_or_Update_Airtime_ContactRoles" class 
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

private class Add_or_Update_Airtime_ContactRolesTest {
   static testMethod void Add_or_Update_Airtime_ContactRoles() {
      test.StartTest();
          //Creating NewCase
          Case newCase = new Case();
          insert newCase;
          
          
           //Passing Current pageParameters from currentPageReference 
          System.currentPageReference().getParameters().put('id', newCase.id);
          ApexPages.StandardController controller = new ApexPages.StandardController(newCase);
          Add_or_Update_Airtime_ContactRoles airTimeUpdate = new Add_or_Update_Airtime_ContactRoles(controller);
          
          
      test.StopTest();
      }
}