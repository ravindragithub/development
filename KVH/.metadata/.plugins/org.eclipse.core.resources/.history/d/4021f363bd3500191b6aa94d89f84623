public with sharing class IITControllerCreateAdhocInvoice {
    public invoiceit_s__Job__c order {get;set;}
    public String responseMessage;
    public invoiceit_s__Job__c job{get;set;}
    date cuttOffDate;
    public boolean firstInvoice{get;set;}
    
    public IITControllerCreateAdhocInvoice(ApexPages.StandardController controller) {
        firstInvoice = true;
        
        order = (invoiceit_s__Job__c) controller.getRecord();
        order = [SELECT invoiceit_s__Status__c, Name, invoiceit_s__Service_Activation_Date__c, Alignment_Date_1__c, Alignment_Date_2__c 
                 FROM invoiceit_s__Job__c 
                 WHERE Id =: order.Id];
        
        // just initalize the instance, since we want invoice date and targetdate
        job = new invoiceit_s__Job__c();
        
        if(order.invoiceit_s__Service_Activation_Date__c == null) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Service Activation Date is blank on the Order'));
            return;
        } 
        
        if(order.Alignment_Date_1__c == null || order.Alignment_Date_1__c == null) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Alignment date(s) are blank on the Order. Please populate the dates.'));
            return;
        }
            
            order.Alignment_Date_2__c = order.Alignment_Date_1__c.addMonths(6);
            Integer noOfDays1 = order.invoiceit_s__Service_Activation_Date__c.daysBetween(order.Alignment_Date_1__c);
            Integer noOfDays2 = order.invoiceit_s__Service_Activation_Date__c.daysBetween(order.Alignment_Date_2__c);
            system.debug('noOfDays1=== ' + noOfDays1);
            system.debug(noOfDays2);
            if(noOfDays1 < noOfDays2) {
                cuttOffDate = order.Alignment_Date_1__c;
                if(noOfDays1 < 0) {cuttOffDate = order.Alignment_Date_2__c;}
            } else {
                cuttOffDate = order.Alignment_Date_2__c;
                if(noOfDays2 < 0) {cuttOffDate = order.Alignment_Date_1__c;}
            }
            
            job.invoiceit_s__Service_End_Date__c = cuttOffDate;
    }
    
    public void onChangefirstInvoice() {
        if(firstInvoice) {
            if(order.Alignment_Date_1__c == null || order.Alignment_Date_1__c == null) {
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Alignment date(s) are blank on the Order. Please populate the dates.'));
                return;
            }
            
            order.Alignment_Date_2__c = order.Alignment_Date_1__c.addMonths(6);
            Integer noOfDays1 = order.invoiceit_s__Service_Activation_Date__c.daysBetween(order.Alignment_Date_1__c);
            Integer noOfDays2 = order.invoiceit_s__Service_Activation_Date__c.daysBetween(order.Alignment_Date_2__c);
            system.debug('noOfDays1=== ' + noOfDays1);
            system.debug(noOfDays2);
            if(noOfDays1 < noOfDays2) {
                cuttOffDate = order.Alignment_Date_1__c;
                if(noOfDays1 < 0) {cuttOffDate = order.Alignment_Date_2__c;}
            } else {
                cuttOffDate = order.Alignment_Date_2__c;
                if(noOfDays2 < 0) {cuttOffDate = order.Alignment_Date_1__c;}
            }
            
            job.invoiceit_s__Service_End_Date__c = cuttOffDate;
        }
    }
    
    public PageReference createAdhocInvoice() {
        Date invoiceDate, targetDate, cutoffDate;
        if(job.invoiceit_s__Service_Activation_Date__c == null || job.invoiceit_s__Service_End_Date__c == null) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Invoice Date or Cut Off Date is blank.'));
            return null;    
        }
        try {

            invoiceit_s__.CustomInvoiceGenerator invoiceGeneratorNew = new invoiceit_s__.CustomInvoiceGenerator();
            invoiceit_s__.CustomInvoiceGenerator.MethodParameters methodParameters = new invoiceit_s__.CustomInvoiceGenerator.MethodParameters();
            methodParameters.orderId = order.Id;
            methodParameters.invoiceDate = job.invoiceit_s__Service_Activation_Date__c;
            methodParameters.targetDate = job.invoiceit_s__Service_End_Date__c;
            methodParameters.cutoffDate = job.invoiceit_s__Service_End_Date__c;
            methodParameters.shouldBillUsages = true;
            methodParameters.simulateInvoiceGeneration = false;
            methodParameters.autoPostInvoice = false;
            responseMessage = invoiceGeneratorNew.generateInvoiceForOrder(methodParameters);
            

            if( responseMessage != null && responseMessage.length() > 0 && !responseMessage.contains('null')) {
                if(responseMessage.contains('ERROR') || responseMessage.contains('null')) {
                    Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, responseMessage)); 
                } else {
                    return new PageReference('/' + responseMessage);    
                }
            } else {
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, system.Label.invoiceit_s.NoInvoicesGenerated));
            }   
        } catch(Exception ex) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, system.Label.invoiceit_s.ExceptionMessage + ex.getTypeName() + ':'+ex.getMessage() + ':'  + ex.getLineNumber()));         
        }

        return null;
    }
}




/*
    Call the below code
        invoiceit_s__.CustomInvoiceGenerator main = new invoiceit_s__.CustomInvoiceGenerator();
        invoiceit_s__.CustomInvoiceGenerator.MethodParameters methodParameters = new invoiceit_s__.CustomInvoiceGenerator.MethodParameters();
        invoiceit_s__Job__c job = [SELECT invoiceit_s__Status__c, Name, invoiceit_s__Service_Activation_Date__c FROM invoiceit_s__Job__c WHERE Id = 'a0Ni000000Z4Cx0EAF'];
        methodParameters.orderId = job.Id;
        methodParameters.invoiceDate = job.invoiceit_s__Service_Activation_Date__c;
        methodParameters.targetDate = job.invoiceit_s__Service_End_Date__c;
        methodParameters.cutoffDate = job.invoiceit_s__Service_End_Date__c;
        methodParameters.shouldBillUsages = true;
        methodParameters.simulateInvoiceGeneration = false;
        methodParameters.autoPostInvoice = false;
        main.generateInvoiceForOrder(methodParameters);
*/