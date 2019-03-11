({
	showhideEditSection : function(component, event, helper) {
		component.set("v.showview",event.getParam("showview"));
        component.set("v.showedit",event.getParam("showedit"));
        var showThankyou = event.getParam("showThankyou");
        component.set("v.showThankyou",showThankyou);
        if(showThankyou)
            helper.fetchuserDetails(component, event, helper);
	},
	showhideSpinner : function(component, event, helper) {
		component.set("v.showspinner",event.getParam("showspinner"));
	},
    doInit: function(component, event, helper) {
         
        helper.fetchuserDetails(component, event, helper);
    }
    
})