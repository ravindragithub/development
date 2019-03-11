/**
 * Created by Jai Chaturvedi on 13/03/2017.
 */
({
    handlePlaceAvailableServiceEvent: function(component, event, helper) {
        var serviceNameTemp = event.getParam("serviceName");
        console.log('@@ serviceNameTemp==>'+serviceNameTemp);
        var serviceAvailableTemp = event.getParam("serviceAvailable");
        var kvhUserRole = event.getParam("kvhUserRole");
        var videourl = component.get("v.videourl");
        if(serviceNameTemp == 'Mini-Vsat Manager' && kvhUserRole == undefined){
            component.set("v.url",videourl);
        }
        console.log("@@ kvhUserRole==>"+kvhUserRole);
        var logonames = component.get("v.logonames");
        if(logonames != undefined){
            var logolst = logonames.split(',');
            component.set("v.images",logolst);
            
        }
        if (component.get("v.serviceName") === serviceNameTemp) 
            if (serviceAvailableTemp === true) {
                component.set("v.availableCheck", 'slds-show-custom ');
                
            } else {
                component.set("v.availableCheck", 'slds-hide-custom');
            }
        }
    },

    redirect : function (component) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            url: component.get("v.url"),
            isredirect: true
        });
        urlEvent.fire();
    }
}
)