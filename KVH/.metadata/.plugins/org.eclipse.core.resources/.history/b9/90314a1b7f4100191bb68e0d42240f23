@isTest
Private Class TestscheduledInActivePrivateStaticIps{
    static testMethod void scheduledInActivePrivateStaticIps(){
        
        InActivePrivateStaticIps__c IA = New InActivePrivateStaticIps__c();
        IA.Region__c = 'Americas';
        IA.RegionCount__c = 49;
        insert IA;
        
        
        GlobalStaticIpRegionCount__c GIP = New GlobalStaticIpRegionCount__c();
        GIP.RegionCount__c = 50;
        GIP.Name = 'GlobalStaticIpRegionCount';
        insert GIP;
        
        Contact conObj = New Contact();
        conObj.LastName = 'KVH SF_Admin';
        insert conObj;
        
        
        SchedulableContext SC;
        scheduledInActivePrivateStaticIps SCPS = New scheduledInActivePrivateStaticIps();
        SCPS.execute(SC);
        
    }
}