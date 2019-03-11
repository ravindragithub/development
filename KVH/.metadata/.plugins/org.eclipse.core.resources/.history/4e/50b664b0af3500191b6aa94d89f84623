({	
    checkFieldValidity : function(component, event, helper) { 
        var validForm = component.find('techCase').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return validForm;
    },
})