@isTest(SeeAllData = true)
private class LTE_LightningLoginFormController_test {
/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Tests for LTE_LightningLoginFormController
*
* Derived from Salesforce generated Class
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         John Thompson   <jthompson@kvh.com@kvh.com>
* @modifiedBy     Modifier   <modifier@kvh.com>
* @maintainedBy   Maintainer   <maintainer@kvh.com>
* @version        1.0
* @created        2018-May-22
* @modified       YYYY-MM-DD
* @systemLayer    Invocation | Service | Utility | Selector | Domain | Test
* @see            ????
* @see            ????
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0            jthompson@kvh.com@kvh.com
* 2018-May-22      Explanation of the change.  Multiple lines can be used to explain the change
*
* vX.X            author@kvh.com
* YYYY-MM-DD      Each change to this file should be documented by incrementing the version number,
*                 and adding a new entry to this @changes list. Note that there is a single blank
*                 line between each @changes entry.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

  @IsTest
  static void testLoginWithInvalidCredentials() {
    System.assertEquals('Argument 1 cannot be null', LTE_LightningLoginFormController.login('testUser', 'fakepwd', null));
  }

  @IsTest
  static void LightningLoginFormControllerInstantiation() {
    LTE_LightningLoginFormController controller = new LTE_LightningLoginFormController();
    System.assertNotEquals(controller, null);
  }

  @IsTest
  static void testIsUsernamePasswordEnabled() {
    System.assertEquals(true, LTE_LightningLoginFormController.getIsUsernamePasswordEnabled());
  }

  @IsTest
  static void testIsSelfRegistrationEnabled() {
    System.assertEquals(false, LTE_LightningLoginFormController.getIsSelfRegistrationEnabled());
  }

  @IsTest
  static void testGetSelfRegistrationURL() {
    System.assertEquals(null, LTE_LightningLoginFormController.getSelfRegistrationUrl());
  }

  @IsTest
  static void testAuthConfig() {
    Auth.AuthConfiguration authConfig = LTE_LightningLoginFormController.getAuthConfig();
    System.assertNotEquals(null, authConfig);
  }
}