public with sharing class myKVH_role_for_user_ctrlEXT {
    private final user theUser;
    //private ApexPages.Standardcontroller cont;
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public myKVH_role_for_user_ctrlEXT(ApexPages.StandardController stdController){
        //cont = stdController;
        this.theUser = (user)stdController.getRecord();
        system.debug(theUser);
        myUser = [SELECT id, Name, myKVH_Role__c FROM User WHERE Id =: theUser.Id LIMIT 1];
        system.debug(myUser.myKVH_Role__c);
        myKVH_Role_Id = myUser.myKVH_Role__c;       //sets the radiobutton corresponding to the Users Role
    }
    public user myUser {get; set;}
    public Boolean Dirty = false;
    public string myKVH_Role_Id {get; set;}
    
    public Boolean getDirty(){
        return Dirty;
    }
    private void setDirty(Boolean dirt){
        Dirty = dirt;
    }
    
    public string getmyKVH_Role_Id(){
        return myKVH_Role_Id;
    }
    public void setmyKVH_Role_Id(string role_id){ 
        myKVH_Role_Id = role_id;
        setDirty(true);
    }
    public list<SelectOption> getRoles(){
        list<SelectOption> options = new list<SelectOption>();
        for (myKVH_Role__c r : [SELECT id, Name FROM myKVH_Role__c 
        						WHERE isRoleExtension__c != true AND isRoleExtension__c  = false]){
            options.add(new SelectOption(r.id, r.Name));
        }
        return options;
    }
    public void onClickAction(){
        setDirty(true);
        list<myKVH_Role__c> roles = new List<myKVH_Role__c>();
        roles = [SELECT Id FROM myKVH_Role__c WHERE Id =: myKVH_Role_Id LIMIT 1];
        myUser.myKVH_Role__c = roles[0].Id;
    }
    
    public pageReference saveRoleChanges(){
        //do the work...
        system.debug(myUser);
        update myUser;
        setDirty(false);
        //return cont.save();
        return null;
    }
}