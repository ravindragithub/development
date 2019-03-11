/* ************************************************************
 * Created By  : Gopi Kishore
 * Created Date: 16/04/2015 
 * Description : 1) Creating invoice commission with invoicelines with order and product.
                 2) Single invoice having only one invoice commission salesAgent.
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/
global class InvoiceCommissionCreationBatch implements Database.batchable<sObject>{ 
    
    global Database.querylocator start(Database.BatchableContext BC) {
        List<InvoiceLineCommissions__c> ILC = InvoiceLineCommissions__c.getall().values();
        List<String> SD = ILC[0].InvoiceLine_SD__c.split(',');
        List<String> ED = ILC[0].InvoiceLine_ED__c.split(',');
        
        String orderLegalEntity = ILC[0].OrderLegalEntity__c;
        
        DateTime SDDate = DateTime.newinstance(Integer.valueOF(SD[0]),Integer.valueOF(SD[1]),Integer.valueOF(SD[2]));
        DateTime EDDate = DateTime.newinstance(Integer.valueOF(ED[0]),Integer.valueOF(ED[1]),Integer.valueOF(ED[2]));
        
        String startDate = SDDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        String endDate   = EDDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        
        Boolean batchRunCheckBox = false;
        //Database.query('Select Id FROM Account WHERE CreatedDate<'+formatedDt);
        
        //ID lineID = 'a2R13000001hNWm';
        
        return Database.getQueryLocator('SELECT Id,Name,invoiceit_s__Product__c,invoiceit_s__Job__c FROM invoiceit_s__Invoice_Lines__c WHERE CreatedDate >=: SDDate AND CreatedDate <=: EDDate AND invoiceit_s__Job__r.Legal_Entity__c=:orderLegalEntity');  
       //return Database.getQueryLocator('SELECT Id,Name,invoiceit_s__Product__c,invoiceit_s__Job__c FROM invoiceit_s__Invoice_Lines__c WHERE ID=:lineID');  
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        InvoiceLineObjectTrigger.CreatingInvoiceLineCommision(scope,'update','BatchRun');
    }
    
    global void finish(Database.BatchableContext BC){  
    }
}