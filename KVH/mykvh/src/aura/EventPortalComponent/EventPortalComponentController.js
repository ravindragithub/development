({
    setPortalview: function(component, event, helper) {
        console.log('@@ in fetcheventlist'+event.getParam('selectedOption'));
        component.set("v.selectedportalview",event.getParam('selectedOption'));    
    },

    handlePlaceAvailableServiceEvent: function(component, event, helper) {
        console.log('in handlePlaceAvailableServiceEvent');
        console.log(event);
        var serviceNameTemp = event.getParam("serviceName");
        var serviceAvailableTemp = event.getParam("serviceAvailable");
       // console.log(serviceNameTemp,serviceAvailableTemp);
        if (component.get("v.serviceName") === serviceNameTemp || true) {
            if (serviceAvailableTemp === true) {
                component.set("v.availableCheck", 'slds-show');
                var emptyArray = [];
                component.set("v.eventlist",emptyArray);
                component.set("v.toptwoeventlist",emptyArray);
                helper.getEventlistHelper(component, event, helper);
            } else {
                component.set("v.availableCheck", 'slds-hide');
            }
        }
    },
    
    openpopup: function(component, event, helper) {
        console.log(component);
        component.set("v.showpopup", 'slds-show');       
    },
    closepopup: function(component, event, helper) {
        console.log(component);
        component.set("v.showpopup", 'slds-hide');       
    },
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    }
})