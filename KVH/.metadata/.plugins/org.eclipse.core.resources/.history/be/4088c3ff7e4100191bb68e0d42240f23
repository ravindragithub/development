global class HTS_terminal_templates_sync_schedulable implements Schedulable {
  global void execute(SchedulableContext sc) {
    ID jobID = System.enqueueJob(new HTS_terminal_templates_sync());
  }
}