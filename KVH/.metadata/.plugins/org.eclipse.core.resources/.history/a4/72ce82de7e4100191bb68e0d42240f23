({
  doInit : function(component, event, helper) {
    //Hide spinner...
    var spinnerDiv = component.find("spinner_div");
    $A.util.addClass(spinnerDiv, "hide");
  },
  handlePairChange : function(component, event, helper){
    console.log("Handling Hybrid Pair Change....");
    //validate inputs... common Asset, related
    //This will have to change when Static IPs are rolled in....
    var subs = component.get("v.hybridPair");
    var hsSub = new Object();
    var ulSub = new Object();
    var hsStatics = [];
    var ulStatics = [];

    for(var i = 0; i < subs.length; i++){
      var tid = subs[i].Traffic_Identifier__c;
      if(tid.slice(-3) == "-01"){ //High speed...
        if(subs[i].SBQQ__Product__r.Name == "Global Static IP"){
          hsStatics.push(subs[i]);
        } else if(subs[i].SBQQ__Product__r.HTS_Subscriber_Plan__c != null){
          component.set("v.terminalId", tid.slice(0,8));
          hsSub = subs[i];
        }
      } else if(tid.slice(-3) == "-02"){
        if(subs[i].SBQQ__Product__r.Name == "Global Static IP"){
          ulStatics.push(subs[i]);
        } else if(subs[i].SBQQ__Product__r.HTS_Subscriber_Plan__c != null){
          ulSub = subs[i];
        }
      }
    }
    
    var hs = new Object();
    var ul = new Object();
    hs = {parentSub: hsSub, childSubs: hsStatics};
    ul = {parentSub: ulSub, childSubs: ulStatics};
    console.log(hs);
    console.log(ul);
    var subsTree = [];
    subsTree.push(hs);
    subsTree.push(ul);
    console.log(subsTree);
    component.set("v.hybridComponents", subsTree);
    console.log(tid);
  },
  terminateService : function(component, event, helper){
    console.log("Initiating service termination....");
    if(!confirm("This is permanent and disruptive.\n*** There is no UNDO button. ***\nDo you wish to proceed?")){
      return;
    }
    //validate inputs... common Asset, related
    //This will have to change when Static IPs are rolled in....
    var subs = component.get("v.hybridPair");
    var subsCount = subs.length;
    var priSub;
    var secSub;
    if(subsCount <= 1){
      alert("non-hybrid service not supported");  //like a V3....
      return;
    }
    for(var i = 0; i < subsCount; i++){
      var tid = subs[i].Traffic_Identifier__c;
      if(subs[i].SBQQ__Product__r.Name == "Global Static IP"){
        alert("Please termiante all Static IPs\nbefore proceeding with Rate Plan termination.");
        return;
      }
      if(tid.slice(-3) == "-01"){ //High speed...
        priSub = subs[i];
      } else if(tid.slice(-3) == "-02"){ //High speed...
        secSub = subs[i];
      }
    }
    //go
    console.log("Proceeding with termination....");
    // Create the action...
    var action = component.get("c.invokeTerminateService");
    var compEvent = component.getEvent("termination");
    compEvent.setParams({stateChange : "busy"});  //show spinner...
    compEvent.fire();
    action.setParams({"primarySub": priSub,
                      "secondarySub": secSub});
    // Add callback behavior for when response is received
    action.setCallback(this, function(response){
      var state = response.getState();
      console.log("Component state: " + state);
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log("Status Message: " + returnObj.statusMessage);
        if(returnObj.statusMessage.substring(0, 8) == 'SUCCESS:'){
          component.set("v.statusMessage", "SUCCESS: Hybrid Plans Terminated Successfully!");
        } else {
          component.set("v.statusMessage", "ERROR: Failed to Terminate Hybrid Plans!");
        }
        var compEvent = component.getEvent("termination");
        compEvent.setParams({stateChange : "done"});
        compEvent.fire();
        alert(component.get("v.statusMessage"));
      } else {
        console.log("Failed with state: " + state);
      }
    });
    $A.enqueueAction(action);
  },
  handleCmpEvent : function(component, event, helper){
    console.log("Event Handler invoked for: " + event.getName());
    var statusMessage = event.getParam("statusMessage");
    var assetReturned = event.getParam("terminal")
    var newState = event.getParam("stateChange");
    var priPlan = event.getParam("primaryPlan");
    var secPlan = event.getParam("secondaryPlan");
    var selRegion = event.getParam("newRegion");

    console.log("Contract Controls Component Handling Component Event: " + newState);

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