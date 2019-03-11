@isTest
private class Kencast_Licenses_Needed_Warning_TEST {
    
    static testMethod void test_KenCastwarn(){
		// Tests have no data in Custom Settings or Objects.
		// Add the needed record to the Custom Setting "Thresholds".
        Thresholds__c One_KenCast_Lic_Reorder_Threshold_Rec = new Thresholds__c();
        One_KenCast_Lic_Reorder_Threshold_Rec.Name='KenCast License Reorder';
        One_KenCast_Lic_Reorder_Threshold_Rec.Threshold__c = 99;
        Database.insert(One_KenCast_Lic_Reorder_Threshold_Rec);
        
        Decimal KenCast_License_Reorder_Threshold = 0;
        
        // This Map, Set and Set iterator is the hard way to access a custom setting record.
        // Done this way here for "practice".
		Thresholds__c OneThresholdRec; 
        Map<String, Thresholds__c> All_Thresholds = Thresholds__c.getall();
        Set <String> Threshold_Keys = new Set<String> ();
        Threshold_Keys = All_Thresholds.keySet();
        
        System.assertEquals(Threshold_Keys.isEmpty(),False);

        // It appears you can't get at the values in a set without an iterator.
        for(String RecName: Threshold_Keys){
            system.debug('Name of Custom Setting record' + RecName);
            if (RecName == 'KenCast License Reorder'){        		
                OneThresholdRec = All_Thresholds.get(RecName); 
                KenCast_License_Reorder_Threshold = OneThresholdRec.Threshold__c;                
                system.debug('In Test Method. KenCast_License_Reorder_Threshold BEFORE: ' + KenCast_License_Reorder_Threshold);
                system.assertEquals(99, KenCast_License_Reorder_Threshold);
            }
        }
       
        // This is the class I'm testing
    	Kencast_Licenses_Needed_Warning KLNW = new Kencast_Licenses_Needed_Warning();
        KLNW.Schedule_Me();
        
        Id RECORD_TYPE_NAME_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
        //Id RECORD_TYPE_NAME_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('KVH_Service_Cloud').getRecordTypeId();
        
        List<Case> CaseIns = [Select Id, Description, RecordTypeId from Case where
            Priority='Critical' AND
            Origin = 'Web' AND
            Action_Plan__c = 'Tech Support Actions' AND
            Status='New'
            Order By CaseNumber Desc LIMIT 1];
            
         String Descrip = CaseIns[0].Description;
             
         System.assertEquals(Descrip.left(43), 'The number of available KenCast Licenses is' );               
         System.assertEquals(RECORD_TYPE_NAME_RECORD_TYPE_ID, CaseIns[0].RecordTypeId);

        // "KenCast License Reorder" is the value in the Name field of the Thresholds record, confusingly called "dataset_name" in the 
        // Apex help files for "List Custom Setting Instance Methods" getInstance() and getValue().
        Thresholds__c OneThresholdRec_Again = Thresholds__c.getInstance('KenCast License Reorder');  
        KenCast_License_Reorder_Threshold = OneThresholdRec_Again.Threshold__c; 
        system.debug('In Test Method. KenCast_License_Reorder_Threshold  AFTER: ' + KenCast_License_Reorder_Threshold);                
		// My class Kencast_Licenses_Needed_Warning halves the Custom Setting. Check that it happened.
        system.assertEquals(49, KenCast_License_Reorder_Threshold);
    }
}