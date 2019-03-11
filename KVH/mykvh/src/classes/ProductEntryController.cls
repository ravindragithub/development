public class ProductEntryController {
    public apexpages.standardcontroller controller;
    public List<CountWrapper> cwraps {get; set;}
    public List<ProdWrapper> wrappers {get; set;}
    public List<Product_Catalogue__c> prodTable {get; set;}
    public Integer toDelIdent {get; set;}
    public Integer toDelIdent1 {get; set;}
    public Integer addCount {get; set;}
    public Integer addCount1 {get; set;}
    private Integer nextIdent=1;
    private Integer nextIdent1=1;
    public Account acct;   
    
    public ProductEntryController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.acct = (Account)controller.getRecord();
        wrappers=new List<ProdWrapper>();
        cwraps=new List<CountWrapper>();
        prodTable = [SELECT Catalog_Display_Name__c, Portal_View__c, Sales__c, Installation_Support__c, Live_Demo_Vehicle__c, Services_Only__c, CSN__c FROM Product_Catalogue__c WHERE Partner_Account__c =: acct.Id];
        for (Integer idx=0; idx<1; idx++) {
            wrappers.add(new ProdWrapper(nextIdent++));
        }
        for (Integer idx=0; idx<1; idx++) {
            cwraps.add(new CountWrapper(nextIdent1++));
        }
    }
    public void noaction(){
        controller.save();
        for (Integer idx=0; idx<cwraps.size(); idx++) {
            if (cwraps[idx].prodCount.Country__c == 'United States') {
                cwraps[idx].rerender = true;
            }
        }
    }
    public PageReference returning(){
        PageReference pageRef = new PageReference('/apex/ConfirmAccount?scontrolCaching=1&id=' + ApexPages.currentPage().getParameters().get('id'));
        return pageRef;      
    }
    public void addRow() {
        for (Integer idx=0; idx<addCount; idx++) {
            wrappers.add(new ProdWrapper(nextIdent++));
        }
    }
    public void addRow1() {
        for (Integer idx=0; idx<addCount1; idx++) {
            cwraps.add(new CountWrapper(nextIdent1++));
        }
    }
    public void saveChanges(){
        controller.save();
        Account acc = [Select Portal_View_s__c FROM Account WHERE Id =: acct.Id];
        if(String.isEmpty(acc.Portal_View_s__c)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please enter a Portal View.'));
        } else{
            ApexPages.getMessages().clear();
        }
        wrappers.clear();
        wrappers.add(new ProdWrapper(1));
    }
    public List<SelectOption> getprodList() {
        List<SelectOption> choices = new List<SelectOption>();
        List<Product_Market_Sector__c> pms = new List<Product_Market_Sector__c>();
        List<Product_Market_Sector__c> pms1 = new List<Product_Market_Sector__c>();
        List<string> views = new List<string>();
        system.debug('account portal view: ' + acct.Portal_View_s__c + ', views is: ' + views);
        if(String.isEmpty(acct.Portal_View_s__c)){
            return null;
        }
        views = acct.Portal_View_s__c.split(';');
        List<string> prodid = new List<string>();
        pms = [SELECT Product__c, Portal_View__c, Sector__c FROM Product_Market_Sector__c WHERE Portal_View__c IN: views];
        for (Integer i=0; i<pms.size(); i++) {
            prodid.add(pms[i].Product__c);
        }
        List<Product2> prod = [SELECT Catalog_Display_Name__c FROM Product2 WHERE Id =: prodid];
        for (Integer i=0; i<prod.size(); i++) {
            choices.add(new SelectOption(prod[i].Catalog_Display_Name__c,prod[i].Catalog_Display_Name__c));
        }
        choices.sort();
        return choices;  
    }   
    public PageReference saveRecords() {
        List <Product_Catalogue__c> prodCats = new List <Product_Catalogue__c>();
        List <Country__c> ctries = new List <Country__c>();
        Account acc = new Account();
        acc.Id =  ApexPages.currentPage().getParameters().get('id');
        acc= [SELECT Portal_View_s__c FROM Account WHERE Id =: acc.Id];
        List<Product_Market_Sector__c> pms = new List<Product_Market_Sector__c>();
        for(ProdWrapper wrap: wrappers){
            List<string> views = new List<string>();
            views = acc.Portal_View_s__c.split(';');
            pms = [SELECT Id FROM Product_Market_Sector__c WHERE Portal_View__c IN: views AND Product__r.Catalog_Display_Name__c =: wrap.prodCat.For_Admin_Use__c];
            system.debug(pms);
            if(pms.size() == 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, wrap.prodCat.For_Admin_Use__c + 'is not an available product for these portal views.'));
    			return null;
            }
            for(Integer i=0; i < pms.size(); i++) {
                Product_Catalogue__c prodCatalog = new Product_Catalogue__c();
                prodCatalog.Sales__c = wrap.prodCat.Sales__c;
                prodCatalog.Services_Only__c = wrap.prodCat.Services_Only__c;
                prodCatalog.Partner_Account__c = acc.Id;
                prodCatalog.Product_Market_Sector__c = pms[i].Id; 
                prodCats.add(prodCatalog);
            }
        }
        insert prodCats;
        for(Integer i=0; i<prodcats.size(); i++){
            for(CountWrapper cwrap: cwraps){
                Country__c ctry = new Country__c();
            	ctry.Country__c = cwrap.prodCount.Country__c;
                ctry.State__c = cwrap.prodCount.State__c;
                ctry.Product_Catalog__c = prodCats[i].Id;
                if(ctry.Country__c == null){}
                else{
                ctries.add(ctry);
                }
            }
        }
        insert ctries;
        List <ProcessInstanceWorkitem> reqs = new List <ProcessInstanceWorkitem>();
        ProcessInstance pi = new ProcessInstance();
        PageReference pageRef = new PageReference('/' + acc.Id);
        reqs = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: acc.Id AND ProcessInstance.Status != 'Approved' AND ProcessInstance.Status != 'Rejected'];
        if(reqs.size()==0){}
        else{
            pageref = new PageReference('/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + reqs[0].id);
        }
        return pageref;
    }
    public class ProdWrapper {
        public Product_Catalogue__c prodCat {get; set;}
        public Integer ident {get; set;}
        public ProdWrapper(Integer inIdent) {
            ident = inIdent;
            prodCat = new Product_Catalogue__c();
            prodCat.Sales__c = true;
            prodCat.Services_Only__c = true;
        }
    }
    public class CountWrapper {
        public Country__c prodCount {get; set;}
        public Integer ident1 {get; set;}
        public boolean rerender {get; set;}
        public CountWrapper(Integer inIdent1) {
            ident1 = inIdent1;
            rerender = false;
            prodCount = new Country__c();         
        }
    }
    public PageReference nextPage(){
        PageReference pageRef = new PageReference('/apex/AddProducts');
        pageRef.getParameters().put('id', acct.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    public void delWrapper1() {
        controller.save();
        Integer toDelPos=-1;
        for (Integer idx=0; idx<cwraps.size(); idx++) {
            if (cwraps[idx].ident1==toDelIdent1) {
                toDelPos=idx;
            }
        }
        if (-1!=toDelPos) {
            cwraps.remove(toDelPos);
        }
    }
    public void delWrapper() {
        controller.save();
        Integer toDelPos=-1;
        for (Integer idx=0; idx<wrappers.size(); idx++) {
            if (wrappers[idx].ident==toDelIdent) {
                toDelPos=idx;
            }
        }
   
        if (-1!=toDelPos) {
            wrappers.remove(toDelPos);
        }
    }
}