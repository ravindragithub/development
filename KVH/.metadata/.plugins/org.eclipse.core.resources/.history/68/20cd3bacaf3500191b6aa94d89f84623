({
    contact1Validation : function(component, event, helper) {
        if(
            helper.handleUploadAction(component) &&
            !$A.util.isEmpty(component.get("v.simpleLTEActivation.Shipping_Country__c")) &&
            !$A.util.isEmpty(component.get("v.simpleLTEActivation.Shipping_State_Province_Territory__c"))
        ){
            component.set("v.cont1Required",false);        
        }else{
            component.set("v.cont1Required",true);
        }
    },
    handleCountryValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Shipping_Country__c",currentvalue);
        var a = component.get('c.contact1Validation');
        $A.enqueueAction(a);  
    },
    handleStateValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Shipping_State_Province_Territory__c",currentvalue);
        var a = component.get('c.contact1Validation');
        $A.enqueueAction(a);  
    },
    updateInfo : function(component, event, helper) { 
        var changeValue = event.getSource().getLocalId();
        var checkCmp;
        checkCmp = component.find(changeValue);
        var inputCmp1 = component.find("LTEFieldCont");        
        var isValid = false;
        if(component.get("v.subInfoRequired") && changeValue == 'Customer'){
            event.getSource().set("v.checked",false);
            helper.showToastHelper(component, 'Please enter all required fields in the "Account" section above.');   
            return;
        }
        else if(component.get("v.installerInfoRequired") &&
                component.get("v.simpleLTEActivation.Installer_Information__c") == 'KVH Authorized Dealer/Distributor' && 
                changeValue == 'KVHAuthorized'){
            event.getSource().set("v.checked",false);
            helper.showToastHelper(component, 'Please enter all required fields in the "KVH Authorized Dealer" section above.');
            return;
        }
        else if(component.get("v.simpleLTEActivation.Installer_Information__c") != 'KVH Authorized Dealer/Distributor' && 
                changeValue == 'KVHAuthorized'){
            event.getSource().set("v.checked",false);
            helper.showToastHelper(component, 'Please select "KVH Authorized Dealer/Distributor" in Installation section above.');
            return;
        }
            else
                isValid = true;
        
        if(changeValue == 'Customer'){
            component.set("v.kvhAUthCheckFlag",false); 
            component.set("v.kvhAUthInfoFlag",false); 
        }
        else if(changeValue == 'KVHAuthorized'){
            component.set("v.customerCheckFlag",false); 
            component.set("v.customerInfoFlag",false);  
        }
        if(isValid){
            if(checkCmp.get("v.checked")){
                for(var i=0; i < inputCmp1.length; i++) {
                    inputCmp1[i].set("v.disabled", true);
                    inputCmp1[i].showHelpMessageIfInvalid();
                } 
                if(changeValue == 'Customer'){
                    component.set("v.customerInfoFlag",true);                    
                    component.set("v.simpleLTEActivation.Shipping_Addressee__c",component.get("v.simpleLTEActivation.Subscriber_First_Name__c") + ' ' + component.get("v.simpleLTEActivation.Subscriber_Last_Name__c"));
                    component.set("v.simpleLTEActivation.Shipping_Address__c",component.get("v.simpleLTEActivation.Subscriber_Address__c"));
                    component.set("v.simpleLTEActivation.Shipping_City__c",component.get("v.simpleLTEActivation.Subscriber_City__c"));                
                    component.set("v.simpleLTEActivation.Shipping_Postal_Zip_Code__c",component.get("v.simpleLTEActivation.Subscriber_Postal_Zip_Code__c"));
                    component.set("v.simpleLTEActivation.Shipping_State_Province_Territory__c",component.get("v.simpleLTEActivation.Subscriber_State_Province_Territory__c"));
                    component.set("v.simpleLTEActivation.Shipping_Country__c",component.get("v.simpleLTEActivation.Subscriber_Country__c"));
                }
                else if(changeValue == 'KVHAuthorized'){
                    component.set("v.kvhAUthInfoFlag",true);     
                    component.set("v.simpleLTEActivation.Shipping_Addressee__c",component.get("v.simpleLTEActivation.Installer_Contact_Name__c"));
                    component.set("v.simpleLTEActivation.Shipping_Address__c",component.get("v.simpleLTEActivation.Installer_Address__c"));
                    component.set("v.simpleLTEActivation.Shipping_City__c",component.get("v.simpleLTEActivation.Installer_City__c"));                
                    component.set("v.simpleLTEActivation.Shipping_Postal_Zip_Code__c",component.get("v.simpleLTEActivation.Installer_Zip_Code__c"));
                    component.set("v.simpleLTEActivation.Shipping_State_Province_Territory__c",component.get("v.simpleLTEActivation.Installer_State_Province_Territory__c"));
                    component.set("v.simpleLTEActivation.Shipping_Country__c",component.get("v.simpleLTEActivation.Installer_Country__c"));
                }
            }
            else{
                for(var i=0; i < inputCmp1.length; i++) {
                    inputCmp1[i].set("v.disabled", false);                    
                    inputCmp1[i].showHelpMessageIfInvalid();
                    inputCmp1[i].set("v.value", "");
                }  
            }
        }
        var a = component.get('c.contact1Validation');
        $A.enqueueAction(a);
        
    },    
    handlekvhAUthInfo : function (component, event, helper) {
        console.log(event.getParam("value") + '===handlekvhAUthInfo');
        if(!event.getParam("value") ){
            var inputCmp1 = component.find("LTEFieldCont");
            for(var i=0; i < inputCmp1.length; i++) {
                inputCmp1[i].set("v.disabled", false); 
                inputCmp1[i].set("v.value", "");
            }
            component.set("v.kvhAUthCheckFlag",false);            
            component.set("v.simpleLTEActivation.Shipping_Country__c","United States");
            var a = component.get('c.contact1Validation');
            $A.enqueueAction(a);
        }
    },
    handlecustomerInfo : function (component, event, helper) {
        console.log(event.getParam("value") + '===handlecustomerInfo');
        if(!event.getParam("value") ){
            var inputCmp1 = component.find("LTEFieldCont");
            for(var i=0; i < inputCmp1.length; i++) {
                inputCmp1[i].set("v.disabled", false); 
                inputCmp1[i].set("v.value", "");
            }
            component.set("v.customerCheckFlag",false);            
            component.set("v.simpleLTEActivation.Shipping_Country__c","United States");
            var a = component.get('c.contact1Validation');
            $A.enqueueAction(a);
        }
    },
})