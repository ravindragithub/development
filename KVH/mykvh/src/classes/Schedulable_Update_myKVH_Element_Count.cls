global class Schedulable_Update_myKVH_Element_Count implements Schedulable {
    global void execute(SchedulableContext sc) {
        Batch_Update_myKVH_Element_Count batch = new Batch_Update_myKVH_Element_Count();
        Database.ExecuteBatch(batch);
    }
}