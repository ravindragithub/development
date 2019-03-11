global with sharing class SelfRegLoginController {
	global String username {get; set;}
	global transient String password {get; set;}
	global string startUrl {get;set;}
	global SelfRegLoginController() {
		startURL = '/home/home.jsp';
	}
	global PageReference login() {
		system.debug('Invoking Typical Controller Login Method');
        PageReference result = Site.login(username, password, startUrl);
        //system.debug(result);
        return result;
    }
}