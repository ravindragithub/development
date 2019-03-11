/***********************************************************************************************************************
Name: Update_AssetSubscriptionController
Copyright © 2017 KVH Industries | Salesforce Instance : 
========================================================================================================================
Purpose:  
------------------------------------------------------------------------------------------------------------------------

-----------------------

========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0     Mayukhman Pathak     06/07/2017       Initial Development                                   
***********************************************************************************************************************/
public class Update_AssetSubscriptionController{
    @AuraEnabled
    public static List<String> getSubscriptionStatus() {
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = SBQQ__Subscription__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple)
            pickListValuesList.add(pickListVal.getLabel());
        return pickListValuesList;
    }
    
    /* Method to get the all Subscription's of Assets related to Asset Hirarchy of 
asset passed from Lightning Component Parameter
*/
    @AuraEnabled
    public static Map<string,List<SBQQ__Subscription__c>> getAllSubscription(string assetId) {
        set<id> allAssetIds = new set<id>();
        allAssetIds.add(assetId);
        
        //Map<Id,Id> topIds = AssetStructure.GetTopMultipleElements(allAssetIds);

        List<Asset> productAssets = new List<Asset>();
        
        Map<string,List<SBQQ__Subscription__c>> assetIdListSubDateMap = new Map<string,List<SBQQ__Subscription__c>>();
        /*if(topIds != null){
            productAssets = [Select id,Name,Product2.Name,Parent_Asset__c,AccountID,Date_Removed__c,InstallDate,Sequence_No__c,Installed_By__c,
                             Parent_Asset__r.Parent_Asset__c,
                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__c,
                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c,
                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c,
                             (SELECT Id, Name,CreatedDate,Status__c,SBQQ__Contract__r.ContractNumber,SBQQ__Account__r.Name,SBQQ__Quantity__c,SBQQ__Product__r.Name,SBQQ__Product__c,Asset__c,Asset__r.Name,Traffic_Identifier__c,SBQQ__SubscriptionStartDate__c ,SBQQ__SubscriptionEndDate__c ,SBQQ__Product__r.Standard_Pricebook_Price__c,SBQQ__Product__r.CurrencyIsoCode 
                              From Subscriptions__r Order by CreatedDate ASC) from Asset 
                             where Id=:topIds.values() OR Parent_Asset__c =: topIds.values() OR
                             Parent_Asset__r.Parent_Asset__c =: topIds.values() OR
                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: topIds.values() OR
                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: topIds.values() OR
                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: topIds.values()];
        }*/
        Asset inputAsset = new Asset(Id = (Id)assetId);
        productAssets = getAssetHierarchyAndSubs(inputAsset);
        Set<SBQQ__Subscription__c> lstSubscriptionNames = New Set<SBQQ__Subscription__c>();
        if(productAssets.size() > 0){
            for(Asset productAsset : productAssets){
                assetIdListSubDateMap.put(productAsset.Name,new List<SBQQ__Subscription__c>());
                for(SBQQ__Subscription__c objSubscription : productAsset.Subscriptions__r){
                    lstSubscriptionNames.add(objSubscription);
                }
            }
        }
        if(lstSubscriptionNames.size() > 0){
            for(SBQQ__Subscription__c  sub :lstSubscriptionNames){
                if(assetIdListSubDateMap.containsKey(sub.Asset__r.Name)){
                    assetIdListSubDateMap.get(sub.Asset__r.Name).add(sub);       
                }
                
            }
        }
        return assetIdListSubDateMap;
    }
    
    /*
Method to get the List of Asset Hierarchy records passing any Asset of the Hierarchy structure.
*/
    @AuraEnabled
    public static List<Asset> getAssetHierarchy(string assetId) {
        set<id> allAssetIds = new set<id>();
        //Map<Id,Id> topIds = new Map<Id,Id>();
        List<Asset> productAssets = new List<Asset>();
        //Map<Id,SBQQ__Subscription__c> subIdSubDateMap = new Map<Id,SBQQ__Subscription__c>();
        if(assetId != ''){
            allAssetIds.add(assetId);
            /*topIds = AssetStructure.GetTopMultipleElements(allAssetIds);
            if(topIds != null){
                productAssets = [Select id,Name,Product2.Name,Product2.RecordType.Name,Root_Asset__c,Root_Asset__r.Name,Root_Asset__r.HTS_REady__c,Root_Asset__r.Product2.Name,AccountID,Date_Removed__c,InstallDate,Sequence_No__c,Installed_By__c,Item_Description__c,Account_Name__c,
                                 System_Warranty_Start_Date__c,HTS_REady__c,Item__c,HTS_Conversion_Kit__c,Warranty_Start_Date__c ,Warranty_Type__c,System_Asset_Warranty__c,Product_Registration__r.Name,Product_Registration__c,Warranty_Period_Months__c,Warranty_End_Date__c,
                                 Parent_Asset__r.Parent_Asset__c,
                                 Parent_Asset__r.Parent_Asset__r.Parent_Asset__c,
                                 Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c,
                                 Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c
                                 from Asset where Id=:topIds.values() OR Parent_Asset__c =: topIds.values() OR
                                 Parent_Asset__r.Parent_Asset__c =: topIds.values() OR
                                 Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: topIds.values() OR
                                 Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: topIds.values() OR
                                 Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: topIds.values()];
            }*/
            Asset inputAsset = new Asset(Id = (Id)assetId);
            productAssets = getAssetHierarchyAndSubs(inputAsset);
        }
        return productAssets;
    }
    
    /*
Method to get the Case Asset Move list of specific Asset and Case record.
*/
    @AuraEnabled
    public static List<Case_Asset_Moves__c> getCaseAssetMove(string assetId,string caseId){
        List<Case_Asset_Moves__c> latestCaseAssetMove = new List<Case_Asset_Moves__c>();
        latestCaseAssetMove  = [SELECT Case_Number__c, Asset_Being_Installed__c, Asset_Being_Removed__c, 
                                Case_Asset_Account__c,Asset_Being_Removed__r.Name,Asset_Being_Installed__r.Name, Asset_Being_Installed_Account__c, Asset_Being_Removed_Account__c, Asset_Being_Removed_KVH_P_N__c, 
                                Asset_Installed_KVH_P_N__c, Asset_Installed_Product_Name__c, Asset_Removed_Product_Name__c, Service_Partner__c, Replaced_by__c, 
                                CreatedDate, CreatedById, Name, Id FROM Case_Asset_Moves__c WHERE Case_Number__c =: caseId 
                                ORDER By CreatedDate DESC];
        return latestCaseAssetMove; 
    }
    
    
    /*
Method to search list of Asset by passing search Key Word of first 3 character of Asset Name.
*/
    @AuraEnabled
    public static List <Asset> fetchAsset(String searchKeyWord) {
        String searchKey = searchKeyWord + '%';
        List <Asset> returnList = new List <Asset> ();
        List <Asset> lstOfAsset = [select id, Name,Product2.Name,SerialNumber,InstallDate,Account_Name__c,Contact.Name,Date_Removed__c,Sequence_No__c,
                                   System_Warranty_Start_Date__c,HTS_REady__c,Item__c,HTS_Conversion_Kit__c,Warranty_Start_Date__c ,Warranty_Type__c,System_Asset_Warranty__c,Product_Registration__r.Name
                                   from Asset where Name LIKE: searchKey limit 25];
        if(lstOfAsset.size() > 0){
            for (Asset asst: lstOfAsset) {
                returnList.add(asst);
            }
        }
        return returnList;
    }
    
    
    /* 
Method to Replace/Add asset in the Asset Hierarchy.Also Create new case and case asset move record using the caseId and replaced asset Id.
*/
    @AuraEnabled
    public static void updateAssetReplacement(String caseId,Asset replacedAsset,Asset replacementAsset,string ReplacementType,string ServicePartner,string replacedby,string HTSReady,Asset antennaAsset) {
        system.debug('==replacementAsset =='+replacementAsset );
        system.debug('==replacedAsset=='+replacedAsset);
        system.debug('==caseId=='+caseId);
        system.debug('==ReplacementType=='+ReplacementType);
        system.debug('==antennaAsset=='+antennaAsset);
        
        if(replacedAsset != null && replacementAsset != null && caseId != null && replacementAsset!= null){
            List<Asset> updateListAsset = new List<Asset>();
            Case_Asset_Moves__c newCaseAssetMove = new Case_Asset_Moves__c();
            Case findCaseAssetName = new Case();
            findCaseAssetName = [Select id,Status,Asset_Account_Name__c,ParentId,CaseNumber,Asset.AccountID from Case where ID=: caseId];
            Asset antennaRootAsset = new Asset();
            
            ///////////////////// Airtime Case subscription
            final Id AirtimeServiceCase_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airtime Service').getRecordTypeId();
            
            Map<string,List<SBQQ__Subscription__c>> checkSubsLst = new Map<string,List<SBQQ__Subscription__c>>();
            checkSubsLst = Update_AssetSubscriptionController.getAllSubscription(replacedAsset.Id);
            List<Case> finalCaseUpdatelst = new List<Case>();
            Case newCase = new Case();
            
            if(checkSubsLst.values().size() > 0){
                List<Case> parentAirtimeCase = new List<Case>([SELECT Id,RecordtypeId,CaseNumber FROM Case WHERE Id =: findCaseAssetName.ParentId AND Status != 'Closed' AND RecordtypeId =: AirtimeServiceCase_RECORD_TYPE_ID ORDER BY CreatedDate Desc LIMIT 1]);
                if(parentAirtimeCase.size() > 0){
                    CaseComment csCommt = new CaseComment();
                    csCommt.ParentId = parentAirtimeCase[0].Id;
                    csCommt.CommentBody = 'The assets have been replaced on '+findCaseAssetName.CaseNumber+', where the replaced assets have related subscriptions that require review.';
                    insert csCommt;
                    parentAirtimeCase[0].Status = 'New Customer Comment'; 
                    finalCaseUpdatelst.add(parentAirtimeCase[0]);
                }
                else{
                    List<Case> childAirtimeCase = new List<Case>([SELECT Id,RecordtypeId,CaseNumber,ParentId FROM Case WHERE ParentId =: findCaseAssetName.Id AND Status != 'Closed' AND RecordtypeId =: AirtimeServiceCase_RECORD_TYPE_ID AND Subject=: 'Update Subscriptions for Replacement Assets' ORDER BY CreatedDate Desc LIMIT 1]);
                    if(childAirtimeCase.size() > 0)
                        newCase.Id = childAirtimeCase[0].Id;
                        
                        newCase.RecordTypeId = AirtimeServiceCase_RECORD_TYPE_ID;
                        newCase.Subject = 'Update Subscriptions for Replacement Assets';
                        newCase.ParentId = caseId;
                        newCase.AssetId = replacedAsset.Id;
                        newCase.Origin = 'Web';
                        newCase.Status = 'New';
                        newCase.Description = 'Review the Subscriptions that are Replacement Assets for the Parent Case. They will need to be updated as the asset was moved to other subscriptions.';
                        finalCaseUpdatelst.add(newCase);
                }
            }
            else{
                List<Case> childCase = new List<Case>([SELECT Id FROM Case WHERE ParentId =: caseId AND Status != 'Closed' ORDER BY CreatedDate Desc LIMIT 1]);
                if(childCase.size() > 0)
                    newCase.Id = childCase[0].Id; 
                newCase.RecordTypeId = AirtimeServiceCase_RECORD_TYPE_ID;
                newCase.Subject = 'Update Subscriptions for Replacement Assets';
                newCase.ParentId = caseId;
                newCase.AssetId = replacedAsset.Id;
                newCase.Origin = 'Web';
                newCase.Status = 'New';
                newCase.Description = 'Review the Subscriptions that are Replacement Assets for the Parent Case. They will need to be updated as the asset was moved to other subscriptions.';
                finalCaseUpdatelst.add(newCase);
            }
            system.debug(finalCaseUpdatelst+'=======');
            ///////////////////// End of Airtime Case subscription/////////////////////
            
            /////////////////// Logic for Warranty///////////////////////
            if(replacedAsset.Product_Registration__c != null)
                replacementAsset.Product_Registration__c = replacedAsset.Product_Registration__c;
            else
                replacementAsset.Product_Registration__c = null;
            if(replacementAsset.Warranty_Period_Months__c != null)
                replacementAsset.Warranty_Period_Months__c = String.valueof(replacementAsset.Warranty_Period_Months__c );
            
            ////////////////////Update Asset Logic////////////////////////
            if(ReplacementType == 'Add'){
                replacementAsset.Parent_Asset__c = replacedAsset.Id;
                updateListAsset.add(replacementAsset);
                
                newCaseAssetMove.Case_Asset_Account__c = findCaseAssetName.Asset.AccountID; 
                newCaseAssetMove.Asset_Being_Installed__c = replacementAsset.Id;
                newCaseAssetMove.Case_Number__c = findCaseAssetName.Id; 
                if(ServicePartner != '')
                    newCaseAssetMove.Service_Partner__c = ServicePartner; 
                if(replacedby!= '')
                    newCaseAssetMove.Replaced_by__c= replacedby; 
            }
            else if(ReplacementType == 'Replace'){
                newCaseAssetMove.Case_Asset_Account__c = findCaseAssetName.Asset.AccountID; 
                newCaseAssetMove.Asset_Being_Installed__c = replacementAsset.Id;
                newCaseAssetMove.Asset_Being_Removed__c = replacedAsset.id;
                newCaseAssetMove.Case_Number__c = findCaseAssetName.Id;
                if(ServicePartner != '') 
                    newCaseAssetMove.Service_Partner__c = ServicePartner; 
                if(replacedby!= '')
                    newCaseAssetMove.Replaced_by__c= replacedby; 
                replacementAsset.Parent_Asset__c = replacedAsset.Parent_Asset__c;
                replacementAsset.Date_Removed__c = null;
                replacedAsset.Parent_Asset__c = null;
                replacedAsset.AccountID = system.label.ReplaceMentAssetAccountID;
                replacedAsset.Date_Removed__c = system.today();
                
                updateListAsset.add(replacementAsset);
                updateListAsset.add(replacedAsset);
            }
            /////////////////Code to implement sequence no/////////////////////
            if(updateListAsset[0].Sequence_No__c != null){
                Map<String, Id> mapSequence = New Map<String, Id>();
                for(Asset objAsset : [SELECT Id, Sequence_No__c FROM Asset WHERE Parent_Asset__c =: updateListAsset[0].Parent_Asset__c AND Sequence_No__c != null])
                    mapSequence.put(objAsset.Sequence_No__c, objAsset.Id);
                while(mapSequence.containsKey(updateListAsset[0].Sequence_No__c))
                    updateListAsset[0].Sequence_No__c = String.valueOf(integer.valueOf(updateListAsset[0].Sequence_No__c) + 1);
            }
            
            //////////////////HTS Asset Upgrade Code////////////////////
            if(antennaAsset != null && ReplacementType == 'Replace'){
                antennaRootAsset = [Select Id,Name From Asset where Id =: antennaAsset.Root_Asset__c];
                system.debug(antennaRootAsset +'===========antennaRootAsset ');
                system.debug('replacement: ' + replacementAsset.Item__c + ' replaced: ' + replacedAsset.Item__c);
                if(HTSReady == 'not ready'){
                    if(!(antennaAsset.Name.contains('-HTS')))
                        antennaAsset.Name = antennaAsset.Name + ' -HTS';
                    if(!(antennaRootAsset.Name.contains('-HTS'))){
                        antennaRootAsset.Name = antennaRootAsset.Name  + ' -HTS';
                        updateListAsset.add(antennaRootAsset);
                    }
                    antennaAsset.HTS_REady__c = true;
                    newCaseAssetMove.HTS_Upgrade_Confirmed__c = true;
                    updateListAsset.add(antennaAsset);
                }
                else if(HTSReady == 'ready' && (replacementAsset.Item__c.contains('02-2204-02') && replacedAsset.Item__c.contains('02-2204-02'))){
                    system.debug('Processing TWO I2CMs');
                    newCaseAssetMove.HTS_Upgrade_Confirmed__c = false;
                }
                else if(HTSReady == 'ready'){
                    newCaseAssetMove.HTS_Upgrade_Confirmed__c = true;
                }
            }
            
            ///////////////////////////////////////DML statements
            
            upsert finalCaseUpdatelst;
            insert newCaseAssetMove;
            update updateListAsset;
        }
    }
    @AuraEnabled
    public static string Service_I2CMFieldSwapMethod(Asset replacedAsset,Asset replacementAsset) {
        Service_I2CMFieldSwap.log  = Service_I2CMFieldSwap.swapI2CMs(replacedAsset,replacementAsset);
        return string.valueof(Service_I2CMFieldSwap.log.success);
    }
    @AuraEnabled
    public static Map<string,Asset> validateHTSAsset(string replaceAssetId) {
        set<id> allAssetIds = new set<id>();
        //Map<Id,Id> topIds = new Map<Id,Id>();
        List<Asset> productAssets = new List<Asset>();
        //set<Id> keyValue = topIds.keyset();
        Map<string,Asset> mapMessageAsset = new Map<string,Asset>();

        Asset sisterAsset = [SELECT Root_Asset__c FROM Asset WHERE ID =: replaceAssetId];
        String rootAssetId;
        if(sisterAsset.Root_Asset__c == null){
          rootAssetId = replaceAssetId;
        }else{
          rootAssetId = sisterAsset.Root_Asset__c;
        }
        if(replaceAssetId != ''){
            productAssets = [Select Id,Name,Product2Id,Root_Asset__r.Name,Root_Asset__c,Product2.Name,Parent_Asset__c,AccountID,Date_Removed__c,InstallDate,Sequence_No__c,Installed_By__c,Item_Description__c,Account_Name__c,Item__c,
                             System_Warranty_Start_Date__c,HTS_REady__c,Warranty_Start_Date__c ,HTS_Conversion_Kit__c,Warranty_Type__c,System_Asset_Warranty__c,Product_Registration__r.Name,Product_Registration__c,Warranty_Period_Months__c,Warranty_End_Date__c
                             FROM Asset 
                             WHERE (Root_Asset__c =: rootAssetId OR Id =: rootAssetId) AND
                             (Root_Asset__c !=: replaceAssetId OR Id !=: replaceAssetId) AND
                             (Item__c LIKE '02-1925%' OR Item__c LIKE '02-1925-01%')];
            system.debug('Product Assets: ' + productAssets);
            Asset abcAsset = new Asset();
            if(productAssets.size() == 1){
                for(Asset asst : productAssets){
                    if(asst.HTS_REady__c == true ){
                        mapMessageAsset.put('ready',asst);
                    } 
                    else if(asst.HTS_Conversion_Kit__c != null && asst.HTS_Conversion_Kit__c != 'Not Applicable')
                        mapMessageAsset.put('not ready',asst);
                }
            }
            else if(productAssets.size() > 1)
                mapMessageAsset.put('more',abcAsset );
            else
                mapMessageAsset.put('not found',abcAsset );
        }
        system.debug('======@@@==========='+mapMessageAsset);
        return mapMessageAsset;
    }
    /*
/*
/*
Method to delete the Asset from Asset Hierarchy.
*/
    @AuraEnabled
    public static void deleteAssetReplacement(Asset assetDelete,String caseId) {
        Case_Asset_Moves__c newCaseAssetMove = new Case_Asset_Moves__c();
        if(assetDelete != null && caseId != null){
            Case findCaseAssetName = new Case();
            findCaseAssetName = [Select id,Asset_Account_Name__c,CaseNumber,Asset.AccountID from Case where ID=: caseId]; 
            if(findCaseAssetName != null){   
                newCaseAssetMove.Case_Asset_Account__c = findCaseAssetName.Asset.AccountID; 
                newCaseAssetMove.Asset_Being_Removed__c = assetDelete.Id;
                newCaseAssetMove.Case_Number__c = findCaseAssetName.Id; 
            }            
            assetDelete.Parent_Asset__c  = null;
            assetDelete.AccountID = system.label.ReplaceMentAssetAccountID;
            assetDelete.Date_Removed__c = system.today();
            assetDelete.Sequence_No__c = null;
            if(newCaseAssetMove != null){
                update assetDelete;
                insert newCaseAssetMove;
            }
        }
    }
    
    /*
Method to update Subscription from Update_Subscription Page
*/
    @AuraEnabled
    public static void updateSubscriptionList(List<SBQQ__Subscription__c> listSubscription) {
        if(listSubscription.size() > 0 && listSubscription != null){
            update listSubscription;
        }
    }
    
    @AuraEnabled
    public static boolean getObjectAccessMethod() {
        return Schema.sObjectType.SBQQ__Subscription__c.isupdateable();
    }
    
    @AuraEnabled
    public static Map<String,String> getWarrantypeValues() {
        Map<String,String> mapWarrantype = new Map<String,String>();
        for(Warranty_Asset_Field__c warrtyAsst : Warranty_Asset_Field__c.getAll().values()){
            if(warrtyAsst.Warranty_Period_Months__c != null)
                mapWarrantype.put(warrtyAsst.Warranty_Type__c,warrtyAsst.Warranty_Period_Months__c);
            else
                mapWarrantype.put(warrtyAsst.Warranty_Type__c,'');
        }
        system.debug(mapWarrantype+'===mapWarrantype===');
        return mapWarrantype;
    }
  /*****************************************************************************
   *Private Methods
   ****************************************************************************/
  @testVisible private static list<Asset> getAssetHierarchyAndSubs(Asset rawDomeAsset){
    /*****************************************************************************
     *This Private method returns a Hierarhcical list of Assets,
     * any and all subsriptions related to the Asset hierarchy,
     * Given a single Asset. Inserts a Case if exception thrown.
     *
     *Uses the legacy "custom" Asset Hierarchy fields
     * (Root_Asset__c, Parent_Asset__c)
     ****************************************************************************/
    String methodName = 'getAssetHierarchyAndSubs(Asset rawDomeAsset)';
    try{
      Asset sisterAsset = [SELECT Root_Asset__c FROM Asset WHERE ID =: rawDomeAsset.Id];
      String rootAssetId;
      if(sisterAsset.Root_Asset__c == null){
        rootAssetId = rawDomeAsset.Id;
      }else{
        rootAssetId = sisterAsset.Root_Asset__c;
      }
      List<Asset> assetHierarchy = [SELECT id, Name, Product2.Name, Parent_Asset__c, AccountID, Date_Removed__c,
                                      InstallDate,Sequence_No__c,Installed_By__c, Product2.RecordType.Name,
                                      Root_Asset__c,Root_Asset__r.Name,Root_Asset__r.HTS_REady__c,
                                      Root_Asset__r.Product2.Name, Item_Description__c,Account_Name__c,
                                      System_Warranty_Start_Date__c,HTS_REady__c,Item__c,HTS_Conversion_Kit__c,
                                      Warranty_Start_Date__c ,Warranty_Type__c,System_Asset_Warranty__c,
                                      Product_Registration__r.Name,Product_Registration__c,Warranty_Period_Months__c,
                                      Warranty_End_Date__c,
                                    (SELECT Id, Name,CreatedDate,Status__c,SBQQ__Contract__r.ContractNumber,SBQQ__Account__r.Name,SBQQ__Quantity__c,SBQQ__Product__r.Name,SBQQ__Product__c,Asset__c,Asset__r.Name,Traffic_Identifier__c,SBQQ__SubscriptionStartDate__c ,SBQQ__SubscriptionEndDate__c ,SBQQ__Product__r.Standard_Pricebook_Price__c,SBQQ__Product__r.CurrencyIsoCode 
                                      FROM Subscriptions__r ORDER BY CreatedDate ASC) 
                                    FROM Asset 
                                    WHERE Root_Asset__c =: rootAssetId OR ID =: rootAssetId];
      //See HTSSF-607... needs to query for and return All the Assets in the Asset Hierarchy related to the input Asset. 
      return assetHierarchy;
    }catch(Exception e){
      Case myExceptionCase = serviceResults.createExceptionCase(e);
      myExceptionCase.Description = 'Update_AssetSubscriptionController failed. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage();
      myExceptionCase.Subject = 'Exception caught in Update_AssetSubscriptionController.' + methodName;
      insert myExceptioncase;
      return new list<Asset>();
    }
  }
}