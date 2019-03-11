({
    closeModal : function(component, event, helper) {
        var appEvent = $A.get("e.c:AssetMovementModal_evt");
        appEvent.setParams({
            className1 : 'slds-backdrop--',
            className2 : 'slds-fade-in-'});
        appEvent.fire();
    },
    replaceAsset : function(component, event, helper) {
        component.set("v.MainContentFlag",false);
        component.set("v.title",'Replace Asset');
        component.set("v.ReplacementType","Replace");
        var forOpen = component.find("contentsection");
        $A.util.addClass(forOpen, 'enlargeSection');
        
    },
    addAsset : function(component, event, helper) {
        component.set("v.MainContentFlag",false);
        component.set("v.title",'Add Asset');
        component.set("v.ReplacementType","Add");
        var forOpen = component.find("contentsection");
        $A.util.addClass(forOpen, 'enlargeSection');
    },
    removeAsset : function(component, event, helper) {
        var r = confirm("Are you sure you want to remove the Asset ?");
        if (r)
        {
            helper.removeAssetHelper(component);
        }
    },
    submitReplacement : function(component, event, helper) {
        
        if(component.get("v.ReplacementType") == 'Asset Added')
        {
            var appEvent = $A.get("e.c:AssetMovementModal_evt");
            appEvent.setParams({
                className1 : 'slds-backdrop--',
                className2 : 'slds-fade-in-'});
            appEvent.fire();
        }
        else
            alert('Please select the Replacement/Add Assets');
    },
    handleComponentEvent : function (component, event, helper) {
        var selectedReplacementAsset = event.getParam("SelectedAsset");
        if(typeof selectedReplacementAsset != 'undefined')
            component.set("v.ReplacementType",'Asset Added');
    },
    backReplacement : function (component, event, helper) {
        component.set("v.MainContentFlag",true);
        var forOpen = component.find("contentsection");
        $A.util.removeClass(forOpen, 'enlargeSection');
    },
})