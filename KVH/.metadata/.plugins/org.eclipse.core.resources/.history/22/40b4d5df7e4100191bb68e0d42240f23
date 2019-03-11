({
  doInit : function(component, event, helper) {
    console.log("initializing...");
    helper.helpDoInit(component, event, helper);

  },
  handleCmpEvent : function(component, event, helper){
    console.log("Handling Component Event...");    
    var spinnerDiv = component.find("spinner_div");
    var hierarchyDiv = component.find("hierarchy_div");
    var postDiv = component.find("post_div");
    var successDiv = component.find("success_div");
    var exceptionDiv = component.find("exception_div");
    var newState = event.getParam("state");
    console.log(newState);
    switch(newState){
      case "INIT": {
        helper.helpDoInit(component, event, helper);
      }
      break;

      case "ASSETS_CREATED": {
        $A.util.removeClass(postDiv, "hide");
        var assetList = event.getParam("lteDevices");
        component.set("v.lteDevices", assetList);
      }
      break;

      case "POST": {
        $A.util.removeClass(postDiv, "hide");
      }
      break;

      case "SUCCESS": {
        $A.util.addClass(postDiv, "hide");
        $A.util.removeClass(successDiv, "hide");
        var log = event.getParam("results");
        helper.helpGenerateURL(component);
        component.set("v.results", log);
      }
      break;

      case "ERROR": {
        $A.util.removeClass(exceptionDiv, "hide");
        var assetList = event.getParam("lteDevices");
        var message = event.getParam("results");
        component.set("v.lteDevices", assetList);
        component.set("v.results", message);
      }
      break;
    }
  }
})