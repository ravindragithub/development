global with sharing class AccountUtilities { 
	
	public set<Id> getPlatformAccountIds(){	/*DEPRECATED (unfortunately named)*/
		//Probably need to start by identifying the "Platform" Record Types
		//by design, the RecordType.DeveloperName *MUST* start with 'Platform'
		Set<Id> RTIds = new Set<Id>();
		for (RecordType RT : [SELECT id, DeveloperName FROM RecordType WHERE DeveloperName LIKE 'Platform%']){
			RTIds.Add(RT.Id);
		}
		System.debug(RTIds); //This set contains all the "Platform" Record Type Ids.
		return RTIds;
	}
	public List<RecordType> getPlatformRecordTypes(){
		List<RecordType> RT = new List<RecordType>();
		RT = [SELECT id, Name, DeveloperName FROM RecordType WHERE DeveloperName LIKE 'Platform%'];
		return RT; 
	}
	public set<Id> getPlatformRecTypeIds(){
		//Probably need to start by identifying the "Platform" Record Types
		//by design, the RecordType.DeveloperName *MUST* start with 'Platform'
		//Could probably use sOBject Describe results... but this is worthy of a Query!
		Set<Id> RTIds = new Set<Id>();
		for (RecordType RT : [SELECT id, DeveloperName FROM RecordType WHERE DeveloperName LIKE 'Platform%']){
			RTIds.Add(RT.Id);
		}
		System.debug(RTIds); //This set contains all the "Platform" Record Type Ids.
		return RTIds;
	}
}