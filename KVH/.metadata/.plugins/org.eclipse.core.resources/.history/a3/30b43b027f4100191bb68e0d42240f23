global with sharing class IITRunSchedulerUpliftPrice implements Schedulable {
     
     global void execute(SchedulableContext context) {
        string sQuery = 'SELECT invoiceit_s__Price_Type__c, invoiceit_s__Order__c, Next_Uplift_Date__c, invoiceit_s__Unit_Price__c FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE invoiceit_s__Uplift__c > 0 AND (Next_Uplift_Date__c <=: system.today()) AND (invoiceit_s__Service_End_Date__c == null || invoiceit_s__Service_End_Date__c >=: system.today())';
        IITBatchUpliftPrice batch = new IITBatchUpliftPrice(sQuery, true);
        ID batchprocessid = Database.executeBatch(batch);
     }
}