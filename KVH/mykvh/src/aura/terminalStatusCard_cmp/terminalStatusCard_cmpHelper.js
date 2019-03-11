({
	getTerminalStatus : function(component, obj_id_from_event) {
        // Create the action
        console.log("Getting Terminal Status from OSS...");
        var action = component.get("c.getStatusbyId");
        console.log("Object ID passed from Controller: " + obj_id_from_event);
        action.setParams({
            "obj_id_string": obj_id_from_event
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            var statusList = [];
            if (component.isValid() && state === "SUCCESS") {
                var returnObj = response.getReturnValue();
                console.log("Success with state: " + returnObj);
                //var KVpairs = JSON.stringify(returnObj);
                for(key in returnObj){
                    statusList.push({ShortName: key, value: returnObj[key]});
                }
                $A.util.addClass(component.find("oss_spinner"), "slds-hide");
                component.set("v.statusItems", statusList);
                //console.log(statusItems);

            } else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
  }
})