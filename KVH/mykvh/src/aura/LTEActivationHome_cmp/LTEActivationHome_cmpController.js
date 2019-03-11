({
    doInit: function(component, event, helper) {
        component.set("v.spinner", true);
        // Prepare a new record from template
        component.find("LTERecordCreator").getNewRecord(
            "LTE_Activation__c", // sObject type (entityAPIName)
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newLTEActivation");
                var error = component.get("v.newLTEActivationError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                }
                else {
                    console.log("Record template initialized: " + rec);
                }
                helper.getCountryHelper(component, event, helper);
                //helper.getStateHelper(component, event, helper);
                helper.getContactHelper(component, event, helper);  
            })
        );

    },    
    onBackHome : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/'
        });
        urlEvent.fire();
    },
    handleSaveLTE : function(component, event, helper) {
        component.set("v.simpleLTEActivation.Inhibit_Transform__c", component.get("v.inhibitTransform"));
        component.set("v.spinner", true); 
        component.get("v.submitFormOnce");
        component.set("v.submitFormOnce", true);;
        
        console.log('Object ::'+ JSON.stringify(component.get("v.simpleLTEActivation")));
        //console.log('Validation ::'+ helper.validateLTEForm(component));
        if(helper.validateLTEForm(component)) {    
            helper.helperLTERegistration(component, event, helper);   
        }else{
            component.set("v.submitFormOnce", false);
            component.set("v.spinner", false);
        }
    },
    hideShowError: function(component) {
        var toggleText1 = component.find("errorTag");  
        $A.util.addClass(toggleText1, "toggle");
    },
    handleNextPayment: function (component, event, helper) {
        component.find("accordion").set('v.activeSectionName', 'Payment');
        component.set('v.paymentAccordion', false);        
        var xdiv = document.getElementById('scrollPayment');
        helper.setScroller(component,xdiv);
    },
    handlePreviousAccount: function (component, event, helper) {
        component.find("accordion").set('v.activeSectionName', 'Account');     
        var xdiv = document.getElementById('scrollAccount');
        helper.setScroller(component,xdiv);
    },    
    handleNextAddContact: function (component, event, helper) {
        component.find("accordion").set('v.activeSectionName', 'AdditionalContact');   
        component.set('v.addContactAccordion', false);
        var xdiv = document.getElementById('scrollAddContact');
        helper.setScroller(component,xdiv);
    },    
    handlePreviousPayment : function (component, event, helper) {
        component.find("accordion").set('v.activeSectionName', 'Payment');     
        var xdiv = document.getElementById('scrollPayment');
        helper.setScroller(component,xdiv);
    },    
    handleNextInstallation: function (component, event, helper) {
        component.find("accordion").set('v.activeSectionName', 'Installation');
        component.set('v.installAccordion', false);
        var xdiv = document.getElementById('scrollInstallation');
        helper.setScroller(component,xdiv);
    },    
    handlePreviousAddContact : function (component, event, helper) {
        component.find("accordion").set('v.activeSectionName', 'AdditionalContact');     
        var xdiv = document.getElementById('scrollAddContact');
        helper.setScroller(component,xdiv);
    },    
    handleNextService: function (component, event, helper) {
        component.find("accordion").set('v.activeSectionName', 'Service');
        component.set('v.serviceAccordion', false);    
        var xdiv = document.getElementById('scrollService');
        helper.setScroller(component,xdiv);
    },    
    handlePreviousInstaller: function (component, event, helper) {
        component.find("accordion").set('v.activeSectionName', 'Installation');        
        var xdiv = document.getElementById('scrollInstallation');
        helper.setScroller(component,xdiv);
    },    
    handleNextAgreement: function (component, event, helper) {
        component.find("accordion").set('v.activeSectionName', 'Agreement');
        component.set('v.agreementAccordion', false);
        var xdiv = document.getElementById('scrollAgreement');
        helper.setScroller(component,xdiv);
    },    
    handlePreviousService: function (component, event, helper) {
        component.find("accordion").set('v.activeSectionName', 'Service');     
        var xdiv = document.getElementById('scrollService');
        helper.setScroller(component,xdiv);
    },    
})