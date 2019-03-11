public class myKVHUserSync implements Queueable{
	private list<User> userList {get;set;}
	//constructor
	public myKVHUserSync(list<User> triggeredUsers){
		this.userList = triggeredUsers;
	}
	public void execute(QueueableContext context){
		for(integer i = 0; i < userList.size(); i++){
			this.userList[i].myKVH_Manual_Push__c = true; 
		}
		update userList;
	}
}