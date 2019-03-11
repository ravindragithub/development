@isTest
public class PartnerRegistrationController_test {
    private static final Id PartnerPortal_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Partner Portal').getRecordTypeId();
	private static final Id DP_RECORD_TYPE_ID = Schema.SObjectType.Partner_Portal_Access_Request__c.getRecordTypeInfosByName().get('Direct Partner').getRecordTypeId();
	private static final Id IP_RECORD_TYPE_ID = Schema.SObjectType.Partner_Portal_Access_Request__c.getRecordTypeInfosByName().get('Indirect Partner').getRecordTypeId();
    private static final Id T_RECORD_TYPE_ID = Schema.SObjectType.Partner_Portal_Access_Request__c.getRecordTypeInfosByName().get('Technician').getRecordTypeId();
    
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	
	@testSetup
	static void setupTestData(){

		User tu = new User();
		tu = [SELECT Id FROM User WHERE Name = 'KVH Partner Portal Site Guest User' LIMIT 1];
        Partner_Portal_Access_Request__c ppa = new Partner_Portal_Access_Request__c();
        ppa.Company_Name__c = 'KVH';
        ppa.Contact_Email__c = 'kvh123@kvh.com';
        ppa.Bank_Name__c = '1234';
        ppa.Company_State__c = 'RI';
        ppa.Credit_State__c = 'RI';
        ppa.Willing_to_Travel__c = 'Yes';
        ppa.Servicing_Other_Companies__c = true;
        ppa.Is_Main_Contact__c = true;
        ppa.Auth_for_Service_Questions__c = true;
        ppa.Training_Needed__c = true;
        ppa.Stock_Service_Parts__c = true;
        ppa.Service_All_KVH_Customers__c = true;
        ppa.RecordTypeId = DP_RECORD_TYPE_ID;
        insert ppa;
        Partner_Prospect_Address__c ppa1 = new Partner_Prospect_Address__c();
        ppa1.Country__c = 'United States';
        ppa1.State__c = 'MA';
        ppa1.Partner_Portal_Access_Request__c = ppa.Id;
        insert ppa1;
    }
    static testMethod void testController(){
        User u = new User();
		u = [SELECT Id FROM User WHERE Name = 'KVH Partner Portal Site Guest User' LIMIT 1];
        Partner_Portal_Access_Request__c req = [SELECT Id, Name FROM Partner_Portal_Access_Request__c WHERE Company_Name__c = 'KVH'];
        req.First_Name__c = 'John';
		test.startTest();
		System.runas(u){
			PageReference pageRef = Page.PartnerRegistration;
            pageref.getParameters().put('id', req.id);
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController stdreq= new ApexPages.StandardController(req);
			PartnerRegistrationController ext = new PartnerRegistrationController(stdreq);
            system.assertEquals(true, ext.render3);
        }    
    }
    static testMethod void testtech(){
    	User u = new User();
		u = [SELECT Id FROM User WHERE Name = 'KVH Partner Portal Site Guest User' LIMIT 1];
        Partner_Portal_Access_Request__c req = new Partner_Portal_Access_Request__c();
        req.First_Name__c = 'John';
		test.startTest();
		System.runas(u){
			PageReference pageRef = Page.PartnerRegistration;
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController stdreq= new ApexPages.StandardController(req);
			PartnerRegistrationController ext = new PartnerRegistrationController(stdreq);
            ext.country = 'Choose One';
            pageref = ext.savetech();
            system.assertEquals(null, pageref);
            ext.country = 'AU';
            ext.state = 'Choose One';
            pageref = ext.savetech();
            system.assertEquals(null, pageref);
            ext.state = 'RI';
			pageref = ext.savetech();
			system.assertEquals('/PartnerRegThanks', pageref.getUrl().Left(45));
		}
		test.stopTest();
		list<Partner_Portal_Access_Request__c> testppar = [SELECT Id FROM Partner_Portal_Access_Request__c WHERE Company_Country__c = 'AU'];
		system.debug(testppar);
		system.assertEquals(1, testppar.size());
    }
    static testMethod void testupdate(){
    	User u = new User();
		u = [SELECT Id FROM User WHERE Name = 'KVH Partner Portal Site Guest User' LIMIT 1];
        Partner_Portal_Access_Request__c req = new Partner_Portal_Access_Request__c();
        req.First_Name__c = 'John';
        insert req;
		test.startTest();
		System.runas(u){
			PageReference pageRef = Page.PartnerCreditApp;
            pageref.getParameters().put('id', req.id);
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController stdreq= new ApexPages.StandardController(req);
			PartnerRegistrationController ext = new PartnerRegistrationController(stdreq);
            ext.locname = 'location';
            ext.creditcountry = 'Choose One';
			pageref = ext.updateppac();
            system.assertEquals(null, pageref);
            ext.creditcountry = 'Italy';
            ext.creditstate = 'Choose One';
            pageref = ext.updateppac();
            system.assertEquals(null, pageref);
            ext.creditstate = 'RI';
            ext.bankcountry = 'Choose One';
            pageref = ext.updateppac();
            system.assertEquals(null, pageref);
            ext.bankcountry = 'Italy';
            ext.CompanyName = null;
            pageref = ext.updateppac();
            system.assertEquals(null, pageref);
            ext.addcountry = 'Choose One';
            pageref = ext.updateppac();
            system.assertEquals(null, pageref);
            pageref = ext.addLocation();
            system.assertEquals(null, pageref);
            ext.addcountry = 'US';
            ext.addstate = 'RI';
            pageref = ext.addLocation();
            system.assertEquals(null, pageref);
            ext.addcountry = 'US';
            ext.addstate = 'RI';
            ext.add1 = '123';
            pageref = ext.addLocation();
            system.assertEquals(1, ext.addresses.size());
            ext.addcountry = 'AU';
            ext.addstate = 'Choose One';
            pageref = ext.updateppac();
            system.assertEquals(1, ext.addresses.size());
            pageref = ext.backtoreg();
            system.assertEquals(req.Id, pageref.getUrl().Right(18));
            ext.CompanyName = '123';
            pageref = ext.updateppac();
			system.assertEquals('/PartnerRegThanks', pageref.getUrl().Left(31));
		}
		test.stopTest();
		list<Partner_Portal_Access_Request__c> testppar = [SELECT Id FROM Partner_Portal_Access_Request__c WHERE First_Name__c = 'John'];
        list<Partner_Prospect_Address__c> testppa = [SELECT Id FROM Partner_Prospect_Address__c WHERE Location_Name__c = 'location'];
		system.assertEquals(1, testppar.size());
        system.assertEquals(1, testppa.size());
    }
    static testMethod void testsavenew(){
    	User u = new User();
		u = [SELECT Id FROM User WHERE Name = 'KVH Partner Portal Site Guest User' LIMIT 1];
        Partner_Portal_Access_Request__c req = new Partner_Portal_Access_Request__c();
        req.First_Name__c = 'John';
		test.startTest();
		System.runas(u){
			PageReference pageRef = Page.PartnerRegIndirect;
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController stdreq= new ApexPages.StandardController(req);
			PartnerRegistrationController ext = new PartnerRegistrationController(stdreq);
            ext.country = 'Choose One';
            pageref = ext.savenewrecord();
            system.assertEquals(null, pageref);
            ext.country = 'AU';
            ext.state = 'Choose One';
            pageref = ext.savenewrecord();
            system.assertEquals(null, pageref);
            ext.state = 'RI';
            ext.mc = 'No';
            pageref = ext.render1set();
            system.assertEquals(ext.render1, true);
            ext.mc = 'Yes';
            pageref = ext.render1set();
            system.assertEquals(ext.render1, false);
            ext.distr = 'No';
            pageref = ext.render2set();
            system.assertEquals(ext.render2, false);
            ext.distr = 'Yes';
            pageref = ext.render2set();
            system.assertEquals(ext.render2, true);
            ext.servicequestion = 'Yes';
            pageref = ext.render3set();
            system.assertEquals(ext.render3, true);
            ext.servicequestion = 'No';
            pageref = ext.render3set();
            system.assertEquals(ext.render3, false);
            ext.currentservice = 'Yes';
            pageref = ext.render5set();
            system.assertEquals(ext.render5, true);
            ext.currentservice = 'No';
            pageref = ext.render5set();
            system.assertEquals(ext.render5, false);
            ext.travel = 'Yes';
            pageref = ext.render6set();
            system.assertEquals(ext.render6, true);
            ext.travel = 'No';
            pageref = ext.render6set();
            system.assertEquals(ext.render6, false);
            ext.applater = true;
            pageref = ext.render7set();
            system.assertEquals(ext.render7, true);
            ext.applater = false;
            pageref = ext.render7set();
            system.assertEquals(ext.render7, false);
            ext.dbaCheck = true;
            pageref = ext.dbaset();
            system.assertEquals(ext.dba, null);
            ext.dbaCheck = false;
            pageref = ext.dbaset();
            system.assertEquals(ext.dba, null);
            Decimal integ = ext.getinteg();
            system.assertEquals(integ, 1);
			pageref = ext.savenewrecord();
			system.assertEquals('/PartnerRegThanks', pageref.getUrl().Left(45));
		}
		test.stopTest();
		list<Partner_Portal_Access_Request__c> testppar = [SELECT Id FROM Partner_Portal_Access_Request__c WHERE Company_Country__c = 'AU'];
		system.debug(testppar);
		system.assertEquals(1, testppar.size());
    }
    static testMethod void testsavecont(){
    	User u = new User();
		u = [SELECT Id FROM User WHERE Name = 'KVH Partner Portal Site Guest User' LIMIT 1];
        Partner_Portal_Access_Request__c req = new Partner_Portal_Access_Request__c();
        req.First_Name__c = 'John';
		test.startTest();
		System.runas(u){
			PageReference pageRef = Page.PartnerRegIndirect;
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController stdreq= new ApexPages.StandardController(req);
			PartnerRegistrationController ext = new PartnerRegistrationController(stdreq);
            list<SelectOption> opts = new list <SelectOption>();
            opts = ext.getCountriesList();
            ext.componentCountryChangeHandlerBilling();
            opts = ext.getaddCountriesList();
            ext.componentaddCountryChangeHandlerBilling();
            opts = ext.getbankCountriesList();
            opts = ext.getcredCountriesList();
            ext.componentCreditCountryChangeHandlerBilling();
            opts = ext.getStatesList();
            opts = ext.getaddStatesList();
            opts = ext.getcredStatesList();
            ext.country = 'Choose One';
            ext.allcust = 'Yes';
            ext.stock = 'Yes';
            ext.training = 'Yes';
			pageref = ext.saveNewRecordCont();
            system.assertEquals(null, pageref);
            ext.country = 'AU';
            ext.state = 'Choose One';
            pageref = ext.saveNewRecordCont();
            system.assertEquals(null, pageref);
            ext.state = null;
            pageref = ext.saveNewRecordCont();
            req = [SELECT Id FROM Partner_Portal_Access_Request__c WHERE First_Name__c = 'John'];
            pageref.getParameters().put('id', req.Id);
            Test.setCurrentPage(pageRef);
            pageref = ext.saveNewRecordCont();
			system.assertEquals('/PartnerCreditApp?id=', pageref.getUrl().Left(21));
            
		}
		test.stopTest();
    }
    static testMethod void testcase(){
    	User u = new User();
		u = [SELECT Id FROM User WHERE Name = 'KVH Partner Portal Site Guest User' LIMIT 1];
        Partner_Portal_Access_Request__c req = new Partner_Portal_Access_Request__c();
        req.First_Name__c = 'JohnJohnJohnJohnJohnJohnJohnJohnJohnJohnJohn';
		test.startTest();
		System.runas(u){
			PageReference pageRef = Page.PartnerRegIndirect;
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController stdreq= new ApexPages.StandardController(req);
			PartnerRegistrationController ext = new PartnerRegistrationController(stdreq);
            ext.country = 'AU';
            ext.forcreation = null;
            ext.state = 'abcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcd';
			pageref = ext.saveNewRecord();
		}
		test.stopTest();
        List <Case> testing = [SELECT Id FROM Case WHERE RecordType.Name = 'Partner Portal'];
        system.assertEquals(testing.size(), 1);
    }
}