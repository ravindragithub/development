global class SiteLoginPageController {
	
	global PageReference isUserLoggedIn() {
    	system.debug(system.Userinfo.getUserType());        
    	if (system.Userinfo.getUserType() != 'Guest'){							//not a 'Guest' means currently logged in...
    		system.debug('Not a Guest');
            siteLoginController util = new siteLoginController();				//instanciate a controller...
    		String startUrl = util.getStartUrl(system.UserInfo.getUserName());	//returns startURL based on Users profile....
    		PageReference HomePageRef = new PageReference(startURL);			//send em home (or wherever)...
    		HomePageRef.setRedirect(true);
            return HomePageRef;
        } else {
            system.debug('Must be a Guest');
    		PageReference pageRef = ApexPages.currentPage();	//or let em log in
    		return null;
    	}
    }
    
}