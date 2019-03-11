/********************************************************
Name       :    myKVH_Case_ViewCtrl
Description :    Controller class for myKVH_Case_View
*********************************************************/
public class myKVH_Case_ViewCtrl{
    public case caseObj{get;set;}
    public boolean showAddComment{get;set;}
    
    public myKVH_Case_ViewCtrl(Apexpages.standardController ctrl){
        showAddComment = true;
        caseObj = [Select id,CaseNumber,Parent_Case__c,Contact_Name__c,contactId,
                   New_Vessel_or_Platform__c,Asset_Name__c,Type,Product_or_Service__c,
                   Status,Subject,Case_Symptom__c,Description,CreatedDate,ClosedDate from Case where ID =: ctrl.getID()];
        User cUser = [Select id,contactid from User where ID =: userinfo.getUserID()];
        List<UserRecordAccess> recordAccess = [SELECT RecordId, HasEditAccess FROM UserRecordAccess 
                                               WHERE UserId =: userInfo.getUserId() AND RecordId =: caseObj.Id ];
        if(recordAccess.size()>0 && recordAccess[0].HasEditAccess){
            showAddComment = true;
        }else{
            showAddComment = false; 
        }
    }
}