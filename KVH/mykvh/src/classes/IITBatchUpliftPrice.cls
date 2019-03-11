global without sharing class IITBatchUpliftPrice implements Database.Batchable<sObject>,Database.Stateful {
    /*
        Date dateToday = system.today();
        string query = 'SELECT AnnualRentYear2__c, AnnualRentYear3__c, AnnualRentYear4__c, Unit_Price_2nd_Year__c, Unit_Price_3rd_Year__c, Unit_Price_4th_Year__c, invoiceit_s__Quantity__c, invoiceit_s__Uplift__c, invoiceit_s__Uplift_Frequency__c, invoiceit_s__Price_Type__c,invoiceit_s__Order__c, Legacy_Orders__c, Next_Uplift_Date__c, invoiceit_s__Unit_Price__c, invoiceit_s__Order__r.BMS_Contract_Year__c FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE Id = \'a2D190000004dHd\' ';
        
        system.debug(database.query(query));
        
        IITBatchUpliftPrice a = new IITBatchUpliftPrice(query, false);
        database.executeBatch(a);
    */
    global String query;
    global set<Id> orderIds;
    Date dateToday = system.today();
    invoiceit_s__Batch_Jobs__c batchJob;
    global string errorLog = null;
    string currentBatchDetails = '';
    global Id chargeId = 'a20190000008yP9';
    
    global IITBatchUpliftPrice(String query, boolean useInternalQuery) {
        this.query = query;  
        orderIds = new set<Id>();
        
        if(useInternalQuery == true || useInternalQuery == null) {
            this.query = 'SELECT BMS_Contract_Year__c, AnnualRentYear2__c, AnnualRentYear3__c, AnnualRentYear4__c, Unit_Price_2nd_Year__c, Unit_Price_3rd_Year__c, Unit_Price_4th_Year__c, invoiceit_s__Quantity__c, invoiceit_s__Uplift__c, invoiceit_s__Uplift_Frequency__c, invoiceit_s__Price_Type__c,invoiceit_s__Order__c, Legacy_Orders__c, Next_Uplift_Date__c, invoiceit_s__Unit_Price__c, invoiceit_s__Order__r.BMS_Contract_Year__c FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE (invoiceit_s__Uplift__c > 0 OR Legacy_Orders__c = true) AND (invoiceit_s__Service_End_Date__c = null OR invoiceit_s__Service_End_Date__c >=:dateToday) AND Next_Uplift_Date__c!= null AND Next_Uplift_Date__c <=:dateToday';
        } else {
            this.query = query; 
        }
        
        batchJob = new invoiceit_s__Batch_Jobs__c(Name = 'BatchUpliftPrice - ' + system.today(), invoiceit_s__Type__c = 'BatchUpliftPrice', invoiceit_s__Start_Date_and_Time__c = system.now(), invoiceit_s__Status__c = 'Processing');
        insert batchJob;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<sObject> scope) {
        SavePoint sp;
        try {
            list<invoiceit_s__Job_Rate_Plan_Charge__c> charges = scope;
            list<invoiceit_s__Job__c> ordersToUpdate = new list<invoiceit_s__Job__c>();
            
            currentBatchDetails = '\n' + '\n' + '\n';
            for(invoiceit_s__Job_Rate_Plan_Charge__c charge : charges) {
                currentBatchDetails = currentBatchDetails + charge.Id + '\n';
            }
            
            sp = DataBase.SetSavePoint();
            for(invoiceit_s__Job_Rate_Plan_Charge__c charge : charges) {
                decimal newPrice = null;
                // check if its a legacy charge
                if(charge.Legacy_Orders__c) {
                    if(charge.BMS_Contract_Year__c != null) {
                        ++charge.BMS_Contract_Year__c;
                        
                        // just assgin the unit price, in case if the annualrentyr is null then we will use the unit price
                        newPrice = charge.invoiceit_s__Unit_Price__c;
                        if(charge.BMS_Contract_Year__c == 2) {
                            if(charge.AnnualRentYear2__c != null)
                                newPrice = charge.AnnualRentYear2__c;   
                        } else if(charge.BMS_Contract_Year__c == 3) {
                            if(charge.AnnualRentYear3__c != null)
                                newPrice = charge.AnnualRentYear3__c;
                        } else if(charge.AnnualRentYear4__c != null) {
                            newPrice = charge.AnnualRentYear4__c;
                        }
                    }
                } else {
                    if(charge.invoiceit_s__Uplift__c == null)
                        charge.invoiceit_s__Uplift__c = 0;
                    
                    if(charge.invoiceit_s__Unit_Price__c != null) {
                        newPrice = (charge.invoiceit_s__Unit_Price__c * (charge.invoiceit_s__Uplift__c/100)) + charge.invoiceit_s__Unit_Price__c;   
                    }
                }
                
                if(newPrice != null) {
                    // update the price
                    charge.invoiceit_s__Unit_Price__c = newPrice;
                    charge.invoiceit_s__Price__c = charge.invoiceit_s__Quantity__c * charge.invoiceit_s__Unit_Price__c;

                    system.debug('Next_Uplift_Date__c is ' + charge.Next_Uplift_Date__c);

                    // populate the next uplift date
                    charge.Last_Uplift_Date__c = charge.Next_Uplift_Date__c;
                    charge.Next_Uplift_Date__c = charge.Next_Uplift_Date__c.addMonths(12);
                    charge.invoiceit_s__Price_Format__c = 'Default';
                    charge.BMS_Contract_Year__c = charge.BMS_Contract_Year__c;

                    system.debug('Id is ' +charge.Id+ 'Next date' +charge.Next_Uplift_Date__c);
                    system.debug('New Price is ' + charge.invoiceit_s__Unit_Price__c);
                        
                    if(!orderIds.contains(charge.invoiceit_s__Order__c)) {
                        orderIds.add(charge.invoiceit_s__Order__c);
                        
                        /*if(charge.Legacy_Orders__c) {
                            ordersToUpdate.add(new invoiceit_s__Job__c(Id = charge.invoiceit_s__Order__c));
                        }*/
                    }
                }
            }    
            
            // unit price will be updated
            update charges;
            
            // we need to update the contract terms for legacy data
            //update ordersToUpdate;
            
            currentBatchDetails = '';
        } catch(exception ex) {
            system.debug('exception getMessage is : ' + ex.getTypeName() + ':'+ex.getMessage() + ':' + ex.getLineNumber() + ':' + ex.getStackTraceString() );
            database.rollback(sp);
            
            errorLog += '\n' + 'An exception has occured, exception type is ' + ex.getTypeName() + ':'+ex.getMessage() + ':' + ex.getLineNumber() + ':' + ex.getStackTraceString() + '\n';
            errorLog += ': ' + currentBatchDetails; 
       }  
    }
    
    global void finish(Database.BatchableContext BC) {
        
        batchJob.invoiceit_s__Completed_Date_and_Time__c = system.now();
        if(errorLog == null) {
            batchJob.invoiceit_s__Status__c = 'Completed';
        } else {
            batchJob.invoiceit_s__Status__c = 'Completed with Errors';
            
            if(errorLog.Length() < 32768) {
                batchJob.invoiceit_s__Exception_Log__c = errorLog; 
            } else {
                Attachment attachment = new Attachment();
                attachment.Body = Blob.valueOf(errorLog);
                attachment.Name = 'ErrorLog.txt';
                attachment.ParentId = batchJob.Id; 
                insert attachment;  
                
                batchJob.invoiceit_s__Exception_Log__c = 'Error log is attached and the same can be found attachement releated list';
            }
        }
        update batchJob;
        
        IITBatchProcessForRecalculateOrder batchProcessForRecalculateOrder = new IITBatchProcessForRecalculateOrder(orderIds);
        Database.executeBatch(batchProcessForRecalculateOrder,1);        
    }     
     
}


/*
                // change the hard codings to use the existing custom labels
                if(charge.invoiceit_s__Uplift_Frequency__c == 'Monthly') {
                    charge.Next_Uplift_Date__c = charge.Next_Uplift_Date__c.addMonths(1);    
                } else if(charge.invoiceit_s__Uplift_Frequency__c == 'Quarterly') {
                    charge.Next_Uplift_Date__c = charge.Next_Uplift_Date__c.addMonths(3);
                } else if(charge.invoiceit_s__Uplift_Frequency__c== 'Half Yearly') {
                    charge.Next_Uplift_Date__c = charge.Next_Uplift_Date__c.addMonths(6);
                } else if(charge.invoiceit_s__Uplift_Frequency__c == 'Annual') {
                    charge.Next_Uplift_Date__c = charge.Next_Uplift_Date__c.addMonths(12);
                    system.debug('Id is ' +charge.Id+ 'Next date' +charge.Next_Uplift_Date__c);
                }
*/