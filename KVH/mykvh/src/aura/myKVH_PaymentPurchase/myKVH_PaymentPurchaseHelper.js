({
	callAttachmentList : function(component, event, helper) {        
		var action = component.get("c.getListAttachment");
        action.setParams({ ProdRegId : component.get("v.simpleLTEActivation.Id") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From callAttachmentList : " + JSON.stringify(response.getReturnValue()));
                component.set("v.attachmentList",response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);      
	},
    deleteAttachmentList : function(component, docId) {   
		var action = component.get("c.deleteAttachmentList");
        action.setParams({ CVId : docId , ProdRegId : component.get("v.simpleLTEActivation.Id") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From callAttachmentList : " + JSON.stringify(response.getReturnValue()));
                component.set("v.attachmentList",response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);      
	}
})