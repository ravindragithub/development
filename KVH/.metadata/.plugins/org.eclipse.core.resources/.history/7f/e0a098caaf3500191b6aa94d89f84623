public without sharing class CCDS_InventoryHelper 
{
    public static Integer CreateOrderBy(boolean IsCustomer, Account a)
    {    
    	System.debug('Entered CreateOrderBy: ' + IsCustomer);   
    	
        if(IsCustomer) {
            System.debug('Creating new order by customer number: ' + a.Custom_Call_Acct_ID__c);
            return CreateOrderByCustomerNumber(Integer.valueOf(a.Custom_Call_Acct_ID__c), a);
        }else {
            System.debug('Creating new order by prospect id: ' + a.CC_Prospect_Acct_ID__c);
            return CreateOrderByProspectId(Integer.valueOf(a.CC_Prospect_Acct_ID__c), a);
        }
    }
    
    public static Integer CreateOrderByProspectId(Integer prospectId, Account a)
    {
    	System.debug('Entered CreateOrderByProspectId with prospectId and account : ' + prospectId);
        CCDS_Inventory.InventoryReturn result = CreateOrderByProspectId(prospectId);
        return ProcessInventoryReturnResult(result,a);
    }
    
    public static CCDS_Inventory.InventoryReturn CreateOrderByProspectId(Integer prospectId)
    {   
    	System.debug('Entered CreateOrderByProspectId with prospectId: ' + prospectId);	
        CCDS_Inventory.InventoryHttpSoap11Endpoint iep = new CCDS_Inventory.InventoryHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Inventory.Authentication ia = (CCDS_Inventory.Authentication)CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Inventory').Value__c);
    	
        if(!System.Test.isRunningTest()) {
        	System.debug('ready to call api startOrderWithProspectId : ' + prospectId);
        	return iep.startOrderWithProspectId(ia, prospectId);
        }else{
        	CCDS_Inventory.InventoryReturn result = new CCDS_Inventory.InventoryReturn();
            result.successful = true;
            result.Ids = new string[] {'1'};   
            return result;
        }   
    }
    
    public static Integer CreateOrderByCustomerNumber(Integer CustomerNumber, Account a)
    {
    	System.debug('Entered CreateOrderByCustomerNumber with customer number and account : ' + CustomerNumber);
        CCDS_Inventory.InventoryReturn result = CreateOrderByCustomerNumber(CustomerNumber);
        return ProcessInventoryReturnResult(result, a);
    }
    
    public static CCDS_Inventory.InventoryReturn CreateOrderByCustomerNumber(Integer CustomerNumber)
    {    
    	System.debug('Entered CreateOrderByCustomerNumber with customer number : ' + CustomerNumber);	        
        CCDS_Inventory.InventoryHttpSoap11Endpoint iep = new CCDS_Inventory.InventoryHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Inventory.Authentication ia = (CCDS_Inventory.Authentication)CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Inventory').Value__c);
    	
        if(!System.Test.isRunningTest()) {
        	System.debug('ready to call api startOrderWithCustomerNumber : ' + CustomerNumber);
        	return iep.startOrderWithCustomerNumber(ia, CustomerNumber);            
        }else{
        	CCDS_Inventory.InventoryReturn result = new CCDS_Inventory.InventoryReturn();
            result.successful = true;
            result.Ids = new string[] {'1'};   
            return result;
        }           
    }
    
    public static boolean SubmitTheOrder(Integer OrderId) 
    {
    	System.debug('Entered SubmitTheOrder with OrderId : ' + OrderId);
    	
        if(OrderId == null) return false;
        
        CCDS_Inventory.InventoryHttpSoap11Endpoint iep = new CCDS_Inventory.InventoryHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Inventory.Authentication ia = (CCDS_Inventory.Authentication)CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Inventory').Value__c);        
        CCDS_Inventory.InventoryReturn result = new CCDS_Inventory.InventoryReturn();

        if(!System.Test.isRunningTest()) {
        	System.debug('ready to call api submitOrder : ' + OrderId);
            result = iep.submitOrder(ia, OrderId); 
            System.debug('back from api call. result.successful is = : ' + result.successful);
            return result.successful;   
        }else{
        	return true;
        }       
    } 
    
    public static boolean CreateOrderFid(Integer prospectOrderID, String valueStr)
    {
    	System.debug('Entered CreateOrderFid with prospectOrderId : ' + prospectOrderId + ' and value : ' + valueStr);
        if(prospectOrderId == null) return false;
        
        CCDS_Inventory.InventoryHttpSoap11Endpoint iep = new CCDS_Inventory.InventoryHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Inventory.Authentication ia = (CCDS_Inventory.Authentication)CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Inventory').Value__c);     
        CCDS_Inventory.InventoryReturn result = new CCDS_Inventory.InventoryReturn();
        
        if(!System.Test.isRunningTest()){ 
        	System.debug('ready to call api addOrUpdateFid : ');
        	result = iep.addOrUpdateFid(ia, prospectOrderId, Integer.valueOf(Global_Variable__c.getInstance('Webtop_Order_FidId').Value__c), valueStr);
        	return result.successful;
        }else{        
        	return true;
        }
    }
    
    public static Integer ProcessInventoryReturnResult(CCDS_Inventory.InventoryReturn result, Account a)
    {
    	System.debug('Entered ProcessInventoryReturnResult with result.successful : ' + result.successful);
        if(result.successful) {               
            a.Account_Status__c = 'Active';  //Inactive, In Review        
            return Integer.valueOf(result.Ids[0]);
        }else {
            a.Account_Status__c = '';
            
            for(string s : result.messages) {
                a.Account_Status__c += (s + '\r\n');    
            }
            
            return -1;
        }
    }     
}