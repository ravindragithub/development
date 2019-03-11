({
    
    /**
     * function used to fire QuickLinkEvent event
     * used to send details of selected Quick Link option
     */
    fireQuickLinkEvent : function (component,event) {
        
        var cmpEvent = component.getEvent("QuickLink");
        var kit;
        if(component.get("v.quicklink").QuickLink_Label__c === 'Sales Tool Kits'){
            kit = true;
        } else {
            kit = false;
        }
        cmpEvent.setParams({
            "quickaction" : component.get("v.quicklink").QuickLink_Label__c ,
            "contenttypes" : component.get("v.quicklink").Content_Type_s__c ,
            "salestoolkit" : kit
        });
        cmpEvent.fire();
        
    }
    
})