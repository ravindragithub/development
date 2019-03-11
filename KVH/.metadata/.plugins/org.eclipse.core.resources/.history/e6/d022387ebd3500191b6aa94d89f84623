public class Update_or_AddSubscriber
{
    public Boolean platformAssetAccount{get;set;}
    public Boolean AssociateAssetPlatform{get;set;}
    public Boolean AssociateAssetplatformSalesforce{get;set;}
    
    public ID CaseID{get;set;}
    public Update_or_AddSubscriber(ApexPages.StandardController controller) 
    {
        platformAssetAccount = false;
        AssociateAssetPlatform = false;
        
        CaseID = apexpages.currentpage().getparameters().get('id');
        
        Case checkCase = [select id,Search_for_or_create_Platform_Account_in__c,Platform_Asset_Account__c,Associate_Asset_to_Platform_in_Salesforc__c from case where id=:CaseID];
        
        if(checkCase.Platform_Asset_Account__c == null)
        {
            platformAssetAccount   = true;
        }
        
        if(!checkCase.Search_for_or_create_Platform_Account_in__c)
        {
            AssociateAssetPlatform = true;
        }
        
        if(!checkCase.Associate_Asset_to_Platform_in_Salesforc__c)
        {
            AssociateAssetplatformSalesforce = true;
        }
        
        
    } 
}