({
    searchHelper : function(component, event, helper, searchinput) {
        var appEvent = $A.get("e.c:ProductSearchEvent");
        appEvent.setParams({ "message" : searchinput, "selectedoption": null });
        appEvent.fire();
    }
})