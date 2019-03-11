/**
 * Created by Jai Chaturvedi on 9/03/2017.
 */
({
    handlePortalViewChangeEvent: function(component, event, helper) {
        var selectedOption = event.getParam("selectedOption");
        component.set("v.selectedView", selectedOption);
        var bgOptionImage = event.getParam("bgOptionImage");
        var bgImage = '';
        var bgcss = '';
        if(bgOptionImage != undefined){
            var tempbgArray = bgOptionImage.split(';');
            bgImage = tempbgArray[0];
            if(tempbgArray.length == 2)
                bgcss = tempbgArray[1];
        }
        component.set("v.bgcss",bgcss);
        component.set("v.bgColor",event.getParam("bgColor"));
        //alert(bgOptionImage);
        bgOptionImage = $A.get("$Label.c.Community_URL") + '/resource/service_component_bg_images/' + bgImage;
        component.set("v.backgroundImage",bgOptionImage);

        if (selectedOption && component.get("v.serviceLabelfieldApiName")) {
            //console.log('in side apex callout');
            var action = component.get("c.constructTopOptions");
            action.setParams({
                portalOption: selectedOption,
                fieldAPINames: component.get("v.serviceLabelfieldApiName")
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('services jitu =>');
                    console.log(response.getReturnValue());
                    component.set("v.partnerMainServices", response.getReturnValue());
                    var gridLength = 'slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-1 slds-large-size--1-of-' + response.getReturnValue().length;
                    component.set("v.gridClass", gridLength);
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            //console.log("Error message on handlePortalViewChangeEvent: " + errors[0].message);
                        }
                    } else {
                        //console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }       
        
    }
})