({
  doLookup : function(component) {
    console.log("this is Helper");
    //Fire off Searching event....
    var searchEvent = component.getEvent("assetHierarchyTemplateSearch");
    searchEvent.setParams({"state" : "SEARCHING"});
    searchEvent.fire();
    console.log("Component Event Fired! " + searchEvent.getParam("status"));
    // Create the action...
    var action = component.get("c.templateSearch");
    console.log(component.get("v.searchString"));
    action.setParams({
      "templateRoot": component.get("v.searchString")
    });
    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
      var state = response.getState();
      console.log(state);
      if (component.isValid() && state === "SUCCESS") {
        var returnedObj = response.getReturnValue();
        console.log("Success with state: " + returnedObj);
        var rows =[];
        var i;
        var resultState = "NOT_FOUND";    //maybe.. unless we enter loop!
        for(i = 0; i < returnedObj.length; i++){
          resultState = "FOUND";
          var row ={
            partNumber:returnedObj[i].Product_Code__c,
            description:returnedObj[i].Type__c,
            parentPartNumber:returnedObj[i].Parent__c,
            name:""
          }
          rows.push(row);
        }
        component.set("v.foundTemplate", rows);
        console.log(component.get("v.foundTemplate"));
        var finishedEvent = component.getEvent("assetHierarchyTemplateSearch");
        // Optional: set some data for the event (also known as event shape)
        finishedEvent.setParams({"state" : resultState,
                                  "foundTemplate" : rows
                                });
        finishedEvent.fire();
        console.log("Component Event Fired! " + finishedEvent.getParam("state"));
      } else {
        console.log("Failed with state: " + state);
        var finishedEvent = component.getEvent("assetHierarchyTemplateSearch");
        // Optional: set some data for the event (also known as event shape)
        finishedEvent.setParams({"state" : "ERROR"});
        finishedEvent.fire();
      }
    });
    // Send action off to be executed
    $A.enqueueAction(action);
  }
})