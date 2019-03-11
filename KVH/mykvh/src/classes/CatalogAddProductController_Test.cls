@isTest 
global class CatalogAddProductController_Test {
  
    @isTest 
    static void unittest() {
        Product2 pro = new Product2(Name = 'test product',Catalog_Display_Name__c = 'test',IsActive = true,Display_Product__c = 'No');
        insert pro;
        
        ApexPages.currentPage().getParameters().put('term','test');
        CatalogAddProductSearchController searchctrl = new CatalogAddProductSearchController();
        searchctrl.getproducts();
        
        CatalogAddProductSearchController searchctrl2 = new CatalogAddProductSearchController();
        searchctrl.getproducts();
        
        CatalogAddProductSearchController searchctrl3 = new CatalogAddProductSearchController();
        searchctrl.getproducts();
        
        
        ApexPages.currentPage().getParameters().put('productId',pro.id);
        CatalogAddProductController ctrl = new CatalogAddProductController();
        ctrl.saveRecords();
        
        ApexPages.currentPage().getParameters().put('productId',pro.id);
        ctrl = new CatalogAddProductController();
        ctrl.rownumber = 0;
        ctrl.removeMarketsector();
        ctrl.saveRecords();
    }
}