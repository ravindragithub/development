/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest()
private class CCDS_BaseHelper_Test{

    static testMethod void GetAuthenticationByType_Test()
    {     
        CCDS_Inventory.Authentication ia1 = (CCDS_Inventory.Authentication)CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Inventory').Value__c);
        System.assert(ia1 != null);
        
        CCDS_Entity.Authentication ia2 = (CCDS_Entity.Authentication)CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Entity').Value__c);
        System.assert(ia2 != null);
        
        CCDS_Customer.Authentication ia3 = (CCDS_Customer.Authentication)CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Customer').Value__c);
        System.assert(ia3 != null);
        
        CCDS_Corporate.Authentication ia4 = (CCDS_Corporate.Authentication)CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Corporate').Value__c);
        System.assert(ia4 != null);
    }
    
    static testMethod void GetWebtopValue_Test()
    {        
        String result = String.valueOf(CCDS_BaseHelper.GetWebtopValue('CCDS_Billing_Cycle__c', 'Active'));
        System.assertEquals(result, 'A');
    }
    
    static testMethod void GetEnvironmentType_Test()
    {       
        Integer temp = CCDS_BaseHelper.GetEnvironmentType();
        System.assert(temp != null);
    }
    
    @testSetup static void GenerateCustomSettings_Test()
    {
        List<Global_Variable__c> customSettings = new List<Global_Variable__c>();  
        //create a list of the Custom Settings so we can insert all at once
        //this approach helps to avoid governor limits.
                                            
        Global_Variable__c setting = new Global_Variable__c();
        //create a single Custom Setting that we will re-use over and over....
          
        /* Setup Custom Settings fields here.... */
        //first one.... set the name
        setting.name = 'Webtop_Application'; 
        //set the value...
        setting.Value__c = 'Salesforce';
        //add to the list. (lather, rinse, repeat....)
        customSettings.add(setting); 
        
        //reset
        //clear out the single instance variable
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_ClientInitials';                   
        setting.Value__c = 'K93'; 
        customSettings.add(setting);
        
        //reset
        //clear out the single instance variable
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_CustomerUpdate_Failure';
        setting.Value__c = 'The customer could not be updated in Webtop';
        customSettings.add(setting); 
        
        //reset
        //clear out the single instance variable
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_CustomerUpdate_Success';
        setting.Value__c = 'The customer was updated successfully in Webtop';
        customSettings.add(setting); 
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_Environment';
        setting.Value__c = '2';
        customSettings.add(setting); 

        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_Category_AcctFields';
        setting.Value__c = '18';
        customSettings.add(setting); 
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_SubCat_AccountID';
        setting.Value__c = '48';
        customSettings.add(setting); 
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_SubCat_SalesRep1';
        setting.Value__c = '49';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_SubCat_SalesRep2';
        setting.Value__c = '50';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_SubCat_EffDate';
        setting.Value__c = '51';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_SubCat_TermReason';
        setting.Value__c = '9';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_SubCat_VesselName';
        setting.Value__c = '10';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_OrderSource';
        setting.Value__c = 'WEB';
        customSettings.add(setting);
        
        /* Dont' need this anymore jthom 1/7/15
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_Password';
        setting.Value__c = '**************';
        customSettings.add(setting);
        */
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_ProspectCreate_Failure';
        setting.Value__c = 'The prospect could not be created in Webtop';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_ProspectCreate_Success';
        setting.Value__c = 'The prospect was created successfully in Webtop';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_Username';
        setting.Value__c = 'kvh.apiUser';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_Version';
        setting.Value__c = '9.3.1';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_WsdlType_Corporate';
        setting.Value__c = 'Corporate';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_WsdlType_Customer';
        setting.Value__c = 'Customer';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_WsdlType_Entity';
        setting.Value__c = 'Entity';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_WsdlType_Inventory';
        setting.Value__c = 'Inventory';
        customSettings.add(setting);
        
        // execute a single DML statement to insert all of the custom settings at once... */
        system.debug('ready to insert '+customSettings.size()+' Global Variable Custom Settings...');
        
        //this inserts the entire list
        insert customSettings;                            
        System.assert(customSettings != null);
        
        CCDS_Billing_Cycle__c bc = new CCDS_Billing_Cycle__c();
        bc.Name = 'CCDS_Billing_Cycle__c';
        bc.Label__c = 'Active';
        bc.Value__c = 'A';
        insert bc;
        System.assert(bc != null);
        
        CCDS_Bill_Type__c bt = new CCDS_Bill_Type__c();
        bt.Name = 'CCDS_Bill_Type__c';
        bt.Label__c = 'Mail';
        bt.Value__c = 'M';
        insert bt;
        System.assert(bt != null);
        
        CCDS_Sales_Office__c so = new CCDS_Sales_Office__c();  
        so.Name = 'CCDS_Sales_Office__c';
        so.Label__c = 'VSAT';
        so.Value__c = 28;
        insert so;
        System.assert(so != null);
                            
        CCDS_Sales_Region__c sr = new CCDS_Sales_Region__c();
        sr.Name = 'CCDS_Sales_Region__c';
        sr.Label__c = 'KU Satcom';
        sr.Value__c = 1;
        insert sr;
        System.assert(sr != null);
        
        CCDS_Sales_Rep__c rep = new CCDS_Sales_Rep__c();
        rep.Name = 'CCDS_Sales_Rep__c';
        rep.Label__c = 'MIAMI';
        rep.Value__c = 3;
        insert rep;
        System.assert(rep != null);
        
        //Need to create a Security__c sObject so that tests will pass....
        Security__c testSecure = new Security__c();
        testSecure.Name = 'CCDS';
        testSecure.Key__c = 'test_password';
        insert testSecure;
    }
    
}