/***********************************************************************************************************************
 Name: CaseAssetPageControllerTest 
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "CaseAssetPageController" class 
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
private class CaseAssetPageControllerTest {

    static testMethod void CaseAssetPageController() {
        
        Case newCase = new Case();
        insert newCase;
    
        ApexPages.StandardController controller = new ApexPages.StandardController(newCase);
        Test.setCurrentPageReference(new PageReference('Page.Find_and_Add_Account_to_Asset')); 
        System.currentPageReference().getParameters().put('id', newCase.id);
        CaseAssetPageController CaseassetTest = new CaseAssetPageController(controller);
        
        
        Case newCaseplatformCheck = new Case();
        newCaseplatformCheck.Search_for_or_create_Platform_Account_in__c = true;
        insert newCaseplatformCheck;
        
        ApexPages.StandardController controllerplatformCheck = new ApexPages.StandardController(newCaseplatformCheck);
        Test.setCurrentPageReference(new PageReference('Page.Find_and_Add_Account_to_Asset')); 
        System.currentPageReference().getParameters().put('id', newCaseplatformCheck.id);
        CaseAssetPageController CaseassetTestplatformCheck = new CaseAssetPageController(controllerplatformCheck);
        
    }
}