({
    initialize : function(component, event, helper) {
        console.log("DependentPickListController.js-initialize");
        window.setTimeout(
            $A.getCallback(function() {
                //call the helper function with pass [component, Controller field and Dependent Field] Api name
                helper.fetchPicklistValues(component,event, helper,
                    component.get("v.controllingField"),
                    component.get("v.dependentField")
                );
            }), 1000
        );
        
    },
    
    // function call on change tha controller field
    onControllerFieldChange: function(component, event, helper) {
       
        console.log("DependentPickListController.js-onControllerFieldChange");
        //alert('Controlling field value:'+event.getSource().get("v.value"));
        // get the selected value
        component.set("v.selectedControl", event.getSource().get("v.value"));
        var controllerValueKey = event.getSource().get("v.value");

        // get the map values
        var Map = component.get("v.depnedentFieldMap");

        // check if selected value is not equal to None then call the helper function.
        // if controller field value is none then make dependent field value is none and disable field
        if (controllerValueKey != 'None') {

            // get dependent values for controller field by using map[key].
            // for i.e "India" is controllerValueKey so in the map give key Name for get map values like
            // map['India'] = its return all dependent picklist values.
            var ListOfDependentFields = Map[controllerValueKey];
            helper.fetchDepValues(component, ListOfDependentFields);
            if (ListOfDependentFields.length > 0){
                component.set("v.hasStateValues", true);
                component.set("v.isDependentDisable", false);
            } else{
                component.set("v.hasStateValues", false);
            }

        } else {
            var defaultVal = [{
                selected: true,
                label: component.get("v.dependentFieldDefault"),
                value: 'None'
            }];
            component.set("v.dependentOptions", defaultVal);
            component.set("v.isDependentDisable", true);
            component.set("v.hasStateValues", false);
        }
    },

    // function call on change tha Dependent field
    onDependentFieldChange: function(component, event, helper) {
        console.log("DependentPickListController.js-onDependentFieldChange");
        component.set("v.selectedDependent", event.getSource().get("v.value"));
        //alert('Dependent field selected:'+event.getSource().get("v.value"));
    }
})