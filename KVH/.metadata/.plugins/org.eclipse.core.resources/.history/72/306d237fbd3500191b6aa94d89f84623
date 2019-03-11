Public Class UserUtilities{
    
    Public List<Contact> PortalUsers(list<User> userData){
        Map<id,user> portalUsers = New Map<id,User>();
        
        for(user verifyPortalUsers:userData){
            if(verifyPortalUsers.contactID!=null){
                portalUsers.put(verifyPortalUsers.contactID,verifyPortalUsers);
            }
        }
        
        List<Contact> updateRoles = [SELECT id,Name,isPortalUser__c,myKVH_Role__c FROM Contact WHERE id=:portalUsers.keySet()];
        
        for(Contact conDetails:updateRoles){
            if(portalUsers.containsKey(conDetails.id)){
                User uDetails = portalUsers.get(conDetails.id);
                if(uDetails.IsActive){
                    conDetails.isPortalUser__c = true;
                    conDetails.myKVH_Role__c = uDetails.myKVH_Role__c;
                }else{
                    conDetails.isPortalUser__c = false;
                    conDetails.myKVH_Role__c = null;
                }
            }
        }
        
        Update updateRoles;
        
        return updateRoles;
    }
}