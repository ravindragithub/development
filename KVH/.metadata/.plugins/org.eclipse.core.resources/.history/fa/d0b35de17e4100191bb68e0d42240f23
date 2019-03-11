({
    handlePlaceAvailableServiceEvent: function(component, event, helper) {
        var serviceNameTemp = event.getParam("serviceName");
       
        var serviceAvailableTemp = event.getParam("serviceAvailable");
        console.log('spotlight component==>'+serviceNameTemp,component.get("v.serviceName"));
        if (component.get("v.serviceName") === serviceNameTemp) {
            if (serviceAvailableTemp === true) {
                component.set("v.availableCheck", 'slds-show');
                helper.getImagelisthelper(component, event, helper);
            } else {
                component.set("v.availableCheck", 'slds-hide');
            }
        }
    }
})