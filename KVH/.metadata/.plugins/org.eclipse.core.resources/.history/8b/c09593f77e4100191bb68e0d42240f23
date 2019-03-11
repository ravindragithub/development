public class CustomerPortalApps {
    
    public Boolean boolRenderPermissionSet  {get; set;}
    public Boolean boolRenderWarningMessage {get; set;}
    public Boolean boolRenderShip {get; set;}
    public String strDescription {get; set;}
    public Boolean  boolIsShowBehalfButton 	{get; set;} // show Register on Behalf of a Customer Button

    public CustomerPortalApps(){
        boolRenderPermissionSet = false;
        boolRenderWarningMessage = false;
        boolIsShowBehalfButton = false;
        boolRenderShip = true;
        for(PermissionSetAssignment objPermissionSetAssignment : [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE Assignee.Id = : UserInfo.getUserId() AND PermissionSet.Name = 'Activation_Portal_Users']){
            boolRenderPermissionSet = true;
        }
        List<User> objUsers = New List<User>();
        for(user objUser : [SELECT Id, myKVH_Role__c, Start_URL__c, Profile.Name, AccountId FROM user WHERE Id = :UserInfo.getUserId()]){
            if(String.isNotBlank(objUser.myKVH_Role__c) && String.isNotBlank(objUser.Start_URL__c)){
                boolRenderShip = false;
                if(objUser.Start_URL__c.containsIgnoreCase('m.mykvh.com'))
                    boolRenderWarningMessage = true;
            } else if (objUser.Profile.Name == 'Customer Portal - Product Registration Only'){
                boolRenderShip = false;
            }
            objUsers.add(objUser);
        }
        
        if(objUsers.size()>0){
            Set<Id> setAccountRecordTypeIds = New Set<Id>();
            setAccountRecordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Partner').getRecordTypeId());
            setAccountRecordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Partner').getRecordTypeId());
            
            Id idAccount = objUsers[0].AccountId;
            Id idAccountRecordTypeId ;
            if(idAccount != null){
                Account objAccountTemp = [SELECT Id,RecordTypeId,Partner_Role__c FROM Account WHERE Id =: idAccount];
                idAccountRecordTypeId = objAccountTemp.RecordTypeId;
                boolIsShowBehalfButton = (setAccountRecordTypeIds.contains(idAccountRecordTypeId)) ? true : false;
            }
        }
    }
    
    public void createcaseMethod(){
        createCase('Verify my KVH mini-VSAT Manager Permissions', strDescription , [SELECT ContactId FROM User WHERE Id =: Userinfo.getUserId()].ContactId);
    }
    @testVisible private void createCase(string strSubject, String strDescription, Id strContactId){ //Used to create a case when something weird happens....
        final Id myKVHFeedbackCase_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('myKVH Feedback').getRecordTypeId();
        final Group SvcCloudQueue = [SELECT Id FROM Group WHERE DeveloperName = 'Service_Cloud_Queue' and Type = 'Queue'];
        Case newCase = New Case();
        newCase.RecordTypeId = myKVHFeedbackCase_RECORD_TYPE_ID;
        newCase.ContactId = strContactId;
        newCase.Subject = strSubject;
        newCase.Origin = 'Web';
        //newCase.Case_Symptom__c = strSymptom;
        newCase.Status = 'New';
        newCase.Description = strDescription + '(Login User : '+userInfo.getUserName()+')';
        newCase.OwnerId = SvcCloudQueue.Id;
        insert newCase;
        // system.debug(newCase); 
    }
    
}