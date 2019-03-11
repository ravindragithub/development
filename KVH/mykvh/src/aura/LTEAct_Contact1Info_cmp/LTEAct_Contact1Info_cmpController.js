({
    contact1Validation : function(component, event, helper) {
        var isValid = true;		
        var appEvent = $A.get("e.c:LTEAct_Object_evt"); 
        appEvent.setParams({"setOnboardFalse" : false}); 
        appEvent.fire(); 
    },
    handleAddContact : function(component, event, helper) {
        if(component.get("v.showAddContact") == true){s
            component.set("v.showAddContact",false)
        }else{
            component.set("v.showAddContact",true)
        }
    },
    handleCountryValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Contact_1_Country__c",currentvalue);
        var a = component.get('c.contact1Validation');
        $A.enqueueAction(a);  
    },
    handleStateValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Contact_1_State_Province__c",currentvalue);
        var a = component.get('c.contact1Validation');
        $A.enqueueAction(a);  
    },
    openPicker : function(component, event, helper) {
        var toggleText = component.find("helptext1");
        $A.util.toggleClass(toggleText, "toggle");
    },
})