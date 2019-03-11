({	
    getStateHelper : function(component, selectedCountryCode) {
        var action = component.get("c.getStateMap");
        action.setParams({ "countryCode" : selectedCountryCode });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stateList = response.getReturnValue(); 
                var opts = [];             	
                if(!$A.util.isEmpty(stateList) && !$A.util.isUndefined(stateList)){
                    var i;
                    var detailtemp = {};
                    detailtemp = { 'class': '', 'label': '', 'value': '' };
                    detailtemp.label = "";
                    //opts.push(detailtemp);                    
                    for(i in stateList){    
                        detailtemp = { 'class': '', 'label': '', 'value': '' };
                        detailtemp.class = "optionClass";
                        detailtemp.label = stateList[i];
                        detailtemp.value = stateList[i];
                        opts.push(detailtemp);
                    } 
                    component.set("v.isRequiredState",true);
                    component.set("v.selectedState",'');
                }
                else{
                    var detailtemp = {};
                    detailtemp = { 'class': '', 'label': '', 'value': '' };
                    detailtemp.class = "optionClass";
                    detailtemp.label = "";
                    detailtemp.value = "";
                    //opts.push(detailtemp);                    
                    component.set("v.isRequiredState",false);
                    component.set("v.selectedState",'--None--');
                }
                component.set("v.stateList", opts);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);        
    },
})