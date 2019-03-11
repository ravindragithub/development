({
  handleFoundVTID : function(component, event, helper) {
    console.log("Event Handler invoked!");
    var eventMap = event.getParam("VTIDmap");
    var mapItems = [];
    for(key in eventMap) {
      console.log(key + " => " + eventMap[key]);
      //mapItems.push({value: key + " => " + eventMap[key]});
      mapItems.push({key: key, value: eventMap[key]});
    }
    $A.util.addClass(component.find("vtid_spinner"), "slds-hide");
    component.set("v.identifiers", mapItems);
    //Check for obj_id, and if present callout for terminal Status
    if(!eventMap["obj_id"].includes("ERROR:")){ //negative logic!
      console.log("Did not Find 'Error:' in obj_id.value....");
      var obj_id_from_event = eventMap["obj_id"]
      console.log(obj_id_from_event);
      helper.getTerminalStatus(component, obj_id_from_event);
    }
    //initiate search for subscribers
    var searchCmp = component.find("lookup");
    var searchTid = searchCmp.get("v.search");
    console.log(searchTid);
    //Create the action
    var action = component.get("c.getSubscriberFromOSS");
    console.log("Getting Subscriber details from OSS...");
    action.setParams({"VTID" : searchTid});
    //Add callback
    action.setCallback(this, function(response){
      var state = response.getState();
      console.log(state);
      
      if (component.isValid() && state === "SUCCESS") {
          var returnObj = response.getReturnValue();
          $A.util.addClass(component.find("subs_spinner"), "slds-hide");
          component.set("v.subsList", returnObj);
          //console.log(statusItems);
      } else {
          console.log("Failed with state: " + state);
      }
      
    });
    // Send action off to be executed
    $A.enqueueAction(action);
  },
  handleSearching : function(component, event, helper){

    component.set("v.identifiers", null);
    component.set("v.statusItems", null);
    component.set("v.subsList", null);
    $A.util.removeClass(component.find("vtid_spinner"), "slds-hide");
    $A.util.removeClass(component.find("oss_spinner"), "slds-hide");
    $A.util.removeClass(component.find("subs_spinner"), "slds-hide");
  }
})