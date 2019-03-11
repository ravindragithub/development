public class ActivationOneCare_Ctrl extends ActivationsBaseController{
    public string selectedTab  {get; set;}
    public list<Activation_Service__c> lstActivationServices {get;set;}
    private Map<String, String> MapOnecareProduct;
    public Map<String, string> MapOnecareProductPrice{get;set;}
    public Map<String, string> mapWarrantyPrice{get;set;}
    public List<string> lstPricekeycheck {get;set;}
    public Map<String, String> mapWarrantyOption{get;set;}
    public String strOnecareProduct{set;get;}
    public string strProduct {get;set;}
    public Wraptable wrap{get;set;}
    public String ProdId{get;set;}
    
    public Map<String,Integer> mapdisableActivationOneCareTabs {
        get { mapdisableActivationOneCareTabs = New Map<String,Integer>();
             mapdisableActivationOneCareTabs.put('Technical_Assistance_Package',1);
             mapdisableActivationOneCareTabs.put('Extended_Warranty',2);
             return mapdisableActivationOneCareTabs; 
            }
        private set; 
    }
    
    public ActivationOneCare_Ctrl(){
        ActivationOrderId = ApexPages.currentPage().getParameters().get('order');
        strProduct = ApexPages.currentPage().getParameters().get('prodActID');
        ActivationStatus = readActivationStatus(ActivationOrderId);
        list<SBQQ__ProductOption__c> mapWarrantyOptions = New list<SBQQ__ProductOption__c>();
        ProdId='';
        strOnecareProduct ='';
        MapOnecareProduct = New Map<String, String>();
        MapOnecareProductPrice = New Map<String, string>();
        mapWarrantyPrice = New Map<String, string>();
        mapWarrantyOption = New Map<String, String>();
        
        lstPricekeycheck = New List<String>();
        lstPricekeycheck.add('Standard');
        lstPricekeycheck.add('Premium');
        lstPricekeycheck.add('Global');
        
        wrapmethod();
        
        lstActivationServices = [Select Id,	VSAT_Antenna_Hardware__c, OneCare_Technical_Assistance_Package__c,OneCare_Technical_Assistance_Package__r.Name,Extended_Warranty_Product__c,Extended_Warranty_Product__r.Name from Activation_Service__c where Activation_Order__r.id=:ActivationOrderId limit 1];
        
        if(lstActivationServices.size()>0){
            string strSysName = lstActivationServices[0].VSAT_Antenna_Hardware__c;
            String strSysContains;
            if(strSysName.contains('V3'))strSysContains='TracPhone V3 Extended Warranty';
            if(strSysName.contains('V7'))strSysContains='TracPhone V7 Extended Warranty';
            if(strSysName.contains('V9'))strSysContains='TracPhone V9 Extended Warranty';
            if(strSysName.contains('V11'))strSysContains='TracPhone V11 Extended Warranty';
            map<string,string> mapProductOption = New map<string,string>();
            for(SBQQ__ProductOption__c SBQQProd : [SELECT id, SBQQ__Feature__r.Name, SBQQ__UnitPrice__c, SBQQ__ConfiguredSKU__r.name,SBQQ__OptionalSKU__r.Id from SBQQ__ProductOption__c where SBQQ__ConfiguredSKU__r.Name like :strSysContains ]){
                mapWarrantyOption.put(SBQQProd.SBQQ__Feature__r.Name,SBQQProd.SBQQ__OptionalSKU__r.Id);   
                mapProductOption.put(SBQQProd.SBQQ__OptionalSKU__r.Id,SBQQProd.SBQQ__Feature__r.Name);
            }
            
            for(PricebookEntry objPricebookEntry : [Select Product2Id,Product2.Name,UnitPrice FROM PricebookEntry WHERE Pricebook2.isStandard = true and Product2Id IN : mapProductOption.keySet()]){
                Decimal decFormat = objPricebookEntry.UnitPrice;
                List<String> args = new String[]{'0','number','###,###,##0'};
                    String strUnitPrice = String.format(decFormat.format(), args);
                mapWarrantyPrice.put(mapProductOption.get(objPricebookEntry.Product2Id),strUnitPrice);        
            }
        }        
        
        String strProductbundleId = Activation_Product_Bundle__c.getValues('OneCare').Product_Bundle_Id__c;
        String strFeatureName = 'Technical Assistance Package';
        String strQuery = 'SELECT Id, Name,SBQQ__Feature__r.Name, SBQQ__MinQuantity__c, SBQQ__ConfiguredSKU__c,SBQQ__Bundled__c, SBQQ__OptionalSKU__c,SBQQ__OptionalSKU__r.RecordType.Name, SBQQ__OptionalSKU__r.Name, SBQQ__OptionalSKU__r.Amount_Free__c  FROM SBQQ__ProductOption__c WHERE SBQQ__OptionalSKU__c != null AND SBQQ__ConfiguredSKU__c != null AND SBQQ__ConfiguredSKU__c =: strProductbundleId AND SBQQ__Feature__c != null AND SBQQ__Feature__r.Name =: strFeatureName ';
        strQuery += ' ORDER BY SBQQ__Number__c ';
        Set<Id> setProductIds = New Set<Id>();
        for(SBQQ__ProductOption__c objProductOption : Database.query(strQuery)){ 
            setProductIds.add(objProductOption.SBQQ__OptionalSKU__c);
            MapOnecareProduct.put(objProductOption.SBQQ__OptionalSKU__r.Name.containsIgnoreCase('Standard') ? 'Standard' : (objProductOption.SBQQ__OptionalSKU__r.Name.containsIgnoreCase('Premium') ? 'Premium' : 'Global') , objProductOption.SBQQ__OptionalSKU__c);
        }
        
        for(PricebookEntry objPricebookEntry : [Select Product2Id,Product2.name,UnitPrice FROM PricebookEntry WHERE Pricebook2.isStandard = true and Product2Id IN: setProductIds]){
            Decimal decFormat = objPricebookEntry.UnitPrice;
            List<String> args = new String[]{'0','number','###,###,##0'};
                String strUnitPrice = String.format(decFormat.format(), args);
            MapOnecareProductPrice.put(objPricebookEntry.Product2.Name.containsIgnoreCase('Standard') ? 'Standard' : (objPricebookEntry.Product2.Name.containsIgnoreCase('Premium') ? 'Premium' : 'Global'),strUnitPrice );
        }
        
        if(lstActivationServices.size() > 0 && lstActivationServices[0].OneCare_Technical_Assistance_Package__c != null){
            strOnecareProduct = (lstActivationServices[0].OneCare_Technical_Assistance_Package__r.Name.containsIgnoreCase('Standard') ? 'Standard' : (lstActivationServices[0].OneCare_Technical_Assistance_Package__r.Name.containsIgnoreCase('Premium') ? 'Premium' : 'Global'));
        }
        
        ActivationStatus.Active_Page__c = 'OneCare'; 
        ActivationStatus.OneCare_Page__c ='available';                           //set Page Available Status
        if(ActivationStatus.OneCare_Active_Tab__c == null){                     //set Active tab
            selectedTab = 'Technical_Assistance_Package';
            ActivationStatus.OneCare_Active_Tab__c = selectedTab;
        } else {
            selectedTab = ActivationStatus.OneCare_Active_Tab__c;
        }
        
        if(ActivationStatus.OneCare_Last_Active_Tab_Index__c == null){
            ActivationStatus.OneCare_Last_Active_Tab_Index__c =1;
        }
        if(ActivationStatus.OneCare_Last_Active_Tab_Index__c < mapdisableActivationOneCareTabs.get(selectedTab)){
            ActivationStatus.OneCare_Last_Active_Tab_Index__c = mapdisableActivationOneCareTabs.get(selectedTab);
        }
    }
    
    public void wrapmethod(){
        list<ActivationOneCare__c> lstOneCare = New list<ActivationOneCare__c>();
        List<String> fields = new List<String>(ActivationOneCare__c.SObjectType.getDescribe().fields.getMap().keySet());
        String stringQuery = ''
            + ' select ' + String.join(fields, ',')
            + ' from ActivationOneCare__c'
            + '  ORDER BY Name ';
        lstOneCare = Database.query( stringQuery );
        
        wrap=new Wraptable();
        wrap.rowtype = new set<string>();
        wrap.mpRows = new Map<string, List<string>>();
        wrap.mpchk = new Map<string, List<boolean>>();
        for(ActivationOneCare__c lstone:lstOneCare){
            wrap.rowtype.add(lstone.OneCareTechnicalAssitance__c);
            
            if(wrap.mpRows.containsKey(lstone.OneCareTechnicalAssitance__c)) {
                List<string> ActSubs = wrap.mpRows.get(lstone.OneCareTechnicalAssitance__c);
                ActSubs.add(lstone.Technical__c);
                wrap.mpRows.put(lstone.OneCareTechnicalAssitance__c, ActSubs);
            } else {
                wrap.mpRows.put(lstone.OneCareTechnicalAssitance__c, new List<string> { lstone.Technical__c });
            }
            
            if(wrap.mpchk.containsKey(lstone.Technical__c)) {
                List<boolean> ActSubs = wrap.mpchk.get(lstone.Technical__c);
                ActSubs.add(lstone.Standard__c);
                ActSubs.add(lstone.Premium__c);
                ActSubs.add(lstone.Global__c);
                wrap.mpchk.put(lstone.Technical__c, ActSubs);
            } else {
                wrap.mpchk.put(lstone.Technical__c, new List<boolean> { lstone.Standard__c,lstone.Premium__c,lstone.Global__c });
            }
        }
    }
    
    public pageReference saveService(){
        pageReference returnPage = ApexPages.currentPage(); 
        Activation_Service__c ObjService = new Activation_Service__c();
        if(lstActivationServices.size() > 0)  ObjService.id = lstActivationServices[0].id;
        else ObjService.Activation_Order__c = ActivationOrderId;
        if(ProdId.contains('Year') && mapWarrantyOption.containsKey(ProdId)) ObjService.Extended_Warranty_Product__c = mapWarrantyOption.get(ProdId);
        else if(MapOnecareProduct.containsKey(ProdId)) ObjService.OneCare_Technical_Assistance_Package__c = MapOnecareProduct.get(ProdId);
        Upsert ObjService;
        returnPage.getParameters().clear();                      
        returnPage.getParameters().put('order', ActivationOrderId);     //add the order ID
        returnPage.setRedirect(true);                            //this causes the constructors to run again...
        return returnPage;  
    }
    
    public pageReference clear(){
        if(lstActivationServices.size() > 0){
            lstActivationServices[0].Extended_Warranty_Product__c = null;
            update lstActivationServices[0]; 
        }
        pageReference returnPage = ApexPages.currentPage(); 
        returnPage.getParameters().clear();                      
        returnPage.getParameters().put('order', ActivationOrderId);     //add the order ID
        returnPage.setRedirect(true);                            //this causes the constructors to run again...
        return returnPage; 
    }
    
    public pageReference gototab(){
        pageReference returnPage = ApexPages.currentPage();      
        if(selectedTab == 'Additional_Plans_and_Services'){
            ActivationStatus.Active_Page__c = 'services';               
            ActivationStatus.Services_Page__c ='available'; 
            ActivationStatus.Services_Active_Tab__c = selectedTab;
            returnPage = page.Services;
        }
        else if(selectedTab == 'Contract_Details'){
            ActivationStatus.Active_Page__c = 'Contract Details';               
            ActivationStatus.Contract_Details_Page__c ='available'; 
            ActivationStatus.Contract_Details_Active_Tab__c = selectedTab;
            returnPage = page.Contract_Details;
        }else{
            ActivationStatus.OneCare_Active_Tab__c = selectedTab; 
        }
        update ActivationStatus;                    
        returnPage.getParameters().clear();                      
        returnPage.getParameters().put('order', ActivationOrderId);     //add the order ID
        returnPage.setRedirect(true);                            //this causes the constructors to run again...
        return returnPage;
    }
    
    public class Wraptable{
        public set<string> rowtype{set;get;}
        public map<string,list<string>> mpRows{set;get;}
        public map<string,list<boolean>> mpchk{set;get;}
    }
}