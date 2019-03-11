public class PortalUserEmail 
{
  public static Messaging.Singleemailmessage GetTemplatedEmail(Id TemplateId, Id orgwideId, Id targetObjId, Id whatId, Boolean saveAsActivity)
  {    
    Messaging.Singleemailmessage singleE = new Messaging.Singleemailmessage();
    singleE.setReplyTo('mykvhsupport@kvh.com');
    singleE.setSenderDisplayName('mykvhsupport@kvh.com');
    singleE.setWhatId(whatId);
    singleE.setTemplateId(TemplateId);  
    singleE.setTargetObjectId(targetObjId);
    singleE.setSaveAsActivity(saveAsActivity); 
    return singleE;
  }
}