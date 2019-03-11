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
private class CountryStateMethods_test {

    static testMethod void test_CountrySetup() {
		list<selectOption> readOptions = new list<selectOption>();		// we will reuse this...
		CountryStateMethods util = new CountryStateMethods(); 
		readOptions.clear();											//reset
		
		readOptions = util.setupCountryPicklist();
		system.assertEquals('Choose One', readOptions[0].getValue());	//test constructor values.
		system.assertEquals('Choose One', readOptions[0].getLabel());	//test constructor values.
		readOptions.clear();											//reset
		
		readOptions = util.setupCountryPicklist('US');
		system.assertNotEquals(1,readOptions.size());								//Should be a big list...
		system.assertEquals(readOptions[0].getValue(),'US');						//but with well known value at top
		//system.assertEquals(readOptions[0].getLabel(),util.CountryMap.get('US').TrimmedName__c);	//use lookup Map
		readOptions.clear();														//reset
		
		readOptions = util.setupStatesPicklist('NF');								//Norfolk Island! Who knew! Only ONE state!
		system.assert(readOptions.size() == 1 );									//Should be a list of one...
		system.assertEquals(readOptions[0].getValue(),'NSW');						//verify of first value/label in list
		system.assertEquals(readOptions[0].getLabel(),'NSW');						//verify of first value/label in list
		system.assertEquals(readOptions[0].getDisabled(), false);					//verify behaviour of ONE state in list
		
    }
    
    static testMethod void test_StatesSetup(){
    	list<selectOption> readOptions = new list<selectOption>();		// we will reuse this...
		CountryStateMethods util = new CountryStateMethods(); 
		readOptions.clear();											//reset
		
		readOptions = util.setupStatesPicklist();
		system.assertEquals(1, readOptions.size());
		system.assertEquals('Choose Country First', readOptions[0].getValue());	//test constructor values.
		system.assertEquals('Choose Country First', readOptions[0].getLabel());	//test constructor values.
		readOptions.clear();
		
		readOptions = util.setupStatesPicklist('US');
		system.assert(readOptions.size() >1);
		system.assertEquals('Choose One', readOptions[0].getValue());	//test constructor values.
		system.assertEquals('Choose One', readOptions[0].getLabel());	//test constructor values.
		readOptions.clear();
		
		readOptions = util.setupStatesPicklist('NF');								//Norfolk Island! Who knew! Only ONE state!
		system.assert(readOptions.size() == 1 );									//Should be a list of one...
		system.assertEquals(readOptions[0].getValue(),'NSW');						//verify of first value/label in list
		system.assertEquals(readOptions[0].getLabel(),'NSW');						//verify of first value/label in list
		system.assertEquals(readOptions[0].getDisabled(), false);					//verify behaviour of ONE state in list
		readOptions.clear();
		
		readOptions = util.setupStatesPicklist('AF');								//Norfolk Island! Who knew! Only ONE state!
		system.assert(readOptions.size() == 1 );									//Should be a list of one...
		system.assertEquals(readOptions[0].getValue(),'n/a');						//verify of first value/label in list
		system.assertEquals(readOptions[0].getLabel(),'n/a');						//verify of first value/label in list
		system.assertEquals(readOptions[0].getDisabled(), true);					//verify behaviour of ONE state in list
		readOptions.clear();
		
		readOptions = util.setupStatesPicklist('US', 'Rhode Island');
		system.assert(readOptions.size() >1);
		system.assertEquals('Rhode Island', readOptions[0].getValue());	//test constructor values.
		system.assertEquals('Rhode Island', readOptions[0].getLabel());	//test constructor values.
		readOptions.clear();
    }
    
    static testMethod void test_CountryChangeHandler(){
    	list<selectOption> readOptions = new list<selectOption>();		// we will reuse this...
		CountryStateMethods util = new CountryStateMethods(); 
		readOptions.clear();											//reset
		
		readOptions = util.CountryChangeHandler(null, null);
		system.assertEquals(1, readOptions.size());
		system.assertEquals('Choose Country First', readOptions[0].getValue());	//test constructor values.
		system.assertEquals('Choose Country First', readOptions[0].getLabel());	//test constructor values.
		readOptions.clear();
		
		readOptions = util.CountryChangeHandler('US', null);
		system.assert(readOptions.size() >1);
		system.assertEquals('Choose One', readOptions[0].getValue());	//test constructor values.
		system.assertEquals('Choose One', readOptions[0].getLabel());	//test constructor values.
		readOptions.clear();
		
		readOptions = util.CountryChangeHandler('US', 'Rhode Island');
		system.assert(readOptions.size() > 1);
		system.assertEquals('Rhode Island', readOptions[0].getValue());	//test constructor values.
		system.assertEquals('Rhode Island', readOptions[0].getLabel());	//test constructor values.
		readOptions.clear();
		
		readOptions = util.CountryChangeHandler('AF', 'Rhode Island');
		system.assert(readOptions.size() == 1 );									//Should be a list of one...
		system.assertEquals('n/a', readOptions[0].getValue());						//verify of first value/label in list
		system.assertEquals('n/a', readOptions[0].getLabel());						//verify of first value/label in list
		system.assertEquals(true, readOptions[0].getDisabled());					//verify behaviour of ONE state in list
		readOptions.clear();
		
		readOptions = util.CountryChangeHandler('AU', 'Rhode Island');
		system.assert(readOptions.size() > 1 );										//Should be a list of one...
		system.assertEquals('Choose One', readOptions[0].getValue());				//test constructor values.
		system.assertEquals('Choose One', readOptions[0].getLabel());				//test constructor values.
		system.assertEquals(false, readOptions[0].getDisabled());					//verify behaviour of ONE state in list
		readOptions.clear();
		
		readOptions = util.CountryChangeHandler('Choose One', 'Rhode Island');
		system.assert(readOptions.size() == 1 );										//Should be a list of one...
		system.assertEquals('Choose Country First', readOptions[0].getValue());				//test constructor values.
		system.assertEquals('Choose Country First', readOptions[0].getLabel());				//test constructor values.
		readOptions.clear();
		
		readOptions = util.CountryChangeHandler('US', 'Choose Country First');
		system.assert(readOptions.size() > 1 );										//Should be a list of one...
		system.assertEquals('Choose One', readOptions[0].getValue());				//test constructor values.
		system.assertEquals('Choose One', readOptions[0].getLabel());				//test constructor values.
		readOptions.clear();
		
		readOptions = util.CountryChangeHandler('Choose One', 'Choose Country First');
		system.assert(readOptions.size() == 1 );										//Should be a list of one...
		system.assertEquals('Choose Country First', readOptions[0].getValue());				//test constructor values.
		system.assertEquals('Choose Country First', readOptions[0].getLabel());				//test constructor values.
		readOptions.clear();
    }
    static testMethod void test_getNamedCountryMap(){
        map<string, KVH_Countries__mdt> readMap = new map<string, KVH_Countries__mdt>();
        CountryStateMethods util = new CountryStateMethods(); 
        readMap = util.getNamedCountryMap();
        KVH_Countries__mdt merica = new KVH_Countries__mdt();
        merica = readMap.get('United States');
        system.assertEquals('US', merica.IsoCode_2__c); 
        readMap.clear();
        Set<string> lstCountryISO = new Set<string>();
        lstCountryISO.add('US');
        readMap = util.buildCountryMap(lstCountryISO);
        merica = new KVH_Countries__mdt();
        merica = readMap.get('US');
        system.assertEquals('United States', merica.TrimmedName__c); 
    }
    static testMethod void test_getStateMap(){
        map<string, KVH_States__mdt> readMap = new map<string, KVH_States__mdt>();
        CountryStateMethods util = new CountryStateMethods(); 
        Set<string> lstCountryISO = new Set<string>();
        lstCountryISO.add('US');
        readMap = util.getStateMap(lstCountryISO);
        KVH_States__mdt RhodeIsland = new KVH_States__mdt();
        RhodeIsland = readMap.get('US@@RI');
        system.debug('RhodeIsland'+RhodeIsland);
        //system.assertEquals('RI', RhodeIsland.IsoCode__c); 
    }
    static testMethod void test_getNamedStateMap(){
        map<string, KVH_States__mdt> readMap = new map<string, KVH_States__mdt>();
        CountryStateMethods util = new CountryStateMethods(); 
        Set<string> lstCountryISO = new Set<string>();
        lstCountryISO.add('US');
        readMap = util.getNamedStateMap(lstCountryISO);
        KVH_States__mdt RhodeIsland = new KVH_States__mdt();
        RhodeIsland = readMap.get('US@@Rhode Island');
        system.assertEquals('US-RI', RhodeIsland.FullIsoCode__c);
    }
}