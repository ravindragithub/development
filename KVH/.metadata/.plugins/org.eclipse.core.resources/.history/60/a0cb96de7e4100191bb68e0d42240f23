({
	doInit : function(component, event, helper) {
    console.log("Initializing...");
    var action = component.get("c.getHTSPlans");
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        //setup and fire EVENT or set values...
        component.set("v.HTSPlans", returnObj);
        helper.helpUpdatePicklists(component, returnObj);
      } else {
        console.log("Failed with state: " + state);
      }
    }),
    $A.enqueueAction(action);
  },

  updatePicklists : function(component, event, helper){
    console.log("Handling Plans list change...");
    var returnObj = component.get("v.HTSPlans");
    helper.helpUpdatePicklists(component, returnObj);
  },
  
  selectPlans : function(component, event, helper){
    console.log("Hybrid plans selected...");
    //Need to convert the two selected plans into a map....
    var selectedPri = component.find("primaryPicklist").get("v.value");
    console.log(selectedPri);
    var selectedSec = component.find("secondaryPicklist").get("v.value");
    console.log(selectedSec);
    if(selectedPri.substring(0,6) == "Choose" || selectedSec.substring(0,6) == "Choose"){
      alert("You must Choose both a HIgh Speed and Unlimited Plan before proceeding!");
      return true;
    }
    var cmpEvent = component.getEvent("cmpDataUpdated");
    cmpEvent.setParams({"stateChange": "PlansSelected",
                        "primaryPlan" : selectedPri,
                        "secondaryPlan" : selectedSec});
    cmpEvent.fire();
  }
})