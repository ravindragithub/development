({
    doInit : function(component, event, helper) {
        helper.getSubscriptionRecords(component);
    },
    handleChangeSubscriptionEvent : function(component, event, helper) {
        var className1 = event.getParam("className1");
        var className2 = event.getParam("className2");
        var listSubscriptionRecord = event.getParam("listSubscriptionRecord");
        console.log(listSubscriptionRecord);
        if(typeof listSubscriptionRecord != 'undefined' )
        {
            helper.getSubscriptionRecords(component);
        }
        helper.toggleClassInverse(component,'backdrop',className1);
        helper.toggleClassInverse(component,'modaldialog',className2);
    },
    handleCheckTask : function(component, event, helper) {
        var index = event.getSource().get("v.text");  
        var subscriptionRec = component.get("v.listSubscription")[index];
        component.set("v.subscriptionRecord",subscriptionRec);
        helper.toggleClass(component,'backdrop','slds-backdrop--');
            helper.toggleClass(component,'modaldialog','slds-fade-in-');    
    },
    returnToCase : function(component) {
        var caseId = component.get("v.caseId");
        window.location.assign('/'+caseId);
    },
})