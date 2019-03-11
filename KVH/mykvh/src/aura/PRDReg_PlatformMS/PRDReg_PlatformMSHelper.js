({
    getPlatformTypeHelper : function(component, event, helper) {
        var action = component.get("c.getVesselTypeMap");
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //console.log('==getPlatformTypeHelper==' + JSON.stringify(response.getReturnValue()));
                var StoreResponse = response.getReturnValue();
                component.set("v.platformMap", StoreResponse);
                var Map = component.get("v.platformMap");
                var listOfkeys = [];
                var ControllerField = [];
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }              
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push({
                        class: "optionClass",
                        label: listOfkeys[i],
                        value: listOfkeys[i]
                    });
                }
                component.set("v.options", ControllerField);
            }                    
        });
        $A.enqueueAction(action);
    },
    fetchDepValues: function(component, ListOfDependentFields,item) {
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
})