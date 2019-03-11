/******************************************
    Name        :    GenerateAWSSignedURLBatch
    Description :    This class generates signed URL of selected
                     Prod Document records
*******************************************/
global class GenerateAWSSignedURLBatch implements  Database.Batchable<sObject>,Database.AllowsCallouts{
   global Set<Id> prodDocumentIds;   
   global String loginuserMail;
   global GenerateAWSSignedURLBatch(Set<Id> prodDocumentIds,String loginuserMail){
       System.debug('@@ prodDocumentIds==>'+prodDocumentIds);
       this.prodDocumentIds = prodDocumentIds;
       this.loginuserMail = loginuserMail;
   }
   global Database.QueryLocator start(Database.BatchableContext BC){
      String query = 'Select Name,Internal_Document_Record__c,File_Extension__c,Hosting_URL__c,File_Access__c,AWS_Error_Log__c from Prod_Documents__c where File_Access__c != NULL AND id IN : prodDocumentIds';
      System.debug('@@ query==>'+query);
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<Prod_Documents__c> scope){
         Map<String,Api_Keys__c> apiKeyMap = Api_Keys__c.getAll();
         for(Prod_Documents__c s : scope){
             try{
                 string fileName = s.Id +'.'+s.File_Extension__c;
                 if(s.File_Access__c == 'Private'){
                     s.Hosting_URL__c = Label.Download_Link + s.Internal_Document_Record__c;
                 } else{
         			 s.Hosting_URL__c = 'https://s3.amazonaws.com/kpp-public/' + s.Id + '.' + s.File_Extension__c;
                 }
             }catch(Exception ex){
                 System.debug('@@ excpetion in url genration==>'+ ex.getlinenumber() + ' ' + s.ID + ' ' + ex.getStackTraceString());
             }
         }
         update scope;
   }

   global void finish(Database.BatchableContext BC){
       String jobID = bc.getJobId();
       List<AsyncApexJob> joblst = [SELECT CreatedByID FROM AsyncApexJob where id =: jobID];
       if(!joblst.isEmpty()){
           List<User> userlst = [Select id,email from User where id =: jobID];
           if(userlst.size()>0)
               loginuserMail = userlst[0].email;
       }

       List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       
       mail.setToAddresses(new List<String>{loginuserMail});
        
        mail.setSubject('AWS URL genration batch job finished');
        String body = 'Hi ' + ', <br><br> All batches has been finished to generate AWS URL.<br><br> Thanks';
        
        mail.setHtmlBody(body);
        
        mails.add(mail);
        Messaging.sendEmail(mails);          
          
   }
}