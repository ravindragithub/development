global with sharing class REST_API_utilities {
	
	global class resultCode { //This Class also exists in Transmission Service Callouts.... this should be made into a Global Class at some point.
		public Boolean success;
		public String exceptionMessage;
		//Constructors for resultCode inner class...
		//two parameter constructor
		public resultCode(Boolean b, String s) {
			success = b;
			exceptionMessage = s;
		}
		//no parameter constructor
		public resultCode(){
			Boolean success;
			String exceptionMessage;
		}
	}
	public Account getBillingAccount(Asset terminal){
		terminal = [SELECT Id, AccountID FROM Asset WHERE Id =: terminal.Id LIMIT 1];					//get additional details
		Boolean foundAcct = false;																		//use a flag
		list<Account> returnAcct = new list<Account>();													//setup return list<sObject>
		returnAcct = [SELECT Name, Custom_Call_Acct_ID__c, Account_Type__c, Account_Status__c, ParentId	//get Asset's Parent Account
						FROM Account WHERE Id =:terminal.AccountId];									//could be a platform, or default Acct... but only 1!!
		if(returnAcct.size()==0){
			foundAcct = true;																					//we are at the top, there's no billing acct!
			return null;
		} else if(returnAcct[0].Account_Type__c == 'Customer' && returnAcct[0].Custom_Call_Acct_ID__c != ''){	//Is the Asset's immediate Parent also it's Billing Acct?
			foundAcct = true;																					//Typically not, but it could be!
		}
		While (!foundAcct){																					//now we bubble up through Accounts
			returnAcct = [SELECT Name, Custom_Call_Acct_ID__c, Account_Type__c, Account_Status__c, ParentId //get Asset's Parent Account
							FROM Account WHERE Id =:returnAcct[0].ParentId ];								//(I hate this SOQL in a loop!)
			if(returnAcct.size()==0){
				foundAcct = true;																					//we are at the top, there's no billing acct!
				return null;
			} else if(returnAcct[0].Account_Type__c == 'Customer' && returnAcct[0].Custom_Call_Acct_ID__c != ''){	//Is this the billing Acct?
				foundAcct = true;																					//If so exit the loop and return!
			}
		}
		return returnAcct[0];
	}
	public Billing_Account__c getBillingAccountObject(Asset terminal){
        string ccID;
        list<SBQQ__Subscription__c> subs = new list<SBQQ__Subscription__c>();
        subs = [SELECT Id, Custom_Call_ID__c 
                FROM SBQQ__Subscription__c 
                WHERE Asset__c =: terminal.Id AND SBQQ__TerminatedDate__c = null
                LIMIT 1]; //get CCIDs associated
        if(subs.size()==0){
            ccID = null;
        }
        else {
        	SBQQ__Subscription__c sub = subs[0];
        	ccID = sub.Custom_Call_ID__c;
        }
		list<Billing_Account__c> returnbacct = new list<Billing_Account__c>();//setup return list<sObject>
		returnbacct = [SELECT Name, Billing_Account_ID__c, RecordTypeName__c, Billing_Cycle__c, Account__c, Main_Contact__c
						FROM Billing_Account__c WHERE Billing_Account_ID__c =: ccID];									
		if(returnbacct.size()==0){																					
			return null;
		}
		return returnbacct[0];
	}

}