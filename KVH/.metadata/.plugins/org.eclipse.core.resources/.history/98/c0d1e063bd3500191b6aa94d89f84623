public with sharing class IITControllerAllocatePayments {

    public invoiceit_s__Payment__c payment {set; get;}
    public list<IITControllerAllocatePayments.PaymentAllocation> listOfallocationClass {set; get;}
    public map<Integer, IITControllerAllocatePayments.PaymentAllocation> map_Counter_allocationClass {set; get;}
    list<invoiceit_s__Payment_Allocation__c> listOfPaymentAllocationsToInsert;
    public list<invoiceit_s__Payment_Allocation__c> listOfPaymentAllocationsInDb {set; get;}
    public boolean isPaymentAllocationsExists {set; get;}
    public boolean isUnpaidInvoicesExists {set; get;}

    public IITControllerAllocatePayments(ApexPages.StandardController stdController) {
        this.payment = (invoiceit_s__Payment__c)stdController.getRecord();
        initalize();
        if(payment.invoiceit_s__Payment_Allocations__r.size() > 0) {
            isPaymentAllocationsExists = true;
            listOfPaymentAllocationsInDb = new list<invoiceit_s__Payment_Allocation__c>();
            listOfPaymentAllocationsInDb.addAll(payment.invoiceit_s__Payment_Allocations__r);
        }
    }

    public void initalize() {
        try {
            payment =  [SELECT Name, invoiceit_s__Account__c, invoiceit_s__Amount__c, invoiceit_s__Currency__c, invoiceit_s__Status__c, invoiceit_s__Allocated_Amount__c, invoiceit_s__Unallocated_Amount__c, invoiceit_s__Account__r.Id, invoiceit_s__Currency__r.invoiceit_s__Currency_Symbol__c,
                       (SELECT Name, invoiceit_s__Amount__c, invoiceit_s__Status__c, invoiceit_s__Invoice__c
                               FROM invoiceit_s__Payment_Allocations__r)
                               FROM invoiceit_s__Payment__c
                               WHERE Id =: payment.Id]; 
            if(payment.invoiceit_s__Status__c != 'Completed') {
                 Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.Info, 'This payment cannot be allocated as the payment status is not \'Completed\'');
                 Apexpages.addMessage(errorMessage);
            }
            
            System.debug('ControllerAllocatePayments initalize ' + payment.invoiceit_s__Payment_Allocations__r);           
            if(payment.invoiceit_s__Unallocated_Amount__c != 0) { 
                list<invoiceit_s__Invoice__c> listOfInvoices = IITControllerAllocatePayments.getInvoicesForPayment(payment);

                if(listOfInvoices.size() > 0) {
                    isUnpaidInvoicesExists = true;
                }                                                                  
                listOfallocationClass = new list<IITControllerAllocatePayments.PaymentAllocation>();  
                map_Counter_allocationClass = new map<Integer, IITControllerAllocatePayments.PaymentAllocation>();                                                       
                IITControllerAllocatePayments.PaymentAllocation allocationClass;
                integer counter = 0;
                invoiceit_s__Payment_Allocation__c paymentAllocation;
                for(invoiceit_s__Invoice__c invoice : listOfInvoices) {
                    System.debug('listOfInvoices in adding ' + listOfInvoices);
                    allocationClass = new IITControllerAllocatePayments.paymentAllocation();
                    allocationClass.counter = ++counter;
                    allocationClass.isChecked = false;
                    allocationClass.invoice = invoice;
                    paymentAllocation = new invoiceit_s__Payment_Allocation__c(invoiceit_s__Invoice__c = invoice.Id, invoiceit_s__Payment__c = payment.Id);
                    allocationClass.paymentAllocation = paymentAllocation;
                    listOfallocationClass.add(allocationClass);
                    map_Counter_allocationClass.put(counter, allocationClass);
                }
            }
        } catch(Exception ex) {
            Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.ERROR,system.Label.invoiceit_s.ExceptionMessage + ex.getTypeName()+':'+ex.getMessage() + ':LINE ' + ex.getLineNumber());
            Apexpages.addMessage(errorMessage);
        }  
    }

    public void getSelectedInvoice() {
        integer selectedInoiceCounter = integer.ValueOf(system.currentPageReference().getParameters().get('selectedCounter'));
        IITControllerAllocatePayments.paymentAllocation allocationClass = map_Counter_allocationClass.get(selectedInoiceCounter);
        if(allocationClass.isChecked) {
            allocationClass.paymentAllocation.invoiceit_s__Amount__c = 0;
        } else {
            allocationClass.paymentAllocation.invoiceit_s__Amount__c = null;
        }
    }

    public PageReference savePaymentAllocations() {
        if(validateAmount()) {
            try {
                insert listOfPaymentAllocationsToInsert;
                return new PageReference('/' + payment.Id);
            } catch(Exception ex) {
                Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.ERROR,system.Label.invoiceit_s.ExceptionMessage + ex.getTypeName()+':'+ex.getMessage() + ':LINE ' + ex.getLineNumber());
                Apexpages.addMessage(errorMessage);
            }  
        }
        return null;    
    }

    public PageReference backToPayment() {
        return new PageReference('/' + payment.Id);
    }

    public boolean validateAmount() {
        decimal calculatedSum = 0.0;
        listOfPaymentAllocationsToInsert = new list<invoiceit_s__Payment_Allocation__c>();
        //1. We have to check whether it is checked
        //2. if it is checked and payment allocation amount is less than zero,show an error message
        //3. if it is checked and payment allocation amount is greathet than invoice un-paid amount,show an error message
        for(IITControllerAllocatePayments.paymentAllocation allocationClass : listOfallocationClass) {
            if(allocationClass.isChecked) {
                if(allocationClass.paymentAllocation.invoiceit_s__Amount__c == 0) {
                    Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.ERROR, system.Label.invoiceit_s.PaymentPageNoZeroValues);
                    Apexpages.addMessage(errorMessage);
                    return false;
                } else if(allocationClass.invoice.invoiceit_s__Unpaid_Amount__c > 0 && allocationClass.paymentAllocation.invoiceit_s__Amount__c > allocationClass.invoice.invoiceit_s__Unpaid_Amount__c) {
                    Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.ERROR, system.Label.invoiceit_s.PaymentPageAllocationIsGreater);
                    Apexpages.addMessage(errorMessage);
                    return false;
                } else if(allocationClass.invoice.invoiceit_s__Unpaid_Amount__c < 0 && allocationClass.paymentAllocation.invoiceit_s__Amount__c < allocationClass.invoice.invoiceit_s__Unpaid_Amount__c) {
                    Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.ERROR, system.Label.invoiceit_s.PaymentPageAllocationIsGreater);
                    Apexpages.addMessage(errorMessage);
                    return false;
                } else {
                    calculatedSum += allocationClass.paymentAllocation.invoiceit_s__Amount__c;
                    listOfPaymentAllocationsToInsert.add(allocationClass.paymentAllocation);
                }
            }
        }

        if(calculatedSum <= payment.invoiceit_s__Unallocated_Amount__c) {
            return true;
        } else {
            Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.ERROR, system.Label.invoiceit_s.PaymentPageTotalPaymentIsGreater);
            Apexpages.addMessage(errorMessage);
            return false;
        }
    }

    public PageReference cancelPaymentAllocation() {
        string selectedPaymentAllocationId = system.currentPageReference().getParameters().get('paymentAllocationId');
        for(invoiceit_s__Payment_Allocation__c pA : listOfPaymentAllocationsInDb) {
            if(pA.Id == selectedPaymentAllocationId) {
                //make payment allocation amount to zero and status to CANCELLED
                pA.invoiceit_s__Amount__c = 0.0;
                pA.invoiceit_s__Status__c = 'Cancelled';
                //once the payAllocation is CANCELLED make invoice status from paid to active

                Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, system.Label.invoiceit_s.PaymentPageCancelledSuccessfully);
                Apexpages.addMessage(infoMessage);
                break;
            }
        }

        try {
            update listOfPaymentAllocationsInDb;
        } catch(Exception ex) {
            Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.ERROR,'An exception has occurred ' + ex.getTypeName()+':'+ex.getMessage() + ':LINE ' + ex.getLineNumber());
            Apexpages.addMessage(errorMessage);
        }
        initalize();
        return null;
    }

    public class PaymentAllocation {
        public integer counter {get;set;}        
        public boolean isChecked {get;set;}
        public invoiceit_s__Invoice__c invoice {get;set;}
        public invoiceit_s__Payment_Allocation__c paymentAllocation {get;set;}
    }

    public static list<invoiceit_s__Invoice__c> getInvoicesForPayment(invoiceit_s__Payment__c payment) {
        list<Account> listofAccount = [SELECT Id FROM Account WHERE ID =:payment.invoiceit_s__Account__c OR ParentId  =:payment.invoiceit_s__Account__c];
        
        list<invoiceit_s__Invoice__c> listOfInvoices = [SELECT invoiceit_s__Invoice_Reference__c, Name, invoiceit_s__Account__c,invoiceit_s__Invoice_Date__c, invoiceit_s__Due_Date__c, invoiceit_s__Total_Invoice_Value__c, invoiceit_s__Paid_Amount__c, invoiceit_s__Unpaid_Amount__c
                                           FROM invoiceit_s__Invoice__c
                                           WHERE invoiceit_s__CurrencyL__c =: payment.invoiceit_s__Currency__c 
                                           AND
                                           invoiceit_s__Account__c in: listofAccount
                                           AND
                                           invoiceit_s__Unpaid_Amount__c != 0
                                           AND
                                           (invoiceit_s__Invoice_Status__c = 'Posted'
                                           OR
                                           (invoiceit_s__Invoice_State__c = 'Proforma' AND invoiceit_s__Invoice_Status__c != 'Cancelled')
                                           )
                                           ORDER BY invoiceit_s__Due_Date__c,invoiceit_s__Account__c];

        return listOfInvoices;                                            
    }
}