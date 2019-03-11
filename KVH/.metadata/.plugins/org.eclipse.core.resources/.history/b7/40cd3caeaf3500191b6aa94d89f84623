({
	doInit : function(component, event, helper) {
        var action = component.get("c.ToolKitLanding");
        action.setStorable(); //setting action as Storable to avoid server callout for page
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.salesKitList", response.getReturnValue());
                console.log('should work');
            } else if (state === "INCOMPLETE") {
                console.log('incomplete');
            } else if (state === "ERROR") {
				console.log('ERROR');
            }
        }) ;
        $A.enqueueAction(action);
        
        var appEvent = $A.get("e.c:SalesAidsUpdateCartEvent");  
        console.log(appEvent);
        appEvent.fire();
    },
    handlePortalViewChange : function(component, event, helper){
        var selectedOption = event.getParam("selectedOption");
        var action = component.get("c.portalChange");
        action.setParams({ portalView : selectedOption });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                document.location.href = './toolkitlanding';
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on handlePortalViewChange: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    handleSalesKitQuickLink : function(component, event, helper){
        console.log('listening');
        helper.showSpinner(component);
        var quickaction = event.getParam("quickaction");
        var action = component.get("c.buildToolKit");
        action.setParams({ toolKitName : quickaction });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.toolkit", true);
                component.set("v.products", result.products);
                component.set("v.documents", result.documents);
                component.set("v.toolkitname", quickaction);
                console.log('should work 2');
                helper.hideSpinner(component);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on toolkit click: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    showhidesection : function(component, event, helper) {
        var iconname = component.get("v.iconname");
        if(iconname == "chevron-right"){
            component.set("v.iconname","chevron-down");
            component.set("v.hidesection","slds-is-collapsed");
        }else{
            component.set("v.iconname","chevron-right");
            component.set("v.hidesection","slds-is-expanded");
        }
    }
 })