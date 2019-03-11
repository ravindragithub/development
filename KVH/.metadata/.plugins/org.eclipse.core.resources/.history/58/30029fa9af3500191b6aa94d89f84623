({
  handleAppEvent : function(component, event, helper){
    console.log("Success Component Handling Application Event: " + event.getParam("appState"));
    component.set("v.statusMessage", event.getParam("statusMessage"));
    component.set("v.assetList", event.getParam("assetList"));
    if(event.getParam("appState") == "RESET"){
      //search and destroy "c:HTS_asynchJobStatus_cmp"
      var body = component.get("v.body"); //gets a reference to the v.body of the success component
      console.log(body);
      component.set("v.body", []);        //wipes out ALL of the dynamically created components
    }
  },

  handleInsert : function(component, event, helper){
      console.log("Initiating Callout to OSS...");
      //Fire off Inserting event....spinner?
      //Maybe this is a flavor of the component event...
      var searchEvent = component.getEvent("cmpDataUpdated");
      searchEvent.setParam("stateChange", "Inserting");
      searchEvent.fire();
      console.log("Component Event Fired! " + searchEvent.getParam("stateChange"));
      // Create the action...
      var action = component.get("c.provisionForTest");
      action.setParams({"assetList" : component.get("v.assetList"),
                        "synchronous" : false});
      // Add callback behavior for when response is received
      action.setCallback(this, function(response) {
          var state = response.getState();
          //console.log(state);
          if (component.isValid() && state === "SUCCESS") {
              //Fire off a couple of events...
              var returnedObj = response.getReturnValue();
              console.log("Status Message: " + returnedObj.statusMessage );
              //setup and fire COMPONENT event
              var foundEvent = component.getEvent("cmpDataUpdated");
              // Optional: set some data for the event (also known as event shape)
              foundEvent.setParams({"stateChange" :  "Inserted",
                                      "assetList" : returnedObj.assetCollection,
                                      "statusMessage" : returnedObj.statusMessage,
                                      "listLength" : returnedObj.assetCollection.length
                                    });
              foundEvent.fire();
              console.log("Component Event Fired! " + foundEvent.getParam("stateChange") + " " + foundEvent.getParam("statusMessage"));
              //setup and fire APPLICATION Event
              var appEvent = $A.get("e.c:HTS_terminals_application_evt");
              appEvent.setParams({"assetList" : returnedObj.assetCollection,
                                  "statusMessage" : returnedObj.statusMessage
                                  });
              console.log(appEvent.getParam("statusMessage"));
              appEvent.fire();
              console.log("Application Event Fired with: " +appEvent.getParam("statusMessage") );
          } else {
              console.log("Failed with state: " + state);
          }
      });
      // Send action off to be executed
      $A.enqueueAction(action);
  },
  
  handleCmpEvent : function(component, event, helper){
    var currentState = event.getParam("stateChange");
    console.log("Handling component Event in Success Term cmp for state: " + currentState);
    if(currentState == "Inserted"){
      var message = event.getParam("statusMessage");
      console.log(message);
      var assets =  event.getParam("assetList");
      console.log(assets);
      var arrayLength = assets.length;
      console.log(arrayLength);
      for (var i = 0; i < arrayLength; i++) {
        if(assets[i].Product2.ProductCode == "Virtual Terminal ID"){
          console.log(assets[i]);
          //Dynamically create asynchStatus component...
          $A.createComponent(
            "c:HTS_asynchJobStatus_cmp",
            {
              "VTID":assets[i].Name
            },
            function(newComp, status, errorMessage){
              //Add the new component to the body array
              if (status === "SUCCESS") {
                  var body = component.get("v.body");
                  body.push(newComp);
                  component.set("v.body", body);
              }
              else if (status === "INCOMPLETE") {
                  console.log("No response from server or client is offline.")
                  // Show offline error
              }
              else if (status === "ERROR") {
                  console.log("Error: " + errorMessage);
                  // Show error message
              }
            }
          )
        }
      }
    }
  }
})