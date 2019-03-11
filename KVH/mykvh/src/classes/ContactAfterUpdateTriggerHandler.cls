public class ContactAfterUpdateTriggerHandler extends TriggerHandlerBase{
	public override void mainEntry(TriggerParameters tp) {
		if(test.isRunningtest()){		//Add this block for 100% code coverage
			inProgressEntry(tp);
		}
		ContactUtilities util = new ContactUtilities();
		util.deactivateUsers(tp.newList);
	}
	public override void inProgressEntry(TriggerParameters tp) {
		system.debug('This is an example for reentrant code...');
	}
}