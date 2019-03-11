global with sharing class IITCustomerStatements {

    
    public map<string, decimal> mapAmounts {get; set;}
    public list<InnerClassToDisplay> listofInnerclass {get; set;}
    InnerClassToDisplay innerClassToDisplay;
    
    public IITCustomerStatements(ApexPages.StandardController stdController) {
        
        list<AggregateResult> invoiceAggResult;
        list<AggregateResult> paymentAggResult;
        listofInnerclass  = new list<InnerClassToDisplay>();
        mapAmounts = new map<string, decimal>{'0-30'=> 0.00, '31-60'=> 0.00, '61-90' => 0.00, '91-120'=> 0.00, '121-180'=> 0.00, '>181' => 0.00};
        
        Id accountId = (Id) stdcontroller.getId();
        invoiceAggResult = [SELECT Sum(Unpaid_Amount_0_30_Days__c) sum1, Sum(Unpaid_Amount_31_60_Days__c) second, Sum(Unpaid_Amount_61_90_Days__c) third,
                            Sum(Unpaid_Amount_91_120_Days__c) forth, Sum(Unpaid_Amount_121_180_Days__c) fifth, Sum(Unpaid_Amount_180_Days__c) sixth
                            FROM invoiceit_s__Invoice__c
                            WHERE invoiceit_s__Invoice_Status__c = 'Posted' 
                            AND 
                            invoiceit_s__Unpaid_Amount__c != 0 
                            AND 
                            invoiceit_s__Invoice_Date__c <=: system.today()
                            AND
                            invoiceit_s__Account__c =: accountId
                            Group By invoiceit_s__Account__c
                            ];
    
        paymentAggResult = [SELECT Sum(UnAllocated_Amount_0_30_Days__c) sum1, Sum(UnAllocated_Amount_31_60_Days__c) second, Sum(UnAllocated_Amount_61_90_Days__c) third,
                            Sum(UnAllocated_Amount_91_120_Days__c) forth, Sum(UnAllocated_Amount_121_180_Days__c) fifth, Sum(UnAllocated_Amount_180_Days__c) sixth
                            FROM invoiceit_s__Payment__c
                            WHERE invoiceit_s__Status__c = 'Completed'
                             AND 
                             invoiceit_s__Unallocated_Amount__c != 0 
                             AND 
                             invoiceit_s__Payment_Date__c <=: system.today()
                             AND
                             invoiceit_s__Account__c =: accountId
                             Group By invoiceit_s__Account__c
                            ];
        
        if(invoiceAggResult.size() > 0) {
            mapAmounts.put('0-30', ((decimal) invoiceAggResult[0].get('sum1')).setscale(2));
            mapAmounts.put('31-60', ((decimal) invoiceAggResult[0].get('second')).setscale(2));
            mapAmounts.put('61-90', ((decimal) invoiceAggResult[0].get('third')).setscale(2));
            mapAmounts.put('91-120', ((decimal) invoiceAggResult[0].get('forth')).setscale(2));
            mapAmounts.put('121-180', ((decimal) invoiceAggResult[0].get('fifth')).setscale(2));
            mapAmounts.put('>181', ((decimal) invoiceAggResult[0].get('sixth')).setscale(2));
        }
       
         if(paymentAggResult.size() > 0) {
            mapAmounts.put('0-30', (mapAmounts.get('0-30') - (decimal) paymentAggResult[0].get('sum1')).setscale(2));
            mapAmounts.put('31-60', (mapAmounts.get('31-60') - (decimal) paymentAggResult[0].get('second')).setscale(2));
            mapAmounts.put('61-90', (mapAmounts.get('61-90') - (decimal) paymentAggResult[0].get('third')).setscale(2));
            mapAmounts.put('91-120', (mapAmounts.get('91-120') - (decimal) paymentAggResult[0].get('forth')).setscale(2));
            mapAmounts.put('121-180', (mapAmounts.get('121-180') - (decimal) paymentAggResult[0].get('fifth')).setscale(2));
            mapAmounts.put('>181', (mapAmounts.get('>181') - (decimal) paymentAggResult[0].get('sixth')).setscale(2));
        }
        
        decimal sum = 0;
        for(string key : mapAmounts.keySet()) {
            innerClassToDisplay =  new InnerClassToDisplay();
            innerClassToDisplay.sRange = key;
            innerClassToDisplay.dValue = mapAmounts.get(key);
            listofInnerclass.add(innerClassToDisplay);
            sum = sum + mapAmounts.get(key);
        }
        innerClassToDisplay =  new InnerClassToDisplay(); 
        innerClassToDisplay.sRange = 'Total Due';
        innerClassToDisplay.dValue = sum;
        listofInnerclass.add(innerClassToDisplay);
    }
    
    public class InnerClassToDisplay
    {
        public String sRange {get; set;}
        public decimal dValue {get; set;}
        
        public InnerClassToDisplay()
        {
            sRange = '';
            dValue = 0.00;
        }
    }
    
    @RemoteAction
    global static ResponseClass generateRealTimeStatement(string accountId) {
        list<invoiceit_s__Invoice__c> unpaidInvoices;
        list<invoiceit_s__Payment__c> unAllocatedPayments;
        list<AR_Snapshot__c> snapshotRecordsToInsert = new list<AR_Snapshot__c>();
        string arRecordName;
        date todaysDate = system.today();
        ResponseClass responseClass = new ResponseClass();
        try {
                arRecordName = string.ValueOf(system.now());
                unpaidInvoices = [SELECT invoiceit_s__Invoice_Date__c,
                                  invoiceit_s__Account__c, invoiceit_s__Paid_Amount__c,invoiceit_s__Total_Invoice_Value__c,invoiceit_s__Unpaid_Amount__c,Unpaid_Amount_0_30_Days__c,Unpaid_Amount_31_60_Days__c,Unpaid_Amount_61_90_Days__c,Unpaid_Amount_91_120_Days__c,Unpaid_Amount_121_180_Days__c,Unpaid_Amount_180_Days__c 
                                  FROM invoiceit_s__Invoice__c 
                                  WHERE invoiceit_s__Invoice_Status__c = 'Posted' 
                                  AND 
                                  invoiceit_s__Unpaid_Amount__c != 0 
                                  AND 
                                  invoiceit_s__Invoice_Date__c <=: todaysDate
                                  AND
                                  invoiceit_s__Account__c =: accountId 
                                ];

                unAllocatedPayments = [SELECT invoiceit_s__Account__c, invoiceit_s__Allocated_Amount__c, invoiceit_s__Amount__c,invoiceit_s__Payment_Date__c,invoiceit_s__Status__c, invoiceit_s__Unallocated_Amount__c, UnAllocated_Amount_180_Days__c, UnAllocated_Amount_0_30_Days__c, UnAllocated_Amount_121_180_Days__c, UnAllocated_Amount_31_60_Days__c, UnAllocated_Amount_61_90_Days__c, UnAllocated_Amount_91_120_Days__c 
                                         FROM invoiceit_s__Payment__c 
                                         WHERE invoiceit_s__Status__c = 'Completed'
                                         AND 
                                         invoiceit_s__Unallocated_Amount__c != 0 
                                         AND 
                                         invoiceit_s__Payment_Date__c <=: todaysDate
                                         AND
                                         invoiceit_s__Account__c =: accountId
                                        ];

                // get the UnPaidInvoices
                snapshotRecordsToInsert = IITARUtilClass.populateARUnpaidInvoices(unpaidInvoices, arRecordName, system.today()); 
                
                // get the UnAllocatedPayments
                snapshotRecordsToInsert.addALL(IITARUtilClass.populateARUnAllocatedPayments(unAllocatedPayments, arRecordName, system.today()));
                
                // insert the data invoices and payments
                insert snapshotRecordsToInsert;
                responseClass.message = 'success';
                responseClass.snapshotName = arRecordName;
                return responseClass;
            } catch(exception ex) {
                system.debug('exception getMessage is : ' + ex.getTypeName() + ':'+ex.getMessage() + ':' + ex.getLineNumber() + ':' + ex.getStackTraceString() );
                
                responseClass.message = 'An exception has occured, exception type is ' + ex.getTypeName() + ':'+ex.getMessage() + ':' + ex.getLineNumber() + ':' + ex.getStackTraceString();
                return responseClass;
        } 
    }
    
    @RemoteAction
    global static ResponseClass generateHistoricStatement(string accountId, string snapshotName) {
        list<AR_Snapshot__c> snapshot = [SELECT Id FROM AR_Snapshot__c WHERE Name =: snapshotName AND Account__c =: accountId];
        ResponseClass responseClass = new ResponseClass();

        if(snapshot.size() > 0) {
            responseClass.message = 'success';
        } else {
            responseClass.message = 'No Snapshot records found ';
        }
        system.debug('snapshotName ' + snapshotName);

        return responseClass;
    }

    // global class used as reponse for JS
    global class ResponseClass {
        global string message;
        global string snapshotName;
    }
}