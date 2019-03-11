({
    billingValidation : function(component, event, helper) {
        helper.finalValidHelper(component, event, helper);
    },
    updateBillingInfo : function(component, event, helper) {
        var checkCmp = component.find("subCheckFlag");
        var inputCmp1 = component.find("LTEBillingField");        
        var isValid = false;
        if(component.get("v.subInfoRequired"))
            helper.showToastHelper(component, 'Please enter all required fields in the "Account" section above.');
        else{
            isValid = true;
        }
        if(isValid){
            if(checkCmp.get("v.checked")){
                for(var i=0; i < inputCmp1.length; i++) {
                    inputCmp1[i].set("v.disabled", true);
                    inputCmp1[i].showHelpMessageIfInvalid();
                } 
                component.set("v.billingInfoFlag",true);
                component.set("v.simpleLTEActivation.Billing_Address__c",component.get("v.simpleLTEActivation.Subscriber_Address__c"));
                component.set("v.simpleLTEActivation.Billing_City__c",component.get("v.simpleLTEActivation.Subscriber_City__c"));                
                component.set("v.simpleLTEActivation.Billing_Postal_Zip_Code__c",component.get("v.simpleLTEActivation.Subscriber_Postal_Zip_Code__c"));
                component.set("v.simpleLTEActivation.Billing_State_Province_Territory__c",component.get("v.simpleLTEActivation.Subscriber_State_Province_Territory__c"));
                component.set("v.simpleLTEActivation.Billing_Country__c",component.get("v.simpleLTEActivation.Subscriber_Country__c"));
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
        helper.finalValidHelper(component, event, helper);        
    },
    handlebillingInfoFlag: function (component, event, helper) {
        if(!event.getParam("value")){
            var inputCmp1 = component.find("LTEBillingField");
            for(var i=0; i < inputCmp1.length; i++) {
                inputCmp1[i].set("v.disabled", false);    
                inputCmp1[i].set("v.value", "");
                component.set("v.simpleLTEActivation.Billing_Country__c","United States");
            }  
            component.set("v.billingCheckFlag",false);    
            helper.finalValidHelper(component, event, helper);
        }
    },
    handleCountryValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Billing_Country__c",currentvalue);        
        helper.finalValidHelper(component, event, helper);
    },
    handleStateValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Billing_State_Province_Territory__c",currentvalue);        
        helper.finalValidHelper(component, event, helper);
    },
    validatePrimaryPayInfo : function(component, event, helper) {
        var inputPrimaryCC = component.find('PrimaryCC'); 
        var valuePrimary = inputPrimaryCC.get('v.value');
        var cmpTarget = component.find('ccSecure');
        if($A.util.isEmpty(valuePrimary)){
            inputPrimaryCC.set('v.errors', [{message:"Complete this field."}]);
            $A.util.addClass(cmpTarget, 'ccSecure2');
            $A.util.removeClass(cmpTarget, 'ccSecure1');
        }else if( !$A.util.isEmpty(valuePrimary) ){
            if(isNaN(valuePrimary) || valuePrimary.toString().length < 12 || valuePrimary.toString().length > 19){
                inputPrimaryCC.set('v.errors', [{message:"Invalid card information"}]);
                $A.util.addClass(cmpTarget, 'ccSecure2');
                $A.util.removeClass(cmpTarget, 'ccSecure1');
            }else if(helper.handleValidateCC(valuePrimary)){
                inputPrimaryCC.set('v.errors', [{message:"Incorrect card information"}]);
                $A.util.addClass(cmpTarget, 'ccSecure2');
                $A.util.removeClass(cmpTarget, 'ccSecure1');
            }else{
                inputPrimaryCC.set("v.errors", null);
                $A.util.addClass(cmpTarget, 'ccSecure1');
                $A.util.removeClass(cmpTarget, 'ccSecure2');
            }
        }
        helper.finalValidHelper(component, event, helper);
    },
    validatePrimaryDateInfo : function(component, event, helper) {
        var inputPrimaryCCDate = component.find('PrimaryCCDate');
        var valuePrimaryCCDate = inputPrimaryCCDate.get('v.value');
        var validExpirationDate = new RegExp('(0[1-9]|10|11|12)/(2[0-9][1-9][8-9])|(2[0-9][2-9][0-9])$');
        if($A.util.isEmpty(valuePrimaryCCDate))
            inputPrimaryCCDate.set('v.errors', [{message:"Complete this field."}]);
        else if( 
            !$A.util.isEmpty(valuePrimaryCCDate) &&
            helper.handleValidateCCExpDate(valuePrimaryCCDate) != 'Valid'
        )
            inputPrimaryCCDate.set("v.errors", [{message:helper.handleValidateCCExpDate(valuePrimaryCCDate)}]);
            else
                inputPrimaryCCDate.set("v.errors", null);    
        helper.finalValidHelper(component, event, helper);
    },
    validatePrimaryNameInfo : function(component, event, helper) {
        var inputPrimaryCCName = component.find('PrimaryCCName');
        var valuePrimaryCCName = inputPrimaryCCName.get('v.value');
        if($A.util.isEmpty(valuePrimaryCCName))
            inputPrimaryCCName.set('v.errors', [{message:"Complete this field."}]);
        else if(!$A.util.isEmpty(inputPrimaryCCName.get('v.value')))
            inputPrimaryCCName.set("v.errors", null);    
        helper.finalValidHelper(component, event, helper);
    },
})