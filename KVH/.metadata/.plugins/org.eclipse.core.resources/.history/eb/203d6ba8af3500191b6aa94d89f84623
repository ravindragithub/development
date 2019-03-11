({
  handleLookup : function(component, event, helper) {
    console.log("Handling LOOKUP request....");
    var searchStringValid = true;
    var inputCmp = component.find("VTID");
    var inputString = inputCmp.get("v.value");
    var validationCmp = component.find("validation");
    validationCmp.set("v.diagnostics", null);
    if ($A.util.isEmpty(inputString)){
      searchStringValid = false;
      inputCmp.set("v.errors", [{message:"Virtual Terminal ID can't be blank"}]);
    } else {
      inputCmp.set("v.errors", null);
    }
    //console.log("this is controller");
    if(searchStringValid){
      var searchEvent = component.getEvent("cmpDataUpdated");
      searchEvent.setParam("stateChange", "Searching");
      searchEvent.fire();
      console.log("Component Event Fired! " + searchEvent.getParam("stateChange"));
      helper.lookupVTID(component);
    }
  }
})