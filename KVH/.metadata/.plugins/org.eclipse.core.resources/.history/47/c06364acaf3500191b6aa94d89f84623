({
    doInit: function(component, event, helper) {
        helper.getPlatformTypeHelper(component, event, helper);
    },
    vesselInfoValidation: function(component, event, helper) {
        helper.validateField(component, event, helper);
    },
    handleVesselTypeValue: function(component, event, helper){
        component.set("v.selectedSector", "");
        component.set("v.selectedAppType", "");
        component.set("v.isDependentDisable1", true);
        component.set("v.isDependentDisable2", true);
        component.set("v.landSelected", false);
        component.set("v.marineSelected", false);
        component.set("v.otherSelected",false);
        
        var emptyArray = [];
        component.set("v.marketList",emptyArray );
        component.set("v.sectorList", emptyArray);        
        var controllerValueKey = event.getSource().get("v.label");
        component.set("v.selectedPT",controllerValueKey)
        var Map = component.get("v.platformMap");
        if(controllerValueKey != ''){
            if(controllerValueKey == 'Vehicle'){
                component.set("v.landSelected", true);
                component.set("v.marineSelected", false);
                component.set("v.simplePRDregistration.RV_or_Vehicle_Make_Model__c",'');  
            }else if(controllerValueKey == 'Vessel'){
                component.set("v.landSelected", false);
                component.set("v.marineSelected", true);
                component.set("v.simplePRDregistration.Vessel_Name__c",'');  
            }
            var ListOfDependentMap = Map[controllerValueKey];  
            component.set("v.marketMap", ListOfDependentMap);
            component.set("v.selectedMarket",controllerValueKey);  
            component.set("v.simplePRDregistration.Platform_Type__c",controllerValueKey);  
            component.set("v.selectedSector",""); 
            component.set("v.isDependentDisable1", false);
            var listOfkeys = [];
            for (var singlekey in ListOfDependentMap) {
                listOfkeys.push(singlekey);
            }
            helper.fetchDepValues(component, listOfkeys,'market');
        }
        helper.validateField(component, event, helper);        
    },
    onControllerFieldChange : function(component, event, helper) {
        component.set("v.isDependentDisable2", true);
        component.set("v.selectedAppType", "");
        component.set("v.otherSelected",false);
        
        var controllerValueKey = event.getSource().get("v.value");
        var Map = component.get("v.marketMap");         
        if(controllerValueKey != '') {          
            component.set("v.isDependentDisable2", false);
            var ListOfDependentFields = Map[controllerValueKey];  
            helper.fetchDepValues(component, ListOfDependentFields,'sector');
            component.set("v.selectedSector",controllerValueKey); 
            component.set("v.simplePRDregistration.Application__c",controllerValueKey);  
        }
        helper.validateField(component, event, helper); 
    },    
    onDependentFieldChange: function(component, event, helper) {
        var controllerValueKey = event.getSource().get("v.value");
        if(controllerValueKey == 'Other')
            component.set("v.otherSelected",true);  
        else{
            component.set("v.otherSelected",false);  
            component.set("v.simplePRDregistration.Other_Installation__c","");            
        }
        component.set("v.simplePRDregistration.Application_Type__c",controllerValueKey); 
        helper.validateField(component, event, helper); 
    },
})