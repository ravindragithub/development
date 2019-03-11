/******************************************************
    Name        :       AgilePlans_attachSalesOrderCtrl
    Description :       controller for AgilePlans_attachSalesOrder
                        to attach sales order to the case
*******************************************************/
public class AgilePlans_attachSalesOrderCtrl{
    public boolean showform{get;set;}
    public List<Case> caselist{get;set;}
    public Case caseObj{get;set;}
   
    ID oppId;
    public AgilePlans_attachSalesOrderCtrl(Apexpages.standardcontroller ctrl){
        oppId = ctrl.getId();
        init();
    }   
    
    public void init(){
        caseObj = new Case();
        
        caselist = [Select id,New_Vessel_or_Platform__c,status from Case where Related_Opportunity__c =: oppId 
                        AND (AgilePlans_Service_Order_Attached__c = true AND AgilePlans_Sales_Order_Entered__c  = false
                             AND RecordType.Name = 'Installation')];
        showform = caselist.size() > 0 ? true : false;
    } 
    
    public pagereference back(){
        return new pagereference('/'+oppId);
    }
    
    public pagereference submit(){
        System.debug('@@ '+caseObj.Id);
        if(!validaton()){
            caseObj.AgilePlans_Sales_Order_Entered__c = true;
           //caseObj.IsEscalated = true;
            update caseObj;
            
           
            
            //relate opportunity with sales order
            Sales_Order__c salesOrder = new Sales_Order__c(ID = caseObj.Sales_Order__c);
            salesOrder.Related_Opportunity__c = oppId;
            update salesOrder;
            createAirtimeCase(caseObj.Id);
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Sales Order successfully updated.'));
            init();
        }
        caseObj.Id = null;
        return null;
    }
    
    private boolean validaton(){
        boolean isError = false;
        if(caseObj.Id == null || String.valueOf(caseObj.Id).length() == 0){
            isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select vessel.'));
        }
        return isError;
    }
    
    private void createAirtimeCase(String caseId){
        Case tempCase = [Select id,New_Vessel_or_Platform__c,ContactId,Sales_Contact__c from case where id =:caseId];
        String queueId = [Select id from Group where type = 'Queue' and name = 'Airtime Services Queue'][0].Id;
        Case atCase = new Case();
        atCase.Related_Opportunity__c = oppId;
        atCase.Type = 'Change or Add an Airtime Service';
        atCase.Status = 'New';
        atCase.New_Vessel_or_Platform__c  = tempCase.New_Vessel_or_Platform__c;
        atCase.Subject = 'New AgilePlans Activation Request for ' + tempCase.New_Vessel_or_Platform__c;
        atCase.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airtime Service').getRecordTypeId();
        atCase.OwnerId = queueId;
        atCase.ContactId = tempCase.ContactId;
        atCase.Sales_Contact__c = tempCase.Sales_Contact__c;
        insert atCase;
        
        //move attachments
        List<Attachment> attlst = new List<Attachment>();
        for(Attachment a : [Select name,body from Attachment where ParentId =: caseId]){
            attlst.add(new Attachment(name = a.name,body = a.body,parentId = atCase.Id));
        }
        if(attlst.size()>0)
            insert attlst;
    }
}