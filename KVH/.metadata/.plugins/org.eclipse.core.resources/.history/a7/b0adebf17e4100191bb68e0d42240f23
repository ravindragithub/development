global with sharing class CCDS_WebtopServices 
{
    webservice static boolean AddAccount(Id AccountID, String accountType) 
    {   
        if(string.isEmpty(accountID) || string.isEmpty(accountType)) return false;
        return CCDS_CustomerHelper.AddAccount(AccountID, accountType);
    }
       
    webservice static boolean UpdateAccount(Id AccountID, String accountType)
    {
        if(string.isEmpty(accountID)) return false;
        return CCDS_CustomerHelper.UpdateAccount(AccountID, accountType);
    }
    
    webservice static boolean AddContact(Id AccountID, String accountType) 
    {   
        if(string.isEmpty(accountID)) return false;
        return CCDS_CustomerHelper.AddContact(AccountID, accountType);
    }
   
}