public with sharing class UserManagementLoader {
	public pageReference onLoad(){
		pageReference p = new pageReference('/Manage_myKVH_Users');
		p.setRedirect(true);
		return p;
	}

}