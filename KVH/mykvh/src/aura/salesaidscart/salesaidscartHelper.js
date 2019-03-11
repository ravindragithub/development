({
	fetchCartInfo : function(component, event, helper) {
		var action = component.get("c.getSaleAidsCart");
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.cartObj",response.getReturnValue());               
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on handleAvailableServiceEvent: " +errors[0].message);
                    }
                } else {
                    console.log("Unknown error handleAvailableServiceEvent");
                }
            }
        });
        $A.enqueueAction(action);
	},
    deleteLineItem : function(component, event, helper,itemId) {
		var action = component.get("c.deleteLineItem");
        var cartObj = component.get("v.cartObj");
        action.setParams({
            "itemId" : itemId,
            "salesCartJson" : JSON.stringify(cartObj)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.cartObj",response.getReturnValue());
                //fire update cart event to update the cart count
                var appEvent = $A.get("e.c:SalesAidsUpdateCartEvent");  
                console.log(appEvent);
                appEvent.fire(); 
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on handleAvailableServiceEvent: " +errors[0].message);
                    }
                } else {
                    console.log("Unknown error handleAvailableServiceEvent");
                }
            }
        });
        $A.enqueueAction(action);
	},
    submitOrder : function(component, event, helper) {
		var action = component.get("c.submitOrder");
        var cartObj = component.get("v.cartObj");
        action.setParams({           
            "salesCartJson" : JSON.stringify(cartObj)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {               
                component.set("v.cartObj",response.getReturnValue());
                if(response.getReturnValue().isError == false){
                    component.set("v.orderplaced",true);
                    //fire update cart event to update the cart count
                    var appEvent = $A.get("e.c:SalesAidsUpdateCartEvent");                    
                    appEvent.fire();
                }                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on handleAvailableServiceEvent: " +errors[0].message);
                    }
                } else {
                    console.log("Unknown error handleAvailableServiceEvent");
                }
            }
        });
        $A.enqueueAction(action);
	},
    updateLineItem : function(component, event, helper,lineItem) {
		var action = component.get("c.updateLineItem");
        var cartObj = component.get("v.cartObj");
        action.setParams({
            "lineItemJson" : JSON.stringify(lineItem),
            "salesCartJson" : JSON.stringify(cartObj)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.cartObj",response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on handleAvailableServiceEvent: " +errors[0].message);
                    }
                } else {
                    console.log("Unknown error handleAvailableServiceEvent");
                }
            }
        });
        $A.enqueueAction(action);
	}
})