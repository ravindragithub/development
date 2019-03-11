global class UpdateContactNotification {
    webservice static string ContactNotification(ID caseId,String ntType){
        List<AsyncApexJob> jobInfo = [SELECT Status,NumberOfErrors FROM AsyncApexJob WHERE JobType=:'Queueable' AND (Status=:'Queued' OR Status=:'Processing') AND ApexClassID=:system.label.UCNDML];
        if(jobInfo.size()==0){
            Case caseDetails = [SELECT id,Satellite_Beam_lookup__r.KVH_Website_URL__c,Beam_or_Flex_Region_Full_Name__c,Product_or_Service_Detail__c,Satellite_Beam_lookup__c,Beam_Not_Applicable__c,Outage_Start__c,
                                Outage_Start_Time_GMT__c,Outage_End_Date__c,Outage_End_Time_GMT__c,Additional_Info__c,
                                Length_of_Service_Interruption__c,Purpose_of_Outage__c,Multiple_Beam_Names__c,Beam_Full_Name__c,
                                Multiple_Beam_URLs__c,Satellite_Beam_lookup__r.Name FROM Case WHERE id=:caseId];
            
                //UCNDML udl = new UCNDML(caseDetails,ntType);
                
                ID queJobId = system.enqueueJob(new UCNDML(caseDetails,ntType));
                
                return 'Queue job Started,Please find queueJobID:'+queJobId;
        }else{
                return 'The record you are attempting to edit, or one of its related records, is currently being modified by another user. Please try again.';
        }
    }
}