global class UAccountShareButton {
        
    webservice static string run(id accountId)
    {
        
        Account a = [Select id, name, Apply_Custom_Sharing__c, parent.Apply_Custom_Sharing__c 
                     From Account 
                     where Id = :accountId];
       
        if(a.Apply_Custom_Sharing__c == false)
        {
            return 'Apply Custom Sharing is set to false';  
        }

        id runForAccount = getTopAccount(accountId);


        set <id> accounts = new set <id>();
        accounts.add(accountId);
        
        UAccountShareJKT.createAccountShare(accounts,false);
        return 'Done (Parent = ' + runForAccount + ')';
    }
    
    
    public static id getTopAccount (id AccountId)
    {
        Account a = [Select id,
                            Apply_Custom_Sharing__c,
                            parent.Id,
                            parent.Apply_Custom_Sharing__c,
                            parent.parent.Id,
                            parent.parent.Apply_Custom_Sharing__c,
                            parent.parent.parent.Id,
                            parent.parent.parent.Apply_Custom_Sharing__c,
                            parent.parent.parent.parent.Id,
                            parent.parent.parent.parent.Apply_Custom_Sharing__c,
                            parent.parent.parent.parent.parent.Id,
                            parent.parent.parent.parent.parent.Apply_Custom_Sharing__c
                     From Account 
                     where Id = :accountId];
        
        if(a.Apply_Custom_Sharing__c == true && a.parent.Apply_Custom_Sharing__c == false)
        {
            system.debug('----------1');
            return a.id;
        }
        else if(a.parent.Apply_Custom_Sharing__c == true && a.parent.parent.Apply_Custom_Sharing__c == false)
        {
            return a.parent.id;
        }
        else if(a.parent.parent.Apply_Custom_Sharing__c == true && a.parent.parent.parent.Apply_Custom_Sharing__c == false)
        {
            return a.parent.parent.id;
        }
        else if(a.parent.parent.parent.Apply_Custom_Sharing__c == true && a.parent.parent.parent.parent.Apply_Custom_Sharing__c == false)
        {
            return a.parent.parent.parent.id;
        }
        else if(a.parent.parent.parent.parent.Apply_Custom_Sharing__c == true && a.parent.parent.parent.parent.parent.Apply_Custom_Sharing__c == false)
        {
            return a.parent.parent.parent.parent.id;
        }
        else if(a.parent.parent.parent.parent.parent.Apply_Custom_Sharing__c == true && a.parent.parent.parent.parent.parent.parent.Apply_Custom_Sharing__c == false)
        {
            return getTopAccount(a.parent.parent.parent.parent.parent.id);
        }
        
        return a.id;
        
    }

}