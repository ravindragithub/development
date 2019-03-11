public class myKVH_Edit_User_Case extends myKVH_User_Management_Base{
	public Id UserId {get;set;}
	public Boolean hasUserId {get;set;}												//indicates that we do or do not have a User ID
	public Boolean isSelfEditing {get;set;}											//Indicates that the Customer Admin is editing thierself
																					//Use this to prevent a Customer Admin from making thierself
																					//not-a-customer-admin
	public String UserChangeRequest {get;set;}										//text area for Case Comment
	public String caseMessage {get;set;}											//Message with Case Number
	public Boolean saveDisabled {get;set;}											//forces user to add a case comment
	public case submittedCase {get;set;}											//the Case the user created
	public Boolean success {get;set;}												//input/output state
	
	public myKVH_Edit_User_Case(){	//Constructor8
		try{
			UserId = (id)apexpages.currentpage().getparameters().get('user');
			system.debug('Editing User with Id: ' + UserId);
			if(UserId != null){
				//Query User/myKVH_Contact
				list<User> readUsers = [SELECT Id, username, LastName, FirstName, contactId, Contact.AccountId, Contact.Account.Name
										FROM User WHERE Id =: UserID];
				SFUser = readUsers[0];
				//Refactor to use Query string defined in Base Class
				list<Contact> readContacts = [SELECT Id, FirstName, LastName, Name, Email, Phone, MobilePhone, AccountId, Account.Name, 
													Job_Function__c, Receive_Network_Service_Notifications__c 
												FROM Contact 
												WHERE Id =: SFUser.ContactId];
				SFContact = readContacts[0];
				list<myKVH_Contact__c> readmyKVHContacts = [SELECT Id, Name, email__c, First_Name__c, Last_Name__c,
																	mobile__c, phone__c, Receive_Network_Service_Notifications__c,
																	Job_Function__c, Contact__c
															FROM myKVH_Contact__c WHERE Contact__c =: SFContact.Id];
				if(readmyKVHContacts.size() == 0){							//No staging contact... not User created
					myKVHContact = populateActivationContact(SFContact);	//must create one! need to manage that FleetId!
				} else if (readmyKVHContacts.size() > 1){					//Should never happen!!
					//What if there are more than one! Maybe we should search on email!
				} else {													//One and only one staging Contact....
					myKVHContact = readmyKVHContacts[0];					//THIS one obviously!
				}
				//VAlidate user Passed into controller is within Current USers' scope....
				AcctsInHierarchy = new list<Account>(getAccountsInHierarchy(myKVHHierarchy));			//Extract a list of Accounts from a filtered Hierarchy
				hasUserId = isManagedUser(SFUser, getManagedUsers(AcctsInHierarchy));					//Dis-allow a URL hack!
				If(hasUserId == true){
					if(UserInfo.getUserId() == UserID){
						isSelfEditing = true;
					}
				success = false;
				saveDisabled = true;
				}
			} else {
				//handle misdirection! Apex page message? Redirect?
				hasUserId = false;
			}
			
		} catch (exception e){	//Handle a WTF situation....
			system.debug('Exception Message: ' + e.getMessage());
			system.debug('Stack Trace: ' + e.getStackTraceString());
		}
	}
	public pageReference Submit(){
		//create and insert Case
		//return to Manage Users Page
		system.debug('Invoking Submit....');
		REST_API_utilities.resultCode rc =  createCase(UserChangeRequest);
		caseMessage = rc.exceptionMessage;
		return null;
	}
	public pageReference Cancel(){
		//return to Edit Users Page
		system.debug('Invoking Cancel....');
		return new PageReference('/myKVH_edit_user?user=' + (string)UserId);
	}
	public void validateComment(){
		if(UserChangeRequest != ''){
			saveDisabled = false;
		} else {
			saveDisabled = true;
		}
	}
	private REST_API_utilities.resultCode createCase(string Comment){
		REST_API_utilities.resultCode rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		submittedCase = new Case();
		Id myKVH_feedback_RECORD_TYPE_ID = Schema.SObjectType.case.getRecordTypeInfosByName().get('myKVH Feedback').getRecordTypeId();
		list<Group> Qs = [select Id from Group where DeveloperName = 'MyKVH_Support' and Type = 'Queue'];
		Id caseQ = Qs[0].Id;
		submittedCase.RecordTypeId = myKVH_feedback_RECORD_TYPE_ID;
		submittedCase.OwnerId = caseQ;		//see what happens....
		submittedCase.ContactId = SFContact.Id;
		submittedCase.Type = 'myKVH Feedback';
		submittedCase.Product_or_Service__c = 'Other Changes';
		submittedCase.Subject = 'myKVH Customer Admin User change request';
		submittedCase.Origin = 'Web';
		String descrip = 'myKVH Customer Admin has requested changes to the following User/Contact:\r\n\r\n';
		descrip = descrip + 'User: '+ SFUser.username + '  ' + SFUser.LastName + ', ' + SFUser.FirstName + '\r\n\r\n';
		descrip = descrip + 'Contact: '  + SFContact.email + '  ' + SFContact.LastName + ', ' + SFContact.FirstName + '\r\n\r\n';
		descrip = descrip + 'Please see Comments for further details';
		submittedCase.Description = descrip;
		try{
			insert submittedCase;
			submittedCase = [SELECT Id, CaseNumber FROM Case WHERE Id =: submittedCase.Id LIMIT 1];		//read back for the case number (anything else?)
			rc.success = true;
			rc.exceptionMessage = 'Your request has been submitted as Case Number ' + submittedCase.CaseNumber;
			CaseComment newCaseComment = new CaseComment();			//CaseComments are NOT required!
			if(Comment != null){									//Make sure that we have a Case Comment before...
				newCaseComment.ParentId = submittedCase.Id;			//assigning the parent Case (e.g. The Comment is related to THIS Case)
				newCaseComment.CommentBody = Comment;
				system.debug(newCaseComment);
				insert newCaseComment;							//Insert the Case Comment
			}
			success = true;
		} catch (exception e){
			system.debug('Exception Message: ' + e.getMessage());
			system.debug('Stack Trace: ' + e.getStackTraceString());
			rc.success = false;
			rc.exceptionMessage = 'Your request was unsuccessful: ' + e.getMessage();
		}
		return rc;
	}
}