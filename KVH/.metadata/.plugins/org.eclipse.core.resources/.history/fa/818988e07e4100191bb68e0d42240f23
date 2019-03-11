({
	
    getNewslist : function(component, event, helper) {
        console.log('in side apex getNewslist');
        var action = component.get("c.getNewslist");      
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('@@ in get news list success');
                //console.log(response.getReturnValue());                
                component.set("v.allnewslist", response.getReturnValue());      
                var allnewslist = component.get("v.allnewslist");
                var toptwonews = [];
                if(allnewslist != undefined){
                    var count = 1;
                    for(var i=0;i<=3 && i<allnewslist.length;i++){
                        toptwonews.push(allnewslist[i]);
                        count++;
                    }
                    component.set("v.toptwonewslist", toptwonews);  
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on handlePortalViewChangeEvent: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})