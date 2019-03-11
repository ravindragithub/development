public class Find_or_Create_Contract_or_Service {

    public boolean createAccountinSalesforce{get;set;}
    public boolean associateAssetPaltform{get;set;}
    public boolean searchPlatformAssetAccount{get;set;}
    public boolean addorUpdateContactRoles{get;set;}
    public Id CaseID{get;set;}
    
    public Find_or_Create_Contract_or_Service(ApexPages.StandardController controller) {
        CaseID = apexpages.currentpage().getparameters().get('id');
         Case checkCase = [select id,Create_Account_in_Salesforce__c,Associate_Asset_to_Platform_in_Salesforc__c,Platform_Asset_Account__c
                            ,Add_or_Update_Contacts_and_Roles__c from case where id=:CaseID];
         
         CreateAccountinSalesforce = checkCase.Create_Account_in_Salesforce__c;
         AssociateAssetPaltform    = checkCase.Associate_Asset_to_Platform_in_Salesforc__c;
         addorUpdateContactRoles   = checkCase.Add_or_Update_Contacts_and_Roles__c;
         if(checkCase.Platform_Asset_Account__c==null)
         CreateAccountinSalesforce = true;
    }

}