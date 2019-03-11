global class HTS_shaping_policy_sync_shedulable implements Schedulable {
  global void execute(SchedulableContext sc) {
    ID jobID = System.enqueueJob(new HTS_subscriber_plans_sync());
  }
}