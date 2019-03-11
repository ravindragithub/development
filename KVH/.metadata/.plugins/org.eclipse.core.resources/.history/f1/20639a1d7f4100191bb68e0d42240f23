public class UCNDML implements Queueable{
   Case caseDetails = New Case();
   String ntType;
   
   public UCNDML(Case collectCase,String typeCollection){
        caseDetails = collectCase;
        ntType = typeCollection;
   }
   public void execute(QueueableContext context){
   
       String ntt;
       String nttExn;
       String conDetailsAllStr;
       if(caseDetails.Product_or_Service_Detail__c == 'Mobile Data Carrier, KVH Mini-VSAT FLEX KU Band Service'){
           if(ntType == 'Standard'  ){
               ntt = 'Receive ALL network notifications';
               conDetailsAllStr = 'SELECT id FROM Contact WHERE (Inactive_Contact__c!=true AND Email!=null AND HasOptedOutOfEmail!=true AND HTS_Notifications__c =:ntt)';
           }
           if(ntType == 'Extended'){    
               nttExn = 'Receive ALL network notifications';
               ntt = 'Receive network notifications ONLY for outages LONGER than 4 hrs';
               conDetailsAllStr = 'SELECT id FROM Contact WHERE (Inactive_Contact__c!=true AND Email!=null AND HasOptedOutOfEmail!=true AND (HTS_Notifications__c =:ntt OR HTS_Notifications__c =:nttExn))';
           }
       }
       else{
           if(ntType == 'Standard'  ){
               ntt = 'Receive ALL network notifications';
               conDetailsAllStr = 'SELECT id FROM Contact WHERE (Inactive_Contact__c!=true AND Email!=null AND HasOptedOutOfEmail!=true AND Network_Outage_Type__c =:ntt)';
           }
           if(ntType == 'Extended'){    
               nttExn = 'Receive ALL network notifications';
               ntt = 'Receive network notifications ONLY for outages LONGER than 4 hrs';
               conDetailsAllStr = 'SELECT id FROM Contact WHERE (Inactive_Contact__c!=true AND Email!=null AND HasOptedOutOfEmail!=true AND (Network_Outage_Type__c =:ntt OR Network_Outage_Type__c=:nttExn))';
           }
       }
       system.debug('conDetailsAllStr========'+conDetailsAllStr);
       List<Contact> conDetailsAll = new List<Contact>();
       conDetailsAll = Database.Query(conDetailsAllStr);
        if(conDetailsAll.size()>0){
            for(Contact conDetails:conDetailsAll){
                //conDetails.Beam_Full_Name__c                 = caseDetails.Beam_Full_Name__c;
                conDetails.Beam_Full_Name__c                 = caseDetails.Beam_or_Flex_Region_Full_Name__c;
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
                conDetails.Network_Outage_Case__c            = caseDetails.id;
                conDetails.Notification_Additional_Info__c   = caseDetails.Additional_Info__c;
                
            }
            
            List<Database.SaveResult> results = database.update(conDetailsAll,false);
        
            Integer recordid = 0;
            Integer failurecount= 0;
            Integer successCount= 0;
            for (Database.SaveResult result : results) {
                recordid++;
                if (!result.isSuccess()){ for (Database.Error err : result.getErrors()){
                        System.debug('Exception in Contact Update:: '+ err.getStatusCode() + ' ' + err.getMessage());
                        System.debug('Contact Record Details:: '+ conDetailsAll[recordid]);
                        failurecount++;
                    } 
                }
                else{
                successCount++;}
            }
            Integer total = successCount+failurecount;
            System.debug('Error Log for Total Records::'+total );
            System.debug('Total Success ::'+successCount);
            System.debug('Total Success ::'+failurecount);
            
            try{
            caseDetails.Multiple_Beams_Updated__c = system.now();
            Update caseDetails;}catch(Exception ae){
                system.debug('Exception in Case Update ::'+ae);
            }
        }
    }
}