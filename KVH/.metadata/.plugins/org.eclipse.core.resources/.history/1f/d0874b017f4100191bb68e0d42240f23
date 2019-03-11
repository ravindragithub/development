public with sharing class IITClassAfterOnQuote {

    public void handleBeforeOnOrder(list<invoiceit_s__Quote__c> listofQuote) {
        
         list<ProcessInstance>  listofProcessInstance = [Select ID, Status, TargetObject.Name,TargetObjectId , 
               (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),
               (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance 
               Where TargetObjectID =: listofQuote AND Status = 'Approved'];
        system.debug('---->' +listofProcessInstance);
        set<Id> setOfOrderId  = new set<Id>();         
        for(ProcessInstance pi : listofProcessInstance ) {
            setOfOrderId.add(pi.TargetObjectId );
        }   
        
        for(invoiceit_s__Quote__c quote : listofQuote) {
            if(!setOfOrderId.contains(quote.Id)) {
                quote.Approved_Status__c = 'Pending';
            } else {
               quote.Approved_Status__c = 'Approved';
            }
        }   
    
    }
    
}