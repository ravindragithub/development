({
	doInit : function(component, event, helper) {
    console.log("Initializing...");
    var action = component.get("c.getControlObject");
    action.setParams({ recId : component.get("v.identifier") });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        //setup and fire EVENT or set values...
        component.set("v.subscriptions", returnObj.subsList);
        //Need to process map into a list construct
        //http://www.infallibletechie.com/2016/05/how-to-iterate-map-in-salesfore.html
        //https://salesforce.stackexchange.com/questions/139744/how-to-iterate-a-map-in-aura
      } else {
        console.log("Failed with state: " + state);
      }
    }),
    $A.enqueueAction(action);
  },
  handleSubscriptionsChange : function(component, event, helper){
    console.log("Handling Subscriptions List change...");
    var allSubs = [];
    var hasHybridSubs = false;
    allSubs = component.get("v.subscriptions");
    for(var i=0; i<allSubs.length; i++){
      // Get the record
      var myRecord = allSubs[i];
      // Pull out the field that's going to be my key
      if(myRecord.SBQQ__Product__r.HTS_Subscriber_Plan__c != null
                && myRecord.SBQQ__TerminatedDate__c == null){
        //Push Hybrid Subs *including* Static IPs to Hybrids Component
        hasHybridSubs = true;
      }
    }
    if(hasHybridSubs){
      $A.createComponent(
        "c:HTS_contract_controls_cmp",
        {"identifier": component.get("v.identifier")},
        function(newComponent, status, errorMessage){
          //Add the new button to the body array
          if (status === "SUCCESS") {
            var body = component.get("v.body");
            body.push(newComponent);
            component.set("v.body", body);
          } else if (status === "INCOMPLETE") {
            console.log("No response from server or client is offline.")
            // Show offline error
          } else if (status === "ERROR") {
            console.log("Error: " + errorMessage);
            // Show error message
          }
        }
      );
    } else {
      $A.createComponent(
        "c:HTS_hybrids_wizard_cmp",
        {"identifier": component.get("v.identifier")},
        function(newComponent, status, errorMessage){
          //Add the new button to the body array
          if (status === "SUCCESS") {
            var body = component.get("v.body");
            body.push(newComponent);
            component.set("v.body", body);
          } else if (status === "INCOMPLETE") {
            console.log("No response from server or client is offline.")
            // Show offline error
          } else if (status === "ERROR") {
            console.log("Error: " + errorMessage);
            // Show error message
          }
        }
      );
    }
  }
})