({
    initialize: function(component, event, helper) {     
        helper.getUrlParameter(component, event, helper);
    },
    handleForgotPass: function(component, event, helper) { 
        component.set("v.spinner",true);
        if( $A.util.isEmpty(component.find('username').get("v.value")) ){
            component.set("v.spinner",false);
            helper.showToastHelper(component,'Enter a value in Email');
        }
        else
            helper.validateUsername(component, event, helper);
        
    },
    onKeyUp: function(component, event, helper){
        if (event.getParam('keyCode')===13) {           
            //component.set("v.spinner",true);
            //	helper.validateUsername(component, event, helper);
        }
    }
})