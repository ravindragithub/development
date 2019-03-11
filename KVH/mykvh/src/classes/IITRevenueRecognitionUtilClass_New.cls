global with sharing class IITRevenueRecognitionUtilClass_New {

  WebService static string createRevenueForecastForOrder(Id orderId) {
    return processRevenueForecast(orderId, null);
  }

  WebService static string createRevenueForecastForOrderCharge(Id chargeId) {
    return processRevenueForecast(null, chargeId);
  }

  public static string processRevenueForecast(Id orderId, Id chargeId) {
    savepoint sp = database.setsavepoint();
    try {
      list<invoiceit_s__Revenue_Forecast__c> listofrevenueForecast = new list<invoiceit_s__Revenue_Forecast__c>();
      // We need to write the code in trigger on what use cases the check box must be true.
      Date dCompare;
      Decimal recognisedRevenue;
      Decimal deferredRevenue;
      invoiceit_s__Revenue_Forecast__c revenueForecast;
      list<invoiceit_s__Revenue_Forecast__c> revenueForecasts = new list<invoiceit_s__Revenue_Forecast__c>();
      
      //Get the list of all revenue periods in the org
      list<invoiceit_s__Revenue_Period__c> revenuePeriods = [select Id, Name, invoiceit_s__Revenue_Period_Start_Date__c,
                                                invoiceit_s__Revenue_Period_End_Date__c 
                                                FROM invoiceit_s__Revenue_Period__c
                                                ORDER BY invoiceit_s__Revenue_Period_Start_Date__c];

      //This would store all the revenue forecasts to delete
      //Everytime the revenue forecasts are created for an order/charge, the older ones are deleted.
      list<invoiceit_s__Revenue_Forecast__c> revenueForecastsToDelete; 

      list<invoiceit_s__Job_Rate_Plan_Charge__c> listOfCharges = new list<invoiceit_s__Job_Rate_Plan_Charge__c>();

      if(chargeId == null) {
        listOfCharges = [SELECT Id, invoiceit_s__Row_Total__c,invoiceit_s__Order__r.invoiceit_s__Number_Of_Terms__c, invoiceit_s__Revenue_Recognition_Rule__c,
                        invoiceit_s__Revenue_Recognition_Rule__r.invoiceit_s__Recognition_Type__c, invoiceit_s__Revenue_Recognition_Rule__r.invoiceit_s__Recognition_Date__c, 
                        invoiceit_s__Order__r.invoiceit_s__Account__c, invoiceit_s__Revenue_Recognition_Date__c, invoiceit_s__Service_Activation_Date__c, invoiceit_s__Service_End_Date__c,
                        invoiceit_s__Uplift__c, invoiceit_s__Uplift_Frequency__c, invoiceit_s__Price_Type__c
                        FROM invoiceit_s__Job_Rate_Plan_Charge__c 
                        WHERE invoiceit_s__Order__c =: orderId];

        revenueForecastsToDelete = [SELECT Id from invoiceit_s__Revenue_Forecast__c  
                                    WHERE invoiceit_s__Order__c = :orderId];
      } else {
        listOfCharges = [SELECT Id, invoiceit_s__Row_Total__c,invoiceit_s__Order__r.invoiceit_s__Number_Of_Terms__c, invoiceit_s__Revenue_Recognition_Rule__c,
                        invoiceit_s__Revenue_Recognition_Rule__r.invoiceit_s__Recognition_Type__c, invoiceit_s__Revenue_Recognition_Rule__r.invoiceit_s__Recognition_Date__c, 
                        invoiceit_s__Order__r.invoiceit_s__Account__c, invoiceit_s__Revenue_Recognition_Date__c, invoiceit_s__Service_Activation_Date__c, invoiceit_s__Service_End_Date__c,
                        invoiceit_s__Uplift__c, invoiceit_s__Uplift_Frequency__c, invoiceit_s__Price_Type__c
                        FROM invoiceit_s__Job_Rate_Plan_Charge__c 
                        WHERE Id =: chargeId];

        revenueForecastsToDelete = [SELECT Id from invoiceit_s__Revenue_Forecast__c  
                                    WHERE invoiceit_s__Order_Rate_Plan_Charge__c =: chargeId];
      }

      for(invoiceit_s__Job_Rate_Plan_Charge__c charge : listOfCharges)
      {

        deferredRevenue = null;

        Date calculationStartDate = charge.invoiceit_s__Service_Activation_Date__c;
        Date calculationEndDate = charge.invoiceit_s__Service_End_Date__c;
        Decimal noOfTimesCharge;
        Decimal calculatedTotal;
        if(calculationEndDate != null){
          calculationEndDate = calculationEndDate.addDays(1);
          noOfTimesCharge = calculateDiffBetweenDatesInMonths(calculationStartDate,calculationEndDate,charge.invoiceit_s__Price_Type__c);
          calculatedTotal = noOfTimesCharge * charge.invoiceit_s__Row_Total__c;
          deferredRevenue = calculatedTotal;
        }

        system.debug('noOfTimesCharge ='+noOfTimesCharge);

        if(charge.invoiceit_s__Revenue_Recognition_Rule__c != null)
        {
          //Find the date from which the revenue has to be recognised
          if(charge.invoiceit_s__Revenue_Recognition_Rule__r.invoiceit_s__Recognition_Date__c == 'Service Activation Date'){
            dCompare = charge.invoiceit_s__Service_Activation_Date__c;
          }
          else if(charge.invoiceit_s__Revenue_Recognition_Rule__r.invoiceit_s__Recognition_Date__c == 'Revenue Recognition Date'){
            dCompare = charge.invoiceit_s__Revenue_Recognition_Date__c;
          }
          else if(charge.invoiceit_s__Revenue_Recognition_Rule__r.invoiceit_s__Recognition_Date__c == 'Service End Date'){
            dCompare = charge.invoiceit_s__Service_End_Date__c;
          }
          else if(charge.invoiceit_s__Revenue_Recognition_Rule__r.invoiceit_s__Recognition_Date__c == 'Invoice Date'){
            //Need to change this later to incorporate invoice date
            //dCompare = charge.Revenue_Recognition_Date__c;
          }

          //Get the chargeTerms 
          Integer chargeTerms = 1;
          if(charge.invoiceit_s__Price_Type__c == 'Annual'){
            chargeTerms = 12;
          }
          else if(charge.invoiceit_s__Price_Type__c == 'Half Yearly'){
            chargeTerms = 6;
          }
          else if(charge.invoiceit_s__Price_Type__c == 'Quarterly'){
            chargeTerms = 3;
          }

          recognisedRevenue = 0;
          charge.invoiceit_s__Recalculate_Revenue_Forecasts__c = false;

          Integer iterationNumber = 0;

          for(invoiceit_s__Revenue_Period__c revenuePeriod : revenuePeriods)
          {
            system.debug('Opening dCompare ='+dCompare);
            
            if( revenuePeriod.invoiceit_s__Revenue_Period_Start_Date__c <= dCompare 
                && revenuePeriod.invoiceit_s__Revenue_Period_End_Date__c >= dCompare)
            {
              system.debug('Opening revenuePeriod ='+revenuePeriod.Name);
              revenueForecast = new invoiceit_s__Revenue_Forecast__c();
              revenueForecast.invoiceit_s__Revenue_Period__c = revenuePeriod.Id;
              revenueForecast.invoiceit_s__Account__c = charge.invoiceit_s__Order__r.invoiceit_s__Account__c;
              revenueForecast.invoiceit_s__Order__c = charge.invoiceit_s__Order__c;
              revenueForecast.invoiceit_s__Order_Rate_Plan_Charge__c = charge.Id;

              if(charge.invoiceit_s__Revenue_Recognition_Rule__r.invoiceit_s__Recognition_Type__c == 'Monthly Recognition Over Time')
              {
                if(charge.invoiceit_s__Service_End_Date__c != null && dCompare >= charge.invoiceit_s__Service_End_Date__c){
                    dCompare = charge.invoiceit_s__Service_End_Date__c;
                    break;
                }

                revenueForecast.invoiceit_s__Revenue_Amount__c = charge.invoiceit_s__Row_Total__c / chargeTerms;
                recognisedRevenue += revenueForecast.invoiceit_s__Revenue_Amount__c;
                if(deferredRevenue != null){
                  deferredRevenue = deferredRevenue - revenueForecast.invoiceit_s__Revenue_Amount__c;
                  revenueForecast.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                }
                revenueForecast.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                revenueForecasts.add(revenueForecast);
              }
            
              if(charge.invoiceit_s__Revenue_Recognition_Rule__r.invoiceit_s__Recognition_Type__c == 'Daily Recognition Over Time')
              {
                  if(iterationNumber == 0){
                    Decimal daysInMonth = Date.daysInMonth(dCompare.year(), dCompare.month());
                    Decimal proratedDays = daysInMonth - dCompare.day();
                    revenueForecast.invoiceit_s__Revenue_Amount__c = proratedDays/daysInMonth*charge.invoiceit_s__Row_Total__c / chargeTerms;
                    recognisedRevenue += revenueForecast.invoiceit_s__Revenue_Amount__c;
                    if(deferredRevenue != null){
                      deferredRevenue = deferredRevenue - revenueForecast.invoiceit_s__Revenue_Amount__c;
                      revenueForecast.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                    }
                    revenueForecast.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                    revenueForecasts.add(revenueForecast);
                  }else if(charge.invoiceit_s__Service_End_Date__c != null && dCompare >= charge.invoiceit_s__Service_End_Date__c){
                    dCompare = charge.invoiceit_s__Service_End_Date__c;
                    Decimal daysInMonth = Date.daysInMonth(dCompare.year(), dCompare.month());
                    Decimal proratedDays = dCompare.day();
                    revenueForecast.invoiceit_s__Revenue_Amount__c = deferredRevenue;
                    recognisedRevenue += revenueForecast.invoiceit_s__Revenue_Amount__c;
                    if(deferredRevenue != null){
                      deferredRevenue = 0;
                      revenueForecast.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                    }
                    revenueForecast.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                    revenueForecasts.add(revenueForecast);
                    break;
                  }else{
                    revenueForecast.invoiceit_s__Revenue_Amount__c = charge.invoiceit_s__Row_Total__c / chargeTerms;
                    recognisedRevenue += revenueForecast.invoiceit_s__Revenue_Amount__c;
                    if(deferredRevenue != null){
                      deferredRevenue = deferredRevenue - revenueForecast.invoiceit_s__Revenue_Amount__c;
                      revenueForecast.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                    }
                    revenueForecast.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                    revenueForecasts.add(revenueForecast);
                  }
              }

              iterationNumber++;
              dCompare = dCompare.addMonths(1);
              system.debug('Closing dCompare ='+dCompare);
            }
          }
        }
      }

      //Delete revenue schedules for that order if any
      delete revenueForecastsToDelete;

      insert revenueForecasts;
      //Update the charges which are processed
      update listOfCharges;
    
    } catch(DMLException dMlEx){
      database.rollback(sp);
      string sException;
      for (Integer i = 0; i < dMlEx.getNumDml(); i++)
      { 
        sException = system.Label.invoiceit_s.ExceptionMessage + ' ' +dMlEx.getDmlMessage(i);
      } 
      return sException;
      
    }  catch(Exception ex) {
      database.rollback(sp);
      return system.Label.invoiceit_s.ExceptionMessage + ex.getTypeName()+':'+ex.getMessage() + ':LINE ' + ex.getLineNumber();
    }
    return 'Success';
  }

  public static string processRevenueTransactions(Id invoiceId, Id invoicelineId) {
      // We need to write the code in trigger on what use cases the check box must be true.
      Date dCompare;
      invoiceit_s__Revenue_Transaction__c revenueTransaction;
      list<invoiceit_s__Revenue_Transaction__c> revenueTransactions = new list<invoiceit_s__Revenue_Transaction__c>();
      
      //Dummy code to delete later
      list<invoiceit_s__Revenue_Transaction__c> transactionToDelete = [select id from invoiceit_s__Revenue_Transaction__c
                                                                                                                                    WHERE invoiceit_s__Invoice_Line__c = :invoicelineId];

      //Get the list of all revenue periods in the org
      list<invoiceit_s__Revenue_Period__c> revenuePeriods = [select Id, Name, invoiceit_s__Revenue_Period_Start_Date__c,
                                                invoiceit_s__Revenue_Period_End_Date__c 
                                                FROM invoiceit_s__Revenue_Period__c
                                                ORDER BY invoiceit_s__Revenue_Period_Start_Date__c];

      list<invoiceit_s__Invoice_Lines__c> listofInvoiceLines = new list<invoiceit_s__Invoice_Lines__c>();

      if(invoicelineId == null) {
        listofInvoiceLines = [SELECT Id, invoiceit_s__Total_Line_Amount__c, RevenueRecognitionRuleNew__c,BillingPeriod__c,invoiceit_s__Calculated_Quantity__c,
                        RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Type__c, RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Date__c, 
                        invoiceit_s__Invoice__r.invoiceit_s__Account__c, Revenue_Recognition_Date__c, RevenueRecognitionEndDatenew__c, 
                        invoiceit_s__Service_Start_Date__c, invoiceit_s__Service_End_Date__c, invoiceit_s__Invoice__c
                        FROM invoiceit_s__Invoice_Lines__c 
                        WHERE invoiceit_s__Invoice__c =: invoiceId];
      } else {
        listofInvoiceLines = [SELECT Id, invoiceit_s__Total_Line_Amount__c, RevenueRecognitionRuleNew__c,BillingPeriod__c,invoiceit_s__Calculated_Quantity__c,
                        RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Type__c, RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Date__c, 
                        invoiceit_s__Invoice__r.invoiceit_s__Account__c, Revenue_Recognition_Date__c, RevenueRecognitionEndDatenew__c, 
                        invoiceit_s__Service_Start_Date__c, invoiceit_s__Service_End_Date__c, invoiceit_s__Invoice__c
                        FROM invoiceit_s__Invoice_Lines__c  
                        WHERE Id =: invoicelineId];
      }

      //loop through the invoice lines
      for(invoiceit_s__invoice_lines__c invoiceline : listofInvoiceLines){
        revenueTransactions = new list<invoiceit_s__Revenue_Transaction__c>();
        //Get the chargeTerms 
        Decimal chargeTerms = 1.0;
        if(invoiceline.BillingPeriod__c == 'Annual'){
          chargeTerms = 12.0;
        }
        else if(invoiceline.BillingPeriod__c == 'Half Yearly'){
          chargeTerms = 6.0;
        }
        else if(invoiceline.BillingPeriod__c == 'Quarterly'){
          chargeTerms = 3.0;
        }

        chargeTerms = chargeTerms * invoiceline.invoiceit_s__Calculated_Quantity__c;
        Decimal recognisedRevenue = 0;
        Decimal deferredRevenue = invoiceline.invoiceit_s__Total_Line_Amount__c;
        dCompare = invoiceline.Revenue_Recognition_Date__c;

        Decimal terms = 1;
        if(chargeTerms != Math.abs(chargeTerms))
        {
            terms = Math.abs(chargeTerms) + 1;
        }
        else
        {
            terms = chargeTerms;
        }

        for(Integer i=0; i<terms; i++){
            
            system.debug('dCompare ='+dCompare);

                for(invoiceit_s__Revenue_Period__c revenuePeriod : revenuePeriods)
          {
            system.debug('For loop ='+revenuePeriod);
            if( revenuePeriod.invoiceit_s__Revenue_Period_Start_Date__c <= dCompare 
                && revenuePeriod.invoiceit_s__Revenue_Period_End_Date__c >= dCompare)
            {
                system.debug('Inside if loop ='+dCompare);

                if(i == terms -1)
                {
                invoiceit_s__Revenue_Transaction__c rt = new invoiceit_s__Revenue_Transaction__c();
                    rt.invoiceit_s__Revenue_Amount__c = invoiceline.invoiceit_s__Total_Line_Amount__c - recognisedRevenue;
                    rt.invoiceit_s__Revenue_Period__c = revenuePeriod.Id;
                        recognisedRevenue = invoiceline.invoiceit_s__Total_Line_Amount__c;
                        deferredRevenue = 0;
                        rt.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                        rt.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                        rt.invoiceit_s__Account__c = invoiceline.invoiceit_s__Invoice__r.invoiceit_s__Account__c;
                        rt.invoiceit_s__Invoice_Line__c = invoiceline.Id;
                        rt.invoiceit_s__Invoice__c = invoiceline.invoiceit_s__Invoice__c;

                        revenueTransactions.add(rt);
                }
                else
                {
                invoiceit_s__Revenue_Transaction__c rt = new invoiceit_s__Revenue_Transaction__c();
                    rt.invoiceit_s__Revenue_Amount__c = invoiceline.invoiceit_s__Total_Line_Amount__c / chargeTerms;
                    rt.invoiceit_s__Revenue_Period__c = revenuePeriod.Id;
                        recognisedRevenue+= rt.invoiceit_s__Revenue_Amount__c;
                        deferredRevenue = deferredRevenue - rt.invoiceit_s__Revenue_Amount__c;
                        rt.invoiceit_s__Deferred_Balance__c = deferredRevenue;
                        rt.invoiceit_s__Recognised_Revenue__c = recognisedRevenue;
                        rt.invoiceit_s__Account__c = invoiceline.invoiceit_s__Invoice__r.invoiceit_s__Account__c;
                        rt.invoiceit_s__Invoice_Line__c = invoiceline.Id;
                        rt.invoiceit_s__Invoice__c = invoiceline.invoiceit_s__Invoice__c;

                        revenueTransactions.add(rt);
                }
            }
            }

          dCompare = dCompare.addMonths(1);
        }

        delete transactionToDelete;
        insert revenueTransactions;

                if(invoiceline.RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Type__c == 'Monthly Recognition Over Time'){

                }

                if(invoiceline.RevenueRecognitionRuleNew__r.invoiceit_s__Recognition_Type__c == 'Daily Recognition Over Time'){
                    
                }
      }
      return 'Success';
  }

  // InvoicingUtilClass.calculateDiffBetweenDatesInMonths(calculationStartDate, calculationEndDate, 'Monthly');
public static decimal calculateDiffBetweenDatesInMonths(date calculationStartDate, date calculationEndDate, String priceType) {
    decimal noOfMonthsComputed = 0;
    decimal noOfDaysComputed = 0; 
    decimal noOfTimesCharge = 0;
    
    Decimal noOfMonths = calculationStartDate.monthsBetween(calculationEndDate);
    // as a industry standard, we need to bill prorated days as days/30 days
    Decimal daysInAMonth = 30.0;
    system.debug('No of months initially == ' + noOfMonths);
    
    // just verify the dates by adding the noOfMonths
    // If dates are equal then 100%, we need to charges for noOfMonths
    // If dates are not equal then we need to calculate for how many extra days we need to compute i.e (noOfMonths - 1) + ExtraDays
    if(calculationStartDate.addMonths(Integer.ValueOf(noOfMonths)) == calculationEndDate) {
        noOfMonthsComputed = noOfMonths;
        noOfDaysComputed = 0;
        
        noOfTimesCharge = noOfMonths;
        
        system.debug('No of months == ' + noOfMonthsComputed);
        system.debug('No of days == ' + noOfDaysComputed);
        system.debug('noOfMonths  Value Laxman == ' + noOfTimesCharge);
        
        //return noOfTimesCharge;
    } else {
        noOfMonthsComputed = noOfMonths - 1;
        date removedComputedMonths = calculationStartDate.addMonths(integer.ValueOf(noOfMonthsComputed));
        Decimal remainingDays = removedComputedMonths.daysBetween(calculationEndDate);
        noOfDaysComputed = remainingDays;
        
        system.debug('noOfMonthsComputed is ' + noOfMonthsComputed);
        system.debug('removedComputedMonths is  ' + removedComputedMonths);
        system.debug('remainingDays is ' + remainingDays);
        
        
        // Some time remaning day might be greather than 30+ when noOfMonths is not calculated properly
        if(remainingDays > 28) {
            date oneMonthFront = removedComputedMonths.addMonths(1);
            ++noOfMonthsComputed;
            remainingDays = oneMonthFront.daysBetween(calculationEndDate);
        } 
        
        if(noOfMonthsComputed <= 0) {
            // this is for calculations like : (five days) or (three days)
            //noOfMonths = remainingDays.Divide(daysInStartMonth, 3, System.RoundingMode.UP);
            noOfMonths = (remainingDays/daysInAMonth);
            system.debug('noOfMonths is ==== see this ====1 ' + noOfMonths);
            
        } else {
            // use the endDate Month for calculating the remanining days
            // subtract one day since both days are included
            system.debug('I am in prorated more than a month, subtracting one day');
            remainingDays = remainingDays - 1;
            noOfMonths = noOfMonthsComputed + (remainingDays/daysInAMonth);
            system.debug('new calculations noOfMonths is ==== see this ====2 ' + noOfMonths);
        }
        
        system.debug('No of months == ' + noOfMonthsComputed);
        system.debug('No of days == ' + remainingDays);
    }
    
    if(priceType == 'Monthly') {
        noOfTimesCharge = noOfMonths;
    } else if(priceType == 'Quarterly') {
        noOfTimesCharge = noOfMonths.Divide(3, 3, System.RoundingMode.UP);
        //system.debug('I am inside quaterly ' + noOfTimesCharge);
    } else if(priceType == 'Half Yearly') {
        noOfTimesCharge = noOfMonths.Divide(6, 3, System.RoundingMode.UP);
        //system.debug('I am inside quaterly ' + (noOfMonths/6.0) );
    } else if(priceType == 'Annual') {
        noOfTimesCharge = noOfMonths.Divide(12, 3, System.RoundingMode.UP);
    }
    
    system.debug('final sending noOfMonths  Value Laxman == ' + noOfTimesCharge);
    
    return noOfTimesCharge;
  }
}