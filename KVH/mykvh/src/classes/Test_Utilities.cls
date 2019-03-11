@isTest //(SeeAllData=true)
public class Test_Utilities {

                                                              
    public static TestMethod void testUtilities_getPicklistValues(){
        Test.startTest();
        List<String> loadOptions = Utilities.getPicklistValues('Quote_Request__c','Salutation__c');
        Test.stopTest();
        System.assertEquals(19, loadOptions.size());
    }
          
}