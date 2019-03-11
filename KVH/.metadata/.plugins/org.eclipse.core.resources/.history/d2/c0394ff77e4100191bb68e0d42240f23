public class CustomHeaderController {
    
    @AuraEnabled
    public static User getCurrentUser() {
        User toReturn = [SELECT Id,
                FirstName,
                LastName,
                Profile.Name,
                Portal_View__c,contactid,
                myKVH_Role__c
                 
        FROM User
        WHERE Id = :UserInfo.getUserId()
        LIMIT 1];
		system.debug('this is the user' + toReturn.Id);
        return toReturn;
    }

}