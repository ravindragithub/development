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
private class myKVH_Case_Comments_Test {
	static integer MAX_LOOP_COUNTER = 15;
	
	private static final Id myKVH_Feedback_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('myKVH Feedback').getRecordTypeId();
	
	@testSetup
	static void setupTestData(){
		//need a case and some comments...
		Case c = new case();
		c.Subject = 'Test New Case for Component';
		c.status = 'New';
		c.RecordTypeId = myKVH_Feedback_RECORD_TYPE_ID;
		insert c;
		
		list<CaseComment> caseCommentList = new list<CaseComment>();
		for (integer i = 0; i<MAX_LOOP_COUNTER; i++){
			CaseComment cComm = new CaseComment();
			cComm.parentId = c.Id;
			cComm.CommentBody = 'Comment Number ' + i;
			cComm.isPublished = true;
			caseCommentList.add(cComm);
		}
		insert caseCommentList;
	}

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        case readCase = [SELECT Id, Subject, CaseNumber FROM Case LIMIT 1];
        system.assertEquals('Test New Case for Component', readCase.Subject);
        myKVH_Case_Comments ccc = new myKVH_Case_Comments();
        ccc.setcaseId(readCase.Id);
        system.assertEquals(readCase.Id, ccc.getcaseId());
        list<CaseComment> cCommList = ccc.getcComments();
        system.assertEquals(MAX_LOOP_COUNTER, cCommList.size());
    }
	

}