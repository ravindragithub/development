public class UAccountShareJKT{
    public static List<AccountShare> createAccountShare(set<id> accounts,Boolean frombatchClass){
        
        //Variable Declartion
        List<id> CollectionAccID = New List<id>();
        Set<id> onlyAccIds = New Set<id>();
        list<Account> allAccts = New List<Account>();
        set<String> parentIds = New set<String>();
        List <AccountShare> sharesToCreate = new List <AccountShare>();
        List<Account> allRelatedChildAccts = New List<Account>();
        Account allRelatedParentAccts = new Account();
        List<Account> allFinalParents = New List<Account>();
        String CurentID;
        integer finalDMLCount = 0;
        List<User> usrLst = new List<User>();
        Map<Id, Account> accountMap = new Map<Id, Account>();
        
        Map<String,set<id>> relatedcontacts = New Map<String,set<id>>();
        //Get the Account Id for which batch will run
        if(! accounts.isEmpty()){
            CollectionAccID.addAll(accounts);
            CurentID = String.valueOF(CollectionAccID[0]).substring(0,15);    
        }
        if(CurentID != null){       
            //Code to get all related Child Accounts
            allRelatedChildAccts = [SELECT id,parentID,parent.parentID,parent.parent.parentID,parent.parent.parent.parentID,
                                    parent.parent.parent.parent.parentID FROM Account
                                    WHERE parentID   =: CurentID OR
                                    parent.parentID  =: CurentID OR
                                    parent.parent.parentID   =: CurentID OR
                                    parent.parent.parent.parentID  =: CurentID OR
                                    parent.parent.parent.parent.parentID   =: CurentID LIMIT 49999];                             
            System.Debug(allRelatedChildAccts.size()+'==@@allRelatedChildAccts@@=='+allRelatedChildAccts);
            //Code to add child Account in the main Account List
            allAccts.addAll(allRelatedChildAccts);
            
            for(Account acc : allRelatedChildAccts){
                onlyAccIds.add(acc.id);
            }
            
            //Code to get all related Parent Accounts
            allRelatedParentAccts = [SELECT id,parentID,parent.parentID,parent.parent.parentID,
                                     parent.parent.parent.parentID,parent.parent.parent.parent.parentID
                                     FROM Account WHERE ID=: CurentID LIMIT 49999];
            parentIds.add(allRelatedParentAccts.id);
            parentIds.add(allRelatedParentAccts.parentID);
            parentIds.add(allRelatedParentAccts.parent.parentID);
            parentIds.add(allRelatedParentAccts.parent.parent.parentID);
            parentIds.add(allRelatedParentAccts.parent.parent.parent.parentID);
            parentIds.add(allRelatedParentAccts.parent.parent.parent.parent.parentID);
            
            allFinalParents = [SELECT id,parentID,
                               parent.parentID,
                               parent.parent.parentID,
                               parent.parent.parent.parentID,
                               parent.parent.parent.parent.parentID 
                               FROM Account WHERE id=:parentIds LIMIT 49999];
            System.Debug(allFinalParents.size()+'==@@allFinalParents@@=='+allFinalParents);
            
            //Code to add Parent Account in the main Account List
            allAccts.addAll(allFinalParents);  
            
            //Code to get Set of all related Account IDs of the Hierarchy
            for(Account acc:allFinalParents){
                onlyAccIds.add(acc.id);
            } 
        }
        
        if(onlyAccIds.size() > 0){
            // Code for Insuffiecent access for cross referrence field
            List<Account> lstAccoutOwner = [SELECT Id, OwnerId FROM Account WHERE Id =: onlyAccIds];
            for (Account acct : lstAccoutOwner ) {
                accountMap.put(acct.Id, acct);
            }
            for(User u : [select id, accountId, profileid
                          from user
                          where accountId=:onlyAccIds
                          and isPortalEnabled = true
                          and isActive = true
                          and contactId != null]){
                              if(accountMap.get(u.accountId).OwnerId != u.id)
                              {                              
                                  AccountShareProfiles__c asp = AccountShareProfiles__c.getInstance(u.profileid);
                                  //Create share records for Portal Contact Related Accounts Only
                                  AccountShare newShare = new AccountShare();
                                  newShare.UserOrGroupId = u.id;
                                  newShare.AccountId = u.accountId;
                                  newShare.CaseAccessLevel = asp.caseAccess__c;
                                  newShare.AccountAccessLevel = asp.accountAccess__c;
                                  newShare.OpportunityAccessLevel = asp.opportunityAccess__c;
                                  sharesToCreate.add(newShare);
                              }
                          }
            system.debug(sharesToCreate+'===@@sharesToCreate'+sharesToCreate.size());
        }
        Map<id, User> UserMap = new Map<id, User>();
        if(onlyAccIds.size() > 0){
            for(User u : [Select id, name, profileid from user where isActive = true and accountId=:onlyAccIds]){
                userMap.put(u.id, u);
            }
            
            usrLst  = [select id, accountId, profileid
                       from user
                       where accountId=:onlyAccIds
                       and isPortalEnabled = true
                       and isActive = true
                       and contactId != null];
        }
        if(usrLst.size() > 0){
            for(user uRelates: usrLst){
                String accId = String.valueOF(uRelates.accountID);
                if(!relatedcontacts.containsKey(accId)){
                    Set<id> userGroupID = New Set<ID>();
                    userGroupID.add(uRelates.ID);
                    
                    relatedcontacts.put(accId,userGroupID);
                }else{
                    relatedcontacts.get(accId).add(uRelates.ID);
                }
            }                    
        }
        system.debug(allAccts+'==@@allAccts@@=='+allAccts.size());
        if(allAccts.size()> 0){
            for(Account acc: allAccts){
                set<id> finaluserIds = New set<id>();
                if(relatedcontacts.containsKey(String.valueOF(acc.id).substring(0,15))){
                    finaluserIds.addAll(relatedcontacts.get(String.valueOF(acc.id).substring(0,15)));
                }
                if(relatedcontacts.containsKey(acc.parentID)){
                    finaluserIds.addAll(relatedcontacts.get(acc.parentID));
                }
                if(relatedcontacts.containsKey(acc.parent.parentID)){
                    finaluserIds.addAll(relatedcontacts.get(acc.parent.parentID));
                }
                if(relatedcontacts.containsKey(acc.parent.parent.parentID)){
                    finaluserIds.addAll(relatedcontacts.get(acc.parent.parent.parentID));
                }
                if(relatedcontacts.containsKey(acc.parent.parent.parent.parentID)){
                    finaluserIds.addAll(relatedcontacts.get(acc.parent.parent.parent.parentID));
                }
                if(relatedcontacts.containsKey(acc.parent.parent.parent.parent.parentID)){
                    finaluserIds.addAll(relatedcontacts.get(acc.parent.parent.parent.parent.parentID));
                }
                
                for(id assignShareRules:finaluserIds){
                    if(userMap.containsKey(assignShareRules) && accountMap.get(acc.id).OwnerId != assignShareRules){
                        AccountShareProfiles__c asp = AccountShareProfiles__c.getInstance(userMap.get(assignShareRules).profileId);
                        AccountShare newShare = UAccountShareJKT_Utility.DMLAccountShare(asp,acc.id,assignShareRules);
                        sharesToCreate.add(newShare);
                    }
                }
            }
        }
        system.debug(sharesToCreate+'===>'+sharesToCreate.size());
        finalDMLCount = finalDMLCount + sharesToCreate.size();
        
        if(!frombatchClass){
            if(finalDMLCount>10000){
                AccountShareDML ASD = New AccountShareDML(sharesToCreate);
                DataBase.ExecuteBatch(ASD,5000);
            }else{
                DataBase.Insert(sharesToCreate,false);
            }
        }else{
            return sharesToCreate;
        }
        return null;
    }
}