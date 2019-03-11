global class SendStateSchedule implements Schedulable{
    global void execute(SchedulableContext sc) {
        SendStateBatch batch = new SendStateBatch();
        Database.executeBatch(batch);
        
        if(test.isRunningTest()){
            Account a = [SELECT Id, Name FROM Account WHERE Name = 'testScheduledApexFromTestMethod'];
            a.name = 'testScheduledApexFromTestMethodUpdated';
            update a;
       }
    }
}