({
	doInit : function(component, event, helper) {
    var terminalId = component.get("v.VTID");
    if(terminalId != null){
      window.setTimeout(  //Need to delay first job status call a few seconds
        $A.getCallback(function(){
          helper.checkJobStatus(component,event,helper);
        }), 5000
      );
      component.set("v.asynchTerm", null);
    }
  },
  manualCheck : function(component,event,helper){
    helper.checkJobStatus(component,event,helper);
  },
  handleStateChange : function(component, event, helper){
    console.log("Handling State Change...");

    var newState = event.getParam("newState");

    var spinnerDiv = component.find("spinner_div");
    var formDiv = component.find("form_div");

    console.log("Component Handling Event: " + newState);
    switch(newState){
      case "Checking":
        {//show spinner
          console.log("show spinner");
          $A.util.removeClass(spinnerDiv, "slds-hide");
        }
        break;
      
      case "Checked":
        {//hide spinner
          console.log("hide spinner");
          $A.util.addClass(spinnerDiv, "slds-hide");
        }
        break;
    }
  }
})