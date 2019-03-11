global class AccountUtilities1{ 
    public List<RecordType> getPlatformRecordTypes(){
        List<RecordType> RT = new List<RecordType>();
        RT = [SELECT id, Name, DeveloperName FROM RecordType WHERE DeveloperName LIKE 'Platform%' AND (NOT DeveloperName Like  '%Platform_Media%')];
        return RT; 
    }
}