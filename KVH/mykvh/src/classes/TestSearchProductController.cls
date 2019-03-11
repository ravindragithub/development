@isTest 
private class TestSearchProductController {
    @isTest 
    static void unittest() {
        
        Product2 pro = new Product2(Name = 'test product',Catalog_Display_Name__c = 'test',Display_Product__c ='Yes');
        insert pro;
        
       apexpages.currentpage().getparameters().put('term','test');
       
       SearchProductController ctrl = new SearchProductController();
       ctrl.getProducts();
    }
}