public class QuicklinkToolkitCreation {
    public Quick_Link__c QL {get;set;}
    public Id QLid {get;set;} 
    public List<Quick_Link__c> QLs {get;set;}
    
    public QuicklinkToolkitCreation(ApexPages.StandardController control){
        QL = (Quick_Link__c)control.getRecord();
        QLs = [SELECT QuickLink_Label__c, Background_Color__c, Icon__c, Content_Type_s__c, Display_Order__c FROM Quick_Link__c WHERE QuickLink_Label__c != null];
    }
    
    public PageReference createQL(){
        insert QL;
        PageReference pageref = new PageReference('/apex/adminlandingpage');
        return pageref;
    }
    public PageReference removeQL(){
        QL = [SELECT Id FROM Quick_Link__c WHERE Id =: QLid];
        delete QL;
        PageReference pageref = new PageReference('/apex/adminlandingpage');
        return pageref;
    }

}