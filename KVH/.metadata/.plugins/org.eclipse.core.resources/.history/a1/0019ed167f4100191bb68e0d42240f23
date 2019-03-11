/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class SiteLoginController {
    public String selectedStartURL {get; set;}
    public String productURL {get; set;}
    global String username {get; set;}
    global String password {get; set;}

    global SiteLoginController () { //no argument constructor....
        selectedStartURL = 'myKVH_Customer_portal'; // default value
        productURL = 'ProductReg';
    }                
    
    global PageReference login() {
        String startUrl = getStartUrl(username);         
        system.debug('startUrl is'+startUrl);              //returns startURL based on Users profile & Fleet Size....
        return Site.login(username, password, startUrl);
    }
    global string getProductUrl(string u){
        //string returnstring = '/apex/SelfRegisteredUserWelcomePage?URLReference=ProductReg';
        string returnstring = '/home/home.jsp';
        return returnstring;
    }
    global PageReference shipboard() {
        String startUrl = getStartUrl(username);
        startUrl = 'https://login.mykvh.com/saml/consume?application=light';
        return Site.login(username, password, startUrl);
    }
    global string getStartUrl(string u){
        string returnString = '/home/home.jsp';                                //default startURL
        User userDetails = new User();                                      //need to query Username for userDetails....
        list<String> VisiblePlatformIds = new list<String>();               //need a list of Platforms visible to User....
        
        try {                                                               //Query against UserName
            userDetails = [SELECT Contact.Agree_to_myKVH_Terms_and_Conditions__c, Id, username, Agree_to_myKVH_Terms_and_Conditions__c, Profile.Name FROM User WHERE username =: u LIMIT 1];
            SiteUtilities util = new SiteUtilities();
            VisiblePlatformIds = util.getFleetList(userDetails.Id);
            system.debug ('check here');
            system.debug('fleet of ' + VisiblePlatformIds[0]);
        } catch (system.QueryException e){                                  //user does not exist!
            system.debug('User ' + u + ' not found! ' + e.getMessage());
        } catch (exception e){system.debug(e.getMessage());}                //code coverage hack, cannot simulate
        if(userDetails.Agree_to_myKVH_Terms_and_Conditions__c == 'Accept') {
            if(ApexPages.currentPage().getParameters().get('reg') == 'true') {
                returnstring = '/Activation_Product_Registration';
                
            } else if(ApexPages.currentPage().getParameters().get('reg') == 'onbehalf') {
                string orderId = ApexPages.currentPage().getParameters().get('orderid');
                returnstring = '/mykvh/activation_product_registration?order=' + orderId;
            } 
            else if (ApexPages.currentPage().getParameters().get('reg') == 'Self') {
                returnstring = '/home/home.jsp';
                //returnstring = '/apex/SelfRegisteredUserWelcomePage?URLReference=Self';
            }
            else if(VisiblePlatformIds.size() == 1){
                returnString = '/idp/login?app=0sp13000000CaVf&RelayState=/platforms/find?sf_id=' + VisiblePlatformIds[0];  //Fleet of ONE!! Directly to myKVH Fleet override default
            } else if(userDetails != null && userDetails.Profile.Name == 'Customer Portal - Customer of Service Provider'){ //is user Customer of Reseller?
                returnString = '/idp/login?app=0sp13000000CaVf';                                                            //Directly to myKVH Fleet override default
            } else {
                returnString = '/home/home.jsp';
            }
        } else if (ApexPages.currentPage().getParameters().get('reg') == 'true') {
            //returnstring = '/apex/SelfRegisteredUserWelcomePage?URLReference=ProductReg';
            returnstring = '/home/home.jsp';
        } else if (ApexPages.currentPage().getParameters().get('reg') == 'onBehalf') {
            string orderId = ApexPages.currentPage().getParameters().get('orderid');
            //returnstring = '/apex/SelfRegisteredUserWelcomePage?URLReference=onBehalf&orderid=' + orderId;
            returnstring = '/home/home.jsp';
        }else if (ApexPages.currentPage().getParameters().get('reg') == 'Self') {
            //returnstring = '/apex/SelfRegisteredUserWelcomePage?URLReference=Self';
            returnstring = '/home/home.jsp';
        }
        system.debug('=========returnString======='+returnString);
        return returnString;                                                //no override, user default!
        }
    
    /*public List<selectOption> optionsForStartURL {
        get {
            List<selectOption> lstselectOptions = New List<selectOption>();
            for (Landing_Page_Setting__mdt objLandingPageSettingmdt : [Select DeveloperName,MasterLabel, URL_Reference__c FROM Landing_Page_Setting__mdt ORDER BY Display_Order__c ASC]){
               system.debug('objLandingPageSettingmdt'+objLandingPageSettingmdt);
                lstselectOptions.add(new SelectOption(objLandingPageSettingmdt.DeveloperName, objLandingPageSettingmdt.MasterLabel));
            }
            return lstselectOptions;
        }
        set;
    }*/
    
    //Need a method to count the number of Platforms (Accounts) for a given Contact.AccountId (in AccountUtilities)
    /*global list<string> getFleetList(string UserAcct){                            //returns a list of myKVH Platforms that a User can see
        system.debug('Entering getFleetList method with Account Id: ' + UserAcct);
        list<String> returnList = new list<String>();
        if (UserAcct != null){                                                  //make sure that we HAVE an Account ID!!
            AccountStructure util = new AccountStructure();
            list<AccountStructure.ObjectStructureMap> Hierarchy = new list<AccountStructure.ObjectStructureMap>();
            Hierarchy = util.getObjectStructure(UserAcct);
        
            for (AccountStructure.ObjectStructureMap asm : Hierarchy){
                if (asm.account.Send_to_myKVH_Physical__c && asm.account.RecordType.DeveloperName.left(9) == 'Platform_'){
                    returnList.add(asm.account.Id);
                }
            }
        }
        
        
        return returnList;
    }*/
}