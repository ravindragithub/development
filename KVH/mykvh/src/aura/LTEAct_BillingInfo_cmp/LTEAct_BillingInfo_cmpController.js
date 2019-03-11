({
    billingValidation : function(component, event, helper) {
        var isValidEmail = true
        if(helper.handleUploadAction(component) &&
           (component.get("v.simpleLTEActivation.Billing_Country__c") != null && component.get("v.simpleLTEActivation.Billing_Country__c") != '') &&
           (component.get("v.simpleLTEActivation.Billing_State_Province_Territory__c") != null && component.get("v.simpleLTEActivation.Billing_State_Province_Territory__c") != '')
          ){
            component.set("v.billingInfoRequired",false);        
        }else{
            component.set("v.billingInfoRequired",true);
        }
    },
    updateBillingInfo : function(component, event, helper) {
        var checkCmp = component.find("subCheckFlag");
        var inputCmp1 = component.find("LTEBillingField");
        var isValid = false;
        if(
            (component.get("v.simpleLTEActivation.Main_Contact_FirstName_Subscriber__c") == null || component.get("v.simpleLTEActivation.Main_Contact_FirstName_Subscriber__c") == '') ||
            (component.get("v.simpleLTEActivation.Main_Contact_LastName_Subscriber__c") == null || component.get("v.simpleLTEActivation.Main_Contact_LastName_Subscriber__c") == '') ||
            (component.get("v.simpleLTEActivation.Subscriber_Email__c") == null || component.get("v.simpleLTEActivation.Subscriber_Email__c") == '') ||
            (component.get("v.simpleLTEActivation.Subscriber_Phone__c") == null || component.get("v.simpleLTEActivation.Subscriber_Phone__c") == '') ||
            (component.get("v.simpleLTEActivation.Subscriber_Address__c") == null || component.get("v.simpleLTEActivation.Subscriber_Address__c") == '') ||
            (component.get("v.simpleLTEActivation.Subscriber_City__c") == null || component.get("v.simpleLTEActivation.Subscriber_City__c") == '') ||
            (component.get("v.simpleLTEActivation.Subscriber_Country__c") == null || component.get("v.simpleLTEActivation.Subscriber_Country__c") == '') ||
            (component.get("v.simpleLTEActivation.Subscriber_State_Province_Territory__c") == null || component.get("v.simpleLTEActivation.Subscriber_State_Province_Territory__c") == '') ||
            (component.get("v.simpleLTEActivation.Subscriber_Postal_Zip_Code__c") == null || component.get("v.simpleLTEActivation.Subscriber_Postal_Zip_Code__c") == '') 
        )
            helper.showToastHelper(component, 'All fields are not filled in Subscriber Contact');
        else{
            isValid = true;
        }
        //console.log('==isValidisValid=='+isValid);
        if(isValid){
            if(checkCmp.get("v.checked")){
                for(var i=0; i < inputCmp1.length; i++) {
                    inputCmp1[i].set("v.disabled", true);
                    inputCmp1[i].showHelpMessageIfInvalid();
                }                   
                //var createEvent = component.getEvent("subBillComponentEvent");
                //createEvent.setParams({"isBillingSameasSubscriberInfo" : checkCmp.get("v.checked")});
                component.set("v.simpleLTEActivation.Main_Contact_FirstName_Billing__c",component.get("v.simpleLTEActivation.Main_Contact_FirstName_Subscriber__c"));
                component.set("v.simpleLTEActivation.Main_Contact_LastName_Billing__c",component.get("v.simpleLTEActivation.Main_Contact_LastName_Subscriber__c"));
                component.set("v.simpleLTEActivation.Billing_Address__c",component.get("v.simpleLTEActivation.Subscriber_Address__c"));
                component.set("v.simpleLTEActivation.Billing_City__c",component.get("v.simpleLTEActivation.Subscriber_City__c"));                
                component.set("v.simpleLTEActivation.Billing_Postal_Zip_Code__c",component.get("v.simpleLTEActivation.Subscriber_Postal_Zip_Code__c"));
                component.set("v.simpleLTEActivation.Billing_Company_Name__c",component.get("v.simpleLTEActivation.Subscriber_Company_Name__c"));
                component.set("v.simpleLTEActivation.Billing_Email__c",component.get("v.simpleLTEActivation.Subscriber_Email__c"));
                component.set("v.simpleLTEActivation.Billing_Phone_No__c",component.get("v.simpleLTEActivation.Subscriber_Phone__c"));
                component.set("v.simpleLTEActivation.Billing_State_Province_Territory__c",component.get("v.simpleLTEActivation.Subscriber_State_Province_Territory__c"));
                component.set("v.simpleLTEActivation.Billing_Country__c",component.get("v.simpleLTEActivation.Subscriber_Country__c"));
                //createEvent.fire();
            }
            else{
                for(var i=0; i < inputCmp1.length; i++) {
                    inputCmp1[i].set("v.disabled", false);                    
                    inputCmp1[i].showHelpMessageIfInvalid();
                    inputCmp1[i].set("v.value", "");
                }  
            }
        }
        else         
            event.getSource().set("v.checked",false);
        var a = component.get('c.billingValidation');
        $A.enqueueAction(a);
        
    },
    handleCountryValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Billing_Country__c",currentvalue);        
        var a = component.get('c.billingValidation');
        $A.enqueueAction(a);  
    },
    handleStateValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Billing_State_Province_Territory__c",currentvalue);        
        var a = component.get('c.billingValidation');
        $A.enqueueAction(a);  
    },
    handlebillingInfoFlag: function (component, event, helper) {
        if(!component.get("v.billingInfoFlag") ){
            var inputCmp1 = component.find("LTEBillingField");
            for(var i=0; i < inputCmp1.length; i++) {
                inputCmp1[i].set("v.disabled", false);                
                //inputCmp1[i].showHelpMessageIfInvalid();
                inputCmp1[i].set("v.value", "");
            }  
            component.set("v.billingInfoFlag",true);
            component.set("v.billingCheckFlag",false);
            var a = component.get('c.billingValidation');
            $A.enqueueAction(a);
        }
    },
})