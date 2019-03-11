/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class PortalForgotPasswordController {
    public String username {get; set;}   
              
    public PortalForgotPasswordController() {}
    
    public PageReference forgotPassword() {
        boolean success = Site.forgotPassword(username);

        PageReference pr = Page.PortalForgotPasswordConfirm;
        pr.setRedirect(true);
        
        if (success) {              
            return pr;            
        }
        
        return null;
    }
        
     @IsTest(SeeAllData=true) public static void testPortalForgotPasswordController() {
        // Instantiate a new controller with all parameters in the page
        PortalForgotPasswordController controller = new PortalForgotPasswordController();
        controller.username = 'test@salesforce.com';        
    
        System.assertEquals(controller.forgotPassword(),null); 
    }
}