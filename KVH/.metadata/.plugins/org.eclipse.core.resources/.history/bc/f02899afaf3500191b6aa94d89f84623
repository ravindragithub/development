({	
    getEventlistHelper: function(component, event, helper) {
        var action = component.get("c.getEventlist");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {  
                component.set("v.eventlist", response.getReturnValue());      
                var alleventlist = component.get("v.eventlist");
                var toptwoevents = [];
                if(alleventlist == undefined || alleventlist.length == 0){
                    component.set("v.shownoeventimg", true); 
                }else{
                    component.set("v.shownoeventimg", false); 
                }
                if(alleventlist != undefined){
                    var count = 1;
                    for(var i=0;i<=1 && i<alleventlist.length;i++){
                        toptwoevents.push(alleventlist[i]);
                        count++;
                    }
                    component.set("v.toptwoeventlist", toptwoevents);  
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