public class Act_Invoice_list_component_controller extends Act_Base_component_controller {
    
    private static String strInvoiceRecipientRole = 'Invoice Recipient'; // Contact InvoiceRecipient Role can be taken from custom labels later
    private static String strGroupRole = 'Group Invoice Recipient';                       // Contact Group Email Role can be taken from custom labels later
    private static String strBillingRepresentativeRole = 'Billing Representative';      // Subscriber Billing Representative Role can be taken from custom labels later

    private static String strKeyPrefixActivationContact = Activation_Contact__c.sobjecttype.getDescribe().getKeyPrefix();  // Keyprefix of Activation Contact
    
    public String   selectedRecordId        {get; set;} // For passing Selected Record Id from vf page
    public String   selectedRecordRoles     {get; set;} // For passing Selected Record Roles from vf page
    //constructor
    public Act_Invoice_list_component_controller(){
        ActOrderId = ApexPages.currentPage().getParameters().get('order');
    }
    
    public List<wrapObject> getInvoiceWrapList(){
        if(ActOrderId !=null){
            List<wrapObject> lstwrapObject = New List<wrapObject>();
                       
            for(Activation_Contact__c objActivationContact : 
                [SELECT Id,First_Name__c,Salutation__c,Last_Name__c,
                 Email__c,Primary_Phone__c,Contact_Role__c
                 FROM Activation_Contact__c 
                 WHERE Activation_Order__c =: ActOrderId AND Contact_Role__c LIKE '%Invoice Recipient%']){
                     wrapObject objwrapObject = New wrapObject();
                     String strName = (objActivationContact.Salutation__c !=null ? objActivationContact.Salutation__c : '') +' '+
                         (objActivationContact.First_Name__c !=null ? objActivationContact.First_Name__c : '') +' '+
                         (objActivationContact.Last_Name__c !=null ? objActivationContact.Last_Name__c : '');
                     
                     objwrapObject.strName = strName;
                     objwrapObject.strPhone = objActivationContact.Primary_Phone__c;
                     objwrapObject.strEmail = objActivationContact.Email__c;
                     objwrapObject.strRoles = objActivationContact.Contact_Role__c;
                     objwrapObject.idRecord = objActivationContact.id;
                     lstwrapObject.add(objwrapObject);
                 }
            return lstwrapObject;
        }
        return null;
    } 
    
    
    //To load Record to edit
    Public PageReference Edit(){
        PageReference reference = ApexPages.currentPage();
        reference.getParameters().clear();                     
        reference.getParameters().put('order', ActOrderId); 
        if(selectedRecordId != '' && selectedRecordId != null){
            if(strKeyPrefixActivationContact == selectedRecordId.substring(0, 3)){
                reference.getParameters().put('conActID', selectedRecordId); 
            }
        }
        if(selectedRecordRoles !=null && selectedRecordRoles !='' && selectedRecordRoles.containsIgnoreCase(strGroupRole)){
            reference.getParameters().put('Role', 'Group'); 
        }
        reference.setRedirect(true);
        return reference;
    } 
   
    //To update Role Invoice 
    Public PageReference updateRole(){
        //Check if Record is contact
        if(strKeyPrefixActivationContact == selectedRecordId.substring(0, 3)){
            Activation_Contact__c objActivationContact = [SELECT Id, Contact_Role__c FROM Activation_Contact__c WHERE Id =: selectedRecordId];
            if(objActivationContact.Contact_Role__c !=null && (objActivationContact.Contact_Role__c.equalsIgnoreCase(strGroupRole) || objActivationContact.Contact_Role__c.equalsIgnoreCase(strInvoiceRecipientRole))){
                objActivationContact.Contact_Role__c = null;
                DELETE objActivationContact;
            }else if(objActivationContact.Contact_Role__c !=null && objActivationContact.Contact_Role__c.containsIgnoreCase(strInvoiceRecipientRole)){
                String strTempRole = objActivationContact.Contact_Role__c.trim().remove(strInvoiceRecipientRole).trim().removeEnd(',').replace(', ,', ', ').replace(',,', ', ').removeStart(',');
                objActivationContact.Contact_Role__c = strTempRole;
                update objActivationContact;
            }
            
        }
        selectedRecordId = '';
        selectedRecordRoles ='';
        getInvoiceWrapList();
        return Edit();
    } 
    
    //Wrapper class to show list of activation contact and  subscriber
    Public Class wrapObject{
        public Id       idRecord            {get; set;}
        public String   strName             {get; set;}
        public String   strPhone            {get; set;}
        public String   strEmail            {get; set;}
        public String   strRoles            {get; set;}
    }
}