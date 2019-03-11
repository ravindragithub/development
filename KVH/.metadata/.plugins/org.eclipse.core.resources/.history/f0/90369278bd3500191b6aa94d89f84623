/**
 * Created by Jai Chaturvedi on 15/05/2017.
 */

@IsTest
private class TestCustomHeaderController {

/*    @testSetup static void setupData() {
        User user = PartnerCommunityTestData.createPartnerUser(
                'Partner-Distributor',
                'robstark@got.com');
        insert user ;
    }*/

    @isTest static void getCurrentUserTest(){
        User currentUser = [ SELECT Id
        FROM User
        WHERE Id = :UserInfo.getUserId()
        ];

        Account acc = PartnerCommunityTestData.createAccount('PartnerCommunity');
        insert acc;
        Contact con = PartnerCommunityTestData.createContact(acc.Id);
        insert con;

        system.runAs(currentUser) {
            User user = PartnerCommunityTestData.createPartnerUser(
                    'Partner-Distributor',
                    'robstark@got.com');
            user.ContactId = con.Id;
            user.Portal_View__c = 'Commercial & OEM Maritime Systems';
            insert user;
            system.runAs(user) {
                CustomHeaderController.getCurrentUser();
            }
        }
    }
}