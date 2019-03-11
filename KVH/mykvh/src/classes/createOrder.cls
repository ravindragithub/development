public with sharing class createOrder {
    public Opportunity OpportunityObj;
    public createOrder(ApexPages.StandardController controller) {
        OpportunityObj = new Opportunity();
        OpportunityObj = (Opportunity) controller.getRecord();
        OpportunityObj  = [SELECT ID, IsWon FROM Opportunity WHERE ID =: OpportunityObj.Id  ];
        if(!OpportunityObj.IsWon) {
            Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.Info, 'Opportunity is not Close won. This will not create Order');
            Apexpages.addMessage(errorMessage);
          }
    }
    
    public pagereference createOrder() {
      OpportunityObj.invoiceit_crmx__Create_Order__c = true; 
      try { 
          
          if(OpportunityObj.IsWon) {
              update OpportunityObj; 
          }
          
          pagereference pg = new pagereference('/'+OpportunityObj.Id);
          return pg;
      } catch(exception ex) {
        Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.ERROR, 'An excepection has occurred ' + ex.getTypeName()+':'+ex.getMessage() + ':LINE ' + ex.getLineNumber());
        Apexpages.addMessage(errorMessage);
        
      }
        return null;
    }

}