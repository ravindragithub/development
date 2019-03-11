public with sharing class IPMC_Utilities {
	public static Map<Id, String> IPMCHardwareMap = new Map<ID, String>();
	public static Set<String> IPMCantennaSet = new Set<string>();
	public static Set<String> IPMCserverSet = new Set<String>();
	
	static {
		for (Product2 p : [SELECT Id, Airtime_Group__c, ProductCode FROM Product2
                WHERE (Airtime_Group__c IN ('V3', 'V7', 'V11') AND ProductCode Like '02-%')    //refurbs
                OR (Airtime_Group__c IN ('V3', 'V7', 'V11') AND ProductCode Like '_02-%')        //Antennas
                OR (Airtime_Group__c IN ('CBX', 'MS', 'SY'))]) {							    //OR CBX License (and maybe MediaServer Licenses!) added SuperYacht 11/17
			system.debug(p);
			IPMCHardwareMap.put(p.Id, p.Airtime_Group__c);
			if (p.Airtime_Group__c == 'V3' || p.Airtime_Group__c == 'V7' || p.Airtime_Group__c == 'V11') {
                IPMCantennaSet.add(p.Airtime_Group__c);				//add unique Airtime Groups (antenna Types) to set
            } else if (p.Airtime_Group__c == 'CBX' || p.Airtime_Group__c == 'MS' || p.Airtime_Group__c == 'SY')  {
                IPMCserverSet.add(p.Airtime_Group__c);				//add unique Airtime Groups (server Types) to set
            }
		}
		system.debug('static Hardware Map ' + IPMCHardwareMap);
		system.debug('static Antenna Set ' + IPMCantennaSet);
		system.debug('static Server Set ' + IPMCserverSet);
	}
	
	public List<Product2> getIPMC_bundles() {	//returns a List of Product2 records with a KVH Product Family field == IPMC Package
		List<Product2> IPMCProducts = new List<Product2>();
		IPMCProducts = [SELECT Id, Name, ProductCode, KVH_Product_Family__r.Name, KVH_Product_Family__c, IsActive,  Airtime_Group__c
						FROM Product2 WHERE KVH_Product_Family__r.Name = 'IPMC Package' AND IsActive = true
						ORDER BY Name ASC];
		return IPMCPRoducts;
	}
	public List<EligibleProducts> getIPMCProducts() {	//returns a List of Eligible (wrapped) Product2 records with a KVH Product Family field == IPMC Package
		List<EligibleProducts> returnList = new List<EligibleProducts>();
		List<Product2> bundles = new List<Product2>();
		bundles = getIPMC_bundles();
		for (Product2 p : bundles) {
			returnList.add(new EligibleProducts(false, p, false, '', '', false, null));
		}
		return returnList;
	}
	public List<EligibleProducts> systemCompatibility (List<EligibleProducts> ServiceList, List<AssetStructureEngine.AssetStructureMap> Hierarchy) {
		//Compares the list of IPMC Services against the Asset Hierarcy and updates the compatibility fields in the List of Eligible Products
		String AirtimeGroup;								//Need a single instance string for...
		Set<String> AirtimeGroups = new Set<String>();		//and a set of all these strings

		for (EligibleProducts ep : ServiceList) {	//for each of the services submitted (probably all of them!)
			AirtimeGroups.clear();					//We need to Convert the Service Lists Airtime Group field into a Set...
			if(ep.IPMCPkg.Airtime_Group__c != null) {
				system.debug(ep.IPMCPkg.Airtime_Group__c);
			}
			
			for (AssetStructureEngine.AssetStructureMap asm : Hierarchy) {	//check each product in the system for compatibility issues....
				if (IPMCHardwareMap.containsKey(asm.Asset.Product2Id)) {	//is this hierarchy node an IPMC Asset (key in map)?
					system.debug(asm.Asset);
					AirtimeGroup = IPMCHardwareMap.get(asm.Asset.Product2Id); //Yes? get corresponding value for key... Which one?
					system.debug(AirtimeGroup);
					
				}
			}
			system.debug(ep);
		}
		//Nested for loops? ServiceList outer and Hierarchy Inner?
		return ServiceList;
	}
	
	public List<EligibleProducts> findExistingSubscriptions (List<Asset> assetList, List<EligibleProducts> ServiceMenu){
		//get a list of all the Services being delivered to the Asset List 
		List<EligibleProducts> returnList = new List<EligibleProducts>();
		ContractUtilities UTIL = new ContractUtilities();
		List<Contracted_Services__c> CurrentServices = new List<Contracted_Services__c>();
		CurrentServices = UTIL.ServicesByAssets(assetList);
		system.debug(CurrentServices);
		//Convert the List to a Map of Product2 (Service Item) Ids, and Contracted Service Ids;
		map<Id, Contracted_Services__c> serviceMap = new Map<Id, Contracted_Services__c>();
		for (Contracted_Services__c cs : CurrentServices) {
			if (cs.Terminated_Date__c == null){					// Need to remove the terminated Services...
				serviceMap.put(cs.Service_Item__c, cs); 	//This is the service item and contracted service record...
			}
		}
		for (IPMC_Utilities.EligibleProducts ep : ServiceMenu) { 	//Loop through all the IPMC products
			if (serviceMap.containsKey(ep.IPMCPkg.Id)){				//and identify the ones already contracted....
				ep.Selected = true;									//set the selected flag
				ep.ContractedService = serviceMap.get(ep.IPMCPkg.Id);
				system.debug(ep);
			}//end IF
			returnList.add(ep);
		}//end For
		return returnList;
	}
	
	public map<Id, list<IPMC_Package_Kinds__c>> getPKsByProduct(list<Product2> productList){	//returns a map of Product2Ids to list of IPMC PkgKinds
		map<Id, list<IPMC_Package_Kinds__c>> returnMap = new map<Id, list<IPMC_Package_Kinds__c>>();
		for(Package_Kinds_by_Product__c PKbP : [SELECT Id, Product__c, IPMC_Package_Kind__c, Package_Kind__c FROM Package_Kinds_by_Product__c
												WHERE Product__c IN :productList]){
			list<IPMC_Package_Kinds__c> PKlist = new list<IPMC_Package_Kinds__c>();
			if(returnMap.get(PKbP.Product__c) != null){					//If the Product is already in the map...
				PKlist = returnMap.get(PKbP.Product__c);				//get the existing List to add to!
			}
			PKlist.add(new IPMC_Package_Kinds__c(Id = PKbP.IPMC_Package_Kind__c, PackageKind__c = PKbP.Package_Kind__c));
			returnMap.put(PKbP.Product__c, PKlist);
		}
		return returnMap;
	}
	
	public list<string> getPkgKindNames (list<IPMC_Package_Kinds__c> PkgKinds){
		list<string> returnList = new list<string>();
		for(IPMC_Package_Kinds__c PK : PkgKinds){
			returnList.add(PK.PackageKind__c);
		}
		return returnList;
	}
	
	//Eligible Products Wrapper Class 
	public Class EligibleProducts{// this serves as a wrapper class....
    	public Boolean Selected;
    	public Product2 IPMCPkg;
    	public Boolean SystemCompatible;
    	public String AntennaStatus;
    	public String ServerStatus;
    	public Boolean is31DayTrial;
    	public Contracted_Services__c ContractedService;	//added 11/17
    	
    	public Boolean getSelected() {
    		return Selected;
    	}
    	public void setSelected (Boolean b) {
    		this.Selected = b;
    	}
    	public Product2 getIPMCPkg() {
    		return IPMCPkg;
    	}
    	public void setIPMCPkg(Product2 p) {
    		this.IPMCPkg = p;
    	}
    	public Boolean getSystemCompatible() {
    		return SystemCompatible;
    	}
    	public void setSystemCompatible(Boolean b) {
    		this.SystemCompatible = b;
    	}
    	public String getAntennaStatus() {
    		return AntennaStatus;
    	}
    	public void setAntennaStatus(string s) {
    		this.AntennaStatus = s;
    	}
    	public String getServerStatus() {
    		return ServerStatus;
    	}
    	public void setServerStatus(string s) {
    		this.ServerStatus = s;
    	}
    	public Boolean getis31DayTrial(){
    		return is31DayTrial;
    	}
    	public void setis31DayTrial(Boolean b){
    		this.is31DayTrial = b;
    	}
    	public Contracted_Services__c getContractedService(){
    		return ContractedService;
    	}
    	public void setContractedService(Contracted_Services__c cs){
    		this.ContractedService = ContractedService;
    	}
    	//constructor, all params
    	public EligibleProducts(Boolean Selected, Product2 IPMCPkg, Boolean SystemCompatible, String AntennaStatus, String ServerStatus, Boolean is31DayTrial, Contracted_Services__c ContractedService) {
    		this.Selected = Selected;
    		this.IPMCPkg = IPMCPkg;
    		this.SystemCompatible = SystemCompatible;
    		this.AntennaStatus = AntennaStatus;
    		this.ServerStatus = ServerStatus;
    		this.is31DayTrial = is31DayTrial;
    		this.ContractedService = ContractedService;
    	}
    	//constructor, no services
    	public EligibleProducts(Boolean Selected, Product2 IPMCPkg, Boolean SystemCompatible, String AntennaStatus, String ServerStatus, Boolean is31DayTrial) {
    		this.Selected = Selected;
    		this.IPMCPkg = IPMCPkg;
    		this.SystemCompatible = SystemCompatible;
    		this.AntennaStatus = AntennaStatus;
    		this.ServerStatus = ServerStatus;
    		this.is31DayTrial = is31DayTrial;
    		this.ContractedService = null; 
    	}
    }
}