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
private class serviceResults_test {
//setup testClass variables here. For example:
//RecordType Ids
private static final Id ServCloud_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
//A common Loop Counter for bulikification purposes
/*private static final integer MAX_LOOP_COUNTER = 200;*/
  
  @testSetup static void setupTestData(){
    //setup common test data here
  }
  
  static testMethod void test_constructor_0(){
    serviceResults sr = new serviceResults();
    system.assertEquals(sr.success, null);
    system.assertEquals(sr.message, null);
  }
  
  static testMethod void test_constructor_2() {
    serviceResults sr = new serviceResults(false, 'test message');
    system.assertEquals(sr.success,false);
    system.assertEquals(sr.message,'test message');
  }
  static testMethod void test_appendLog(){
    serviceResults sr = new serviceResults();
    sr.appendLog('EVENT', 'details');
    system.assert(sr.message.contains('EVENT'));
    system.assert(sr.message.contains('details'));
  }
  static testMethod void test_createCase(){
    serviceResults sr = new serviceResults();
    Exception ex = new NoDataFoundException();
    ex.setMessage('This is Bad');
    system.debug(ex.getCause());
    system.debug(ex.getLineNumber());
    system.debug(ex.getMessage());
    system.debug(ex.getStackTraceString());
    system.debug(ex.getTypeName());
    
    test.startTest();
    sr.createCase(ex);
    insert sr.srCase;   //Need to test that we CAN actually insert the Case....
    test.stopTest();
    Case c = [SELECT ID, Subject, Status, Origin, RecordTypeId FROM Case LIMIT 1];
    system.assertEquals(ServCloud_RECORD_TYPE_ID, c.RecordTypeId);
    system.assertEquals('This is Bad', c.Subject);
    system.assertEquals('System Generated', c.Origin);
    system.assertEquals('New', c.Status);
  }
  static testMethod void test_createExceptionCase(){
    Exception ex = new NoDataFoundException();
    ex.setMessage('This is Bad');
    system.debug(ex.getCause());
    system.debug(ex.getLineNumber());
    system.debug(ex.getMessage());
    system.debug(ex.getStackTraceString());
    system.debug(ex.getTypeName());
    
    test.startTest();
    Case exCase = serviceResults.createExceptionCase(ex);
    insert exCase;   //Need to test that we CAN actually insert the Case....
    test.stopTest();
    Case c = [SELECT ID, Subject, Status, Origin, RecordTypeId FROM Case LIMIT 1];
    system.assertEquals(ServCloud_RECORD_TYPE_ID, c.RecordTypeId);
    system.assertEquals('This is Bad', c.Subject);
    system.assertEquals('System Generated', c.Origin);
    system.assertEquals('New', c.Status);
  }
}