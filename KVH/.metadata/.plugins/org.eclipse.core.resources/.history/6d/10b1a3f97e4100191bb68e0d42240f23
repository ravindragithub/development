/***********************************************************************************************************************
 Name: FindandAddAccounttoAsset
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to update AssetId in case
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      09/04/2014       Initial Development                                   
***********************************************************************************************************************/

public class FindandAddAccounttoAsset
{
    public Case caseAccountName{get;set;}
    public String SerialNumber{get;set;}
    public Boolean FoundAsset{get;set;}
    public Boolean NotFoundAsset{get;set;}
    public List<Asset> searchAssets{get;set;}
    public List<AssetWithRadio> allAssestRadio{set;get;}
    public Asset selectedAsset{get;set;}
    public boolean selectedBlock{get;set;}
    public boolean newAssetBlock{get;set;}
    public Asset newAsset{get;set;}
    public list<AssetStructure.ObjectStructureMap> ObjectStructure{get;set;}
    Id CaseId;
    Boolean IpAddressinObjectStructure;
    Boolean topLevelAsset;
    ID topLevelAssetID;
    ID IpaddressId;
    ID ProductIpAddressAssetID;
    
    public FindandAddAccounttoAsset()
    {  
        IpAddressinObjectStructure = false;
        CaseId = System.currentPagereference().getParameters().get('caseid');
        caseAccountName = [select id,account.name,AssetID,AccountID,Platform_Asset_Account__r.name,Platform_Asset_Account__c,Product_or_Service__c from Case where id=:CaseId];
    }
    
    
    public void searchAsset()
    {
        allAssestRadio = new List<AssetWithRadio>();
        String SearchQuery = 'select id,name,Account.name,Service_Activation_Date__c,Product2.name,Date_Removed__c from Asset where Name Like \'%'+SerialNumber+'%\' ';
        SearchQuery = SearchQuery + 'Limit 30';
        searchAssets = Database.Query(SearchQuery);
        if(searchAssets.size()>0)
        {
            FoundAsset = true;
            for(Asset assetRadio:searchAssets)
            {
                AssetWithRadio AWR = new AssetWithRadio();
                AWR.MySelection = false;
                AWR.SelectedAsset = assetRadio;
                allAssestRadio.add(AWR);
            }
        }else
        {
            newAssetBlock = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'Asset Not Found'));
        }
    }

    ID selAssetid;
    
    public Void selectAsset()
    {
        selectedBlock = true;
        selectedAsset = new Asset();
        IpaddressId = null;
        selAssetid = System.currentPagereference().getParameters().get('id');
        AssetStructure ASE = new AssetStructure();
        ObjectStructure = ASE.formatObjectStructure(selAssetid);
        system.debug(ObjectStructure);
        for(AssetStructure.ObjectStructureMap checkIpAddress:ObjectStructure)
        {
            if(caseAccountName.Product_or_Service__c == 'mini-VSAT Broadband Airtime Service Activation')
            {
                if(checkIpAddress.Asset.Item_Description__c == 'IP Address')
                {
                       IpaddressId = checkIpAddress.Asset.id;
                       IpAddressinObjectStructure = true;
                }
            }
        }
        selectedAsset = [select id,name,Account.name,Product2.name,Service_Activation_Date__c,Date_Removed__c from Asset where id=:selAssetid];
    }
    
    
    
    public pageReference saveAsset()
    {
        if(caseAccountName.Product_or_Service__c == 'mini-VSAT Broadband Airtime Service Activation' && IpAddressinObjectStructure)
        {
            caseAccountName.Associate_Asset_to_Platform_in_Salesforc__c = true;
            caseAccountName.Modem_IP_2__c = IpaddressId;
            caseAccountName.AssetID = topLevelAssetID;
        }
        
        if(caseAccountName.Product_or_Service__c != 'mini-VSAT Broadband Airtime Service Activation' || (caseAccountName.Product_or_Service__c == 'mini-VSAT Broadband Airtime Service Activation' && !IpAddressinObjectStructure))
        {
            if(caseAccountName.AssetID == null)
            //caseAccountName.AssetID = System.currentPagereference().getParameters().get('firstParam');
            
            caseAccountName.Associate_Asset_to_Platform_in_Salesforc__c = true;
        }
        
        update caseAccountName;
        
        String parentAssetDelete = System.currentPagereference().getParameters().get('secondParam');
        Asset assetAccountUpdate = [select id,Parent_Asset__c from Asset where id=:System.currentPagereference().getParameters().get('firstParam')]; 
        assetAccountUpdate.AccountID = caseAccountName.Platform_Asset_Account__c;
        assetAccountUpdate.Service_Activation_Date__c = system.today();
        if(parentAssetDelete == 'performParentAssetDelete')
        {
            assetAccountUpdate.Parent_Asset__c = null;
        }
        update assetAccountUpdate;
        
        
        pageReference returnToCase = new PageReference('/'+CaseId);
        return returnToCase;
    }
   
    
    public pageReference Cancel()
    {
        pageReference returnToCase = new PageReference('/'+CaseId);
        return returnToCase;
    }
    
    public class AssetWithRadio
    {
        public Boolean MySelection{get;set;}
        public Asset SelectedAsset{get;set;}
    }   
}