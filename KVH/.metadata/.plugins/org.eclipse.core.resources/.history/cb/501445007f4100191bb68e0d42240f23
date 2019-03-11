public class I2CMAssignIdentifiers_queueable implements Queueable, Database.AllowsCallouts{
  public Asset I2CM;

  public I2CMAssignIdentifiers_queueable(Asset inputObj){
    I2CM = new Asset();
    this.I2CM = inputObj;
  }
  public void execute(QueueableContext context){
    system.debug(Service_I2CMAssignIdentifers.assignIdentifiers(I2CM));
  }
}