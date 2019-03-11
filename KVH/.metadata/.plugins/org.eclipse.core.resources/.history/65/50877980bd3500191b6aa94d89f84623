global class classSendContactEmailPortal{
    webservice static void sendContactEmailPortal(Id targetId,Id objectId){
        system.debug('Portal Email=========');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Id ownerId = targetId != null ? targetId : userInfo.getUserId();
        mail.setTargetObjectId(ownerId);
        mail.setWhatId(objectId);
        mail.setSenderDisplayName('Salesforce Support');
        mail.setUseSignature(false);
        mail.setBccSender(false);
        mail.setSaveAsActivity(false);
        EmailTemplate objEmailTemplate=[SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName=:'KVH_Registration_Submitted_on_Behalf_of'];
        mail.setTemplateId(objEmailTemplate.Id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                
    }
}