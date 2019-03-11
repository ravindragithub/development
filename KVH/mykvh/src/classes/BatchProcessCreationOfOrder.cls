global with sharing class BatchProcessCreationOfOrder implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts{
	
	global string squery;
	global integer icount;
	global List<String> listOfString = new List<String>();
	global invoiceit_s__Job__c OrderObj;
	
	global BatchProcessCreationOfOrder(integer iCount,invoiceit_s__Job__c OrderObj){
		this.icount = icount;
		this.OrderObj = orderObj;
	}
	
	// this method would return the count of batch execution
	public Iterable<String> start(Database.BatchableContext BC)
    {   
    	string s;
    	for(integer i=1;i<=icount;i++){
    		s = 'order creation'+i;
    		listOfString.add(s);
    	}
        return listOfString;
    }
	
	global void execute(Database.BatchableContext BC, List<String> strings){
         SavePoint sp;
        try{
            sp = DataBase.setSavepoint();
		    string sResponce = ControllerCloneOrder.OrderCreation(orderObj,false);
        }catch(exception ex){
            Database.rollback(sp);
            Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.ERROR,'Please follow the exception messege ==>>' + ex.getTypeName()+':'+ex.getMessage() + ':LINE ' + ex.getLineNumber());
        }    
	}
	
	global void finish(Database.BatchableContext BC){
	
	}

}