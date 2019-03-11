({
	toggelDetails : function(component, event, helper) {
		var arrowIcon = component.get("v.arrowIcon");
        if(arrowIcon == 'utility:chevrondown'){
            component.set("v.arrowIcon","utility:chevronright");
        }else{
            component.set("v.arrowIcon","utility:chevrondown");
        }
	},
    handleCollapseAllEvent :  function(component, event, helper) {
        var vesselName = component.get("v.vesselObj").vesselName;
        var arrowIcon = event.getParam('arrowicon');
        //alert(arrowIcon);
        if(vesselName){
           component.set("v.arrowIcon",arrowIcon); 
        }
	}
})