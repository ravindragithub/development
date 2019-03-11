global class AccountParentCaseAssetBackfillBatchable implements Database.Batchable<sObject>
{
	//Flag to indicate test mode
	global final Boolean isInTestMode; 

	//Ctor
	global AccountParentCaseAssetBackfillBatchable()
	{
		this(false);
	}
	
	global AccountParentCaseAssetBackfillBatchable(Boolean testMode)
	{
		isInTestMode = testMode;
	}
	
	//
	//	Query the Won, Renewable Opportunities that haven't been 
	//  assigned a Previous Opportunity
	//
	global Database.QueryLocator start(Database.BatchableContext BC) 
	{
		return Database.getQueryLocator(GetQueryLocatorString());
  	}
  	
  	private string GetQueryLocatorString()
  	{
  		string query = 'Select Id,ParentId,Parent.Name, Name from Account where	ParentID != null';
  		return (isInTestMode)? query + ' LIMIT 1' : query;
  	}
  	
	//
	//	Excute the batch
	//
  	global void execute(Database.BatchableContext BC, List<sObject> batch) 
	{	
		Uaccount.BackFillParentAccountInfo((List<Account>)batch);
  	}
	
	//
	//	Finish 
	//
  	global void finish(Database.BatchableContext BC) 
  	{
  	} 
}