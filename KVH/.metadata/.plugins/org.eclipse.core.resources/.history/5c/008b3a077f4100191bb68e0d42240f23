Public Class MultipleBeamEntries{
    Public List<Case> multipleBeamEntries{get;set;}
    Public ID currentCaseID{get;set;}
    Public boolean refreshPage{get;set;}
    Public Case currentCaseUpdate{get;set;}
    Public boolean visibleBlock{get;set;}
    Public MultipleBeamEntries(Apexpages.StandardController caseObj){
        multipleBeamEntries = New List<Case>();
        currentCaseID = apexpages.currentpage().getparameters().get('id');
        currentCaseUpdate = [Select id,Beam_Not_Applicable__c,Multiple_Beam_Ids__c FROM Case WHERE id=:currentCaseID];
        refreshPage = false;
        
        if(currentCaseUpdate.Multiple_Beam_Ids__c==null){
            Case c = New Case();
            multipleBeamEntries.add(c);
        }else{
            List<String> allExistingBeamIds = currentCaseUpdate.Multiple_Beam_Ids__c.split('\n');
            List<ID> beamIds = New List<ID>(); 
            for(String populateExisting:allExistingBeamIds){
                Case c = New Case();
                c.Satellite_Beam_lookup__c = populateExisting.trim();
                multipleBeamEntries.add(c);
                beamIds.add(c.Satellite_Beam_lookup__c);
            }
            populateMultipleBeamUtilMethod(beamIds);
        }  
    }
    
    Public void addMultipleBeams(){
         Case c = New Case();
         multipleBeamEntries.add(c);
    }
    
    public void saveMultipleBeams(){
        List<id> beamIds = New list<id>();
        for(Case addParentBeam:multipleBeamEntries){
            beamIds.add(addParentBeam.Satellite_Beam_lookup__c);
        }
        List<Beam__c> allBeams = [Select id,KVH_Website_URL__c,Beam_Full_Name__c FROM Beam__c WHERE id=:beamIds];
        String multipleURLs = '';
        String multipleFullNames = '';
        String multipleBeamIds = '';
        for(Beam__c b:allBeams){
            if(b.KVH_Website_URL__c != null && b.KVH_Website_URL__c != ''){
                multipleURLs +=b.KVH_Website_URL__c+'\n';
                multipleFullNames +=  '<a href='+ b.KVH_Website_URL__c+'>'+b.Beam_Full_Name__c+ '</a>'+'<br/>';
                multipleBeamIds +=b.id+'\n';
            }
        }
        
        currentCaseUpdate.Multiple_Beam_Names__c = multipleFullNames;
        currentCaseUpdate.Multiple_Beam_URLs__c = multipleURLs;
        currentCaseUpdate.Multiple_Beam_Ids__c = multipleBeamIds;
        update currentCaseUpdate;
        refreshPage = true;
        visibleBlock = false;
    }
    public Integer rowNum{get;set;}
    public void delRow(){
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        multipleBeamEntries.remove(rowNum);  
    }    
    
    public void EditSection(){
        visibleBlock = true;
    }
    
    
    public void populateCurrentURL(){
       List<ID> allBeamIds = New List<ID>();
       for(integer i=0;i<multipleBeamEntries.size();i++){
           allBeamIds.add(multipleBeamEntries[i].Satellite_Beam_lookup__c);
       }
       populateMultipleBeamUtilMethod(allBeamIds);
     }
     
     
     Public void populateMultipleBeamUtilMethod(List<ID> allBeamIds){
           List<Beam__c> populateValues = [SELECT id,KVH_Website_URL__c,Beam_Full_Name__c FROM Beam__c WHERE id=:allBeamIds];
           Map<id,Beam__c> storeBeamValues = New Map<id,Beam__c>();
           for(Beam__c b:populateValues){
               storeBeamValues.put(b.id,b);
           }
           
           for(integer j=0;j<multipleBeamEntries.size();J++){
                if(storeBeamValues.containsKey(multipleBeamEntries[j].Satellite_Beam_lookup__c)){
                    system.debug(storeBeamValues.get(multipleBeamEntries[j].Satellite_Beam_lookup__c).KVH_Website_URL__c);
                    multipleBeamEntries[j].Satellite_Beam_lookup__r = New Beam__c();
                    multipleBeamEntries[j].Satellite_Beam_lookup__r.KVH_Website_URL__c = storeBeamValues.get(multipleBeamEntries[j].Satellite_Beam_lookup__c).KVH_Website_URL__c;
                    multipleBeamEntries[j].Satellite_Beam_lookup__r.Name = storeBeamValues.get(multipleBeamEntries[j].Satellite_Beam_lookup__c).Beam_Full_Name__c;  
                }
           }
     }
     
     
     
}