/**
* @createdby        :   Gopi
* @createddate      :
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   03/30/2017
* @description      :   Class Used In ActivationSystemInfo Page for Activation hardware Creation 
*                       update and for navigating between tabs.
**/

Public without sharing Class ActivationSystemInfo extends ActivationsBaseController{
    public string   selectedTab             {get;set;}
    private static  String strSystemDetailsTab = 'System_Details';
    private static  String strSystemSelectionTab = 'System_Selection';
    public Activation_Hardware__c objActivationHardware {get;set;} 
    public Activation_Order__c objActivationOrder {get;set;} 
    private list<Activation_Service__c> objActivationService;
    private String strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Activation System').getRecordTypeId();
    public List<Activation_System_Hardware__c> lstActivationSystemHardwares {get; set;} // custom setting data
    Boolean boolchkChange;
    public boolean param{get; set;}
    //TAB Index variable can be get from custom settings
    public Map<String,Integer> mapdisableActivationHardwareTabs {
        get { mapdisableActivationHardwareTabs = New Map<String,Integer>();
             mapdisableActivationHardwareTabs.put('System_Type',1);
             mapdisableActivationHardwareTabs.put('System_Selection',2);
             mapdisableActivationHardwareTabs.put('System_Details',3);
             return mapdisableActivationHardwareTabs; 
            }
        private set; 
    }
    
    public ActivationSystemInfo(){
        ActivationOrderId = ApexPages.currentPage().getParameters().get('order');    //extract Order Id
        ActivationStatus = readActivationStatus(ActivationOrderId);             //get status record
        objActivationHardware = readActivationHardware(ActivationOrderId);       //get hardware record
        system.debug('===>'+ActivationStatus);
        objActivationOrder = [select id,Lease_Contract__c,Hardware_Purchased_or_Leased__c, Order_Status__c, Activation_Type__c,CreatedById from Activation_Order__c where id=:ActivationOrderId];
        objActivationService = [select id,Extended_Warranty_Product__c from Activation_Service__c where Activation_Order__c=:ActivationOrderId limit 1];
        ActivationStatus.Active_Page__c = 'System'; 
        ActivationStatus.System_Page__c ='available';                           //set Page Available Status 
        if(ActivationStatus.System_Active_Tab__c == null){                     //set Active tab
            selectedTab = 'System_Type';
            ActivationStatus.System_Active_Tab__c = selectedTab;
        } else {
            selectedTab = ActivationStatus.System_Active_Tab__c;
        }
        
        if(ActivationStatus.System_Type_Last_Active_Tab_Index__c == null){
            ActivationStatus.System_Type_Last_Active_Tab_Index__c =1;
        }
        if(ActivationStatus.System_Type_Last_Active_Tab_Index__c < mapdisableActivationHardwareTabs.get(selectedTab)){
            ActivationStatus.System_Type_Last_Active_Tab_Index__c = mapdisableActivationHardwareTabs.get(selectedTab);
        }
        readCustSettingHardware();
    }
    
        /**
        * @last modified by     :   Teertha prasad
        * @last modified date   :   09/26/2016
        * @description          :   readCustSettingHardware Method.
        *                           To load custom setting data for custom system selection TAB 
        * @return               :   List<Activation_System_Hardware__c>
        * @invoke               :   From constructor
        **/
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
    
    
    public Activation_Hardware__c readActivationHardware(String strOrderId){
        Activation_Hardware__c objActivationHardware = New Activation_Hardware__c();
        for(Activation_Hardware__c ActivationHardware  : [SELECT Id, Image_URL_Formulated__c,RecordTypeId, Image_path_name__c, 
                                                          Sequence__c, Static_Resource_Archive__c, Status__c,Below_Decks_Root_Asset__c, 
                                                          Title__c, isOptionalHardware__c, Antenna_Serial_Number__c, 
                                                          Below_Decks_Serial_Number__c,Activation_Order__c,System_Name_Group__c, 
                                                          Do_Not_Know_Serial_Number__c,System_Detail__c, System_Name__c,
                                                          Antenna_Root_Asset__c FROM Activation_Hardware__c WHERE Activation_Order__c =:strOrderId AND RecordTypeId =: strActivationHardwareRecordTypeId LIMIT 1]){
                                                              objActivationHardware = ActivationHardware; 
                                                          }
        boolchkChange = objActivationHardware.Do_Not_Know_Serial_Number__c;
        objActivationHardware.RecordTypeId = strActivationHardwareRecordTypeId;
        return objActivationHardware;
    }
    
    public void updateActivationhardware(){
        if(objActivationHardware.Do_Not_Know_Serial_Number__c){
            objActivationHardware.Antenna_Serial_Number__c = '';
            objActivationHardware.Below_Decks_Serial_Number__c = '';
            objActivationHardware.Below_Decks_Root_Asset__c = null;
            objActivationHardware.Antenna_Root_Asset__c = null;
            
        }
        
        if(objActivationHardware.Do_Not_Know_Serial_Number__c != boolchkChange){
            objActivationHardware.Image_path_name__c = '';
            objActivationHardware.Static_Resource_Archive__c = '';
            objActivationHardware.System_Name_Group__c = '';
            objActivationOrder.Lease_Contract__c = null;
            objActivationOrder.Hardware_Purchased_or_Leased__c = '';
        }
        
        if(objActivationHardware.Do_Not_Know_Serial_Number__c  && strSystemSelectionTab == selectedTab && objActivationHardware.System_Name__c != null){
            objActivationHardware.System_Name_Group__c = Activation_System_Hardware__c.getValues(objActivationHardware.System_Name__c).Product_Group__c;
        }
        
        if(objActivationHardware.Activation_Order__c == null)  objActivationHardware.Activation_Order__c = ActivationOrderId;
        
        Map<String, String> mapRootNumbers = New Map<String, String>();
        if(objActivationHardware.Antenna_Serial_Number__c != '' && objActivationHardware.Antenna_Serial_Number__c != null)  mapRootNumbers.put(objActivationHardware.Antenna_Serial_Number__c, null);
        if(objActivationHardware.Below_Decks_Serial_Number__c != '' && objActivationHardware.Below_Decks_Serial_Number__c != null)  mapRootNumbers.put(objActivationHardware.Below_Decks_Serial_Number__c, null);
        for(Asset objAsset : [SELECT Id,Description,Name,product2.name,Product2.Description,Root_Asset__c FROM Asset WHERE Name IN: mapRootNumbers.keySet()]){
            if(objAsset.Root_Asset__c!=null){
                mapRootNumbers.put(objAsset.Name, objAsset.Root_Asset__c);
            }else{
                mapRootNumbers.put(objAsset.Name, objAsset.Id);
            }
        }
        objActivationHardware.Below_Decks_Root_Asset__c = (!mapRootNumbers.isEmpty() && objActivationHardware.Below_Decks_Serial_Number__c != '' && objActivationHardware.Below_Decks_Serial_Number__c != null && mapRootNumbers.containsKey(objActivationHardware.Below_Decks_Serial_Number__c) ? mapRootNumbers.get(objActivationHardware.Below_Decks_Serial_Number__c) : null);
        objActivationHardware.Antenna_Root_Asset__c = (!mapRootNumbers.isEmpty() && objActivationHardware.Antenna_Serial_Number__c != '' && objActivationHardware.Antenna_Serial_Number__c != null && mapRootNumbers.containsKey(objActivationHardware.Antenna_Serial_Number__c) ? mapRootNumbers.get(objActivationHardware.Antenna_Serial_Number__c) : null);
        objActivationHardware.Root_Assets_Do_NOT_Match__c = objActivationHardware.Below_Decks_Root_Asset__c == objActivationHardware.Antenna_Root_Asset__c ? false : true ;
        upsert objActivationHardware;
        if(objActivationHardware.Below_Decks_Root_Asset__c != null){
            list<Contracted_Services__c> CS=[select id,Asset__c, Service_Item__r.Name, Contract__r.id, Contract__r.Lease_Status__c from Contracted_Services__c where Asset__c =: objActivationHardware.Below_Decks_Root_Asset__c and Service_Item__r.Name='Lease' and Contract__r.Lease_Status__c != 'T' limit 1];
            if(CS.size()>0){
                objActivationOrder.Lease_Contract__c = CS[0].Contract__r.id;
                objActivationOrder.Hardware_Purchased_or_Leased__c = 'Leased';
            }else{
                objActivationOrder.Lease_Contract__c = null;
                if(selectedTab != '') objActivationOrder.Hardware_Purchased_or_Leased__c = '';
            }
        }
        if(selectedTab != ''){ 
         update objActivationOrder;
            if(objActivationService.size() > 0){
                objActivationService[0].Extended_Warranty_Product__c = null;
                update objActivationService[0];
            } 
        }}
    
    public pageReference goToNextTab(){
        updateActivationhardware();
        return goToTab();
    }
    
    public pageReference goToTab(){
        system.debug('TAB'+ selectedTab);
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        if(selectedTab == 'Dealer_Distributor_Info'){
            ActivationStatus.Installation_Type_Active_Tab__c = selectedTab;
            ActivationStatus.Active_Page__c = 'Installation Type';
            returnPage = page.Installation_Type;      //unfortunately, this returns the whole view state!
        }else if(selectedTab == ''){
            objActivationOrder.Order_Status__c = 'Subscriber Account Submitted';
            Update objActivationOrder;
            ActivationStatus.First_Review_Page__c = 'available';
            ActivationStatus.Active_Page__c = 'First Review';
            returnPage = page.Review_Activation_Order_1; 
        }
        else{
            ActivationStatus.System_Active_Tab__c = selectedTab;
            if(ActivationStatus.System_Type_Last_Active_Tab_Index__c < mapdisableActivationHardwareTabs.get(selectedTab)){
                ActivationStatus.System_Type_Last_Active_Tab_Index__c = mapdisableActivationHardwareTabs.get(selectedTab);
            }
        }
        update ActivationStatus;

        returnPage.getParameters().clear();                         //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActivationOrderId); //add the order ID
        returnPage.setRedirect(true);                               //this causes the constructors to run again...
        return returnPage;
    }
    
    boolean validateAsset;
    
    Public void SearchAsset(){
        Set<String> assetString = New Set<String>();
        assetString.add(objActivationHardware.Below_Decks_Serial_Number__c);
        MAP<ID,ID> topAssetMap = GetTopMultipleElements(assetString);
		objActivationHardware.Do_Not_Know_Serial_Number__c= false;
        if(topAssetMap.size()>0){
            List<ID> allTopIds = New List<ID>();
            allTopIds.addAll(topAssetMap.values());
            Asset topAsset = [SELECT id,Description,Name,product2.name,Product2.Description FROM Asset WHERE id=:allTopIds[0]];
            if(topAsset.product2.Description !=null){
                validateAsset = topAsset.Product2.Description.length()<255 ? true : false;
                objActivationHardware.System_Name__c = validateAsset ? topAsset.Product2.Description : '';
            }
        }
    }
    
    public boolean getexistsAsset(){
        return validateAsset;
    }
    
    public boolean getNameException(){
        return objActivationHardware.System_Name__c == '';
    }
    
    public void AssetNotFound(){
        objActivationHardware.Antenna_Serial_Number__c = '';
        objActivationHardware.Below_Decks_Serial_Number__c = '';
        objActivationHardware.Below_Decks_Root_Asset__c = null;
        objActivationHardware.Antenna_Root_Asset__c = null;
        objActivationHardware.Do_Not_Know_Serial_Number__c= true;
        objActivationHardware.System_Name__c = '';
        if(objActivationHardware.Activation_Order__c == null)
        objActivationHardware.Activation_Order__c = ActivationOrderId;
        upsert objActivationHardware;
    }
    /**
* Find the tom most multiple elements in Heirarchy (Method created By Gopi)
* @return Multiple Asset Parent objIds.
*/
    public Static Map<ID,ID> GetTopMultipleElements( Set<String> objId ){
        MAP<ID,ID> mutipleAssetParentIds = new MAP<ID,ID>();
        
        MAP<ID,ID> FindTopLevelAssets = new MAP<ID,ID>();
        
        for(integer repeatLoop=0;repeatLoop<2;repeatLoop++){
            
            List<Asset> soqla = [Select a.Id, 
                                 
                                 a.Parent_Asset__c,
                                 
                                 a.Parent_Asset__r.Parent_Asset__c,
                                 
                                 a.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c,
                                 
                                 a.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c,
                                 
                                 a.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c From Asset a where a.Name =: objId ];
            
            Asset a = null;
            if (!soqla.isEmpty()) { // we got records!
                for(integer i=0;i<soqla.size();i++){
                    a = soqla.get(i);
                    if(a.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c!=null){
                        ID singleobjId = a.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c;
                        objId.add(singleobjId);
                        FindTopLevelAssets.put(singleobjId,a.id);
                    }else if(a.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c!=null){
                        ID singleobjId = a.Parent_Asset__r.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c;
                        if(FindTopLevelAssets.containskey(a.id)){
                            mutipleAssetParentIds.put(FindTopLevelAssets.get(a.id),singleobjId);
                        }else{
                            mutipleAssetParentIds.put(soqla[i].ID,singleobjId);
                        }
                    }else if(a.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c!=null){
                        ID singleobjId = a.Parent_Asset__r.Parent_Asset__r.Parent_Asset__c;
                        if(FindTopLevelAssets.containskey(a.id)){
                            mutipleAssetParentIds.put(FindTopLevelAssets.get(a.id),singleobjId);
                        }else{
                            mutipleAssetParentIds.put(soqla[i].ID,singleobjId);
                        }
                    }else if(a.Parent_Asset__r.Parent_Asset__c!=null){
                        ID singleobjId = a.Parent_Asset__r.Parent_Asset__c;
                        if(FindTopLevelAssets.containskey(a.id)){
                            mutipleAssetParentIds.put(FindTopLevelAssets.get(a.id),singleobjId);
                        }else{
                            mutipleAssetParentIds.put(soqla[i].ID,singleobjId);
                        }
                    }else if ( a.Parent_Asset__c != null ) {
                        ID singleobjId = a.Parent_Asset__c;
                        if(FindTopLevelAssets.containskey(a.id)){
                            mutipleAssetParentIds.put(FindTopLevelAssets.get(a.id),singleobjId);
                        }else{
                            mutipleAssetParentIds.put(soqla[i].ID,singleobjId);
                        }
                    }else if ( a.Parent_Asset__c == null ) {
                        ID singleobjId = a.Id;
                        mutipleAssetParentIds.put(soqla[i].ID,singleobjId);
                    }
                }
            } 
        }
        return mutipleAssetParentIds; 
    }
   
    public pagereference saveandExit(){
        upsert objActivationHardware;
        return null;
    }
}