/**
* @createdby        :   Teertha prasad
* @createddate      :   12/09/2016
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   06/23/2017
* @description      :   Class Used In Activation_ThankYou Page
**/

Public Class Activation_ThankYou_Controller extends ActivationsBaseController{
    
    public String strCaseId {get; set;}
    public String strCaseNumber {get; set;}
    public String strEmailId {get; set;}
    public Boolean BoolDealerOrNot {get; set;}
    public Boolean isAirtimeActivationCase {get;set;}
    
    public Activation_ThankYou_Controller(){
        BoolDealerOrNot = false;
        strEmailId = '';
        ActivationOrderId = ApexPages.currentPage().getParameters().get('order');
        ActivationStatus = readActivationStatus(ActivationOrderId);
        List<Activation_Order__c> lstActivationOrder = New List<Activation_Order__c>();
        lstActivationOrder= [SELECT Id,Case__c,CreatedById,Activation_Type__c,Case__r.CaseNumber,Activation_Opportunity__c,
                             (SELECT Id,Contact__c, Contact__r.Email, Subscriber_Email__c FROM Activation_Subscribers__r)
                             FROM Activation_Order__c 
                             WHERE Id=:ActivationOrderId LIMIT 1];
        
        if(lstActivationOrder.size()>0){
            BoolDealerOrNot = (lstActivationOrder[0].CreatedById == Userinfo.getUserId() && lstActivationOrder[0].Activation_Type__c == 'Activation on behalf of Customer') ? true : false;
            strCaseId = lstActivationOrder[0].Case__c != null ? lstActivationOrder[0].Case__c : '';
            strCaseNumber = lstActivationOrder[0].Case__c != null ? lstActivationOrder[0].Case__r.CaseNumber : '';
            isAirtimeActivationCase = lstActivationOrder[0].Activation_Type__c == 'Airtime Case Activation';
            for(Activation_Subscriber__c objActivationAccount : lstActivationOrder[0].Activation_Subscribers__r){
                strEmailId = objActivationAccount.Subscriber_Email__c;
            } 
        }
    }
}