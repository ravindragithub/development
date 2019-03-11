({
    handleAppEvent : function(component, event, helper){
        console.log("Container Component Handling Application Event: " + event.getParam("appState"));
    },
    handleCmpEvent : function(component, event, helper){
        console.log("Event Handler invoked for: " + event.getName());
        var statusMessage = event.getParam("statusMessage");
        var listSize = event.getParam("listLength");
        var eventList = event.getParam("assetList");
        var newState = event.getParam("stateChange");
        console.log("Container Component Handling Component Event: " + newState);

        var exceptionDiv = component.find("exception_div");
        var successDiv = component.find("success_div");
        var insertDiv = component.find("insert_div");
        var spinnerDiv = component.find("spinner_div");

        switch(newState) {
            case "RESET":
                { //do Reset stuff
                  //setup and fire APPLICATION Event
                  var appEvent = $A.get("e.c:HTS_terminals_application_evt");
                  appEvent.setParams({"appState":"RESET",
                                      //<!-- from search component -->
                                      "searchString" : null,
                                      //<-- from insert, success component -->
                                      "systemSerialNumber" : null,
                                      "adminIP" : null,
                                      "swSerialNumber" : null,
                                      "MTAMAC" : null,
                                      "satRouter" : null,
                                      //<!-- from success, exception component -->
                                      "statusMessage" : null,
                                      "assetList" : null });
                  appEvent.fire();
                  helper.initHelp(component, event, helper);
                }
                break;

            case "Searching":
                {
                    console.log("Searching");
                    helper.hideThreeDivs(component);
                    $A.util.removeClass(spinnerDiv, "toggle");
                }
                break;

            case "SearchComplete":
                {//do search complete stuff
                    $A.util.addClass(spinnerDiv, "toggle");
                    console.log("SearchComplete");
                    if(listSize == 1){
                        //show existing component, propagate searchResults attribute
                        $A.util.toggleClass(exceptionDiv, "toggle");

                        //Hide previous div
                    } else if(listSize == 0){
                        //show existing component, propagate searchResults attribute
                        $A.util.toggleClass(insertDiv, "toggle");

                        component.find("insert").set("v.systemSerialNumber", component.find("search").get("v.searchString")); 
                        //Hide previous div
                    }
                }
                break;


            case "Inserting":
                {
                    console.log("Inserting");
                    $A.util.removeClass(spinnerDiv, "toggle");
                }
                break;

            case "Inserted":
                {
                    $A.util.addClass(spinnerDiv, "toggle");
                    console.log("Inserted");
                    if(statusMessage.startsWith("ERROR:")){
                        $A.util.removeClass(exceptionDiv, "toggle");
                    } else {
                        $A.util.addClass(insertDiv, "toggle")
                        $A.util.addClass(exceptionDiv, "toggle");
                        $A.util.removeClass(successDiv, "toggle");
                    }
                }
                break;
        }

    },
    doInit : function(component, event, helper){
      helper.initHelp(component, event, helper);
    },
    handleInsertI2CM : function(component, event, helper){ //Do we need this???
        var message = event.getParam("statusMessage");
        var assets = event.getParam("assetList");
        console.log("Event Handler invoked for: " + event.getName());
        component.find("success").set("v.statusMessage", message); 
        component.find("success").set("v.assetList", assets);
    }
})