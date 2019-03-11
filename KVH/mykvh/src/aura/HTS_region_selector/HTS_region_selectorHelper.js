({
  helpUpdatePicklists : function(component, regionList) {
    console.log("Helping to setup Picklist...");
    
    component.set("v.configTemplates", regionList); 
    var regions = [];
    var arrayLength = regionList.length;
    for (var i = 0; i < arrayLength; i++) {
      var oneRegion = {label: regionList[i].Region__c,
                        value: regionList[i].obj_id__c,
                        selected: false,
                        disabled: true};
      if(regionList[i].isReleased__c == true){
        console.log("Found unreleased region!!");
        oneRegion.disabled = false;
      }
      if(regionList[i].isDefault__c){
        console.log("Found default region!!");
        oneRegion.selected = true;
      }
      regions.push(oneRegion);
    }
    component.set("v.options", regions);
    console.log(component.get("v.options"));
  },
  compareRegionVersion : function(component){
    console.log("Comparing region and version...");
    var actionReq = "Terminal is using Non-standard Template!";
    var selectedRegion = component.get("v.selectedRegion");
    var template = component.get("v.enabledTerminal.template_id");
    var version = component.get("v.enabledTerminal.template_version");
    var regionList = component.get("v.configTemplates");
    var regionMap = new Map();
    regionList.forEach(obj => regionMap.set(obj.Name, obj));
    console.log(regionMap);

    if(regionMap.get(template) === undefined){
      actionReq = "Terminal using non-standard template!";
    } else if(selectedRegion == template){
      //Region matches, check version!
      if(version == regionMap.get(selectedRegion).Version__c){
        actionReq = "Terminal template up to date";

        $A.createComponent(
          "lightning:button",
          {
            "aura:id": "nothingtodo",
            "label": "Nothing to do! Click to Continue...",
            "variant": "brand",
            "iconName": "utility:smiley_and_people",
            "iconPosition": "left",
            "onclick": component.getReference("c.handleNothingToDo")
          },
          function(newButton, status, errorMessage){
            //Add the new button to the body array
            if (status === "SUCCESS") {
                var body = component.get("v.body");
                body = [];
                body.push(newButton);
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
        );
      } else {
        actionReq = "Terminal template needs update!";

        $A.createComponent(
          "lightning:button",
          {
            "aura:id": "update",
            "label": "Update Terminal Template",
            "variant": "brand",
            "iconName": "utility:refresh",
            "iconPosition": "left",
            "onclick": component.getReference("c.handleUpdateTemplate")
          },
          function(newButton, status, errorMessage){
            //Add the new button to the body array
            if (status === "SUCCESS") {
                var body = component.get("v.body");
                body = [];
                body.push(newButton);
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
        );

      }
    } else {
      actionReq = "Terminal template needs to be changed!";

      $A.createComponent(
        "lightning:button",
        {
          "aura:id": "changeRegion",
          "label": "Change Terminal Region",
          "variant": "brand",
          "iconName": "utility:replace",
          "iconPosition": "left",
          "onclick": component.getReference("c.handleChangeTemplate")
        },
        function(newButton, status, errorMessage){
          //Add the new button to the body array
          if (status === "SUCCESS") {
              var body = component.get("v.body");
              body = [];
              body.push(newButton);
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
      );

    }
    component.set("v.actionRequired", actionReq);
  },
  helpUpdateTemplate : function(component, event, helper, mode){
    var action = component.get("c.updateTerminal");
    var term = component.get("v.enabledTerminal");
    console.log(term);
    action.setParams({"terminal_id": term.terminal_id,
                      "terminal_ip_address": term.terminal_ip_address,
                      "template_id": term.template_id,
                      "terminaltype_id": term.terminaltype_id});
      action.setCallback(this, function(response){
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        //setup and fire EVENT or set values...
        var cmpEvent = component.getEvent("cmpDataUpdated");
        cmpEvent.setParams({"jobId": returnObj,
                            "stateChange": "asynchJobEnqueued"});
        cmpEvent.fire();
        //disable the button....
        component.find(mode).set("v.disabled", true);
        //component.set(disableTheButton, true);
      } else if (component.isValid() && state === "ERROR"){
        console.log("c.updateTerminal Failed with state: " + state); 
      }

    });
    $A.enqueueAction(action);
  }
})