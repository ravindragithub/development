/****************************************************
    Name        :    myKVH_Case_ViewCtrl_Test
    Description :    test class for my_Case_ViewPartnerCtrl
*****************************************************/
@isTest
private class myKVH_Case_ViewCtrl_Test{
    static testMethod void unittest(){
        Id portalCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Partner Portal').getRecordTypeId();
        Case newCase = new Case();
        newCase.recordTypeId = portalCaseRecordTypeId;
       
       
        newCase.Description = 'Testding';
        newCase.subject = '"My Profile" Email Update Request from ';
        
        
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.useDefaultRule= true;
        newCase.setOptions(dmlOpts); 
        newCase.Origin = 'Web';
        insert newCase;
        
        new myKVH_Case_ViewCtrl(new Apexpages.standardController(newCase));
    }
}