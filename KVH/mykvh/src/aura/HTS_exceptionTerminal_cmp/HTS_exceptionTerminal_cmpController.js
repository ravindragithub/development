({
    handleAppEvent : function(component, event, helper){
      console.log("Exception Component Handling Application Event: " + event.getParam("appState"));
      component.set("v.statusMessage", event.getParam("statusMessage"));
      component.set("v.assetList", event.getParam("assetList"));
    }
})