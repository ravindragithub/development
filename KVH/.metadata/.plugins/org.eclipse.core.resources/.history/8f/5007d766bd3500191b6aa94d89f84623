/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class LTE_ForgotPassword {
    public String username {get; set;}   
       
    public LTE_ForgotPassword() {}
    
    public PageReference forgotPassword() {
        boolean success; 
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(username);

        if(username != null && username != ''){
            if(MyMatcher.matches()){
                List<User> userlst = new List<User>([Select id,name,username,email from User where email =: username limit 1]);
                if(userlst.size() > 0)
                success = Site.forgotPassword(username);
                else{
                success = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Did not recognize that email address, or maybe you are a New to myKVH'));
                
                }
            }
            else{
            success = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter a valid email address'));
            }
        }
        else{
        success = false;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter a valid email address'));
        }
        
        
        PageReference pr = Page.LTE_ForgotPasswordConfirm;
        pr.setRedirect(true);
        if (success) {              
            return pr;
        }
        return null;
    }
       

}