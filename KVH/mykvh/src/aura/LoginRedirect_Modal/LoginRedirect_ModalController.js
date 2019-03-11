({
	navigateToURL : function(component, event, helper) {
         component.set("v.modalopen",false);
        window.open(component.get("v.redirectURL"),'_top');
	},
    closepopup : function(component, event, helper) {
		component.set("v.modalopen",false);
	}
})