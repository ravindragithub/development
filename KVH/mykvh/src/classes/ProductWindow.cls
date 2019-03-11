/***********************************************************************************************************************
 Name: productWindow
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: 1) This is used to popup product records denpend on identifier selected on Add_Identifier_Product page
          2) selected product value placed in Add_Identifier_Productpage  
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      16/06/2014       Initial Development                                   
***********************************************************************************************************************/

public with sharing class ProductWindow{
 
  public List<product2> results{get;set;} // search results  
  public string searchString{get;set;} // search keyword
  public String identifierType{get;set;}
  Map<ID,String> mapAccountContactRole = new Map<ID,String>();
  
  list<id> contactIds = new List<id>();
  public ProductWindow() { 
    searchString = System.currentPageReference().getParameters().get('lksrch');
    identifierType = System.currentPageReference().getParameters().get('IFtype');
    runSearch();  
  }

  public PageReference search() {
    runSearch();
    return null;
  }
 
  private void runSearch() {   
    results = performSearch(searchString);               
  } 
  
  private List<product2> performSearch(string searchString) {
    String soql = 'select id,Name,Family,Description,ProductCode from product2';
    if(searchString != '' && searchString != null){
        soql = soql +  ' where name LIKE \'%' + searchString +'%\'';
        soql = soql + ' AND Identifier_Type__c LIKE \'%' + identifierType +'%\' ';
    }else{
        soql = soql +  ' where Identifier_Type__c LIKE \'%' + identifierType +'%\'';
    }
    soql = soql + ' limit 25';
    list<product2> product2Data = database.query(soql);
    return product2Data;   
  }
 
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
}