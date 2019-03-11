@RestResource(urlMapping='/V1/services/*')
global with sharing class REST_services {
	@HttpGet
	//Responds to an HttpGet naturally... 
	//Given a ContractedServices ID, this Class returns the list of Services objects
	global static Contracted_Services__c[] doGet() {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		//declare return list
		List<Contracted_Services__c> Services = new List<Contracted_Services__c>();
		//variables for Services query
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		if (identifier.left(3) != 'a1H') { //a1M in ServCLoud, a1H in production!!! grr
			//We did not get a Services identifier
			res.statusCode = 400;		//Something bad happened... Should never get here!
										//recommended remidial action is try again!
		} else {
			Try {
				Services = [SELECT Id, Name, Item_Category__c, Bill_Description__c, 
							Asset__r.Id, Asset__r.Name, Contract__r.myKVH_Parent_Account__c  
							FROM Contracted_Services__c WHERE Id=:identifier];
				if (Services.size()==0){
					res.statusCode = 404;
				}
			} Catch (Exception e) {
			res.statusCode = 500;		//Something bad happened... Should never get here!
										//recommended remidial action is try again!
			}
		}
		
		return Services;
	}
}