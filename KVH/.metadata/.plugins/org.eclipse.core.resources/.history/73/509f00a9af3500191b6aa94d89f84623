({
	doInit : function(component, event, helper) {
    console.log("Initializing HTS_region_selector...");
    //Do this first...
    var action = component.get("c.getRegions");
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        //setup and fire EVENT or set values...
        helper.helpUpdatePicklists(component, returnObj);
        $A.enqueueAction(action2);  //Now do the second thing...
      } else {
        console.log("c.getRegions Failed with state: " + state);
      }
    });
    //Then do the second thing...
    var action2 = component.get("c.getTerminal");
    action2.setParams({"vtid": component.get("v.termId")});
    action2.setCallback(this, function(response){
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        //setup and fire EVENT or set values...
        component.set("v.enabledTerminal", returnObj);
        helper.compareRegionVersion(component);
      } else {
        console.log("c.getTerminal Failed with state: " + state); 
      }

    });
    $A.enqueueAction(action);
  },
  handleRegionChange : function(component, event, helper){
    console.log("Handling selected region change....");
    var cmpEvent = component.getEvent("cmpDataUpdated");
    cmpEvent.setParams({"stateChange": "RegionSelected",
                         "newRegion": component.get("v.selectedRegion")});
    helper.compareRegionVersion(component);
    cmpEvent.fire();
  },
  handleChangeTemplate : function(component, event, helper){
    //alert("Change Template button clicked!!");
    var term = component.get("v.enabledTerminal");
    var region = component.get("v.selectedRegion");
    term.template_id = region;
    component.set("v.enabledTerminal", term);
    console.log(term);
    //disable the lightning:select....
    component.find("regionPicker").set("v.disabled", true);
    helper.helpUpdateTemplate(component, event, helper, "changeRegion");
  },
  handleUpdateTemplate : function(component, event, helper){
    //alert("Update template button clicked!");
    //disable the lightning:select....
    component.find("regionPicker").set("v.disabled", true);
    helper.helpUpdateTemplate(component, event, helper, "update");
  },
  handleNothingToDo : function(component, event, helper){
    //disable the lightning:select....
    component.find("regionPicker").set("v.disabled", true);
    component.find("nothingtodo").set("v.disabled", true);
    var cmpEvent = component.getEvent("cmpDataUpdated");
    cmpEvent.setParams({"stateChange": "asynchJobComplete"});
    cmpEvent.fire();
  }
})