({
	doInit : function(component, event, helper) {
    console.log("Initializing...");
  },
  handleApplicationEvent : function(component, event, helper){
    console.log("Handling Application Event....");
    var asynchJob = event.getParam("jobId");
    component.set("v.jobId", asynchJob);
    component.set("v.jobResults", "Unknown");
    component.set("v.jobStatus", "Not Complete");
    helper.checkJobStatus(component, event, helper);
  },
  handleCmpEvent : function(component, event, helper){
    console.log("Event Handler invoked for: " + event.getName());
  },
  handleLocalEvent : function(component, event, helper){
    console.log("Event Handler invoked for: " + event.getName());
  }

})