public class Kencast_Licenses_Needed_Warning {

    Public void Schedule_Me()
    {
        Integer KenCastAvailableLicenseCnt = 0;
        
        KenCastAvailableLicenseCnt = [SELECT count() FROM KenCast_License__c WHERE Issued_to_Asset__c = ''];
        
        // This is a Custom Object that has a record named 
        Thresholds__c The_One_KenCast_Threshold_Record = Thresholds__c.getInstance('KenCast License Reorder');
        
        Decimal The_One_KenCast_License_Reorder_Threshold = The_One_KenCast_Threshold_Record.Threshold__c;
            
        if (KenCastAvailableLicenseCnt < The_One_KenCast_License_Reorder_Threshold){
            Case MyNewCase = new Case();

            //Id RECORD_TYPE_NAME_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('KVH_Service_Cloud').getRecordTypeId();            
            Id RECORD_TYPE_NAME_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();

            MyNewCase.Action_Plan__c = 'Tech Support Actions';            
            MyNewCase.Description = 'The number of available KenCast Licenses is ' + KenCastAvailableLicenseCnt + 
                ' which is less than the warning threshold of: ' + The_One_KenCast_License_Reorder_Threshold + 
                '.   Note, after new KenCast Licenses have been added, a human needs to manually set the value of the threshold to an appropriate number. ' + 
                ' Edit the Threshold field in the record with Name="KenCast License Reorder" in Custom Setting "Thresholds".';
            
            MyNewCase.Origin = 'Web';
            MyNewCase.Priority='Critical';            
            MyNewCase.RecordTypeId =RECORD_TYPE_NAME_RECORD_TYPE_ID;
            MyNewCase.Status='New';
            MyNewCase.Subject='KVH Needs to Buy KenCast Licenses';
            
            Database.INSERT(MyNewCase);
            
            // Cut the reorder threshold in half so we don't make a case every day.
            // Some human will have to Edit the Threshold back to a reasonable number after KenCast Licenses have been added.
            if (The_One_KenCast_License_Reorder_Threshold > 2) {
                The_One_KenCast_Threshold_Record.Threshold__c = math.floor(The_One_KenCast_License_Reorder_Threshold/2);
                Database.Update (The_One_KenCast_Threshold_Record, False);  
            }
        }   
    }
}