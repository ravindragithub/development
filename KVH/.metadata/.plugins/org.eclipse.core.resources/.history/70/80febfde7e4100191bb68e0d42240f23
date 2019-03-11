({
	doInit : function(component, event, helper) {
    console.log("Initializing Log Panel with: " + component.get("v.identifier"));
    component.find("logPanel").set("v.newMessage", "INIT: recordId = " + component.get("v.identifier"));
	},
  rebuild : function(component, event, helper) {
    console.log("Commencing rebuild....");
    component.find("logPanel").set("v.newMessage", "ACTION: commencing re-build");
    //Verify that the Asset is a VTID
    helper.verifyVTID(component, event, helper);
  },
  handleStateChange : function(component, event, helper) {
    console.log("Event Handler invoked for: " + event.getName());
    var statusMessage = event.getParam("statusMessage");
    var listSize = event.getParam("listLength");
    var eventList = event.getParam("assetList");
    var newState = event.getParam("stateChange");
    console.log("Container Component Handling Component Event: " + newState);

    //Supported States: Searching, Verified, Rebuilding, Rebuilt
    switch(newState) {
      case "RESET":
        {//do Reset stuff
        }
        break;
      case "Searching":
        {//do Searching stuff
          
        }
        break;
    case "Verified":
        {//do Verified stuff
          //component.set("v.assetList", eventList);
          component.set("v.identifier", eventList[0].Name);
          component.find("logPanel").set("v.newMessage", statusMessage);
          if(statusMessage.startsWith("SUCCESS:")){
            helper.getObjIdFromOSS(component, event, helper);
          }
        }
        break;
    case "Rebuilding":
        {//do Rebuilding stuff
          console.log("Re-building");
          component.find("logPanel").set("v.newMessage", statusMessage);
          if(statusMessage.startsWith("SUCCESS:")){
            helper.executeRebuild(component, event, helper);
          }
        }
        break;
    case "Rebuilt":
        {//do Rebuilt stuff
          console.log("Rebuild Completed!");
          component.find("logPanel").set("v.newMessage", statusMessage);
        }
        break;
    }
  }
})