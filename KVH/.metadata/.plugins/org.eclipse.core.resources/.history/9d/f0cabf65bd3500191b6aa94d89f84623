public with sharing class KVHUpdateServices {
    
    private final Beam__c b;
    public KVHUpdateServices(ApexPages.StandardController stdController) {
    this.b = (Beam__c)stdController.getRecord();
    }
    public PageReference autoRun() {
        String theId = ApexPages.currentPage().getParameters().get('id');
        if (theId == null) {
            // Display the Visualforce page's content if no Id is passed over
            return null;
        }
        system.debug('We are running the autoRun method of the KVHUpdateServices Class');
        //invoke any other apex Class(es) needed or actions to be taken...
        beam_to_beams_XML myBmXML = new beam_to_beams_XML();
        system.debug('Testing = ' + test.isRunningTest());
        myBmXML.Schedule_This();   
        
        // Redirect the user back to the original page
        PageReference pageRef = new PageReference('/' + theId);
        pageRef.setRedirect(true);
        return pageRef;
    }
}