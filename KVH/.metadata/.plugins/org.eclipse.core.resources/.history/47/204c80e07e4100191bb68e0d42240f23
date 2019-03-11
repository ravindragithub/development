({
	handlePlaceAvailableServiceEvent : function(component, event, helper) {
		var serviceNameTemp = event.getParam("serviceName");
        var serviceAvailable = event.getParam("serviceAvailable");
        var kvhUserRole = event.getParam("kvhUserRole");
        if(kvhUserRole == undefined){
            component.set("v.miniVSATManagerurl",component.get("v.miniVSATManagerPageurl"));
        }
        if(serviceNameTemp == 'TracVision and Compass' ){
           component.set("v.showTracVision",serviceAvailable);
           component.set("v.showservices",true);
        }else if(serviceNameTemp == 'mini-VSAT Activation'){
           component.set("v.showminiVSATBroadband",serviceAvailable);
           component.set("v.showservices",true);
        }else if(serviceNameTemp == 'Inmarsat SATCOM Activation' ){
           component.set("v.showInmarsatSATCOMSystems",serviceAvailable);
           component.set("v.showservices",true);
        }else if(serviceNameTemp == 'Mini-Vsat Manager' ){
           component.set("v.showminiVSATManager",serviceAvailable);
           component.set("v.showservices",true);
        }
	}
})