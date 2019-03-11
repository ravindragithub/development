public without sharing class myKVH_SupportCenterController {
    @AuraEnabled public List<Case> lstOfCases{get;set;}
    @AuraEnabled public List<String> webProductServiceTypeList{get;set;}
    @AuraEnabled public Map<String,String> CaseRecordTypeList{get;set;}
    /***********************************************
Name        :    doIntialize
Description :    Method to get the server related response in a class variable
************************************************/
    @AuraEnabled
    public static myKVH_SupportCenterController doIntialize(){
        myKVH_SupportCenterController obj = new myKVH_SupportCenterController();
        
        obj.lstOfCases = myKVH_SupportCenterController.getCaseRecords('["Open"]','','CaseNumber',false);
        obj.webProductServiceTypeList = myKVH_SupportCenterController.getWebProductServiceType();        
        obj.CaseRecordTypeList= myKVH_SupportCenterController.getCaseRecordType();        
        return obj;
    }
    
    /***********************************************
Name        :    CreateCaseController
Description :    Method to insert support center case
************************************************/
    @AuraEnabled
    public static Case CreateCaseController(Case aCase,string valueSelected,string typeCase){
        try{
        system.debug('==Web_Product_or_Service_Type__c==' + aCase.Web_Product_or_Service_Type__c);
            if(typeCase == 'airtimeCase')
            aCase = buildAirtimeCase(aCase,valueSelected);
            else if(typeCase == 'techSupportCase')
            aCase = buildTechnicalCase(aCase,null);
            
            system.debug('==aCase==' + aCase);
            
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            
            aCase.setOptions(dmo);  
            insert aCase;    
            return [SELECT Id, CaseNumber, Subject, RecordType.Name, Platform_Name__c,Parent_Case__c,Contact_Name__c,Product_or_Service__c,Type,
                    CreatedDate,ClosedDate,Status,Asset_Name__c,Product_Group__c,New_Vessel_or_Platform__c,Description,Case_Symptom__c 
                    From Case Where Id =: aCase.Id];
        }
        catch (Exception e) {
            throw new AuraHandledException('Darn it! Something went wrong: '
                                           + e.getMessage());    
        }
        finally {
        }      
    }    
    
    /***********************************************
Name        :    CreateCaseComment
Description :    Method to submit Case Comment
************************************************/
    @AuraEnabled
    public static List<CaseComment> CreateCaseComment(string addCommentVal, Case aCase){
        try{            
            CaseComment cseCmmt = new CaseComment();
            cseCmmt.ParentId = aCase.Id;
            cseCmmt.CommentBody = addCommentVal;
            insert cseCmmt;               
            if(aCase.Status == 'Closed' || aCase.Status == 'Closed As Duplicate'){
                aCase.Status = 'New Customer Comment';
                update aCase;
            }
            return [SELECT Id, ParentId, CommentBody,CreatedBy.Name,IsPublished,CreatedDate FROM CaseComment 
                    where ParentId =: aCase.Id AND IsPublished =: true
                    ORDER BY CreatedDate DESC NULLS LAST];
        }
        catch (Exception e) {
            throw new AuraHandledException('Darn it! Something went wrong: '
                                           + e.getMessage());    
        }
        finally {
        }             
    }
    /***********************************************
Name        :    buildTechnicalCase
Description :    Private method to build Technical Support Cases
************************************************/ 
    private static Case buildTechnicalCase(Case c,string valueSelected){ 
        map<string, string> ProductOrServiceMap = new map<string, string>();   
        ProductOrServiceMap.put('mini-VSAT Broadband', 'KVH mini-VSAT Broadband (TracPhone V-Series, V-IP Series)');
        ProductOrServiceMap.put('Inmarsat', 'Inmarsat (TracPhone Fleet, Mini-M, FleetBroadband)');
        ProductOrServiceMap.put('Standalone CommBox (C2, R8)', 'Standalone CommBox (C2, R8, Hub)'); //check recordtypeId
        ProductOrServiceMap.put('Iridium', 'Iridium (Pilot)');
        ProductOrServiceMap.put('Communications', 'Communications: VoIP, Crew Calling, OnGo Fax, GSM Remote Support Module');
        ProductOrServiceMap.put('CommBox','CommBox: "Quick" Software');
        ProductOrServiceMap.put('TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products', 'TracVision TV-series; M-series, HD-series, and Legacy TV Antenna Products');
        ProductOrServiceMap.put('Digital Compasses', 'Digital Compasses');  
        
        map<string, string> caserecordtypeMap = new map<string, string>();   
        caserecordtypeMap.put('mini-VSAT Broadband', Schema.SObjectType.Case.getRecordTypeInfosByName().get('mini-VSAT').getRecordTypeId() );
        caserecordtypeMap.put('Inmarsat', Schema.SObjectType.Case.getRecordTypeInfosByName().get('mini-VSAT').getRecordTypeId() );
        caserecordtypeMap.put('TracPhone SatComm', Schema.SObjectType.Case.getRecordTypeInfosByName().get('mini-VSAT').getRecordTypeId() );
        caserecordtypeMap.put('Iridium', Schema.SObjectType.Case.getRecordTypeInfosByName().get('mini-VSAT').getRecordTypeId() );
        caserecordtypeMap.put('IP-MobileCast', Schema.SObjectType.Case.getRecordTypeInfosByName().get('mini-VSAT').getRecordTypeId() );
        caserecordtypeMap.put('CommBox', Schema.SObjectType.Case.getRecordTypeInfosByName().get('CommBox').getRecordTypeId() );
        caserecordtypeMap.put('Other', Schema.SObjectType.Case.getRecordTypeInfosByName().get('SatTV').getRecordTypeId() );
        caserecordtypeMap.put('Digital Compasses', Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nav/Compass').getRecordTypeId() );
        caserecordtypeMap.put('TracVision Satellite TV', Schema.SObjectType.Case.getRecordTypeInfosByName().get('SatTV').getRecordTypeId() );
        
        Id userId = UserInfo.getUserId();        
        User u = [Select AccountId, ContactId from User where ID =:userId];
        c.AccountId = u.AccountId;
        c.ContactId = u.ContactId;
        c.Origin = 'Customer Portal';
        c.Type = 'Report a Service or Product Problem';
        if(caserecordtypeMap.containskey(c.Web_Product_or_Service_Type__c))
        c.RecordTypeId = caserecordtypeMap.get(c.Web_Product_or_Service_Type__c);
        if(ProductOrServiceMap.containskey(c.Web_Product_or_Service_Type__c))
        c.Product_or_Service__c = ProductOrServiceMap.get(c.Web_Product_or_Service_Type__c);  
        return c;
    }

    /***********************************************
Name        :    buildAirtimeCase
Description :    Private method to build Airtime Support Cases
************************************************/   
    private static Case buildAirtimeCase(Case c,string valueSelected){
        map<string, string> ProductOrServiceMap = new map<string, string>();
        ProductOrServiceMap.put('Questions about an invoice you received', 'Billing Inquiry or Dispute');
        ProductOrServiceMap.put('Billing issue', 'Billing Inquiry or Dispute');
        ProductOrServiceMap.put('Questions about a high usage alert you received', 'High Usage Alert Inquiry');
        ProductOrServiceMap.put('High usage', 'High Usage Alert Inquiry');
        ProductOrServiceMap.put('Questions about policies (such as suspension or plan change policies)', 'General Account or Service Inquiry');
        ProductOrServiceMap.put('Questions about available services (e.g. airtime rate plans, IP-MobileCast, OneCare, Vessel Tracking, Crew Calling, etc.)', 'General Account or Service Inquiry');
        ProductOrServiceMap.put('Questions about activation forms', 'General Account or Service Inquiry');
        ProductOrServiceMap.put('General question or feedback', 'General Account or Service Inquiry');
        ProductOrServiceMap.put('Airtime account change', 'General Account or Service Inquiry');
        
        map<string, string> ProductOrServiceDetailsMap = new map<string, string>();
        ProductOrServiceDetailsMap.put('Questions about an invoice you received', 'Questions about an invoice you received');
        ProductOrServiceDetailsMap.put('Questions about a high usage alert you received', 'Questions about a high usage alert you received');
        ProductOrServiceDetailsMap.put('High usage', '');
        ProductOrServiceDetailsMap.put('Questions about policies (such as suspension or plan change policies)', 'Questions about policies (such as suspension or plan change policies)');
        ProductOrServiceDetailsMap.put('Questions about available services (e.g. airtime rate plans, IP-MobileCast, OneCare, Vessel Tracking, Crew Calling, etc.)', 'Questions about available services (e.g. airtime rate plans, GlobalCare)');
        ProductOrServiceDetailsMap.put('Questions about activation forms', 'Questions about activation forms');
        ProductOrServiceDetailsMap.put('General question or feedback', 'General questions');
        ProductOrServiceDetailsMap.put('Airtime account change', 'General questions');
        ProductOrServiceDetailsMap.put('Billing issue', '');
        
        string CASE_TYPE = 'Information on an Existing Service';
        Group AIRTIMEQUEUE = [Select Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Airtime_Services_Queue'];
        Id userId = UserInfo.getUserId();
        User u = [Select AccountId, ContactId, Portal_View__c from User where ID =:userId];
        c.AccountId = u.AccountId;
        c.ContactId = u.ContactId;
        c.OwnerId = AIRTIMEQUEUE.Id;
        c.Origin = 'Customer Portal';
        c.Type = CASE_TYPE;
        c.RecordTypeId = PortalProductServiceRecordTypeMap__c.getAll().get(CASE_TYPE).RecordTypeId__c;
        c.Product_or_Service__c = ProductOrServiceMap.get(valueSelected); 
        c.Product_or_Service_Detail__c = ProductOrServiceDetailsMap.get(valueSelected);
        c.Case_Symptom__c = valueselected;
        return c;
    }
    /***********************************************
Name        :    getCaseRecords
Description :    Method to fetch all the Case related to the community user
************************************************/
    @AuraEnabled
    public static List<Case> getCaseRecords(string selectedStatus,string selectedType,string sortField,boolean sortDirection){
        system.debug('==selectedStatus==' + selectedStatus);
        system.debug('==selectedType==' + selectedType);
        Set<String> newselectedStatus = new Set<String>();
        Set<Id> newselectedType = new Set<Id>();
        system.debug(selectedStatus);
        if(selectedStatus != '' && selectedStatus != null)
        newselectedStatus = (Set<String>)System.JSON.deserialize(selectedStatus, Set<String>.class);
        
        if(selectedType != '' && selectedType != null)
        newselectedType= (Set<Id>)System.JSON.deserialize(selectedType, Set<Id>.class);
        system.debug('---serialized string--'+newselectedType);
        system.debug('---serialized string--'+newselectedType.size());
        string sortDir = '';
        if(sortDirection == false)
            sortDir = 'DESC NULLS LAST';
        else
            sortDir = 'ASC NULLS FIRST';
        
        List<Case> lstCases = new List<Case>();
        Set<Id> visibleRecTypes = new Set<Id>();  
        
        map<string, PortalProductServiceRecordTypeMap__c> settings = PortalProductServiceRecordTypeMap__c.getAll();
        system.debug(settings.values());
        //system.debug(System.Json.deserializeUntyped(selectedType);
        if(newselectedType.isEmpty()){
            system.debug('into zero');
            for (PortalProductServiceRecordTypeMap__c s : settings.values()){
                if(s.isCustomerPortal__c)
                visibleRecTypes.add(s.RecordTypeId__c);
            }        
        }
        else{
            system.debug('into not zero');
            for(Id objId: newselectedType){
                if(!visibleRecTypes.contains(objId))
                visibleRecTypes.add(objId);
            }
        }
        system.debug('==visibleRecTypes==' + visibleRecTypes);
        User userRec = [ SELECT Id, AccountId,contactId,Portal_View__c,Default_Account_ID__c
                        FROM User
                        WHERE Id =: UserInfo.getUserId()
                        LIMIT 1
                       ];
        String selectedPortalView = '';
        Id contactId = userRec.contactId;
        Id accountId = userRec.AccountId != null ? userRec.AccountId : userRec.Default_Account_ID__c;
        
        //get account Hierarchy from current node to all child nodes   
            
        AccountHierarchyUtility util = new AccountHierarchyUtility();
        AccountHierarchyUtility.ObjectStructureMap[] accStructure = util.formatObjectStructure(accountId,false);
        Set<String> accountIds = new Set<String>();
        if(accStructure != null && accStructure.size()>0){
            for(AccountHierarchyUtility.ObjectStructureMap asobj : accStructure){
                if(asobj.account != null && !String.valueOf(asobj.account.Id).startswith(Label.mykvh_Self_Registered_Users_Account_ID)){
                    accountIds.add(asobj.account.Id);
                }
            }
        }
        String soql = 'SELECT Id, CaseNumber, Subject, RecordType.Name, Platform_Name__c,  CreatedDate ,  ClosedDate, Status,  Asset_Name__c, Product_Group__c FROM Case ';
        string whereClause='';
        if(visibleRecTypes !=null)
            whereClause = 'WHERE RecordTypeId IN :visibleRecTypes ';
        
        if(contactId != null){
            whereClause += ' AND (ContactId =: contactId  OR AccountID IN : accountIds) '; 
        }else{
            whereClause += ' AND AccountID IN : accountIds ';
        }
        system.debug('newselectedStatus'+newselectedStatus);
        if(newselectedStatus.contains('Closed') && !newselectedStatus.contains('Open')) {
            whereClause += 'AND ClosedDate = LAST_N_DAYS:1095 ';        //3 years or 2500 cases, whichever is smaller
            lstCases = Database.query(soql + whereClause + 'and status = \'Closed\' ORDER BY ' + sortField + ' ' + sortDir + ' LIMIT 49999'); // avoid max view state
        }
        system.debug('newselectedStatus'+newselectedStatus);
        if(newselectedStatus.contains('Open') && !newselectedStatus.contains('Closed')) {
            lstCases = Database.query(soql + whereClause + 'and status NOT IN (\'Closed\', \'Closed as Duplicate\') ORDER BY ' + sortField + ' ' + sortDir + ' LIMIT 49999'); // avoid max view state 
        }
        else{
            whereClause += 'AND ( (ClosedDate = LAST_N_DAYS:1095 AND status = \'Closed\') OR status NOT IN (\'Closed\', \'Closed as Duplicate\')) ';
            lstCases = Database.query(soql + whereClause + 'ORDER BY ' + sortField + ' ' + sortDir + ' LIMIT 49999'); // avoid max view state 
        }
        
        return lstCases;
    }
    /***********************************************
Name        :    getCaseRecordType
Description :    Private method to fetch all the Case record  types
************************************************/
    private static Map<String, String> getCaseRecordType(){
    Map<String, String> visibleRecTypes = new Map<String, String>();
    Map<string, PortalProductServiceRecordTypeMap__c> settings = PortalProductServiceRecordTypeMap__c.getAll();
    for (PortalProductServiceRecordTypeMap__c s : settings.values()){
        if(s.isCustomerPortal__c)
        visibleRecTypes.put(s.RecordTypeId__c,s.Record_Type_Name__c);
    } 
    return visibleRecTypes;       
    }
    /***********************************************
Name        :    getWebProductServiceType
Description :    Private method to fetch all the WebProductServiceType picklist Values
************************************************/
    private static List<String> getWebProductServiceType(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Case.Web_Product_or_Service_Type__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
    /***********************************************
Name        :    caseCommentAccessMethod
Description :    Method to get all edit Access, comment list and case detailsfor the logged in community User
************************************************/
    @AuraEnabled
    public static caseCommentAccessWrapperClass caseCommentAccessMethod(string casesId){
        caseCommentAccessWrapperClass tempWrap = new caseCommentAccessWrapperClass();
        UserRecordAccess usrAccess = [SELECT RecordId, HasEditAccess FROM UserRecordAccess 
                                      WHERE UserId =: userInfo.getUserId() AND RecordId =: casesId LIMIT 1];
        if(usrAccess.HasEditAccess)
            tempWrap.caseAccess = true;
        else
            tempWrap.caseAccess = false;   
        tempWrap.caseData =  [SELECT Id, CaseNumber, Subject, RecordType.Name, Platform_Name__c,Parent_Case__c,Contact_Name__c,Product_or_Service__c,Type,
                              CreatedDate,ClosedDate,Status,Asset_Name__c,Product_Group__c,New_Vessel_or_Platform__c,Description,Case_Symptom__c 
                              From Case where Id =: casesId LIMIT 1];         
        tempWrap.caseCommentList = [SELECT Id, ParentId, CommentBody,CreatedBy.Name,CreatedDate FROM CaseComment 
                                    where ParentId =: casesId AND IsPublished =: true
                                    ORDER BY CreatedDate DESC NULLS LAST];        
        return tempWrap ;
    }
    public class caseCommentAccessWrapperClass{
        @AuraEnabled public Case caseData{get;set;}
        @AuraEnabled public boolean caseAccess{get;set;}
        @AuraEnabled public List<CaseComment> caseCommentList{get;set;}
    }
}