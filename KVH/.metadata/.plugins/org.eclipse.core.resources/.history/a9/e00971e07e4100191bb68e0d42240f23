({
	fetchPicklistValues: function(component, objectName, fieldName) {
        console.log("PickListHelper.js-fetchPicklistValues");
        // call the server side function
        var action = component.get("c.getPicklistValues");
        // pass paramerters [object name , contrller field name ,dependent field name] -
        // to server side function

        action.setParams({
            'objApiName': objectName,
            'fieldApiName': fieldName
        });
        console.log(objectName);
        console.log(fieldName);
        //set callback
        action.setCallback(this, function(response) {
            console.log(response.getState());
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)
                var pickList = response.getReturnValue();
                var fieldDefault = component.get("v.fieldDefault");
                console.log(fieldDefault);
                var pickListValues = [];
                if (pickList != undefined && pickList.length > 0 && fieldDefault.length > 0) {
                    pickListValues.push({
                        selected: true,
                        label: fieldDefault,
                        value: "None"
                    });
                }

                for (var i = 0; i < pickList.length; i++) {
                    pickListValues.push({
                        selected: false,
                        label: pickList[i],
                        value: pickList[i]
                    });
                }
                console.log(pickListValues);
                component.set("v.pickListOptions", pickListValues);
            }
        });
        $A.enqueueAction(action);
    },
})