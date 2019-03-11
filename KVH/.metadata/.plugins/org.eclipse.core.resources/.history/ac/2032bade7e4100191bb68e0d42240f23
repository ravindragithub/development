({
	helpShapingPolicyComparison : function(component, event, helper) {
    var sub = component.get("v.subscription");
    var oss = component.get("v.diagnostics");
    var match = component.get("v.enabled");
    //need to handle a variety of activeSubscriptions list sizes
    var subscriber_id_list = component.get("v.diagnostics.activeSubscriptions");  //Need the list of subscribers from OSS
    var subs_list_length = subscriber_id_list.length;
    console.log(subs_list_length);
    if(subs_list_length == 0){
      console.log("Error condition found...");
      component.set("v.enabled", false);
      return;
    }
    for(var i = 0; i < subs_list_length; i++){
      if(subscriber_id_list[i].subscriber_id == sub.Traffic_Identifier__c){
        component.set("v.OSSsubscriber", subscriber_id_list[i]);
        console.log("Matching OSS Subscriber Below: ");
        console.log(component.get("v.OSSsubscriber"));
      }
    }
    if(sub.SBQQ__Product__r.HTS_Subscriber_Plan__r.Name == component.get("v.OSSsubscriber").subscriber_plan_id){
      console.log("Match Found! Nothing to do here!");
      component.set("v.enabled", false);
    } else {
      console.log("No Matchie, enable provisioning!");
      component.set("v.enabled", true);
    }
    //Fire local event to hide spinner
    var stateTrans = component.getEvent("stateTransition");
    stateTrans.setParams({"stateChange":"done"});
    stateTrans.fire();
    console.log("Update Done Transition Event fired!");
	},
  helpUpdateOSSSubscriber : function(component, event, helper){
    console.log("invoking helper");

    //Fire local event to show spinner
    var stateTrans = component.getEvent("stateTransition");
    stateTrans.setParams({"stateChange":"busy"});
    stateTrans.fire();
    console.log("Update Starting Transition Event fired!");

    var OSSsub = component.get("v.OSSsubscriber");  //Need the list of subscribers from OSS
    console.log(OSSsub);

    var OSS_obj_id = OSSsub.obj_id;        //Need the obj_id from this....
    var OSS_TID = OSSsub.subscriber_id;        //Need the OSS Traffic Id
    var shaping_policy = component.get("v.subscription"); //Need the NEW Shaping Policy from this...

    console.log(OSS_obj_id);
    console.log(OSS_TID);
    console.log(shaping_policy);
    
    var action = component.get("c.updateSubscription"); 
    action.setParams({ obj_id : OSS_obj_id,
                       TID : OSS_TID,
                       shapingPolicy : shaping_policy });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        //broadcast event up through hierarchy...
        var updateDone = component.getEvent("updateComplete");
        updateDone.setParams({"statusMessage":returnObj.statusMessage});
        updateDone.fire();
        console.log("Update Complete Event fired!");
      } else {
        console.log("Failed with state: " + state);
      }
    }),
    $A.enqueueAction(action);
    
  }
})