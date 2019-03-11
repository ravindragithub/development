public class CaseAssetPageController
{
    public Boolean platformAssetAccount{get;set;}
    public Boolean AssociateAssetPlatform{get;set;}
    public ID CaseID{get;set;}
    public CaseAssetPageController(ApexPages.StandardController controller) 
    {
        platformAssetAccount = false;
        AssociateAssetPlatform = false;
        
        CaseID = apexpages.currentpage().getparameters().get('id');
        
        Case checkCase = [select id,Search_for_or_create_Platform_Account_in__c,Platform_Asset_Account__c from case where id=:CaseID];
        
        if(checkCase.Platform_Asset_Account__c == null)
        {
            platformAssetAccount   = true;
        }
        if(checkCase.Search_for_or_create_Platform_Account_in__c)
        {
            AssociateAssetPlatform = false;
        }else
        {
            AssociateAssetPlatform = true;
        }
    } 
}