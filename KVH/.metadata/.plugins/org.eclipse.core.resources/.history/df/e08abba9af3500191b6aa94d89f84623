({
  doInit : function(component, event, helper) {
    console.log("Initializing termStatus component....");
    //Determine if we even render the component, THEN kick off the actions.

    var VTID = component.get("v.search");
    var prod = component.get("v.prodCode");
    if(typeof VTID !== "undefined" && VTID !== "" && prod == "Virtual Terminal ID"){
      console.log("Non-empty terminal Id found: " + VTID + " based on: " + prod);
      helper.lookupVTID(component, event, helper);
      component.set("v.showComponent", "true");
      console.log(component.get("v.showComponent"));
    }
  },
  handleFoundVTID : function(component, event, helper){
    console.log("Handling found VTID event....");
    var eventMap = event.getParam("VTIDmap");
    console.log(eventMap);
    if(eventMap["asset_id"].substring(0,3) == "02i" ){
      component.set("v.inSalesforce", "TRUE");
    } else {
      component.set("v.inSalesforce", "FALSE");
    }
    console.log(eventMap["obj_id"]);
    if(eventMap["obj_id"].substring(0,6) != "ERROR:" ){
      component.set("v.inNetwork", "TRUE");
    } else {
      component.set("v.inNetwork", "FALSE");
    }
    console.log(eventMap["configTemplate"]);
    if(eventMap["configTemplate"].substring(0,6) != "ERROR:" ){
      component.set("v.configTemplate", eventMap["configTemplate"]);
    } 
    //Check for obj_id, and if present callout for terminal Status  configTemplate
    if(!eventMap["obj_id"].includes("ERROR:")){ //negative logic!
      console.log("Did not Find 'Error:' in obj_id.value....");
      var obj_id_from_event = eventMap["obj_id"]
      console.log(obj_id_from_event);
      helper.getTerminalStatus(component, obj_id_from_event);
      //Create the action
      var action = component.get("c.getSubscriberFromOSS");
      console.log("Getting Subscriber details from OSS...");
      action.setParams({"VTID" : component.get("v.search")});
      //Add callback
      action.setCallback(this, function(response){
        var state = response.getState();
        console.log(state);
        
        if (component.isValid() && state === "SUCCESS") {
          var returnObj = response.getReturnValue();
          component.set("v.subsList", returnObj);
          //console.log(statusItems);
        } else {
          console.log("Failed with state: " + state);
        }
        
      });
      // Send action off to be executed
      $A.enqueueAction(action);
    }
  }


})