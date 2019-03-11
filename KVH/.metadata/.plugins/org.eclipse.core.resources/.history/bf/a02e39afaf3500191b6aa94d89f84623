({
    handleInsert: function(component, event, helper) {
        //validate input attributes
        var isnum = /^\d+$/.test(component.get("v.serialNumber"));
        console.log("serialNumber validation: " + isnum);

        //var isnum = /^\d+$/.test(component.get("v.provisioningKey"));
        //console.log("provisioningKey validation: " + isnum);

        //var isnum = /^\d+$/.test(component.get("v.revision"));
        //console.log("revision validation: " + isnum);
        
        helper.doInsert(component);

    }
})