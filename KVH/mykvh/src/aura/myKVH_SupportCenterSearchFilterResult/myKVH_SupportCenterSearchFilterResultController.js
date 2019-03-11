({
	handleRemove : function(component, event, helper) {
        var index = event.getSource().get("v.name");
        var AllRowsList = component.get("v.filterResult");
        AllRowsList.splice(index, 1);
        component.set("v.filterResult", AllRowsList);
        var cmpEvent = component.getEvent("cmpEvent"); 
        cmpEvent.setParams({filterListEvt : AllRowsList,
                           isFilterRemoved : true}); 
        cmpEvent.fire(); 
	}
})