trigger versionControllingFromTVROProvider on TVRO_Provider__c (after insert,after update){
    
    list<ID> tvroProviderIds = new list<ID>();
    list<ID> satIds = new list<ID>();
    
    //IF trigger updated need to version controll for TVRO Master.
    
    
        for(integer i=0;i<trigger.new.size();i++){
            if(trigger.isupdate){
                if(trigger.new[i] != trigger.old[i]){
                    tvroProviderIds.add(trigger.new[i].id);
                }
            }
            
            if(trigger.isInsert){
                tvroProviderIds.add(trigger.new[i].id);
            }
      } 
    //Related services and getting satIds from TVRO
    list<TVRO_Satellites_with_Services__c> tvroSatServiceUpdate = [select id,Satellite_Record__c from TVRO_Satellites_with_Services__c where TRVO_Provider__c=:tvroProviderIds];
    for(TVRO_Satellites_with_Services__c minorVersionUpdate:tvroSatServiceUpdate){
        satIds.add(minorVersionUpdate.Satellite_Record__c);
    }
    
    //UptoSatInfo Object for versionControlling
    list<SatInfoMaster__c> satInfoUpdate = [select id,Minor_Version__c from SatInfoMaster__c where id=:satIds];
    for(SatInfoMaster__c updateVersion:satInfoUpdate){
        updateVersion.Minor_Version__c = true;
    }
    if(satInfoUpdate.size()>0)
    update satInfoUpdate;
}