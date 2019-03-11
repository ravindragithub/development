({
    doInit: function(component, event, helper) {
        //helper.getContactHelper(component, event, helper);
    },
    subscriberValidation : function(component, event, helper) {
        var isValidEmail = true; 
        if(helper.handleUploadAction(component) &&
           (component.get("v.simpleLTEActivation.Subscriber_Country__c") != null && component.get("v.simpleLTEActivation.Subscriber_Country__c") != '') &&
           (component.get("v.simpleLTEActivation.Subscriber_State_Province_Territory__c") != null && component.get("v.simpleLTEActivation.Subscriber_State_Province_Territory__c") != '')
          )
            component.set("v.subInfoRequired",false);        
        else
            component.set("v.subInfoRequired",true);      
    },
    handleCountryValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Subscriber_Country__c",currentvalue);        
        var a = component.get('c.subscriberValidation');
        $A.enqueueAction(a);  
    },
    handleStateValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Subscriber_State_Province_Territory__c",currentvalue);        
        var a = component.get('c.subscriberValidation');
        $A.enqueueAction(a);  
    }
})