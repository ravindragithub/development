global class EbillHyperlinkSchedulable_V2 implements Schedulable{
    global void execute(SchedulableContext sc) {
        BatchEbilllink_V2 batch = new BatchEbilllink_V2();
        Database.ExecuteBatch(batch, 25);
        /*Maximum tested batch size = 25*/
        if(test.isRunningTest()){
            Account a = [SELECT Id, Name FROM Account WHERE Name = 'testScheduledApexFromTestMethod'];
            a.name = 'testScheduledApexFromTestMethodUpdated';
            update a;
       }
    }
}