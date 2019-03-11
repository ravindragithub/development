@isTest
Private Class ContactTriggerTest{
    private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
    //Method used to Reutilizing Data
    @testSetup static void setup(){
        //AccountObject TestData Creation
        Account accObj = New Account();
        accObj.name = 'TestAccTestName';
        accObj.BillingCountry = 'United States';
        accObj.Billingstate = 'Rhode Island';
        insert accObj;
        
        //ContactObject TestData Creation
        Contact objContact = New Contact();
        objContact.FirstName = 'TestConFirstname';
        objContact.lastName = 'TestConnameTest';
        objContact.AccountID = accObj.id;
        objContact.Inactive_Contact__c = false;
        objContact.email = 'testFalse@etKVH.com';
        insert objContact;
        
        //ContactObject TestTrueData Creation
        Contact objTrueContact = New Contact();
        objTrueContact.FirstName = 'TestConTruename';
            objTrueContact.lastName = 'TestConTrueTest';
        objTrueContact.AccountID = accObj.id;
        objTrueContact.Inactive_Contact__c = true;
        objTrueContact.email = 'testTrue@etKVH.com';
        insert objTrueContact;
        
        
        profile pf = [SELECT ID FROM Profile where name=:'Customer Portal - Read/Write Case Access (all cases in accounts in hierarchy)'];
        
        //Create false user 
        User mockUser = new User(contactId=objContact.Id, 
                            username=objContact.Email, 
                            firstname=objContact.FirstName,
                            lastname=objContact.LastName, 
                            email=objContact.Email,
                            communityNickname = objContact.LastName + '_'+Math.random(),
                            alias = string.valueof(objContact.FirstName.substring(0,1) + 
                                    objContact.LastName.substring(0,1)), 
                            profileid = pf.Id, emailencodingkey='UTF-8',
                            languagelocalekey='en_US', 
                            localesidkey='en_US', 
                            isActive=true,
                            IsActiveProxy__c = true,
                            timezonesidkey='America/Los_Angeles',UserPreferencesDisableAllFeedsEmail = false); 
                            
         system.runAs(adminUser){	//Avoid mixed DML
         	insert mockUser;
         }
         
         
         //Create true user 
        User mockTrueUser = new User(contactId=objTrueContact.Id, 
                            username=objTrueContact.Email, 
                            firstname=objTrueContact.FirstName,
                            lastname=objTrueContact.LastName, 
                            email=objTrueContact.Email,
                            communityNickname = objTrueContact.LastName + '_'+Math.random(),
                            alias = string.valueof(objTrueContact.FirstName.substring(0,1) + 
                                    objTrueContact.LastName.substring(0,1)), 
                            profileid = pf.Id, emailencodingkey='UTF-8',
                            languagelocalekey='en_US', 
                            localesidkey='en_US', 
                            isActive=false,
                            IsActiveProxy__c = false,
                            timezonesidkey='America/Los_Angeles',UserPreferencesDisableAllFeedsEmail = false); 
                            
         system.runAs(adminUser){	//Avoid mixed DML
         	insert mockTrueUser;
         }
    }
    
    @isTest static void ContactTriggerTrueValidation(){
       //Before trigger fires
       test.startTest();
       Contact conObj = [SELECT id,LastName,Inactive_Contact__c FROM Contact WHERE LastName=:'TestConnameTest' LIMIT 1];
       system.assert(conObj.Inactive_Contact__c==false);
       
       User userDataValidateBefore = [SELECT ID,isActive,IsActiveProxy__c FROM User WHERE ContactID=:conObj.id LIMIT 1];
       system.assertEquals(userDataValidateBefore.IsActiveProxy__c,true);
       
       User systemAdimUser = [SELECT id FROM User WHERE Id=:userinfo.getuserID()];
       system.runAs(systemAdimUser){
           conObj.Inactive_Contact__c = true;
           update conObj;
       }
       
       //After trigger fires
       test.stopTest();				//Async jobs catch up....
       Contact conObjAfter = [SELECT id,LastName,Inactive_Contact__c FROM Contact WHERE id=:conObj.id LIMIT 1];
       system.assert(conObj.Inactive_Contact__c==true);
       
       //IsActiveProxy__c is no longer used
       //User userDataValidateAfter = [SELECT ID,isActive,IsActiveProxy__c FROM User WHERE ContactID=:conObj.id LIMIT 1];
       //system.assertEquals(userDataValidateAfter.IsActiveProxy__c,false);
    }
    
    @isTest static void ContactTriggerFalseValidation(){
       //Before trigger fires
       test.startTest();
       Contact conObj = [SELECT id,LastName,Inactive_Contact__c FROM Contact WHERE LastName=:'TestConTrueTest' LIMIT 1];
       system.assert(conObj.Inactive_Contact__c==true);
       
       User userDataValidateBefore = [SELECT ID,isActive,IsActiveProxy__c FROM User WHERE ContactID=:conObj.id LIMIT 1];
       system.assertEquals(userDataValidateBefore.IsActiveProxy__c,false);
       
       User systemAdimUser = [SELECT id FROM User WHERE Id=:userinfo.getuserID()];
       system.runAs(systemAdimUser){
           conObj.Inactive_Contact__c = false;
           update conObj;
       }
       
       //After trigger fires
       test.stopTest();				//Async jobs catch up....
       Contact conObjAfter = [SELECT id,LastName,Inactive_Contact__c FROM Contact WHERE id=:conObj.id LIMIT 1];
       system.assert(conObj.Inactive_Contact__c==false);
       
       //IsActiveProxy__c is no longer used
       //User userDataValidateAfter = [SELECT ID,isActive,IsActiveProxy__c FROM User WHERE ContactID=:conObj.id LIMIT 1];
       //system.assertEquals(userDataValidateAfter.IsActiveProxy__c,true);
    }
}