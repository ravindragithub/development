trigger TVROVersionUpdateFromTuner on Tuner1_2__c (before insert,before update) {
   if(Trigger.isInsert || trigger.isUpdate){
       for(integer i = 0;i<trigger.new.size();i++){
           if(Trigger.IsUpdate){
               if(trigger.new[i] != trigger.old[i]){
                   if(SatInfoXMLController.stopTrigger){
                       trigger.new[i].Minor_Version__c = true;
                   }
               }
           }
           if(Trigger.isInsert){    
               trigger.new[i].Minor_Version__c = true;
           }
       }
   }
}