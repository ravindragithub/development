@RestResource(urlMapping='/V2/services/*')
global with sharing class REST_services_V2 {
	//Responds to an HttpGet naturally... 
	//Given a ContractedServices ID, this Class returns the list of Services objects
	//OR Given an Asset Name/ID (serial number) returns a list of services provided, including PkgKinds
	@HttpGet
	global static SvcDetail[] doGet(){
		RestRequest req = RestContext.request;												//standard REST API stuff...
		RestResponse res = RestContext.response;
		SvcDetail util = new SvcDetail();													//instanciate the Class to get at the Methods...
		List<SvcDetail> Services = new List<SvcDetail>();									//declare return list
		List<Contracted_Services__c> ConServs = new List<Contracted_Services__c>();			//declare intermediate list
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);	//variables for Services query
		system.debug(identifier);															
		String nameSearch = req.params.get('name');											//Set the search param from URI (there might not be one...)
		//system.debug(nameSearch);															//nice to have
		if (identifier.left(6) == 'search'){												//Determine if the request is an AssetName search....
			system.debug('Execute an Asset Name Query against ' + nameSearch);
			Try {																			//wrap it up in a try catch 
				ConServs = new List<Contracted_Services__c>(								//query Contracted Services....
							[SELECT Id, Name, Item_Category__c, Bill_Description__c, 
							Asset__r.Id, Asset__r.Name, Asset__r.Account.Vessel_Email__c, Asset__r.Account.Name, Asset__r.Account.Vessel_IMO__c,
							Contract__r.myKVH_Parent_Account__c, Terminated_Date__c,
							Service_Item__c, Service_Item__r.IPMC_FS_Partner_Email__c, Service_Item__r.Name
							FROM Contracted_Services__c WHERE Asset__r.Name=:nameSearch]);
				if (ConServs.size()==0){													//Make sure we got something back...
					system.debug('No rows returned from Query... ' + nameSearch);
					res.statusCode = 404;													//If not return 404 error!
				}
			} Catch (Exception e) {	res.statusCode = 500; }									//Something bad happened... Should never get here!
																							//recommended remedial action is try again!
			Services = util.getWrappedResponse(ConServs);									//Wrap up that List of Contracted Services!
		} else if (identifier.left(3) != 'a1H'){											//No name search and We did not get a Contracted Services record ID!
			res.statusCode = 400;															//Something bad happened... (malformed URI) Should never get here!
																							//recommended remidial action is try again!
		} else {																			//OK not a name search, but we have a Contracted Services record ID!
			Try {																			//wrap it up in a try catch 
				ConServs = new List<Contracted_Services__c>(								//query Contracted Services....(There should be only 1!)
							[SELECT Id, Name, Item_Category__c, Bill_Description__c, 
							Asset__r.Id, Asset__r.Name, Asset__r.Account.Vessel_Email__c, Asset__r.Account.Name, Asset__r.Account.Vessel_IMO__c,
							Contract__r.myKVH_Parent_Account__c, Terminated_Date__c,
							Service_Item__c, Service_Item__r.IPMC_FS_Partner_Email__c, Service_Item__r.Name
							FROM Contracted_Services__c WHERE Id=:identifier]);
				if (ConServs.size()==0){													//Make sure we got something back...
					system.debug('No rows returned from Query... ' + nameSearch);
				res.statusCode = 404;														//If not return 404 error!
				}
			} Catch (Exception e) {	res.statusCode = 500; }									//Something bad happened... Should never get here!
																							//recommended remedial action is try again!
			Services = util.getWrappedResponse(ConServs);									//Wrap up that List of Contracted Services!
		}
		return Services;																	//return that list of SvcDetails
	}
	/* Inner Class for return Object */
	global Class SvcDetail{
		//Need a contracted service, a list of IPMC PkgKinds (just the names, for File Services)....
		//Partner E-mail (for File Services) and Vessel E-mail (for File Services)!
		public string Name {get;set;}														//Just nice to have a name
		public Contracted_Services__c Service {get;set;}									//Embed the Partner and Vessel details in here...
		public List<String> PkgKinds {get;set;}												//That list of PackageKinds
		//constructors
		public SvcDetail(){																	//no parameter constructor
			this.Name = 'Service Details';													//default name, nice to have
		}
		
		public SvcDetail(Contracted_Services__c Service, List<String> PkgKinds ){			//two parameter constructor
			this.Name = 'Service Details';													//default name, nice to have
			this.Service = Service;
			this.PkgKinds = PkgKinds;
		}
		
		public list<SvcDetail> getWrappedResponse(list<Contracted_Services__c> ConServs){		//Kind of a super-constructor helper method
			list<SvcDetail> returnList = new list<SvcDetail>();									//declare return list
			IPMC_Utilities util = new IPMC_Utilities();											//instanciate utility class
			list<Product2> IPMC_Bundles = new list<Product2>(util.getIPMC_bundles());			//get ALL the IPMC Bundles!
			map<Id, list<IPMC_Package_Kinds__c>> PKsByProduct = new map<Id, list<IPMC_Package_Kinds__c>>(util.getPKsByProduct(IPMC_Bundles));//and ALL the Product/PkgKind mappings
			for(Contracted_Services__c cs : ConServs){											//loop through the list of contracted services...
				if(PKsByProduct.get(cs.Service_Item__c) != null){								//if the service item has PkgKinds (e.g. an IPMC Service!)...
					list<string> PKStrings = new list<string>();								//prepare a list of strings...
					PKStrings = util.getPkgKindNames(PKsByProduct.get((Id)cs.Service_Item__c));	//and extract from the list of PkgKinds...watch those type conversions!...
					SvcDetail OneSvc = new SvcDetail(cs, PKStrings);							//construct a single instance of our wrapper class
					returnList.add(OneSvc);														//add our wrapped class to the return list!
				} else {																		//no Package Kinds! not an IPMC Service
					SvcDetail OneSvc = new SvcDetail(cs, null);									//construct a single instance of our wrapper class without a list of PkgKind names
					returnList.add(OneSvc);														//add our wrapped class to the return list!
				}
			}
			return returnList;																	//and return the list of the SvcDetail
		}																						//Super-constructor complete!
	}
	
}