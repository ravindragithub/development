public without sharing class Thresholds 
{
	public Thresholds() 
	{

	}

	public static Integer getHTSStaticIP_Lower_Limit()
	{
		Integer RetVal = 255;		//Fail safely with a HIGH default... we do NOT want to run out!
		// workbench proves this query is good.
		Threshold_of_record_count__mdt[] myMetaRecs = [SELECT DeveloperName,Low_Limit__c 
		                                               FROM Threshold_of_record_count__mdt 
																									 WHERE DeveloperName='HTS_Static_IPs'];
		if(myMetaRecs.Size() != 1){										//This is not good! and probably not possible!
			Exception ex = new NoDataFoundException();  //Create, but do not throw an exception as an input to the method
			ex.setMessage('Failed to find one and only one Custom Metadata Row WHERE DeveloperName=\'HTS_Static_IPs\' ');
			Case MyNewCase = serviceResults.createExceptionCase(ex);
			insert MyNewCase;
		} else {
			RetVal = Integer.valueOf(myMetaRecs[0].Low_Limit__c);	//only one record for sure!
		}
		return RetVal;
	}

	public static Integer getHTSStaticIPCount(String region, String dataChannel)
	{
		Integer RecordCntAvl = [SELECT count() FROM HTS_Static_IPs__c WHERE Date_Issued__c = null AND isReserved__c = false AND Channel_Id__c = :dataChannel AND Region__c = :region];
		// Channel_Id__c Text (12), '1703','1704','1705','1706','1707','1708'
		// Region__c picklist values 'CONUS', 'EMEA' and 'ASIA'
		if (RecordCntAvl != null)
			return RecordCntAvl;
		else
			return 0;
	}

	public string checkHTSStaticIpAvaiability()
	{
		//We need to check available Static IPs by (2) data channels * (3) regions
		//And open cases for levels below the Threshold
		List<Case> belowThresholdCases = new List<Case>();

		String Name_of_SObject_we_are_checking = 'HTS_Static_IPs';
		//All HTS Static IPs share a common Threshold Level stored in Custom Metadata
		Integer Lower_Limit_HTS_Static_IPs = Thresholds.getHTSStaticIP_Lower_Limit();

		// For DeveloperName=HTS_Static_IPs__c, this is the SOQL
		// Proven to work in workbench 

		String mySOQL_AvReCnt = 'SELECT count(Id) Cnt, Channel_Id__c, Region__c ' +
		'FROM HTS_Static_IPs__c ' +
		'WHERE Date_Issued__c = null AND isReserved__c = false ' +
		'GROUP BY Channel_Id__c, Region__c';

		// Channel_Id__c Text (12), '1703','1704','1705','1706','1707','1708'
		// Region__c picklist values 'CONUS', 'EMEA' and 'ASIA'

		// Now run the SOQL
		AggregateResult[] groupedResults = Database.query(mySOQL_AvReCnt);
		for (AggregateResult oneAGRes:groupedResults)
		{
			Integer RecordCntAvl = Integer.valueOf(oneAGRes.get('Cnt'));
			String Channel_Id = (String)oneAGRes.get('Channel_Id__c');
			String Region = (String)oneAGRes.get('Region__c');				

			if(RecordCntAvl < Lower_Limit_HTS_Static_IPs)
			{
				Exception ex = new NoDataFoundException();  //Create, but do not throw an exception as an input to the method
				String caseSubject = 'The number of available ' + Name_of_SObject_we_are_checking + ' Channel: ' + 
					Channel_Id + ' Region: ' + Region + ' is below the Threshold of: ' + Lower_Limit_HTS_Static_IPs.format();
				
				ex.setMessage(caseSubject);
				Case MyNewCase = serviceResults.createExceptionCase(ex);
				belowThresholdCases.add(MyNewCase);
				
				// NOT DOING YET Cut the reorder threshold in half so we don't make a case every day.
				// NOT DOING YET Some human will have to Edit the Threshold back to a reasonable number after records have been added.
			} 
		}
		
		if(belowThresholdCases != null)
		{	 
			if(belowThresholdCases.size() > 0 )  Database.INSERT(belowThresholdCases);
		}
		
		return 'Created ' + belowThresholdCases.size() + ' Cases';
	}		
}