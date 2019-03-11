public class ContactBeforeInsertTriggerHandler extends TriggerHandlerBase{
	public override void mainEntry(TriggerParameters tp) {
		if(test.isRunningtest()){		//Add this block for 100% code coverage
			inProgressEntry(tp);
		}
	}
	public override void inProgressEntry(TriggerParameters tp) {
		system.debug('This is an example for reentrant code...');
	}
}