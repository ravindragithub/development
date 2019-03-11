/***********************************************************************************************************************
Name: ReplacementAsset 
Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
Purpose: This is used to test "Replacement Of Asset" class 
------------------------------------------------------------------------------------------------------------------------
Utilized in(Called in):
-----------------------

========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0     Gopi Kishore. K      18/09/2014       Initial Development                                   
***********************************************************************************************************************/

public class ReplacementAsset{
    
    public list<AssetStructure.ObjectStructureMap> ObjectStructure{get;set;}
    public Case CaseAsset                      {get;set;}
    public String assetNameFromVF              {get;set;}
    public String oldAssetIDFromVF             {get;set;}
    public String oldAssetNameFromVF           {get;set;}
    public String finaltableString             {get;set;}
    public Boolean Initial                     {get;set;}
    public String revertAsset                  {get;set;}
    public List<ReplacedAssets> replacements   {get;set;}
    public ID CaseID                           {get;set;}
    public List<Asset> SearchAssets            {get;set;}
    public String searchAssetName              {get;set;}
    public String assetID                      {get;set;}
    public Case_Asset_Moves__c cam             {get;set;}
    public List<Case_Asset_Moves__c> caseAssets{get;set;}
    public boolean assetsReplaced              {get;set;}
    public String assetTypes                   {get;set;}
    public Asset newAsset                      {get;set;}
    
    public String caseAssetName;
    Case findCaseAssetName;
    public boolean currentURl                   {get;set;}
    
    
    //Final Section LabelVariables
    
    public String headerTitle                    {get;set;}
    public String leftTitle                      {get;set;}
    public String rightTitle                     {get;set;}
    public boolean buttonHide                    {get;set;}
    public String leftType                       {get;set;}
    public String rightType                      {get;set;}
    private Set<Asset> NewAssets;
    private Set<Asset> OldAssets;
    //private Id TopLevelNewAsset;
    public ReplacementAsset(){
        assetsReplaced = true;
        cam = New Case_Asset_Moves__c();
        CaseID = apexpages.currentpage().getparameters().get('CID'); 
        if(apexpages.currentpage().getparameters().get('nonce')!=null)
            currentURl = true;
        
        findCaseAssetName = [Select id,Asset_Account_Name__c,Asset.AccountID from Case where ID=:CaseID]; 
        if(findCaseAssetName.Asset_Account_Name__c!=null && findCaseAssetName.Asset_Account_Name__c!=''){
            caseAssetName = findCaseAssetName.Asset_Account_Name__c;
        }
        CaseAsset = new Case();
        replacements = new List<ReplacedAssets>();
        AssetStructure ASE = new AssetStructure();
        ObjectStructure = ASE.formatObjectStructure(apexpages.currentpage().getparameters().get('assetId'));
        caseAssetMoves(CaseID);
    }
    
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
    
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
    
    Set<ID> oldAssetIds = new Set<ID>();
    Set<ID> newAssetIds = new Set<ID>();
    Set<ID> allAssetIds = new Set<ID>();
    Map<ID,ID> replacementAssets = new Map<ID,ID>();
    
    ID newAssetID;
    public void passSelectedID(){
        buttonHide  = true;
        if(assetTypes!='childAsset'){
            headerTitle = 'Replacement Assets';
            leftTitle   = 'Replaced Values';
            rightTitle  = 'Replacement Values';
            buttonHide  = true;
            leftType = 'Replaced';
            rightType = 'Replacemet'; 
        }else{
            headerTitle = 'Assets Added';
            leftTitle   = 'Parent Asset';
            rightTitle  = 'Child Asset';
            leftType    = 'Parent';
            rightType   = 'Child'; 
            buttonHide  = false;
        }
        
        assetsReplaced = false;
        Initial = true;
        String caseNumber = apexpages.currentpage().getparameters().get('CN');
        
        newAssetID = assetID;
        ID oldAssetID = oldAssetNameFromVF;
        list<ID> AssetIds = new List<ID>();
        
        AssetIds.add(newAssetID);
        AssetIds.add(oldAssetID);
        
        //For Final Replacment
        
        oldAssetIds.add(oldAssetID);
        newAssetIds.add(newAssetID);
        
        allAssetIds.add(oldAssetID);
        allAssetIds.add(newAssetID);
        Map<Id,Id> topIds = AssetStructure.GetTopMultipleElements(allAssetIds);
        //TopLevelNewAsset = topIds.get(newAssetID);
        replacementAssets.put(newAssetID,oldAssetID);
        Map<ID,String> productAssetName = New Map<ID,String>();
        Map<ID,Set<SBQQ__Subscription__c>> assetSubscriptionName = New Map<ID,Set<SBQQ__Subscription__c>>();
        List<Asset> productAssets = [Select id,Name,Product2.Name,Parent_Asset__c,AccountID,Date_Removed__c,InstallDate,Sequence_No__c,Installed_By__c,
                                     Parent_Asset__r.Parent_Asset__c,
                                     Parent_Asset__r.Parent_Asset__r.Parent_Asset__c,
                                     Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c,(SELECT Id,Name,SBQQ__Product__r.Name, SBQQ__ContractNumber__c,SBQQ__Account__r.Name,Asset__c,SBQQ__StartDate__c,SBQQ__EndDate__c From Subscriptions__r) from Asset 
                                     where Id=:topIds.values() OR Parent_Asset__c =: topIds.values() OR
                                     Parent_Asset__r.Parent_Asset__c =: topIds.values() OR
                                     Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: topIds.values() OR
                                     Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: topIds.values() OR
                                     Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: topIds.values()];
        
        Id requiredId ;
        NewAssets = New Set<Asset>();
        OldAssets = New Set<Asset>();
        for(Asset productAsset:productAssets){
            productAssetName.put(productAsset.id,productAsset.Product2.Name);
            Set<SBQQ__Subscription__c> lstSubscriptionNames = New Set<SBQQ__Subscription__c>();
            for(SBQQ__Subscription__c objSubscription:productAsset.Subscriptions__r)
                lstSubscriptionNames.add(objSubscription);
            if(productAsset.id == topIds.get(oldAssetID) || productAsset.Parent_Asset__c == topIds.get(oldAssetID) ||
               productAsset.Parent_Asset__r.Parent_Asset__c == topIds.get(oldAssetID) ||
               productAsset.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c == topIds.get(oldAssetID) ||
               productAsset.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c == topIds.get(oldAssetID) ||
               productAsset.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c == topIds.get(oldAssetID) ){
                   requiredId = oldAssetID;
                   OldAssets.add(productAsset);
               }else{
                   requiredId = newAssetID;
                   NewAssets.add(productAsset);
               }
            if(assetSubscriptionName.containsKey(requiredId))
                assetSubscriptionName.get(requiredId).addAll(lstSubscriptionNames);
            else
                assetSubscriptionName.put(requiredId,lstSubscriptionNames);
        }
        ReplacedAssets newReplacementAsset = new ReplacedAssets(caseNumber,caseAssetName,oldAssetIDFromVF,productAssetName.get(oldAssetID),assetNameFromVF,productAssetName.get(newAssetID),assetSubscriptionName.get(oldAssetID),assetSubscriptionName.get(newAssetID),NewAssets);
        replacements.add(newReplacementAsset);
    }
    
    public void replacingAsset(){
        for(integer i=0;i<replacements.size();i++){
            if(replacements[i].ReplacedAsset == revertAsset){
                replacements.remove(i);
            }
            if(replacements.size()==0){
                Initial = false;
            }
        }
    }
    public boolean isShowSubscriptions{set;get;}
    public void FinalReplacement(){
        isShowSubscriptions = true;
        assetsReplaced = true;
        List<Asset> productAssets = [Select id,Name,Product2.Name,Parent_Asset__c,AccountID,Date_Removed__c,InstallDate,Sequence_No__c,Installed_By__c,(SELECT id, Name, Asset__c FROM Subscriptions__r) from Asset where Id=:allAssetIds];
        Map<Id,Asset> getOldValues = new Map<Id,Asset>();
        List<Case_Asset_Moves__c> caseAssetMoves = new List<Case_Asset_Moves__c>();
        Id newCaseAssetId;
        
        for(Asset storeValues:productAssets){
            getOldValues.put(storeValues.id,storeValues);
        } 
        for(Asset finalUpdates:productAssets){
            
            if(newAssetIds.contains(finalUpdates.id)){
                
                finalUpdates.AccountID         = getOldValues.get(replacementAssets.get(finalUpdates.id)).AccountID;
                if(assetTypes!='childAsset'){
                    finalUpdates.Parent_Asset__c   = getOldValues.get(replacementAssets.get(finalUpdates.id)).Parent_Asset__c;
                    finalUpdates.Date_Removed__c   = null;
                    finalUpdates.InstallDate       = system.today();
                    finalUpdates.Installed_By__c   = userinfo.getFirstName() + userinfo.getLastName(); 
                    if(getOldValues.get(replacementAssets.get(finalUpdates.id)).Sequence_No__c != null){
                        finalUpdates.Sequence_No__c    = String.valueOf(integer.valueOf(getOldValues.get(replacementAssets.get(finalUpdates.id)).Sequence_No__c) + 1);
                    }
                }else{
                    finalUpdates.Parent_Asset__c = replacementAssets.get(finalUpdates.id);
                    finalUpdates.AccountID       = system.label.ReplaceMentAssetAccountID;
                    finalUpdates.Date_Removed__c = system.today();
                }
                
                Case_Asset_Moves__c createdAssetMove;
                if(assetTypes!='childAsset'){
                    createdAssetMove = createAssetMove(finalUpdates.ID,getOldValues.get(replacementAssets.get(finalUpdates.id)).ID);
                }else{
                    createdAssetMove = createAssetMove(finalUpdates.id,null);
                    finalUpdates.InstallDate       = system.today();
                    finalUpdates.Installed_By__c   = userinfo.getFirstName() + userinfo.getLastName();  
                }
                caseAssetMoves.add(createdAssetMove);
                newCaseAssetId = getOldValues.get(replacementAssets.get(finalUpdates.id)).ID;
            }
        }
        
        if(assetTypes!='childAsset'){
            for(Asset finalUpdates:productAssets){
                if(oldAssetIds.contains(finalUpdates.id)){
                    finalUpdates.AccountID                     = system.label.ReplaceMentAssetAccountID;
                    finalUpdates.Date_Removed__c               = system.today();
                    finalUpdates.Parent_Asset__c               = null;
                    finalUpdates.Sequence_No__c                = null;
                    finalUpdates.Service_Activation_Date__c    = null;
                }
            }
        }
        
        try{
            if(productAssets.size()>0){
                update productAssets;
                if(assetTypes!='childAsset'){
                    caseAssetMoveUpdatesonChildAssets(newAssetID);
                }
            }
            
            if(caseAssetMoves.size()>0){
                insert caseAssetMoves;
            }
        }catch(System.DmlException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error:'+e.getDmlMessage(0)));
        }
        try{
            caseAssetMoves(CaseID);
            SubmitSubscriptions();
            replacements = new List<ReplacedAssets>();
            passSelectedID();
            Initial = false;
            if(replacements[0].OldSubscriptionNames.size()>0 && newCaseAssetId != null){}
            CreateCaseforReplacementAssets(newCaseAssetId,CaseID);
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error:'+e));
        }
    }
    
    public integer totalCount{get;set;}
    public void SearchAsset(){
        try{
            AggregateResult results = database.query('SELECT COUNT(id) result FROM Asset WHERE Name LIKE \'%' + searchAssetName + '%\'');
            totalCount = Integer.valueOF(results.get('result'));
            
            String assetSearch = 'Select id,Name,Product2.Name,SerialNumber,InstallDate,Account.Name,Contact.Name,Date_Removed__c from Asset Where Name LIKE \'%' + searchAssetName + '%\' LIMIT 20';
            SearchAssets = database.Query(assetSearch);
        }Catch(Exception soqlException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error:'+soqlException));
        }
    }
    //While Replacing updating to allchild assets-Updated on 02/26/2016
    public void caseAssetMoveUpdatesonChildAssets(ID newAssetID){
        List<Asset> allRelatedChildassets = [SELECT id FROM Asset WHERE Parent_Asset__c =: newAssetID OR
                                             Parent_Asset__r.Parent_Asset__c =: newAssetID OR
                                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: newAssetID OR
                                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: newAssetID OR
                                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: newAssetID];
        
        for(Asset defaultvalues:allRelatedChildassets){
            defaultvalues.Date_Removed__c   = null;
            defaultvalues.InstallDate       = system.today();
            defaultvalues.Installed_By__c   = userinfo.getFirstName() + userinfo.getLastName(); 
        }         
        update allRelatedChildassets;                                        
    }
    //<!-- ------------------------- -->
    
    public void ClearAsset(){
        SearchAssets = new List<Asset>();
        totalCount   = 0;
    }
    
    public void removeAsset(){
        try{
            id removeAssetId = Apexpages.currentPage().getParameters().get('firstParam');
            
            Asset assetReplace = [SELECT id,parent_asset__c FROM Asset WHERE id=:removeAssetId];
            assetReplace.parent_asset__c = null;
            assetReplace.AccountID       = system.label.ReplaceMentAssetAccountID;
            assetReplace.Date_Removed__c = system.today();
            
            update assetReplace;
            
            Case_Asset_Moves__c newCaseAssetMoveDelete = createAssetMove(null,assetReplace.id);
            
            insert newCaseAssetMoveDelete;
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'DML Error Contact SYSTEM ADMIN'+e));
        }
    }
    
    public Case_Asset_Moves__c createAssetMove(ID beingInstallID,ID beingRemovedID){
        Case_Asset_Moves__c assetMoves = new Case_Asset_Moves__c();
        assetMoves.Asset_Being_Installed__c = beingInstallID;
        assetMoves.Asset_Being_Removed__c   = beingRemovedID;
        assetMoves.Case_Number__c           = CaseID;
        assetMoves.Replaced_by__c           = cam.Replaced_by__c;
        assetMoves.Service_Partner__c       = cam.Service_Partner__c;
        
        if(findCaseAssetName.Asset.AccountID!=null){
            assetMoves.Case_Asset_Account__c    = findCaseAssetName.Asset.AccountID;
        }
        return assetMoves;
    }
    
    
    public void ReverseSubscriptionMove(){
        list<SBQQ__Subscription__c> lstSubscriptionNew = New list<SBQQ__Subscription__c>();
        list<SBQQ__Subscription__c> lstSubscriptions = [SELECT ID, Asset__c, Old_Asset__c, Last_Asset__c FROM SBQQ__Subscription__c WHERE Asset__c in: NewAssets AND Old_Asset__c in: OldAssets];
        for(SBQQ__Subscription__c Sub: lstSubscriptions){
            Sub.Last_Asset__c = Sub.Asset__c;
            Sub.Asset__c = Sub.Old_Asset__c;
            Sub.Old_Asset__c = null;
            lstSubscriptionNew.add(Sub);
        }
        if(lstSubscriptionNew.size() > 0)
            Update lstSubscriptionNew;
        replacements = new List<ReplacedAssets>();
        passSelectedID();
        Initial = false;
    }
    
    public void SubmitSubscriptions(){
        list<SBQQ__Subscription__c> lstSubscriptions = [SELECT ID, Asset__c, Old_Asset__c FROM SBQQ__Subscription__c WHERE Old_Asset__c != null LIMIT 10000];
        for(SBQQ__Subscription__c Subscription : lstSubscriptions){
            Subscription.Old_Asset__c = null; 
        }
        if(lstSubscriptions.size() > 0)
            Update lstSubscriptions;
    }
    
    public void SubscriptionUpdateBySelection(){
        list<SBQQ__Subscription__c> lstSubscriptions = New list<SBQQ__Subscription__c>();
        Map<Id,SBQQ__Subscription__c> mapSubscriptions = New Map<Id,SBQQ__Subscription__c>([SELECT ID, Asset__c, Old_Asset__c,Last_Asset__c FROM SBQQ__Subscription__c WHERE Id in :replacements[0].OldSubscriptionNames]);
        for(SBQQ__Subscription__c Sub:replacements[0].OldSubscriptionNames){
            if(Sub.Asset__c != null){
                if(mapSubscriptions.containsKey(Sub.Id)){
                Sub.Old_Asset__c = mapSubscriptions.get(Sub.Id).Asset__c;
                Sub.Last_Asset__c = mapSubscriptions.get(Sub.Id).Asset__c;    
                }
                lstSubscriptions.add(Sub);
            }
        }
        if(lstSubscriptions.size()>0)
            Update lstSubscriptions;
        replacements = new List<ReplacedAssets>();
        passSelectedID();
        Initial = false;
    }
    @future
    public static void CreateCaseforReplacementAssets(ID tempId,ID CaseIDHere){
        final Id AirtimeServiceCase_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airtime Service').getRecordTypeId();
        Case newCase = new Case();
        newCase.RecordTypeId = AirtimeServiceCase_RECORD_TYPE_ID;
        newCase.Subject = 'Update Subscriptions for Replacement Assets';
        newCase.ParentId = CaseIDHere;
        newCase.AssetId = tempId;
        newCase.Origin = 'Web';
        newCase.Status = 'New';
        newCase.Description = 'Review the Subscriptions that are Replacement Assets for the Parent Case. They will need to be updated as the asset was moved to other subscriptions.';
        insert newCase;
        system.debug('I AM NEW caase==>'+newCase);
    }
    
    public void SubscriptionMove(){
        if(caseAssets.size() > 0){
            if(caseAssets[caseAssets.size()-1].Asset_Being_Removed__c != null){
                SubmitSubscriptions();
                oldAssetNameFromVF = caseAssets[caseAssets.size()-1].Asset_Being_Removed__c;
                assetID =  caseAssets[caseAssets.size()-1].Asset_Being_Installed__c != null ? caseAssets[caseAssets.size()-1].Asset_Being_Installed__c : apexpages.currentpage().getparameters().get('assetId');
                passSelectedID();
                Initial = false;
                isShowSubscriptions = true;
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'Unable to Show the Subscriptions, Asset Being Removed Is Null'));
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'Unable to Show the Subscriptions, Assets not moved for this Case'));
        }
    }
    public class ReplacedAssets{
        public String CaseName                    {get;set;}
        public String caseAssetName               {get;set;}
        public String ReplacedAsset               {get;set;}
        public String ReplacedProduct             {get;set;}
        public String ReplacemetAsset             {get;set;}
        public String ReplacementProduct          {get;set;}
        public Set<SBQQ__Subscription__c> OldSubscriptionNames   {get;set;}
        public Set<SBQQ__Subscription__c> NewSubscriptionNames   {get;set;}
        public List<selectOption> NAoptions {get;set;}
        public ReplacedAssets(String fromCase,String fromcaseAssetName,String RA,String RP,String RPA,String RPAP,Set<SBQQ__Subscription__c> OSN,Set<SBQQ__Subscription__c> NSN,Set<Asset> NAsset){
            CaseName             = fromCase;
            caseAssetName        = fromcaseAssetName;
            ReplacedAsset        = RA;
            ReplacedProduct      = RP;
            ReplacemetAsset      = RPA;
            ReplacementProduct   = RPAP;
            OldSubscriptionNames    = OSN;
            NewSubscriptionNames    = NSN;
            NAoptions = New List<selectOption>();
            NAoptions.add(new Selectoption('', 'None'));
            for(Asset N:NAsset)
                NAoptions.add(new Selectoption(N.Id, N.Name));
        }
    }  
    
    public List<Case_Asset_Moves__c> caseAssetMoves(Id caseId){
        caseAssets = [SELECT id,Asset_Being_Removed__c,Asset_Being_Removed_KVH_P_N__c,Asset_Being_Installed__c,Asset_Installed_KVH_P_N__c FROM Case_Asset_Moves__c WHERE Case_Number__c=:caseId ORDER BY CreatedDate];
        if(caseAssets.size()==0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'Info:Assets not moved for this Case'));
            return null;
        }
        return caseAssets;
    }
    
}