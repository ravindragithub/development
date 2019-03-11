({
	initializeCompopnentHelper : function(component, event, helper) {
        component.set("v.spinner", true);
        var action = component.get("c.initializeComponent");  
               
         action.setCallback(this, function(response) {
             var state = response.getState();
             if (state === "SUCCESS") {
                 
                 var userObj = response.getReturnValue().userObj;
                 component.set("v.UserObj",userObj);
                 if(userObj.myKVH_Role__c != undefined && userObj.myKVH_Role__c != ''){
                     component.set("v.hasKVHRole",true);
                 }
                 
                 component.set("v.accountlist",response.getReturnValue().accountlist);
                 component.set("v.productRegInProgress",response.getReturnValue().productRegInProgress);
                 
                 
                 
                 component.set("v.spinner", false);                 
             }else if (state === "ERROR") {
                 var errors = response.getError();
                 if (errors) {
                     if (errors[0] && errors[0].message) {
                         console.log("Error message in initialize: " +
                                     errors[0].message);
                         window.alert("Error message in initialize: " +
                                      errors[0].message);
                     }
                     window.alert("Unknown error try search again");
                 } else {
                     console.log("Unknown error");
                     window.alert("Unknown error try search again");
                 }
                 component.set("v.spinner", false);
             }
         });
         $A.enqueueAction(action);
	},
    deleteUnusedFiles : function(component, event, helper) {
        component.set("v.spinner", true);
        var docIds = component.get('v.documentIds');
           	
        var action = component.get("c.deleteDocuments");  
        action.setParams({
            "docIds" :  docIds
        });   
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var blanklist = [];
                component.set('v.documentIds',blanklist);
               component.set("v.spinner", false);
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                        window.alert("Error message : " +
                                     errors[0].message);
                    }
                    window.alert("Unknown error try search again");
                } else {
                    console.log("Unknown error");
                    window.alert("Unknown error try search again");
                }
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
	}
})