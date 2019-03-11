public with sharing class IITClassAfterOnQuoteRatePlanCharges {
    public static string quoteId;
    
    public void handleBeforeOnQuoteCharge(map<Id,invoiceit_s__Quote_Rate_Plan_Charge__c> newMap, map<Id,invoiceit_s__Quote_Rate_Plan_Charge__c> oldMap, list<invoiceit_s__Quote_Rate_Plan_Charge__c> charges) {
        map<Id, invoiceit_s__Quote_Rate_Plan__c> map_QuoteId_Job = new map<Id, invoiceit_s__Quote_Rate_Plan__c>();
        invoiceit_s__Quote__c order;
        invoiceit_s__Quote_Rate_Plan__c qrp;
        
        for(invoiceit_s__Quote_Rate_Plan_Charge__c charge : charges) {
            map_QuoteId_Job.put(charge.invoiceit_s__Quote_Rate_Plan__c, null);        
        }
        
        map_QuoteId_Job = new map<Id, invoiceit_s__Quote_Rate_Plan__c>([SELECT invoiceit_s__Quote_Product__r.invoiceit_s__Quote__r.Shipping_Account__r.BillingCountry, 
                                                            invoiceit_s__Quote_Product__r.invoiceit_s__Quote__r.IITIntended_Use__c,
                                                            invoiceit_s__Quote_Product__r.invoiceit_s__Quote__c
                                                            FROM invoiceit_s__Quote_Rate_Plan__c
                                                             WHERE Id IN: map_QuoteId_Job.keySet()]
                                                           );
        
        system.debug('map_QuoteId_Job ' + map_QuoteId_Job);                 
        for(invoiceit_s__Quote_Rate_Plan_Charge__c charge : charges) {
            qrp = map_QuoteId_Job.get(charge.invoiceit_s__Quote_Rate_Plan__c);      
            quoteId = qrp.invoiceit_s__Quote_Product__r.invoiceit_s__Quote__c;
            
            if((qrp.invoiceit_s__Quote_Product__r.invoiceit_s__Quote__r.Shipping_Account__r.BillingCountry == 'United Kingdom' || qrp.invoiceit_s__Quote_Product__r.invoiceit_s__Quote__r.Shipping_Account__r.BillingCountry == 'Isle of Man') 
                 && 
                (qrp.invoiceit_s__Quote_Product__r.invoiceit_s__Quote__r.IITIntended_Use__c == 'LOCAL UK WATERS' || qrp.invoiceit_s__Quote_Product__r.invoiceit_s__Quote__r.IITIntended_Use__c == 'LAND')) 
            {
                charge.invoiceit_s__Product_Charge_Category__c = 'Taxable';  
                charge.invoiceit_s__VAT_Percentage__c = 20;
                charge.invoiceit_s__TAX_Percentage__c = 0;
                charge.invoiceit_s__VAT__c = ((charge.invoiceit_s__Quantity__c * charge.invoiceit_s__Unit_Price__c) - charge.invoiceit_s__Discount_Value__c)*(charge.invoiceit_s__VAT_Percentage__c/100);
                charge.invoiceit_s__Tax__c = ((charge.invoiceit_s__Quantity__c * charge.invoiceit_s__Unit_Price__c) - charge.invoiceit_s__Discount_Value__c)*(charge.invoiceit_s__Tax_Percentage__c/100);  
            }  
            else
            {
                charge.invoiceit_s__Product_Charge_Category__c = 'Non Taxable';
                charge.invoiceit_s__VAT_Percentage__c = 0;
                charge.invoiceit_s__TAX_Percentage__c = 0;
                charge.invoiceit_s__VAT__c = 0;
                charge.invoiceit_s__Tax__c = 0; 
            }
        }    
    }
}