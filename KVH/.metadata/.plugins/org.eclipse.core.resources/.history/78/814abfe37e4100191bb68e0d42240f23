({
    createSubscription : function(component) {
        var oldSubscriptionOldData = component.get("v.oldSubscriptionRecord");
        var newSubscriptionData = component.get("v.newSubscriptionRecord");
        if(newSubscriptionData != null)
        {
            oldSubscriptionOldData.SBQQ__SubscriptionEndDate__c  = newSubscriptionData.SBQQ__SubscriptionStartDate__c ;
            oldSubscriptionOldData.Id = newSubscriptionData.Id;
            if(component.get("v.selectedProductId") != null)
                newSubscriptionData.SBQQ__Product__c = component.get("v.selectedProductId");
        }
        var action = component.get("c.createNewSubscription"); 
        action.setParams({
            newSubscriptionData : newSubscriptionData,
            oldSubscriptionOldData : oldSubscriptionOldData
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var compEvent = component.getEvent("oChangeSubsEvent");
                compEvent.setParams({className1: 'slds-backdrop--',className2: 'slds-fade-in-',listSubscriptionRecord : a.getReturnValue()});  
                compEvent.fire();
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }
        });
        $A.enqueueAction(action);
    }
})