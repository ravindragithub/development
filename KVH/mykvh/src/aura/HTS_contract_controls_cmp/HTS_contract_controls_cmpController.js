({
	doInit : function(component, event, helper) {
    console.log("Initializing...");
    component.set("v.state", "INIT");
    //Hide spinner...
    //var spinnerDiv = component.find("spinner_div");
    //$A.util.addClass(spinnerDiv, "hide");
    var debugDiv = component.find("debug_div");
    $A.util.addClass(debugDiv, "hide");
    helper.helpReadAllSubs(component, event, helper);
  },
  handleStateChange : function(component, event, helper){
    console.log("Handling State Change...");

  },
  handleSubscriptionsChange : function(component, event, helper){
    console.log("Handling Subscriptions List change...");
    helper.helpHandleSubsChanged(component, event, helper);
  },
  handleCmpEvent : function(component, event, helper){
    console.log("Event Handler invoked for: " + event.getName());
    var statusMessage = event.getParam("statusMessage");
    var assetReturned = event.getParam("terminal")
    var newState = event.getParam("stateChange");
    var priPlan = event.getParam("primaryPlan");
    var secPlan = event.getParam("secondaryPlan");
    var selRegion = event.getParam("newRegion");

    console.log("Contract Controls Component Handling Component Event: " + newState);

    //var spinnerDiv = component.find("spinner_div");

    switch(newState) {
      case "RESET": { //do Reset stuff
        //setup and fire APPLICATION Event
      } break;

      case "busy": {
        console.log("Busy, busy, busy....");
        //$A.util.removeClass(spinnerDiv, "hide");
      } break;

      case "done": {
        helper.helpReadAllSubs(component, event, helper);
        console.log("Done!");
        //$A.util.addClass(spinnerDiv, "hide");
      } break;
      
      default: {
        console.log("Unknown state....");
      }
    }
  }

})