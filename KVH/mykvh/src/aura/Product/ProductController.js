({
    showProductDetail : function (component,event,helper) {
        var cmpEvent = component.getEvent("showproduct");
        cmpEvent.setParams({
            "product" : component.get("v.product.productItem.Id"),
            "prodid" : component.get("v.product.productItem.Product_Market_Sector__r.Product__c")
        });
        cmpEvent.fire();
    }
})