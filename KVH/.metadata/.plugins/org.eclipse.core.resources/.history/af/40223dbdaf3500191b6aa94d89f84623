/**
* @createdby        :   Teertha prasad
* @createddate      :   01/08/2016
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   06/22/2017
* @description      :   Class Used In ActivationAccountsPage for Activation Corporate Accounts List View 
*                       And To Create Activation Corporate Accounts.
**/ 

public class ActivationAccountsController {
    
    public Map<String, Billing_Account__c> mapBillingCorporateAccounts  {get; set;} // to store corporate accounts with unique id (2 or 3 digit) as a key
    public Map<String, Billing_Account__c> mapBillingCustomerAccounts       {get; set;} // to store customer accounts with unique id (2 or 3 digit) as a key
    
    public Map<String, Map<String, Billing_Account__c>> mapCorporateMapCustomerAccounts        {get; set;} // to store customer accounts with unique id (4 or 5 digit) as a key and outer key of corporate!
    
    private Id strCorporateRecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Corporate CC Account').getRecordTypeId(); // Account billing record type(corporate account)
    private Id strCustomerRecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId(); // Account billing record type(customer account)
    
    private Set<String> setRoles = New Set<String>{'Airtime Main Contact', 'Authorized Representative', 'Airtime Authorized Representative'}; // page accessible only to these contact roles ( can be taken from custom setting)
        
    public Boolean  boolIsShowMsg           {get; set;} // show error if found on vf page
    public Boolean  boolIsShowCorporates    {get; set;} // show error if found on vf page
    public Boolean  boolIsShowCustomers     {get; set;} // show error if found on vf page
    public Id       idAccount               {get; set;}
    public Id       idCorporateAccount      {get; set;}
    private Id      idUserContact           {get; set;}
    private Id      idCase                  {get; set;}
    public Boolean  boolIsShowData     		{get; set;} // show data or term popup validation
    public Boolean  boolIsShowBehalfButton 	{get; set;} // show Activate a System on Behalf of a Customer Button
    public String 	strAcceptOrDeny			{get; set;}
    
    Map<String, Set<Id>> mapBillingAccountRecordTypeAccounts = New Map<String, Set<Id>>();
    
    /** Constructor - Start **/
    public ActivationAccountsController(){
        strAcceptOrDeny = '';
    }
    /** Constructor - End **/
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   01/31/2017
* @description          :   validatePopupOnload Method.
*                           To validate and redirect page
* @return               :   pagereference
* @invoke               :   From VF page on load action 
**/  
    public pagereference validatePopupOnload(){
        idCase = apexpages.currentpage().getparameters().get('caseID');
        boolIsShowData = true;
        boolIsShowBehalfButton = false;
        List<User> objUser = New List<User>();
        objUser = [SELECT Id,Activation_Order_Terms__c FROM User WHERE ContactId != null AND AccountId != null AND Contact.Inactive_Contact__c = false AND ID=: UserInfo.getUserId() AND (Activation_Order_Terms__c = null OR Activation_Order_Terms__c = '') LIMIT 1];
        if(objUser.size()>0){
            strAcceptOrDeny = objUser[0].Activation_Order_Terms__c;
            boolIsShowData = false;
        }else if(idCase != null ){
            list<case> lstcase=[SELECT Id,contact.Account.CPI__c FROM case WHERE ContactId != null AND AccountId != null AND Contact.Inactive_Contact__c = false AND ID=: idCase AND contact.Account.CPI__c = null LIMIT 1];
            if(lstcase.size()>0){
                strAcceptOrDeny = lstcase[0].contact.Account.CPI__c;
                boolIsShowData = false;   
            }
        }
        return boolIsShowData ? validateRedirectionOnload() : null;
    } 
    
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   02/08/2017
* @description          :   validateRedirectionOnload Method.
*                           To validate and redirect page
* @return               :   pagereference
* @invoke               :   From VF page on load action 
**/  
    public pagereference validateRedirectionOnload(){
        String strExtCust = apexpages.currentpage().getparameters().get('ExtCust');
        boolIsShowMsg = false;
        boolIsShowCorporates= false;
        boolIsShowCustomers = false;
        idAccount = null;
        mapBillingAccountRecordTypeAccounts.put(strCorporateRecordTypeId, New Set<Id>());
        mapBillingAccountRecordTypeAccounts.put(strCustomerRecordTypeId, New Set<Id>());
        
        mapCorporateMapCustomerAccounts = New Map<String, Map<String, Billing_Account__c>>();
        Set<Id> setAccountRecordTypeIds = New Set<Id>();
        setAccountRecordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Partner').getRecordTypeId());
        setAccountRecordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Partner').getRecordTypeId());
        Id idDirectCustomerAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
        
        List<User> objUser = New List<User>();
        objUser = [SELECT Id, Email, IsActive, username, lastName, firstName, contactId, AccountId FROM User WHERE ContactId != null AND AccountId != null AND Contact.Inactive_Contact__c = false AND ID=: UserInfo.getUserId() LIMIT 1]; //  UserInfo.getUserId()'0051b000000OsNN' '0051b000000OzbC' '0051b000000OQt1' '0051b000000Oi91' '0051b000000OTwI'
        Set<Id> setAccountIds = New Set<Id>();
        
        if(objUser.size()>0){
            idAccount = objUser[0].AccountId;
            Id idAccountRecordTypeId ;
            if(idAccount != null){
                Account objAccountTemp = [SELECT Id,RecordTypeId,Partner_Role__c FROM Account WHERE Id =: idAccount];
                idAccountRecordTypeId = objAccountTemp.RecordTypeId;
                boolIsShowBehalfButton = (setAccountRecordTypeIds.contains(idAccountRecordTypeId) && objAccountTemp.Partner_Role__c != 'Service Provider') ? true : false;
            }
            idUserContact = objUser[0].ContactId;
            if (idAccount != null && !boolIsShowData){
                acceptOrDenyTerms(idAccount);
            }
            for(Billing_Account__c objBillingAccount : [SELECT ID, RecordTypeId, Main_Contact__c,Account__c FROM Billing_Account__c WHERE Main_Contact__c =: objUser[0].ContactId]){
                setAccountIds.add(objBillingAccount.Id);
                mapBillingAccountRecordTypeAccounts.get(objBillingAccount.RecordTypeId).add(objBillingAccount.Id);
            }
            for(Billing_Contact_Role__c objBillingContactRole : [SELECT Contact__c, Role_s__c, Billing_Account__c, Billing_Account__r.RecordTypeId, Billing_Account__r.Account__c FROM Billing_Contact_Role__c WHERE Contact__c =: objUser[0].ContactId ]){
                Set<String> setRolesT = New Set<String>();
                setRolesT.addAll((objBillingContactRole.Role_s__c != null ? objBillingContactRole.Role_s__c.trim().split(';') : New List<String>{null}));
                if(setRolesT.size()>0){
                    for(String strRole : setRolesT){
                        if(setRoles.contains(strRole.trim())){
                            setAccountIds.add(objBillingContactRole.Billing_Account__c);
                            mapBillingAccountRecordTypeAccounts.get(objBillingContactRole.Billing_Account__r.RecordTypeId).add(objBillingContactRole.Billing_Account__c);
                        }
                    }
                }
            }
            
            if(setAccountIds.size() >0){
                loadAccounts(setAccountIds);
            }else if(setAccountRecordTypeIds.size() == 2 && idAccountRecordTypeId != null && setAccountRecordTypeIds.contains(idAccountRecordTypeId)){
                return createNewActOrderConditionType();
            }else if(idAccountRecordTypeId != null){ // && idDirectCustomerAccountRecordType == idAccountRecordTypeId
                return createNewActOrder();
            }else{
                // boolIsShowMsg = true;
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Contact Role Not Expected!','Detail'));
            }
        }else if(idCase != null){
            if(String.isNotBlank(strExtCust) && strExtCust.equalsIgnoreCase('false')){
                ActivationsController objActivationsController = New ActivationsController();
                PageReference returnPage = objActivationsController.createNewActOrder(false);
                return returnPage;
            }
            list<case> lstcase=[select accountId, Account.RecordTypeId, Account.Partner_Role__c, contactId from case WHERE ContactId != null AND AccountId != null AND Contact.Inactive_Contact__c = false AND ID=: idCase LIMIT 1];
            if(lstcase.size()>0){
                boolIsShowBehalfButton = (setAccountRecordTypeIds.contains(lstcase[0].Account.RecordTypeId) && lstcase[0].Account.Partner_Role__c != 'Service Provider' ) ? true : false;
                idAccount = lstcase[0].AccountId;
                idUserContact = lstcase[0].ContactId;
                if (idAccount != null && !boolIsShowData){
                    acceptOrDenyTerms(idAccount);
                }
                for(Billing_Account__c objBillingAccount : [SELECT ID, RecordTypeId,Main_Contact__c,Account__c FROM Billing_Account__c WHERE Main_Contact__c =: lstcase[0].ContactId AND RecordTypeId =: strCorporateRecordTypeId]){
                    setAccountIds.add(objBillingAccount.Id);
                    mapBillingAccountRecordTypeAccounts.get(objBillingAccount.RecordTypeId).add(objBillingAccount.Id);
                }
                
                for(Billing_Contact_Role__c objBillingContactRole : [SELECT Contact__c, Role_s__c, Billing_Account__c,Billing_Account__r.RecordTypeId, Billing_Account__r.Account__c FROM Billing_Contact_Role__c WHERE Contact__c =: lstcase[0].ContactId ]){
                    Set<String> setRolesT = New Set<String>();
                    setRolesT.addAll((objBillingContactRole.Role_s__c != null ? objBillingContactRole.Role_s__c.trim().split(';') : New List<String>{null}));
                    if(setRolesT.size()>0){
                        for(String strRole : setRolesT){
                            if(setRoles.contains(strRole.trim())){
                                setAccountIds.add(objBillingContactRole.Billing_Account__c);
                                mapBillingAccountRecordTypeAccounts.get(objBillingContactRole.Billing_Account__r.RecordTypeId).add(objBillingContactRole.Billing_Account__c);
                            }
                        }
                    }
                } 
                
                if(setAccountIds.size() >0){
                    loadAccounts(setAccountIds);
                }else{
                    ActivationsController objActivationsController = New ActivationsController();
                    PageReference returnPage = objActivationsController.createNewActOrder(false);
                    if(String.isNotBlank(strExtCust) && strExtCust.equalsIgnoreCase('true')){
                        returnPage.getParameters().put('maincontactId',idUserContact);
                        returnPage.getParameters().put('AccountId',idAccount);
                    }
                    return returnPage;
                }
            }
        }else {
            boolIsShowMsg = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'You are not suppose to see this page!','Detail'));
        }
        
        return null;
    }
    
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   03/27/2017
* @description          :   acceptOrDenyTerms Method.
*                           To accept or deny activation order terms on contact.
* @return               :   void
* @param                :   String
* @invoke               :   From validateRedirectionOnload Method 
**/ 
    public void acceptOrDenyTerms(String strAccountId){
        strAcceptOrDeny = apexpages.currentpage().getparameters().get('strAcceptOrDeny');
        system.debug('strAcceptOrDeny' + strAcceptOrDeny);
        if(strAcceptOrDeny != '' && strAcceptOrDeny != null){
            for(Account objAccount : [SELECT Id,CPI__c FROM Account WHERE Id =: strAccountId]){
                objAccount.CPI__c = strAcceptOrDeny;
                 //only one record!
                update objAccount;
            }
            boolIsShowData = true;
        }
    }    
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   01/31/2017
* @description          :   loadAccounts Method.
*                           To load all relevent account billing data.
* @return               :   void
* @param                :   Set<Id> (Account Ids)
* @invoke               :   From constructor 
**/ 
    public void loadAccounts(Set<Id> setAccountIds){
        // system.debug('setAccountIds****' +setAccountIds);
        mapCorporateMapCustomerAccounts = New Map<String, Map<String, Billing_Account__c>>();
        Map<Id, Billing_Account__c> mapBillingAccounts = New Map<Id, Billing_Account__c>([SELECT ID, RecordTypeId,Main_Contact__c,Account__c, Corporate_CC_Account_Name__c, Corporate_CC_Account_Name__r.Id,  Corporate_CC_Account__c, Account__r.Salesforce_Account_ID__c, Billing_Account_ID__c, Name ,Billing_Account_Status__c FROM Billing_Account__c WHERE Id IN: setAccountIds OR Corporate_CC_Account_Name__c IN: setAccountIds ORDER BY Billing_Account_ID__c ASC] );
        //system.debug('mapBillingAccounts****'+mapBillingAccounts);
        mapBillingCorporateAccounts = New Map<String, Billing_Account__c>();
        
        for(Id Id :mapBillingAccounts.keySet()){
            mapBillingAccounts.get(Id).Billing_Account_ID__c = mapBillingAccounts.get(Id).Billing_Account_ID__c != null && mapBillingAccounts.get(Id).Billing_Account_ID__c != '' ? mapBillingAccounts.get(Id).Billing_Account_ID__c : (mapBillingAccounts.get(Id).Billing_Account_Status__c == 'In Review' ? 'Pending' : null );
                if(mapBillingAccountRecordTypeAccounts.containsKey(strCorporateRecordTypeId) && mapBillingAccountRecordTypeAccounts.get(strCorporateRecordTypeId) != null){
                    if(mapBillingAccounts.get(Id).Billing_Account_ID__c != null && mapBillingAccounts.get(Id).RecordTypeId == strCorporateRecordTypeId && mapBillingAccountRecordTypeAccounts.get(strCorporateRecordTypeId).contains(mapBillingAccounts.get(Id).Id)){
                        String strCorporateKey = mapBillingAccounts.get(Id).Billing_Account_ID__c.isNumeric() ? (String.valueOf(Integer.valueOf(mapBillingAccounts.get(Id).Billing_Account_ID__c) + 1000000)+Id) : (mapBillingAccounts.get(Id).Billing_Account_ID__c+Id);
                            mapBillingCorporateAccounts.put(strCorporateKey, mapBillingAccounts.get(Id)); 
                    }else if(mapBillingAccounts.get(Id).Corporate_CC_Account__c != null && mapBillingAccounts.get(Id).RecordTypeId == strCustomerRecordTypeId && mapBillingAccounts.get(Id).Corporate_CC_Account_Name__c != null && mapBillingAccountRecordTypeAccounts.get(strCorporateRecordTypeId).contains(mapBillingAccounts.get(Id).Corporate_CC_Account_Name__c)){
                        String strCorporateKey = (mapBillingAccounts.get(Id).Corporate_CC_Account__c.isNumeric() ? (String.valueOf(Integer.valueOf(mapBillingAccounts.get(Id).Corporate_CC_Account__c) + 1000000)+mapBillingAccounts.get(Id).Corporate_CC_Account_Name__r.Id) : (mapBillingAccounts.get(Id).Corporate_CC_Account__c+mapBillingAccounts.get(Id).Corporate_CC_Account_Name__r.Id));
                        String strCustomerKey = (mapBillingAccounts.get(Id).Billing_Account_ID__c.isNumeric() ? (String.valueOf(Integer.valueOf(mapBillingAccounts.get(Id).Billing_Account_ID__c) + 1000000)+Id) : (mapBillingAccounts.get(Id).Billing_Account_ID__c+Id));
                        if(!mapCorporateMapCustomerAccounts.containsKey(strCorporateKey)){
                            Map<String, Billing_Account__c> mapBillingCustomerAccountsTemp = New Map<String, Billing_Account__c>();
                            mapBillingCustomerAccountsTemp.put(strCustomerKey, mapBillingAccounts.get(Id));
                            mapCorporateMapCustomerAccounts.put(strCorporateKey, mapBillingCustomerAccountsTemp);
                        }else{
                            Map<String, Billing_Account__c> mapBillingCustomerAccountsTemp = mapCorporateMapCustomerAccounts.get(strCorporateKey);
                            mapBillingCustomerAccountsTemp.put(strCustomerKey, mapBillingAccounts.get(Id));
                            mapCorporateMapCustomerAccounts.put(strCorporateKey, mapBillingCustomerAccountsTemp);
                        }
                    }
                }
        }
        
        for(String strKey : mapBillingCorporateAccounts.keySet()){
            if(!mapCorporateMapCustomerAccounts.containsKey(strKey)){
                mapCorporateMapCustomerAccounts.put(strKey, New Map<String, Billing_Account__c>());
            }
        }
        
        if(!mapBillingCorporateAccounts.isEmpty()){
            boolIsShowCorporates = true;
        }
        mapBillingCustomerAccounts = New Map<String, Billing_Account__c>();
        for(Id Id :mapBillingAccounts.keySet()){ 
            if( mapBillingAccountRecordTypeAccounts.containsKey(strCustomerRecordTypeId) && mapBillingAccountRecordTypeAccounts.get(strCustomerRecordTypeId) != null && mapBillingAccountRecordTypeAccounts.get(strCustomerRecordTypeId).contains(mapBillingAccounts.get(Id).Id) && mapBillingAccounts.get(Id).RecordTypeId == strCustomerRecordTypeId && (mapBillingAccounts.get(Id).Corporate_CC_Account__c == null || ( mapBillingAccountRecordTypeAccounts.containsKey(strCorporateRecordTypeId) && !mapBillingAccountRecordTypeAccounts.get(strCorporateRecordTypeId).contains(mapBillingAccounts.get(Id).Corporate_CC_Account_Name__c)))){ //  &&
                String strCustomerKey = mapBillingAccounts.get(Id).Billing_Account_ID__c.isNumeric() ? (String.valueOf(Integer.valueOf(mapBillingAccounts.get(Id).Billing_Account_ID__c) + 1000000)+Id) : (mapBillingAccounts.get(Id).Billing_Account_ID__c+Id);
                    if(!mapBillingCustomerAccounts.containsKey(strCustomerKey)){
                        mapBillingCustomerAccounts.put(strCustomerKey, mapBillingAccounts.get(Id));
                    }
            }
        }
        // system.debug('mapBillingCustomerAccounts' + mapBillingCustomerAccounts);
        if(!mapBillingCustomerAccounts.isEmpty()){
            boolIsShowCustomers = true;
        }
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   18/08/2016
* @description          :   createNewActOrder Method.
*                           To Create Activation Order And load Activation Page.
* @return               :   PageReference
* @invoke               :   From VF page and class method
**/
    public PageReference createNewActOrder(){
        ActivationsController objActivationsController = New ActivationsController();
        PageReference returnPage = objActivationsController.selfActivation();
        returnPage.getParameters().put('CorporateAccountId', idCorporateAccount);  
        returnPage.getParameters().put('CorporateAccountCCId', ApexPages.currentPage().getParameters().get('idCCAccount'));
        returnPage.getParameters().put('AccountId', idAccount);
        if(ApexPages.currentPage().getParameters().get('accountType') != null && ApexPages.currentPage().getParameters().get('accountType') != '' && ApexPages.currentPage().getParameters().get('accountType') == 'corporate'){
            String strOrderId = returnPage.getParameters().get('order');
            returnPage = Page.Activation_Corporate;
            returnPage.getParameters().put('order', strOrderId);
            returnPage.getParameters().put('ParentAccountId', idAccount);
        }
        returnPage.getParameters().put('mainContactId', idUserContact);
        returnPage.setRedirect(true);
        return returnPage;     
    }
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   01/19/2017
* @description          :   createNewActOrderConditionType Method.
*                           To Create Activation Order And load Activation Page.
* @return               :   PageReference
* @invoke               :   From VF page and class method
**/
    public PageReference createNewActOrderConditionType(){
        ActivationsController objActivationsController = New ActivationsController();
        PageReference returnPage = objActivationsController.dealerActivation();
        returnPage.setRedirect(true);
        return returnPage;     
    }
    
}