global with sharing class ContractUtilities {
	public final Id IPMC_CONTRACT_RECORD_TYPE_ID =Schema.SObjectType.Contract.getRecordTypeInfosByName().get('IP-MobileCast').getRecordTypeId();
	
    public List<Contracted_Services__c> ServicesByAssets(List<Asset> a) {//Use this Method with a List of Assets
        List<Contracted_Services__c> svcs = new List<Contracted_Services__c>();
        svcs = [Select Terminated_Date__c, SystemModstamp, Service_Item__c, Qty__c, Product__c, 
                Name, LastModifiedDate, LastModifiedById, LastActivityDate, Item_Category__c, IsDeleted, Id, 
                Effective_Date__c, CreatedDate, CreatedById, Contract__c, Charge__c, Charge_Frequency__c, 
                Bill_Description__c, Asset__c, Asset_Service_Activation_Date__c, Asset_Parent_Account__c, 
                Asset_Date_Removed_Date__c, Asset_Account__c 
                From Contracted_Services__c
                WHERE Asset__c IN :a];
        return svcs;
    }
    public List<Contracted_Services__c> ServicesByAssets(Asset a) {//User this method with a single Asset
        List<Contracted_Services__c> svcs = new List<Contracted_Services__c>();
        svcs = [Select Terminated_Date__c, SystemModstamp, Service_Item__c, Qty__c, Product__c, 
                Name, LastModifiedDate, LastModifiedById, LastActivityDate, Item_Category__c, IsDeleted, Id, 
                Effective_Date__c, CreatedDate, CreatedById, Contract__c, Charge__c, Charge_Frequency__c, 
                Bill_Description__c, Asset__c, Asset_Service_Activation_Date__c, Asset_Parent_Account__c, 
                Asset_Date_Removed_Date__c, Asset_Account__c 
                From Contracted_Services__c
                WHERE Asset__c =: a.Id];
        return svcs;
    }
}