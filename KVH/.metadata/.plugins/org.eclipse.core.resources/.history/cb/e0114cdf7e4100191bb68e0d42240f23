({
    handleChange: function (component, event) {
        var changeValue = event.getSource().get("v.label");
        var toggleText1 = component.find("kvh");        
        var toggleText2 = component.find("atfactory");
        if(changeValue == 'KVH Authorized Dealer/Distributor'){
            $A.util.removeClass(toggleText1, "toggle");
            $A.util.addClass(toggleText2, "toggle");
            component.set("v.simpleLTEActivation.Installer_Manufacture__c","");
        }
        else if(changeValue == 'At Factory(by vessel/vehicle manufacturer)'){
            $A.util.addClass(toggleText1, "toggle");
            $A.util.removeClass(toggleText2, "toggle");
            component.set("v.simpleLTEActivation.Installer_Contact_Name__c","");
            component.set("v.simpleLTEActivation.Installer_Country__c","");
            component.set("v.simpleLTEActivation.Installer_State_Province_Territory__c","");
        }
            else{
                $A.util.addClass(toggleText1, "toggle");
                $A.util.addClass(toggleText2, "toggle");
                component.set("v.simpleLTEActivation.Installer_Contact_Name__c","");
                component.set("v.simpleLTEActivation.Installer_Country__c","");
                component.set("v.simpleLTEActivation.Installer_State_Province_Territory__c","");
                component.set("v.simpleLTEActivation.Installer_Manufacture__c","");
            }
        component.set("v.simpleLTEActivation.Installer_Information__c",changeValue);
    },
    handleCountryValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Installer_Country__c",currentvalue); 
    },
    handleStateValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Installer_State_Province_Territory__c",currentvalue);
    }
});