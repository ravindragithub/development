({
    fireQuickLinkEvent : function (component,event) {
        console.log('firing event');
        var cmpEvent = component.getEvent("SalesKitQuickLink");
        cmpEvent.setParams({
            "quickaction" : component.get("v.saleskit").Sales_Tool_Kit_Label__c ,
            "salestoolkit" : component.get("v.saleskit").Sales_Kit__c
        });
        cmpEvent.fire();

    }
})