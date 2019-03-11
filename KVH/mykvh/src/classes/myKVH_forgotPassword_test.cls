@isTest(SeeAllData=false)
public class myKVH_forgotPassword_test {

    static testMethod void testLTE_ForgotPassword() {
        // Instantiate a new controller with all parameters in the page
        myKVH_forgotPassword controller = new myKVH_forgotPassword();
        controller.username = 'test@salesforce.com';        
    
        System.assertEquals(controller.forgotPassword(),null); 
        
        myKVH_forgotPassword.forgotPass('test@salesforce.com','test','test');
         myKVH_forgotPassword.forgotPass('test.com','test','test');
    }
    static testMethod void testforgotPass(){
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
        myKVH_forgotPassword.forgotPass('pb@ff.com','test','test');
        Test.stopTest(); 
    }
    
    
}