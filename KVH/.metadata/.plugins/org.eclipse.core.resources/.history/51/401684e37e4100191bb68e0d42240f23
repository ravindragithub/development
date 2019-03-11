({
  handleLookup : function(component, event, helper) {
    console.log("this is controller");
    //validate input attributes
    var pattern = /^(0|[1-9][0-9]*)$/;
    var isnum = pattern.test(component.get("v.searchString"));
    console.log("serialNumber validation: " + isnum);
    if(!isnum){
      alert("iDirect Modem Serial number must consist of numbers only!\n\rNo leading zeros allowed!");
    } else if(component.get("v.searchString").length > 6){
      alert("iDirect Modem Serial number must not exceed 6 digits in length!");
    } else {
      helper.doLookup(component);
    }
  },
  handleReset : function(component, event, helper) {
    //Fire off Reset event....
    var resetEvt = component.getEvent("cmpDataUpdated");
    resetEvt.setParams({"stateChange" : "RESET"});
    resetEvt.fire();
  },
  stripLeadingZero : function(component, event, helper){
    var serNum = component.get("v.searchString").replace(/^[0]+/g,"");
    console.log(serNum);
    component.set("v.searchString", serNum);
  }
})