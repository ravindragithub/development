public class Act_Billing_picklist_component_ctrl extends Act_Base_component_controller{
    
    public string strSelectedSubscriberOrContactId  {get; set;}
    private static String strActivationInvoiceSelectionTab = 'ActivationInvoiceSelection'; // should be same as current component id.
    private static String strInvoiceRecipientRole = 'Invoice Recipient'; // Contact InvoiceRecipient Role can be taken from custom labels later
    private static String strGroupRole = 'Group Invoice Recipient';                       // Contact Group Email Role can be taken from custom labels later
    private static String strActivationBillingSelectionTab = 'billingSelection'; // should be same as current component id.
    private static String strMainContactRole = 'Main Contact';                       //Main Contact Role can be taken from custom labels later
    private static String strAuthorizedRepRole = 'Authorized Representative';
    public boolean DisablePicklist{set;get;}
    public String parentContainer {get;set;} //Getting current component Id from VF Page
    //Constructor
    public Act_Billing_picklist_component_ctrl(){
        DisablePicklist = true;
        strSelectedSubscriberOrContactId = '';
        ActOrderId = ApexPages.currentPage().getParameters().get('order');
        system.debug('Invoking Act_Billing_controller Constructor....');
    }
    
    //getters and setters
    public list<SelectOption> getSameAsBillingList(){
        system.debug('Order Id after' + ActOrderId);
        
        list<SelectOption> lstSubscribersAndContacts = new list<SelectOption>();
        lstSubscribersAndContacts.add(new SelectOption('Choose One', '--Select--'));
        
        if(ActOrderId != null){
            String strQuery = 'SELECT Id, Name, Activation_Order__c, ';
            strQuery = 'SELECT Id, Name, Activation_Order__c, ';
            strQuery += 'First_Name__c,Salutation__c,Last_Name__c,Contact_Role__c ';
            strQuery += 'FROM Activation_Contact__c ';
            strQuery += 'WHERE Activation_Order__c =: ActOrderId AND Contact_Role__c !=: strGroupRole ' ;
            
            if(parentContainer == strActivationInvoiceSelectionTab){
                strQuery+= ' AND (NOT Contact_Role__c LIKE \'%'+strInvoiceRecipientRole+'%\')  ';
            } 
            if(parentContainer == 'ActivationContact'){
                strQuery+= ' AND (NOT Contact_Role__c LIKE \'%'+strMainContactRole+'%\') AND (NOT Contact_Role__c LIKE \'%'+strAuthorizedRepRole+'%\') ';
            } 
            system.debug('strQuery'+strQuery);
            for(Activation_Contact__c objActivationContact : Database.query(strQuery)){
                if(objActivationContact.Contact_Role__c == null)objActivationContact.Contact_Role__c ='';// 'No Role'
                
                String strName = (objActivationContact.Salutation__c !=null ? objActivationContact.Salutation__c : '') +' '+
                    (objActivationContact.First_Name__c !=null ? objActivationContact.First_Name__c : '') +' '+
                    (objActivationContact.Last_Name__c !=null ? objActivationContact.Last_Name__c : '');
                lstSubscribersAndContacts.add(new SelectOption(objActivationContact.Id,strName+(objActivationContact.Contact_Role__c ==''?'':' - ')+objActivationContact.Contact_Role__c));
                DisablePicklist = false;
            }
        }
        system.debug('lstSubscribersAndContacts' + lstSubscribersAndContacts);
        return lstSubscribersAndContacts;
    }
    
    public pageReference selectedSubscriberOrContactId(){
        system.debug('strSelectedSubscriberOrContactId before-' +strSelectedSubscriberOrContactId);
        PageReference reference = ApexPages.currentPage();      
        reference.getParameters().clear();     
        reference.getParameters().put('order', ActOrderId);     
        if(strSelectedSubscriberOrContactId != '' && strSelectedSubscriberOrContactId !='Choose One'){
            reference.getParameters().put('conActID', strSelectedSubscriberOrContactId); 
        }else{
            reference.getParameters().put('Record', 'New');
        }
        system.debug(reference.getURL());                      
        reference.setRedirect(true);                            
        return reference;
        //return null;
    }
}