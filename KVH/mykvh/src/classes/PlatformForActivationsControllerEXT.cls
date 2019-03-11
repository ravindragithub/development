public class PlatformForActivationsControllerEXT {

    private ApexPages.StandardController StdCtrl;
    Public ID caseID{get;set;}
    //constructor
    public PlatformForActivationsControllerEXT(apexPages.StandardController std) {
        StdCtrl = std;
        caseID = apexpages.currentpage().getparameters().get('CaseId');
    }
    //Page Properties
    public Account thePlatform {get;set;}
    
    public Account defaultParent = [SELECT id, Name FROM Account WHERE Name = 'Airtime Activations in Progress' LIMIT 1];public Case theCase {get;set;}
    //public Account ParentAcct;
    
    public List<Account> SelectedPlatform = new List<Account>();
    //public Account OneSelectedPlatform {get;set;}
    public List<Account> getSelectedPlatform() { system.debug(SelectedPlatform); return SelectedPlatform;}
    public List<Account> PlatformTable = new List<Account>();
    public List<Account> getPlatformTable() { system.debug(PlatformTable); return PlatformTable;}
    
    public List<RecordType> PlatformRecTypes = new List<RecordType>();
    public List<RecordType> getPlatformRecTypes() {
        /*Updated By Gopi from AccountUtilities to AccountUtilities1 class 
          Due to avoid some recordtypes like platform media
        */
        AccountUtilities1 AU = new AccountUtilities1();
        List<RecordType> RT = new List<RecordType>();
        PlatformRecTypes = AU.getPlatformRecordTypes();
        return PlatformRecTypes;
    }
    public RecordType theRecType = new RecordType();
    public RecordType gettheRecType() { return theRecType; }
    
    
    public List<SelectOption> IMOoptions = new List<SelectOption>();
    public List<SelectOption> getIMOoptions() {system.debug(IMOoptions); return IMOoptions;}
    
    public String IMOStats {get;set;}           //Status String for user feedback
    public String StatusColor {get;set;}        //Status STring Color...
    
    
    /* six boolean flags maintain the State machine built into the page and Block visibility */
    public Boolean showIMOSearch {get;set;}             //flag to control visibility of IMOSearch pageBlock
    public Boolean showPlatformSearch {get; set;}       //flag to control visibility of Platform Search
    public Boolean showPlatformTable {get; set;}        //flag to control visibility of SOQL/SOSL results
    public Boolean showPlatformSelection {get; set;}    //flag to control visibility of Selected Platform record
    public Boolean showRecTypeTable {get; set;}         //flag to control visibility of Platform RecordTypes
    public Boolean showRecTypeSelection {get; set;}     //flag to control visibility of Selected Platform RecordType
    public Boolean showCreatePlatform {get; set;}       //flag to control visibility of Platform Creation Page Block
    
    public Boolean noIMO;// {get; set;}     User override flag.. no IMO# on activation form
    public Boolean getnoIMO(){return noIMO;}
    public void setnoIMO(Boolean b){    
        noIMO = b;
        if (b){
            showPlatformSearch = b;
            IMOStats = 'Proceeding without an IMO#...';
            StatusColor = 'blue';
        }
    }
    public Boolean IMOValidated;// {get; set;} Flag for IMO# validation results
    public Boolean getIMOValidated() {return IMOValidated;}
    public void setIMOValidated(Boolean b){
        IMOValidated = b;
        if (b){
            showPlatformSearch = b;
            IMOStats = 'IMO Validated!';
            StatusColor = 'green';
        }
    }
    
    public String searchTerm {get; set;}        //Platform Name Search term...
    
    /* Controller Methods...  */
    public PageReference autoRun() { //Setup properties/class variables
        thePlatform = new Account();
        showIMOSearch = true;
        IMOStats = 'The Vessel IMO# is preferred identifier for commercial ships....';
        StatusColor = 'black';
        noIMO = false;
        IMOValidated = false;
        showRecTypeTable = false;
        showCreatePlatform = false;
        return null;
    }
    
    public void findIMO(){ //validate IMO# and query for it (IMO# is foreign key!)
        If (noIMO){                                             //catch override condition
            setnoIMO(true);
            return;
        } else if (thePlatform.Vessel_IMO__c == null) {         //catch null exception
            return;
        } else if (thePlatform.Vessel_IMO__c.length() <> 7) {   //seven characters long...
            IMOStats = 'Vessel IMO#s must be 7 digits long';
            StatusColor = 'red';
            return;
        } else if (!thePlatform.Vessel_IMO__c.isNumeric()) {    //all seven are numeric
            IMOStats = 'Vessel IMO#s must consist of only numbers';
            StatusColor = 'red';
            return;
        }
        integer checksum = 0;   //calculate Checksum.... ZERO based strings!!
        checksum = checksum + integer.valueof(thePlatform.Vessel_IMO__c.mid(0,1)) * 7;
        checksum = checksum + integer.valueof(thePlatform.Vessel_IMO__c.mid(1,1)) * 6;
        checksum = checksum + integer.valueof(thePlatform.Vessel_IMO__c.mid(2,1)) * 5;
        checksum = checksum + integer.valueof(thePlatform.Vessel_IMO__c.mid(3,1)) * 4;
        checksum = checksum + integer.valueof(thePlatform.Vessel_IMO__c.mid(4,1)) * 3;
        checksum = checksum + integer.valueof(thePlatform.Vessel_IMO__c.mid(5,1)) * 2;
        checksum = math.mod(checksum,10);
        system.debug('IMONumber: ' + thePlatform.Vessel_IMO__c + ' Checksum: ' + checksum);
        if (String.valueOf(checksum) <> thePlatform.Vessel_IMO__c.mid(6,1)) {
            IMOStats = 'Invalid Vessel IMO#';
            StatusColor = 'red';
            return;
        }
        IMOValidated = true;
        IMOStats = 'Vessel IMO# Validated! Searching....';
        StatusColor = 'green';
        ID platformRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();
        //Query for IMO# 
        PlatformTable = [SELECT id, Name, Vessel_IMO__c, Parent.Name, Parent.Custom_Call_Acct_ID__c 
                    FROM Account WHERE Vessel_IMO__c =: thePlatform.Vessel_IMO__c AND RecordTypeID !=:platformRTID];
        If (PlatformTable.size() == 0){     //IMO# is not in SFDC
            IMOStats = 'Vessel IMO# Validated, but Platform not found!';
            StatusColor = 'green';
            showPlatformSearch = true;
        } else {            //IMO# has been found, should only be ONE!
            IMOStats = 'Vessel IMO# Validated! Found ' + PlatformTable.size() + ' matching IMO#';
            StatusColor = 'green';
            for (Account a : PlatformTable){
                IMOoptions.add(new SelectOption(a.name, a.name));
            }
            showPlatformTable = true;
            system.debug(thePlatform.Vessel_IMO__c);
        }
    }
    
    public void SearchPlatform() {              //IMO# results not successful, search by platform name...
        searchTerm = searchTerm + '*';          //wild card at begininning of search term not supported :(
         ID platformRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();
        List<List <sObject>> searchList = [FIND :searchTerm 
                    IN NAME FIELDS RETURNING Account(Id, Name, Vessel_IMO__c, Parent.Name, Parent.Custom_Call_Acct_ID__c
                    WHERE RecordType.DeveloperName  Like 'Platform%' AND (RecordTypeID!=:platformRTID)) ];
        system.debug(searchList);//AND RecordTypeID !=:platformRTID
        PlatformTable = ((List<Account>)SearchList[0]);
        system.debug(PlatformTable);
        If (PlatformTable.size() == 0){
            IMOStats = 'Platform not found!';
            //change state? go to New Platform creation
        } Else {
            system.debug(PlatformTable);
            IMOStats = 'Found ' + PlatformTable.size() + ' matching Vessel Names';
            for (Account a : PlatformTable){
                IMOoptions.add(new SelectOption(a.name, a.name));
            }
            showPlatformTable = true;
        }
    }
    
    public void SelectPlatform() {
        String PlatformId = System.currentPagereference().getParameters().get('PlatId');
        ID platformRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();
        system.debug(platformId);
        thePlatform = [SELECT id, Name, Vessel_IMO__c, Parent.Name, Parent.Custom_Call_Acct_ID__c 
                        FROM Account WHERE Id =: PlatformId AND (RecordTypeID!=:platformRTID)];
        system.debug(thePlatform);
        SelectedPlatform.clear();
        SelectedPlatform.add(thePlatform);
        //OneSelectedPlatform = thePlatform;
        showPlatformSelection = true;
    }
    public pageReference useSelectedPlatform() {
        //update the case details here....
        updateCase(System.currentPagereference().getParameters().get('CaseId'), thePlatform.Id);
        //redirect to the Account page here in (view mode)
        pageReference gotoPage = new pageReference('/' + thePlatform.Id);
        gotoPage.setRedirect(true);
        return gotoPage;
    }
    
    public void searchRecordType() {
        //thePlatform = new Account();
        showIMOSearch = false;
        showPlatformTable = false;
        showPlatformSearch = false;
        showPlatformSelection = false;
        showRecTypeTable = true;
    }
    public void selectRecordType() {
        showIMOSearch = false;
        showPlatformTable = false;
        showPlatformSearch = false;
        showPlatformSelection = false;
        showRecTypeTable = true;
        showRecTypeSelection = true;
        String RecTypeID = System.currentPagereference().getParameters().get('RecTypeId');
        theRecType = [SELECT id, Name FROM RecordType WHERE id =:RecTypeID];
        system.debug(theRecType);
    }
    public void useSelectedRecordType() {
        showIMOSearch = false;
        showPlatformTable = false;
        showPlatformSearch = false;
        showPlatformSelection = false;
        showRecTypeTable = false;
        showRecTypeSelection = true;
        showCreatePlatform = true;
        thePlatform.ParentId = defaultParent.Id;
        thePlatform.RecordTypeId = theRecType.Id;
    }
    
    public pageReference Finish() {
        //thePlatform.BillingState   = 'Rhode Island';
        System.Debug('=====>'+thePlatform.Vessel_IMO__c);
        thePlatform.BillingCountry = 'Platform';
        Database.SaveResult MySaveResult = Database.Insert(thePlatform, true);
        //update the case details here....
        system.debug(MySaveResult.id);
        updateCase(System.currentPagereference().getParameters().get('CaseId'), MySaveResult.Id);
        //re-direct to the Account page here (in edit mode)
        pageReference gotoPage = new pageReference('/'+System.currentPagereference().getParameters().get('CaseId'));
        gotoPage.setRedirect(true);
        return gotoPage;
    }


    private void updateCase(Id caseId, Id PlatformId){
        system.debug('Case ID = ' + caseId);
        system.debug('Platform ID = ' + PlatformId); 
        case c = new Case(); 
        c = [SELECT id, CaseNumber, Platform_Asset_Account__c, Search_for_or_create_Platform_Account_in__c FROM Case WHERE id =: caseId];
        c.Platform_Asset_Account__c = PlatformId;
        c.Search_for_or_create_Platform_Account_in__c = true;
        update c;
    }
}