@isTest
Private Class TestAccountAirtimeSubcriber{
    static testMethod void ifAddressExists(){
        test.startTest();
        Account newAcc = new Account();
        newAcc.name = 'NewTestCustomer';
        newAcc.OwnerID = Userinfo.getUserId();
        newAcc.BillingStreet ='abc';
        newAcc.BillingCountry= 'United States';
        newAcc.BillingCity= 'middletown-11';
        newAcc.Billingstate = 'Rhode Island';
        newAcc.BillingPostalCode ='02842';
        newAcc.Account_Effective_Date__c = system.today();
        newAcc.Revenue_Category__c = 'VSAT';
        newAcc.Custom_Call_Acct_ID__c = '123';
        insert newAcc;
        
        //setup a billing account
        Billing_Account__c objBillingAccountCorporate = New Billing_Account__c();
        objBillingAccountCorporate.Account__c = newAcc.id;
        objBillingAccountCorporate.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
        objBillingAccountCorporate.Billing_Account_ID__c = '00';
        insert objBillingAccountCorporate;
        System.assert(objBillingAccountCorporate != null); 
        
        address__c a1 = new address__c();
        a1.country__c='Canada';
        a1.state__c='NB';
        a1.Billing_Account__c = objBillingAccountCorporate.Id;
        a1.Account__c=newAcc.id;
        a1.Address_Type__c='Airtime Services Billing';
        insert a1; 
        
        address__c a2 = new address__c();
        a2.country__c='Canada';
        a2.state__c='NB';
        a2.Billing_Account__c = objBillingAccountCorporate.Id;
        a2.Account__c=newAcc.id;
        a2.Address_Type__c='Airtime Services Subscriber';
        insert a2;  
        
        pw_ccpro__CountryObject__c pco = New pw_ccpro__CountryObject__c();
        pco.name = 'United States';
        pco.pw_ccpro__IsoCode_2__c = 'is';
        pco.pw_ccpro__IsoCode_3__c = 'iso';
        insert pco;
        
        pw_ccpro__State__c pst = new pw_ccpro__State__c();
        pst.name = 'Rhode Island';
        pst.pw_ccpro__Country__c = pco.id;
        pst.pw_ccpro__IsoCode__c = 'RI';
        insert pst;
        
        Test.setCurrentPageReference(new PageReference('Page.AccountAirtimeSubcriber')); 
        System.currentPageReference().getParameters().put('accID', newAcc.id);
        
        AccountAirtimeSubcriber aas = new AccountAirtimeSubcriber();
        
        //Validating Account
        
        System.AssertEquals(aas.SelectedSubscriberDisplay.id,newAcc.id);
        System.AssertEquals(aas.SelectedSubscriberDisplay.Addresses__r.size(),2);
        
        aas.EditSubscriber();
        aas.finalSaveFunction();
        aas.CallWebService();
        
        test.stopTest();
    } 
    static testMethod void ifAddressNotExists(){
        test.startTest();
        Account newAcc = new Account();
        newAcc.name = 'NewTestCustomer';
        newAcc.OwnerID = Userinfo.getUserId();
        newAcc.BillingStreet ='abc';
        newAcc.BillingCountry= 'United States';
        newAcc.BillingCity= 'middletown-11';
        newAcc.Billingstate = 'Rhode Island';
        newAcc.BillingPostalCode ='02842';
        insert newAcc;
        
        pw_ccpro__CountryObject__c pco = New pw_ccpro__CountryObject__c();
        pco.name = 'United States';
        pco.pw_ccpro__IsoCode_2__c = 'is';
        pco.pw_ccpro__IsoCode_3__c = 'iso';
        insert pco;
        
        pw_ccpro__State__c pst = new pw_ccpro__State__c();
        pst.name = 'Rhode Island';
        pst.pw_ccpro__Country__c = pco.id;
        pst.pw_ccpro__IsoCode__c = 'RI';
        insert pst;
        
        Test.setCurrentPageReference(new PageReference('Page.AccountAirtimeSubcriber')); 
        System.currentPageReference().getParameters().put('accID', newAcc.id);
        
        AccountAirtimeSubcriber aas = new AccountAirtimeSubcriber();
        
        //Validating Account
        
        System.AssertEquals(aas.SelectedSubscriberDisplay.id,newAcc.id);
        System.AssertEquals(aas.SelectedSubscriberDisplay.Addresses__r.size(),0);
        
        aas.EditSubscriber();
        aas.finalSaveFunction();
        aas.CallWebService();
        
        test.stopTest();
    }    
}