public class AccountShare_PortalContact_BatchUtility {
    public static List<AccountShare> createAccountShare(set<id> accountIds){
        List <AccountShare> accSharesCreate = new List <AccountShare>();
        Map<Id, User> portalUserMap;
        Map<Id,set<Id>> userToAcctLstMap = new Map<Id,set<Id>>();
        Map<Id, Account> accountOwnerMap = new Map<Id, Account>();
        
        //Code logic starts here
        Map<Id,Account> relatedAccount = New Map<Id,Account>([Select id,Name,parentID,OwnerId,parent.parentID,parent.parent.parentID,parent.parent.parent.parentID,
                                                              parent.parent.parent.parent.parentID From Account
                                                              Where id = : accountIds OR
                                                              parentID   =: accountIds OR
                                                              parent.parentID  =: accountIds OR
                                                              parent.parent.parentID   =: accountIds OR
                                                              parent.parent.parent.parentID  =: accountIds OR
                                                              parent.parent.parent.parent.parentID   =: accountIds]);
        system.debug(relatedAccount.size()+'====relatedAccount==='+relatedAccount);
        if(relatedAccount.keySet().size() > 0){
            for (Account acct : relatedAccount.values() ) {
                accountOwnerMap.put(acct.Id, acct);
            }
            portalUserMap = new Map<Id, User>([Select id, accountId, profileid From user
                                               Where accountId=:relatedAccount.keySet() AND isPortalEnabled = true AND isActive = true AND contactId != null]);
            if(portalUserMap != null){
                for(User u : portalUserMap.values()){
                    if(userToAcctLstMap.containsKey(u.accountId)){                
                        userToAcctLstMap.get(u.accountId).add(u.Id);
                    }else{
                        userToAcctLstMap.put(u.accountId,new set<Id>{u.Id});
                    }            
                }
            }
        }
        
        for(Account acc : relatedAccount.values()){
            if(userToAcctLstMap.containskey(acc.Id)){
                for(Id usrId : userToAcctLstMap.get(acc.Id)){
                    AccountShareProfiles__c asp1 = AccountShareProfiles__c.getInstance(portalUserMap.get(usrId).profileid);
                    if(asp1 != null){
                        if(accountOwnerMap.get(acc.Id).OwnerId != usrId){
                            AccountShare newShare = UAccountShareJKT_Utility.DMLAccountShare(asp1,acc.Id,usrId);
                            accSharesCreate.add(newShare);
                        }
                    } 
                }
            }
            if(userToAcctLstMap.containskey(acc.parentID)){
                for(Id usrId : userToAcctLstMap.get(acc.parentID)){
                    AccountShareProfiles__c asp1 = AccountShareProfiles__c.getInstance(portalUserMap.get(usrId).profileid);
                    if(asp1 != null){
                        if(accountOwnerMap.get(acc.Id).OwnerId != usrId){
                            AccountShare newShare = UAccountShareJKT_Utility.DMLAccountShare(asp1,acc.Id,usrId);
                            accSharesCreate.add(newShare);
                        }
                    } 
                }
            }
            if(userToAcctLstMap.containskey(acc.parent.parentID)){
                for(Id usrId : userToAcctLstMap.get(acc.parent.parentID)){
                    AccountShareProfiles__c asp1 = AccountShareProfiles__c.getInstance(portalUserMap.get(usrId).profileid);
                    if(asp1 != null){
                        if(accountOwnerMap.get(acc.Id).OwnerId != usrId){
                            AccountShare newShare = UAccountShareJKT_Utility.DMLAccountShare(asp1,acc.Id,usrId);
                            accSharesCreate.add(newShare);
                        }
                    } 
                }
            }
            if(userToAcctLstMap.containskey(acc.parent.parent.parentID)){
                for(Id usrId : userToAcctLstMap.get(acc.parent.parent.parentID)){
                    AccountShareProfiles__c asp1 = AccountShareProfiles__c.getInstance(portalUserMap.get(usrId).profileid);
                    if(asp1 != null){
                        if(accountOwnerMap.get(acc.Id).OwnerId != usrId){
                            AccountShare newShare = UAccountShareJKT_Utility.DMLAccountShare(asp1,acc.Id,usrId);
                            accSharesCreate.add(newShare);
                        }
                    } 
                }
            }
            if(userToAcctLstMap.containskey(acc.parent.parent.parent.parentID )){
                for(Id usrId : userToAcctLstMap.get(acc.parent.parent.parent.parentID )){
                    AccountShareProfiles__c asp1 = AccountShareProfiles__c.getInstance(portalUserMap.get(usrId).profileid);
                    if(asp1 != null){
                        if(accountOwnerMap.get(acc.Id).OwnerId != usrId){
                            AccountShare newShare = UAccountShareJKT_Utility.DMLAccountShare(asp1,acc.Id,usrId);
                            accSharesCreate.add(newShare);
                        }
                    } 
                }
            }
            if(userToAcctLstMap.containskey(acc.parent.parent.parent.parent.parentID )){
                for(Id usrId : userToAcctLstMap.get(acc.parent.parent.parent.parent.parentID )){
                    AccountShareProfiles__c asp1 = AccountShareProfiles__c.getInstance(portalUserMap.get(usrId).profileid);
                    if(asp1 != null){
                        if(accountOwnerMap.get(acc.Id).OwnerId != usrId){
                            AccountShare newShare = UAccountShareJKT_Utility.DMLAccountShare(asp1,acc.Id,usrId);
                            accSharesCreate.add(newShare);
                        }
                    } 
                }
            }
        }    
        system.debug(accSharesCreate.size()+'====accSharesCreate==='+accSharesCreate);
        return accSharesCreate;
    }
}