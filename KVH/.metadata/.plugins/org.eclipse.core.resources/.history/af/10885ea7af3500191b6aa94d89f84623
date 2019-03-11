({
    hideDynamicDivs: function(component) {
        console.log("Hiding visible divs...");
        //Add the Toggle Class to all dynamic divs
        var insert_cmp = component.find("insert_div");
        $A.util.addClass(insert_cmp, "toggle"); 
 
        var exception_cmp = component.find("exception_div");
        $A.util.addClass(exception_cmp, "toggle"); 
        
        var existing_cmp = component.find("existing_div");
        $A.util.addClass(existing_cmp, "toggle"); 
        
        var success_cmp = component.find("success_div");
        $A.util.addClass(success_cmp, "toggle"); 
    },
    clearAllAttributes : function(component){
        var insertCmp = component.find("insert");
        insertCmp.set("v.serialNumber", "");
        insertCmp.set("v.provisioningKey", "");
        insertCmp.set("v.revision", "");
        var successCmp = component.find("success");
        successCmp.set("v.assetList", []);
        successCmp.set("v.statusMessage", "");
        var exceptionCmp = component.find("exception");
        exceptionCmp.set("v.assetList", []);
        exceptionCmp.set("v.statusMessage", "");
        exceptionCmp.set("v.searchResults", []);
        console.log("All Attributes CLeared!");
    }
})