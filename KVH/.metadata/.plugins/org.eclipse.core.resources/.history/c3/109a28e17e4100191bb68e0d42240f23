({
    searchHelper : function(component,event,getInputkeyWord) 
    {
        var action = component.get("c.fetchAsset");
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var count = 0;
            if (state === "SUCCESS") {
                var storeResponse = [];
                storeResponse = response.getReturnValue();
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    for(var key in storeResponse)
                    count++;
                    component.set("v.Message", 'TOTAL SEARCH ASSETS:');
                }
                
                if(count == 0)
                    component.set("v.listofRecordsCount", 0);
                else
                    component.set("v.listofRecordsCount", count);
                
                component.set("v.listOfSearchRecords", storeResponse);
            }
        });
        $A.enqueueAction(action);
    }
})