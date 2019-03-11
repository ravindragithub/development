trigger IITTriggerOnSuspension on Suspension_Period__c (before insert) {
    
    // we create the one time charge as a discount and we need to associate the rev rule
    list<invoiceit_s__Revenue_Recognition_Rule__c> revRules = [SELECT Id
                                                               FROM invoiceit_s__Revenue_Recognition_Rule__c
                                                               WHERE Name = 'Full Recognition - On Invoice Date'
                                                               LIMIT 1];
    if(revRules.size() == 0) {
        for(Suspension_Period__c suspensionPeriod : trigger.new) {
            suspensionPeriod.addError('Full Recognition - On Invoice Date Revenue Rule is missing in your org');
        }

        return;
    }
    
    map<Id, invoiceit_s__Job_Rate_Plan_Charge__c> mapofCharge = new map<Id, invoiceit_s__Job_Rate_Plan_Charge__c>();
    invoiceit_s__Job_Rate_Plan_Charge__c charge;
    invoiceit_s__Job_Rate_Plan_Charge__c suspensionCharge;
    set<Id> setofCharges = new set<Id>();
  
    for(Suspension_Period__c SuspensionPeriod : trigger.new) {
        setofCharges.add(SuspensionPeriod.Order_Rate_Plan_Charge_Suspension__c);
    }
    map<Id, invoiceit_s__Job_Rate_Plan_Charge__c> mapofSuspensionCharges = new map<Id, invoiceit_s__Job_Rate_Plan_Charge__c>([SELECT invoiceit_s__Quantity__c, invoiceit_s__CurrencyL__c,Next_Uplift_Date__c,invoiceit_s__Order__c,invoiceit_s__Price_Type__c,invoiceit_s__VAT_Percentage__c,invoiceit_s__Unit_Price__c,invoiceit_s__Job_Rate_Plan__c,invoiceit_s__Discount_Value__c,invoiceit_s__Price_Format__c,invoiceit_s__Service_End_Date__c  FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE Id in:setofCharges ]);
    invoiceit_s__Job__c order;
    
    for(Suspension_Period__c suspensionPeriod : trigger.new) {
        suspensionCharge = mapofSuspensionCharges.get(SuspensionPeriod.Order_Rate_Plan_Charge_Suspension__c);
        system.debug('---->' +suspensionCharge.invoiceit_s__Unit_Price__c);
        
        decimal newUnitPrice = 0;
        system.debug('suspensionCharge.invoiceit_s__Price_Type__c === ' + suspensionCharge.invoiceit_s__Price_Type__c);
        decimal noOfMonths = IITCommonUtilClass.calculateDiffBetweenDatesInMonths(SuspensionPeriod.Suspension_Start_Date__c , SuspensionPeriod.Suspension_End_Date__c.addDays(1), suspensionCharge.invoiceit_s__Price_Type__c);
        if(suspensionCharge.invoiceit_s__Price_Type__c == 'Monthly') {
            newUnitPrice = noOfMonths * suspensionCharge.invoiceit_s__Unit_Price__c;
        } else if(suspensionCharge.invoiceit_s__Price_Type__c == 'Quarterly') {
            newUnitPrice = noOfMonths * (suspensionCharge.invoiceit_s__Unit_Price__c/3);
        } else if(suspensionCharge.invoiceit_s__Price_Type__c == 'Half Yearly') {
            newUnitPrice = noOfMonths * (suspensionCharge.invoiceit_s__Unit_Price__c/6);
        } else if(suspensionCharge.invoiceit_s__Price_Type__c == 'Annual') {
            newUnitPrice = noOfMonths * (suspensionCharge.invoiceit_s__Unit_Price__c/12);
        }
        
        system.debug('newUnitPrice == ' + newUnitPrice);
        charge = new invoiceit_s__Job_Rate_Plan_Charge__c();
        charge.invoiceit_s__Quantity__c = suspensionCharge.invoiceit_s__Quantity__c;
        charge.invoiceit_s__Price_Type__c = 'One Time';
        charge.invoiceit_s__Unit_Price__c = -1 *  newUnitPrice;
        if(suspensionCharge.invoiceit_s__VAT_Percentage__c == null) {
            suspensionCharge.invoiceit_s__VAT_Percentage__c = 0;
        }
        charge.invoiceit_s__VAT_Percentage__c = suspensionCharge.invoiceit_s__VAT_Percentage__c ;
        charge.invoiceit_s__Discount_Value__c = suspensionCharge.invoiceit_s__Discount_Value__c;
        charge.invoiceit_s__VAT__c = ((-1 * charge.invoiceit_s__Quantity__c * charge.invoiceit_s__Unit_Price__c) - charge.invoiceit_s__Discount_Value__c)*(charge.invoiceit_s__VAT_Percentage__c/100);
        charge.invoiceit_s__Job_Rate_Plan__c = suspensionCharge.invoiceit_s__Job_Rate_Plan__c ;
        charge.Name = 'Suspension Charge';
        charge.invoiceit_s__Sequence_No__c = 10;
        charge.invoiceit_s__Service_Activation_Date__c = suspensionPeriod.Suspension_Start_Date__c;
        charge.invoiceit_s__Status__c = 'Ready to Bill';
        charge.invoiceit_s__CurrencyL__c = suspensionCharge.invoiceit_s__CurrencyL__c;
        charge.invoiceit_s__Revenue_Recognition_Rule__c = revRules[0].Id;
        
        if(suspensionCharge.invoiceit_s__Service_End_Date__c != null) {
            suspensionCharge.invoiceit_s__Service_End_Date__c = suspensionCharge.invoiceit_s__Service_End_Date__c.addDays(SuspensionPeriod.Suspension_Start_Date__c.daysBetween(SuspensionPeriod.Suspension_End_Date__c));
            suspensionCharge.invoiceit_s__Service_End_Date__c = suspensionCharge.invoiceit_s__Service_End_Date__c.addDays(1);
        }
        
        if(suspensionCharge.Next_Uplift_Date__c != null) {
            suspensionCharge.Next_Uplift_Date__c = suspensionCharge.Next_Uplift_Date__c.addDays(SuspensionPeriod.Suspension_Start_Date__c.daysBetween(SuspensionPeriod.Suspension_End_Date__c));
            suspensionCharge.Next_Uplift_Date__c = suspensionCharge.Next_Uplift_Date__c.addDays(1);
        }
        mapofCharge.put(SuspensionPeriod.Id, charge);
        order = new invoiceit_s__Job__c(Id = suspensionCharge.invoiceit_s__Order__c, invoiceit_s__Recalculate__c = true);
    }
    
    insert mapofCharge.values();
    upsert mapofSuspensionCharges.values();
    update order;
    for(Suspension_Period__c SuspensionPeriod : trigger.new) {
        SuspensionPeriod.Order_Rate_Plan_Charge_Discount__c = mapofCharge.get(SuspensionPeriod.Id).Id;
    }
}