global class Schedule_IPMC_File_Services_Vessel_Email implements Schedulable{
    global void execute(SchedulableContext sc){
        Batch_IPMC_File_Services_Vessel_Email batch = new Batch_IPMC_File_Services_Vessel_Email();
        id jobID = Database.executeBatch(batch);
        if(test.isRunningTest()){
            Account a = [SELECT Id, Name FROM Account WHERE Name = 'testScheduledApexFromTestMethod'];
            a.name = 'testScheduledApexFromTestMethodUpdated';
            update a;
        }
    }
}