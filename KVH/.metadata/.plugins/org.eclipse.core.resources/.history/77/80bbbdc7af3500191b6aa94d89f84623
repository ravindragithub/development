global class Batch_IPMC_File_Services_Vessel_Email implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Asset__r.Account.Name,Asset__r.Account.Vessel_email__c,Service_Item__r.Family,Vessel_Email__c FROM Contracted_Services__c ';
        String whereClause = 'WHERE Terminated_Date__c = null AND Service_Item__r.Family = \'File Services\'';
        return Database.getQueryLocator(query + whereClause);
    }
    
    global void execute(Database.BatchableContext BC, List<Contracted_Services__c> scope){
        list<Contracted_Services__c> updateList = new list<Contracted_Services__c>();
        for(Contracted_Services__c cs : scope){
            //compare and fix Emails... make a new list...
            if(cs.Asset__r.Account.Vessel_email__c != null && cs.Vessel_Email__c != cs.Asset__r.Account.Vessel_email__c){
                Contracted_Services__c newCS = new Contracted_Services__c(Id = cs.Id, Vessel_Email__c = cs.Asset__r.Account.Vessel_email__c);
                updateList.add(newCS);
            }
        }
        system.debug('updateList : ' + updateList);
        update updateList;
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug('Finished IPMC_File_Services_Vessel_Email_Batch');
    }
}