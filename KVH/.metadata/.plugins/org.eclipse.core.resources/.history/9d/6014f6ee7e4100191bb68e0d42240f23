public with sharing class AttachmentUploadController {
    //probably going to need to pass the parameter from the button/link
  //public string InstallConfigId = ApexPages.CurrentPage().getparameters().get('id');
  
  public Attachment attachment {
  get {
      if (attachment == null)
        attachment = new Attachment();
        //attachment.Name = 'Original CommBox Config';
        //attachment.Description = 'This is the default file description. Please enter some meaningful information';
      return attachment;
    }
  set;
  }
  
        
 //Need to add a Cancel button...
 //Need to setup a return URL (probably the InstallConfigId)
  public PageReference Cancel() {
    PageReference OriginPage = new PageReference(ApexPages.CurrentPage().getparameters().get('retURL'));
    return OriginPage;
  }
  
 //Maybe change the attachment name so it's read only.
  public PageReference upload() {
    //attachment.Name = fileName;
    string InstallConfigId = ApexPages.CurrentPage().getparameters().get('id');
    PageReference OriginPage = new PageReference(ApexPages.CurrentPage().getparameters().get('retURL'));
    attachment.OwnerId = UserInfo.getUserId();
    attachment.ParentId = InstallConfigId;
    //attachment.ParentId = 'a0He00000003ZlR'; // the record the file is attached to
    //attachment.IsPrivate = true; //The isPrivate setting prevents other users from downloading files uploaded from other users
    system.debug(attachment.Name);  //rename the attached file
    

    Database.SaveResult sr;
    try {
      //insert attachment;
      sr = Database.insert(attachment, false); } catch (DMLException e) {ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));return OriginPage;
    } finally {
      attachment = new Attachment(); 
    }
    //Populate the records "file" field with the record ID of the attached file
    //The "link" field will be populated automatically...
    Install_Config__c CBXIC = new Install_Config__c();
    CBXIC = [SELECT Id, Initial_CBX_Config_File__c FROM Install_Config__c WHERE id =:InstallConfigId];
    CBXIC.Initial_CBX_Config_File__c = sr.getId();
    //try
    update CBXIC;

    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
    return OriginPage;
  }
}