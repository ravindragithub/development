({
  handleLookup : function(component, event, helper) {
    console.log("Handling LOOKUP request....");
    var searchStringValid = true;
    var inputCmp = component.find("I2CM");
    var inputString = inputCmp.get("v.value");
    if ($A.util.isEmpty(inputString)){
      searchStringValid = false;
      inputCmp.set("v.errors", [{message:"I2CM Serial Number can't be blank"}]);
    } else {
      inputCmp.set("v.errors", null);
    }
    //console.log("this is controller");
    if(searchStringValid){
      helper.lookupI2CM(component);
    }
  },
  handleAppEvent : function(component, event, helper){
    console.log("Search Component Handling Application Event: " + event.getParam("appState"));
    component.set("v.searchString", event.getParam("searchString"));
  },
  handleReset : function(component, event, helper){
    console.log("Handling RESET request....");
    //Fire off Searching event....spinner?
    //Maybe this is a flavor of the component event...
    var resetEvent = component.getEvent("cmpDataUpdated");
    resetEvent.setParam("stateChange", "RESET");
    resetEvent.fire();
    console.log("Component Event Fired! " + resetEvent.getParam("stateChange"));
  }
})