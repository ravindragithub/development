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
private class myKVH_my_cases_controller_test {
    static integer MAX_LOOP_COUNTER = 15;
    
    private static final Id myKVH_Feedback_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('myKVH Feedback').getRecordTypeId();
    
    private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
    private static final User portalUser = [SELECT Id, username FROM User WHERE Profile.Name LIKE 'Customer Portal - Read/Write%' AND isActive = true LIMIT 1];
    
    @testSetup
    static void setupTestData(){
        //need some cases for sure!
        //Probably contacts, too
        list<Case> caseList = new list<Case>();
        for (integer i = 0; i<MAX_LOOP_COUNTER; i++){
            Case c = new case();
            c.Subject = i + ' Test New Case';
            c.status = 'New';
            c.RecordTypeId = myKVH_Feedback_RECORD_TYPE_ID;
            caseList.add(c);
        }
        for (integer i = 0; i<MAX_LOOP_COUNTER; i++){
            Case c = new case();
            c.Subject = i + ' Test Closed Case';
            c.status = 'Closed';
            c.RecordTypeId = myKVH_Feedback_RECORD_TYPE_ID;
            caseList.add(c);
        }
        for (integer i = 0; i<MAX_LOOP_COUNTER; i++){
            Case c = new case();
            c.Subject = i + ' Test In Progress Case';
            c.status = 'In Progress';
            c.RecordTypeId = myKVH_Feedback_RECORD_TYPE_ID;
            caseList.add(c);
        }
        insert caseList;
        //add a custom settings record...
        PortalProductServiceRecordTypeMap__c s = new PortalProductServiceRecordTypeMap__c();
        s.RecordTypeId__c = myKVH_Feedback_RECORD_TYPE_ID;
        s.Name = 'myKVH Support and Feedback';
        s.Record_Type_Name__c = 'myKVH Feedback';
        insert s;
    }

    static testMethod void testDataSetup() {
        list<Case> readList = new list<Case>();
        readList = [SELECT Id, CaseNumber FROM Case];
        system.assertEquals(MAX_LOOP_COUNTER*3, readList.size());
        //see SF known issue https://success.salesforce.com/issues_view?id=a1p30000000T0tvAAC
        /*readList.clear();
        readList = [SELECT Id, Subject, LastViewedDate FROM Case WHERE Subject LIKE '%Test In Progress Case'];
        system.assertEquals(MAX_LOOP_COUNTER, readList.size());
        for (integer i = 0; i<MAX_LOOP_COUNTER; i++){
            system.assertNotEquals(null, readList[i].LastViewedDate);
        }*/
    }
    
    static testMethod void testConstructor1(){
        test.startTest();
        myKVH_my_cases_controller util = new myKVH_my_cases_controller();
        List<SelectOption> filters = util.getItems();
        system.assertEquals(3, filters.size());
        list<Case> casesList = new list<Case>();
        Integer integ = util.pageHeight();
        casesList = util.getCaseList();                                 //This should be the default list view... "Open"
        //system.assertEquals(MAX_LOOP_COUNTER*2, util.fullCaseList.size());  //ALL the cases returned from the query...
        system.debug('Page size : ' + util.PageSize);
        if(MAX_LOOP_COUNTER*3 > util.PageSize){                         // if there are enough records for pagination...
            //system.assertEquals(true, util.hasNext);
        } else {
            system.assertEquals(false, util.hasNext);
        }
        system.assertEquals(false, util.hasPrevious);
        Decimal pageCount = (Decimal)MAX_LOOP_COUNTER*2/(Decimal)util.PageSize;
        system.debug('Decimal Page Count : ' + pageCount);
        Integer ipageCount = (Integer)pageCount.round(System.RoundingMode.CEILING);
        system.debug('Integer Page Count : ' + ipageCount);
       // system.assertEquals(ipageCount, util.getTotalPages());
        system.assertEquals('CaseNumber', util.sortField);              //default sort field for "Open"
        system.assertEquals('DESC NULLS LAST', util.sortDir);           //default sort direction for "Open"
        util.toggleSort();                                              //test toggle sort
        system.assertEquals('ASC NULLS FIRST', util.sortDir);
        system.assertEquals(1, util.pageNumber);
        util.pageSize = null;
        PageReference pageref = util.setRecsPerPage();
        system.assertEquals(null, pageref);
        test.stopTest();
    }
    
    
    static testMethod void testActivationCases(){
        test.startTest();
        list<Case> casesList = new list<Case>();
        myKVH_my_cases_controller util = new myKVH_my_cases_controller();
        util.sortField = null;
        util.sortDir = null;
        util.filter = 'Activations';                                                //get Activations cases
        util.refresh();
        casesList = util.getCaseList();
        system.assertEquals(0, casesList.size());                   //no activation cases
        test.stopTest();
    }

    static testMethod void testOpenCases(){
        test.startTest();
        list<Case> casesList = new list<Case>();
        myKVH_my_cases_controller util = new myKVH_my_cases_controller();
        util.sortField = null;
        util.sortDir = null;
        util.filter = 'open';                                               //get open cases
        util.refresh();
        casesList = util.getCaseList();
       // system.assertEquals(MAX_LOOP_COUNTER*2, util.fullCaseList.size());
        system.assertEquals('CaseNumber', util.sortField);                  //default sort field for "open"
        system.assertEquals('DESC NULLS LAST', util.sortDir);               //default sort direction for "open"
        test.stopTest();
    }

    static testMethod void testClosedCases(){
        test.startTest();
        list<Case> casesList = new list<Case>();
        myKVH_my_cases_controller util = new myKVH_my_cases_controller();
        util.sortField = null;
        util.sortDir = null;
        util.filter = 'closed';                                         //get closed cases
        util.refresh();
        casesList = util.getCaseList();
        //system.assertEquals(MAX_LOOP_COUNTER, util.fullCaseList.size());
        system.assertEquals('ClosedDate', util.sortField);              //default sort field for "closed"
        system.assertEquals('DESC NULLS LAST', util.sortDir);           //default sort direction for "closed"
        util.PageSize = null;
        util.setRecsPerPage();
        util.con.setPageSize(10);
        util.setRecsPerPage();
        system.assertEquals(10, util.PageSize);
        test.stopTest();
    }
    
    static testMethod void testNav(){
        test.startTest();
        myKVH_my_cases_controller util = new myKVH_my_cases_controller();
        util.first();
        util.last();
        util.next();
        util.previous();
        util.cancel();
        test.stopTest();
    }
}