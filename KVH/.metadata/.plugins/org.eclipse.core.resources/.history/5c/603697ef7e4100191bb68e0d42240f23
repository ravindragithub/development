global with sharing class BatchProcessForRevenueTransactions implements Database.Batchable<sObject>, Database.Stateful{
  
  global string sQuery;
  global BatchProcessForRevenueTransactions(string query){
    this.sQuery = query;
  }
  
   
  public Database.QueryLocator start(Database.BatchableContext BC) {   
       return Database.getQueryLocator(squery);
  }
    
  global void execute(Database.BatchableContext BC, list< invoiceit_s__Invoice_Lines__c > listofinvoicelines){
         SavePoint sp;
        try{
            sp = DataBase.setSavepoint();
            IITRevenueTransactions.processRevenueTransactions(null,listofinvoicelines[0].Id);
        }catch(exception ex){
            Database.rollback(sp);
            //ex.getTypeName()+':'+ex.getMessage() + ':LINE ' + ex.getLineNumber()
        }    
  }
  
  global void finish(Database.BatchableContext BC){
  
  }

}