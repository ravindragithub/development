public without sharing class myKVH_AccountHierarchyController {     
    /***********************************************
        Name        :    getBillingAccountList
        Description :    Method to construct the wrapper to Implement Account Fleet functionality in LTE Activation Form						 
    ************************************************/
    @AuraEnabled
    public static List<accountHierarchyWrapper> getBillingAccountList() {
        User loggedInUser = [Select Id,Name,ContactId,AccountId From User Where Id =: UserInfo.getUserId()];
        List<Account> accListHierarchyLst = new List<Account>();
        List<Id> accListId = new List<Id>();
        Set<Id> customerbillingIds = new Set<Id>();
        Set<Id> parentCorpbillingIds = new Set<Id>();
        List<accountHierarchyWrapper> accWrapList = new List<accountHierarchyWrapper>();
        Set<Id> corporateIds = new Set<Id>();
        List<customerAccountListWrapper> customerTempOrphanWrap = new List<customerAccountListWrapper>();
        
        //Get account hierarchyList
        accListHierarchyLst = [Select Id,Name,ParentId, Parent.ParentId,Parent.Parent.ParentId,Parent.Parent.Parent.ParentId,Parent.Parent.Parent.Parent.ParentId From Account
                               Where Id =: loggedInUser.AccountId OR ParentId =: loggedInUser.AccountId OR Parent.ParentId =: loggedInUser.AccountId OR Parent.Parent.ParentId =: loggedInUser.AccountId OR
                               Parent.Parent.Parent.ParentId =: loggedInUser.AccountId OR Parent.Parent.Parent.Parent.ParentId =: loggedInUser.AccountId];
        for(Account accLst : accListHierarchyLst)
            accListId.add(accLst.Id);
        //Get account Corporate CC Account Map
        Map<string,Billing_Account__c> corporatebillingAccMap = new Map<string,Billing_Account__c>([Select Id,Name,Corporate_CC_Account_Name__c,Account__c,RecordType.Name From Billing_Account__c 
                                                                                            Where Account__c =: accListId AND RecordType.Name = 'Corporate CC Account']);
        
        
        //Get account Customer CC Account Map
        Map<Id,Billing_Account__c> customerbillingAccMap = new Map<Id,Billing_Account__c>([Select Id,Name,Corporate_CC_Account_Name__c,Account__c,RecordType.Name,Billing_Account_ID__c From Billing_Account__c 
                                                                                           Where Account__c =: accListId AND RecordType.Name = 'Customer CC Account' ORDER  BY Corporate_CC_Account_Name__c]);
        for(Id tempBA : customerbillingAccMap.keySet() ){
            customerbillingIds.add(tempBA);
            parentCorpbillingIds.add(customerbillingAccMap.get(tempBA).Corporate_CC_Account_Name__c);
        }
            
        
        //Get account Customer CC Account's Contract Map
        Map<Id,Contract> customerbillingContractMap = new Map<Id,Contract>();
        for(Contract tempContract : [Select Id,Name,AccountId,Billing_Account__c,ContractNumber,Installation__r.Name,Installation__c From Contract Where Billing_Account__c  =: customerbillingIds AND Installation__c != null]){
            customerbillingContractMap.put(tempContract.Billing_Account__c,tempContract);
        }
        //Create wrapper list to display
        if(customerbillingAccMap.keyset().size() > 1){
            for(Billing_Account__c tempBACust : customerbillingAccMap.values()){
                if(customerbillingContractMap.containsKey(tempBACust.Id)){
                    accountHierarchyWrapper wrap = new accountHierarchyWrapper();
                    List<customerAccountListWrapper> custAccListWrap = new List<customerAccountListWrapper>();
                    if(corporatebillingAccMap.containsKey(tempBACust.Corporate_CC_Account_Name__c)){  
                        if(corporateIds.contains(tempBACust.Corporate_CC_Account_Name__c)){
                            for(accountHierarchyWrapper mainTemp : accWrapList){
                                if(mainTemp.unqiueNo == string.valueof(tempBACust.Corporate_CC_Account_Name__c)){
                                    customerAccountListWrapper childWrap = new customerAccountListWrapper();
                                    childWrap.customerAccount = tempBACust;
                                    childWrap.platformAccount = customerbillingContractMap.get(tempBACust.Id);                            
                                    mainTemp.customerAccountListWrap.add(childWrap);
                                }
                            }
                        }
                        else{
                            corporateIds.add(tempBACust.Corporate_CC_Account_Name__c);
                            wrap.unqiueNo = corporatebillingAccMap.get(tempBACust.Corporate_CC_Account_Name__c).Id;                            
                            wrap.typeOfWrapper = 'Multiple Customer';                    
                            wrap.corporateAccount = corporatebillingAccMap.get(tempBACust.Corporate_CC_Account_Name__c);
                            customerAccountListWrapper childWrap = new customerAccountListWrapper();
                            childWrap.customerAccount = tempBACust;                  
                            childWrap.platformAccount = customerbillingContractMap.get(tempBACust.Id);
                            List<customerAccountListWrapper> childTempWrap = new List<customerAccountListWrapper>();
                            childTempWrap.add(childWrap);
                            wrap.customerAccountListWrap = childTempWrap;
                        }
                    }
                    else{    
                        if(accWrapList.size() > 0){
                            for(accountHierarchyWrapper mainTemp : accWrapList){
                                if(mainTemp.unqiueNo == 'Orphan'){
                                    customerAccountListWrapper childWrap = new customerAccountListWrapper();
                                    childWrap.customerAccount = tempBACust;
                                    if(customerbillingContractMap.containskey(tempBACust.Id))
                                        childWrap.platformAccount = customerbillingContractMap.get(tempBACust.Id);
                                    customerTempOrphanWrap.add(childWrap);
                                }
                            }
                        }
                        else{
                            wrap.unqiueNo = 'Orphan';         
                            wrap.typeOfWrapper = 'Multiple Customer';   
                            wrap.corporateAccount = null;
                            customerAccountListWrapper childWrap = new customerAccountListWrapper();
                            childWrap.customerAccount = tempBACust;
                            if(customerbillingContractMap.containskey(tempBACust.Id))
                                childWrap.platformAccount = customerbillingContractMap.get(tempBACust.Id);
                            customerTempOrphanWrap.add(childWrap);
                        }
                    }
                    if(wrap.unqiueNo != '' && wrap.unqiueNo != null)
                        accWrapList.add(wrap);      
                }
                
            }
            //Create wrapper list to display for Orphan customer account
            if(accWrapList.size() > 0){
                for(accountHierarchyWrapper mainTemp : accWrapList){
                    if(mainTemp.unqiueNo == 'Orphan'){
                        mainTemp.customerAccountListWrap = customerTempOrphanWrap;
                    }
                }            
            }
        }
        else if(customerbillingAccMap.keyset().size() == 1){            
            for(Billing_Account__c tempBACust : customerbillingAccMap.values()){
                if(customerbillingContractMap.containsKey(tempBACust.Id)){
                    accountHierarchyWrapper wrap = new accountHierarchyWrapper();
                    wrap.unqiueNo = 'Orphan Cust Account';
                    wrap.customerSingleAccount = tempBACust;
                    wrap.platformCustAccount = customerbillingContractMap.get(tempBACust.Id);
                    wrap.typeOfWrapper = 'Single Customer';                    
                    accWrapList.add(wrap);  
                } 
            }
        }
        
        if(corporatebillingAccMap != null){
            for(Id corpBA : corporatebillingAccMap.keyset()){
                if(
                    !parentCorpbillingIds.contains(corpBA) 
                ){
                    accountHierarchyWrapper wrap = new accountHierarchyWrapper();
                    wrap.unqiueNo = 'Orphan Corp Account';
                    wrap.corporateAccount = corporatebillingAccMap.get(corpBA);
                    wrap.typeOfWrapper = 'Multiple Corporate';                    
                    accWrapList.add(wrap);  
                }
            }
        }
        
        system.debug('==accWrapList==' + accWrapList);
        return accWrapList;
    }
    public class accountHierarchyWrapper{
        @AuraEnabled public string unqiueNo{get;set;}
        @AuraEnabled public string typeOfWrapper{get;set;}
        @AuraEnabled public Billing_Account__c corporateAccount{get;set;}
        @AuraEnabled public Billing_Account__c customerSingleAccount{get;set;}
        @AuraEnabled public List<customerAccountListWrapper> customerAccountListWrap{get;set;}
        @AuraEnabled public Contract platformCustAccount{get;set;}
    }
    public class customerAccountListWrapper{
        @AuraEnabled public Billing_Account__c customerAccount{get;set;}
        @AuraEnabled public Contract platformAccount {get;set;}
    }
}