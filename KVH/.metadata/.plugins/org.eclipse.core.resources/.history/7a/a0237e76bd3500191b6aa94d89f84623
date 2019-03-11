@isTest(SeeAllData=true) 
private class  SimpliCTIScrpopRuleManagerTest {   
    
    private static testMethod void testSearch() {
        
        // ANI to search on
        string ANI = '41009'; 
        // Create Contact
        Contact contact = new Contact();
        contact.FirstName = 'Test' + DateTime.now();
        contact.LastName = 'SimpliCTIScrpopRuleManagerTest';
        contact.phone = ANI;
        contact.mailingcountry = 'INDIA';    //added see case 407446
        insert contact; 
        try {
            // Test contact query method
            System.assert(SimpliCTIScrpopRuleManager.search('meta_cv9=+' + ANI).contains(ANI), 'Result should contain at least one contact with ANI');
            //System.assert(UpdatedSimpliCTIScrpopRuleManager.search('meta_cv9=+1' + ANI).contains(ANI), 'Result should contain at least one contact with ANI');
            //System.assert(UpdatedSimpliCTIScrpopRuleManager.search('meta_cv9=Oppertunity').contains(ANI), 'Result should contain at least one contact with ANI');
            //System.assert(UpdatedSimpliCTIScrpopRuleManager.search('meta_cv9=00001002').contains(ANI), 'Result should contain at least one contact with ANI');
            
            //SimpliCTIScrpopRuleManager.initSearch();
             SimpliCTIScrpopRuleManager.search(null);
            SimpliCTIScrpopRuleManager.search('meta_cv8=00001002');
            SimpliCTIScrpopRuleManager.search('meta_cv7=1234');
            SimpliCTIScrpopRuleManager.search('meta_cv6=41009');
            SimpliCTIScrpopRuleManager.search('meta_cv9=41009');
            SimpliCTIScrpopRuleManager.search('meta_cv1=Web');
            SimpliCTIScrpopRuleManager.search('meta_cv1="41009"');
            //SimpliCTIScrpopRuleManager.search('meta_cv1=22');
            //SimpliCTIScrpopRuleManager.search('meta_cv1=null');
            //SimpliCTIScrpopRuleManager.search('');
           
           
          
        
        } finally {
            // Delete Contact
            delete contact;
        }
    }
}