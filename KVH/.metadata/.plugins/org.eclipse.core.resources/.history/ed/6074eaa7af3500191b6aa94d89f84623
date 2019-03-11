({
  createAssets : function(component, event, helper) {
    //TODO: Move to helper...
		var insertEvent = component.getEvent("cmpDataUpdated");
        insertEvent.setParam("stateChange", "Inserting");
        insertEvent.fire();
        console.log("Component Event Fired! " + insertEvent.getParam("stateChange"));

		var action = component.get("c.createTerminal");
		var serNumMap = {};
		serNumMap["satRouter"] = component.get("v.satRouter");
		serNumMap["MTAMAC"] = component.get("v.MTAMAC");
		serNumMap["swSerialNumber"] = component.get("v.swSerialNumber");
		serNumMap["adminIP"] = component.get("v.adminIP");
		serNumMap["systemSerialNumber"] = component.get("v.systemSerialNumber");
		action.setParams({"mfgSerialNumbers": serNumMap});
		action.setCallback(this, function(response) {
      var state = response.getState();
      console.log(state);
      if (component.isValid() && state === "SUCCESS") {
        var returnedObj = response.getReturnValue();
        var statusString = returnedObj.statusMessage;
        console.log("Status Message: " + statusString );
        var insertEvent = component.getEvent("cmpDataUpdated");
        insertEvent.setParams({"stateChange" : "Inserted",
                               "assetList" : returnedObj.assetCollection,
                               "statusMessage" : returnedObj.statusMessage,
                               "listLength" : returnedObj.assetCollection.length});
        insertEvent.fire();
        //setup and fire APPLICATION Event
        var appEvent = $A.get("e.c:HTS_terminals_application_evt");
        appEvent.setParams({"assetList" : returnedObj.assetCollection,
                            "statusMessage" : returnedObj.statusMessage,
                            "searchString" : component.get("v.systemSerialNumber"),
        "systemSerialNumber" : component.get("v.satRouter"),
        "adminIP" : component.get("v.adminIP"),
        "swSerialNumber" : component.get("v.swSerialNumber"),
        "MTAMAC" : component.get("v.MTAMAC"),
        "satRouter" : component.get("v.satRouter")});
        console.log(appEvent.getParam("statusMessage"));
        appEvent.fire();
        console.log("Application Event Fired with: " +appEvent.getParam("statusMessage") );
      } else {
        console.log("Failed with state: " + state);
      }
    });
    $A.enqueueAction(action);
  }
})