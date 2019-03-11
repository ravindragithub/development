public with sharing class KenCast_License_Trigger_Handler {
  private boolean m_isExecuting = false;
  private integer BatchSize = 0;
  public static boolean firstBeforeRun = true; //prevent recursion....
  public static boolean firstAfterRun = true;
  public static string UserName = '';
  //Constructor
  public KenCast_License_Trigger_Handler(boolean isExecuting, Integer size){
    m_isExecuting = isExecuting;
    BatchSize = size;
    UserName = UserInfo.getName();
  }
  
  public void OnBeforeInsert(KenCast_License__c[] newLicenses){
    // EXECUTE BEFORE INSERT LOGIC
    //Need to parse out the <SiteID Value="##########"/> Attribute from the License file(s)...
    //Convert to integer...
    //Store as KenCast_License__c.Site_Id__c
    String StatusMSG;
    String SiteIDValue;
    //easy!
    for (KenCast_License__c KL : newLicenses){
      //License Loader application is no longer available....
      //Need to handle manual inserts mostly
      if ( String.isBlank(KL.License_File__c) && String.isNotBlank(kl.License_File_B64_Encoded__c) ) {
        KL.License_File__c = EncodingUtil.base64Decode(KL.License_File_B64_Encoded__c).toString();
      } else if(String.isNotBlank(KL.License_File__c) && String.isBlank(kl.License_File_B64_Encoded__c) ){
        KL.License_File_B64_Encoded__c = encodeAsBase64(KL.License_File__c);
      }
      StatusMSG = '';
      SiteIDValue = '';
      DOM.Document KLfile = new Dom.Document();

      KLfile.load(KL.License_File__c);
      StatusMSG = 'Document Loaded... ';
      //Retrieve the root element for this document 
      Dom.XMLNode RootTag = KLfile.getRootElement();
      StatusMSG = StatusMSG + 'Root Element Found... ';
      system.debug(RootTag);    //Root
      Dom.XMLNode LicenseData = RootTag.getChildElement('LicenseData',null);
      StatusMSG = StatusMSG + 'License Data Found... ';
      system.debug(LicenseData);  //Level 1
      Dom.XMLNode SiteID = LicenseData.getChildElement('SiteID',null);
      StatusMSG = StatusMSG + 'Site ID Found... ';
      system.debug(SiteID);
      system.debug(SiteID.getAttributeCount());
      system.debug(SiteID.getAttribute('Value',null));
      SiteIDValue = SiteID.getAttribute('Value',null);
      StatusMSG = StatusMSG + SiteIDValue;
      KL.Site_ID__c = double.ValueOf(SiteIDValue);
      StatusMSG = StatusMSG + ' String to Double Conversion OK!';
      system.debug(StatusMSG);
    }
  }

  @testVisible private String encodeAsBase64(String inputString){
    String outputString = 'Failed to encode!';  //pessimistic initialization
    Blob myBlob = Blob.valueof(inputString);
    outputString = EncodingUtil.base64Encode(myBlob);
    return outputString;
  }
}