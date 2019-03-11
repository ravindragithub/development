/***********************************************************************************************************************
Name: SubscriptionAssigmentLightningController
Copyright © 2017 KVH Industries | Salesforce Instance : 
========================================================================================================================
Purpose: This is used to create new Subscription Data from Existing Subscription of same Asset Hirarchy data. 
------------------------------------------------------------------------------------------------------------------------
Utilized in(Called in):
-----------------------

========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0     Mayukhman Pathak     05/23/2017       Initial Development                                   
***********************************************************************************************************************/
public class SubscriptionAssigmentLightningController{
    
    /* Method to get the all Subscription's of Assets related to Asset Hirarchy of 
asset passed from Lightning Component Parameter
*/
    @AuraEnabled
    public static Map<Id,SBQQ__Subscription__c> getSubscription(string assetId) 
    {
        set<id> allAssetIds = new set<id>();
        allAssetIds.add(assetId);
        Map<Id,Id> topIds = AssetStructure.GetTopMultipleElements(allAssetIds);
        List<Asset> productAssets = new List<Asset>();
        
        Map<Id,SBQQ__Subscription__c> subIdSubDateMap = new Map<Id,SBQQ__Subscription__c>();
        if(topIds != null)
        {
            productAssets = [Select id,Name,Product2.Name,Parent_Asset__c,AccountID,Date_Removed__c,InstallDate,Sequence_No__c,Installed_By__c,
                             Parent_Asset__r.Parent_Asset__c,
                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__c,
                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c,
                             (SELECT Id, Name,CreatedDate,SBQQ__Quantity__c,SBQQ__Product__r.Name,SBQQ__Product__c,Asset__c,Asset__r.Name,SBQQ__SubscriptionStartDate__c ,SBQQ__SubscriptionEndDate__c ,SBQQ__Product__r.Standard_Pricebook_Price__c,SBQQ__Product__r.CurrencyIsoCode 
                              From Subscriptions__r Order by CreatedDate ASC) from Asset 
                             where Id=:topIds.values() OR Parent_Asset__c =: topIds.values() OR
                             Parent_Asset__r.Parent_Asset__c =: topIds.values() OR
                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: topIds.values() OR
                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: topIds.values() OR
                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: topIds.values()];
        }
        Set<SBQQ__Subscription__c> lstSubscriptionNames = New Set<SBQQ__Subscription__c>();
        if(productAssets.size() > 0)
        {
            for(Asset productAsset:productAssets)
            {
                for(SBQQ__Subscription__c objSubscription:productAsset.Subscriptions__r)
                    lstSubscriptionNames.add(objSubscription);
            }
        }
        if(lstSubscriptionNames.size() > 0)
        {
            for(SBQQ__Subscription__c  sub :lstSubscriptionNames)
            {
                subIdSubDateMap.put(sub.Id,sub);
            }
        }
        return subIdSubDateMap;
    }
    
    /* Method to create new Subscription and update the Existing subscription End Date based on Data selected in 
Lighnting UI */
    @AuraEnabled
    public static List<SBQQ__Subscription__c> createNewSubscription(SBQQ__Subscription__c newSubscriptionData,SBQQ__Subscription__c oldSubscriptionOldData) 
    {
        List<SBQQ__Subscription__c> listUpdateSub= new List<SBQQ__Subscription__c>();
        if(newSubscriptionData != null && oldSubscriptionOldData != null)
        {
            newSubscriptionData.SBQQ__SubscriptionStartDate__c = Date.valueof(newSubscriptionData.SBQQ__SubscriptionStartDate__c );
            newSubscriptionData.SBQQ__SubscriptionEndDate__c = Date.valueof(newSubscriptionData.SBQQ__SubscriptionEndDate__c );
            oldSubscriptionOldData.SBQQ__SubscriptionEndDate__c = Date.valueof(oldSubscriptionOldData.SBQQ__SubscriptionEndDate__c );
            newSubscriptionData.id = null;
            listUpdateSub.add(oldSubscriptionOldData);
            listUpdateSub.add(newSubscriptionData);
        }
        if(listUpdateSub.size() > 0)
            upsert listUpdateSub;
        return listUpdateSub;
    }
    /* Method return list of Active Service Type Product on New Subcription Modal Window based on User Typeahead */ 
    @AuraEnabled
    public static List <sObject> fetchProduct(String searchKeyWord,string searchObjective) {
        system.debug(searchKeyWord+'===searchObjective==='+searchObjective);
        String searchKey = searchKeyWord + '%';
        List <sObject> returnList = new List <sObject> ();
        if(searchObjective == 'Update_Subscription'){
            List <Product2> lstOfProduct = [select id, Name,RecordType.Name, IsActive  from Product2 
                                            where (RecordType.Name = 'Service' AND isActive = true AND Name LIKE: searchKey) limit 25];
            if(lstOfProduct.size() > 0){
                for (Product2 prod: lstOfProduct) {
                    returnList.add(prod);
                }
            }
        }
    else if(searchObjective == 'Asset Replacement'){
            List <Account> lstOfAccount = [SELECT id, Name  from Account
                                           WHERE (RecordType.Name = 'Direct Partner' OR RecordType.Name = 'Indirect Partner')
                                           AND Name LIKE: searchKey limit 25];
            if(lstOfAccount.size() > 0){
                for (Account acc: lstOfAccount) {
                    returnList.add(acc);
                }
            }
        }
    else if(searchObjective == 'Beam_List'){
            List <Beam__c> lstOfBeam = [SELECT id,Name,KVH_Website_URL__c,Beam_Full_Name__c FROM Beam__c
                                           WHERE Name LIKE: searchKey limit 5];
            if(lstOfBeam.size() > 0){
                for (Beam__c acc: lstOfBeam) {
                    returnList.add(acc);
                }
            }
        }
    else if(searchObjective == 'Flex_List'){
            List <FLEX_HTS_Region__c> lstOfFlex = [SELECT id,Name,Region_URL__c FROM FLEX_HTS_Region__c
                                           WHERE Name LIKE: searchKey limit 5];
            if(lstOfFlex.size() > 0){
                for (FLEX_HTS_Region__c acc: lstOfFlex ) {
                    returnList.add(acc);
                }
            }
        }
        else if(searchObjective == 'WorkOrder_Product'){
            List <Product2> lstOfProduct = [select id, Name,Description,ProductCode, IsActive  from Product2 
                                            where (isActive = true AND (Name LIKE: searchKey OR ProductCode Like : searchKey)) limit 25];
            if(lstOfProduct.size() > 0){
                for (Product2 prod: lstOfProduct) {
                    returnList.add(prod);
                }
            }
        }
        return returnList;
    }
}