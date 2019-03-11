({
	getNewsDetail : function(component, event, helper) {
        console.log('in side apex getNewsDetail');
        var action = component.get("c.getNewsDetail");
        action.setParams({
            "releaseId": component.get("v.releaseid")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('@@ in get event list success');
                //console.log(response.getReturnValue()); 
                var news =   response.getReturnValue();             
                component.set("v.responsehtml", news.content);      
                component.set("v.newwtitle", news.title);     
                component.set("v.newsdate", news.newsdate);     
               
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