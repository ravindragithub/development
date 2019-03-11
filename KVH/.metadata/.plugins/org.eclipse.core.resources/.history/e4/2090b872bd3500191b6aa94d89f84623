/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest
private class SBQQPackageAutoAsignController_Test {
    static testMethod void testSBQQPackageAutoAsignController(){
        list<Profile> lstAdminProfile = new list<Profile>();
        lstAdminProfile = [SELECT Id, Name FROM Profile WHERE Name LIKE '%System Admin%' LIMIT 1];
        User objUser = new User(LastName = 'gues1t user 1', 
                                Username = 'gue1st.user.1@example.com', 
                                CommunityNickname = 'nickname',
                                Email = 'gue1st.1@example.com', 
                                Alias = 'g1ues1', 
                                TimeZoneSidKey = 'GMT', 
                                LocaleSidKey = 'en_GB', 
                                EmailEncodingKey = 'ISO-8859-1', 
                                ProfileId = lstAdminProfile[0].id, 
                                LanguageLocaleKey = 'en_US'); 
        Test.startTest();
        SBQQPackageAutoAsignController.validateRecord(New List<User>{objUser}); //Try Block Handling
        SBQQPackageAutoAsignController.validateRecord(New List<User>{objUser}); //Catch Block Handling
        Test.stopTest();
        
    }
}