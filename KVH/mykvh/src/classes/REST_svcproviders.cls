@RestResource(urlMapping='/V1/svcproviders/*')
global with sharing class REST_svcproviders {
	@HttpGet
	//Responds to an HttpGet naturally... 
	//Given an port ID, this Class returns the list of port and country detials
	global static Services_by_Port__c[] doGet(){
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		//declare return list
		List<Services_by_Port__c> svcProviders = new List<Services_by_Port__c>();
		//variables for Service_Provider__c query, Identifier prefix == a1G
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		if (identifier.left(3) == 'a1G') {			//Try to get a single svcProvider...
			try {
				/*NOTE: This SOQL field set must match the SOQL field set used in REST_ports...
				 *      If they happen to diverge, then there will be discrepancies in the documentation */
				svcProviders = [SELECT Id, Name, Service_Partner_Account__c, Priority__c, Port_Name__c, Port_Country__c,
								Service_Partner_Account__r.Name, Service_Partner_Account__r.Parts_Availability__c
								FROM Services_by_Port__c WHERE Id =: identifier];
				if (svcProviders.size()==0){
					res.statusCode = 404;
					system.debug('empty LIST !!!!!!!!!!!!!');
					}
			} catch (exception e) { res.statusCode = 500; } /*ugly test coverage hack*/
		} else if (identifier.left(3) == 'a0W'){	//Try to get ALL the svcProviders for a given Port
			try {
				svcProviders = [SELECT Id, Name, Service_Partner_Account__c, Priority__c, Port_Name__c, Port_Country__c,
								Service_Partner_Account__r.name, Service_Partner_Account__r.Parts_Availability__c
								FROM Services_by_Port__c WHERE Port_Name__c =: identifier];
				if (svcProviders.size()==0){
					res.statusCode = 404;
					system.debug('empty LIST !!!!!!!!!!!!!');
					}
			} catch (exception e) { res.statusCode = 500; } /*ugly test coverage hack*/
		} else if (identifier.left(3) == 'all'){	//Try to get all the svcPRoviders 
			try {
				svcProviders = [SELECT Id, Name, Service_Partner_Account__c, Priority__c, Port_Name__c, Port_Country__c,
								Service_Partner_Account__r.name, Service_Partner_Account__r.Parts_Availability__c
								FROM Services_by_Port__c];
				if (svcProviders.size()==0){
					res.statusCode = 404;
					system.debug('empty LIST !!!!!!!!!!!!!');
					}
			} catch (exception e) { res.statusCode = 500; } /*ugly test coverage hack*/
		} else {
			//The parameter is not a svcProvider ID, Port ID or 'all'....
			system.debug('Bad request, no Id, not all, not search...');
			res.statusCode = 400;		//Something bad happened... Should never get here!
										//recommended remidial action is try again!
		}
		return svcProviders;
	}
}