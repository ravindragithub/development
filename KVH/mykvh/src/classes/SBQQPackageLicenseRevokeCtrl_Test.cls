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
private class SBQQPackageLicenseRevokeCtrl_Test{
    static testMethod void testSBQQPackageLicenseRevokeCtrl(){
        User objPortalUser = getPortalUser(PortalType.PowerPartner, null, true);
        System.assert([SELECT isPortalEnabled 
                       FROM user 
                       WHERE id =: objPortalUser.id].isPortalEnabled,
                      'User was not flagged as portal enabled.');  
        
        UserPackageLicense objUserPackageLicense = new UserPackageLicense();
        objUserPackageLicense.PackageLicenseId = [SELECT Id FROM PackageLicense WHERE NamespacePrefix = 'SBQQ'].Id;
        objUserPackageLicense.UserId = objPortalUser.Id;
        insert objUserPackageLicense;

        Datetime objDateTime = Datetime.now().addMinutes(1);
        String strCornExpression = '0 '+ objDateTime.minute() + ' * ' + objDateTime.day() + ' ' + objDateTime.month() + ' ? ' + objDateTime.year();
        Test.startTest();
        SBQQPackageLicenseRevokeController objSBQQPackageLicenseRevokeController = New SBQQPackageLicenseRevokeController();
        system.schedule('Test', strCornExpression, objSBQQPackageLicenseRevokeController);
        Test.stopTest();
    }
    
   enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }

    private static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert) {
        /* Make sure the running user has a role otherwise an exception 
		will be thrown. */
        if(userWithRole == null) {   
            if(UserInfo.getUserRoleId() == null) {
                UserRole objUserRole = new UserRole(name = 'TEST ROLE');
                Database.insert(objUserRole);
                userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest1.com', userroleid = objUserRole.id,
                                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                        localesidkey='en_US', profileid = UserInfo.getProfileId(), 
                                        timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
            } else {
                userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }
            
            System.assert(userWithRole.userRoleId != null, 
                          'This test requires the target org to have at least one UserRole created. Please create a user role in this organization and try again.');
        }
        
        Account objAccount;
        Contact objContact;
        System.runAs(userWithRole) {
            
            objAccount = new Account(name = 'TEST ACCOUNT');
            Database.insert(objAccount);
            
            objContact = new Contact(AccountId = objAccount.id, lastname = 'lastname');
            Database.insert(objContact);
            
        }
        
        /* Get any profile for the given type.*/
        Profile objProfile = [SELECT id 
                     FROM profile 
                     WHERE usertype =: portalType.name()
                     LIMIT 1];   
        
        String testemail = 'te13name@mail.com';
        User objUser = new User(profileId = objProfile.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname', contactId = objContact.id);
        
        if(doInsert) {
            Database.insert(objUser);
        }
        return objUser;
    }
    
}