public with sharing class IITARUtilClass {
	public static list<AR_Snapshot__c> populateARUnpaidInvoices(list<invoiceit_s__Invoice__c> unpaidInvoices, string nameOfAR, date closingDate) {

		list<AR_Snapshot__c> snapshotRecordsToInsert = new list<AR_Snapshot__c>();	
		AR_Snapshot__c snapshot;

		for(invoiceit_s__Invoice__c unpaidInvoice : unpaidInvoices) {

			integer NoOfDaysfromInvoiceDateToClosingDate = unpaidInvoice.invoiceit_s__Invoice_Date__c.daysBetween(closingDate);

	        snapshot = new AR_Snapshot__c();
	        snapshot.Unpaid_Amount_180_Days__c = 0;
	        snapshot.Unpaid_Amount_0_30_Days__c = 0;
	        snapshot.Unpaid_Amount_121_180_Days__c = 0;
	        snapshot.Unpaid_Amount_31_60_Days__c = 0;
	        snapshot.Unpaid_Amount_61_90_Days__c = 0;
	        snapshot.Unpaid_Amount_91_120_Days__c = 0;

	        if(NoOfDaysfromInvoiceDateToClosingDate >= 0 && NoOfDaysfromInvoiceDateToClosingDate <= 30) {
	        	snapshot.Unpaid_Amount_0_30_Days__c = unpaidInvoice.invoiceit_s__Unpaid_Amount__c;
	        } else if(NoOfDaysfromInvoiceDateToClosingDate >= 31 && NoOfDaysfromInvoiceDateToClosingDate <= 60) {
	        	snapshot.Unpaid_Amount_31_60_Days__c = unpaidInvoice.invoiceit_s__Unpaid_Amount__c;
			} else if(NoOfDaysfromInvoiceDateToClosingDate >= 61 && NoOfDaysfromInvoiceDateToClosingDate <= 90) {
	        	snapshot.Unpaid_Amount_61_90_Days__c = unpaidInvoice.invoiceit_s__Unpaid_Amount__c;	
	        } else if(NoOfDaysfromInvoiceDateToClosingDate >= 91 && NoOfDaysfromInvoiceDateToClosingDate <= 120) {
	        	snapshot.Unpaid_Amount_91_120_Days__c = unpaidInvoice.invoiceit_s__Unpaid_Amount__c;	
	        } else if(NoOfDaysfromInvoiceDateToClosingDate >= 121 && NoOfDaysfromInvoiceDateToClosingDate <= 180) {
	        	 snapshot.Unpaid_Amount_121_180_Days__c = unpaidInvoice.invoiceit_s__Unpaid_Amount__c;	
	        } else if(NoOfDaysfromInvoiceDateToClosingDate >= 181) {
	        	 snapshot.Unpaid_Amount_180_Days__c = unpaidInvoice.invoiceit_s__Unpaid_Amount__c;	
	        } 

	        snapshot.Name = nameOfAR;
	        snapshot.Invoice__c = unpaidInvoice.Id;
	        snapshot.Paid_Amount__c = unpaidInvoice.invoiceit_s__Paid_Amount__c;
	        snapshot.Unpaid_Amount__c = unpaidInvoice.invoiceit_s__Unpaid_Amount__c;
	        snapshot.Transaction_Value__c = unpaidInvoice.invoiceit_s__Total_Invoice_Value__c;
	        snapshot.Transaction_Type__c = 'Invoice'; 
	        snapshot.Account__c = unpaidInvoice.invoiceit_s__Account__c;
	        snapshot.Deferred_Revenue_Balance__c = 0;
	        snapshot.Statement_Date__c = closingDate;
	        
	        if(unpaidInvoice.invoiceit_s__Revenue_Transaction_Invoice__r.size() > 0) {
	            for(invoiceit_s__Revenue_Transaction__c revTrans : unpaidInvoice.invoiceit_s__Revenue_Transaction_Invoice__r) {
	                snapshot.Deferred_Revenue_Balance__c = snapshot.Deferred_Revenue_Balance__c + revTrans.invoiceit_s__Deferred_Balance__c;    
	            }
	        }
	        
	        snapshotRecordsToInsert.add(snapshot);
	    }

	    return snapshotRecordsToInsert;
	}


	public static list<AR_Snapshot__c> populateARUnAllocatedPayments(list<invoiceit_s__Payment__c> unAllocatedPayments, string nameOfAR, date closingDate) {
		list<AR_Snapshot__c> snapshotRecordsToInsert = new list<AR_Snapshot__c>();	
		AR_Snapshot__c snapshot;

		for(invoiceit_s__Payment__c payment : unAllocatedPayments) {
            integer NoOfDaysfromInvoiceDateToClosingDate = payment.invoiceit_s__Payment_Date__c.daysBetween(closingDate);

            snapshot = new AR_Snapshot__c();
            snapshot.Unpaid_Amount_180_Days__c = 0;
            snapshot.Unpaid_Amount_0_30_Days__c = 0;
            snapshot.Unpaid_Amount_121_180_Days__c = 0;
            snapshot.Unpaid_Amount_31_60_Days__c = 0;
            snapshot.Unpaid_Amount_61_90_Days__c = 0;
            snapshot.Unpaid_Amount_91_120_Days__c = 0;

            if(NoOfDaysfromInvoiceDateToClosingDate >= 0 && NoOfDaysfromInvoiceDateToClosingDate <= 30) {
	        	snapshot.Unpaid_Amount_0_30_Days__c = payment.invoiceit_s__Unallocated_Amount__c * (-1);
	        } else if(NoOfDaysfromInvoiceDateToClosingDate >= 31 && NoOfDaysfromInvoiceDateToClosingDate <= 60) {
	        	snapshot.Unpaid_Amount_31_60_Days__c = payment.invoiceit_s__Unallocated_Amount__c * (-1);
			} else if(NoOfDaysfromInvoiceDateToClosingDate >= 61 && NoOfDaysfromInvoiceDateToClosingDate <= 90) {
	        	snapshot.Unpaid_Amount_61_90_Days__c = payment.invoiceit_s__Unallocated_Amount__c * (-1);	
	        } else if(NoOfDaysfromInvoiceDateToClosingDate >= 91 && NoOfDaysfromInvoiceDateToClosingDate <= 120) {
	        	snapshot.Unpaid_Amount_91_120_Days__c = payment.invoiceit_s__Unallocated_Amount__c * (-1);	
	        } else if(NoOfDaysfromInvoiceDateToClosingDate >= 121 && NoOfDaysfromInvoiceDateToClosingDate <= 180) {
	        	 snapshot.Unpaid_Amount_121_180_Days__c = payment.invoiceit_s__Unallocated_Amount__c * (-1);	
	        } else if(NoOfDaysfromInvoiceDateToClosingDate >= 181) {
	        	 snapshot.Unpaid_Amount_180_Days__c = payment.invoiceit_s__Unallocated_Amount__c * (-1);	
	        } 

            snapshot.Name = nameOfAR;
            snapshot.Payment__c = payment.Id;
            snapshot.Paid_Amount__c = payment.invoiceit_s__Allocated_Amount__c * (-1);
            snapshot.Unpaid_Amount__c = payment.invoiceit_s__Unallocated_Amount__c * (-1);
            snapshot.Transaction_Value__c = payment.invoiceit_s__Amount__c * (-1);
            snapshot.Transaction_Type__c = 'Payment'; 
            snapshot.Account__c = payment.invoiceit_s__Account__c;
            snapshot.Statement_Date__c = closingDate;
            
            snapshotRecordsToInsert.add(snapshot);
        }

        return snapshotRecordsToInsert;
	}
}