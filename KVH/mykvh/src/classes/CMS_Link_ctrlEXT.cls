public with sharing class CMS_Link_ctrlEXT {
    private final Asset cbx;
    // Constructor
    public CMS_Link_ctrlEXT(){
        
    }
    public PageReference autoRun() {
        //Be sure to launch this page in a new tab and use swserial as a parameter
        String swSerialNumber = ApexPages.currentPage().getParameters().get('swserial');
        if (swSerialNumber == null) {
            // Display the Visualforce page's content if no Id is passed over
            return null;
        }
        system.debug('We are running the autoRun method of CMS_Link_ctrlEXT Class');
        //invoke any other apex Class(es) needed or actions to be taken...
        //Collect the Password
        Security__c pw = [SELECT key__c FROM Security__c WHERE Name = 'CMS link' LIMIT 1];
        // Setup the page re-direct using basic authentication in the new tab.... 
        // CMS, "Production" instance
        PageReference pageRef = new PageReference('https://admin:'+pw.key__c+'@cms.commbox.com/index.php?r=allCbx/admin&AllCbx[swserial]='+swSerialNumber);
        pageRef.setRedirect(true);
        return pageRef;
    }
}