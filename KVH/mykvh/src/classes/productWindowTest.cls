/***********************************************************************************************************************
 Name: productWindowTest
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "productWindow" class 
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      17/06/2014       Initial Development                                   
***********************************************************************************************************************/
@isTest
private class  productWindowTest {
   static testMethod void  ProductWindow() {
      test.StartTest();
      
        Product2 newProduct = new Product2();
        newProduct.Name = 'MyTestProduct';
        newProduct.Identifier_Type__c = 'Data';
        insert newProduct;
        
        
        //Testing class with out search value 
        Test.setCurrentPageReference(new PageReference('Page.ProductWindow')); 
        System.currentPageReference().getParameters().put('IFtype', newProduct.Identifier_Type__c);
        
        ProductWindow proWinNoSearch = new ProductWindow();
    
    
        //Testing class with search value
        Test.setCurrentPageReference(new PageReference('Page.ProductWindow')); 
        System.currentPageReference().getParameters().put('lksrch', newProduct.Name);
        System.currentPageReference().getParameters().put('IFtype', newProduct.Identifier_Type__c);
        
        ProductWindow proWin = new ProductWindow();
        proWin.search();
        proWin.getFormTag();
        proWin.getTextBox();
        
      test.StopTest();
   }
}