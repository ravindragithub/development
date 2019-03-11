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
private class Act_Dealer_component_controller_test {
    
    @testSetup static void setupTestData(){
    
        Activation_Order__c testActOrder = new Activation_Order__c();
        testActOrder.isSelf_Activation__c = true;
        testActOrder.User_Agent_String__c = 'test User-Agent string';
        testActOrder.Activation_Type__c = 'Activation on behalf of Customer';
        insert testActOrder;
        
        Activation_Status__c testOrderStatus = new Activation_Status__c();
        testOrderStatus.Activation_Order__c = testActOrder.Id;
        insert testOrderStatus;
        
    }
    
    static testMethod void testConstructor(){
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference testPage = page.Account_Setup;        
        testPage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(testPage);
        Act_Dealer_component_controller util = new Act_Dealer_component_controller();
        util.ActOrderId = (string)ActOrder.Id;
        util.componentStateChangeHandlerBilling();
        system.assertEquals(ActOrder.Id, util.Dealer.Activation_Order__c);
    }
    
    static testMethod void testConstructor2(){
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Dealer__c insertDealer = new Activation_Dealer__c();
        Activation_Status__c readStatus = [SELECT Id, Account_Setup_Active_Tab__c FROM Activation_Status__c LIMIT 1];
        insertDealer.Activation_Order__c = (string)ActOrder.Id;
        insertDealer.Contact_Email__c = 'actwiz.dealer@act.wiz';
        insert insertDealer;
        PageReference testPage = page.Account_Setup;        
        testPage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(testPage);
        test.startTest();
        
        Act_Dealer_component_controller util = new Act_Dealer_component_controller();
        util.ActOrderId = (string)ActOrder.Id;
        system.assertEquals(ActOrder.Id, util.Dealer.Activation_Order__c);
        system.assertEquals('actwiz.dealer@act.wiz', util.Dealer.Contact_Email__c);
        // pass selected tab
        util.selectedTab = 'Invoicing_Preferences';
        util.actStatus = readStatus;
        // Check Dealer to upsert
        util.save();
        util.SaveSaveAndExit();
        readStatus = [SELECT Id, Account_Setup_Active_Tab__c FROM Activation_Status__c LIMIT 1];
       // system.assertEquals('Invoicing_Preferences', readStatus.Account_Setup_Active_Tab__c);
        test.stopTest();
        
    }
    
    static testMethod void testSave(){
        Activation_Order__c readOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Status__c readStatus = [SELECT Id, Account_Setup_Active_Tab__c FROM Activation_Status__c LIMIT 1];
        PageReference testPage = page.Account_Setup;        
        testPage.getParameters().put('order', readOrder.Id);
        Test.setCurrentPage(testPage);
        Act_Dealer_component_controller util = new Act_Dealer_component_controller();
        util.ActOrderId = (string)readOrder.Id;
        util.actStatus = readStatus;
        system.assertEquals(readOrder.Id, util.Dealer.Activation_Order__c);
        //setup dealer
        util.Dealer.Contact_Email__c = 'actwiz.dealer@act.wiz';
        upsert util.Dealer;
        util.selectedTab = 'System_Type';
        
        pageReference destinationPage = util.Save();
        system.assertEquals(readOrder.Id, destinationPage.getParameters().get('order'));
        system.assert(destinationPage.getRedirect());
        Activation_Dealer__c readDealer = [SELECT Id, Contact_Email__c 
                                        FROM Activation_Dealer__c
                                        WHERE Activation_Order__c =: readOrder.Id
                                        LIMIT 1];
        system.assertEquals('actwiz.dealer@act.wiz', readDealer.Contact_Email__c);
        readStatus = [SELECT Id, Account_Setup_Active_Tab__c FROM Activation_Status__c LIMIT 1];
        //system.assertEquals('System_Type', readStatus.Account_Setup_Active_Tab__c);
    }
    
    static testMethod void testBack(){
        Activation_Order__c readOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Status__c readStatus = [SELECT Id, Account_Setup_Active_Tab__c FROM Activation_Status__c LIMIT 1];
        PageReference testPage = page.Account_Setup;        
        testPage.getParameters().put('order', readOrder.Id);
        Test.setCurrentPage(testPage);
        Act_Dealer_component_controller util = new Act_Dealer_component_controller();
        util.parentContainer = 'Dummy Container';
        util.ActOrderId = (string)readOrder.Id;
        util.actStatus = readStatus;
        system.assertEquals(readOrder.Id, util.Dealer.Activation_Order__c);
        //setup navigation
        util.selectedTab = 'test_tab_name_back';
        
        pageReference destinationPage = util.Back();
        system.assertEquals(readOrder.Id, destinationPage.getParameters().get('order'));
        system.assert(destinationPage.getRedirect());
        readStatus = [SELECT Id, Account_Setup_Active_Tab__c FROM Activation_Status__c LIMIT 1];
        system.assertEquals('test_tab_name_back', readStatus.Account_Setup_Active_Tab__c);
    }
    
}