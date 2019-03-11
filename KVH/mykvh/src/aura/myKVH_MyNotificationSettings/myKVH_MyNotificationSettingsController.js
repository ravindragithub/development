({
    handleCheckAcceptAll : function(component, event, helper) {
        var isChecked = component.find("acceptAllCheckbox").get("v.checked");
        component.set("v.acceptAllValue", isChecked);
        if(isChecked){
            component.find("emailCheckbox").set("v.checked");
            component.set("v.emailValue", isChecked);
            component.find("postalMailCheckbox").set("v.checked");
            component.set("v.postalValue", isChecked);
            component.find("telphoneCheckbox").set("v.checked");
            component.set("v.telephoneValue", isChecked);
        }else{
            component.find("emailCheckbox").set("v.checked");
            component.set("v.emailValue", isChecked);
            component.find("postalMailCheckbox").set("v.checked");
            component.set("v.postalValue", isChecked);
            component.find("telphoneCheckbox").set("v.checked");
            component.set("v.telephoneValue", isChecked);
        }
        var isChecked = component.find("declineCheckbox").set("v.checked");
        component.set("v.declineValue", isChecked);
    },    
    handleCheck : function(component, event, helper) {
        console.log('handleCheck'); 
        var isemailChecked = component.find("emailCheckbox").get("v.checked");
        component.set("v.emailValue", isemailChecked);
        console.log(component.get("v.emailValue"));
        var ispostalChecked = component.find("postalMailCheckbox").get("v.checked");
        component.set("v.postalValue", ispostalChecked);
        console.log(component.get("v.postalValue"));
        var istelphoneChecked = component.find("telphoneCheckbox").get("v.checked");
        component.set("v.telephoneValue", istelphoneChecked);
        console.log(component.get("v.telephoneValue"));
        if(component.get("v.emailValue") && component.get("v.postalValue") && component.get("v.telephoneValue")){
            console.log(component.get("v.emailValue"));
            var isChecked = component.find("acceptAllCheckbox").set("v.checked");
            component.set("v.acceptAllValue", isemailChecked);
        }else if(!(component.get("v.emailValue") && component.get("v.postalValue") && component.get("v.telephoneValue"))){
            var isChecked = component.find("acceptAllCheckbox").set("v.checked");
            component.set("v.acceptAllValue", isChecked);
        }
        var isChecked = component.find("declineCheckbox").set("v.checked");
        component.set("v.declineValue", isChecked);
    },    
    handleCheckDecline : function(component, event, helper) {
        var isChecked = component.find("declineCheckbox").get("v.checked");
        component.set("v.declineValue", isChecked);
        if(!isChecked){
            component.set("v.emailValue", isChecked);
            component.find("emailCheckbox").set("v.checked");
            component.set("v.postalValue", isChecked);
            component.find("postalMailCheckbox").set("v.checked");
            component.set("v.telephoneValue", isChecked);
            component.find("telphoneCheckbox").set("v.checked");
            component.set("v.acceptAllValue", isChecked);
            component.find("acceptAllCheckbox").set("v.checked");
        }else{
            component.set("v.emailValue", isChecked);
            component.find("emailCheckbox").set("v.checked");
            component.set("v.postalValue", isChecked);
            component.find("postalMailCheckbox").set("v.checked");
            component.set("v.telephoneValue", isChecked);
            component.find("telphoneCheckbox").set("v.checked");
            component.set("v.acceptAllValue", isChecked);
            component.find("acceptAllCheckbox").set("v.checked");
        }
    },
    handleSave: function (component, event, helpler) {
        helpler.handleSavehelpler(component, event, helpler);        
    },
    onBackHome : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": 'https://www.kvh.com/'
        });
        urlEvent.fire();
    },
})