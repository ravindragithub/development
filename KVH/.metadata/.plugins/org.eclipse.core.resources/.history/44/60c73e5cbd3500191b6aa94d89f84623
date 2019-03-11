public class Enqueue_Service_LTE_provisioining implements Queueable, Database.AllowsCallouts {

  public SBQQ__Subscription__c rawSub;

  public Enqueue_Service_LTE_provisioining(SBQQ__Subscription__c inputObj){
    rawSub = new SBQQ__Subscription__c();
    this.rawSub = inputObj;
  }
  public void execute(QueueableContext context){
    system.debug(Service_LTE_activation_provisioning.provisionLTE(rawSub));
  }

}