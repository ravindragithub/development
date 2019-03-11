({
	launchStatus : function(component, event, helper) {
    var bodyComponent = "c:HTS_status_demo";
    var appEvent = $A.get("e.c:HTS_modal_show_evt");
    appEvent.setParam("request", bodyComponent);
    console.log("firing app event! " + appEvent.getParam("request"));
    appEvent.fire();
	},
  launchRebuild : function(component, event, helper){
    var bodyComponent = "c:HTS_rebuildTerminal_cmp";
    var appEvent = $A.get("e.c:HTS_modal_show_evt");
    appEvent.setParams({"request" : bodyComponent,
                        "identifier" : component.get("v.identifier")
                       });
    console.log("firing app event! " + appEvent.getParam("request"));
    console.log("firing app event! " + appEvent.getParam("identifier"));
    appEvent.fire();
  }
})