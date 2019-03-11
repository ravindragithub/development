({
	contact2Validation : function(component, event, helper) {
        var isValid = true;		
        var appEvent = $A.get("e.c:LTEAct_Object_evt"); 
        appEvent.setParams({"setOnboardFalse" : false}); 
        appEvent.fire(); 
    },
    handleCountryValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Contact_2_Country__c",currentvalue);          
        var a = component.get('c.contact2Validation');
        $A.enqueueAction(a);  
    },
    handleStateValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Contact_2_State_Province_Territory__c",currentvalue);
        var a = component.get('c.contact2Validation');
        $A.enqueueAction(a);  
    },
    openPicker : function(component, event, helper) {
        var toggleText = component.find("helptext2");
        $A.util.toggleClass(toggleText, "toggle");
    },
})