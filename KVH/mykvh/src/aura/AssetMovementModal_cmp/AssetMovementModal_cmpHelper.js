({
    removeAssetHelper : function(component) {
        var compEvent = component.getEvent("cmpEvnt");
        compEvent.setParams({"RemovedAsset" : component.get("v.AssetRec") });
        compEvent.fire();
        var appEvent = $A.get("e.c:AssetMovementModal_evt");
        appEvent.setParams({
            className1 : 'slds-backdrop--',
            className2 : 'slds-fade-in-'});
        appEvent.fire();
        
    },
})