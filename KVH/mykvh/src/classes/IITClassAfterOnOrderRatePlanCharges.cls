public with sharing class IITClassAfterOnOrderRatePlanCharges {
    public static boolean ExecuteTrigger = true;

    // Requirements :
    // 1) KVH-51  --> VAT should be applied when, (Order.Shipping_Account = 'United Kingdom' Or 'Isle of Man') AND (Order.Intended_Use__c = 'LOCAL UK WATERS' || Order.Intended_Use__c == 'LAND')
    // 2) KVH-110 --> Tax should be applied when, (order.Withholding_Tax_Percentage__c > 0)
    // 3) Order.Invoice_Details__c = 'Consolidated' then the all the charges.Invoice Grouping = “Master Order.Account”
    // 4)  populating the next uplift date here
    public void handleBeforeOnOrderCharge(map<Id,invoiceit_s__Job_Rate_Plan_Charge__c> newMap, map<Id,invoiceit_s__Job_Rate_Plan_Charge__c> oldMap, list<invoiceit_s__Job_Rate_Plan_Charge__c> charges) {
        map<Id, invoiceit_s__Job__c> map_OrderId_Job = new map<Id, invoiceit_s__Job__c>();
        invoiceit_s__Job__c order;
        Id childOrderRecordTypeId = Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Child Order').getRecordTypeId();
        decimal taxPercentage;
        
        for(invoiceit_s__Job_Rate_Plan_Charge__c charge : charges) {
            map_OrderId_Job.put(charge.invoiceit_s__Order__c, null);        
        }
        
        map_OrderId_Job = new map<Id, invoiceit_s__Job__c>([SELECT Shipping_Account__r.BillingCountry, IITIntended_Use__c, Withholding_Tax_Percentage__c, Invoice_Details__c, RecordtypeID
                                                            FROM invoiceit_s__Job__c
                                                            WHERE Id IN: map_OrderId_Job.keySet()]
                                                            );
                         
        for(invoiceit_s__Job_Rate_Plan_Charge__c charge : charges) {
            order = map_OrderId_Job.get(charge.invoiceit_s__Order__c);      
            
            /********* calculation of VAT starts here ***********/
            if( (order.Shipping_Account__r.BillingCountry == 'United Kingdom' || order.Shipping_Account__r.BillingCountry == 'Isle of Man') 
                 && 
                (order.IITIntended_Use__c == 'LOCAL UK WATERS' || order.IITIntended_Use__c == 'LAND')
              ) 
            {
                charge.invoiceit_s__VAT_Percentage__c = 20;
                charge.invoiceit_s__VAT__c = ((charge.invoiceit_s__Quantity__c * charge.invoiceit_s__Unit_Price__c) - charge.invoiceit_s__Discount_Value__c)*(charge.invoiceit_s__VAT_Percentage__c/100);
            }  
            else
            {
                charge.invoiceit_s__VAT_Percentage__c = 0;
                charge.invoiceit_s__VAT__c = 0;
            }
            /********* calculation of VAT ends here ***********/
            
            /********* calculation of Tax starts here ***********/
            if((order.Withholding_Tax_Percentage__c != null && order.Withholding_Tax_Percentage__c > 0))
            {
                taxPercentage = 100 - order.Withholding_Tax_Percentage__c;
                charge.invoiceit_s__Price__c = (charge.invoiceit_s__Quantity__c * charge.invoiceit_s__Unit_Price__c);
                charge.invoiceit_s__Net_Total__c = (charge.invoiceit_s__Quantity__c * charge.invoiceit_s__Unit_Price__c) - charge.invoiceit_s__Discount_Value__c;
                charge.invoiceit_s__TAX_Percentage__c = order.Withholding_Tax_Percentage__c;
                charge.invoiceit_s__Tax__c = (charge.invoiceit_s__Net_Total__c/(taxPercentage/100) - charge.invoiceit_s__Net_Total__c);  
            }  
            else
            {
                charge.invoiceit_s__TAX_Percentage__c = 0;
                charge.invoiceit_s__Tax__c = 0;     
                charge.invoiceit_s__Price__c = (charge.invoiceit_s__Quantity__c * charge.invoiceit_s__Unit_Price__c);
                charge.invoiceit_s__Net_Total__c = charge.invoiceit_s__Price__c - charge.invoiceit_s__Discount_Value__c;
                
            }
            /********* calculation of Tax ends here ***********/
            
            
            /********* populating the invoice grouping starts here ***********/
            if((order.RecordtypeID == childOrderRecordTypeId && order.Invoice_Details__c == 'Consolidated'))
            {
                charge.invoiceit_s__Invoice_Grouping__c = 'Master Order.Account';
            }  
            else
            {
                charge.invoiceit_s__Invoice_Grouping__c = null;
            }
            /********* populating the invoice grouping ends here ***********/
            
            
            system.debug('before first condition');
            /********* populating the next uplift date here, populate the uplift date only for the new ones ***********/
            date dt = Date.newInstance(2015, 01, 01); 
            if(charge.Legacy_Orders__c == false && charge.Next_Uplift_Date__c == null && charge.invoiceit_s__Service_Activation_Date__c != null && charge.invoiceit_s__Service_Activation_Date__c >= dt)
            {
                system.debug('first condition');
                if(charge.invoiceit_s__Price_Type__c != 'One Time' && charge.invoiceit_s__Price_Type__c != 'Usage' && charge.invoiceit_s__Uplift__c != null && charge.invoiceit_s__Uplift__c > 0) 
                {
                    system.debug('second condition');
                    system.debug('charge.invoiceit_s__Service_Activation_Date__c ' + charge.invoiceit_s__Service_Activation_Date__c);
                    charge.Next_Uplift_Date__c = charge.invoiceit_s__Service_Activation_Date__c.addYears(1);
                    system.debug('charge.charge.Next_Uplift_Date__c ' + charge.Next_Uplift_Date__c);
                    charge.invoiceit_s__Uplift_Frequency__c = 'Annual';
                }
            }  
            /********* populating the invoice grouping ends here ***********/
            
        }    
    }
    
    public void handleAfterOnOrderCharge(map<Id,invoiceit_s__Job_Rate_Plan_Charge__c> newMap, map<Id,invoiceit_s__Job_Rate_Plan_Charge__c> oldMap, list<invoiceit_s__Job_Rate_Plan_Charge__c> charges) {
      
    }
}