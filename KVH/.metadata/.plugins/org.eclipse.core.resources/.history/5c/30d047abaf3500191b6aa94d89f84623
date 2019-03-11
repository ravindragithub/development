({
	doInit : function(component, event, helper) {
    console.log("Initializing LTE_post_devices.cmp");
    //fire off init event...
    var spinnerDiv = component.find("spinner_div");
    $A.util.addClass(spinnerDiv, "hide");
  },
  postDevice : function(component, event, helper) {
    console.log("POSTing device to OSS");
    var compEvent = component.getEvent("svcCLassEvent");
    compEvent.setParams({"state" : "POST"});
    compEvent.fire();
  },
  handleCmpEvent : function(component, event, helper){
    console.log("Handling Component Event: " + event.getName());    
    var spinnerDiv = component.find("spinner_div");
    var actionDiv = component.find("action_div");

    var newState = event.getParam("state");
    console.log(newState);
    switch(newState){
      case "INIT": {
        $A.util.addClass(spinnerDiv, "hide");
      }
      break;

      case "POST": {
        component.set("v.disablePOST", true);
        $A.util.removeClass(spinnerDiv, "hide");
        helper.helpPostLTEDeviceToOSS(component, event, helper);
      }
      break;

      case "SUCCESS": {
        $A.util.addClass(spinnerDiv, "hide");
        var log = event.getParam("results");
        component.set("v.results", log);
      }
      break;

      case "ERROR": {
        $A.util.addClass(spinnerDiv, "hide");
        var log = event.getParam("results");
        component.set("v.results", log);
      }
      break;
    }
  }
})