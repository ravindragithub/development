public with sharing class myKVH_Role_Clone_Engine {
    //Constructor
    public myKVH_Role_Clone_Engine() {
		this.showCloneCompleted=false;
        system.debug('Running constructor');
    }
    
    // Private variables, not properties
	private id newRoleID;
    // END Private variables, not properties    
     
    //Page Properties     
    public string newRoleURL  {get; private set;}

    private myKVH_Role__c originalRole = new myKVH_Role__c();       //this is the role to be cloned
    
    myKVH_Role__c clonedRole = new myKVH_Role__c();                 //this is the new, cloned role
    
    public string clonedRoleName {get; set;}                        //User inputs a new name for the role (check for dupes!)
    
    List<SelectOption> SelectFromRoles= new List<SelectOption>();   //this is a list comprised of all existing roles
    
    private string selectedRoleID;                                  //this is the ID of the role that the user selected
    
    public Boolean showMessages {get; set;}                         //Boolean flag to show/hide page messages in case of an error or needed notification to the user.
    
    public boolean showCloneCompleted {get; private set;}			//Boolean flag to show/hide the final page block after a successful clone.
    
    //Property Getters and Setters
    public myKVH_Role__c getoriginalRole() {
        return originalRole;
    }
    private void setoriginalRole(string roleId) {
        // AAM 2014-07-29
        originalRole = [SELECT id, Name FROM myKVH_Role__c WHERE id =: roleID];
        system.debug('IN setOriginalRole = ' + OriginalRole);
    }
    public List<selectOption> getSelectFromRoles() {
        return SelectFromRoles;
    }
    private void setSelectFromOptions() {
        SelectFromRoles.clear();
        for (myKVH_Role__c r : [SELECT Id, Name FROM myKVH_Role__c]) {
            SelectFromRoles.add(new SelectOption(r.id, r.Name));
        }
    }
    
    public String getSelectedRoleID() {
        return selectedRoleID;
    }
    public void setSelectedRoleID(String InputSelected) {
        this.selectedRoleID = InputSelected;
        system.debug('IN setSelectedRoleID, selectedRoleID = ' + this.selectedRoleID);
    }

    
    //Controller Methods
    public void onLoad() {
        // The external page that sends us to this page must set the ?roleID=xxxxxxxx query strinf parameter.
        // If you just preview this page, roleID will be NULL or an empty string.
        string roleID = ApexPages.currentPage().getParameters().get('roleID');  //try digesting a roleID query parameter 
        system.debug('In onLoad  roleID from Query String: ' + roleId);
        try {
            setoriginalRole(roleID);
            showMessages = false;
        } catch (exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You must select an existing myKVH Role to Clone....'));
            showMessages= true;
        }
        // Load the dropdown of roles
        setSelectFromOptions();
    }
    
    public pageReference CloneRole() {
        // Andy Magruder "This is how I think it works":
        // 		<apex:selectList id="selListRoleDropdown" <apex:selectList id="selListRoleDropdown" value="{!SelectedRoleID}"  
        // 
        // 		the value="{!SelectedRoleID}" from the VisualForce markup above is really a call to "public void setSelectedRoleID(String InputSelected)"
        // 		where MVC passes the selected item in the dropdown in parameter "InputSelected" .
        // 		
        // 		i.e. the selected value in the dropdown sets property selectedRoleID via a call to the "SETTER" routine setSelectedRoleID  
        // 
        // This call runs the SOQL that fills the property variable "originalRole" which is a myKVH_Role__c record.
        system.debug('In CloneRole, selectedRoleID = ' + this.selectedRoleID);
        setoriginalRole(this.selectedRoleID);
        showMessages = false;
        return null;
    }
    
    
    public pageReference validateUniqueName() {

        system.debug('Top of validateUniqueName, selectedRoleID = ' + this.selectedRoleID);        
        
        // The user might have changed the role he wants to clone from the dropdown.
        // Not necessary as user must click CloneRole button after dropdown change    setoriginalRole(this.selectedRoleID);

        Integer rowsInserted=0;
        
        if (this.clonedRoleName == '')
        {            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You must enter a name for your role to be cloned....'));
            showMessages = true;
        }
        else
        {
        // Get a query locator
        Database.QueryLocator q = Database.getQueryLocator(
            [SELECT Id, Name FROM myKVH_Role__c WHERE Name =: clonedRoleName LIMIT 1]);
        // Get an iterator
        Database.QueryLocatorIterator it = q.iterator();
        
        if (it.hasNext()) {
            showMessages= true;
            //This is a duplicate Name
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A myKVH Role with this name already exists! Please enter another.'));
            //clonedRoleName.addError('This name is not unique! Please select another.');   //only good for sObjects
        } else {
            //set things up for cloning...
            // AAM 2014-07-29
            this.clonedRole.Name = this.clonedRoleName;
            Database.SaveResult srRole = Database.insert(this.clonedRole, true);
            rowsInserted += 1;
            
            if (srRole.isSuccess())
            {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted myKVH_Role__c: ' + srRole.getId());
                
                this.newRoleID = srRole.getId();
                
                List<myKVH_Permission_Set__c> manyPrmSet = 
                    [Select id, adminFlag__c, canCreate__c, canDelete__c, canRead__c, canUpdate__c, CreatedById, CreatedDate, myKVH_Feature__c, myKVH_Role__c, myKVH_User__c, Name, PermSetFeature__c FROM myKVH_Permission_Set__c WHERE myKVH_Role__c =: this.originalRole.id];                
                
                For (myKVH_Permission_Set__c onePrmSet : manyPrmSet)
                {
                    
                    
                    id oldPrmSetId = onePrmSet.id;
                    
                    myKVH_Permission_Set__c newPrmSet = new myKVH_Permission_Set__c();
                    
                    //lines 143-151 could be replaced with "newPrmSet = onePrmSet.clone(false, true, false, false);"
                    //See http://www.salesforce.com/us/developer/docs/dbcom_apex230/index_Left.htm#CSHID=apex_methods_system_sobject.htm|StartTopic=Content%2Fapex_methods_system_sobject.htm|SkinName=webhelp
                    newPrmSet.adminFlag__c = 		onePrmSet.adminFlag__c;
                    newPrmSet.canCreate__c = 		onePrmSet.canCreate__c;
                    newPrmSet.canDelete__c = 		onePrmSet.canDelete__c;
                    newPrmSet.canRead__c = 			onePrmSet.canRead__c;
                    newPrmSet.canUpdate__c = 		onePrmSet.canUpdate__c;
                    newPrmSet.myKVH_Feature__c = 	onePrmSet.myKVH_Feature__c;
                    newPrmSet.myKVH_Role__c = 		this.newRoleID;
                    newPrmSet.myKVH_User__c = 		onePrmSet.myKVH_User__c;
                    newPrmSet.Name = 				onePrmSet.Name;
                    
                    //JT 8/25/14, There are advantages to adding all of the newly created records to a List<myKVH_Permission_Set__c>
                    // and then adding the list in a single DML statement rather than one-by-one in the loop....
                    Database.SaveResult srPrmSet = Database.insert(newPrmSet, true);
                    rowsInserted += 1;
                    
                    id newPrmSetId = srPrmSet.getId();
                    
                    //JT 8/25/14, We should try to get this SOQL statement outside of this FOR loop...
                    // if we had a List<myKVH_Permission_Set__c> for the newly cloned records, we could change the where clause to use IN List<myKVH_Permission_Set__c>....
                    List<myKVH_Field_Permission__c> oldFldPrms = 
                        [SELECT myKVH_User_Field__c, Name, permissionEdit__c, permissionRead__c from myKVH_Field_Permission__c WHERE myKVH_Permission_Set__c =: oldPrmSetId];
                    
                    
                    List<myKVH_Field_Permission__c> FldPrms_TO_INSERT = new List<myKVH_Field_Permission__c>();
                    
                    
                    For (myKVH_Field_Permission__c oneFldPrm : oldFldPrms) {
                        myKVH_Field_Permission__c newFldPrm = new myKVH_Field_Permission__c(); 
                        
                        newFldPrm.myKVH_Permission_Set__c  =   newPrmSetId; 
                        newFldPrm.myKVH_User_Field__c	  =   oneFldPrm.myKVH_User_Field__c;     
                        newFldPrm.Name   				  =   oneFldPrm.Name;                    
                        newFldPrm.permissionEdit__c  	  =   oneFldPrm.permissionEdit__c;       
                        newFldPrm.permissionRead__c  	  =   oneFldPrm.permissionRead__c;
                        
                        //database.insert(newFldPrm, true);
                        //rowsInserted += 1;
                        
                        FldPrms_TO_INSERT.add(newFldPrm);
                    }	//JT 8/25/14, Very nice... create a list, add clones to the list, then a single DML statement to insert may rows!
                    Database.SaveResult[] srFldPrms = Database.insert(FldPrms_TO_INSERT, true);
                    
                    rowsInserted += FldPrms_TO_INSERT.size();
                    
                    // See if you are hitting record limits
                    system.debug('rowsInserted: ' + rowsInserted.format());
                    system.debug('getLimitDMLRows(): ' + Limits.getLimitDMLRows().format());
                    system.debug('getDMLRows(): ' + Limits.getDMLRows().format());
                    
                }
                
               
                // ToDo, doesn't work, returns NULL, I am forced to use hard coding below.           String TempUrl = Site.getDomain();   
                

                String TempUrl = system.URL.getSalesforceBaseUrl().toExternalForm();
                
				system.debug ('TempURL (Site.getDomain()) = ' + TempURL);
                if (TempUrl.right(1) == '/')
                {
                this.newRoleURL=TempURL + this.newRoleID;
                }
                else
                {
                this.newRoleURL=TempURL + '/' + this.newRoleID; 
				}
            
                
                //  get rid of hardcoding          this.newRoleURL='https://kvh--servcloud.cs15.my.salesforce.com/' + this.newRoleID;
                this.showCloneCompleted = true;
            }
            else
            {
                // Save myKVHRole Operation failed, so get all errors
                for(Database.Error err : srRole.getErrors()) {
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, err.getMessage()));                
                }
            }
        }

        }
        return null; 
    }
    
    
	//Private method test helpers
	//First extend the exception Class
	public with sharing class TestException extends Exception {
	}
   
    
    
    public void test_setoriginalRole(String origRoleId){
        //This method can only be called from a test method.
        //  This method allows calling a private method from test code to allow for faster test performance.
        if (!test.isRunningTest()){
            throw new TestException('This method can only be called from a test.');
        }
        setoriginalRole(origRoleId);
    }
}