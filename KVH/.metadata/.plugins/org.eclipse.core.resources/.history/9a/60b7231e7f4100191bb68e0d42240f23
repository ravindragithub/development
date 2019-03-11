global class UpdateContactNotificationDML implements Database.Batchable<sObject>{
    Global Case caseDetails = New Case();
    Global String ntType;
    global UpdateContactNotificationDML(Case collectCase,String typeCollection){
         caseDetails = collectCase;
         ntType = typeCollection;
    }
   
    global Database.QueryLocator start(Database.BatchableContext BC){
         String conDetailsAll = 'SELECT id FROM Contact WHERE (Inactive_Contact__c!=true AND Email!=null AND HasOptedOutOfEmail!=true)';
         return Database.getQueryLocator(conDetailsAll);
    }
  
    global void execute(Database.BatchableContext BC, List<Contact> scope){
         if(scope.size()>0){
            for(Contact conDetails:scope){
                if(ntType == 'Standard'){
                    conDetails.Network_Outage_Type__c = 'Receive ALL network notifications';
                }
                
                if(ntType == 'Extended'){
                    conDetails.Network_Outage_Type__c = 'Receive network notifications ONLY for outages LONGER than 4 hrs';
                }
                conDetails.Beam_Full_Name__c                 = caseDetails.Satellite_Beam_lookup__r.Name;
                conDetails.Beam_URL__c                       = caseDetails.Satellite_Beam_lookup__r.KVH_Website_URL__c;
                if(caseDetails.Length_of_Service_Interruption__c!=null){
                    conDetails.Length_of_Service_Interruption__c = caseDetails.Length_of_Service_Interruption__c.trim();
                }
                conDetails.Outage_Start_Date__c              = caseDetails.Outage_Start__c;
                conDetails.Outage_Start_Time_GMT__c          = caseDetails.Outage_Start_Time_GMT__c;
                conDetails.Outage_End_Date__c                = caseDetails.Outage_End_Date__c;
                conDetails.Outage_End_Time_GMT__c            = caseDetails.Outage_End_Time_GMT__c;
                conDetails.Multiple_Beam_Names__c            = caseDetails.Multiple_Beam_Names__c;
                conDetails.Multiple_Beam_URLs__c             = caseDetails.Multiple_Beam_URLs__c;
                conDetails.Network_Outage_Case__c            = caseDetails.Id;
            }
          }
         //update scope;
         Database.Update(scope,false);
         //database.delete(scope,false);
    }
 
    global void finish(Database.BatchableContext BC){
        caseDetails.Multiple_Beams_Updated__c = system.now();
        Update caseDetails;
    }
}