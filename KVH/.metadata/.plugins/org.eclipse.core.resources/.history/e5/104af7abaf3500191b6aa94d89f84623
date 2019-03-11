({
    handleChange: function (component, event,helper) {
        var prdReg = component.get("v.simplePRDregistration");
        var changeValue = event.getSource().get("v.label");
        var toggleText1 = component.find("kvh");        
        var toggleText2 = component.find("atfactory");
        component.set('v.countryFlg',false);
        if(changeValue == 'KVH Authorized Dealer/Distributor'){
            $A.util.removeClass(toggleText1, "toggle");
            $A.util.addClass(toggleText2, "toggle");
            prdReg.Installer_Manufacture__c = '';
            //component.set("v.simplePRDregistration.Installer_Manufacture__c","");
            component.set('v.countryFlg',true);
        }else if(changeValue == 'At Factory (by vessel/vehicle manufacturer)'){
            $A.util.addClass(toggleText1, "toggle");
            $A.util.removeClass(toggleText2, "toggle");            
            helper.resetFields(component);
        }else{
            $A.util.addClass(toggleText1, "toggle");
            $A.util.addClass(toggleText2, "toggle");                
            helper.resetFields(component);
        }
        prdReg.Installer_Information__c = changeValue;
        component.set("v.simplePRDregistration",prdReg);
        //component.set("v.simplePRDregistration.Installer_Information__c",changeValue);
        var a = component.get('c.installerValidation');
        $A.enqueueAction(a);  
    },
    handleCountryValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        var prdReg = component.get("v.simplePRDregistration");
        prdReg.Installer_Country__c = currentvalue;
        component.set("v.simplePRDregistration",prdReg);
        //component.set("v.simplePRDregistration.Installer_Country__c",currentvalue);
        var a = component.get('c.installerValidation');
        $A.enqueueAction(a);  
    },
    handleStateValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        var prdReg = component.get("v.simplePRDregistration");
        prdReg.Installer_State_Province_Territory__c = currentvalue;
        component.set("v.simplePRDregistration",prdReg);
        //component.set("v.simplePRDregistration.Installer_State_Province_Territory__c",currentvalue);
        var a = component.get('c.installerValidation');
        $A.enqueueAction(a);  
    },
    installerValidation : function(component, event, helper) {
        component.set("v.kvhAUthInfoFlag",false);
        component.set("v.installerInfoRequired",true);
        var installInfo = component.get("v.simplePRDregistration.Installer_Information__c");
        if(installInfo){
            if(installInfo==='KVH Authorized Dealer/Distributor'){
                if(helper.handleUploadAction(component) && 
                   !$A.util.isEmpty(component.get("v.simplePRDregistration.Installer_Country__c")) && 
                   !$A.util.isEmpty(component.get("v.simplePRDregistration.Installer_State_Province_Territory__c"))){
                    component.set("v.installerInfoRequired",false);
                }
            }else{
                component.set("v.installerInfoRequired",false);
            }
        }
    }
});