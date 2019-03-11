({

    fetchPicklistValues: function(component,event, helper, controllerField, dependentField) {
        
        console.log("DependentPickListHelper.js-fetchPicklistValues");
        // call the server side function
        var action = component.get("c.getDependentOptionsImpl");
        // pass paramerters [object name , contrller field name ,dependent field name] -
        // to server side function

        action.setParams({
            'objApiName': component.get("v.objInfo"),
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField
        });
        //set callback
        action.setCallback(this, function(response) {
            console.log(response.getState());
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)
                var StoreResponse = response.getReturnValue();
                
                console.log(StoreResponse);
                //console.log(StoreResponse);
                // once set #StoreResponse to depnedentFieldMap attribute
                component.set("v.depnedentFieldMap", StoreResponse);
				
                // create a empty array for store map keys(@@--->which is controller picklist values)

                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on ui field.

                // play a for loop on Return map
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
				//set the controller field value for ui:inputSelect
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push({
                        selected: true,
                        label: component.get("v.controllingFieldDefault"),
                        value: "None"
                    });
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push({
                        selected: false,
                        label: listOfkeys[i],
                        value: listOfkeys[i]
                    });
                }
                
                
                // set the ControllerField variable values to country(controller picklist field)
                component.set("v.controllingOptions", ControllerField);
                var defaultValue = component.get("v.controllingFieldPreDefault");
                
                if(defaultValue != undefined){
                    window.setTimeout(
                        $A.getCallback(function() {
                              component.find("controllingIdDefault").set("v.value",defaultValue);
                              helper.onLoadControllerFieldChange(component, event, helper,defaultValue);                              
                        }), 1000
                    );
                }
                
               

               // component.set("v.selectedControl", component.get("v.controllingFieldPreDefault"));
                
            }
        });
        $A.enqueueAction(action);
    },


    fetchDepValues: function(component, ListOfDependentFields) {
        
        console.log("DependentPickListHelper.js-fetchDepValues");
        // create a empty array var for store dependent picklist values for controller field)
        var dependentFields = [];

        dependentFields.push({
            selected: true,
            label: component.get("v.dependentFieldDefault"),
            value: "None"
        });
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push({
                selected: false,
                label: ListOfDependentFields[i],
                value: ListOfDependentFields[i]
            });
        }
        console.log(dependentFields);
        if(dependentFields.length>1){
            component.set("v.dependentFlag",true);
        }else{
            component.set("v.dependentFlag",false);
        }
        //console.log(dependentFields);
        // set the dependentFields variable values to State(dependent picklist field) on ui:inputselect
        component.set("v.dependentOptions", dependentFields);
        // make disable false for ui:inputselect field
        //component.set("v.isDependentDisable", false);
    },
    
    onLoadControllerFieldChange: function(component, event, helper,defaultValue) {
       
       
        // get the selected value
        component.set("v.selectedControl", defaultValue);
        var controllerValueKey = defaultValue;

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
            
            var dependentFieldPreDefault = component.get("v.dependentFieldPreDefault");
            //alert(dependentFieldPreDefault);
            if(dependentFieldPreDefault != undefined){
                component.find("dependentIdDefault").set("v.value",dependentFieldPreDefault);
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
        
        
    }
})