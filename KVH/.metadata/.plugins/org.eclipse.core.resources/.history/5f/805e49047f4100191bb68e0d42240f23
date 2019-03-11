@isTest
private class KenCast_License_Trigger_Handler_test {

  static testMethod void test_InsertLicenseAsXML(){
    //verify that the trigger handler extracts the Site ID correctly
    system.debug(getXml());
    KenCast_License__c KCL = new KenCast_License__c();
    KCL.License_File__c = getXml();
    test.startTest();
    insert KCL;
    test.stopTest();
    KenCast_License__c KCLread = new KenCast_License__c();
    KCLread = [SELECT id, Site_ID__c, License_File__c, License_File_B64_Encoded__c
               FROM KenCast_License__c LIMIT 1];
    system.assertEquals(170612, KCLread.Site_ID__c);
    system.assert(String.isNotBlank(KCLread.License_File__c));
    system.assert(String.isNotBlank(KCLread.License_File_B64_Encoded__c));
  }

  static testMethod void test_InsertLicenseAsBase64(){
    //verify that the trigger handler extracts the Site ID correctly
    system.debug(getXml());
    KenCast_License__c KCL = new KenCast_License__c();
    KCL.License_File_B64_Encoded__c = getB64();
    test.startTest();
    insert KCL;
    test.stopTest();
    KenCast_License__c KCLread = new KenCast_License__c();
    KCLread = [SELECT id, Site_ID__c, License_File__c, License_File_B64_Encoded__c
               FROM KenCast_License__c LIMIT 1];
    system.assertEquals(170613, KCLread.Site_ID__c);
    system.assert(String.isNotBlank(KCLread.License_File__c));
    system.assert(String.isNotBlank(KCLread.License_File_B64_Encoded__c));
  }

  static testMethod void test_encodeAsBase64(){
    String inputString = 'Test Base 64 Encoding';
    KenCast_License_Trigger_Handler util = new KenCast_License_Trigger_Handler(true, 200);
    test.startTest();
    String outputString = util.encodeAsBase64(inputString);
    test.stopTest();
    system.assertEquals('VGVzdCBCYXNlIDY0IEVuY29kaW5n', outputString);
    //Known value, 'VGVzdCBCYXNlIDY0IEVuY29kaW5n' is a Base 64 represntation of
    //'Test Base 64 Encoding'
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