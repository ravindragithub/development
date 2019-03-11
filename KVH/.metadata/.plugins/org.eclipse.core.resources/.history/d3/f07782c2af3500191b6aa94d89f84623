public class Add_or_Update_Airtime_ContactRoles {
    
    public boolean CreateAccountinSalesforce{get;set;}
    public boolean AssociateAssetPaltform{get;set;}
    public boolean searchPlatformAssetAccount{get;set;}
    
    public Id CaseID{get;set;}
    
    public Add_or_Update_Airtime_ContactRoles(ApexPages.StandardController controller) {
         CaseID = apexpages.currentpage().getparameters().get('id');
         Case checkCase = [select id,Create_Account_in_Salesforce__c,Associate_Asset_to_Platform_in_Salesforc__c,Platform_Asset_Account__c from case where id=:CaseID];
         
         CreateAccountinSalesforce = checkCase.Create_Account_in_Salesforce__c;
         AssociateAssetPaltform    = checkCase.Associate_Asset_to_Platform_in_Salesforc__c;
         
         if(checkCase.Platform_Asset_Account__c==null)
         CreateAccountinSalesforce = true;
    }

}