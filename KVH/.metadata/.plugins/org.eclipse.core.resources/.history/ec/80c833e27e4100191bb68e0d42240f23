({
    getCurrentUser : function(component, event, helper) {
        var action = component.get("c.getCurrentUser"); // method in the apex class
        action.setCallback(this, function(a) {
            console.log('!!! mykvhrole ' + a.getReturnValue().myKVH_Role__c);
            var hasMyKVHrole;
            if(a.getReturnValue().myKVH_Role__c == undefined)
                hasMyKVHrole = false;
            else
                hasMyKVHrole = true;
            component.set("v.hasMyKVHrole",hasMyKVHrole);
            
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
        
    },
})