({
    getPlatformTypeHelper : function(component, event, helper) {
        var action = component.get("c.getVesselTypeMap");
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
               //component.set("v.simpleLTEActivation.Market__c",'Leisure'); 
                //component.set("v.simpleLTEActivation.Sector__c",'Marine Systems'); 
                //component.set("v.simpleLTEActivation.Flag__c",'United States'); 
                var StoreResponse = response.getReturnValue();
                component.set("v.platformMap", StoreResponse);
                var Map = component.get("v.platformMap");
                controllerValueKey = 'Leisure';
                var intiMap = Map[controllerValueKey]; 
                component.set("v.marketMap", intiMap);
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
                var controllerValueKey = "Leisure";
                var controllerValueKey2 = "Marine Systems";
                if (controllerValueKey != '') {
                    var ListOfDependentMap = StoreResponse[controllerValueKey];
                    var ListOfDependentMap2 = ListOfDependentMap[controllerValueKey2];
                    component.set("v.selectedMarket",controllerValueKey); 
                    component.set("v.selectedSector",controllerValueKey2); 
                    var listOfkeys = [];
                    for (var singlekey in ListOfDependentMap) {
                        listOfkeys.push(singlekey);
                    }
                    this.fetchDepValues(component, listOfkeys,'market');
                    this.fetchDepValues(component, ListOfDependentMap2,'sector');
                } 
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