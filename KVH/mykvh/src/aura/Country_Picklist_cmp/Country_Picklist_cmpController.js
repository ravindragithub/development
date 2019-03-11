({
    doInit : function(component, event, helper) {
        var stateMap = component.get("v.stateMap");
        var detailtemp = {};
        detailtemp = { 'class': '', 'label': '', 'value': '' };
        detailtemp.label = "";
        var opts = [];
        var stateList = [];
        opts.push(detailtemp);
        for (var singlekey in stateMap) {	
            if(singlekey == 'US'){
                detailtemp = { 'class': '', 'label': '', 'value': '' };
                detailtemp.class = "optionClass";
                detailtemp.label = stateList[i];
                detailtemp.value = stateList[i];
                opts.push(detailtemp);
            }
        }
        component.set("v.stateList", opts);
    },
    onCountrySelect: function(component, event, helper) {
        var acc = component.get("v.countryList")[component.get("v.country")];
        var selectedCountry = '';
        if(typeof acc != 'undefined'){
            selectedCountry = acc.label;
            var selectedCountryCode = acc.value;
            component.set("v.selectedCountry",selectedCountry);
            helper.getStateHelper(component, selectedCountryCode);
        }
    },
    onStateChange: function(component) {
        var state= component.get("v.stateList")[component.get("v.state")];
        var selectedState = '';
        if(typeof state != 'undefined'){
            selectedState = state.label;
            var selectedstateCode = state.value;         
        } 
        component.set("v.selectedState",selectedState);  
    },
})