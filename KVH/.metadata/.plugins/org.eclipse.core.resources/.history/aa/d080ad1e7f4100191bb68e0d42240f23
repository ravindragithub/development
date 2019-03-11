/***********************************************************************************************************************
 Name: Update_or_AddSubscriberTest 
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "Update_or_AddSubscriber" class 
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

private class Update_or_AddSubscriberTest {
   static testMethod void Update_or_AddSubscriber() {
      test.StartTest();
          //Creating NewCase
          Case newCase = new Case();
          insert newCase;
          
          
           //Passing Current pageParameters from currentPageReference 
          System.currentPageReference().getParameters().put('id', newCase.id);
          ApexPages.StandardController controller = new ApexPages.StandardController(newCase);
          Update_or_AddSubscriber addSubscriber = new Update_or_AddSubscriber(controller);
          
          
      test.StopTest();
      }
}