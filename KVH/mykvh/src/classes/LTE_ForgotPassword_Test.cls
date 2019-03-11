@isTest(SeeAllData=true)
public class LTE_ForgotPassword_Test {

         static testMethod void testLTE_ForgotPassword() {
        // Instantiate a new controller with all parameters in the page
        LTE_ForgotPassword controller = new LTE_ForgotPassword();
        controller.username = 'test@salesforce.com';        
    
        System.assertEquals(controller.forgotPassword(),null); 
    }
    
    
}