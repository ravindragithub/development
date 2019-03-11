({
    subscriberValidation : function(component, event, helper) {
        component.set("v.billingInfoFlag",false); 
        component.set("v.customerInfoFlag",false); 
        var isValidEmail = true; 
        if(helper.handleUploadAction(component) &&
           (component.get("v.simplePRDregistration.Subscriber_Country__c") != null && component.get("v.simplePRDregistration.Subscriber_Country__c") != '') &&
           (component.get("v.simplePRDregistration.Subscriber_State_Province_Territory__c") != null && component.get("v.simplePRDregistration.Subscriber_State_Province_Territory__c") != '')
          )
            component.set("v.subInfoRequired",false);        
        else
            component.set("v.subInfoRequired",true);      
    },
    handleCountryValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        var prdReg = component.get("v.simplePRDregistration");
        prdReg.Subscriber_Country__c = currentvalue;
        component.set("v.simplePRDregistration",prdReg);
        //component.set("v.simplePRDregistration.Subscriber_Country__c",currentvalue); 
        component.set("v.subsCountry",currentvalue);
        var a = component.get('c.subscriberValidation');
        $A.enqueueAction(a);  
    },
    handleStateValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        var prdReg = component.get("v.simplePRDregistration");
        prdReg.Subscriber_State_Province_Territory__c = currentvalue;
        component.set("v.simplePRDregistration",prdReg);
        //component.set("v.simplePRDregistration.Subscriber_State_Province_Territory__c",currentvalue);        
        var a = component.get('c.subscriberValidation');
        $A.enqueueAction(a);  
    }
})