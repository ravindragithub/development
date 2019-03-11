/****************************************************
    Name        :     OpportunityTriggerHelper
    Description :    Trigger handler for Opportunity
***************************************************/
public class OpportunityTriggerHelper{
 public static void createApplicationEngineeringCase(Set<Id> oppIds){
        List<Case> newCaselist = new List<Case>();
        String queueId = [Select id from Group where type = 'Queue' and name = 'Application Engineering'][0].Id;
        String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Application Engineering').getRecordTypeId();
        for(Opportunity opp : [Select id,Account.name,of_Vessels__c,ownerId, name,Technical_Contact__c  from Opportunity where ID IN : oppIds]){
            newCaselist.add(createNewCase(queueId,recordTypeId,opp));
        }
        
        if(newCaselist.size()>0)
            insert newCaselist;
    }
    
    private static Case createNewCase(String ownerId,String recordTypeId,Opportunity opp){
        Case atCase = new Case();
        atCase.Related_Opportunity__c = opp.Id;
        atCase.Type = 'Professional Services Request';
        atCase.Status = 'New';
        atCase.Origin = 'Opportunity';
        atcase.Product_or_Service__c = 'AgilePlans Services Consult';
        atcase.Case_Symptom__c  = 'TBD';        
        atCase.Subject = 'AgilePlans Services Consult';
        atCase.Priority = '3. Medium';
        atCase.Description = 'Opportunity Account : ' + opp.Account.name + '\r\nNumber of Vessels on the Opportunity : ' + (opp.of_Vessels__c != null ? String.valueOf(opp.of_Vessels__c)  : '' ) + '.';        
        atCase.Contactid = opp.Technical_Contact__c ;
        atCase.Sales_Contact__c = opp.ownerId;
        atCase.recordTypeId = recordTypeId;
        atCase.OwnerId = ownerId;
        return atCase;
    }
}