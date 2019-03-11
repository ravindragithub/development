Public Class Add_New_Global_StaticIP{
    Public Id CaseID{get;set;}
    public Boolean accountValidate{get;set;}
    public Boolean assetValidate{get;set;}
    public Add_New_Global_StaticIP(ApexPages.StandardController CSC){
        CaseID = apexpages.currentpage().getparameters().get('id');
        Case checkCase = [select id,AccountId,AssetID from case where id=:CaseID];
        if(checkCase.AccountId==null){
            accountValidate = true;
        }
        
        if(checkCase.AssetID==null){
            assetValidate = true;
        }
    }
}