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
private class testKenCast_License_Trigger {

	static testMethod void myUnitTest() {
		// TO DO: implement unit test
		//verify that the trigger handler extracts the Site ID correctly
		system.debug(getXml());
		KenCast_License__c KCL = new KenCast_License__c();
		KCL.License_File__c = getXml();
		insert KCL;
		KenCast_License__c KCLread = new KenCast_License__c();
		KCLread = [SELECT id, Site_ID__c FROM KenCast_License__c LIMIT 1];
		system.assertEquals(170612, KCLread.Site_ID__c);
		delete KCLread;
		//Verify that the trigger handler decodes a Base 64 blob, and extracts the Site ID correctly
		system.debug(getB64());
		KenCast_License__c KCL2 = new KenCast_License__c();
		KCL2.License_File_B64_Encoded__c = getB64();
		insert KCL2;
		KenCast_License__c KCLread2 = new KenCast_License__c();
		KCLread2 = [SELECT id, Site_ID__c, License_File__c, License_File_B64_Encoded__c 
					FROM KenCast_License__c LIMIT 1];
		system.assertEquals(170613, KCLread2.Site_ID__c);
		system.assert(String.isNotBlank(KCLread2.License_File__c));
		}
		
	static String getXml() {
		string mockKCLicense = '<FazztLicense version="1.0">'+
		'<LicenseData>'+
		'<!-- WARNING: DO NOT MODIFY THIS FILE. Modifying this file will invalidate your license. -->'+
		'<!-- You may use this file on ONE COMPUTER ONLY. -->'+
		'<Customer Value="KVH Industries, Inc."/>'+
		'<CustomerID Value="52789"/>'+
		'<LicenseID Value="3CBCB952-0912-4114-98C3-1ECC80123236"/>'+
		'<Created Value="2013-10-24"/>'+
		'<Product Value="Fazzt Professional Client 8.2"/>'+
		'<ProductCode Value="33"/>'+
		'<Evaluation Value="TRUE"/>'+
		'<StartDate Value="2013-10-24"/>'+
		'<StopDate Value="2014-03-31"/>'+
		'<VersionMajor Value="8"/>'+
		'<VersionMinor Value="2"/>'+
		'<RxChannelTypes Value="IP,TCP"/>'+
		'<ChannelLC Value="9,33"/>'+
		'<NetworkID Value="52789"/>'+
		'<SiteID Value="170612"/>'+
		'<EULA><![CDATA[ I like CDATA ]]></EULA>'+
		'</LicenseData>'+
		'<LicenseKey>x</LicenseKey>'+
		'</FazztLicense>';
		return mockKCLicense;
	}
	
	static String getB64() {
		string mockKCLicense2 = '<FazztLicense version="1.0">'+
		'<LicenseData>'+
		'<!-- WARNING: DO NOT MODIFY THIS FILE. Modifying this file will invalidate your license. -->'+
		'<!-- You may use this file on ONE COMPUTER ONLY. -->'+
		'<Customer Value="KVH Industries, Inc."/>'+
		'<CustomerID Value="52789"/>'+
		'<LicenseID Value="3CBCB952-0912-4114-98C3-1ECC80123236"/>'+
		'<Created Value="2013-10-24"/>'+
		'<Product Value="Fazzt Professional Client 8.2"/>'+
		'<ProductCode Value="33"/>'+
		'<Evaluation Value="TRUE"/>'+
		'<StartDate Value="2013-10-24"/>'+
		'<StopDate Value="2014-03-31"/>'+
		'<VersionMajor Value="8"/>'+
		'<VersionMinor Value="2"/>'+
		'<RxChannelTypes Value="IP,TCP"/>'+
		'<ChannelLC Value="9,33"/>'+
		'<NetworkID Value="52789"/>'+
		'<SiteID Value="170613"/>'+
		'<EULA><![CDATA[ I like CDATA ]]></EULA>'+
		'</LicenseData>'+
		'<LicenseKey>x</LicenseKey>'+
		'</FazztLicense>';
		string b64LicenseContents = EncodingUtil.base64Encode(Blob.valueOf(mockKCLicense2));
		return b64LicenseContents;
	}

}