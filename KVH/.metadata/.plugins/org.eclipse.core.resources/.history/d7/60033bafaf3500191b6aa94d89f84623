({
	doInsert : function(component) {
        //setup and fire COMPONENT Event
        var insertingEvt = component.getEvent("cmpDataUpdated");
        insertingEvt.setParams({"stateChange" : "Inserting"});
        insertingEvt.fire();
        var action = component.get("c.insertSatRouter");
        //create string, string map
        action.setParams(
            {
                "cmp_values": {
                    "serialNumber": component.get("v.serialNumber"),
                    "provisioningKey": component.get("v.provisioningKey"),
                    "revision": component.get("v.revision")
                 }
             }
        );
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (component.isValid() && state === "SUCCESS") {
                var responseObj = response.getReturnValue();
                console.log(responseObj);
                //setup and fire COMPONENT Event
                var insertedEvt = component.getEvent("cmpDataUpdated");
                insertedEvt.setParams({"stateChange" : "InsertingDone",
                                       "assetList" : responseObj.assetCollection,
                                       "statusMessage" : responseObj.statusMessage
                                      });
                insertedEvt.fire();
                console.log("cmpDataUpdated Event Fired! " + insertedEvt.getParam("statusMessage"));
                //setup and fire APPLICATION Event
                var appEvent = $A.get("e.c:HTS_SatRouter_Application_evt");
                appEvent.setParams({"serialNumber": component.get("v.serialNumber"),
                                    "provisioningKey": component.get("v.provisioningKey"),
                                    "revision": component.get("v.revision")
                                   });
                appEvent.fire();
                console.log("Application Event Fired with: " +appEvent.getParam("serialNumber"));
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
	}
})