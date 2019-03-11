public class myKVH_User_Role_Extension_Utilities {
	public void SendTomyKVH(list<myKVH_User_Role_Extension__c> UREList){
		set<User> UsersToSend = new set<User>();
		for(myKVH_User_Role_Extension__c URE : UREList){
			User u = new User();
			u.Id = URE.User__c;
			u.myKVH_Manual_Push__c = true;
			UsersToSend.add(u);
		}
		list<User> UserList = new list<User>(UsersToSend);
		update UserList;
	}
	

}