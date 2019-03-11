public with sharing class IPMC_Service_Mapping_Controller { 
	/* State machine details
		1) find asset to make service adjustments to (passed as Parameter...)
			1a) Asset analysis to manage product eligibility
		2) find all existing services (contracted services)
		3) list all eligible services (probably query products with IPMC PkgKinds probably)
		4) track changes made by agent
		5) verify results with agent
		6) record change set (history??)
		7) make Callouts to TS to adjust pkgKind Mapping
		8) record results Code
	*/
	/*Controller Properties*/
	/*private ApexPages.Standardcontroller stdCtrl;
	public IPMC_Service_Mapping_Controller(ApexPages.standardController std){
		stdCtrl = std;
	}*/

	public Boolean isActive {get; set;}			//Flag for Receive Site has KenCast License
	public Boolean MappingEnabled {get; set;}	//Controls visibility of "Activate and Map" button
	public String SRVRId {get; set;}			//SF Record ID of Asset to activate from URL params
	public String SystemId {get; set;}			//SF REcord ID of system level Asset from URL params
	public String searchCCId {get; set;}		//Custom Call Acct ID from URL Params or user input override
	public String AcctSearchStatus {get; set;}	//Status string for Acct search results
	public Integer SRVRCount {get; set;}		//Count of CBXs or MSs
	public Integer ANTCount {get; set;}			//Count of Antennas...
	
	public String TSActivationResults {get;set;}			//String representation of TransmissionServices ResultsCode from Activate/Deactivate call
	public String getTSActivationResults() { return TSActivationResults; }
	public void setTSActivationResults(String result) { TSActivationResults = result; }
	
	public String TSMappingResults {get;set;}			//String representation of TransmissionServices ResultsCode from Mapping call
	public String getTSMappingResults() { return TSMappingResults; }
	public void setTSMappingResults(String result) { TSMappingResults = result; }
	
	string activateResponse; 
	public string getactivateResponse() {return activateResponse;}	//might want to requery the Asset for status....
	public void setactivateResponse(string s) {activateResponse = s;}

	KenCast_License__c KLC = new KenCast_License__c();
	public KenCast_License__c getKLC() {return KLC;}
	public void setKLC(KenCast_License__c k) {KLC = k;}

	public List<IPMC_Utilities.EligibleProducts> ValidChoices = new List<IPMC_Utilities.EligibleProducts>();	//Processed menu of service productsjavascript:void(0);
	public List<IPMC_Utilities.EligibleProducts> getValidChoices() {
		return ValidChoices;
	}
	
	public List<Contracted_Services__c> CurrentServices = new List<Contracted_Services__c>();	//Contracted Services associated to Receive Site
	public List<Contracted_Services__c> getCurrentServices(){
		return CurrentServices;
	}
	public void setCurrentServices(Asset RecieveSite){					//probably all IPMC services, but
		CurrentServices = ContractUTIL.ServicesByAssets(ReceiveSite);	//There could be non-IPMC services here...
		system.debug(CurrentServices);
		for (integer i=0; i < CurrentServices.size(); i++){
			system.debug('Current Service: '+ CurrentServices[i].Name + CurrentServices[i].Terminated_Date__c);
			if (CurrentServices[i].Terminated_Date__c != null) {
				CurrentServices.remove(i);
			}
		}
		If (CurrentServices.size()>0){									//This is a little risky... many contracts against a single Asset....
			ExistingContract = [SELECT id, Name, AccountId FROM Contract WHERE ID =:CurrentServices[0].contract__c];
		}
		system.debug('Existing Contract: ' + ExistingContract);
	}


	public List<Account> BillingAcct = new List<Account>();		//Default Billing Account to associate contract to
	public List<Account> getBillingAcct() {
		return BillingAcct;
	}
	private void setBillingAcct(String CCId) {
		If (CCId == '') {
			AcctSearchStatus = 'Enter the Custom Call Account number to be billed for service...';
		} else {
			BillingAcct= [SELECT Id, Name, Custom_Call_Acct_ID__c, RecordType.Name FROM Account WHERE Custom_Call_Acct_ID__c =: CCId LIMIT 10];
			If (BillingAcct.size() == 0) {
				AcctSearchStatus = 'Custom Call Account Number not found...';
			} else if (BillingAcct.size() > 1) {
				AcctSearchStatus = 'Found ' + String.valueOf(BillingAcct.size() - 1) + ' Duplicate Custom Call Account Numbers!!!!';
			} else {
				AcctSearchStatus = 'Found 1 matching Custom Call Account Number';
			}
		}
	}
	public Asset ReceiveSite = new Asset();
	public Asset getReceiveSite() {
		return ReceiveSite;
	}
	public void setReceiveSite (String s) {	//string representation of the Receive Site (Asset Id)
		ReceiveSite = [SELECT Id, Name, Product2Id, Product2.ProductCode, Item_Description__c, Product2.Airtime_Group__c,
							IPMC_License_Issued_by__c, IPMC_License_Issued__c, IPMC_KenCast_SiteID__c, AccountId, 
							Parent_Asset__c, Parent_Asset__r.Product2.ProductCode, Parent_Asset__r.Product2.Airtime_Group__c
						FROM Asset WHERE ID =: s];
		if (String.isEmpty(ReceiveSite.IPMC_KenCast_SiteID__c)) { //ReceiveSite.IPMC_KenCast_SiteID__c == ''
				setactivateResponse('This '+ReceiveSite.Product2.ProductCode+' is currently not activated for IPMC Services....');
				isActive = false;
				MappingEnabled = false;
				//SiteMapPkgKindsInhibited = true;
			} else {
				setactivateResponse('This '+ReceiveSite.Product2.ProductCode+' was activated on '+
											ReceiveSite.IPMC_License_Issued__c+' for IPMC Services by '+
											getUserName(ReceiveSite.IPMC_License_Issued_by__c));
				isActive = true;
				MappingEnabled= true;
				//SiteMapPkgKindsInhibited = false;
			}
	}
	
	public List<AssetStructureEngine.AssetStructureMap> Hierarchy = new List<AssetStructureEngine.AssetStructureMap>();
	public AssetStructureEngine.AssetStructureMap[] getHierarchy(){return Hierarchy;}
	private void setHierarchy(string s){ //s = record ID of topmost element in Asset Hierarchy
		Hierarchy = AssetStructureEngine.getAssetStructure(s);
	}


	/*Controller Variables */

	public Contract existingContract = new Contract();
	private String SingleAntenna;	//If there is only one installed antenna, this is they type
	private String SingleServer;	//This is the default Asset to Activate
	public map<Id, Id> ContractMap = new Map<Id, Id>();				//This is a map of PRoducts to Contracts based on Contracted Services
	private Map<Id, String> IPMCProducts;		// These are all the IPMC related Products in the database
	public Map<String, Integer> InstalledAntennaTypes = new Map<String, Integer>();	//This is a count of the installed IPMC related Assets by antenna type
	public Map<String, Integer> InstalledServerTypes = new Map<String, Integer>();	//This is a count of the intalled IPMC server types by server type
	public List<IPMC_Utilities.EligibleProducts> OriginalSubscriptions = new List<IPMC_Utilities.EligibleProducts>();
	
	/* Supporting Classes */
	public IPMC_Utilities UTIL = new IPMC_Utilities();
	public ContractUtilities ContractUTIL = new ContractUtilities();
	
	/* Controller Methods */
	public PageReference autoRun(){
		//Use static final variables from the Utility Class....
    	IPMCProducts = IPMC_Utilities.IPMCHardwareMap;	//get a map of all IPMC related products...
    	system.debug('local Map ' + IPMCproducts); 
    	//initialize the Installed Antenna Types count map to zeros...
    	for (String s : IPMC_Utilities.IPMCantennaSet) {
            InstalledAntennaTypes.put(s,0);
        }
        system.debug(InstalledAntennaTypes);
        //initialize the Installed Antenna Types count map to zeros...
        for (String s : IPMC_Utilities.IPMCserverSet) {
            InstalledServerTypes.put(s,0);
        }
        system.debug(InstalledServerTypes);
        //set the Asset and System Ids...
		searchCCId = System.currentPageReference().getParameters().get('ACCT');	//pluck the Custom Call ID from the URL
		setBillingAcct(searchCCId);												//make it available
		SRVRId = System.currentPageReference().getParameters().get('SRVR');		//pluck the selected Server from the URL
		setReceiveSite(SRVRId);													//and set it as the server to act upon
		SystemId = System.currentPageReference().getParameters().get('SYSTEM');	//pluck the System level Asset ID from the URL
		setHierarchy(SystemId);													//and query the hierarchy (so we can search for an antenna...)
		//IPMCProducts = buildIPMCProducts();			//build a map of all IPMC related assets
		countIPMCProducts();													//count the IPMC critical Assets...
		for (string s : InstalledAntennaTypes.keyset()){	//Figure out our one antenna type
				if (InstalledAntennaTypes.get(s) == 1) {
					SingleAntenna = s;
					system.debug(SingleAntenna);	//should be 'V3', 'V7', or 'V11'...
				}
			}
			
		SingleServer = ReceiveSite.Product2.Airtime_Group__c;
		if(ReceiveSite.Parent_Asset__r.Product2.ProductCode == '02-2104'){ //It's a SuperYacht!
			SingleServer = 'SY';
		}
		system.debug(SingleServer);
		setCurrentServices(ReceiveSite); 	//AND existing Contract!
		ListEligibleProducts();
		return null;
	}

	public PageReference AcctSearch() {
		AcctSearchStatus = 'Searching...';
		setBillingAcct(searchCCId);
		return null;
	}
	public PageReference MapService() {	//Debug only for now.... soon to be create contracted service and map....
		//Need to start with a list of selected products, leading to a set of PkgKinds....
		List<Product2> SelectedServices = new List<Product2>();	//originally sObject Product2
		Set<String> PkgKindsToMap = new Set<String>();
		
		//Map<Product2, Asset> SVCMapping = new Map<Product2, Asset>();	//Change to Map<IPMC_Utilities.EligibleProducts, Asset>....
		Map<IPMC_Utilities.EligibleProducts, Asset> SVCMapping = new Map<IPMC_Utilities.EligibleProducts, Asset>();	//Change to Map<IPMC_Utilities.EligibleProducts, Asset>....
		
		for (IPMC_Utilities.EligibleProducts ep : ValidChoices) {	//debug only....
			system.debug('Selected:' + ep.Selected +' Name: '+ ep.IPMCPkg.Name + ' Compatible:'+ep.SystemCompatible+' Status:'+ep.AntennaStatus+' Is 31 Day Trial: '+ep.is31DayTrial);	//
			if (ep.Selected) {
				SelectedServices.add(ep.IPMCPkg);	//We will use this list to get the PkgKinds and create the contracted Services...
				
				//SVCMapping.put(ep.IPMCPkg, ReceiveSite);	//Change to Map<IPMC_Utilities.EligibleProducts, Asset>....
				SVCMapping.put(ep, ReceiveSite);	//Change to Map<IPMC_Utilities.EligibleProducts, Asset>....
			}
		}
		system.debug(SelectedServices);
		For (Package_Kinds_by_Product__c PKbyP : [SELECT Package_Kind__c FROM Package_Kinds_by_Product__c WHERE Product__c IN :SelectedServices]) {
			PkgKindsToMap.add(PKbyP.Package_Kind__c);	//Use a set to de-duplicate, and convert to List for Callout purposes....
		}
		system.debug(PkgKindsToMap);

		//And then add the contracted Services  10/2/14 might need to change SVCMapping to <EligibleProduct, Asset>....
		AdjustContractedServices(existingContract, SVCMapping);		//Change to Map<IPMC_Utilities.EligibleProducts, Asset>....
		MappingEnabled = false;				//disable mapping without reload....
		return null;
	}
	
	public Contract CreateNewIPMCContract (Account acct) {
		Contract Kontrakt = new Contract();
		Kontrakt.AccountId = acct.Id;
		//Kontrakt.RecordTypeId = RT.Id;
		Kontrakt.RecordTypeId = ContractUTIL.IPMC_CONTRACT_RECORD_TYPE_ID;
		Kontrakt.StartDate = date.today();
		Kontrakt.ContractTerm = 12;
		insert Kontrakt;
		system.debug(Kontrakt);
		return Kontrakt;
	}
	
	public List<IPMC_Utilities.EligibleProducts> flagCurrentSubscriptions(List<IPMC_Utilities.EligibleProducts> IPMC_list) {
		Id ContractId;		//Might need to hold a Contract ID for a minute...
		for (Contracted_Services__c cs : CurrentServices) {
			if (cs.Terminated_Date__c == null) {
				ContractMap.put(cs.Service_Item__c, cs.Contract__c); //This is the service and governing contract
			}
		}
		for (IPMC_Utilities.EligibleProducts ep : IPMC_list) {	//Loop through all the IPMC products
			if (ContractMap.containsKey(ep.IPMCPkg.Id)){		//and identify the ones already contracted....
				ep.Selected = true;
				ContractId = (ContractMap.get(ep.IPMCPkg.Id));
				system.debug(ContractId);
			}
			system.debug(ep.Selected +':'+ ep.IPMCPkg.Name + ':'+ep.SystemCompatible+':'+ep.AntennaStatus);
		}
		return IPMC_List;
	}
	
	public void AdjustContractedServices (Contract k, Map<IPMC_Utilities.EligibleProducts, Asset> SVCMapping) {	//Change to Map<IPMC_Utilities.EligibleProducts, Asset>....
		system.debug(SVCMapping);
		
		map<IPMC_Utilities.EligibleProducts, Asset> SVCsToCreate = new map<IPMC_Utilities.EligibleProducts, Asset>();
		map<IPMC_Utilities.EligibleProducts, Asset> SVCsToTerminate = new map<IPMC_Utilities.EligibleProducts, Asset>();
		
		Set<IPMC_Utilities.EligibleProducts> IPMCProducts = new Set<IPMC_Utilities.EligibleProducts>();		
		IPMCProducts.addAll(UTIL.getIPMCProducts());			//These are all the IPMC services
		
		Set<IPMC_Utilities.EligibleProducts> CurrentSVCs = new Set<IPMC_Utilities.EligibleProducts>();	//Set to hold Current Services
		Set<Product2> CurrentProds = new Set<Product2>();												//Set to hold current products....
		
		//Compare original vs current....
		OriginalSubscriptions = UTIL.getIPMCProducts();								//initialize the list of IPMC Products (Eligible Products)
		OriginalSubscriptions = flagCurrentSubscriptions(OriginalSubscriptions); 	//flag the current subscriptions
		for (IPMC_Utilities.EligibleProducts ep : OriginalSubscriptions) {			//Now loop through the list...
			if (ep.Selected) {														//Find the Current Subscriptions....
				CurrentSVCs.add(ep);												//Add the currently subscibed product to the list...
				CurrentProds.add(ep.IPMCPkg);										//Add the Product to the other list....
			}
		}
		system.debug(CurrentProds);		//List of Product2s
		
		//change SelectedSVCs from Set<IPMC_Utilities.EligibleProducts> to Map<Product2, IPMC_Utilities.EligibleProducts> jthom 3/6/15
		Map<Product2, IPMC_Utilities.EligibleProducts> SelectedSVCs = new Map<Product2, IPMC_Utilities.EligibleProducts>();
		
		Set<Product2> SelectedProds = new Set<Product2>();							//create a set of selected services and Products.....
		for (IPMC_Utilities.EligibleProducts ep : SVCMapping.keySet()) {			//loop through the IPMC products from the page..
			if (ep.Selected){														//If it's selected on the page...
				SelectedSVCs.put(ep.IPMCpkg, ep);									//Add it to the Map of selected services
				SelectedProds.add(ep.IPMCpkg);										//and the list of selelcted products....
			}
		}
		system.debug(SelectedProds);	//Another list of Product2
		
		system.debug(CurrentSVCs.size() + ' current subscriptions');	//These are the current subscriptions
		system.debug(SelectedSVCs + 'services checked');				//These are the services checked.... includes 37 day flag
		system.debug(IPMCProducts.size() + ' total....');				//total....
		system.debug(ContractMap);
		
		//This doesn't work if all Services are unselected since SelectedSVC.size() = 0.....
		
		for (IPMC_Utilities.EligibleProducts p : IPMCProducts) {		//must loop through ALL IPMC Products....
			//OK four conditions.... 
			if (!CurrentProds.contains(p.IPMCPkg) && !SelectedProds.contains(p.IPMCPkg)) {
			// no changes & not subscribed (not selected and not in current subscriptions) 
				system.debug(p.IPMCPkg.Name);
				system.debug('-------------------> no change, not subscribed & not selected');
			} else if (CurrentProds.contains(p.IPMCPkg) && SelectedProds.contains(p.IPMCPkg)){
			// no changes & subscribed (selected and in Current Subscriptions)
				system.debug(p.IPMCPkg.Name);
                system.debug('-------------------> no change, subscribed & selected');
				SVCsToCreate.put(p, ReceiveSite);
				//add to mapping (re-mapping technically...)
			} else if (CurrentProds.contains(p.IPMCPkg) && !SelectedProds.contains(p.IPMCPkg)){
			// Terminate a service (not selected, but in current subscriptions)
				system.debug(p.IPMCPkg.Name);
				system.debug('-------------------> terminate service, subscribed & not selected');
				SVCsToTerminate.put(p, ReceiveSite);
				//do not add to mapping, and terminate corresponding service
			} else if (!CurrentProds.contains(p.IPMCPkg) && SelectedProds.contains(p.IPMCPkg)){
			// Add a service (Selected and not in current subscription)
				system.debug(p.IPMCPkg.Name);
				system.debug('-------------------> Add new service, not subscribed & selected');
				SVCsToCreate.put(SelectedSVCs.get(p.IPMCpkg), ReceiveSite);							//takes 37 day trial into consideration
				//add to mapping, and create new Contracted Service
			}
		}
		//Make the callout first! then update the database to avoid the uncommited work error...
        TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();
        system.debug('SvcsToCreate : ' + SVCsToCreate.keyset());
        List<Product2> SVCsToMap = new List<Product2>();
		for (IPMC_Utilities.EligibleProducts ep : SVCsToCreate.keyset()){
        	SVCsToMap.add(ep.IPMCPkg);
        	system.debug(ep.IPMCPkg);
        }
        //SVCsToMap.addAll(SelectedSVCs);
        TSC.resultCode = MapProductsToAsset(ReceiveSite, SVCsToMap);
        setTSMappingResults('Callout success: '+TSC.resultCode.success+' Response message: '+TSC.resultCode.exceptionMessage);
        if (TSC.resultCode.success){
        	system.debug(k);
        	//terminate Contracted Services....
        	system.debug('Termination: ' + SVCsToTerminate);
        	TerminateContractedServices(k, SVCsToTerminate);
        	//Create Contracted Services....
        	system.debug('Creation: ' + SVCsToCreate);
        	CreateContractedServices(k, SVCsToCreate);
        } else {
        	system.debug('TSC callout failed...');
        }
	}
	
	
	public void TerminateContractedServices (Contract k, Map<IPMC_Utilities.EligibleProducts, Asset> SVCUnMapping) {
        List<Contracted_Services__c> csToTerminate = new List<Contracted_Services__c>();
        Set<IPMC_Utilities.EligibleProducts> ServiceItems = new Set<IPMC_Utilities.EligibleProducts>(SVCUnMapping.keySet());
		system.debug('Service Items successfully de-provisioned : '+ ServiceItems);
        system.debug('From Contract: ' + k);
        //need a list of Product2 from Eligible Products for SOQL
        Set<Product2> SvcsToTerminate = new Set<Product2>();
        for (IPMC_Utilities.EligibleProducts ep : ServiceItems){
        	SvcsToTerminate.add(ep.IPMCPkg);
        }
        csToTerminate = [SELECT id, Terminated_Date__c, Service_Item__c, Contract__c FROM Contracted_Services__c 
				         WHERE Service_Item__c IN :SvcsToTerminate AND Contract__c =: k.Id AND Terminated_Date__c = null];
				         
        for (Contracted_Services__c cs2kill : csToTerminate){
            system.debug(cs2kill);
        	cs2kill.Terminated_Date__c = date.today();
        }
        system.debug('Service Items to Terminate: '+ csToTerminate);
        update csToTerminate;
	}
	
    public void CreateContractedServices (Contract k, Map<IPMC_Utilities.EligibleProducts, Asset> SVCMapping) {	//Change to Map<IPMC_Utilities.EligibleProducts, Asset>....
    	system.debug(SVCMapping);
        List<Contracted_Services__c> csToCreate = new List<Contracted_Services__c>();
        Set<IPMC_Utilities.EligibleProducts> ServiceItems = new Set<IPMC_Utilities.EligibleProducts>(SVCMapping.keySet());				//Change to Map<IPMC_Utilities.EligibleProducts, Asset>....
        system.debug('Service Items successfully Provisioned : '+ ServiceItems);
        system.debug(k);
        Set<Id> ExistingServices = new Set<Id>();									//Create a set of the Existing Service Item Ids subscribed to
        for (Contracted_Services__c svcs : [SELECT Id, Name, Service_Item__c 		//Loop through all of the services attached to the contract
        									FROM Contracted_Services__c 
        									WHERE Contract__c =: k.Id AND Terminated_Date__c = null]){
        	ExistingServices.add(svcs.Service_Item__c);								//Adding the Products as we go
        }
        
        for (IPMC_Utilities.EligibleProducts p : ServiceItems) {
        	system.debug(p);
        	if (ExistingServices.contains(p.IPMCPkg.Id) == false){					//If a service already exists....SKIP IT!
        		Contracted_Services__c csNew = new Contracted_Services__c();
            	csNew.Contract__c =  k.Id;
            	csNew.Service_Item__c = p.IPMCPkg.Id;
            	csNew.Effective_Date__c = date.today();
            	csNew.Name = p.IPMCPkg.Name;
            	csNew.Asset__c = ReceiveSite.Id;
            	if (p.is31DayTrial){
            		csNew.Service_End_Date__c = Date.today() + 60;					//Changed to 37 days see case 233663//Changed to 60 days see case 406413
            	}
            	csToCreate.add(csNew);
        	}
        }
        system.debug(csToCreate);
        insert csToCreate;
    }


	
	public string findAssetResponse {get; set;}
	
	public void findAsset() {	//return an Asset??
		Asset a = new Asset();
		List<Asset> toActivate = new List<Asset>();
		toActivate = [SELECT id, Name, Product2.ProductCode, IPMC_KenCast_SiteID__c,
								IPMC_License_Issued_by__c, IPMC_License_Issued__c
						FROM Asset WHERE Id=:KLC.Issued_to_Asset__c];
		if (toActivate.size()==0){
			findAssetResponse = 'Cannot find Asset....';
		} else if (toActivate.size()==1){
			if (toActivate[0].IPMC_KenCast_SiteID__c == null) {
				findAssetResponse = 'This '+toActivate[0].Product2.ProductCode+' has never been activated for IPMC Services....';
				a = toActivate[0];
			} else {
				findAssetResponse = 'This '+toActivate[0].Product2.ProductCode+' was activated on '+
											toActivate[0].IPMC_License_Issued__c+' for IPMC Services by '+
											toActivate[0].IPMC_License_Issued_by__c;
				a = toActivate[0];
			}
		} else if (toActivate.size()>1){	//Should NEVER get here!
			findAssetResponse = 'Multiple Assets with the same ID found!!!';
		} else {							//Should NEVER get here!
			findAssetResponse = 'Something weird just happened!';
		}
	}
	
	public String getUserName(Id UserId) {
		String UserName = 'Unknown';
		List<User> FoundUser = new List<User>();
		FoundUser = [SELECT Name FROM User WHERE Id =: UserId];
		if (FoundUser.size() == 1) {		//If we get one and only One User back....
			UserName = FoundUser[0].Name;	//return that User name
		}
		return UserName;
	}
	
    /*private Map<Id, String> buildIPMCProducts(){	//Builds a map for Product IDs to AirtimeGroups and initialized intalled antenna and server types
    	Set<String> antSet = new Set<String>();
    	Map<String, Integer> ants = new Map<String, Integer>();
    	Set<String> srvrsSet = new Set<String>();
        Map<String, Integer> srvrs = new Map<String, Integer>();
        Map<Id, String> prods = new Map<Id,String>();
        for (Product2 p : [SELECT Id, Airtime_Group__c, ProductCode FROM Product2
				            WHERE (Airtime_Group__c IN ('V3', 'V7', 'V11') AND ProductCode Like '02-%')	//Antenna Subassys w/Airtime Groups 
				            OR (Airtime_Group__c IN ('CBX', 'MS'))]) {							//OR CBX License (and maybe MediaServer Licenses!)
			system.debug(p);
        	if (p.Airtime_Group__c == 'V3' || p.Airtime_Group__c == 'V7' || p.Airtime_Group__c == 'V11') {
				prods.put(p.Id, p.Airtime_Group__c); //add Product2ID and AirtimeGroup to the Map
				antSet.add(p.Airtime_Group__c);      //add unique Airtime Groups (antenna Types) to set
            } else if (p.Airtime_Group__c == 'CBX' || p.Airtime_Group__c == 'MS')  {
				system.debug('p = '+p);
				prods.put(p.Id, p.Airtime_Group__c);
				srvrsSet.add(p.Airtime_Group__c);
            }
		}
		for (String s : antSet) {    //initialize the Map to zeros...
            ants.put(s, 0);
            InstalledAntennaTypes.put(s,0);
        }
        for (String s : srvrsSet) {    //initialize the Map to zeros...
            InstalledServerTypes.put(s, 0);
        }
		return prods;
    }*/
    
	private void countIPMCProducts() {
        /* Counts the IPMC critical Asset Types
         * Assumes that Map InstalledAntennaTypes is initialized,
         * and Hierarchy and IPMCProducts is populated */
        String AirtimeGroup;
        ANTCount = 0;
        SRVRCount = 0;
        for (AssetStructureEngine.AssetStructureMap asm : Hierarchy) {//Count the Antenna Types, and the CBX Licenses
            system.debug(asm);
            if (IPMCProducts.containsKey(asm.Asset.Product2Id)) {//is this hierarchy node an IPMC Asset (key in map)?
                system.debug(asm.Asset);
                AirtimeGroup = IPMCProducts.get(asm.Asset.Product2Id); //Yes? get corresponding value for key... Which one?
                system.debug(AirtimeGroup);
                
                if (InstalledAntennaTypes.containsKey(AirtimeGroup)) {
                	InstalledAntennaTypes.put(AirtimeGroup,InstalledAntennaTypes.get(AirtimeGroup)+1);	//increment....
                	ANTCount = ANTCount + 1;
                } else if (InstalledServerTypes.containsKey(AirtimeGroup)) {
                	InstalledServerTypes.put(AirtimeGroup,InstalledServerTypes.get(AirtimeGroup)+1);	//increment....
                	//SRVRCount = SRVRCount + 1;
                	//SRVRList.add(asm.Asset);
                	//setServerToActivate(asm.Asset.Id);
                }
                system.debug(InstalledAntennaTypes);
                system.debug(InstalledServerTypes);
            }
        }
    }
    private void ListEligibleProducts() {	//add params String SRVRGroup, String ANTGroup
    	List<Product2> IPMCProducts = new List<Product2>();
		IPMCProducts = UTIL.getIPMC_bundles();
		Set<String> AirtimeGroups = new Set<String>();	//We need to Convert the Airtime Group field into a Set...
		for (Product2 p : IPMCProducts) {		//get all the Airtime Groups from All the IPMC products into a set.
			AirtimeGroups.clear();
			if (p.Airtime_Group__c != null) {	// Make sure that the IPMC Package HAS Airtime Groups...
				AirtimeGroups.addAll(p.Airtime_Group__c.split(','));	//Split into List<String> and convert to Set<String>
				if (AirtimeGroups.contains(SingleAntenna) && AirtimeGroups.contains(SingleServer)) {
					ValidChoices.add(new IPMC_Utilities.EligibleProducts(false, p, true, 'System Compatible!', '', false));
				} else {
					ValidChoices.add(new IPMC_Utilities.EligibleProducts(false, p, false, 'System *NOT* Compatible!', '', false));
				}
			}
		}
		//get a list of all the Services currently being delivered to the Asset 
		system.debug('Currently subscribed to: '+CurrentServices);
		//Convert the List to a Map of Product Ids, and Contract Ids;
		//map<Id, Id> ContractMap = new Map<Id, Id>();
		Id ContractId;		//Might need to hold a Contract ID for a minute...
		ValidChoices = flagCurrentSubscriptions(ValidChoices); 
		system.debug(existingContract);
    }
	/* SiteActivate STARTS here */
	public PageReference SiteActivate() {
		//instanciate a new TSCallout class includes "resultCode"
		TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();
		//moving KenCast License Mgmt INTO TransmissionServiceCallouts because it results in an "uncommited" error
		KenCast_License__c kl = new KenCast_License__c();
		kl = TSC.getLicense();
		//Need to check activation status of Asset (and maybe proceed anyway....)
		TSC.resultCode = TSC.SiteActivate(ReceiveSite.Name, kl.Site_ID__c.intValue(), kl.License_File__c);
		system.debug(TSC.resultCode);
		setTSActivationResults('Callout success: '+TSC.resultCode.success+' Response message: '+TSC.resultCode.exceptionMessage);
		setReceiveSite(String.valueOf(ReceiveSite.Id)); //?
		//Create a new Contract (Unless there is an existing one...)
		if (existingContract.Id == null) {
			existingContract = CreateNewIPMCContract(billingAcct[0]);
		}
		system.debug(existingContract);
		return null;
	}	/*SiteActivate ENDS here */
	
	/* SiteDeactivate STARTS here */
	public PageReference SiteDeactivate() {
		//Need to start with an Asset to be Deactivated...
		Asset toDeactivate = new Asset();
		toDeactivate = [SELECT Id, Name FROM Asset WHERE Id =:ReceiveSite.Id];
		system.debug(toDeactivate);
		//instanciate a new TSCallout class includes "resultCode"
		TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();
		TransmissionServiceCallouts.resultCode rc = new TransmissionServiceCallouts.resultCode(null, null);
		rc = TSC.SiteDeactivate(toDeactivate.Name);	//Asset.Name == SW serial number...
		setTSActivationResults('Callout success: '+rc.success+' Response message: '+rc.exceptionMessage);
		isActive = false;
		//need to terminate all IPMC services to the receive site....
		map<IPMC_Utilities.EligibleProducts, Asset> SVCsToTerminate = new map<IPMC_Utilities.EligibleProducts, Asset>();
		setCurrentServices(ReceiveSite);
		OriginalSubscriptions = UTIL.getIPMCProducts();		//initialize the list
		for (IPMC_Utilities.EligibleProducts ep : OriginalSubscriptions) {
			system.debug('Selected: ' + ep.Selected + ' Service: ' + ep.IPMCPkg.Name);
		}
		OriginalSubscriptions = flagCurrentSubscriptions(OriginalSubscriptions); //flag the current subscriptions
		for (IPMC_Utilities.EligibleProducts ep : OriginalSubscriptions) {
			system.debug('Selected: ' + ep.Selected + ' Service: ' + ep.IPMCPkg.Name);
		}
		//Set<Product2> CurrentSVCs = new Set<Product2>();	//create a set of subscribed services
		for (IPMC_Utilities.EligibleProducts ep : OriginalSubscriptions) {
			system.debug(ep);
			if (ep.Selected) {									//These are the Current subscriptions
				SVCsToTerminate.put(ep, ReceiveSite);
				system.debug(SVCsToTerminate);
				//CurrentSVCs.add(ep.IPMCPkg);
			}
		}
		
		TerminateContractedServices(existingContract, SVCsToTerminate);
		return null;
	}	/* SiteDeactivate ENDS here */
	/* SiteMapPkgKinds STARTS here */
	private TransmissionServiceCallouts.resultCode MapProductsToAsset(Asset a, List<Product2> Services) {
		//Need to start with an Asset to map to... that's "a"!
		//Need to convert Products to PkgKinds
		system.debug('List : ' + Services);
		set<String> PkgKindsToMap = new set<String>();
		for (Package_Kinds_by_Product__c PKP : [Select Package_Kind__c From Package_Kinds_by_Product__c WHERE Product__c IN :Services]) {
			PkgKindsToMap.add(PKP.Package_Kind__c);		//make a set to avoid dupes...
		}
		system.debug('Set : ' + PkgKindsToMap);
		List<string> PkgKinds = new List<string>();
		PkgKinds.addAll(PkgKindsToMap);
		system.debug('List : ' + PkgKinds);
		//instanciate a new TSCallout class includes "resultCode"
		TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();
		TSC.resultCode = TSC.SiteMapPkgKinds(ReceiveSite.Name, PkgKinds);
		system.debug(TSC.resultCode);
		setactivateResponse('Callout success: '+TSC.resultCode.success+' Response message: '+TSC.resultCode.exceptionMessage);
		
		return TSC.resultCode;
	}
	/* Support for unit testing of Private Methods */
	public with sharing class TestException extends Exception {
	}
	public void test_setHierarchy(string s){ 
		//This method can only be called from a test method.
		//  This method allows calling a private method from test code to allow for faster test performance.
		if (!test.isRunningTest()){
		throw new TestException('This method can only be called from a test.');
		}
		setHierarchy(s);
	}
	public void test_setBillingAcct(string s) {
		//This method can only be called from a test method.
		//  This method allows calling a private method from test code to allow for faster test performance.
		if (!test.isRunningTest()){
		throw new TestException('This method can only be called from a test.');
		}
		setBillingAcct(s); 
	}
	public void test_ListEligibleProducts() {
		//This method can only be called from a test method.
		//  This method allows calling a private method from test code to allow for faster test performance.
		if (!test.isRunningTest()){
		throw new TestException('This method can only be called from a test.');
		}
		ListEligibleProducts(); 
	}
	
	/* End Private Method Unit Test Suppport */
}