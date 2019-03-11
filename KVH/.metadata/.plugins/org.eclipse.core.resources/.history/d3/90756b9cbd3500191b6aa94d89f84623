trigger versionControllingFromGroup on Group__c (after insert,after update){  
      
    list<id> allSatinfoUpdate = new list<id>();
    for(integer i=0;i<trigger.new.size();i++){
        if(trigger.isupdate){
            if(trigger.new[i] != trigger.old[i]){
                if(trigger.new[i].A__c != null){
                    allSatinfoUpdate.add(trigger.new[i].A__c);
                }
                if(trigger.new[i].B__c != null){
                    allSatinfoUpdate.add(trigger.new[i].B__c);
                }
                if(trigger.new[i].C__c != null){
                    allSatinfoUpdate.add(trigger.new[i].C__c);
                }
                if(trigger.new[i].D__c != null){
                    allSatinfoUpdate.add(trigger.new[i].D__c);
                }
            }  
        }
        
            if(Trigger.isInsert){
                if(trigger.new[i].A__c != null){
                    allSatinfoUpdate.add(trigger.new[i].A__c);
                }
                if(trigger.new[i].B__c != null){
                    allSatinfoUpdate.add(trigger.new[i].B__c);
                }
                if(trigger.new[i].C__c != null){
                    allSatinfoUpdate.add(trigger.new[i].C__c);
                }
                if(trigger.new[i].D__c != null){
                    allSatinfoUpdate.add(trigger.new[i].D__c);
                }
            }  
        }
    
    list<SatInfoMaster__c> satInfoUpdate = [select id,Minor_Version__c from SatInfoMaster__c where id=:allSatinfoUpdate];
    for(SatInfoMaster__c updateVersion:satInfoUpdate){
        updateVersion.Minor_Version__c = true;
    }
    if(satInfoUpdate.size()>0)
    update satInfoUpdate;
}