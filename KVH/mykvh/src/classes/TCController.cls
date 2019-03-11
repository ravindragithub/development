public class TCController {
    public Terms_and_Conditions__c TC {get;set;}
    public List <Terms_and_Conditions__c> TCs {get;set;}
    public Id tcid {get; set;}
    
    public TCController(ApexPages.StandardController controller){
        TC = (Terms_and_Conditions__c)Controller.getRecord();
        if(TC.Id != null){
        TC = [SELECT Id, Name, Name__c, Body__c FROM Terms_and_Conditions__c WHERE Id =: TC.Id];
        }
        TCs = [SELECT Name, Name__c, Body__c FROM Terms_and_Conditions__c];
    }
    public PageReference updateTC(){
        PageReference pageRef = new PageReference('/apex/UpdateTC?Id=' + tcid);
        pageRef.setRedirect(true);
        return pageRef;   
    }
    public PageReference updateRecord(){
        update TC;
        PageReference pageRef = new PageReference('/apex/adminlandingpage');
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference createRecord(){
        insert TC;
        PageReference pageRef = new PageReference('/apex/adminlandingpage');
        pageRef.setRedirect(true);
        return pageRef;
    }

}