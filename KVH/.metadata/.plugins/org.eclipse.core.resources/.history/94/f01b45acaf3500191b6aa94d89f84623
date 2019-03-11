({    
    doInit: function(component, event, helper){
        component.set('v.recieverInfoRequired',false);
    },
    onChangeFreeReceiver: function (component, event, helper) {       
        var changeValue = event.getSource().get("v.label");
        var simpleLTEActivation = component.get("v.simpleLTEActivation");
        simpleLTEActivation.Free_DirectTV_or_DISH_receiver_requested__c = changeValue;
        component.set("v.simpleLTEActivation",simpleLTEActivation);
        if(changeValue == 'Yes'){
            component.set("v.recieverInfoRequired",true);
        }else{
            component.set("v.recieverInfoRequired",false);
        }    
    }
});