public with sharing class CustomAssetItemLookupController {
    
    public Product2 objProduct2 {get;set;} 
    public List<Product2> results{get;set;} 
    public string searchString{get;set;} 
    
    public CustomAssetItemLookupController() {
        objProduct2 = new Product2();
        searchString = System.currentPageReference().getParameters().get('lksrch');
        runSearch();  
    }
    
    // performs the keyword search
    public PageReference search() {
        runSearch();
        return null;
    }
    
    // prepare the query and issue the search command
    private void runSearch() {
        // TODO prepare query string for complex serarches & prevent injections
        results = performSearch(searchString);               
    } 
    
    private List<Product2> performSearch(string searchString) {
        
        String soql = 'Select Name,Id,ProductCode,Product_ID__c from Product2 WHERE isActive=true AND Product_ID__c LIKE \'%_US\' ';
        if(searchString != '' && searchString != null)
            soql = soql +  ' and Product_ID__c LIKE \'%' + searchString +'%\'';
        soql = soql + ' limit 25';
        System.debug(soql);
        return database.query(soql); 
        
    }
    
}