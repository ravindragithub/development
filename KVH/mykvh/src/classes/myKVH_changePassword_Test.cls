@isTest
public class myKVH_changePassword_Test {
    
    static testMethod void testLTE_ChangePassword() {
        // Instantiate a new controller with all parameters in the page
        myKVH_changePassword controller = new myKVH_changePassword();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                
        
        System.assertEquals(controller.changePassword(),null);                           
    }    
    
}