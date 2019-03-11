@isTest(SeeallData=true)
private class EmailsTest {
    static testMethod void Emails () {
        
        EmailTemplate e = [SELECT ID FROM EmailTemplate LIMIT 1];
        
        ID targetObjectID = UserInfo.getUserId();
        
        Account acc = New Account();
        acc.Name = 'TestAccName';
        acc.BillingCountry = 'INDIA';
        insert acc;
        
        Contact targetConID = New Contact();
        targetConID.LastName = 'TestContact';
        targetConID.Email = 'Test@test.Com';
        targetConID.MailingCountry = 'Italy';
        targetConID.AccountId = acc.ID;
        insert targetConID;
        
        ID OrgID = UserInfo.getOrganizationId();
       
        PortalUserEmail coverEmailClass  = New PortalUserEmail();
        PortalUserEmail.GetTemplatedEmail(e.id,OrgID,targetObjectID,targetConID.ID,true);
    }
}