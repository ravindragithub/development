({	
    closeBtn : function(component, event, helper) {
        var cmpTarget = component.find('showError');
        $A.util.addClass(cmpTarget, 'errorToast');
    },
})