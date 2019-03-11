@RestResource(urlMapping='/V1/rateplans/*')
global with sharing class REST_rateplans {
	@HttpGet
	//Responds to an HttpGet naturally... 
	//Given an User ID, or an E-mail search parameter
	//this Class returns a list of Users, Typically one and only one!
	global static sObject[] doGet(){		//Use generic Object...
		string queryString = 'SELECT Id, Name, Monthly_Data_Allowance__c, Allowance_Units__c, Overage_Alert_Default__c, Overage_Alert_Units__c, ';
		queryString += 'Standard_Speed_V3_Down_Up__c, Standard_Speed_V7_Down_Up__c, Standard_Speed_V11_Down_Up__c, Throttle_Speed__c, Plan_Type__c, ';
		queryString += 'V3_Target_CDC__c, V7_Target_CDC__c, V11_Target_CDC__c, Overage_Charge__c, Overage_Unit__c ';
		queryString += 'FROM Rate_Plan__c';
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		List<Rate_Plan__c> plans = new List<Rate_Plan__c>();								//declare return list...
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);	//Get the identifier from the URI...
		system.debug(identifier);
		if (identifier.left(3) == 'a3i'){													//Production a3i..
			try {
				string whereClause = ' WHERE id = \'' + identifier +'\'';					//escape single quotes....
				system.debug(queryString + whereClause);
				plans = Database.query(queryString + whereClause);
				if (plans.size() == 0){														//Rate Plan not found!
					system.debug('No rows returned from Query... ' + plans);
					res.statusCode = 404;													//return 404 and empty list
				} else if (plans.size() > 1){												//duplicates found! (highly unlikely!)
					system.debug('Duplicate Rate Plans found... ' + plans);
					res.statusCode = 300;													//return 300 and list of users
				}
			} catch(exception e){ res.statusCode = 500; }								//Something bad happened... Should never get here!
																						//recommended remedial action is try again!

		} else if (identifier.left(3) == 'all'){	//provide for mass refresh.... (how many could there possibly be ?!?!?)
			try {
				plans = Database.query(queryString);
				if (plans.size() == 0){														//Rate Plan not found!
					system.debug('No rows returned from Query... ' + plans);
					res.statusCode = 404;													//return 404 and empty list
				}
			} catch(exception e){ res.statusCode = 500; }								//Something bad happened... Should never get here!
																						//recommended remedial action is try again!
		}
		system.debug(res.statusCode);
		system.debug(plans);
		return plans;
	}
}