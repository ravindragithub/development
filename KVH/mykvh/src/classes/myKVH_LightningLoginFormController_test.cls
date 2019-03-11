@isTest(SeeAllData = true)
private class myKVH_LightningLoginFormController_test {
    /**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Tests for LTE_LightningLoginFormController
*
* Derived from Salesforce generated Class
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         John Thompson   <jthompson@kvh.com@kvh.com>
* @modifiedBy     Modifier   <modifier@kvh.com>
* @maintainedBy   Maintainer   <maintainer@kvh.com>
* @version        1.0
* @created        2018-May-22
* @modified       YYYY-MM-DD
* @systemLayer    Invocation | Service | Utility | Selector | Domain | Test
* @see            ????
* @see            ????
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0            jthompson@kvh.com@kvh.com
* 2018-May-22      Explanation of the change.  Multiple lines can be used to explain the change
*
* vX.X            author@kvh.com
* YYYY-MM-DD      Each change to this file should be documented by incrementing the version number,
*                 and adding a new entry to this @changes list. Note that there is a single blank
*                 line between each @changes entry.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    
    @IsTest
    static void testLoginWithInvalidCredentials() {
        System.assertEquals('Argument 1 cannot be null', myKVH_LightningLoginFormController.login('testUser', 'fakepwd', null, null, null));
    }
    
    @IsTest
    static void LightningLoginFormControllerInstantiation() {
        myKVH_LightningLoginFormController controller = new myKVH_LightningLoginFormController();
        System.assertNotEquals(controller, null);
    }
    
    @IsTest
    static void testIsUsernamePasswordEnabled() {
        System.assertEquals(true, myKVH_LightningLoginFormController.getIsUsernamePasswordEnabled());
    }
    
    @IsTest
    static void testIsSelfRegistrationEnabled() {
        System.assertEquals(false, myKVH_LightningLoginFormController.getIsSelfRegistrationEnabled());
    }
    
    @IsTest
    static void testGetSelfRegistrationURL() {
        System.assertEquals(null, myKVH_LightningLoginFormController.getSelfRegistrationUrl());
    }
    @IsTest
    static void testForgotPasswordUrl() {
        System.assertEquals(null, myKVH_LightningLoginFormController.getForgotPasswordUrl());
    }
    @IsTest
    static void testAuthConfig() {
        Auth.AuthConfiguration authConfig = myKVH_LightningLoginFormController.getAuthConfig();
        System.assertNotEquals(null, authConfig);
    }
    // Test Method to cover GDPRfieldUpdate
    static testMethod void test_validProfile() {
        List<Account> accList = TestDataFactory.createAccountRecords(1, null,'Prospect',false,false,'','',null,'');
        insert accList;  
        Contact con = TestDataFactory.createContactRecords('testFCon','testLCon', 'test@email.com');
        con.AccountId = accList[0].Id;
        insert con;  
        Profile p = [select Id,name from Profile where Name =: 'myKVH Customer Community User' limit 1];
        
        User newUser = new User(
            profileId = p.id,
            username = 'newUser@yahoo.com',
            email = 'pb@ff.com',
            emailencodingkey = 'UTF-8',
            localesidkey = 'en_US',
            languagelocalekey = 'en_US',
            timezonesidkey = 'America/Los_Angeles',
            alias='nuser',
            lastname='lastname',
            contactId = con.id
        );
        insert newUser;
        Test.startTest(); 
        myKVH_LightningLoginFormController.setExperienceId('123');
        system.assertEquals('myKVH Customer Community User', myKVH_LightningLoginFormController.validProfile('newUser@yahoo.com'));
        Test.stopTest(); 
    }
}