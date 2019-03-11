/* This controller is used to collect details essential to the
 * activation and maintenance of IPMC services. IT will be typically launched
 * from a button that included the following parameters
 * /apex/IPMCAssetFlow?Asset={!Asset.Id}&ActivatedBy={!User.Name}             */
//10 SOQL queries for a typical V3-IP system...
public with sharing class IPMCAssetFlowController {
    //public AssetStructureEngine ASE = new AssetStructureEngine();
    /* Local Variables */
    private Map<Id, String> IPMCProducts;		// These are all the IPMC related Products in the database
	public Map<String, Integer> InstalledAntennaTypes = new Map<String, Integer>();	//This is a count of the installed IPMC related Assets by antenna type
	public Map<String, Integer> InstalledServerTypes = new Map<String, Integer>();	//This is a count of the intalled IPMC server types by server type
	
    private String SingleAntenna;	//If there is only one installed antenna, this is they type
    private String SingleServer;	//This is the default Asset to Activate
    
    
    /* Page Properties */
    public Asset ServerToActivate; 	//This is the default Asset to be activated (typically a media server)
    public Asset SystemID;			//This is the system level Asset in the Hierarchy
    public List<AssetStructureEngine.AssetStructureMap> Hierarchy = new List<AssetStructureEngine.AssetStructureMap>();
    public List<Asset> SRVRList = new List<Asset>();

    public Boolean RequiresReview;
    public Boolean AcctRequiresReview;
    public Integer SRVRCount {get; set;}
    public Integer ANTCount {get; set;}
    public Boolean showSRVRList {get;set;}
    public String SelectedSRVR {get; set;}
    
	public Contract existingContract = new Contract();
	public Contract getexistingContract(){
		return existingContract;
	}
	public void setexistingContract(Contract k) { 
		existingContract = k;
	}
    
    public List<IPMC_Utilities.EligibleProducts> ValidChoices = new List<IPMC_Utilities.EligibleProducts>();
    
    public pageReference ActivateAndMap(){
    	//String SRVRId = System.currentPagereference().getParameters().get('SelectedSRVR');
    	//pageReference Service_mappingPage = new PageReference('/apex/IPMC_Service_mapping?SRVR=' + SelectedSRVR + '&SYSTEM=' + SystemId.Id);
    	pageReference Service_mappingPage = page.IPMC_Service_mapping;
    	Service_mappingPage.getParameters().put('SRVR', SelectedSRVR);
    	Service_mappingPage.getParameters().put('SYSTEM', SystemId.Id);
    	Service_mappingPage.getParameters().put('ACCT', ServerToActivate.Account.Parent.Custom_Call_Acct_ID__c);
    	Service_mappingPage.setRedirect(false);
    	return Service_mappingPage;
    }
    
    /* End of Page Properties */
    /* Getters and Setters */
	public AssetStructureEngine.AssetStructureMap[] getHierarchy(){return Hierarchy;}
	private void setHierarchy(string s){ //s = record ID of topmost element in Asset Hierarchy
        Hierarchy = AssetStructureEngine.getAssetStructure(s);
    } 
    
    public Asset getServerToActivate(){return ServerToActivate;} 
    private void setServerToActivate(string s){
		ServerToActivate = [SELECT Id, Name, Item_Description__c, 
    					AccountId, Account.Name, Account.RecordType.DeveloperName, Account.RecordType.Name,
    					Account.ParentId, Account.Parent.Name, Account.Parent.Custom_Call_Acct_ID__c,
    					Account.Parent.RecordType.DeveloperName , Account.Parent.RecordType.Name
						FROM Asset WHERE id =:s];
    }
    
    public Asset getSystemID(){return SystemID;}
    private void setSystemID(string s){
        SystemID = [SELECT Id, Name, Item_Description__c FROM Asset WHERE id =:s];
    }
    public Map<String, Integer> getInstalledAntennaTypes() {return InstalledAntennaTypes;}
    public Map<String, Integer> getInstalledServerTypes() {return InstalledServerTypes;}
    //Setter??? is initialized and populated in onLoad()
    
    public Boolean getRequiresReview() {
        If (SRVRCount == 1 && ANTCount == 1){
            return false;
        } else {
            return true;
        }
    }
	public Boolean getAcctRequiresReview() {
        If (ServerToActivate == null){	//check for null
            return true;
        } else if (ServerToActivate.Account.RecordType.DeveloperName.left(8) == 'Platform' && 
            ServerToActivate.Account.Parent.Custom_Call_Acct_ID__c.length() >= 4){
            return false;
        } else {
        	return true;
        }
    }
    public List<Asset> getSRVRList() {
    	return SRVRList;
    }
    private void setSRVRList() {
        SRVRList = [SELECT id, Name, Item_Description__c, Product2.Airtime_Group__c,
                            Parent_Asset__r.Name, Parent_Asset__r.Id, Parent_Asset__r.Item_Description__c,
                            IPMC_KenCast_SiteID__c, IPMC_License_Issued__c, IPMC_License_Issued_by__c
                            FROM Asset WHERE Id IN :SRVRList];
    }
    
    public String GetTopElement( String objId ){
        system.debug(objId);
        Boolean top = false;
        while ( !top ) {
            List<Asset> soqla = [ Select a.Id, a.Parent_Asset__c From Asset a where a.Id =: objId ];
            system.debug(soqla);
            Asset a = null;
            if (!soqla.isEmpty()) { // we got records!
                a = soqla.get(0);  // just want the first one
            } else {
                // do something else?! No Parent!
            }
            if ( a.Parent_Asset__c != null ) {
                objId = a.Parent_Asset__c;
            } else {
                top = true;
            }
        }
        return objId ;
    }
    
    public List<IPMC_Utilities.EligibleProducts> getValidChoices() {
    	return ValidChoices; 
    }
    /*End of Getters and Setters */
    
    
    public PageReference autoRun() {
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
        setSystemID(GetTopElement(ApexPages.currentPage().getParameters().get('Asset'))); //get the System Level Asset
		showSRVRList = false;
        
        setHierarchy(String.valueOf(SystemId.id));	//Get the Asset Hierarchy
        system.debug(Hierarchy.size());
        											//loop through the hierarcy, summing antenna types and server types
        countIPMCProducts();      			//count the IPMC critical Assets...
        if (!getRequiresReview()){			//If the Asset Hierarchy is in high order...
        	for (string s : InstalledAntennaTypes.keyset()){	//Figure out our one antenna type
        		if (InstalledAntennaTypes.get(s) == 1) {
        			SingleAntenna = s;
        			system.debug(SingleAntenna);	//should be 'V3', 'V7', or 'V11'...
        		}
        	}
        	for (string s : InstalledServerTypes.keyset()) {
        		if (InstalledServerTypes.get(s) == 1) {
        			SingleServer = s;
        			system.debug('Single server == ' + SingleServer);	//should be 'CBX', or 'MS'...        			
        		}
        	}
        	ListEligibleProducts();
        }
        return null;
    }
    public PageReference getCBXDetails() {
    	setSRVRList();
    	showSRVRList = true;
        //setCBXList(Hierarchy);
        return null; 
    }
    public PageReference getAcctDetails() {
    	return null;
    }

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
                	SRVRCount = SRVRCount + 1;
                	SRVRList.add(asm.Asset);
                	setServerToActivate(asm.Asset.Id);
                }
                system.debug(InstalledAntennaTypes);
                system.debug(InstalledServerTypes);
            }
        }
    }
    private void ListEligibleProducts() {	//add params String SRVRGroup, String ANTGroup
    	List<Product2> IPMCProducts = new List<Product2>();
		IPMCProducts = [SELECT Id, Name, ProductCode, KVH_Product_Family__r.Name, KVH_Product_Family__c, IsActive,  Airtime_Group__c
					 FROM Product2
					 WHERE KVH_Product_Family__r.Name = 'IPMC Package' AND IsActive = true];
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
		//tryout the new IPMC_Utilities.systemCompatibility() function
		IPMC_Utilities IPMC_UTIL = new IPMC_Utilities();
		List<IPMC_Utilities.EligibleProducts> ValidChoicesTEMP = new List<IPMC_Utilities.EligibleProducts>();
		ValidChoicesTEMP = IPMC_UTIL.systemCompatibility(ValidChoices, Hierarchy);
		system.debug(ValidChoicesTEMP);
		
		//End tryout...
		
		//get a list of all the Services being delivered to the Asset List 
		ContractUtilities UTIL = new ContractUtilities();
		List<Contracted_Services__c> CurrentServices = new List<Contracted_Services__c>();
		CurrentServices = UTIL.ServicesByAssets(SRVRList);
		system.debug(CurrentServices);
		//Convert the List to a Map of Product Ids, and Contract Ids;
		map<Id, Id> ContractMap = new Map<Id, Id>();
		Id ContractId;		//Might need to hold a Contract ID for a minute...
		for (Contracted_Services__c cs : CurrentServices) {
			if (cs.Terminated_Date__c == null){							// Need to remove the terminated Services...
				ContractMap.put(cs.Service_Item__c, cs.Contract__c); 	//This is the service and governing contract
			}
		}
		for (IPMC_Utilities.EligibleProducts ep : ValidChoices) {	//Loop through all the IPMC products
			if (ContractMap.containsKey(ep.IPMCPkg.Id)){		//and identify the ones already contracted....
				ep.Selected = true;
				ContractId = (ContractMap.get(ep.IPMCPkg.Id));
				system.debug(ContractId);
			}
			system.debug(ep.Selected +':'+ ep.IPMCPkg.Name + ':'+ep.SystemCompatible+':'+ep.AntennaStatus);
		}
		if (ContractId != null) {
			setexistingContract([SELECT Id, Name, AccountId FROM Contract WHERE Id =: ContractId]);
		}
		system.debug(existingContract);
    }
	/* Support for unit testing of Private Methods */
	public with sharing class TestException extends Exception {
	}
	public void test_setSystemID(string s) {
		//This method can only be called from a test method.
		//  This method allows calling a private method from test code to allow for faster test performance.
		if (!test.isRunningTest()){
		throw new TestException('This method can only be called from a test.');
		}
		setSystemId(s); 
	}
		public void test_setServerToActivate(string s) {
		//This method can only be called from a test method.
		//  This method allows calling a private method from test code to allow for faster test performance.
		if (!test.isRunningTest()){
		throw new TestException('This method can only be called from a test.');
		}
		setServerToActivate(s); 
	}
}