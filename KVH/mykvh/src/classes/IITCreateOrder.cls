public with sharing class IITCreateOrder {
    public RecordType  recordTypeObj {get;Set;}
    
    public invoiceit_s__Job__c job {get;Set;}
    public IITCreateOrder(ApexPages.StandardController controller) {
        job = new invoiceit_s__Job__c();
        job = (invoiceit_s__Job__c)controller.getRecord();
        String recordId = system.currentPageReference().getParameters().get('RecordType');
        if(recordId != null) {
            recordTypeObj = [SELECT Name FROM RecordType WHERE Id =: recordId];
            job.RecordTypeId =  recordId;
        } else {
             String sQuery = ControllerCloneOrder.getObjectSelectQuery('invoiceit_s__Job__c') + ' WHERE  id = \'' + job.id + '\'';
            sQuery = String.escapeSingleQuotes(sQuery);
            sQuery = sQuery.replace('\\','');
            job = database.query(sQuery);
            
             recordTypeObj = [SELECT Name FROM RecordType WHERE Id =: job.RecordTypeId];
        }
    }
    
    public pageReference save() {
        try {
        job.invoiceit_s__Override_Vat_Tax__c = true;
        upsert job;
        
        list<invoiceit_s__Job_Rate_Plan_Charge__c> listofCharges = new list<invoiceit_s__Job_Rate_Plan_Charge__c>();
        listofCharges = [SELECT Id FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE invoiceit_s__Order__c =: job.Id ];
        update listofCharges;
        
        job.invoiceit_s__Recalculate__c = true;
        upsert job;
        
        } catch(exception ex) {
            Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.ERROR,'Please follow the exception messege ==>>' + ex.getTypeName()+':'+ex.getMessage() + ':LINE ' + ex.getLineNumber());
            Apexpages.addMessage(errorMessage);
            return null;
        }
        return new PageReference('/' + job.Id);
    }
    
    public void quicksave() {
        save();
    }
}