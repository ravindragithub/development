trigger TunerRecordCreation on SatInfoMaster__c (after update) {
    List<Tuner1_2__c> tuners = New List<Tuner1_2__c>();
    
    for(SatInfoMaster__c satInfo:Trigger.New){
        //Tuner1 Values//
    
        Tuner1_2__c tunes  = New Tuner1_2__c();
        
        tunes.PolarizationVH__c = satInfo.PolarizationVH__c;
        tunes.PolarizationHH__c = satInfo.PolarizationHH__c;
        tunes.PolarizationVL__c = satInfo.PolarizationVL__c;
        tunes.PolarizationHL__c = satInfo.PolarizationHL__c;
        
        tunes.bandVH__c = satInfo.bandVH__c;
        tunes.bandHH__c = satInfo.bandHH__c;
        tunes.bandVL__c = satInfo.bandVL__c;
        tunes.bandHL__c = satInfo.bandHL__c;
        
        tunes.FrequencyHH__c = satInfo.FrequencyHH__c;
        tunes.FrequencyHL__c = satInfo.FrequencyHL__c;
        tunes.FrequencyVL__c = satInfo.FrequencyVL__c;
        tunes.FrequencyVH__c = satInfo.FrequencyVH__c;
        
        tunes.symbolRateHH__c = satInfo.symbolRateHH__c;
        tunes.symbolRateVL__c = satInfo.symbolRateVL__c;
        tunes.symbolRateHL__c = satInfo.symbolRateHL__c;
        tunes.symbolRateVH__c = satInfo.symbolRateVH__c;
        
        
        tunes.FEC_Code_HH__c = satInfo.FEC_Code_HH__c;
        tunes.FEC_Code_VH__c = satInfo.FEC_Code_VH__c;
        tunes.FEC_Code_HL__c = satInfo.FEC_Code_HL__c;
        tunes.FEC_Code_VL__c = satInfo.FEC_Code_VL__c;
        
        
        tunes.NetworkidVH__c = satInfo.NetworkidVH__c;
        tunes.NetworkidHH__c = satInfo.NetworkidHH__c;
        tunes.NetworkidVL__c = satInfo.NetworkidVL__c;
        tunes.NetworkidHL__c = satInfo.NetworkidHL__c;
        
        tunes.decodetypeVH__c = satInfo.decodetypeVH__c;
        tunes.decodetypeHH__c = satInfo.decodetypeHH__c;
        tunes.decodetypeVL__c = satInfo.decodetypeVL__c;
        tunes.decodetypeHL__c = satInfo.decodetypeHL__c;
        
        tunes.Variable_Name_HH__c = satInfo.Variable_Name_HH__c;
        tunes.Variable_Name_VH__c = satInfo.Variable_Name_VH__c;
        tunes.Variable_Name_HL__c = satInfo.Variable_Name_HL__c;
        tunes.Variable_Name_VL__c = satInfo.Variable_Name_VL__c;
        
        tunes.RecordtypeID = ObjectUtil.getObjectRecordTypeId(Tuner1_2__c.SObjectType, 'Tuner 1');
        
        tunes.SatInfoMaster__c = satInfo.id;
        
        
        Tuner1_2__c tunes2  = New Tuner1_2__c();

        tunes2.PolarizationVH__c = satInfo.PolarizationVH__c;
        tunes2.PolarizationHH__c = satInfo.PolarizationHH__c;
        tunes2.PolarizationVL__c = satInfo.PolarizationVL__c;
        tunes2.PolarizationHL__c = satInfo.PolarizationHL__c;

        tunes2.bandVH__c = satInfo.bandVH__c;
        tunes2.bandHH__c = satInfo.bandHH__c;
        tunes2.bandVL__c = satInfo.bandVL__c;
        tunes2.bandHL__c = satInfo.bandHL__c;


        tunes2.FrequencyVHalt__c = satInfo.FrequencyVHalt__c;
        tunes2.FrequencyHHalt__c = satInfo.FrequencyHHalt__c;
        tunes2.FrequencyVLalt__c = satInfo.FrequencyVLalt__c;
        tunes2.FrequencyHLalt__c = satInfo.FrequencyHLalt__c;



        tunes2.symbolRateVHalt__c = satInfo.symbolRateVHalt__c;
        tunes2.symbolRateHHalt__c = satInfo.symbolRateHHalt__c;
        tunes2.symbolRateHLalt__c = satInfo.symbolRateHLalt__c;
        tunes2.symbolRateVLalt__c = satInfo.symbolRateVLalt__c;


        tunes2.FEC_Code_VHalt__c = satInfo.FEC_Code_VHalt__c;
        tunes2.FEC_Code_HHalt__c = satInfo.FEC_Code_HHalt__c;
        tunes2.FEC_Code_HLalt__c = satInfo.FEC_Code_HLalt__c;
        tunes2.FEC_Code_VLalt__c = satInfo.FEC_Code_VLalt__c;



        tunes2.decodetypeHHalt__c = satInfo.decodetypeHHalt__c;
        tunes2.decodetypeVHalt__c = satInfo.decodetypeVHalt__c;
        tunes2.decodetypeVLalt__c = satInfo.decodetypeVLalt__c;
        tunes2.decodetypeHLalt__c = satInfo.decodetypeHLalt__c;


        tunes2.Variable_Name_VHalt__c = satInfo.Variable_Name_VHalt__c;
        tunes2.Variable_Name_HHalt__c = satInfo.Variable_Name_HHalt__c;
        tunes2.Variable_Name_HLalt__c = satInfo.Variable_Name_HLalt__c;
        tunes2.Variable_Name_VLalt__c = satInfo.Variable_Name_VLalt__c;


        tunes2.NetworkidHHalt__c = satInfo.NetworkidHHalt__c;
        tunes2.NetworkidVHalt__c = satInfo.NetworkidVHalt__c;
        tunes2.NetworkidVLalt__c = satInfo.NetworkidVLalt__c;
        tunes2.NetworkidHLalt__c = satInfo.NetworkidHLalt__c;
        
        tunes2.RecordtypeID = ObjectUtil.getObjectRecordTypeId(Tuner1_2__c.SObjectType, 'Tuner 2');
        tunes2.SatInfoMaster__c = satInfo.id;
        
        tuners.add(tunes);
        tuners.add(tunes2);
        
    }
    
    insert tuners;
}