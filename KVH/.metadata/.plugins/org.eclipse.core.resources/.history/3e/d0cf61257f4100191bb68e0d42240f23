/**
* An apex page controller that exposes the site forgot password functionality
*/
public without sharing class myKVH_forgotPassword {
    public String username {get; set;}  
    
    public myKVH_forgotPassword() {
        
    }
    
    @AuraEnabled
    public static Map<String,Object> forgotPass(string username,string serialnumber,string destination) {
        Map<String,Object> resultmap = new Map<String,Object>();
        boolean success = false; 
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(username);
        system.debug('==MyMatcher.matches()=='+MyMatcher.matches());
        if(MyMatcher.matches()){
            List<User> userlst = new List<User>([Select id,name,username,email,profile.name from User where email =: username 
                                                 and contactId != null limit 1]);
            if(userlst.size() > 0){
                resultmap.put('profilename',userlst[0].profile.name);
                Set<String> partnerProfiles = new Set<String>();
                for(String p : Label.Partner_Profiles.split(',')){
                    partnerProfiles.add(p);
                    if(userlst[0].profile.name == p)
                      resultmap.put('partnerprofile',p);
                }
                if(
                    !partnerProfiles.contains(userlst[0].profile.name) &&
                    userlst[0].profile.name != 'myKVH Customer of a Service Provider'
                ){
                    success = Site.forgotPassword(userlst[0].username);
                    resultmap.put('success',true);
                    resultmap.put('error','correct profile');
                }else{                       
                    resultmap.put('success',false);
                    resultmap.put('error','wrong profile');
                }
                system.debug('==success==' + success);
                
                if(success){
                    userlst[0].Destination__c = destination;
                    userlst[0].Serial_Number__c = serialnumber;
                    update userlst;                       
                    
                }
            }
            else{
                resultmap.put('success',false );
                resultmap.put('error','Did not recognize that email address, or maybe you are a New to myKVH');
                
            }
        }
        else{
            resultmap.put('success',false);
            resultmap.put('error','Please enter a valid email address');
        }
        return resultmap;
    }
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
        
        string urlstr= URL.getSalesforceBaseUrl().toExternalForm();
        PageReference pageref = new PageReference(Label.myKVH_community_url +'mykvh-forgot-password-confirm');
        pageref.setRedirect(true);
        if (success) {              
            return pageref;
        }
        return null;
    }
    
    
}