@isTest
Private Class CreateKVHIndirectContactTest{
    static testMethod Void CreateKVHIndirectContact(){
         //Creating New Account
          Account newAcc = new Account();
          newAcc.name = 'NewTestCustomer';
          newAcc.OwnerID = Userinfo.getUserId();
          newAcc.BillingStreet ='abc';
          newAcc.BillingCountry= 'United States';
          newAcc.BillingCity= 'middletown-11';
          newAcc.Billingstate = 'Rhode Island';
          newAcc.BillingPostalCode ='02842';
          insert newAcc;
          
          
          Account newAcc1 = new Account();
          newAcc1.name = 'NewTestCustomer';
          newAcc1.OwnerID = Userinfo.getUserId();
          newAcc1.BillingStreet ='abc';
          newAcc1.BillingCountry= 'United States';
          newAcc1.BillingCity= 'middletown-11';
          newAcc1.Billingstate = 'Rhode Island';
          newAcc1.BillingPostalCode ='02842';
          insert newAcc1;
         
          newAcc.id=newAcc.id;       
          newAcc.Account_Status__c = 'Active';
          newAcc.BillingStreet='Abc';
          newAcc.Account_Effective_Date__c = system.today(); 
          update newAcc;        
          
          
          //Creating NewContact
          Contact newCon   = new Contact();
          newCon.FirstName = 'NewTestContactName';
          newCon.LastName  = 'NewTest';
          newCon.Email     = 'test@test.com';
          newCon.AccountID = newAcc.id;
          newCon.MailingCountry = 'United States';
          newCon.MailingCity = 'middletown';
          newCon.MailingPostalCode = '1234';
          newCon.MailingState = 'Rhode Island';
          newCon.MailingStreet = 'abc';
          
          Asset asset= new Asset();
          asset.Name='pa1';
          asset.AccountId=newAcc.id;
          asset.Asset_ID__c='123456789123456789789789';
          insert asset;
          
          //Creating NewCase
          Case newCase = new Case();
          newCase.AssetId= asset.id;
          newCase.Platform_Asset_Account__c = newAcc1.id;
             
          insert newCase;
            
            
          //Passing Current pageParameters from currentPageReference 
          Test.setCurrentPageReference(new PageReference('Page.CreateKVHIndirectContact')); 
          System.currentPageReference().getParameters().put('CaseId', newCase.id);
          System.currentPageReference().getParameters().put('accountId',newAcc.id);
          CreateKVHIndirectContact CKIC = New CreateKVHIndirectContact();
          CKIC.con = newCon;
          CKIC.emailAddress = 'test@test123.com';
          CKIC.phone = '1234';
          CKIC.mobile = '1234';
             
            
            
          CKIC.search();
          //IF RECORDS NOT FOUND
          system.assertEquals(CKIC.contactDetails.size(),0);
          system.assertEquals(CKIC.foundData,false);
          
          CKIC.createNewContactAndAccountConfirmation();
          CKIC.CreateAccountContact();
          CKIC.ContactToCase();
          CKIC.AccountLinkRedirect();
              
          Contact newCon1   = new Contact();
          newCon1.FirstName = 'NewTestContactName';
          newCon1.LastName  = 'NewTest';
          newCon1.Email     = 'test@test.com';
          newCon1.phone     = '1234';
          newCon1.MobilePhone= '1234';
          newCon1.AccountID = newAcc.id;
          newCon1.MailingCountry = 'United States';
          newCon1.MailingCity = 'middletown';
          newCon1.MailingPostalCode = '1234';
          newCon1.MailingState = 'Rhode Island';
          newCon1.MailingStreet = 'abc';
          insert newCon1;
            
          CKIC.emailAddress = 'test';
          CKIC.phone  = '1234';
          CKIC.mobile = '1234';  
          CKIC.search();
          //IF RECORDS NOT FOUND
          system.assertEquals(CKIC.contactDetails.size(),1);
          system.assertEquals(CKIC.foundData,true);
          
          System.currentPageReference().getParameters().put('contactID', newCon1.id);
          CKIC.ContactLinkRedirect();
          CKIC.existingContactUpdate();         
    }
}