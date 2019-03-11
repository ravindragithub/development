/*

    Name: PortalUserProfileController
    Created By: Jason McCormack (GearsCRM)
    Created Date: 
    Description: 
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public with sharing class PortalUserProfileController 
{   
    private User user;
    private boolean isEdit = false;
    
    public User getUser() {
        return user;
    }

    public PortalUserProfileController() {
        user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
        // guest users should never be able to access this page
        if (user.usertype == 'GUEST') {
            throw new NoAccessException();
        }
    }
    
    public Boolean getIsEdit() {
        return isEdit;
    }
    
    public void edit() {
        isEdit=true;
    }    
    
    public void save() {
        if (user.contact != null) {              
            setContactFields(user.contact, user);
        }
        
        try {
            update user;
            if (user.contact != null) { 
                update user.contact;
            }
            isEdit=false;
        } catch(DmlException e) {
            ApexPages.addMessages(e);
        }
    }
    
    public PageReference changePassword() {
        return Page.PortalChangePassword;
    }
    
    public void cancel() {
        isEdit=false;
        user = [SELECT id, email, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
    }
    
    private static void setContactFields(Contact c, User u) {
        c.title = u.title;
        c.firstname = u.firstname;
        c.lastname = u.lastname;
        c.email = u.email;
        c.phone = u.phone;
        c.mobilephone = u.mobilephone;
        c.fax = u.fax;
        c.mailingstreet = u.street;
        c.mailingcity = u.city;
        c.mailingstate = u.state;
        c.mailingpostalcode = u.postalcode;
        c.mailingcountry = u.country;
    }

    @IsTest(SeeAllData=true) static void testSave() {         
        // Modify the test to query for a portal user that exists in your org
        List<User> existingPortalUsers = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND UserType='CustomerSuccess'];

        if (existingPortalUsers.isEmpty()) {
            User currentUser = [select id, title, firstname, lastname, email, phone, mobilephone, fax, street, city, state, postalcode, country
                                FROM User WHERE id =: UserInfo.getUserId()];
            PortalUserProfileController controller = new PortalUserProfileController();
            System.assertEquals(currentUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
            System.assert(controller.isEdit == false, 'isEdit should default to false');
            controller.edit();
            System.assert(controller.isEdit == true);
            controller.cancel();
            System.assert(controller.isEdit == false);
            /*Need to create a test Account here, and add the Contact below to it jthom 8/15/13*/
            Account testAcct1 = new Account(Name = 'testAcct1', BillingCountry = 'Spain');
            Insert testAcct1;
            testAcct1 = [SELECT Id, Name FROM Account WHERE name =: 'testAcct1' LIMIT 1];
            /*testAcct1 added jthom 8/15/13*/
            Contact c = new Contact();
            c.LastName = 'TestContact';
            c.MailingCountry = 'Italy';
            c.AccountId = testAcct1.Id;     //This should prevent the validation rule exception
            insert c;
            
            setContactFields(c, currentUser);
            controller.save();
            System.assert(Page.PortalChangePassword.getUrl().equals(controller.changePassword().getUrl()));
        } else {
            User existingPortalUser = existingPortalUsers[0];
            String randFax = Math.rint(Math.random() * 1000) + '5551234';
            
            System.runAs(existingPortalUser) {
                PortalUserProfileController controller = new PortalUserProfileController();
                System.assertEquals(existingPortalUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
                System.assert(controller.isEdit == false, 'isEdit should default to false');
                controller.edit();
                System.assert(controller.isEdit == true);
                
                controller.cancel();
                System.assert(controller.isEdit == false);
                
                controller.getUser().Fax = randFax;
                controller.save();
                System.assert(controller.isEdit == false);
            }
            
            // verify that the user and contact were updated
            existingPortalUser = [Select id, fax, Contact.Fax from User where id =: existingPortalUser.Id];
            System.assert(existingPortalUser.fax == randFax);
            System.assert(existingPortalUser.Contact.fax == randFax);
        }
    }

}