public class BundlerAppUI {
    
    public list<ColoumTableClass> AllValuesForColumns{get;set;}
    ID SelectedProductId;
    Set<Id> IPMCids = new Set<Id>();
    
    public integer initialCountOfRecords{get;set;}
    public string SelectedIPMCProduct{get;set;}
    public Boolean saveDisabled{get;set;}				//switch to enable/disable Save button
    
    public BundlerAppUI(ApexPages.StandardController controller){}
    
    public List<SelectOption> getIPMCProducts() {
        IPMC_Utilities ipmcUtlity = new IPMC_Utilities();
        list<Product2> IPMCProducts = ipmcUtlity.getIPMC_bundles();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','- NONE -'));	//This is default when page loads...
        for(Product2 ipmcProduct:IPMCProducts){
			options.add(new SelectOption(ipmcProduct.id,ipmcProduct.Name));
        }
        return options;
    }

    public void SaveWithSelected(){
        List<Package_Kinds_by_Product__c> allSelectedPackaeKindInsert = new List<Package_Kinds_by_Product__c>();
        Set<Id> deletingpackageKind = new set<ID>();
        for(ColoumTableClass addSelectedValues:AllValuesForColumns){
            system.debug('==>'+IPMCids);
            system.debug('==>'+addSelectedValues.IPMCpackageKind.Id);
            system.debug('==>'+addSelectedValues.ValueBoolean);
            if(addSelectedValues.ValueBoolean && !IPMCids.contains(addSelectedValues.IPMCpackageKind.Id)){
                Package_Kinds_by_Product__c newSelectedPackageKind = new Package_Kinds_by_Product__c();
                newSelectedPackageKind.IPMC_Package_Kind__c = addSelectedValues.IPMCpackageKind.Id;
                newSelectedPackageKind.Product__c = SelectedProductId;
                allSelectedPackaeKindInsert.add(newSelectedPackageKind);
            }else if(!addSelectedValues.ValueBoolean && IPMCids.contains(addSelectedValues.IPMCpackageKind.Id)){
                deletingpackageKind.add(addSelectedValues.IPMCpackageKind.Id);
            }
        }
        
        if(allSelectedPackaeKindInsert.size()>0){
        	insert allSelectedPackaeKindInsert;
        }
        
        List<Package_Kinds_by_Product__c> deletePackageKinds = [select id from Package_Kinds_by_Product__c where (IPMC_Package_Kind__c=:deletingpackageKind and Product__c=:SelectedProductId)];
        if(deletePackageKinds.size()>0){
        	delete deletePackageKinds;
        }
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'successfully created/updated packagekinds'));
        populatePackageKinds();
    }
    
    
    public class ColoumTableClass{				//Wrapper Class that couples PkgKinds with Boolean
        public Boolean ValueBoolean{get;set;}
        public IPMC_Package_Kinds__c IPMCpackageKind{get;set;}
    }  
    
    public void populatePackageKinds(){ 
        initialCountOfRecords = 0;
        
        if(SelectedIPMCProduct != NULL && SelectedIPMCProduct != ''){
            SelectedProductId = SelectedIPMCProduct;
            system.debug('If condition: '+SelectedProductId);
            saveDisabled = false;
        }
        else{
            SelectedProductId = apexpages.currentpage().getparameters().get('id');
            SelectedIPMCProduct = SelectedProductId;
            system.debug('Else condition: '+SelectedProductId);
            saveDisabled = true;
        }
        AllValuesForColumns = NULL;
        IPMCids = NULL;
        AllValuesForColumns = new List<ColoumTableClass>();
        IPMCids = new Set<ID>();
        
        List<Package_Kinds_by_Product__c> packageKindProductData = [select id,Product__c,IPMC_Package_Kind__c 
        															from Package_Kinds_by_Product__c 
        															where Product__c=:SelectedProductId];
        for(integer j=0;j<packageKindProductData.size();j++){
            IPMCids.add(packageKindProductData[j].IPMC_Package_Kind__c);
            initialCountOfRecords = initialCountOfRecords+1;
        }
        
        List<IPMC_Package_Kinds__c> packageKinds = [select id,PackageKind__c from IPMC_Package_Kinds__c 
        											WHERE Status__c IN ('Active', 'Planned') ORDER BY PackageKind__c ASC];
        
        for(integer i=0; i < packageKinds.size() ;i++){   
            ColoumTableClass CTC = new ColoumTableClass();
            if(IPMCids.contains(packageKinds[i].id)){
                CTC.ValueBoolean = true;
            }else{ 
                CTC.ValueBoolean = false;
            }
            CTC.IPMCpackageKind = packageKinds[i];
            AllValuesForColumns.add(CTC);
        } 
    }
}