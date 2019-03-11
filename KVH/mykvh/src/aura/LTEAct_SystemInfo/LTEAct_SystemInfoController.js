({
    systemValidation : function(component, event, helper) {
        //console.log(helper.handleUploadAction(component));
        if(helper.handleUploadAction(component)){
            component.set("v.serviceRequired",false);   
        }else{
            component.set("v.serviceRequired",true);    
        }
    },
    openPicker : function(component, event, helper) {
        var toggleText = component.find("text");
        $A.util.toggleClass(toggleText, "toggle");
    },
})