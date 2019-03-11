Public Class Activation_Corporate_Authorized_Rep extends Act_Base_component_controller{
    
    public String strActivationContact  {get; set;} // selected ContactId from Vf page pass it as page parameter
    public static String strAuthorizedRepRole {  // Contact Authorized Rep Role can be taken from custom labels later
        get { return 'Authorized Representative';}
        private set;
    }
    public static String strInvoiceRole {  // Contact Invoice Recipient Role can be taken from custom labels later
        get { return 'Invoice Recipient';}
        private set;
    }
    public static String strMainContactRole { 
        get { return 'Main Contact';}
        private set;
    }      // Contact Main Role can be taken from custom labels later
    public String parentContainer {get; set;}
    private static String strparentContainer = 'contactlistcomponent';  // tab Id of authorized rep
    public static String strBillingRepresentativeRole {   // Billing Representative Role can be taken from custom labels later
        get { return 'Billing Representative';}
        private set;
    }  
    private static String strGroupRole = 'Group Invoice Recipient';                       // Contact Group Email Role can be taken from custom labels later
    public String currentRole {get; set;}
    public Integer countAuthorizedRepRecord {get; set;}
    public Integer countInvoiceRepRecord {get; set;}
    public string strCorpduplicate {get;set;}
    public boolean boolDisableRadio {get;set;} 
    //Constructor
    public Activation_Corporate_Authorized_Rep(){
        ActOrderId = ApexPages.currentPage().getParameters().get('order');
        countAuthorizedRepRecord = 0;
        countInvoiceRepRecord = 0;
        list<Activation_Subscriber__c> lstActivationSubscriber = [SELECT id,Corporate_Billing_Account__r.Bill_to__c,Corporate_Billing_Account__r.Billing_Contact__c,Corporate_Billing_Account__r.Corp_Duplicate__c FROM Activation_Subscriber__c WHERE Activation_Order__c=:ActOrderId  LIMIT 1];
        if(lstActivationSubscriber.size()>0){
            strCorpduplicate =  lstActivationSubscriber[0].Corporate_Billing_Account__r.Corp_Duplicate__c ;
            if(lstActivationSubscriber[0].Corporate_Billing_Account__r.Billing_Contact__c != null && (lstActivationSubscriber[0].Corporate_Billing_Account__r.Bill_to__c == 'Corporate' || lstActivationSubscriber[0].Corporate_Billing_Account__r.Corp_Duplicate__c == 'No')){
                strCorpduplicate = 'No'; 
                boolDisableRadio = true;
            }	
        }
    }
    
    // Method To get all Contacts Only
    public List<Activation_Contact__c> getActivationContactList(){
        countAuthorizedRepRecord = 0;
        countInvoiceRepRecord = 0;
        if(ActOrderId !=null){
            system.debug('parentContainer'+parentContainer);
            List<Activation_Contact__c> lstActivationContacts = New List<Activation_Contact__c>();
            List<Activation_Contact__c> lstActivationContactsBilling = New List<Activation_Contact__c>();
            for(Activation_Contact__c objActivationContact: 
                [SELECT id,First_Name__c,Salutation__c,Last_Name__c,State__c,
                 Email__c,Primary_Phone__c,Job_Function__c,Job_Title__c,Account__c,Country__c,Contact__c,Contact__r.id,
                 Secondary_Phone__c, Secondary_Phone_Type__c,Contact_Role__c,Activation_Order__c,Company_Main_Contact__c
                 FROM Activation_Contact__c WHERE  (Activation_Order__c =: ActOrderId AND Contact_Role__c != null) ]){ //AND Contact_Role__c=:'Authorized Rep' ORDER BY Contact_Role__c DESC
                     if(strparentContainer == parentContainer && objActivationContact.Contact_Role__c.containsIgnoreCase(strAuthorizedRepRole) || objActivationContact.Contact_Role__c.containsIgnoreCase(strMainContactRole)){
                         lstActivationContacts.add(objActivationContact);
                     }
                     if(objActivationContact.Contact_Role__c.containsIgnoreCase(strInvoiceRole) || objActivationContact.Contact_Role__c.equalsIgnoreCase(strGroupRole) || objActivationContact.Contact_Role__c.equalsIgnoreCase(strBillingRepresentativeRole)){
                         lstActivationContactsBilling.add(objActivationContact);
                     }
                     if(objActivationContact.Contact_Role__c.containsIgnoreCase(strAuthorizedRepRole)){
                         countAuthorizedRepRecord++;
                     }
                     if(objActivationContact.Contact_Role__c.containsIgnoreCase(strInvoiceRole)){
                         countInvoiceRepRecord++;
                     }
                 }
            return (strparentContainer == parentContainer) ? lstActivationContacts : lstActivationContactsBilling;
        }
        return null;
    } 
    
    
    //To load activation contact to edit
    Public PageReference EditContact(){
        PageReference reference = ApexPages.currentPage();
        reference.getParameters().clear();                     
        reference.getParameters().put('order', ActOrderId); 
        reference.getParameters().put('conActID', strActivationContact);
        if(currentRole !=null && currentRole !='' && currentRole.containsIgnoreCase(strGroupRole)){
            reference.getParameters().put('Role', 'Group'); 
        }
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
            
            if(currentRole == strMainContactRole){
                if(objActivationContact.Contact_Role__c !=null && (objActivationContact.Contact_Role__c.equalsIgnoreCase(strAuthorizedRepRole))){
                    objActivationContact.Contact_Role__c = null;
                    delete objActivationContact;
                }else if(objActivationContact.Contact_Role__c !=null && objActivationContact.Contact_Role__c.containsIgnoreCase(strAuthorizedRepRole)){
                    String strTempRole = objActivationContact.Contact_Role__c.trim().remove(strAuthorizedRepRole).trim().removeEnd(',').replace(', ,', ', ').replace(',,', ', ').removeStart(',');
                    objActivationContact.Contact_Role__c = strTempRole;
                    update objActivationContact;
                }
            }else{
                if(objActivationContact.Contact_Role__c !=null && (objActivationContact.Contact_Role__c.equalsIgnoreCase(strGroupRole) || objActivationContact.Contact_Role__c.equalsIgnoreCase(strInvoiceRole))){
                    objActivationContact.Contact_Role__c = null;
                    DELETE objActivationContact;
                }else if(objActivationContact.Contact_Role__c !=null && objActivationContact.Contact_Role__c.containsIgnoreCase(strInvoiceRole)){
                    String strTempRole = objActivationContact.Contact_Role__c.trim().remove(strInvoiceRole).trim().removeEnd(',').replace(', ,', ', ').replace(',,', ', ').removeStart(',');
                    objActivationContact.Contact_Role__c = strTempRole;
                    update objActivationContact;
                }                
            }
            getActivationContactList();
        }
        return reloadcontactlist();
    }
    
    Public PageReference UpdatedContact(){
        if(strActivationContact != '' && strActivationContact != null){
            system.debug('currentRole'+currentRole);
            List<Activation_Contact__c> lstActivationContacts = New List<Activation_Contact__c>();
            for(Activation_Contact__c objActivationContact: [SELECT id,Company_Main_Contact__c,Contact_Role__c FROM Activation_Contact__c WHERE  (Activation_Order__c =: ActOrderId AND Contact_Role__c != null)]){
                if(strActivationContact == objActivationContact.id){
                    if(!objActivationContact.Contact_Role__c.containsIgnoreCase(currentRole)){
                        if(currentRole == strMainContactRole){
                            objActivationContact.Company_Main_Contact__c = true;
                            String strTempRole = objActivationContact.Contact_Role__c.trim().replace(strAuthorizedRepRole,strMainContactRole).removeEnd(',').replace(', ,', ', ').replace(',,', ', ').removeStart(',');
                            system.debug('Current Role Details==>'+objActivationContact.Contact_Role__c);
                            objActivationContact.Contact_Role__c = (strTempRole.containsIgnoreCase(strMainContactRole) ? strTempRole : (strTempRole +', '+currentRole));
                        }else{
                            String strTempRole = objActivationContact.Contact_Role__c.trim().removeEnd(',').replace(', ,', ', ').replace(',,', ', ').removeStart(',');
                            system.debug('Current Role Details==>'+objActivationContact.Contact_Role__c);
                            objActivationContact.Contact_Role__c = strTempRole+', '+currentRole;
                        }
                    }
                }else{
                    if(currentRole == strMainContactRole){
                        objActivationContact.Company_Main_Contact__c = false;
                        String strTempRole = objActivationContact.Contact_Role__c.trim().replace(strMainContactRole, strAuthorizedRepRole).trim().removeEnd(',').replace(', ,', ', ').replace(',,', ', ').removeStart(',');
                        objActivationContact.Contact_Role__c = strTempRole;
                    }
                    else if(objActivationContact.Contact_Role__c.containsIgnoreCase(currentRole)){
                        String strTempRole = objActivationContact.Contact_Role__c.trim().remove(currentRole).trim().removeEnd(',').replace(', ,', ', ').replace(',,', ', ').removeStart(',');
                        objActivationContact.Contact_Role__c = strTempRole;
                    }
                }
                lstActivationContacts.add(objActivationContact);
            }
            update lstActivationContacts;
        }
        return reloadcontactlist();
    }
    
}