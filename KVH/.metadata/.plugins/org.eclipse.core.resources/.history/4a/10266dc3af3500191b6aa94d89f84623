/****************************************************
    Name        :        AgilePlansController
    Description :
*****************************************************/
public class AgilePlansController{
    //public veriables
    public List<Case> caselist{get;set;}
    public Case newCase{get;set;}
    public List<SelectOption> notificationOptions{get;set;}
    public Attachment serviceOrder{get;set;}
    public Attachment siteSurvey{get;set;}
    public String notification{get;set;}
    public String comments{get;set;}
    
    string oppId;
    Opportunity opp;
    
    /***************************************
    #constructor
    ****************************************/
    public agilePlansController(Apexpages.standardcontroller ctrl){
        this.oppId = ctrl.getId();
        init();
    }
    
    private void init(){
        
        this.caselist = new List<Case>();
        this.notificationOptions = new List<SelectOption>();
        notificationOptions.add(new SelectOption('KU','KU'));
        notificationOptions.add(new SelectOption('KE','KE'));
        notificationOptions.add(new SelectOption('KS','KS'));
        serviceOrder = new Attachment();
        siteSurvey = new Attachment();
        opp = [Select id,Owner.name,Technical_Contact__r.Name,Technical_Contact__c,ownerId from Opportunity where ID =: oppId];
        newCase = new Case();
        fetchRelatedCases();
    }
    
    private void fetchRelatedCases(){
        String caseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Installation').getRecordTypeId();
        caselist  = [Select id,New_Vessel_or_Platform__c,status from Case where Related_Opportunity__c =: oppId AND recordTypeID =: caseRecordType ];
    }
    
    public PageReference back(){
        return new PageReference('/'+oppId);
    }
    
    public PageReference submit(){
        Savepoint sp = Database.setSavepoint();
        System.debug('@@ newCase==>'+newCase);
        if(!validation()){
            try{
                //create new case
                String queueId = [Select id from Group where type = 'Queue' and name = 'Field Service Backlog'][0].Id;
                newCase.subject = newCase.New_Vessel_or_Platform__c + ' - New AgilePlans Install Request';
                newCase.Related_Opportunity__c = oppId;
                newCase.Type = 'Request AgilePlans Installation Support';
                newCase.Product_or_Service__c = 'KVH mini-VSAT Broadband (TracPhone V-Series, V-IP Series)';
                newCase.Product_or_Service_Detail__c = 'Mobile Data Carrier, KVH Mini-VSAT KU/C Band Service';
                
                String description = 'Please see the attached Service Order and Sales Order for ' + newCase.New_Vessel_or_Platform__c + ' AgilePlans installation.';
                newCase.Description = description;
                newCase.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Installation').getRecordTypeId();
                if(serviceOrder.body != null)
                    newCase.AgilePlans_Service_Order_Attached__c = true;
                if(siteSurvey.body != null)
                    newCase.AgilePlans_Site_Survey_Attached__c = true;
                
                newCase.Sales_Order_Desk__c = notification;
                newCase.ContactId = opp.Technical_Contact__c;
                newCase.Sales_Contact__c = opp.ownerId;
                String contactId;
                if(notification == 'KU'){
                    contactId = Label.AgilePlans_KU_Email;
                }else if(notification == 'KE'){
                    contactId = Label.AgilePlans_KE_Email;
                }else if(notification == 'KS'){
                    contactId = Label.AgilePlans_KS_Email;
                }
                //newCase.AgilePlans_Opportunity_Id__c = oppID;
                newCase.OwnerId = queueId;
                //set status
                if(newCase.AgilePlans_Service_Order_Attached__c == true && newCase.AgilePlans_Site_Survey_Attached__c == true){
                    newCase.status = 'Pending Sales Order';
                }else if(newCase.AgilePlans_Service_Order_Attached__c == true && newCase.AgilePlans_Site_Survey_Attached__c == false){
                    newCase.status = 'Pending Sales Order and Site Survey';
                } 
                
                newCase.Origin = 'Opportunity';
                insert newCase;
                
                //insert case comment
                CaseComment caseComment = new CaseComment();
                caseComment.ParentId = newCase.Id;
                caseComment.CommentBody = comments;
                insert caseComment;
                
                //attache the attachments under new case created
                List<Attachment> attlst = new List<Attachment>();
                if(serviceOrder.body != null){
                    attlst.add(serviceOrder);
                    serviceOrder.parentId = newCase.Id;
                }
                if(siteSurvey.body != null){
                    siteSurvey.parentId = newCase.Id;
                    attlst.add(siteSurvey);
                }
                
                if(attlst.size()>0)
                    insert attlst;
               serviceOrder = new Attachment();
               siteSurvey = new Attachment();
               sendNotification(newCase.Id,contactId);
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Please click the back button to navigate to the opportunity detail page.'));
               System.debug('@@ newCase==>'+newCase);
               init();
           }catch(Exception ex){               
               Database.rollback( sp );
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,ex.getmessage() + ' ' + ex.getlinenumber()));
               init();
           }
       }else{
           serviceOrder = new Attachment();
           siteSurvey = new Attachment();
       }
       return null;
    }
    
    private boolean validation(){
        boolean isError = false;
        if(serviceOrder.body == null){            
            isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Service Order is required.'));
        }
        
        if(notification == null || String.isBlank(notification)){            
            isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Order Entry Notification is required.'));
        }
        
        
        return isError;
    } 
    
    private void sendNotification(String caseId,String contactId){
       List<Messaging.EmailFileAttachment> attachmentlist = new List<Messaging.EmailFileAttachment>();
       for(Attachment att : [Select name,body from Attachment where parentId =: caseId]){
           Messaging.EmailFileAttachment attach= new Messaging.EmailFileAttachment();
           attach.setBody(att.body);
           attach.setFileName(att.name);
           attachmentlist.add(attach);
       }
       List<EmailTemplate> emailTemplates = [Select id from EmailTemplate where name = 'New AgilePlans Service Order'];
       List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where Address = 'sf_substitute@kvh.com'];
       if(emailTemplates.size()>0){
           Messaging.SingleEmailMessage semail= new Messaging.SingleEmailMessage();
           semail.setTargetObjectId(contactId);
           semail.setWhatId(caseId);
           semail.setTemplateId(emailTemplates[0].Id);
           semail.setFileAttachments(attachmentlist);          
           if ( owea.size() > 0 ) {
                semail.setOrgWideEmailAddressId(owea[0].ID);
           }
           Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});
       }       
       
    }  
}