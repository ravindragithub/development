public with sharing class ContactRoleWindow{
 
  public List<Contact> results{get;set;} // search results  
  public string searchString{get;set;} // search keyword
  public ID accountID;
  Map<ID,String> mapAccountContactRole = new Map<ID,String>();
  list<id> contactIds = new List<id>();
  public ContactRoleWindow() { 
    accountID = System.currentPageReference().getParameters().get('accId');
    searchString = System.currentPageReference().getParameters().get('lksrch');
    List<AccountContactRole> contactRoles = [select id,ContactID,role from AccountContactRole where AccountID=:accountID];
    for(AccountContactRole ACR:contactRoles){
        contactIds.add(ACR.contactID);
        mapAccountContactRole.put(ACR.contactID,ACR.Role);
    }
    runSearch();  
  }

  public PageReference search() {
    runSearch();
    return null;
  }
 
  private void runSearch() {   
    results = performSearch(searchString);               
  } 
  public List<contactRoleDetails> UIContactRoleDetails{get;set;}
  private List<Contact> performSearch(string searchString) {
    UIContactRoleDetails = new List<contactRoleDetails>();
    String soql = 'select id,lastname,firstname,name,Account.name from contact';
    if(searchString != '' && searchString != null){
        soql = soql +  ' where name LIKE \'%' + searchString +'%\'';
        soql = soql + ' AND ID IN :contactIds';
    }else{
        soql = soql + ' where ID IN :contactIds';
    }
    soql = soql + ' limit 25';
    list<Contact> contactRoles = database.query(soql);
    for(Contact CR:contactRoles){
        contactRoleDetails CRD = new contactRoleDetails();
        CRD.contactId = CR.id;
        CRD.ContactName = CR.name;
        CRD.AccountName = CR.Account.name;
        if(mapAccountContactRole.containskey(CR.id))
        CRD.Role = mapAccountContactRole.get(CR.id);
        
        UIContactRoleDetails.add(CRD);
    }
    return contactRoles;   
  }
 
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  } 
  
  public class contactRoleDetails{
      public ID contactId{get;set;}
      public String ContactName{get;set;}
      public String AccountName{get;set;}
      public String Role{get;set;}
  } 
}