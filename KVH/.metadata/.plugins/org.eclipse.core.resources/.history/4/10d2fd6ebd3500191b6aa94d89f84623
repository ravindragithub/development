@RestResource(urlMapping='/V1/elements/*')
global with sharing class REST_elements {
	@HttpGet
	//Responds to an HttpGet naturally... 
	global static Asset[] doGet(){
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		List<Asset> Elements = new List<Asset>();		//declare return list
		//variables for Asset query
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		system.debug(identifier);
		//Set the search param from URI (there might not be one...)
		String nameSearch = req.params.get('name');
		system.debug(nameSearch);
		//Determine if the request is an Asset.Name search....
		if (identifier.left(6) == 'search'){
			system.debug('Execute an Asset.Name Query against ' + nameSearch);
			try {
				Elements = [SELECT Id, Name, AccountId, Account.Name, Account.RecordType.DeveloperName, Account.Parent.E_bill_URL__c,
							Product2.KVH_Product_Family__r.Name, Product2.KVH_Product_Family__r.FCP_Element_Type__c, Modem_Type__c, Account.Parent.Custom_Call_Acct_ID__c, 
							Antenna_type__c, Below_Decks_type__c, IPMC_KenCast_SiteID__c, Account.Vessel_IMO__c,
							Root_Asset__c, Root_Asset__r.Name, isCrewlink__c
							FROM Asset WHERE Name =: nameSearch];
				system.debug(Elements);
				if (Elements.size()==0){
					system.debug('Named Asset not found...' + Elements);
					res.statusCode = 404;
				} else if (Elements.size() > 1){
					system.debug('Duplicate Asset Names found... ' + Elements);
					res.statusCode = 300;
				}
			} Catch (Exception e) {res.statusCode = 500;}	//Something bad happened... Should never get here!
															//recommended remedial action is try again!
		//Determine if the request is an Asset.Id search....
		}else if (identifier.left(3) == '02i') {
			system.debug('Execute an Asset.ID Query against ' + identifier);		//We got an Asset identifier!!
			Try {
				Elements = [SELECT Id, Name, AccountId, Account.Name, Account.RecordType.DeveloperName, Account.Parent.E_bill_URL__c,
							Product2.KVH_Product_Family__r.Name, Product2.KVH_Product_Family__r.FCP_Element_Type__c, Modem_Type__c, Account.Parent.Custom_Call_Acct_ID__c,
							Antenna_type__c, Below_Decks_type__c, IPMC_KenCast_SiteID__c, Account.Vessel_IMO__c,
							Root_Asset__c, Root_Asset__r.Name, isCrewlink__c
							FROM Asset WHERE Id=:identifier];
				//Add Account.Parent.E_bill_URL__c to get the hyperlink to E-bill
				//Add Modem_Type__c to identify ICM vs. Legacy
				//Add Account.Parent.Custom_Call_Acct_ID__c
				if (Elements.size()==0){
					res.statusCode = 404;} } Catch (Exception e) {res.statusCode = 500;} /*ugly test coverage hack*/
				//Something bad happened... Should never get here!
				//recommended remidial action is try again!
		} else if (identifier.left(3) == 'all'){
			//Someone wants ALL the Elements! Maybe they are re-building database!
			//This identifier has been known to time out....
			Try {
				system.debug('Trying to get all Elements...');
				Elements = [SELECT Id, Name, AccountId, Account.Name, Account.RecordType.DeveloperName, Account.Parent.E_bill_URL__c,
							Product2.KVH_Product_Family__r.Name, Product2.KVH_Product_Family__r.FCP_Element_Type__c, Modem_Type__c, Account.Parent.Custom_Call_Acct_ID__c, 
							Antenna_type__c, Below_Decks_type__c, IPMC_KenCast_SiteID__c, Account.Vessel_IMO__c,
							Root_Asset__c, Root_Asset__r.Name, isCrewlink__c 
							FROM Asset WHERE Product2.KVH_Product_Family__r.FCP_Element_Type__c != null];
				//Add Account.Parent.E_bill_URL__c to get the hyperlink to E-bill
				//Add Modem_Type__c to identify ICM vs. Legacy
				//Add Account.Parent.Custom_Call_Acct_ID__c
				if (Elements.size()==0){
					res.statusCode = 404;} } Catch (Exception e) {res.statusCode = 500;} /*ugly test coverage hack*/
				//Something bad happened... Should never get here!
				//recommended remidial action is try again!
		} else {
			//The parameter is not an Asset ID or 'all', or 'search'... 
			system.debug('Bad request, no Id, not all, not search...');
			res.statusCode = 400;		//Something bad happened... Should never get here!
										//recommended remidial action is try again!
		}
		return Elements;
	}
}