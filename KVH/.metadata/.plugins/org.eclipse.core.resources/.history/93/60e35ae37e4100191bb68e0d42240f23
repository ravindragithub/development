({
	showeditsection : function(component, event, helper) {
		 var appEvent = $A.get("e.c:profileeditClickEvent");
            appEvent.setParams({
                "showview": true,
                "showedit": false,
                "showThankyou": false
         });
         appEvent.fire();
	},
    showemailchangealert :function(component, event, helper) {        
        component.set("v.showpopup","slds-show");
    },
    closepopup :function(component, event, helper) {        
        component.set("v.showpopup","slds-hide");
    },
    setfocustoemail:function(component, event, helper) {    
        var emailfield = component.find("emailfield");
        console.log(emailfield);
        component.set("v.showpopup","slds-hide");
        setTimeout(function(){ emailfield.focus(); component.set("v.showpopup","slds-hide"); }, 200);
    },
    doInit: function(component, event, helper) {
        console.log("in profile view component");
        var action = component.get("c.getUserDetails");
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
				component.set("v.userdetail",response.getReturnValue());
               
                var salutationOpt = JSON.parse(response.getReturnValue().salutationOptions);                
                component.find("salutationOpt").set("v.options",salutationOpt);
                
                var jobfunctionOpt = JSON.parse(response.getReturnValue().jobfunctionOptions);                
                component.find("jobfunctionOpt").set("v.options",jobfunctionOpt);
                
                var countryOpt = JSON.parse(response.getReturnValue().countryOtions);  
                component.find("countryOpt").set("v.options",countryOpt);
                
                var stateOptions = response.getReturnValue().stateoptions;
                component.set("v.stateOptions",stateOptions);
                
                helper.showstatelisthelper(component, event, helper,response.getReturnValue().con.MailingState);
             
               
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on profile load: " +errors[0].message);
                    }
                } else {
                    console.log("Unknown error profile view");
                }
            }
        });
        $A.enqueueAction(action);
    },
    showstatelist : function(component, event, helper) {
		helper.showstatelisthelper(component, event, helper,'');
	},
    saveChangesaction : function(component, event, helper) {  
        var appEvent = $A.get("e.c:profileSpinnerEvent");
        appEvent.setParams({
            "showspinner": "slds-show"
        });
        appEvent.fire();
        
        var action = component.get("c.updateUserRecord");
         var userdetails = component.get("v.userdetail");
        console.log(userdetails);
         action.setParams({
             userdetailJson : JSON.stringify(userdetails)
         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                
                 var appEvent = $A.get("e.c:profileSpinnerEvent");
                    appEvent.setParams({
                        "showspinner": "slds-hide"
                 });
                 appEvent.fire();
                
                var appEvent = $A.get("e.c:profileeditClickEvent");
                    appEvent.setParams({
                        "showview": false,
                        "showedit": false,
                        "showThankyou": true
                 });
                 appEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on profile load: " +errors[0].message);
                    }
                } else {
                    console.log("Unknown error profile view");
                }
            }
        });
        $A.enqueueAction(action);
	}
    
    
})