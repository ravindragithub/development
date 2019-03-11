({
    selectProduct : function(component, event, helper)
    {   
        var getSelectProduct = component.get("v.oProduct2");
        var compEvent = component.getEvent("oselectedProductEvent");
        compEvent.setParams({"productByEvent" : getSelectProduct });  
        compEvent.fire();
    }
})