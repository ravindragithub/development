({
    doInit: function(component, event, helper) {
        console.log(component.get("v.node.Name"));
    },
    
    toggle: function(component, event, helper) {
        component.set("v.expanded", !component.get("v.expanded"));
    },
    handleCheckTask : function(component, event, helper) {
        var index = component.find("button1").get("v.text"); 
        var compEvent = component.getEvent("cmpEvnt");
        compEvent.setParams({"ReplacedAsset" : index });
        compEvent.fire();
        helper.toggleClass(component,'backdrop','slds-backdrop--');
        helper.toggleClass(component,'modaldialog','slds-fade-in-');
    },
    closeModal : function(component, event, helper) {
        var className1 = event.getParam("className1");
        var className2 = event.getParam("className2");
        helper.toggleClassInverse(component,'backdrop',className1);
        helper.toggleClassInverse(component,'modaldialog',className2);
    },
    
})