({
  verifyVTID : function(component, event, helper) {
    console.log("verifying that Asset is a VTID");
    //TODO: Fire newState event rather than setting logPanel newMessage attribute (create method??)
    //var stateEvent =  component.getEvent("newState");
    //stateEvent.setParams({"stateChange" : "Searching",
    //                      "statusMessage" : "ACTION: verifying Asset is VTID"
    //                    });
    //stateEvent.fire();
    component.find("logPanel").set("v.newMessage", "ACTION: verifying Asset is VTID");
    var action = component.get("c.verifyAssetType");
    action.setParams({ recId : component.get("v.identifier") });
    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
      var state = response.getState();
      console.log(state);
      var statusList = [];
      if (component.isValid() && state === "SUCCESS") {
          var returnObj = response.getReturnValue();
          console.log(returnObj);
          //setup and fire COMPONENT Event
          var verifiedVTIDEvent =  component.getEvent("newState");
          verifiedVTIDEvent.setParams({"stateChange" : "Verified",
                                       "assetList" : returnObj.assetCollection,
                                       "statusMessage" : returnObj.statusMessage
                                      });
          verifiedVTIDEvent.fire();
          //console.log(statusItems);

      } else {
          console.log("Failed with state: " + state);
      }
    }),
    $A.enqueueAction(action);
  },
  getObjIdFromOSS : function(component, event, helper){
    console.log("collecting obj_id from OSS");
    //TODO: Fire newState event rather than setting logPanel newMessage attribute
    //var stateEvent =  component.getEvent("newState");
    //stateEvent.setParams({"stateChange" : "Searching",
    //                      "statusMessage" : "ACTION: collecting Terminal data from OSS"
    //                    });
    //stateEvent.fire();
    component.find("logPanel").set("v.newMessage", "ACTION: collecting Terminal data from OSS");
    var action = component.get("c.getTerminalFromOSS");
    action.setParams({"VTID" : component.get("v.identifier")});
    action.setCallback(this, function(response){
      var state = response.getState();
      console.log(state);
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        //setup and fire COMPONENT Event
        var myTerminal = returnObj.term;
        console.log(JSON.stringify(myTerminal));
        //update identifier
        component.set("v.terminal", myTerminal);
        console.log(JSON.stringify(component.get("v.terminal")));
        var verifiedVTIDEvent =  component.getEvent("newState");
        verifiedVTIDEvent.setParams({"stateChange" : "Rebuilding",
                                      "statusMessage" : returnObj.statusMessage
                                    });
        verifiedVTIDEvent.fire();

      } else {
          console.log("Failed with state: " + state);
      }
    }),
    $A.enqueueAction(action);
  },
  executeRebuild : function(component, event, helper){
    console.log("invoking Apex for Rebuild");
    var mapToSend = {};
    mapToSend["obj_id"] = component.get("v.terminal.obj_id");
    mapToSend["obj_revision"] = component.get("v.terminal.obj_revision");
    console.log(mapToSend);

    var action = component.get("c.rebuildTerminalInOSS");

    action.setParams({"termMap" : mapToSend});
    action.setCallback(this, function(response){
      var state = response.getState();
      console.log(state);
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        var rebuildCompleted =  component.getEvent("newState");
        rebuildCompleted.setParams({"stateChange" : "Rebuilt",
                                      "statusMessage" : returnObj.statusMessage
                                    });
        rebuildCompleted.fire();
    } else {
          console.log("Failed with state: " + state);
      }
    }),
    $A.enqueueAction(action);
  }
})