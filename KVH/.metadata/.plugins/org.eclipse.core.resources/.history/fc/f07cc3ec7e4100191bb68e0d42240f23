Public Class Add_New_Global_StaticIPImplentation{
    Public List<SelectOption>             multipleRegion {get;set;}
    public String                         selectedRegion {get;set;}
    public Id                             CaseID         {get;set;}
    public List<Private_Static_IP__c>     psip           {get;set;}
    public Case                           caseDetails    {get;set;}
    public Asset                          findGlobalAsset{get;set;}
    public Install_Config__c              IC             {get;set;}
    public Asset                          replacements   {get;set;}
    
    //Hidding Variables
    
    public Boolean                        installConfig  {get;set;}
    public Boolean                        privateStaticIP{get;set;}
    public Boolean                        globalIPAsset  {get;set;}
    public Boolean                        assetHirarchy  {get;set;}
    public Boolean                    replaceAssetSection{get;set;}
    public Boolean                     regionSelection   {get;set;}
    public Boolean                     typeOfUpdation    {get;set;}
    
    public Add_New_Global_StaticIPImplentation(){
                
        CaseID = apexpages.currentpage().getparameters().get('caseid');
        caseDetails = [SELECT id,AssetID,AccountID,Asset.AccountID FROM Case WHERE id=:CaseID];
        multipleRegion = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Private_Static_IP__c.Region__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        multipleRegion.add(new SelectOption('--None--', '--None--'));
        for( Schema.PicklistEntry f : ple){
          multipleRegion.add(new SelectOption(f.getLabel(), f.getValue()));
        }  
    }
    
    public void NewFunction(){
        assetHirarchy = false;
        typeOfUpdation = true;
        regionSelection = true;
    }
    
    public void RemoveFunction(){
        typeOfUpdation = false;
        regionSelection = false;
        privateStaticIP = false;
        installConfig = false;
        globalIPAsset = false;
        
        AssetStructure ASE = new AssetStructure();
        ObjectStructure = ASE.formatObjectStructure(caseDetails.AssetID);
        assetHirarchy = true;
    }
    
    
    public pageReference removeAsset(){
       try{
           
           id removeAssetId = Apexpages.currentPage().getParameters().get('Assetremove');
           
           Asset assetReplace = [SELECT id,parent_asset__c,AccountID,Name FROM Asset WHERE id=:removeAssetId];
           
           assetReplace.parent_asset__c = null;
           assetReplace.AccountID       = system.label.ReplaceMentAssetAccountID;
           assetReplace.Date_Removed__c = system.today();
           
           update assetReplace;
           
           List<Private_Static_IP__c> updateInstallConfig = [SELECT id,Install_Config__r.Inactive__c FROM Private_Static_IP__c where Name=:assetReplace.Name];
           if(updateInstallConfig.size()>0){
               updateInstallConfig[0].Install_Config__r.Inactive__c = true;
               updateInstallConfig[0].Inactive__c = true;
               updateInstallConfig[0].Install_Config__c = null;
               
               update updateInstallConfig[0];
               update updateInstallConfig[0].Install_Config__r;
           }
           
           
           Case_Asset_Moves__c assetMoves = new Case_Asset_Moves__c();
           assetMoves.Asset_Being_Removed__c   = removeAssetId;
           assetMoves.Case_Number__c           = CaseID;
           insert assetMoves;
           
           integer i = 0;
           
           AssetStructure ASE = new AssetStructure();
           ObjectStructure = ASE.formatObjectStructure(caseDetails.AssetID);
           
           for(AssetStructure.ObjectStructureMap findGlobalStaticRecs:ObjectStructure){
               if(findGlobalStaticRecs.asset.Item_Description__c == 'Global Static IP'){
                   i = i+1;
               }
           }
           
           if(i==0){
               pageReference pagref = New pageReference('/'+CaseID);
               return pagref;
           }else{
               return null;
           }
              
       }catch(Exception e){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception:'+e));
           return null;
       }
   }
   
    public List<Public_IP__c> privatePublicIps{get;set;}
    
    public void CreateInstallConfigRecord(){
        installConfig = true;
        IC = New Install_Config__c();
        IC.Asset__c = caseDetails.AssetID;
        IC.Account_Name__c = caseDetails.Asset.AccountID;
        IC.RecordTypeID = Schema.SObjectType.Install_Config__c.getRecordTypeInfosByName().get('Global Static IP').getRecordTypeId();
        
        privatePublicIps = [SELECT id,Name,Region__c FROM Public_IP__c WHERE Private_Static_IP__c=:psip[0].id];
        
        findGlobalIpAddress();
    }  
    String regionSelected;
    public void searchNextPrivateStaticIP(){
        try{
            psip = [SELECT id,Region__c,name,Static_IP_Type__c,Gateway__c,Subnet__c,InActive__c FROM Private_Static_IP__c WHERE (Install_Config__c=null AND Region__c=:selectedRegion AND Static_IP_Type__c=:'Global Static IP' AND InActive__c=:false) ORDER by Name LIMIT 1];
            
            if(psip.size()==0){
                psip = [SELECT id,Region__c,name,Static_IP_Type__c,Gateway__c,Subnet__c,InActive__c FROM Private_Static_IP__c WHERE (Install_Config__c=null AND Region__c=:selectedRegion AND Static_IP_Type__c=:'Global Static IP' AND InActive__c=:true) ORDER by Name LIMIT 1];
                privateStaticIP = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Private static IP not found'));
            }else{
                regionSelected = psip[0].Region__c;
                privateStaticIP = true;
            }
        }
        Catch(Exception e){
            privateStaticIP = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Private static IP not found'));
        }
    }
    
    public void findGlobalIpAddress(){
        try{
            findGlobalAsset = [SELECT id,Parent_Asset__c,Product2ID,Item__c,InstallDate,Name FROM Asset WHERE Name=:psip[0].Name];
            if(findGlobalAsset!=null){
                globalAssetupsertion(false,psip[0].Name,caseDetails.AssetID);
            }
        }Catch(Exception e){
            globalAssetupsertion(true,psip[0].Name,caseDetails.AssetID);
        }
    }  
   
    public list<AssetStructure.ObjectStructureMap> ObjectStructure{get;set;}
    public void saveAsset(){
        try{
            insert IC;
        
            psip[0].Install_Config__c = IC.id;
            update psip[0];
            
            IC = [SELECT name,Asset__c,Account_Name__c FROM Install_Config__c WHERE id=:IC.id];
            
            
            DataBase.Upsert(findGlobalAsset,false);
            AssetStructure ASE = new AssetStructure();
            ObjectStructure = ASE.formatObjectStructure(findGlobalAsset.id);
            assetHirarchy = true;
            globalIPAsset = false;
            findGlobalAsset = [SELECT id,Parent_Asset__c,Product2ID,Item__c,InstallDate,Name,Product2.Name FROM Asset WHERE Name=:psip[0].Name];
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Exception occured please contact system admin'));
        }
    }
    
    
    public void replacementAsset(){
        replaceAssetSection = true;
        ID assetId = Apexpages.currentPage().getParameters().get('firstParam');
        replacements = [SELECT id,Name,Product2.Name,AccountID,Parent_Asset__c,Sequence_No__c  FROM ASSET WHERE id=:assetId];
    }
    
    
    public pageReference finalReplacementAsset(){
       List<Asset> replacementAssets = New List<Asset>();
       
       findGlobalAsset.AccountID         = replacements.AccountID;
       findGlobalAsset.Parent_Asset__c   = replacements.Parent_Asset__c;
       findGlobalAsset.Date_Removed__c   = null;
       findGlobalAsset.InstallDate       = system.today();
       findGlobalAsset.Installed_By__c   = userinfo.getFirstName() + userinfo.getLastName();
       replacementAssets.add(findGlobalAsset);
       
       replacements.AccountID                     = system.label.ReplaceMentAssetAccountID;
       replacements.Date_Removed__c               = system.today();
       replacements.Parent_Asset__c               = null;
       replacements.Service_Activation_Date__c    = null;
       
       replacementAssets.add(replacements);
       
       try{
           upsert replacementAssets;
           //Case Asset Moves insert
           Case_Asset_Moves__c assetMoves = new Case_Asset_Moves__c();
           assetMoves.Asset_Being_Installed__c = findGlobalAsset.ID;
           assetMoves.Asset_Being_Removed__c   = replacements.ID;
           assetMoves.Case_Number__c           = CaseID;
           insert assetMoves;
       }catch(System.DmlException e){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error:'+e.getDmlMessage(0)));
           return null;
       }
       PageReference pagRef = New Pagereference('/'+CaseID);
       return pagRef;
       
    }
    
    
    public Asset globalAssetupsertion(boolean isInsert,String privateStaticName,ID caseAssetID){
        globalIPAsset = True;
        if(isInsert){
            findGlobalAsset = New Asset();
        }
        findGlobalAsset.Name = privateStaticName;
        findGlobalAsset.Parent_Asset__c = caseAssetID;
        if(regionSelected != 'Connect-Two'){
            findGlobalAsset.Product2ID = system.label.Global_StaticIP;
            //findGlobalAsset.Item__c = 'Global Static IP'; 
        }else{
            findGlobalAsset.Product2ID = '01t29000000HAHE';
        }
        if(findGlobalAsset.Product2.Name!=null && findGlobalAsset.Product2.Name!=''){
            findGlobalAsset.Item__c = findGlobalAsset.Product2.Name; 
        }
        findGlobalAsset.InstallDate = system.today();
         
        return findGlobalAsset;
     }
    
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
 
   public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
     
}