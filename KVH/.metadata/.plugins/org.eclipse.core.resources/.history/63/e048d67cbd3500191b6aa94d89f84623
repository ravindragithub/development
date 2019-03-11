global class UAccountShareBatchSched implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        
        UAccountShareBatch batchApex = new UAccountShareBatch(false);
        ID batchprocessid = Database.executeBatch(batchApex, 1);
         
    }
}