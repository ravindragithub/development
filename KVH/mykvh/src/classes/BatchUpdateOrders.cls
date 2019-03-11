global class BatchUpdateOrders implements Database.Batchable<sObject>,Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      
      String query ='Select id, invoiceit_s__Master_Order__r.invoiceit_s__Account__c, invoiceit_s__Account__c,invoiceit_s__Billing_Master_Account__c from invoiceit_s__Job__c WHERE RecordType.Name =\'Child Order\' and invoiceit_s__Billing_Master_Account__c = null and Invoice_Details__c = \'Consolidated\'';
      
      if(Test.isRunningTest()){
          query ='Select id, invoiceit_s__Master_Order__r.invoiceit_s__Account__c, invoiceit_s__Account__c,invoiceit_s__Billing_Master_Account__c from invoiceit_s__Job__c WHERE RecordType.Name =\'Child Order\' and invoiceit_s__Billing_Master_Account__c = null and Invoice_Details__c = \'Consolidated\' limit 1';
      }
      return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<invoiceit_s__Job__c> scope){
      list< invoiceit_s__Job__c > joblist = new list< invoiceit_s__Job__c >();
        for(invoiceit_s__Job__c job : scope) 
        { 
         job.invoiceit_s__Billing_Master_Account__c = job.invoiceit_s__Master_Order__r.invoiceit_s__Account__c; 
        joblist.add(job);

        } 
        update joblist;

    }
    global void finish(Database.BatchableContext BC){
                    
      system.debug('Batch Job to update child order’s “Billing Master Account" is completed!'); 
    }

}