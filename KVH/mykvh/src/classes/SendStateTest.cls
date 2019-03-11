@isTest
private class SendStateTest {
        static testMethod void teststatement() {
            
        IITTestClassForPhase1.insertCustomSettings();
            
        Account a1 = new Account(Name = '1234567', BillingCountry = 'United Kingdom', recordtypeID = '01213000001CCzwAAG');
        insert a1;
        system.debug('inserted account a1  SOQL=' + limits.getQueries());     
        
        Contact c = new Contact();
        c.AccountId = a1.Id;
        c.LastName = 'Joe';
        insert c;
        system.debug('inserted contact c SOQL=' + limits.getQueries());
            
        Account a2 = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = '01213000001CCzwAAG');
        a2.Receive_Statements__c = c.Id;
        insert a2;
        system.debug('inserted account a2  SOQL=' + limits.getQueries());
        
        invoiceit_s__Product__c invoiceItProduct = new invoiceit_s__Product__c(invoiceit_s__Valid_From_Date__c = system.today(), Name = 'Test');
        insert invoiceItProduct;
            system.debug('inserted product SOQL=' + limits.getQueries());

        invoiceit_s__Product_Rate_Plan__c ratePlan = new invoiceit_s__Product_Rate_Plan__c(Name = 'Full......', invoiceit_s__Valid_From_Date__c = system.today());
        ratePlan.invoiceit_s__Product__c = invoiceItProduct.Id;
        insert ratePlan;
            system.debug('inserted product rate plan SOQL=' + limits.getQueries());
        
        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'EUR', invoiceit_s__Symbol__c = '£');
        insert currency1; 
            system.debug('inserted currency SOQL=' + limits.getQueries());
        
        invoiceit_s__Product_Rate_Plan_Charge__c productCharge = new invoiceit_s__Product_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'Annual Subscription Fee: Full', invoiceit_s__CurrencyL__c = currency1.Id);
        insert productCharge;
            system.debug('inserted product rate plan charge SOQL=' + limits.getQueries());

        invoiceit_s__Job__c job = new invoiceit_s__Job__c(invoiceit_s__Account__c = a2.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        job.Shipping_Account__c = a2.Id;
        job.IITIntended_Use__c = 'HIGH SEAS';
        insert job;
            system.debug('inserted order SOQL=' + limits.getQueries());
        
        invoiceit_s__Job_Product__c  jobProduct= new invoiceit_s__Job_Product__c(invoiceit_s__Product__c = invoiceItProduct.Id, Name = 'jobProduct',invoiceit_s__Job__c = job.Id);
        insert jobProduct;
            system.debug('inserted order product SOQL=' + limits.getQueries());

        invoiceit_s__Job_Rate_Plan__c jobRP = new invoiceit_s__Job_Rate_Plan__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'JobRP',invoiceit_s__Job_Product__c =jobProduct.Id);
        insert jobRP;
            system.debug('inserted order rate plan SOQL=' + limits.getQueries());

        invoiceit_s__Job_Rate_Plan_Charge__c charge1 = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge1.Name = 'Charge1';
        charge1.invoiceit_s__Order__c = job.Id;
        charge1.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge1.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge1.invoiceit_s__Quantity__c = 1;
        charge1.invoiceit_s__Price_Type__c = 'Annual';
        charge1.invoiceit_s__Accounting_Code__c = '12345';
        charge1.invoiceit_s__Charge_Date__c = system.today() - 90;
        charge1.invoiceit_s__Unit_Price__c = 100;
        charge1.invoiceit_s__Service_Activation_Date__c = System.today() - 90;
        charge1.invoiceit_s__Service_End_Date__c = charge1.invoiceit_s__Service_Activation_Date__c.addYears(4);
        insert charge1;
            system.debug('inserted ORPC SOQL=' + limits.getQueries());
        
        invoiceit_s__Invoice__c inv1 = new invoiceit_s__Invoice__c();
        inv1.invoiceit_s__Account__c = a2.Id;
        inv1.invoiceit_s__Invoice_Date__c = system.today() - 90;
        insert inv1;
            system.debug('inserted invoice SOQL=' + limits.getQueries());

        invoiceit_s__Invoice_Lines__c invoiceLine = new invoiceit_s__Invoice_Lines__c();
        invoiceLine.invoiceit_s__Job__c = job.Id;
        invoiceLine.invoiceit_s__Invoice__c = inv1.Id;
        invoiceline.invoiceit_s__Service_Start_Date__c = system.today()-60;
        invoiceline.invoiceit_s__Service_End_Date__c = system.today().addMonths(10);
        invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__c = charge1.Id;
        invoiceLine.invoiceit_s__Unit_Price__c = 100;
        invoiceline.invoiceit_s__Quantity__c = 1;
        invoiceline.invoiceit_s__Line_Amount__c = 100;
        insert invoiceline;
            system.debug('inserted invoice line SOQL=' + limits.getQueries());
        
        inv1.invoiceit_s__Invoice_Status__c = 'Posted';
        update inv1;
            system.debug('posted invoice SOQL=' + limits.getQueries());
        
        Test.startTest();
        SendStateBatch batch = new SendStateBatch();
        Id JobId = database.executeBatch(batch);
            system.debug('ran batch SOQL=' + limits.getQueries());
        Test.stopTest();
        
        
        Account testing2 = [SELECT Id, Date_Statement_Sent__c FROM Account WHERE Id =: a2.Id];
        System.assertEquals(Date.valueOf(system.today()),testing2.Date_Statement_Sent__c);

}
}