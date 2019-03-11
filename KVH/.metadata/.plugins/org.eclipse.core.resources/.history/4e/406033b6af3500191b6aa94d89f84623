Public Class Act_Contact_list_component_controller extends Act_Base_component_controller{
    
    public String strActivationContact  {get; set;} // selected ContactId from Vf page pass it as page parameter
    private static String strAuthorizedRepRole = 'Authorized Representative';      // Contact Authorized Rep Role can be taken from custom labels later
    private static String strInvoiceRole = 'Invoice Recipient';      // Contact Invoice Recipient Role can be taken from custom labels later
   
    //Constructor
    public Act_Contact_list_component_controller(){
        ActOrderId = ApexPages.currentPage().getParameters().get('order');
    }
    
    // Method To get all Contacts with 'Authorized Representative' Role Only
    public List<Activation_Contact__c> getActivationContactList(){
        ActOrderId = ApexPages.currentPage().getParameters().get('order');
        if(ActOrderId !=null){
            List<Activation_Contact__c> lstActivationContacts = New List<Activation_Contact__c>();
            for(Activation_Contact__c objActivationContact: 
                [SELECT id,First_Name__c,Salutation__c,Last_Name__c,State__c,
                 Email__c,Primary_Phone__c,Job_Function__c,Job_Title__c,Account__c,Country__c,
                 Secondary_Phone__c, Secondary_Phone_Type__c,Contact_Role__c,Contact__c
                 FROM Activation_Contact__c WHERE  Activation_Order__c =: ActOrderId]){
                     if(objActivationContact.Contact_Role__c != null && objActivationContact.Contact_Role__c.containsIgnoreCase(strAuthorizedRepRole)){
                         lstActivationContacts.add(objActivationContact);
                     }
                 }
            return lstActivationContacts;
        }
        return null;
    } 
    
    
    //To load activation contact to edit
    Public PageReference EditContact(){
        PageReference reference = ApexPages.currentPage();
        reference.getParameters().clear();
        reference.getParameters().put('order', ActOrderId); 
        reference.getParameters().put('conActID', strActivationContact);
        reference.setRedirect(true);
        return reference;
    } 
    
    //To load activation contact to edit
    Public PageReference reloadcontactlist(){
        PageReference reference = ApexPages.currentPage();
        reference.getParameters().clear();                     
        reference.getParameters().put('order', ActOrderId); 
        reference.setRedirect(true);
        return reference;
    } 
    
    //To Remove Authorized Representative Role 
    Public PageReference RemoveRole(){
        system.debug('strActivationContact'+strActivationContact);
        if(strActivationContact != '' && strActivationContact != null){
            Activation_Contact__c objActivationContact = [SELECT Id, Contact_Role__c FROM Activation_Contact__c WHERE Id =: strActivationContact];
            if(objActivationContact.Contact_Role__c == strAuthorizedRepRole || objActivationContact.Contact_Role__c == (strAuthorizedRepRole +', '+ strInvoiceRole) || objActivationContact.Contact_Role__c == (strInvoiceRole +', '+ strAuthorizedRepRole)){
                Delete objActivationContact;
            }else
                if(objActivationContact.Contact_Role__c.containsIgnoreCase(strAuthorizedRepRole)){
                String strTempRole = objActivationContact.Contact_Role__c.trim().remove(strAuthorizedRepRole).trim().removeEnd(',').replace(', ,', ', ').removeStart(',');
                objActivationContact.Contact_Role__c = strTempRole;
                system.debug('objActivationContact'+objActivationContact);
                Update objActivationContact;
            }
            getActivationContactList();
        }
        return reloadcontactlist();
    }
}