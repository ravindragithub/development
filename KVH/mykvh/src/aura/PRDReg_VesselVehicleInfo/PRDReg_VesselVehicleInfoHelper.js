({
    getPlatformTypeHelper : function(component, event, helper){
        var action = component.get("c.getVesselTypeMap");
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var StoreResponse = response.getReturnValue();
                component.set("v.platformMap", StoreResponse);
                //var Map = component.get("v.platformMap");
                var listOfkeys = [];
                var ControllerField = [];
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }              
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }
                component.set("v.options", ControllerField);
            }                    
        });
        $A.enqueueAction(action);
    },
    fetchDepValues: function(component, ListOfDependentFields,item){
        var dependentFields = [];
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push({
                class: "optionClass",
                label: ListOfDependentFields[i],
                value: ListOfDependentFields[i]
            });
        }
        if(item == 'market')
            component.set("v.marketList", dependentFields);
        else            
            component.set("v.sectorList", dependentFields);
    },
    validateField : function(component, event, helper) {
        component.set("v.vesselInfoRequired",true);
        if(component.get("v.selectedPT")!='' && component.get("v.selectedSector")!='' && component.get("v.selectedAppType")!=''){
            if((component.get("v.selectedPT") == 'Vehicle' && !$A.util.isEmpty(component.get("v.simplePRDregistration.RV_or_Vehicle_Make_Model__c"))) || 
               (component.get("v.selectedPT") == 'Vessel' &&  !$A.util.isEmpty(component.get("v.simplePRDregistration.Vessel_Name__c")))){
                component.set("v.vesselInfoRequired",false);
            }
        }
    }
})