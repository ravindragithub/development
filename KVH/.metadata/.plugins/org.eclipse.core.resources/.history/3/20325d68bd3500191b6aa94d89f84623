public class MultipleBeamEntriesController{
    @AuraEnabled
    public static List<MultipleBeamEntriesController.DisplayListBeamFlex> getBeamListMethod(string caseId,string beamregiontype) {
        List<MultipleBeamEntriesController.DisplayListBeamFlex> multipleBeamEntries = new List<MultipleBeamEntriesController.DisplayListBeamFlex>();
        List<ID> beamIds = New List<ID>(); 
        Case currentCaseUpdate = [Select id,Beam_Not_Applicable__c,Multiple_Beam_Ids__c FROM Case WHERE id=:caseId];
        if(currentCaseUpdate.Multiple_Beam_Ids__c !=null){
            List<String> allExistingBeamIds = currentCaseUpdate.Multiple_Beam_Ids__c.split('\n');
            for(String populateExisting:allExistingBeamIds){
                MultipleBeamEntriesController.DisplayListBeamFlex c = New MultipleBeamEntriesController.DisplayListBeamFlex();
                c.recordId = populateExisting.trim();
                multipleBeamEntries.add(c);
                beamIds.add(c.recordId);
            }
        } 
        if(beamIds.size() > 0){
            if(beamregiontype == 'beam'){
                Map<id,Beam__c> storeBeamValues = New Map<id,Beam__c>([SELECT id,Name,KVH_Website_URL__c,Beam_Full_Name__c FROM Beam__c WHERE id=:beamIds]);
                for(integer j=0;j<multipleBeamEntries.size();J++){
                    if(storeBeamValues.containsKey(multipleBeamEntries[j].recordId)){
                        multipleBeamEntries[j].recordId = storeBeamValues.get(multipleBeamEntries[j].recordId).Id;
                        multipleBeamEntries[j].recordURL = storeBeamValues.get(multipleBeamEntries[j].recordId).KVH_Website_URL__c;
                        multipleBeamEntries[j].recordName = storeBeamValues.get(multipleBeamEntries[j].recordId).Name;  
                        multipleBeamEntries[j].recordFullName = storeBeamValues.get(multipleBeamEntries[j].recordId).Beam_Full_Name__c;  
                    }
                    else
                    multipleBeamEntries = new List<MultipleBeamEntriesController.DisplayListBeamFlex>();
                }
            }
            else{
                Map<id,FLEX_HTS_Region__c> storeBeamValues = New Map<id,FLEX_HTS_Region__c>([SELECT id,Name,Region_URL__c From FLEX_HTS_Region__c WHERE id=:beamIds]);
                for(integer j=0;j<multipleBeamEntries.size();J++){
                    if(storeBeamValues.containsKey(multipleBeamEntries[j].recordId)){
                        multipleBeamEntries[j].recordId = storeBeamValues.get(multipleBeamEntries[j].recordId).Id;
                        multipleBeamEntries[j].recordURL = storeBeamValues.get(multipleBeamEntries[j].recordId).Region_URL__c ;
                        multipleBeamEntries[j].recordName = storeBeamValues.get(multipleBeamEntries[j].recordId).Name;  
                        multipleBeamEntries[j].recordFullName = storeBeamValues.get(multipleBeamEntries[j].recordId).Name;  
                    }
                    else
                    multipleBeamEntries = new List<MultipleBeamEntriesController.DisplayListBeamFlex>();
                }
            }
        }
        return multipleBeamEntries;
    }
    @AuraEnabled
    public static void saveMultipleBeams(string wrapperLst,string caseId,string beamregiontype){
        system.debug(wrapperLst+'============wrapperLst');
        set<Id> beamIds = new set<Id>();
        String multipleURLs = '';
        String multipleFullNames = '';
        String multipleBeamIds = '';
        if(!string.isBlank(wrapperLst) ){
        List<MultipleBeamEntriesController.DisplayListBeamFlex> multipleBeamEntries = 
            (List<MultipleBeamEntriesController.DisplayListBeamFlex>)
            System.JSON.deserialize(wrapperLst,List<MultipleBeamEntriesController.DisplayListBeamFlex>.class);
        
        for(MultipleBeamEntriesController.DisplayListBeamFlex b : multipleBeamEntries){
            if(b.recordURL != null && b.recordURL != ''){
                multipleURLs +=b.recordURL +'\n';
                multipleFullNames +=  '<a href='+ b.recordURL+'>'+b.recordName+ '</a>'+'<br/>';
                multipleBeamIds +=b.recordId+'\n';
            }
        }
        Case currentCaseUpdate = new Case();
        currentCaseUpdate.Id = caseId;
        if(multipleBeamEntries.size() >0)
        currentCaseUpdate.Beam_or_Flex_Region_Full_Name__c= multipleBeamEntries[0].recordFullName;
        else
        currentCaseUpdate.Beam_or_Flex_Region_Full_Name__c = '';
        currentCaseUpdate.Multiple_Beam_Names__c = multipleFullNames;
        currentCaseUpdate.Multiple_Beam_URLs__c = multipleURLs;
        currentCaseUpdate.Multiple_Beam_Ids__c = multipleBeamIds;
        update currentCaseUpdate;
        }
    }
    public class DisplayListBeamFlex {
        @AuraEnabled public string recordId;
        @AuraEnabled public string recordURL;
        @AuraEnabled public string recordName;
        @AuraEnabled public string recordFullName;
        public DisplayListBeamFlex(){
        }
    }
}