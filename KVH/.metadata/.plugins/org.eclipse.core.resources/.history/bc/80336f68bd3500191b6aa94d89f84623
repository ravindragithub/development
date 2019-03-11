@isTest
Private Class MultipleBeamEntriesTest{
    static testMethod void MultipleBeamEntries(){
         
         Beam__c bm = New Beam__c();
         bm.Feed_Designator__c = 'CARI';
         bm.Frequency_KU_Downlink_MHz__c = 125;
         bm.Map_Name__c = 'TestName';
         bm.SAT_Long__c = 125;
         bm.KVH_Website_URL__c = 'http://www.kvh.com/Pages/MVB-Satellite-Beams/Americas-Region/CARIBBEAN.aspx';
         bm.SAT_Name__c = 'TestSatName';
         insert bm;
         
         Case caseRecord = New Case();
         caseRecord.Length_of_Service_Interruption__c = '12';
         caseRecord.Satellite_Beam_lookup__c = bm.id;
         insert caseRecord;
         
         Contact conObj = New Contact();
         conObj.LastName = 'lastName';
         conObj.Network_Outage_Case__c = caseRecord.id;
         conObj.Inactive_Contact__c = false;
         conObj.Email = 'test@test.com';
         conObj.HasOptedOutOfEmail = false;
         insert conObj;
         
         Test.setCurrentPageReference(new PageReference('Page.MultipleBeamEntries')); 
         System.currentPageReference().getParameters().put('id', caseRecord.id);
         System.currentPageReference().getParameters().put('index', '0');
         
         Apexpages.StandardController caseObj = New Apexpages.StandardController(caseRecord);
         MultipleBeamEntries mbe = New MultipleBeamEntries(caseObj);
         
         mbe.addMultipleBeams();
         mbe.populateCurrentURL();
         mbe.delRow();
         mbe.saveMultipleBeams();
         
         
    }
}