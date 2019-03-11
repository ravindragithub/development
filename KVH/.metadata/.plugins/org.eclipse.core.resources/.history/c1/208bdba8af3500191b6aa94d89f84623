({
	handleSubscriptionChange : function(component, event, helper){
    console.log("Handling Subscription Change...");
	},
  handleDiagnosticsChange : function(component, event, helper){
    console.log("Handling Diagnostics Change...");
    helper.helpShapingPolicyComparison(component, event, helper);
  },
  handleNothing : function(component, event, helper){
    alert("Nothing to do here....");
  },
  handleSubChange : function(component, event, helper){
    helper.helpUpdateOSSSubscriber(component, event, helper);
  },
  handleComponentEvent : function(component, event, helper){
    console.log("Event Handler invoked for: " + event.getName());
    var newState = event.getParam("stateChange");
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