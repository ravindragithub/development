({    
    handleUploadAction : function(component) {
        var allValid = component.find('LTEField').reduce(function (validSoFar, inputCmp) {
            //inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return(allValid);        
    },
    getContactHelper : function(component, event, helper) {
        console.log('getContactHelper')
        var action = component.get("c.getContactInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("From server: " + JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
                setTimeout(function () {
                    if (newState == -1) {
                        //alert('VIDEO HAS STOPPED');
                    }
                }, 10000);
                component.set("v.simpleLTEActivation.Subscriber_Email__c", response.getReturnValue().email);
                component.set("v.simpleLTEActivation.Contact_email__c ", response.getReturnValue().email);
                component.set("v.simpleLTEActivation.Subscriber_Phone__c", response.getReturnValue().mobilePhone);
                component.set("v.simpleLTEActivation.Main_Contact_FirstName_Subscriber__c", response.getReturnValue().firstName);
                component.set("v.simpleLTEActivation.Main_Contact_LastName_Subscriber__c", response.getReturnValue().lastName);
                component.set("v.simpleLTEActivation.Antenna_Serial_No__c", response.getReturnValue().serialNumber);
                component.set("v.spinner", false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action); 
    },
})