/*

	Name: USObject
	Created By: Jason McCormack (GearsCRM)
	Created Date: 2012-04-12
	Description: 
    
	Modified By: 
	Modified Date: 
	Description: 

*/

public with sharing class USObject 
{
	public static SObject getCustomSettingByProfileName(String customSettingName, String profileName)
	{
		String profileId = [select Id from Profile where Name = :profileName limit 1].Id;
		
		return getCustomSettingByProfileId(customSettingName, profileId);
	}
	
	public static SObject getCustomSettingByProfileId(String customSettingName, String profileId)
	{
		return getCustomSetting(customSettingName, profileId);
	}
	
	public static SObject getCustomSetting(String customSettingName)
	{
		return getCustomSetting(customSettingName, null);
	}
	
	public static SObject getCustomSetting(String customSettingName, String ownerId)
	{
		if(ownerId == null || ownerId.trim().length() == 0)
		{
			ownerId = UserInfo.getOrganizationId();
		}
		
		Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(customSettingName);

		SObject customSetting = sObjectType.newSObject();

		if(customSetting.Id == null)
		{
			customSetting.put('SetupOwnerId', ownerId);
			customSetting.put('Name', 'Default');
		}	
		
		return customSetting;						
	}
		
    public static Set<String> getIdSetFromSOBjectList(List<SObject> records)
    {
        return getSetFromSOBjectList(records, 'Id');
    }
        
    public static Set<String> getSetFromSOBjectList(List<SObject> records, String fieldName)
    {
        Set<String> ids = new Set<String>();
        
        if(fieldName == null || fieldName.length() == 0)
        {
            
        }
        
        for(SObject record : records)
        {
            String id = (String) record.get(fieldName);
            
            ids.add(id);
        }
                                
        return ids;
    }
    
    public static Map<String, String> getMapFromSOBjectList(List<SObject> records, String keyFieldName, String valueFieldName)
    {
        Map<String, String> idsMap = new Map<String, String>();
        
        if(keyFieldName == null || keyFieldName.length() == 0)
        {
            //Need to handle
        }
        
        if(valueFieldName == null || valueFieldName.length() == 0)
        {
            //Need to handle
        }
        
        for(SObject record : records)
        {
            String key = (String) record.get(keyFieldName);
            String value = (String) record.get(valueFieldName);
            
            idsMap.put(key, value);
        }
        
        return idsMap;
    }    
        
    public static List<Schema.DescribeFieldResult> getMatchingEditableFields(SObject newRecord, SObject oldRecord)
    {
        List<Schema.DescribeFieldResult> matchingFields = getMatchingEditableFields(newRecord, oldRecord, null);
        
        return matchingFields;          
    }   
    
    public static List<Schema.DescribeFieldResult> getMatchingEditableFields(SObject newRecord, SObject oldRecord, Set<String> fieldExceptions)
    {
        if(fieldExceptions == null)
        {
            fieldExceptions = new Set<String>();    
        }
        
        List<Schema.DescribeFieldResult> matchingFields = new List<Schema.DescribeFieldResult>();
        
        Schema.DescribeSObjectResult newRecordDescribe = newRecord.getSObjectType().getDescribe();      
        Map<String, Schema.SObjectField> newRecordFields = newRecordDescribe.fields.getMap();
        
        Schema.DescribeSObjectResult oldRecordDescribe = oldRecord.getSObjectType().getDescribe();
        Map<String, Schema.SObjectField> oldRecordFields = oldRecordDescribe.fields.getMap();
        
        for(String key : newRecordFields.keySet())
        {           
            if(oldRecordFields.containsKey(key) == true)
            {
                Schema.DescribeFieldResult f1 = newRecordFields.get(key).getDescribe();
                
                if(f1.isCreateable() == true)
                {                   
                    if(fieldExceptions.contains(key.trim().toUpperCase()) == false)
                    {
                        matchingFields.add(f1);
                    }
                }
            }
        }
        
        return matchingFields;          
    }   
    
    private static testMethod void testGetIdSetFromSBojectList()
    {
        List<Account> accounts = UTestData.getAccounts(250);
        
        insert accounts;
        
        Set<String> accountIds = getIdSetFromSOBjectList(accounts);
        
        System.assert(accountIds.size() == accounts.size(), 'Results don\'t match Accounts count = ' + accounts.size() + ' | Account Ids count = ' + accountIds.size());
        
        List<Schema.DescribeFieldResult> fieldResults = getMatchingEditableFields(new Contact(), new Lead());
    }
}