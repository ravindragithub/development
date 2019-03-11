({
    doInit: function(component, event, helper) {
        helper.getEventlistHelper(component, event, helper);
    },
    
    openpopup: function(component, event, helper) {
        component.set("v.showpopup", 'slds-show');       
    },
    closepopup: function(component, event, helper) {
        component.set("v.showpopup", 'slds-hide');       
    },
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    }
})