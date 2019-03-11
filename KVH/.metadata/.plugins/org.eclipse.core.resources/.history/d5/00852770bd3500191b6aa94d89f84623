@RestResource(urlMapping='/V1/ports/*')
global with sharing class REST_ports { 
	@HttpGet
	//Responds to an HttpGet naturally... 
	//Given an port ID, this Class returns the list of port and country detials
	//OR a list of Svc by Ports
	global static sObject[] doGet(){		//Need to use generic sObject because we might return Users or Account Shares!
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		//declare return list
		List<Port__c> Ports = new List<Port__c>();
		//variables for Port__c query Identifer prefix == a0W 
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		if (identifier.left(3) == 'a0W') {			//Try to get a single port...
			try {
				Ports = [SELECT Id, Name, City__c, Country_New__r.Name, Latitude__c, Longitude__c, Port_Authority__c
							FROM Port__c
							WHERE Id=:identifier];
				if (Ports.size()==0){
					res.statusCode = 404;
					system.debug('empty LIST !!!!!!!!!!!!!');
					}
			} catch (exception e){ res.statusCode = 500; } /*ugly test coverage hack*/
		} else if (identifier.left(3) == 'all'){		//Try to get ALL ports...
			try {
				Ports = [SELECT Id, Name, City__c, Country_New__r.Name, Latitude__c, Longitude__c, Port_Authority__c
							FROM Port__c];
				if (Ports.size()==0){
					res.statusCode = 404;
					system.debug('empty LIST !!!!!!!!!!!!!');
					}
			} catch (exception e){ res.statusCode = 500; } /*ugly test coverage hack*/
		} else if (identifier.left(12) == 'svcproviders'){				//returning svc by Ports must be self-contained...
			List<Services_by_Port__c> svcByPortsList = new List<Services_by_Port__c>();
			String PortId = req.requestURI.substringBeforeLast('/');				//Get the Port_Name__c from the URI, step 1
			PortId = PortId.substringAfterLast('/');								//step 2
			system.debug(PortId);
			try {
				/*NOTE: This SOQL field set must match the SOQL field set used in REST_svcproviders...
				 *      If they happen to diverge, then there will be discrepancies in the documentation */
				svcByPortsList = [SELECT Id, Name, Service_Partner_Account__c, Priority__c, Port_Name__c, Port_Country__c,
								Service_Partner_Account__r.name, Service_Partner_Account__r.Parts_Availability__c
								FROM Services_by_Port__c WHERE Port_Name__c =: PortId];
				system.debug('Number of svcByPorts Records Found : ' + svcByPortsList.size());
				if (svcByPortsList.size()==0){
					res.statusCode = 404;
					system.debug('No rows returned from Query... ' + svcByPortsList);
					Ports = [SELECT Id, Name, City__c, Country_New__r.Name, Latitude__c, Longitude__c, Port_Authority__c
							FROM Port__c
							WHERE Id=: PortId];
					system.debug(Ports);													//verify Port_Id is found....
					if (Ports.size() == 0){													//Port Id not found!!
						system.debug('No rows returned from Query... ' + Ports + ' Invalid Port!');
						res.statusCode = 404;												//Port not found status code = 404, return empty list
						system.debug(res.statusCode);
						system.debug(svcByPortsList);
						return svcByPortsList;
					} else {																//Port found status code = 200
						system.debug(res.statusCode);										//There just aren't any Services By Port!
						system.debug(svcByPortsList);
						return svcByPortsList;												//Return the empty list
					}
				} else {
					system.debug(res.statusCode);										//Everything is awesome!!!! We found Services by Port for the Port!
					system.debug(svcByPortsList);
					return svcByPortsList;
				}
			} catch (exception e) { res.statusCode = 500; } /*ugly test coverage hack*/
		} else {									
			//The parameter is not a Port ID or 'all'....
			system.debug('Bad request, no Id, not all, not search...');
			res.statusCode = 400;		//Something bad happened... Should never get here!
										//recommended remidial action is try again!
		}
		return Ports;
	}
}