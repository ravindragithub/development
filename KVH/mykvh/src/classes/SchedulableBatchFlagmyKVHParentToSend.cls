global class SchedulableBatchFlagmyKVHParentToSend implements Schedulable {
    global void execute(SchedulableContext sc) {
        BatchFlagmyKVHParentToSend batch = new BatchFlagmyKVHParentToSend();
        Database.ExecuteBatch(batch);
    }
}