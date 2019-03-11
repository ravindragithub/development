/**
 * Created by Jai Chaturvedi on 12/03/2017.
 */
({
    handlePlaceAvailableServiceEvent: function(component, event, helper) {
        var serviceNameTemp = event.getParam("serviceName");
        var serviceAvailableTemp = event.getParam("serviceAvailable");
        if (component.get("v.serviceName") === serviceNameTemp) {
            if (serviceAvailableTemp === true) {
                component.set("v.availableCheck", 'slds-show');
            } else {
                component.set("v.availableCheck", 'slds-hide');
            }
        }
    }
})