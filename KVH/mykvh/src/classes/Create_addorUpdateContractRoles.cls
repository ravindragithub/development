/***********************************************************************************************************************
Name: Create_addorUpdateContractRoles
Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
Purpose: 1) This is used to create new child Asset for existing case Asset.
------------------------------------------------------------------------------------------------------------------------
Utilized in(Called in):
-----------------------

========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0     Gopi Kishore. K      21/05/2014       Initial Development 
1.1     Gopi Kishore. K      09/11/2014       Modified due to contractServices Contracts Not Visible when pageLoads.                
***********************************************************************************************************************/
public class Create_addorUpdateContractRoles{
    
    public List<contract> subscriberContracts{get;set;}
    public ID CaseId{get;set;}
    public ID assetID{get;set;}
    public string enteredText2{get;set;}
    public ID AccountID{get;set;}
    public string BillingAccountID{get;set;}
    public List<Contract> lstContract{get;set;}
    //boolean variable for newContractBlock
    
    public boolean newContractBlock{get;set;}
    
    //Visible block for subscriber block
    
    public boolean contractSubscriberBlock{get;set;}
    
    //input variables
    public String recordTypeName{get;set;}
    public String accountName{get;set;}
    public String customCallAccountID{get;set;}
    public String contractOwner{get;set;}
    
    
    
    Case contractCases;
    public Create_addorUpdateContractRoles(){
        newContractBlock = false;
        contractSubscriberBlock = true;
        
        List<Id> accIds = new List<Id>();
        List<Id> assetIds = new List<Id>();
        CaseID = apexpages.currentpage().getparameters().get('caseid');
        
        contractCases = [select id,AccountID,AssetID,Modem_IP_2__c,Account.name,Custom_Call_Acct_ID__c,Account.Custom_Call_Acct_ID__c,Billing_Account__r.Billing_Account_ID__c,
                         Billing_Account__c,Account.owner.name,Platform_Asset_Account__c from Case where id=:CaseID];
        AccountID = contractCases.AccountID;
        assetID = contractCases.AssetID;
        if(contractCases.AccountID!=null){
            accIds.add(contractCases.AccountID);
        }
        
        if(contractCases.Modem_IP_2__c != null){
            assetIds.add(contractCases.Modem_IP_2__c);
        }
        
        if(contractCases.AssetID != null){
            AssetStructure assetAllIDs = new AssetStructure();
            LIST<AssetStructure.ObjectStructureMap> allAssetHirarchy = assetAllIDs.formatObjectStructure(contractCases.AssetID);
            for(AssetStructure.ObjectStructureMap storeAsstIds:allAssetHirarchy){
                assetIds.add(storeAsstIds.Asset.ID);
            }
            //assetIds.add(contractCases.AssetID);//Previous Code
        }
        
        recordTypeName = 'Airtime Contract';
        accountName = contractCases.Account.Name;
        //customCallAccountID = contractCases.Account.Custom_Call_Acct_ID__c;
        contractOwner = contractCases.Account.owner.Name;
        
        
        if(contractCases.Platform_Asset_Account__c != null){
            accIds.add(contractCases.Platform_Asset_Account__c);
        }
        Set<ID> contractIds = new Set<ID>();
        List<Contracted_Services__c> listContractServices  = [Select Contract__c From Contracted_Services__c WHERE Asset__c=:assetIds];
        for(Contracted_Services__c contractIDsFromService:listContractServices){
            if(contractIDsFromService.Contract__c != null)
                contractIds.add(contractIDsFromService.Contract__c);
        }
        subscriberContracts = [select id,ContractNumber,status,Account.Name,Account.Custom_Call_Acct_ID__c,RecordType.Name,StartDate,EndDate,owner.Name,Account.Id,
                               (Select id,Name,BTN__c,Line_Type__c,Overage_Rate__c,Overage_Std_Price__c,Approved__c ,Overage_Rate_Plan__c,Service_Item__r.Identifier_Type__c,Service_End_Date__c,Service_Item__c,Service_Std_Price__c,Charge__c,Asset__c,Asset__r.Account.name,Effective_Date__c,Terminated_Date__c from Contracted_Service__r ORDER BY Effective_Date__c)
                               from contract where (AccountID=:accIds OR Asset__c=:assetIds OR ID=:contractIds) ORDER BY ContractNumber];
        
        if(subscriberContracts.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'No Contract Found for Subscriber'));
        }
    }
    
    public void SelectedContractService(){
        if(Apexpages.currentPage().getParameters().get('firstParam') != null){
            contract statusUpdate = [select id,status from contract where id=:Apexpages.currentPage().getParameters().get('firstParam')];
            statusUpdate.status = 'Activated';
            update statusUpdate;
        }
    }
    
    //By Creating New Contracted Services
    
    public Contracted_Services__c newContractedService{get;set;}
    public Boolean newContractedServiceBlock{get;set;}
    public void NewContractedService(){
        newContractedServiceBlock = true;
        contractSubscriberBlock = false;
        newContractedService = new Contracted_Services__c();
        /*AssetStructure topAsset = New AssetStructure();
Asset topLevelAsset;
if(contractCases.AssetID != null){
String topAssetID = topAsset.GetTopElement(contractCases.AssetID);
topLevelAsset = [select id,Name,Product2.KVH_Product_Family__r.Name from Asset where id=:topAssetID];
}*/
        newContractedService.Contract__c = Apexpages.currentPage().getParameters().get('secondParam');
        newContractedService.Data_Rate_Plan__c = true;
    }
    
    
    public void populateCharge(){
        system.debug(newContractedService.Service_Item__c);
        list<product2> standardPriceBook = [select id,Standard_Pricebook_Price__c from product2 where id=:newContractedService.Service_Item__c];
        if(standardPriceBook.size()>0){
            newContractedService.Charge__c = standardPriceBook[0].Standard_Pricebook_Price__c;
        }else{
            newContractedService.Charge__c = 0.0;
        }
    }
    
    //Reference Variable for changing ORPCharge
    public decimal ORPChargeInital{get;set;}
    public String OverageRatePlan{get;set;}
    public product2 productIT{get;set;}
    public void populateORP(){
        Asset assetProductIT = new Asset();
        product2 product2Name = new Product2();
        if(newContractedService.Asset__c!=null){
            assetProductIT = [select id,Product2.Identifier_Type__c from Asset where id=:newContractedService.Asset__c];
            newContractedService.Line_Type__c = assetProductIT.Product2.Identifier_Type__c;
            productIT = new Product2();
            productIT.Identifier_Type__c = assetProductIT.Product2.Identifier_Type__c;
        }
        if(newContractedService.Service_Item__c!=null){
            product2Name = [select id,name from product2 where id=:newContractedService.Service_Item__c];
        }
        
        if(product2Name.name!=null && product2Name.name!=''){
            List<Airtime_Charges_with_Plans__c> ACP = [select id,Airtime_Charge__c,Overage_Rate_Plan__c,Overage_Rate_Plan__r.name,Overage_Rate_Plan__r.Standard_Pricebook_Price__c from Airtime_Charges_with_Plans__c where Airtime_Charge__r.name=:product2Name.name];
            system.debug('ACP Size==>'+ACP.size());
            for(Airtime_Charges_with_Plans__c ORPchk:ACP){
                if(assetProductIT.Product2.Identifier_Type__c != null){
                    if(ORPchk.Overage_Rate_Plan__r.name.contains(assetProductIT.Product2.Identifier_Type__c)){
                        newContractedService.Overage_Rate_Plan__c = ORPchk.Overage_Rate_Plan__c;
                        OverageRatePlan = '$'+ORPchk.Overage_Rate_Plan__r.Standard_Pricebook_Price__c;
                        newContractedService.Overage_Rate__c = ORPchk.Overage_Rate_Plan__r.Standard_Pricebook_Price__c;
                        ORPChargeInital = ORPchk.Overage_Rate_Plan__r.Standard_Pricebook_Price__c;
                    }
                }
            }
        }
    }
    
    
    public void insertContractedServiceFunction(){
        product2 productName = [select id,name from product2 where id=:newContractedService.Service_Item__c];
        newContractedService.Name = productName.Name;
        insert newContractedService;
    }
    
    public void customerSignedFunction(){
        system.debug('I AM HERE:'+newContractRecord.CustomerSignedID);
    }
    public contract newContractRecord{get;set;}
    public void newContractBlockFunction(){
        newContractRecord = new contract();
        newContractRecord.Auto_Renewal__c = true;
        newContractRecord.AccountID = AccountID;
        newContractBlock = true;
        contractSubscriberBlock = false;
        //New code for SSA - 212
        if(contractCases.Custom_Call_Acct_ID__c != null){
            List<Billing_Account__c> caseBillingAcc = new List<Billing_Account__c>([Select Id,name,Billing_Account_ID__c,Account__c from Billing_Account__c where Billing_Account_ID__c =: contractCases.Custom_Call_Acct_ID__c]);
            if(caseBillingAcc.size() > 0){
                BillingAccountID = caseBillingAcc[0].Billing_Account_ID__c;
                newContractRecord.Billing_Account__c = caseBillingAcc[0].Id;  
                //Get value for MSA
                set<Id> parentIds = New set<Id>();
                List<Account> allRelatedParentAccts = new List<Account>([SELECT id,parentID,parent.parentID,parent.parent.parentID,
                                                                         parent.parent.parent.parentID,parent.parent.parent.parent.parentID
                                                                         FROM Account WHERE ID=: caseBillingAcc[0].Account__c LIMIT 49999]);
                if(allRelatedParentAccts.size() > 0){
                    parentIds.add(allRelatedParentAccts[0].id);
                    parentIds.add(allRelatedParentAccts[0].parentID);
                    parentIds.add(allRelatedParentAccts[0].parent.parentID);
                    parentIds.add(allRelatedParentAccts[0].parent.parent.parentID);
                    parentIds.add(allRelatedParentAccts[0].parent.parent.parent.parentID);
                    parentIds.add(allRelatedParentAccts[0].parent.parent.parent.parent.parentID);
                }
                lstContract = new List<Contract>([Select id,Name,AccountId,Status,Recordtype.Name,Owner.Name,Account.Name,ContractNumber from Contract where (AccountId =: parentIds AND Recordtype.Name = 'Master Services Agreement' AND (Status != 'Expired' OR Status != 'Terminated'))]);
            }
        }
        newContractRecord.Installation__c = contractCases.Platform_Asset_Account__c;
    }
    
    public void activateContractService(){
        
    }
    
    public pageReference insertContractFunction(){
        system.debug(newContractRecord.ContractTerm);
        system.debug(newContractRecord.StartDate);
        system.debug(newContractRecord.CustomerSignedID);
        
        List<Case> updateCase = new List<Case>([Select id,Billing_Account__c from Case Where id =: contractCases.id limit 1]);
        updateCase[0].Billing_Account__c = newContractRecord.Billing_Account__c;
        try{
            newContractRecord.Contract_Type__c = 'Airtime';
            insert newContractRecord;
            system.debug('===newContractRecord==='+newContractRecord);
            upsert updateCase[0];
            pageReference pagRef = new pageReference('/apex/Create_addorUpdateContractRoles?caseid='+CaseID);
            pagRef.setRedirect(true);
            return pagRef;
        }catch(Exception ae){
            system.debug('System Exception ::'+ae);
            return null;
        }
    }
    public void MSAContractMethod(){
    }
    public pageReference returnToCase(){
        pageReference pagRef = new pageReference('/'+CaseID);
        return pagRef;
    }
}