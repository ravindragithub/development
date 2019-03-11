trigger Act_Subscriber on Activation_Subscriber__c (after insert, after update) {
    if(Trigger.isAfter && Activation_Corporate_Company.onlyActivationSubuscriber){
        Act_Subscriber_Handler.onAfter(Trigger.New);
    }
    if(Trigger.isInsert)
	Act_Subscriber_Handler.AddContactRole(Trigger.New);
}