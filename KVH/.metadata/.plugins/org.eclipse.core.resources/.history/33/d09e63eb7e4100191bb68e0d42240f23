Public Class Activation_Invoice_Payment{
    public String SelectedPaymentType{get;set;}
    public List<Activation_Subscriber__c> aSubValues{get;set;}
    Public Boolean summaryInvoice{get;set;}
    public integer selectingRadio{get;set;}
   
    public void setasub(List<Activation_Subscriber__c> asList){
        aSubValues = asList;
         if(aSubValues.size()>0){
            if(aSubValues[0].Bill_to__c == 'Customer' && aSubValues[0].Pay_from_sub_account_invoices__c){
                selectingRadio = 0;
                summaryInvoice = true;
            }else
            if(aSubValues[0].Pay_from_corporate_account_summary__c){
                selectingRadio = 1;
                summaryInvoice = true;
            }else
            if(aSubValues[0].Bill_to__c == 'Corporate' && aSubValues[0].Pay_from_sub_account_invoices__c){
                selectingRadio = 2;
                summaryInvoice = true;
            }
         }
    }
    public List<Activation_Subscriber__c> getaSub(){
        return null;
    }
    
    
    Public void selectedInvoicePayment(){
        if(aSubValues.size()>0){
            if(SelectedPaymentType == 'first'){
                aSubValues[0].Pay_from_sub_account_invoices__c = true;
                aSubValues[0].Pay_from_corporate_account_summary__c = false;
                aSubValues[0].Bill_to__c = 'Customer';
            }else
            if(SelectedPaymentType == 'second'){
                aSubValues[0].Pay_from_sub_account_invoices__c = false;
                aSubValues[0].Pay_from_corporate_account_summary__c = true;
                aSubValues[0].Bill_to__c = 'Corporate';
            }else
            if(SelectedPaymentType == 'third'){
                 aSubValues[0].Pay_from_sub_account_invoices__c = true;
                 aSubValues[0].Pay_from_corporate_account_summary__c = false;
                 aSubValues[0].Bill_to__c = 'Corporate';
            }
            Update aSubValues;
        }
        
    }
}