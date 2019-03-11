global with sharing class IITBatchProcessForRecalculateOrder implements Database.Batchable<sObject>{
    
    global string squery;
    global invoiceit_s__Job__c OrderObj;
    global set<Id> orderIds = new set<Id>();
    
    global IITBatchProcessForRecalculateOrder(set<Id> orderIds) {
        this.orderIds.addAll(orderIds);
    }
    
    // this method would return the count of batch execution
    public Database.QueryLocator start(Database.BatchableContext BC) {   
        squery = 'SELECT Id FROM invoiceit_s__Job__c WHERE Id in:orderIds ';
        return Database.getQueryLocator(squery);
    }
    
    // Hard coding zero beacuse batch size will be always 1
    global void execute(Database.BatchableContext BC, List<invoiceit_s__Job__c > listOfOrder) {
      try {   
        invoiceit_s__Job__c  orderObj = new invoiceit_s__Job__c(Id = listOfOrder[0].Id, invoiceit_s__Recalculate__c = true);
        update orderObj;
       } catch(exception ex) {
       
       }    
    }
    
    global void finish(Database.BatchableContext BC) {
    
    }

}