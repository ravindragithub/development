public with sharing class CreateAssetTemp {
    public Id productid           {get;set;}
    public String itemNumber      {get;set;}
    public Product2 productobj    {get;set;}
    public String sequenceName    {get;set;}
    public String sequenceNumber  {get;set;}
    public Asset parentAssetRecord{get;set;}
    public id assetid             {get;set;}
    public Boolean displayPCfld   {get;set;}
    public CreateAssetTemp(){
        productid  = ApexPages.CurrentPage().getparameters().get('ProductId');
        assetid = ApexPages.CurrentPage().getparameters().get('assetID');
        //productobj = New Product2();
        if(productid!=null){
                displayPCfld = true;
                productobj = [SELECT Id, Name,Description ,ProductCode,Media_Supplier__c,Supplier__c FROM Product2 WHERE ID =: productid];
                itemNumber = productobj.ProductCode;
        }else if(assetid!=null){
                displayPCfld = false;
                parentAssetRecord = [SELECT id,Product2Id,Product2.ProductCode,Name,AccountID,SerialNumber,Sequence_No__c,Region__c FROM Asset where id=:assetid];
                String s = '_US';
            }
        }
        
    
    public pageReference createAsset(){ 
        try{
            Asset ast = new Asset();  
            if(productid!=null){
                if(Apexpages.currentPage().getParameters().get('node')!=null && Apexpages.currentPage().getParameters().get('node')!=''){
                    ast.Product2Id = Apexpages.currentPage().getParameters().get('node');
                }else{
                    ast.Product2Id = productobj.Id;
                }
                ast.Asset_ID__c = Itemnumber + '_US_' + sequenceName;
            }else if(assetid!=null){
                ast.Product2Id = Apexpages.currentPage().getParameters().get('node');
                ast.Parent_Asset__c = parentAssetRecord.id;
                ast.Asset_ID__c = parentAssetRecord.Product2.ProductCode + '_US_' + sequenceName;
            }
            ast.Name = sequenceName ;
            ast.SerialNumber = sequenceName;
            //TO FIND DUPLICATE SERIAL NUMBER
            List<Asset> toFindAssetSerialNumber = [SELECT id FROM Asset WHERE SerialNumber=:ast.SerialNumber.trim()];
            if(toFindAssetSerialNumber.size()>0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error Found: This asset that you are trying to create has already been assigned. Please validate the asset is correct'));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Here is a link to the existing asset: <a href="/' + toFindAssetSerialNumber[0].id +'" target="_blank">Asset Record</a>')); 
                return null;
            }
             set<String> findingSequenceNumber = New set<String>();
            if(assetid!=null){
                //TO FIND DUPLICATE SEQUENCE NUMBER
                AssetStructure  topast = New AssetStructure();
                id findTopLevelAsset = topast.GetTopElement(assetid); 
                
                List<Asset> allRelatedChildAccts = [SELECT id,Sequence_No__c FROM Asset
                                                       
                                                       WHERE id=:findTopLevelAsset OR
                                                             Parent_Asset__c =: findTopLevelAsset OR
                                                             Parent_Asset__r.Parent_Asset__c  =: findTopLevelAsset OR
                                                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: findTopLevelAsset OR
                                                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c =: findTopLevelAsset OR
                                                             Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c=: findTopLevelAsset];
                
                for(Asset assetSeq:allRelatedChildAccts){
                    if(assetSeq.Sequence_No__c!=null && assetSeq.Sequence_No__c!=''){
                        findingSequenceNumber.add(assetSeq.Sequence_No__c.trim());
                    }
                }
            }
            if(findingSequenceNumber.size()>0 && findingSequenceNumber.contains(sequenceNumber.trim())){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error:The sequence number for the asset you are trying to create is a duplicate with another asset in the hierarchy. Please review the assets in the hierarchy.'));
                return null; 
            }else{
                ast.Sequence_No__c = sequenceNumber;
                ast.InstallDate = system.today();
                ast.Region__c = 'US';
                DefaultAccounts__c defaultAccountID = DefaultAccounts__c.getInstance('DefaultAssets');
                ast.AccountId = defaultAccountID.Account_ID__c;
                ast.Installed_By__c = userinfo.getFirstname()+' '+userinfo.getLastName();
                insert ast;
               return new PageReference('/' +ast.Id); 
            }
        }Catch(System.DmlException typeOfException){
            String exceptionType = String.ValueOF(typeOfException);
            if(exceptionType.contains('duplicate')){
                List<String> findDuplicateID = exceptionType.split(':');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error Found: The asset you are trying to create has already been assigned. Please validate the asset serial number is correct.')); 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Duplicate Record: <a href="/' + findDuplicateID[4].trim() +'" target="_blank">Click Me</a>')); 
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error Found:'+typeOfException.getDmlMessage(0))); 
            }
            return null;
        }
    }

}