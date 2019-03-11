/*********************************************
Name        :    Case_OrderEntryNotificationCtrl
Description :    Send notification to the service desk 
                for order entry
**********************************************/
public class Case_OrderEntryNotificationCtrl{
    
    String caseId;
    public Case_OrderEntryNotificationCtrl(Apexpages.standardcontroller ctrl){
        this.caseId = ctrl.getId();
    }
    
    public void sendNotification(){
        case caseObj = [Select id,Sales_Order_Desk__c from Case where id =: caseId];
        String contactId;
        if(caseObj.Sales_Order_Desk__c == 'KE'){
            contactId = Label.AgilePlans_KE_Email;
        }else if(caseObj.Sales_Order_Desk__c == 'KS'){
            contactId = Label.AgilePlans_KS_Email;
        }else if(caseObj.Sales_Order_Desk__c == 'KU'){
            contactId = Label.AgilePlans_KU_Email;
        }
        List<EmailTemplate> emailTemplates = [Select id from EmailTemplate where name = 'Shipping Info to Order Entering Notification'];
        List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where Address = 'sf_substitute@kvh.com'];
        if(emailTemplates.size()>0){
           Messaging.SingleEmailMessage semail= new Messaging.SingleEmailMessage();
           semail.setTargetObjectId(contactId);
           semail.setWhatId(caseId);
           semail.setTemplateId(emailTemplates[0].Id);           
           if ( owea.size() > 0 ) {
                semail.setOrgWideEmailAddressId(owea[0].ID);
           }
           Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Shipping Info to order notification sent.'));
        }       
        
      
    }
    
    public PageReference back(){
        return new PageReference('/'+caseId);
    }
}