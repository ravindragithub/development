global class Purge_Old_Records_Schedulable implements Schedulable {

    Public void execute(SchedulableContext SC){
        
    // Retention_Policy__mdt is a "Custom MetaData Type".  As of 2017-09-12 it has one record, which the SOQL below will return. 
    // The record has the field Days__c set to 90.

    // Purge the old records from object (Table)  Callout_Log_c
    List<Retention_Policy__mdt> myRetentionPol = [SELECT Days__c FROM Retention_Policy__mdt WHERE DeveloperName='Callout_Log_c'];
    Integer Days_To_Retain = Integer.valueOf(myRetentionPol[0].Days__c);
    List<Callout_Log__c> toDel = CalloutLogs.getRecordsToPurge(Days_To_Retain);
    delete toDel;

    // The intent is that you can copy the above 4 lines code below and edit it to purge old records from any other object. 
    // First, search Setup for "Custom Metadata Types", find the Type "Retention Policy", click the "Manage" link, add a new record with the
    // DeveloperName field set to the APIName of the object you want to purge and Days__c set to an appropriate number.


     }

}