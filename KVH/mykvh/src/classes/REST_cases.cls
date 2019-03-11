@RestResource(urlMapping='/V1/cases/*')
global with sharing class REST_cases {
	@HttpGet
	//Responds to an HttpGet naturally... 
	//Given a User ID, this Method returns the list of Cases that the user can see
	//Given a Case ID, this MEthod returns the details of the Case
	global static sObject[] doGet(){								//might return a list of CaseShares, or a Case
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		List<sObject> returnList = new List<sObject>();		//declare return list
		//variables for CaseShare query
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		if(identifier.left(3) == '005'){
			system.debug('Searching for Case Shares by User');
			Try {
				returnList = [SELECT ID, Case.Id, Case.CaseNumber, Case.Subject, RowCause, UserOrGroupId, CaseAccessLevel, Case.ContactId,
							 Case.AccountId, Case.AssetID, Case.Platform_Asset_Account__c, Case.Status 
							 FROM CaseShare 
							 WHERE UserOrGroupID =:identifier AND Case.Status NOT IN ('Closed', 'Closed As Duplicate')];
				if (returnList.size()==0){
					res.statusCode = 404;
				}
				
			} Catch (Exception e) { res.statusCode = 500;	//Something bad happened... Should never get here!
															//An empty query response (zero records) returns statusCode 200!
			}												//recommended remedial action is try again!
			
		} else if(identifier.left(3) == '500'){
			system.debug('Searching for Cases by Case Id'); //query cases
			Try {
				returnList = [SELECT OwnerId, CaseNumber, RecordTypeId,
							  X3rd_Party_Ticket__c, X3rd_Party_Ticket_Provider__c, Type, Subject, Status, 
							  Satellite_Beam__c, Resolve_Date__c, Resolution__c, Product_or_Service__c, 
							  Product_or_Service_Detail__c, Origin, IsEscalated, Case_Symptom__c, Action_Plan__c 
							 FROM Case
							 WHERE Id =: identifier];
				if (returnList.size()==0){
					res.statusCode = 404;
				}
			} Catch (Exception e) { res.statusCode = 500;	//Something bad happened... Should never get here!
															//An empty query response (zero records) returns statusCode 200!
			}												//recommended remidial action is try again!
			
		} else if (identifier.left(13) == 'case_comments'){
			system.debug('Searching for Case Comments by Case Id');		//Search for Case Comment give a Case Id
			String CaseId = req.requestURI.substringBeforeLast('/');	//Get the group from the URI, step 1
			CaseId = CaseId.substringAfterLast('/');					//step 2
			system.debug(CaseId);
			try {
				returnList = [SELECT ParentId, LastModifiedDate, LastModifiedById, IsPublished, CommentBody
							  FROM CaseComment
							  WHERE ParentId =: CaseId];
				if (returnList.size()==0){
					res.statusCode = 404;
				}
			} catch (Exception e) { res.statusCode = 500;	//Something bad happened... Should never get here!
															//An empty query response (zero records) returns statusCode 200!
			}												//recommended remidial action is try again!
			
		} else {	//fail! we did not get a User or a Case!
			res.statusCode = 400;
		}
		return returnList;
	}
	@HttpPost
	global static cases_return doPost(cases_submit caseRequest){
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		REST_API_utilities.resultCode rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		cases_return createdCase = new cases_return(rc,null);	//init cases_return class....
		Case insertCase = new Case();								//init sObject references...
		Case newCase = new Case();
		CaseComment newCaseComment = new CaseComment();			//CaseComments are NOT required!
		try {													//Case workflow sets severity and Owner...this could possibly be overwritten with an update DML action
			insertCase = caseRequest.case_details;					//deserialize the Case details
			newCaseComment = caseRequest.case_comment;			//deserialize the CaseComment...
			insert insertCase;										//and Away We GO!   insert the new case
			newCase = [SELECT Id, CaseNumber FROM Case WHERE Id =: insertCase.Id LIMIT 1];		    //read back for the case number (anything else?)
			system.debug('POST service created Case ID: ' + newCase.Id + '\r\n Case Number: ' + newCase.CaseNumber);
			if(newCaseComment != null){							//Make sure that we have a Case Comment before...
				newCaseComment.ParentId = newCase.Id;			//assigning the parent Case (e.g. The Comment is related to THIS Case)
				system.debug(newCaseComment);
				insert newCaseComment;							//Insert the Case Comment
				if(insertCase.status == 'Closed'){              //Adding Comments to a Closed Case re-opens it :(
				    newCase.Status = 'Closed';
				    update newCase;
				}
			}
			rc.success = true;									//Everything (maybe) worked... 
			rc.exceptionMessage = '';							//no Exception Message, everything is cool!
			createdCase.resultCode = rc;						//Attach the resultCode Class to the return payload
			createdCase.case_id = newCase.Id;					//Attach the Case Id to the return payload
			createdCase.case_number = newCase.CaseNumber;		//Attach the Case Number to the return payload
			return createdCase;									//return to service that called POST! Go get coffee!
		} catch (Exception e){								//Something went wrong...
			rc.success = false;								//Success == false
			rc.exceptionMessage = 'Exception Type: ' + e.getTypeName() + '  Message: ' + e.getMessage();	//Build a nice exception message
			createdCase.resultCode = rc;					//Attach the resultCode Class to the return payload
			createdCase.case_id = newCase.Id;				//we *might* have created a Case
			createdCase.case_number = newCase.CaseNumber;	//we *might* have a Case number
			return createdCase;								//return to service that called POST!
		}
		
	}
	//Inner Classes for input and output
	global class cases_return {						//Used as return object for a POST call
		//public resultCode resultCode;			//resultCode class...
		public REST_API_utilities.resultCode resultCode;			//resultCode class...
		public string case_id;	//record ID of created Case (if POST successful)
		public string case_number; //Case number of Created Case
		//Constructor for payload inner class
		public cases_return(REST_API_utilities.resultCode RC_code, string case_id){
			resultCode = RC_Code;
			case_id = null;
			case_number = null;
		}
	}
	global class cases_submit {
		public Case case_details;							//Case fields submitted in JSON
		public CaseComment case_comment;					//Case Comment (Body) max size == 4000 bytes
	}
}