({
    callAction: function(component, method, callback, params){
        component.set("v.spinner", true);
        var action = component.get(method);
        if(params) action.setParams(params);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                if(response.getReturnValue()){
                    callback.call(this, response.getReturnValue());
                }
                component.set("v.spinner", false);
            }else if(state === "INCOMPLETE"){
                this.showToast('error', 'Error!', 'Unknown error');
                component.set("v.spinner", false);
            }else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        this.showToast('error', 'Error!', errors[0].message);
                    }
                }else{
                    this.showToast('error', 'Error!', 'Unknown error');
                }
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    showToast: function(typ, titl, msg){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": typ,
            "title": titl,
            "message": msg,
            "mode": 'sticky'
        });
        toastEvent.fire();
    }
})