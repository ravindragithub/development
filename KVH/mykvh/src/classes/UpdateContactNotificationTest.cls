@isTest
Private Class UpdateContactNotificationTest{
    static testMethod void UpdateContactNotification(){
         
    
         Case caseRecord = New Case();
         caseRecord.Length_of_Service_Interruption__c = '12';
         insert caseRecord;
         
         Contact conObj = New Contact();
         conObj.LastName = 'lastName';
         conObj.Network_Outage_Case__c = caseRecord.id;
         conObj.Inactive_Contact__c = false;
         conObj.Email = 'test@test.com';
         conObj.HasOptedOutOfEmail = false;
         conObj.Network_Outage_Type__c ='Receive ALL network notifications';
         insert conObj;
         
         UpdateContactNotification.ContactNotification(caseRecord.id,'Standard');
         
         UpdateContactNotification.ContactNotification(caseRecord.id,'Extended');
         
         
    }
}