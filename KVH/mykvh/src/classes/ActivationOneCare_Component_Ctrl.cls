public Class ActivationOneCare_Component_Ctrl {
   
    public Activation_Hardware__c actProd{get;set;}      
    public list<SelectOption> ProductList = new list<SelectOption>();
    public String parentContainer{get; set;}
    public String ActOrderId{get; set;}
    public String currenttab{get; set;}
    public List<Activation_System_Hardware__c> lstActivationSystemHardwares {get; set;}
    //URL Variables
    Public String strActivationProduct{get; set;}
    
     /** Constructor - Start **/
    public ActivationOneCare_Component_Ctrl (){
        System.Debug('Parent Component Container-->'+parentContainer);
        actProd = New Activation_Hardware__c();
        strActivationProduct = ApexPages.currentPage().getParameters().get('prodActID');
        ActOrderId = ApexPages.currentPage().getParameters().get('order');
        actProd = (strActivationProduct !=null && strActivationProduct != '') ? readActivationProduct(strActivationProduct) : New Activation_Hardware__c();
        readCustSettingHardware();
    }
    /** Constructor - End **/
    
    //Getters and Setters
    public list<SelectOption> getProductTypeList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('-- Select --','-- Select --'));
        Schema.DescribeFieldResult fieldResult = Activation_Hardware__c.Integrated_Product_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
  		for( Schema.PicklistEntry f : ple){
     	options.add(new SelectOption(f.getLabel(), f.getValue()));
   		}       
   		return options;
    }
  
    public List<Activation_System_Hardware__c> readCustSettingHardware(){
        lstActivationSystemHardwares = New List<Activation_System_Hardware__c>();
        lstActivationSystemHardwares = Activation_System_Hardware__c.getAll().values();
        List<String> lstOrders = New List<String>();
        Map<String, Activation_System_Hardware__c> mapActivationSystemHardware = New Map<String, Activation_System_Hardware__c>();
        
        for(Activation_System_Hardware__c objActivationSystemHardware : lstActivationSystemHardwares){
            mapActivationSystemHardware.put(String.valueOf(objActivationSystemHardware.Order__c), objActivationSystemHardware);
            lstOrders.add(String.valueOf(objActivationSystemHardware.Order__c));
        }
        
        lstOrders.sort();
        lstActivationSystemHardwares = New List<Activation_System_Hardware__c>();
        for(String strKey : lstOrders){
            lstActivationSystemHardwares.add(mapActivationSystemHardware.get(strKey));
        }
        //system.debug('lstActivationSystemHardwares' + lstActivationSystemHardwares);
        return lstActivationSystemHardwares;
    }
    public Activation_Hardware__c readActivationProduct(String strActivationProduct){
        actProd = New Activation_Hardware__c();
        if(strActivationProduct!=null && strActivationProduct !=''){
            actProd = [SELECT Id, Image_URL_Formulated__c, Image_path_name__c,Integrated_Product_Type__c,
                                                          Sequence__c, Static_Resource_Archive__c, Status__c,Below_Decks_Root_Asset__c, 
                                                          Title__c, isOptionalHardware__c, Antenna_Serial_Number__c, 
                                                          Below_Decks_Serial_Number__c,Activation_Order__c,System_Name_Group__c, 
                                                          Do_Not_Know_Serial_Number__c,System_Detail__c, System_Name__c,
                                                          Antenna_Root_Asset__c FROM Activation_Hardware__c  WHERE  id=:strActivationProduct ];
        }
        return actProd;
    }
    
    public pageReference ProductSave(){
       	if(actProd.Activation_Order__c == null)  actProd.Activation_Order__c = ActOrderId;
        actProd.RecordTypeid = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Integrated Product').getRecordTypeId();
        Map<String, String> mapRootNumbers = New Map<String, String>();
        if(actProd.Antenna_Serial_Number__c != '' && actProd.Antenna_Serial_Number__c != null)  mapRootNumbers.put(actProd.Antenna_Serial_Number__c, null);
        if(actProd.Below_Decks_Serial_Number__c != '' && actProd.Below_Decks_Serial_Number__c != null)  mapRootNumbers.put(actProd.Below_Decks_Serial_Number__c, null);
        for(Asset objAsset : [SELECT Id,Description,Name,product2.name,Product2.Description,Root_Asset__c FROM Asset WHERE Name IN: mapRootNumbers.keySet()]){
            if(objAsset.Root_Asset__c!=null){
                mapRootNumbers.put(objAsset.Name, objAsset.Root_Asset__c);
            }else{
                mapRootNumbers.put(objAsset.Name, objAsset.Id);
            }
        }
        actProd.Below_Decks_Root_Asset__c = (!mapRootNumbers.isEmpty() && actProd.Below_Decks_Serial_Number__c != '' && actProd.Below_Decks_Serial_Number__c != null && mapRootNumbers.containsKey(actProd.Below_Decks_Serial_Number__c) ? mapRootNumbers.get(actProd.Below_Decks_Serial_Number__c) : null);
        actProd.Antenna_Root_Asset__c = (!mapRootNumbers.isEmpty() && actProd.Antenna_Serial_Number__c != '' && actProd.Antenna_Serial_Number__c != null && mapRootNumbers.containsKey(actProd.Antenna_Serial_Number__c) ? mapRootNumbers.get(actProd.Antenna_Serial_Number__c) : null);
        actProd.Root_Assets_Do_NOT_Match__c = actProd.Below_Decks_Root_Asset__c == actProd.Antenna_Root_Asset__c ? false : true;
        upsert actProd;
        PageReference reference = ApexPages.currentPage();      
        system.debug(reference.getURL());                       
        reference.getParameters().clear();                      
        reference.getParameters().put('order', ActOrderId);     
        system.debug(reference.getURL());                     
        reference.setRedirect(true);                          
        return reference;
    }
    
    // Method To get all Products 
    public List<Activation_Hardware__c> getActivationProductList(){
        if(ActOrderId !=null){
            List<Activation_Hardware__c> lstActivationProducts = New List<Activation_Hardware__c>();
            for(Activation_Hardware__c objActivationProduct: 
                [SELECT Id, Image_URL_Formulated__c, Image_path_name__c, Integrated_Product_Type__c	,
                                                          Sequence__c, Static_Resource_Archive__c, Status__c,Below_Decks_Root_Asset__c, 
                                                          Title__c, isOptionalHardware__c, Antenna_Serial_Number__c, 
                                                          Below_Decks_Serial_Number__c,Activation_Order__c,System_Name_Group__c, 
                                                          Do_Not_Know_Serial_Number__c,System_Detail__c, System_Name__c,
                                                          Antenna_Root_Asset__c FROM Activation_Hardware__c WHERE  Activation_Order__c =: ActOrderId and RecordTypeId =: Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Integrated Product').getRecordTypeId()]){
                         lstActivationProducts.add(objActivationProduct);
                 }
            return lstActivationProducts;
        }
        return null;
    } 
    
    
    //To load activation prodtact to edit
    Public PageReference EditProduct(){
        PageReference reference = ApexPages.currentPage();
        reference.getParameters().clear();                     
        reference.getParameters().put('order', ActOrderId); 
        reference.getParameters().put('prodActID', strActivationProduct);
        reference.setRedirect(true);
        return reference;
    } 
    
    Public PageReference reloadprodtactlist(){
        PageReference reference = ApexPages.currentPage();
        reference.getParameters().clear();                     
        reference.getParameters().put('order', ActOrderId); 
        reference.setRedirect(true);
        return reference;
    } 
    Public PageReference RemoveProduct(){
        system.debug('strActivationProduct'+strActivationProduct);
        if(strActivationProduct != '' && strActivationProduct != null){
            Activation_Hardware__c objActivationProduct = [SELECT Id FROM Activation_Hardware__c WHERE Id =: strActivationProduct];
            Delete objActivationProduct;
            getActivationProductList();
        }
        return reloadprodtactlist();
    }
    Public pageReference SearchAsset(){
        Set<String> assetString = New Set<String>();
        assetString.add(actProd.Below_Decks_Serial_Number__c);
        MAP<ID,ID> topAssetMap = ActivationSystemInfo.GetTopMultipleElements(assetString);
        if(topAssetMap.size()>0){
            List<ID> allTopIds = New List<ID>();
            allTopIds.addAll(topAssetMap.values());
            Asset topAsset = [SELECT id,Description,Name,product2.name,Product2.Description FROM Asset WHERE id=:allTopIds[0]];
            if(topAsset.product2.name !=null){
                actProd.System_Name__c = topAsset.Product2.Description;
            }
        }
        else{
            actProd.Do_Not_Know_Serial_Number__c = true;
            actProd.System_Name__c = '';
        }
       return ProductSave();
    }
 }