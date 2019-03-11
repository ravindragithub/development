@isTest
public class myKVHAddComment_Test {
    //get record ids for test cases
    private static final Id myKVH_Case_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airtime Service').getRecordTypeId();
	private static final Id DirectCust_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    
    @testSetup
	static void setupTestData(){
        Account testParent = new Account(Name = 'Add Comment Parent Account', RecordTypeId = DirectCust_RECORD_TYPE_ID);
		insert testParent;
        
        Case newCase = new Case();
        newCase.RecordTypeId = myKVH_Case_RECORD_TYPE_ID;
        newCase.Subject='1234';
        insert newCase;
    }
    static testMethod void testInsertAttachment(){
        Case testCase = [SELECT ID FROM Case WHERE Subject ='1234' LIMIT 1];
        ApexPages.StandardController stdCase= new ApexPages.StandardController(testCase);
		myKVHAddComment ext = new myKVHAddComment(stdCase);
		Attachment att = new Attachment();
        att.Body = Blob.valueOf('12654645');
        att.Name = 'test attach';
        ext.attach = att;
        ext.InsertAttachment(testCase.Id);
        List<Attachment> attach = [SELECT Name FROM Attachment WHERE ParentId =: testCase.Id];
        system.assertEquals(1, attach.size());
    }
    static testMethod void testSaveComment(){
        Case testCase = [SELECT ID FROM Case WHERE Subject ='1234' LIMIT 1];
        ApexPages.StandardController stdCase= new ApexPages.StandardController(testCase);
		myKVHAddComment ext = new myKVHAddComment(stdCase);
        ext.setbody('1234');
        string s = ext.getbody();
        ext.saveComment();
        List<CaseComment> ccs = [SELECT Id FROM CaseComment WHERE ParentId =: testCase.Id];
        system.assertEquals(1, ccs.size());
        system.assertEquals('1234', s);
    }
    static testMethod void testGoBack(){
        Case testCase = [SELECT ID FROM Case WHERE Subject ='1234' LIMIT 1];
        ApexPages.StandardController stdCase= new ApexPages.StandardController(testCase);
		myKVHAddComment ext = new myKVHAddComment(stdCase);
        PageReference pageref = ext.goback();
        system.assertEquals(testCase.Id, pageref.getParameters().get('recordid'));
    }

}