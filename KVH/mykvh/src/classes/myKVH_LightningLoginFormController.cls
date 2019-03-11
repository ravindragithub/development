global without sharing class myKVH_LightningLoginFormController {
    public myKVH_LightningLoginFormController() {
        
    }
    /***********************************************
Name        :    validProfile
Description :    Valid Login Profile, based on which user will be redirect to Partner portal or mvh.kvh.com
************************************************/
    @AuraEnabled
    public static String validProfile(String username) {
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
    /***********************************************
Name        :    validProfile
Description :    Standard Login Method in Community
************************************************/
    @AuraEnabled
    public static String login(String username, String password, String startUrl,String destination,String serialNumber) {     
        try{
            List<User> loginUser = new List<User>([Select Id,Name,ProfileId,Username,Destination__c,Serial_Number__c From User Where Username =: username]);
            if(loginUser.size() > 0){
                if(destination != '' && serialNumber != ''){
                    loginUser[0].Destination__c = destination;
                    loginUser[0].Serial_Number__c = serialNumber;
                    update loginUser;
                }
                /*if(loginUser[0].Destination__c != null && loginUser[0].Destination__c != '' && 
                  loginUser[0].Serial_Number__c != null && loginUser[0].Serial_Number__c != '')
                    startUrl = Label.myKVH_community_url + loginUser[0].Destination__c;*/
                if(loginUser[0].Destination__c != null && loginUser[0].Destination__c != '')
                    startUrl = Label.myKVH_community_url + loginUser[0].Destination__c;
            }
            ApexPages.PageReference lgn = Site.login(username, password, startUrl);
            aura.redirect(lgn);
            return null;
        }
        catch (Exception ex) {
            return ex.getMessage();            
        }    
    }
    
    @AuraEnabled
    public static Boolean getIsUsernamePasswordEnabled() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        return authConfig.getUsernamePasswordEnabled();
    }
    
    @AuraEnabled
    public static Boolean getIsSelfRegistrationEnabled() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        return authConfig.getSelfRegistrationEnabled();
    }
    
    @AuraEnabled
    public static String getSelfRegistrationUrl() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        if (authConfig.getSelfRegistrationEnabled()) {
            return authConfig.getSelfRegistrationUrl();
        }
        return null;
    }
    
    @AuraEnabled
    public static String getForgotPasswordUrl() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        return authConfig.getForgotPasswordUrl();
    }
    
    @TestVisible
    private static Auth.AuthConfiguration getAuthConfig(){
        Id networkId = Network.getNetworkId();
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(networkId,'');
        return authConfig;
    }
    
    @AuraEnabled
    global static String setExperienceId(String expId) {
        // Return null if there is no error, else it will return the error message 
        try {
            if (expId != null) {
                if(!Test.isRunningTest()){
                    Site.setExperienceId(expId);
                }
            }
            return null; 
        } catch (Exception ex) {
            return ex.getMessage();            
        }
    }
}