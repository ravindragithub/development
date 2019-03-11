({
    closeModal : function(component, event, helper) 
    {
        var compEvent = component.getEvent("oChangeSubsEvent");
        compEvent.setParams({className1: 'slds-backdrop--',className2: 'slds-fade-in-'});  
        compEvent.fire();
    },
    submitSubscription : function(component, event, helper) 
    {
        helper.createSubscription(component);
    },
    handleComponentEvent : function(component, event, helper) 
    { 
        var selectedAccountGetFromEvent = event.getParam("productByEvent");
        component.set("v.selectedProductId" , selectedAccountGetFromEvent.Id);
    }
})