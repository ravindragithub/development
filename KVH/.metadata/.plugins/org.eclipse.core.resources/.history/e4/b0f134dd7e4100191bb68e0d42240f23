({
    callAttachmentList : function(component, event, helper) {  
        component.set("v.spinner",true);
        var action = component.get("c.getListAttachment");
        action.setParams({ ProdRegId : component.get("v.objectId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.spinner",false);
            if (state === "SUCCESS") {
                //console.log("From callAttachmentList : " + JSON.stringify(response.getReturnValue()));  
                component.set("v.attachmentList",response.getReturnValue());
                if(component.get("v.attachmentList").size() > 0 )
                    component.set("v.attachmentCheck",true);
            }         
            else if (state === "ERROR") {
                var errors = response.getError();
                var sMsg = 'System error: Please contact Airtime Services for assistance. \n';
                sMsg += 'KVH Airtime Services \n Hours: 6:00 PM Sunday to 5:00 PM Friday (ET) \n Phone: +1 401.851.3862 \n Email: airtimeservices@kvh.com';
                this.handleShowError(component,sMsg);  
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
    deleteAttachmentList : function(component, docId,type) {     
        component.set("v.spinner",true);
        var action = component.get("c.deleteAttachmentList");
        action.setParams({ CVId : docId , ProdRegId : component.get("v.objectId"),typeDoc : type });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.spinner",false);
            if (state === "SUCCESS") {
                component.set("v.attachmentList",response.getReturnValue());
                if(component.get("v.attachmentList").size() > 0 )
                    component.set("v.attachmentCheck",true);
                this.handleShowInfo(component, "Delete" ,"File removed successfully");
            }        
            else if (state === "ERROR") {
                var errors = response.getError();
                var sMsg = 'System error: Please contact Airtime Services for assistance. \n';
                sMsg += 'KVH Airtime Services \n Hours: 6:00 PM Sunday to 5:00 PM Friday (ET) \n Phone: +1 401.851.3862 \n Email: airtimeservices@kvh.com';
                this.handleShowError(component,sMsg);  
                console.log("message:: " + errors[0].message );
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
    handleShowInfo : function(component,title,text) {     
        var showToast = $A.get("e.force:showToast"); 
        showToast.setParams({ 
            title : 'Success',
            duration:'5000',
            type: 'info',
            mode: 'dismissible',
            message: text
        }); 
        showToast.fire(); 
    },    
    handleShowError : function(component,text) {     
        var showToast = $A.get("e.force:showToast"); 
        showToast.setParams({ 
            'title' : 'Error', 
            "type": "error",
            "mode": 'sticky',
            'message' : text
        }); 
        showToast.fire(); 
    },    
})