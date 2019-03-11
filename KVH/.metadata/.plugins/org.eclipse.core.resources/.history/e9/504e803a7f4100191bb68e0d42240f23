trigger versionControllingFromSatServices on TVRO_Satellites_with_Services__c (after insert,after update){
    
    list<id> satInfoID = new list<id>();
    for(integer i=0;i<trigger.new.size();i++){
        
        if(trigger.isupdate){
            if(trigger.new[i] != trigger.old[i] && trigger.new[i].Satellite_Record__c != null){
                    if(trigger.new[i].Satellite_Record__c != null){
                        satInfoID.add(trigger.new[i].Satellite_Record__c);
                }
            }
        }
        
        if(trigger.isinsert){
            if(trigger.new[i].Satellite_Record__c != null){
                satInfoID.add(trigger.new[i].Satellite_Record__c);
            }
        }
    }
    list<SatInfoMaster__c> satInfoUpdate = [select id,Minor_Version__c from SatInfoMaster__c where id=:satInfoID];
    for(SatInfoMaster__c updateVersion:satInfoUpdate){
        updateVersion.Minor_Version__c = true;
    }
    if(satInfoUpdate.size()>0)
    update satInfoUpdate;
}