global with sharing class IITRevenueTransactions {
    public static string processRevenueTransactions(Id invoiceId, Id invoiceLineId) {
        savepoint sp = database.setsavepoint();
        try {
            list<invoiceit_s__Revenue_Transaction__c> listofrevenueTransactions = new list<invoiceit_s__Revenue_Transaction__c>();
            // We need to write the code in trigger on what use cases the check box must be true.
            Date dCompare;
            Decimal recognisedRevenue;
            Decimal deferredRevenue;
            invoiceit_s__Revenue_Transaction__c revenueTransaction;

            //Get the list of all revenue periods in the org
            list<invoiceit_s__Revenue_Period__c> revenuePeriods = [select Id, Name, invoiceit_s__Revenue_Period_Start_Date__c,
                                                 invoiceit_s__Revenue_Period_End_Date__c
                                                 FROM invoiceit_s__Revenue_Period__c
                                                 ORDER BY invoiceit_s__Revenue_Period_Start_Date__c];

            //This would store all the revenue forecasts to delete
            //Everytime the revenue forecasts are created for an order/charge, the older ones are deleted.
            list<invoiceit_s__Revenue_Transaction__c> revenueTransactionsToDelete;

            list<invoiceit_s__Invoice_Lines__c> listofInvoiceLines = new list<invoiceit_s__Invoice_Lines__c>();

            if (invoicelineId == null) {
                listofInvoiceLines = [SELECT Id, invoiceit_s__Total_Line_Amount__c,RevenueRecognitionRuleNew__c, BillingPeriod__c, invoiceit_s__Calculated_Quantity__c,
                                   RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Type__c ,RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Date__c,
                                  invoiceit_s__Invoice__r.invoiceit_s__Account__c, Revenue_Recognition_Date__c,RevenueRecognitionEndDatenew__c,
                                  invoiceit_s__Service_Start_Date__c, invoiceit_s__Service_End_Date__c, invoiceit_s__Invoice__c ,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Service_Activation_Date__c,
                                  invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Revenue_Recognition_Date__c,
                                  invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Service_End_Date__c,
                                  invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Price_Type__c
 ,invoiceit_s__Invoice_Lines__c.invoiceit_s__Job__c,
                                  invoiceit_s__Invoice__r.invoiceit_s__Order__r.invoiceit_s__Account__c,
                                  invoiceit_s__Invoice__r.invoiceit_s__Invoice_Date__c,
                                  invoiceit_s__Quantity__c,invoiceit_s__Unit_Price__c,
                                  invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Row_Total__c
                                  FROM invoiceit_s__Invoice_Lines__c
                                  WHERE invoiceit_s__Invoice__c = : invoiceId
                                  AND RevenueRecognitionRuleNew__c != null
                                  AND invoiceit_s__Invoice__r.invoiceit_s__Invoice_Status__c = 'Posted'];
            } else {
                listofInvoiceLines = [SELECT Id, invoiceit_s__Total_Line_Amount__c,RevenueRecognitionRuleNew__c, BillingPeriod__c, invoiceit_s__Calculated_Quantity__c,
                                      RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Type__c,RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Date__c,
                                      invoiceit_s__Invoice__r.invoiceit_s__Account__c, Revenue_Recognition_Date__c, RevenueRecognitionEndDatenew__c,
                                      invoiceit_s__Service_Start_Date__c, invoiceit_s__Service_End_Date__c, invoiceit_s__Invoice__c ,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Service_Activation_Date__c,
                                      invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Revenue_Recognition_Date__c,
                                      invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Service_End_Date__c,
                                      invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Price_Type__c
 ,invoiceit_s__Invoice_Lines__c.invoiceit_s__Job__c,
                                      invoiceit_s__Invoice__r.invoiceit_s__Order__r.invoiceit_s__Account__c,
                                      invoiceit_s__Invoice__r.invoiceit_s__Invoice_Date__c,
                                      invoiceit_s__Quantity__c,invoiceit_s__Unit_Price__c,
                                      invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Row_Total__c
                                      FROM invoiceit_s__Invoice_Lines__c
                                      WHERE Id = : invoicelineId
                                      AND RevenueRecognitionRuleNew__c != null
                                      AND invoiceit_s__Invoice__r.invoiceit_s__Invoice_Status__c = 'Posted'];
            }
            revenueTransactionsToDelete = [SELECT Id from invoiceit_s__Revenue_Transaction__c
                                            WHERE invoiceit_s__Invoice_Line__c = : invoicelineId];


            system.debug('Before the lines ='+listofInvoiceLines);
            for (invoiceit_s__Invoice_Lines__c invoiceline : listofInvoiceLines) {

                deferredRevenue = null;

                Date calculationStartDate = invoiceline.invoiceit_s__Service_Start_Date__c;
                Date calculationEndDate = invoiceline.invoiceit_s__Service_End_Date__c;

                //Find the date from which the revenue has to be recognised
                if (invoiceline.RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Date__c == 'Service Activation Date') {
                    dCompare = invoiceline.invoiceit_s__Service_Start_Date__c;
                } else if (invoiceline.RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Date__c == 'Revenue Recognition Date') {
                    dCompare = invoiceline.Revenue_Recognition_Date__c;
                } else if (invoiceline.RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Date__c == 'Service End Date') {
                    dCompare = invoiceline.invoiceit_s__Service_End_Date__c;
                } else if (invoiceline.RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Date__c == 'Invoice Date') {
                    dCompare = invoiceline.invoiceit_s__Invoice__r.invoiceit_s__Invoice_Date__c;
                }

                system.debug('dCompare ='+dCompare);

                Decimal noOfTimesCharge;
                Decimal calculatedTotal;
                Decimal absCalculatedTotal;
                boolean isNegativeValue = false;
                    
                if(invoiceline.BillingPeriod__c == 'One Time' || invoiceline.BillingPeriod__c == 'Usage'){
                    noOfTimesCharge = 1;
                    calculatedTotal = invoiceline.invoiceit_s__Total_Line_Amount__c;
                    absCalculatedTotal = Math.abs(calculatedTotal);
                    if(absCalculatedTotal != calculatedTotal){
                        isNegativeValue = true;
                        calculatedTotal = absCalculatedTotal;
                    }
                    deferredRevenue = calculatedTotal;
                }else if (calculationEndDate != null) {
                    calculationEndDate = calculationEndDate.addDays(1);
                    noOfTimesCharge = IITRevenueRecognitionUtilClass_New.calculateDiffBetweenDatesInMonths(calculationStartDate, calculationEndDate, invoiceline.BillingPeriod__c);    
                    calculatedTotal = noOfTimesCharge*invoiceline.invoiceit_s__Quantity__c*invoiceline.invoiceit_s__Unit_Price__c;
                    absCalculatedTotal = Math.abs(calculatedTotal);
                    if(absCalculatedTotal != calculatedTotal){
                        isNegativeValue = true;
                        calculatedTotal = absCalculatedTotal;
                    }
                    //calculatedTotal = noOfTimesCharge * invoiceline.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Row_Total__c;
                    deferredRevenue = Math.abs(invoiceline.invoiceit_s__Total_Line_Amount__c);
                }

                system.debug('====================================================================================================');
                system.debug('dCompare ='+dCompare);
                system.debug('calculationStartDate ='+calculationStartDate);
                system.debug('calculationEndDate ='+calculationEndDate);
                system.debug('noOfTimesCharge ='+noOfTimesCharge);
                system.debug('calculatedTotal ='+calculatedTotal);
                system.debug('deferredRevenue ='+deferredRevenue);
                system.debug('====================================================================================================');

                //Get the chargeTerms
                Decimal chargeTerms = 1.0;
                if (invoiceline.BillingPeriod__c == 'Annual') {
                    chargeTerms = 12.0;
                } else if (invoiceline.BillingPeriod__c == 'Half Yearly') {
                    chargeTerms = 6.0;
                } else if (invoiceline.BillingPeriod__c == 'Quarterly') {
                    chargeTerms = 3.0;
                }

                Integer noOfIterations;
                Integer noOfDays;

                if(calculationEndDate != null){
                  noOfDays = calculationStartDate.daysBetween(calculationEndDate);
                }

                Decimal dNoOfIterations = noOfTimesCharge * chargeTerms;
                Long lNoOfIterations = dNoOfIterations.round(System.RoundingMode.UP);

                if (dNoOfIterations < lNoOfIterations) {
                    noOfIterations = dNoOfIterations.intValue() + 1;
                } else {
                    noOfIterations = dNoOfIterations.intValue();
                }

                system.debug('noOfIterations =' + noOfIterations);

                system.debug('noOfTimesCharge =' + noOfTimesCharge);

                system.debug('calculationEndDate for check ='+calculationEndDate);

                //We need to add 1 to the iterations only if the endday < startday
                Integer calculationStartDay;
                if(calculationStartDate != null){
                    calculationStartDay = calculationStartDate.day();
                } 
                //Subtract 1 day from the enddate to reset this
                Integer calculationEndDay;
                if(calculationEndDate != null){
                    calculationEndDay = calculationEndDate.addDays(-1).day();
                }

                //If the revenue recognition
                if ((invoiceline.RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Type__c == 'Weighted Monthly Recognition Over Time'
                    ||
                    invoiceline.RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Type__c == 'Daily Recognition Over Time')
                    && calculationEndDay < calculationStartDay) 
                {
                    noOfIterations++;

                }
                else if(invoiceline.RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Type__c == 'Full Recognition on Specific Date')
                {
                  noOfIterations = 1;
                }

                system.debug('noOfIterations after ='+noOfIterations);
 
                recognisedRevenue = 0;

                for (Integer i = 0; i < noOfIterations; i++) {
                    for (invoiceit_s__Revenue_Period__c revenuePeriod : revenuePeriods) {
                        if ( revenuePeriod.invoiceit_s__Revenue_Period_Start_Date__c <= dCompare
                                && revenuePeriod.invoiceit_s__Revenue_Period_End_Date__c >= dCompare) {
                            revenueTransaction = new invoiceit_s__Revenue_Transaction__c();
                            revenueTransaction.invoiceit_s__Revenue_Period__c = revenuePeriod.Id;
                            revenueTransaction.invoiceit_s__Account__c = invoiceline.invoiceit_s__Invoice__r.invoiceit_s__Account__c;
                            revenueTransaction.invoiceit_s__Order__c = invoiceline.invoiceit_s__Job__c;
                            revenueTransaction.invoiceit_s__Order_Rate_Plan_Charge__c = invoiceline.invoiceit_s__Job_Rate_Plan_Charge__c;
                            revenueTransaction.invoiceit_s__Invoice__c = invoiceline.invoiceit_s__Invoice__c;
                            revenueTransaction.invoiceit_s__Invoice_Line__c = invoiceline.Id;
                        }
                    }

                    //Get into the conditional check only if the revenueTransaction != null 
                    //i.e., when we can match it to the right accounting period
                    //Exit the charges for loop if this is null
                    system.debug('revenueTransaction ='+revenueTransaction);

                    if(revenueTransaction == null){
                        break;
                    }
                    if (invoiceline.RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Type__c == 'Monthly Recognition Over Time') {
                        //If deferred revenue < monthly amount then use that for revenue
                        if (deferredRevenue <= invoiceline.invoiceit_s__Total_Line_Amount__c/noOfTimesCharge/chargeTerms) {
                            revenueTransaction.invoiceit_s__Revenue_Amount__c = deferredRevenue;
                            recognisedRevenue += revenueTransaction.invoiceit_s__Revenue_Amount__c;
                            revenueTransaction.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                            deferredRevenue = deferredRevenue - revenueTransaction.invoiceit_s__Revenue_Amount__c;
                            revenueTransaction.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                        } else {
                            revenueTransaction.invoiceit_s__Revenue_Amount__c = calculatedTotal/noOfTimesCharge/chargeTerms;
                            recognisedRevenue += revenueTransaction.invoiceit_s__Revenue_Amount__c;
                            revenueTransaction.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                            deferredRevenue = deferredRevenue - revenueTransaction.invoiceit_s__Revenue_Amount__c;
                            revenueTransaction.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                        }

                        //Before adding the revenueTransaction we need to offset for negative values
                        if(isNegativeValue){
                            revenueTransaction = offSetNegativeValues(revenueTransaction);
                        }
                        listofrevenueTransactions.add(revenueTransaction);
                    }
                    if (invoiceline.RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Type__c == 'Weighted Monthly Recognition Over Time') {
                        if (i == 0) {
                            Date lastDayOfThisMonth = Date.newInstance(dCompare.year(), dCompare.month(), Date.daysInMonth(dCompare.year(), dCompare.month()));
                            //Add 1 day to this to make sure the days in between also includes the end date
                            lastDayOfThisMonth = lastDayOfThisMonth.addDays(1);
                            Decimal noOfTimesForCalculation = IITRevenueRecognitionUtilClass_New.calculateDiffBetweenDatesInMonths(dCompare, lastDayOfThisMonth, invoiceline.BillingPeriod__c);

                            system.debug('dCompare ='+dCompare);
                            system.debug('lastDayOfThisMonth ='+lastDayOfThisMonth);
                            system.debug('noOfTimesForCalculation ='+noOfTimesForCalculation);
                            system.debug('revenueTransaction ='+revenueTransaction);
                            system.debug('noOfTimesCharge ='+noOfTimesCharge);

                            revenueTransaction.invoiceit_s__Revenue_Amount__c = noOfTimesForCalculation * calculatedTotal/noOfTimesCharge;
                            recognisedRevenue += revenueTransaction.invoiceit_s__Revenue_Amount__c;
                            revenueTransaction.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                            deferredRevenue = deferredRevenue - revenueTransaction.invoiceit_s__Revenue_Amount__c;
                            revenueTransaction.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                            //Before adding the revenueTransaction we need to offset for negative values
                            if(isNegativeValue){
                                revenueTransaction = offSetNegativeValues(revenueTransaction);
                            }
                            listofrevenueTransactions.add(revenueTransaction);
                        } else if (i == noOfIterations - 1) {
                            revenueTransaction.invoiceit_s__Revenue_Amount__c = deferredRevenue;
                            recognisedRevenue += revenueTransaction.invoiceit_s__Revenue_Amount__c;
                            revenueTransaction.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                            deferredRevenue = deferredRevenue - revenueTransaction.invoiceit_s__Revenue_Amount__c;
                            revenueTransaction.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                            //Before adding the revenueTransaction we need to offset for negative values
                            if(isNegativeValue){
                                revenueTransaction = offSetNegativeValues(revenueTransaction);
                            }
                            listofrevenueTransactions.add(revenueTransaction);
                        } else {
                            //If deferred revenue < monthly amount then use that for revenue
                            if (deferredRevenue <= calculatedTotal/noOfTimesCharge/chargeTerms) {
                                revenueTransaction.invoiceit_s__Revenue_Amount__c = deferredRevenue;
                                recognisedRevenue += revenueTransaction.invoiceit_s__Revenue_Amount__c;
                                revenueTransaction.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                                deferredRevenue = deferredRevenue - revenueTransaction.invoiceit_s__Revenue_Amount__c;
                                revenueTransaction.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                                //Before adding the revenueTransaction we need to offset for negative values
                                if(isNegativeValue){
                                    revenueTransaction = offSetNegativeValues(revenueTransaction);
                                }
                                listofrevenueTransactions.add(revenueTransaction);
                            } else {
                                revenueTransaction.invoiceit_s__Revenue_Amount__c = calculatedTotal/noOfTimesCharge/chargeTerms;
                                recognisedRevenue += revenueTransaction.invoiceit_s__Revenue_Amount__c;
                                revenueTransaction.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                                deferredRevenue = deferredRevenue - revenueTransaction.invoiceit_s__Revenue_Amount__c;
                                revenueTransaction.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                                //Before adding the revenueTransaction we need to offset for negative values
                                if(isNegativeValue){
                                    revenueTransaction = offSetNegativeValues(revenueTransaction);
                                }
                                listofrevenueTransactions.add(revenueTransaction);
                            }
                        }
                    }
                    if (invoiceline.RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Type__c == 'Daily Recognition Over Time') {
                        if (i == 0) {
                            Decimal daysInMonth = Date.daysInMonth(dCompare.year(), dCompare.month());
                            Decimal proratedDays = daysInMonth - dCompare.day() + 1;
                            revenueTransaction.invoiceit_s__Revenue_Amount__c = (proratedDays / noOfDays) * noOfTimesCharge * calculatedTotal;
                            recognisedRevenue += revenueTransaction.invoiceit_s__Revenue_Amount__c;
                            revenueTransaction.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                            deferredRevenue = deferredRevenue - revenueTransaction.invoiceit_s__Revenue_Amount__c;
                            revenueTransaction.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                            //Before adding the revenueTransaction we need to offset for negative values
                            if(isNegativeValue){
                                revenueTransaction = offSetNegativeValues(revenueTransaction);
                            }
                            listofrevenueTransactions.add(revenueTransaction);
                        } else if (i == noOfIterations - 1) {
                            revenueTransaction.invoiceit_s__Revenue_Amount__c = deferredRevenue;
                            recognisedRevenue += revenueTransaction.invoiceit_s__Revenue_Amount__c;
                            revenueTransaction.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                            deferredRevenue = deferredRevenue - revenueTransaction.invoiceit_s__Revenue_Amount__c;
                            revenueTransaction.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                            //Before adding the revenueTransaction we need to offset for negative values
                            if(isNegativeValue){
                                revenueTransaction = offSetNegativeValues(revenueTransaction);
                            }
                            listofrevenueTransactions.add(revenueTransaction);
                        } else {
                            Decimal daysInMonth = Date.daysInMonth(dCompare.year(), dCompare.month());
                            revenueTransaction.invoiceit_s__Revenue_Amount__c = (daysInMonth / noOfDays) * noOfTimesCharge * calculatedTotal;
                            recognisedRevenue += revenueTransaction.invoiceit_s__Revenue_Amount__c;
                            revenueTransaction.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                            deferredRevenue = deferredRevenue - revenueTransaction.invoiceit_s__Revenue_Amount__c;
                            revenueTransaction.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                            //Before adding the revenueTransaction we need to offset for negative values
                            if(isNegativeValue){
                                revenueTransaction = offSetNegativeValues(revenueTransaction);
                            }
                            listofrevenueTransactions.add(revenueTransaction);
                        }
                    }
                    if (invoiceline.RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Type__c == 'Full Recognition on Specific Date') {
                        revenueTransaction.invoiceit_s__Revenue_Amount__c = deferredRevenue;
                        recognisedRevenue += revenueTransaction.invoiceit_s__Revenue_Amount__c;
                        revenueTransaction.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                        deferredRevenue = deferredRevenue - revenueTransaction.invoiceit_s__Revenue_Amount__c;
                        revenueTransaction.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                        //Before adding the revenueTransaction we need to offset for negative values
                        if(isNegativeValue){
                                revenueTransaction = offSetNegativeValues(revenueTransaction);
                        }   
                        listofrevenueTransactions.add(revenueTransaction);
                    }

                    revenueTransaction = null;
                    dCompare = dCompare.addMonths(1);
                }
            }

            //Delete revenue schedules for that order if any
            delete revenueTransactionsToDelete;

            insert listofrevenueTransactions;

        } catch (DMLException dMlEx) {
            database.rollback(sp);
            string sException;
            for (Integer i = 0; i < dMlEx.getNumDml(); i++) {
                sException = system.Label.invoiceit_s.ExceptionMessage + ' ' + dMlEx.getDmlMessage(i);
            }
            return sException;

        }  catch (Exception ex) {
            database.rollback(sp);
            return system.Label.invoiceit_s.ExceptionMessage + ex.getTypeName() + ':' + ex.getMessage() + ':LINE ' + ex.getLineNumber();
        }
        return 'Success';
    }

    public static invoiceit_s__Revenue_Transaction__c offSetNegativeValues(invoiceit_s__Revenue_Transaction__c revenueTransaction){

        revenueTransaction.invoiceit_s__Revenue_Amount__c = -1*revenueTransaction.invoiceit_s__Revenue_Amount__c;
        revenueTransaction.invoiceit_s__Recognised_Revenue__c = -1*revenueTransaction.invoiceit_s__Recognised_Revenue__c;
        revenueTransaction.invoiceit_s__Deferred_Balance__c = -1*revenueTransaction.invoiceit_s__Deferred_Balance__c;


        return revenueTransaction;
    }
}