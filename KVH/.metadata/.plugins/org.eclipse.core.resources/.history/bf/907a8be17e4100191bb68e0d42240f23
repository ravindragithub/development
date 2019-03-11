({
    getSubscriptionRecords: function(component) {       
        var action = component.get("c.getAllSubscription");
        action.setParams({
            assetId : component.get("v.assetId")
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var mymap =  a.getReturnValue();
                var subList = [];
                var assetName = [];
                for(var singlekey in mymap){
                    if(mymap[singlekey].length > 0){
                        for(var i in mymap[singlekey])
                        {
                            subList.push(mymap[singlekey][i]);
                        }
                    }
                }
                if(component.get("v.mode") == 'editable' && subList.length == 0){
                    var compEvent = component.getEvent("cmpEvnt");
                    compEvent.setParams({"noAssetSubscription" : true});
                    compEvent.fire();
                }
                
                component.set("v.listSubscription", subList);
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }         
        });        
        $A.enqueueAction(action);                
    },
    getSubscriptionStatus: function(component) {       
        var action = component.get("c.getSubscriptionStatus");
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var result =  a.getReturnValue();
                component.set("v.listSubscriptionStatus", result);
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }         
        });        
        $A.enqueueAction(action);                
    },
})