//NEEDS UPDATE ON CASE TO UPDATE WHAT PART OF THE TRANSFORM FAILED
//

public with sharing class  Service_LTE_activation_transform {
    public static serviceResults log {get; private set;}
    public static serviceResults warningLog {get; private set;}
    public static Case warningCase {get; private set;}

    private static final Id DIRECTCUSTOMER_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    private static final Id PLATFORM_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Leisure Vessel').getRecordTypeId();
    private static final Id CC_RECORD_TYPE_ID = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
    private static final Id CONTRACT_RECORD_TYPE_ID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Airtime Activation Service Contract').getRecordTypeId();
    private static final Id AIRTIME_CASE_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airtime Service').getRecordTypeId();
    private static boolean existingUser = false;

    public static Map<String, String> recordMap = new Map<String, String>();
    public static List<case> airtimeCase = new List<case>();
    
    public Service_LTE_activation_transform() {
        
    }
    
    static {
        log = new serviceResults();
        log.success = true;       //optimistic initialization....
        log.message = DateTime.now() + '\t' + 'SERVICE_INITIALIZATION\t' + 'Initializing LTE Activation Transform Service';
        warningLog = new serviceResults();
        log.success = true;       
    }
    public static serviceResults getLog(){
        return log;
    }
    public static serviceResults getWarningLog(){
        return warningLog;
    }
    public static Case getWarningCase(){
        return warningCase;
    }
    public static map<String, String> getrecordMap(){
        return recordMap;
    }
    /*****************************************************************************
     *Main Method 
     ****************************************************************************/
    public static serviceResults transformLTEActivationForm(LTE_activation__c rawForm){
        system.debug('transformLTEActivationForm');
        system.debug('rawForm');
        system.debug(rawForm.Id);
        
        //airtimeCase = [SELECT Id,Description,LTE_Activation__c, Contract__c FROM case WHERE LTE_Activation__c =: rawForm.Id  LIMIT 1];
        //system.debug('LTE_Activation__c.Id');
        //system.debug(airtimeCase.get(0).LTE_Activation__r.Id);
        //system.debug('LTE_Activation__c');
        //system.debug(airtimeCase.get(0).LTE_Activation__c);
        //system.debug('rawForm.Id');
        //system.debug(rawForm.Id);
        
        log.appendLog('METHOD_ENTRY', 'transformLTEActivationForm(LTE_activation__c rawForm)|Begin LTE provisioning process..');
        warningLog.appendLog('Error Reporting', 'Reporting errors...');
        preProcessValidation(rawForm);    
        if(log.success == false){ return returnFatalError(rawForm); }
        
        LTE_activation__c cleanForm = getCleanForm(rawForm);
        if(log.success == false){ return returnFatalError(cleanForm); }
        
        Account subscriberAcct = createSubscriberAcct(cleanForm); //insert Account
        if(log.success == false){ return returnFatalError(cleanForm); }
        recordMap.put('SubscriberAcct',subscriberAcct.Id );
        
        Account platformAcct = createPlatformAcct(cleanForm, subscriberAcct); //insert Account
        if(log.success == false){ return returnFatalError(cleanForm); }
        recordMap.put('PlatformAcct',platformAcct.Id );
        
        Asset domeAsset = moveAssets( cleanForm,  platformAcct); //move the assets
        if(log.success == false){ return returnFatalError(cleanForm); }
        recordMap.put('Asset',domeAsset.Id );        
        
        Contact subscriberContact = moveSubscriberContact( cleanForm,  subscriberAcct); //move the sub contact
        if(log.success == false){ return returnFatalError(cleanForm); }
        recordMap.put('SubscriberContact',domeAsset.Id );  
        
        User communityUser = addMyKVHRoleToUser(subscriberContact);
        if(log.success == false){ return returnFatalError(cleanForm); }
        recordMap.put('User',communityUser.Id );  
        
        Billing_Account__c billingAcct = createBillingAccount( cleanForm, subscriberAcct); 
        if(log.success == false){ return returnFatalError(cleanForm); } 
        recordMap.put('BillingAcct',billingAcct.Id );   
        
        Contract subscriberContract = createContract(cleanForm,subscriberAcct,  platformAcct, billingAcct);
        if(log.success == false){ return returnFatalError(cleanForm); }  
        recordMap.put('Contract',subscriberContract.Id ); 
        
        SBQQ__Subscription__c theSubscription =  createSubscription(domeAsset,subscriberContract, cleanForm);
        if(log.success == false){ return returnFatalError(cleanForm); } 
        recordMap.put('Subscription',theSubscription.Id );
        
        //Case theCase = updateCase(subscriberAcct, platformAcct,  billingAcct, domeAsset,subscriberContact, subscriberContract);
        //if(log.success == false){ return returnFatalError(); }  
        //recordMap.put('Case',theCase.Id );
        
        Id provisioningJob = invokeProvisioining(theSubscription);
        if(log.success == false){ return returnFatalError(cleanForm); }
        
        //map<String, String> recordMap = getrecordMap();
        //if(log.success == false){ return returnFatalError(); }
        
        log.appendLog('METHOD_EXIT', 'transformLTEActivationForm(LTE_activation__c cleanForm)|LTE provisioning process finished for: ' + cleanForm.Id ); // need to include LTE Activaiton number
        warningLog.appendLog('Error reporting', 'All errors have been reported ' );
        if (log.success){
            if(log.srCase != null){
                log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
                insert log.srCase;
                log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
            }
            log.appendLog('SERVICE_FINISHED', 'SUCCESS: LTE Activation Transform Service completed successfully!');
        } else {
            return returnFatalError(cleanForm);
        }
        //TODO: no callouts in this service, remove!
        //system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
        return log;
        return warningLog;  //This line will never get executed...
    }
    /*****************************************************************************
     *Private methods
     ****************************************************************************/
    @testVisible private static serviceResults returnFatalError(LTE_Activation__c cleanForm){
        if(log.srCase == null){
            Exception ex = new NoDataFoundException();  //Create, but do not throw an exception as an input to the method
            ex.setMessage('Fatal Error in Service_LTE_activation_transform Class');
            log.createCase(ex);
        }
        log.srCase.Description = log.srCase.Description + '\n' + log.message;   //append log.message to stack trace from Exception
        insert log.srCase;
        log.appendLog('CASE_CREATED', 'Record ID: ' + log.srCase.Id);
        log.appendLog('SERVICE_FINISHED', 'ERROR: LTE Activation Transform Service failed to complete successfully. See log for details.');
        system.debug(CalloutLogs.commitLogs());                     //do this LAST just before returning from method
        if (cleanForm.Id == null){
            cleanForm.Transform_Service__c = 'Did not start';
        }
        else{
            cleanForm.Transform_Service__c = 'Completed Partially';
        }
        update cleanForm;
        return log;
    }

    @testVisible  private static void preProcessValidation(LTE_Activation__c actForm){
        String methodName = 'preProcessValidation(LTE_Activation__c actForm)';
        log.appendLog('METHOD_ENTRY', methodName + '|Beginning Pre-Process Validation of LTE_Activation__c');
        integer myDMLLimit = Limits.getDMLStatements();
        log.appendLog('METHOD_ENTRY', '|Beginning Pre-Process Validation of LTE_Activation__c list' + actForm.Id);
        if(actForm.Id == null){
            log.appendLog('METHOD_EXIT', methodName + '|Input LTE_Activation__c missing record Ids!');
            log.appendLog('FATAL_ERROR', 'Pre-process validation failed. Input LTE_Activation__c does not include record Ids');
            
            log.success = false;
            return;
        }
        
        log.appendLog('METHOD_EXIT', methodName + '|Pre-Process Validation of LTE_Activation__c Complete ' );
        return;
    }    
    @testVisible private static LTE_Activation__c getCleanForm(LTE_Activation__c rawForm){
        String methodName = 'getCleanForm(LTE_Activation__c rawForm)';
        LTE_Activation__c cleanForm = new LTE_Activation__c();
        log.appendLog('METHOD_ENTRY', methodName + '|Getting clean list of Form from Salesforce');
        try{
            cleanForm = [ SELECT Id, Billing_Address__c, Subscriber_Address__c,Agreed_to_Receive_Texts__c,Antenna_Serial_No__c, Billing_City__c,  
                         Subscriber_City__c,Billing_Company_Name__c, Contact_1_Company_Name__c,Contact_2_Company_Name__c,
                         Onboard_Company_Name__c, Subscriber_Company_Name__c, Contact1_is_Authorized_Rep__c, Contact1_is_Billing_Point__c,
                         Contact1_is_Invoice_Recipient__c, Contact2_is_Authorized_Rep__c, Contact2_is_Billing_Point__c,Contact2_is_Invoice_Recipient__c, 
                         Onboard_Contact_Name__c, Billing_Country__c, Contact_1_Country__c, Contact_2_Country__c,  Subscriber_Country__c ,
                         Customer_Code__c, Billing_Email__c, 
                         Contact_1_Email__c, Contact_2_Email__c, Subscriber_Email__c, Flag__c,  
                         IMO_Registration_No__c, Installer_Contact_Name__c,  Installer_Country__c, Installer_Information__c, Installer_Manufacture__c  ,  
                         Installer_State_Province_Territory__c,Market__c, Sector__c, Contact_1_Job_Title__c, Contact_2_Job_Title__c, Main_Contact_First_Name_Cont1__c, 
                         Main_Contact_First_Name_Cont2__c,  Main_Contact_FirstName_Subscriber__c,  Main_Contact_FirstName_Billing__c,  
                         Main_Contact_LastName_Billing__c, Main_Contact_LastName_Subscriber__c,  Main_Contact_Last_Name_Cont1__c,  Main_Contact_Last_Name_Cont2__c, 
                         MMSI__c,  Primary_Name_on_Card__c, Secondary_Name_on_Card__c,  Onboard_Country__c,  Onboard_Email__c,  Onboard_Job_Title__c, 
                         Onboard_Phone__c , Onboard_Role__c, Onboard_State_Province_Territory__c, Contact_1_Phone__c, Contact_2_Phone__c, Subscriber_Phone__c,
                         Billing_Phone_No__c, Billing_Postal_Zip_Code__c, Subscriber_Postal_Zip_Code__c, Pre_activation_Date__c, Primary_CC_Exp_Date__c, 
                         Primary_Credit_Card_No__c,Privacy_Policy_is_Accepted__c, Privacy_Policy_is_Accepted2__c, Privacy_Policy_is_Accepted3__c, 
                         Promotional_Code__c,Purchased_From__c, Sim_Serial_No__c,
                         Requested_Service_Start_Date__c, Contact_1_Role__c, Contact_2_Role__c, Secondary_CC_Exp_Date__c, 
                         Secondary_Credit_Card_No__c, Billing_State_Province_Territory__c, Contact_1_State_Province__c, 
                         Contact_2_State_Province_Territory__c, 
                         Subscriber_State_Province_Territory__c, Subscriber_is_Billing_Point_of_Contact__c, 
                         Subscriber_is_Invoice_recipient__c, Vessel_Length__c, Vessel_Name__c, Vessel_Type__c, Name, CurrencyIsoCode, Account__c,  Platform_Account__c
                         , Billing_Account__c  ,   Contact__c,    Contract__c , Corporate_Billing_Account__c   , Rate_Plan__c
                         FROM LTE_Activation__c
                         WHERE Id =: rawForm.Id 
                         LIMIT 1
                        ];
            log.appendLog('METHOD_EXIT', methodName + '|Successfully obtained clean list of form from Salesforce');
        } catch(Exception e){
            log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
            log.appendLog('FATAL_ERROR', 'Could not obtain clean list of form from Salesforce. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
            warningLog.appendLog('Error', 'Could not find the activation form');
            log.success = false;
            log.createCase(e);  //create case
            return cleanForm;
        }
        system.debug(cleanForm);
        return cleanForm;  
    }
    @testVisible private static Account createSubscriberAcct(LTE_Activation__c cleanForm){
        String methodName = 'createSubscriberAcct(LTE_Activation__c inputForm)';
        log.appendLog('METHOD_ENTRY', methodName + '|Preparing to Create Subscriber Account');
        
        //Check for existing account
        if(cleanForm.Account__c != null){
            Account returnAccount = new Account();
            returnAccount.Id = cleanForm.Account__c;
            existingUser = true;
            log.appendLog('METHOD_EXIT', methodName + '|Subscriber Account with Id: ' + returnAccount.Id + ' Successfully Found');
            
            return returnAccount;
        }

        Platform_Market_Sector__c marketSector = new Platform_Market_Sector__c();
        Account returnAccount = new Account();
        try{
            marketSector = [SELECT Account_Market__c, Account_Record_Type__c, Account_Sector__c, Market__c, Name, Sector__c FROM Platform_Market_Sector__c WHERE Market__c =: 
                            cleanForm.Market__c AND Sector__c =: cleanForm.Sector__c AND Name =: cleanForm.Vessel_Type__c LIMIT 1 ];
            
            returnAccount.RecordTypeId = DIRECTCUSTOMER_RECORD_TYPE_ID;
            
            if(cleanForm.Subscriber_Company_Name__c == null){
                returnAccount.Name = cleanForm.Main_Contact_FirstName_Subscriber__c + ' ' + cleanForm.Main_Contact_LastName_Subscriber__c + ' ' + cleanForm.Name;
            }
            else{
                returnAccount.Name = cleanForm.Subscriber_Company_Name__c;
            }
            returnAccount.KVH_Sales_Office__c = 'KU Satcom';
            returnAccount.Account_Status__c = 'Active';
            returnAccount.Market__c = marketSector.Account_Market__c;
            returnAccount.Market_Sector__c = marketSector.Account_Sector__c;
            returnAccount.BillingCountry = cleanForm.Subscriber_Country__c;
            returnAccount.BillingStreet = cleanForm.Subscriber_Address__c ;
            returnAccount.BillingCity = cleanForm.Subscriber_City__c;
            returnAccount.BillingState = cleanForm.Subscriber_State_Province_Territory__c;
            returnAccount.BillingPostalCode = cleanForm.Subscriber_Postal_Zip_Code__c;
            
            insert returnAccount; //fil in rest
            cleanForm.Account__c = returnAccount.Id;
            update cleanForm;
        }
        catch(Exception e){
            log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
            log.appendLog('FATAL_ERROR', 'LTE createSubscriber method failed. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
            warningLog.appendLog('Error', 'Could not create the subscriber account');
            log.success = false;
            log.createCase(e);  //create case
            
            system.debug(log);
        }
        log.appendLog('METHOD_EXIT', methodName + '|Subscriber Account with Id: ' + returnAccount.Id + ' Successfully Created');
        
        return returnAccount;
    } 
    
    @testVisible private static Account createPlatformAcct(LTE_Activation__c cleanForm, Account subscriberAcct){
        String methodName = 'createPlatformAcct(LTE_Activation__c cleanForm, Account subscriberAcct)';
        log.appendLog('METHOD_ENTRY', methodName + '|Preparing to Create Platform Account');
        
        Account returnPlatformAccount = new Account();
        //Check for existing platform account
        if(cleanForm.Platform_Account__c != null){
            
            returnPlatformAccount.Id = cleanForm.Platform_Account__c;
            
            log.appendLog('METHOD_EXIT', methodName + '|Platform Account with Id: ' + returnPlatformAccount.Id + ' Successfully Found');
            
            return returnPlatformAccount;
        }

        Platform_Market_Sector__c marketSector = new Platform_Market_Sector__c();
        case statusCase = new case();
        
        try{
            marketSector = [SELECT Account_Market__c, Account_Vessel_type__c, Account_Record_Type__c, Account_Sector__c, Market__c, Name, Sector__c FROM Platform_Market_Sector__c WHERE Market__c =: 
                            cleanForm.Market__c AND Sector__c =: cleanForm.Sector__c AND Name =: cleanForm.Vessel_Type__c LIMIT 1 ];
            system.debug('before query');
            //statusCase = [SELECT Id, LTE_Activation__c.Id FROM case where LTE_Activation__c.Id =: cleanForm.Id];
            system.debug('case value');
            //system.debug(LTE_Activation__c);
            //system.debug(statusCase.Id);
            
            returnPlatformAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(marketSector.Account_Record_Type__c).getRecordTypeId();
            returnPlatformAccount.ParentId = subscriberAcct.Id;
            returnPlatformAccount.Name = cleanForm.Vessel_Name__c;
            
            if(cleanForm.Vessel_Type__c == 'Power Boat/Yacht <80 ft (24m)' ){
                returnPlatformAccount.Industry_Designation__c = marketSector.Account_Vessel_type__c;
                returnPlatformAccount.Platform_Detail__c = 'Cruiser';
                
            }
            else{
                returnPlatformAccount.Industry_Designation__c = marketSector.Account_Vessel_type__c;
            }
            returnPlatformAccount.Market__c = marketSector.Account_Market__c;
            returnPlatformAccount.Market_Sector__c = marketSector.Account_Sector__c;
            returnPlatformAccount.Confirm_if_boat_yacht_is_chartered__c = 'No';
            returnPlatformAccount.Flag__c = cleanForm.Flag__c;
            returnPlatformAccount.Vessel_Length_ft_m__c = cleanForm.Vessel_Length__c;
            returnPlatformAccount.MMSI__c = cleanForm.MMSI__c;
            returnPlatformAccount.Vessel_IMO__c = cleanForm.IMO_Registration_No__c;
            
            insert returnPlatformAccount; //fil in rest
            cleanForm.Platform_Account__c = returnPlatformAccount.Id;
            update cleanForm;
            
        }
        catch(Exception e){
            log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
            log.appendLog('FATAL_ERROR', 'LTE createPlatformAcct method failed. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
            warningLog.appendLog('Error', 'Could not find create the platform account');
            log.success = false;
            log.createCase(e);  //create case
            
            system.debug(log);
        }
        
        log.appendLog('METHOD_EXIT', methodName + '|Platform Account with Id: ' + returnPlatformAccount.Id + ' Successfully Created');
        return returnPlatformAccount;
    }
    @testVisible private static Asset moveAssets(LTE_Activation__c cleanForm, Account platformAcct){
        
        String methodName = 'moveAssets(LTE_Activation__c cleanForm, Account platformAcct)';
        log.appendLog('METHOD_ENTRY', methodName + '|Preparing to move asset');
        Asset domeAsset = new Asset();
        try{
            domeAsset = [SELECT Id, SerialNumber,Name,  Root_Asset__c, AccountId, Root_Asset__r.AccountId, Root_Asset__r.SerialNumber, Root_Asset__r.Id 
                         FROM Asset  Where Name =: cleanForm.Antenna_Serial_No__c];
            
            if(domeAsset.Root_Asset__c == null){
                domeAsset.AccountId = platformAcct.Id;
                update domeAsset; //fil in rest
                cleanForm.Asset__c = domeAsset.Id;
                update cleanForm;
            }
            else{
                Asset root = new Asset(Id=domeAsset.Root_Asset__r.Id, AccountId=platformAcct.Id);
                update root;
                cleanForm.Asset__c = root.Id;
                update cleanForm;
            }
            
        }
        catch(Exception e){
            log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
            log.appendLog('FATAL_ERROR', 'LTE moveAssets method failed. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
            warningLog.appendLog('Error', 'Could not move the assets');
            log.success = false;
            log.createCase(e);  //create case
           
            system.debug(log);
        }
        log.appendLog('METHOD_EXIT', methodName + '|Asset with Id: ' + domeAsset.Id + ' Successfully Moved');
        
        return domeAsset;
        
    }
    @testVisible private static Contact moveSubscriberContact(LTE_Activation__c cleanForm, Account subscriberAcct){
        
        String methodName = 'moveSubscriberContact(LTE_Activation__c cleanForm, Account subscriberAcct)';
        log.appendLog('METHOD_ENTRY', methodName + '|Preparing to move contact');
        Contact subscriberContact = new Contact();

        try{
            subscriberContact = [SELECT Id, FirstName, LastName, LastModifiedDate,
                                 Email FROM Contact  Where Email =: cleanForm.Subscriber_Email__c AND FirstName =: cleanForm.Main_Contact_FirstName_Subscriber__c AND LastName =: cleanForm.Main_Contact_LastName_Subscriber__c ORDER BY LastModifiedDate DESC LIMIT 1 ];
            subscriberContact.Phone = cleanForm.Subscriber_Phone__c;
            subscriberContact.MailingCity = cleanForm.Subscriber_City__c;
            subscriberContact.MailingCountry = cleanForm.Subscriber_Country__c;
            subscriberContact.MailingPostalCode = cleanForm.Subscriber_Postal_Zip_Code__c;
            subscriberContact.MailingState = cleanForm.Subscriber_State_Province_Territory__c;
            subscriberContact.MailingStreet = cleanForm.Subscriber_Address__c;
            //reassign the sub you just found 
            if(!existingUser){
                subscriberContact.AccountId = subscriberAcct.Id;
                log.appendLog('INFO', methodName + '|Subscriber already is on an account so not moving it.');
            }
            
            //Assign the contact role to the account
            AccountContactRole conRole = new AccountContactRole();
            conRole.AccountId = subscriberAcct.Id;
            conRole.ContactId = subscriberContact.Id;
            conRole.Role = 'Airtime Services Main Contact';
            
            insert conRole;
            update subscriberContact; 
            cleanForm.Contact__c = subscriberContact.Id;
            update cleanForm;
        }
        catch(Exception e){
            log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
            log.appendLog('FATAL_ERROR', 'LTE moveSubscriberContact method failed. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
            log.appendLog('INFO', 'This is probably because there was no contact that had an email that matched the one provided on the activation form ');
            warningLog.appendLog('Error', 'Could not move the subscriber, the emails probably do not match');
            log.success = false;
            log.createCase(e);  //create case

            system.debug(log);
        }
        log.appendLog('METHOD_EXIT', methodName + '|Contact with Id: ' + subscriberContact.Id + ' Successfully Moved');
        
        return subscriberContact;
        
    }
    
    @testVisible private static User addMyKVHRoleToUser(Contact subscriberContact){
        String methodName = 'addMyKVHRoleToUser(LTE_Activation__c cleanForm, Contact subscriberContact)';
        User returnObj = new User();
        log.appendLog('METHOD_ENTRY', methodName + '|Preparing to update ' + subscriberContact.Name + '\'s User record');
        list<User> userList = [SELECT Id, username, Name FROM User WHERE contactId =: subscriberContact.Id];
        if(userList.size() != 1){
            log.appendLog('METHOD_EXIT', methodName + '|Found ' + userList.size() + ' Users!');
            log.appendLog('FATAL_ERROR', 'Unable to isolate the Contact\'s User!');
            warningLog.appendLog('Error', 'Could not update the User');
            log.success = false;
            return returnObj;
        }
        try{
            //Get the Custom Setting
            myKVH_new_User_Defaults__c userDefaults = myKVH_new_User_Defaults__c.getValues('DirectCustomerDefaults');
            udpateUser(userList[0].Id, userDefaults.myKVH_Role_Id__c);  //@future method
            returnObj = userList[0];
            log.appendLog('METHOD_EXIT', methodName + '|Successfully enqueued update for ' + subscriberContact.Name + '\'s User record');
        } catch(Exception e){
            log.appendLog('METHOD_EXIT', methodName + '|Exception caught when updating User!');
            log.appendLog('FATAL_ERROR', 'User Update failed. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
            log.success = false;
            log.createCase(e);  //create case
        }
        return returnObj;
    }
    
    @testVisible private static Billing_Account__c createBillingAccount(LTE_Activation__c cleanForm, Account subscriberAcct){
        String methodName = 'createBillingAccount(LTE_Activation__c cleanForm, Account subscriberAcct)';
        log.appendLog('METHOD_ENTRY', methodName + '|Preparing to Create Billing Account');
        
        Billing_Account__c returnBillingAccount = new Billing_Account__c();


        try{
            returnBillingAccount.RecordTypeId = CC_RECORD_TYPE_ID;
            returnBillingAccount.Account__c	 = subscriberAcct.Id;
            
            if(cleanForm.Subscriber_Company_Name__c == null){
                returnBillingAccount.Name = cleanForm.Main_Contact_FirstName_Subscriber__c + ' ' + cleanForm.Main_Contact_LastName_Subscriber__c;
            }
            else{
                returnBillingAccount.Name = cleanForm.Subscriber_Company_Name__c;
            }
            
            if(cleanForm.Billing_Account__c != null){
                returnBillingAccount.Id = cleanForm.Billing_Account__c;
                log.appendLog('METHOD_EXIT', methodName + '|Billing Account with Id: ' + returnBillingAccount.Id + ' Successfully Found');
                system.debug('@@@ in 1st loop billing account');
                return returnBillingAccount;
            }
            else if(cleanForm.Corporate_Billing_Account__c != null){
                if(cleanForm.Billing_Account__c == null){
                    returnBillingAccount.Corporate_CC_Account_Name__c = cleanForm.Corporate_Billing_Account__c;
                    log.appendLog('INFO', methodName + '|Corporate Billing Account with Id: ' + cleanForm.Corporate_Billing_Account__c + ' Successfully Found');
                    system.debug('@@@ in 2st loop billing account');
                    insert returnBillingAccount;
                }
            }
            else{
                system.debug('@@@ in 3st loop billing account');
                insert returnBillingAccount;
            }

             //fil in rest
            cleanForm.Billing_Account__c = returnBillingAccount.Id;
            update cleanForm;
            
        }
        catch(Exception e){
            log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
            log.appendLog('FATAL_ERROR', 'LTE createBillingAccount method failed. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
            warningLog.appendLog('Error', 'Could not create the billing account');
            log.success = false;
            log.createCase(e);  //create case
            
            system.debug(log);
        }
        log.appendLog('METHOD_EXIT', methodName + '|Billing Account with Id: ' + returnBillingAccount.Id + ' Successfully Created');
        return returnBillingAccount;
    }

    @testVisible private static Contract createContract(LTE_Activation__c cleanForm,Account subscriberAcct, Account platformAcct, Billing_Account__c billingAcct){
        String methodName = 'createContract(Account subscriberAcct, Account platformAcct, Billing_Account__c billingAcct)';
        log.appendLog('METHOD_ENTRY', methodName + '|Preparing to Create Contract');
        
        Contract subscriberContract = new Contract();
        
        try{
            
            //change these fields
            subscriberContract.AccountId = subscriberAcct.Id;
            subscriberContract.Installation__c = platformAcct.Id;
            subscriberContract.Billing_Account__c = billingAcct.Id;
            subscriberContract.ContractTerm = 1;
            subscriberContract.Contract_Type__c = 'Airtime';
            subscriberContract.Status = 'Draft';
            subscriberContract.StartDate = system.today();
            subscriberContract.RecordTypeId = Contract_RECORD_TYPE_ID;
            //subscriberContract.MSA__c = ;
            
            insert subscriberContract; //fil in rest
            cleanForm.Contract__c = subscriberContract.Id;
            update cleanForm; 
            
        }
        catch(Exception e){
            log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
            log.appendLog('FATAL_ERROR', 'LTE createContract method failed. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
            warningLog.appendLog('Error', 'Could not create the contract');
            log.success = false;
            log.createCase(e);  //create case
            
            system.debug(log);
        }
        log.appendLog('METHOD_EXIT', methodName + '|Contract with Id: ' + subscriberContract.Id + ' Successfully Created');
        return subscriberContract;
    }

    @testVisible private static SBQQ__Subscription__c createSubscription(Asset domeAsset, Contract subscriberContract,LTE_Activation__c cleanForm){
        String methodName = 'createSubscription(Asset domeAsset, Contract subscriberContract)';
        log.appendLog('METHOD_ENTRY', methodName + '|Preparing to Create Subscription');
        
        SBQQ__Subscription__c theSubscription = new SBQQ__Subscription__c();
        Product2 theProduct = new Product2();
        
        try{
            //theProduct = [SELECT Id, Name FROM Product2 Where Name = 'LTE20GB' LIMIT 1]; //FOR NOW
            theProduct = [SELECT Id, Name FROM Product2 Where Name =: cleanForm.Rate_Plan__c and Data_Rate_Plan__c = true limit 1];
            
            theSubscription.SBQQ__Product__c = theProduct.Id;
            theSubscription.Asset__c = domeAsset.Id;
            theSubscription.SBQQ__Quantity__c = 1;
            theSubscription.Status__c = 'Pending';
            theSubscription.SBQQ__Contract__c = subscriberContract.Id;
            
            insert theSubscription; //fil in rest
            
            cleanForm.Subscription__c = theSubscription.Id;
            cleanForm.Transform_Service__c = 'Completed Fully';
            update cleanForm;
        }
        catch(Exception e){
            log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
            log.appendLog('FATAL_ERROR', 'LTE createSubscription method failed. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
            warningLog.appendLog('Error', 'Could not create the subscription');
            log.success = false;
            log.createCase(e);  //create case
            system.debug(log);
        }
        log.appendLog('METHOD_EXIT', methodName + '|Subscription with Id: ' + theSubscription.Id + ' Successfully Created');
        return theSubscription;
    }

    @testVisible public static Id invokeProvisioining(SBQQ__Subscription__c theSub){
        String methodName = 'invokeProvisioining(SBQQ__Subscription__c theSub)';
        log.appendLog('METHOD_ENTRY', methodName + '|Preparing to invoke provisioning');
        
        try{
            Id provisioningJob  =  system.enqueueJob(new Enqueue_Service_LTE_provisioining(theSub));
            
            log.appendLog('METHOD_EXIT', methodName + '|Case with Id: ' + provisioningJob + ' Successfully updated');
            return provisioningJob;
        }
        catch(Exception e){
            log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
            log.appendLog('FATAL_ERROR', 'LTE invokeProvisioining failed. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
            log.success = false;
            
            log.createCase(e);  //create case
            system.debug(log);
            //update theCase;
        }
        return null;
        
    }
    
    /*****************************************************************************
    *@future methods
    ****************************************************************************/
    @future private static void udpateUser(Id userId, string roleString){
        String methodName = '@future udpateUser(Id userId, string roleString)';
        log.appendLog('METHOD_ENTRY', methodName + '|Preparing to update User record: ' + userId);
        try{
            User u = [SELECT Id, myKVH_Role__c FROM User WHERE Id =: userId LIMIT 1];
            u.myKVH_Role__c = roleString;
            u.uas__Sync_to_Contact__c = false;
            update u;
            log.appendLog('METHOD_EXIT', methodName + '|Successfully updated User');
        } catch(Exception e){
            log.appendLog('METHOD_EXIT', methodName + '|Exception caught! Proceeding anyway!');
            log.appendLog('INFO', methodName + '|Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
            warningLog.appendLog('Error', 'Could not update the User Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
            warninglog.createCase(e);  //create case
            insert warningLog.srCase;
        }
    }
    /*****************************************************************************
     *Code to be removed
     ****************************************************************************/
    //NOT USED ANYMORE
    // @testVisible private static Case updateCase(Account subscriberAcct, Account platformAcct, Billing_Account__c billingAcct, Asset domeAsset, Contact subscriberContact, Contract subscriberContract){
    //     String methodName = 'updateCase(Account subscriberAcct, Account platformAcct, Billing_Account__c billingAcct, Asset domeAsset, Contact subscriberContact, Contract subscriberContract))';
    //     log.appendLog('METHOD_ENTRY', methodName + '|Preparing to update Case');
        
    //     Case theCase = new Case();
        
    //     try{    
    //         theCase = [SELECT Id,AccountId,LTE_Transform_Status__c,AssetId,Billing_Account__c,Platform_Asset_Account__c,Subject, ContactId,Description, Contract__c FROM case WHERE ContactId =: subscriberContact.Id  LIMIT 1];
    //         theCase.ContactId = subscriberContact.Id;
            
    //         theCase.AccountId = subscriberAcct.Id;
    //         theCase.AssetId = domeAsset.Id;
    //         theCase.Billing_Account__c = billingAcct.Id;
    //         theCase.Platform_Asset_Account__c = platformAcct.Id;
    //         theCase.Subject = 'LTE Activation – ' + subscriberAcct.Name + ' - ' + platformAcct.Name ;
    //         theCase.Contract__c = subscriberContract.Id;
    //         theCase.LTE_Transform_Status__c = 'Success';
    //         //serviceResults theLog = getWarningLog();
    //         theCase.Description = 'Please review and process this LTE Airtime Service Activation. Please access the contract associated with this case to review the details of the order and complete processing.  ' ;
    //         update theCase; //fil in rest
    //     }
    //     catch(Exception e){
    //         //theCase = [SELECT Id,AccountId,LTE_Transform_Status__c,AssetId,Billing_Account__c,Platform_Asset_Account__c,Subject, ContactId,Description, Contract__c FROM case WHERE LTE_Activation__c =: rawForm.Id  LIMIT 1];
    //         log.appendLog('METHOD_EXIT', methodName + '|An Exception has been caught.');
    //         log.appendLog('FATAL_ERROR', 'LTE updateCase method failed. Line number: ' + e.getLineNumber() + ' Message: ' + e.getMessage());
    //         log.success = false;
    //         //theCase.LTE_Transform_Status__c = 'Failure';
    //         log.createCase(e);  //create case
    //         system.debug(log);
    //         //update theCase;
    //     }
    //     log.appendLog('METHOD_EXIT', methodName + '|Case with Id: ' + theCase.Id + ' Successfully updated');
    //     return theCase;
    // }
}