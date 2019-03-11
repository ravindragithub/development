global class PartnerLoginController {
    public apexpages.standardcontroller controller;
    global String uname;
    global String password {get; set;}
    global string newpassword {get; set;}
    global string newpassword1 {get; set;}
    
    //contact us form variable
    public String firstname{get;set;}
    public String lastname{get;set;}
    public String email{get;set;}
    public String message{get;set;}
    public boolean messagesent{get;set;}

    global PartnerLoginController () {messagesent=false;} 
    
    private string stieprifix = site.getPathPrefix();
       
    global PageReference resetpass() {
        string message;
        List <User> u1 = new List <User>();
        u1 = [SELECT Id, Email FROM User WHERE Email =: uname LIMIT 1];
        if (u1.size() ==0){
            message = 'This email address was not found.  Please verify the address.';
            ApexPages.Message mess = new ApexPages.Message(ApexPages.Severity.ERROR, message);
            ApexPages.addMessage(mess);
            return null;
        } 
        system.resetPassword(u1[0].Id, true);
        PageReference pageref = new PageReference(stieprifix + '/PartnerLoginThanks');
        return pageref;
    }
    public PageReference changepassword() {
        return Site.changePassword(newPassword, newpassword1, password);    
    } 
    global void setuname(String uname) {
        this.uname = uname;
    }
    global string getuname(){
        return uname;
    }
    global PageReference login() {
        string rtnValue = validProfile(uname);
        if(rtnValue == 'myKVH Customer Community User'){
            string urlstr =  Label.myKVH_community_url;
            PageReference pageref = new PageReference(urlstr);
            return pageref;
        }
        else if(rtnValue == 'myKVH Customer of a Service Provider'){
            PageReference pageref = new PageReference('https://mvm.mykvh.com/');
            return pageref;
        }
        else{
            String startUrl = stieprifix + '/s/';        
            return Site.login(uname, password, startUrl);
        }
    }
    private String validProfile(String username) {
        List<User> loginUser = new List<User>([Select Id,Name,ProfileId,Username From User Where Username =: username]);
        String profileName;
        if(loginUser.size() > 0){
            profileName = [Select Id,Name from Profile where Id=: loginUser[0].ProfileId].Name;
            return profileName;
        }
        else{
            return null;
        }
    }
    //send email to support
    public void createCase(){
        messagesent = false;
      /*  system.debug('@@ firstname==>'+firstname);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        string[] to = new string[] {Label.KVH_Contact_Us_Email};
        
        mail.setToAddresses(to);
       
        mail.setSubject('New enquiry from '+firstname);
        String body = 'Hi,<br/><br/>';
        body += 'You have following request on KVH partner portal.<br/><br/>';
        body += '<b>First Name<b/> : '+firstname + '<br/>';
        body += '<b>Last Name<b/> : ' + lastname + '<br/>';
        body += '<b>Email<b/> : '+ email + '<br/>';
        body += '<b>Message<b/> : '+ message.replaceAll('\\\n','<br/>') + '<br/>';
        body += '<br/>Thanks<br/>KVH Portal';
        mail.setHtmlBody(body);
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            firstname = '';
            lastname = '';
            email = '';
            message = '';
            messagesent = true;
        }catch(Exception ex){
            System.debug('@@ exception==>'+ex.getmessage());
        }*/
        try{
            Id portalCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Partner Portal').getRecordTypeId();
            Case newCase = new Case();
            newCase.recordTypeId = portalCaseRecordTypeId;
            newCase.SuppliedName = firstname + ' ' + lastname;
            newCase.SuppliedEmail = email;
            String descr = 'From: ' + firstname + ' ' +lastname + ' <' + email + '>\n';
            descr += 'To: partnerportal@kvh.com\n\n';
            descr += 'New "Contact Us" Form Submission from KVH Partner Portal password reset page.\n\n';
            descr += 'First Name : ' + firstname + '\n';
            descr += 'Last Name  : ' + lastname + '\n';
            descr += 'Email : ' + email +'\n';
            descr += 'Message : '+ message;
            newCase.Description = descr;
            newCase.subject = 'New "Contact Us" Form Submission from ' + firstname + ' ' + lastname;
            
            
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.useDefaultRule= true;
            newCase.setOptions(dmlOpts);
            newCase.Origin = 'Web';
            insert newCase;
            firstname = '';
            lastname = '';
            email = '';
            message = '';
            messagesent = true;
        }catch(Exception ex){
            System.debug('Excetpion in contact us form==>'+ex.getmessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getmessage()));
        }
    }
}