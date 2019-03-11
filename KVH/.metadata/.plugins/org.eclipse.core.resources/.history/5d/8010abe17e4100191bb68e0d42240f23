({
  handleLookup : function(component, event, helper) {
    console.log("this is controller");
    //validate input attributes
    var alertMsg = "System Part Number must in the form\n\r01-xxxx\n\ror\n\r02-xxxx-xx";
    var pattern = /^0[1-2]{1}-[0-9]{4}(-.{2})?(?:.{2})?$/;
    var isValid = pattern.test(component.get("v.searchString"));
    console.log("serialNumber validation: " + isValid);
    if(!isValid){
      alert(alertMsg);
      return;
    }
    if(component.get("v.searchString") != "01-0419"){
      //constrain to 01-0419 FOR NOW!!
      isValid = false;
      alertMsg = "Only 01-0419 currently supported";
      alert(alertMsg);
      return;
    }
    helper.doLookup(component);
  },
  doInit : function(component, event, helper) {
    console.log("initializing...");
    var spinnerDiv = component.find("spinner_div");
    var inputDiv = component.find("input_div");
    $A.util.addClass(spinnerDiv, "hide");
    $A.util.addClass(inputDiv, "hide");
  },
  handleReset : function(component, event, helper) {
    //Fire off RESET/INIT event....
    var searchEvent = component.getEvent("assetHierarchyTemplateSearch");
    searchEvent.setParams({"state":"INIT"});
    searchEvent.fire();
  },
  handleCmpEvent : function(component, event, helper){
    console.log("Handling Component Event...");    
    var spinnerDiv = component.find("spinner_div");
    var inputDiv = component.find("input_div");

    var newState = event.getParam("state");
    console.log(newState);
    switch(newState){
      case "INIT": {
        var clearArray = component.get("v.foundTemplate");
        clearArray.length = 0;
        component.set("v.foundTemplate", clearArray);
        component.set("v.searchString", "");
        component.set("v.disableSearch", false);
        component.set("v.disableCreate", false);
        $A.util.addClass(spinnerDiv, "hide");
        $A.util.addClass(inputDiv, "hide");
      }
      break;

      case "SEARCHING": {
        $A.util.removeClass(spinnerDiv, "hide");
      }
      break;

      case "FOUND": {
        $A.util.addClass(spinnerDiv, "hide");
        $A.util.removeClass(inputDiv, "hide");
        component.set("v.disableSearch", true);
      }
      break;

      case "NOT_FOUND": {
        $A.util.addClass(spinnerDiv, "hide");
        var templateId = component.get("v.searchString");
        component.set("v.disableSearch", true);
        alert("Could not find template for " + templateId);
      }
      break;

      case "ASSETS_CREATED": {
        
      }
      break;

      case "ERROR": {
        
      }
      break;
    }
  },
  createSFAssets : function(component, event, helper){
    // Create the action...
    var spinnerDiv = component.find("spinner_div");
    $A.util.removeClass(spinnerDiv, "hide");
    component.set("v.disableCreate", true);
    var action = component.get("c.createAssets");
    //validate all field filled in
    var userInput = component.get("v.foundTemplate");
    console.log(userInput);
    for (var i = 0; i < userInput.length; i++) { 
      console.log(userInput[i]);
      if(userInput[i].name == ""){
        //deliver high voltage electric shock to scanner, mouse, and keyboard
        alert("All Fields must be filled in!");
        $A.util.addClass(spinnerDiv, "hide");
        component.set("v.disableCreate", false);
        return;
      }
      if(userInput[i].partNumber == "19-1035"){ //strip trailing "F"
        if(userInput[i].name.endsWith("F")){    //IF it has one!
          userInput[i].name = userInput[i].name.split("F")[0];
        }
      }
    }
    var payload = JSON.stringify(userInput);
    console.log(payload);
    action.setParams({"objList": payload});
    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
      var state = response.getState();
      console.log(state);
      if (component.isValid() && state === "SUCCESS"){
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        var cmpEvent = component.getEvent("assetHierarchyTemplateSearch");
        console.log(returnObj.serverResults);
        if(returnObj.serverResults.startsWith("DUPLICATES FOUND:")){
          cmpEvent.setParams({"state": "ERROR",
                            "lteDevices" : returnObj,
                            "results" : "Duplicate Assets Found!"});
        } else {
          cmpEvent.setParams({"state": "ASSETS_CREATED",
                            "lteDevices" : returnObj});
        }
        cmpEvent.fire();
        $A.util.addClass(spinnerDiv, "hide");
      } else {
        console.log("Failed with state: " + state);
      }
    });
    // Send action off to be executed
    $A.enqueueAction(action);
  }
})