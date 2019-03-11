Public Class GenerateTVROHTML{
    Public List<SatInfoMaster__c> satInfo{get;set;}
  
    public integer dayDate{get;set;}
    public String dayMonth{get;set;}
    public integer dayYear{get;set;}

    Public GenerateTVROHTML(){
        satInfo = [SELECT id,TVRO_Header__r.LastModifiedDate,Name,Name__c,LastModifiedDate,Install_Name_M9__c,Install_Name_M7__c,Install_Name_M3__c,
                   Orbital_Position__c,
                   (SELECT id,Variable_Name_VH__c,FrequencyVH__c,symbolRateVH__c,FEC_Code_VH__c,NetworkidVH__c,
                   PolarizationVH__c,bandVH__c,decodetypeVH__c,Variable_Name_VL__c,FrequencyVL__c,symbolRateVL__c,
                   FEC_Code_VL__c,NetworkidVL__c,PolarizationVL__c,bandVL__c,decodetypeVL__c,Variable_Name_HH__c,
                   FrequencyHH__c,symbolRateHH__c,FEC_Code_HH__c,NetworkidHH__c,PolarizationHH__c,bandHH__c,decodetypeHH__c,
                   Variable_Name_HL__c,FrequencyHL__c,symbolRateHL__c,FEC_Code_HL__c,NetworkidHL__c,PolarizationHL__c,
                   bandHL__c,decodetypeHL__c FROM Tuner1_2__r WHERE RecordtypeID=:system.label.Tuner1RT) FROM SatInfoMaster__c WHERE TVRO_Header__c=:apexpages.currentpage().getparameters().get('recordId') AND (Install_Name_M9__c!=null AND (NOT Install_Name_M9__c Like '%USER%')) ORDER BY Hemisphere__c,Orbital_Position__c];  
        Date lastModifiedDate = Date.valueOf(satInfo[0].TVRO_Header__r.LastModifiedDate);
        system.debug(lastModifiedDate);
        dayDate = lastModifiedDate.day();
        dayYear = lastModifiedDate.year();
        dayMonth = satInfo[0].TVRO_Header__r.LastModifiedDate.format('MMMMM');
        
        
        
    }
    
}