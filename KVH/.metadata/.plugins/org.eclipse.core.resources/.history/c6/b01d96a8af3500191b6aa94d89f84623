({
	doInit : function(component, event, helper) {
    console.log("Initializing...");
    component.set("v.state", "SEARCH");
    //Hide spinner...
    var spinnerDiv = component.find("spinner_div");
    $A.util.addClass(spinnerDiv, "hide");
    var debugDiv = component.find("debug_div");
    $A.util.addClass(debugDiv, "hide");
    //read Contract
    var action = component.get("c.getContract");
    action.setParams({ recId : component.get("v.identifier") });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        //setup and fire EVENT or set values...
        component.set("v.kontract", returnObj.parentContr);
        component.set("v.statusMessage", returnObj.statusMessage);
      } else {
        console.log("Failed with state: " + state);
      }
    }),
    $A.enqueueAction(action);
  },

  createSubsRecords : function(component, event, helper){
    console.log("Proceeding with subscription record creation...");
    var cmpEvent = component.getEvent("cmpDataUpdated");
    cmpEvent.setParams({"stateChange": "CreateSubscriptions"});
    cmpEvent.fire();
  },

  provisionHybrids : function(component, event, helper){
    console.log("Proceeding with service provisioning...");
    var cmpEvent = component.getEvent("cmpDataUpdated");
    cmpEvent.setParams({"stateChange": "ProvisionHybridPlans"});
    cmpEvent.fire();
  },

  handleValidation : function(component, event, helper){
    console.log("Handling Validation Complete Event....");
    var diag = event.getParam("diagnostics");
    var disabled = false;
    for(var i = 0; i < diag.activeSubscriptions.length; i++){ //look for active subscriptions
      console.log(diag.activeSubscriptions[i]);
      console.log(diag.activeSubscriptions[i].subscriber_id.substring(8));
      if(diag.activeSubscriptions[i].subscriber_id.substring(8) != "-00"){
        disabled = true;
        alert("This Terminal already appears to have a subscription!");
      }
    }
    for(var i = 0; i < diag.validationResults.length; i++){
      console.log(diag.validationResults[i]);
      if(diag.validationResults[i].substring(0,3) != "OK:"){
        disabled = true;
        alert(diag.validationResults[i]);
      }
    }
    var cmpEvent = component.getEvent("cmpDataUpdated");
    cmpEvent.setParams({"stateChange": "ValidationComplete"});
    cmpEvent.fire();
    if(disabled){
      component.set("v.state", "BLOCKER");
    }

  },

  handleStateChange : function(component, event, helper){
    console.log("Handling State Change....");
    var newState = event.getParam("value");
    var oldState = event.getParam("oldValue");
    //alert("Old State: " + oldState + "\n" + "New State: " + newState);

    
    var debugDiv = component.find("debug_div");
    var spinnerDiv = component.find("spinner_div");
    var searchDiv = component.find("search_div");
    var regionDiv = component.find("region_div");
    var plansDiv = component.find("plans_div");
    var recordsDiv = component.find("records_div");
    var provisionDiv = component.find("provision_div");
    var successDiv = component.find("success_div");

    switch(newState){
      case "SEARCH":
      {
        $A.util.addClass(regionDiv, "hide");
        $A.util.addClass(plansDiv, "hide");
        $A.util.addClass(recordsDiv, "hide");
        $A.util.addClass(provisionDiv, "hide");
        $A.util.addClass(successDiv, "hide");
      }
      break;

      case "REGION":{
        console.log("Transitioning to REGIONS state....");
        $A.createComponent(
          "c:HTS_region_selector",
          {
              "aura:id": "region_selector",
              "termId": component.get("v.terminal.Name")
          },
          function(region, status, errorMessage){
            //Add the new button to the body array
            if (status === "SUCCESS") {
              var body = component.get("v.body");
              body.push(region);
              component.set("v.body", body);
            }
            else if (status === "INCOMPLETE") {
              console.log("No response from server or client is offline.")
              // Show offline error
            }
            else if (status === "ERROR") {
              console.log("Error: " + errorMessage);
              // Show error message
            }
          }
        );
        $A.util.removeClass(regionDiv, "hide");
      } break;

      case "UPDATING":{
        //alert(newState);
      } break;

      case "PLANS":
      {

        $A.util.removeClass(plansDiv, "hide");
      }
      break;

      case "RECORDS":
      {
        $A.util.removeClass(recordsDiv, "hide");
      }
      break;

      case "PROVISION":
      {
        $A.util.removeClass(provisionDiv, "hide");
      }
      break;

      case "COMPLETE":
      {
        $A.util.addClass(provisionDiv, "hide");
        $A.util.removeClass(successDiv, "hide");
        var k = component.get("v.kontract");
        component.set("v.successURL", "/" + k.Id);
        alert(component.get("v.statusMessage"));
      }
      break;

      case "BLOCKER":
      {
        $A.util.removeClass(successDiv, "hide");
        var k = component.get("v.kontract");
        component.set("v.successURL", "/" + k.Id);
        alert("Cannot Procced With Hybrid Service Provisoining!");
      }
      break;
      
      case "ERROR":
      {
        $A.util.removeClass(debugDiv, "hide");
        alert("Looks like something went wrong! Please grab a screenshot and open a case with SF Support");
      }
      break;
    }

  },

  handleCmpEvent : function(component, event, helper){
    console.log("Event Handler invoked for: " + event.getName());
    var statusMessage = event.getParam("statusMessage");
    var assetReturned = event.getParam("terminal")
    var newState = event.getParam("stateChange");
    var priPlan = event.getParam("primaryPlan");
    var secPlan = event.getParam("secondaryPlan");
    var selRegion = event.getParam("newRegion");

    console.log("Container Component Handling Component Event: " + newState);

    var spinnerDiv = component.find("spinner_div");

    switch(newState) {
      case "RESET": { //do Reset stuff
        //setup and fire APPLICATION Event
      } break;

      case "Searching": {
        console.log("Searching");
        component.set("v.terminal", null);
        $A.util.removeClass(spinnerDiv, "hide");
      } break;

      case "SearchComplete": {//do search complete stuff
        console.log("SearchComplete");
        if(assetReturned === undefined){
          alert(statusMessage);
          $A.util.addClass(spinnerDiv, "hide");
          return true;  //bail out completely!!
        }
        component.set("v.statusMessage", statusMessage);
        if(assetReturned.Product2.ProductCode != "Virtual Terminal ID"){
          //$A.util.toggleClass(exceptionDiv, "toggle");
          alert("This is not a Virtual Terminal ID!");
          //Hide previous div
        } else {
          //component.set("v.state", "PLANS");
          component.set("v.terminal", assetReturned);
        }
      } break;
      
      case "ValidationComplete": {
        $A.util.addClass(spinnerDiv, "hide");
        component.set("v.state", "REGION");
      } break;

      case "asynchJobEnqueued": {
        var job = event.getParam("jobId");
        //alert(job);
        component.set("v.state", "UPDATING");
        var appEvent = $A.get("e.c:HTS_hybrids_application_evt");
        appEvent.setParams({"jobId":job});
        appEvent.fire();
      } break;

      case "asynchJobComplete": {
        component.set("v.state", "PLANS");
      } break;

      case "PlansSelected": {
        console.log("Plans Selected...");
        //$A.util.addClass(spinnerDiv, "toggle");
        console.log(priPlan);
        component.set("v.primaryPlan", priPlan);
        console.log(secPlan);
        component.set("v.secondaryPlan", secPlan);
        component.set("v.state", "RECORDS");
      } break;
      
      case "CreateSubscriptions": {
        console.log("Creating Subscription Records...");
        $A.util.removeClass(spinnerDiv, "hide");
        helper.helpCreateSubs(component);
      } break;

      case "SubscriptionsComplete": {
        component.set("v.state", "PROVISION");
        $A.util.addClass(spinnerDiv, "hide");
      } break;
      
      case "RegionSelected":{
        console.log("Region Selected...");
        //helper.helpCreateSubs(component);
        component.set("v.region", selRegion);
      } break;
      
      case "ProvisionHybridPlans": {
        console.log("Invoking service class to provision hybrid plans...");
        $A.util.removeClass(spinnerDiv, "hide");
        helper.helpProvisionHybrids(component);
      } break;

      case "ProvisioningComplete":{
        component.set("v.state", "COMPLETE");
        $A.util.addClass(spinnerDiv, "hide");
      } break;
      
      default: {
        console.log("Unknown state....");
      }
    }
  }
})