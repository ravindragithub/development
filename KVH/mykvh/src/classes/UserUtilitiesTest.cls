@isTest
Private class UserUtilitiesTest{
    private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
    private static final Profile PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
    private static final User adminUser = [SELECT Id, username, profileID FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
    static integer MAX_LOOP_COUNTER = 200;
    @testSetup static void dataSetup() {
        Account acc = new Account (
        Name = 'newAcc1',
        recordTypeID = Platform_RECORD_TYPE_ID
        );  
        insert acc;
        
        //Contacts to create portal users
        List<Contact> conts = new List<Contact>();
        for(integer i=0;i<MAX_LOOP_COUNTER;i++){
            Contact con = new Contact (
            AccountId = acc.id,
            LastName = 'portalTestUser'
            );
            conts.add(con);
        }
        insert conts;
        //Users with out contact
        List<User> allUsers = New List<User>();
        for(integer i=0;i<MAX_LOOP_COUNTER;i++){
            User newUser = new User(
                profileId = adminUser.profileID,
                username = 'newUser@kvh.com'+i,
                email = 'pb@ff.com',
                emailencodingkey = 'UTF-8',
                localesidkey = 'en_US',
                languagelocalekey = 'en_US',
                timezonesidkey = 'America/Los_Angeles',
                alias='nuser',
                lastname='lastname',
                isActive = true,
                myKVH_Role__c = '12345'
            );
            allUsers.add(newUser); 
         }
         
        //Portal user creation
        for(integer i=0;i<conts.size();i++){
            User newUser = new User(
                profileId = PortalProf.ID,
                username = 'newUserPortal@kvh.com'+i,
                email = 'pb@ff.com',
                emailencodingkey = 'UTF-8',
                localesidkey = 'en_US',
                languagelocalekey = 'en_US',
                timezonesidkey = 'America/Los_Angeles',
                alias='nuser',
                lastname='lastname',
                myKVH_Role__c = '12345',
                contactID = conts[i].id
            );
            if(i>2){
                newUser.isActive = true;
            }else{
                newUser.isActive = false;
            }
            allUsers.add(newUser); 
         }
         system.debug('ALL USERS==>'+allUsers.size());
         System.runAs (new User(Id = UserInfo.getUserId())){
             insert allUsers;
         }
         
    }
    
    
    static testMethod void UserUtilities(){
        //validating testData
        Test.startTest();
        List<User> validateUsers = [SELECT id,isActive,myKVH_Role__c,contactID FROM USER];
       
        UserUtilities uu = New UserUtilities();
        List<Contact> portalContacts = uu.PortalUsers(validateUsers);
        
        //Total Portal contacts
        
        system.assertEquals(MAX_LOOP_COUNTER,portalContacts.size());
        
        integer activePortalContacts = 0;
        integer deActivePortalContacts = 0;
        
        for(contact findportalUser:portalContacts){
            if(findportalUser.isPortalUser__c){
                activePortalContacts +=1;
            }else{
                deActivePortalContacts+=1;
            }
        }
        
        //Active Portal contacts -> Here we should get 197 active portal users because line number 58 I am activating  isActive "true"
        system.assertEquals(activePortalContacts,197);
        
        //De-Active Portal contacts
        system.assertEquals(deActivePortalContacts,3);
        
        Test.stopTest();  
    }
}