public with sharing class IITClassAfterOnOpptyRatePlanCharges {

    public void handleBeforeOnOpptyCharge(map<Id,invoiceit_crmx__Opportunity_Rate_Plan_Charge__c> newMap, map<Id,invoiceit_crmx__Opportunity_Rate_Plan_Charge__c> oldMap, list<invoiceit_crmx__Opportunity_Rate_Plan_Charge__c> charges) {
        map<Id, invoiceit_crmx__Opportunity_Rate_Plan__c> map_OpportunityId_Oppty = new map<Id, invoiceit_crmx__Opportunity_Rate_Plan__c>();
        Opportunity oppty;
        invoiceit_crmx__Opportunity_Rate_Plan__c orp;
        
        for(invoiceit_crmx__Opportunity_Rate_Plan_Charge__c charge : charges) {
            map_OpportunityId_Oppty.put(charge.invoiceit_crmx__Opportunity_Rate_Plan__c, null);        
        }
        
        map_OpportunityId_Oppty = new map<Id, invoiceit_crmx__Opportunity_Rate_Plan__c>([SELECT invoiceit_crmx__Opportunity_Product__r.invoiceit_crmx__Opportunity__r.Shipping_Account__r.BillingCountry, 
                                                              invoiceit_crmx__Opportunity_Product__r.invoiceit_crmx__Opportunity__r.IITIntended_Use__c,
                                                              invoiceit_crmx__Opportunity_Product__r.invoiceit_crmx__Opportunity__c
                                                              FROM invoiceit_crmx__Opportunity_Rate_Plan__c
                                                              WHERE Id IN: map_OpportunityId_Oppty.keySet()]
                                                             );
                         
        for(invoiceit_crmx__Opportunity_Rate_Plan_Charge__c charge : charges) {
            orp = map_OpportunityId_Oppty.get(charge.invoiceit_crmx__Opportunity_Rate_Plan__c);      
            
            if((orp.invoiceit_crmx__Opportunity_Product__r.invoiceit_crmx__Opportunity__r.Shipping_Account__r.BillingCountry == 'United Kingdom' || orp.invoiceit_crmx__Opportunity_Product__r.invoiceit_crmx__Opportunity__r.Shipping_Account__r.BillingCountry == 'Isle of Man') 
                 && 
                (orp.invoiceit_crmx__Opportunity_Product__r.invoiceit_crmx__Opportunity__r.IITIntended_Use__c == 'LOCAL UK WATERS' || orp.invoiceit_crmx__Opportunity_Product__r.invoiceit_crmx__Opportunity__r.IITIntended_Use__c == 'LAND')) 
            {
                charge.invoiceit_crmx__Product_Charge_Category__c = 'Taxable';  
                charge.invoiceit_crmx__VAT_Percentage__c = 20;
                charge.invoiceit_crmx__TAX_Percentage__c = 0;
                charge.invoiceit_crmx__VAT__c = ((charge.invoiceit_crmx__Quantity__c * charge.invoiceit_crmx__Unit_Price__c) - charge.invoiceit_crmx__Discount_Value__c)*(charge.invoiceit_crmx__VAT_Percentage__c/100);
                charge.invoiceit_crmx__Tax__c = ((charge.invoiceit_crmx__Quantity__c * charge.invoiceit_crmx__Unit_Price__c) - charge.invoiceit_crmx__Discount_Value__c)*(charge.invoiceit_crmx__Tax_Percentage__c/100);  
            }  
            else
            {
                charge.invoiceit_crmx__Product_Charge_Category__c = 'Non Taxable';
                charge.invoiceit_crmx__VAT_Percentage__c = 0;
                charge.invoiceit_crmx__Tax_Percentage__c = 0;
                charge.invoiceit_crmx__VAT__c = 0;
                charge.invoiceit_crmx__Tax__c = 0; 
            }
        }    
    }
}