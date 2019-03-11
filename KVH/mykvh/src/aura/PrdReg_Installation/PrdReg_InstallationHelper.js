({
    getStateOpts: function(component,contryCode){
        var countryStateMap = component.get('v.countryStateMap');
        var stateList = countryStateMap[contryCode];
        var opts = [];
        if(stateList.length>0){
            for(var i in stateList){
                var stateOpt = {};
                stateOpt.label = stateList[i];
                stateOpt.value = stateList[i];
                opts.push(stateOpt);
            }
        }
        component.set("v.stateOptions", opts);
    },
    validateAddress: function(component){
        var allValid = component.find('addFld').reduce(function (validSoFar, inputCmp) {
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return(allValid);
    }
})