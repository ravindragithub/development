public with sharing class IITClassAfterOInvoiceLine {
    
     // Revenue_Recognition_Rule__c and date should inherit from ORPC
     // Recognition End Date = revenue recognition date + no of days between invoiceLine.charge start date and invoiceLine.charge end date
     // If it's a one time charge then populate the service start date as OrderCharge.ServiceStart Date
     public void handleBeforeOnInvoiceLine(map<Id,invoiceit_s__Invoice_Lines__c > newMap, map<Id,invoiceit_s__Invoice_Lines__c > oldMap, list<invoiceit_s__Invoice_Lines__c > charges) {
        set<Id> orderChargeIds = new set<Id>();
    
        for(invoiceit_s__Invoice_Lines__c invoiceLine : charges) {
            if(invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__c != null) {
                orderChargeIds.add(invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__c);
            }
        }
        
        map<Id, invoiceit_s__Job_Rate_Plan_Charge__c> orderCharges;
        orderCharges = new map<Id, invoiceit_s__Job_Rate_Plan_Charge__c>([SELECT invoiceit_s__Revenue_Recognition_Rule__c,
                                                                        invoiceit_s__Revenue_Recognition_Date__c,
                                                                        invoiceit_s__Service_Activation_Date__c,
                                                                        invoiceit_s__Service_End_Date__c,
                                                                        invoiceit_s__Price_Type__c
                                                                        FROM invoiceit_s__Job_Rate_Plan_Charge__c
                                                                        WHERE Id IN: orderChargeIds 
                                                                        ]);
        
        invoiceit_s__Job_Rate_Plan_Charge__c orderCharge;
        for(invoiceit_s__Invoice_Lines__c invoiceLine : charges) {
            if(invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__c != null) {
               orderCharge = orderCharges.get(invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__c);
               
               // populate the rev date and rule from the Order Rate Plan Charge
               invoiceLine.RevenueRecognitionRuleNew__c = orderCharge.invoiceit_s__Revenue_Recognition_Rule__c;
               invoiceLine.Revenue_Recognition_Date__c = orderCharge.invoiceit_s__Revenue_Recognition_Date__c;
               
               if(orderCharge.invoiceit_s__Price_Type__c == 'One Time') {
                   invoiceLine.invoiceit_s__Service_Start_Date__c = orderCharge.invoiceit_s__Service_Activation_Date__c;
               }

               // end date will be null for one time charge
               if(invoiceLine.invoiceit_s__Service_End_Date__c == null) {
                   invoiceLine.invoiceit_s__Service_End_Date__c = invoiceLine.invoiceit_s__Service_Start_Date__c;
               }
               
               Integer numberDaysbtw = invoiceLine.invoiceit_s__Service_Start_Date__c.daysBetween(invoiceLine.invoiceit_s__Service_End_Date__c);
               
               if(invoiceLine.Revenue_Recognition_Date__c != null) {
                   invoiceLine.RevenueRecognitionEndDatenew__c = invoiceLine.RevenueRecognitionEndDatenew__c.addDays(numberDaysbtw);
               }  
            }
        }   
     }
     
     public void handleAfterOnInvoiceLine(map<Id,invoiceit_s__Invoice_Lines__c > newMap, map<Id,invoiceit_s__Invoice_Lines__c > oldMap) {
        if(trigger.isInsert) {
            list<invoiceit_s__Invoice_Lines__c> invoiceLines;
            invoiceLines = [SELECT Id
                           FROM invoiceit_s__Invoice_Lines__c
                           WHERE Id In : newMap.keySet()
                           //AND
                           //invoiceit_s__Job__r.Mid_Term_Order__c = true
                           AND
                           Split_Invoice__c = false
                           AND
                           invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Price_Type__c != 'One Time'
                           AND
                           invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Price_Type__c != 'Monthly'
                           ];        
            
            if(invoiceLines.size() > 0) {
                IITCommonUtilClass.calculateQuantity(invoiceLines); 
            }
        }
     }
}