public with sharing class ActivationsController {
    //Need to handle Activation of my System AND Activation on behalf of...
    //Page attributes
    Activation_Order__c newActivation = new Activation_Order__c();
    Activation_Status__c newActivationStatus = new Activation_Status__c();
    private String strCorporateOrderRecordTypelabel = 'Corporate Activation'; // can be get from custom setting
    private String strCustomerOrderRecordTypelabel = 'Customer Activation'; // can be get from custom setting
    
    // Click Handlers... 
    public pageReference selfActivation(){
        //Create a new Activation Order, and return that plus a self activation flag == true
        //then redirect to the Subscriber page
        return createNewActOrder(true);
    }
    public pageReference dealerActivation(){
        //Create a new Activation Order, and return that plus a self activation flag == false
        //then redirect to the Subscriber page
        return createNewActOrder(false);
    }
    
    public PageReference createNewActOrder(boolean selfActivation){
        PageReference returnPage = page.Account_Setup;                      //start building the page reference....
        
        String urlCaseID = ApexPages.currentPage().getparameters().get('CaseID');
        List<Activation_Order__c> findExistOrderForCase = New List<Activation_Order__c>();
        
        if(urlCaseID != null && urlCaseID !=''){
            newActivation.Activation_Type__c = 'Airtime Case Activation';
            newActivation.isSelf_Activation__c = false;
            newActivation.Case__c = urlCaseID;
            findExistOrderForCase = [SELECT id FROM Activation_Order__c WHERE Case__c=:urlCaseID];
            if(findExistOrderForCase.size()>0){
                newActivation.id = findExistOrderForCase[0].id;
                List<Activation_Status__c> lstActivationStatus = [SELECT Id FROM  Activation_Status__c WHERE Activation_Order__c =: newActivation.Id];
                if(lstActivationStatus.size() > 0) newActivationStatus.Id = lstActivationStatus[0].Id;
                newActivationStatus.Account_Setup_Active_Tab__c = 'Subscriber_Information';
            }
        }else if(selfActivation){                                             //set the self activation flag
            newActivation.Activation_Type__c = 'Self Activation';
            newActivation.isSelf_Activation__c = true;
            returnPage.getParameters().put('maincontactId',ApexPages.currentPage().getparameters().get('maincontactId'));
            returnPage.getParameters().put('SFAccountId',ApexPages.currentPage().getparameters().get('SFAccountId'));
            returnPage.getParameters().put('AccountId',ApexPages.currentPage().getparameters().get('AccountId')); 
        } else {
            newActivation.Activation_Type__c = 'Activation on behalf of Customer';
            newActivation.isSelf_Activation__c = false;
        }
        
        newActivation.User_Agent_String__c = ApexPages.currentPage().getHeaders().get('User-Agent');
        Id RECORD_TYPE_IDOrder = Schema.SObjectType.Activation_Order__c.getRecordTypeInfosByName().get('Customer Activation').getRecordTypeId();
        newActivation.RecordTypeId = RECORD_TYPE_IDOrder; 
        
        String strAccountType = ApexPages.currentPage().getParameters().get('accountType');
        if(strAccountType != null && strAccountType != ''){
            strAccountType = ('corporate'.equalsIgnoreCase( strAccountType ) ? strCorporateOrderRecordTypelabel  : strCustomerOrderRecordTypelabel);
            Id RECORD_TYPE_ID = Schema.SObjectType.Activation_Order__c.getRecordTypeInfosByName().get(strAccountType).getRecordTypeId();
            newActivation.RecordTypeId = RECORD_TYPE_ID; 
        }
        
        upsert newActivation;//add the new Activation to the database
        if(!(findExistOrderForCase.size()>0))
            newActivationStatus.Activation_Order__c = newActivation.Id;     //assoicate a new Status with the Order
        upsert newActivationStatus;                                     //insert that into the database
        
        returnPage.getParameters().put('order', newActivation.Id);      //add the order ID
        returnPage.setRedirect(true);                                   //set to redirect
        system.debug(returnPage.getUrl());
        return returnPage;                                              //return the page reference
    }
}