({
	getSubscriptionRecords: function(component) {       
        var action = component.get("c.getSubscription");
        action.setParams({
            assetId : component.get("v.assetId")
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var mymap =  a.getReturnValue();
                component.set("v.subscriptionIdListMap", mymap);
                var i ;
                var subList = [];
                for(i in mymap)
                {
                    subList.push(mymap[i]);
                }
                component.set("v.listSubscription", subList);
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }         
        });        
        $A.enqueueAction(action);                
    },
    toggleClass: function(component,componentId,className) {
        var modal = component.find(componentId);
        $A.util.removeClass(modal,className+'hide');
        $A.util.addClass(modal,className+'open');
    },
    
    toggleClassInverse: function(component,componentId,className) {
        var modal = component.find(componentId);
        $A.util.addClass(modal,className+'hide');
        $A.util.removeClass(modal,className+'open');
    }
})