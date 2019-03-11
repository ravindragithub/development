public with sharing class platform_record_type_controller {
	public String PlatRecType = '';
	public Account ParentAcct;			//This will become the Platform Parent
	public Asset ParentAsset;			//This will be the Parent Asset added to the new Platform
	public Id RefId;
	public String AcctRef = ApexPages.currentPage().getParameters().get('Acctid');
	public String AssetRef = ApexPages.currentPage().getParameters().get('ParentAsset');
	
	public String getAcctRef() {
		system.debug(AcctRef);
		return AcctRef;
	}
		public String getAssetRef() {
		system.debug(AssetRef);
		return AssetRef;
	}//public void setRef(String Ref) { this.Ref = Ref; }
	
	public Id getrefId() {
		Id refID = AcctRef;
		System.debug(refID);
		return refId;
	}
	
	public Account getParentAcct() {
		Account a = new Account();
		//maybe this Account is the page where we clicked the button,
		//maybe it's the parent Account of the Asset
		a = [SELECT Id, Name FROM Account WHERE Id = :AcctRef LIMIT 1];
		system.debug(a);
		return a;
	}
	//change to RecordType from SelectOptiontype?
	public List<RecordType> getItems() {
		List<RecordType> options = new List<RecordType>();
		
		List<RecordType> RecTypes = new List<RecordType>(); 
		for (RecordType RT : [SELECT id, DeveloperName, Name FROM RecordType WHERE DeveloperName LIKE 'Platform%']){
			RecTypes.Add(RT);
			options.add(RT);
			}
		System.debug(options); //This List contains all the "Platform" Record Type Ids.
		return options;
		}

	public String getPlatRecType() {
		return PlatRecType;
	}

	public void setPlatRecType(String PlatRecType) { this.PlatRecType = PlatRecType; }
}