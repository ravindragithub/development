public without sharing class myKVH_NotificationSettingController {
    /***********************************************
        Name        :    GDPRfieldUpdate
        Description :    Update Contact communication fields based on User input in
						My Notification external page
    ************************************************/
    @AuraEnabled
    public static void GDPRfieldUpdate(String recordId, Boolean emailValue, Boolean postalValue, Boolean telephoneValue, Boolean declineValue) {
        List<Contact> theContact = new List<Contact>([SELECT Id, Title, CSN_Patch_Sent__c, Telephone_Opted_In__c,MailingCountry, MailingState ,Email_Opted_In__c, Phone, Postal_Mail_Opted_In__c, FirstName, LastName 
                                                           FROM contact  WHERE Id =: recordId LIMIT 1]);
        if(theContact.size() > 0){
            if(emailValue == true){
                theContact[0].Email_Opted_In__c = 'Agree'  ;          
            }
            if(postalValue == true){
                theContact[0].Postal_Mail_Opted_In__c = 'Agree'  ;          
            }
            if(telephoneValue == true){
                theContact[0].Telephone_Opted_In__c = 'Agree'  ;          
            }
            if(declineValue == true){
                theContact[0].Email_Opted_In__c = 'Decline'  ;
                theContact[0].Postal_Mail_Opted_In__c = 'Decline';
                theContact[0].Telephone_Opted_In__c = 'Decline'  ; 
            }
            try{
                //Insert Lead Record
                update theContact[0];
            }catch(DmlException e) {
                //get DML exception message
                throw new AuraHandledException(e.getMessage());
            }catch(Exception e){
                //get exception message
                throw new AuraHandledException(e.getMessage());
            }
            finally {
            }
            
        }
    }
}