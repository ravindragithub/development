public class Act_Service_Info_Component_Controller {
    private String ActivationOrderId;
    public Activation_Service__c objActivationService; // very important to pass vf component "attribute" value to controller 
    
    public void setobjActivationService(Activation_Service__c ActivationService){
        if(objActivationService == null){
            objActivationService = ActivationService;
            if(objActivationService.Inbound_Applications__c == null)
                 objActivationService.Inbound_Applications__c = 'None';
            ActivationOrderId = ApexPages.currentPage().getParameters().get('order');    //extract Order Id
        }
    } 
    
    public Activation_Service__c getobjActivationService(){
        return objActivationService; 
    }
    
    /** Constructor - Start **/
    public Act_Service_Info_Component_Controller(){
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   10/10/2016
* @description          :   clearActivationService Method.
*                           Upsert Activation Service
* @return               :   void
* @invoke               :   From action method of Vf page
**/
    public pagereference clearActivationService(){
        objActivationService.Global_Static_IP_Selected__c = false;
        objActivationService.Inbound_IPs_ranges__c = '';
        objActivationService.Other_Inbound_Applications__c = '';
        objActivationService.World_Region__c = '';
        objActivationService.Inbound_Applications__c = 'None';
        objActivationService.Activation_Contact__c = null;
        objActivationService.Additional_Comments__c = '';
        update objActivationService; 
        return null;
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   10/10/2016
* @description          :   updateActivationService Method.
*                           Upsert Activation Service
* @return               :   void
* @invoke               :   From action method of Vf page
**/
    public pagereference updateActivationServiceInformation(){
        objActivationService.Global_Static_IP_Selected__c = true;
        update objActivationService;
        return null;
    }

    public List<SelectOption> Regions{
        get {
            List<SelectOption> options = new List<SelectOption>();
            for(Schema.PicklistEntry objPickList : Activation_Service__c.World_Region__c.getDescribe().getPicklistValues()) {
                options.add(new SelectOption(objPickList.getValue(), objPickList.getLabel()));
            } 
            return options;
        }  
        set;
    }
    
    public List<SelectOption> InboundApplications{
        get {
            List<SelectOption> options = new List<SelectOption>();
            for(Schema.PicklistEntry objPickList : Activation_Service__c.Inbound_Applications__c.getDescribe().getPicklistValues()) {
                options.add(new SelectOption(objPickList.getValue(), objPickList.getLabel()));
            } 
            return options;
        }  
        set;
    }
    
    public String[] selectedInboundApplications { 
        get {
            String[] selected = new List<String>();
            List<SelectOption> lstSelectOption = this.InboundApplications;
            for(SelectOption objSelectOption : lstSelectOption) {
                if(this.objActivationService.Inbound_Applications__c !=null && this.objActivationService.Inbound_Applications__c.contains(objSelectOption.getValue()))
                    selected.add(objSelectOption.getValue());
            }
            return selected;
        }public set {
            String selectedCheckBox = '';
            for(String strkey : value) {
                selectedCheckBox += (selectedCheckBox == '' ? strkey : ';' + strkey);
            }
            this.objActivationService.Inbound_Applications__c = selectedCheckBox;
        }
    } 
    
    
    public List<SelectOption> allContactLists{
        get {
            list<SelectOption> options = new list<SelectOption>();
            options.add(new SelectOption('', '--Select--'));
            if(ActivationOrderId != null){
                String strQuery = 'SELECT Id, Name, Activation_Order__c, ';
                strQuery = 'SELECT Id, Name, Activation_Order__c, ';
                strQuery += 'First_Name__c,Salutation__c,Last_Name__c,Contact_Role__c ';
                strQuery += 'FROM Activation_Contact__c ';
                strQuery += 'WHERE Activation_Order__c =: ActivationOrderId  AND Contact_Role__c != null ' ; 
                for(Activation_Contact__c objActivationContact : Database.query(strQuery)){
                    String strName = (objActivationContact.Salutation__c !=null ? objActivationContact.Salutation__c : '') +' '+
                        (objActivationContact.First_Name__c !=null ? objActivationContact.First_Name__c : '') +' '+
                        (objActivationContact.Last_Name__c !=null ? objActivationContact.Last_Name__c : '');
                    options.add(new SelectOption(objActivationContact.Id,strName+' - '+objActivationContact.Contact_Role__c));
                }
            }
            return options;
        }  
        set;
    }
}