({
	doInit : function(component, event, helper) {
    var sub = component.get("v.subscription");
    console.log(sub);
    if("Asset__c" in sub ? true : false) {   //check if the subscription has an Asset
      //TODO: verify Asset is VTID!
      console.log("setting render to true!");
      component.set("v.renderCard", true);
      helper.helpDoInit(component, event, helper);
    }
	},
  handleValidationComplete : function(component, event, helper){
    console.log("Handling Validation Complete Event...");
    //event.stopPropagation(); //might become important when there are many Cards in the App!
    var diagnostics = event.getParam("diagnostics");
    console.log(diagnostics);
    var subs = diagnostics.activeSubscriptions;
    var count = subs.length;
    console.log(count);
    for(var i = 0; i < count; i++){
      console.log(subs[i]);
    }
    component.set("v.diagnostics", diagnostics);
    var provisioner = component.find("provisioner");
    provisioner.set("v.diagnostics", diagnostics);
  },
  handleUpdateComplete : function(component, event, helper){
    console.log("Handling Update Complete Event...");
    //setup and fire application event
    var appEvent = $A.get("e.c:HTS_subscriptions_application_evt");
    // Optional: set some data for the event (also known as event shape)
    // A parameter’s name must match the name attribute
    // of one of the event’s <aura:attribute> tags
    //appEvent.setParams({ "myParam" : myValue });
    appEvent.fire();
    console.log("Application Event Fired!");
  }
})