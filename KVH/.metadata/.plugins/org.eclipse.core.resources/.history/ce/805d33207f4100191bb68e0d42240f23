public with sharing class VW_CreateNewAssetController {
	/*need to get params*/
	public Asset ParentAsset;
	public string AssetRef = ApexPages.CurrentPage().getParameters().get('ParentAsset');
	public Flow.Interview.Create_New_Asset myFlow {get;set;}

	public PageReference getFinishPage() {
		if (AssetRef == '') {	//AssetRef means we are creating a child Asset
			PageReference p = new PageReference('/' + getactID() );
			p.setRedirect(true);
			return p;
		} else {	//IF there is no AssetRef then we created a parent Asset
			PageReference p = new PageReference('/' + AssetRef );
			p.setRedirect(true);
			return p;
		}
	}
	
	public String getactID() {
		if (myFlow==null) {
			return '';
		} else {
			return myFlow.BrandNewAsset;
		}
	}
	public string getAssetRef() {
		system.debug(AssetRef);
		return AssetRef;
	}
	public Asset getParentAsset() {
		Asset a = new Asset();
		//This is probably the Asset detail page from which we clicked the button!
		a = [SELECT id, Name, AccountId, Asset_Id__c, SerialNumber, Product2Id
			FROM Asset
			WHERE id =:AssetRef LIMIT 1];
			system.debug(a);
			return a;
	}
}