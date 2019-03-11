public with sharing class controllerSyncQuote {
    public invoiceit_s__Quote__c quoteObj;
    public controllerSyncQuote(ApexPages.StandardController controller) {
        quoteObj = new invoiceit_s__Quote__c();
        quoteObj = (invoiceit_s__Quote__c) controller.getRecord();
        quoteObj = [SELECT Id,invoiceit_s__CurrencyL__c,invoiceit_crmx__Opportunity__r.invoiceit_crmx__CurrencyL__c,invoiceit_s__Sync_Quote__c,invoiceit_crmx__Opportunity__c  FROM invoiceit_s__Quote__c WHERE Id =: quoteObj.Id ];
        
        if(quoteObj.invoiceit_crmx__Opportunity__c == null ) {
            Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'No opportunity is related for this quote. Please select opportunity to sync quote.');
            Apexpages.addMessage(infoMessage);
        }
        
        if(quoteObj.invoiceit_crmx__Opportunity__r.invoiceit_crmx__CurrencyL__c != quoteObj.invoiceit_s__CurrencyL__c) {
            Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'Opportunity & quote currencies are different. This cannot be synced to opportunity.');
            Apexpages.addMessage(infoMessage);
        }
    }
    
    public pageReference SyncQuote() {
      try {
        if(!quoteObj.invoiceit_s__Sync_Quote__c && quoteObj.invoiceit_crmx__Opportunity__c != null && quoteObj.invoiceit_crmx__Opportunity__r.invoiceit_crmx__CurrencyL__c == quoteObj.invoiceit_s__CurrencyL__c) {
            list<invoiceit_s__Quote__c> listofQuote = [SELECT Id FROM invoiceit_s__Quote__c WHERE invoiceit_crmx__Opportunity__c =: quoteObj.invoiceit_crmx__Opportunity__c AND invoiceit_s__Sync_Quote__c = true AND Id !=: quoteObj.Id];
            for(invoiceit_s__Quote__c quote : listofQuote ) {
                quote.invoiceit_s__Sync_Quote__c = false;
            } 
            if(!listofQuote.isEmpty())
                update listofQuote;
                
            quoteObj.invoiceit_s__Sync_Quote__c = true;
            update quoteObj;
        } 
       } catch(exception ex) {
           Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.ERROR, 'An excepection has occurred ' + ex.getTypeName()+':'+ex.getMessage() + ':LINE ' + ex.getLineNumber());
            Apexpages.addMessage(errorMessage);
       } 
        pagereference pg = new pagereference('/'+quoteObj.Id);
        return pg;
    }

}