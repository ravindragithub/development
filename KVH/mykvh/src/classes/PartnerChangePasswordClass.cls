public with sharing class PartnerChangePasswordClass {

    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}

    public PageReference changePassword() {
        if(String.isBlank(newPassword) || String.isBlank(verifyNewPassword) || String.isBlank(oldpassword)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Password fields are required'));
            return null;
        }
        else if(!(newPassword.isAlphanumeric()) || (newPassword.isNumeric()) || (newPassword.isAlpha()) || (newPassword.length() < 8) || newPassword.equals(newPassword.toLowerCase())){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'New password field does not match password requirements'));
            return null;
        }
        else if(!(newPassword.equals(verifyNewPassword))){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'New password and verification of new password does not match'));
            return null;
        }
        PageReference pr;
        try{
            User u = [Select Id,Username,FirstName,LastName, Email FROM User Where Id=:UserInfo.getUserId()];
            /*
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {u.Email};
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,u.Email));
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('SF_Support@kvh.com');
            //OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'SF_Support@kvh.com'];
            //mail.setOrgWideEmailAddressId(owea.get(0).Id);
            mail.setSubject('Changed Password');
            mail.setBccSender(false);
            mail.setPlainTextBody('Hello ' + u.FirstName +' your password has been changed. If this was not you please create a case at ');
            mail.setHtmlBody('Hello ' + u.FirstName +' your password has been changed. If this was not you please create a case at <p>');
			*/
            Site.validatePassword(u,newPassword,verifyNewPassword);
            pr=Site.changePassword(newPassword, verifyNewPassword, oldpassword);
            if(pr != null){
            	//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Password changed'));
        		pr= new PageReference('/apex/PartnerChangePasswordSuccess');
                pr.setRedirect(true);
            	System.debug(pr.getUrl());
                return pr;
            }else{
                //Adding this to bypass Site methods because they cannot be covered by test classes.
                pr= new PageReference('PartnerChangePassword');
            }
        }catch(exception e){
            System.debug(e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        	return null;
        }
        return null;
    }

}