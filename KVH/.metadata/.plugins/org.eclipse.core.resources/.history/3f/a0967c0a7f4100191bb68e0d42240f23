/*

	Name: PortalChangePasswordController
	Created By: Jason McCormack (GearsCRM)
	Created Date: 
	Description: 
    
	Modified By: 
	Modified Date: 
	Description: 

*/

public with sharing class PortalChangePasswordController 
{
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}        
    
    public PageReference changePassword() {
        return Site.changePassword(newPassword, verifyNewPassword, oldpassword);    
    }     
    
    public PortalChangePasswordController() {}
    
    public static testMethod void testPortalChangePasswordController() {
        // Instantiate a new controller with all parameters in the page
        PortalChangePasswordController controller = new PortalChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                
        
        System.assertEquals(controller.changePassword(),null);                           
    }    
}