({
    handleStateChange : function(component, event, helper){
        console.log("State Change Handler invoked for: " + event.getName());
        var spinnerDiv = component.find("spinner_div");
        var insertDiv = component.find("insert_div");
        var exceptionDiv = component.find("exception_div");
        var successDiv = component.find("success_div");
        

        var newState = event.getParam("stateChange");
        switch(newState) {
            case "RESET" :
                {
                    component.find("search").set("v.searchString", ""); //only do this on reset, not on search!
                    helper.hideDynamicDivs(component);
                    helper.clearAllAttributes(component);
                }
                break;
            case "Searching" :
                {   // show spinner
                    helper.hideDynamicDivs(component);
                    helper.clearAllAttributes(component);
                    $A.util.removeClass(spinnerDiv, "slds-hide");
                }
                break;
            case "SearchingDone" :
                {   // show spinner
                    $A.util.addClass(spinnerDiv, "slds-hide");
                    if(event.getParam("statusMessage").startsWith("SUCCESS:")){
                        $A.util.removeClass(insertDiv, "toggle"); //Show insert div
                        component.find("insert").set("v.serialNumber", component.find("search").get("v.searchString"));
                    } else {
                        $A.util.removeClass(exceptionDiv, "toggle"); //show exception div
                        var results = event.getParam("satRouterMap");
                        var mapItems = [];
                        for(key in results) {
	                        mapItems.push({key: key, value: results[key]});
	                    }
                        component.find("exception").set("v.searchResults", mapItems);
                        component.find("exception").set("v.statusMessage", event.getParam("statusMessage"));
                        component.find("exception").set("v.assetList", event.getParam("assetList"));
                    }
                }
                break;
            case "Inserting" :
                {   // show spinner
                    helper.hideDynamicDivs(component);
                    $A.util.removeClass(spinnerDiv, "slds-hide");
                }
                break;
            case "InsertingDone" :
                {   // show spinner
                    $A.util.addClass(spinnerDiv, "slds-hide");
                    if(event.getParam("statusMessage").startsWith("SUCCESS:")){
                        $A.util.removeClass(successDiv, "toggle"); //Show insert div
                        component.find("success").set("v.assetList", event.getParam("assetList"));
                        component.find("success").set("v.statusMessage", event.getParam("statusMessage"));
                    } else {
                        $A.util.removeClass(exceptionDiv, "toggle"); //show exception div
                        component.find("exception").set("v.statusMessage", event.getParam("statusMessage"));
                        component.find("exception").set("v.assetList", event.getParam("assetList"));
                    }
                }
                break;
        }
    }
})