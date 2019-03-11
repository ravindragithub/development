global class EquipmentBatchSchedulable implements Schedulable{
	global void execute(SchedulableContext sc){
		EquipmentBatch1 batch = new EquipmentBatch1();
		Id JobId = Database.executeBatch(batch, 4);
		system.debug('Started Batch Apex Job: '+ JobId);
	}
}