public with sharing class SendAirtimeConfirmationController_ext {

	//Constructor
	public SendAirtimeConfirmationController_ext(ApexPages.StandardController stdCont){
		
	}
	public pageReference autoRun(){
		Id caseId = ApexPages.currentPage().getParameters().get('Id');
        if (caseId == null) {
            // Display the Visualforce page's content if no Id is passed over
            return null;
        }
        EmailTemplate template = [SELECT e.Id FROM EmailTemplate e WHERE DeveloperName = 'Activation_Confirmation' LIMIT 1];
        Case airtimeCase = [SELECT Id, ContactId FROM Case WHERE Id =: caseID LIMIT 1]; 
		system.debug(airtimeCase);
		// set the manual push flag
		airtimeCase.myKVH_Manual_Push__c = true;
		update airtimeCase;
		//redirect to the standard email page
		//what is  template_id=00X700000015WDiEAM   - this is the email template id i think. 
		string longURL = '/_ui/core/email/author/EmailAuthor?p2_lkid='+ airtimeCase.ContactId + '&rtype=003&p3_lkid=' + airtimeCase.Id;
		longURL += '&retURL=' + airtimeCase.Id + '&template_id=' + template.Id;
		system.debug(longURL);
		PageReference sendEmail = new PageReference(longURL);
		return sendEmail;
	}
}