({
  checkJobStatus : function(component, event, helper) {
    console.log("invoking checkJobStatus helper method...");
    var jobStatus = component.get("v.jobStatus");
    var that = this;  //Allows us to re-invoke this action
    switch(jobStatus){
      case "Not Complete":{
        console.log("Asynch job not finished, checking...");
        //change the state...
        component.set("v.state", "Polling");
        // Create the action...
        var action = component.get("c.getAsynchStatusByObjId");
        action.setParams({"obj_id": component.get("v.jobId")});
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
          var state = response.getState();
          console.log(state);
          if (component.isValid() && state === "SUCCESS") {
            var returnedObj = response.getReturnValue();
            if(returnedObj.complete){
              //change the state...
              component.set("v.state", "Finished");
              //update the status.....
              component.set("v.jobStatus", "Complete"); 
              var jobStatus = component.find("jobStatus");
              //Hide the spinner...
              var spinnerDiv = component.find("spinner");
              $A.util.addClass(spinnerDiv, "hide");
              var stateDiv = component.find("state");
              $A.util.addClass(stateDiv, "hide");
              var cmpEvent = component.getEvent("cmpDataUpdated");
              cmpEvent.setParams({"stateChange": "asynchJobComplete"});
              cmpEvent.fire();
            } else {
              component.set("v.state", "Waiting");
              var jobStatus = component.find("jobStatus");
            }
            //update the results
            if(returnedObj.result != null){
              if(returnedObj.result){
                component.set("v.jobResults", "Success");
                var results = component.find("results");
                
              } else {
                component.set("v.jobResults", "Failed"); 
                var results = component.find("results");
                
              }
            } else {
              component.set("v.jobResults", "Unknown");
              var results = component.find("results");
              
            }
          } else {
            console.log("Failed with state: " + state);
          }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
        //re-invoke the action based on the timeout interval....
        var interval = component.get("v.pollingInterval");
        window.setTimeout(
          $A.getCallback(function() {
            console.log("re-checking...");
            that.checkJobStatus(component,event,helper);
          }), interval
        );
      } break;

      case "Complete":{
        //alert("Complete");
      } break;
      
      case "Unknown":{
        alert("Unknown");
      } break;

      
      case "Not Found!":{
        alert("Not Found!");
      } break;
    }
  }
})