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
            component.set("v.isDependentDisable1", true);
        if (controllerValueKey != '') {
            var ListOfDependentMap = Map[controllerValueKey];  
            component.set("v.marketMap", ListOfDependentMap);
            component.set("v.selectedMarket",controllerValueKey);  
            component.set("v.simpleLTEActivation.Market__c",controllerValueKey);  
            component.set("v.selectedSector",""); 
            component.set("v.simpleLTEActivation.Sector__c","");
            
            var listOfkeys = [];
            for (var singlekey in ListOfDependentMap) {
                listOfkeys.push(singlekey);
            }
            helper.fetchDepValues(component, listOfkeys,'market');
        } 
    },
    onDependentFieldChange: function(component, event, helper) {
        var controllerValueKey = event.getSource().get("v.value");
        component.set("v.simpleLTEActivation.Vessel_Type__c",controllerValueKey); 
        component.set("v.selectedVesselType",controllerValueKey);   
    },
    onControllerFieldChange : function(component, event, helper) {
        //alert(event.getSource().get("v.value"));
        var controllerValueKey = event.getSource().get("v.value");
        var Map = component.get("v.marketMap");         
        if (controllerValueKey != '') {          
            component.set("v.isDependentDisable1", false);
            var ListOfDependentFields = Map[controllerValueKey];  
            helper.fetchDepValues(component, ListOfDependentFields,'sector');
            component.set("v.selectedSector",controllerValueKey); 
            component.set("v.simpleLTEActivation.Sector__c",controllerValueKey);  
            component.set("v.selectedVesselType",""); 
            component.set("v.simpleLTEActivation.Vessel_Type__c",""); 
        }
    }
})