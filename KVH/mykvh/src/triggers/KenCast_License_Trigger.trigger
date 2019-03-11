trigger KenCast_License_Trigger on KenCast_License__c (after delete, after insert, after undelete, 
										after update, before delete, before insert, before update) {
		
	List<KenCast_License__c> records = trigger.isDelete ? trigger.old :           trigger.new;
	//  if its a delete trigger  then return trigger.old else return trigger.new^

	KenCast_License_Trigger_Handler handler = 
		new KenCast_License_Trigger_Handler(Trigger.isExecuting, Trigger.size);
		
	/* Unused Trigger Contexts may be commeneted out when deployed to Production
		Corresponding Trigger Handler Contexts may also be commented out */
	/* Before Insert */
	if(Trigger.isInsert && Trigger.isBefore){
		handler.OnBeforeInsert(Trigger.new); 
	}
	/* Only need a before insert context...
	// After Insert 
	else if(Trigger.isInsert && Trigger.isAfter){
		handler.OnAfterInsert(trigger.new, trigger.oldMap);
	}
	
	// Before Update 
	else if(Trigger.isUpdate && Trigger.isBefore){
		handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
	}
	
	// After Update 
	else if(Trigger.isUpdate && Trigger.isAfter){
		handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap); 
	}
	*/
}