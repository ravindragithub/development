public with sharing class my_Cases_Customer_Controller {
	public set<Id> visibleRecTypes = new set<Id>(); //list case RecordTypeIds to be surfaced in Customer Portal, TODO Replace with Custom Setting
    public String filter {get; set;}
    public id uid;
    //public id actid;
    //public String contIdChosen {get; set;}
    private String soql {get;set;}
    private String whereClause {get;set;}
    public List <case> fullCaseList = New List <case>();
    //public String soqlsort {get;set;}
    public List <case> caseList2 = New List <case>();
    public List <case> caseList3 = New List <case>();

    public my_Cases_Customer_Controller(){
    	
        this.uid = UserInfo.getUserid();
        if (filter != null){
            this.filter = filter;
        } else {
            this.filter = 'open';
        }
		getVisibleRecTypes();
        getItems();
        refresh();
        getCaseList2();
        
    }
    
    public void getVisibleRecTypes(){
    	map<string, PortalProductServiceRecordTypeMap__c> settings = PortalProductServiceRecordTypeMap__c.getAll();
    	for (PortalProductServiceRecordTypeMap__c s : settings.values()){
    		visibleRecTypes.add(s.RecordTypeId__c);
    	}
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('closed','Closed Cases'));
        options.add(new SelectOption('open','Open Cases'));
        options.add(new SelectOption('recent','Recently Viewed Cases'));
        options.add(new SelectOption('Activations','Activation Orders - Open'));
        //options.add(new SelectOption('others','My Others Cases')); To add a new query, add both the select option
        //AND the specific query construct in the refresh() method.....
        return options;
    }

    public pageReference getCaseList2(){
        this.filter = filter;
        getCaseList();                      
        return null;
    }   

    // List used in to display the table in VF page.
    public List<case> getCaseList() {
        // Passing the values of list to VF page.                    
        return con.getRecords();
    }
    
    public pageReference setRecsPerPage(){
    	if (con.getPageSize() == null){
    		con.setPageSize(10);
    	} else {
    		con.setPageSize(PageSize);
    	}
    	return null;
    }

    public ApexPages.StandardSetController con {
        get;
        set;
    }

    public Boolean hasNext {
        get { return con.getHasNext(); }
        set;
    }

    public Boolean hasPrevious {
        get { return con.getHasPrevious(); }
        set;
    }

    public Integer pageSize {
        get { return con.getPageSize(); }
        set;
    }

    public Integer getTotalPages(){

        Decimal totalSize = this.Con.getResultSize();
        Decimal pageSize = this.Con.getPageSize();

        Decimal pages = totalSize/pageSize;

        return (Integer)pages.round(System.RoundingMode.CEILING);
    }

    public Integer pageNumber {
        get { return con.getPageNumber(); }
        set;
    }
    public void first() {
        this.con.first();
    }

    // returns the last page of records
    public void last() {
        this.con.last();        
    }

    // returns the previous page of records
    public void previous() { 
        this.con.previous();
    }

    // returns the next page of records
    public void next() {
        this.con.next();
    }

    // returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        con.cancel();
    } 
    public void toggleSort() {
        // simply toggle the direction
        sortDir = sortDir.startsWithIgnoreCase('ASC') ? 'DESC NULLS LAST' : 'ASC NULLS FIRST';
        refresh();
    }

    public String sortDir {
        // To set a Direction either in ascending order or descending order.
        get  { if (sortDir == null) {  sortDir = 'DESC NULLS LAST'; } return sortDir;}
        set;
    }

    // the current field to sort by. defaults to last name
    public String sortField {
        // To set a Field for sorting.
        get{
        	if (sortField == null) {
        		if (filter == 'recent'){
        			sortField = 'LastViewedDate';
        			sortDir = 'DESC NULLS LAST';
        		} else if (filter == 'Closed'){
        			sortField = 'ClosedDate';
        			sortDir = 'DESC NULLS LAST';
        		} else {
        			sortField = 'CaseNumber';
        			sortDir = 'DESC NULLS LAST';
        		}
        	}
        	return sortField;
    	}
        set;
    }

    /*
     * Refresh the data on the screen by re-constructing and initializng
     * the set controller
     */
    public void refresh() {
    	soql = 'SELECT Id, CaseNumber, Subject, RecordType.Name, Platform_Asset_Account__c, Child_Asset_Name__c, CreatedDate , LastModifiedDate, ClosedDate, Status, ContactId, AssetId, Asset_Name__c, Product_Group__c FROM Case ';
    	whereClause = 'WHERE RecordTypeId IN :visibleRecTypes ';
        if(filter == 'closed') {
        	whereClause += 'AND ClosedDate = LAST_N_DAYS:1095 '; 		//3 years or 2500 cases, whichever is smaller
        	System.debug('filter closed is: ' + filter);
            // Passing the String array to a list with Selected field sorting.
            fullCaseList = Database.query(soql + whereClause + 'and status = \'Closed\' ORDER BY ' + sortField + ' ' + sortDir + ' LIMIT 2300'); // avoid max view state

            // setting values of List in StandardSetController.
            con = new ApexPages.StandardSetController(fullCaseList);

        }else if(filter == 'open') {
            System.debug('filter open is: ' + filter);
            // Passing the String array to a list with Selected field sorting.
			fullCaseList = Database.query(soql + whereClause + 'and status NOT IN (\'Closed\', \'Closed as Duplicate\') ORDER BY ' + sortField + ' ' + sortDir + ' LIMIT 2300'); // avoid max view state 
            // setting values of List in StandardSetController.
            con = new ApexPages.StandardSetController(fullCaseList);

        }else if(filter == 'recent') {
			//Recently viewed is a special case....
            System.debug('filter recent is: ' + filter);
            // Passing the String array to a list with Selected field sorting.
            fullCaseList = Database.query(soql + whereClause + 'and LastViewedDate = LAST_N_DAYS:30 AND status != \'Closed as Duplicate\' ORDER BY ' + sortField + ' ' + sortDir + ' LIMIT 2300');

            // setting values of List in StandardSetController.
            con = new ApexPages.StandardSetController(fullCaseList);
        }else if(filter == 'Activations') {
            fullCaseList = Database.query(soql + whereClause + 'and Case_Symptom__c = \'Airtime Services Activation\' AND status != \'Closed\' ORDER BY ' + sortField + ' ' + sortDir + ' LIMIT 2300');

            // setting values of List in StandardSetController.
            con = new ApexPages.StandardSetController(fullCaseList);
        }
        
		
    }
}