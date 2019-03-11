public class InActivePrivateCase{
   public InActivePrivateCase(){
       List<InActivePrivateStaticIps__c> IAS = [SELECT id,Region__c,RegionCount__c FROM InActivePrivateStaticIps__c WHERE CreatedDate=today];
       List<Case> allCases = New List<Case>();
       
       if(IAS.size()>0){
         Map<String,GlobalStaticIpRegionCount__c> allCodes = GlobalStaticIpRegionCount__c.getAll();
         Group queId = [select id from Group where Name = 'Satcom AppEng Queue' and Type = 'Queue'];
         Contact conID = [SELECT id FROM Contact Where Name='KVH SF_Admin'];
         for(InActivePrivateStaticIps__c IpCase:IAS){
             if(IpCase.RegionCount__c<=allCodes.get('GlobalStaticIpRegionCount').RegionCount__c && IpCase.Region__c!=null){
                   Case staticIPminiVSAT = New Case();
                   staticIPminiVSAT.OwnerID = queId.id;
                   staticIPminiVSAT.ContactId = conID.id;
                   staticIPminiVSAT.Origin = 'Email';
                   staticIPminiVSAT.Case_Symptom__c = 'Static IP Request';
                   staticIPminiVSAT.Subject = 'Replenish Regiolnal Static IPs';
                   staticIPminiVSAT.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('mini-VSAT').getRecordTypeId();
                   staticIPminiVSAT.Description = ' The minimum number of Global Static IPs for the  '+IpCase.Region__c+' region has been reached.There are now only '+IpCase.RegionCount__c+' Global Static IPs available for this region. Please replenish the inventory of available Private and related Public IPs';
                   allCases.add(staticIPminiVSAT);
               }
           }
           if(allCases.size()>0)
           insert allCases;           
       }
   }
}