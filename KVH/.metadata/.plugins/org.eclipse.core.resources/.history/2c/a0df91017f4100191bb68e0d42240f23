public with sharing class IITCommonUtilClass {
   
    Public static void calculateQuantity(list<invoiceit_s__Invoice_Lines__c> invoiceLinesFromTrigger) {
        invoiceit_s__Invoice_Lines__c newInvoiceLine;
        list<invoiceit_s__Invoice_Lines__c> invoiceLines;
        
        list<invoiceit_s__Invoice_Lines__c> invoiceLinesToInsert = new list<invoiceit_s__Invoice_Lines__c>();
        
        invoiceLines = [SELECT BillingPeriod__c, invoiceit_s__Job_Rate_Plan_Charge__c, invoiceit_s__Service_Start_Date__c, invoiceit_s__Service_End_Date__c
                       , invoiceit_s__Accounting_Code__c,invoiceit_s__Calculated_Quantity__c,invoiceit_s__Charge_Date__c,invoiceit_s__CurrencyL__c,invoiceit_s__Discount_Value__c,invoiceit_s__Line_Name__c,invoiceit_s__Product__c,invoiceit_s__Product_Name__c,invoiceit_s__Product_Rate_Plan_Charge__c,invoiceit_s__Quantity__c,RevenueRecognitionRuleNew__c,invoiceit_s__Status__c,invoiceit_s__Unit_of_Measurement__c
                       , invoiceit_s__Invoice__c, invoiceit_s__Job__c,invoiceit_s__Price_Type__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.Legacy_Orders__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.Next_Uplift_Date__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Quantity__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Uplift__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__VAT_Percentage__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Tax_Percentage__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Unit_Price__c                      
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.AnnualRentYear2__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.AnnualRentYear3__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.AnnualRentYear4__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Price_Type__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Order__r.BMS_Contract_Year__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.BMS_Contract_Year__c
                       FROM invoiceit_s__Invoice_Lines__c
                       WHERE Id In : invoiceLinesFromTrigger]; 
        
        for(invoiceit_s__Invoice_Lines__c invoiceLine : invoiceLines) {                        
            if(invoiceLine.invoiceit_s__Service_Start_Date__c <= invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.Next_Uplift_Date__c
               &&
               invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.Next_Uplift_Date__c <= invoiceLine.invoiceit_s__Service_End_Date__c
               ) 
                {
                string priceType = invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Price_Type__c;
                // just initialize the value same as unit price, some times legacy data may be null
                decimal upliftPrice = invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Unit_Price__c;
                invoiceLine.Split_Invoice__c = true;
                if(invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.Legacy_Orders__c) {
                    decimal contractYr = invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.BMS_Contract_Year__c;

                    if(contractYr != null) {
                        ++contractYr;

                        if(contractYr == 2) {
                            if(invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.AnnualRentYear2__c != null)
                            upliftPrice = invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.AnnualRentYear2__c;
                        } else if(contractYr == 3) {
                            if(invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.AnnualRentYear3__c != null)
                            upliftPrice = invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.AnnualRentYear3__c;
                        } else {
                            if(invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.AnnualRentYear4__c != null)
                                upliftPrice = invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.AnnualRentYear4__c;
                        }
                    }
                      
                } else {
                    system.debug('Uplift percentage ' + invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Uplift__c);
                    if(invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Uplift__c == null)
                        invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Uplift__c = 0;
                    
                    upliftPrice = invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Unit_Price__c + ((invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Uplift__c/100) * invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Unit_Price__c);   
                    system.debug('Uplift percentage ' + upliftPrice);
                }
                
                // if uplift and unit price are same then we should not create two lines
                if(upliftPrice == invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Unit_Price__c) {
                    system.debug('both prices are same, so correction needed');
                    
                    return;
                }
                
                // before you clone divide the discount by two
                if(invoiceLine.invoiceit_s__Discount_Value__c != null && invoiceLine.invoiceit_s__Discount_Value__c > 0) {
                    invoiceLine.invoiceit_s__Discount_Value__c = invoiceLine.invoiceit_s__Discount_Value__c/2;            
                }
                
                system.debug('condition is true');
                newInvoiceLine = invoiceLine.clone();
                newInvoiceLine.invoiceit_s__Service_Start_Date__c = invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.Next_Uplift_Date__c;
                newInvoiceLine.invoiceit_s__Service_End_Date__c = invoiceLine.invoiceit_s__Service_End_Date__c;
                newInvoiceLine.invoiceit_s__Sequence_No__c = 2;
                newInvoiceLine.Split_Invoice__c = true;
                //below line added by ram from steelbrick case # : 00013661 
                newInvoiceLine.invoiceit_s__Price_Type__c = invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Price_Type__c;
                //newInvoiceLine.invoiceit_s__Price_Type__c = invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Price_Type__c;BillingPeriod__c
                // call the util methods, which will return on how many months it should charge
                decimal noOfMonths = IITCommonUtilClass.calculateDiffBetweenDatesInMonths( newInvoiceLine.invoiceit_s__Service_Start_Date__c, 
                                                                                           newInvoiceLine.invoiceit_s__Service_End_Date__c.addDays(1), 
                                                                                            priceType
                                                                                         );
                system.debug('ipriceType ' + priceType);
                decimal newUnitPrice;
                if(priceType == 'Half Yearly') {
                    newUnitPrice = noOfMonths * (upliftPrice/6);
                    newInvoiceLine.invoiceit_s__Calculated_Quantity__c = (noOfMonths/6.0);                   
                } else if(priceType == 'Annual') {
                    newUnitPrice = noOfMonths * (upliftPrice/12);
                    newInvoiceLine.invoiceit_s__Calculated_Quantity__c = (noOfMonths/12.0); 
                }
                
                system.debug('upliftPrice ' + upliftPrice);
                system.debug('newUnitPrice ' + newUnitPrice);
                newInvoiceLine.invoiceit_s__Unit_Price__c = upliftPrice;
                newInvoiceLine.invoiceit_s__Line_Amount__c = newUnitPrice * newInvoiceLine.invoiceit_s__Quantity__c;
                
                if(newInvoiceLine.invoiceit_s__Discount_Value__c == null) {
                    newInvoiceLine.invoiceit_s__Discount_Value__c = 0;            
                }
                decimal netTotal = newInvoiceLine.invoiceit_s__Line_Amount__c - newInvoiceLine.invoiceit_s__Discount_Value__c;
                if(invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Tax_Percentage__c != null && invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Tax_Percentage__c > 0) {
                    newInvoiceLine.invoiceit_s__Tax__c = (netTotal/((100 - invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Tax_Percentage__c)/100) - netTotal);         
                }
                
                if(invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__VAT_Percentage__c != null && invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__VAT_Percentage__c > 0) {
                    newInvoiceLine.invoiceit_s__VAT__c = (netTotal*invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__VAT_Percentage__c/100); 
                }
                    
                
                invoiceLine.invoiceit_s__Service_End_Date__c =  invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.Next_Uplift_Date__c.addDays(-1);
                noOfMonths = IITCommonUtilClass.calculateDiffBetweenDatesInMonths( invoiceLine.invoiceit_s__Service_Start_Date__c, 
                                                                                           invoiceLine.invoiceit_s__Service_End_Date__c.addDays(1), 
                                                                                            priceType
                                                                                         );                                                                                    
                                    
                if(priceType  == 'Half Yearly') {
                    newUnitPrice = noOfMonths * (invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Unit_Price__c/6);
                    invoiceLine.invoiceit_s__Calculated_Quantity__c = (noOfMonths/6.0);

                } else if(priceType == 'Annual') {
                    newUnitPrice = noOfMonths * (invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Unit_Price__c/12);
                    invoiceLine.invoiceit_s__Calculated_Quantity__c = (noOfMonths/12.0);
                }
                invoiceLine.invoiceit_s__Line_Amount__c = newUnitPrice * newInvoiceLine.invoiceit_s__Quantity__c;
            

                netTotal = invoiceLine.invoiceit_s__Line_Amount__c - invoiceLine.invoiceit_s__Discount_Value__c;
                if(invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Tax_Percentage__c != null && invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Tax_Percentage__c > 0) {
                    invoiceLine.invoiceit_s__Tax__c = (netTotal/((100 - invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Tax_Percentage__c)/100) - netTotal);         
                }
                if(invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__VAT_Percentage__c != null && invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__VAT_Percentage__c > 0) {
                    invoiceLine.invoiceit_s__VAT__c = (netTotal*invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__VAT_Percentage__c/100); 
                }
                //rounding up the value upto two decimal points
                if(invoiceLine.invoiceit_s__Line_Amount__c != null && invoiceLine.invoiceit_s__Line_Amount__c > 0) {
                    invoiceLine.invoiceit_s__Line_Amount__c = invoiceLine.invoiceit_s__Line_Amount__c.setScale(2);
                }
                if(invoiceLine.invoiceit_s__Discount_Value__c != null && invoiceLine.invoiceit_s__Discount_Value__c > 0) {
                    invoiceLine.invoiceit_s__Discount_Value__c = invoiceLine.invoiceit_s__Discount_Value__c.setScale(2);
                }
                if(invoiceLine.invoiceit_s__VAT__c != null && invoiceLine.invoiceit_s__VAT__c > 0) {
                    invoiceLine.invoiceit_s__VAT__c = invoiceLine.invoiceit_s__VAT__c.setScale(2);
                }
                if(invoiceLine.invoiceit_s__Tax__c != null && invoiceLine.invoiceit_s__Tax__c > 0) {
                    invoiceLine.invoiceit_s__Tax__c = invoiceLine.invoiceit_s__Tax__c.setScale(2);
                }
                
                invoiceLinesToInsert.add(newInvoiceLine);
                system.debug('invoiceLinesToInsert---111>'+invoiceLinesToInsert);
            }  
        }
        
        update invoiceLines;
        
        insert invoiceLinesToInsert;
        
        system.debug('condition is false');                
        
    }
    
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
                //remainingDays = remainingDays - 1;
                noOfMonths = noOfMonthsComputed + (remainingDays/daysInAMonth);
                system.debug('new calculations noOfMonths is ==== see this ====2 ' + noOfMonths);
            }
        }
        
        system.debug('final noOfMonths == ' + noOfMonths);
        
        return noOfMonths;
    }   
    
    
    /*
        invoiceit_s__Invoice_Lines__c newInvoiceLine;
        newInvoiceLine = [SELECT BillingPeriod__c, invoiceit_s__Job_Rate_Plan_Charge__c, invoiceit_s__Service_Start_Date__c, invoiceit_s__Service_End_Date__c
                       , invoiceit_s__Invoice__c, invoiceit_s__Job__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.Next_Uplift_Date__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Quantity__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Uplift__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__VAT_Percentage__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Tax_Percentage__c
                       ,invoiceit_s__Job_Rate_Plan_Charge__r.invoiceit_s__Unit_Price__c
                       FROM invoiceit_s__Invoice_Lines__c
                       WHERE Id = 'a27190000004bK5'];
    
    IITCommonUtilClass.calculateQuantity(newInvoiceLine);
    */

}