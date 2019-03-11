/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class test_myKVH_Role_Clone_Engine {
	// We need two original roles, some child Permission Sets and some Field Permissions.
	// Role 1 and child records declarations
	static myKVH_User_Field__c myKVHUser1 = new myKVH_User_Field__c(Name='myKVHUser1');
	static myKVH_User_Field__c myKVHUser2 = new myKVH_User_Field__c(Name='myKVHUser2');
	static myKVH_Feature__c feature1 = new myKVH_Feature__c(Name='feature1');
	static myKVH_Feature__c feature2 = new myKVH_Feature__c(Name='feature2');
	static myKVH_Role__c test_OrigRoleRec1 = new myKVH_Role__c(Name = 'test_OrigRoleRec1');
        static myKVH_Permission_Set__c test_OrigR1_PrmSet1 = new  myKVH_Permission_Set__c(Name='test_OrigR1_PrmSet1');
			static myKVH_Field_Permission__c  test_OrigR1_PS1_FP1 = new myKVH_Field_Permission__c(Name='test_OrigR1_PS1_FP1');
			static myKVH_Field_Permission__c  test_OrigR1_PS1_FP2 = new myKVH_Field_Permission__c(Name='test_OrigR1_PS1_FP2');
			static myKVH_Field_Permission__c  test_OrigR1_PS1_FP3 = new myKVH_Field_Permission__c(Name='test_OrigR1_PS1_FP3');    

    	static myKVH_Permission_Set__c test_OrigR1_PrmSet2 = new myKVH_Permission_Set__c(Name='test_OrigR1_PrmSet2');
  
        static myKVH_Permission_Set__c test_OrigR1_PrmSet3 = new myKVH_Permission_Set__c(Name='test_OrigR1_PrmSet3');
			static myKVH_Field_Permission__c  test_OrigR1_PS3_FP1 = new myKVH_Field_Permission__c(Name='test_OrigR1_PS3_FP1');
			static myKVH_Field_Permission__c  test_OrigR1_PS3_FP2 = new myKVH_Field_Permission__c(Name='test_OrigR1_PS3_FP2');

	// Role 2 and child records declarations
	static myKVH_Role__c test_OrigRoleRec2 = new myKVH_Role__c(Name = 'test_OrigRoleRec2');
        static myKVH_Permission_Set__c test_OrigR2_PrmSet1 = new myKVH_Permission_Set__c(Name='test_OrigR2_PrmSet1');

        static myKVH_Permission_Set__c test_OrigR2_PrmSet2 = new myKVH_Permission_Set__c(Name='test_OrigR2_PrmSet2');
			static myKVH_Field_Permission__c  test_OrigR2_PS2_FP1 = new myKVH_Field_Permission__c(Name='test_OrigR2_PS2_FP1');

        static myKVH_Permission_Set__c test_OrigR2_PrmSet3 = new myKVH_Permission_Set__c(Name='test_OrigR2_PrmSet3');    

        static myKVH_Permission_Set__c test_OrigR2_PrmSet4 = new myKVH_Permission_Set__c(Name='test_OrigR2_PrmSet4');

	// Role 3 declarations, has no child records.
		static myKVH_Role__c test_OrigRoleRec3 = new myKVH_Role__c(Name = 'test_OrigRoleRec3');


	static {
		insert (feature1);
		insert (feature2);
		myKVHUser1.myKVH_Feature__c = feature1.Id;
		myKVHUser2.myKVH_Feature__c = feature2.Id;
        insert (myKVHUser1);
        insert (myKVHUser2);
		// Role 1 set field values and do Inserts
		insert test_OrigRoleRec1;
		test_OrigRoleRec1 = [SELECT Id, Name FROM myKVH_Role__c WHERE Name = 'test_OrigRoleRec1'];
			//test_OrigR1_PrmSet1 = new myKVH_Permission_Set__c();
        	test_OrigR1_PrmSet1.myKVH_Role__c = test_OrigRoleRec1.Id;
        	//test_OrigR1_PrmSet1.Name = 'test_OrigR1_PrmSet1';
			test_OrigR1_PrmSet1.myKVH_Feature__c = feature1.id;
			insert(test_OrigR1_PrmSet1);
        	//test_OrigR1_PrmSet1 = [Select Id, Name, myKVH_Role__c, myKVH_Feature__c from myKVH_Permission_Set__c Where Name = 'test_OrigR1_PrmSet1'];
			    //test_OrigR1_PS1_FP1 = new myKVH_Field_Permission__c();
				test_OrigR1_PS1_FP1.myKVH_Permission_Set__c = test_OrigR1_PrmSet1.id;
	    		//test_OrigR1_PS1_FP1.Name = 'test_OrigR1_PS1_FP1';
        		test_OrigR1_PS1_FP1.myKVH_User_Field__c = myKVHUser1.id;
				insert(test_OrigR1_PS1_FP1);
			    //test_OrigR1_PS1_FP2 = new myKVH_Field_Permission__c();
				test_OrigR1_PS1_FP2.myKVH_Permission_Set__c = test_OrigR1_PrmSet1.id;
	    		//test_OrigR1_PS1_FP2.Name = 'test_OrigR1_PS1_FP2';
        		test_OrigR1_PS1_FP2.myKVH_User_Field__c = myKVHUser2.id;        
				insert(test_OrigR1_PS1_FP2);
 			    //test_OrigR1_PS1_FP3 = new myKVH_Field_Permission__c();
				test_OrigR1_PS1_FP3.myKVH_Permission_Set__c = test_OrigR1_PrmSet1.id;
	    		//test_OrigR1_PS1_FP3.Name = 'test_OrigR1_PS1_FP3';
        		test_OrigR1_PS1_FP3.myKVH_User_Field__c = myKVHUser2.id;        
				insert(test_OrigR1_PS1_FP3);


			//test_OrigR1_PrmSet2 = new myKVH_Permission_Set__c();
			test_OrigR1_PrmSet2.myKVH_Role__c = test_OrigRoleRec1.Id;
			//test_OrigR1_PrmSet2.Name = 'test_OrigR1_PrmSet2';
			test_OrigR1_PrmSet2.myKVH_Feature__c = feature1.id;
 			insert(test_OrigR1_PrmSet2);
            //test_OrigR1_PrmSet2 = [Select Id, Name, myKVH_Role__c, myKVH_Feature__c from myKVH_Permission_Set__c Where Name = 'test_OrigR1_PrmSet2'];
       
			//test_OrigR1_PrmSet3 = new myKVH_Permission_Set__c();
			test_OrigR1_PrmSet3.myKVH_Role__c = test_OrigRoleRec1.Id;
			//test_OrigR1_PrmSet3.Name = 'test_OrigR1_PrmSet3';
			test_OrigR1_PrmSet3.myKVH_Feature__c = feature2.id;
			insert(test_OrigR1_PrmSet3);
        	// test_OrigR1_PrmSet3 = [Select Id, Name, myKVH_Role__c, myKVH_Feature__c from myKVH_Permission_Set__c Where Name = 'test_OrigR1_PrmSet3'];        
				//test_OrigR1_PS3_FP1 = new myKVH_Field_Permission__c();
				test_OrigR1_PS3_FP1.myKVH_Permission_Set__c = test_OrigR1_PrmSet3.id;
				//test_OrigR1_PS3_FP1.Name = 'test_OrigR1_PS3_FP1';
                test_OrigR1_PS3_FP1.myKVH_User_Field__c = myKVHUser1.id;
				insert(test_OrigR1_PS3_FP1);
				//test_OrigR1_PS3_FP2 = new myKVH_Field_Permission__c();
				test_OrigR1_PS3_FP2.myKVH_Permission_Set__c = test_OrigR1_PrmSet3.id;
				//test_OrigR1_PS3_FP2.Name = 'test_OrigR1_PS3_FP2';
        		test_OrigR1_PS3_FP2.myKVH_User_Field__c = myKVHUser1.id;        
				insert(test_OrigR1_PS3_FP2);

	    // Role 2 set field values and do Inserts
		insert test_OrigRoleRec2;
		test_OrigRoleRec2 = [SELECT Id, Name FROM myKVH_Role__c WHERE Name = 'test_OrigRoleRec2'];
			//Test_OrigR2_PrmSet1 = new myKVH_Permission_Set__c();
			test_OrigR2_PrmSet1.myKVH_Role__c = test_OrigRoleRec2.Id;
			//test_OrigR2_PrmSet1.Name = 'test_OrigR2_PrmSet1';
			test_OrigR2_PrmSet1.myKVH_Feature__c = feature1.id;
			insert(test_OrigR2_PrmSet1);
        	//test_OrigR2_PrmSet1 = [Select Id, Name, myKVH_Role__c, myKVH_Feature__c from myKVH_Permission_Set__c Where Name = 'test_OrigR2_PrmSet1'];
        
			//test_OrigR2_PrmSet2 = new myKVH_Permission_Set__c();
			test_OrigR2_PrmSet2.myKVH_Role__c = test_OrigRoleRec2.Id;
			//test_OrigR2_PrmSet2.Name = 'test_OrigR2_PrmSet2';
			test_OrigR2_PrmSet2.myKVH_Feature__c = feature2.id;
			insert(test_OrigR2_PrmSet2);
        	//test_OrigR2_PrmSet2 = [Select Id, Name, myKVH_Role__c, myKVH_Feature__c from myKVH_Permission_Set__c Where Name = 'test_OrigR2_PrmSet2'];        
				//test_OrigR2_PS2_FP1 = new myKVH_Field_Permission__c();
				test_OrigR2_PS2_FP1.myKVH_Permission_Set__c = test_OrigR2_PrmSet1.id;
				//test_OrigR2_PS2_FP1.Name = 'test_OrigR2_PS1_FP1';
        		test_OrigR2_PS2_FP1.myKVH_User_Field__c = myKVHUser2.id;
				insert(test_OrigR2_PS2_FP1);

			//test_OrigR2_PrmSet3 = new myKVH_Permission_Set__c();
			test_OrigR2_PrmSet3.myKVH_Role__c = test_OrigRoleRec2.Id;
			//test_OrigR2_PrmSet3.Name = 'test_OrigR2_PrmSet3';
			test_OrigR2_PrmSet3.myKVH_Feature__c = feature1.id;
			insert(test_OrigR2_PrmSet3);
        	//test_OrigR2_PrmSet3 = [Select Id, Name, myKVH_Role__c, myKVH_Feature__c from myKVH_Permission_Set__c Where Name = 'test_OrigR2_PrmSet3'];        

			//test_OrigR2_PrmSet4 = new myKVH_Permission_Set__c();
			test_OrigR2_PrmSet4.myKVH_Role__c = test_OrigRoleRec2.Id;
			//test_OrigR2_PrmSet4.Name = 'test_OrigR2_PrmSet4';
			test_OrigR2_PrmSet4.myKVH_Feature__c = feature2.id;
			insert(test_OrigR2_PrmSet4);
        	//test_OrigR2_PrmSet4 = [Select Id, Name, myKVH_Role__c, myKVH_Feature__c from myKVH_Permission_Set__c Where Name = 'test_OrigR2_PrmSet4'];        

		// Role 3 set field values and do Insert
		insert test_OrigRoleRec3;
		test_OrigRoleRec3 = [SELECT Id, Name FROM myKVH_Role__c WHERE Name = 'test_OrigRoleRec3'];
	}

    static testMethod void test_OriginalRole() {
        //Instantiate a controller
		myKVH_Role_Clone_Engine ctrl = new myKVH_Role_Clone_Engine();
		ctrl.test_setoriginalRole(test_OrigRoleRec1.Id);
		string roleName = ctrl.getoriginalRole().Name;
		system.assertEquals('test_OrigRoleRec1', roleName);
    }
    static testMethod void test_onLoadWithoutParams() {
		//Instantiate a controller
		myKVH_Role_Clone_Engine ctrl = new myKVH_Role_Clone_Engine();	
		//create a page with no params
		PageReference testPage = Page.myKVH_Role_Cloning_Engine;
		Test.setCurrentPage(testPage);
		//execute default load method...
		ctrl.onLoad();
		String summryMsg = apexPages.getMessages()[0].getSummary();
		system.debug(summryMsg);
		system.assertEquals('You must select an existing myKVH Role to Clone....', summryMsg);
		//check that the selectOptions list is populated (three roles)...
		system.assertEquals(3,ctrl.getSelectFromRoles().size());
        
		//simulate user selects a role and clicks the id="btn_NextSteptoClone" button ...
		ctrl.setSelectedRoleID(test_OrigRoleRec2.Id);
		system.assertEquals(test_OrigRoleRec2.Id, ctrl.getSelectedRoleID());
        ctrl.test_setoriginalRole(ctrl.getSelectedRoleID());
		string roleName = ctrl.getoriginalRole().Name;
		system.assertEquals('test_OrigRoleRec2', roleName);		

		//simulate user selects the other role and clicks the id="btn_NextSteptoClone" button again ...        
		ctrl.setSelectedRoleID(test_OrigRoleRec1.Id);
		system.assertEquals(test_OrigRoleRec1.Id, ctrl.getSelectedRoleID());
		ctrl.CloneRole();
		roleName = ctrl.getoriginalRole().Name;
		system.assertEquals('test_OrigRoleRec1', roleName);
        
        // Simulate the user left the textbox with id="newName"  blank 
        ctrl.clonedRoleName = '';
        // Simulate the user clicked the button with id="btn_CloneNow"
		ctrl.validateUniqueName();
        

        integer NumOfMsgs = apexPages.getMessages().size();
		system.debug('At empty clonedRoleName, Number of messages: ' + NumOfMsgs);
		summryMsg = apexPages.getMessages()[NumOfMsgs-1].getSummary();
		system.assertEquals('You must enter a name for your role to be cloned....', summryMsg);
       
        
        // Simulate the user put the name of one of the other EXISTING roles in the textbox with id="newName".
        ctrl.clonedRoleName = 'test_OrigRoleRec3';
        // Simulate the user clicked the button with id="btn_CloneNow"
		ctrl.validateUniqueName();
        
        NumOfMsgs = apexPages.getMessages().size();
		system.debug('At A myKVH Role with this name already exists, Number of messages: ' + NumOfMsgs);
		summryMsg = apexPages.getMessages()[NumOfMsgs-1].getSummary();
		system.assertEquals('A myKVH Role with this name already exists! Please enter another.', summryMsg);
		
		// Simulate the user put a new valid Role name in textbox with id="newName"
        ctrl.clonedRoleName = 'test_OrigRoleRec1 CLONED';
        // Simulate the user clicked the button with id="btn_CloneNow"
		ctrl.validateUniqueName();
        system.assertEquals(true, ctrl.showCloneCompleted);

 // Check that the Permissions Sets got cloned.
        List<myKVH_Permission_Set__c> PrmSets1 = 
        [select myKVH_Permission_Set__c.ID
		from myKVH_Permission_Set__c 
		where myKVH_Role__r.Name = 'test_OrigRoleRec1 CLONED'];
        system.assertEquals(3, PrmSets1.size(), 'Cloned permission set count is off.');
        
        List<myKVH_Field_Permission__c> PrmFldsAll = 
        [select myKVH_Field_Permission__c.ID, Name
		from myKVH_Field_Permission__c 
		where myKVH_Permission_Set__r.myKVH_Role__r.Name = 'test_OrigRoleRec1 CLONED'];
        system.assertEquals(5,PrmFldsAll.size(), 'Cloned permission field count for all of first role is off.');       
        
        //JT 8/25/14 why does Name: test_OrigRoleRec1 CLONED.feature1 have TWO field permissions for myKVHUser2, and
        //why does Name: test_OrigRoleRec1 CLONED.feature2 have TWO field permissions for myKVHUser1??
        system.debug('PrmFldsAll[0].Name: ' + PrmFldsAll[0].Name);
        system.debug('PrmFldsAll[1].Name: ' + PrmFldsAll[1].Name);
        system.debug('PrmFldsAll[2].Name: ' + PrmFldsAll[2].Name);
        system.debug('PrmFldsAll[3].Name: ' + PrmFldsAll[3].Name);
        system.debug('PrmFldsAll[4].Name: ' + PrmFldsAll[4].Name);        
        
        //JT 8/25/14 comments and changes
        //Salesforce workflow re-names Permission Sets and Field Permissions like..
        //<myKVH_Role__c.Name> . <myKVH_Feature__c.Name> . <myKVH_User_Field__c.Name>   e.g.
        //"test_OrigRoleRec1 CLONED.feature1.myKVHUser1" for a Field Permission AND
        //"test_OrigRoleRec1 CLONED.feature1" for a Permission Set
        //changed three where clauses to use LIKE operator against myKVH_Permission_Set__r.Name
        List<myKVH_Field_Permission__c> PrmFlds2 = 
        [select myKVH_Field_Permission__c.ID, name
		from myKVH_Field_Permission__c 
		where myKVH_Permission_Set__r.Name LIKE 'test_OrigRoleRec1 CLONED%'  and myKVH_Permission_Set__r.myKVH_Role__r.Name = 'test_OrigRoleRec1 CLONED'];
		system.debug(PrmFlds2);
        system.assertEquals(5,PrmFlds2.size());			//All 5 Field Permissions....
        
        
        List<myKVH_Field_Permission__c> PrmFlds3 = 
        [select myKVH_Field_Permission__c.ID, name
		from myKVH_Field_Permission__c 
		where myKVH_Permission_Set__r.Name LIKE '%feature1'  and myKVH_Permission_Set__r.myKVH_Role__r.Name = 'test_OrigRoleRec1 CLONED'];
		system.debug(PrmFlds3);
        system.assertEquals(3, PrmFlds3.size());
        
        
        List<myKVH_Field_Permission__c> PrmFlds1 = 
        [select myKVH_Field_Permission__c.ID
		from myKVH_Field_Permission__c 
		where myKVH_Permission_Set__r.Name LIKE '%feature2'  and myKVH_Permission_Set__r.myKVH_Role__r.Name = 'test_OrigRoleRec1 CLONED'];
        system.assertEquals(2, PrmFlds1.size());
      
    }
    static testMethod void test_onLoadWithParams() {
    	//Instantiate a controller
		myKVH_Role_Clone_Engine ctrl = new myKVH_Role_Clone_Engine();	
		//create another page with params...
		PageReference testPage2 = Page.myKVH_Role_Cloning_Engine;
		Test.setCurrentPage(testPage2);
		apexPages.currentPage().getParameters().put('roleID', test_OrigRoleRec2.Id);
		system.debug(apexPages.currentPage().getParameters());
		ctrl.onLoad();
		system.assertEquals(0, apexPages.getMessages().size());	//there should be NO messages...
		string roleName = ctrl.getoriginalRole().Name;
		system.assertEquals('test_OrigRoleRec2', roleName);
		
    }
}