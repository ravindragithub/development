({
    doInit: function(component, event, helper) {
        helper.getPlatformTypeHelper(component, event, helper);
    },
    handleVesselTypeValue: function(component, event, helper) { 
        var emptyArray = [];
        component.set("v.marketList",emptyArray );
        component.set("v.sectorList", emptyArray);
        var controllerValueKey = event.getSource().get("v.value");
        var Map = component.get("v.platformMap");
        //component.set("v.isDependentDisable1", true);
        if (controllerValueKey != '') {
            if(controllerValueKey == 'Vehicle'){
                component.set("v.landSelected", true);
                component.set("v.marineSelected", false);
            }
            else if(controllerValueKey == 'Vessel'){
                component.set("v.landSelected", false);
                component.set("v.marineSelected", true);
            }
            var ListOfDependentMap = Map[controllerValueKey];  
            component.set("v.marketMap", ListOfDependentMap);
            component.set("v.selectedMarket",controllerValueKey);  
            component.set("v.simplePRDregistration.Market__c",controllerValueKey);  
            component.set("v.selectedSector",""); 
            component.set("v.simplePRDregistration.Sector__c","");
            component.set("v.isDependentDisable1", false);
            var listOfkeys = [];
            for (var singlekey in ListOfDependentMap) {
                listOfkeys.push(singlekey);
            }
            helper.fetchDepValues(component, listOfkeys,'market');
        } 
        else{
            component.set("v.isDependentDisable1", true);
            component.set("v.isDependentDisable2", true);
            component.set("v.selectedSector", "");
            component.set("v.selectedAppType", "");
            component.set("v.landSelected", false);
            component.set("v.marineSelected", false);
        }
    },
    onDependentFieldChange: function(component, event, helper) {
        var controllerValueKey = event.getSource().get("v.value");
        if(controllerValueKey == 'Other')
            component.set("v.otherSelected",true);  
        else
            component.set("v.otherSelected",false);  
        component.set("v.simplePRDregistration.Vessel_Type__c",controllerValueKey); 
        component.set("v.selectedVesselType",controllerValueKey);   
    },
    onControllerFieldChange : function(component, event, helper) {
        var controllerValueKey = event.getSource().get("v.value");
        var Map = component.get("v.marketMap");         
        if (controllerValueKey != '') {          
            component.set("v.isDependentDisable2", false);
            var ListOfDependentFields = Map[controllerValueKey];  
            helper.fetchDepValues(component, ListOfDependentFields,'sector');
            component.set("v.selectedSector",controllerValueKey); 
            component.set("v.simplePRDregistration.Sector__c",controllerValueKey);  
            component.set("v.selectedVesselType",""); 
            component.set("v.simplePRDregistration.Vessel_Type__c",""); 
        }
        else{
            component.set("v.isDependentDisable2", true);
            component.set("v.selectedAppType", "");
        }
    },
})