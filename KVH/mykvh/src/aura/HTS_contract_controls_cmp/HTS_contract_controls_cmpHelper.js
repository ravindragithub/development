({
  helpReadAllSubs : function(component, event, helper) {
    //read Contract
    var action = component.get("c.getControlObject");
    action.setParams({ recId : component.get("v.identifier") });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        //setup and fire EVENT or set values...
        component.set("v.kontract", returnObj.parentContract);
        component.set("v.statusMessage", returnObj.statusMessage);
        component.set("v.subscriptions", returnObj.subsList);
        //Need to process map into a list construct
        //http://www.infallibletechie.com/2016/05/how-to-iterate-map-in-salesfore.html
        //https://salesforce.stackexchange.com/questions/139744/how-to-iterate-a-map-in-aura
        var k = component.get("v.kontract");
        component.set("v.successURL", "/" + k.Id);
      } else {
        console.log("Failed with state: " + state);
      }
    }),
    $A.enqueueAction(action);
  },
  helpHandleSubsChanged : function(component, event, helper){
    console.log("Helper function invoked...");
    var allSubs = [];
    allSubs = component.get("v.subscriptions");
    var flexPlans =[];
    var relatedSubscriptions = [];
    var terminatedSubscriptions =[];
    for(var i=0; i<allSubs.length; i++){
      // Get the record
      var myRecord = allSubs[i];
      // Pull out the field that's going to be my key
      if(myRecord.SBQQ__TerminatedDate__c != null){
        //Push Terminated Subs to Terminated Component....
        terminatedSubscriptions.push(myRecord);
      } else if(myRecord.SBQQ__Product__r.HTS_Subscriber_Plan__c != null){
        //Push Hybrid Subs *including* Static IPs to Hybrids Component
        flexPlans.push(myRecord);
      } else if(myRecord.SBQQ__Product__r.Name == "Global Static IP"){ //do not like using name...
        //Push Hybrid Subs *including* Static IPs to Hybrids Component
        flexPlans.push(myRecord);
      } else {
        //Push related subs to related component...
        relatedSubscriptions.push(myRecord);
      }
    }
    component.set("v.terminatedSubs", terminatedSubscriptions)
    component.set("v.hybridPair", flexPlans);
    component.set("v.relatedSubs", relatedSubscriptions);
  }
})