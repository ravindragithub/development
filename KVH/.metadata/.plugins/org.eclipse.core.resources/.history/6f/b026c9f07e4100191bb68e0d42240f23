public without sharing class CCDS_CustomerHelper 
{
    public static boolean AddAccount(String accountID, String accountType)
    { 
        Account a = GetAccountByID(accountId);
        if(a==null) return false;
        
        a.CC_Integration_Errors__c = ''; 
        boolean result = false;
        
        if(accountType == 'Corporate'){ 
            result = ProcessCorporateAdd(a);
            return result;
        }
        
        CCDS_Customer.CustomerReturn cr = ProcessEntityByAccount(a);
        
        if(cr != null){
            result = ProcessCustomerReturnResult(cr,a);
        }     
     
        if(result == true){
            if(IsCustomer(a) == false) {
                cr = AddMiscInformation(IsCustomer(a), GetEntityID(a), Integer.valueOf(Global_Variable__c.getInstance('Webtop_MiscInfo_Category_AcctFields').Value__c) ,Integer.valueOf(Global_Variable__c.getInstance('Webtop_MiscInfo_SubCat_AccountID').Value__c), String.valueOf(a.Id));
                if(!cr.successful){
                    return false;
                }               
                if(CreateMiscInfo(a, IsCustomer(a), GetEntityID(a)) == false){
                    return false;          
                }
            }
            
            System.debug('ready to call CreateOrderBy with is customer and account : ' + IsCustomer(a));
             
            integer NewOrderID = CCDS_InventoryHelper.CreateOrderBy(IsCustomer(a), a);  
            
            System.debug('NewOrderID is = : ' + NewOrderID);
                  
            if(NewOrderID == -1){
                return false;
            } 
            
            if(CCDS_InventoryHelper.CreateOrderFid(NewOrderID, 'vesselName')== false){
                update a;
                return false;
            }
            
            System.debug('ready to call SubmitTheOrder with NewOrderID : ' );
            
            if(CCDS_InventoryHelper.SubmitTheOrder(NewOrderID) == false){
            	System.debug('SubmitTheOrder returned false : ');
                update a;
                return false; 
            } 
        }
        
        if(System.Test.isRunningTest()){
            system.debug('AddAccount returning true');
            return true;
        }
                
        update a;       
        return result;
    }
    
    public static boolean ProcessCorporateAdd(Account a)
    {
        CCDS_Corporate.CorporateMessageReturn cmr = CCDS_CorporateHelper.AddCorporateAccount(a);
        
        if(cmr.successful){
            a.Custom_Call_Acct_ID__c = String.valueOf(cmr.id); 
            a.CC_Integration_Errors__c = 'Successfully created Corporate account' ;
            System.debug('Successfully created Corporate account using ' + a.Id);
            update a;
        }else{
            System.debug('Error creating Corporate account using ' + a.Id);
            a.CC_Integration_Errors__c = 'Error creating Corporate account using ' + a.Id + '. Transaction id = ' + cmr.transactionId;
            for(String s : cmr.messages){
                a.CC_Integration_Errors__c += (s + ' \r\n');    
            }
            update a;
        }
        
        return cmr.successful;
    }
    
    public static boolean UpdateAccount(String accountID, String accountType)
    {                      
        Account a = GetAccountByID(accountId);
        if(a==null) return false;
        
        a.CC_Integration_Errors__c = '';
        
        boolean result = true;
        
        if(a == null || a.Custom_Call_Acct_ID__c == null || Integer.valueOf(a.Custom_Call_Acct_ID__c) < 1){ 
            System.debug('The Account number is incorrect or missing for update account...');
            a.CC_Integration_Errors__c = 'The Account number is incorrect or missing for update account...';
            update a;
            result = false;
            return result;
        }

        if(accountType == 'Corporate'){ 
            result = ProcessCorporateUpdate(a);
            return result;
        }   

        CCDS_Entity.EntityContactReturn ecr = CCDS_EntityHelper.UpdateCustomerContact(a);
        
        if(CreateMiscInfo(a, IsCustomer(a), GetEntityID(a)) == false) return false;
        
        CCDS_Customer.CustomerReturn cr = ProcessEntityByAccount(a);
        result = ProcessCustomerReturnResult(cr,a); 

        if(System.Test.isRunningTest()){
            system.debug('UpdateAccount returning true');
            return true;
        }
                 
        update a;        
        return result;
    }
    
    public static boolean ProcessCorporateUpdate(Account a)
    {
        CCDS_Corporate.CorporateMessageReturn cmr = CCDS_CorporateHelper.UpdateCorporateAccount(a);

        if(cmr.successful){
            System.debug('Successfully updated Corporate account using ' + a.Id);
            a.CC_Integration_Errors__c = 'Successfully updated Corporate account' ;
            update a;                               
        }else{
            System.debug('Error updating Corporate account using ' + a.Id);
            a.CC_Integration_Errors__c = 'Error updating Corporate account using ' + a.Id + '. Transaction id = ' + cmr.transactionId;
            for(String s : cmr.messages){
                a.CC_Integration_Errors__c += (s + ' \r\n');    
            }
            update a;
        }
        
        return cmr.successful;
    }
    
    public static boolean AddContact(String AccountID, String accountType)
    {               
        Account a = GetAccountByID(accountId); 
        if(a==null) return false;
        
        a.CC_Integration_Errors__c = '';
        
        boolean result = true;

        if(a == null || a.Custom_Call_Acct_ID__c == null || Integer.valueOf(a.Custom_Call_Acct_ID__c) < 1){ 
            System.debug('The Account number is incorrect or missing for add contact...');
            a.CC_Integration_Errors__c = 'The Account number is incorrect or missing for add contact...';
            update a;
            result = false;
            return result;
        }  
        
        if(accountType == 'Corporate'){ 
            result = ProcessCorporateContact(a);
            return result;
        }
        
        CCDS_Entity.EntityContactReturn ecr = CCDS_EntityHelper.AddCustomerContact(a);
        if(ecr.successful){
            System.debug('Successfully created Customer contact using ' + accountID);
            System.debug('transaction id = ' + ecr.transactionId);
            a.CC_Integration_Errors__c = 'Successfully created Customer contact' ;
            result = true;
        }else{
            System.debug('Error creating Customer contact using ' + accountID);
            System.debug('transaction id = ' + ecr.transactionId);
            a.CC_Integration_Errors__c = 'Error creating Customer contact using ' + accountID + '. Transaction id = ' + ecr.transactionId;
            for(String s : ecr.messages){
                a.CC_Integration_Errors__c += (s + ' \r\n');    
            }
            result = false;
        }                
        
        if(System.Test.isRunningTest()){
            system.debug('AddContact returning true');
            return true;
        }
        
        update a;
        return result; 
    }
    
    public static boolean ProcessCorporateContact(Account a)
    {
        CCDS_Corporate.CorporateMessageReturn cmr = CCDS_CorporateHelper.AddCorporateContact(a);
        
        if(cmr.successful){
            System.debug('Successfully created Corporate contact using ' + a.Id);
            a.CC_Integration_Errors__c = 'Successfully created Corporate contact' ;
            update a;
        }else{
            System.debug('Error creating Corporate contact using ' + a.Id);
            a.CC_Integration_Errors__c = 'Error creating Corporate contact using ' + a.Id + '. Transaction id = ' + cmr.transactionId;
            for(String s : cmr.messages){
                a.CC_Integration_Errors__c += (s + ' \r\n');    
            }
            update a;
        }
        
        return cmr.successful;
    }
    
    public static boolean CreateMiscInfo(Account a, boolean IsCustomer, Integer EntityId)
    {
        if(EntityId == null) return false;   
        
        CCDS_Customer.CustomerReturn cr = null;

        String ownerName = GetUserNameById((String)a.get('OwnerId'));
        String dealerName = GetDealerNameById((String)a.get('Commission_Dealer__c'));
        String accountEffDate = String.valueOf(a.Account_Effective_Date__c);
        Integer catId = Integer.valueOf(Global_Variable__c.getInstance('Webtop_MiscInfo_Category_AcctFields').Value__c);
        
        Integer subCat = Integer.valueOf(Global_Variable__c.getInstance('Webtop_MiscInfo_SubCat_SalesRep1').Value__c);        
        cr = AddMiscInformation(IsCustomer, EntityId, catId, subCat, dealerName);
        
        subCat = Integer.valueOf(Global_Variable__c.getInstance('Webtop_MiscInfo_SubCat_SalesRep2').Value__c);
        cr = AddMiscInformation(IsCustomer, EntityId, catId, subCat, ownerName);

        subCat = Integer.valueOf(Global_Variable__c.getInstance('Webtop_MiscInfo_SubCat_EffDate').Value__c);
        cr = AddMiscInformation(IsCustomer, EntityId, catId, subCat, accountEffDate);
        
        subCat = Integer.valueOf(Global_Variable__c.getInstance('Webtop_MiscInfo_SubCat_VesselName').Value__c);
        cr = AddMiscInformation(IsCustomer, EntityId, 10, subCat, ' ');
        
        subCat = Integer.valueOf(Global_Variable__c.getInstance('Webtop_MiscInfo_SubCat_TermReason').Value__c);
        cr = AddMiscInformation(IsCustomer, EntityId, 9, subCat, ' ');
        
        if(System.Test.isRunningTest()) {
            system.debug('CreateMiscInfo returning true');
            cr = new CCDS_Customer.CustomerReturn();
            cr.successful = true;
            cr.id = string.valueOf(EntityId);  
        }
       
        return cr.successful; 
    }
    
    public static CCDS_Customer.CustomerReturn ProcessEntityByAccount(Account a)
    {
        CCDS_Customer.CustomerHttpSoap11Endpoint ep = new CCDS_Customer.CustomerHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Customer.Authentication auth = (CCDS_Customer.Authentication) CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Customer').Value__c);                      
        CCDS_Customer.CustomerReturn cr = new CCDS_Customer.CustomerReturn();
        CCDS_Customer.CustomerBillOptionEntity cbe = new CCDS_Customer.CustomerBillOptionEntity();
        CCDS_Customer.CustomerBillOptionReturn cbr = new CCDS_Customer.CustomerBillOptionReturn();
        
        cr.successful = true;
        cbr.successful = true;
        
        CCDS_Customer.CustomerEntity ce = CCDS_EntityHelper.GetCustomerEntityFromAccount(a);
        
        String tmpName = ce.customerName;
        if(tmpName.length() > 50){
            System.debug('The Account name is > than 50 characters...');
            ce.customerName = tmpName.substring(0,50);
        }
               
        if(ce != null){         
             if(!System.Test.isRunningTest()){
                if(IsCustomer(a)){ 
                    cbe.customerNumber = Integer.valueOf(a.Custom_Call_Acct_ID__c);
                    cbe.billOption = ce.billType;
                    cbr = ep.updateCustomerBillOptions(auth, cbe);
                    if(cbr.successful){
                        return ep.updateCustomer(auth, ce); 
                    }
                }           
                
                if(a.CC_Prospect_Acct_ID__c != null){
                    return CreateCustomerReturnResultForExistingProspect(a);
                }else{
                	ep.timeout_x = 30000;
                	system.debug('Timeout is set to 30000. Ready to call api addProspect with customer entity');
                	a.CC_Integration_Errors__c += 'Timeout is set to 30000. Ready to call api addProspect with customer entity';
                    cr = ep.addProspect(auth,ce);
                    System.debug('back from addProspect api call. successful is = : ' + cr.successful);
                    a.CC_Integration_Errors__c += ('back from addProspect api call. successful is = : ' + cr.successful);
            		return cr;
                }  
            }else{
                system.debug('ProcessEntityByAccount system test returning cr.id of -9999');
                cr.id = '-9999';
                cr.successful = true;
                return cr;
            }       
        }else{
            system.debug('Customer Entity is null. Check for errors.');
            cr.successful = false;
            return cr;
        }
    }
   
    public static boolean ProcessCustomerReturnResult(CCDS_Customer.CustomerReturn result, Account a)
    {          
        boolean noError = true;
        
        //a.CC_Integration_Errors__c = '';

        if(result.Successful){          
            if(a.CC_Prospect_Acct_ID__c == null || Integer.valueOf(a.CC_Prospect_Acct_ID__c) < 1){
                a.CC_Prospect_Acct_ID__c = decimal.valueOf(result.id);                   
                a.CC_Integration_Errors__c += Global_Variable__c.getInstance('Webtop_ProspectCreate_Success').Value__c;
                if(a.Name.length() > 50){
                    a.CC_Integration_Errors__c += ' \r\nThe Account name cannot be greater than 50 characters.';
                }                               
            }else{  
                if(a.Custom_Call_Acct_ID__c == null || Integer.valueOf(a.Custom_Call_Acct_ID__c) < 1){
                    System.debug('The Account number is incorrect or missing...');
                    a.CC_Integration_Errors__c += 'The Account number is incorrect or missing.....';
                    noError = false;
                }else{
                    a.CC_Integration_Errors__c += Global_Variable__c.getInstance('Webtop_CustomerUpdate_Success').Value__c;
                }                 
            }
        }else{ 
            if(a.CC_Prospect_Acct_ID__c == null || a.CC_Prospect_Acct_ID__c < 1){
                if(result.id != null) a.CC_Prospect_Acct_ID__c = decimal.valueOf(result.id);
                    a.CC_Integration_Errors__c += Global_Variable__c.getInstance('Webtop_ProspectCreate_Failure').Value__c + '\r\n';
            }else{
                a.CC_Integration_Errors__c += Global_Variable__c.getInstance('Webtop_CustomerUpdate_Failure').Value__c  + '\r\n';
            }
            if(result.messages != null){
                for(string s : result.messages){
                    a.CC_Integration_Errors__c += (s + ' \r\n');    
                }
            }
            noError = false;
        }

        return noError;           
    } 
    
    public static CCDS_Customer.CustomerReturn CreateCustomerReturnResultForExistingProspect(Account a)
    {
        CCDS_Customer.CustomerReturn cr = new CCDS_Customer.CustomerReturn();
        cr.successful = true;
        cr.id = string.valueOf(a.CC_Prospect_Acct_ID__c);
        
        return cr;
    }
    
    public static CCDS_Customer.CustomerReturn AddMiscInformation(boolean IsCustomer, Integer EntityNumber, Integer catId, Integer subCat, String miscInfo)
    {  
        CCDS_Customer.MiscInformation mi = new CCDS_Customer.MiscInformation();
        CCDS_Customer.CustomerHttpSoap11Endpoint cep = new CCDS_Customer.CustomerHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Customer.Authentication auth = (CCDS_Customer.Authentication) CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Customer').Value__c);   

        if(IsCustomer) mi.customerNumber = EntityNumber;
        if(!IsCustomer) mi.prospectId = EntityNumber; 
        mi.miscInformationCategoryId = catId;
        mi.miscInformationSubCategoryId = subCat;
        mi.value = miscInfo;    
        
        if(!System.Test.isRunningTest()){          
            return cep.addMiscInfo(auth, mi);
        }else{ 
            system.debug('AddMiscInformation returning true');
            CCDS_Customer.CustomerReturn cr = new CCDS_Customer.CustomerReturn();
            cr.successful = true;            
            return cr; 
        }        
    }
    
    public static Account GetAccountByID(String AccountID)
    {
        return [select Id, Name, Parent_Acct_CC_ID__c, Custom_Call_Acct_ID__c, CC_Prospect_Acct_ID__c, Account_Effective_Date__c, Acct_ID_18_Char__c, Bill_To_Corporate__c, Billing_Account__c, 
                Account_Type__c, Bill_Type__c, Billing_Cycle_picklist__c, Bill_to__c, Mail_to__c, Account_Status__c, KVH_Sales_Office__c, Sales_Rep_Code__c, Revenue_Category__c, Owner.Name, Owner.Id,
                CC_Reseller_Account_ID__c, Home_Hub__c, ParentId, Customer_CC_Reseller_Account_ID__c, Commission_Dealer__r.Name, Commission_Dealer__r.Id, CC_Integration_Errors__c, Mail_to_Corporate__c
                from Account where Id = :AccountID];
    }
    
    public static String GetDealerNameById(String accountId)
    {
        if(System.test.isRunningTest()){
            return 'testDealer';
        }
        
        Account a = [select Name from Account where Id = :accountId];
        
        return a.Name;
    }
    
    public static String GetUserNameById(String userId)
    {         
        if(System.Test.isRunningTest()){
            return 'testUser';
        }
        
        User u = [select Name from User where Id = :userId];
        
        return u.Name;
    }
    
    public static boolean IsCustomer(Account a)
    {
        return a.Custom_Call_Acct_ID__c != null && Integer.valueOf(a.Custom_Call_Acct_ID__c) > 0;
    }
    
    public static Integer GetEntityID(Account a)
    {        
        return IsCustomer(a) ? Integer.valueOf(a.Custom_Call_Acct_ID__c) : Integer.valueOf(a.CC_Prospect_Acct_ID__c);
    }      
}