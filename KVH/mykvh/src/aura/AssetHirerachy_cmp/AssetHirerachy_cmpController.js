({
    doInit : function(component, event, helper) 
    {
        if(component.get("v.assetId") != null)
            helper.getAssetHierarchy(component);
    },
})