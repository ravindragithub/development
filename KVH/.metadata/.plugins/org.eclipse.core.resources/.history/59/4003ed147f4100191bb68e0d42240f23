global class SendStateBatch implements Database.Batchable<sObject> {
  global Database.Querylocator start(Database.BatchableContext context) {
    System.debug('Start');
      List<invoiceit_s__Invoice__c> results = new List<invoiceit_s__Invoice__c>();     
      results = [SELECT invoiceit_s__Account__c FROM invoiceit_s__Invoice__c WHERE Unpaid_Amount_30_days__c > 0 AND invoiceit_s__Invoice_Status__c = 'Posted'];
      List<Id> fiList = new List<Id>();
      for (invoiceit_s__Invoice__c t: results) {
          fiList.add( t.invoiceit_s__Account__c );
      }
    return Database.getQueryLocator(
      [SELECT Id, Snapshot_Name__c FROM Account WHERE (Date_Statement_Sent__c <: (system.today()-30) OR Date_Statement_Sent__c =: null) AND RecordTypeId = '01213000001CCzwAAG' AND Do_Not_Send_Statement__c = FALSE AND Receive_Statements__c !=: null AND Id IN :fiList LIMIT 70]);
  }
  
  global void execute(Database.BatchableContext context, List<sObject> scope) {
     System.debug('Executing');
     for(sObject rec : scope) {
         Account a = (Account)rec;
         IITCustomerStatements.ResponseClass result = IITCustomerStatements.generateRealTimeStatement(a.Id);
         string snapshot = result.snapshotName;
         System.debug(snapshot);
         a.Snapshot_Name__c = snapshot;
         System.debug(a);
    }
      update scope;
  }
  global void finish(Database.BatchableContext context) {
    System.Debug('Finish!');
  }
}