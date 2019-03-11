global class AccountShare_PortalContact_Scheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        AccountShare_PortalContact_Batch batchApex = new AccountShare_PortalContact_Batch();
        ID batchprocessid = Database.executeBatch(batchApex, 100);
    }
}