/* Whenever we add or remove (of update) a Platform Share Record,
 * we need to send a User Outbound Message to myKVH for the corresponding Users.
 * This ensures that myKVH User details stay in sync with Salesforce.
 */
public class myKVH_Shared_Platforms_Utilities {
	public void SendTomyKVH(list<myKVH_Shared_Platforms__c> PlatShareList){	//We need a list of Shared Platforms in order to proceed...
		set<User> UsersToSend = new set<User>();							//Use a set to de-duplicate Users
		for(myKVH_Shared_Platforms__c PlatShare : PlatShareList){			//Loop through our input list
			User u = new User();											//Create a User sObject...
			u.Id = PlatShare.User__c;										//using the User Id from the Platform Share record...
			u.myKVH_Manual_Push__c = true;									//and set that Manual Push field!
			UsersToSend.add(u);												//add the User to the list (handles dupes perfectly!)
		}
		list<User> UserList = new list<User>(UsersToSend);					//Convert set to list...
		//update UserList;													//Update the Users, would rather NOT do this synchronously!
		ID jobID = System.enqueueJob(new myKVHUserSync(UserList));			//Update the Users, asynchonously!
	}
}