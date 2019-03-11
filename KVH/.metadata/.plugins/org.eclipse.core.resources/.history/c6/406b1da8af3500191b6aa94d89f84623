({
  doInit : function(component, event, helper) {
    //Hide spinner...
    var spinnerDiv = component.find("spinner_div");
    $A.util.addClass(spinnerDiv, "hide");
    var mySub = component.get("v.singleSub");
    if(mySub.SBQQ__Product__r == undefined){
      console.log("mySub is undefined!");
      return;
    }
    if(mySub.SBQQ__Product__r.HTS_Subscriber_Plan__c != null){
      component.set("v.type", "custom:custom61");
    }
  },
  invokeStaticIpService : function(component, event, helper){
    if (confirm('This will create a new Subscription and Provision the Static IP \n Do you wish to proceed?')) {
      console.log("affirmative response");  // Go Baby, GO!
      helper.helperSetupStatic(component, event, helper);
    } else {
      console.log("negative response");
      // Do nothing!
    }
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

    var spinnerDiv = component.find("spinner_div");

    switch(newState) {
      case "RESET": { //do Reset stuff
        //setup and fire APPLICATION Event
      } break;

      case "busy": {
        console.log("Busy, busy, busy....");
        $A.util.removeClass(spinnerDiv, "hide");
      } break;

      case "done": {
        console.log("Done!");
        $A.util.addClass(spinnerDiv, "hide");
      } break;
      
      default: {
        console.log("Unknown state....");
      }
    }
  }
})