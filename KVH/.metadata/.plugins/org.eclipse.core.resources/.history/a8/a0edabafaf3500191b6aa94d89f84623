({    
    handleSavehelpler: function (component, event, helpler) {
        component.set("v.spinner", true);   
        var recordId = component.get("v.recordId");
        var emailValue = component.get("v.emailValue");
        var postalValue = component.get("v.postalValue");
        var telephoneValue = component.get("v.telephoneValue");
        var declineValue = component.get("v.declineValue");
        if(
            !component.get("v.emailValue") && 
            !component.get("v.postalValue") &&
            !component.get("v.telephoneValue") &&
            !component.get("v.acceptAllValue") &&
            !component.get("v.declineValue")
        )     {
            this.showToastHelper(component,'Please select the type of communication you wish to receive.');
            component.set("v.spinner", false);   
            return;
        }      
        else if(component.get("v.recordId") == '' || component.get("v.recordId") == null){
            this.showToastHelper(component,'No Contact Record related');
            component.set("v.spinner", false);   
            return;            
        }
        var action = component.get("c.GDPRfieldUpdate");
        action.setParams({recordId : recordId,emailValue:emailValue, postalValue:postalValue, 
                          telephoneValue:telephoneValue,declineValue:declineValue});
        action.setCallback(this, function(a){
            var state = a.getState();
            if(state === "SUCCESS"){                
                var rtnValue = a.getReturnValue();
                component.set("v.confirmFlag",true);
            } else if(state === "ERROR"){
                var sMsg = 'System error: Please contact Airtime Services for assistance. \n';
                    sMsg += 'KVH Airtime Services \n Hours: 6:00 PM Sunday to 5:00 PM Friday (ET) \n Phone: +1 401.851.3862 \n Email: airtimeservices@kvh.com';
                this.showToastHelper(component,sMsg);
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message);
                    }
                }
            }else if (status === "INCOMPLETE") {                
                this.showToastHelper(component,'No response from server or client is offline');
            }
            component.set("v.spinner", false);   
        });
        $A.enqueueAction(action);
    },
    showToastHelper : function(component,text) {
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